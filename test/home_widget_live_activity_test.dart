import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_bridge.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/presentation/providers/home_widget_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeWidgetLiveState', () {
    test('round-trips JSON correctly', () {
      final started = DateTime.utc(2026, 9, 10, 12, 0);
      final updated = DateTime.utc(2026, 9, 10, 12, 0, 5);

      final state = HomeWidgetLiveState(
        active: true,
        chatId: 'chat-123',
        characterId: 'char-456',
        characterName: 'Elena',
        characterAvatar: 'character_char-456.img',
        snippet: 'The candles flicker quietly as she turns.',
        phase: HomeWidgetLivePhase.generating,
        providerLabel: 'DeepSeek',
        deepLink: 'nativetavern://widget/chat?id=chat-123',
        startedAt: started,
        updatedAt: updated,
        tokensToday: 345,
        error: null,
      );

      final json = state.toJson();
      expect(json['active'], isTrue);
      expect(json['chatId'], 'chat-123');
      expect(json['characterName'], 'Elena');
      expect(json['phase'], 'generating');
      expect(json['providerLabel'], 'DeepSeek');
      expect(json['tokensToday'], 345);

      final parsed = HomeWidgetLiveState.fromJson(json);
      expect(parsed.active, state.active);
      expect(parsed.chatId, state.chatId);
      expect(parsed.characterId, state.characterId);
      expect(parsed.characterName, state.characterName);
      expect(parsed.characterAvatar, state.characterAvatar);
      expect(parsed.snippet, state.snippet);
      expect(parsed.phase, HomeWidgetLivePhase.generating);
      expect(parsed.providerLabel, state.providerLabel);
      expect(parsed.deepLink, state.deepLink);
      expect(parsed.startedAt, started);
      expect(parsed.updatedAt, updated);
      expect(parsed.tokensToday, 345);
      expect(parsed.error, isNull);
    });

    test('idle factory produces safe empty state', () {
      final idle = HomeWidgetLiveState.idle();
      expect(idle.active, isFalse);
      expect(idle.chatId, isEmpty);
      expect(idle.characterName, isEmpty);
      expect(idle.phase, HomeWidgetLivePhase.idle);
      expect(idle.error, isNull);
    });

    test('HomeWidgetSnapshot embeds live state optional payload', () {
      final now = DateTime.utc(2026, 9, 10, 14);
      final live = HomeWidgetLiveState(
        active: true,
        chatId: 'c1',
        characterName: 'Aria',
        snippet: 'Streaming tokens...',
        phase: HomeWidgetLivePhase.generating,
        startedAt: now,
        updatedAt: now,
      );

      final snapshot = HomeWidgetSnapshot(
        updatedAt: now,
        locale: 'en',
        settings: const HomeWidgetSettings(),
        labels: HomeWidgetLabels.english,
        status: const StatusWidgetPayload(
          provider: 'deepSeek',
          providerLabel: 'DeepSeek',
          model: 'deepseek-chat',
          health: HomeWidgetProviderHealth.ready,
          deepLink: 'nativetavern://widget/aiConfig',
        ),
        live: live,
      );

      final json = snapshot.toJson();
      expect(json['live'], isNotNull);
      expect(json['live']['characterName'], 'Aria');

      final deserialized = HomeWidgetSnapshot.fromJson(json);
      expect(deserialized.live?.active, isTrue);
      expect(deserialized.live?.characterName, 'Aria');
      expect(deserialized.live?.phase, HomeWidgetLivePhase.generating);
    });
  });

  group('China App Store Provider Label Masking', () {
    test('RegionService correctly identifies China region policy triggers', () {
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
          languageCode: 'ZH',
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

    test('restricted providers are masked to LLM when hideRestricted is true', () {
      const restricted = [
        LLMProvider.openai,
        LLMProvider.xai,
        LLMProvider.claude,
        LLMProvider.gemini,
        LLMProvider.openRouter,
      ];

      for (final provider in restricted) {
        expect(
          homeWidgetProviderLabel(provider, hideRestricted: true),
          'LLM',
          reason: '$provider must be masked to generic LLM in China/zh',
        );
      }
    });

    test('unrestricted providers remain visible when hideRestricted is true', () {
      const unrestricted = {
        LLMProvider.deepSeek: 'DeepSeek',
        LLMProvider.qwen: 'Qwen',
        LLMProvider.siliconFlow: 'SiliconFlow',
        LLMProvider.moonshot: 'Moonshot',
        LLMProvider.zai: 'Z.AI',
        LLMProvider.miniMax: 'MiniMax',
        LLMProvider.openAICompatible: 'OAI Compatible',
        LLMProvider.ollama: 'Ollama',
        LLMProvider.lmStudio: 'LM Studio',
        LLMProvider.koboldCpp: 'KoboldCpp',
      };

      for (final entry in unrestricted.entries) {
        expect(
          homeWidgetProviderLabel(entry.key, hideRestricted: true),
          entry.value,
          reason: '${entry.key} must be visible in China/zh',
        );
      }
    });

    test('all providers display proper labels when hideRestricted is false', () {
      expect(homeWidgetProviderLabel(LLMProvider.xai, hideRestricted: false), 'xAI (Grok)');
      expect(homeWidgetProviderLabel(LLMProvider.openai, hideRestricted: false), 'OpenAI');
      expect(homeWidgetProviderLabel(LLMProvider.claude, hideRestricted: false), 'Claude');
      expect(homeWidgetProviderLabel(LLMProvider.gemini, hideRestricted: false), 'Gemini');
      expect(homeWidgetProviderLabel(LLMProvider.openRouter, hideRestricted: false), 'OpenRouter');
    });
  });

  group('Moments Isolation & Live Activity Bridge', () {
    test('starting, updating, and ending live activity does not require momentsEnabled', () async {
      final methodCalls = <MethodCall>[];
      const channel = MethodChannel('com.nativetavern/home_widgets');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        methodCalls.add(call);
        if (call.method == 'getContainerPath') return '/mock/container';
        return null;
      });

      final bridge = HomeWidgetBridge(
        channel: channel,
        supportedOverride: () => true,
      );

      const momentsEnabled = false;
      expect(momentsEnabled, isFalse, reason: 'Moments feature explicitly disabled');

      final started = DateTime.utc(2026, 9, 10, 15, 0);
      final liveState = HomeWidgetLiveState(
        active: true,
        chatId: 'chat-99',
        characterId: 'char-1',
        characterName: 'Seraphina',
        snippet: 'Thinking...',
        phase: HomeWidgetLivePhase.generating,
        providerLabel: 'DeepSeek',
        deepLink: 'nativetavern://widget/chat?id=chat-99',
        startedAt: started,
        updatedAt: started,
      );

      // 1. Start live
      await bridge.startLive(liveState);
      expect(methodCalls.any((c) => c.method == 'startLive'), isTrue);
      final startPayload = jsonDecode(
        methodCalls.firstWhere((c) => c.method == 'startLive').arguments['json'] as String,
      ) as Map<String, dynamic>;
      expect(startPayload['chatId'], 'chat-99');
      expect(startPayload['characterName'], 'Seraphina');

      // 2. Update live streaming tokens
      final updatedState = HomeWidgetLiveState(
        active: true,
        chatId: 'chat-99',
        characterId: 'char-1',
        characterName: 'Seraphina',
        snippet: 'Here is the reply as it streams.',
        phase: HomeWidgetLivePhase.generating,
        providerLabel: 'DeepSeek',
        deepLink: 'nativetavern://widget/chat?id=chat-99',
        startedAt: started,
        updatedAt: DateTime.utc(2026, 9, 10, 15, 0, 1),
      );
      await bridge.updateLive(updatedState);
      expect(methodCalls.any((c) => c.method == 'updateLive'), isTrue);

      // 3. End live
      await bridge.endLive(HomeWidgetLiveState.idle());
      expect(methodCalls.any((c) => c.method == 'endLive'), isTrue);

      // Clean mock handler
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });
}
