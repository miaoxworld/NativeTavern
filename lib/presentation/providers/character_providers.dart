import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';

// Note: characterRepositoryProvider is defined in character_repository.dart

/// Selected character state
final selectedCharacterIdProvider = StateProvider<String?>((ref) => null);

/// Character details, invalidated after editor writes so open screens refresh.
final characterDetailProvider =
    FutureProvider.family<Character?, String>((ref, id) async {
  final repo = ref.watch(characterRepositoryProvider);
  return repo.getCharacter(id);
});

/// Character list provider
final characterListProvider =
    AsyncNotifierProvider<CharacterListNotifier, List<Character>>(() {
  return CharacterListNotifier();
});

/// Character list notifier
class CharacterListNotifier extends AsyncNotifier<List<Character>> {
  static const _pageSize = 40;
  int _offset = 0;
  bool _hasMore = true;
  bool _loadingMore = false;
  String _query = '';

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _loadingMore;

  @override
  Future<List<Character>> build() async {
    final repo = ref.watch(characterRepositoryProvider);
    _offset = 0;
    _hasMore = true;
    final page = await repo.getCharactersPage(limit: _pageSize);
    _offset = page.length;
    _hasMore = page.length == _pageSize;
    return page;
  }

  Future<void> refresh() async {
    _offset = 0;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final page =
          await ref.read(characterRepositoryProvider).getCharactersPage(
                limit: _pageSize,
                query: _query,
              );
      _offset = page.length;
      _hasMore = page.length == _pageSize;
      return page;
    });
  }

  Future<void> setQuery(String query) async {
    _query = query.trim();
    await refresh();
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore || !state.hasValue) return;
    _loadingMore = true;
    try {
      final page =
          await ref.read(characterRepositoryProvider).getCharactersPage(
                limit: _pageSize,
                offset: _offset,
                query: _query,
              );
      final current = state.valueOrNull ?? const <Character>[];
      state = AsyncData([...current, ...page]);
      _offset += page.length;
      _hasMore = page.length == _pageSize;
    } catch (error, stack) {
      state = AsyncError(error, stack);
    } finally {
      _loadingMore = false;
    }
  }

  Future<Character> addCharacter(Character character) async {
    final repo = ref.read(characterRepositoryProvider);
    final createdCharacter = await repo.createCharacter(character);
    await refresh();
    return createdCharacter;
  }

  Future<void> updateCharacter(Character character) async {
    final repo = ref.read(characterRepositoryProvider);
    await repo.updateCharacter(character);
    await refresh();
  }

  Future<void> deleteCharacter(String id) async {
    final repo = ref.read(characterRepositoryProvider);
    await repo.deleteCharacter(id);
    await refresh();
  }
}

/// Selected character provider
final selectedCharacterProvider = FutureProvider<Character?>((ref) async {
  final id = ref.watch(selectedCharacterIdProvider);
  if (id == null) return null;

  final repo = ref.watch(characterRepositoryProvider);
  return repo.getCharacter(id);
});

/// Character search provider
final characterSearchProvider =
    FutureProvider.family<List<Character>, String>((ref, query) async {
  if (query.isEmpty) return [];

  final repo = ref.watch(characterRepositoryProvider);
  return repo.searchCharacters(query);
});
