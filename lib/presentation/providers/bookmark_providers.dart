import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/bookmark.dart';
import 'package:native_tavern/data/repositories/bookmark_repository.dart';

/// Provider for bookmarks of a specific chat
final chatBookmarksProvider = FutureProvider.family<List<Bookmark>, String>((ref, chatId) async {
  final repo = ref.watch(bookmarkRepositoryProvider);
  return repo.getBookmarksForChat(chatId);
});

/// Provider for a single bookmark
final bookmarkProvider = FutureProvider.family<Bookmark?, String>((ref, bookmarkId) async {
  final repo = ref.watch(bookmarkRepositoryProvider);
  return repo.getBookmark(bookmarkId);
});

/// State for managing bookmarks in active chat
class BookmarkState {
  final List<Bookmark> bookmarks;
  final bool isLoading;
  final String? error;

  const BookmarkState({
    this.bookmarks = const [],
    this.isLoading = false,
    this.error,
  });

  BookmarkState copyWith({
    List<Bookmark>? bookmarks,
    bool? isLoading,
    String? error,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing bookmarks
class BookmarkNotifier extends StateNotifier<BookmarkState> {
  final BookmarkRepository _repository;
  String? _currentChatId;

  BookmarkNotifier(this._repository) : super(const BookmarkState());

  /// Load bookmarks for a chat
  Future<void> loadBookmarks(String chatId) async {
    _currentChatId = chatId;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final bookmarks = await _repository.getBookmarksForChat(chatId);
      state = state.copyWith(bookmarks: bookmarks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create a new bookmark at current message
  Future<Bookmark?> createBookmark({
    required String name,
    String? description,
    required String messageId,
    required int messageIndex,
  }) async {
    if (_currentChatId == null) return null;

    try {
      final bookmark = await _repository.createBookmark(
        chatId: _currentChatId!,
        name: name,
        description: description,
        messageId: messageId,
        messageIndex: messageIndex,
      );

      state = state.copyWith(
        bookmarks: [...state.bookmarks, bookmark],
      );

      return bookmark;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Update a bookmark
  Future<void> updateBookmark(Bookmark bookmark) async {
    try {
      final updated = await _repository.updateBookmark(bookmark);
      state = state.copyWith(
        bookmarks: state.bookmarks.map((b) {
          return b.id == bookmark.id ? updated : b;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete a bookmark
  Future<void> deleteBookmark(String bookmarkId) async {
    try {
      await _repository.deleteBookmark(bookmarkId);
      state = state.copyWith(
        bookmarks: state.bookmarks.where((b) => b.id != bookmarkId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Clear bookmarks (when switching chats)
  void clear() {
    _currentChatId = null;
    state = const BookmarkState();
  }
}

/// Provider for bookmark notifier
final bookmarkNotifierProvider = StateNotifierProvider<BookmarkNotifier, BookmarkState>((ref) {
  final repo = ref.watch(bookmarkRepositoryProvider);
  return BookmarkNotifier(repo);
});