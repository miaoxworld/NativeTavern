import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart' hide Chat, Message;
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/services/chat_naming_service.dart';
import 'package:native_tavern/domain/services/llm_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late ChatRepository chatRepo;
  late CharacterRepository characterRepo;

  const testConfig = LLMConfig(
    provider: LLMProvider.openai,
    model: 'gpt-4o',
    apiKey: 'test-key',
    apiUrl: 'https://api.openai.com/v1',
  );

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.customSelect('SELECT 1').get();

    final now = DateTime.utc(2026, 8, 23);
    await database.into(database.characters).insert(
          CharactersCompanion.insert(
            id: 'char-1',
            name: 'Aria',
            createdAt: now,
            modifiedAt: now,
          ),
        );

    chatRepo = ChatRepository(database);
    characterRepo = CharacterRepository(database, '/tmp');
  });

  tearDown(() => database.close());

  test('renameChat updates chat title successfully', () async {
    final chat = await chatRepo.createChat(
      Chat(
        id: 'chat-1',
        characterId: 'char-1',
        title: 'Original Title',
        createdAt: DateTime.utc(2026, 8, 23),
        updatedAt: DateTime.utc(2026, 8, 23),
      ),
    );

    final service = ChatNamingService(
      chatRepository: chatRepo,
      characterRepository: characterRepo,
    );

    final updated = await service.renameChat(
      chatId: chat.id,
      newTitle: 'The Midnight Stroll',
    );

    expect(updated.title, 'The Midnight Stroll');

    final fetched = await chatRepo.getChat(chat.id);
    expect(fetched?.title, 'The Midnight Stroll');
  });

  test('renameChat throws ArgumentError when title is blank', () async {
    await chatRepo.createChat(
      Chat(
        id: 'chat-blank',
        characterId: 'char-1',
        title: 'Original',
        createdAt: DateTime.utc(2026, 8, 23),
        updatedAt: DateTime.utc(2026, 8, 23),
      ),
    );

    final service = ChatNamingService(
      chatRepository: chatRepo,
      characterRepository: characterRepo,
    );

    expect(
      () => service.renameChat(chatId: 'chat-blank', newTitle: '   '),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('generateChatTitle invokes transport and cleans quotes/symbols', () async {
    await chatRepo.createChat(
      Chat(
        id: 'chat-llm',
        characterId: 'char-1',
        title: 'Old Title',
        createdAt: DateTime.utc(2026, 8, 23),
        updatedAt: DateTime.utc(2026, 8, 23),
      ),
    );

    await chatRepo.addMessage(
      ChatMessage(
        id: 'msg-1',
        chatId: 'chat-llm',
        role: MessageRole.user,
        content: 'Tell me about the hidden temple.',
        timestamp: DateTime.utc(2026, 8, 23, 10),
      ),
    );

    await chatRepo.addMessage(
      ChatMessage(
        id: 'msg-2',
        chatId: 'chat-llm',
        role: MessageRole.assistant,
        content: 'The hidden temple lies deep within the misty mountains.',
        timestamp: DateTime.utc(2026, 8, 23, 10, 1),
      ),
    );

    final service = ChatNamingService(
      chatRepository: chatRepo,
      characterRepository: characterRepo,
      transport: (prompt, config) async {
        return '"The Hidden Temple"';
      },
    );

    final title = await service.generateChatTitle(
      chatId: 'chat-llm',
      config: testConfig,
    );

    expect(title, 'The Hidden Temple');
  });

  test('autoNameChatsForCharacter renames multiple chats for character', () async {
    await chatRepo.createChat(
      Chat(
        id: 'chat-a',
        characterId: 'char-1',
        title: 'Aria Chat',
        createdAt: DateTime.utc(2026, 8, 23, 1),
        updatedAt: DateTime.utc(2026, 8, 23, 1),
      ),
    );

    await chatRepo.addMessage(
      ChatMessage(
        id: 'msg-a',
        chatId: 'chat-a',
        role: MessageRole.user,
        content: 'Let us bake a pie.',
        timestamp: DateTime.utc(2026, 8, 23, 1, 5),
      ),
    );

    await chatRepo.createChat(
      Chat(
        id: 'chat-b',
        characterId: 'char-1',
        title: 'Aria Chat',
        createdAt: DateTime.utc(2026, 8, 23, 2),
        updatedAt: DateTime.utc(2026, 8, 23, 2),
      ),
    );

    await chatRepo.addMessage(
      ChatMessage(
        id: 'msg-b',
        chatId: 'chat-b',
        role: MessageRole.user,
        content: 'Let us travel to the stars.',
        timestamp: DateTime.utc(2026, 8, 23, 2, 5),
      ),
    );

    final service = ChatNamingService(
      chatRepository: chatRepo,
      characterRepository: characterRepo,
      transport: (prompt, config) async {
        final content = prompt.last['content'] ?? '';
        if (content.contains('bake a pie')) {
          return '**Baking Apple Pie**';
        }
        return 'Voyage to the Stars.';
      },
    );

    final results = await service.autoNameChatsForCharacter(
      characterId: 'char-1',
      config: testConfig,
    );

    expect(results['chat-a'], 'Baking Apple Pie');
    expect(results['chat-b'], 'Voyage to the Stars');

    final chatA = await chatRepo.getChat('chat-a');
    final chatB = await chatRepo.getChat('chat-b');

    expect(chatA?.title, 'Baking Apple Pie');
    expect(chatB?.title, 'Voyage to the Stars');
  });
}
