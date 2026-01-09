import 'package:flutter/foundation.dart';
import 'prompt_manager.dart';

/// AI Preset - combines generation settings, prompt ordering, and instruct template
/// This is the equivalent of SillyTavern's preset system
@immutable
class AIPreset {
  final String id;
  final String name;
  final String? description;
  final bool isBuiltIn;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Generation Settings (sampler parameters)
  final GenerationPreset generationSettings;

  // Prompt Manager Configuration
  final PromptManagerConfig? promptManagerConfig;

  // Instruct Template ID (references built-in or custom template)
  final String? instructTemplateId;

  const AIPreset({
    required this.id,
    required this.name,
    this.description,
    this.isBuiltIn = false,
    required this.createdAt,
    required this.updatedAt,
    required this.generationSettings,
    this.promptManagerConfig,
    this.instructTemplateId,
  });

  AIPreset copyWith({
    String? id,
    String? name,
    String? description,
    bool? isBuiltIn,
    DateTime? createdAt,
    DateTime? updatedAt,
    GenerationPreset? generationSettings,
    PromptManagerConfig? promptManagerConfig,
    String? instructTemplateId,
  }) {
    return AIPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      generationSettings: generationSettings ?? this.generationSettings,
      promptManagerConfig: promptManagerConfig ?? this.promptManagerConfig,
      instructTemplateId: instructTemplateId ?? this.instructTemplateId,
    );
  }

  /// Export format for sharing - SillyTavern compatible format
  /// Generation settings are at root level, not nested
  Map<String, dynamic> toExportJson() {
    final json = <String, dynamic>{
      // Metadata
      'preset_name': name,
      'description': description,
      
      // Generation settings at root level (SillyTavern format)
      ...generationSettings.toJson(),
      
      // Prompt ordering
      if (promptManagerConfig != null)
        'prompt_order': _promptConfigToSillyTavernFormat(promptManagerConfig!),
      
      // NativeTavern-specific fields
      '_native_tavern': {
        'version': 1,
        'instructTemplateId': instructTemplateId,
        'createdAt': createdAt.toIso8601String(),
      },
    };
    return json;
  }

  /// Convert prompt config to SillyTavern prompt_order format
  static List<Map<String, dynamic>> _promptConfigToSillyTavernFormat(
      PromptManagerConfig config) {
    // Map our section types to SillyTavern identifiers
    final typeToIdentifier = <PromptSectionType, String>{
      PromptSectionType.systemPrompt: 'main',
      PromptSectionType.persona: 'personaDescription',
      PromptSectionType.characterDescription: 'charDescription',
      PromptSectionType.characterPersonality: 'charPersonality',
      PromptSectionType.characterScenario: 'scenario',
      PromptSectionType.exampleMessages: 'dialogueExamples',
      PromptSectionType.worldInfo: 'worldInfoBefore',
      PromptSectionType.authorNote: 'authorNote',
      PromptSectionType.postHistoryInstructions: 'jailbreak',
    };

    return [
      {
        'character_id': 100000,
        'order': config.sortedSections.map((section) {
          return {
            'identifier': typeToIdentifier[section.type] ?? section.type.name,
            'enabled': section.enabled,
          };
        }).toList(),
      }
    ];
  }

  /// Full JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'isBuiltIn': isBuiltIn,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'generationSettings': generationSettings.toJson(),
        'promptManagerConfig': promptManagerConfig?.toJson(),
        'instructTemplateId': instructTemplateId,
      };

  factory AIPreset.fromJson(Map<String, dynamic> json) {
    return AIPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      generationSettings: GenerationPreset.fromJson(
        json['generationSettings'] as Map<String, dynamic>,
      ),
      promptManagerConfig: json['promptManagerConfig'] != null
          ? PromptManagerConfig.fromJson(
              json['promptManagerConfig'] as Map<String, dynamic>,
            )
          : null,
      instructTemplateId: json['instructTemplateId'] as String?,
    );
  }

  /// Import from export format - supports both SillyTavern and legacy NativeTavern formats
  factory AIPreset.fromExportJson(Map<String, dynamic> json, String id) {
    // Check if it's the legacy NativeTavern format with nested generationSettings
    if (json['generationSettings'] != null) {
      return AIPreset(
        id: id,
        name: json['name'] as String? ?? 'Imported Preset',
        description: json['description'] as String?,
        isBuiltIn: false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        updatedAt: DateTime.now(),
        generationSettings: GenerationPreset.fromJson(
          json['generationSettings'] as Map<String, dynamic>,
        ),
        promptManagerConfig: json['promptManagerConfig'] != null
            ? PromptManagerConfig.fromJson(
                json['promptManagerConfig'] as Map<String, dynamic>,
              )
            : null,
        instructTemplateId: json['instructTemplateId'] as String?,
      );
    }

    // Otherwise, parse as SillyTavern format (generation settings at root level)
    return AIPreset.fromSillyTavernJson(json, id);
  }

  /// Import from SillyTavern preset format
  /// Generation settings are at root level with snake_case keys
  factory AIPreset.fromSillyTavernJson(Map<String, dynamic> json, String id) {
    // Extract name
    final name = json['preset_name'] as String? ??
        json['name'] as String? ??
        'Imported Preset';
    
    // Extract description
    final description = json['description'] as String?;

    // Extract NativeTavern-specific metadata if present
    final nativeTavernMeta = json['_native_tavern'] as Map<String, dynamic>?;
    DateTime createdAt = DateTime.now();
    String? instructTemplateId;
    
    if (nativeTavernMeta != null) {
      if (nativeTavernMeta['createdAt'] != null) {
        createdAt = DateTime.parse(nativeTavernMeta['createdAt'] as String);
      }
      instructTemplateId = nativeTavernMeta['instructTemplateId'] as String?;
    }

    // Parse generation settings from root level
    final generationSettings = GenerationPreset.fromJson(json);

    // Parse prompt order if present
    PromptManagerConfig? promptConfig;
    if (json['prompt_order'] != null) {
      promptConfig = PromptManagerConfig.fromSillyTavernJson(json);
    }

    return AIPreset(
      id: id,
      name: name,
      description: description ?? 'Imported preset',
      isBuiltIn: false,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      generationSettings: generationSettings,
      promptManagerConfig: promptConfig,
      instructTemplateId: instructTemplateId,
    );
  }

  /// Check if JSON is in SillyTavern format
  static bool isSillyTavernFormat(Map<String, dynamic> json) {
    // SillyTavern presets have these characteristic fields at root level
    return json.containsKey('temperature') &&
        (json.containsKey('top_p') || json.containsKey('topP')) &&
        (json.containsKey('chat_completion_source') ||
            json.containsKey('openai_model') ||
            json.containsKey('prompt_order') ||
            json.containsKey('prompts'));
  }
}

/// Generation settings preset (sampler parameters only, no connection info)
@immutable
class GenerationPreset {
  final double temperature;
  final double topP;
  final int topK;
  final double minP;
  final double typicalP;
  final double repetitionPenalty;
  final int repetitionPenaltyRange;
  final double frequencyPenalty;
  final double presencePenalty;
  final double tailFreeSampling;
  final double topA;
  final int mirostatMode;
  final double mirostatTau;
  final double mirostatEta;
  final int maxTokens;
  final List<String> stopSequences;
  final int seed;
  final bool streamEnabled;

  const GenerationPreset({
    this.temperature = 1.0,
    this.topP = 0.95,
    this.topK = 40,
    this.minP = 0.0,
    this.typicalP = 1.0,
    this.repetitionPenalty = 1.0,
    this.repetitionPenaltyRange = 0,
    this.frequencyPenalty = 0.0,
    this.presencePenalty = 0.0,
    this.tailFreeSampling = 1.0,
    this.topA = 0.0,
    this.mirostatMode = 0,
    this.mirostatTau = 5.0,
    this.mirostatEta = 0.1,
    this.maxTokens = 512,
    this.stopSequences = const [],
    this.seed = -1,
    this.streamEnabled = true,
  });

  GenerationPreset copyWith({
    double? temperature,
    double? topP,
    int? topK,
    double? minP,
    double? typicalP,
    double? repetitionPenalty,
    int? repetitionPenaltyRange,
    double? frequencyPenalty,
    double? presencePenalty,
    double? tailFreeSampling,
    double? topA,
    int? mirostatMode,
    double? mirostatTau,
    double? mirostatEta,
    int? maxTokens,
    List<String>? stopSequences,
    int? seed,
    bool? streamEnabled,
  }) {
    return GenerationPreset(
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      topK: topK ?? this.topK,
      minP: minP ?? this.minP,
      typicalP: typicalP ?? this.typicalP,
      repetitionPenalty: repetitionPenalty ?? this.repetitionPenalty,
      repetitionPenaltyRange: repetitionPenaltyRange ?? this.repetitionPenaltyRange,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      tailFreeSampling: tailFreeSampling ?? this.tailFreeSampling,
      topA: topA ?? this.topA,
      mirostatMode: mirostatMode ?? this.mirostatMode,
      mirostatTau: mirostatTau ?? this.mirostatTau,
      mirostatEta: mirostatEta ?? this.mirostatEta,
      maxTokens: maxTokens ?? this.maxTokens,
      stopSequences: stopSequences ?? this.stopSequences,
      seed: seed ?? this.seed,
      streamEnabled: streamEnabled ?? this.streamEnabled,
    );
  }

  /// Export to JSON using SillyTavern-compatible snake_case keys
  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'top_p': topP,
        'top_k': topK,
        'min_p': minP,
        'typical_p': typicalP,
        'repetition_penalty': repetitionPenalty,
        'repetition_penalty_range': repetitionPenaltyRange,
        'frequency_penalty': frequencyPenalty,
        'presence_penalty': presencePenalty,
        'tfs': tailFreeSampling,
        'top_a': topA,
        'mirostat_mode': mirostatMode,
        'mirostat_tau': mirostatTau,
        'mirostat_eta': mirostatEta,
        'openai_max_tokens': maxTokens,
        'stop_sequences': stopSequences,
        'seed': seed,
        'stream_openai': streamEnabled,
      };

  /// Parse from JSON (supports both snake_case and camelCase for compatibility)
  factory GenerationPreset.fromJson(Map<String, dynamic> json) {
    return GenerationPreset(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 1.0,
      // Support both snake_case (SillyTavern) and camelCase (legacy)
      topP: (json['top_p'] as num?)?.toDouble() ??
            (json['topP'] as num?)?.toDouble() ?? 1.0,
      topK: (json['top_k'] as num?)?.toInt() ??
            (json['topK'] as num?)?.toInt() ?? 0,
      minP: (json['min_p'] as num?)?.toDouble() ??
            (json['minP'] as num?)?.toDouble() ?? 0.0,
      typicalP: (json['typical_p'] as num?)?.toDouble() ??
                (json['typicalP'] as num?)?.toDouble() ?? 1.0,
      repetitionPenalty: (json['repetition_penalty'] as num?)?.toDouble() ??
                         (json['repetitionPenalty'] as num?)?.toDouble() ?? 1.0,
      repetitionPenaltyRange: (json['repetition_penalty_range'] as num?)?.toInt() ??
                              (json['repetitionPenaltyRange'] as num?)?.toInt() ?? 0,
      frequencyPenalty: (json['frequency_penalty'] as num?)?.toDouble() ??
                        (json['frequencyPenalty'] as num?)?.toDouble() ?? 0.0,
      presencePenalty: (json['presence_penalty'] as num?)?.toDouble() ??
                       (json['presencePenalty'] as num?)?.toDouble() ?? 0.0,
      tailFreeSampling: (json['tfs'] as num?)?.toDouble() ??
                        (json['tailFreeSampling'] as num?)?.toDouble() ?? 1.0,
      topA: (json['top_a'] as num?)?.toDouble() ??
            (json['topA'] as num?)?.toDouble() ?? 0.0,
      mirostatMode: (json['mirostat_mode'] as num?)?.toInt() ??
                    (json['mirostatMode'] as num?)?.toInt() ?? 0,
      mirostatTau: (json['mirostat_tau'] as num?)?.toDouble() ??
                   (json['mirostatTau'] as num?)?.toDouble() ?? 5.0,
      mirostatEta: (json['mirostat_eta'] as num?)?.toDouble() ??
                   (json['mirostatEta'] as num?)?.toDouble() ?? 0.1,
      maxTokens: (json['openai_max_tokens'] as num?)?.toInt() ??
                 (json['max_tokens'] as num?)?.toInt() ??
                 (json['maxTokens'] as num?)?.toInt() ?? 512,
      stopSequences: (json['stop_sequences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['stopSequences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      seed: (json['seed'] as num?)?.toInt() ?? -1,
      streamEnabled: json['stream_openai'] as bool? ??
                     json['streamEnabled'] as bool? ?? true,
    );
  }

  /// Alias for fromJson - both now support SillyTavern format
  factory GenerationPreset.fromSillyTavernJson(Map<String, dynamic> json) {
    return GenerationPreset.fromJson(json);
  }
}

/// Built-in AI presets
class BuiltInAIPresets {
  static final defaultPreset = AIPreset(
    id: 'default',
    name: 'Default',
    description: 'Balanced settings for general use',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    generationSettings: const GenerationPreset(
      temperature: 1.0,
      topP: 0.95,
      topK: 40,
      maxTokens: 512,
    ),
  );

  static final creative = AIPreset(
    id: 'creative',
    name: 'Creative',
    description: 'Higher temperature for more creative responses',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    generationSettings: const GenerationPreset(
      temperature: 1.3,
      topP: 0.98,
      topK: 100,
      minP: 0.05,
      maxTokens: 1024,
    ),
  );

  static final precise = AIPreset(
    id: 'precise',
    name: 'Precise',
    description: 'Lower temperature for more focused responses',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    generationSettings: const GenerationPreset(
      temperature: 0.7,
      topP: 0.9,
      topK: 20,
      maxTokens: 512,
    ),
  );

  static final deterministic = AIPreset(
    id: 'deterministic',
    name: 'Deterministic',
    description: 'Very low randomness for consistent outputs',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    generationSettings: const GenerationPreset(
      temperature: 0.1,
      topP: 0.5,
      topK: 10,
      maxTokens: 512,
      seed: 42,
    ),
  );

  static final longform = AIPreset(
    id: 'longform',
    name: 'Long Form',
    description: 'Optimized for longer responses',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    generationSettings: const GenerationPreset(
      temperature: 0.9,
      topP: 0.95,
      topK: 40,
      maxTokens: 2048,
      repetitionPenalty: 1.15,
    ),
  );

  static final mirostat = AIPreset(
    id: 'mirostat',
    name: 'Mirostat',
    description: 'Uses Mirostat sampling for adaptive perplexity',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
    generationSettings: const GenerationPreset(
      temperature: 1.0,
      mirostatMode: 2,
      mirostatTau: 5.0,
      mirostatEta: 0.1,
      maxTokens: 512,
    ),
  );

  static final List<AIPreset> all = [
    defaultPreset,
    creative,
    precise,
    deterministic,
    longform,
    mirostat,
  ];
}