import 'package:drift/drift.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/data/models/tag.dart' as models;
import 'package:uuid/uuid.dart';

/// Repository for managing tags
class TagRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  TagRepository(this._db);

  /// Get all tags
  Future<List<models.Tag>> getAllTags() async {
    final rows = await _db.select(_db.tags).get();
    return rows.map<models.Tag>(_tagFromRow).toList();
  }

  /// Get a tag by ID
  Future<models.Tag?> getTagById(String id) async {
    final row = await (_db.select(_db.tags)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _tagFromRow(row) : null;
  }

  /// Get a tag by name
  Future<models.Tag?> getTagByName(String name) async {
    final row = await (_db.select(_db.tags)
          ..where((t) => t.name.equals(name)))
        .getSingleOrNull();
    return row != null ? _tagFromRow(row) : null;
  }

  /// Create a new tag
  Future<models.Tag> createTag({
    required String name,
    String? color,
    String? icon,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await _db.into(_db.tags).insert(TagsCompanion.insert(
          id: id,
          name: name,
          color: Value(color),
          icon: Value(icon),
          createdAt: now,
        ));

    return models.Tag(
      id: id,
      name: name,
      color: color,
      icon: icon,
      createdAt: now,
    );
  }

  /// Update a tag
  Future<void> updateTag(models.Tag tag) async {
    await (_db.update(_db.tags)..where((t) => t.id.equals(tag.id))).write(
      TagsCompanion(
        name: Value(tag.name),
        color: Value(tag.color),
        icon: Value(tag.icon),
      ),
    );
  }

  /// Delete a tag
  Future<void> deleteTag(String tagId) async {
    // First remove all character-tag associations
    await (_db.delete(_db.characterTags)
          ..where((ct) => ct.tagId.equals(tagId)))
        .go();

    // Then delete the tag
    await (_db.delete(_db.tags)..where((t) => t.id.equals(tagId))).go();
  }

  /// Get tags for a character
  Future<List<models.Tag>> getTagsForCharacter(String characterId) async {
    final query = _db.select(_db.tags).join([
      innerJoin(
        _db.characterTags,
        _db.characterTags.tagId.equalsExp(_db.tags.id),
      ),
    ])
      ..where(_db.characterTags.characterId.equals(characterId));

    final rows = await query.get();
    return rows.map((row) => _tagFromRow(row.readTable(_db.tags))).toList();
  }

  /// Get characters for a tag
  Future<List<String>> getCharacterIdsForTag(String tagId) async {
    final rows = await (_db.select(_db.characterTags)
          ..where((ct) => ct.tagId.equals(tagId)))
        .get();
    return rows.map((row) => row.characterId).toList();
  }

  /// Add a tag to a character
  Future<void> addTagToCharacter(String characterId, String tagId) async {
    await _db.into(_db.characterTags).insertOnConflictUpdate(
          CharacterTagsCompanion.insert(
            characterId: characterId,
            tagId: tagId,
          ),
        );
  }

  /// Remove a tag from a character
  Future<void> removeTagFromCharacter(String characterId, String tagId) async {
    await (_db.delete(_db.characterTags)
          ..where((ct) =>
              ct.characterId.equals(characterId) & ct.tagId.equals(tagId)))
        .go();
  }

  /// Set tags for a character (replaces all existing tags)
  Future<void> setTagsForCharacter(
      String characterId, List<String> tagIds) async {
    await _db.transaction(() async {
      // Remove all existing tags
      await (_db.delete(_db.characterTags)
            ..where((ct) => ct.characterId.equals(characterId)))
          .go();

      // Add new tags
      for (final tagId in tagIds) {
        await _db.into(_db.characterTags).insert(
              CharacterTagsCompanion.insert(
                characterId: characterId,
                tagId: tagId,
              ),
            );
      }
    });
  }

  /// Get characters that have ALL of the specified tags
  Future<List<String>> getCharactersWithAllTags(List<String> tagIds) async {
    if (tagIds.isEmpty) return [];

    // Get all character-tag pairs for the specified tags
    final rows = await (_db.select(_db.characterTags)
          ..where((ct) => ct.tagId.isIn(tagIds)))
        .get();

    // Group by character and count
    final characterTagCounts = <String, int>{};
    for (final row in rows) {
      characterTagCounts[row.characterId] =
          (characterTagCounts[row.characterId] ?? 0) + 1;
    }

    // Return characters that have all tags
    return characterTagCounts.entries
        .where((e) => e.value == tagIds.length)
        .map((e) => e.key)
        .toList();
  }

  /// Get characters that have ANY of the specified tags
  Future<List<String>> getCharactersWithAnyTags(List<String> tagIds) async {
    if (tagIds.isEmpty) return [];

    final rows = await (_db.select(_db.characterTags)
          ..where((ct) => ct.tagId.isIn(tagIds)))
        .get();

    return rows.map((row) => row.characterId).toSet().toList();
  }

  /// Get tag usage count (number of characters using each tag)
  Future<Map<String, int>> getTagUsageCounts() async {
    final rows = await _db.select(_db.characterTags).get();
    final counts = <String, int>{};
    for (final row in rows) {
      counts[row.tagId] = (counts[row.tagId] ?? 0) + 1;
    }
    return counts;
  }

  /// Convert database row to Tag model
  models.Tag _tagFromRow(Tag row) {
    return models.Tag(
      id: row.id,
      name: row.name,
      color: row.color,
      icon: row.icon,
      createdAt: row.createdAt,
    );
  }
}