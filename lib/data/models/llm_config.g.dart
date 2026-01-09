// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LLMConfigImpl _$$LLMConfigImplFromJson(Map<String, dynamic> json) =>
    _$LLMConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      provider: $enumDecode(_$LLMProviderEnumMap, json['provider']),
      endpoint: json['endpoint'] as String,
      apiKey: json['apiKey'] as String?,
      model: json['model'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      defaultSettings: json['defaultSettings'] == null
          ? null
          : GenerationSettings.fromJson(
              json['defaultSettings'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    );

Map<String, dynamic> _$$LLMConfigImplToJson(_$LLMConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'provider': _$LLMProviderEnumMap[instance.provider]!,
      'endpoint': instance.endpoint,
      'apiKey': instance.apiKey,
      'model': instance.model,
      'enabled': instance.enabled,
      'isDefault': instance.isDefault,
      'defaultSettings': instance.defaultSettings,
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
    };

const _$LLMProviderEnumMap = {
  LLMProvider.openai: 'openai',
  LLMProvider.claude: 'claude',
  LLMProvider.openrouter: 'openrouter',
  LLMProvider.gemini: 'gemini',
  LLMProvider.mistral: 'mistral',
  LLMProvider.ollama: 'ollama',
  LLMProvider.koboldcpp: 'koboldcpp',
  LLMProvider.llamacpp: 'llamacpp',
  LLMProvider.local: 'local',
  LLMProvider.custom: 'custom',
};

_$GenerationSettingsImpl _$$GenerationSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$GenerationSettingsImpl(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      topP: (json['topP'] as num?)?.toDouble() ?? 0.9,
      topK: (json['topK'] as num?)?.toInt() ?? 40,
      minP: (json['minP'] as num?)?.toDouble() ?? 0.0,
      typicalP: (json['typicalP'] as num?)?.toDouble() ?? 1.0,
      repetitionPenalty: (json['repetitionPenalty'] as num?)?.toDouble() ?? 1.1,
      frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble() ?? 0.0,
      presencePenalty: (json['presencePenalty'] as num?)?.toDouble() ?? 0.0,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 512,
      contextLength: (json['contextLength'] as num?)?.toInt() ?? 4096,
      stopSequences: (json['stopSequences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      stream: json['stream'] as bool? ?? false,
      seed: (json['seed'] as num?)?.toInt(),
      extra: json['extra'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$GenerationSettingsImplToJson(
        _$GenerationSettingsImpl instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'topP': instance.topP,
      'topK': instance.topK,
      'minP': instance.minP,
      'typicalP': instance.typicalP,
      'repetitionPenalty': instance.repetitionPenalty,
      'frequencyPenalty': instance.frequencyPenalty,
      'presencePenalty': instance.presencePenalty,
      'maxTokens': instance.maxTokens,
      'contextLength': instance.contextLength,
      'stopSequences': instance.stopSequences,
      'stream': instance.stream,
      'seed': instance.seed,
      'extra': instance.extra,
    };

_$LocalModelConfigImpl _$$LocalModelConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$LocalModelConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      filePath: json['filePath'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      description: json['description'] as String?,
      contextLength: (json['contextLength'] as num?)?.toInt() ?? 1000000,
      batchSize: (json['batchSize'] as num?)?.toInt() ?? 512,
      gpuLayers: (json['gpuLayers'] as num?)?.toInt() ?? 0,
      threads: (json['threads'] as num?)?.toInt() ?? 4,
      useMmap: json['useMmap'] as bool? ?? false,
      useMlock: json['useMlock'] as bool? ?? false,
      chatTemplate: json['chatTemplate'] as String?,
      downloadedAt: json['downloadedAt'] == null
          ? null
          : DateTime.parse(json['downloadedAt'] as String),
    );

Map<String, dynamic> _$$LocalModelConfigImplToJson(
        _$LocalModelConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'filePath': instance.filePath,
      'fileSize': instance.fileSize,
      'description': instance.description,
      'contextLength': instance.contextLength,
      'batchSize': instance.batchSize,
      'gpuLayers': instance.gpuLayers,
      'threads': instance.threads,
      'useMmap': instance.useMmap,
      'useMlock': instance.useMlock,
      'chatTemplate': instance.chatTemplate,
      'downloadedAt': instance.downloadedAt?.toIso8601String(),
    };

_$PromptTemplateImpl _$$PromptTemplateImplFromJson(Map<String, dynamic> json) =>
    _$PromptTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      systemPrefix: json['systemPrefix'] as String,
      systemSuffix: json['systemSuffix'] as String,
      userPrefix: json['userPrefix'] as String,
      userSuffix: json['userSuffix'] as String,
      assistantPrefix: json['assistantPrefix'] as String,
      assistantSuffix: json['assistantSuffix'] as String,
      firstMessagePrefix: json['firstMessagePrefix'] as String? ?? '',
      lastMessageSuffix: json['lastMessageSuffix'] as String? ?? '',
      wrapInNewlines: json['wrapInNewlines'] as bool? ?? false,
    );

Map<String, dynamic> _$$PromptTemplateImplToJson(
        _$PromptTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'systemPrefix': instance.systemPrefix,
      'systemSuffix': instance.systemSuffix,
      'userPrefix': instance.userPrefix,
      'userSuffix': instance.userSuffix,
      'assistantPrefix': instance.assistantPrefix,
      'assistantSuffix': instance.assistantSuffix,
      'firstMessagePrefix': instance.firstMessagePrefix,
      'lastMessageSuffix': instance.lastMessageSuffix,
      'wrapInNewlines': instance.wrapInNewlines,
    };
