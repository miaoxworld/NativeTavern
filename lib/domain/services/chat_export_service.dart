import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

/// Service for importing and exporting chat history
/// Compatible with SillyTavern JSONL format
class ChatExportService {
  static const List<String> _supportedImportExtensions = ['jsonl', 'json'];

  /// Export chat to SillyTavern-compatible JSONL format
  ///
  /// SillyTavern format:
  /// - First line: metadata object with user_name, character_name, create_date
  /// - Following lines: message objects with name, is_user, is_system, send_date, mes, swipes, swipe_id
  Future<String> exportToJsonl(
    Chat chat,
    List<ChatMessage> messages,
    Character character, {
    String? userName,
  }) async {
    final buffer = StringBuffer();

    // First line: metadata
    final metadata = {
      'user_name': userName ?? 'User',
      'character_name': character.name,
      'create_date': chat.createdAt.millisecondsSinceEpoch,
      'chat_metadata': {
        'note_prompt': chat.authorNote,
        'note_depth': chat.authorNoteDepth,
        'note_interval': 1,
        'note_position': 1,
      },
    };
    buffer.writeln(jsonEncode(metadata));

    // Message lines
    for (final message in messages) {
      final isUser = message.role == MessageRole.user;
      final isSystem = message.role == MessageRole.system;

      final messageData = {
        'name': isUser ? (userName ?? 'User') : character.name,
        'is_user': isUser,
        'is_system': isSystem,
        'send_date': message.timestamp.millisecondsSinceEpoch,
        'mes': message.content,
        'swipes': message.swipes,
        'swipe_id': message.currentSwipeIndex,
        if (message.reasoning != null) 'reasoning': message.reasoning,
        if (message.reasoningSwipes != null)
          'reasoning_swipes': message.reasoningSwipes,
        if (message.characterId != null) 'original_avatar': message.characterId,
        if (message.characterName != null)
          'force_avatar': message.characterName,
      };
      buffer.writeln(jsonEncode(messageData));
    }

    return buffer.toString();
  }

  /// Export chat to JSON format (alternative format)
  Future<String> exportToJson(
    Chat chat,
    List<ChatMessage> messages,
    Character character, {
    String? userName,
  }) async {
    final data = {
      'chat_id': chat.id,
      'character_id': chat.characterId,
      'character_name': character.name,
      'user_name': userName ?? 'User',
      'title': chat.title,
      'created_at': chat.createdAt.toIso8601String(),
      'updated_at': chat.updatedAt.toIso8601String(),
      'author_note': chat.authorNote,
      'author_note_depth': chat.authorNoteDepth,
      'author_note_enabled': chat.authorNoteEnabled,
      'messages': messages
          .map((m) => {
                'id': m.id,
                'role': m.role.name,
                'content': m.content,
                'timestamp': m.timestamp.toIso8601String(),
                'swipes': m.swipes,
                'current_swipe_index': m.currentSwipeIndex,
                if (m.reasoning != null) 'reasoning': m.reasoning,
                if (m.reasoningSwipes != null)
                  'reasoning_swipes': m.reasoningSwipes,
                if (m.characterId != null) 'character_id': m.characterId,
                if (m.characterName != null) 'character_name': m.characterName,
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Save exported chat to file and share
  Future<void> exportAndShare(
    Chat chat,
    List<ChatMessage> messages,
    Character character, {
    String? userName,
    bool useJsonl = true,
    Rect? sharePositionOrigin,
  }) async {
    final content = useJsonl
        ? await exportToJsonl(chat, messages, character, userName: userName)
        : await exportToJson(chat, messages, character, userName: userName);

    final extension = useJsonl ? 'jsonl' : 'json';
    final fileName = '${character.name}_${chat.id}.$extension';

    // Get temp directory
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(content);

    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path)],
      subject: 'Chat with ${character.name}',
      sharePositionOrigin: sharePositionOrigin,
    ));
  }

  /// Save exported chat to downloads folder
  Future<String?> exportToFile(
    Chat chat,
    List<ChatMessage> messages,
    Character character, {
    String? userName,
    bool useJsonl = true,
  }) async {
    final content = useJsonl
        ? await exportToJsonl(chat, messages, character, userName: userName)
        : await exportToJson(chat, messages, character, userName: userName);

    final extension = useJsonl ? 'jsonl' : 'json';
    final fileName = '${character.name}_${chat.id}.$extension';

    // Let user choose save location
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Chat Export',
      fileName: fileName,
      bytes: Uint8List.fromList(utf8.encode(content)),
      type: FileType.custom,
      allowedExtensions: [extension],
    );

    if (result != null) {
      final file = File(result);
      if (!await file.exists() || await file.length() == 0) {
        await file.writeAsString(content);
      }
      return result;
    }

    return null;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is int) {
      if (value < 10000000000) {
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      }
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      final asInt = int.tryParse(value);
      if (asInt != null) {
        return _parseDate(asInt);
      }
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return DateTime.now();
  }

  /// Import chat from JSONL format
  /// Returns a tuple of (metadata, messages)
  Future<ChatImportResult?> importFromJsonl(String content) async {
    final lines = content.trim().split('\n');
    if (lines.isEmpty) return null;

    try {
      // First line is metadata
      final metadata = jsonDecode(lines[0]) as Map<String, dynamic>;
      final userName = metadata['user_name'] as String? ?? 'User';
      final characterName =
          metadata['character_name'] as String? ?? 'Character';
      final createDate = _parseDate(metadata['create_date']);
      final chatMetadata = metadata['chat_metadata'] as Map<String, dynamic>?;

      final detectedModel = (chatMetadata?['main_model'] as String?) ??
          (chatMetadata?['model'] as String?) ??
          (metadata['model'] as String?);

      final personaName = (chatMetadata?['persona'] as String?) ??
          (chatMetadata?['user_name'] as String?);

      final authorNote = (chatMetadata?['note_prompt'] as String?) ??
          (metadata['author_note'] as String?);
      final authorNoteDepth = (chatMetadata?['note_depth'] as int?) ??
          (metadata['author_note_depth'] as int?);
      final authorNoteEnabled = (chatMetadata?['note_enabled'] as bool?) ??
          (metadata['author_note_enabled'] as bool?);

      // Parse messages
      final messages = <ImportedMessage>[];
      String? fallbackModel = detectedModel;

      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        try {
          final msgData = jsonDecode(line) as Map<String, dynamic>;
          final isUser =
              msgData['is_user'] as bool? ?? (msgData['role'] == 'user');
          final isSystem =
              msgData['is_system'] as bool? ?? (msgData['role'] == 'system');

          MessageRole role;
          if (isSystem) {
            role = MessageRole.system;
          } else if (isUser) {
            role = MessageRole.user;
          } else {
            role = MessageRole.assistant;
          }

          final extra = msgData['extra'] as Map<String, dynamic>?;
          final msgModel =
              (extra?['model'] as String?) ?? (msgData['model'] as String?);
          if (fallbackModel == null &&
              msgModel != null &&
              msgModel.isNotEmpty) {
            fallbackModel = msgModel;
          }

          final rawSwipes =
              (msgData['swipes'] as List<dynamic>?)?.cast<String>() ?? [];
          final activeContent =
              msgData['mes'] as String? ?? msgData['content'] as String? ?? '';

          final reasoning = (msgData['reasoning'] as String?) ??
              (extra?['reasoning'] as String?);
          final reasoningSwipes =
              (msgData['reasoning_swipes'] as List<dynamic>?)?.cast<String>() ??
                  (extra?['reasoning_swipes'] as List<dynamic>?)
                      ?.cast<String>();

          messages.add(ImportedMessage(
            role: role,
            content: activeContent,
            timestamp: _parseDate(msgData['send_date'] ?? msgData['timestamp']),
            swipes: rawSwipes,
            currentSwipeIndex: msgData['swipe_id'] as int? ??
                msgData['current_swipe_index'] as int? ??
                0,
            reasoning: reasoning,
            reasoningSwipes: reasoningSwipes,
            model: msgModel,
            characterId: (msgData['original_avatar'] as String?) ??
                (msgData['character_id'] as String?),
            characterName: (msgData['force_avatar'] as String?) ??
                (msgData['character_name'] as String?) ??
                (msgData['name'] as String?),
            metadata: extra ?? const {},
          ));
        } catch (e) {
          // Skip malformed message lines
          continue;
        }
      }

      return ChatImportResult(
        userName: userName,
        characterName: characterName,
        createDate: createDate,
        model: fallbackModel,
        personaName: personaName,
        authorNote: authorNote,
        authorNoteDepth: authorNoteDepth,
        authorNoteEnabled: authorNoteEnabled,
        messages: messages,
      );
    } catch (e) {
      return null;
    }
  }

  /// Import chat from JSON format
  Future<ChatImportResult?> importFromJson(String content) async {
    try {
      final data = jsonDecode(content) as Map<String, dynamic>;

      final userName = data['user_name'] as String? ?? 'User';
      final characterName = data['character_name'] as String? ?? 'Character';
      final createdAt = _parseDate(data['created_at'] ?? data['create_date']);
      final model = data['model'] as String? ??
          (data['settings'] is Map
              ? (data['settings'] as Map)['model'] as String?
              : null);

      final messagesData = data['messages'] as List<dynamic>? ?? [];
      final messages = messagesData.map((m) {
        final msgData = m as Map<String, dynamic>;
        final extra = msgData['extra'] as Map<String, dynamic>?;
        return ImportedMessage(
          role: MessageRole.values.firstWhere(
            (r) => r.name == msgData['role'],
            orElse: () => (msgData['is_user'] == true)
                ? MessageRole.user
                : MessageRole.assistant,
          ),
          content:
              msgData['content'] as String? ?? msgData['mes'] as String? ?? '',
          timestamp: _parseDate(msgData['timestamp'] ?? msgData['send_date']),
          swipes: (msgData['swipes'] as List<dynamic>?)?.cast<String>() ?? [],
          currentSwipeIndex: msgData['current_swipe_index'] as int? ??
              msgData['swipe_id'] as int? ??
              0,
          reasoning:
              msgData['reasoning'] as String? ?? extra?['reasoning'] as String?,
          reasoningSwipes: (msgData['reasoning_swipes'] as List<dynamic>?)
                  ?.cast<String>() ??
              (extra?['reasoning_swipes'] as List<dynamic>?)?.cast<String>(),
          model: msgData['model'] as String? ?? extra?['model'] as String?,
          characterId: msgData['character_id'] as String? ??
              msgData['original_avatar'] as String?,
          characterName: msgData['character_name'] as String? ??
              msgData['force_avatar'] as String? ??
              msgData['name'] as String?,
          metadata: (msgData['metadata'] is Map)
              ? Map<String, dynamic>.from(msgData['metadata'] as Map)
              : (extra ?? const {}),
        );
      }).toList();

      return ChatImportResult(
        userName: userName,
        characterName: characterName,
        createDate: createdAt,
        model: model,
        authorNote: data['author_note'] as String?,
        authorNoteDepth: data['author_note_depth'] as int?,
        authorNoteEnabled: data['author_note_enabled'] as bool?,
        messages: messages,
      );
    } catch (e) {
      return null;
    }
  }

  /// Import chat from file directly
  Future<ChatImportResult?> importFromPath(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return null;
    final content = await file.readAsString();
    return importFromString(content);
  }

  /// Import chat from file picker
  Future<ChatImportResult?> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;
    final filePath = result.files.first.path;
    if (filePath == null) return null;

    final file = File(filePath);
    final content = await file.readAsString();
    final fileName = result.files.first.name.toLowerCase();
    final fileExtension =
        fileName.contains('.') ? fileName.split('.').last : '';

    if (!_supportedImportExtensions.contains(fileExtension)) {
      // Fallback: try parsing content directly if extension is unrecognized
      return importFromString(content);
    }

    if (fileName.endsWith('.jsonl')) {
      return importFromJsonl(content);
    } else {
      return importFromJson(content);
    }
  }

  /// Auto-detect format and import
  Future<ChatImportResult?> importFromString(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return null;

    // Try JSONL first (starts with { and has multiple lines)
    if (trimmed.startsWith('{') && trimmed.contains('\n')) {
      final result = await importFromJsonl(content);
      if (result != null && result.messages.isNotEmpty) return result;
    }

    // Try JSON
    return importFromJson(content);
  }
}

/// Result of importing a chat
class ChatImportResult {
  final String userName;
  final String characterName;
  final DateTime createDate;
  final String? model;
  final String? personaName;
  final String? authorNote;
  final int? authorNoteDepth;
  final bool? authorNoteEnabled;
  final List<ImportedMessage> messages;

  ChatImportResult({
    required this.userName,
    required this.characterName,
    required this.createDate,
    this.model,
    this.personaName,
    this.authorNote,
    this.authorNoteDepth,
    this.authorNoteEnabled,
    required this.messages,
  });
}

/// Imported message data
class ImportedMessage {
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final List<String> swipes;
  final int currentSwipeIndex;
  final String? reasoning;
  final List<String>? reasoningSwipes;
  final String? model;
  final String? characterId;
  final String? characterName;
  final Map<String, dynamic> metadata;

  ImportedMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.swipes = const [],
    this.currentSwipeIndex = 0,
    this.reasoning,
    this.reasoningSwipes,
    this.model,
    this.characterId,
    this.characterName,
    this.metadata = const {},
  });

  /// Convert to ChatMessage
  ChatMessage toChatMessage(String chatId, String id) {
    return ChatMessage(
      id: id,
      chatId: chatId,
      role: role,
      content: content,
      timestamp: timestamp,
      swipes: swipes.isEmpty ? [content] : swipes,
      currentSwipeIndex: currentSwipeIndex,
      reasoning: reasoning,
      reasoningSwipes: reasoningSwipes,
      characterId: characterId,
      characterName: characterName,
      metadata: {
        if (model != null && model!.isNotEmpty) 'model': model,
        ...metadata,
      },
    );
  }
}
