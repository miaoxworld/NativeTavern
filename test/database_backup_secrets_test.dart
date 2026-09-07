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
}
