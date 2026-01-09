import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart' hide Persona;
import 'package:native_tavern/data/models/persona.dart';

/// Repository for managing personas
class PersonaRepository {
  final AppDatabase _db;

  PersonaRepository(this._db);

  /// Get all personas
  Future<List<Persona>> getAllPersonas() async {
    final rows = await _db.customSelect(
      'SELECT * FROM personas ORDER BY is_default DESC, name ASC',
    ).get();

    return rows.map((row) => _rowToPersona(row.data)).toList();
  }

  /// Get a persona by ID
  Future<Persona?> getPersona(String id) async {
    final rows = await _db.customSelect(
      'SELECT * FROM personas WHERE id = ?',
      variables: [Variable.withString(id)],
    ).get();

    if (rows.isEmpty) return null;
    return _rowToPersona(rows.first.data);
  }

  /// Get the default persona
  Future<Persona?> getDefaultPersona() async {
    final rows = await _db.customSelect(
      'SELECT * FROM personas WHERE is_default = 1 LIMIT 1',
    ).get();

    if (rows.isEmpty) return null;
    return _rowToPersona(rows.first.data);
  }

  /// Create a new persona
  Future<void> createPersona(Persona persona) async {
    await _db.customInsert(
      '''
      INSERT INTO personas (id, name, description, avatar_path, is_default, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
      variables: [
        Variable.withString(persona.id),
        Variable.withString(persona.name),
        Variable.withString(persona.description),
        persona.avatarPath != null
            ? Variable.withString(persona.avatarPath!)
            : const Variable(null),
        Variable.withBool(persona.isDefault),
        Variable.withDateTime(persona.createdAt),
        Variable.withDateTime(persona.updatedAt),
      ],
    );
  }

  /// Update a persona
  Future<void> updatePersona(Persona persona) async {
    await _db.customUpdate(
      '''
      UPDATE personas
      SET name = ?, description = ?, avatar_path = ?, is_default = ?, updated_at = ?
      WHERE id = ?
      ''',
      variables: [
        Variable.withString(persona.name),
        Variable.withString(persona.description),
        persona.avatarPath != null
            ? Variable.withString(persona.avatarPath!)
            : const Variable(null),
        Variable.withBool(persona.isDefault),
        Variable.withDateTime(persona.updatedAt),
        Variable.withString(persona.id),
      ],
      updates: {},
    );
  }

  /// Delete a persona
  Future<void> deletePersona(String id) async {
    await _db.customStatement(
      'DELETE FROM personas WHERE id = ?',
      [id],
    );
  }

  /// Set a persona as default (and unset others)
  Future<void> setDefaultPersona(String id) async {
    await _db.transaction(() async {
      // Unset all defaults
      await _db.customUpdate(
        'UPDATE personas SET is_default = 0',
        updates: {},
      );
      // Set the new default
      await _db.customUpdate(
        'UPDATE personas SET is_default = 1 WHERE id = ?',
        variables: [Variable.withString(id)],
        updates: {},
      );
    });
  }

  /// Ensure default persona exists
  Future<void> ensureDefaultPersonaExists() async {
    final defaultPersona = await getDefaultPersona();
    if (defaultPersona == null) {
      await createPersona(createDefaultPersona());
    }
  }

  Persona _rowToPersona(Map<String, dynamic> row) {
    return Persona(
      id: row['id'] as String,
      name: row['name'] as String,
      description: row['description'] as String? ?? '',
      avatarPath: row['avatar_path'] as String?,
      isDefault: (row['is_default'] as int) == 1,
      createdAt: _parseDateTime(row['created_at']),
      updatedAt: _parseDateTime(row['updated_at']),
    );
  }

  /// Parse DateTime from database value (can be int or String)
  DateTime _parseDateTime(dynamic value) {
    if (value is int) {
      // Unix timestamp in seconds
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      return DateTime.now();
    }
  }
}

/// Provider for persona repository
final personaRepositoryProvider = Provider<PersonaRepository>((ref) {
  final db = DatabaseProvider.instance;
  return PersonaRepository(db);
});