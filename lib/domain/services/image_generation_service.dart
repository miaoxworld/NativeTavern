import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Image Generation Provider types
enum ImageGenProvider {
  stableDiffusion('stable_diffusion', 'Stable Diffusion'),
  dalle('dalle', 'DALL-E'),
  comfyui('comfyui', 'ComfyUI'),
  automatic1111('automatic1111', 'Automatic1111'),
  ;

  final String id;
  final String displayName;

  const ImageGenProvider(this.id, this.displayName);

  static ImageGenProvider? fromId(String id) {
    try {
      return ImageGenProvider.values.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Image Generation Settings
class ImageGenSettings {
  final bool enabled;
  final ImageGenProvider provider;
  final String? apiKey;
  final String? apiEndpoint;
  final String defaultModel;
  final int defaultWidth;
  final int defaultHeight;
  final int defaultSteps;
  final double defaultCfgScale;
  final String defaultSampler;
  final String? defaultNegativePrompt;

  const ImageGenSettings({
    this.enabled = false,
    this.provider = ImageGenProvider.stableDiffusion,
    this.apiKey,
    this.apiEndpoint,
    this.defaultModel = 'stable-diffusion-v1-5',
    this.defaultWidth = 512,
    this.defaultHeight = 512,
    this.defaultSteps = 20,
    this.defaultCfgScale = 7.0,
    this.defaultSampler = 'euler_a',
    this.defaultNegativePrompt,
  });

  ImageGenSettings copyWith({
    bool? enabled,
    ImageGenProvider? provider,
    String? apiKey,
    String? apiEndpoint,
    String? defaultModel,
    int? defaultWidth,
    int? defaultHeight,
    int? defaultSteps,
    double? defaultCfgScale,
    String? defaultSampler,
    String? defaultNegativePrompt,
  }) {
    return ImageGenSettings(
      enabled: enabled ?? this.enabled,
      provider: provider ?? this.provider,
      apiKey: apiKey ?? this.apiKey,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      defaultModel: defaultModel ?? this.defaultModel,
      defaultWidth: defaultWidth ?? this.defaultWidth,
      defaultHeight: defaultHeight ?? this.defaultHeight,
      defaultSteps: defaultSteps ?? this.defaultSteps,
      defaultCfgScale: defaultCfgScale ?? this.defaultCfgScale,
      defaultSampler: defaultSampler ?? this.defaultSampler,
      defaultNegativePrompt: defaultNegativePrompt ?? this.defaultNegativePrompt,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'provider': provider.id,
        'apiKey': apiKey,
        'apiEndpoint': apiEndpoint,
        'defaultModel': defaultModel,
        'defaultWidth': defaultWidth,
        'defaultHeight': defaultHeight,
        'defaultSteps': defaultSteps,
        'defaultCfgScale': defaultCfgScale,
        'defaultSampler': defaultSampler,
        'defaultNegativePrompt': defaultNegativePrompt,
      };

  factory ImageGenSettings.fromJson(Map<String, dynamic> json) => ImageGenSettings(
        enabled: json['enabled'] as bool? ?? false,
        provider: ImageGenProvider.fromId(json['provider'] as String? ?? 'stable_diffusion') ?? ImageGenProvider.stableDiffusion,
        apiKey: json['apiKey'] as String?,
        apiEndpoint: json['apiEndpoint'] as String?,
        defaultModel: json['defaultModel'] as String? ?? 'stable-diffusion-v1-5',
        defaultWidth: json['defaultWidth'] as int? ?? 512,
        defaultHeight: json['defaultHeight'] as int? ?? 512,
        defaultSteps: json['defaultSteps'] as int? ?? 20,
        defaultCfgScale: (json['defaultCfgScale'] as num?)?.toDouble() ?? 7.0,
        defaultSampler: json['defaultSampler'] as String? ?? 'euler_a',
        defaultNegativePrompt: json['defaultNegativePrompt'] as String?,
      );
}

/// Image generation request parameters
class ImageGenRequest {
  final String prompt;
  final String? negativePrompt;
  final int width;
  final int height;
  final int steps;
  final double cfgScale;
  final String sampler;
  final String? model;
  final int? seed;
  final int batchSize;

  const ImageGenRequest({
    required this.prompt,
    this.negativePrompt,
    this.width = 512,
    this.height = 512,
    this.steps = 20,
    this.cfgScale = 7.0,
    this.sampler = 'euler_a',
    this.model,
    this.seed,
    this.batchSize = 1,
  });

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'negative_prompt': negativePrompt,
        'width': width,
        'height': height,
        'steps': steps,
        'cfg_scale': cfgScale,
        'sampler_name': sampler,
        'model': model,
        'seed': seed ?? -1,
        'batch_size': batchSize,
      };
}

/// Image generation result
class ImageGenResult {
  final List<Uint8List> images;
  final String prompt;
  final int seed;
  final Map<String, dynamic>? metadata;

  const ImageGenResult({
    required this.images,
    required this.prompt,
    required this.seed,
    this.metadata,
  });
}

/// Available samplers
class ImageGenSampler {
  final String id;
  final String name;

  const ImageGenSampler({required this.id, required this.name});

  static const List<ImageGenSampler> samplers = [
    ImageGenSampler(id: 'euler', name: 'Euler'),
    ImageGenSampler(id: 'euler_a', name: 'Euler Ancestral'),
    ImageGenSampler(id: 'heun', name: 'Heun'),
    ImageGenSampler(id: 'dpm_2', name: 'DPM2'),
    ImageGenSampler(id: 'dpm_2_a', name: 'DPM2 Ancestral'),
    ImageGenSampler(id: 'lms', name: 'LMS'),
    ImageGenSampler(id: 'dpm_fast', name: 'DPM Fast'),
    ImageGenSampler(id: 'dpm_adaptive', name: 'DPM Adaptive'),
    ImageGenSampler(id: 'dpmpp_2s_a', name: 'DPM++ 2S Ancestral'),
    ImageGenSampler(id: 'dpmpp_sde', name: 'DPM++ SDE'),
    ImageGenSampler(id: 'dpmpp_2m', name: 'DPM++ 2M'),
    ImageGenSampler(id: 'ddim', name: 'DDIM'),
    ImageGenSampler(id: 'plms', name: 'PLMS'),
    ImageGenSampler(id: 'uni_pc', name: 'UniPC'),
  ];
}

/// Image aspect ratios
class ImageAspectRatio {
  final String name;
  final int width;
  final int height;

  const ImageAspectRatio({
    required this.name,
    required this.width,
    required this.height,
  });

  double get ratio => width / height;

  static const List<ImageAspectRatio> presets = [
    ImageAspectRatio(name: 'Square (1:1)', width: 512, height: 512),
    ImageAspectRatio(name: 'Portrait (2:3)', width: 512, height: 768),
    ImageAspectRatio(name: 'Landscape (3:2)', width: 768, height: 512),
    ImageAspectRatio(name: 'Wide (16:9)', width: 912, height: 512),
    ImageAspectRatio(name: 'Tall (9:16)', width: 512, height: 912),
    ImageAspectRatio(name: 'HD Square', width: 1024, height: 1024),
    ImageAspectRatio(name: 'HD Portrait', width: 832, height: 1216),
    ImageAspectRatio(name: 'HD Landscape', width: 1216, height: 832),
  ];
}

/// Image Generation Service
class ImageGenerationService {
  ImageGenSettings _settings = const ImageGenSettings();

  /// Callbacks
  void Function(double)? onProgress;
  void Function(String)? onError;

  ImageGenSettings get settings => _settings;

  /// Update settings
  void updateSettings(ImageGenSettings settings) {
    _settings = settings;
  }

  /// Generate images
  Future<ImageGenResult?> generate(ImageGenRequest request) async {
    if (!_settings.enabled) return null;

    try {
      debugPrint('Image Generation: "${request.prompt}"');
      debugPrint('  Size: ${request.width}x${request.height}');
      debugPrint('  Steps: ${request.steps}, CFG: ${request.cfgScale}');
      debugPrint('  Sampler: ${request.sampler}');

      // Simulate progress
      for (var i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        onProgress?.call(i / 100);
      }

      // In production, this would call the actual API
      // For now, return a placeholder result
      return ImageGenResult(
        images: [], // Would contain actual image bytes
        prompt: request.prompt,
        seed: request.seed ?? DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      onError?.call('Image generation error: $e');
      return null;
    }
  }

  /// Generate character portrait
  Future<ImageGenResult?> generatePortrait({
    required String characterName,
    required String characterDescription,
    String? style,
  }) async {
    final prompt = _buildPortraitPrompt(
      characterName,
      characterDescription,
      style,
    );

    return generate(ImageGenRequest(
      prompt: prompt,
      negativePrompt: _settings.defaultNegativePrompt ?? _defaultNegativePrompt,
      width: 512,
      height: 768, // Portrait aspect ratio
      steps: _settings.defaultSteps,
      cfgScale: _settings.defaultCfgScale,
      sampler: _settings.defaultSampler,
    ));
  }

  /// Build portrait prompt from character info
  String _buildPortraitPrompt(
    String name,
    String description,
    String? style,
  ) {
    final parts = <String>[];
    
    // Add style prefix
    if (style != null && style.isNotEmpty) {
      parts.add(style);
    } else {
      parts.add('high quality portrait');
    }

    // Add character description
    if (description.isNotEmpty) {
      // Extract key visual descriptors
      parts.add(description);
    }

    // Add quality tags
    parts.add('detailed face');
    parts.add('beautiful lighting');
    parts.add('professional photography');

    return parts.join(', ');
  }

  /// Default negative prompt
  static const String _defaultNegativePrompt = 
      'low quality, blurry, distorted, deformed, ugly, bad anatomy, '
      'bad proportions, extra limbs, mutated hands, poorly drawn face, '
      'watermark, text, signature';

  /// Parse /imagine command
  ImageGenRequest? parseImagineCommand(String command) {
    // Format: /imagine <prompt> [--width N] [--height N] [--steps N] [--cfg N] [--seed N]
    if (!command.startsWith('/imagine ')) return null;

    var prompt = command.substring(9).trim();
    int width = _settings.defaultWidth;
    int height = _settings.defaultHeight;
    int steps = _settings.defaultSteps;
    double cfgScale = _settings.defaultCfgScale;
    int? seed;

    // Parse optional parameters
    final widthMatch = RegExp(r'--width\s+(\d+)').firstMatch(prompt);
    if (widthMatch != null) {
      width = int.parse(widthMatch.group(1)!);
      prompt = prompt.replaceFirst(widthMatch.group(0)!, '').trim();
    }

    final heightMatch = RegExp(r'--height\s+(\d+)').firstMatch(prompt);
    if (heightMatch != null) {
      height = int.parse(heightMatch.group(1)!);
      prompt = prompt.replaceFirst(heightMatch.group(0)!, '').trim();
    }

    final stepsMatch = RegExp(r'--steps\s+(\d+)').firstMatch(prompt);
    if (stepsMatch != null) {
      steps = int.parse(stepsMatch.group(1)!);
      prompt = prompt.replaceFirst(stepsMatch.group(0)!, '').trim();
    }

    final cfgMatch = RegExp(r'--cfg\s+([\d.]+)').firstMatch(prompt);
    if (cfgMatch != null) {
      cfgScale = double.parse(cfgMatch.group(1)!);
      prompt = prompt.replaceFirst(cfgMatch.group(0)!, '').trim();
    }

    final seedMatch = RegExp(r'--seed\s+(\d+)').firstMatch(prompt);
    if (seedMatch != null) {
      seed = int.parse(seedMatch.group(1)!);
      prompt = prompt.replaceFirst(seedMatch.group(0)!, '').trim();
    }

    if (prompt.isEmpty) return null;

    return ImageGenRequest(
      prompt: prompt,
      negativePrompt: _settings.defaultNegativePrompt,
      width: width,
      height: height,
      steps: steps,
      cfgScale: cfgScale,
      sampler: _settings.defaultSampler,
      seed: seed,
    );
  }
}