// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      role: $enumDecode(_$MessageRoleEnumMap, json['role']),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isEdited: json['isEdited'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
      metadata: json['metadata'] == null
          ? null
          : MessageMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'isEdited': instance.isEdited,
      'isHidden': instance.isHidden,
      'metadata': instance.metadata,
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.system: 'system',
};

_$MessageMetadataImpl _$$MessageMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageMetadataImpl(
      promptTokens: (json['promptTokens'] as num?)?.toInt(),
      completionTokens: (json['completionTokens'] as num?)?.toInt(),
      totalTokens: (json['totalTokens'] as num?)?.toInt(),
      model: json['model'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      maxTokens: (json['maxTokens'] as num?)?.toInt(),
      swipes: (json['swipes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentSwipeIndex: (json['currentSwipeIndex'] as num?)?.toInt() ?? 0,
      reasoning: json['reasoning'] as String?,
      extra: json['extra'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$MessageMetadataImplToJson(
        _$MessageMetadataImpl instance) =>
    <String, dynamic>{
      'promptTokens': instance.promptTokens,
      'completionTokens': instance.completionTokens,
      'totalTokens': instance.totalTokens,
      'model': instance.model,
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'swipes': instance.swipes,
      'currentSwipeIndex': instance.currentSwipeIndex,
      'reasoning': instance.reasoning,
      'extra': instance.extra,
    };
