import 'package:freezed_annotation/freezed_annotation.dart';

part 'instruct_template.freezed.dart';
part 'instruct_template.g.dart';

/// Names behavior for instruct templates
enum InstructNamesBehavior {
  /// Don't include names
  none,
  /// Force names in all messages
  force,
  /// Always include names (even in system)
  always,
}

/// Instruct template model - defines how prompts are formatted for different models
@freezed
class InstructTemplate with _$InstructTemplate {
  const factory InstructTemplate({
    required String id,
    required String name,
    @Default('') String description,
    
    // === System prompt wrapping ===
    @Default('') String systemPrefix,
    @Default('') String systemSuffix,
    
    // === User message wrapping ===
    @Default('') String userPrefix,
    @Default('') String userSuffix,
    
    // === Assistant message wrapping ===
    @Default('') String assistantPrefix,
    @Default('') String assistantSuffix,
    
    // === First message handling ===
    /// Different format for first user message
    String? firstUserPrefix,
    String? firstUserSuffix,
    
    /// Different format for first assistant message
    String? firstAssistantPrefix,
    String? firstAssistantSuffix,
    
    // === Last message handling ===
    /// Different format for last user message (before generation)
    String? lastUserPrefix,
    String? lastUserSuffix,
    
    /// Different format for last assistant message
    String? lastAssistantPrefix,
    String? lastAssistantSuffix,
    
    // === Input/Output sequences (SillyTavern compatibility) ===
    /// Input sequence (alternative to userPrefix)
    @Default('') String inputSequence,
    /// Output sequence (alternative to assistantPrefix)
    @Default('') String outputSequence,
    /// First input sequence
    @Default('') String firstInputSequence,
    /// First output sequence
    @Default('') String firstOutputSequence,
    /// Last input sequence
    @Default('') String lastInputSequence,
    /// Last output sequence
    @Default('') String lastOutputSequence,
    
    // === Story string formatting ===
    /// Prefix for story string (character description, scenario, etc.)
    @Default('') String storyStringPrefix,
    /// Suffix for story string
    @Default('') String storyStringSuffix,
    
    // === Chat formatting ===
    /// Separator between chat messages
    @Default('') String chatSeparator,
    /// String to mark start of chat
    @Default('') String chatStart,
    
    // === User alignment message ===
    /// Message to align user expectations (inserted before first user message)
    @Default('') String userAlignmentMessage,
    
    // === Stop sequences ===
    @Default([]) List<String> stopSequences,
    
    // === Behavior options ===
    /// Whether this is a built-in template
    @Default(false) bool isBuiltIn,
    
    /// Whether this is the default template
    @Default(false) bool isDefault,
    
    /// Regex pattern for auto-activation based on model name
    String? activationRegex,
    
    /// Whether to bind to context (use context template settings)
    @Default(false) bool bindToContext,
    
    /// Whether to skip example messages
    @Default(false) bool skipExamples,
    
    /// Names behavior (none, force, always)
    @Default(InstructNamesBehavior.none) InstructNamesBehavior namesBehavior,
    
    /// Whether system messages use same format as user
    @Default(false) bool systemSameAsUser,
    
    /// Whether to use sequences as stop strings
    @Default(true) bool sequencesAsStopStrings,
    
    /// Whether to enable macro substitution in sequences
    @Default(true) bool macroSubstitution,
    
    /// Whether to wrap sequences in newlines
    @Default(true) bool wrapInNewlines,
    
    /// Whether to include names in prompts
    @Default(false) bool includeNames,
    
    /// Format string for names (e.g., "{{name}}: ")
    @Default('{{name}}: ') String nameFormat,
    
    /// Whether to force names for all messages
    @Default(false) bool forceNames,
    
    // === Timestamps ===
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InstructTemplate;

  factory InstructTemplate.fromJson(Map<String, dynamic> json) =>
      _$InstructTemplateFromJson(json);
}

/// Extension methods for InstructTemplate
extension InstructTemplateExtension on InstructTemplate {
  /// Get effective user prefix (considering first/last message)
  String getEffectiveUserPrefix({bool isFirst = false, bool isLast = false}) {
    if (isFirst && firstUserPrefix != null && firstUserPrefix!.isNotEmpty) {
      return firstUserPrefix!;
    }
    if (isLast && lastUserPrefix != null && lastUserPrefix!.isNotEmpty) {
      return lastUserPrefix!;
    }
    if (inputSequence.isNotEmpty) {
      return inputSequence;
    }
    return userPrefix;
  }
  
  /// Get effective user suffix (considering first/last message)
  String getEffectiveUserSuffix({bool isFirst = false, bool isLast = false}) {
    if (isFirst && firstUserSuffix != null && firstUserSuffix!.isNotEmpty) {
      return firstUserSuffix!;
    }
    if (isLast && lastUserSuffix != null && lastUserSuffix!.isNotEmpty) {
      return lastUserSuffix!;
    }
    return userSuffix;
  }
  
  /// Get effective assistant prefix (considering first/last message)
  String getEffectiveAssistantPrefix({bool isFirst = false, bool isLast = false}) {
    if (isFirst && firstAssistantPrefix != null && firstAssistantPrefix!.isNotEmpty) {
      return firstAssistantPrefix!;
    }
    if (isLast && lastAssistantPrefix != null && lastAssistantPrefix!.isNotEmpty) {
      return lastAssistantPrefix!;
    }
    if (outputSequence.isNotEmpty) {
      return outputSequence;
    }
    return assistantPrefix;
  }
  
  /// Get effective assistant suffix (considering first/last message)
  String getEffectiveAssistantSuffix({bool isFirst = false, bool isLast = false}) {
    if (isFirst && firstAssistantSuffix != null && firstAssistantSuffix!.isNotEmpty) {
      return firstAssistantSuffix!;
    }
    if (isLast && lastAssistantSuffix != null && lastAssistantSuffix!.isNotEmpty) {
      return lastAssistantSuffix!;
    }
    return assistantSuffix;
  }
  
  /// Get effective system prefix (considering systemSameAsUser)
  String getEffectiveSystemPrefix() {
    if (systemSameAsUser) {
      return userPrefix;
    }
    return systemPrefix;
  }
  
  /// Get effective system suffix (considering systemSameAsUser)
  String getEffectiveSystemSuffix() {
    if (systemSameAsUser) {
      return userSuffix;
    }
    return systemSuffix;
  }
  
  /// Check if this template should be auto-activated for a model
  bool shouldActivateForModel(String modelName) {
    if (activationRegex == null || activationRegex!.isEmpty) {
      return false;
    }
    try {
      final regex = RegExp(activationRegex!, caseSensitive: false);
      return regex.hasMatch(modelName);
    } catch (_) {
      return false;
    }
  }
  
  /// Get all stop sequences (including sequences if enabled)
  List<String> getAllStopSequences() {
    final stops = List<String>.from(stopSequences);
    if (sequencesAsStopStrings) {
      // Add prefixes as stop sequences
      if (userPrefix.isNotEmpty) stops.add(userPrefix.trim());
      if (assistantPrefix.isNotEmpty) stops.add(assistantPrefix.trim());
      if (inputSequence.isNotEmpty) stops.add(inputSequence.trim());
      if (outputSequence.isNotEmpty) stops.add(outputSequence.trim());
    }
    return stops.toSet().toList(); // Remove duplicates
  }
}

/// Built-in instruct templates
class BuiltInTemplates {
  static final chatML = InstructTemplate(
    id: 'chatml',
    name: 'ChatML',
    description: 'OA Compatible ChatML format used by many models',
    systemPrefix: '<|im_start|>system\n',
    systemSuffix: '<|im_end|>\n',
    userPrefix: '<|im_start|>user\n',
    userSuffix: '<|im_end|>\n',
    assistantPrefix: '<|im_start|>assistant\n',
    assistantSuffix: '<|im_end|>\n',
    stopSequences: ['<|im_end|>', '<|im_start|>'],
    activationRegex: r'(qwen|yi-|deepseek)',
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
    activationRegex: r'llama-?2',
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
    activationRegex: r'llama-?3',
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
    activationRegex: r'mistral|mixtral',
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
    activationRegex: r'vicuna',
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
    activationRegex: r'command-?r',
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
    activationRegex: r'gemma',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final phi3 = InstructTemplate(
    id: 'phi3',
    name: 'Phi-3',
    description: 'Microsoft Phi-3 instruct format',
    systemPrefix: '<|system|>\n',
    systemSuffix: '<|end|>\n',
    userPrefix: '<|user|>\n',
    userSuffix: '<|end|>\n',
    assistantPrefix: '<|assistant|>\n',
    assistantSuffix: '<|end|>\n',
    stopSequences: ['<|end|>', '<|user|>', '<|assistant|>'],
    activationRegex: r'phi-?3',
    isBuiltIn: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final none = InstructTemplate(
    id: 'none',
    name: 'None (API Default)',
    description: 'No formatting - use API default (for OACompatible, Claude, etc.)',
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
        phi3,
      ];

  static InstructTemplate? getById(String id) {
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
  
  /// Find best matching template for a model name
  static InstructTemplate? findForModel(String modelName) {
    for (final template in all) {
      if (template.shouldActivateForModel(modelName)) {
        return template;
      }
    }
    return null;
  }
}

/// SillyTavern instruct template import/export format
@freezed
class InstructTemplateExport with _$InstructTemplateExport {
  const factory InstructTemplateExport({
    required String name,
    @JsonKey(name: 'system_prompt') @Default('') String systemPrompt,
    @JsonKey(name: 'input_sequence') @Default('') String inputSequence,
    @JsonKey(name: 'output_sequence') @Default('') String outputSequence,
    @JsonKey(name: 'first_output_sequence') @Default('') String firstOutputSequence,
    @JsonKey(name: 'last_output_sequence') @Default('') String lastOutputSequence,
    @JsonKey(name: 'system_sequence') @Default('') String systemSequence,
    @JsonKey(name: 'stop_sequence') @Default('') String stopSequence,
    @JsonKey(name: 'separator_sequence') @Default('') String separatorSequence,
    @JsonKey(name: 'wrap') @Default(true) bool wrap,
    @JsonKey(name: 'macro') @Default(true) bool macro,
    @JsonKey(name: 'names') @Default(false) bool names,
    @JsonKey(name: 'names_force_groups') @Default(true) bool namesForceGroups,
    @JsonKey(name: 'activation_regex') @Default('') String activationRegex,
    @JsonKey(name: 'skip_examples') @Default(false) bool skipExamples,
    @JsonKey(name: 'output_suffix') @Default('') String outputSuffix,
    @JsonKey(name: 'input_suffix') @Default('') String inputSuffix,
    @JsonKey(name: 'system_suffix') @Default('') String systemSuffix,
    @JsonKey(name: 'user_alignment_message') @Default('') String userAlignmentMessage,
    @JsonKey(name: 'system_same_as_user') @Default(false) bool systemSameAsUser,
    @JsonKey(name: 'last_system_sequence') @Default('') String lastSystemSequence,
    @JsonKey(name: 'first_input_sequence') @Default('') String firstInputSequence,
    @JsonKey(name: 'last_input_sequence') @Default('') String lastInputSequence,
  }) = _InstructTemplateExport;

  factory InstructTemplateExport.fromJson(Map<String, dynamic> json) =>
      _$InstructTemplateExportFromJson(json);
}

/// Convert InstructTemplate to export format
InstructTemplateExport instructTemplateToExport(InstructTemplate template) {
  return InstructTemplateExport(
    name: template.name,
    inputSequence: template.inputSequence.isNotEmpty 
        ? template.inputSequence 
        : template.userPrefix,
    outputSequence: template.outputSequence.isNotEmpty 
        ? template.outputSequence 
        : template.assistantPrefix,
    firstOutputSequence: template.firstAssistantPrefix ?? '',
    lastOutputSequence: template.lastAssistantPrefix ?? '',
    systemSequence: template.systemPrefix,
    stopSequence: template.stopSequences.join(','),
    separatorSequence: template.chatSeparator,
    wrap: template.wrapInNewlines,
    macro: template.macroSubstitution,
    names: template.includeNames,
    namesForceGroups: template.forceNames,
    activationRegex: template.activationRegex ?? '',
    skipExamples: template.skipExamples,
    outputSuffix: template.assistantSuffix,
    inputSuffix: template.userSuffix,
    systemSuffix: template.systemSuffix,
    userAlignmentMessage: template.userAlignmentMessage,
    systemSameAsUser: template.systemSameAsUser,
    firstInputSequence: template.firstUserPrefix ?? '',
    lastInputSequence: template.lastUserPrefix ?? '',
  );
}

/// Convert export format to InstructTemplate
InstructTemplate instructTemplateFromExport(
  InstructTemplateExport export,
  String id,
) {
  return InstructTemplate(
    id: id,
    name: export.name,
    description: '',
    systemPrefix: export.systemSequence,
    systemSuffix: export.systemSuffix,
    userPrefix: export.inputSequence,
    userSuffix: export.inputSuffix,
    assistantPrefix: export.outputSequence,
    assistantSuffix: export.outputSuffix,
    firstUserPrefix: export.firstInputSequence.isNotEmpty ? export.firstInputSequence : null,
    lastUserPrefix: export.lastInputSequence.isNotEmpty ? export.lastInputSequence : null,
    firstAssistantPrefix: export.firstOutputSequence.isNotEmpty ? export.firstOutputSequence : null,
    lastAssistantPrefix: export.lastOutputSequence.isNotEmpty ? export.lastOutputSequence : null,
    inputSequence: export.inputSequence,
    outputSequence: export.outputSequence,
    firstInputSequence: export.firstInputSequence,
    firstOutputSequence: export.firstOutputSequence,
    lastInputSequence: export.lastInputSequence,
    lastOutputSequence: export.lastOutputSequence,
    chatSeparator: export.separatorSequence,
    userAlignmentMessage: export.userAlignmentMessage,
    stopSequences: export.stopSequence.isNotEmpty 
        ? export.stopSequence.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
        : [],
    activationRegex: export.activationRegex.isNotEmpty ? export.activationRegex : null,
    skipExamples: export.skipExamples,
    systemSameAsUser: export.systemSameAsUser,
    wrapInNewlines: export.wrap,
    macroSubstitution: export.macro,
    includeNames: export.names,
    forceNames: export.namesForceGroups,
    isBuiltIn: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
