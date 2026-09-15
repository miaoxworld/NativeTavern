import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('applying a connection profile restores the API key', () async {
    const initial = LLMConfig(
      provider: LLMProvider.openai,
      model: 'gpt-test',
      apiKey: 'openai-key',
      apiUrl: 'https://api.openai.com/v1',
    );
    SharedPreferences.setMockInitialValues({
      'llm_config': jsonEncode(initial.toJson()),
    });
    final prefs = await SharedPreferences.getInstance();
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(container.dispose);

    final config = container.read(llmConfigProvider.notifier);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(container.read(llmConfigProvider).apiKey, 'openai-key');

    await container
        .read(connectionProfilesProvider.notifier)
        .saveCurrent('openai');
    final profileId = container.read(connectionProfilesProvider).single.id;

    await config.updateProvider(LLMProvider.openRouter);
    config.updateApiKey('router-key');
    await config.flushPersistence();
    expect(container.read(llmConfigProvider).apiKey, 'router-key');

    await container.read(connectionProfilesProvider.notifier).apply(profileId);
    await config.flushPersistence();

    expect(container.read(llmConfigProvider).apiKey, 'openai-key');

    final reloaded = LLMConfigNotifier(prefs, database);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(reloaded.state.apiKey, 'openai-key');
  });

  test('applying a profile saved without a key must not wipe the key',
      () async {
    const initial = LLMConfig(
      provider: LLMProvider.openai,
      model: 'gpt-test',
      apiKey: '',
      apiUrl: 'https://api.openai.com/v1',
    );
    SharedPreferences.setMockInitialValues({
      'llm_config': jsonEncode(initial.toJson()),
    });
    final prefs = await SharedPreferences.getInstance();
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(container.dispose);

    final config = container.read(llmConfigProvider.notifier);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    // A profile created before the key was entered (or by an older build).
    await container
        .read(connectionProfilesProvider.notifier)
        .saveCurrent('stale');
    final profileId = container.read(connectionProfilesProvider).single.id;
    expect(container.read(llmConfigProvider).apiKey, isEmpty);

    config.updateApiKey('good-key');
    await config.flushPersistence();

    await container.read(connectionProfilesProvider.notifier).apply(profileId);
    await config.flushPersistence();

    expect(container.read(llmConfigProvider).apiKey, 'good-key');

    final reloaded = LLMConfigNotifier(prefs, database);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(reloaded.state.apiKey, 'good-key');
  });
}
