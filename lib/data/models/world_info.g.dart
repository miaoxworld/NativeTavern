// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorldInfoCharacterFilterImpl _$$WorldInfoCharacterFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$WorldInfoCharacterFilterImpl(
      type: $enumDecodeNullable(
              _$WorldInfoCharacterFilterTypeEnumMap, json['type']) ??
          WorldInfoCharacterFilterType.none,
      characterIds: (json['characterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$WorldInfoCharacterFilterImplToJson(
        _$WorldInfoCharacterFilterImpl instance) =>
    <String, dynamic>{
      'type': _$WorldInfoCharacterFilterTypeEnumMap[instance.type]!,
      'characterIds': instance.characterIds,
      'tags': instance.tags,
    };

const _$WorldInfoCharacterFilterTypeEnumMap = {
  WorldInfoCharacterFilterType.none: 'none',
  WorldInfoCharacterFilterType.include: 'include',
  WorldInfoCharacterFilterType.exclude: 'exclude',
};

_$WorldInfoTimedEffectsImpl _$$WorldInfoTimedEffectsImplFromJson(
        Map<String, dynamic> json) =>
    _$WorldInfoTimedEffectsImpl(
      sticky: (json['sticky'] as num?)?.toInt() ?? 0,
      cooldown: (json['cooldown'] as num?)?.toInt() ?? 0,
      delay: (json['delay'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$WorldInfoTimedEffectsImplToJson(
        _$WorldInfoTimedEffectsImpl instance) =>
    <String, dynamic>{
      'sticky': instance.sticky,
      'cooldown': instance.cooldown,
      'delay': instance.delay,
    };

_$WorldInfoImpl _$$WorldInfoImplFromJson(Map<String, dynamic> json) =>
    _$WorldInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => WorldInfoEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      enabled: json['enabled'] as bool? ?? true,
      isGlobal: json['isGlobal'] as bool? ?? false,
      characterId: json['characterId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      defaultScanDepth: (json['defaultScanDepth'] as num?)?.toInt() ?? 4,
      recursiveScanning: json['recursiveScanning'] as bool? ?? true,
      maxRecursionDepth: (json['maxRecursionDepth'] as num?)?.toInt() ?? 3,
      allowEntryCascade: json['allowEntryCascade'] as bool? ?? true,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      creatorNotes: json['creatorNotes'] as String? ?? '',
    );

Map<String, dynamic> _$$WorldInfoImplToJson(_$WorldInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'entries': instance.entries,
      'enabled': instance.enabled,
      'isGlobal': instance.isGlobal,
      'characterId': instance.characterId,
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
      'defaultScanDepth': instance.defaultScanDepth,
      'recursiveScanning': instance.recursiveScanning,
      'maxRecursionDepth': instance.maxRecursionDepth,
      'allowEntryCascade': instance.allowEntryCascade,
      'tags': instance.tags,
      'creatorNotes': instance.creatorNotes,
    };

_$WorldInfoEntryImpl _$$WorldInfoEntryImplFromJson(Map<String, dynamic> json) =>
    _$WorldInfoEntryImpl(
      id: json['id'] as String,
      worldInfoId: json['worldInfoId'] as String,
      keys:
          (json['keys'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      secondaryKeys: (json['secondaryKeys'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      content: json['content'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      constant: json['constant'] as bool? ?? false,
      selective: json['selective'] as bool? ?? false,
      insertionOrder: (json['insertionOrder'] as num?)?.toInt() ?? 0,
      caseSensitive: json['caseSensitive'] as bool? ?? false,
      matchWholeWords: json['matchWholeWords'] as bool? ?? false,
      useGroupScoring: json['useGroupScoring'] as bool? ?? false,
      automationId: json['automationId'] as bool? ?? false,
      probability: (json['probability'] as num?)?.toInt() ?? 0,
      position:
          $enumDecodeNullable(_$WorldInfoPositionEnumMap, json['position']) ??
              WorldInfoPosition.before,
      depth: (json['depth'] as num?)?.toInt() ?? 0,
      group: json['group'] as String?,
      groupWeight: (json['groupWeight'] as num?)?.toInt() ?? 0,
      preventRecursion: json['preventRecursion'] as bool? ?? false,
      delayUntilRecursion: json['delayUntilRecursion'] as bool? ?? false,
      scanDepth: (json['scanDepth'] as num?)?.toInt() ?? 0,
      extensions: json['extensions'] as Map<String, dynamic>? ?? const {},
      role: $enumDecodeNullable(_$WorldInfoRoleEnumMap, json['role']) ??
          WorldInfoRole.system,
      timedEffects: json['timedEffects'] == null
          ? const WorldInfoTimedEffects()
          : WorldInfoTimedEffects.fromJson(
              json['timedEffects'] as Map<String, dynamic>),
      characterFilter: json['characterFilter'] == null
          ? const WorldInfoCharacterFilter()
          : WorldInfoCharacterFilter.fromJson(
              json['characterFilter'] as Map<String, dynamic>),
      groupOverride: (json['groupOverride'] as num?)?.toInt() ?? 0,
      excludeRecursion: json['excludeRecursion'] as bool? ?? false,
      useProbability: json['useProbability'] as bool? ?? false,
      vectorized: json['vectorized'] as String?,
      displayIndex: (json['displayIndex'] as num?)?.toInt() ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$WorldInfoEntryImplToJson(
        _$WorldInfoEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'worldInfoId': instance.worldInfoId,
      'keys': instance.keys,
      'secondaryKeys': instance.secondaryKeys,
      'content': instance.content,
      'comment': instance.comment,
      'enabled': instance.enabled,
      'constant': instance.constant,
      'selective': instance.selective,
      'insertionOrder': instance.insertionOrder,
      'caseSensitive': instance.caseSensitive,
      'matchWholeWords': instance.matchWholeWords,
      'useGroupScoring': instance.useGroupScoring,
      'automationId': instance.automationId,
      'probability': instance.probability,
      'position': _$WorldInfoPositionEnumMap[instance.position]!,
      'depth': instance.depth,
      'group': instance.group,
      'groupWeight': instance.groupWeight,
      'preventRecursion': instance.preventRecursion,
      'delayUntilRecursion': instance.delayUntilRecursion,
      'scanDepth': instance.scanDepth,
      'extensions': instance.extensions,
      'role': _$WorldInfoRoleEnumMap[instance.role]!,
      'timedEffects': instance.timedEffects,
      'characterFilter': instance.characterFilter,
      'groupOverride': instance.groupOverride,
      'excludeRecursion': instance.excludeRecursion,
      'useProbability': instance.useProbability,
      'vectorized': instance.vectorized,
      'displayIndex': instance.displayIndex,
      'isFavorite': instance.isFavorite,
    };

const _$WorldInfoPositionEnumMap = {
  WorldInfoPosition.before: 0,
  WorldInfoPosition.after: 1,
  WorldInfoPosition.ANTop: 2,
  WorldInfoPosition.ANBottom: 3,
  WorldInfoPosition.atDepth: 4,
  WorldInfoPosition.EMTop: 5,
  WorldInfoPosition.EMBottom: 6,
  WorldInfoPosition.outlet: 7,
};

const _$WorldInfoRoleEnumMap = {
  WorldInfoRole.system: 0,
  WorldInfoRole.user: 1,
  WorldInfoRole.assistant: 2,
};

_$WorldInfoExportImpl _$$WorldInfoExportImplFromJson(
        Map<String, dynamic> json) =>
    _$WorldInfoExportImpl(
      entries: (json['entries'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, WorldInfoEntryExport.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$WorldInfoExportImplToJson(
        _$WorldInfoExportImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries,
    };

_$WorldInfoEntryExportImpl _$$WorldInfoEntryExportImplFromJson(
        Map<String, dynamic> json) =>
    _$WorldInfoEntryExportImpl(
      uid: (json['uid'] as num).toInt(),
      key: (json['key'] as List<dynamic>).map((e) => e as String).toList(),
      keySecondary: (json['keysecondary'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      content: json['content'] as String,
      comment: json['comment'] as String? ?? '',
      selective: json['selective'] as bool? ?? false,
      constant: json['constant'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
      position: (json['position'] as num?)?.toInt() ?? 0,
      disable: json['disable'] as bool? ?? false,
      excludeRecursion: json['excludeRecursion'] as bool? ?? false,
      preventRecursion: json['preventRecursion'] as bool? ?? false,
      delayUntilRecursion: json['delayUntilRecursion'] as bool? ?? false,
      probability: (json['probability'] as num?)?.toInt() ?? 0,
      useProbability: json['useProbability'] as bool? ?? false,
      depth: (json['depth'] as num?)?.toInt() ?? 4,
      group: json['group'] as String? ?? '',
      groupOverride: (json['groupOverride'] as num?)?.toInt() ?? 100,
      groupWeight: json['groupWeight'] as bool? ?? false,
      scanDepth: (json['scanDepth'] as num?)?.toInt() ?? 0,
      caseSensitive: json['caseSensitive'] as bool? ?? false,
      matchWholeWords: json['matchWholeWords'] as bool? ?? false,
      useGroupScoring: json['useGroupScoring'] as bool? ?? false,
      automationId: json['automationId'] as String? ?? '',
      role: json['role'] as String? ?? '',
      vectorized: json['vectorized'] as String? ?? '',
      extensions: json['extensions'] as Map<String, dynamic>? ?? const {},
      sticky: (json['sticky'] as num?)?.toInt() ?? 0,
      cooldown: (json['cooldown'] as num?)?.toInt() ?? 0,
      delay: (json['delay'] as num?)?.toInt() ?? 0,
      characterFilter: json['character_filter'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$WorldInfoEntryExportImplToJson(
        _$WorldInfoEntryExportImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'key': instance.key,
      'keysecondary': instance.keySecondary,
      'content': instance.content,
      'comment': instance.comment,
      'selective': instance.selective,
      'constant': instance.constant,
      'order': instance.order,
      'position': instance.position,
      'disable': instance.disable,
      'excludeRecursion': instance.excludeRecursion,
      'preventRecursion': instance.preventRecursion,
      'delayUntilRecursion': instance.delayUntilRecursion,
      'probability': instance.probability,
      'useProbability': instance.useProbability,
      'depth': instance.depth,
      'group': instance.group,
      'groupOverride': instance.groupOverride,
      'groupWeight': instance.groupWeight,
      'scanDepth': instance.scanDepth,
      'caseSensitive': instance.caseSensitive,
      'matchWholeWords': instance.matchWholeWords,
      'useGroupScoring': instance.useGroupScoring,
      'automationId': instance.automationId,
      'role': instance.role,
      'vectorized': instance.vectorized,
      'extensions': instance.extensions,
      'sticky': instance.sticky,
      'cooldown': instance.cooldown,
      'delay': instance.delay,
      'character_filter': instance.characterFilter,
    };
