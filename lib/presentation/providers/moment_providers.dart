import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/repositories/character_friendship_repository.dart';
import 'package:native_tavern/data/repositories/operation_log_repository.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/drift_moment_repository.dart';
import 'package:native_tavern/data/repositories/group_repository.dart';
import 'package:native_tavern/data/repositories/world_info_repository.dart';
import 'package:native_tavern/domain/repositories/moment_repository.dart';
import 'package:native_tavern/domain/services/character_social_service.dart';
import 'package:native_tavern/domain/services/chat_generation_pipeline.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/domain/services/moment_context_contributor.dart';
import 'package:native_tavern/domain/services/moment_service.dart';
import 'package:native_tavern/domain/services/world_runtime.dart';
import 'package:native_tavern/presentation/providers/chat_extension_providers.dart';
import 'package:native_tavern/presentation/providers/data_bank_providers.dart';
import 'package:native_tavern/presentation/providers/image_gen_providers.dart';
import 'package:native_tavern/presentation/providers/memory_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/story_providers.dart';
import 'package:native_tavern/presentation/providers/story_timeline_providers.dart';

final momentRepositoryProvider = Provider<MomentRepository>((ref) {
  return DriftMomentRepository(ref.watch(databaseProvider));
});

final characterFriendshipRepositoryProvider =
    Provider<CharacterFriendshipRepository>((ref) {
  return CharacterFriendshipRepository(ref.watch(databaseProvider));
});

final characterSocialServiceProvider = Provider<CharacterSocialService>((ref) {
  return CharacterSocialService(
    friendships: ref.watch(characterFriendshipRepositoryProvider),
    groups: ref.watch(groupRepositoryProvider),
    characters: ref.watch(characterRepositoryProvider),
  );
});

final operationLogRepositoryProvider = Provider<OperationLogRepository>((ref) {
  return OperationLogRepository(ref.watch(databaseProvider));
});

final momentServiceProvider = Provider<MomentService>((ref) {
  return MomentService(
    momentRepository: ref.watch(momentRepositoryProvider),
    characterRepository: ref.watch(characterRepositoryProvider),
    chatRepository: ref.watch(chatRepositoryProvider),
    worldInfoRepository: ref.watch(worldInfoRepositoryProvider),
    dataBank: ref.watch(dataBankRepositoryProvider),
    social: ref.watch(characterSocialServiceProvider),
    operations: ref.watch(operationLogRepositoryProvider),
    memories: ref.watch(longTermMemoryRepositoryProvider),
    dataPath: ref.watch(dataPathProvider),
    transport: (messages, config) {
      return ref.read(llmServiceProvider).generate(messages, config);
    },
    imageGenerator: (prompt) async {
      final imageSettings = ref.read(imageGenSettingsProvider);
      if (!imageSettings.enabled) return null;
      final imageService = ref.read(imageGenServiceProvider);
      imageService.updateSettings(imageSettings);
      final result = await imageService.generate(
        ImageGenRequest(
          prompt: prompt,
          negativePrompt: imageSettings.defaultNegativePrompt,
          width: imageSettings.defaultWidth,
          height: imageSettings.defaultHeight,
          steps: imageSettings.defaultSteps,
          cfgScale: imageSettings.defaultCfgScale,
          sampler: imageSettings.defaultSampler,
          scheduler: imageSettings.defaultScheduler,
        ),
      );
      if (result == null || result.images.isEmpty) return null;
      return result.images.first;
    },
  );
});

final momentContextContributorProvider =
    Provider<MomentContextContributor>((ref) {
  return MomentContextContributor(
    moments: ref.watch(momentServiceProvider),
    enabled: () => ref.read(appSettingsProvider).momentsEnabled,
    chatEnabled: (chatId) async {
      final chat = await ref.read(chatRepositoryProvider).getChat(chatId);
      return chat?.momentsInChat == true;
    },
  );
});

final momentContextRegistrationProvider =
    Provider<ChatExtensionRegistration>((ref) {
  final registration = ref
      .watch(chatExtensionRegistryProvider)
      .registerContributor(ref.watch(momentContextContributorProvider));
  ref.onDispose(registration.dispose);
  return registration;
});

final worldMomentRevisionProvider = StateProvider<int>((ref) => 0);

final worldRuntimeProvider = Provider<WorldRuntime>((ref) {
  final settings = ref.watch(appSettingsProvider);
  final runtime = WorldRuntime(
    momentService: ref.watch(momentServiceProvider),
    characterRepository: ref.watch(characterRepositoryProvider),
    social: ref.watch(characterSocialServiceProvider),
    story: ref.watch(storyServiceProvider),
    operations: ref.watch(operationLogRepositoryProvider),
    store: FileWorldWakeStore(ref.watch(dataPathProvider)),
    enabled: () => ref.read(appSettingsProvider).momentsEnabled,
    storyEnabled: () => ref.read(appSettingsProvider).storyEnabled,
    config: () => ref.read(llmConfigProvider),
    onPublished: (_) {
      ref.read(worldMomentRevisionProvider.notifier).state++;
    },
    onStoryChanged: () {
      ref.read(storyRevisionProvider.notifier).state++;
    },
  );
  if (settings.momentsEnabled || settings.storyEnabled) {
    runtime.start();
  }
  ref.onDispose(runtime.dispose);
  return runtime;
});

final momentFeedProvider =
    FutureProvider.autoDispose<List<MomentFeedItem>>((ref) async {
  ref.watch(worldMomentRevisionProvider);
  return ref.watch(momentServiceProvider).loadFeed();
});

/// Paginated feed used by the moments screen.
final pagedMomentFeedProvider = AsyncNotifierProvider.autoDispose<
    PagedMomentFeedNotifier, List<MomentFeedItem>>(PagedMomentFeedNotifier.new);

class PagedMomentFeedNotifier
    extends AutoDisposeAsyncNotifier<List<MomentFeedItem>> {
  static const _pageSize = 24;
  int _offset = 0;
  bool _hasMore = true;
  bool _loadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _loadingMore;

  @override
  Future<List<MomentFeedItem>> build() async {
    ref.watch(worldMomentRevisionProvider);
    _offset = 0;
    _hasMore = true;
    final page = await ref.read(momentServiceProvider).loadFeedPage(
          limit: _pageSize,
          offset: 0,
        );
    final unique = _uniqueById(page);
    _offset = page.length;
    _hasMore = page.length == _pageSize;
    return unique;
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore || !state.hasValue) return;
    _loadingMore = true;
    try {
      final page = await ref.read(momentServiceProvider).loadFeedPage(
            limit: _pageSize,
            offset: _offset,
          );
      final current = state.valueOrNull ?? const <MomentFeedItem>[];
      state = AsyncData(_uniqueById([...current, ...page]));
      _offset += page.length;
      _hasMore = page.length == _pageSize;
    } catch (error, stack) {
      state = AsyncError(error, stack);
    } finally {
      _loadingMore = false;
    }
  }

  List<MomentFeedItem> _uniqueById(List<MomentFeedItem> items) {
    final seen = <String>{};
    return [
      for (final item in items)
        if (seen.add(item.post.id)) item,
    ];
  }
}
