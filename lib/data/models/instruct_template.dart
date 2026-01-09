import 'package:freezed_annotation/freezed_annotation.dart';

part 'instruct_template.freezed.dart';
part 'instruct_template.g.dart';

/// Instruct template model - defines how prompts are formatted for different models
@freezed
class InstructTemplate with _$InstructTemplate {
  const factory InstructTemplate({
    required String id,
    required String name,
    @Default('') String description,
    
    // System prompt wrapping
    @Default('') String systemPrefix,
    @Default('') String systemSuffix,
    
    // User message wrapping
    @Default('') String userPrefix,
    @Default('') String userSuffix,
    
    // Assistant message wrapping
    @Default('') String assistantPrefix,
    @Default('') String assistantSuffix,
    
    // First message handling (optional different format for first assistant message)
    String? firstAssistantPrefix,
    String? firstAssistantSuffix,
    
    // Stop sequences
    @Default([]) List<String> stopSequences,
    
    // Whether this is a built-in template
    @Default(false) bool isBuiltIn,
    
    // Whether this is the default template
    @Default(false) bool isDefault,
    
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InstructTemplate;

  factory InstructTemplate.fromJson(Map<String, dynamic> json) =>
      _$InstructTemplateFromJson(json);
}

/// Built-in instruct templates
class BuiltInTemplates {
  static final chatML = InstructTemplate(
    id: 'chatml',
    name: 'ChatML',
    description: 'OpenAI ChatML format used by many models',
    systemPrefix: '<|im_start|>system\n',
    systemSuffix: '<|im_end|>\n',
    userPrefix: '<|im_start|>user\n',
    userSuffix: '<|im_end|>\n',
    assistantPrefix: '<|im_start|>assistant\n',
    assistantSuffix: '<|im_end|>\n',
    stopSequences: ['<|im_end|>', '<|im_start|>'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final alpaca = InstructTemplate(
    id: 'alpaca',
    name: 'Alpaca',
    description: 'Stanford Alpaca instruction format',
    systemPrefix: '### Instruction:\n',
    systemSuffix: '\n\n',
    userPrefix: '### Input:\n',
    userSuffix: '\n\n',
    assistantPrefix: '### Response:\n',
    assistantSuffix: '\n\n',
    stopSequences: ['### Instruction:', '### Input:', '### Response:'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final llama2Chat = InstructTemplate(
    id: 'llama2-chat',
    name: 'Llama 2 Chat',
    description: 'Meta Llama 2 chat format',
    systemPrefix: '[INST] <<SYS>>\n',
    systemSuffix: '\n<</SYS>>\n\n',
    userPrefix: '',
    userSuffix: ' [/INST] ',
    assistantPrefix: '',
    assistantSuffix: ' </s><s>[INST] ',
    firstAssistantPrefix: '',
    firstAssistantSuffix: ' </s><s>[INST] ',
    stopSequences: ['[INST]', '[/INST]', '</s>'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final llama3 = InstructTemplate(
    id: 'llama3',
    name: 'Llama 3',
    description: 'Meta Llama 3 instruct format',
    systemPrefix: '<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\n',
    systemSuffix: '<|eot_id|>',
    userPrefix: '<|start_header_id|>user<|end_header_id|>\n\n',
    userSuffix: '<|eot_id|>',
    assistantPrefix: '<|start_header_id|>assistant<|end_header_id|>\n\n',
    assistantSuffix: '<|eot_id|>',
    stopSequences: ['<|eot_id|>', '<|end_of_text|>'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final mistral = InstructTemplate(
    id: 'mistral',
    name: 'Mistral Instruct',
    description: 'Mistral AI instruct format',
    systemPrefix: '[INST] ',
    systemSuffix: '\n',
    userPrefix: '',
    userSuffix: ' [/INST]',
    assistantPrefix: '',
    assistantSuffix: '</s> [INST] ',
    stopSequences: ['[INST]', '[/INST]', '</s>'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final vicuna = InstructTemplate(
    id: 'vicuna',
    name: 'Vicuna',
    description: 'Vicuna/ShareGPT format',
    systemPrefix: '',
    systemSuffix: '\n\n',
    userPrefix: 'USER: ',
    userSuffix: '\n',
    assistantPrefix: 'ASSISTANT: ',
    assistantSuffix: '\n',
    stopSequences: ['USER:', 'ASSISTANT:'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final commandR = InstructTemplate(
    id: 'command-r',
    name: 'Command R',
    description: 'Cohere Command R format',
    systemPrefix: '<|START_OF_TURN_TOKEN|><|SYSTEM_TOKEN|>',
    systemSuffix: '<|END_OF_TURN_TOKEN|>',
    userPrefix: '<|START_OF_TURN_TOKEN|><|USER_TOKEN|>',
    userSuffix: '<|END_OF_TURN_TOKEN|>',
    assistantPrefix: '<|START_OF_TURN_TOKEN|><|CHATBOT_TOKEN|>',
    assistantSuffix: '<|END_OF_TURN_TOKEN|>',
    stopSequences: ['<|END_OF_TURN_TOKEN|>'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final gemma = InstructTemplate(
    id: 'gemma',
    name: 'Gemma',
    description: 'Google Gemma instruct format',
    systemPrefix: '<start_of_turn>user\n',
    systemSuffix: '\n',
    userPrefix: '',
    userSuffix: '<end_of_turn>\n',
    assistantPrefix: '<start_of_turn>model\n',
    assistantSuffix: '<end_of_turn>\n',
    stopSequences: ['<end_of_turn>', '<start_of_turn>'],
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final none = InstructTemplate(
    id: 'none',
    name: 'None (API Default)',
    description: 'No formatting - use API default (for OpenAI, Claude, etc.)',
    systemPrefix: '',
    systemSuffix: '',
    userPrefix: '',
    userSuffix: '',
    assistantPrefix: '',
    assistantSuffix: '',
    stopSequences: [],
    isBuiltIn: true,
    isDefault: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static List<InstructTemplate> get all => [
        none,
        chatML,
        alpaca,
        llama2Chat,
        llama3,
        mistral,
        vicuna,
        commandR,
        gemma,
      ];

  static InstructTemplate? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}