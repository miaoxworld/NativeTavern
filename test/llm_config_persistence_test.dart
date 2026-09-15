import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('API keys survive rapid settings writes and provider switching',
      () async {
    const initial = LLMConfig(
      provider: LLMProvider.openai,
      model: 'gpt-test',
      apiKey: 'old-key',
      apiUrl: 'https://example.com/v1',
    );
    SharedPreferences.setMockInitialValues({
      'llm_config': jsonEncode(initial.toJson()),
    });
    final prefs = await SharedPreferences.getInstance();
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final notifier = LLMConfigNotifier(prefs, database);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    notifier.updateApiKey('new-key');
    for (var index = 0; index < 20; index++) {
      notifier.updateTemperature(0.5 + index / 100);
    }
    await notifier.flushPersistence();

    expect(notifier.state.apiKey, 'new-key');
    final activeRow = await (database.select(database.globalStates)
          ..where((row) => row.key.equals('llm_config')))
        .getSingle();
    expect(
      (jsonDecode(activeRow.value) as Map<String, dynamic>)['apiKey'],
      'new-key',
    );
    final providerRow = await (database.select(database.globalStates)
          ..where((row) => row.key.equals('llm_provider_config_openai')))
        .getSingle();
    expect(
      (jsonDecode(providerRow.value) as Map<String, dynamic>)['apiKey'],
      'new-key',
    );

    await notifier.updateProvider(LLMProvider.openRouter);
    notifier.updateApiKey('router-key');
    await notifier.flushPersistence();
    await notifier.updateProvider(LLMProvider.openai);
    expect(notifier.state.apiKey, 'new-key');
    await notifier.updateProvider(LLMProvider.openRouter);
    expect(notifier.state.apiKey, 'router-key');
  });

  test('parameter send toggles persist and reload', () async {
    const initial = LLMConfig(
      provider: LLMProvider.openai,
      model: 'gpt-test',
      apiKey: 'key',
      apiUrl: 'https://example.com/v1',
    );
    SharedPreferences.setMockInitialValues({
      'llm_config': jsonEncode(initial.toJson()),
    });
    final prefs = await SharedPreferences.getInstance();
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final notifier = LLMConfigNotifier(prefs, database);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    notifier.updateParameterEnabled(SamplerParameters.presencePenalty, false);
    await notifier.flushPersistence();

    final row = await (database.select(database.globalStates)
          ..where((r) => r.key.equals('llm_config')))
        .getSingle();
    final decoded = jsonDecode(row.value) as Map<String, dynamic>;
    expect(decoded['disabledParameters'], contains('presence_penalty'));

    final restored = LLMConfig.fromJson(decoded);
    expect(restored.sendsParameter(SamplerParameters.presencePenalty), isFalse);
    expect(restored.sendsParameter(SamplerParameters.temperature), isTrue);

    notifier.updateParameterEnabled(SamplerParameters.presencePenalty, true);
    await notifier.flushPersistence();
    expect(
      notifier.state.sendsParameter(SamplerParameters.presencePenalty),
      isTrue,
    );
  });
}
