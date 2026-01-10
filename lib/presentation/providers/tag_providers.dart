import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/tag.dart' as models;
import 'package:native_tavern/data/repositories/tag_repository.dart';
import 'package:native_tavern/core/services/initialization_service.dart';

/// Provider for TagRepository
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TagRepository(db);
});

/// Provider for all tags
final allTagsProvider = FutureProvider<List<models.Tag>>((ref) async {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getAllTags();
});

/// Provider for tag usage counts
final tagUsageCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getTagUsageCounts();
});

/// Provider for tags of a specific character
final characterTagsProvider =
    FutureProvider.family<List<models.Tag>, String>((ref, characterId) async {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.getTagsForCharacter(characterId);
});

/// State notifier for managing tags
class TagNotifier extends StateNotifier<AsyncValue<List<models.Tag>>> {
  final TagRepository _repository;
  final Ref _ref;

  TagNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadTags();
  }

  Future<void> _loadTags() async {
    state = const AsyncValue.loading();
    try {
      final tags = await _repository.getAllTags();
      state = AsyncValue.data(tags);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadTags();
    // Invalidate related providers
    _ref.invalidate(allTagsProvider);
    _ref.invalidate(tagUsageCountsProvider);
  }

  Future<models.Tag> createTag({
    required String name,
    String? color,
    String? icon,
  }) async {
    final tag = await _repository.createTag(
      name: name,
      color: color,
      icon: icon,
    );
    await refresh();
    return tag;
  }

  Future<void> updateTag(models.Tag tag) async {
    await _repository.updateTag(tag);
    await refresh();
  }

  Future<void> deleteTag(String tagId) async {
    await _repository.deleteTag(tagId);
    await refresh();
  }

  Future<void> addTagToCharacter(String characterId, String tagId) async {
    await _repository.addTagToCharacter(characterId, tagId);
    _ref.invalidate(characterTagsProvider(characterId));
    _ref.invalidate(tagUsageCountsProvider);
  }

  Future<void> removeTagFromCharacter(String characterId, String tagId) async {
    await _repository.removeTagFromCharacter(characterId, tagId);
    _ref.invalidate(characterTagsProvider(characterId));
    _ref.invalidate(tagUsageCountsProvider);
  }

  Future<void> setTagsForCharacter(
      String characterId, List<String> tagIds) async {
    await _repository.setTagsForCharacter(characterId, tagIds);
    _ref.invalidate(characterTagsProvider(characterId));
    _ref.invalidate(tagUsageCountsProvider);
  }
}

/// Provider for TagNotifier
final tagNotifierProvider =
    StateNotifierProvider<TagNotifier, AsyncValue<List<models.Tag>>>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return TagNotifier(repository, ref);
});

/// State for tag-based character filtering
class TagFilterState {
  final Set<String> selectedTagIds;
  final bool matchAll; // true = AND, false = OR

  const TagFilterState({
    this.selectedTagIds = const {},
    this.matchAll = false,
  });

  TagFilterState copyWith({
    Set<String>? selectedTagIds,
    bool? matchAll,
  }) {
    return TagFilterState(
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      matchAll: matchAll ?? this.matchAll,
    );
  }

  bool get hasFilter => selectedTagIds.isNotEmpty;
}

/// Notifier for tag filter state
class TagFilterNotifier extends StateNotifier<TagFilterState> {
  final TagRepository _repository;

  TagFilterNotifier(this._repository) : super(const TagFilterState());

  void toggleTag(String tagId) {
    final newSet = Set<String>.from(state.selectedTagIds);
    if (newSet.contains(tagId)) {
      newSet.remove(tagId);
    } else {
      newSet.add(tagId);
    }
    state = state.copyWith(selectedTagIds: newSet);
  }

  void selectTag(String tagId) {
    final newSet = Set<String>.from(state.selectedTagIds);
    newSet.add(tagId);
    state = state.copyWith(selectedTagIds: newSet);
  }

  void deselectTag(String tagId) {
    final newSet = Set<String>.from(state.selectedTagIds);
    newSet.remove(tagId);
    state = state.copyWith(selectedTagIds: newSet);
  }

  void clearFilter() {
    state = const TagFilterState();
  }

  void setMatchAll(bool matchAll) {
    state = state.copyWith(matchAll: matchAll);
  }

  /// Get character IDs that match the current filter
  Future<Set<String>?> getFilteredCharacterIds() async {
    if (!state.hasFilter) return null;

    final tagIds = state.selectedTagIds.toList();
    final characterIds = state.matchAll
        ? await _repository.getCharactersWithAllTags(tagIds)
        : await _repository.getCharactersWithAnyTags(tagIds);

    return characterIds.toSet();
  }
}

/// Provider for tag filter state
final tagFilterProvider =
    StateNotifierProvider<TagFilterNotifier, TagFilterState>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return TagFilterNotifier(repository);
});

/// Provider for filtered character IDs based on tag selection
final tagFilteredCharacterIdsProvider = FutureProvider<Set<String>?>((ref) async {
  final filterState = ref.watch(tagFilterProvider);
  if (!filterState.hasFilter) return null;

  final repository = ref.watch(tagRepositoryProvider);
  final tagIds = filterState.selectedTagIds.toList();
  
  final characterIds = filterState.matchAll
      ? await repository.getCharactersWithAllTags(tagIds)
      : await repository.getCharactersWithAnyTags(tagIds);

  return characterIds.toSet();
});