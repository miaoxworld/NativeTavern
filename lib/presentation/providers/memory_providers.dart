import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/long_term_memory.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/drift_long_term_memory_repository.dart';
import 'package:native_tavern/data/repositories/persona_repository.dart';
import 'package:native_tavern/domain/repositories/long_term_memory_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/long_term_memory_governance_service.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';

final longTermMemoryRepositoryProvider =
    Provider<LongTermMemoryRepository>((ref) {
  return DriftLongTermMemoryRepository(ref.watch(databaseProvider));
});

final longTermMemoryExtractionServiceProvider =
    Provider<LongTermMemoryExtractionService>((ref) {
  return LongTermMemoryExtractionService.forLlm(
    repository: ref.watch(longTermMemoryRepositoryProvider),
    llmService: ref.watch(llmServiceProvider),
  );
});

final longTermMemoryGovernanceServiceProvider =
    Provider<LongTermMemoryGovernanceService>((ref) {
  return LongTermMemoryGovernanceService(
    repository: ref.watch(longTermMemoryRepositoryProvider),
  );
});

enum MemoryInboxView { candidates, active, history }

final class MemoryInboxState {
  const MemoryInboxState({
    this.candidates = const [],
    this.active = const [],
    this.history = const [],
    this.conflicts = const {},
    this.selectedIds = const {},
    this.recentChats = const [],
    this.isLoading = true,
    this.isExtracting = false,
    this.error,
    this.lastExtraction,
  });

  final List<LongTermMemory> candidates;
  final List<LongTermMemory> active;
  final List<LongTermMemory> history;
  final Map<String, MemoryConflictAssessment> conflicts;
  final Set<String> selectedIds;
  final List<Chat> recentChats;
  final bool isLoading;
  final bool isExtracting;
  final String? error;
  final MemoryExtractionResult? lastExtraction;

  MemoryInboxState copyWith({
    List<LongTermMemory>? candidates,
    List<LongTermMemory>? active,
    List<LongTermMemory>? history,
    Map<String, MemoryConflictAssessment>? conflicts,
    Set<String>? selectedIds,
    List<Chat>? recentChats,
    bool? isLoading,
    bool? isExtracting,
    String? error,
    bool clearError = false,
    MemoryExtractionResult? lastExtraction,
    bool clearLastExtraction = false,
  }) {
    return MemoryInboxState(
      candidates: candidates ?? this.candidates,
      active: active ?? this.active,
      history: history ?? this.history,
      conflicts: conflicts ?? this.conflicts,
      selectedIds: selectedIds ?? this.selectedIds,
      recentChats: recentChats ?? this.recentChats,
      isLoading: isLoading ?? this.isLoading,
      isExtracting: isExtracting ?? this.isExtracting,
      error: clearError ? null : (error ?? this.error),
      lastExtraction:
          clearLastExtraction ? null : (lastExtraction ?? this.lastExtraction),
    );
  }
}

final memoryInboxProvider =
    StateNotifierProvider<MemoryInboxController, MemoryInboxState>((ref) {
  return MemoryInboxController(
    repository: ref.watch(longTermMemoryRepositoryProvider),
    extraction: ref.watch(longTermMemoryExtractionServiceProvider),
    governance: ref.watch(longTermMemoryGovernanceServiceProvider),
    chatRepository: ref.watch(chatRepositoryProvider),
    personaRepository: ref.watch(personaRepositoryProvider),
    llmService: ref.watch(llmServiceProvider),
    ref: ref,
  );
});

final class MemoryInboxController extends StateNotifier<MemoryInboxState> {
  MemoryInboxController({
    required LongTermMemoryRepository repository,
    required LongTermMemoryExtractionService extraction,
    required LongTermMemoryGovernanceService governance,
    required ChatRepository chatRepository,
    required PersonaRepository personaRepository,
    required LLMService llmService,
    required Ref ref,
  })  : _repository = repository,
        _extraction = extraction,
        _governance = governance,
        _chatRepository = chatRepository,
        _personaRepository = personaRepository,
        _llmService = llmService,
        _ref = ref,
        super(const MemoryInboxState()) {
    refresh();
  }

  final LongTermMemoryRepository _repository;
  final LongTermMemoryExtractionService _extraction;
  final LongTermMemoryGovernanceService _governance;
  final ChatRepository _chatRepository;
  final PersonaRepository _personaRepository;
  final LLMService _llmService;
  final Ref _ref;

  Future<void> refresh() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _governance.expireDueMemories();
      final results = await Future.wait([
        _repository.findByStates(const {MemoryState.candidate}),
        _repository.findByStates(const {MemoryState.active}),
        _repository.findByStates(
          const {MemoryState.superseded, MemoryState.forgotten},
        ),
        _chatRepository.getRecentChats(limit: 100),
      ]);
      final candidates = results[0] as List<LongTermMemory>;
      final conflicts = <String, MemoryConflictAssessment>{};
      for (final candidate in candidates) {
        conflicts[candidate.id] = await _governance.inspect(candidate.id);
      }
      if (!mounted) return;
      state = state.copyWith(
        candidates: candidates,
        active: results[1] as List<LongTermMemory>,
        history: results[2] as List<LongTermMemory>,
        recentChats: results[3] as List<Chat>,
        conflicts: conflicts,
        selectedIds: state.selectedIds
            .intersection(candidates.map((memory) => memory.id).toSet()),
        isLoading: false,
      );
    } catch (error) {
      if (mounted) {
        state = state.copyWith(isLoading: false, error: error.toString());
      }
    }
  }

  Future<MemoryExtractionResult?> extractChat(
    String chatId, {
    bool automatic = false,
    List<ChatMessage>? turnMessages,
    LLMConfig? config,
  }) async {
    if (automatic &&
        !_ref.read(appSettingsProvider).memoryAutoExtractionEnabled) {
      return null;
    }
    if (state.isExtracting) return null;
    state = state.copyWith(
      isExtracting: true,
      clearError: true,
      clearLastExtraction: true,
    );
    try {
      final chat = await _chatRepository.getChat(chatId);
      if (chat == null) throw StateError('The selected chat no longer exists.');
      final sourceMessages =
          turnMessages ?? await _chatRepository.getMessages(chatId);
      final usable = sourceMessages
          .where((message) => message.content.trim().isNotEmpty)
          .toList();
      if (usable.isEmpty) {
        throw StateError('The selected chat has no messages to extract.');
      }
      final result = await _extraction.extractAndStage(
        scope: await _scopeForChat(chat),
        chatId: chatId,
        messages: usable
            .map(
              (message) => MemoryExtractionMessage(
                id: message.id,
                role: message.role.name,
                content: message.content,
              ),
            )
            .toList(growable: false),
        config: config ?? _ref.read(llmConfigProvider),
      );
      if (!mounted) return result;
      await refresh();
      if (!mounted) return result;
      state = state.copyWith(
        isExtracting: false,
        lastExtraction: result,
        error: result.failure?.message,
        clearError: result.failure == null,
      );
      return result;
    } catch (error) {
      if (mounted) {
        state = state.copyWith(isExtracting: false, error: error.toString());
      }
      return null;
    }
  }

  void cancelExtraction() {
    _llmService.cancelActiveRequest();
  }

  Future<MemoryResolutionResult> approve(String id) async {
    final result = await _governance.approve(id);
    if (result.kind == MemoryResolutionKind.blockedByLock) {
      state = state.copyWith(error: result.explanation);
    }
    await refresh();
    return result;
  }

  Future<void> ignore(Set<String> ids) async {
    await _governance.ignore(ids);
    await refresh();
  }

  Future<void> setLocked(String id, bool locked) async {
    await _governance.setLocked(id, locked);
    await refresh();
  }

  Future<void> saveEdits({
    required String id,
    required MemoryKind kind,
    required String content,
    required String identityKey,
    required double importance,
    required double confidence,
    DateTime? expiresAt,
    bool clearExpiresAt = false,
    required bool locked,
  }) async {
    await _governance.saveEdits(
      memoryId: id,
      kind: kind,
      content: content,
      identityKey: identityKey,
      importance: importance,
      confidence: confidence,
      expiresAt: expiresAt,
      clearExpiresAt: clearExpiresAt,
      locked: locked,
    );
    await refresh();
  }

  Future<void> createManual({
    required MemoryScope scope,
    required MemoryKind kind,
    required String content,
    String? identityKey,
    double importance = LongTermMemory.defaultImportance,
    bool locked = false,
  }) async {
    await _governance.createManual(
      scope: scope,
      kind: kind,
      content: content,
      identityKey: identityKey,
      importance: importance,
      locked: locked,
    );
    await refresh();
  }

  Future<void> mergeSelected({
    required MemoryKind kind,
    required String content,
    String? identityKey,
    bool locked = false,
  }) async {
    await _governance.mergeCandidates(
      candidateIds: state.selectedIds,
      kind: kind,
      content: content,
      identityKey: identityKey,
      locked: locked,
    );
    await refresh();
  }

  void toggleSelected(String id) {
    final selected = {...state.selectedIds};
    selected.contains(id) ? selected.remove(id) : selected.add(id);
    state = state.copyWith(selectedIds: selected);
  }

  void clearSelection() {
    state = state.copyWith(selectedIds: const {});
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    final selected = {...state.selectedIds}..remove(id);
    state = state.copyWith(selectedIds: selected);
    await refresh();
  }

  Future<void> deleteSelected() async {
    for (final id in state.selectedIds) {
      await _repository.delete(id);
    }
    state = state.copyWith(selectedIds: const {});
    await refresh();
  }

  Future<MemoryScope> _scopeForChat(Chat chat) async {
    if (chat.groupId != null) return MemoryScope.group(chat.groupId!);
    final personas = await _personaRepository.getAllPersonas();
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
    final activeId = _ref.read(activePersonaIdProvider);
    persona ??= activeId == null
        ? await _personaRepository.getDefaultPersona()
        : await _personaRepository.getPersona(activeId);
    return persona == null
        ? MemoryScope.character(chat.characterId)
        : MemoryScope.characterPersona(
            characterId: chat.characterId,
            personaId: persona.id,
          );
  }
}
