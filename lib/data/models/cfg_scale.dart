import 'dart:convert';

/// Settings for CFG (Classifier-Free Guidance) Scale
class CFGScaleSettings {
  /// Global guidance scale (1.0 = no effect)
  final double globalGuidanceScale;
  
  /// Global negative prompt
  final String globalNegativePrompt;
  
  /// Global positive prompt (optional enhancement)
  final String globalPositivePrompt;
  
  /// Whether CFG is enabled globally
  final bool enabled;
  
  /// Character-specific CFG settings
  final List<CharacterCFGSettings> characterSettings;

  const CFGScaleSettings({
    this.globalGuidanceScale = 1.0,
    this.globalNegativePrompt = '',
    this.globalPositivePrompt = '',
    this.enabled = false,
    this.characterSettings = const [],
  });

  factory CFGScaleSettings.fromJson(Map<String, dynamic> json) {
    return CFGScaleSettings(
      globalGuidanceScale: (json['globalGuidanceScale'] as num?)?.toDouble() ?? 1.0,
      globalNegativePrompt: json['globalNegativePrompt'] as String? ?? '',
      globalPositivePrompt: json['globalPositivePrompt'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      characterSettings: (json['characterSettings'] as List<dynamic>?)
              ?.map((e) => CharacterCFGSettings.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalGuidanceScale': globalGuidanceScale,
      'globalNegativePrompt': globalNegativePrompt,
      'globalPositivePrompt': globalPositivePrompt,
      'enabled': enabled,
      'characterSettings': characterSettings.map((e) => e.toJson()).toList(),
    };
  }

  CFGScaleSettings copyWith({
    double? globalGuidanceScale,
    String? globalNegativePrompt,
    String? globalPositivePrompt,
    bool? enabled,
    List<CharacterCFGSettings>? characterSettings,
  }) {
    return CFGScaleSettings(
      globalGuidanceScale: globalGuidanceScale ?? this.globalGuidanceScale,
      globalNegativePrompt: globalNegativePrompt ?? this.globalNegativePrompt,
      globalPositivePrompt: globalPositivePrompt ?? this.globalPositivePrompt,
      enabled: enabled ?? this.enabled,
      characterSettings: characterSettings ?? this.characterSettings,
    );
  }

  /// Get effective CFG settings for a character
  EffectiveCFGSettings getEffectiveSettings({
    String? characterId,
    String? chatId,
    ChatCFGSettings? chatSettings,
  }) {
    if (!enabled) {
      return const EffectiveCFGSettings(
        guidanceScale: 1.0,
        negativePrompt: '',
        positivePrompt: '',
        isActive: false,
      );
    }

    // Start with global settings
    double scale = globalGuidanceScale;
    String negative = globalNegativePrompt;
    String positive = globalPositivePrompt;

    // Apply character-specific settings if available
    if (characterId != null) {
      final charSettings = characterSettings.firstWhere(
        (s) => s.characterId == characterId,
        orElse: () => CharacterCFGSettings.empty(characterId),
      );
      
      if (charSettings.useCharacterSettings) {
        if (charSettings.guidanceScale != null) {
          scale = charSettings.guidanceScale!;
        }
        if (charSettings.negativePrompt != null && charSettings.negativePrompt!.isNotEmpty) {
          negative = charSettings.negativePrompt!;
        }
        if (charSettings.positivePrompt != null && charSettings.positivePrompt!.isNotEmpty) {
          positive = charSettings.positivePrompt!;
        }
      }
    }

    // Apply chat-specific settings if available (highest priority)
    if (chatSettings != null) {
      if (chatSettings.guidanceScale != null) {
        scale = chatSettings.guidanceScale!;
      }
      if (chatSettings.negativePrompt != null && chatSettings.negativePrompt!.isNotEmpty) {
        negative = chatSettings.negativePrompt!;
      }
      if (chatSettings.positivePrompt != null && chatSettings.positivePrompt!.isNotEmpty) {
        positive = chatSettings.positivePrompt!;
      }
    }

    return EffectiveCFGSettings(
      guidanceScale: scale,
      negativePrompt: negative,
      positivePrompt: positive,
      isActive: scale != 1.0 || negative.isNotEmpty,
    );
  }

  static String serialize(CFGScaleSettings settings) {
    return jsonEncode(settings.toJson());
  }

  static CFGScaleSettings deserialize(String json) {
    return CFGScaleSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}

/// Character-specific CFG settings
class CharacterCFGSettings {
  final String characterId;
  final bool useCharacterSettings;
  final double? guidanceScale;
  final String? negativePrompt;
  final String? positivePrompt;

  const CharacterCFGSettings({
    required this.characterId,
    this.useCharacterSettings = false,
    this.guidanceScale,
    this.negativePrompt,
    this.positivePrompt,
  });

  factory CharacterCFGSettings.empty(String characterId) {
    return CharacterCFGSettings(characterId: characterId);
  }

  factory CharacterCFGSettings.fromJson(Map<String, dynamic> json) {
    return CharacterCFGSettings(
      characterId: json['characterId'] as String? ?? '',
      useCharacterSettings: json['useCharacterSettings'] as bool? ?? false,
      guidanceScale: (json['guidanceScale'] as num?)?.toDouble(),
      negativePrompt: json['negativePrompt'] as String?,
      positivePrompt: json['positivePrompt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'useCharacterSettings': useCharacterSettings,
      'guidanceScale': guidanceScale,
      'negativePrompt': negativePrompt,
      'positivePrompt': positivePrompt,
    };
  }

  CharacterCFGSettings copyWith({
    String? characterId,
    bool? useCharacterSettings,
    double? guidanceScale,
    String? negativePrompt,
    String? positivePrompt,
    bool clearGuidanceScale = false,
    bool clearNegativePrompt = false,
    bool clearPositivePrompt = false,
  }) {
    return CharacterCFGSettings(
      characterId: characterId ?? this.characterId,
      useCharacterSettings: useCharacterSettings ?? this.useCharacterSettings,
      guidanceScale: clearGuidanceScale ? null : (guidanceScale ?? this.guidanceScale),
      negativePrompt: clearNegativePrompt ? null : (negativePrompt ?? this.negativePrompt),
      positivePrompt: clearPositivePrompt ? null : (positivePrompt ?? this.positivePrompt),
    );
  }

  /// Check if this has any non-default values
  bool get hasCustomSettings {
    return useCharacterSettings ||
        guidanceScale != null ||
        (negativePrompt != null && negativePrompt!.isNotEmpty) ||
        (positivePrompt != null && positivePrompt!.isNotEmpty);
  }
}

/// Chat-specific CFG settings (stored in chat metadata)
class ChatCFGSettings {
  final double? guidanceScale;
  final String? negativePrompt;
  final String? positivePrompt;
  final PromptCombineMode promptCombineMode;
  final String? promptSeparator;
  final bool useGroupCharacterSettings;

  const ChatCFGSettings({
    this.guidanceScale,
    this.negativePrompt,
    this.positivePrompt,
    this.promptCombineMode = PromptCombineMode.replace,
    this.promptSeparator,
    this.useGroupCharacterSettings = false,
  });

  factory ChatCFGSettings.fromJson(Map<String, dynamic> json) {
    return ChatCFGSettings(
      guidanceScale: (json['guidanceScale'] as num?)?.toDouble(),
      negativePrompt: json['negativePrompt'] as String?,
      positivePrompt: json['positivePrompt'] as String?,
      promptCombineMode: PromptCombineMode.values.firstWhere(
        (e) => e.name == json['promptCombineMode'],
        orElse: () => PromptCombineMode.replace,
      ),
      promptSeparator: json['promptSeparator'] as String?,
      useGroupCharacterSettings: json['useGroupCharacterSettings'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guidanceScale': guidanceScale,
      'negativePrompt': negativePrompt,
      'positivePrompt': positivePrompt,
      'promptCombineMode': promptCombineMode.name,
      'promptSeparator': promptSeparator,
      'useGroupCharacterSettings': useGroupCharacterSettings,
    };
  }

  ChatCFGSettings copyWith({
    double? guidanceScale,
    String? negativePrompt,
    String? positivePrompt,
    PromptCombineMode? promptCombineMode,
    String? promptSeparator,
    bool? useGroupCharacterSettings,
    bool clearGuidanceScale = false,
    bool clearNegativePrompt = false,
    bool clearPositivePrompt = false,
  }) {
    return ChatCFGSettings(
      guidanceScale: clearGuidanceScale ? null : (guidanceScale ?? this.guidanceScale),
      negativePrompt: clearNegativePrompt ? null : (negativePrompt ?? this.negativePrompt),
      positivePrompt: clearPositivePrompt ? null : (positivePrompt ?? this.positivePrompt),
      promptCombineMode: promptCombineMode ?? this.promptCombineMode,
      promptSeparator: promptSeparator ?? this.promptSeparator,
      useGroupCharacterSettings: useGroupCharacterSettings ?? this.useGroupCharacterSettings,
    );
  }
}

/// How to combine prompts from different sources
enum PromptCombineMode {
  /// Replace lower priority prompts
  replace,
  /// Prepend to lower priority prompts
  prepend,
  /// Append to lower priority prompts
  append,
}

/// Effective CFG settings after combining all sources
class EffectiveCFGSettings {
  final double guidanceScale;
  final String negativePrompt;
  final String positivePrompt;
  final bool isActive;

  const EffectiveCFGSettings({
    required this.guidanceScale,
    required this.negativePrompt,
    required this.positivePrompt,
    required this.isActive,
  });

  /// Convert to API request format
  Map<String, dynamic> toApiFormat() {
    if (!isActive) return {};
    
    return {
      'guidance_scale': guidanceScale,
      if (negativePrompt.isNotEmpty) 'negative_prompt': negativePrompt,
      if (positivePrompt.isNotEmpty) 'positive_prompt': positivePrompt,
    };
  }
}