import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/chat_background.dart';
import '../../data/repositories/character_repository.dart';
import 'settings_providers.dart';

const String _globalBackgroundKey = 'global_chat_background';
const String _characterBackgroundPrefix = 'character_background_';

/// Provider for global chat background
final globalBackgroundProvider =
    StateNotifierProvider<GlobalBackgroundNotifier, ChatBackground>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return GlobalBackgroundNotifier(prefs);
});

/// Notifier for global background
class GlobalBackgroundNotifier extends StateNotifier<ChatBackground> {
  final SharedPreferences _prefs;

  GlobalBackgroundNotifier(this._prefs) : super(ChatBackground.none) {
    _loadBackground();
  }

  void _loadBackground() {
    final jsonString = _prefs.getString(_globalBackgroundKey);
    if (jsonString != null) {
      try {
        state = ChatBackground.fromJsonString(jsonString);
      } catch (e) {
        state = ChatBackground.none;
      }
    }
  }

  Future<void> _saveBackground() async {
    if (state.type == BackgroundType.none) {
      await _prefs.remove(_globalBackgroundKey);
    } else {
      await _prefs.setString(_globalBackgroundKey, state.toJsonString());
    }
  }

  Future<void> setBackground(ChatBackground background) async {
    state = background;
    await _saveBackground();
  }

  Future<void> clearBackground() async {
    state = ChatBackground.none;
    await _saveBackground();
  }

  Future<void> setOpacity(double opacity) async {
    state = state.copyWith(opacity: opacity.clamp(0.0, 1.0));
    await _saveBackground();
  }

  Future<void> setBlur(bool blur) async {
    state = state.copyWith(blur: blur);
    await _saveBackground();
  }

  Future<void> setBlurAmount(double amount) async {
    state = state.copyWith(blurAmount: amount.clamp(0.0, 20.0));
    await _saveBackground();
  }
}

/// Provider for per-character backgrounds
final characterBackgroundProvider = StateNotifierProvider.family<
    CharacterBackgroundNotifier, ChatBackground?, String>((ref, characterId) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CharacterBackgroundNotifier(prefs, characterId);
});

/// Notifier for character-specific background
class CharacterBackgroundNotifier extends StateNotifier<ChatBackground?> {
  final SharedPreferences _prefs;
  final String _characterId;

  CharacterBackgroundNotifier(this._prefs, this._characterId) : super(null) {
    _loadBackground();
  }

  String get _key => '$_characterBackgroundPrefix$_characterId';

  void _loadBackground() {
    final jsonString = _prefs.getString(_key);
    if (jsonString != null) {
      try {
        state = ChatBackground.fromJsonString(jsonString);
      } catch (e) {
        state = null;
      }
    }
  }

  Future<void> _saveBackground() async {
    if (state == null || state!.type == BackgroundType.none) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, state!.toJsonString());
    }
  }

  Future<void> setBackground(ChatBackground? background) async {
    state = background;
    await _saveBackground();
  }

  Future<void> clearBackground() async {
    state = null;
    await _saveBackground();
  }
}

/// Provider that returns the effective background for a chat
/// Priority: character-specific background > character avatar (if enabled) > global background
final effectiveBackgroundProvider =
    FutureProvider.family<ChatBackground, String?>((ref, characterId) async {
  // Check if we should use character avatar as background
  final useCharacterAvatar = ref.watch(
      appSettingsProvider.select((s) => s.useCharacterAvatarAsBackground));
  // Get global image background settings - applies to all image backgrounds
  final enableBlur =
      ref.watch(appSettingsProvider.select((s) => s.enableBackgroundBlur));
  final backgroundOpacity =
      ref.watch(appSettingsProvider.select((s) => s.backgroundOpacity));
  // Get global background (for fallback and bubbleOpacity)
  final globalBg = ref.watch(globalBackgroundProvider);

  ChatBackground effectiveBg;

  if (characterId != null) {
    // 1. Check for character-specific background
    final characterBg = ref.watch(characterBackgroundProvider(characterId));
    if (characterBg != null && characterBg.type != BackgroundType.none) {
      effectiveBg = characterBg;
    } else if (useCharacterAvatar) {
      // 2. Check for character avatar if enabled
      try {
        final repo = ref.watch(characterRepositoryProvider);
        final character = await repo.getCharacter(characterId);
        if (character?.assets?.avatarPath != null) {
          // Use global settings for all image parameters
          effectiveBg = ChatBackground.imagePath(
            character!.assets!.avatarPath!,
            opacity: backgroundOpacity,
            blur: enableBlur,
            blurAmount: 10.0,
            bubbleOpacity: globalBg.bubbleOpacity,
          );
        } else {
          // 3. Fall back to global background
          effectiveBg = globalBg;
        }
      } catch (e) {
        // If character not found or error, fall through to global background
        effectiveBg = globalBg;
      }
    } else {
      // 3. Fall back to global background
      effectiveBg = globalBg;
    }
  } else {
    // No character ID, use global background
    effectiveBg = globalBg;
  }

  // Apply global settings to all image backgrounds
  if (effectiveBg.type == BackgroundType.image) {
    return effectiveBg.copyWith(
      opacity: backgroundOpacity,
      blur: enableBlur,
      blurAmount: 10.0,
    );
  }

  return effectiveBg;
});

/// Provider for all saved character backgrounds
final savedCharacterBackgroundsProvider =
    FutureProvider<Map<String, ChatBackground>>((ref) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  final keys =
      prefs.getKeys().where((k) => k.startsWith(_characterBackgroundPrefix));

  final backgrounds = <String, ChatBackground>{};
  for (final key in keys) {
    final characterId = key.substring(_characterBackgroundPrefix.length);
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      try {
        backgrounds[characterId] = ChatBackground.fromJsonString(jsonString);
      } catch (_) {
        // Skip invalid entries
      }
    }
  }

  return backgrounds;
});
