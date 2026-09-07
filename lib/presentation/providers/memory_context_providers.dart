import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/long_term_memory.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/data/repositories/persona_repository.dart';
import 'package:native_tavern/domain/services/chat_generation_pipeline.dart';
import 'package:native_tavern/domain/services/long_term_memory_context_service.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/services/moment_service.dart';
import 'package:native_tavern/domain/services/story_memory_scope_service.dart';
import 'package:native_tavern/presentation/providers/chat_extension_providers.dart';
import 'package:native_tavern/presentation/providers/memory_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/vector_storage_providers.dart';

final longTermMemoryContextServiceProvider =
    Provider<LongTermMemoryContextService>((ref) {
  return LongTermMemoryContextService(
    repository: ref.watch(longTermMemoryRepositoryProvider),
  );
});

final longTermMemoryContextContributorProvider =
    Provider<LongTermMemoryContextContributor>((ref) {
  return LongTermMemoryContextContributor(
    service: ref.watch(longTermMemoryContextServiceProvider),
    resolveScopes: (request) => _resolveScopes(ref, request),
    enabled: () {
      final settings = ref.read(appSettingsProvider);
      return settings.memoryContextEnabled;
    },
    tokenBudget: () => ref.read(appSettingsProvider).memoryContextTokenBudget,
    semanticEnabled: () =>
        ref.read(appSettingsProvider).memorySemanticSearchEnabled,
    semanticThreshold: () =>
        ref.read(vectorStorageSettingsProvider).similarityThreshold,
    semanticScorer: (query, candidates) =>
        _scoreSemantically(ref, query, candidates),
    includeMemory: (request, memory) async {
      if (MomentService.isMomentsKnowledgeMemory(memory)) {
        if (!ref.read(appSettingsProvider).momentsEnabled) return false;
        final chat =
            await ref.read(chatRepositoryProvider).getChat(request.chatId);
        if (chat?.momentsInChat != true) return false;
      }
      return StoryMemoryScopeService(
        chatRepository: ref.read(chatRepositoryProvider),
      ).isMemoryVisible(chatId: request.chatId, memory: memory);
    },
  );
});

final longTermMemoryContextRegistrationProvider =
    Provider<ChatExtensionRegistration>((ref) {
  final registration =
      ref.watch(chatExtensionRegistryProvider).registerContributor(
            ref.watch(longTermMemoryContextContributorProvider),
          );
  ref.onDispose(registration.dispose);
  return registration;
});

final class MemoryContextUsageItem {
  const MemoryContextUsageItem({
    required this.memory,
    required this.status,
    required this.score,
    required this.originalTokens,
    required this.usedTokens,
  });

  final LongTermMemory memory;
  final ContextContributionItemStatus status;
  final double score;
  final int originalTokens;
  final int usedTokens;
}

final class MemoryContextUsage {
  const MemoryContextUsage({
    required this.chatId,
    required this.mode,
    required this.status,
    required this.items,
    required this.allocatedTokens,
    required this.usedTokens,
    this.fallbackReason,
  });

  final String chatId;
  final MemoryRetrievalMode mode;
  final ContextContributionStatus status;
  final List<MemoryContextUsageItem> items;
  final int allocatedTokens;
  final int usedTokens;
  final MemorySemanticFallbackReason? fallbackReason;

  int get includedCount => items
      .where((item) => item.status != ContextContributionItemStatus.dropped)
      .length;
}

final memoryContextUsageProvider =
    FutureProvider.family<MemoryContextUsage?, String>((ref, chatId) async {
  final assembly = ref.watch(lastContextAssemblyProvider);
  if (assembly == null || assembly.chatId != chatId) return null;

  ContextContributionTrace? trace;
  for (final candidate in assembly.traces) {
    if (candidate.contributorId ==
        LongTermMemoryContextContributor.contributorId) {
      trace = candidate;
      break;
    }
  }
  if (trace == null) return null;

  final scores = <String, double>{};
  final rawScores = trace.metadata['scores'];
  if (rawScores is Map) {
    for (final entry in rawScores.entries) {
      final value = entry.value;
      if (entry.key is String && value is num && value.isFinite) {
        scores[entry.key as String] = value.toDouble();
      }
    }
  }

  final repository = ref.watch(longTermMemoryRepositoryProvider);
  final items = <MemoryContextUsageItem>[];
  for (final itemTrace in trace.itemTraces) {
    final memory = await repository.getById(itemTrace.itemId);
    if (memory == null) continue;
    items.add(
      MemoryContextUsageItem(
        memory: memory,
        status: itemTrace.status,
        score: scores[itemTrace.itemId] ?? 0,
        originalTokens: itemTrace.originalTokens,
        usedTokens: itemTrace.usedTokens,
      ),
    );
  }

  final modeName = trace.metadata['retrievalMode'];
  final mode = MemoryRetrievalMode.values.firstWhere(
    (candidate) => candidate.name == modeName,
    orElse: () => MemoryRetrievalMode.fts,
  );
  final fallbackName = trace.metadata['semanticFallbackReason'];
  MemorySemanticFallbackReason? fallbackReason;
  for (final candidate in MemorySemanticFallbackReason.values) {
    if (candidate.name == fallbackName) {
      fallbackReason = candidate;
      break;
    }
  }
  return MemoryContextUsage(
    chatId: chatId,
    mode: mode,
    status: trace.status,
    items: List<MemoryContextUsageItem>.unmodifiable(items),
    allocatedTokens: trace.allocatedTokens,
    usedTokens: trace.usedTokens,
    fallbackReason: fallbackReason,
  );
});

Future<List<MemoryScope>> _resolveScopes(
  Ref ref,
  ChatContextRequest request,
) async {
  final scopes = <MemoryScope>[
    ...await StoryMemoryScopeService(
      chatRepository: ref.read(chatRepositoryProvider),
    ).readableChatScopes(request.chatId),
  ];
  final groupId = request.groupId;
  if (groupId != null && groupId.trim().isNotEmpty) {
    scopes.add(MemoryScope.group(groupId));
  }

  final characterId = request.characterId;
  if (characterId != null && characterId.trim().isNotEmpty) {
    final persona = await _resolvePersona(ref, request);
    if (persona != null) {
      scopes.add(
        MemoryScope.characterPersona(
          characterId: characterId,
          personaId: persona.id,
        ),
      );
    }
    scopes.add(MemoryScope.character(characterId));
  }
  return scopes;
}

Future<Persona?> _resolvePersona(Ref ref, ChatContextRequest request) async {
  final repository = ref.read(personaRepositoryProvider);
  final personas = await repository.getAllPersonas();

  Persona? connectedWhere(bool Function(PersonaConnection) matches) {
    for (final persona in personas) {
      if (persona.connections.any(matches)) return persona;
    }
    return null;
  }

  final byChat = connectedWhere(
    (connection) => connection.chatId == request.chatId,
  );
  if (byChat != null) return byChat;
  if (request.groupId case final groupId?) {
    final byGroup = connectedWhere(
      (connection) => connection.groupId == groupId,
    );
    if (byGroup != null) return byGroup;
  }
  if (request.characterId case final characterId?) {
    final byCharacter = connectedWhere(
      (connection) => connection.characterId == characterId,
    );
    if (byCharacter != null) return byCharacter;
  }

  final activeId = ref.read(activePersonaIdProvider);
  if (activeId != null) {
    final active = await repository.getPersona(activeId);
    if (active != null) return active;
  }
  return repository.getDefaultPersona();
}

Future<Map<String, double>> _scoreSemantically(
  Ref ref,
  String query,
  List<LongTermMemory> candidates,
) async {
  final settings = ref.read(vectorStorageSettingsProvider);
  final embeddings = await ref.read(embeddingServiceProvider).embedBatch([
    query,
    ...candidates.map((memory) => memory.content),
  ], settings);
  if (embeddings.length != candidates.length + 1 || embeddings.first.isEmpty) {
    throw const FormatException(
      'Embedding response shape does not match input.',
    );
  }
  final queryEmbedding = embeddings.first;
  return {
    for (var index = 0; index < candidates.length; index++)
      candidates[index].id: _cosineSimilarity(
        queryEmbedding,
        embeddings[index + 1],
      ),
  };
}

double _cosineSimilarity(List<double> left, List<double> right) {
  if (left.isEmpty || left.length != right.length) {
    throw const FormatException('Embedding dimensions do not match.');
  }
  var dot = 0.0;
  var leftNorm = 0.0;
  var rightNorm = 0.0;
  for (var index = 0; index < left.length; index++) {
    final leftValue = left[index];
    final rightValue = right[index];
    if (!leftValue.isFinite || !rightValue.isFinite) {
      throw const FormatException('Embedding contains a non-finite value.');
    }
    dot += leftValue * rightValue;
    leftNorm += leftValue * leftValue;
    rightNorm += rightValue * rightValue;
  }
  if (leftNorm == 0 || rightNorm == 0) return 0;
  return dot / (math.sqrt(leftNorm) * math.sqrt(rightNorm));
}
