// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persona.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonaConnectionImpl _$$PersonaConnectionImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonaConnectionImpl(
      characterId: json['characterId'] as String?,
      groupId: json['groupId'] as String?,
      lockType:
          $enumDecodeNullable(_$PersonaLockTypeEnumMap, json['lockType']) ??
              PersonaLockType.none,
    );

Map<String, dynamic> _$$PersonaConnectionImplToJson(
        _$PersonaConnectionImpl instance) =>
    <String, dynamic>{
      'characterId': instance.characterId,
      'groupId': instance.groupId,
      'lockType': _$PersonaLockTypeEnumMap[instance.lockType]!,
    };

const _$PersonaLockTypeEnumMap = {
  PersonaLockType.none: 'none',
  PersonaLockType.chat: 'chat',
  PersonaLockType.character: 'character',
  PersonaLockType.defaultLock: 'defaultLock',
};

_$PersonaDescriptionSettingsImpl _$$PersonaDescriptionSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PersonaDescriptionSettingsImpl(
      position: $enumDecodeNullable(
              _$PersonaDescriptionPositionEnumMap, json['position']) ??
          PersonaDescriptionPosition.beforeChar,
      depth: (json['depth'] as num?)?.toInt() ?? 0,
      role:
          $enumDecodeNullable(_$PersonaDescriptionRoleEnumMap, json['role']) ??
              PersonaDescriptionRole.system,
    );

Map<String, dynamic> _$$PersonaDescriptionSettingsImplToJson(
        _$PersonaDescriptionSettingsImpl instance) =>
    <String, dynamic>{
      'position': _$PersonaDescriptionPositionEnumMap[instance.position]!,
      'depth': instance.depth,
      'role': _$PersonaDescriptionRoleEnumMap[instance.role]!,
    };

const _$PersonaDescriptionPositionEnumMap = {
  PersonaDescriptionPosition.beforeChar: 'beforeChar',
  PersonaDescriptionPosition.afterChar: 'afterChar',
  PersonaDescriptionPosition.atDepth: 'atDepth',
  PersonaDescriptionPosition.inSystemPrompt: 'inSystemPrompt',
  PersonaDescriptionPosition.topAN: 'topAN',
  PersonaDescriptionPosition.bottomAN: 'bottomAN',
};

const _$PersonaDescriptionRoleEnumMap = {
  PersonaDescriptionRole.system: 'system',
  PersonaDescriptionRole.user: 'user',
  PersonaDescriptionRole.assistant: 'assistant',
};

_$PersonaImpl _$$PersonaImplFromJson(Map<String, dynamic> json) =>
    _$PersonaImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      avatarPath: json['avatarPath'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      connections: (json['connections'] as List<dynamic>?)
              ?.map(
                  (e) => PersonaConnection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      descriptionSettings: json['descriptionSettings'] == null
          ? const PersonaDescriptionSettings()
          : PersonaDescriptionSettings.fromJson(
              json['descriptionSettings'] as Map<String, dynamic>),
      lorebookId: json['lorebookId'] as String?,
      systemPromptOverride: json['systemPromptOverride'] as String?,
      postHistoryInstructions: json['postHistoryInstructions'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      creatorNotes: json['creatorNotes'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$PersonaImplToJson(_$PersonaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'avatarPath': instance.avatarPath,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'connections': instance.connections,
      'descriptionSettings': instance.descriptionSettings,
      'lorebookId': instance.lorebookId,
      'systemPromptOverride': instance.systemPromptOverride,
      'postHistoryInstructions': instance.postHistoryInstructions,
      'tags': instance.tags,
      'creatorNotes': instance.creatorNotes,
      'isFavorite': instance.isFavorite,
    };
