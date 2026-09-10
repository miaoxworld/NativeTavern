import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart' hide Chat, Message;
import 'package:native_tavern/data/database/database.dart' as db;
import 'package:native_tavern/data/models/chat.dart' as models;
import 'package:uuid/uuid.dart';

/// Provider for chat repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Repository for managing chat data
class ChatRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

  ChatRepository(this._db);

  /// Get all chats
  Future<List<models.Chat>> getAllChats() async {
    final rows = await (_db.select(
      _db.chats,
    )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_chatFromRow).toList();
  }

  /// Loads a bounded page for the home chat list.
  Future<List<models.Chat>> getChatsPage({
    int limit = 40,
    int offset = 0,
  }) async {
    final rows = await (_db.select(_db.chats)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(limit, offset: offset < 0 ? 0 : offset))
        .get();
    return rows.map(_chatFromRow).toList(growable: false);
  }

  /// Get chats for a specific character
  Future<List<models.Chat>> getChatsForCharacter(String characterId) async {
    final rows = await (_db.select(_db.chats)
          ..where((t) => t.characterId.equals(characterId) & t.groupId.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_chatFromRow).toList();
  }

  /// Get recent chats
  Future<List<models.Chat>> getRecentChats({int limit = 10}) async {
    final rows = await (_db.select(_db.chats)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(limit))
        .get();
    return rows.map(_chatFromRow).toList();
  }

  /// Get chat by ID
  Future<models.Chat?> getChat(String id) async {
    final row = await (_db.select(
      _db.chats,
    )..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _chatFromRow(row) : null;
  }

  /// Create a new chat
  Future<models.Chat> createChat(models.Chat chat) async {
    final id = chat.id.isEmpty ? _uuid.v4() : chat.id;
    final now = DateTime.now();

    final settings = Map<String, dynamic>.from(chat.settings);
    settings['titleUpdatedAt'] = now.toIso8601String();
    final newChat = models.Chat(
      id: id,
      characterId: chat.characterId,
      groupId: chat.groupId,
      title: chat.title,
      authorNote: chat.authorNote,
      authorNoteDepth: chat.authorNoteDepth,
      authorNoteEnabled: chat.authorNoteEnabled,
      summaries: chat.summaries,
      settings: settings,
      createdAt: now,
      updatedAt: now,
    );

    await _db.into(_db.chats).insert(
          ChatsCompanion(
            id: Value(newChat.id),
            characterId: Value(newChat.characterId),
            groupId: Value(newChat.groupId),
            title: Value(newChat.title),
            authorNote: Value(newChat.authorNote),
            authorNoteDepth: Value(newChat.authorNoteDepth),
            authorNoteEnabled: Value(newChat.authorNoteEnabled),
            settingsJson: Value(_encodeSettings(newChat)),
            createdAt: Value(newChat.createdAt),
            updatedAt: Value(newChat.updatedAt),
          ),
        );

    return newChat;
  }

  /// Update chat
  Future<models.Chat> updateChat(models.Chat chat) async {
    final now = DateTime.now();
    final existing = await getChat(chat.id);
    var next = chat;
    if (existing == null || existing.title != chat.title) {
      next = chat.withSetting('titleUpdatedAt', now.toIso8601String());
    }

    await (_db.update(_db.chats)..where((t) => t.id.equals(chat.id))).write(
      ChatsCompanion(
        title: Value(next.title),
        authorNote: Value(next.authorNote),
        authorNoteDepth: Value(next.authorNoteDepth),
        authorNoteEnabled: Value(next.authorNoteEnabled),
        settingsJson: Value(_encodeSettings(next)),
        updatedAt: Value(now),
      ),
    );

    return next.copyWith(updatedAt: now);
  }

  /// Delete chat and all its messages
  Future<void> deleteChat(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.bookmarks)..where((t) => t.chatId.equals(id))).go();
      await (_db.delete(_db.messages)..where((t) => t.chatId.equals(id))).go();
      await (_db.delete(_db.chats)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Get messages for a chat
  Future<List<models.ChatMessage>> getMessages(String chatId) async {
    final rows = await (_db.select(_db.messages)
          ..where((t) => t.chatId.equals(chatId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.timestamp),
            (t) => OrderingTerm.asc(t.rowId),
          ]))
        .get();
    return rows.map(_messageFromRow).toList();
  }

  /// Load a bounded page of messages, keeping chronological order.
  ///
  /// Pages are addressed from the newest message: offset 0 returns the most
  /// recent page, while larger offsets load progressively older messages.
  Future<List<models.ChatMessage>> getMessagesPage(
    String chatId, {
    int limit = 50,
    int offset = 0,
  }) async {
    if (limit <= 0) return const [];
    final rows = await (_db.select(_db.messages)
          ..where((t) => t.chatId.equals(chatId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.timestamp),
            (t) => OrderingTerm.desc(t.rowId),
          ])
          ..limit(limit, offset: offset < 0 ? 0 : offset))
        .get();
    return rows.reversed.map(_messageFromRow).toList(growable: false);
  }

  /// Add a message to a chat
  Future<models.ChatMessage> addMessage(models.ChatMessage message) async {
    final id = message.id.isEmpty ? _uuid.v4() : message.id;

    final newMessage = message.copyWith(id: id);

    await _db.into(_db.messages).insert(
          MessagesCompanion(
            id: Value(newMessage.id),
            chatId: Value(newMessage.chatId),
            role: Value(newMessage.role.name),
            content: Value(newMessage.content),
            timestamp: Value(newMessage.timestamp),
            swipes: Value(jsonEncode(newMessage.swipes)),
            currentSwipeIndex: Value(newMessage.currentSwipeIndex),
            characterId: Value(newMessage.characterId),
            characterName: Value(newMessage.characterName),
            metadataJson: Value(jsonEncode(newMessage.metadata)),
            attachmentsJson: Value(
              jsonEncode(
                newMessage.attachments.map((a) => a.toJson()).toList(),
              ),
            ),
          ),
        );

    // Update chat's updatedAt
    await (_db.update(_db.chats)..where((t) => t.id.equals(message.chatId)))
        .write(ChatsCompanion(updatedAt: Value(DateTime.now())));

    return newMessage;
  }

  /// Update a message
  Future<models.ChatMessage> updateMessage(models.ChatMessage message) async {
    await (_db.update(
      _db.messages,
    )..where((t) => t.id.equals(message.id)))
        .write(
      MessagesCompanion(
        content: Value(message.content),
        swipes: Value(jsonEncode(message.swipes)),
        currentSwipeIndex: Value(message.currentSwipeIndex),
        characterId: Value(message.characterId),
        characterName: Value(message.characterName),
        metadataJson: Value(jsonEncode(message.metadata)),
        attachmentsJson: Value(
          jsonEncode(message.attachments.map((a) => a.toJson()).toList()),
        ),
      ),
    );

    // Update chat's updatedAt
    await (_db.update(_db.chats)..where((t) => t.id.equals(message.chatId)))
        .write(ChatsCompanion(updatedAt: Value(DateTime.now())));

    return message;
  }

  /// Delete a message
  Future<void> deleteMessage(String id) async {
    await (_db.delete(_db.messages)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all messages and message-dependent data while keeping the chat.
  Future<void> clearMessages(String chatId) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.bookmarks,
      )..where((t) => t.chatId.equals(chatId)))
          .go();
      await (_db.delete(
        _db.messages,
      )..where((t) => t.chatId.equals(chatId)))
          .go();
      await (_db.update(_db.chats)..where((t) => t.id.equals(chatId))).write(
        ChatsCompanion(updatedAt: Value(DateTime.now())),
      );
    });
  }

  /// Get message count for a chat
  Future<int> getMessageCount(String chatId) async {
    final countExpression = _db.messages.id.count();
    final row = await (_db.selectOnly(_db.messages)
          ..addColumns([countExpression])
          ..where(_db.messages.chatId.equals(chatId)))
        .getSingle();
    return row.read(countExpression) ?? 0;
  }

  /// Get last message of a chat
  Future<models.ChatMessage?> getLastMessage(String chatId) async {
    final row = await (_db.select(_db.messages)
          ..where((t) => t.chatId.equals(chatId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(1))
        .getSingleOrNull();
    return row != null ? _messageFromRow(row) : null;
  }

  /// Get chats for a group
  Future<List<models.Chat>> getChatsForGroup(String groupId) async {
    final rows = await (_db.select(_db.chats)
          ..where((t) => t.groupId.equals(groupId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_chatFromRow).toList();
  }

  // Private helpers

  models.Chat _chatFromRow(db.Chat row) {
    Map<String, dynamic> settings = const {};
    try {
      settings = jsonDecode(row.settingsJson) as Map<String, dynamic>;
    } catch (_) {
      // Keep empty settings on malformed JSON
    }
    return models.Chat(
      id: row.id,
      characterId: row.characterId,
      groupId: row.groupId,
      title: row.title,
      authorNote: row.authorNote,
      authorNoteDepth: row.authorNoteDepth,
      authorNoteEnabled: row.authorNoteEnabled,
      settings: settings,
      summaries: (settings['summaries'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(models.ChatSummary.fromJson)
              .toList() ??
          const [],
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  String _encodeSettings(models.Chat chat) {
    return jsonEncode({
      ...chat.settings,
      'summaries': chat.summaries.map((summary) => summary.toJson()).toList(),
    });
  }

  models.ChatMessage _messageFromRow(db.Message row) {
    return models.ChatMessage(
      id: row.id,
      chatId: row.chatId,
      role: models.MessageRole.values.firstWhere(
        (r) => r.name == row.role,
        orElse: () => models.MessageRole.user,
      ),
      content: row.content,
      timestamp: row.timestamp,
      swipes: _parseJsonList(row.swipes),
      currentSwipeIndex: row.currentSwipeIndex,
      characterId: row.characterId,
      characterName: row.characterName,
      metadata: _parseMetadata(row.metadataJson),
      attachments: _parseAttachments(row.attachmentsJson),
    );
  }

  List<String> _parseJsonList(String json) {
    try {
      final list = jsonDecode(json) as List;
      return list.cast<String>();
    } catch (_) {
      return [];
    }
  }

  List<models.ChatAttachment> _parseAttachments(String json) {
    try {
      final list = jsonDecode(json) as List;
      return list
          .map(
            (item) =>
                models.ChatAttachment.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _parseMetadata(String json) {
    try {
      return Map<String, dynamic>.from(jsonDecode(json) as Map);
    } catch (_) {
      return const {};
    }
  }
}
