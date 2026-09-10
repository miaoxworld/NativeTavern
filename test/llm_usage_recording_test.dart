import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/models/tool_calling.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/llm_usage_parser.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/domain/services/tool_calling/openai_tool_calling_adapter.dart';

void main() {
  const messages = [
    {'role': 'user', 'content': 'Hi'},
  ];

  test('parses Ollama eval counts and merges Claude stream usage', () {
    final ollama = LlmUsageParser.parse({
      'done': true,
      'prompt_eval_count': 40,
      'eval_count': 12,
    });
    expect(ollama?.promptTokens, 40);
    expect(ollama?.completionTokens, 12);
    expect(ollama?.totalTokens, 52);

    final start = LlmUsageParser.parse({
      'type': 'message_start',
      'message': {
        'usage': {'input_tokens': 21, 'output_tokens': 1},
      },
    });
    final delta = LlmUsageParser.parse({
      'type': 'message_delta',
      'usage': {'output_tokens': 18},
    });
    final merged = start!.mergedWith(delta!);
    expect(merged.promptTokens, 21);
    expect(merged.completionTokens, 18);
  });

  test('records usage from OpenAI streaming chunks', () async {
    final recorded = <LlmTokenUsage>[];
    final service = LLMService(
      dio: Dio()
        ..httpClientAdapter = _SseAdapter(
          'data: {"choices":[{"delta":{"content":"Hi"}}]}\n\n'
          'data: {"choices":[{"delta":{},"finish_reason":"stop"}],'
          '"usage":{"prompt_tokens":11,"completion_tokens":2,"total_tokens":13}}\n\n'
          'data: [DONE]\n\n',
        ),
    )..onUsage = (_, usage) => recorded.add(usage);

    await service
        .generateStreamWithReasoning(
          messages,
          const LLMConfig(
            provider: LLMProvider.openai,
            model: 'gpt-4.1',
            apiKey: 'sk-test',
            apiUrl: 'https://api.openai.com/v1',
          ),
        )
        .toList();

    expect(recorded, hasLength(1));
    expect(recorded.single.promptTokens, 11);
    expect(recorded.single.completionTokens, 2);
    expect(recorded.single.totalTokens, 13);
  });

  test('records usage from Claude streaming message events', () async {
    final recorded = <LlmTokenUsage>[];
    final service = LLMService(
      dio: Dio()
        ..httpClientAdapter = _SseAdapter(
          'data: {"type":"message_start","message":{"usage":{"input_tokens":9,"output_tokens":1}}}\n\n'
          'data: {"type":"content_block_delta","delta":{"type":"text_delta","text":"Hi"}}\n\n'
          'data: {"type":"message_delta","usage":{"output_tokens":4}}\n\n',
        ),
    )..onUsage = (_, usage) => recorded.add(usage);

    await service
        .generateStreamWithReasoning(
          messages,
          const LLMConfig(
            provider: LLMProvider.claude,
            model: 'claude-sonnet-4-5',
            apiKey: 'sk-ant',
            apiUrl: 'https://api.anthropic.com',
          ),
        )
        .toList();

    expect(recorded, hasLength(1));
    expect(recorded.single.promptTokens, 9);
    expect(recorded.single.completionTokens, 4);
  });

  test('records usage from a tool-calling turn', () async {
    final recorded = <LlmTokenUsage>[];
    final service = LLMService(
      dio: Dio()
        ..httpClientAdapter = _JsonAdapter({
          'choices': [
            {
              'message': {
                'role': 'assistant',
                'content': 'done',
              },
            }
          ],
          'usage': {
            'prompt_tokens': 30,
            'completion_tokens': 6,
            'total_tokens': 36,
          },
        }),
    )..onUsage = (_, usage) => recorded.add(usage);

    await service.generateToolTurn(
      baseMessages: messages,
      continuationMessages: const [],
      config: const LLMConfig(
        provider: LLMProvider.openai,
        model: 'gpt-4.1',
        apiKey: 'sk-test',
        apiUrl: 'https://api.openai.com/v1',
      ),
      toolConfiguration: const ToolCallingConfiguration.disabled(),
      adapter: const OpenAiToolCallingAdapter(),
      cancellationToken: ToolCancellationController().token,
    );

    expect(recorded.single.totalTokens, 36);
    expect(recorded.single.promptTokens, 30);
  });

  group('xAI usage is gated by mainland China region', () {
    const xaiConfig = LLMConfig(
      provider: LLMProvider.xai,
      model: 'grok-4',
      apiKey: 'xai-test',
      apiUrl: 'https://api.x.ai/v1',
    );
    const dualDetectConfig = LLMConfig(
      provider: LLMProvider.openAICompatible,
      model: 'grok-4',
      apiKey: 'xai-test',
      apiUrl: 'https://api.x.ai/v1',
    );
    const openaiConfig = LLMConfig(
      provider: LLMProvider.openai,
      model: 'gpt-4.1',
      apiKey: 'sk-test',
      apiUrl: 'https://api.openai.com/v1',
    );

    const streamBody =
        'data: {"choices":[{"delta":{"content":"Hi"}}]}\n\n'
        'data: {"choices":[{"delta":{},"finish_reason":"stop"}],'
        '"usage":{"prompt_tokens":11,"completion_tokens":2,"total_tokens":13}}\n\n'
        'data: [DONE]\n\n';

    tearDown(RegionService.clearCache);

    bool chinaAwareRecord(LLMConfig config) {
      if (RegionService.isXaiUsageEndpoint(config)) {
        return RegionService.allowsXaiUsageAccounting;
      }
      return true;
    }

    test('detects xAI and dual-detected Grok endpoints', () {
      expect(RegionService.isXaiUsageEndpoint(xaiConfig), isTrue);
      expect(RegionService.isXaiUsageEndpoint(dualDetectConfig), isTrue);
      expect(RegionService.isXaiUsageEndpoint(openaiConfig), isFalse);
    });

    test('records xAI stream usage and sends stream_options outside China', () async {
      RegionService.debugSetChinaRegion(false);
      final recorded = <LlmTokenUsage>[];
      final adapter = _SseAdapter(streamBody);
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter)
        ..shouldRecordUsage = chinaAwareRecord
        ..onUsage = (_, usage) => recorded.add(usage);

      await service.generateStreamWithReasoning(messages, xaiConfig).toList();

      expect(recorded, hasLength(1));
      expect(recorded.single.totalTokens, 13);
      expect(_requestMap(adapter.lastOptions?.data)['stream_options'], {
        'include_usage': true,
      });
    });

    test('skips xAI metering and stream_options in mainland China', () async {
      RegionService.debugSetChinaRegion(true);
      final recorded = <LlmTokenUsage>[];
      final adapter = _SseAdapter(streamBody);
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter)
        ..shouldRecordUsage = chinaAwareRecord
        ..onUsage = (_, usage) => recorded.add(usage);

      await service.generateStreamWithReasoning(messages, xaiConfig).toList();

      expect(recorded, isEmpty);
      expect(
        _requestMap(adapter.lastOptions?.data).containsKey('stream_options'),
        isFalse,
      );
    });

    test('still records OpenAI usage in mainland China', () async {
      RegionService.debugSetChinaRegion(true);
      final recorded = <LlmTokenUsage>[];
      final adapter = _SseAdapter(streamBody);
      final service = LLMService(dio: Dio()..httpClientAdapter = adapter)
        ..shouldRecordUsage = chinaAwareRecord
        ..onUsage = (_, usage) => recorded.add(usage);

      await service.generateStreamWithReasoning(messages, openaiConfig).toList();

      expect(recorded, hasLength(1));
      expect(_requestMap(adapter.lastOptions?.data)['stream_options'], {
        'include_usage': true,
      });
    });
  });
}

Map<String, dynamic> _requestMap(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  if (data is String) return jsonDecode(data) as Map<String, dynamic>;
  throw StateError('unexpected request data ${data.runtimeType}');
}

class _SseAdapter implements HttpClientAdapter {
  _SseAdapter(this.body);

  final String body;
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: ['text/event-stream'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _JsonAdapter implements HttpClientAdapter {
  _JsonAdapter(this.json);

  final Map<String, dynamic> json;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(this.json),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
