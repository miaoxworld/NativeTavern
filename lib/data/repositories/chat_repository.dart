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
    final rows = await (_db.select(_db.chats)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_chatFromRow).toList();
  }

  /// Get chats for a specific character
  Future<List<models.Chat>> getChatsForCharacter(String characterId) async {
    final rows = await (_db.select(_db.chats)
          ..where((t) => t.characterId.equals(characterId))
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
    final row = await (_db.select(_db.chats)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _chatFromRow(row) : null;
  }

  /// Create a new chat
  Future<models.Chat> createChat(models.Chat chat) async {
    final id = chat.id.isEmpty ? _uuid.v4() : chat.id;
    final now = DateTime.now();
    
    final newChat = models.Chat(
      id: id,
      characterId: chat.characterId,
      groupId: chat.groupId,
      title: chat.title,
      authorNote: chat.authorNote,
      authorNoteDepth: chat.authorNoteDepth,
      authorNoteEnabled: chat.authorNoteEnabled,
      createdAt: now,
      updatedAt: now,
    );

    await _db.into(_db.chats).insert(ChatsCompanion(
      id: Value(newChat.id),
      characterId: Value(newChat.characterId),
      groupId: Value(newChat.groupId),
      title: Value(newChat.title),
      authorNote: Value(newChat.authorNote),
      authorNoteDepth: Value(newChat.authorNoteDepth),
      authorNoteEnabled: Value(newChat.authorNoteEnabled),
      createdAt: Value(newChat.createdAt),
      updatedAt: Value(newChat.updatedAt),
    ));
    
    return newChat;
  }

  /// Update chat
  Future<models.Chat> updateChat(models.Chat chat) async {
    final now = DateTime.now();
    
    await (_db.update(_db.chats)..where((t) => t.id.equals(chat.id)))
        .write(ChatsCompanion(
          title: Value(chat.title),
          authorNote: Value(chat.authorNote),
          authorNoteDepth: Value(chat.authorNoteDepth),
          authorNoteEnabled: Value(chat.authorNoteEnabled),
          updatedAt: Value(now),
        ));
    
    return chat.copyWith(updatedAt: now);
  }

  /// Delete chat and all its messages
  Future<void> deleteChat(String id) async {
    // Delete all messages first
    await (_db.delete(_db.messages)..where((t) => t.chatId.equals(id))).go();
    // Delete the chat
    await (_db.delete(_db.chats)..where((t) => t.id.equals(id))).go();
  }

  /// Get messages for a chat
  Future<List<models.ChatMessage>> getMessages(String chatId) async {
    final rows = await (_db.select(_db.messages)
          ..where((t) => t.chatId.equals(chatId))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
    return rows.map(_messageFromRow).toList();
  }

  /// Add a message to a chat
  Future<models.ChatMessage> addMessage(models.ChatMessage message) async {
    final id = message.id.isEmpty ? _uuid.v4() : message.id;
    
    final newMessage = message.copyWith(id: id);

    await _db.into(_db.messages).insert(MessagesCompanion(
      id: Value(newMessage.id),
      chatId: Value(newMessage.chatId),
      role: Value(newMessage.role.name),
      content: Value(newMessage.content),
      timestamp: Value(newMessage.timestamp),
      swipes: Value(jsonEncode(newMessage.swipes)),
      currentSwipeIndex: Value(newMessage.currentSwipeIndex),
      characterId: Value(newMessage.characterId),
      characterName: Value(newMessage.characterName),
    ));
    
    // Update chat's updatedAt
    await (_db.update(_db.chats)..where((t) => t.id.equals(message.chatId)))
        .write(ChatsCompanion(updatedAt: Value(DateTime.now())));
    
    return newMessage;
  }

  /// Update a message
  Future<models.ChatMessage> updateMessage(models.ChatMessage message) async {
    await (_db.update(_db.messages)..where((t) => t.id.equals(message.id)))
        .write(MessagesCompanion(
          content: Value(message.content),
          swipes: Value(jsonEncode(message.swipes)),
          currentSwipeIndex: Value(message.currentSwipeIndex),
          characterId: Value(message.characterId),
          characterName: Value(message.characterName),
        ));
    
    // Update chat's updatedAt
    await (_db.update(_db.chats)..where((t) => t.id.equals(message.chatId)))
        .write(ChatsCompanion(updatedAt: Value(DateTime.now())));
    
    return message;
  }

  /// Delete a message
  Future<void> deleteMessage(String id) async {
    await (_db.delete(_db.messages)..where((t) => t.id.equals(id))).go();
  }

  /// Get message count for a chat
  Future<int> getMessageCount(String chatId) async {
    final messages = await (_db.select(_db.messages)
          ..where((t) => t.chatId.equals(chatId)))
        .get();
    return messages.length;
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
    return models.Chat(
      id: row.id,
      characterId: row.characterId,
      groupId: row.groupId,
      title: row.title,
      authorNote: row.authorNote,
      authorNoteDepth: row.authorNoteDepth,
      authorNoteEnabled: row.authorNoteEnabled,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
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
}