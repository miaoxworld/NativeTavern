import 'dart:math';

import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';

class ChatSlideshowSource {
  final String chatId;
  final String characterId;
  final String characterName;
  final String title;
  final HomeWidgetImageRef avatar;
  final List<ChatSlideshowMessage> messages;

  const ChatSlideshowSource({
    required this.chatId,
    required this.characterId,
    required this.characterName,
    required this.title,
    this.avatar = const HomeWidgetImageRef(),
    required this.messages,
  });
}

class ChatSlideshowMessage {
  final String role;
  final String body;
  final DateTime timestamp;

  const ChatSlideshowMessage({
    required this.role,
    required this.body,
    required this.timestamp,
  });
}

/// Builds the chat widget's slide list: latest chats, then the latest N
/// messages of each chat in chronological order. Optional shuffle only
/// reorders chats, never the messages inside a chat.
class HomeWidgetSlideshow {
  const HomeWidgetSlideshow();

  List<ChatWidgetSlide> buildChatSlides(
    List<ChatSlideshowSource> chats, {
    required HomeWidgetSettings settings,
    Random? random,
  }) {
    if (chats.isEmpty) return const [];
    final limited = chats.take(settings.recentChatLimit).toList();
    if (settings.chatOrder == ChatSlideOrder.shuffled) {
      limited.shuffle(random ?? Random());
    }

    final slides = <ChatWidgetSlide>[];
    for (final chat in limited) {
      final messages = chat.messages
          .where((message) => message.body.trim().isNotEmpty)
          .toList();
      if (messages.isEmpty) continue;
      final start = max(0, messages.length - settings.messagesPerChat);
      final window = messages.sublist(start);
      for (var i = 0; i < window.length; i++) {
        final message = window[i];
        slides.add(
          ChatWidgetSlide(
            chatId: chat.chatId,
            characterId: chat.characterId,
            characterName: chat.characterName,
            title: chat.title,
            role: message.role,
            body: message.body,
            timestamp: message.timestamp,
            messageIndex: i,
            messageCount: window.length,
            avatar: chat.avatar,
            deepLink: HomeWidgetDeepLink(
              target: HomeWidgetDeepLinkTarget.chat,
              id: chat.chatId,
              kind: HomeWidgetKind.chats,
            ).toUri().toString(),
          ),
        );
      }
    }
    return slides;
  }

  /// Index of the slide that should be visible at [now], wrapping forever.
  int slideIndex({
    required int count,
    required DateTime now,
    required DateTime epoch,
    required int intervalSeconds,
  }) {
    if (count <= 0) return 0;
    final interval = intervalSeconds <= 0 ? 8 : intervalSeconds;
    final elapsed = now.difference(epoch).inSeconds;
    if (elapsed <= 0) return 0;
    return (elapsed ~/ interval) % count;
  }

  /// Wraps [current] + [delta] into `0..count-1`.
  int wrapIndex({
    required int current,
    required int delta,
    required int count,
  }) {
    if (count <= 0) return 0;
    return ((current + delta) % count + count) % count;
  }
}
