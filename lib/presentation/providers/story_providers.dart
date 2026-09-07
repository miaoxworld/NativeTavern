import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/models/long_term_memory.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/data/models/story/story_chapter.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/drift_story_repository.dart';
import 'package:native_tavern/data/repositories/persona_repository.dart';
import 'package:native_tavern/domain/repositories/story_repository.dart';
import 'package:native_tavern/domain/services/story_pipeline.dart';
import 'package:native_tavern/domain/services/story_play_service.dart';
import 'package:native_tavern/domain/services/story_query_service.dart';
import 'package:native_tavern/domain/services/story_service.dart';
import 'package:native_tavern/presentation/providers/chat_extension_providers.dart';
import 'package:native_tavern/presentation/providers/memory_context_providers.dart';
import 'package:native_tavern/presentation/providers/memory_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return DriftStoryRepository(ref.watch(databaseProvider));
});

final storyServiceProvider = Provider<StoryService>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return StoryService.forLlm(
    storyRepository: ref.watch(storyRepositoryProvider),
    memoryRepository: ref.watch(longTermMemoryRepositoryProvider),
    chatRepository: ref.watch(chatRepositoryProvider),
    llmService: ref.watch(llmServiceProvider),
    turnsPerChapter: settings.storyTurnsPerChapter,
    highConfidenceThreshold: settings.storyHighConfidenceThreshold,
  );
});

final storyQueryServiceProvider = Provider<StoryQueryService>((ref) {
  return StoryQueryService(
    storyRepository: ref.watch(storyRepositoryProvider),
    memoryRepository: ref.watch(longTermMemoryRepositoryProvider),
  );
});

final storyPlayServiceProvider = Provider<StoryPlayService>((ref) {
  return StoryPlayService(
    chatRepository: ref.watch(chatRepositoryProvider),
    storyRepository: ref.watch(storyRepositoryProvider),
    transport: ref.watch(llmServiceProvider).generate,
  );
});

final storyLinesProvider = FutureProvider<List<StoryLine>>((ref) {
  return ref.watch(storyPlayServiceProvider).listLines();
});

final storyChaptersProvider =
    FutureProvider.family<List<StoryChapter>, String>((ref, chatId) {
  return ref.watch(storyQueryServiceProvider).listChapters(chatId);
});

final storyContextContributorProvider =
    Provider<StoryContextContributor>((ref) {
  return StoryContextContributor(
    memoryContributor: ref.watch(longTermMemoryContextContributorProvider),
    enabled: () => ref.read(appSettingsProvider).storyEnabled,
  );
});

final storyExtensionsProvider = Provider<void>((ref) {
  final registry = ref.watch(chatExtensionRegistryProvider);
  final chatRepository = ref.watch(chatRepositoryProvider);
  final storyService = ref.watch(storyServiceProvider);
  final contributorRegistration = registry.registerContributor(
    ref.watch(storyContextContributorProvider),
  );
  final middlewareRegistration = registry.registerMiddleware(
    StoryWriteMiddleware(
      storyService: storyService,
      resolveScope: (chatId) => _scopeForChat(ref, chatId),
      loadMessages: chatRepository.getMessages,
      enabled: () => ref.read(appSettingsProvider).storyEnabled,
    ),
  );
  ref.onDispose(() {
    middlewareRegistration.dispose();
    contributorRegistration.dispose();
  });
});

Future<MemoryScope> resolveStoryMemoryScope(Ref ref, String chatId) {
  return _scopeForChat(ref, chatId);
}

Future<MemoryScope> _scopeForChat(Ref ref, String chatId) async {
  // Capture dependencies before the first await. Story writes run in the
  // background and the owning provider may be disposed while repositories are
  // still resolving the scope.
  final chatRepository = ref.read(chatRepositoryProvider);
  final personaRepository = ref.read(personaRepositoryProvider);
  final activeId = ref.read(activePersonaIdProvider);
  final chat = await chatRepository.getChat(chatId);
  if (chat == null) return MemoryScope.chat(chatId);
  final storyRootId = chat.settings[storyRootChatIdKey];
  if (storyRootId is String && storyRootId.trim().isNotEmpty) {
    return MemoryScope.chat(chatId);
  }
  if (chat.groupId != null) return MemoryScope.group(chat.groupId!);

  final personas = await personaRepository.getAllPersonas();
  Persona? persona;
  for (final candidate in personas) {
    final connected = candidate.connections.any(
      (connection) =>
          connection.chatId == chat.id ||
          connection.characterId == chat.characterId,
    );
    if (connected) {
      persona = candidate;
      break;
    }
  }
  persona ??= activeId == null
      ? await personaRepository.getDefaultPersona()
      : await personaRepository.getPersona(activeId);
  return persona == null
      ? MemoryScope.character(chat.characterId)
      : MemoryScope.characterPersona(
          characterId: chat.characterId,
          personaId: persona.id,
        );
}
