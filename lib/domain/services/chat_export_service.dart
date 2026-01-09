import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

/// Service for importing and exporting chat history
/// Compatible with SillyTavern JSONL format
class ChatExportService {
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
        if (message.reasoningSwipes != null) 'reasoning_swipes': message.reasoningSwipes,
        if (message.characterId != null) 'original_avatar': message.characterId,
        if (message.characterName != null) 'force_avatar': message.characterName,
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
      'messages': messages.map((m) => {
        'id': m.id,
        'role': m.role.name,
        'content': m.content,
        'timestamp': m.timestamp.toIso8601String(),
        'swipes': m.swipes,
        'current_swipe_index': m.currentSwipeIndex,
        if (m.reasoning != null) 'reasoning': m.reasoning,
        if (m.reasoningSwipes != null) 'reasoning_swipes': m.reasoningSwipes,
        if (m.characterId != null) 'character_id': m.characterId,
        if (m.characterName != null) 'character_name': m.characterName,
      }).toList(),
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
    
    // Share the file using the new share_plus API
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Chat with ${character.name}',
    );
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
      type: FileType.custom,
      allowedExtensions: [extension],
    );
    
    if (result != null) {
      final file = File(result);
      await file.writeAsString(content);
      return result;
    }
    
    return null;
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
      final characterName = metadata['character_name'] as String? ?? 'Character';
      final createDate = metadata['create_date'] as int?;
      final chatMetadata = metadata['chat_metadata'] as Map<String, dynamic>?;
      
      // Parse messages
      final messages = <ImportedMessage>[];
      for (var i = 1; i < lines.length; i++) {
        if (lines[i].trim().isEmpty) continue;
        
        try {
          final msgData = jsonDecode(lines[i]) as Map<String, dynamic>;
          final isUser = msgData['is_user'] as bool? ?? false;
          final isSystem = msgData['is_system'] as bool? ?? false;
          
          MessageRole role;
          if (isSystem) {
            role = MessageRole.system;
          } else if (isUser) {
            role = MessageRole.user;
          } else {
            role = MessageRole.assistant;
          }
          
          messages.add(ImportedMessage(
            role: role,
            content: msgData['mes'] as String? ?? '',
            timestamp: msgData['send_date'] != null
                ? DateTime.fromMillisecondsSinceEpoch(msgData['send_date'] as int)
                : DateTime.now(),
            swipes: (msgData['swipes'] as List<dynamic>?)?.cast<String>() ?? [],
            currentSwipeIndex: msgData['swipe_id'] as int? ?? 0,
            reasoning: msgData['reasoning'] as String?,
            reasoningSwipes: (msgData['reasoning_swipes'] as List<dynamic>?)?.cast<String>(),
            characterId: msgData['original_avatar'] as String?,
            characterName: msgData['force_avatar'] as String?,
          ));
        } catch (e) {
          // Skip malformed message lines
          continue;
        }
      }
      
      return ChatImportResult(
        userName: userName,
        characterName: characterName,
        createDate: createDate != null
            ? DateTime.fromMillisecondsSinceEpoch(createDate)
            : DateTime.now(),
        authorNote: chatMetadata?['note_prompt'] as String?,
        authorNoteDepth: chatMetadata?['note_depth'] as int?,
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
      final createdAt = data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now();
      
      final messagesData = data['messages'] as List<dynamic>? ?? [];
      final messages = messagesData.map((m) {
        final msgData = m as Map<String, dynamic>;
        return ImportedMessage(
          role: MessageRole.values.firstWhere(
            (r) => r.name == msgData['role'],
            orElse: () => MessageRole.user,
          ),
          content: msgData['content'] as String? ?? '',
          timestamp: msgData['timestamp'] != null
              ? DateTime.parse(msgData['timestamp'] as String)
              : DateTime.now(),
          swipes: (msgData['swipes'] as List<dynamic>?)?.cast<String>() ?? [],
          currentSwipeIndex: msgData['current_swipe_index'] as int? ?? 0,
          reasoning: msgData['reasoning'] as String?,
          reasoningSwipes: (msgData['reasoning_swipes'] as List<dynamic>?)?.cast<String>(),
          characterId: msgData['character_id'] as String?,
          characterName: msgData['character_name'] as String?,
        );
      }).toList();
      
      return ChatImportResult(
        userName: userName,
        characterName: characterName,
        createDate: createdAt,
        authorNote: data['author_note'] as String?,
        authorNoteDepth: data['author_note_depth'] as int?,
        authorNoteEnabled: data['author_note_enabled'] as bool?,
        messages: messages,
      );
    } catch (e) {
      return null;
    }
  }

  /// Import chat from file
  Future<ChatImportResult?> importFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jsonl', 'json'],
      allowMultiple: false,
    );
    
    if (result == null || result.files.isEmpty) return null;
    
    final file = File(result.files.first.path!);
    final content = await file.readAsString();
    final fileName = result.files.first.name.toLowerCase();
    
    if (fileName.endsWith('.jsonl')) {
      return importFromJsonl(content);
    } else {
      return importFromJson(content);
    }
  }

  /// Auto-detect format and import
  Future<ChatImportResult?> importFromString(String content) async {
    // Try JSONL first (starts with { and has multiple lines)
    if (content.trim().startsWith('{') && content.contains('\n')) {
      final result = await importFromJsonl(content);
      if (result != null) return result;
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
  final String? authorNote;
  final int? authorNoteDepth;
  final bool? authorNoteEnabled;
  final List<ImportedMessage> messages;

  ChatImportResult({
    required this.userName,
    required this.characterName,
    required this.createDate,
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
  final String? characterId;
  final String? characterName;

  ImportedMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.swipes = const [],
    this.currentSwipeIndex = 0,
    this.reasoning,
    this.reasoningSwipes,
    this.characterId,
    this.characterName,
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
    );
  }
}