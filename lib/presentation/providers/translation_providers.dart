import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/translation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for translation service
final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService();
});

/// Provider for translation settings
final translationSettingsProvider = StateNotifierProvider<TranslationSettingsNotifier, TranslationSettings>((ref) {
  return TranslationSettingsNotifier(ref.watch(translationServiceProvider));
});

/// Notifier for translation settings
class TranslationSettingsNotifier extends StateNotifier<TranslationSettings> {
  static const _prefsKey = 'translation_settings';
  final TranslationService _service;

  TranslationSettingsNotifier(this._service) : super(const TranslationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKey);
      if (jsonStr != null) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = TranslationSettings.fromJson(json);
        _service.updateSettings(state);
      }
    } catch (e) {
      // Use default settings on error
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(state.toJson());
      await prefs.setString(_prefsKey, jsonStr);
      _service.updateSettings(state);
    } catch (e) {
      // Ignore save errors
    }
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _saveSettings();
  }

  void setProvider(TranslationProvider provider) {
    state = state.copyWith(provider: provider);
    _saveSettings();
  }

  void setSourceLanguage(String language) {
    state = state.copyWith(sourceLanguage: language);
    _saveSettings();
  }

  void setTargetLanguage(String language) {
    state = state.copyWith(targetLanguage: language);
    _saveSettings();
  }

  void setAutoTranslateIncoming(bool auto) {
    state = state.copyWith(autoTranslateIncoming: auto);
    _saveSettings();
  }

  void setAutoTranslateOutgoing(bool auto) {
    state = state.copyWith(autoTranslateOutgoing: auto);
    _saveSettings();
  }

  void setShowOriginal(bool show) {
    state = state.copyWith(showOriginal: show);
    _saveSettings();
  }

  void setApiKey(String? apiKey) {
    state = state.copyWith(apiKey: apiKey);
    _saveSettings();
  }

  void setApiEndpoint(String? endpoint) {
    state = state.copyWith(apiEndpoint: endpoint);
    _saveSettings();
  }

  void swapLanguages() {
    if (state.sourceLanguage == 'auto') return;
    state = state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
    );
    _saveSettings();
  }

  void reset() {
    state = const TranslationSettings();
    _saveSettings();
  }
}

/// Provider for translating text
final translateTextProvider = FutureProvider.family<TranslationResult?, TranslateParams>((ref, params) async {
  final service = ref.watch(translationServiceProvider);
  final settings = ref.watch(translationSettingsProvider);
  
  if (!settings.enabled) return null;
  
  return service.translate(
    params.text,
    sourceLanguage: params.sourceLanguage,
    targetLanguage: params.targetLanguage,
  );
});

/// Parameters for translation
class TranslateParams {
  final String text;
  final String? sourceLanguage;
  final String? targetLanguage;

  const TranslateParams({
    required this.text,
    this.sourceLanguage,
    this.targetLanguage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateParams &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          sourceLanguage == other.sourceLanguage &&
          targetLanguage == other.targetLanguage;

  @override
  int get hashCode => text.hashCode ^ sourceLanguage.hashCode ^ targetLanguage.hashCode;
}

/// Provider for detecting language
final detectLanguageProvider = FutureProvider.family<String?, String>((ref, text) async {
  final service = ref.watch(translationServiceProvider);
  return service.detectLanguage(text);
});

/// Translation action provider
final translateProvider = Provider<Future<TranslationResult?> Function(String, {String? source, String? target})>((ref) {
  final service = ref.watch(translationServiceProvider);
  final settings = ref.watch(translationSettingsProvider);
  
  return (String text, {String? source, String? target}) async {
    if (!settings.enabled) return null;
    return service.translate(
      text,
      sourceLanguage: source,
      targetLanguage: target,
    );
  };
});

/// Provider for translation state (loading, result, error)
class TranslationState {
  final bool isLoading;
  final TranslationResult? result;
  final String? error;

  const TranslationState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  TranslationState copyWith({
    bool? isLoading,
    TranslationResult? result,
    String? error,
  }) {
    return TranslationState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

/// Notifier for managing translation state
class TranslationStateNotifier extends StateNotifier<TranslationState> {
  final TranslationService _service;

  TranslationStateNotifier(this._service) : super(const TranslationState());

  Future<void> translate(String text, {String? source, String? target}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _service.translate(
        text,
        sourceLanguage: source,
        targetLanguage: target,
      );
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() {
    state = const TranslationState();
  }
}

/// Provider for translation state notifier
final translationStateProvider = StateNotifierProvider<TranslationStateNotifier, TranslationState>((ref) {
  final service = ref.watch(translationServiceProvider);
  return TranslationStateNotifier(service);
});