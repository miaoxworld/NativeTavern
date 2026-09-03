import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/database/database.dart' hide Chat, Message;
import 'package:native_tavern/data/models/character.dart' as models;
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/long_term_memory.dart';
import 'package:native_tavern/data/models/moment/moment_post.dart';
import 'package:native_tavern/data/repositories/character_friendship_repository.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/drift_long_term_memory_repository.dart';
import 'package:native_tavern/data/repositories/drift_moment_repository.dart';
import 'package:native_tavern/data/repositories/group_repository.dart';
import 'package:native_tavern/domain/services/character_social_service.dart';
import 'package:native_tavern/domain/services/chat_generation_pipeline.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/moment_context_contributor.dart';
import 'package:native_tavern/domain/services/moment_service.dart';
import 'dart:io';

void main() {
  late AppDatabase database;
  late Directory dataDirectory;
  late CharacterRepository characters;
  late GroupRepository groups;
  late CharacterFriendshipRepository friendships;
  late CharacterSocialService social;
  late DriftMomentRepository moments;
  late DriftLongTermMemoryRepository memories;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataDirectory = Directory.systemTemp.createTempSync('nt_social');
    characters = CharacterRepository(database, dataDirectory.path);
    groups = GroupRepository(database);
    friendships = CharacterFriendshipRepository(database);
    social = CharacterSocialService(
      friendships: friendships,
      groups: groups,
      characters: characters,
    );
    moments = DriftMomentRepository(database);
    memories = DriftLongTermMemoryRepository(database);
    final now = DateTime.now();
    await characters.createCharacter(
      models.Character(
        id: 'ava',
        name: 'Ava',
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await characters.createCharacter(
      models.Character(
        id: 'ben',
        name: 'Ben',
        createdAt: now,
        modifiedAt: now,
      ),
    );
    await characters.createCharacter(
      models.Character(
        id: 'cora',
        name: 'Cora',
        createdAt: now,
        modifiedAt: now,
      ),
    );
  });

  tearDown(() async {
    await database.close();
    dataDirectory.deleteSync(recursive: true);
  });

  test('group-mates become friends and can comment on each other', () async {
    await groups
        .createGroup(name: 'Garden', characterIds: const ['ava', 'ben']);
    final ava = (await characters.getCharacter('ava'))!;
    final added = await social.addGroupMates(character: ava);
    expect(added, hasLength(1));
    expect(await friendships.areFriends('ava', 'ben'), isTrue);
    expect((await social.friendsOf('ava')).single.name, 'Ben');

    final service = MomentService(
      momentRepository: moments,
      dataPath: dataDirectory.path,
      social: social,
      memories: memories,
      minInterval: Duration.zero,
      transport: (messages, config) async {
        final system = messages.first['content'] as String;
        if (system.contains('commenting on a moments post')) {
          return '{"post_id":"post-ava","body":"Saw the gate."}';
        }
        return '{"kind":"text","body":"Locked it."}';
      },
    );

    await service.createPost(
      authorId: 'ava',
      authorName: 'Ava',
      origin: MomentPostOrigin.character,
      body: 'The gate is locked.',
    );
    // Force known id for comment draft by creating a second named post via repo
    await moments.create(
      MomentPost(
        id: 'post-ava',
        authorId: 'ava',
        authorName: 'Ava',
        publicBody: 'Evening light.',
        origin: MomentPostOrigin.character,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    final comment = await service.considerFriendComment(
      character: (await characters.getCharacter('ben'))!,
      config: _llm,
    );
    expect(comment?.body, 'Saw the gate.');
    expect(comment?.authorId, 'ben');

    final stored = await memories.findByScope(
      MemoryScope.character('ava'),
      states: {MemoryState.active},
    );
    expect(
      stored.map((memory) => memory.content).join('\n'),
      contains('moments'),
    );
  });

  test('a character only knows friends, the player, and related comments',
      () async {
    await groups
        .createGroup(name: 'Garden', characterIds: const ['ava', 'ben']);
    final ava = (await characters.getCharacter('ava'))!;
    await social.addGroupMates(character: ava);

    final service = MomentService(
      momentRepository: moments,
      dataPath: dataDirectory.path,
      social: social,
      memories: memories,
      minInterval: Duration.zero,
      transport: (messages, config) async {
        final user = messages.last['content'] as String;
        expect(user, contains('Evening light'));
        expect(user, contains('Saw the gate'));
        expect(user, contains('Tea tonight'));
        expect(user, contains('Looks warm'));
        expect(user, isNot(contains('Secret from Cora')));
        expect(user, isNot(contains('Hidden comment')));
        return '{"skip":true}';
      },
    );

    await moments.create(
      MomentPost(
        id: 'post-ava',
        authorId: 'ava',
        authorName: 'Ava',
        publicBody: 'Evening light.',
        origin: MomentPostOrigin.character,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await service.comment(
      postId: 'post-ava',
      body: 'Saw the gate.',
      authorId: 'ben',
      authorName: 'Ben',
    );
    await service.publishPlayerPost(body: 'Tea tonight.');
    final playerPosts = (await service.loadFeed())
        .where((item) => item.post.authorId == MomentService.userAuthorId);
    await service.comment(
      postId: playerPosts.first.post.id,
      body: 'Looks warm.',
      authorId: 'ava',
      authorName: 'Ava',
    );
    await moments.create(
      MomentPost(
        id: 'post-cora',
        authorId: 'cora',
        authorName: 'Cora',
        publicBody: 'Secret from Cora.',
        origin: MomentPostOrigin.character,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await service.comment(
      postId: 'post-cora',
      body: 'Hidden comment.',
      authorId: 'cora',
      authorName: 'Cora',
    );

    final visible = await service.visibleFeedFor('ben');
    final visibleText = MomentService.formatVisibleMoments(visible);
    expect(visibleText, contains('Evening light'));
    expect(visibleText, contains('Saw the gate'));
    expect(visibleText, contains('Tea tonight'));
    expect(visibleText, contains('Looks warm'));
    expect(visibleText, isNot(contains('Secret from Cora')));
    expect(visibleText, isNot(contains('Hidden comment')));

    final coraVisible = MomentService.formatVisibleMoments(
      await service.visibleFeedFor('cora'),
    );
    expect(coraVisible, contains('Tea tonight'));
    expect(coraVisible, contains('Looks warm'));
    expect(coraVisible, contains('Secret from Cora'));
    expect(coraVisible, contains('Hidden comment'));
    expect(coraVisible, isNot(contains('Evening light')));

    await service.considerCharacter(
      character: (await characters.getCharacter('ben'))!,
      config: _llm,
    );

    final playerPostId = playerPosts.first.post.id;
    final strangerComment = await MomentService(
      momentRepository: moments,
      dataPath: dataDirectory.path,
      social: social,
      minInterval: Duration.zero,
      transport: (messages, config) async {
        final user = messages.last['content'] as String;
        expect(user, isNot(contains('post-cora')));
        expect(user, isNot(contains('Secret from Cora')));
        return '{"post_id":"post-cora","body":"I should not see this."}';
      },
    ).considerFriendComment(
      character: (await characters.getCharacter('ben'))!,
      config: _llm,
    );
    expect(strangerComment, isNull);

    final playerComment = await MomentService(
      momentRepository: moments,
      dataPath: dataDirectory.path,
      social: social,
      minInterval: Duration.zero,
      transport: (messages, config) async {
        final user = messages.last['content'] as String;
        expect(user, contains(playerPostId));
        expect(user, contains('Tea tonight'));
        expect(user, isNot(contains('post-cora')));
        return '{"post_id":"$playerPostId","body":"Save me a cup."}';
      },
    ).considerFriendComment(
      character: (await characters.getCharacter('ben'))!,
      config: _llm,
    );
    expect(playerComment?.body, 'Save me a cup.');
    expect(playerComment?.postId, playerPostId);
  });

  test('chat knowledge only injects moments the character can see', () async {
    await groups
        .createGroup(name: 'Garden', characterIds: const ['ava', 'ben']);
    await social.addGroupMates(
        character: (await characters.getCharacter('ava'))!);

    final service = MomentService(
      momentRepository: moments,
      dataPath: dataDirectory.path,
      social: social,
    );
    await moments.create(
      MomentPost(
        id: 'post-ava',
        authorId: 'ava',
        authorName: 'Ava',
        publicBody: 'Evening light.',
        origin: MomentPostOrigin.character,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    await service.publishPlayerPost(body: 'Tea tonight.');
    await moments.create(
      MomentPost(
        id: 'post-cora',
        authorId: 'cora',
        authorName: 'Cora',
        publicBody: 'Secret from Cora.',
        origin: MomentPostOrigin.character,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    final contributor = MomentContextContributor(
      moments: service,
      enabled: () => true,
      chatEnabled: (_) async => true,
    );
    final registry = ChatExtensionRegistry()..registerContributor(contributor);
    final pipeline = ChatGenerationPipeline(registry: registry);
    final session = pipeline.startSession(
      chatId: 'chat-ben',
      characterId: 'ben',
      mode: ChatGenerationMode.send,
      config: _llm,
    );
    final assembly = await session.assemble(const [
      {'role': 'system', 'content': 'Stay in character.'},
      {'role': 'user', 'content': 'What did you see?'},
    ]);
    final injected = assembly.messages
        .map((message) => message['content'] as String)
        .join('\n');
    expect(injected, contains('Evening light'));
    expect(injected, contains('Tea tonight'));
    expect(injected, isNot(contains('Secret from Cora')));
    session.close();
    await pipeline.dispose();
  });

  test('chat stays independent until moments-in-chat is turned on', () async {
    await groups
        .createGroup(name: 'Garden', characterIds: const ['ava', 'ben']);
    await social.addGroupMates(
      character: (await characters.getCharacter('ava'))!,
    );
    final service = MomentService(
      momentRepository: moments,
      dataPath: dataDirectory.path,
      social: social,
    );
    await moments.create(
      MomentPost(
        id: 'post-ava',
        authorId: 'ava',
        authorName: 'Ava',
        publicBody: 'Evening light.',
        origin: MomentPostOrigin.character,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    Future<String> assembleWith({
      required Future<bool> Function(String chatId)? chatEnabled,
    }) async {
      final contributor = MomentContextContributor(
        moments: service,
        enabled: () => true,
        chatEnabled: chatEnabled,
      );
      final registry = ChatExtensionRegistry()
        ..registerContributor(contributor);
      final pipeline = ChatGenerationPipeline(registry: registry);
      final session = pipeline.startSession(
        chatId: 'chat-ben',
        characterId: 'ben',
        mode: ChatGenerationMode.send,
        config: _llm,
      );
      final assembly = await session.assemble(const [
        {'role': 'system', 'content': 'Stay in character.'},
        {'role': 'user', 'content': 'What did you see?'},
      ]);
      final text = assembly.messages
          .map((message) => message['content'] as String)
          .join('\n');
      session.close();
      await pipeline.dispose();
      return text;
    }

    final offByDefault = await assembleWith(chatEnabled: null);
    expect(offByDefault, isNot(contains('Evening light')));
    expect(
      Chat(
        id: 'chat-ben',
        characterId: 'ben',
        title: 'Ben',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).momentsInChat,
      isFalse,
    );

    final optedIn = await assembleWith(chatEnabled: (_) async => true);
    expect(optedIn, contains('Evening light'));
  });
}

const _llm = LLMConfig(
  provider: LLMProvider.openai,
  model: 'chat-model',
  apiKey: 'secret',
  apiUrl: 'https://example.com/v1',
  streamEnabled: false,
);
