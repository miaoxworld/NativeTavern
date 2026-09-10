import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart' hide Character, Chat;
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/moment/moment_post.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/drift_moment_repository.dart';
import 'package:native_tavern/data/repositories/provider_usage_repository.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_slideshow.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_snapshot_builder.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/llm_usage_parser.dart';
import 'package:native_tavern/domain/services/provider_reachability.dart';
import 'package:native_tavern/domain/services/provider_usage_remote.dart';
import 'package:native_tavern/domain/services/provider_usage_service.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:dio/dio.dart';

void main() {
  group('LlmUsageParser', () {
    test('parses OpenAI-compatible usage', () {
      final usage = LlmUsageParser.parse({
        'usage': {
          'prompt_tokens': 11,
          'completion_tokens': 7,
          'total_tokens': 18,
        },
      });
      expect(usage?.promptTokens, 11);
      expect(usage?.completionTokens, 7);
      expect(usage?.totalTokens, 18);
    });

    test('parses Claude usage', () {
      final usage = LlmUsageParser.parse({
        'usage': {
          'input_tokens': 40,
          'output_tokens': 12,
        },
      });
      expect(usage?.promptTokens, 40);
      expect(usage?.completionTokens, 12);
      expect(usage?.totalTokens, 52);
    });

    test('parses Gemini usageMetadata and OpenRouter cost', () {
      final gemini = LlmUsageParser.parse({
        'usageMetadata': {
          'promptTokenCount': 9,
          'candidatesTokenCount': 3,
          'totalTokenCount': 12,
        },
      });
      expect(gemini?.totalTokens, 12);
      final openRouter = LlmUsageParser.parse({
        'usage': {
          'prompt_tokens': 100,
          'completion_tokens': 20,
          'total_tokens': 120,
          'cost': 0.0042,
          'completion_tokens_details': {'reasoning_tokens': 8},
        },
      });
      expect(openRouter?.costUsd, 0.0042);
      expect(openRouter?.reasoningTokens, 8);
    });

    test('returns null when usage is missing', () {
      expect(LlmUsageParser.parse({'choices': []}), isNull);
      expect(LlmUsageParser.parse('nope'), isNull);
    });
  });

  group('HomeWidgetSlideshow', () {
    const slideshow = HomeWidgetSlideshow();

    ChatSlideshowSource chat(String id, int messages) {
      return ChatSlideshowSource(
        chatId: id,
        characterId: 'c-$id',
        characterName: id,
        title: id,
        messages: [
          for (var i = 0; i < messages; i++)
            ChatSlideshowMessage(
              role: i.isEven ? 'user' : 'assistant',
              body: '$id-$i',
              timestamp: DateTime.utc(2026, 1, 1, 0, i),
            ),
        ],
      );
    }

    test('walks latest messages in order, then the next chat', () {
      final slides = slideshow.buildChatSlides(
        [chat('alpha', 5), chat('beta', 2)],
        settings: const HomeWidgetSettings(messagesPerChat: 3, recentChatLimit: 8),
      );
      expect(
        slides.map((slide) => '${slide.characterName}:${slide.body}').toList(),
        ['alpha:alpha-2', 'alpha:alpha-3', 'alpha:alpha-4', 'beta:beta-0', 'beta:beta-1'],
      );
      expect(slides.first.messageIndex, 0);
      expect(slides.first.messageCount, 3);
    });

    test('shuffle only reorders chats', () {
      final slides = slideshow.buildChatSlides(
        [chat('alpha', 2), chat('beta', 2)],
        settings: const HomeWidgetSettings(
          messagesPerChat: 2,
          chatOrder: ChatSlideOrder.shuffled,
        ),
        random: Random(4),
      );
      expect(slides, hasLength(4));
      final firstChat = slides.first.characterName;
      expect(slides.take(2).every((slide) => slide.characterName == firstChat), isTrue);
      expect(slides[0].body.endsWith('-0'), isTrue);
      expect(slides[1].body.endsWith('-1'), isTrue);
    });

    test('slide index wraps by interval', () {
      expect(
        slideshow.slideIndex(
          count: 3,
          now: DateTime.utc(2026, 1, 1, 0, 0, 17),
          epoch: DateTime.utc(2026, 1, 1),
          intervalSeconds: 8,
        ),
        2,
      );
    });

    test('wrapIndex handles next, previous, and empty lists', () {
      expect(
        slideshow.wrapIndex(current: 0, delta: 1, count: 3),
        1,
      );
      expect(
        slideshow.wrapIndex(current: 0, delta: -1, count: 3),
        2,
      );
      expect(
        slideshow.wrapIndex(current: 2, delta: 1, count: 3),
        0,
      );
      expect(
        slideshow.wrapIndex(current: 4, delta: 1, count: 0),
        0,
      );
    });
  });

  group('HomeWidgetDeepLink', () {
    test('round-trips chat and character URIs', () {
      final chat = HomeWidgetDeepLink(
        target: HomeWidgetDeepLinkTarget.chat,
        id: 'abc',
        kind: HomeWidgetKind.chats,
      );
      expect(chat.toUri().toString(), 'nativetavern://widget/chat?id=abc&kind=chats');
      expect(HomeWidgetDeepLink.tryParse(chat.toUri())?.location, '/chat/abc');
      expect(
        HomeWidgetDeepLink.tryParse(
          Uri.parse('nativetavern://widget/moments'),
        )?.location,
        '/play/moments',
      );
      expect(
        HomeWidgetDeepLink.tryParse(
          Uri.parse('https://example.com'),
        ),
        isNull,
      );
    });
  });

  group('ProviderUsageService', () {
    late AppDatabase database;
    late ProviderUsageService service;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      service = ProviderUsageService(
        repository: ProviderUsageRepository(database),
        clock: () => DateTime.utc(2026, 9, 9, 12),
      );
    });

    tearDown(() async {
      await database.close();
    });

    tearDown(RegionService.clearCache);

    test('records local tokens and aggregates today vs all-time', () async {
      const config = LLMConfig(
        provider: LLMProvider.openRouter,
        model: 'anthropic/claude-sonnet-4',
        apiKey: 'sk-or-test',
        apiUrl: 'https://openrouter.ai/api/v1',
      );
      await service.record(
        config: config,
        usage: const LlmTokenUsage(
          promptTokens: 10,
          completionTokens: 5,
          totalTokens: 15,
          costUsd: 0.01,
        ),
      );
      final today = await service.today(config);
      expect(today.totalTokens, 15);
      expect(today.generationCount, 1);
      expect(today.costUsd, 0.01);
    });

    test('does not record xAI usage in mainland China', () async {
      RegionService.debugSetChinaRegion(true);
      const xai = LLMConfig(
        provider: LLMProvider.xai,
        model: 'grok-4',
        apiKey: 'xai-test',
        apiUrl: 'https://api.x.ai/v1',
      );
      final skipped = await service.record(
        config: xai,
        usage: const LlmTokenUsage(
          promptTokens: 4,
          completionTokens: 2,
          totalTokens: 6,
        ),
      );
      expect(skipped, isNull);
      expect((await service.today(xai)).totalTokens, 0);

      RegionService.debugSetChinaRegion(false);
      final stored = await service.record(
        config: xai,
        usage: const LlmTokenUsage(
          promptTokens: 4,
          completionTokens: 2,
          totalTokens: 6,
        ),
      );
      expect(stored, isNotNull);
      expect((await service.today(xai)).totalTokens, 6);
    });
  });

  group('ProviderReachability', () {
    test('skips cloud providers that still need a key', () async {
      var pings = 0;
      final reachability = ProviderReachability(
        ping: (_) async {
          pings += 1;
          return true;
        },
      );
      expect(
        await reachability.isReachable(
          const LLMConfig(
            provider: LLMProvider.openai,
            model: 'gpt-4.1',
            apiKey: '',
            apiUrl: 'https://api.openai.com/v1',
          ),
        ),
        isNull,
      );
      expect(pings, 0);
    });

    test('caches failures until TTL and force-refresh', () async {
      var now = DateTime.utc(2026, 9, 9, 12);
      var pings = 0;
      final reachability = ProviderReachability(
        ping: (_) async {
          pings += 1;
          return false;
        },
        ttl: const Duration(minutes: 15),
        clock: () => now,
      );
      const config = LLMConfig(
        provider: LLMProvider.claude,
        model: 'claude-sonnet-4-5',
        apiKey: 'sk-ant',
        apiUrl: 'https://api.anthropic.com',
      );
      expect(await reachability.isReachable(config), isFalse);
      expect(await reachability.isReachable(config), isFalse);
      expect(pings, 1);
      now = now.add(const Duration(minutes: 16));
      expect(await reachability.isReachable(config), isFalse);
      expect(pings, 2);
      expect(await reachability.isReachable(config, force: true), isFalse);
      expect(pings, 3);
    });
  });

  group('ProviderUsageRemoteClient', () {
    test('OpenRouter key endpoint maps remaining credits', () async {
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': {
                    'usage': 12.5,
                    'limit': 100,
                    'limit_remaining': 87.5,
                    'is_free_tier': false,
                  },
                },
              ),
            );
          },
        ),
      );
      final client = ProviderUsageRemoteClient(dio: dio);
      final snapshot = await client.fetch(
        const LLMConfig(
          provider: LLMProvider.openRouter,
          model: 'openai/gpt-4.1',
          apiKey: 'sk-or',
          apiUrl: 'https://openrouter.ai/api/v1',
        ),
      );
      expect(snapshot.ok, isTrue);
      expect(snapshot.supported, isTrue);
      expect(snapshot.remaining, 87.5);
      expect(snapshot.used, 12.5);
    });

    test('local providers are unsupported without a request', () async {
      final snapshot = await ProviderUsageRemoteClient(dio: Dio()).fetch(
        const LLMConfig(
          provider: LLMProvider.ollama,
          model: 'llama3',
          apiKey: '',
          apiUrl: 'http://localhost:11434',
        ),
      );
      expect(snapshot.supported, isFalse);
      expect(snapshot.detail, 'local');
    });
  });

  group('HomeWidgetSnapshotBuilder', () {
    late AppDatabase database;
    late Directory dataDirectory;
    late CharacterRepository characters;
    late ChatRepository chats;
    late DriftMomentRepository moments;
    late ProviderUsageService usage;
    late HomeWidgetSnapshotBuilder builder;

    setUp(() async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      dataDirectory = Directory.systemTemp.createTempSync('nt-home-widgets');
      characters = CharacterRepository(database, dataDirectory.path);
      chats = ChatRepository(database);
      moments = DriftMomentRepository(database);
      usage = ProviderUsageService(
        repository: ProviderUsageRepository(database),
        clock: () => DateTime.utc(2026, 9, 9, 15),
      );
      builder = HomeWidgetSnapshotBuilder(
        characters: characters,
        chats: chats,
        moments: moments,
        usage: usage,
        clock: () => DateTime.utc(2026, 9, 9, 15),
      );
      final now = DateTime.utc(2026, 9, 9, 12);
      await characters.createCharacter(
        Character(
          id: 'ava',
          name: 'Ava',
          description: 'Keeps the spare key under the pot.',
          createdAt: now,
          modifiedAt: now,
        ),
      );
      await chats.createChat(
        Chat(
          id: 'chat-1',
          characterId: 'ava',
          title: 'Evening',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await chats.addMessage(
        ChatMessage(
          id: 'm1',
          chatId: 'chat-1',
          role: MessageRole.user,
          content: 'Did you lock the gate?',
          timestamp: now,
        ),
      );
      await chats.addMessage(
        ChatMessage(
          id: 'm2',
          chatId: 'chat-1',
          role: MessageRole.assistant,
          content: 'Of course.',
          timestamp: now.add(const Duration(minutes: 1)),
        ),
      );
      await moments.create(
        MomentPost(
          id: 'p1',
          authorId: 'ava',
          authorName: 'Ava',
          publicBody: 'The garden is quiet tonight.',
          createdAt: now,
        ),
      );
      await usage.record(
        config: const LLMConfig(
          provider: LLMProvider.claude,
          model: 'claude-sonnet-4-5',
          apiKey: 'sk-ant',
          apiUrl: 'https://api.anthropic.com',
        ),
        usage: const LlmTokenUsage(
          promptTokens: 20,
          completionTokens: 8,
          totalTokens: 28,
        ),
      );
    });

    tearDown(() async {
      await database.close();
      dataDirectory.deleteSync(recursive: true);
    });

    test('builds moments, chats, characters, and status', () async {
      final snapshot = await builder.build(
        config: const LLMConfig(
          provider: LLMProvider.claude,
          model: 'claude-sonnet-4-5',
          apiKey: 'sk-ant',
          apiUrl: 'https://api.anthropic.com',
        ),
        settings: const HomeWidgetSettings(messagesPerChat: 3),
        labels: HomeWidgetLabels.english,
        locale: 'en',
      );
      expect(snapshot.moments.single.authorName, 'Ava');
      expect(snapshot.chats, hasLength(2));
      expect(snapshot.chats.last.body, 'Of course.');
      expect(snapshot.characters.single.name, 'Ava');
      expect(snapshot.status.health, HomeWidgetProviderHealth.ready);
      expect(snapshot.status.tokensToday, 28);
      expect(snapshot.status.model, 'claude-sonnet-4-5');
    });

    test('status is needsKey when the cloud provider has no key', () async {
      final snapshot = await builder.build(
        config: const LLMConfig(
          provider: LLMProvider.openai,
          model: 'gpt-4.1',
          apiKey: '',
          apiUrl: 'https://api.openai.com/v1',
        ),
        settings: const HomeWidgetSettings(),
        labels: HomeWidgetLabels.english,
        locale: 'en',
      );
      expect(snapshot.status.health, HomeWidgetProviderHealth.needsKey);
    });

    test('status is unreachable when the provider ping fails', () async {
      final snapshot = await builder.build(
        config: const LLMConfig(
          provider: LLMProvider.openai,
          model: 'gpt-4.1',
          apiKey: 'sk-test',
          apiUrl: 'https://api.openai.com/v1',
        ),
        settings: const HomeWidgetSettings(),
        labels: HomeWidgetLabels.english,
        locale: 'en',
        reachable: false,
      );
      expect(snapshot.status.health, HomeWidgetProviderHealth.unreachable);
    });

    test('embeds the in-app theme in the snapshot', () async {
      const theme = HomeWidgetTheme(
        isDark: true,
        primary: '#112233',
        accent: '#445566',
        background: '#000000',
        surface: '#111111',
        card: '#222222',
        textPrimary: '#EEEEEE',
        textSecondary: '#AAAAAA',
      );
      final snapshot = await builder.build(
        config: const LLMConfig(
          provider: LLMProvider.claude,
          model: 'claude-sonnet-4-5',
          apiKey: 'sk-ant',
          apiUrl: 'https://api.anthropic.com',
        ),
        settings: const HomeWidgetSettings(),
        labels: HomeWidgetLabels.english,
        locale: 'en',
        theme: theme,
      );
      expect(snapshot.theme.primary, '#112233');
      expect(HomeWidgetSnapshot.fromJson(snapshot.toJson()).theme.card, '#222222');
    });

    test('pins one character and can filter chats to favorites', () async {
      final later = DateTime.utc(2026, 9, 9, 13);
      await characters.createCharacter(
        Character(
          id: 'ben',
          name: 'Ben',
          description: 'Keeps the lanterns lit.',
          isFavorite: true,
          createdAt: later,
          modifiedAt: later,
        ),
      );
      await chats.createChat(
        Chat(
          id: 'chat-2',
          characterId: 'ben',
          title: 'Lanterns',
          createdAt: later,
          updatedAt: later,
        ),
      );
      await chats.addMessage(
        ChatMessage(
          id: 'm3',
          chatId: 'chat-2',
          role: MessageRole.assistant,
          content: 'The porch is warm.',
          timestamp: later,
        ),
      );

      final pinned = await builder.build(
        config: const LLMConfig(
          provider: LLMProvider.claude,
          model: 'claude-sonnet-4-5',
          apiKey: 'sk-ant',
          apiUrl: 'https://api.anthropic.com',
        ),
        settings: const HomeWidgetSettings(pinnedCharacterId: 'ava'),
        labels: HomeWidgetLabels.english,
        locale: 'en',
      );
      expect(pinned.characters.map((item) => item.id), ['ava']);
      expect(
        pinned.chats.every((slide) => slide.characterId == 'ava'),
        isTrue,
      );

      final favorites = await builder.build(
        config: const LLMConfig(
          provider: LLMProvider.claude,
          model: 'claude-sonnet-4-5',
          apiKey: 'sk-ant',
          apiUrl: 'https://api.anthropic.com',
        ),
        settings: const HomeWidgetSettings(
          favoritesOnlyCharacters: true,
          favoriteChatsOnly: true,
        ),
        labels: HomeWidgetLabels.english,
        locale: 'en',
      );
      expect(favorites.characters.map((item) => item.id), ['ben']);
      expect(
        favorites.chats.every((slide) => slide.characterId == 'ben'),
        isTrue,
      );
    });
  });
}


