import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/quick_reply.dart';
import 'settings_providers.dart';

const String _quickReplyConfigKey = 'quick_reply_config';

/// Provider for quick reply configuration
final quickReplyConfigProvider = StateNotifierProvider<QuickReplyConfigNotifier, QuickReplyConfig>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return QuickReplyConfigNotifier(prefs);
});

/// Notifier for managing quick reply configuration
class QuickReplyConfigNotifier extends StateNotifier<QuickReplyConfig> {
  final SharedPreferences _prefs;

  QuickReplyConfigNotifier(this._prefs) : super(QuickReplyConfig.defaultConfig) {
    _loadConfig();
  }

  void _loadConfig() {
    final jsonString = _prefs.getString(_quickReplyConfigKey);
    if (jsonString != null) {
      try {
        state = QuickReplyConfig.fromJsonString(jsonString);
      } catch (e) {
        // If parsing fails, use default config
        state = QuickReplyConfig.defaultConfig;
      }
    } else {
      // First time - save default config
      _saveConfig();
    }
  }

  Future<void> _saveConfig() async {
    await _prefs.setString(_quickReplyConfigKey, state.toJsonString());
  }

  /// Add a new quick reply
  Future<void> addReply(QuickReply reply) async {
    state = state.addReply(reply);
    await _saveConfig();
  }

  /// Update an existing quick reply
  Future<void> updateReply(QuickReply reply) async {
    state = state.updateReply(reply);
    await _saveConfig();
  }

  /// Remove a quick reply
  Future<void> removeReply(String id) async {
    state = state.removeReply(id);
    await _saveConfig();
  }

  /// Reorder replies
  Future<void> reorder(int oldIndex, int newIndex) async {
    state = state.reorder(oldIndex, newIndex);
    await _saveConfig();
  }

  /// Toggle a reply's enabled state
  Future<void> toggleReply(String id) async {
    state = state.toggleReply(id);
    await _saveConfig();
  }

  /// Toggle showing quick replies
  Future<void> toggleShowQuickReplies() async {
    state = state.copyWith(showQuickReplies: !state.showQuickReplies);
    await _saveConfig();
  }

  /// Toggle position (above/below input)
  Future<void> togglePosition() async {
    state = state.copyWith(showAboveInput: !state.showAboveInput);
    await _saveConfig();
  }

  /// Reset to default configuration
  Future<void> resetToDefault() async {
    state = QuickReplyConfig.defaultConfig;
    await _saveConfig();
  }
}

/// Provider for enabled quick replies only
final enabledQuickRepliesProvider = Provider<List<QuickReply>>((ref) {
  final config = ref.watch(quickReplyConfigProvider);
  return config.enabledReplies;
});

/// Provider for whether quick replies should be shown
final showQuickRepliesProvider = Provider<bool>((ref) {
  final config = ref.watch(quickReplyConfigProvider);
  return config.showQuickReplies;
});