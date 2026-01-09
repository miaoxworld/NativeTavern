import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart' hide Character;
import 'package:native_tavern/data/database/database.dart' as db;
import 'package:native_tavern/data/models/character.dart' as models;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Provider for character repository
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Repository for managing character data
class CharacterRepository {
  final AppDatabase _db;
  final String _dataPath;
  static const _uuid = Uuid();

  CharacterRepository(this._db, this._dataPath);

  /// Get all characters
  Future<List<models.Character>> getAllCharacters() async {
    final rows = await _db.select(_db.characters).get();
    return rows.map(_characterFromRow).toList();
  }

  /// Get character by ID
  Future<models.Character?> getCharacter(String id) async {
    final row = await (_db.select(_db.characters)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _characterFromRow(row) : null;
  }

  /// Search characters by name
  Future<List<models.Character>> searchCharacters(String query) async {
    final rows = await (_db.select(_db.characters)
          ..where((t) => t.name.like('%$query%')))
        .get();
    return rows.map(_characterFromRow).toList();
  }

  /// Get characters by tags
  Future<List<models.Character>> getCharactersByTag(String tag) async {
    final rows = await _db.select(_db.characters).get();
    return rows
        .map(_characterFromRow)
        .where((c) => c.tags.contains(tag))
        .toList();
  }

  /// Get favorite characters
  Future<List<models.Character>> getFavoriteCharacters() async {
    final rows = await (_db.select(_db.characters)
          ..where((t) => t.isFavorite.equals(true)))
        .get();
    return rows.map(_characterFromRow).toList();
  }

  /// Toggle character favorite status
  Future<models.Character> toggleFavorite(String characterId) async {
    final character = await getCharacter(characterId);
    if (character == null) {
      throw Exception('Character not found');
    }
    
    final updatedCharacter = character.copyWith(
      isFavorite: !character.isFavorite,
      modifiedAt: DateTime.now(),
    );
    
    await (_db.update(_db.characters)
          ..where((t) => t.id.equals(characterId)))
        .write(_characterToCompanion(updatedCharacter));
    
    return updatedCharacter;
  }

  /// Set character favorite status
  Future<models.Character> setFavorite(String characterId, bool isFavorite) async {
    final character = await getCharacter(characterId);
    if (character == null) {
      throw Exception('Character not found');
    }
    
    final updatedCharacter = character.copyWith(
      isFavorite: isFavorite,
      modifiedAt: DateTime.now(),
    );
    
    await (_db.update(_db.characters)
          ..where((t) => t.id.equals(characterId)))
        .write(_characterToCompanion(updatedCharacter));
    
    return updatedCharacter;
  }

  /// Create a new character
  Future<models.Character> createCharacter(models.Character character) async {
    final id = character.id.isEmpty ? _uuid.v4() : character.id;
    final now = DateTime.now();
    
    final newCharacter = character.copyWith(
      id: id,
      createdAt: now,
      modifiedAt: now,
    );

    await _db.into(_db.characters).insert(_characterToCompanion(newCharacter));
    return newCharacter;
  }

  /// Update an existing character
  Future<models.Character> updateCharacter(models.Character character) async {
    final updatedCharacter = character.copyWith(modifiedAt: DateTime.now());
    
    await (_db.update(_db.characters)
          ..where((t) => t.id.equals(character.id)))
        .write(_characterToCompanion(updatedCharacter));
    
    return updatedCharacter;
  }

  /// Delete a character
  Future<void> deleteCharacter(String id) async {
    // Delete associated chats first
    await (_db.delete(_db.chats)..where((t) => t.characterId.equals(id))).go();
    
    // Delete the character
    await (_db.delete(_db.characters)..where((t) => t.id.equals(id))).go();
    
    // Delete avatar file if exists
    await _deleteCharacterAvatar(id);
  }

  /// Save character avatar
  Future<String> saveAvatar(String characterId, Uint8List imageData) async {
    final avatarDir = Directory(p.join(_dataPath, 'avatars'));
    if (!await avatarDir.exists()) {
      await avatarDir.create(recursive: true);
    }
    
    final avatarPath = p.join(avatarDir.path, '$characterId.png');
    await File(avatarPath).writeAsBytes(imageData);
    
    // Update character with avatar path
    await (_db.update(_db.characters)
          ..where((t) => t.id.equals(characterId)))
        .write(CharactersCompanion(avatarPath: Value(avatarPath)));
    
    return avatarPath;
  }

  /// Get character count
  Future<int> getCharacterCount() async {
    final count = await _db.select(_db.characters).get();
    return count.length;
  }

  /// Import character from JSON data
  Future<models.Character> importFromJson(Map<String, dynamic> json) async {
    // Parse character card (V2 or V3 format)
    String name = '';
    String description = '';
    String personality = '';
    String scenario = '';
    String firstMessage = '';
    String exampleMessages = '';
    String systemPrompt = '';
    String postHistoryInstructions = '';
    String creatorNotes = '';
    List<String> tags = [];
    String creator = '';
    String version = '';
    Map<String, dynamic> extensions = {};

    // Check for V3 format
    if (json.containsKey('spec') && json.containsKey('data')) {
      final data = json['data'] as Map<String, dynamic>? ?? {};
      name = data['name'] as String? ?? '';
      description = data['description'] as String? ?? '';
      personality = data['personality'] as String? ?? '';
      scenario = data['scenario'] as String? ?? '';
      firstMessage = data['first_mes'] as String? ?? '';
      exampleMessages = data['mes_example'] as String? ?? '';
      systemPrompt = data['system_prompt'] as String? ?? '';
      postHistoryInstructions = data['post_history_instructions'] as String? ?? '';
      creatorNotes = data['creator_notes'] as String? ?? '';
      tags = (data['tags'] as List<dynamic>?)?.cast<String>() ?? [];
      creator = data['creator'] as String? ?? '';
      version = data['character_version'] as String? ?? '';
      extensions = data['extensions'] as Map<String, dynamic>? ?? {};
    } 
    // Check for V2 format (has data field but no spec)
    else if (json.containsKey('data')) {
      final data = json['data'] as Map<String, dynamic>? ?? {};
      name = data['name'] as String? ?? json['name'] as String? ?? '';
      description = data['description'] as String? ?? '';
      personality = data['personality'] as String? ?? '';
      scenario = data['scenario'] as String? ?? '';
      firstMessage = data['first_mes'] as String? ?? '';
      exampleMessages = data['mes_example'] as String? ?? '';
      systemPrompt = data['system_prompt'] as String? ?? '';
      postHistoryInstructions = data['post_history_instructions'] as String? ?? '';
      creatorNotes = data['creator_notes'] as String? ?? '';
      tags = (data['tags'] as List<dynamic>?)?.cast<String>() ?? [];
      creator = data['creator'] as String? ?? '';
      version = data['character_version'] as String? ?? '';
      extensions = data['extensions'] as Map<String, dynamic>? ?? {};
    }
    // V1 format (flat structure)
    else {
      name = json['name'] as String? ?? json['char_name'] as String? ?? '';
      description = json['description'] as String? ?? json['char_persona'] as String? ?? '';
      personality = json['personality'] as String? ?? '';
      scenario = json['scenario'] as String? ?? json['world_scenario'] as String? ?? '';
      firstMessage = json['first_mes'] as String? ?? json['char_greeting'] as String? ?? '';
      exampleMessages = json['mes_example'] as String? ?? json['example_dialogue'] as String? ?? '';
    }
    
    final character = models.Character(
      id: _uuid.v4(),
      name: name,
      description: description,
      personality: personality,
      scenario: scenario,
      firstMessage: firstMessage,
      exampleMessages: exampleMessages,
      systemPrompt: systemPrompt,
      postHistoryInstructions: postHistoryInstructions,
      creatorNotes: creatorNotes,
      tags: tags,
      creator: creator,
      version: version,
      extensions: extensions,
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    );
    
    return createCharacter(character);
  }

  /// Export character to JSON (V3 format)
  Map<String, dynamic> exportToJson(models.Character character) {
    return {
      'spec': 'chara_card_v3',
      'spec_version': '3.0',
      'data': {
        'name': character.name,
        'description': character.description,
        'personality': character.personality,
        'scenario': character.scenario,
        'first_mes': character.firstMessage,
        'mes_example': character.exampleMessages,
        'system_prompt': character.systemPrompt,
        'post_history_instructions': character.postHistoryInstructions,
        'creator_notes': character.creatorNotes,
        'tags': character.tags,
        'creator': character.creator,
        'character_version': character.version,
        'extensions': character.extensions,
      },
    };
  }

  // Private helpers
  
  models.Character _characterFromRow(db.Character row) {
    return models.Character(
      id: row.id,
      name: row.name,
      description: row.description,
      personality: row.personality,
      scenario: row.scenario,
      firstMessage: row.firstMessage,
      alternateGreetings: _parseJsonList(row.alternateGreetings),
      exampleMessages: row.exampleDialogue,
      systemPrompt: row.systemPrompt,
      postHistoryInstructions: row.postHistoryInstructions,
      creatorNotes: row.creatorNotes,
      tags: _parseJsonList(row.tags),
      creator: row.creator,
      version: row.characterVersion,
      assets: row.avatarPath != null
          ? models.CharacterAssets(avatarPath: row.avatarPath)
          : null,
      characterBook: _parseCharacterBook(row.characterBookJson),
      extensions: _parseJsonMap(row.extensionsJson),
      isFavorite: row.isFavorite,
      createdAt: row.createdAt,
      modifiedAt: row.modifiedAt,
    );
  }

  CharactersCompanion _characterToCompanion(models.Character character) {
    return CharactersCompanion(
      id: Value(character.id),
      name: Value(character.name),
      description: Value(character.description),
      personality: Value(character.personality),
      scenario: Value(character.scenario),
      firstMessage: Value(character.firstMessage),
      alternateGreetings: Value(jsonEncode(character.alternateGreetings)),
      exampleDialogue: Value(character.exampleMessages),
      systemPrompt: Value(character.systemPrompt),
      postHistoryInstructions: Value(character.postHistoryInstructions),
      creatorNotes: Value(character.creatorNotes),
      tags: Value(jsonEncode(character.tags)),
      creator: Value(character.creator),
      characterVersion: Value(character.version),
      avatarPath: Value(character.assets?.avatarPath),
      characterBookJson: Value(_serializeCharacterBook(character.characterBook)),
      extensionsJson: Value(jsonEncode(character.extensions)),
      isFavorite: Value(character.isFavorite),
      createdAt: Value(character.createdAt),
      modifiedAt: Value(character.modifiedAt),
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

  Map<String, dynamic> _parseJsonMap(String json) {
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  models.CharacterBook? _parseCharacterBook(String json) {
    if (json.isEmpty) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return models.CharacterBook.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  String _serializeCharacterBook(models.CharacterBook? book) {
    if (book == null) return '';
    return jsonEncode(book.toJson());
  }

  Future<void> _deleteCharacterAvatar(String characterId) async {
    try {
      final avatarPath = p.join(_dataPath, 'avatars', '$characterId.png');
      final file = File(avatarPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Failed to delete avatar: $e');
    }
  }
}