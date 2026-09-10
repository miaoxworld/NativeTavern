import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
import 'package:native_tavern/domain/services/secret_vault_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('database backup excludes API keys and restore preserves local key',
      () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.utc(2026, 1, 1);
    await database.into(database.llmConfigs).insert(
          LlmConfigsCompanion.insert(
            id: 'config',
            name: 'Provider',
            provider: 'openai',
            endpoint: 'https://example.com',
            apiKey: const Value('device-secret'),
            createdAt: now,
            modifiedAt: now,
          ),
        );
    final service = DatabaseBackupService(database);

    final exported = await service.exportAllData();
    final config = (exported['llmConfigs'] as Map)['config'] as Map;
    expect(config['apiKey'], isNull);

    final restoredConfig = Map<String, dynamic>.from(config)
      ..['name'] = 'Restored Provider'
      ..['modifiedAt'] = now.add(const Duration(days: 1)).toIso8601String();
    await service.importData(
      data: {
        'llmConfigs': {'config': restoredConfig},
      },
      mode: ImportMode.replace,
    );
    final stored = await (database.select(database.llmConfigs)
          ..where((table) => table.id.equals('config')))
        .getSingle();
    expect(stored.apiKey, 'device-secret');
    expect(stored.name, 'Restored Provider');
  });

  test('encrypted vault restores API keys onto a second device copy', () async {
    SharedPreferences.setMockInitialValues({});
    final source = AppDatabase.forTesting(NativeDatabase.memory());
    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(source.close);
    addTearDown(target.close);
    final now = DateTime.utc(2026, 1, 1);
    await source.into(source.llmConfigs).insert(
          LlmConfigsCompanion.insert(
            id: 'config',
            name: 'Provider',
            provider: 'openai',
            endpoint: 'https://example.com',
            apiKey: const Value('synced-secret'),
            createdAt: now,
            modifiedAt: now,
          ),
        );
    await target.into(target.llmConfigs).insert(
          LlmConfigsCompanion.insert(
            id: 'config',
            name: 'Provider',
            provider: 'openai',
            endpoint: 'https://example.com',
            createdAt: now,
            modifiedAt: now,
          ),
        );

    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 3));
    final vault = SecretVaultService(
      database: source,
      wrapKeyLoader: () async => wrapKey,
    );
    final sealed = await vault.sealBundle({
      'llmConfigs': {'config': 'synced-secret'},
    });

    final exported = await DatabaseBackupService(source).exportAllData();
    expect((exported['llmConfigs'] as Map)['config']['apiKey'], isNull);

    await DatabaseBackupService(target).importData(
      data: exported,
      mode: ImportMode.merge,
    );
    await SecretVaultService(
      database: target,
      wrapKeyLoader: () async => wrapKey,
    ).applyVault(sealed);

    final stored = await (target.select(target.llmConfigs)
          ..where((table) => table.id.equals('config')))
        .getSingle();
    expect(stored.apiKey, 'synced-secret');
  });

  test('merge keeps a custom chat title when a later message updates the row',
      () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final older = DateTime.utc(2026, 9, 1, 12);
    final newer = DateTime.utc(2026, 9, 1, 13);
    await database.into(database.characters).insert(
          CharactersCompanion.insert(
            id: 'char',
            name: 'Alice',
            createdAt: older,
            modifiedAt: older,
          ),
        );
    await database.into(database.chats).insert(
          ChatsCompanion.insert(
            id: 'chat',
            characterId: 'char',
            createdAt: older,
            updatedAt: older,
            title: const Value('Harbor talk'),
            settingsJson: const Value('{"titleUpdatedAt":"2026-09-01T12:00:00Z"}'),
          ),
        );
    await DatabaseBackupService(database).importData(
      data: {
        'chats': {
          'chat': {
            'id': 'chat',
            'characterId': 'char',
            'title': 'Chat with Alice',
            'settingsJson': '{}',
            'authorNote': '',
            'authorNoteDepth': 4,
            'authorNoteEnabled': false,
            'createdAt': older.toIso8601String(),
            'updatedAt': newer.toIso8601String(),
          },
        },
        'messages': {
          'msg': {
            'id': 'msg',
            'chatId': 'chat',
            'role': 'user',
            'content': 'Hello from the other device',
            'timestamp': newer.toIso8601String(),
          },
        },
      },
      mode: ImportMode.merge,
    );
    final chat = await (database.select(database.chats)
          ..where((table) => table.id.equals('chat')))
        .getSingle();
    expect(chat.title, 'Harbor talk');
    final messages = await database.select(database.messages).get();
    expect(messages.single.content, 'Hello from the other device');
  });

  test('imports chats even when the character row is missing from the backup',
      () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.utc(2026, 9, 1);
    await DatabaseBackupService(database).importData(
      data: {
        'chats': {
          'chat': {
            'id': 'chat',
            'characterId': 'missing-char',
            'title': 'Orphaned session',
            'createdAt': now.toIso8601String(),
            'updatedAt': now.toIso8601String(),
          },
        },
        'messages': {
          'msg': {
            'id': 'msg',
            'chatId': 'chat',
            'role': 'assistant',
            'content': 'Still here',
            'timestamp': now.toIso8601String(),
          },
        },
      },
      mode: ImportMode.merge,
    );
    final chat = await (database.select(database.chats)
          ..where((table) => table.id.equals('chat')))
        .getSingle();
    expect(chat.title, 'Orphaned session');
    final messages = await database.select(database.messages).get();
    expect(messages.single.content, 'Still here');
  });

  test('vault restores llm_config keys into globalStates used by settings',
      () async {
    SharedPreferences.setMockInitialValues({});
    final source = AppDatabase.forTesting(NativeDatabase.memory());
    final target = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(source.close);
    addTearDown(target.close);
    final now = DateTime.utc(2026, 1, 1);
    await source.into(source.globalStates).insert(
          GlobalStatesCompanion.insert(
            key: 'llm_config',
            value: '{"provider":"xai","apiKey":"xai-live-secret","model":"grok"}',
            updatedAt: now,
          ),
        );
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 4));
    final sealed = await SecretVaultService(
      database: source,
      wrapKeyLoader: () async => wrapKey,
    ).sealCurrentSecrets();
    expect(sealed, isNotNull);

    await SecretVaultService(
      database: target,
      wrapKeyLoader: () async => wrapKey,
    ).applyVault(sealed);
    final stored = await (target.select(target.globalStates)
          ..where((table) => table.key.equals('llm_config')))
        .getSingle();
    expect(stored.value, contains('xai-live-secret'));
  });
}
