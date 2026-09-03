import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:native_tavern/domain/services/import_service.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/domain/services/external_call_audit_service.dart';

enum UrlSource {
  nativeTavern,
  chub,
  janitorAI,
  pygmalion,
  risurealm,
  aiCharacterCards,
  directPng,
  directJson,
  unknown,
}

class UrlImportResult {
  final Character character;
  final UrlSource source;
  final String sourceUrl;

  UrlImportResult({
    required this.character,
    required this.source,
    required this.sourceUrl,
  });
}

class UrlImportService {
  final ImportService _importService;
  final Dio _dio;

  UrlImportService(
    this._importService, {
    Dio? dio,
    ExternalCallAuditRepository auditRepository =
        const NoopExternalCallAuditRepository(),
  }) : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 60),
              headers: {
                'User-Agent': 'NativeTavern/1.0',
              },
            )) {
    _dio.interceptors.add(ExternalCallAuditInterceptor(
      repository: auditRepository,
      capabilityId: 'characterImport',
      classifyData: (request) => const {
        ExternalDataType.metadata,
        ExternalDataType.characterCard,
      },
    ));
  }

  UrlSource identifySource(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return UrlSource.unknown;

    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    if (host.contains('nativetavern.com')) {
      return UrlSource.nativeTavern;
    }
    if (host.contains('chub.ai') || host.contains('characterhub.org')) {
      return UrlSource.chub;
    }
    if (host.contains('janitorai.com') ||
        host.contains('janitor.ai') ||
        host.contains('jannyai.com')) {
      return UrlSource.janitorAI;
    }
    if (host.contains('pygmalion.chat')) {
      return UrlSource.pygmalion;
    }
    if (host.contains('risuai.net') || host.contains('risurealm')) {
      return UrlSource.risurealm;
    }
    if (host.contains('aicharactercards.com')) {
      return UrlSource.aiCharacterCards;
    }

    if (path.endsWith('.png') || path.endsWith('.webp')) {
      return UrlSource.directPng;
    }
    if (path.endsWith('.json')) {
      return UrlSource.directJson;
    }

    return UrlSource.unknown;
  }

  String getSourceDisplayName(UrlSource source) {
    switch (source) {
      case UrlSource.nativeTavern:
        return 'NativeTavern';
      case UrlSource.chub:
        return 'Chub.ai';
      case UrlSource.janitorAI:
        return 'JanitorAI';
      case UrlSource.pygmalion:
        return 'Pygmalion Chat';
      case UrlSource.risurealm:
        return 'RisuRealm';
      case UrlSource.aiCharacterCards:
        return 'AI Character Cards';
      case UrlSource.directPng:
        return 'PNG Link';
      case UrlSource.directJson:
        return 'JSON Link';
      case UrlSource.unknown:
        return 'Unknown';
    }
  }

  Future<UrlImportResult> importFromUrl(String url) async {
    final source = identifySource(url);

    switch (source) {
      case UrlSource.nativeTavern:
        return await _importFromNativeTavern(url);
      case UrlSource.chub:
        return await _importFromChub(url);
      case UrlSource.janitorAI:
        return await _importFromJanitorAI(url);
      case UrlSource.pygmalion:
        return await _importFromPygmalion(url);
      case UrlSource.risurealm:
        return await _importFromRisurealm(url);
      case UrlSource.aiCharacterCards:
        return await _importFromAICharacterCards(url);
      case UrlSource.directPng:
        return await _importFromDirectPng(url);
      case UrlSource.directJson:
        return await _importFromDirectJson(url);
      case UrlSource.unknown:
        return await _importFromUnknownUrl(url);
    }
  }

  /// NativeTavern: Auto-detect format from community URL
  /// URL format: https://nativetavern.com/characters/{id} or direct file links
  Future<UrlImportResult> _importFromNativeTavern(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url.trim(),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        final contentType = response.headers.value('content-type') ?? '';

        if (contentType.contains('image/png') || _isPngBytes(bytes)) {
          final character = await _importService.importFromPngBytes(bytes);
          return UrlImportResult(
            character: character,
            source: UrlSource.nativeTavern,
            sourceUrl: url,
          );
        }

        final jsonStr = utf8.decode(bytes);
        final character = await _importService.importFromJson(jsonStr);
        return UrlImportResult(
          character: character,
          source: UrlSource.nativeTavern,
          sourceUrl: url,
        );
      }
      throw Exception('NativeTavern returned status ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Character not found on NativeTavern');
      }
      throw Exception('Failed to download from NativeTavern: ${e.message}');
    }
  }

  /// Chub.ai: GET metadata to find avatar PNG URL, then download the PNG
  /// which contains embedded character card data.
  /// URL format: https://chub.ai/characters/{author}/{name}
  Future<UrlImportResult> _importFromChub(String url) async {
    final uri = Uri.parse(url.trim());
    final pathSegments = uri.pathSegments;

    String? fullPath;
    for (int i = 0; i < pathSegments.length - 1; i++) {
      if (pathSegments[i] == 'characters' && i + 2 < pathSegments.length) {
        fullPath = '${pathSegments[i + 1]}/${pathSegments[i + 2]}';
        break;
      }
    }

    if (fullPath == null) {
      throw Exception(
          'Invalid Chub.ai URL. Expected: https://chub.ai/characters/{author}/{name}');
    }

    try {
      // Step 1: Get character metadata to find avatar PNG URL
      final metaResponse = await _dio.get(
        'https://api.chub.ai/api/characters/$fullPath',
        queryParameters: {'full': 'true'},
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (metaResponse.statusCode != 200) {
        throw Exception(
            'Chub.ai API returned status ${metaResponse.statusCode}');
      }

      final metaData = metaResponse.data is String
          ? jsonDecode(metaResponse.data as String) as Map<String, dynamic>
          : metaResponse.data as Map<String, dynamic>;

      final node = metaData['node'] as Map<String, dynamic>?;
      if (node == null) {
        throw Exception('Invalid Chub.ai response: missing character data');
      }

      // Step 2: Download the avatar PNG which has embedded character card data
      final avatarUrl = node['max_res_url']?.toString();
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        final pngResponse = await _dio.get<List<int>>(
          avatarUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        if (pngResponse.statusCode == 200 && pngResponse.data != null) {
          final bytes = Uint8List.fromList(pngResponse.data!);
          if (_isPngBytes(bytes)) {
            try {
              final character = await _importService.importFromPngBytes(bytes);
              return UrlImportResult(
                character: character,
                source: UrlSource.chub,
                sourceUrl: url,
              );
            } catch (_) {
              // PNG didn't have embedded data, fall through to JSON parsing
            }
          }
        }
      }

      // Fallback: parse character data from the metadata definition field
      final definition = node['definition'] as Map<String, dynamic>?;
      if (definition != null) {
        final character = _parseChubDefinition(definition);
        return UrlImportResult(
          character: character,
          source: UrlSource.chub,
          sourceUrl: url,
        );
      }

      throw Exception('Could not extract character data from Chub.ai response');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Character not found on Chub.ai');
      }
      throw Exception('Failed to download from Chub.ai: ${e.message}');
    }
  }

  Character _parseChubDefinition(Map<String, dynamic> defn) {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString() +
        (now.microsecond % 1000).toString().padLeft(3, '0');

    return Character(
      id: id,
      name: defn['name']?.toString() ?? '',
      description: defn['description']?.toString() ?? '',
      personality: defn['personality']?.toString() ??
          defn['tavern_personality']?.toString() ??
          '',
      scenario: defn['scenario']?.toString() ?? '',
      firstMessage: defn['first_message']?.toString() ?? '',
      alternateGreetings: _parseStringList(defn['alternate_greetings']),
      exampleMessages: defn['example_dialogs']?.toString() ?? '',
      systemPrompt: defn['system_prompt']?.toString() ?? '',
      postHistoryInstructions:
          defn['post_history_instructions']?.toString() ?? '',
      creatorNotes: defn['creator_notes']?.toString() ?? '',
      tags: _parseStringList(defn['tags']),
      creator: defn['creator']?.toString() ?? '',
      version: defn['character_version']?.toString() ?? '',
      extensions: defn['extensions'] as Map<String, dynamic>? ?? {},
      createdAt: now,
      modifiedAt: now,
    );
  }

  /// JanitorAI: POST to api.jannyai.com/api/v1/download to get downloadUrl,
  /// then download the PNG from that URL.
  /// Note: JanitorAI uses Cloudflare protection which may block direct API calls.
  /// URL format: https://janitorai.com/characters/{uuid}
  Future<UrlImportResult> _importFromJanitorAI(String url) async {
    final uuid = _extractUuid(url);

    if (uuid == null) {
      throw Exception('Invalid JanitorAI URL. Could not find character UUID.');
    }

    try {
      final response = await _dio.post(
        'https://api.jannyai.com/api/v1/download',
        data: {'characterId': uuid},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 403) {
        throw Exception(
            'JanitorAI is protected by Cloudflare and cannot be accessed directly. '
            'Please download the character card PNG from the JanitorAI website and import it as a local file.');
      }

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;

        final downloadUrl = data['downloadUrl']?.toString();
        if (downloadUrl == null || downloadUrl.isEmpty) {
          throw Exception('JanitorAI did not return a download URL');
        }

        final cardResponse = await _dio.get<List<int>>(
          downloadUrl,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
          ),
        );

        if (cardResponse.statusCode == 200 && cardResponse.data != null) {
          final bytes = Uint8List.fromList(cardResponse.data!);
          final character = await _importService.importFromPngBytes(bytes);
          return UrlImportResult(
            character: character,
            source: UrlSource.janitorAI,
            sourceUrl: url,
          );
        }
        throw Exception('Failed to download character card from JanitorAI');
      }
      throw Exception('JanitorAI API returned status ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception(
            'JanitorAI is protected by Cloudflare and cannot be accessed directly. '
            'Please download the character card PNG from the JanitorAI website and import it as a local file.');
      }
      if (e.response?.statusCode == 404) {
        throw Exception('Character not found on JanitorAI');
      }
      throw Exception('Failed to download from JanitorAI: ${e.message}');
    }
  }

  /// Pygmalion Chat: GET https://server.pygmalion.chat/api/export/character/{id}/v2
  /// URL format: https://pygmalion.chat/character/{id}
  Future<UrlImportResult> _importFromPygmalion(String url) async {
    final uri = Uri.parse(url.trim());
    final pathSegments = uri.pathSegments;

    String? characterId;
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] == 'character' && i + 1 < pathSegments.length) {
        characterId = pathSegments[i + 1];
        break;
      }
    }

    if (characterId == null) {
      throw Exception(
          'Invalid Pygmalion Chat URL. Expected: https://pygmalion.chat/character/{id}');
    }

    try {
      final response = await _dio.get(
        'https://server.pygmalion.chat/api/export/character/$characterId/v2',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonStr = response.data is String
            ? response.data as String
            : jsonEncode(response.data);
        final character = await _importService.importFromJson(jsonStr);
        return UrlImportResult(
          character: character,
          source: UrlSource.pygmalion,
          sourceUrl: url,
        );
      }
      throw Exception(
          'Pygmalion Chat API returned status ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Character not found on Pygmalion Chat');
      }
      throw Exception('Failed to download from Pygmalion Chat: ${e.message}');
    }
  }

  /// RisuRealm: GET https://realm.risuai.net/api/v1/download/{format}/{id}
  /// URL format: https://realm.risuai.net/character/{hash}
  Future<UrlImportResult> _importFromRisurealm(String url) async {
    final uri = Uri.parse(url.trim());
    final pathSegments = uri.pathSegments;

    String? characterId;
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] == 'character' && i + 1 < pathSegments.length) {
        characterId = pathSegments[i + 1];
        break;
      }
    }

    if (characterId == null && pathSegments.isNotEmpty) {
      characterId = pathSegments.last;
    }

    if (characterId == null) {
      throw Exception(
          'Invalid RisuRealm URL. Expected: https://realm.risuai.net/character/{id}');
    }

    try {
      // Use the documented download API with png-v3 format
      final response = await _dio.get<List<int>>(
        'https://realm.risuai.net/api/v1/download/png-v3/$characterId',
        queryParameters: {
          'non_commercial': 'true',
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        if (_isPngBytes(bytes)) {
          final character = await _importService.importFromPngBytes(bytes);
          return UrlImportResult(
            character: character,
            source: UrlSource.risurealm,
            sourceUrl: url,
          );
        }

        // Fallback: try as JSON
        final jsonStr = utf8.decode(bytes);
        final character = await _importService.importFromJson(jsonStr);
        return UrlImportResult(
          character: character,
          source: UrlSource.risurealm,
          sourceUrl: url,
        );
      }
      throw Exception('RisuRealm API returned status ${response.statusCode}');
    } on DioException catch (e) {
      // If png-v3 fails, try json-v3
      if (e.response?.statusCode == 403 || e.response?.statusCode == 400) {
        return await _importFromRisurealmJson(characterId, url);
      }
      if (e.response?.statusCode == 404) {
        throw Exception('Character not found on RisuRealm');
      }
      throw Exception('Failed to download from RisuRealm: ${e.message}');
    }
  }

  Future<UrlImportResult> _importFromRisurealmJson(
      String characterId, String url) async {
    final response = await _dio.get(
      'https://realm.risuai.net/api/v1/download/json-v3/$characterId',
      queryParameters: {
        'non_commercial': 'true',
      },
      options: Options(
        headers: {'Accept': 'application/json'},
      ),
    );

    if (response.statusCode == 200) {
      final jsonStr = response.data is String
          ? response.data as String
          : jsonEncode(response.data);
      final character = await _importService.importFromJson(jsonStr);
      return UrlImportResult(
        character: character,
        source: UrlSource.risurealm,
        sourceUrl: url,
      );
    }
    throw Exception('RisuRealm JSON fallback failed: ${response.statusCode}');
  }

  /// AI Character Cards: GET https://aicharactercards.com/wp-json/pngapi/v1/image/{id}
  /// URL format: https://aicharactercards.com/character-cards/{slug}/
  Future<UrlImportResult> _importFromAICharacterCards(String url) async {
    final uri = Uri.parse(url.trim());
    final pathSegments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

    // Try to extract the card slug or ID
    String? slug;
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i] == 'character-cards' && i + 1 < pathSegments.length) {
        slug = pathSegments[i + 1];
        break;
      }
    }

    if (slug == null && pathSegments.isNotEmpty) {
      slug = pathSegments.last;
    }

    if (slug == null) {
      throw Exception('Invalid AI Character Cards URL');
    }

    // If the slug looks like a number, try the direct API
    final numericId = int.tryParse(slug);
    if (numericId != null) {
      return await _downloadAICCById(numericId, url);
    }

    // Otherwise, try fetching the page to find the card ID, or try the slug as PNG URL
    try {
      final response = await _dio.get<List<int>>(
        url.trim(),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        if (_isPngBytes(bytes)) {
          final character = await _importService.importFromPngBytes(bytes);
          return UrlImportResult(
            character: character,
            source: UrlSource.aiCharacterCards,
            sourceUrl: url,
          );
        }

        // Try to parse as HTML and extract image URL
        final html = utf8.decode(bytes);
        final pngMatch = RegExp(
                r'https://aicharactercards\.com/wp-json/pngapi/v1/image/(\d+)')
            .firstMatch(html);
        if (pngMatch != null) {
          final id = int.parse(pngMatch.group(1)!);
          return await _downloadAICCById(id, url);
        }

        throw Exception(
            'Could not find character card on AI Character Cards page');
      }
      throw Exception(
          'AI Character Cards returned status ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(
          'Failed to download from AI Character Cards: ${e.message}');
    }
  }

  Future<UrlImportResult> _downloadAICCById(int id, String url) async {
    final response = await _dio.get<List<int>>(
      'https://aicharactercards.com/wp-json/pngapi/v1/image/$id',
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final bytes = Uint8List.fromList(response.data!);
      final character = await _importService.importFromPngBytes(bytes);
      return UrlImportResult(
        character: character,
        source: UrlSource.aiCharacterCards,
        sourceUrl: url,
      );
    }
    throw Exception(
        'AI Character Cards image API returned ${response.statusCode}');
  }

  /// Direct PNG link
  Future<UrlImportResult> _importFromDirectPng(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url.trim(),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        final character = await _importService.importFromPngBytes(bytes);
        return UrlImportResult(
          character: character,
          source: UrlSource.directPng,
          sourceUrl: url,
        );
      }
      throw Exception('Failed to download PNG: status ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Failed to download PNG: ${e.message}');
    }
  }

  /// Direct JSON link
  Future<UrlImportResult> _importFromDirectJson(String url) async {
    try {
      final response = await _dio.get(
        url.trim(),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200) {
        final jsonStr = response.data is String
            ? response.data as String
            : jsonEncode(response.data);
        final character = await _importService.importFromJson(jsonStr);
        return UrlImportResult(
          character: character,
          source: UrlSource.directJson,
          sourceUrl: url,
        );
      }
      throw Exception('Failed to download JSON: status ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Failed to download JSON: ${e.message}');
    }
  }

  /// Auto-detect format from an unknown URL
  Future<UrlImportResult> _importFromUnknownUrl(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url.trim(),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        final contentType = response.headers.value('content-type') ?? '';

        // Try PNG first
        if (contentType.contains('image/png') || _isPngBytes(bytes)) {
          try {
            final character = await _importService.importFromPngBytes(bytes);
            return UrlImportResult(
              character: character,
              source: UrlSource.directPng,
              sourceUrl: url,
            );
          } catch (_) {}
        }

        // Try JSON
        if (contentType.contains('json') ||
            contentType.contains('text') ||
            !_isPngBytes(bytes)) {
          try {
            final jsonStr = utf8.decode(bytes);
            final character = await _importService.importFromJson(jsonStr);
            return UrlImportResult(
              character: character,
              source: UrlSource.directJson,
              sourceUrl: url,
            );
          } catch (_) {}
        }

        throw Exception(
            'Could not parse character data from the URL. The file may not contain valid character card data.');
      }
      throw Exception('Failed to download: status ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Failed to download from URL: ${e.message}');
    }
  }

  bool _isPngBytes(Uint8List bytes) {
    if (bytes.length < 8) return false;
    return bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
  }

  /// Extract UUID from any URL
  String? _extractUuid(String url) {
    final match = RegExp(
      r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
    ).firstMatch(url);
    return match?.group(0);
  }

  List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }
}
