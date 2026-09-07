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

  test('exportWrapKey returns the configured wrapping key', () async {
    final wrapKey = Uint8List.fromList(List<int>.generate(32, (i) => i + 1));
    final vault = SecretVaultService(wrapKeyLoader: () async => wrapKey);
    expect(await vault.exportWrapKey(), wrapKey);
  });
}

String jsonish(Map<String, dynamic> value) => value.toString();
