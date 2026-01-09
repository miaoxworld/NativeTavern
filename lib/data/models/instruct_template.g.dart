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
      firstAssistantPrefix: json['firstAssistantPrefix'] as String?,
      firstAssistantSuffix: json['firstAssistantSuffix'] as String?,
      stopSequences: (json['stopSequences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
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
      'firstAssistantPrefix': instance.firstAssistantPrefix,
      'firstAssistantSuffix': instance.firstAssistantSuffix,
      'stopSequences': instance.stopSequences,
      'isBuiltIn': instance.isBuiltIn,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
