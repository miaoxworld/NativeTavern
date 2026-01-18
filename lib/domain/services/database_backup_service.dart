import 'package:drift/drift.dart';
import 'package:native_tavern/data/database/database.dart';

/// Service for exporting and importing database data for backup purposes
class DatabaseBackupService {
  final AppDatabase _db;
  
  DatabaseBackupService(this._db);
  
  /// Export all database data to a map suitable for backup
  Future<Map<String, dynamic>> exportAllData() async {
    final characters = await _db.select(_db.characters).get();
    final chats = await _db.select(_db.chats).get();
    final messages = await _db.select(_db.messages).get();
    final worldInfos = await _db.select(_db.worldInfos).get();
    final worldInfoEntries = await _db.select(_db.worldInfoEntries).get();
    final llmConfigs = await _db.select(_db.llmConfigs).get();
    final personas = await _db.select(_db.personas).get();
    final groups = await _db.select(_db.groups).get();
    final bookmarks = await _db.select(_db.bookmarks).get();
    final tags = await _db.select(_db.tags).get();
    final characterTags = await _db.select(_db.characterTags).get();
    
    return {
      'characters': _listToMap(characters.map((c) => c.toJson()).toList(), 'id'),
      'chats': _listToMap(chats.map((c) => c.toJson()).toList(), 'id'),
      'messages': _listToMap(messages.map((m) => m.toJson()).toList(), 'id'),
      'worldInfos': _listToMap(worldInfos.map((w) => w.toJson()).toList(), 'id'),
      'worldInfoEntries': _listToMap(worldInfoEntries.map((e) => e.toJson()).toList(), 'id'),
      'llmConfigs': _listToMap(llmConfigs.map((l) => l.toJson()).toList(), 'id'),
      'personas': _listToMap(personas.map((p) => p.toJson()).toList(), 'id'),
      'groups': _listToMap(groups.map((g) => g.toJson()).toList(), 'id'),
      'bookmarks': _listToMap(bookmarks.map((b) => b.toJson()).toList(), 'id'),
      'tags': _listToMap(tags.map((t) => t.toJson()).toList(), 'id'),
      'characterTags': characterTags.map((ct) => {'characterId': ct.characterId, 'tagId': ct.tagId}).toList(),
    };
  }
  
  /// Convert a list of items to a map keyed by the specified field
  Map<String, dynamic> _listToMap(List<Map<String, dynamic>> list, String keyField) {
    final map = <String, dynamic>{};
    for (final item in list) {
      final key = item[keyField];
      if (key != null) {
        map[key.toString()] = item;
      }
    }
    return map;
  }
  
  /// Import data from a backup, with support for different restore modes
  Future<ImportResult> importData({
    required Map<String, dynamic> data,
    required ImportMode mode,
  }) async {
    final result = ImportResult();
    
    // Import in order of dependencies
    // 1. Characters (no dependencies)
    if (data.containsKey('characters')) {
      final charResult = await _importCharacters(
        data['characters'] as Map<String, dynamic>,
        mode,
      );
      result.charactersAdded = charResult.added;
      result.charactersUpdated = charResult.updated;
      result.charactersSkipped = charResult.skipped;
    }
    
    // 2. Tags (no dependencies)
    if (data.containsKey('tags')) {
      final tagResult = await _importTags(
        data['tags'] as Map<String, dynamic>,
        mode,
      );
      result.tagsAdded = tagResult.added;
      result.tagsUpdated = tagResult.updated;
      result.tagsSkipped = tagResult.skipped;
    }
    
    // 3. Character-Tags junction (depends on characters and tags)
    if (data.containsKey('characterTags')) {
      await _importCharacterTags(
        data['characterTags'] as List<dynamic>,
        mode,
      );
    }
    
    // 4. World Infos (may depend on characters)
    if (data.containsKey('worldInfos')) {
      final wiResult = await _importWorldInfos(
        data['worldInfos'] as Map<String, dynamic>,
        mode,
      );
      result.worldInfosAdded = wiResult.added;
      result.worldInfosUpdated = wiResult.updated;
      result.worldInfosSkipped = wiResult.skipped;
    }
    
    // 5. World Info Entries (depends on world infos)
    if (data.containsKey('worldInfoEntries')) {
      await _importWorldInfoEntries(
        data['worldInfoEntries'] as Map<String, dynamic>,
        mode,
      );
    }
    
    // 6. Groups (no dependencies, but members reference characters)
    if (data.containsKey('groups')) {
      final groupResult = await _importGroups(
        data['groups'] as Map<String, dynamic>,
        mode,
      );
      result.groupsAdded = groupResult.added;
      result.groupsUpdated = groupResult.updated;
      result.groupsSkipped = groupResult.skipped;
    }
    
    // 7. Personas (no dependencies)
    if (data.containsKey('personas')) {
      final personaResult = await _importPersonas(
        data['personas'] as Map<String, dynamic>,
        mode,
      );
      result.personasAdded = personaResult.added;
      result.personasUpdated = personaResult.updated;
      result.personasSkipped = personaResult.skipped;
    }
    
    // 8. LLM Configs (no dependencies)
    if (data.containsKey('llmConfigs')) {
      final llmResult = await _importLlmConfigs(
        data['llmConfigs'] as Map<String, dynamic>,
        mode,
      );
      result.llmConfigsAdded = llmResult.added;
      result.llmConfigsUpdated = llmResult.updated;
      result.llmConfigsSkipped = llmResult.skipped;
    }
    
    // 9. Chats (depends on characters)
    if (data.containsKey('chats')) {
      final chatResult = await _importChats(
        data['chats'] as Map<String, dynamic>,
        mode,
      );
      result.chatsAdded = chatResult.added;
      result.chatsUpdated = chatResult.updated;
      result.chatsSkipped = chatResult.skipped;
    }
    
    // 10. Messages (depends on chats)
    if (data.containsKey('messages')) {
      final msgResult = await _importMessages(
        data['messages'] as Map<String, dynamic>,
        mode,
      );
      result.messagesAdded = msgResult.added;
      result.messagesUpdated = msgResult.updated;
      result.messagesSkipped = msgResult.skipped;
    }
    
    // 11. Bookmarks (depends on chats and messages)
    if (data.containsKey('bookmarks')) {
      final bookmarkResult = await _importBookmarks(
        data['bookmarks'] as Map<String, dynamic>,
        mode,
      );
      result.bookmarksAdded = bookmarkResult.added;
      result.bookmarksUpdated = bookmarkResult.updated;
      result.bookmarksSkipped = bookmarkResult.skipped;
    }
    
    return result;
  }
  
  Future<_ImportEntityResult> _importCharacters(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.characters)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        // Add new
        await _db.into(_db.characters).insert(Character.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        // Replace
        await (_db.update(_db.characters)..where((t) => t.id.equals(id)))
            .write(Character.fromJson(json).toCompanion(true));
        updated++;
      } else if (mode == ImportMode.merge) {
        // Merge - newer wins
        final backupTime = DateTime.tryParse(json['modifiedAt'] as String? ?? '');
        if (backupTime != null && backupTime.isAfter(existing.modifiedAt)) {
          await (_db.update(_db.characters)..where((t) => t.id.equals(id)))
              .write(Character.fromJson(json).toCompanion(true));
          updated++;
        } else {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<_ImportEntityResult> _importChats(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.chats)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.chats).insert(Chat.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.chats)..where((t) => t.id.equals(id)))
            .write(Chat.fromJson(json).toCompanion(true));
        updated++;
      } else if (mode == ImportMode.merge) {
        final backupTime = DateTime.tryParse(json['updatedAt'] as String? ?? '');
        if (backupTime != null && backupTime.isAfter(existing.updatedAt)) {
          await (_db.update(_db.chats)..where((t) => t.id.equals(id)))
              .write(Chat.fromJson(json).toCompanion(true));
          updated++;
        } else {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<_ImportEntityResult> _importMessages(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.messages)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.messages).insert(Message.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.messages)..where((t) => t.id.equals(id)))
            .write(Message.fromJson(json).toCompanion(true));
        updated++;
      } else if (mode == ImportMode.merge) {
        final backupTime = DateTime.tryParse(json['timestamp'] as String? ?? '');
        if (backupTime != null && backupTime.isAfter(existing.timestamp)) {
          await (_db.update(_db.messages)..where((t) => t.id.equals(id)))
              .write(Message.fromJson(json).toCompanion(true));
          updated++;
        } else {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<_ImportEntityResult> _importWorldInfos(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.worldInfos)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.worldInfos).insert(WorldInfo.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.worldInfos)..where((t) => t.id.equals(id)))
            .write(WorldInfo.fromJson(json).toCompanion(true));
        updated++;
      } else if (mode == ImportMode.merge) {
        final backupTime = DateTime.tryParse(json['modifiedAt'] as String? ?? '');
        if (backupTime != null && backupTime.isAfter(existing.modifiedAt)) {
          await (_db.update(_db.worldInfos)..where((t) => t.id.equals(id)))
              .write(WorldInfo.fromJson(json).toCompanion(true));
          updated++;
        } else {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<void> _importWorldInfoEntries(Map<String, dynamic> data, ImportMode mode) async {
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.worldInfoEntries)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.worldInfoEntries).insert(WorldInfoEntry.fromJson(json));
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.worldInfoEntries)..where((t) => t.id.equals(id)))
            .write(WorldInfoEntry.fromJson(json).toCompanion(true));
      }
    }
  }
  
  Future<_ImportEntityResult> _importTags(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.tags)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.tags).insert(Tag.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.tags)..where((t) => t.id.equals(id)))
            .write(Tag.fromJson(json).toCompanion(true));
        updated++;
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<void> _importCharacterTags(List<dynamic> data, ImportMode mode) async {
    for (final item in data) {
      final json = item as Map<String, dynamic>;
      final characterId = json['characterId'] as String;
      final tagId = json['tagId'] as String;
      
      final existing = await (_db.select(_db.characterTags)
        ..where((t) => t.characterId.equals(characterId) & t.tagId.equals(tagId)))
        .getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.characterTags).insert(
          CharacterTagsCompanion.insert(characterId: characterId, tagId: tagId),
        );
      }
    }
  }
  
  Future<_ImportEntityResult> _importGroups(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.groups)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.groups).insert(Group.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.groups)..where((t) => t.id.equals(id)))
            .write(Group.fromJson(json).toCompanion(true));
        updated++;
      } else if (mode == ImportMode.merge) {
        final backupTime = DateTime.tryParse(json['modifiedAt'] as String? ?? '');
        if (backupTime != null && backupTime.isAfter(existing.modifiedAt)) {
          await (_db.update(_db.groups)..where((t) => t.id.equals(id)))
              .write(Group.fromJson(json).toCompanion(true));
          updated++;
        } else {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<_ImportEntityResult> _importPersonas(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.personas)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.personas).insert(Persona.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.personas)..where((t) => t.id.equals(id)))
            .write(Persona.fromJson(json).toCompanion(true));
        updated++;
      } else if (mode == ImportMode.merge) {
        final backupTime = DateTime.tryParse(json['updatedAt'] as String? ?? '');
        if (backupTime != null && backupTime.isAfter(existing.updatedAt)) {
          await (_db.update(_db.personas)..where((t) => t.id.equals(id)))
              .write(Persona.fromJson(json).toCompanion(true));
          updated++;
        } else {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<_ImportEntityResult> _importLlmConfigs(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.llmConfigs)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.llmConfigs).insert(LlmConfig.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.llmConfigs)..where((t) => t.id.equals(id)))
            .write(LlmConfig.fromJson(json).toCompanion(true));
        updated++;
      } else if (mode == ImportMode.merge) {
        final backupTime = DateTime.tryParse(json['modifiedAt'] as String? ?? '');
        if (backupTime != null && backupTime.isAfter(existing.modifiedAt)) {
          await (_db.update(_db.llmConfigs)..where((t) => t.id.equals(id)))
              .write(LlmConfig.fromJson(json).toCompanion(true));
          updated++;
        } else {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
  
  Future<_ImportEntityResult> _importBookmarks(Map<String, dynamic> data, ImportMode mode) async {
    int added = 0, updated = 0, skipped = 0;
    
    for (final entry in data.entries) {
      final json = entry.value as Map<String, dynamic>;
      final id = json['id'] as String;
      
      final existing = await (_db.select(_db.bookmarks)..where((t) => t.id.equals(id))).getSingleOrNull();
      
      if (existing == null) {
        await _db.into(_db.bookmarks).insert(Bookmark.fromJson(json));
        added++;
      } else if (mode == ImportMode.replace) {
        await (_db.update(_db.bookmarks)..where((t) => t.id.equals(id)))
            .write(Bookmark.fromJson(json).toCompanion(true));
        updated++;
      } else {
        skipped++;
      }
    }
    
    return _ImportEntityResult(added: added, updated: updated, skipped: skipped);
  }
}

/// Import mode
enum ImportMode {
  /// Replace all existing data with backup data
  replace,
  /// Merge backup data with existing data (newer wins)
  merge,
  /// Only add new items, skip existing
  addNewOnly,
}

/// Result of importing a single entity type
class _ImportEntityResult {
  final int added;
  final int updated;
  final int skipped;
  
  _ImportEntityResult({
    required this.added,
    required this.updated,
    required this.skipped,
  });
}

/// Result of a full import operation
class ImportResult {
  int charactersAdded = 0;
  int charactersUpdated = 0;
  int charactersSkipped = 0;
  
  int chatsAdded = 0;
  int chatsUpdated = 0;
  int chatsSkipped = 0;
  
  int messagesAdded = 0;
  int messagesUpdated = 0;
  int messagesSkipped = 0;
  
  int worldInfosAdded = 0;
  int worldInfosUpdated = 0;
  int worldInfosSkipped = 0;
  
  int groupsAdded = 0;
  int groupsUpdated = 0;
  int groupsSkipped = 0;
  
  int personasAdded = 0;
  int personasUpdated = 0;
  int personasSkipped = 0;
  
  int llmConfigsAdded = 0;
  int llmConfigsUpdated = 0;
  int llmConfigsSkipped = 0;
  
  int tagsAdded = 0;
  int tagsUpdated = 0;
  int tagsSkipped = 0;
  
  int bookmarksAdded = 0;
  int bookmarksUpdated = 0;
  int bookmarksSkipped = 0;
  
  int get totalAdded => charactersAdded + chatsAdded + messagesAdded + 
      worldInfosAdded + groupsAdded + personasAdded + llmConfigsAdded + 
      tagsAdded + bookmarksAdded;
      
  int get totalUpdated => charactersUpdated + chatsUpdated + messagesUpdated + 
      worldInfosUpdated + groupsUpdated + personasUpdated + llmConfigsUpdated + 
      tagsUpdated + bookmarksUpdated;
      
  int get totalSkipped => charactersSkipped + chatsSkipped + messagesSkipped + 
      worldInfosSkipped + groupsSkipped + personasSkipped + llmConfigsSkipped + 
      tagsSkipped + bookmarksSkipped;
  
  @override
  String toString() {
    return 'ImportResult(added: $totalAdded, updated: $totalUpdated, skipped: $totalSkipped)';
  }
}
