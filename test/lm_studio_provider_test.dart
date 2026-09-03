import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/tool_calling/tool_generation_loop.dart';
import 'package:native_tavern/l10n/generated/app_localizations_en.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LM Studio is a local OpenAI-compatible provider', () {
    expect(LLMProvider.lmStudio.isLocalServer, isTrue);
    expect(LLMProvider.lmStudio.usesOpenAiChatCompletions, isTrue);
    expect(LLMProvider.ollama.isLocalServer, isTrue);
    expect(LLMProvider.ollama.usesOpenAiChatCompletions, isFalse);
    expect(
      ToolGenerationLoop.adapterForProvider(LLMProvider.lmStudio),
      isNotNull,
    );
  });

  test('LM Studio uses the local server URL and does not require an API key',
      () async {
    SharedPreferences.setMockInitialValues({});
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final prefs = await SharedPreferences.getInstance();
    final notifier = LLMConfigNotifier(prefs, db);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await notifier.updateProvider(LLMProvider.lmStudio);

    expect(notifier.state.provider, LLMProvider.lmStudio);
    expect(notifier.state.apiUrl, 'http://localhost:1234/v1');
    expect(notifier.state.apiKey, isEmpty);
  });

  test('xAI API key hint uses the xai- prefix', () {
    final l10n = AppLocalizationsEn();
    expect(l10n.xaiApiKeyHint, 'xai-...');
    expect(l10n.apiKeyHint, 'sk-...');
  });
}
