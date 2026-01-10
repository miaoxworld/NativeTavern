import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/data/models/cfg_scale.dart';

/// Provider for CFG Scale settings
final cfgScaleSettingsProvider =
    StateNotifierProvider<CFGScaleSettingsNotifier, CFGScaleSettings>((ref) {
  return CFGScaleSettingsNotifier();
});

/// Notifier for managing CFG Scale settings
class CFGScaleSettingsNotifier extends StateNotifier<CFGScaleSettings> {
  static const _storageKey = 'cfg_scale_settings';

  CFGScaleSettingsNotifier() : super(const CFGScaleSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);
      if (json != null) {
        state = CFGScaleSettings.deserialize(json);
      }
    } catch (e) {
      // Keep default settings on error
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, CFGScaleSettings.serialize(state));
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Toggle CFG enabled state
  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _saveSettings();
  }

  /// Set global guidance scale
  void setGlobalGuidanceScale(double scale) {
    state = state.copyWith(globalGuidanceScale: scale.clamp(0.1, 30.0));
    _saveSettings();
  }

  /// Set global negative prompt
  void setGlobalNegativePrompt(String prompt) {
    state = state.copyWith(globalNegativePrompt: prompt);
    _saveSettings();
  }

  /// Set global positive prompt
  void setGlobalPositivePrompt(String prompt) {
    state = state.copyWith(globalPositivePrompt: prompt);
    _saveSettings();
  }

  /// Update character-specific settings
  void updateCharacterSettings(CharacterCFGSettings settings) {
    final index = state.characterSettings.indexWhere(
      (s) => s.characterId == settings.characterId,
    );

    List<CharacterCFGSettings> newSettings;
    if (index >= 0) {
      newSettings = List.from(state.characterSettings);
      if (settings.hasCustomSettings) {
        newSettings[index] = settings;
      } else {
        // Remove if no custom settings
        newSettings.removeAt(index);
      }
    } else if (settings.hasCustomSettings) {
      newSettings = [...state.characterSettings, settings];
    } else {
      return; // Nothing to update
    }

    state = state.copyWith(characterSettings: newSettings);
    _saveSettings();
  }

  /// Remove character-specific settings
  void removeCharacterSettings(String characterId) {
    final newSettings = state.characterSettings
        .where((s) => s.characterId != characterId)
        .toList();
    state = state.copyWith(characterSettings: newSettings);
    _saveSettings();
  }

  /// Get character-specific settings
  CharacterCFGSettings? getCharacterSettings(String characterId) {
    try {
      return state.characterSettings.firstWhere(
        (s) => s.characterId == characterId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Reset all settings to defaults
  void resetToDefaults() {
    state = const CFGScaleSettings();
    _saveSettings();
  }
}

/// Provider for chat-specific CFG settings
/// This should be used in conjunction with chat metadata
final chatCFGSettingsProvider = StateNotifierProvider.family<
    ChatCFGSettingsNotifier, ChatCFGSettings, String?>((ref, chatId) {
  return ChatCFGSettingsNotifier(chatId);
});

/// Notifier for chat-specific CFG settings
class ChatCFGSettingsNotifier extends StateNotifier<ChatCFGSettings> {
  final String? chatId;
  static const _storageKeyPrefix = 'chat_cfg_settings_';

  ChatCFGSettingsNotifier(this.chatId) : super(const ChatCFGSettings()) {
    if (chatId != null) {
      _loadSettings();
    }
  }

  Future<void> _loadSettings() async {
    if (chatId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('$_storageKeyPrefix$chatId');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) {
          state = ChatCFGSettings.fromJson(decoded);
        }
      }
    } catch (e) {
      // Keep default settings on error
    }
  }

  Future<void> _saveSettings() async {
    if (chatId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_storageKeyPrefix$chatId',
        jsonEncode(state.toJson()),
      );
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Set guidance scale for this chat
  void setGuidanceScale(double? scale) {
    if (scale == null) {
      state = state.copyWith(clearGuidanceScale: true);
    } else {
      state = state.copyWith(guidanceScale: scale.clamp(0.1, 30.0));
    }
    _saveSettings();
  }

  /// Set negative prompt for this chat
  void setNegativePrompt(String? prompt) {
    if (prompt == null || prompt.isEmpty) {
      state = state.copyWith(clearNegativePrompt: true);
    } else {
      state = state.copyWith(negativePrompt: prompt);
    }
    _saveSettings();
  }

  /// Set positive prompt for this chat
  void setPositivePrompt(String? prompt) {
    if (prompt == null || prompt.isEmpty) {
      state = state.copyWith(clearPositivePrompt: true);
    } else {
      state = state.copyWith(positivePrompt: prompt);
    }
    _saveSettings();
  }

  /// Set prompt combine mode
  void setPromptCombineMode(PromptCombineMode mode) {
    state = state.copyWith(promptCombineMode: mode);
    _saveSettings();
  }

  /// Set prompt separator
  void setPromptSeparator(String? separator) {
    state = state.copyWith(promptSeparator: separator);
    _saveSettings();
  }

  /// Set whether to use group character settings
  void setUseGroupCharacterSettings(bool use) {
    state = state.copyWith(useGroupCharacterSettings: use);
    _saveSettings();
  }

  /// Clear all chat-specific settings
  void clearSettings() {
    state = const ChatCFGSettings();
    _saveSettings();
  }
}

/// Provider for effective CFG settings for a specific context
final effectiveCFGSettingsProvider = Provider.family<EffectiveCFGSettings, CFGContext>((ref, context) {
  final globalSettings = ref.watch(cfgScaleSettingsProvider);
  final chatSettings = context.chatId != null
      ? ref.watch(chatCFGSettingsProvider(context.chatId))
      : null;

  return globalSettings.getEffectiveSettings(
    characterId: context.characterId,
    chatId: context.chatId,
    chatSettings: chatSettings,
  );
});

/// Context for getting effective CFG settings
class CFGContext {
  final String? characterId;
  final String? chatId;

  const CFGContext({
    this.characterId,
    this.chatId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CFGContext &&
        other.characterId == characterId &&
        other.chatId == chatId;
  }

  @override
  int get hashCode => Object.hash(characterId, chatId);
}

/// Provider for checking if CFG is active
final isCFGActiveProvider = Provider<bool>((ref) {
  final settings = ref.watch(cfgScaleSettingsProvider);
  return settings.enabled;
});

/// Provider for CFG guidance scale value (for display)
final cfgGuidanceScaleDisplayProvider = Provider.family<String, CFGContext>((ref, context) {
  final effective = ref.watch(effectiveCFGSettingsProvider(context));
  return effective.guidanceScale.toStringAsFixed(2);
});