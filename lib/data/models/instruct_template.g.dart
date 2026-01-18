// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruct_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstructTemplateImpl _$$InstructTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$InstructTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      systemPrefix: json['systemPrefix'] as String? ?? '',
      systemSuffix: json['systemSuffix'] as String? ?? '',
      userPrefix: json['userPrefix'] as String? ?? '',
      userSuffix: json['userSuffix'] as String? ?? '',
      assistantPrefix: json['assistantPrefix'] as String? ?? '',
      assistantSuffix: json['assistantSuffix'] as String? ?? '',
      firstUserPrefix: json['firstUserPrefix'] as String?,
      firstUserSuffix: json['firstUserSuffix'] as String?,
      firstAssistantPrefix: json['firstAssistantPrefix'] as String?,
      firstAssistantSuffix: json['firstAssistantSuffix'] as String?,
      lastUserPrefix: json['lastUserPrefix'] as String?,
      lastUserSuffix: json['lastUserSuffix'] as String?,
      lastAssistantPrefix: json['lastAssistantPrefix'] as String?,
      lastAssistantSuffix: json['lastAssistantSuffix'] as String?,
      inputSequence: json['inputSequence'] as String? ?? '',
      outputSequence: json['outputSequence'] as String? ?? '',
      firstInputSequence: json['firstInputSequence'] as String? ?? '',
      firstOutputSequence: json['firstOutputSequence'] as String? ?? '',
      lastInputSequence: json['lastInputSequence'] as String? ?? '',
      lastOutputSequence: json['lastOutputSequence'] as String? ?? '',
      storyStringPrefix: json['storyStringPrefix'] as String? ?? '',
      storyStringSuffix: json['storyStringSuffix'] as String? ?? '',
      chatSeparator: json['chatSeparator'] as String? ?? '',
      chatStart: json['chatStart'] as String? ?? '',
      userAlignmentMessage: json['userAlignmentMessage'] as String? ?? '',
      stopSequences: (json['stopSequences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      activationRegex: json['activationRegex'] as String?,
      bindToContext: json['bindToContext'] as bool? ?? false,
      skipExamples: json['skipExamples'] as bool? ?? false,
      namesBehavior: $enumDecodeNullable(
              _$InstructNamesBehaviorEnumMap, json['namesBehavior']) ??
          InstructNamesBehavior.none,
      systemSameAsUser: json['systemSameAsUser'] as bool? ?? false,
      sequencesAsStopStrings: json['sequencesAsStopStrings'] as bool? ?? true,
      macroSubstitution: json['macroSubstitution'] as bool? ?? true,
      wrapInNewlines: json['wrapInNewlines'] as bool? ?? true,
      includeNames: json['includeNames'] as bool? ?? false,
      nameFormat: json['nameFormat'] as String? ?? '{{name}}: ',
      forceNames: json['forceNames'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$InstructTemplateImplToJson(
        _$InstructTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'systemPrefix': instance.systemPrefix,
      'systemSuffix': instance.systemSuffix,
      'userPrefix': instance.userPrefix,
      'userSuffix': instance.userSuffix,
      'assistantPrefix': instance.assistantPrefix,
      'assistantSuffix': instance.assistantSuffix,
      'firstUserPrefix': instance.firstUserPrefix,
      'firstUserSuffix': instance.firstUserSuffix,
      'firstAssistantPrefix': instance.firstAssistantPrefix,
      'firstAssistantSuffix': instance.firstAssistantSuffix,
      'lastUserPrefix': instance.lastUserPrefix,
      'lastUserSuffix': instance.lastUserSuffix,
      'lastAssistantPrefix': instance.lastAssistantPrefix,
      'lastAssistantSuffix': instance.lastAssistantSuffix,
      'inputSequence': instance.inputSequence,
      'outputSequence': instance.outputSequence,
      'firstInputSequence': instance.firstInputSequence,
      'firstOutputSequence': instance.firstOutputSequence,
      'lastInputSequence': instance.lastInputSequence,
      'lastOutputSequence': instance.lastOutputSequence,
      'storyStringPrefix': instance.storyStringPrefix,
      'storyStringSuffix': instance.storyStringSuffix,
      'chatSeparator': instance.chatSeparator,
      'chatStart': instance.chatStart,
      'userAlignmentMessage': instance.userAlignmentMessage,
      'stopSequences': instance.stopSequences,
      'isBuiltIn': instance.isBuiltIn,
      'isDefault': instance.isDefault,
      'activationRegex': instance.activationRegex,
      'bindToContext': instance.bindToContext,
      'skipExamples': instance.skipExamples,
      'namesBehavior': _$InstructNamesBehaviorEnumMap[instance.namesBehavior]!,
      'systemSameAsUser': instance.systemSameAsUser,
      'sequencesAsStopStrings': instance.sequencesAsStopStrings,
      'macroSubstitution': instance.macroSubstitution,
      'wrapInNewlines': instance.wrapInNewlines,
      'includeNames': instance.includeNames,
      'nameFormat': instance.nameFormat,
      'forceNames': instance.forceNames,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$InstructNamesBehaviorEnumMap = {
  InstructNamesBehavior.none: 'none',
  InstructNamesBehavior.force: 'force',
  InstructNamesBehavior.always: 'always',
};

_$InstructTemplateExportImpl _$$InstructTemplateExportImplFromJson(
        Map<String, dynamic> json) =>
    _$InstructTemplateExportImpl(
      name: json['name'] as String,
      systemPrompt: json['system_prompt'] as String? ?? '',
      inputSequence: json['input_sequence'] as String? ?? '',
      outputSequence: json['output_sequence'] as String? ?? '',
      firstOutputSequence: json['first_output_sequence'] as String? ?? '',
      lastOutputSequence: json['last_output_sequence'] as String? ?? '',
      systemSequence: json['system_sequence'] as String? ?? '',
      stopSequence: json['stop_sequence'] as String? ?? '',
      separatorSequence: json['separator_sequence'] as String? ?? '',
      wrap: json['wrap'] as bool? ?? true,
      macro: json['macro'] as bool? ?? true,
      names: json['names'] as bool? ?? false,
      namesForceGroups: json['names_force_groups'] as bool? ?? true,
      activationRegex: json['activation_regex'] as String? ?? '',
      skipExamples: json['skip_examples'] as bool? ?? false,
      outputSuffix: json['output_suffix'] as String? ?? '',
      inputSuffix: json['input_suffix'] as String? ?? '',
      systemSuffix: json['system_suffix'] as String? ?? '',
      userAlignmentMessage: json['user_alignment_message'] as String? ?? '',
      systemSameAsUser: json['system_same_as_user'] as bool? ?? false,
      lastSystemSequence: json['last_system_sequence'] as String? ?? '',
      firstInputSequence: json['first_input_sequence'] as String? ?? '',
      lastInputSequence: json['last_input_sequence'] as String? ?? '',
    );

Map<String, dynamic> _$$InstructTemplateExportImplToJson(
        _$InstructTemplateExportImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'system_prompt': instance.systemPrompt,
      'input_sequence': instance.inputSequence,
      'output_sequence': instance.outputSequence,
      'first_output_sequence': instance.firstOutputSequence,
      'last_output_sequence': instance.lastOutputSequence,
      'system_sequence': instance.systemSequence,
      'stop_sequence': instance.stopSequence,
      'separator_sequence': instance.separatorSequence,
      'wrap': instance.wrap,
      'macro': instance.macro,
      'names': instance.names,
      'names_force_groups': instance.namesForceGroups,
      'activation_regex': instance.activationRegex,
      'skip_examples': instance.skipExamples,
      'output_suffix': instance.outputSuffix,
      'input_suffix': instance.inputSuffix,
      'system_suffix': instance.systemSuffix,
      'user_alignment_message': instance.userAlignmentMessage,
      'system_same_as_user': instance.systemSameAsUser,
      'last_system_sequence': instance.lastSystemSequence,
      'first_input_sequence': instance.firstInputSequence,
      'last_input_sequence': instance.lastInputSequence,
    };
