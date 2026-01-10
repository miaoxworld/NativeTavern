import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/data/models/logprobs.dart';

/// Provider for logprobs settings
final logprobsSettingsProvider =
    StateNotifierProvider<LogprobsSettingsNotifier, LogprobsSettings>((ref) {
  return LogprobsSettingsNotifier();
});

/// Notifier for managing logprobs settings
class LogprobsSettingsNotifier extends StateNotifier<LogprobsSettings> {
  static const _storageKey = 'logprobs_settings';

  LogprobsSettingsNotifier() : super(const LogprobsSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);
      if (json != null) {
        state = LogprobsSettings.deserialize(json);
      }
    } catch (e) {
      // Keep default settings on error
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, LogprobsSettings.serialize(state));
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Toggle request token probabilities
  void setRequestTokenProbabilities(bool value) {
    state = state.copyWith(requestTokenProbabilities: value);
    _saveSettings();
  }

  /// Set number of top logprobs to request
  void setTopLogprobsCount(int count) {
    state = state.copyWith(topLogprobsCount: count.clamp(1, 20));
    _saveSettings();
  }

  /// Toggle show logprobs panel
  void setShowLogprobsPanel(bool value) {
    state = state.copyWith(showLogprobsPanel: value);
    _saveSettings();
  }

  /// Set color intensity for visualization
  void setColorIntensity(double intensity) {
    state = state.copyWith(colorIntensity: intensity.clamp(0.0, 1.0));
    _saveSettings();
  }
}

/// Provider for storing message logprobs data
final messageLogprobsProvider =
    StateNotifierProvider<MessageLogprobsNotifier, Map<String, MessageLogprobs>>((ref) {
  return MessageLogprobsNotifier();
});

/// Notifier for managing message logprobs
class MessageLogprobsNotifier extends StateNotifier<Map<String, MessageLogprobs>> {
  static const int _maxStoredMessages = 100;

  MessageLogprobsNotifier() : super({});

  /// Store logprobs for a message
  void storeLogprobs(MessageLogprobs logprobs) {
    final newState = Map<String, MessageLogprobs>.from(state);
    newState[logprobs.messageId] = logprobs;

    // Limit stored messages
    if (newState.length > _maxStoredMessages) {
      final sortedKeys = newState.keys.toList()
        ..sort((a, b) {
          final aTime = newState[a]!.createdAt;
          final bTime = newState[b]!.createdAt;
          return aTime.compareTo(bTime);
        });
      
      // Remove oldest entries
      for (int i = 0; i < newState.length - _maxStoredMessages; i++) {
        newState.remove(sortedKeys[i]);
      }
    }

    state = newState;
  }

  /// Get logprobs for a message
  MessageLogprobs? getLogprobs(String messageId) {
    return state[messageId];
  }

  /// Remove logprobs for a message
  void removeLogprobs(String messageId) {
    if (state.containsKey(messageId)) {
      final newState = Map<String, MessageLogprobs>.from(state);
      newState.remove(messageId);
      state = newState;
    }
  }

  /// Clear all stored logprobs
  void clearAll() {
    state = {};
  }
}

/// Provider for currently selected token in logprobs view
final selectedTokenLogprobProvider = StateProvider<TokenLogprob?>((ref) => null);

/// Provider for getting logprobs for a specific message
final messageLogprobProvider = Provider.family<MessageLogprobs?, String>((ref, messageId) {
  final allLogprobs = ref.watch(messageLogprobsProvider);
  return allLogprobs[messageId];
});

/// Provider for checking if logprobs are available for a message
final hasLogprobsProvider = Provider.family<bool, String>((ref, messageId) {
  final logprobs = ref.watch(messageLogprobProvider(messageId));
  return logprobs != null && logprobs.tokenLogprobs.isNotEmpty;
});

/// Provider for parsing API response logprobs
final logprobsParserProvider = Provider<LogprobsParser>((ref) {
  return LogprobsParser();
});

/// Parser for converting API responses to MessageLogprobs
class LogprobsParser {
  /// Parse OpenAI format logprobs
  MessageLogprobs? parseOpenAI({
    required String messageId,
    required Map<String, dynamic> response,
    String? continueFrom,
  }) {
    try {
      final choices = response['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) return null;

      final choice = choices[0] as Map<String, dynamic>;
      final logprobs = choice['logprobs'] as Map<String, dynamic>?;
      if (logprobs == null) return null;

      final content = logprobs['content'] as List<dynamic>?;
      if (content == null) return null;

      final tokenLogprobs = content.map((item) {
        final tokenData = item as Map<String, dynamic>;
        final topLogprobs = tokenData['top_logprobs'] as List<dynamic>?;
        
        return TokenLogprob(
          token: tokenData['token'] as String? ?? '',
          logprob: (tokenData['logprob'] as num?)?.toDouble() ?? 0.0,
          topCandidates: topLogprobs?.map((t) {
            final candidate = t as Map<String, dynamic>;
            return TokenCandidate(
              token: candidate['token'] as String? ?? '',
              logprob: (candidate['logprob'] as num?)?.toDouble() ?? 0.0,
            );
          }).toList() ?? [],
        );
      }).toList();

      return MessageLogprobs(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        messageId: messageId,
        api: 'openai',
        tokenLogprobs: tokenLogprobs,
        continueFrom: continueFrom,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Parse generic format logprobs (for other APIs)
  MessageLogprobs? parseGeneric({
    required String messageId,
    required String api,
    required List<Map<String, dynamic>> logprobsData,
    String? continueFrom,
  }) {
    try {
      final tokenLogprobs = logprobsData.map((item) {
        return TokenLogprob.fromJson(item);
      }).toList();

      return MessageLogprobs(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        messageId: messageId,
        api: api,
        tokenLogprobs: tokenLogprobs,
        continueFrom: continueFrom,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }
}

/// Provider for calculating probability color
final probabilityColorProvider = Provider<ProbabilityColorCalculator>((ref) {
  final settings = ref.watch(logprobsSettingsProvider);
  return ProbabilityColorCalculator(intensity: settings.colorIntensity);
});

/// Calculator for probability-based colors
class ProbabilityColorCalculator {
  final double intensity;

  ProbabilityColorCalculator({this.intensity = 0.5});

  /// Get color for a probability value (0-100)
  int getColor(double probability) {
    // Clamp probability to 0-100
    final p = probability.clamp(0.0, 100.0) / 100.0;
    
    // Calculate color based on probability
    // High probability = green, low probability = red
    final r = ((1 - p) * 255 * intensity).round();
    final g = (p * 255 * intensity).round();
    final b = 0;
    final a = (intensity * 255).round();

    return (a << 24) | (r << 16) | (g << 8) | b;
  }

  /// Get tint index for alternating token colors (0-3)
  int getTintIndex(int tokenIndex) {
    return tokenIndex % 4;
  }

  /// Convert log probability to linear probability
  double logToLinear(double logprob) {
    if (logprob > 0) return logprob; // Already linear
    return math.exp(logprob) * 100;
  }
}