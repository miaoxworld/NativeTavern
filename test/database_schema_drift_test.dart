import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart';

import 'support/database_migration_harness.dart';

void main() {
  late MigrationTestHarness harness;

  setUp(() {
    harness = MigrationTestHarness.create();
  });

  tearDown(() async {
    await harness.dispose();
  });

  group('Database Schema Drift & Integrity Test Suite', () {
    test('Fresh database schema matches Drift model definitions exactly',
        () async {
      final db = harness.createCurrentDatabase();

      // 1. Check user version
      final userVersion = await readSchemaVersion(db);
      expect(userVersion, db.schemaVersion);

      // 2. Run SQLite Pragmas for corruption and integrity
      expect(await runIntegrityCheck(db), 'ok');
      final quickCheck = await db.customSelect('PRAGMA quick_check').get();
      expect(quickCheck.first.data.values.first, 'ok');

      final fkViolations = await findForeignKeyViolations(db);
      expect(fkViolations, isEmpty,
          reason: 'Zero foreign key violations in fresh database');

      // 3. Inspect PRAGMA table_info against all registered Drift tables
      final driftTables = db.allTables.toList();
      final tableNamesInDb = await readTableNames(db);

      for (final table in driftTables) {
        expect(tableNamesInDb, contains(table.actualTableName),
            reason: 'Table ${table.actualTableName} must exist in SQLite');

        final tableInfo = await db
            .customSelect('PRAGMA table_info("${table.actualTableName}")')
            .get();
        final columnsInDb = {
          for (final row in tableInfo) row.read<String>('name'): row.data,
        };

        for (final column in table.$columns) {
          expect(columnsInDb.containsKey(column.$name), isTrue,
              reason:
                  'Column ${column.$name} in table ${table.actualTableName} must exist');
        }
      }
    });

    test('Migrated legacy v10 database has identical schema to fresh database',
        () async {
      final freshDb = harness.createCurrentDatabase();
      final freshTables = await readTableNames(freshDb);

      final v10File = harness.createFixture(LegacyDatabaseFixtures.v10);
      final migratedDb = harness.openWithProductionMigrations(v10File);

      expect(await readSchemaVersion(migratedDb), migratedDb.schemaVersion);
      expect(await runIntegrityCheck(migratedDb), 'ok');
      expect(await findForeignKeyViolations(migratedDb), isEmpty);

      final migratedTables = await readTableNames(migratedDb);
      for (final tableName in freshTables) {
        expect(migratedTables, contains(tableName),
            reason: 'Migrated database must contain table $tableName');

        final freshColumns =
            await freshDb.customSelect('PRAGMA table_info("$tableName")').get();
        final migratedColumns = await migratedDb
            .customSelect('PRAGMA table_info("$tableName")')
            .get();

        final freshColNames =
            freshColumns.map((c) => c.read<String>('name')).toSet();
        final migratedColNames =
            migratedColumns.map((c) => c.read<String>('name')).toSet();

        expect(migratedColNames, containsAll(freshColNames),
            reason: 'Migrated $tableName columns must match fresh schema');
      }
    });

    test('Foreign key constraints and cascade relations maintain zero drift',
        () async {
      final db = harness.createCurrentDatabase();

      // Insert character
      const charId = 'test-character-fk';
      await db.into(db.characters).insert(
            CharactersCompanion.insert(
              id: charId,
              name: 'Test Character',
              createdAt: DateTime.now(),
              modifiedAt: DateTime.now(),
            ),
          );

      // Insert chat attached to character
      const chatId = 'test-chat-fk';
      await db.into(db.chats).insert(
            ChatsCompanion.insert(
              id: chatId,
              characterId: charId,
              title: const Value('Test Chat'),
              authorNote: const Value(''),
              authorNoteDepth: const Value(4),
              authorNoteEnabled: const Value(false),
              settingsJson: const Value('{}'),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

      // Insert message attached to chat
      await db.into(db.messages).insert(
            MessagesCompanion.insert(
              id: 'test-message-fk',
              chatId: chatId,
              role: 'user',
              content: 'Hello there',
              timestamp: DateTime.now(),
              swipes: const Value('["Hello there"]'),
              currentSwipeIndex: const Value(0),
              metadataJson: const Value('{}'),
            ),
          );

      expect(await findForeignKeyViolations(db), isEmpty);
      expect(await runIntegrityCheck(db), 'ok');

      // Delete chat and verify messages cleanup
      await (db.delete(db.messages)..where((t) => t.chatId.equals(chatId)))
          .go();
      await (db.delete(db.chats)..where((t) => t.id.equals(chatId))).go();

      final remainingMessages = await (db.select(db.messages)
            ..where((t) => t.chatId.equals(chatId)))
          .get();
      expect(remainingMessages, isEmpty);
      expect(await findForeignKeyViolations(db), isEmpty);
    });
  });
}
