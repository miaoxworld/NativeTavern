import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/llm_service.dart';

/// Verifies that unchecked sampler parameters never reach the provider. This
/// is what lets endpoints such as the xAI API reject unknown fields while the
/// user simply turns the offending parameter off.
void main() {
  Future<HttpServer> startServer(
    List<Map<String, dynamic>> received,
    Map<String, dynamic> response,
  ) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(server.close);
    server.listen((request) async {
      final body = await utf8.decoder.bind(request).join();
      received.add(Map<String, dynamic>.from(jsonDecode(body) as Map));
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(response));
      await request.response.close();
    });
    return server;
  }

  const openAiResponse = {
    'choices': [
      {
        'message': {'role': 'assistant', 'content': 'ok'},
        'finish_reason': 'stop',
      },
    ],
  };

  test('unchecked OpenAI-compatible parameters are omitted from the request',
      () async {
    final received = <Map<String, dynamic>>[];
    final server = await startServer(received, openAiResponse);
    final service = LLMService();

    final config = LLMConfig(
      provider: LLMProvider.openai,
      model: 'grok-4.6',
      apiKey: 'test-key',
      apiUrl: 'http://127.0.0.1:${server.port}/v1',
      disabledParameters: const {
        SamplerParameters.presencePenalty,
        SamplerParameters.frequencyPenalty,
        SamplerParameters.maxTokens,
      },
    );

    final content = await service.generate(
      const [
        {'role': 'user', 'content': 'hello'},
      ],
      config,
    );

    expect(content, 'ok');
    final body = received.single;
    expect(body.containsKey('presence_penalty'), isFalse);
    expect(body.containsKey('frequency_penalty'), isFalse);
    expect(body.containsKey('max_tokens'), isFalse);
    // Parameters that stay checked must still be sent.
    expect(body['temperature'], config.temperature);
    expect(body['top_p'], config.topP);
  });

  test('every parameter is sent when none is disabled', () async {
    final received = <Map<String, dynamic>>[];
    final server = await startServer(received, openAiResponse);
    final service = LLMService();

    final config = LLMConfig(
      provider: LLMProvider.openai,
      model: 'gpt-test',
      apiKey: 'test-key',
      apiUrl: 'http://127.0.0.1:${server.port}/v1',
    );

    await service.generate(
      const [
        {'role': 'user', 'content': 'hello'},
      ],
      config,
    );

    final body = received.single;
    expect(body.containsKey('presence_penalty'), isTrue);
    expect(body.containsKey('frequency_penalty'), isTrue);
    expect(body.containsKey('max_tokens'), isTrue);
  });

  test('unchecked Claude parameters are omitted from the request', () async {
    final received = <Map<String, dynamic>>[];
    final server = await startServer(received, {
      'content': [
        {'type': 'text', 'text': 'ok'},
      ],
    });
    final service = LLMService();

    final config = LLMConfig(
      provider: LLMProvider.claude,
      model: 'claude-test',
      apiKey: 'test-key',
      apiUrl: 'http://127.0.0.1:${server.port}',
      disabledParameters: const {SamplerParameters.maxTokens},
    );

    final content = await service.generate(
      const [
        {'role': 'user', 'content': 'hello'},
      ],
      config,
    );

    expect(content, 'ok');
    expect(received.single.containsKey('max_tokens'), isFalse);
  });

  test('sendsParameter only reports disabled keys', () {
    const config = LLMConfig(
      provider: LLMProvider.openai,
      model: 'test',
      apiKey: '',
      apiUrl: 'https://example.com/v1',
      disabledParameters: {SamplerParameters.presencePenalty},
    );

    expect(config.sendsParameter(SamplerParameters.presencePenalty), isFalse);
    expect(config.sendsParameter(SamplerParameters.temperature), isTrue);
  });
}
