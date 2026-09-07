import 'dart:async';

import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';

/// Transport signature for executing prompt completions for chat naming.
typedef ChatLlmTransport = Future<String> Function(
  List<Map<String, String>> prompt,
  LLMConfig config,
);

/// Domain service to manage chat naming and AI-powered title generation
/// for individual and multiple chats.
class ChatNamingService {
  ChatNamingService({
    required ChatRepository chatRepository,
    required CharacterRepository characterRepository,
    ChatLlmTransport? transport,
  })  : _chats = chatRepository,
        _characters = characterRepository,
        _transport = transport;

  final ChatRepository _chats;
  final CharacterRepository _characters;
  final ChatLlmTransport? _transport;

  /// Manually rename a chat by ID.
  Future<Chat> renameChat({
    required String chatId,
    required String newTitle,
  }) async {
    final chat = await _chats.getChat(chatId);
    if (chat == null) {
      throw StateError('Chat $chatId not found.');
    }
    final trimmed = newTitle.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Chat title cannot be empty.');
    }
    final updated = chat.copyWith(
      title: trimmed,
      updatedAt: DateTime.now(),
    );
    await _chats.updateChat(updated);
    return updated;
  }

  /// Generate a concise, descriptive title for a chat using LLM.
  Future<String> generateChatTitle({
    required String chatId,
    required LLMConfig config,
  }) async {
    final transport = _transport;
    if (transport == null) {
      throw StateError('LLM transport is not configured for chat title generation.');
    }

    final chat = await _chats.getChat(chatId);
    if (chat == null) {
      throw StateError('Chat $chatId not found.');
    }

    String? characterName;
    if (chat.characterId.isNotEmpty) {
      final character = await _characters.getCharacter(chat.characterId);
      characterName = character?.name;
    }

    final messages = await _chats.getMessages(chatId);
    if (messages.isEmpty) {
      if (chat.title.trim().isNotEmpty) return chat.title.trim();
      return characterName != null ? '$characterName Chat' : 'New Chat';
    }

    final contextBuffer = StringBuffer();
    if (characterName != null) {
      contextBuffer.writeln('Character: $characterName');
    }
    contextBuffer.writeln('Recent Conversation:');
    final recent = messages.reversed.take(8).toList().reversed;
    for (final msg in recent) {
      final roleName = msg.role == MessageRole.user
          ? 'User'
          : (characterName ?? 'Assistant');
      final content = msg.content.length > 140
          ? '${msg.content.substring(0, 140)}...'
          : msg.content;
      contextBuffer.writeln('$roleName: $content');
    }

    final prompt = [
      {
        'role': 'system',
        'content':
            'You are a creative assistant. Generate a short, descriptive chat title (2 to 5 words) that summarizes the conversation between the user and ${characterName ?? 'the character'}. Return ONLY the title in plain text, without quotes, asterisks, hashtags, or punctuation at the end.',
      },
      {
        'role': 'user',
        'content':
            'Here is the conversation:\n$contextBuffer\n\nGenerate title:',
      },
    ];

    final response = await transport(
      prompt,
      config.copyWith(
        streamEnabled: false,
        temperature: 0.7,
        maxTokens: 32,
      ),
    );

    var title = response.trim();
    title = title.replaceAll(RegExp(r'^["`*_#]+|["`*_#.,:;!?]+$'), '').trim();
    if (title.isEmpty) {
      return chat.title.trim().isNotEmpty
          ? chat.title.trim()
          : (characterName != null ? '$characterName Chat' : 'New Chat');
    }
    return title;
  }

  /// Automatically generate and assign titles for all chats with a given character.
  Future<Map<String, String>> autoNameChatsForCharacter({
    required String characterId,
    required LLMConfig config,
  }) async {
    final chats = await _chats.getChatsForCharacter(characterId);
    final results = <String, String>{};

    for (final chat in chats) {
      try {
        final generated = await generateChatTitle(
          chatId: chat.id,
          config: config,
        );
        if (generated.isNotEmpty && generated != chat.title) {
          await renameChat(chatId: chat.id, newTitle: generated);
          results[chat.id] = generated;
        } else {
          results[chat.id] = chat.title;
        }
      } catch (_) {
        results[chat.id] = chat.title;
      }
    }

    return results;
  }
}
