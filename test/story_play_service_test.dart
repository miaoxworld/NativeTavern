import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart' hide Chat, Message;
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/long_term_memory.dart';
import 'package:native_tavern/data/models/story/story_chapter.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/drift_story_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/repositories/story_repository.dart';
import 'package:native_tavern/domain/services/story_play_service.dart';
import 'package:native_tavern/domain/services/story_memory_scope_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late ChatRepository chats;
  late StoryRepository stories;
  late StoryPlayService play;
  var generatedId = 0;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.customSelect('SELECT 1').get();
    final now = DateTime.utc(2026, 8, 23);
    await database.into(database.characters).insert(
          CharactersCompanion.insert(
            id: 'character-1',
            name: 'Story Tester',
            createdAt: now,
            modifiedAt: now,
          ),
        );
    chats = ChatRepository(database);
    stories = DriftStoryRepository(database);
    play = StoryPlayService(
      chatRepository: chats,
      storyRepository: stories,
      createId: () => 'generated-${generatedId++}',
    );
  });

  tearDown(() => database.close());

  test('fork preserves source and copies messages and chapters through node',
      () async {
    await _createChat(chats, 'root');
    final messages = await _addMessages(chats, 'root', 6);
    final first = await _createChapter(
      stories,
      id: 'root-chapter-1',
      chatId: 'root',
      messages: messages,
      start: 0,
      end: 1,
      title: 'Arrival',
    );
    final forkPoint = await _createChapter(
      stories,
      id: 'root-chapter-2',
      chatId: 'root',
      messages: messages,
      start: 2,
      end: 3,
      title: 'The locked gate',
      narrative: const StoryChapterNarrative(
        keyEvents: ['The gate was locked.'],
        stateChanges: ['Mara now carries the key.'],
        openThreads: ['Who locked the gate?'],
        nextSteps: ['Ask Mara about the key.'],
      ),
    );
    await _createChapter(
      stories,
      id: 'root-chapter-3',
      chatId: 'root',
      messages: messages,
      start: 4,
      end: 5,
      title: 'Original aftermath',
    );

    final result = await play.forkFromChapter(
      chapterId: forkPoint.id,
      branchTitle: 'Follow Mara',
    );

    expect(await chats.getMessages('root'), hasLength(6));
    expect(await stories.listByChatId('root'), hasLength(3));
    final copiedMessages = await chats.getMessages(result.chat.id);
    expect(copiedMessages, hasLength(4));
    expect(
      copiedMessages.map((message) => message.content),
      messages.take(4).map((message) => message.content),
    );
    expect(
      copiedMessages.map((message) => message.id).toSet(),
      isNot(contains(first.startMessageId)),
    );

    expect(result.copiedChapters, hasLength(2));
    final copiedForkPoint = result.copiedChapters.singleWhere(
      (chapter) => chapter.title == forkPoint.title,
    );
    expect(copiedForkPoint.chatId, result.chat.id);
    expect(copiedForkPoint.startMessageId, copiedMessages[2].id);
    expect(copiedForkPoint.endMessageId, copiedMessages[3].id);
    expect(copiedForkPoint.narrative, forkPoint.narrative);
    expect(copiedForkPoint.createdAt, forkPoint.createdAt);
    expect(copiedForkPoint.updatedAt, forkPoint.updatedAt);

    final persistedRoot = await chats.getChat('root');
    final persistedBranch = await chats.getChat(result.chat.id);
    expect(persistedRoot!.settings[storyRootChatIdKey], 'root');
    expect(persistedBranch!.settings, containsPair(storyRootChatIdKey, 'root'));
    expect(
      persistedBranch.settings,
      containsPair(storyParentChatIdKey, 'root'),
    );
    expect(
      persistedBranch.settings,
      containsPair(storyForkChapterIdKey, forkPoint.id),
    );
    expect(persistedBranch.settings[storyForkOrdinalKey], 3);
    expect(
      persistedBranch.settings[storyBranchTitleKey],
      'Follow Mara',
    );

    final memoryScopes = StoryMemoryScopeService(chatRepository: chats);
    expect(
      await memoryScopes.readableChatScopes(result.chat.id),
      [MemoryScope.chat(result.chat.id), MemoryScope.chat('root')],
    );
    expect(
      await memoryScopes.isMemoryVisible(
        chatId: result.chat.id,
        memory: _generatedMemory('before-fork', 'root', [messages[2].id]),
      ),
      isTrue,
    );
    expect(
      await memoryScopes.isMemoryVisible(
        chatId: result.chat.id,
        memory: _generatedMemory('after-fork', 'root', [messages[5].id]),
      ),
      isFalse,
    );

    final sibling = await play.forkFromChapter(
      chapterId: forkPoint.id,
      branchTitle: 'Stay at the gate',
    );
    final branchMessage = (await _addMessages(
      chats,
      result.chat.id,
      1,
      startOrdinal: 4,
    ))
        .single;
    expect(
      await memoryScopes.isMemoryVisible(
        chatId: sibling.chat.id,
        memory: _generatedMemory(
          'sibling-fact',
          result.chat.id,
          [branchMessage.id],
        ),
      ),
      isFalse,
    );
    expect(
      await memoryScopes.isMemoryVisible(
        chatId: sibling.chat.id,
        memory: LongTermMemory(
          id: 'manual-shared',
          kind: MemoryKind.personFact,
          scope: MemoryScope.character('character-1'),
          state: MemoryState.active,
          content: 'Mara has green eyes.',
          createdAt: DateTime.utc(2026, 8, 23),
          normalizedIdentityKey: 'person:mara:eyes',
        ),
      ),
      isTrue,
    );
  });

  test('comparison uses the real common ancestor for nested branches',
      () async {
    await _createChat(chats, 'root');
    final rootMessages = await _addMessages(chats, 'root', 4);
    final rootForkPoint = await _createChapter(
      stories,
      id: 'root-fork',
      chatId: 'root',
      messages: rootMessages,
      start: 0,
      end: 1,
      title: 'Shared opening',
    );
    final firstFork = await play.forkFromChapter(
      chapterId: rootForkPoint.id,
      branchTitle: 'First branch',
    );

    final firstBranchMessages = await _addMessages(
      chats,
      firstFork.chat.id,
      2,
      startOrdinal: 2,
    );
    final allFirstBranchMessages = [
      ...await chats.getMessages(firstFork.chat.id),
    ];
    expect(firstBranchMessages, hasLength(2));
    final nestedForkPoint = await _createChapter(
      stories,
      id: 'first-branch-shared',
      chatId: firstFork.chat.id,
      messages: allFirstBranchMessages,
      start: 2,
      end: 3,
      title: 'Promise at the bridge',
      narrative: const StoryChapterNarrative(
        stateChanges: ['Both lines promised to return.'],
      ),
    );
    final nestedFork = await play.forkFromChapter(
      chapterId: nestedForkPoint.id,
      branchTitle: 'Break the promise',
    );

    await _addMessages(
      chats,
      firstFork.chat.id,
      2,
      startOrdinal: 4,
    );
    final leftMessages = await chats.getMessages(firstFork.chat.id);
    await _createChapter(
      stories,
      id: 'left-outcome',
      chatId: firstFork.chat.id,
      messages: leftMessages,
      start: 4,
      end: 5,
      title: 'The promise kept',
      narrative: const StoryChapterNarrative(
        stateChanges: ['Mara trusts the traveler.'],
        openThreads: ['The sealed letter remains unread.'],
      ),
    );

    await _addMessages(
      chats,
      nestedFork.chat.id,
      2,
      startOrdinal: 4,
    );
    final rightMessages = await chats.getMessages(nestedFork.chat.id);
    await _createChapter(
      stories,
      id: 'right-outcome',
      chatId: nestedFork.chat.id,
      messages: rightMessages,
      start: 4,
      end: 5,
      title: 'The promise broken',
      narrative: const StoryChapterNarrative(
        stateChanges: ['Mara no longer trusts the traveler.'],
        openThreads: ['Can the promise be repaired?'],
      ),
    );

    final comparison = await play.compare(
      leftChatId: firstFork.chat.id,
      rightChatId: nestedFork.chat.id,
    );

    expect(comparison.divergenceOrdinal, 3);
    expect(
      comparison.left.chapters.map((chapter) => chapter.title),
      ['The promise kept'],
    );
    expect(
      comparison.right.chapters.map((chapter) => chapter.title),
      ['The promise broken'],
    );
    expect(
      comparison.left.stateChanges,
      ['Mara trusts the traveler.'],
    );
    expect(
      comparison.right.stateChanges,
      ['Mara no longer trusts the traveler.'],
    );
  });

  test('jot note persists a manual playable chapter', () async {
    await _createChat(chats, 'root');
    final messages = await _addMessages(chats, 'root', 2);

    final chapter = await play.jotNote(
      chatId: 'root',
      note: 'The compass points beneath the old station.',
    );
    final persisted = await stories.getById(chapter.id);

    expect(persisted, isNotNull);
    expect(persisted!.origin, StoryChapterOrigin.manual);
    expect(persisted.startMessageId, messages.first.id);
    expect(persisted.endMessageId, messages.last.id);
    expect(
      persisted.narrative.keyEvents,
      ['The compass points beneath the old station.'],
    );
  });

  test('renameStory updates the root chat title', () async {
    await _createChat(chats, 'root');
    final updated = await play.renameStory(
      rootChatId: 'root',
      newTitle: 'The New Chronicles',
    );

    expect(updated.title, 'The New Chronicles');
    final fetched = await chats.getChat('root');
    expect(fetched?.title, 'The New Chronicles');
  });

  test('generateStoryTitle generates and sanitizes title via transport', () async {
    await _createChat(chats, 'root');
    await _addMessages(chats, 'root', 2);
    final playWithLlm = StoryPlayService(
      chatRepository: chats,
      storyRepository: stories,
      createId: () => 'test-id',
      transport: (messages, config) async => '"A Tale of Mystery"',
    );

    final title = await playWithLlm.generateStoryTitle(
      rootChatId: 'root',
      config: const LLMConfig(
        provider: LLMProvider.openAICompatible,
        model: 'test-model',
        apiKey: 'test-key',
        apiUrl: 'http://localhost',
      ),
    );
    expect(title, 'A Tale of Mystery');
  });
}

Future<void> _createChat(ChatRepository chats, String id) async {
  final now = DateTime.utc(2026, 8, 23);
  await chats.createChat(
    Chat(
      id: id,
      characterId: 'character-1',
      title: 'Harbor story',
      createdAt: now,
      updatedAt: now,
    ),
  );
}

Future<List<ChatMessage>> _addMessages(
  ChatRepository chats,
  String chatId,
  int count, {
  int startOrdinal = 0,
}) async {
  final messages = <ChatMessage>[];
  for (var index = 0; index < count; index++) {
    final ordinal = startOrdinal + index;
    messages.add(
      await chats.addMessage(
        ChatMessage(
          id: '$chatId-message-$ordinal',
          chatId: chatId,
          role: ordinal.isEven ? MessageRole.user : MessageRole.assistant,
          content: '$chatId message $ordinal',
          timestamp: DateTime.utc(2026, 8, 23, 0, ordinal),
        ),
      ),
    );
  }
  return messages;
}

Future<StoryChapter> _createChapter(
  StoryRepository stories, {
  required String id,
  required String chatId,
  required List<ChatMessage> messages,
  required int start,
  required int end,
  required String title,
  StoryChapterNarrative narrative = const StoryChapterNarrative(),
}) {
  return stories.create(
    StoryChapter(
      id: id,
      chatId: chatId,
      title: title,
      summary: '$title summary',
      narrative: narrative,
      startMessageId: messages[start].id,
      endMessageId: messages[end].id,
      startOrdinal: start,
      endOrdinal: end,
      createdAt: DateTime.utc(2026, 8, 23, 1, end),
    ),
  );
}

LongTermMemory _generatedMemory(
  String id,
  String chatId,
  List<String> messageIds,
) {
  final now = DateTime.utc(2026, 8, 23, 2);
  return LongTermMemory(
    id: id,
    kind: MemoryKind.event,
    scope: MemoryScope.character('character-1'),
    state: MemoryState.active,
    content: '$id content',
    source: MemorySource.generated(
      sourceChatId: chatId,
      sourceMessageIds: messageIds,
      extractedAt: now,
      providerId: 'test-provider',
      modelId: 'test-model',
    ),
    createdAt: now,
    normalizedIdentityKey: 'event:$id',
  );
}
