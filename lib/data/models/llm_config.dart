import 'package:freezed_annotation/freezed_annotation.dart';

part 'llm_config.freezed.dart';
part 'llm_config.g.dart';

/// LLM Provider types
enum LLMProvider {
  @JsonValue('openai')
  openai,
  @JsonValue('claude')
  claude,
  @JsonValue('openrouter')
  openrouter,
  @JsonValue('gemini')
  gemini,
  @JsonValue('mistral')
  mistral,
  @JsonValue('ollama')
  ollama,
  @JsonValue('koboldcpp')
  koboldcpp,
  @JsonValue('llamacpp')
  llamacpp,
  @JsonValue('local')
  local, // On-device llama.cpp
  @JsonValue('custom')
  custom,
}

/// LLM Connection configuration
@freezed
class LLMConfig with _$LLMConfig {
  const factory LLMConfig({
    required String id,
    required String name,
    required LLMProvider provider,
    required String endpoint,
    String? apiKey,
    String? model,
    @Default(true) bool enabled,
    @Default(false) bool isDefault,
    GenerationSettings? defaultSettings,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) = _LLMConfig;

  factory LLMConfig.fromJson(Map<String, dynamic> json) => _$LLMConfigFromJson(json);
}

/// Generation settings / sampler parameters
@freezed
class GenerationSettings with _$GenerationSettings {
  const factory GenerationSettings({
    @Default(0.7) double temperature,
    @Default(0.9) double topP,
    @Default(40) int topK,
    @Default(0.0) double minP,
    @Default(1.0) double typicalP,
    @Default(1.1) double repetitionPenalty,
    @Default(0.0) double frequencyPenalty,
    @Default(0.0) double presencePenalty,
    @Default(512) int maxTokens,
    @Default(4096) int contextLength,
    @Default([]) List<String> stopSequences,
    @Default(false) bool stream,
    int? seed,
    
    // Additional parameters for specific providers
    @Default({}) Map<String, dynamic> extra,
  }) = _GenerationSettings;

  factory GenerationSettings.fromJson(Map<String, dynamic> json) => _$GenerationSettingsFromJson(json);
}

/// Local model configuration for on-device inference
@freezed
class LocalModelConfig with _$LocalModelConfig {
  const factory LocalModelConfig({
    required String id,
    required String name,
    required String filePath,
    required int fileSize,
    String? description,
    @Default(1000000) int contextLength,
    @Default(512) int batchSize,
    @Default(0) int gpuLayers, // For Metal/Vulkan acceleration
    @Default(4) int threads,
    @Default(false) bool useMmap,
    @Default(false) bool useMlock,
    String? chatTemplate,
    DateTime? downloadedAt,
  }) = _LocalModelConfig;

  factory LocalModelConfig.fromJson(Map<String, dynamic> json) => _$LocalModelConfigFromJson(json);
}

/// Prompt template for formatting messages
@freezed
class PromptTemplate with _$PromptTemplate {
  const factory PromptTemplate({
    required String id,
    required String name,
    required String systemPrefix,
    required String systemSuffix,
    required String userPrefix,
    required String userSuffix,
    required String assistantPrefix,
    required String assistantSuffix,
    @Default('') String firstMessagePrefix,
    @Default('') String lastMessageSuffix,
    @Default(false) bool wrapInNewlines,
  }) = _PromptTemplate;

  factory PromptTemplate.fromJson(Map<String, dynamic> json) => _$PromptTemplateFromJson(json);

  /// Common preset templates
  static const chatML = PromptTemplate(
    id: 'chatml',
    name: 'ChatML',
    systemPrefix: '<|im_start|>system\n',
    systemSuffix: '<|im_end|>\n',
    userPrefix: '<|im_start|>user\n',
    userSuffix: '<|im_end|>\n',
    assistantPrefix: '<|im_start|>assistant\n',
    assistantSuffix: '<|im_end|>\n',
  );

  static const llama2 = PromptTemplate(
    id: 'llama2',
    name: 'Llama 2',
    systemPrefix: '[INST] <<SYS>>\n',
    systemSuffix: '\n<</SYS>>\n\n',
    userPrefix: '',
    userSuffix: ' [/INST] ',
    assistantPrefix: '',
    assistantSuffix: ' </s><s>[INST] ',
  );

  static const alpaca = PromptTemplate(
    id: 'alpaca',
    name: 'Alpaca',
    systemPrefix: '### Instruction:\n',
    systemSuffix: '\n\n',
    userPrefix: '### Input:\n',
    userSuffix: '\n\n',
    assistantPrefix: '### Response:\n',
    assistantSuffix: '\n\n',
  );

  static const vicuna = PromptTemplate(
    id: 'vicuna',
    name: 'Vicuna',
    systemPrefix: '',
    systemSuffix: '\n\n',
    userPrefix: 'USER: ',
    userSuffix: '\n',
    assistantPrefix: 'ASSISTANT: ',
    assistantSuffix: '\n',
  );
}