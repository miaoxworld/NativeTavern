import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for image generation service
final imageGenServiceProvider = Provider<ImageGenerationService>((ref) {
  return ImageGenerationService();
});

/// Provider for image generation settings
final imageGenSettingsProvider = StateNotifierProvider<ImageGenSettingsNotifier, ImageGenSettings>((ref) {
  return ImageGenSettingsNotifier(ref.watch(imageGenServiceProvider));
});

/// Notifier for image generation settings
class ImageGenSettingsNotifier extends StateNotifier<ImageGenSettings> {
  static const _prefsKey = 'image_gen_settings';
  final ImageGenerationService _service;

  ImageGenSettingsNotifier(this._service) : super(const ImageGenSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKey);
      if (jsonStr != null) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = ImageGenSettings.fromJson(json);
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

  void setProvider(ImageGenProvider provider) {
    state = state.copyWith(provider: provider);
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

  void setDefaultModel(String model) {
    state = state.copyWith(defaultModel: model);
    _saveSettings();
  }

  void setDefaultWidth(int width) {
    state = state.copyWith(defaultWidth: width.clamp(256, 2048));
    _saveSettings();
  }

  void setDefaultHeight(int height) {
    state = state.copyWith(defaultHeight: height.clamp(256, 2048));
    _saveSettings();
  }

  void setDefaultSteps(int steps) {
    state = state.copyWith(defaultSteps: steps.clamp(1, 150));
    _saveSettings();
  }

  void setDefaultCfgScale(double cfgScale) {
    state = state.copyWith(defaultCfgScale: cfgScale.clamp(1.0, 30.0));
    _saveSettings();
  }

  void setDefaultSampler(String sampler) {
    state = state.copyWith(defaultSampler: sampler);
    _saveSettings();
  }

  void setDefaultNegativePrompt(String? negativePrompt) {
    state = state.copyWith(defaultNegativePrompt: negativePrompt);
    _saveSettings();
  }

  void reset() {
    state = const ImageGenSettings();
    _saveSettings();
  }
}

/// Image generation state
class ImageGenState {
  final bool isGenerating;
  final double progress;
  final ImageGenResult? result;
  final String? error;

  const ImageGenState({
    this.isGenerating = false,
    this.progress = 0.0,
    this.result,
    this.error,
  });

  ImageGenState copyWith({
    bool? isGenerating,
    double? progress,
    ImageGenResult? result,
    String? error,
  }) {
    return ImageGenState(
      isGenerating: isGenerating ?? this.isGenerating,
      progress: progress ?? this.progress,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

/// Notifier for image generation state
class ImageGenStateNotifier extends StateNotifier<ImageGenState> {
  final ImageGenerationService _service;

  ImageGenStateNotifier(this._service) : super(const ImageGenState()) {
    _service.onProgress = (progress) {
      state = state.copyWith(progress: progress);
    };
    _service.onError = (error) {
      state = state.copyWith(isGenerating: false, error: error);
    };
  }

  Future<void> generate(ImageGenRequest request) async {
    state = state.copyWith(isGenerating: true, progress: 0.0, error: null);
    
    try {
      final result = await _service.generate(request);
      state = state.copyWith(isGenerating: false, result: result);
    } catch (e) {
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  Future<void> generatePortrait({
    required String characterName,
    required String characterDescription,
    String? style,
  }) async {
    state = state.copyWith(isGenerating: true, progress: 0.0, error: null);
    
    try {
      final result = await _service.generatePortrait(
        characterName: characterName,
        characterDescription: characterDescription,
        style: style,
      );
      state = state.copyWith(isGenerating: false, result: result);
    } catch (e) {
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  void clear() {
    state = const ImageGenState();
  }
}

/// Provider for image generation state
final imageGenStateProvider = StateNotifierProvider<ImageGenStateNotifier, ImageGenState>((ref) {
  final service = ref.watch(imageGenServiceProvider);
  return ImageGenStateNotifier(service);
});

/// Provider for generating images
final generateImageProvider = Provider<Future<ImageGenResult?> Function(ImageGenRequest)>((ref) {
  final service = ref.watch(imageGenServiceProvider);
  final settings = ref.watch(imageGenSettingsProvider);
  
  return (ImageGenRequest request) async {
    if (!settings.enabled) return null;
    
    ref.read(imageGenStateProvider.notifier).generate(request);
    
    // Wait for completion
    while (ref.read(imageGenStateProvider).isGenerating) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    return ref.read(imageGenStateProvider).result;
  };
});

/// Provider for parsing /imagine command
final parseImagineCommandProvider = Provider<ImageGenRequest? Function(String)>((ref) {
  final service = ref.watch(imageGenServiceProvider);
  return service.parseImagineCommand;
});