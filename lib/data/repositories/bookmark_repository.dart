import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart' hide Bookmark;
import 'package:native_tavern/data/database/database.dart' as db;
import 'package:native_tavern/data/models/bookmark.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:uuid/uuid.dart';

/// Provider for bookmark repository
final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return BookmarkRepository(database);
});

/// Repository for managing bookmark data
class BookmarkRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

  BookmarkRepository(this._db);

  /// Get all bookmarks for a chat
  Future<List<Bookmark>> getBookmarksForChat(String chatId) async {
    final rows = await (_db.select(_db.bookmarks)
          ..where((t) => t.chatId.equals(chatId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_bookmarkFromRow).toList();
  }

  /// Get bookmark by ID
  Future<Bookmark?> getBookmark(String id) async {
    final row = await (_db.select(_db.bookmarks)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _bookmarkFromRow(row) : null;
  }

  /// Create a new bookmark
  Future<Bookmark> createBookmark({
    required String chatId,
    required String name,
    String? description,
    required String messageId,
    required int messageIndex,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    final bookmark = Bookmark(
      id: id,
      chatId: chatId,
      name: name,
      description: description,
      messageId: messageId,
      messageIndex: messageIndex,
      createdAt: now,
    );

    await _db.into(_db.bookmarks).insert(BookmarksCompanion(
          id: Value(bookmark.id),
          chatId: Value(bookmark.chatId),
          name: Value(bookmark.name),
          description: Value(bookmark.description),
          messageId: Value(bookmark.messageId),
          messageIndex: Value(bookmark.messageIndex),
          createdAt: Value(bookmark.createdAt),
        ));

    return bookmark;
  }

  /// Update a bookmark
  Future<Bookmark> updateBookmark(Bookmark bookmark) async {
    await (_db.update(_db.bookmarks)..where((t) => t.id.equals(bookmark.id)))
        .write(BookmarksCompanion(
          name: Value(bookmark.name),
          description: Value(bookmark.description),
        ));
    return bookmark;
  }

  /// Delete a bookmark
  Future<void> deleteBookmark(String id) async {
    await (_db.delete(_db.bookmarks)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all bookmarks for a chat
  Future<void> deleteBookmarksForChat(String chatId) async {
    await (_db.delete(_db.bookmarks)..where((t) => t.chatId.equals(chatId))).go();
  }

  /// Get bookmark count for a chat
  Future<int> getBookmarkCount(String chatId) async {
    final bookmarks = await getBookmarksForChat(chatId);
    return bookmarks.length;
  }

  // Private helper
  Bookmark _bookmarkFromRow(db.Bookmark row) {
    return Bookmark(
      id: row.id,
      chatId: row.chatId,
      name: row.name,
      description: row.description,
      messageId: row.messageId,
      messageIndex: row.messageIndex,
      createdAt: row.createdAt,
    );
  }
}