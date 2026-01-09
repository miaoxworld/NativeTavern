import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';

// Note: characterRepositoryProvider is defined in character_repository.dart

/// Selected character state
final selectedCharacterIdProvider = StateProvider<String?>((ref) => null);

/// Character list provider
final characterListProvider = AsyncNotifierProvider<CharacterListNotifier, List<Character>>(() {
  return CharacterListNotifier();
});

/// Character list notifier
class CharacterListNotifier extends AsyncNotifier<List<Character>> {
  @override
  Future<List<Character>> build() async {
    final repo = ref.watch(characterRepositoryProvider);
    return repo.getAllCharacters();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(characterRepositoryProvider);
      return repo.getAllCharacters();
    });
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
final characterSearchProvider = FutureProvider.family<List<Character>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final repo = ref.watch(characterRepositoryProvider);
  return repo.searchCharacters(query);
});