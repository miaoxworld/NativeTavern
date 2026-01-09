import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/character.dart';
import '../../data/repositories/character_repository.dart';

/// Sort options for characters
enum CharacterSortOption {
  nameAsc,
  nameDesc,
  createdAtDesc,
  createdAtAsc,
  modifiedAtDesc,
  modifiedAtAsc,
}

/// Filter state for character list
class CharacterFilterState {
  final String searchQuery;
  final List<String> selectedTags;
  final bool showFavoritesOnly;
  final CharacterSortOption sortOption;

  const CharacterFilterState({
    this.searchQuery = '',
    this.selectedTags = const [],
    this.showFavoritesOnly = false,
    this.sortOption = CharacterSortOption.modifiedAtDesc,
  });

  CharacterFilterState copyWith({
    String? searchQuery,
    List<String>? selectedTags,
    bool? showFavoritesOnly,
    CharacterSortOption? sortOption,
  }) {
    return CharacterFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTags: selectedTags ?? this.selectedTags,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  /// Check if any filters are active
  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || selectedTags.isNotEmpty || showFavoritesOnly;
}

/// Notifier for character filter state
class CharacterFilterNotifier extends StateNotifier<CharacterFilterState> {
  CharacterFilterNotifier() : super(const CharacterFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleTag(String tag) {
    final tags = List<String>.from(state.selectedTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(selectedTags: tags);
  }

  void clearTags() {
    state = state.copyWith(selectedTags: []);
  }

  void setTags(List<String> tags) {
    state = state.copyWith(selectedTags: tags);
  }

  void toggleFavoritesOnly() {
    state = state.copyWith(showFavoritesOnly: !state.showFavoritesOnly);
  }

  void setSortOption(CharacterSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void clearFilters() {
    state = const CharacterFilterState();
  }
}

/// Provider for character filter state
final characterFilterProvider =
    StateNotifierProvider<CharacterFilterNotifier, CharacterFilterState>((ref) {
  return CharacterFilterNotifier();
});

/// Provider for all unique tags across all characters
final allTagsProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(characterRepositoryProvider);
  final characters = await repo.getAllCharacters();
  
  final tagSet = <String>{};
  for (final character in characters) {
    tagSet.addAll(character.tags);
  }
  
  final tags = tagSet.toList()..sort();
  return tags;
});

/// Provider for filtered and sorted characters
final filteredCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final repo = ref.watch(characterRepositoryProvider);
  final filterState = ref.watch(characterFilterProvider);
  
  var characters = await repo.getAllCharacters();
  
  // Apply search filter
  if (filterState.searchQuery.isNotEmpty) {
    final query = filterState.searchQuery.toLowerCase();
    characters = characters.where((c) {
      return c.name.toLowerCase().contains(query) ||
          c.description.toLowerCase().contains(query) ||
          c.tags.any((t) => t.toLowerCase().contains(query)) ||
          c.creator.toLowerCase().contains(query);
    }).toList();
  }
  
  // Apply tag filter
  if (filterState.selectedTags.isNotEmpty) {
    characters = characters.where((c) {
      return filterState.selectedTags.every((tag) => c.tags.contains(tag));
    }).toList();
  }
  
  // Apply favorites filter
  if (filterState.showFavoritesOnly) {
    characters = characters.where((c) => c.isFavorite).toList();
  }
  
  // Apply sorting
  switch (filterState.sortOption) {
    case CharacterSortOption.nameAsc:
      characters.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      break;
    case CharacterSortOption.nameDesc:
      characters.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      break;
    case CharacterSortOption.createdAtDesc:
      characters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case CharacterSortOption.createdAtAsc:
      characters.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case CharacterSortOption.modifiedAtDesc:
      characters.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      break;
    case CharacterSortOption.modifiedAtAsc:
      characters.sort((a, b) => a.modifiedAt.compareTo(b.modifiedAt));
      break;
  }
  
  return characters;
});

/// Provider for favorite characters only
final favoriteCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final repo = ref.watch(characterRepositoryProvider);
  final characters = await repo.getAllCharacters();
  return characters.where((c) => c.isFavorite).toList();
});

/// Provider for character count by tag
final tagCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repo = ref.watch(characterRepositoryProvider);
  final characters = await repo.getAllCharacters();
  
  final counts = <String, int>{};
  for (final character in characters) {
    for (final tag in character.tags) {
      counts[tag] = (counts[tag] ?? 0) + 1;
    }
  }
  
  return counts;
});

/// Helper extension for sort option display
extension CharacterSortOptionExtension on CharacterSortOption {
  String get displayName {
    switch (this) {
      case CharacterSortOption.nameAsc:
        return 'Name (A-Z)';
      case CharacterSortOption.nameDesc:
        return 'Name (Z-A)';
      case CharacterSortOption.createdAtDesc:
        return 'Newest First';
      case CharacterSortOption.createdAtAsc:
        return 'Oldest First';
      case CharacterSortOption.modifiedAtDesc:
        return 'Recently Modified';
      case CharacterSortOption.modifiedAtAsc:
        return 'Least Recently Modified';
    }
  }

  String get icon {
    switch (this) {
      case CharacterSortOption.nameAsc:
        return '↑';
      case CharacterSortOption.nameDesc:
        return '↓';
      case CharacterSortOption.createdAtDesc:
      case CharacterSortOption.modifiedAtDesc:
        return '↓';
      case CharacterSortOption.createdAtAsc:
      case CharacterSortOption.modifiedAtAsc:
        return '↑';
    }
  }
}