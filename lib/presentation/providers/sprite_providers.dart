import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/sprite.dart';
import 'package:native_tavern/domain/services/emotion_detection_service.dart';
import 'package:native_tavern/domain/services/sprite_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Provider for emotion detection service
final emotionDetectionServiceProvider = Provider<EmotionDetectionService>((ref) {
  return EmotionDetectionService();
});

/// Provider for sprite service
final spriteServiceProvider = Provider<SpriteService>((ref) {
  final emotionService = ref.watch(emotionDetectionServiceProvider);
  return SpriteService(emotionService: emotionService);
});

/// Provider for sprite settings
final spriteSettingsProvider = StateNotifierProvider<SpriteSettingsNotifier, SpriteSettings>((ref) {
  return SpriteSettingsNotifier();
});

/// Notifier for sprite settings
class SpriteSettingsNotifier extends StateNotifier<SpriteSettings> {
  static const _prefsKey = 'sprite_settings';

  SpriteSettingsNotifier() : super(const SpriteSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKey);
      if (jsonStr != null) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = SpriteSettings.fromJson(json);
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
    } catch (e) {
      // Ignore save errors
    }
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _saveSettings();
  }

  void setSize(double size) {
    state = state.copyWith(size: size.clamp(50.0, 400.0));
    _saveSettings();
  }

  void setPosition(SpritePosition position) {
    state = state.copyWith(position: position);
    _saveSettings();
  }

  void setOpacity(double opacity) {
    state = state.copyWith(opacity: opacity.clamp(0.0, 1.0));
    _saveSettings();
  }

  void setShowDuringStreaming(bool show) {
    state = state.copyWith(showDuringStreaming: show);
    _saveSettings();
  }

  void setAnimateTransitions(bool animate) {
    state = state.copyWith(animateTransitions: animate);
    _saveSettings();
  }

  void setTransitionDuration(int durationMs) {
    state = state.copyWith(transitionDurationMs: durationMs.clamp(0, 1000));
    _saveSettings();
  }

  void reset() {
    state = const SpriteSettings();
    _saveSettings();
  }
}

/// Provider for a character's sprite pack
final spritePackProvider = FutureProvider.family<SpritePack, String>((ref, characterId) async {
  final spriteService = ref.watch(spriteServiceProvider);
  return spriteService.loadSpritePack(characterId);
});

/// Provider for checking if a character has sprites
final hasSpritesProvider = FutureProvider.family<bool, String>((ref, characterId) async {
  final spriteService = ref.watch(spriteServiceProvider);
  return spriteService.hasSprites(characterId);
});

/// Provider for getting sprite for a message
final messageSpriteProvider = FutureProvider.family<Sprite?, MessageSpriteParams>((ref, params) async {
  final spriteService = ref.watch(spriteServiceProvider);
  return spriteService.getSpriteForMessage(params.characterId, params.messageContent);
});

/// Parameters for message sprite provider
class MessageSpriteParams {
  final String characterId;
  final String messageContent;

  const MessageSpriteParams({
    required this.characterId,
    required this.messageContent,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSpriteParams &&
          runtimeType == other.runtimeType &&
          characterId == other.characterId &&
          messageContent == other.messageContent;

  @override
  int get hashCode => characterId.hashCode ^ messageContent.hashCode;
}

/// Notifier for managing sprites for a character
class SpritePackNotifier extends StateNotifier<AsyncValue<SpritePack>> {
  final SpriteService _spriteService;
  final String characterId;

  SpritePackNotifier(this._spriteService, this.characterId)
      : super(const AsyncValue.loading()) {
    _loadPack();
  }

  Future<void> _loadPack() async {
    state = const AsyncValue.loading();
    try {
      final pack = await _spriteService.loadSpritePack(characterId);
      state = AsyncValue.data(pack);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSprite(String emotion, File imageFile) async {
    try {
      await _spriteService.addSprite(
        characterId: characterId,
        emotion: emotion,
        sourceImage: imageFile,
      );
      await _loadPack();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeSprite(String emotion) async {
    try {
      await _spriteService.removeSprite(characterId, emotion);
      await _loadPack();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setDefaultEmotion(String emotion) async {
    try {
      await _spriteService.setDefaultEmotion(characterId, emotion);
      await _loadPack();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> importFromDirectory(Directory directory) async {
    try {
      final count = await _spriteService.importSpritesFromDirectory(
        characterId,
        directory,
      );
      await _loadPack();
      return count;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return 0;
    }
  }

  Future<void> deleteAll() async {
    try {
      await _spriteService.deleteAllSprites(characterId);
      await _loadPack();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    _spriteService.clearCacheForCharacter(characterId);
    await _loadPack();
  }
}

/// Provider for sprite pack notifier (for editing)
final spritePackNotifierProvider = StateNotifierProvider.family<
    SpritePackNotifier, AsyncValue<SpritePack>, String>((ref, characterId) {
  final spriteService = ref.watch(spriteServiceProvider);
  return SpritePackNotifier(spriteService, characterId);
});

/// Provider for current emotion detected from a message
final detectedEmotionProvider = Provider.family<SpriteEmotion, String>((ref, messageContent) {
  final emotionService = ref.watch(emotionDetectionServiceProvider);
  return emotionService.detectEmotion(messageContent);
});

/// Provider for emotion detection with confidence
final detectedEmotionWithConfidenceProvider = Provider.family<EmotionResult, String>((ref, messageContent) {
  final emotionService = ref.watch(emotionDetectionServiceProvider);
  return emotionService.detectEmotionWithConfidence(messageContent);
});