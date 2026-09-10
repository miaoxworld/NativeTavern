import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/domain/repositories/mcp_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Encrypts API keys and tokens for cross-device cloud sync.
///
/// Plaintext credentials never enter `.ntx` JSON. The wrapping key lives in
/// iCloud Keychain on Apple devices and in this app's private Google Drive
/// App Data on Android so a second signed-in device can decrypt the vault.
class SecretVaultService {
  static const vaultPackageKey = 'ntxVault';
  static const _wrapKeyStorageKey = 'native_tavern.icloud.vault.wrap.v1';
  static const _algorithmName = 'A256GCM';

  SecretVaultService({
    AppDatabase? database,
    FlutterSecureStorage? storage,
    McpCredentialRepository? mcpCredentials,
    Future<Uint8List?> Function()? wrapKeyLoader,
  })  : _database = database,
        _storage = storage ??
            const FlutterSecureStorage(
              iOptions: IOSOptions(
                synchronizable: true,
                accessibility: KeychainAccessibility.first_unlock,
              ),
              mOptions: MacOsOptions(
                synchronizable: true,
                accessibility: KeychainAccessibility.first_unlock,
              ),
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            ),
        _mcpCredentials = mcpCredentials,
        _wrapKeyLoader = wrapKeyLoader;

  final AppDatabase? _database;
  final FlutterSecureStorage _storage;
  final McpCredentialRepository? _mcpCredentials;
  final Future<Uint8List?> Function()? _wrapKeyLoader;
  final AesGcm _aes = AesGcm.with256bits();

  static const llmConfigPreferenceKey = 'llm_config';
  static const llmProviderConfigPrefix = 'llm_provider_config_';

  static bool isConnectionSecretKey(String key) {
    return key == llmConfigPreferenceKey ||
        key.startsWith(llmProviderConfigPrefix);
  }

  static bool isSensitivePreferenceKey(String key) {
    if (isConnectionSecretKey(key)) return true;
    final normalized = key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    const needles = [
      'apikey',
      'accesstoken',
      'refreshtoken',
      'authtoken',
      'authorization',
      'bearer',
      'sessionid',
      'oauth',
      'password',
      'secret',
      'credential',
      'privatekey',
      'cookie',
    ];
    return needles.any(normalized.contains);
  }

  static bool encodedValueContainsSecret(String value) {
    final trimmed = value.trimLeft();
    if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) {
      return false;
    }
    try {
      return _jsonContainsSecret(jsonDecode(value));
    } catch (_) {
      return false;
    }
  }

  static bool _jsonContainsSecret(Object? value) {
    if (value is Map) {
      for (final entry in value.entries) {
        if (isSensitivePreferenceKey(entry.key.toString()) &&
            entry.value is String &&
            (entry.value as String).trim().isNotEmpty) {
          return true;
        }
        if (_jsonContainsSecret(entry.value)) return true;
      }
    } else if (value is List) {
      return value.any(_jsonContainsSecret);
    }
    return false;
  }

  Future<Map<String, dynamic>?> sealCurrentSecrets() async {
    final bundle = await collectSecrets();
    if (bundle.isEmpty) return null;
    return sealBundle(bundle);
  }

  Future<Map<String, dynamic>> collectSecrets() async {
    final llmKeys = <String, String>{};
    final globalStates = <String, String>{};
    final database = _database;
    if (database != null) {
      final configs = await database.select(database.llmConfigs).get();
      for (final config in configs) {
        final key = config.apiKey?.trim();
        if (key != null && key.isNotEmpty) {
          llmKeys[config.id] = key;
        }
      }
      final states = await database.select(database.globalStates).get();
      for (final state in states) {
        if (!_shouldCollectSecretValue(state.key, state.value)) continue;
        globalStates[state.key] = state.value;
      }
    }

    final preferences = <String, String>{};
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys()) {
      final value = prefs.get(key);
      if (value is! String || value.trim().isEmpty) continue;
      if (!_shouldCollectSecretValue(key, value)) continue;
      preferences[key] = value;
    }

    final mcpTokens = <String, String>{};
    try {
      final stored = await _storage.readAll();
      stored.forEach((key, value) {
        if (key.startsWith('native_tavern.mcp.') && value.trim().isNotEmpty) {
          mcpTokens[key] = value;
        }
      });
    } catch (_) {
      // Plugin storage is unavailable in unit tests.
    }

    return {
      if (llmKeys.isNotEmpty) 'llmConfigs': llmKeys,
      if (preferences.isNotEmpty) 'preferences': preferences,
      if (globalStates.isNotEmpty) 'globalStates': globalStates,
      if (mcpTokens.isNotEmpty) 'mcpTokens': mcpTokens,
    };
  }

  bool _shouldCollectSecretValue(String key, String value) {
    return isSensitivePreferenceKey(key) || encodedValueContainsSecret(value);
  }

  Future<Map<String, dynamic>> sealBundle(Map<String, dynamic> bundle) async {
    final wrapKey = await _loadOrCreateWrapKey();
    final secretKey = await _aes.newSecretKeyFromBytes(wrapKey);
    final clear = utf8.encode(jsonEncode(bundle));
    final box = await _aes.encrypt(clear, secretKey: secretKey);
    return {
      'alg': _algorithmName,
      'n': base64Encode(box.nonce),
      'c': base64Encode(box.cipherText),
      't': base64Encode(box.mac.bytes),
    };
  }

  Future<Map<String, dynamic>?> unseal(
    Object? vault, {
    Uint8List? wrapKey,
  }) async {
    if (vault is! Map) return null;
    final nonce = vault['n'];
    final cipher = vault['c'];
    final mac = vault['t'];
    if (nonce is! String || cipher is! String || mac is! String) return null;
    try {
      final keyBytes = wrapKey ?? await loadWrapKey();
      if (keyBytes == null) return null;
      final secretKey = await _aes.newSecretKeyFromBytes(keyBytes);
      final clear = await _aes.decrypt(
        SecretBox(
          base64Decode(cipher),
          nonce: base64Decode(nonce),
          mac: Mac(base64Decode(mac)),
        ),
        secretKey: secretKey,
      );
      final decoded = jsonDecode(utf8.decode(clear));
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<void> applyVault(Object? vault) async {
    final bundle = await unseal(vault);
    if (bundle == null) return;
    await applyBundle(bundle);
  }

  Future<void> applyBundle(Map<String, dynamic> bundle) async {
    final database = _database;
    final llmKeys = bundle['llmConfigs'];
    if (database != null && llmKeys is Map) {
      for (final entry in llmKeys.entries) {
        final id = entry.key.toString();
        final apiKey = entry.value?.toString();
        if (apiKey == null || apiKey.isEmpty) continue;
        await (database.update(database.llmConfigs)
              ..where((table) => table.id.equals(id)))
            .write(LlmConfigsCompanion(apiKey: Value(apiKey)));
      }
    }

    final preferences = bundle['preferences'];
    if (preferences is Map) {
      final prefs = await SharedPreferences.getInstance();
      for (final entry in preferences.entries) {
        final value = entry.value;
        if (value is String) {
          await prefs.setString(entry.key.toString(), value);
        }
      }
    }

    final globalStates = bundle['globalStates'];
    if (database != null && globalStates is Map) {
      for (final entry in globalStates.entries) {
        final value = entry.value?.toString();
        if (value == null || value.isEmpty) continue;
        await database.into(database.globalStates).insert(
              GlobalStatesCompanion.insert(
                key: entry.key.toString(),
                value: value,
                updatedAt: DateTime.now(),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    }

    final mcpTokens = bundle['mcpTokens'];
    if (mcpTokens is Map) {
      for (final entry in mcpTokens.entries) {
        final value = entry.value?.toString();
        if (value == null || value.isEmpty) continue;
        await _storage.write(key: entry.key.toString(), value: value);
      }
    }

    final mcpRepo = _mcpCredentials;
    if (mcpRepo != null && mcpTokens is Map) {
      for (final entry in mcpTokens.entries) {
        final key = entry.key.toString();
        final value = entry.value?.toString() ?? '';
        const prefix = 'native_tavern.mcp.';
        const suffix = '.token';
        if (!key.startsWith(prefix) || !key.endsWith(suffix)) continue;
        final serverId =
            key.substring(prefix.length, key.length - suffix.length);
        await mcpRepo.writeToken(serverId, value);
      }
    }
  }

  /// Returns the wrapping key, creating one if this device has never synced.
  Future<Uint8List> exportWrapKey() => _loadOrCreateWrapKey();

  /// Existing wrapping key, or null when this device has never sealed a vault.
  Future<Uint8List?> loadWrapKey() async {
    final loader = _wrapKeyLoader;
    if (loader != null) return loader();
    try {
      final existing = await _storage.read(key: _wrapKeyStorageKey);
      if (existing != null && existing.isNotEmpty) {
        return Uint8List.fromList(base64Decode(existing));
      }
    } catch (_) {
      // Plugin storage is unavailable in unit tests.
    }
    return null;
  }

  /// Adopts a wrapping key from another device on the same cloud account.
  Future<void> importWrapKey(Uint8List bytes) async {
    if (bytes.length != 32) {
      throw ArgumentError.value(bytes.length, 'bytes.length', 'Expected 32');
    }
    await _storage.write(
      key: _wrapKeyStorageKey,
      value: base64Encode(bytes),
    );
  }

  Future<Uint8List> _loadOrCreateWrapKey() async {
    final existing = await loadWrapKey();
    if (existing != null) return existing;
    final generated = await _aes.newSecretKey();
    final bytes = Uint8List.fromList(await generated.extractBytes());
    await _storage.write(
      key: _wrapKeyStorageKey,
      value: base64Encode(bytes),
    );
    return bytes;
  }
}
