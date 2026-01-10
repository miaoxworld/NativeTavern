import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/data/models/tokenizer.dart';
import 'package:native_tavern/domain/services/tokenizer_service.dart';

/// Provider for TokenizerService
final tokenizerServiceProvider = Provider<TokenizerService>((ref) {
  return TokenizerService();
});

/// Provider for tokenizer settings
final tokenizerSettingsProvider =
    StateNotifierProvider<TokenizerSettingsNotifier, TokenizerSettings>((ref) {
  return TokenizerSettingsNotifier();
});

/// Notifier for managing tokenizer settings
class TokenizerSettingsNotifier extends StateNotifier<TokenizerSettings> {
  static const _storageKey = 'tokenizer_settings';

  TokenizerSettingsNotifier() : super(const TokenizerSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);
      if (json != null) {
        state = TokenizerSettings.deserialize(json);
      }
    } catch (e) {
      // Keep default settings on error
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, TokenizerSettings.serialize(state));
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Set selected tokenizer
  void setSelectedTokenizer(TokenizerType tokenizer) {
    state = state.copyWith(selectedTokenizer: tokenizer);
    _saveSettings();
  }

  /// Toggle show token count
  void setShowTokenCount(bool value) {
    state = state.copyWith(showTokenCount: value);
    _saveSettings();
  }

  /// Toggle show token visualization
  void setShowTokenVisualization(bool value) {
    state = state.copyWith(showTokenVisualization: value);
    _saveSettings();
  }

  /// Toggle cache results
  void setCacheResults(bool value) {
    state = state.copyWith(cacheResults: value);
    _saveSettings();
  }
}

/// Provider for tokenization result
final tokenizationResultProvider = FutureProvider.family<TokenizationResult, TokenizationRequest>((ref, request) async {
  final service = ref.watch(tokenizerServiceProvider);
  final settings = ref.watch(tokenizerSettingsProvider);
  
  final tokenizer = request.tokenizer ?? settings.selectedTokenizer;
  return service.tokenize(
    request.text,
    tokenizer,
    useCache: settings.cacheResults,
  );
});

/// Request for tokenization
class TokenizationRequest {
  final String text;
  final TokenizerType? tokenizer;

  const TokenizationRequest({
    required this.text,
    this.tokenizer,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TokenizationRequest &&
        other.text == text &&
        other.tokenizer == tokenizer;
  }

  @override
  int get hashCode => Object.hash(text, tokenizer);
}

/// Provider for quick token count estimation
final tokenCountEstimateProvider = Provider.family<int, String>((ref, text) {
  final service = ref.watch(tokenizerServiceProvider);
  return service.estimateTokenCount(text);
});

/// Provider for token statistics
final tokenStatisticsProvider = Provider.family<AsyncValue<TokenStatistics>, TokenizationRequest>((ref, request) {
  final resultAsync = ref.watch(tokenizationResultProvider(request));
  return resultAsync.when(
    data: (result) {
      final service = ref.watch(tokenizerServiceProvider);
      return AsyncValue.data(service.getStatistics(result));
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

/// Provider for best tokenizer based on current API
final bestTokenizerProvider = Provider.family<TokenizerType, ApiModelInfo>((ref, info) {
  final service = ref.watch(tokenizerServiceProvider);
  return service.getBestTokenizer(info.api, info.model);
});

/// API and model info for tokenizer selection
class ApiModelInfo {
  final String api;
  final String? model;

  const ApiModelInfo({
    required this.api,
    this.model,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiModelInfo &&
        other.api == api &&
        other.model == model;
  }

  @override
  int get hashCode => Object.hash(api, model);
}