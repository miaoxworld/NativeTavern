import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/models/tool_calling.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/domain/services/tool_calling/openai_tool_calling_adapter.dart';

void main() {
  const sampleMessages = [
    {'role': 'user', 'content': 'Hello Grok!'},
  ];

  group('xAI Grok Dynamic Models & Parameter Filtering', () {
    test(
        'fetches available models dynamically from xAI server /models endpoint',
        () async {
      final adapter = _RecordingLlmAdapter(
        jsonResponse: {
          'object': 'list',
          'data': [
            {'id': 'grok-4.3', 'object': 'model'},
            {'id': 'grok-4.3-mini', 'object': 'model'},
          ],
        },
      );
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter);

      final config = LLMConfig(
        provider: LLMProvider.xai,
        model: '',
        apiKey: 'xai-test-key',
        apiUrl: 'https://api.x.ai/v1',
      );

      final models = await service.getAvailableModels(config);
      expect(models, ['grok-4.3', 'grok-4.3-mini']);
      expect(adapter.lastOptions?.path, 'https://api.x.ai/v1/models');
      expect(
        adapter.lastOptions?.headers['Authorization'],
        'Bearer xai-test-key',
      );
    });

    test(
        'LLMProvider.xai excludes presence_penalty and extended samplers in non-streaming requests',
        () async {
      final adapter = _RecordingLlmAdapter();
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter);

      final config = LLMConfig(
        provider: LLMProvider.xai,
        model: 'grok-4.3',
        apiKey: 'xai-test-key',
        apiUrl: 'https://api.x.ai/v1',
        presencePenalty: 0.5,
        repetitionPenalty: 1.2,
        topK: 50,
        minP: 0.05,
      );

      await service.generateWithReasoning(sampleMessages, config);

      final requestData = _data(adapter.lastOptions);
      expect(requestData['model'], 'grok-4.3');
      expect(requestData['messages'], sampleMessages);
      expect(requestData.containsKey('presence_penalty'), isFalse,
          reason: 'xAI rejects presence_penalty with HTTP 400');
      expect(requestData.containsKey('repetition_penalty'), isFalse,
          reason: 'xAI rejects repetition_penalty');
      expect(requestData.containsKey('top_k'), isFalse,
          reason: 'xAI rejects top_k');
      expect(requestData.containsKey('min_p'), isFalse,
          reason: 'xAI rejects min_p');
    });

    test('LLMProvider.xai excludes presence_penalty in streaming requests',
        () async {
      final adapter = _RecordingLlmAdapter(streaming: true);
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter);

      final config = LLMConfig(
        provider: LLMProvider.xai,
        model: 'grok-4.3',
        apiKey: 'xai-test-key',
        apiUrl: 'https://api.x.ai/v1',
        presencePenalty: 0.8,
        topK: 60,
      );

      await service
          .generateStreamWithReasoning(sampleMessages, config)
          .toList();

      final requestData = _data(adapter.lastOptions);
      expect(requestData['stream'], isTrue);
      expect(requestData.containsKey('presence_penalty'), isFalse);
      expect(requestData.containsKey('top_k'), isFalse);
    });

    test(
        'Dual detection: LLMProvider.openAICompatible auto-detects xAI when URL contains api.x.ai and model starts with grok-',
        () async {
      final adapter = _RecordingLlmAdapter();
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter);

      final config = LLMConfig(
        provider: LLMProvider.openAICompatible,
        model: 'grok-4.3',
        apiKey: 'test-key',
        apiUrl: 'https://api.x.ai/v1',
        presencePenalty: 0.5,
        repetitionPenalty: 1.15,
        topK: 40,
      );

      await service.generateWithReasoning(sampleMessages, config);

      final requestData = _data(adapter.lastOptions);
      expect(requestData['model'], 'grok-4.3');
      expect(requestData.containsKey('presence_penalty'), isFalse);
      expect(requestData.containsKey('repetition_penalty'), isFalse);
      expect(requestData.containsKey('top_k'), isFalse);
    });

    test(
        'Generic OpenAI-compatible endpoint preserves presence_penalty and extended samplers',
        () async {
      final adapter = _RecordingLlmAdapter();
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter);

      final config = LLMConfig(
        provider: LLMProvider.openAICompatible,
        model: 'local-llama-3',
        apiKey: 'test-key',
        apiUrl: 'http://localhost:8080/v1',
        presencePenalty: 0.5,
        repetitionPenalty: 1.15,
        topK: 40,
        minP: 0.05,
      );

      await service.generateWithReasoning(sampleMessages, config);

      final requestData = _data(adapter.lastOptions);
      expect(requestData['presence_penalty'], 0.5);
      expect(requestData['repetition_penalty'], 1.15);
      expect(requestData['top_k'], 40);
      expect(requestData['min_p'], 0.05);
    });

    test(
        'generateToolTurn with LLMProvider.xai excludes presence_penalty from request',
        () async {
      final adapter = _RecordingLlmAdapter(
        jsonResponse: {
          'choices': [
            {
              'message': {
                'role': 'assistant',
                'content': 'Tool completed',
              },
            }
          ],
        },
      );
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter);

      final config = LLMConfig(
        provider: LLMProvider.xai,
        model: 'grok-4.3',
        apiKey: 'xai-test-key',
        apiUrl: 'https://api.x.ai/v1',
        presencePenalty: 0.7,
        topK: 30,
      );

      final cancellation = ToolCancellationController();
      await service.generateToolTurn(
        baseMessages: sampleMessages,
        continuationMessages: const [],
        config: config,
        toolConfiguration: const ToolCallingConfiguration.disabled(),
        adapter: const OpenAiToolCallingAdapter(),
        cancellationToken: cancellation.token,
      );

      final requestData = _data(adapter.lastOptions);
      expect(requestData.containsKey('presence_penalty'), isFalse);
      expect(requestData.containsKey('top_k'), isFalse);
    });

    test(
        'OpenAI and xAI are both filtered out when China restriction is active',
        () {
      List<LLMProvider> filterProviders({required bool hideRestricted}) {
        return LLMProvider.values.where((provider) {
          if (hideRestricted &&
              RegionService.isRestrictedCloudProvider(provider)) {
            return false;
          }
          return true;
        }).toList();
      }

      final restrictedProviders = filterProviders(hideRestricted: true);
      expect(restrictedProviders.contains(LLMProvider.openai), isFalse);
      expect(restrictedProviders.contains(LLMProvider.xai), isFalse);
      expect(restrictedProviders.contains(LLMProvider.claude), isTrue);
      expect(restrictedProviders.contains(LLMProvider.deepSeek), isTrue);
      expect(restrictedProviders.contains(LLMProvider.lmStudio), isTrue);
      expect(restrictedProviders.contains(LLMProvider.ollama), isTrue);
      expect(
        RegionService.isRestrictedCloudProvider(LLMProvider.lmStudio),
        isFalse,
      );

      final unrestrictedProviders = filterProviders(hideRestricted: false);
      expect(unrestrictedProviders.contains(LLMProvider.openai), isTrue);
      expect(unrestrictedProviders.contains(LLMProvider.xai), isTrue);
      expect(unrestrictedProviders.contains(LLMProvider.lmStudio), isTrue);
    });

    test('Chinese language and China region hide xAI from user-facing lists',
        () {
      expect(
        RegionService.hidesRestrictedAiProviders(
          isChinaRegion: true,
          languageCode: 'en',
        ),
        isTrue,
      );
      expect(
        RegionService.hidesRestrictedAiProviders(
          isChinaRegion: false,
          languageCode: 'zh',
        ),
        isTrue,
      );
      expect(
        RegionService.hidesRestrictedAiProviders(
          isChinaRegion: false,
          languageCode: 'en',
        ),
        isFalse,
      );
    });
  });
}

Map<String, dynamic> _data(RequestOptions? options) {
  if (options?.data is Map<String, dynamic>) {
    return options!.data as Map<String, dynamic>;
  }
  return jsonDecode(options?.data?.toString() ?? '{}') as Map<String, dynamic>;
}

class _RecordingLlmAdapter implements HttpClientAdapter {
  _RecordingLlmAdapter({this.streaming = false, this.jsonResponse});

  final bool streaming;
  final Map<String, dynamic>? jsonResponse;
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    if (streaming) {
      return ResponseBody.fromString(
        'data: {"choices":[{"delta":{"content":"ok"},"finish_reason":null}]}\n\n'
        'data: [DONE]\n\n',
        200,
        headers: {
          Headers.contentTypeHeader: ['text/event-stream'],
        },
      );
    }
    return ResponseBody.fromString(
      jsonEncode(
        jsonResponse ??
            {
              'choices': [
                {
                  'message': {
                    'role': 'assistant',
                    'content': 'ok',
                  },
                }
              ],
            },
      ),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
