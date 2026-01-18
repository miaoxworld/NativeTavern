import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/data/repositories/world_info_repository.dart';
import 'package:native_tavern/core/services/initialization_service.dart';

/// Provider for WorldInfo repository (properly initialized)
final worldInfoRepositoryProvider = Provider<WorldInfoRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return WorldInfoRepository(db);
});

/// All world infos provider
final allWorldInfosProvider = FutureProvider<List<WorldInfo>>((ref) async {
  final repo = ref.watch(worldInfoRepositoryProvider);
  return repo.getAllWorldInfos();
});

/// Global world infos provider
final globalWorldInfosProvider = FutureProvider<List<WorldInfo>>((ref) async {
  final repo = ref.watch(worldInfoRepositoryProvider);
  return repo.getGlobalWorldInfos();
});

/// World infos for a specific character
final characterWorldInfosProvider = FutureProvider.family<List<WorldInfo>, String>((ref, characterId) async {
  final repo = ref.watch(worldInfoRepositoryProvider);
  return repo.getWorldInfosForCharacter(characterId);
});

/// Active world info IDs for the current chat
final activeWorldInfoIdsProvider = StateProvider<List<String>>((ref) => []);

/// World info notifier for CRUD operations
class WorldInfoNotifier extends StateNotifier<AsyncValue<List<WorldInfo>>> {
  final WorldInfoRepository _repository;
  final Ref _ref;

  WorldInfoNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadWorldInfos();
  }

  Future<void> _loadWorldInfos() async {
    state = const AsyncValue.loading();
    try {
      final worldInfos = await _repository.getAllWorldInfos();
      state = AsyncValue.data(worldInfos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadWorldInfos();
  }

  Future<WorldInfo> createWorldInfo({
    required String name,
    String? description,
    bool isGlobal = false,
    String? characterId,
  }) async {
    final worldInfo = await _repository.createWorldInfo(
      name: name,
      description: description,
      isGlobal: isGlobal,
      characterId: characterId,
    );
    await _loadWorldInfos();
    return worldInfo;
  }

  Future<void> updateWorldInfo(WorldInfo worldInfo) async {
    await _repository.updateWorldInfo(worldInfo);
    await _loadWorldInfos();
  }

  Future<void> deleteWorldInfo(String id) async {
    await _repository.deleteWorldInfo(id);
    await _loadWorldInfos();
  }

  Future<WorldInfoEntry> addEntry({
    required String worldInfoId,
    required List<String> keys,
    required String content,
    List<String>? secondaryKeys,
    String? comment,
    WorldInfoPosition? position,
    bool? constant,
    bool? selective,
    int? insertionOrder,
  }) async {
    final entry = await _repository.addEntry(
      worldInfoId: worldInfoId,
      keys: keys,
      content: content,
      secondaryKeys: secondaryKeys,
      comment: comment,
      position: position,
      constant: constant,
      selective: selective,
      insertionOrder: insertionOrder,
    );
    await _loadWorldInfos();
    return entry;
  }

  Future<void> updateEntry(WorldInfoEntry entry) async {
    await _repository.updateEntry(entry);
    await _loadWorldInfos();
  }

  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id);
    await _loadWorldInfos();
  }
}

/// Provider for world info notifier
final worldInfoNotifierProvider = StateNotifierProvider<WorldInfoNotifier, AsyncValue<List<WorldInfo>>>((ref) {
  final repo = ref.watch(worldInfoRepositoryProvider);
  return WorldInfoNotifier(repo, ref);
});

/// Service for finding matching world info entries
class WorldInfoMatcher {
  final WorldInfoRepository _repository;

  WorldInfoMatcher(this._repository);

  /// Find all matching entries for the given context
  /// Supports recursion - entries can trigger other entries
  Future<List<WorldInfoEntry>> findMatchingEntries({
    required String contextText,
    required List<String> worldInfoIds,
    int maxRecursionDepth = 3,
    int tokenBudget = 2000, // Maximum tokens for world info
  }) async {
    print('=== WorldInfoMatcher.findMatchingEntries ===');
    print('World info IDs to search: $worldInfoIds');
    print('Context length: ${contextText.length}');
    
    final allMatched = <WorldInfoEntry>[];
    final processedIds = <String>{};
    var currentContext = contextText;
    var recursionDepth = 0;

    while (recursionDepth <= maxRecursionDepth) {
      print('Recursion depth: $recursionDepth');
      final newMatches = await _repository.findMatchingEntries(
        currentContext,
        worldInfoIds,
      );
      print('Repository found ${newMatches.length} matches at depth $recursionDepth');

      // Filter out already processed entries
      final unprocessedMatches = newMatches
          .where((e) => !processedIds.contains(e.id))
          .where((e) => !e.preventRecursion || recursionDepth == 0)
          .toList();
      
      print('Unprocessed matches: ${unprocessedMatches.length}');

      if (unprocessedMatches.isEmpty) break;

      for (final entry in unprocessedMatches) {
        if (!processedIds.contains(entry.id)) {
          processedIds.add(entry.id);
          allMatched.add(entry);
          print('  Added entry: ${entry.comment.isNotEmpty ? entry.comment : entry.keys.join(", ")}');
          
          // Add entry content to context for recursive matching
          currentContext = '$currentContext\n${entry.content}';
        }
      }

      recursionDepth++;
    }

    // Add constant entries that are always included
    // An entry is constant if:
    // 1. entry.constant == true (explicitly marked as constant)
    // 2. entry.keys is empty (no keys means always included)
    debugPrint('\n╔══════════════════════════════════════════════════════════════');
    debugPrint('║ 📋 CHECKING CONSTANT ENTRIES');
    debugPrint('╠══════════════════════════════════════════════════════════════');
    
    for (final worldInfoId in worldInfoIds) {
      final entries = await _repository.getEntriesForWorldInfo(worldInfoId);
      debugPrint('║ World Info ID: $worldInfoId');
      debugPrint('║ Total entries: ${entries.length}');
      debugPrint('╠──────────────────────────────────────────────────────────────');
      
      for (final entry in entries) {
        final isConstant = entry.constant || entry.keys.isEmpty;
        final entryName = entry.comment.isNotEmpty ? entry.comment : (entry.keys.isEmpty ? "(no keys)" : entry.keys.join(", "));
        
        debugPrint('║   Entry: $entryName');
        debugPrint('║     • enabled: ${entry.enabled}');
        debugPrint('║     • constant: ${entry.constant}');
        debugPrint('║     • keys: ${entry.keys.isEmpty ? "(empty)" : entry.keys.join(", ")}');
        debugPrint('║     • isConstant (constant OR keys.isEmpty): $isConstant');
        
        if (isConstant && entry.enabled && !processedIds.contains(entry.id)) {
          allMatched.add(entry);
          processedIds.add(entry.id);
          debugPrint('║     ✅ ADDED as constant entry');
        } else if (!entry.enabled) {
          debugPrint('║     ❌ SKIPPED: entry is disabled');
        } else if (processedIds.contains(entry.id)) {
          debugPrint('║     ⏭️ SKIPPED: already processed');
        } else if (!isConstant) {
          debugPrint('║     ℹ️ Not a constant entry, will be matched by keywords');
        }
      }
      debugPrint('║');
    }

    // Sort by insertion order
    allMatched.sort((a, b) => a.insertionOrder.compareTo(b.insertionOrder));

    debugPrint('╠══════════════════════════════════════════════════════════════');
    debugPrint('║ 📊 FINAL RESULT: ${allMatched.length} matched entries');
    debugPrint('╚══════════════════════════════════════════════════════════════\n');
    
    return allMatched;
  }

  /// Group entries by their insertion position
  Map<WorldInfoPosition, List<WorldInfoEntry>> groupByPosition(List<WorldInfoEntry> entries) {
    final grouped = <WorldInfoPosition, List<WorldInfoEntry>>{};
    
    for (final entry in entries) {
      grouped.putIfAbsent(entry.position, () => []).add(entry);
    }
    
    return grouped;
  }
}

/// Provider for world info matcher
final worldInfoMatcherProvider = Provider<WorldInfoMatcher>((ref) {
  final repo = ref.watch(worldInfoRepositoryProvider);
  return WorldInfoMatcher(repo);
});