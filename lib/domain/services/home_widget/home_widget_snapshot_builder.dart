import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/provider_usage.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/repositories/moment_repository.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_slideshow.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/provider_usage_service.dart';

class HomeWidgetSnapshotBuilder {
  HomeWidgetSnapshotBuilder({
    required CharacterRepository characters,
    required ChatRepository chats,
    required MomentRepository moments,
    required ProviderUsageService usage,
    HomeWidgetSlideshow slideshow = const HomeWidgetSlideshow(),
    DateTime Function()? clock,
  })  : _characters = characters,
        _chats = chats,
        _moments = moments,
        _usage = usage,
        _slideshow = slideshow,
        _clock = clock ?? DateTime.now;

  final CharacterRepository _characters;
  final ChatRepository _chats;
  final MomentRepository _moments;
  final ProviderUsageService _usage;
  final HomeWidgetSlideshow _slideshow;
  final DateTime Function() _clock;

  Future<HomeWidgetSnapshot> build({
    required LLMConfig config,
    required HomeWidgetSettings settings,
    required HomeWidgetLabels labels,
    required String locale,
    RemoteProviderUsage? remote,
    String Function(LLMProvider provider)? providerLabel,
    HomeWidgetTheme theme = HomeWidgetTheme.nativetavernDark,
    bool? reachable,
  }) async {
    final now = _clock();
    final characters = await _buildCharacters(settings);
    final chats = await _buildChats(settings, characters);
    final moments = await _buildMoments(settings);
    final today = await _usage.today(config);
    final allTime = await _usage.totalsFor(config);
    final health = _health(config, reachable);

    return HomeWidgetSnapshot(
      updatedAt: now,
      locale: locale,
      settings: settings,
      labels: labels,
      theme: theme,
      moments: moments,
      chats: chats,
      characters: characters,
      status: StatusWidgetPayload(
        provider: config.provider.name,
        providerLabel: providerLabel?.call(config.provider) ??
            config.provider.name,
        model: config.model,
        health: health,
        tokensToday: today.totalTokens,
        tokensTotal: allTime.totalTokens,
        generationsToday: today.generationCount,
        costUsdToday: today.costUsd,
        remoteRemaining: remote?.remaining,
        remoteUnit: remote?.unit ?? remote?.currency,
        remoteDetail: remote?.detail,
        remoteSupported: remote?.supported ?? false,
        deepLink: const HomeWidgetDeepLink(
          target: HomeWidgetDeepLinkTarget.aiConfig,
          kind: HomeWidgetKind.status,
        ).toUri().toString(),
      ),
    );
  }

  Future<List<CharacterWidgetItem>> _buildCharacters(
    HomeWidgetSettings settings,
  ) async {
    final all = await _characters.getAllCharacters();
    final pin = settings.pinnedCharacterId;
    var filtered = all;
    if (pin != null && pin.isNotEmpty) {
      filtered = all.where((character) => character.id == pin).toList();
    } else if (settings.favoritesOnlyCharacters) {
      filtered = all.where((character) => character.isFavorite).toList();
    }
    filtered.sort((a, b) {
      if (a.isFavorite != b.isFavorite) {
        return a.isFavorite ? -1 : 1;
      }
      return b.modifiedAt.compareTo(a.modifiedAt);
    });
    return filtered.take(settings.characterLimit).map((character) {
      return CharacterWidgetItem(
        id: character.id,
        name: character.name,
        description: _snippet(character.description, 160),
        isFavorite: character.isFavorite,
        avatar: HomeWidgetImageRef(path: character.assets?.avatarPath),
        deepLink: HomeWidgetDeepLink(
          target: HomeWidgetDeepLinkTarget.character,
          id: character.id,
          kind: HomeWidgetKind.characters,
        ).toUri().toString(),
      );
    }).toList(growable: false);
  }

  Future<List<ChatWidgetSlide>> _buildChats(
    HomeWidgetSettings settings,
    List<CharacterWidgetItem> characters,
  ) async {
    final pool = settings.recentChatLimit * 4;
    var chats = await _chats.getRecentChats(limit: pool);
    final pin = settings.pinnedCharacterId;
    if (pin != null && pin.isNotEmpty) {
      chats = chats.where((chat) => chat.characterId == pin).toList();
    } else if (settings.favoriteChatsOnly) {
      final favoriteIds = {
        for (final character in await _characters.getAllCharacters())
          if (character.isFavorite) character.id,
      };
      chats = chats
          .where((chat) => favoriteIds.contains(chat.characterId))
          .toList();
    }
    if (chats.length > settings.recentChatLimit) {
      chats = chats.take(settings.recentChatLimit).toList();
    }
    final sources = <ChatSlideshowSource>[];
    for (final chat in chats) {
      final messages = await _chats.getMessagesPage(
        chat.id,
        limit: settings.messagesPerChat,
      );
      Character? character;
      try {
        character = await _characters.getCharacter(chat.characterId);
      } catch (_) {
        character = null;
      }
      final name = character?.name ??
          characters
              .where((item) => item.id == chat.characterId)
              .map((item) => item.name)
              .firstOrNull ??
          chat.title;
      sources.add(
        ChatSlideshowSource(
          chatId: chat.id,
          characterId: chat.characterId,
          characterName: name,
          title: chat.title,
          avatar: HomeWidgetImageRef(path: character?.assets?.avatarPath),
          messages: messages
              .where((message) => message.role != MessageRole.system)
              .map(
                (message) => ChatSlideshowMessage(
                  role: message.role.name,
                  body: _snippet(message.content, 220),
                  timestamp: message.timestamp,
                ),
              )
              .toList(),
        ),
      );
    }
    return _slideshow.buildChatSlides(sources, settings: settings);
  }

  Future<List<MomentWidgetItem>> _buildMoments(
    HomeWidgetSettings settings,
  ) async {
    final posts = await _moments.listPage(limit: settings.momentLimit);
    return posts
        .map(
          (post) => MomentWidgetItem(
            id: post.id,
            authorName: post.authorName,
            body: _snippet(post.publicBody, 180),
            createdAt: post.createdAt,
            image: HomeWidgetImageRef(path: post.imagePath),
            deepLink: const HomeWidgetDeepLink(
              target: HomeWidgetDeepLinkTarget.moments,
              kind: HomeWidgetKind.moments,
            ).toUri().toString(),
          ),
        )
        .toList(growable: false);
  }

  HomeWidgetProviderHealth _health(LLMConfig config, bool? reachable) {
    if (!config.provider.isLocalServer && config.apiKey.trim().isEmpty) {
      return HomeWidgetProviderHealth.needsKey;
    }
    if (reachable == false) {
      return HomeWidgetProviderHealth.unreachable;
    }
    if (config.provider.isLocalServer) {
      return HomeWidgetProviderHealth.local;
    }
    return HomeWidgetProviderHealth.ready;
  }

  static String _snippet(String value, int max) {
    final trimmed = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (trimmed.length <= max) return trimmed;
    return '${trimmed.substring(0, max).trimRight()}…';
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
