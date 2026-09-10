import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/secret_vault_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sealed vault round-trips secrets without exposing plaintext', () async {
    SharedPreferences.setMockInitialValues({});
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final vault = SecretVaultService(wrapKeyLoader: () async => wrapKey);
    final sealed = await vault.sealBundle({
      'llmConfigs': {'config': 'sk-live-secret'},
    });

    expect(sealed['alg'], 'A256GCM');
    expect(jsonish(sealed), isNot(contains('sk-live-secret')));

    final opened = await vault.unseal(sealed, wrapKey: wrapKey);
    expect(opened, isNotNull);
    expect((opened!['llmConfigs'] as Map)['config'], 'sk-live-secret');
  });

  test('wrong wrapping key cannot read the vault', () async {
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final otherKey = Uint8List.fromList(List<int>.generate(32, (i) => 32 - i));
    final vault = SecretVaultService(wrapKeyLoader: () async => wrapKey);
    final sealed = await vault.sealBundle({
      'llmConfigs': {'config': 'sk-live-secret'},
    });

    expect(await vault.unseal(sealed, wrapKey: otherKey), isNull);
  });

  test(
      'collects connection snapshots even when the preference key is llm_config',
      () async {
    SharedPreferences.setMockInitialValues({
      'llm_config': jsonEncode({
        'provider': 'xai',
        'model': 'grok-4',
        'apiKey': 'xai-live-secret',
        'apiUrl': 'https://api.x.ai/v1',
      }),
      'llm_provider_config_openai': jsonEncode({
        'apiKey': 'sk-live-secret',
        'apiUrl': 'https://api.openai.com/v1',
        'model': 'gpt-4o',
      }),
      'locale': 'en',
    });
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final vault = SecretVaultService(wrapKeyLoader: () async => wrapKey);
    final bundle = await vault.collectSecrets();
    final preferences = bundle['preferences'] as Map;
    expect(preferences['llm_config'], contains('xai-live-secret'));
    expect(
      preferences['llm_provider_config_openai'],
      contains('sk-live-secret'),
    );
    expect(preferences.containsKey('locale'), isFalse);
  });

  test('unseal returns null when this device has no wrapping key yet',
      () async {
    SharedPreferences.setMockInitialValues({});
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final sealed = await SecretVaultService(
      wrapKeyLoader: () async => wrapKey,
    ).sealBundle({
      'preferences': {'llm_config': '{"apiKey":"xai-live-secret"}'},
    });
    final opened = await SecretVaultService(
      wrapKeyLoader: () async => null,
    ).unseal(sealed);
    expect(opened, isNull);
  });

  test('applyBundle never wipes a local key with an empty remote value',
      () async {
    SharedPreferences.setMockInitialValues({
      'llm_config': '{"apiKey":"local-secret"}',
    });
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final vault = SecretVaultService(wrapKeyLoader: () async => wrapKey);
    final result = await vault.applyBundle({
      'preferences': {'llm_config': ''},
    });
    expect(result.conflicts, isEmpty);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('llm_config'), '{"apiKey":"local-secret"}');
  });

  test(
      'applyBundle keeps the local key and reports a conflict when both differ',
      () async {
    SharedPreferences.setMockInitialValues({
      'llm_config': '{"apiKey":"local-secret"}',
    });
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final vault = SecretVaultService(wrapKeyLoader: () async => wrapKey);
    final result = await vault.applyBundle({
      'preferences': {'llm_config': '{"apiKey":"remote-secret"}'},
    });
    expect(result.conflicts, hasLength(1));
    expect(result.conflicts.single.localValue, contains('local-secret'));
    expect(result.conflicts.single.remoteValue, contains('remote-secret'));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('llm_config'), '{"apiKey":"local-secret"}');

    await vault.applyChosenRemoteKeys(result.conflicts);
    expect(prefs.getString('llm_config'), '{"apiKey":"remote-secret"}');
  });

  test('exportWrapKey returns the configured wrapping key', () async {
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final vault = SecretVaultService(wrapKeyLoader: () async => wrapKey);
    expect(await vault.exportWrapKey(), wrapKey);
  });
}

String jsonish(Map<String, dynamic> value) => value.toString();
