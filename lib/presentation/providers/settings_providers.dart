import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/domain/services/llm_service.dart';

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

/// LLM Config notifier
class LLMConfigNotifier extends StateNotifier<LLMConfig> {
  final SharedPreferences _prefs;
  static const _configKey = 'llm_config';

  LLMConfigNotifier(this._prefs) : super(_defaultConfig()) {
    _loadConfig();
  }

  static LLMConfig _defaultConfig() {
    return const LLMConfig(
      provider: LLMProvider.openai,
      model: 'gpt-4o',
      apiKey: '',
      apiUrl: 'https://api.openai.com/v1',
      maxTokens: 1000000,
      temperature: 0.8,
      topP: 0.95,
      topK: 40,
      frequencyPenalty: 0.0,
      presencePenalty: 0.0,
      streamEnabled: true,
    );
  }

  void _loadConfig() {
    final json = _prefs.getString(_configKey);
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        state = LLMConfig.fromJson(map);
      } catch (e) {
        // Use default config on error
      }
    }
  }

  Future<void> _saveConfig() async {
    await _prefs.setString(_configKey, jsonEncode(state.toJson()));
  }

  void updateProvider(LLMProvider provider) {
    // Set default URL and model for each provider
    String defaultUrl;
    String defaultModel;
    
    switch (provider) {
      case LLMProvider.openai:
        defaultUrl = 'https://api.openai.com/v1';
        defaultModel = 'gpt-4o';
        break;
      case LLMProvider.claude:
        defaultUrl = 'https://api.anthropic.com';
        defaultModel = 'claude-3-5-sonnet-20241022';
        break;
      case LLMProvider.openRouter:
        defaultUrl = 'https://openrouter.ai/api/v1';
        defaultModel = 'anthropic/claude-3.5-sonnet';
        break;
      case LLMProvider.gemini:
        defaultUrl = 'https://generativelanguage.googleapis.com/v1';
        defaultModel = 'gemini-1.5-pro';
        break;
      case LLMProvider.ollama:
        defaultUrl = 'http://localhost:11434';
        defaultModel = 'llama3.2';
        break;
      case LLMProvider.koboldCpp:
        defaultUrl = 'http://localhost:5001';
        defaultModel = '';
        break;
    }

    state = state.copyWith(
      provider: provider,
      apiUrl: defaultUrl,
      model: defaultModel,
    );
    _saveConfig();
  }

  void updateApiKey(String apiKey) {
    state = state.copyWith(apiKey: apiKey);
    _saveConfig();
  }

  void updateApiUrl(String apiUrl) {
    state = state.copyWith(apiUrl: apiUrl);
    _saveConfig();
  }

  void updateModel(String model) {
    state = state.copyWith(model: model);
    _saveConfig();
  }

  void updateMaxTokens(int maxTokens) {
    state = state.copyWith(maxTokens: maxTokens);
    _saveConfig();
  }

  void updateTemperature(double temperature) {
    state = state.copyWith(temperature: temperature);
    _saveConfig();
  }

  void updateTopP(double topP) {
    state = state.copyWith(topP: topP);
    _saveConfig();
  }

  void updateTopK(int topK) {
    state = state.copyWith(topK: topK);
    _saveConfig();
  }

  void updateFrequencyPenalty(double penalty) {
    state = state.copyWith(frequencyPenalty: penalty);
    _saveConfig();
  }

  void updatePresencePenalty(double penalty) {
    state = state.copyWith(presencePenalty: penalty);
    _saveConfig();
  }

  void updateStreamEnabled(bool enabled) {
    state = state.copyWith(streamEnabled: enabled);
    _saveConfig();
  }

  // Advanced sampler methods
  void updateTypicalP(double value) {
    state = state.copyWith(typicalP: value);
    _saveConfig();
  }

  void updateMinP(double value) {
    state = state.copyWith(minP: value);
    _saveConfig();
  }

  void updateRepetitionPenalty(double value) {
    state = state.copyWith(repetitionPenalty: value);
    _saveConfig();
  }

  void updateRepetitionPenaltyRange(int value) {
    state = state.copyWith(repetitionPenaltyRange: value);
    _saveConfig();
  }

  void updateTailFreeSampling(double value) {
    state = state.copyWith(tailFreeSampling: value);
    _saveConfig();
  }

  void updateTopA(double value) {
    state = state.copyWith(topA: value);
    _saveConfig();
  }

  void updateMirostatMode(int mode) {
    state = state.copyWith(mirostatMode: mode);
    _saveConfig();
  }

  void updateMirostatTau(double value) {
    state = state.copyWith(mirostatTau: value);
    _saveConfig();
  }

  void updateMirostatEta(double value) {
    state = state.copyWith(mirostatEta: value);
    _saveConfig();
  }

  void updateStopSequences(List<String> sequences) {
    state = state.copyWith(stopSequences: sequences);
    _saveConfig();
  }

  void updateSeed(int seed) {
    state = state.copyWith(seed: seed);
    _saveConfig();
  }

  void resetToDefaults() {
    state = _defaultConfig();
    _saveConfig();
  }
}

/// Provider for LLM configuration
final llmConfigProvider = StateNotifierProvider<LLMConfigNotifier, LLMConfig>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LLMConfigNotifier(prefs);
});

/// App settings state
class AppSettings {
  final String theme;
  final String language;
  final bool enableNotifications;
  final bool enableHaptics;
  final String defaultCharacterSortOrder;
  final bool confirmBeforeDelete;
  final bool autoSaveChats;

  const AppSettings({
    this.theme = 'dark',
    this.language = 'en',
    this.enableNotifications = true,
    this.enableHaptics = true,
    this.defaultCharacterSortOrder = 'name',
    this.confirmBeforeDelete = true,
    this.autoSaveChats = true,
  });

  AppSettings copyWith({
    String? theme,
    String? language,
    bool? enableNotifications,
    bool? enableHaptics,
    String? defaultCharacterSortOrder,
    bool? confirmBeforeDelete,
    bool? autoSaveChats,
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
    );
  }
}

/// App settings notifier
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;
  static const _settingsKey = 'app_settings';

  AppSettingsNotifier(this._prefs) : super(const AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final json = _prefs.getString(_settingsKey);
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        state = AppSettings.fromJson(map);
      } catch (e) {
        // Use default settings on error
      }
    }
  }

  Future<void> _saveSettings() async {
    await _prefs.setString(_settingsKey, jsonEncode(state.toJson()));
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

  void resetToDefaults() {
    state = const AppSettings();
    _saveSettings();
  }
}

/// Provider for app settings
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppSettingsNotifier(prefs);
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
    _log('API Key: ${config.apiKey.isEmpty ? "(empty)" : "${config.apiKey.substring(0, 8)}..."}');
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
        _log('Failed to fetch models: $e', error: e.toString(), stackTrace: stackTrace);
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
      
      _log('Connection test failed: $errorMessage', error: e.toString(), stackTrace: stackTrace);
      
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
        _log('Models: ${models.take(10).join(", ")}${models.length > 10 ? "..." : ""}');
        state = ModelFetchState(
          status: ModelFetchStatus.success,
          models: models,
        );
        _log('Model fetch completed successfully');
      } else {
        // Provide helpful message based on provider
        String message;
        switch (config.provider) {
          case LLMProvider.openai:
          case LLMProvider.openRouter:
          case LLMProvider.gemini:
            message = 'No models found. Check your API key.';
            break;
          case LLMProvider.ollama:
            message = 'No models found. Run "ollama pull <model>" to download models.';
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
      _log('Model fetch failed: $errorMessage', error: e.toString(), stackTrace: stackTrace);
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