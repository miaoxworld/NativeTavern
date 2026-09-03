import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/chat_summarization_service.dart';
import 'package:native_tavern/domain/services/tokenizer_service.dart';
import 'package:drift/drift.dart' as drift;
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/core/services/initialization_service.dart';

/// Log a message to the console
void _log(String message, {String? error, StackTrace? stackTrace}) {
  final timestamp = DateTime.now().toIso8601String();
  final logMessage = '[$timestamp] SettingsProvider: $message';

  if (kDebugMode) {
    debugPrint(logMessage);
    if (error != null) {
      debugPrint('  Error: $error');
    }
  }

  developer.log(
    message,
    name: 'SettingsProvider',
    error: error,
    stackTrace: stackTrace,
  );
}

/// Shared preferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Provider for LLM service
final llmServiceProvider = Provider<LLMService>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

class LLMConfigNotifier extends StateNotifier<LLMConfig> {
  final SharedPreferences _prefs;
  final AppDatabase _db;
  static const _configKey = 'llm_config';
  static const _providerConfigKeyPrefix = 'llm_provider_config_';

  LLMConfigNotifier(this._prefs, this._db) : super(_defaultConfig()) {
    _loadConfig();
  }

  // All settings writes share one queue. Provider switches and preset applies
  // otherwise race and an older snapshot can overwrite a newer API key.
  Future<void> _writeQueue = Future<void>.value();
  bool _stateChangedBeforeLoad = false;

  static LLMConfig _defaultConfig() {
    return const LLMConfig(
      provider: LLMProvider.claude,
      model: 'claude-sonnet-4-5-20250929',
      apiKey: '',
      apiUrl: 'https://api.anthropic.com',
      maxTokens: 8192,
      temperature: 0.8,
      topP: 0.95,
      topK: 40,
      frequencyPenalty: 0.0,
      presencePenalty: 0.0,
      streamEnabled: true,
    );
  }

  /// Get default URL for a provider
  static String _getDefaultUrl(LLMProvider provider) {
    switch (provider) {
      case LLMProvider.openai:
        return 'https://api.openai.com/v1';
      case LLMProvider.claude:
        return 'https://api.anthropic.com';
      case LLMProvider.openRouter:
        return 'https://openrouter.ai/api/v1';
      case LLMProvider.gemini:
        return 'https://generativelanguage.googleapis.com/v1';
      case LLMProvider.ollama:
        return 'http://localhost:11434';
      case LLMProvider.lmStudio:
        return 'http://localhost:1234/v1';
      case LLMProvider.koboldCpp:
        return 'http://localhost:5001';
      case LLMProvider.deepSeek:
        return 'https://api.deepseek.com/v1';
      case LLMProvider.qwen:
        return 'https://dashscope.aliyuncs.com/compatible-mode/v1';
      case LLMProvider.siliconFlow:
        return 'https://api.siliconflow.cn/v1';
      case LLMProvider.moonshot:
        return 'https://api.moonshot.cn/v1';
      case LLMProvider.zai:
        return 'https://open.bigmodel.cn/api/paas/v4';
      case LLMProvider.miniMax:
        return 'https://api.minimaxi.com/v1';
      case LLMProvider.openAICompatible:
        return 'http://localhost:8080/v1';
      case LLMProvider.xai:
        return 'https://api.x.ai/v1';
    }
  }

  /// Get default model for a provider
  static String _getDefaultModel(LLMProvider provider) {
    switch (provider) {
      case LLMProvider.openai:
        return 'gpt-5.2';
      case LLMProvider.claude:
        return 'claude-sonnet-4-6';
      case LLMProvider.openRouter:
        return 'anthropic/claude-sonnet-4.5';
      case LLMProvider.gemini:
        return 'gemini-2.5-flash';
      case LLMProvider.ollama:
        return 'llama3.2';
      case LLMProvider.lmStudio:
        return '';
      case LLMProvider.koboldCpp:
        return '';
      case LLMProvider.deepSeek:
        return 'deepseek-chat';
      case LLMProvider.qwen:
        return 'qwen-plus';
      case LLMProvider.siliconFlow:
        return 'deepseek-ai/DeepSeek-V3';
      case LLMProvider.moonshot:
        return 'kimi-latest';
      case LLMProvider.zai:
        return 'glm-5';
      case LLMProvider.miniMax:
        return 'MiniMax-M2';
      case LLMProvider.openAICompatible:
        return '';
      case LLMProvider.xai:
        return '';
    }
  }

  static String _normalizeApiUrl(LLMProvider provider, String apiUrl) {
    var normalized = apiUrl.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    final suffixes = switch (provider) {
      LLMProvider.claude => const ['/v1/messages'],
      LLMProvider.gemini => const ['/models'],
      LLMProvider.ollama => const ['/api/tags'],
      LLMProvider.koboldCpp => const ['/api/v1/model'],
      LLMProvider.lmStudio => const ['/chat/completions', '/models'],
      _ => const ['/chat/completions', '/models'],
    };
    for (final suffix in suffixes) {
      if (normalized.endsWith(suffix)) {
        normalized = normalized.substring(0, normalized.length - suffix.length);
        break;
      }
    }
    return normalized;
  }

  /// Get the storage key for a provider's configuration
  String _getProviderConfigKey(LLMProvider provider) {
    return '$_providerConfigKeyPrefix${provider.name}';
  }

  /// Save the current provider's connection settings (apiKey, apiUrl, model)
  Future<void> _saveCurrentProviderConfig([LLMConfig? snapshot]) async {
    final config = snapshot ?? state;
    final key = _getProviderConfigKey(config.provider);
    final providerConfig = {
      'apiKey': config.apiKey,
      'apiUrl': config.apiUrl,
      'model': config.model,
    };
    final jsonStr = jsonEncode(providerConfig);

    // Save to DB
    await _db.into(_db.globalStates).insert(
          GlobalStatesCompanion(
            key: drift.Value(key),
            value: drift.Value(jsonStr),
            updatedAt: drift.Value(DateTime.now()),
          ),
          mode: drift.InsertMode.insertOrReplace,
        );

    // Keep syncing to prefs for backup safety until fully migrated (optional but good for now)
    await _prefs.setString(key, jsonStr);
    _log(
        'Saved config for provider ${config.provider.name}: apiUrl=${config.apiUrl}, model=${config.model}');
  }

  /// Load a provider's connection settings, or return defaults if none exist
  Future<Map<String, String>> _loadProviderConfig(LLMProvider provider) async {
    final key = _getProviderConfigKey(provider);

    // Try DB first
    final row = await (_db.select(_db.globalStates)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    String? jsonStr;

    if (row != null) {
      jsonStr = row.value;
    } else {
      // Fallback to prefs
      jsonStr = _prefs.getString(key);
    }

    if (jsonStr != null) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        _log(
            'Loaded saved config for provider ${provider.name}: apiUrl=${map['apiUrl']}, model=${map['model']}');
        return {
          'apiKey': map['apiKey'] as String? ?? '',
          'apiUrl': _normalizeApiUrl(
            provider,
            map['apiUrl'] as String? ?? _getDefaultUrl(provider),
          ),
          'model': map['model'] as String? ?? _getDefaultModel(provider),
        };
      } catch (e) {
        _log('Failed to load config for provider ${provider.name}: $e');
      }
    }

    // Return defaults if no saved config
    _log('Using default config for provider ${provider.name}');
    return {
      'apiKey': '',
      'apiUrl': _getDefaultUrl(provider),
      'model': _getDefaultModel(provider),
    };
  }

  Future<void> _loadConfig() async {
    // 1. Try DB
    final row = await (_db.select(_db.globalStates)
          ..where((t) => t.key.equals(_configKey)))
        .getSingleOrNull();

    String? jsonStr;
    bool needsMigration = false;

    if (row != null) {
      jsonStr = row.value;
    } else {
      // 2. Fallback to prefs (Migration)
      jsonStr = _prefs.getString(_configKey);
      if (jsonStr != null) {
        needsMigration = true;
      }
    }

    if (jsonStr != null) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        final loaded = LLMConfig.fromJson(map);
        if (!_stateChangedBeforeLoad) {
          state = loaded.copyWith(
            apiUrl: _normalizeApiUrl(loaded.provider, loaded.apiUrl),
          );
        }

        if (needsMigration) {
          _log('Migrating LLM config from SharedPreferences to Database');
          _enqueuePersistence(); // Save to DB
        }
      } catch (e) {
        // Use default config on error
      }
    }
  }

  Future<void> _saveConfig([LLMConfig? snapshot]) async {
    final jsonStr = jsonEncode((snapshot ?? state).toJson());

    // Save to DB
    await _db.into(_db.globalStates).insert(
          GlobalStatesCompanion(
            key: const drift.Value(_configKey),
            value: drift.Value(jsonStr),
            updatedAt: drift.Value(DateTime.now()),
          ),
          mode: drift.InsertMode.insertOrReplace,
        );

    // Sync to Prefs for redundancy/legacy
    await _prefs.setString(_configKey, jsonStr);
  }

  Future<void> _enqueuePersistence({bool providerConfig = false}) {
    _stateChangedBeforeLoad = true;
    final snapshot = state;
    return _enqueueWrite(() async {
      await _saveConfig(snapshot);
      if (providerConfig) await _saveCurrentProviderConfig(snapshot);
    });
  }

  Future<void> _enqueueWrite(Future<void> Function() operation) {
    final result = _writeQueue.then((_) => operation());
    // Keep later writes usable even if one persistence operation fails. The
    // returned future still reports the error to callers that await it.
    _writeQueue = result.catchError((Object error, StackTrace stackTrace) {
      _log(
        'LLM config persistence failed',
        error: '$error',
        stackTrace: stackTrace,
      );
    });
    return result;
  }

  Future<void> flushPersistence() => _writeQueue;

  Future<void> updateProvider(LLMProvider provider) {
    // Don't do anything if switching to the same provider
    if (provider == state.provider) {
      return Future<void>.value();
    }
    _stateChangedBeforeLoad = true;

    return _enqueueWrite(() async {
      // Save current provider's connection settings before switching.
      await _saveCurrentProviderConfig(state);

      // Load the new provider's saved settings (or defaults)
      final newProviderConfig = await _loadProviderConfig(provider);

      state = state.copyWith(
        provider: provider,
        apiKey: newProviderConfig['apiKey'],
        apiUrl: newProviderConfig['apiUrl'],
        model: newProviderConfig['model'],
      );
      await _saveConfig(state);
      await _saveCurrentProviderConfig(state);

      _log(
          'Switched to provider ${provider.name}: apiUrl=${state.apiUrl}, model=${state.model}');
    });
  }

  /// Force set provider and reload its config from DB.
  /// Unlike updateProvider, this does NOT skip if the provider is the same.
  /// Used when applying presets to ensure connection settings are refreshed.
  ///
  /// This is commonly called after restoreProviderConfigs has written the
  /// target provider snapshot; the active state is refreshed before both
  /// mirrors are persisted below.
  Future<void> forceSetProvider(LLMProvider provider) {
    _stateChangedBeforeLoad = true;
    return _enqueueWrite(() async {
      // Load the target provider's saved settings (freshly restored from preset)
      final newProviderConfig = await _loadProviderConfig(provider);

      final keepCurrentKey = provider == state.provider &&
          (newProviderConfig['apiKey']?.isEmpty ?? true) &&
          state.apiKey.trim().isNotEmpty;
      state = state.copyWith(
        provider: provider,
        apiKey: keepCurrentKey ? state.apiKey : newProviderConfig['apiKey'],
        apiUrl: newProviderConfig['apiUrl'],
        model: newProviderConfig['model'],
      );
      await _saveConfig(state);
      await _saveCurrentProviderConfig(state);

      _log(
          'Force set provider ${provider.name}: apiUrl=${state.apiUrl}, model=${state.model}, apiKey=${state.apiKey.isNotEmpty ? "***" : "(empty)"}');
    });
  }

  void updateApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey);
    _enqueuePersistence(providerConfig: true);
  }

  void updateApiUrl(String apiUrl) {
    final normalized = _normalizeApiUrl(state.provider, apiUrl);
    state = state.copyWith(apiUrl: normalized);
    _enqueuePersistence(providerConfig: true);
  }

  void updateModel(String model) {
    state = state.copyWith(
      model: model.trim(),
      openRouterProvider: state.provider == LLMProvider.openRouter
          ? ''
          : state.openRouterProvider,
    );
    _enqueuePersistence(providerConfig: true);
  }

  void updateOpenRouterProvider(String provider) {
    state = state.copyWith(openRouterProvider: provider);
    _enqueuePersistence();
  }

  void updateMaxTokens(int maxTokens) {
    state = state.copyWith(maxTokens: maxTokens);
    _enqueuePersistence();
  }

  void updateContextLength(int contextLength) {
    state = state.copyWith(contextLength: contextLength);
    _enqueuePersistence();
  }

  void updateTemperature(double temperature) {
    state = state.copyWith(temperature: temperature);
    _enqueuePersistence();
  }

  void updateTopP(double topP) {
    state = state.copyWith(topP: topP);
    _enqueuePersistence();
  }

  void updateTopK(int topK) {
    state = state.copyWith(topK: topK);
    _enqueuePersistence();
  }

  void updateFrequencyPenalty(double penalty) {
    state = state.copyWith(frequencyPenalty: penalty);
    _enqueuePersistence();
  }

  void updatePresencePenalty(double penalty) {
    state = state.copyWith(presencePenalty: penalty);
    _enqueuePersistence();
  }

  void updateStreamEnabled(bool enabled) {
    state = state.copyWith(streamEnabled: enabled);
    _enqueuePersistence();
  }

  void updateReasoningEffort(String effort) {
    state = state.copyWith(reasoningEffort: effort);
    _enqueuePersistence();
  }

  void updatePromptCacheEnabled(bool enabled) {
    state = state.copyWith(promptCacheEnabled: enabled);
    _enqueuePersistence();
  }

  void updateMergeConsecutiveRoles(bool enabled) {
    state = state.copyWith(mergeConsecutiveRoles: enabled);
    _enqueuePersistence();
  }

  /// Apply a full connection configuration (used by connection profiles)
  Future<void> applyConfig(LLMConfig config) async {
    _stateChangedBeforeLoad = true;
    await _enqueueWrite(() async {
      state = config;
      await _saveConfig(state);
      await _saveCurrentProviderConfig(state);
    });
  }

  // Advanced sampler methods
  void updateTypicalP(double value) {
    state = state.copyWith(typicalP: value);
    _enqueuePersistence();
  }

  void updateMinP(double value) {
    state = state.copyWith(minP: value);
    _enqueuePersistence();
  }

  void updateRepetitionPenalty(double value) {
    state = state.copyWith(repetitionPenalty: value);
    _enqueuePersistence();
  }

  void updateRepetitionPenaltyRange(int value) {
    state = state.copyWith(repetitionPenaltyRange: value);
    _enqueuePersistence();
  }

  void updateTailFreeSampling(double value) {
    state = state.copyWith(tailFreeSampling: value);
    _enqueuePersistence();
  }

  void updateTopA(double value) {
    state = state.copyWith(topA: value);
    _enqueuePersistence();
  }

  void updateMirostatMode(int mode) {
    state = state.copyWith(mirostatMode: mode);
    _enqueuePersistence();
  }

  void updateMirostatTau(double value) {
    state = state.copyWith(mirostatTau: value);
    _enqueuePersistence();
  }

  void updateMirostatEta(double value) {
    state = state.copyWith(mirostatEta: value);
    _enqueuePersistence();
  }

  void updateStopSequences(List<String> sequences) {
    state = state.copyWith(stopSequences: sequences);
    _enqueuePersistence();
  }

  void updateSeed(int seed) {
    state = state.copyWith(seed: seed);
    _enqueuePersistence();
  }

  void updateAutoSummarizeEnabled(bool enabled) {
    state = state.copyWith(autoSummarizeEnabled: enabled);
    _enqueuePersistence();
  }

  void updateAutoSummarizeThreshold(double threshold) {
    state = state.copyWith(autoSummarizeThreshold: threshold);
    _enqueuePersistence();
  }

  void resetToDefaults() {
    state = _defaultConfig();
    _enqueuePersistence(providerConfig: true);
  }

  /// Get configuration for all providers
  Future<Map<String, Map<String, dynamic>>> getAllProviderConfigs() async {
    late final Map<String, Map<String, dynamic>> result;
    await _enqueueWrite(() async {
      // Ensure current config is saved first
      await _saveCurrentProviderConfig();

      result = <String, Map<String, dynamic>>{};
      for (final provider in LLMProvider.values) {
        // _loadProviderConfig returns {apiKey, apiUrl, model}
        final config = await _loadProviderConfig(provider);
        // Ensure we store concrete values, not nulls
        result[provider.name] = {
          'apiKey': config['apiKey'],
          'apiUrl': config['apiUrl'],
          'model': config['model'],
        };
      }
    });
    return result;
  }

  /// Restore configuration for all providers (writes to DB/prefs only).
  /// The caller is responsible for refreshing the active provider state
  /// (e.g., via forceSetProvider).
  Future<void> restoreProviderConfigs(
      Map<String, Map<String, dynamic>> configs) {
    return _enqueueWrite(() async {
      for (final entry in configs.entries) {
        try {
          final providerName = entry.key;
          final config = entry.value;

          // Find the provider enum
          final provider = LLMProvider.values.firstWhere(
              (p) => p.name == providerName,
              orElse: () => LLMProvider.openai // Fallback
              );

          if (provider.name != providerName) {
            continue; // Skip if name didn't match exactly
          }

          final key = _getProviderConfigKey(provider);
          final current = await _loadProviderConfig(provider);
          final restored = <String, dynamic>{...config};
          // Presets/backups intentionally omit secrets. Never turn an omitted
          // key into an empty key when applying one of those snapshots.
          if (!restored.containsKey('apiKey') || restored['apiKey'] == null) {
            restored['apiKey'] = current['apiKey'] ?? '';
          }
          final jsonStr = jsonEncode(restored);

          // Save to DB
          await _db.into(_db.globalStates).insert(
                GlobalStatesCompanion(
                  key: drift.Value(key),
                  value: drift.Value(jsonStr),
                  updatedAt: drift.Value(DateTime.now()),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );

          // Sync to Prefs
          await _prefs.setString(key, jsonStr);
          _log('Restored config for provider ${provider.name}');
        } catch (e) {
          _log('Failed to restore config for ${entry.key}: $e');
        }
      }
    });
  }
}

final llmConfigProvider =
    StateNotifierProvider<LLMConfigNotifier, LLMConfig>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final db = ref.watch(databaseProvider);
  return LLMConfigNotifier(prefs, db);
});

/// A named connection profile: a full snapshot of the LLM connection
/// (provider, endpoint, key, model, sampling settings) that can be
/// applied with one tap. Mirrors SillyTavern's Connection Profiles.
class ConnectionProfile {
  final String id;
  final String name;
  final LLMConfig config;
  final DateTime createdAt;

  const ConnectionProfile({
    required this.id,
    required this.name,
    required this.config,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'config': config.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory ConnectionProfile.fromJson(Map<String, dynamic> json) =>
      ConnectionProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        config: LLMConfig.fromJson(json['config'] as Map<String, dynamic>),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

class ConnectionProfilesNotifier
    extends StateNotifier<List<ConnectionProfile>> {
  static const _storageKey = 'connection_profiles';
  final SharedPreferences _prefs;
  final Ref _ref;

  ConnectionProfilesNotifier(this._prefs, this._ref) : super(const []) {
    _load();
  }

  void _load() {
    final jsonStr = _prefs.getString(_storageKey);
    if (jsonStr == null) return;
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      state = list
          .map((e) => ConnectionProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _log('Failed to load connection profiles: $e');
    }
  }

  Future<void> _save() async {
    await _prefs.setString(
      _storageKey,
      jsonEncode(state.map((p) => p.toJson()).toList()),
    );
  }

  /// Save the current connection settings under a name
  Future<ConnectionProfile> saveCurrent(String name) async {
    final config = _ref.read(llmConfigProvider);
    final profile = ConnectionProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      config: config,
      createdAt: DateTime.now(),
    );
    state = [...state, profile];
    await _save();
    return profile;
  }

  /// Apply a profile's configuration
  Future<void> apply(String id) async {
    final profile = state.where((p) => p.id == id).firstOrNull;
    if (profile == null) return;
    await _ref.read(llmConfigProvider.notifier).applyConfig(profile.config);
  }

  Future<void> remove(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _save();
  }

  Future<void> rename(String id, String newName) async {
    state = [
      for (final p in state)
        if (p.id == id)
          ConnectionProfile(
            id: p.id,
            name: newName,
            config: p.config,
            createdAt: p.createdAt,
          )
        else
          p,
    ];
    await _save();
  }
}

final connectionProfilesProvider =
    StateNotifierProvider<ConnectionProfilesNotifier, List<ConnectionProfile>>(
        (ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ConnectionProfilesNotifier(prefs, ref);
});

/// App settings state
class AppSettings {
  static const memoryContextTokenBudgets = [256, 512, 1024, 2048];

  final String theme;
  final String language;
  final bool enableNotifications;
  final bool enableHaptics;
  final String defaultCharacterSortOrder;
  final bool confirmBeforeDelete;
  final bool autoSaveChats;
  final bool enableDebugLog;
  final bool useCharacterAvatarAsBackground;
  final bool enableBackgroundBlur;
  final double backgroundOpacity;
  final String chatLayoutMode;
  final bool memoryAutoExtractionEnabled;
  final bool memoryContextEnabled;
  final bool memorySemanticSearchEnabled;
  final int memoryContextTokenBudget;
  final bool storyEnabled;
  final int storyTurnsPerChapter;
  final double storyHighConfidenceThreshold;
  final bool momentsEnabled;

  const AppSettings({
    this.theme = 'dark',
    this.language = 'en',
    this.enableNotifications = true,
    this.enableHaptics = true,
    this.defaultCharacterSortOrder = 'name',
    this.confirmBeforeDelete = true,
    this.autoSaveChats = true,
    this.enableDebugLog = false,
    this.useCharacterAvatarAsBackground = true,
    this.enableBackgroundBlur = false,
    this.backgroundOpacity = 1.0,
    this.chatLayoutMode = 'bubble',
    this.memoryAutoExtractionEnabled = false,
    this.memoryContextEnabled = true,
    this.memorySemanticSearchEnabled = false,
    this.memoryContextTokenBudget = 512,
    this.storyEnabled = false,
    this.storyTurnsPerChapter = 20,
    this.storyHighConfidenceThreshold = 0.8,
    this.momentsEnabled = false,
  });

  AppSettings copyWith({
    String? theme,
    String? language,
    bool? enableNotifications,
    bool? enableHaptics,
    String? defaultCharacterSortOrder,
    bool? confirmBeforeDelete,
    bool? autoSaveChats,
    bool? enableDebugLog,
    bool? useCharacterAvatarAsBackground,
    bool? enableBackgroundBlur,
    double? backgroundOpacity,
    String? chatLayoutMode,
    bool? memoryAutoExtractionEnabled,
    bool? memoryContextEnabled,
    bool? memorySemanticSearchEnabled,
    int? memoryContextTokenBudget,
    bool? storyEnabled,
    int? storyTurnsPerChapter,
    double? storyHighConfidenceThreshold,
    bool? momentsEnabled,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      defaultCharacterSortOrder:
          defaultCharacterSortOrder ?? this.defaultCharacterSortOrder,
      confirmBeforeDelete: confirmBeforeDelete ?? this.confirmBeforeDelete,
      autoSaveChats: autoSaveChats ?? this.autoSaveChats,
      enableDebugLog: enableDebugLog ?? this.enableDebugLog,
      useCharacterAvatarAsBackground:
          useCharacterAvatarAsBackground ?? this.useCharacterAvatarAsBackground,
      enableBackgroundBlur: enableBackgroundBlur ?? this.enableBackgroundBlur,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      chatLayoutMode: chatLayoutMode ?? this.chatLayoutMode,
      memoryAutoExtractionEnabled:
          memoryAutoExtractionEnabled ?? this.memoryAutoExtractionEnabled,
      memoryContextEnabled: memoryContextEnabled ?? this.memoryContextEnabled,
      memorySemanticSearchEnabled:
          memorySemanticSearchEnabled ?? this.memorySemanticSearchEnabled,
      memoryContextTokenBudget:
          memoryContextTokenBudget ?? this.memoryContextTokenBudget,
      storyEnabled: storyEnabled ?? this.storyEnabled,
      storyTurnsPerChapter: storyTurnsPerChapter ?? this.storyTurnsPerChapter,
      storyHighConfidenceThreshold:
          storyHighConfidenceThreshold ?? this.storyHighConfidenceThreshold,
      momentsEnabled: momentsEnabled ?? this.momentsEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'language': language,
        'enableNotifications': enableNotifications,
        'enableHaptics': enableHaptics,
        'defaultCharacterSortOrder': defaultCharacterSortOrder,
        'confirmBeforeDelete': confirmBeforeDelete,
        'autoSaveChats': autoSaveChats,
        'enableDebugLog': enableDebugLog,
        'useCharacterAvatarAsBackground': useCharacterAvatarAsBackground,
        'enableBackgroundBlur': enableBackgroundBlur,
        'backgroundOpacity': backgroundOpacity,
        'chatLayoutMode': chatLayoutMode,
        'memoryAutoExtractionEnabled': memoryAutoExtractionEnabled,
        'memoryContextEnabled': memoryContextEnabled,
        'memorySemanticSearchEnabled': memorySemanticSearchEnabled,
        'memoryContextTokenBudget': memoryContextTokenBudget,
        'storyEnabled': storyEnabled,
        'storyTurnsPerChapter': storyTurnsPerChapter,
        'storyHighConfidenceThreshold': storyHighConfidenceThreshold,
        'momentsEnabled': momentsEnabled,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      theme: json['theme'] as String? ?? 'dark',
      language: json['language'] as String? ?? 'en',
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableHaptics: json['enableHaptics'] as bool? ?? true,
      defaultCharacterSortOrder:
          json['defaultCharacterSortOrder'] as String? ?? 'name',
      confirmBeforeDelete: json['confirmBeforeDelete'] as bool? ?? true,
      autoSaveChats: json['autoSaveChats'] as bool? ?? true,
      enableDebugLog: json['enableDebugLog'] as bool? ?? false,
      useCharacterAvatarAsBackground:
          json['useCharacterAvatarAsBackground'] as bool? ?? true,
      enableBackgroundBlur: json['enableBackgroundBlur'] as bool? ?? false,
      backgroundOpacity: (json['backgroundOpacity'] as num?)?.toDouble() ?? 1.0,
      chatLayoutMode: json['chatLayoutMode'] as String? ?? 'bubble',
      memoryAutoExtractionEnabled:
          json['memoryAutoExtractionEnabled'] as bool? ?? false,
      memoryContextEnabled: json['memoryContextEnabled'] as bool? ?? true,
      memorySemanticSearchEnabled:
          json['memorySemanticSearchEnabled'] as bool? ?? false,
      memoryContextTokenBudget: normalizeMemoryContextTokenBudget(
        (json['memoryContextTokenBudget'] as num?)?.toInt(),
      ),
      storyEnabled: json['storyEnabled'] as bool? ?? false,
      storyTurnsPerChapter: normalizeStoryTurnsPerChapter(
        (json['storyTurnsPerChapter'] as num?)?.toInt(),
      ),
      storyHighConfidenceThreshold: normalizeStoryHighConfidenceThreshold(
        (json['storyHighConfidenceThreshold'] as num?)?.toDouble(),
      ),
      momentsEnabled: json['momentsEnabled'] as bool? ?? false,
    );
  }

  static int normalizeMemoryContextTokenBudget(int? value) {
    return memoryContextTokenBudgets.contains(value) ? value! : 512;
  }

  static int normalizeStoryTurnsPerChapter(int? value) {
    if (value == null || value < 5 || value > 80) return 20;
    return value;
  }

  static double normalizeStoryHighConfidenceThreshold(double? value) {
    if (value == null || !value.isFinite) return 0.8;
    return value.clamp(0.5, 1.0).toDouble();
  }
}

/// App settings notifier
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;
  final AppDatabase _db;
  static const _settingsKey = 'app_settings';

  AppSettingsNotifier(this._prefs, this._db) : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // 1. Try DB
    final row = await (_db.select(_db.globalStates)
          ..where((t) => t.key.equals(_settingsKey)))
        .getSingleOrNull();

    String? jsonStr;
    bool needsMigration = false;

    if (row != null) {
      jsonStr = row.value;
    } else {
      // 2. Fallback to prefs
      jsonStr = _prefs.getString(_settingsKey);
      if (jsonStr != null) {
        needsMigration = true;
      }
    }

    if (jsonStr != null) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = AppSettings.fromJson(map);

        if (needsMigration) {
          _log('Migrating App Settings from SharedPreferences to Database');
          _saveSettings();
        }
      } catch (e) {
        // Use default settings on error
      }
    }
  }

  Future<void> _saveSettings() async {
    final jsonStr = jsonEncode(state.toJson());

    // Save to DB
    await _db.into(_db.globalStates).insert(
          GlobalStatesCompanion(
            key: const drift.Value(_settingsKey),
            value: drift.Value(jsonStr),
            updatedAt: drift.Value(DateTime.now()),
          ),
          mode: drift.InsertMode.insertOrReplace,
        );

    // Sync to Prefs
    await _prefs.setString(_settingsKey, jsonStr);
  }

  void updateTheme(String theme) {
    state = state.copyWith(theme: theme);
    _saveSettings();
  }

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
    _saveSettings();
  }

  void updateNotifications(bool enabled) {
    state = state.copyWith(enableNotifications: enabled);
    _saveSettings();
  }

  void updateHaptics(bool enabled) {
    state = state.copyWith(enableHaptics: enabled);
    _saveSettings();
  }

  void updateCharacterSortOrder(String order) {
    state = state.copyWith(defaultCharacterSortOrder: order);
    _saveSettings();
  }

  void updateConfirmBeforeDelete(bool confirm) {
    state = state.copyWith(confirmBeforeDelete: confirm);
    _saveSettings();
  }

  void updateAutoSaveChats(bool autoSave) {
    state = state.copyWith(autoSaveChats: autoSave);
    _saveSettings();
  }

  void updateDebugLog(bool enabled) {
    state = state.copyWith(enableDebugLog: enabled);
    _saveSettings();
  }

  void updateUseCharacterAvatarAsBackground(bool enabled) {
    state = state.copyWith(useCharacterAvatarAsBackground: enabled);
    _saveSettings();
  }

  void updateEnableBackgroundBlur(bool enabled) {
    state = state.copyWith(enableBackgroundBlur: enabled);
    _saveSettings();
  }

  void updateBackgroundOpacity(double opacity) {
    state = state.copyWith(backgroundOpacity: opacity.clamp(0.1, 1.0));
    _saveSettings();
  }

  void updateChatLayoutMode(String mode) {
    state = state.copyWith(chatLayoutMode: mode);
    _saveSettings();
  }

  void updateMemoryAutoExtraction(bool enabled) {
    state = state.copyWith(memoryAutoExtractionEnabled: enabled);
    _saveSettings();
  }

  void updateMemoryContext(bool enabled) {
    state = state.copyWith(memoryContextEnabled: enabled);
    _saveSettings();
  }

  void updateMemorySemanticSearch(bool enabled) {
    state = state.copyWith(memorySemanticSearchEnabled: enabled);
    _saveSettings();
  }

  void updateMemoryContextTokenBudget(int tokens) {
    state = state.copyWith(
      memoryContextTokenBudget:
          AppSettings.normalizeMemoryContextTokenBudget(tokens),
    );
    _saveSettings();
  }

  void updateStoryEnabled(bool enabled) {
    state = state.copyWith(storyEnabled: enabled);
    _saveSettings();
  }

  void updateStoryTurnsPerChapter(int turns) {
    state = state.copyWith(
      storyTurnsPerChapter: AppSettings.normalizeStoryTurnsPerChapter(turns),
    );
    _saveSettings();
  }

  void updateStoryHighConfidenceThreshold(double threshold) {
    state = state.copyWith(
      storyHighConfidenceThreshold:
          AppSettings.normalizeStoryHighConfidenceThreshold(threshold),
    );
    _saveSettings();
  }

  void updateMomentsEnabled(bool enabled) {
    state = state.copyWith(momentsEnabled: enabled);
    _saveSettings();
  }

  void resetToDefaults() {
    state = const AppSettings();
    _saveSettings();
  }
}

/// Provider for app settings
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final db = ref.watch(databaseProvider);
  return AppSettingsNotifier(prefs, db);
});

/// API connection test state
enum ConnectionStatus { idle, testing, success, error }

class ConnectionTestState {
  final ConnectionStatus status;
  final String? message;
  final List<String>? availableModels;

  const ConnectionTestState({
    this.status = ConnectionStatus.idle,
    this.message,
    this.availableModels,
  });

  ConnectionTestState copyWith({
    ConnectionStatus? status,
    String? message,
    List<String>? availableModels,
  }) {
    return ConnectionTestState(
      status: status ?? this.status,
      message: message,
      availableModels: availableModels ?? this.availableModels,
    );
  }
}

/// Connection test notifier
class ConnectionTestNotifier extends StateNotifier<ConnectionTestState> {
  final LLMService _llmService;

  ConnectionTestNotifier(this._llmService) : super(const ConnectionTestState());

  Future<void> testConnection(LLMConfig config) async {
    _log('Starting connection test for ${config.provider.name}');
    _log('API URL: ${config.apiUrl}');
    _log(
        'API Key: ${config.apiKey.isEmpty ? "(empty)" : "${config.apiKey.substring(0, 8)}..."}');
    _log('Model: ${config.model}');

    state = const ConnectionTestState(status: ConnectionStatus.testing);

    try {
      // testConnection now returns a success message or throws an exception
      _log('Calling LLMService.testConnection...');
      final successMessage = await _llmService.testConnection(config);
      _log('Connection test successful: $successMessage');

      // Try to get available models
      List<String>? models;
      try {
        _log('Fetching available models...');
        models = await _llmService.getAvailableModels(config);
        _log('Fetched ${models.length} models');
      } catch (e, stackTrace) {
        // Models fetching is optional, don't fail the test
        _log('Failed to fetch models: $e',
            error: e.toString(), stackTrace: stackTrace);
      }

      state = ConnectionTestState(
        status: ConnectionStatus.success,
        message: successMessage,
        availableModels: models,
      );
      _log('Connection test completed successfully');
    } catch (e, stackTrace) {
      // Extract the error message from the exception
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }

      _log('Connection test failed: $errorMessage',
          error: e.toString(), stackTrace: stackTrace);

      state = ConnectionTestState(
        status: ConnectionStatus.error,
        message: errorMessage,
      );
    }
  }

  void reset() {
    _log('Resetting connection test state');
    state = const ConnectionTestState();
  }
}

/// Provider for connection testing
final connectionTestProvider =
    StateNotifierProvider<ConnectionTestNotifier, ConnectionTestState>((ref) {
  final llmService = ref.watch(llmServiceProvider);
  return ConnectionTestNotifier(llmService);
});

/// Model fetching state
enum ModelFetchStatus { idle, loading, success, error }

class ModelFetchState {
  final ModelFetchStatus status;
  final List<String> models;
  final String? errorMessage;

  const ModelFetchState({
    this.status = ModelFetchStatus.idle,
    this.models = const [],
    this.errorMessage,
  });

  ModelFetchState copyWith({
    ModelFetchStatus? status,
    List<String>? models,
    String? errorMessage,
  }) {
    return ModelFetchState(
      status: status ?? this.status,
      models: models ?? this.models,
      errorMessage: errorMessage,
    );
  }
}

/// Model fetch notifier
class ModelFetchNotifier extends StateNotifier<ModelFetchState> {
  final LLMService _llmService;

  ModelFetchNotifier(this._llmService) : super(const ModelFetchState());

  Future<void> fetchModels(LLMConfig config) async {
    _log('Starting model fetch for ${config.provider.name}');
    _log('API URL: ${config.apiUrl}');

    state = const ModelFetchState(status: ModelFetchStatus.loading);

    try {
      _log('Calling LLMService.getAvailableModels...');
      final models = await _llmService.getAvailableModels(config);
      _log('Received ${models.length} models');

      if (models.isNotEmpty) {
        _log(
            'Models: ${models.take(10).join(", ")}${models.length > 10 ? "..." : ""}');
        state = ModelFetchState(
          status: ModelFetchStatus.success,
          models: models,
        );
        _log('Model fetch completed successfully');
      } else {
        // Provide helpful message based on provider
        String message;
        switch (config.provider) {
          case LLMProvider.openRouter:
          case LLMProvider.gemini:
          case LLMProvider.deepSeek:
          case LLMProvider.qwen:
          case LLMProvider.siliconFlow:
          case LLMProvider.moonshot:
          case LLMProvider.zai:
          case LLMProvider.miniMax:
          case LLMProvider.openAICompatible:
          case LLMProvider.openai:
          case LLMProvider.xai:
            message = 'No models found. Check your API key.';
            break;
          case LLMProvider.lmStudio:
            message =
                'No models found. Load a model in LM Studio and start the local server.';
            break;
          case LLMProvider.ollama:
            message =
                'No models found. Run "ollama pull <model>" to download models.';
            break;
          case LLMProvider.koboldCpp:
            message = 'No model loaded. Load a model in KoboldCpp first.';
            break;
          case LLMProvider.claude:
            message = 'Claude models are pre-defined. Select from the list.';
            break;
        }
        _log('No models found: $message');
        state = ModelFetchState(
          status: ModelFetchStatus.error,
          errorMessage: message,
        );
      }
    } catch (e, stackTrace) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      _log('Model fetch failed: $errorMessage',
          error: e.toString(), stackTrace: stackTrace);
      state = ModelFetchState(
        status: ModelFetchStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  void reset() {
    _log('Resetting model fetch state');
    state = const ModelFetchState();
  }
}

/// Provider for model fetching
final modelFetchProvider =
    StateNotifierProvider<ModelFetchNotifier, ModelFetchState>((ref) {
  final llmService = ref.watch(llmServiceProvider);
  return ModelFetchNotifier(llmService);
});

/// Provider for tokenizer service
final tokenizerServiceProvider = Provider<TokenizerService>((ref) {
  return TokenizerService();
});

/// Provider for chat summarization service
final chatSummarizationServiceProvider =
    Provider<ChatSummarizationService>((ref) {
  final llmService = ref.watch(llmServiceProvider);
  final tokenizerService = ref.watch(tokenizerServiceProvider);
  return ChatSummarizationService(llmService, tokenizerService);
});
