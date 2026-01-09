import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart' hide WorldInfo, WorldInfoEntry;
import 'package:native_tavern/data/database/database.dart' as db;
import 'package:native_tavern/data/models/world_info.dart' as models;
import 'package:uuid/uuid.dart';

/// Provider for WorldInfo repository
final worldInfoRepositoryProvider = Provider<WorldInfoRepository>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Repository for managing world info / lorebook data
class WorldInfoRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

  WorldInfoRepository(this._db);

  /// Get all world infos
  Future<List<models.WorldInfo>> getAllWorldInfos() async {
    final rows = await _db.select(_db.worldInfos).get();
    
    final worldInfos = <models.WorldInfo>[];
    for (final row in rows) {
      final entries = await getEntriesForWorldInfo(row.id);
      worldInfos.add(_worldInfoFromRow(row, entries));
    }
    return worldInfos;
  }

  /// Get global world infos (not bound to a character)
  Future<List<models.WorldInfo>> getGlobalWorldInfos() async {
    final rows = await (_db.select(_db.worldInfos)
          ..where((t) => t.isGlobal.equals(true)))
        .get();
    
    final worldInfos = <models.WorldInfo>[];
    for (final row in rows) {
      final entries = await getEntriesForWorldInfo(row.id);
      worldInfos.add(_worldInfoFromRow(row, entries));
    }
    return worldInfos;
  }

  /// Get world infos for a specific character
  Future<List<models.WorldInfo>> getWorldInfosForCharacter(String characterId) async {
    final rows = await (_db.select(_db.worldInfos)
          ..where((t) => t.characterId.equals(characterId)))
        .get();
    
    final worldInfos = <models.WorldInfo>[];
    for (final row in rows) {
      final entries = await getEntriesForWorldInfo(row.id);
      worldInfos.add(_worldInfoFromRow(row, entries));
    }
    return worldInfos;
  }

  /// Get world info by ID
  Future<models.WorldInfo?> getWorldInfoById(String id) async {
    final row = await (_db.select(_db.worldInfos)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    
    if (row == null) return null;
    
    final entries = await getEntriesForWorldInfo(id);
    return _worldInfoFromRow(row, entries);
  }

  /// Create a new world info
  Future<models.WorldInfo> createWorldInfo({
    required String name,
    String? description,
    bool isGlobal = false,
    String? characterId,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    
    final companion = WorldInfosCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      enabled: const Value(true),
      isGlobal: Value(isGlobal),
      characterId: Value(characterId),
      createdAt: Value(now),
      modifiedAt: Value(now),
    );
    
    await _db.into(_db.worldInfos).insert(companion);
    
    return models.WorldInfo(
      id: id,
      name: name,
      description: description,
      entries: [],
      enabled: true,
      isGlobal: isGlobal,
      characterId: characterId,
      createdAt: now,
      modifiedAt: now,
    );
  }

  /// Update world info
  Future<models.WorldInfo> updateWorldInfo(models.WorldInfo worldInfo) async {
    final now = DateTime.now();
    
    await (_db.update(_db.worldInfos)..where((t) => t.id.equals(worldInfo.id)))
        .write(
      WorldInfosCompanion(
        name: Value(worldInfo.name),
        description: Value(worldInfo.description),
        enabled: Value(worldInfo.enabled),
        isGlobal: Value(worldInfo.isGlobal),
        characterId: Value(worldInfo.characterId),
        modifiedAt: Value(now),
      ),
    );
    
    return worldInfo.copyWith(modifiedAt: now);
  }

  /// Delete world info
  Future<void> deleteWorldInfo(String id) async {
    // Delete all entries first
    await (_db.delete(_db.worldInfoEntries)
          ..where((t) => t.worldInfoId.equals(id)))
        .go();
    // Delete the world info
    await (_db.delete(_db.worldInfos)..where((t) => t.id.equals(id))).go();
  }

  /// Get entries for a world info
  Future<List<models.WorldInfoEntry>> getEntriesForWorldInfo(String worldInfoId) async {
    final rows = await (_db.select(_db.worldInfoEntries)
          ..where((t) => t.worldInfoId.equals(worldInfoId))
          ..orderBy([(t) => OrderingTerm.asc(t.insertionOrder)]))
        .get();
    return rows.map(_entryFromRow).toList();
  }

  /// Add entry to world info
  Future<models.WorldInfoEntry> addEntry({
    required String worldInfoId,
    required List<String> keys,
    required String content,
    List<String>? secondaryKeys,
    String? comment,
    models.WorldInfoPosition position = models.WorldInfoPosition.afterCharDefs,
    int depth = 4,
  }) async {
    final id = _uuid.v4();
    
    // Get the next insertion order
    final existingEntries = await getEntriesForWorldInfo(worldInfoId);
    final insertionOrder = existingEntries.isEmpty 
        ? 0 
        : existingEntries.map((e) => e.insertionOrder).reduce((a, b) => a > b ? a : b) + 1;
    
    final companion = WorldInfoEntriesCompanion(
      id: Value(id),
      worldInfoId: Value(worldInfoId),
      keys: Value(jsonEncode(keys)),
      secondaryKeys: Value(jsonEncode(secondaryKeys ?? [])),
      content: Value(content),
      comment: Value(comment ?? ''),
      enabled: const Value(true),
      constant: const Value(false),
      selective: Value(secondaryKeys?.isNotEmpty ?? false),
      insertionOrder: Value(insertionOrder),
      caseSensitive: const Value(false),
      matchWholeWords: const Value(false),
      probability: const Value(100),
      position: Value(position.index),
      depth: Value(depth),
      groupWeight: const Value(100),
      preventRecursion: const Value(false),
      scanDepth: const Value(1000),
      extensionsJson: const Value('{}'),
    );
    
    await _db.into(_db.worldInfoEntries).insert(companion);
    
    // Update world info modified time
    await (_db.update(_db.worldInfos)
          ..where((t) => t.id.equals(worldInfoId)))
        .write(WorldInfosCompanion(modifiedAt: Value(DateTime.now())));
    
    return models.WorldInfoEntry(
      id: id,
      worldInfoId: worldInfoId,
      keys: keys,
      secondaryKeys: secondaryKeys ?? [],
      content: content,
      comment: comment ?? '',
      enabled: true,
      constant: false,
      selective: secondaryKeys?.isNotEmpty ?? false,
      insertionOrder: insertionOrder,
      caseSensitive: false,
      matchWholeWords: false,
      probability: 100,
      position: position,
      depth: depth,
      groupWeight: 100,
      preventRecursion: false,
      scanDepth: 1000,
    );
  }

  /// Update entry
  Future<models.WorldInfoEntry> updateEntry(models.WorldInfoEntry entry) async {
    await (_db.update(_db.worldInfoEntries)
          ..where((t) => t.id.equals(entry.id)))
        .write(
      WorldInfoEntriesCompanion(
        keys: Value(jsonEncode(entry.keys)),
        secondaryKeys: Value(jsonEncode(entry.secondaryKeys)),
        content: Value(entry.content),
        comment: Value(entry.comment),
        enabled: Value(entry.enabled),
        constant: Value(entry.constant),
        selective: Value(entry.selective),
        insertionOrder: Value(entry.insertionOrder),
        caseSensitive: Value(entry.caseSensitive),
        matchWholeWords: Value(entry.matchWholeWords),
        probability: Value(entry.probability),
        position: Value(entry.position.index),
        depth: Value(entry.depth),
        group: Value(entry.group),
        groupWeight: Value(entry.groupWeight),
        preventRecursion: Value(entry.preventRecursion),
        scanDepth: Value(entry.scanDepth),
      ),
    );
    
    // Update world info modified time
    await (_db.update(_db.worldInfos)
          ..where((t) => t.id.equals(entry.worldInfoId)))
        .write(WorldInfosCompanion(modifiedAt: Value(DateTime.now())));
    
    return entry;
  }

  /// Delete entry
  Future<void> deleteEntry(String id) async {
    await (_db.delete(_db.worldInfoEntries)..where((t) => t.id.equals(id)))
        .go();
  }

  /// Find matching entries for given text
  Future<List<models.WorldInfoEntry>> findMatchingEntries(
    String text,
    List<String> worldInfoIds,
  ) async {
    final matchingEntries = <models.WorldInfoEntry>[];
    
    for (final worldInfoId in worldInfoIds) {
      final entries = await getEntriesForWorldInfo(worldInfoId);
      
      for (final entry in entries) {
        if (!entry.enabled) continue;
        
        final textToSearch = entry.caseSensitive ? text : text.toLowerCase();
        
        bool keyMatched = false;
        for (final key in entry.keys) {
          final searchKey = entry.caseSensitive ? key : key.toLowerCase();
          
          if (entry.matchWholeWords) {
            final regex = RegExp(r'\b' + RegExp.escape(searchKey) + r'\b');
            keyMatched = regex.hasMatch(textToSearch);
          } else {
            keyMatched = textToSearch.contains(searchKey);
          }
          
          if (keyMatched) break;
        }
        
        if (!keyMatched) continue;
        
        // Check secondary keys if selective
        if (entry.selective && entry.secondaryKeys.isNotEmpty) {
          bool secondaryMatched = false;
          for (final key in entry.secondaryKeys) {
            final searchKey = entry.caseSensitive ? key : key.toLowerCase();
            if (textToSearch.contains(searchKey)) {
              secondaryMatched = true;
              break;
            }
          }
          if (!secondaryMatched) continue;
        }
        
        // Check probability
        if (entry.probability < 100) {
          final random = DateTime.now().millisecondsSinceEpoch % 100;
          if (random >= entry.probability) continue;
        }
        
        matchingEntries.add(entry);
      }
    }
    
    // Sort by insertion order
    matchingEntries.sort((a, b) => a.insertionOrder.compareTo(b.insertionOrder));
    
    return matchingEntries;
  }

  // Private helpers
  
  models.WorldInfo _worldInfoFromRow(db.WorldInfo row, List<models.WorldInfoEntry> entries) {
    return models.WorldInfo(
      id: row.id,
      name: row.name,
      description: row.description,
      entries: entries,
      enabled: row.enabled,
      isGlobal: row.isGlobal,
      characterId: row.characterId,
      createdAt: row.createdAt,
      modifiedAt: row.modifiedAt,
    );
  }

  models.WorldInfoEntry _entryFromRow(db.WorldInfoEntry row) {
    return models.WorldInfoEntry(
      id: row.id,
      worldInfoId: row.worldInfoId,
      keys: _parseJsonList(row.keys),
      secondaryKeys: _parseJsonList(row.secondaryKeys),
      content: row.content,
      comment: row.comment,
      enabled: row.enabled,
      constant: row.constant,
      selective: row.selective,
      insertionOrder: row.insertionOrder,
      caseSensitive: row.caseSensitive,
      matchWholeWords: row.matchWholeWords,
      probability: row.probability,
      position: models.WorldInfoPosition.values[row.position],
      depth: row.depth,
      group: row.group,
      groupWeight: row.groupWeight,
      preventRecursion: row.preventRecursion,
      scanDepth: row.scanDepth,
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
