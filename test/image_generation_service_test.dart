import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';

void main() {
  group('ImageGenSettings effectiveEndpoint', () {
    test('adds /v1 to an OpenAI-compatible root URL', () {
      const settings = ImageGenSettings(
        provider: ImageGenProvider.openai,
        apiEndpoints: {
          'openai': '  https://oneapi.example.com/  ',
        },
      );

      expect(settings.effectiveEndpoint, 'https://oneapi.example.com/v1');
    });

    test('preserves an existing /v1 base path', () {
      const settings = ImageGenSettings(
        provider: ImageGenProvider.openai,
        apiEndpoints: {
          'openai': 'https://oneapi.example.com/v1/',
        },
      );

      expect(settings.effectiveEndpoint, 'https://oneapi.example.com/v1');
    });

    test('preserves a custom API base path', () {
      const settings = ImageGenSettings(
        provider: ImageGenProvider.openaiChat,
        apiEndpoints: {
          'openai_chat': 'https://proxy.example.com/api/v1/',
        },
      );

      expect(settings.effectiveEndpoint, 'https://proxy.example.com/api/v1');
    });

    test('accepts a full image generations endpoint', () {
      const settings = ImageGenSettings(
        provider: ImageGenProvider.openai,
        apiEndpoints: {
          'openai': 'https://oneapi.example.com/v1/images/generations',
        },
      );

      expect(settings.effectiveEndpoint, 'https://oneapi.example.com/v1');
    });

    test('accepts a full chat completions endpoint', () {
      const settings = ImageGenSettings(
        provider: ImageGenProvider.openaiChat,
        apiEndpoints: {
          'openai_chat': 'https://proxy.example.com/v1/chat/completions/',
        },
      );

      expect(settings.effectiveEndpoint, 'https://proxy.example.com/v1');
    });

    test('only removes trailing slashes for other providers', () {
      const settings = ImageGenSettings(
        provider: ImageGenProvider.automatic1111,
        apiEndpoints: {
          'automatic1111': 'http://localhost:7860/',
        },
      );

      expect(settings.effectiveEndpoint, 'http://localhost:7860');
    });
  });

  group('ImageGenSettings auth headers', () {
    test('serializes and deserializes authHeaderNames and authHeaderValues', () {
      final settings = const ImageGenSettings(
        provider: ImageGenProvider.automatic1111,
      ).withAuthHeader(name: 'X-Custom-Auth', value: 'secret-token');

      expect(settings.authHeaderName, 'X-Custom-Auth');
      expect(settings.authHeaderValue, 'secret-token');

      final json = settings.toJson();
      final loaded = ImageGenSettings.fromJson(json);

      expect(loaded.authHeaderNames['automatic1111'], 'X-Custom-Auth');
      expect(loaded.authHeaderValues['automatic1111'], 'secret-token');
      expect(loaded.authHeaderName, 'X-Custom-Auth');
      expect(loaded.authHeaderValue, 'secret-token');
    });

    test('withAuthHeader clears values when empty or null', () {
      final settings = const ImageGenSettings(
        provider: ImageGenProvider.comfyui,
      ).withAuthHeader(name: 'Authorization', value: 'Bearer abc')
       .withAuthHeader(name: '', value: null);

      expect(settings.authHeaderName, isNull);
      expect(settings.authHeaderValue, isNull);
    });
  });
}
