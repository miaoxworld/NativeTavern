// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => GroupMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      settings: json['settings'] == null
          ? const GroupSettings()
          : GroupSettings.fromJson(json['settings'] as Map<String, dynamic>),
      avatarPath: json['avatarPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      creatorNotes: json['creatorNotes'] as String? ?? '',
      lorebookId: json['lorebookId'] as String?,
      scenario: json['scenario'] as String?,
      firstMessage: json['firstMessage'] as String?,
      chatMetadata: json['chatMetadata'] as Map<String, dynamic>? ?? const {},
      pastChats: (json['pastChats'] as List<dynamic>?)
              ?.map((e) => GroupChatInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'members': instance.members,
      'settings': instance.settings,
      'avatarPath': instance.avatarPath,
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
      'tags': instance.tags,
      'isFavorite': instance.isFavorite,
      'creatorNotes': instance.creatorNotes,
      'lorebookId': instance.lorebookId,
      'scenario': instance.scenario,
      'firstMessage': instance.firstMessage,
      'chatMetadata': instance.chatMetadata,
      'pastChats': instance.pastChats,
    };

_$GroupMemberImpl _$$GroupMemberImplFromJson(Map<String, dynamic> json) =>
    _$GroupMemberImpl(
      characterId: json['characterId'] as String,
      isMuted: json['isMuted'] as bool? ?? false,
      talkativeness: (json['talkativeness'] as num?)?.toInt() ?? 50,
      triggerProbability: (json['triggerProbability'] as num?)?.toInt() ?? 100,
      triggerWords: (json['triggerWords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      insertionOrder: (json['insertionOrder'] as num?)?.toInt() ?? 0,
      depthPrompt: json['depthPrompt'] as String?,
      depthPromptDepth: (json['depthPromptDepth'] as num?)?.toInt() ?? 4,
      depthPromptRole: $enumDecodeNullable(
              _$GroupMemberDepthRoleEnumMap, json['depthPromptRole']) ??
          GroupMemberDepthRole.system,
      isActive: json['isActive'] as bool? ?? true,
      displayNameOverride: json['displayNameOverride'] as String?,
      avatarOverride: json['avatarOverride'] as String?,
      extensions: json['extensions'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$GroupMemberImplToJson(_$GroupMemberImpl instance) =>
    <String, dynamic>{
      'characterId': instance.characterId,
      'isMuted': instance.isMuted,
      'talkativeness': instance.talkativeness,
      'triggerProbability': instance.triggerProbability,
      'triggerWords': instance.triggerWords,
      'insertionOrder': instance.insertionOrder,
      'depthPrompt': instance.depthPrompt,
      'depthPromptDepth': instance.depthPromptDepth,
      'depthPromptRole':
          _$GroupMemberDepthRoleEnumMap[instance.depthPromptRole]!,
      'isActive': instance.isActive,
      'displayNameOverride': instance.displayNameOverride,
      'avatarOverride': instance.avatarOverride,
      'extensions': instance.extensions,
    };

const _$GroupMemberDepthRoleEnumMap = {
  GroupMemberDepthRole.system: 'system',
  GroupMemberDepthRole.user: 'user',
  GroupMemberDepthRole.assistant: 'assistant',
};

_$GroupSettingsImpl _$$GroupSettingsImplFromJson(Map<String, dynamic> json) =>
    _$GroupSettingsImpl(
      activationStrategy: $enumDecodeNullable(
              _$GroupActivationStrategyEnumMap, json['activationStrategy']) ??
          GroupActivationStrategy.natural,
      generationMode: $enumDecodeNullable(
              _$GroupGenerationModeEnumMap, json['generationMode']) ??
          GroupGenerationMode.swap,
      autoModeDelay: (json['autoModeDelay'] as num?)?.toInt() ?? 5000,
      allowSelfResponse: json['allowSelfResponse'] as bool? ?? false,
      hideDisabledMembers: json['hideDisabledMembers'] as bool? ?? true,
      maxResponses: (json['maxResponses'] as num?)?.toInt() ?? 1,
      autoSelectSpeaker: json['autoSelectSpeaker'] as bool? ?? true,
      showCharacterNames: json['showCharacterNames'] as bool? ?? true,
      allowUserAsCharacter: json['allowUserAsCharacter'] as bool? ?? true,
      minMessagesBetweenSameSpeaker:
          (json['minMessagesBetweenSameSpeaker'] as num?)?.toInt() ?? 0,
      useCharacterPrompts: json['useCharacterPrompts'] as bool? ?? true,
      mergeConsecutiveMessages:
          json['mergeConsecutiveMessages'] as bool? ?? false,
      groupSystemPrompt: json['groupSystemPrompt'] as String? ?? '',
      includeGroupScenario: json['includeGroupScenario'] as bool? ?? true,
      includeMemberList: json['includeMemberList'] as bool? ?? true,
      memberListFormat: json['memberListFormat'] as String? ??
          '{{char}} is present in this conversation.',
      favorTriggeredCharacters:
          json['favorTriggeredCharacters'] as bool? ?? true,
      triggeredCharacterWeight:
          (json['triggeredCharacterWeight'] as num?)?.toDouble() ?? 2.0,
    );

Map<String, dynamic> _$$GroupSettingsImplToJson(_$GroupSettingsImpl instance) =>
    <String, dynamic>{
      'activationStrategy':
          _$GroupActivationStrategyEnumMap[instance.activationStrategy]!,
      'generationMode': _$GroupGenerationModeEnumMap[instance.generationMode]!,
      'autoModeDelay': instance.autoModeDelay,
      'allowSelfResponse': instance.allowSelfResponse,
      'hideDisabledMembers': instance.hideDisabledMembers,
      'maxResponses': instance.maxResponses,
      'autoSelectSpeaker': instance.autoSelectSpeaker,
      'showCharacterNames': instance.showCharacterNames,
      'allowUserAsCharacter': instance.allowUserAsCharacter,
      'minMessagesBetweenSameSpeaker': instance.minMessagesBetweenSameSpeaker,
      'useCharacterPrompts': instance.useCharacterPrompts,
      'mergeConsecutiveMessages': instance.mergeConsecutiveMessages,
      'groupSystemPrompt': instance.groupSystemPrompt,
      'includeGroupScenario': instance.includeGroupScenario,
      'includeMemberList': instance.includeMemberList,
      'memberListFormat': instance.memberListFormat,
      'favorTriggeredCharacters': instance.favorTriggeredCharacters,
      'triggeredCharacterWeight': instance.triggeredCharacterWeight,
    };

const _$GroupActivationStrategyEnumMap = {
  GroupActivationStrategy.natural: 'natural',
  GroupActivationStrategy.list: 'list',
  GroupActivationStrategy.manual: 'manual',
  GroupActivationStrategy.pooled: 'pooled',
};

const _$GroupGenerationModeEnumMap = {
  GroupGenerationMode.swap: 'swap',
  GroupGenerationMode.append: 'append',
  GroupGenerationMode.appendDisabled: 'appendDisabled',
};

_$GroupChatInfoImpl _$$GroupChatInfoImplFromJson(Map<String, dynamic> json) =>
    _$GroupChatInfoImpl(
      chatId: json['chatId'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      previewText: json['previewText'] as String?,
    );

Map<String, dynamic> _$$GroupChatInfoImplToJson(_$GroupChatInfoImpl instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'messageCount': instance.messageCount,
      'previewText': instance.previewText,
    };

_$GroupExportImpl _$$GroupExportImplFromJson(Map<String, dynamic> json) =>
    _$GroupExportImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      activationStrategy: (json['activation_strategy'] as num?)?.toInt() ?? 0,
      generationMode: (json['generation_mode'] as num?)?.toInt() ?? 0,
      disabledMembers: (json['disabled_members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      chatMetadata: json['chat_metadata'] as Map<String, dynamic>? ?? const {},
      pastMetadata: json['past_metadata'] as Map<String, dynamic>? ?? const {},
      fav: json['fav'] as bool? ?? false,
      chatId: json['chat_id'] as String?,
      chats:
          (json['chats'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$GroupExportImplToJson(_$GroupExportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'members': instance.members,
      'activation_strategy': instance.activationStrategy,
      'generation_mode': instance.generationMode,
      'disabled_members': instance.disabledMembers,
      'chat_metadata': instance.chatMetadata,
      'past_metadata': instance.pastMetadata,
      'fav': instance.fav,
      'chat_id': instance.chatId,
      'chats': instance.chats,
    };
