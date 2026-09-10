import 'package:dio/dio.dart';
import 'package:native_tavern/data/models/provider_usage.dart';
import 'package:native_tavern/domain/services/llm_service.dart';

/// Fetches remaining credits/balance from providers that document a
/// user-key usage endpoint. Most providers only expose usage on each
/// completion response; those return [RemoteProviderUsage.unsupported].
class ProviderUsageRemoteClient {
  ProviderUsageRemoteClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<RemoteProviderUsage> fetch(LLMConfig config) {
    return switch (config.provider) {
      LLMProvider.openRouter => _openRouter(config),
      LLMProvider.deepSeek => _deepSeek(config),
      LLMProvider.siliconFlow => _siliconFlow(config),
      LLMProvider.moonshot => _moonshot(config),
      LLMProvider.openai ||
      LLMProvider.claude ||
      LLMProvider.gemini ||
      LLMProvider.xai ||
      LLMProvider.qwen ||
      LLMProvider.zai ||
      LLMProvider.miniMax ||
      LLMProvider.openAICompatible =>
        Future.value(
          RemoteProviderUsage.unsupported(
            config.provider.name,
            at: DateTime.now().toUtc(),
          ),
        ),
      LLMProvider.ollama ||
      LLMProvider.lmStudio ||
      LLMProvider.koboldCpp =>
        Future.value(
          RemoteProviderUsage(
            provider: config.provider.name,
            kind: RemoteUsageKind.unsupported,
            supported: false,
            ok: true,
            detail: 'local',
            fetchedAt: DateTime.now().toUtc(),
          ),
        ),
    };
  }

  /// GET /api/v1/key works with a regular inference key.
  Future<RemoteProviderUsage> _openRouter(LLMConfig config) async {
    final now = DateTime.now().toUtc();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${_trimSlash(config.apiUrl.isEmpty ? 'https://openrouter.ai/api/v1' : config.apiUrl)}/key',
        options: Options(
          headers: {'Authorization': 'Bearer ${config.apiKey}'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode != 200 || response.data == null) {
        return RemoteProviderUsage.error(
          config.provider.name,
          'HTTP ${response.statusCode}',
          at: now,
        );
      }
      final data = response.data!['data'] is Map
          ? Map<String, dynamic>.from(response.data!['data'] as Map)
          : response.data!;
      return RemoteProviderUsage(
        provider: config.provider.name,
        kind: RemoteUsageKind.credits,
        supported: true,
        ok: true,
        remaining: _num(data['limit_remaining']),
        used: _num(data['usage']) ?? _num(data['usage_daily']),
        limit: _num(data['limit']),
        currency: 'USD',
        unit: 'credits',
        detail: data['is_free_tier'] == true ? 'free_tier' : null,
        fetchedAt: now,
      );
    } catch (error) {
      return RemoteProviderUsage.error(
        config.provider.name,
        error.toString(),
        at: now,
      );
    }
  }

  /// GET /user/balance
  Future<RemoteProviderUsage> _deepSeek(LLMConfig config) async {
    final now = DateTime.now().toUtc();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${_trimSlash(config.apiUrl.isEmpty ? 'https://api.deepseek.com' : config.apiUrl)}/user/balance',
        options: Options(
          headers: {'Authorization': 'Bearer ${config.apiKey}'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode != 200 || response.data == null) {
        return RemoteProviderUsage.error(
          config.provider.name,
          'HTTP ${response.statusCode}',
          at: now,
        );
      }
      final infos = response.data!['balance_infos'];
      Map<String, dynamic>? usd;
      if (infos is List) {
        for (final item in infos) {
          if (item is Map && item['currency'] == 'USD') {
            usd = Map<String, dynamic>.from(item);
            break;
          }
        }
        if (usd == null && infos.isNotEmpty && infos.first is Map) {
          usd = Map<String, dynamic>.from(infos.first as Map);
        }
      }
      return RemoteProviderUsage(
        provider: config.provider.name,
        kind: RemoteUsageKind.balance,
        supported: true,
        ok: true,
        remaining: _num(usd?['total_balance']) ??
            _num(response.data!['total_balance']),
        currency: usd?['currency'] as String? ?? 'USD',
        unit: 'balance',
        fetchedAt: now,
      );
    } catch (error) {
      return RemoteProviderUsage.error(
        config.provider.name,
        error.toString(),
        at: now,
      );
    }
  }

  Future<RemoteProviderUsage> _siliconFlow(LLMConfig config) async {
    final now = DateTime.now().toUtc();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${_trimSlash(config.apiUrl.isEmpty ? 'https://api.siliconflow.cn/v1' : config.apiUrl)}/user/info',
        options: Options(
          headers: {'Authorization': 'Bearer ${config.apiKey}'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode != 200 || response.data == null) {
        return RemoteProviderUsage.error(
          config.provider.name,
          'HTTP ${response.statusCode}',
          at: now,
        );
      }
      final data = response.data!['data'] is Map
          ? Map<String, dynamic>.from(response.data!['data'] as Map)
          : response.data!;
      return RemoteProviderUsage(
        provider: config.provider.name,
        kind: RemoteUsageKind.balance,
        supported: true,
        ok: true,
        remaining: _num(data['balance']) ?? _num(data['totalBalance']),
        currency: 'CNY',
        unit: 'balance',
        fetchedAt: now,
      );
    } catch (error) {
      return RemoteProviderUsage.error(
        config.provider.name,
        error.toString(),
        at: now,
      );
    }
  }

  Future<RemoteProviderUsage> _moonshot(LLMConfig config) async {
    final now = DateTime.now().toUtc();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${_trimSlash(config.apiUrl.isEmpty ? 'https://api.moonshot.cn/v1' : config.apiUrl)}/users/me/balance',
        options: Options(
          headers: {'Authorization': 'Bearer ${config.apiKey}'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode != 200 || response.data == null) {
        return RemoteProviderUsage.error(
          config.provider.name,
          'HTTP ${response.statusCode}',
          at: now,
        );
      }
      final data = response.data!['data'] is Map
          ? Map<String, dynamic>.from(response.data!['data'] as Map)
          : response.data!;
      return RemoteProviderUsage(
        provider: config.provider.name,
        kind: RemoteUsageKind.balance,
        supported: true,
        ok: true,
        remaining: _num(data['available_balance']) ??
            _num(data['balance']) ??
            _num(data['cash_balance']),
        currency: 'CNY',
        unit: 'balance',
        fetchedAt: now,
      );
    } catch (error) {
      return RemoteProviderUsage.error(
        config.provider.name,
        error.toString(),
        at: now,
      );
    }
  }

  static String _trimSlash(String url) {
    if (url.endsWith('/')) return url.substring(0, url.length - 1);
    return url;
  }

  static double? _num(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
