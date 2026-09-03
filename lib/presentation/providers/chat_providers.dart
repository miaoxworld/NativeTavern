import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:native_tavern/data/models/bookmark.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/operation_log.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/data_bank_context.dart';
import 'package:native_tavern/data/models/group.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/data/models/prompt_manager.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/group_repository.dart';
import 'package:native_tavern/data/repositories/persona_repository.dart';
import 'package:native_tavern/domain/models/tool_calling.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/macro_service.dart';
import 'package:native_tavern/domain/services/chat_summarization_service.dart';
import 'package:native_tavern/domain/services/chat_generation_pipeline.dart';
import 'package:native_tavern/domain/services/chat_export_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/chat_extension_providers.dart';
import 'package:native_tavern/presentation/providers/data_bank_providers.dart';
import 'package:native_tavern/presentation/providers/group_providers.dart';
import 'package:native_tavern/presentation/providers/memory_providers.dart';
import 'package:native_tavern/presentation/providers/story_providers.dart';
import 'package:native_tavern/presentation/providers/locale_provider.dart';
import 'package:native_tavern/presentation/providers/moment_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/story_timeline_providers.dart';
import 'package:native_tavern/presentation/providers/prompt_manager_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/tool_calling_providers.dart';
import 'package:native_tavern/presentation/providers/vector_storage_providers.dart';
import 'package:native_tavern/presentation/providers/world_info_providers.dart';

// Note: Repository providers are defined in their respective repository files
// llmServiceProvider is defined in settings_providers.dart

/// Current active chat ID
final activeChatIdProvider = StateProvider<String?>((ref) => null);

/// Active chat state
class ActiveChatState {
  final Chat? chat;
  final Character? character;
  final Group? group; // For group chats
  final Map<String, Character>
      groupCharacters; // Character cache for group chats
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool hasOlderMessages;
  final bool isLoadingOlderMessages;
  final bool isGenerating;
  final Set<String> generatingMessageIds;
  final String? error;
  final String?
      currentResponderId; // Which character is currently responding (group chat)

  const ActiveChatState({
    this.chat,
    this.character,
    this.group,
    this.groupCharacters = const {},
    this.messages = const [],
    this.isLoading = false,
    this.hasOlderMessages = false,
    this.isLoadingOlderMessages = false,
    this.isGenerating = false,
    this.generatingMessageIds = const {},
    this.error,
    this.currentResponderId,
  });

  /// Check if this is a group chat
  bool get isGroupChat => group != null;

  Character? characterForMessage(ChatMessage message) {
    final senderId = message.characterId;
    if (senderId != null) {
      return groupCharacters[senderId] ?? character;
    }
    return character;
  }

  ActiveChatState copyWith({
    Chat? chat,
    Character? character,
    Group? group,
    bool clearGroup = false,
    Map<String, Character>? groupCharacters,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? hasOlderMessages,
    bool? isLoadingOlderMessages,
    bool? isGenerating,
    Set<String>? generatingMessageIds,
    String? error,
    String? currentResponderId,
    bool clearCurrentResponder = false,
  }) {
    return ActiveChatState(
      chat: chat ?? this.chat,
      character: character ?? this.character,
      group: clearGroup ? null : (group ?? this.group),
      groupCharacters: groupCharacters ?? this.groupCharacters,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      hasOlderMessages: hasOlderMessages ?? this.hasOlderMessages,
      isLoadingOlderMessages:
          isLoadingOlderMessages ?? this.isLoadingOlderMessages,
      isGenerating: isGenerating ?? this.isGenerating,
      generatingMessageIds: generatingMessageIds ?? this.generatingMessageIds,
      error: error,
      currentResponderId: clearCurrentResponder
          ? null
          : (currentResponderId ?? this.currentResponderId),
    );
  }
}

class _PreparedGroupResponse {
  const _PreparedGroupResponse({
    required this.context,
    required this.session,
    required this.message,
  });

  final List<Map<String, dynamic>> context;
  final ChatGenerationSession session;
  final ChatMessage message;
}

/// Active chat notifier
class ActiveChatNotifier extends StateNotifier<ActiveChatState> {
  static const _messagePageSize = 50;
  final ChatRepository _chatRepository;
  final CharacterRepository _characterRepository;
  final GroupRepository _groupRepository;
  final PersonaRepository _personaRepository;
  final LLMService _llmService;
  final WorldInfoMatcher _worldInfoMatcher;
  final ChatSummarizationService _summarizationService;
  final ChatGenerationPipeline _generationPipeline;
  final Ref _ref;

  // Track cancellation flag for stream processing
  bool _isCancelling = false;
  int _chatLoadGeneration = 0;
  ChatGenerationSession? _activeGenerationSession;
  DataBankContextSnapshot? _pendingDataBankContext;

  ActiveChatNotifier({
    required ChatRepository chatRepository,
    required CharacterRepository characterRepository,
    required GroupRepository groupRepository,
    required PersonaRepository personaRepository,
    required LLMService llmService,
    required WorldInfoMatcher worldInfoMatcher,
    required ChatSummarizationService summarizationService,
    required ChatGenerationPipeline generationPipeline,
    required Ref ref,
  })  : _chatRepository = chatRepository,
        _characterRepository = characterRepository,
        _groupRepository = groupRepository,
        _personaRepository = personaRepository,
        _llmService = llmService,
        _worldInfoMatcher = worldInfoMatcher,
        _summarizationService = summarizationService,
        _generationPipeline = generationPipeline,
        _ref = ref,
        super(const ActiveChatState());

  AppLocalizations get _l10n {
    final requestedLocale =
        _ref.read(localeProvider) ?? PlatformDispatcher.instance.locale;
    final isSupported = AppLocalizations.supportedLocales.any(
      (locale) => locale.languageCode == requestedLocale.languageCode,
    );
    return lookupAppLocalizations(
      isSupported ? requestedLocale : const Locale('en'),
    );
  }

  Future<Persona?> _resolvePersona({
    String? characterId,
    String? groupId,
    String? chatId,
  }) async {
    final effectiveChatId = chatId ?? state.chat?.id;
    final effectiveGroupId = groupId ?? state.group?.id ?? state.chat?.groupId;
    final effectiveCharacterId =
        characterId ?? state.character?.id ?? state.chat?.characterId;
    final personas = await _personaRepository.getAllPersonas();

    Persona? connectedWhere(bool Function(PersonaConnection) matches) {
      for (final persona in personas) {
        if (persona.connections.any(matches)) return persona;
      }
      return null;
    }

    if (effectiveChatId != null) {
      final connected = connectedWhere(
        (connection) => connection.chatId == effectiveChatId,
      );
      if (connected != null) return connected;
    }
    if (effectiveGroupId != null) {
      final connected = connectedWhere(
        (connection) => connection.groupId == effectiveGroupId,
      );
      if (connected != null) return connected;
    }
    if (effectiveCharacterId != null) {
      final connected = connectedWhere(
        (connection) => connection.characterId == effectiveCharacterId,
      );
      if (connected != null) return connected;
    }

    final activePersonaId = _ref.read(activePersonaIdProvider);
    if (activePersonaId != null) {
      final active = await _personaRepository.getPersona(activePersonaId);
      if (active != null) return active;
    }

    return _personaRepository.getDefaultPersona();
  }

  /// Apply the chat's "Start Reply With" assistant prefill to the request
  List<Map<String, dynamic>> _withPrefill(List<Map<String, dynamic>> context) {
    final prefill = state.chat?.startReplyWith ?? '';
    if (prefill.isEmpty) return context;
    return [
      ...context,
      {'role': 'assistant', 'content': prefill},
    ];
  }

  void _startGenerationSession(
    LLMConfig config,
    ChatGenerationMode mode, {
    String? characterId,
  }) {
    _pendingDataBankContext = null;
    final previousSession = _activeGenerationSession;
    if (previousSession != null) {
      unawaited(previousSession.cancel('Superseded by a new generation'));
      previousSession.close();
    }
    final chat = state.chat;
    if (chat == null) return;
    _activeGenerationSession = _generationPipeline.startSession(
      chatId: chat.id,
      characterId: characterId ?? state.character?.id,
      groupId: state.group?.id ?? chat.groupId,
      mode: mode,
      config: config,
      metadata: {
        'isGroupChat': state.isGroupChat,
        'messageCount': state.messages.length,
      },
    );
  }

  Future<List<Map<String, dynamic>>> _applyContextContributors(
    List<Map<String, dynamic>> messages, {
    int? conversationStartIndex,
    ChatGenerationSession? generationSession,
  }) async {
    final session = generationSession ?? _activeGenerationSession;
    if (session == null) return messages;
    final result = await session.assemble(
      messages,
      conversationStartIndex: conversationStartIndex,
    );
    final dataBankContext = _ref.read(lastDataBankContextProvider);
    if (dataBankContext?.sessionId == session.sessionId) {
      _pendingDataBankContext =
          dataBankContext!.sources.isEmpty ? null : dataBankContext;
    }
    if (result.cancelled) {
      throw ChatGenerationCancelledException(
        session.cancellationToken.reason ?? 'Cancelled',
      );
    }
    return result.messages;
  }

  Map<String, dynamic> _newAssistantMetadata() {
    return appendDataBankContextMetadata(
      metadata: const {},
      existingSwipeCount: 0,
      snapshot: _pendingDataBankContext,
    );
  }

  Map<String, dynamic> _metadataForNewSwipe(ChatMessage message) {
    return appendDataBankContextMetadata(
      metadata: message.metadata,
      existingSwipeCount: message.swipes.length,
      snapshot: _pendingDataBankContext,
    );
  }

  void _closeGenerationSession([ChatGenerationSession? session]) {
    final target = session ?? _activeGenerationSession;
    target?.close();
    if (session == null || identical(session, _activeGenerationSession)) {
      _activeGenerationSession = null;
    }
  }

  void _discardTrailingEmptyAssistantPlaceholder() {
    final messages = state.messages;
    if (messages.isEmpty) return;
    final last = messages.last;
    if (last.role != MessageRole.assistant ||
        last.content.isNotEmpty ||
        last.swipes.any((swipe) => swipe.isNotEmpty)) {
      return;
    }
    state = state.copyWith(messages: messages.sublist(0, messages.length - 1));
  }

  Future<LLMResponse?> _generateWithTools(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final settings = _ref.read(toolCallingSettingsProvider);
    final chatId = state.chat?.id;
    if (!settings.enabled || chatId == null) return null;

    final runtime = _ref.read(toolRuntimeProvider.notifier);
    final handle = runtime.beginGeneration(chatId);
    try {
      final result = await _ref.read(toolGenerationLoopProvider).run(
            chatId: chatId,
            messages: messages,
            config: config,
            settings: settings,
            capabilities: _ref.read(toolCapabilitySnapshotProvider),
            cancellationToken: handle.token,
            requestBuiltInApproval: (preview) =>
                runtime.requestBuiltIn(chatId, preview),
            requestMcpApproval: (preview) =>
                runtime.requestMcp(chatId, preview),
            onProgress: runtime.report,
          );
      if (result == null) return null;
      return LLMResponse(
        content: result.content,
        reasoning: result.reasoning,
      );
    } on ToolProtocolException catch (error) {
      if (error.code == 'cancelled') {
        throw ChatGenerationCancelledException(error.message);
      }
      rethrow;
    } finally {
      runtime.finishGeneration(handle);
    }
  }

  Stream<LLMStreamChunk> _toolAwareStream(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final toolResponse = await _generateWithTools(
      _withPrefill(messages),
      config,
    );
    final prefill = state.chat?.startReplyWith ?? '';
    if (toolResponse != null) {
      if (prefill.isNotEmpty) yield LLMStreamChunk(content: prefill);
      if (toolResponse.reasoning?.isNotEmpty == true) {
        yield LLMStreamChunk(
          reasoning: toolResponse.reasoning,
          isReasoningChunk: true,
        );
      }
      if (toolResponse.content.isNotEmpty) {
        yield LLMStreamChunk(content: toolResponse.content);
      }
      return;
    }

    if (prefill.isNotEmpty) yield LLMStreamChunk(content: prefill);
    yield* _llmService.generateStreamWithReasoning(
      _withPrefill(messages),
      config,
    );
  }

  /// Stream generation with assistant prefill: the prefill text is sent as
  /// a trailing assistant message (native prefill on Claude, continuation
  /// on OpenAI-compatible APIs) and emitted first so it becomes part of
  /// the displayed/saved reply
  Stream<LLMStreamChunk> _generateStreamWithPrefill(
    List<Map<String, dynamic>> context,
    LLMConfig config, {
    ChatGenerationSession? generationSession,
  }) async* {
    final session = generationSession ?? _activeGenerationSession;
    if (session == null) {
      yield* _toolAwareStream(context, config);
      return;
    }

    Stream<LLMStreamChunk> transport(ChatGenerationRequest request) async* {
      yield* _toolAwareStream(request.messages, request.config);
    }

    try {
      yield* session.generateStream(context, transport);
    } finally {
      _closeGenerationSession(session);
    }
  }

  /// Non-streaming generation with assistant prefill
  Future<LLMResponse> _generateWithPrefill(
    List<Map<String, dynamic>> context,
    LLMConfig config, {
    ChatGenerationSession? generationSession,
  }) async {
    final session = generationSession ?? _activeGenerationSession;
    final prefill = state.chat?.startReplyWith ?? '';
    try {
      if (session == null) {
        final response =
            await _generateWithTools(_withPrefill(context), config) ??
                await _llmService.generateWithReasoning(
                  _withPrefill(context),
                  config,
                );
        if (prefill.isEmpty) return response;
        return LLMResponse(
          content: prefill + response.content,
          reasoning: response.reasoning,
        );
      }
      return await session.generate(context, (request) async {
        final response = await _generateWithTools(
              _withPrefill(request.messages),
              request.config,
            ) ??
            await _llmService.generateWithReasoning(
              _withPrefill(request.messages),
              request.config,
            );
        if (prefill.isEmpty) return response;
        return LLMResponse(
          content: prefill + response.content,
          reasoning: response.reasoning,
        );
      });
    } finally {
      if (session != null) _closeGenerationSession(session);
    }
  }

  Future<LLMResponse> _generateWithoutPrefill(
    List<Map<String, dynamic>> context,
    LLMConfig config,
  ) async {
    final session = _activeGenerationSession;
    try {
      if (session == null) {
        return _llmService.generateWithReasoning(context, config);
      }
      return await session.generate(
        context,
        (request) =>
            _llmService.generateWithReasoning(request.messages, request.config),
      );
    } finally {
      if (session != null) _closeGenerationSession(session);
    }
  }

  /// Cancel current generation
  Future<void> cancelGeneration() async {
    _isCancelling = true;
    _ref.read(toolRuntimeProvider.notifier).cancelGeneration();
    final pipelineCancellation = _generationPipeline.cancelActiveSessions();
    // Abort the HTTP request so server-side generation actually stops
    _llmService.cancelActiveRequest();
    state = state.copyWith(isGenerating: false);
    await pipelineCancellation;
    // Reset flag after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _isCancelling = false;
    });
  }

  /// Load a chat by ID
  Future<void> loadChat(String chatId) async {
    final loadGeneration = ++_chatLoadGeneration;
    state = const ActiveChatState(isLoading: true);

    try {
      final chat = await _chatRepository.getChat(chatId);
      if (loadGeneration != _chatLoadGeneration) return;
      if (chat == null) {
        state = const ActiveChatState(
          isLoading: false,
          error: 'Chat not found',
        );
        return;
      }

      final character = await _characterRepository.getCharacter(
        chat.characterId,
      );
      final messageCount = await _chatRepository.getMessageCount(chatId);
      var messages = await _chatRepository.getMessagesPage(
        chatId,
        limit: _messagePageSize,
      );
      if (loadGeneration != _chatLoadGeneration) return;

      if (!chat.isGroupChat &&
          character != null &&
          messages.length == messageCount) {
        messages = await _syncGreetingSwipes(chat, character, messages);
        if (loadGeneration != _chatLoadGeneration) return;
      }

      // Check if this is a group chat
      if (chat.isGroupChat) {
        final group = await _groupRepository.getGroup(chat.groupId!);
        if (loadGeneration != _chatLoadGeneration) return;
        if (group == null) throw Exception('Group not found');

        // Load all group member characters
        final groupChars = <String, Character>{};
        for (final member in group.members) {
          final char = await _characterRepository.getCharacter(
            member.characterId,
          );
          if (char != null) {
            groupChars[char.id] = char;
          }
        }
        if (loadGeneration != _chatLoadGeneration) return;

        state = state.copyWith(
          chat: chat,
          character: character,
          group: group,
          groupCharacters: groupChars,
          messages: messages,
          hasOlderMessages: messages.length < messageCount,
          isLoadingOlderMessages: false,
          isLoading: false,
        );
      } else {
        if (loadGeneration != _chatLoadGeneration) return;
        state = state.copyWith(
          chat: chat,
          character: character,
          clearGroup: true,
          groupCharacters: const {},
          messages: messages,
          hasOlderMessages: messages.length < messageCount,
          isLoadingOlderMessages: false,
          isLoading: false,
        );
      }
    } catch (e, stackTrace) {
      if (loadGeneration != _chatLoadGeneration) return;
      debugPrint('❌ ChatProvider error: $e\n$stackTrace');
      state = ActiveChatState(isLoading: false, error: e.toString());
    }
  }

  /// Load the next page of older messages for the active chat.
  Future<void> loadOlderMessages() async {
    final chatId = state.chat?.id;
    if (chatId == null ||
        !state.hasOlderMessages ||
        state.isLoadingOlderMessages) {
      return;
    }

    state = state.copyWith(isLoadingOlderMessages: true);
    try {
      final older = await _chatRepository.getMessagesPage(
        chatId,
        limit: _messagePageSize,
        offset: state.messages.length,
      );
      if (older.isEmpty) {
        state = state.copyWith(
          hasOlderMessages: false,
          isLoadingOlderMessages: false,
        );
        return;
      }
      final merged = [...older, ...state.messages];
      state = state.copyWith(
        messages: merged,
        hasOlderMessages: older.length == _messagePageSize,
        isLoadingOlderMessages: false,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ ChatProvider loadOlderMessages error: $e\n$stackTrace');
      state =
          state.copyWith(isLoadingOlderMessages: false, error: e.toString());
    }
  }

  /// Generation requires the complete history even though the UI is paged.
  Future<void> _ensureAllMessagesLoaded() async {
    final chatId = state.chat?.id;
    if (chatId == null || !state.hasOlderMessages) return;
    state = state.copyWith(isLoadingOlderMessages: true);
    try {
      final messages = await _chatRepository.getMessages(chatId);
      state = state.copyWith(
        messages: messages,
        hasOlderMessages: false,
        isLoadingOlderMessages: false,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ ChatProvider load context error: $e\n$stackTrace');
      state =
          state.copyWith(isLoadingOlderMessages: false, error: e.toString());
      rethrow;
    }
  }

  /// Return the UI to a bounded page after a generation used full context.
  Future<void> _restoreRecentMessagesPage() async {
    final chatId = state.chat?.id;
    if (chatId == null) return;
    final count = await _chatRepository.getMessageCount(chatId);
    if (count <= _messagePageSize) {
      state = state.copyWith(hasOlderMessages: false);
      return;
    }
    final messages = await _chatRepository.getMessagesPage(
      chatId,
      limit: _messagePageSize,
    );
    state = state.copyWith(
      messages: messages,
      hasOlderMessages: messages.length < count,
      isLoadingOlderMessages: false,
    );
  }

  Future<List<ChatMessage>> _syncGreetingSwipes(
    Chat chat,
    Character character,
    List<ChatMessage> messages,
  ) async {
    if (messages.isEmpty ||
        character.firstMessage.isEmpty ||
        character.alternateGreetings.isEmpty) {
      return messages;
    }
    final first = messages.first;
    if (first.role != MessageRole.assistant) return messages;

    final persona = await _resolvePersona(
      characterId: character.id,
      chatId: chat.id,
    );
    final macroService = MacroService(
      MacroContext.fromData(
        character: character,
        persona: persona,
        chat: chat,
        messages: messages,
      ),
    );
    final primaryGreeting = macroService.process(character.firstMessage);
    final existingSwipes = first.swipes.isEmpty
        ? <String>[first.content]
        : List<String>.from(first.swipes);
    if (first.content != primaryGreeting &&
        !existingSwipes.contains(primaryGreeting)) {
      return messages;
    }

    final expected = [
      primaryGreeting,
      ...character.alternateGreetings
          .where((greeting) => greeting.trim().isNotEmpty)
          .map(macroService.process),
    ];
    var changed = false;
    for (final greeting in expected) {
      if (!existingSwipes.contains(greeting)) {
        existingSwipes.add(greeting);
        changed = true;
      }
    }
    if (!changed) return messages;

    final updated = first.copyWith(swipes: existingSwipes);
    await _chatRepository.updateMessage(updated);
    return [updated, ...messages.skip(1)];
  }

  /// Create a new chat with a character
  Future<String?> createChat(String characterId) async {
    _chatLoadGeneration++;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final character = await _characterRepository.getCharacter(characterId);
      if (character == null) {
        state = state.copyWith(
          isLoading: false,
          error: _l10n.characterNotFoundMessage,
        );
        return null;
      }

      final chat = Chat(
        id: _generateId(),
        characterId: characterId,
        title: _l10n.chatWithName(character.name),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _chatRepository.createChat(chat);

      // Add first message (greeting) if character has one
      if (character.firstMessage.isNotEmpty) {
        // Get active persona for macro processing
        final persona = await _resolvePersona(
          characterId: character.id,
          chatId: chat.id,
        );

        // Process macros in the greeting
        final macroContext = MacroContext.fromData(
          character: character,
          persona: persona,
          chat: chat,
          messages: [],
        );
        final macroService = MacroService(macroContext);
        final processedGreeting = macroService.process(character.firstMessage);

        // Alternate greetings become swipes of the first message so the
        // user can browse the card's opening variants (ST behavior)
        final greetingSwipes = [
          processedGreeting,
          ...character.alternateGreetings
              .where((g) => g.trim().isNotEmpty)
              .map(macroService.process),
        ];

        final greeting = ChatMessage(
          id: _generateId(),
          chatId: chat.id,
          role: MessageRole.assistant,
          content: processedGreeting,
          timestamp: DateTime.now(),
          swipes: greetingSwipes,
          currentSwipeIndex: 0,
        );
        await _chatRepository.addMessage(greeting);
        state = state.copyWith(
          chat: chat,
          character: character,
          messages: [greeting],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          chat: chat,
          character: character,
          messages: [],
          isLoading: false,
        );
      }

      return chat.id;
    } catch (e, stackTrace) {
      debugPrint('❌ ChatProvider createChat error: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Create a new group chat
  Future<String?> createGroupChat(Group group) async {
    if (group.members.isEmpty) return null;

    _chatLoadGeneration++;
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load all member characters
      final groupChars = <String, Character>{};
      for (final member in group.members) {
        final char = await _characterRepository.getCharacter(
          member.characterId,
        );
        if (char != null) {
          groupChars[char.id] = char;
        }
      }

      if (groupChars.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: _l10n.noValidCharactersInGroup,
        );
        return null;
      }

      // Use first member as the "primary" character
      final firstChar = group.members
          .map((member) => groupChars[member.characterId])
          .whereType<Character>()
          .first;
      final firstCharId = firstChar.id;

      final chat = Chat(
        id: _generateId(),
        characterId: firstCharId,
        groupId: group.id,
        title: _l10n.chatWithName(group.name),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _chatRepository.createChat(chat);

      // Get active persona for macro processing
      final persona = await _resolvePersona(
        characterId: firstCharId,
        groupId: group.id,
        chatId: chat.id,
      );

      // Generate initial greetings from each character (if they have one)
      final messages = <ChatMessage>[];
      for (final member in group.members.where((m) => !m.isMuted)) {
        final char = groupChars[member.characterId];
        if (char != null && char.firstMessage.isNotEmpty) {
          // Process macros in the greeting
          final macroContext = MacroContext.fromData(
            character: char,
            persona: persona,
            chat: chat,
            messages: messages,
            groupCharacters: groupChars.values.toList(),
          );
          final processedGreeting = MacroService(
            macroContext,
          ).process(char.firstMessage);

          final greetingSwipes = [
            processedGreeting,
            ...char.alternateGreetings
                .where((greeting) => greeting.trim().isNotEmpty)
                .map(MacroService(macroContext).process),
          ];
          final greeting = ChatMessage(
            id: _generateId(),
            chatId: chat.id,
            role: MessageRole.assistant,
            content: processedGreeting,
            timestamp: DateTime.now(),
            swipes: greetingSwipes,
            currentSwipeIndex: 0,
            characterId: char.id,
            characterName: char.name,
          );
          await _chatRepository.addMessage(greeting);
          messages.add(greeting);
        }
      }

      state = state.copyWith(
        chat: chat,
        character: firstChar,
        group: group,
        groupCharacters: groupChars,
        messages: messages,
        isLoading: false,
      );

      return chat.id;
    } catch (e, stackTrace) {
      debugPrint('❌ ChatProvider createGroupChat error: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Send a user message and get AI response
  Future<void> sendMessage(
    String content,
    LLMConfig config, {
    List<ChatAttachment> attachments = const [],
  }) async {
    if (state.chat == null) return;

    await _ensureAllMessagesLoaded();

    // For group chats, use group message handling
    if (state.isGroupChat) {
      await sendGroupMessage(content, config, attachments: attachments);
      return;
    }

    if (state.character == null) return;

    // Add user message
    final userMessage = ChatMessage(
      id: _generateId(),
      chatId: state.chat!.id,
      role: MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
      swipes: [content],
      currentSwipeIndex: 0,
      attachments: attachments,
    );

    await _chatRepository.addMessage(userMessage);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isGenerating: true,
      error: null,
    );

    // Check if we need to summarize before generating response
    await _checkAndSummarize(config);

    _startGenerationSession(config, ChatGenerationMode.send);

    try {
      // Prepare context for LLM
      final context = await _buildContext();
      final assistantMetadata = _newAssistantMetadata();

      // Create placeholder for assistant message
      final assistantMessage = ChatMessage(
        id: _generateId(),
        chatId: state.chat!.id,
        role: MessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        swipes: [''],
        currentSwipeIndex: 0,
        metadata: assistantMetadata,
      );

      state = state.copyWith(messages: [...state.messages, assistantMessage]);

      String finalContent;
      String? finalReasoning;

      if (config.streamEnabled) {
        // Stream the response with reasoning support
        final contentBuffer = StringBuffer();
        final reasoningBuffer = StringBuffer();
        await for (final chunk in _generateStreamWithPrefill(context, config)) {
          if (chunk.isReasoningChunk && chunk.reasoning != null) {
            reasoningBuffer.write(chunk.reasoning);
          }
          if (chunk.content != null) {
            contentBuffer.write(chunk.content);
          }
          final updatedMessage = assistantMessage.copyWith(
            content: contentBuffer.toString(),
            swipes: [contentBuffer.toString()],
            reasoning:
                reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
            reasoningSwipes: reasoningBuffer.isNotEmpty
                ? [reasoningBuffer.toString()]
                : null,
          );

          final updatedMessages = List<ChatMessage>.from(state.messages);
          updatedMessages[updatedMessages.length - 1] = updatedMessage;
          state = state.copyWith(messages: updatedMessages);
        }
        finalContent = contentBuffer.toString();
        finalReasoning =
            reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null;
      } else {
        // Non-streaming: get complete response at once with reasoning support
        final response = await _generateWithPrefill(context, config);
        finalContent = response.content;
        finalReasoning = response.reasoning;

        // Update the message with final content
        final updatedMessage = assistantMessage.copyWith(
          content: finalContent,
          swipes: [finalContent],
        );
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] = updatedMessage;
        state = state.copyWith(messages: updatedMessages);
      }

      // Save the final message
      final finalMessage = assistantMessage.copyWith(
        content: finalContent,
        swipes: [finalContent],
        reasoning: finalReasoning,
        reasoningSwipes: finalReasoning != null ? [finalReasoning] : null,
      );
      await _chatRepository.addMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
      await _restoreRecentMessagesPage();
      unawaited(
        _writeStoryAfterTurn(
          chatId: state.chat!.id,
          turnMessages: [userMessage, finalMessage],
          config: config,
        ),
      );
    } catch (e, stackTrace) {
      _closeGenerationSession();
      if (e is ChatGenerationCancelledException) {
        _discardTrailingEmptyAssistantPlaceholder();
        state = state.copyWith(isGenerating: false);
        return;
      }
      debugPrint('❌ ChatProvider sendMessage error: $e\n$stackTrace');
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  /// Regenerate the last assistant message
  Future<void> regenerateLastMessage(LLMConfig config) async {
    await _ensureAllMessagesLoaded();
    if (state.messages.isEmpty) return;

    final lastMessage = state.messages.last;
    if (lastMessage.role != MessageRole.assistant) return;

    state = state.copyWith(isGenerating: true, error: null);
    _startGenerationSession(config, ChatGenerationMode.regenerate);

    try {
      final context = await _buildContext(excludeLastAssistant: true);
      final responseMetadata = _metadataForNewSwipe(lastMessage);

      String finalContent;
      String? finalReasoning;

      if (config.streamEnabled) {
        // Streaming mode
        final contentBuffer = StringBuffer();
        final reasoningBuffer = StringBuffer();
        await for (final chunk in _generateStreamWithPrefill(context, config)) {
          // Check if generation was cancelled
          if (_isCancelling) {
            break;
          }

          if (chunk.isReasoningChunk && chunk.reasoning != null) {
            reasoningBuffer.write(chunk.reasoning);
          }
          if (chunk.content != null) {
            contentBuffer.write(chunk.content);
          }

          final newSwipes = List<String>.from(lastMessage.swipes);
          final newSwipeIndex = newSwipes.length;
          newSwipes.add(contentBuffer.toString());

          // Handle reasoning swipes
          final newReasoningSwipes = List<String>.from(
            lastMessage.reasoningSwipes ?? [],
          );
          while (newReasoningSwipes.length < newSwipeIndex) {
            newReasoningSwipes.add('');
          }
          if (reasoningBuffer.isNotEmpty) {
            if (newReasoningSwipes.length <= newSwipeIndex) {
              newReasoningSwipes.add(reasoningBuffer.toString());
            } else {
              newReasoningSwipes[newSwipeIndex] = reasoningBuffer.toString();
            }
          }

          final updatedMessage = lastMessage.copyWith(
            content: contentBuffer.toString(),
            swipes: newSwipes,
            currentSwipeIndex: newSwipeIndex,
            reasoning:
                reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
            reasoningSwipes:
                newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
            metadata: responseMetadata,
          );

          final updatedMessages = List<ChatMessage>.from(state.messages);
          updatedMessages[updatedMessages.length - 1] = updatedMessage;
          state = state.copyWith(messages: updatedMessages);
        }
        finalContent = contentBuffer.toString();
        finalReasoning =
            reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null;
      } else {
        // Non-streaming mode with reasoning support
        final response = await _generateWithPrefill(context, config);
        finalContent = response.content;
        finalReasoning = response.reasoning;
      }

      // Save the updated message
      final newSwipes = List<String>.from(lastMessage.swipes);
      newSwipes.add(finalContent);

      // Handle reasoning swipes for final message
      final newReasoningSwipes = List<String>.from(
        lastMessage.reasoningSwipes ?? [],
      );
      while (newReasoningSwipes.length < newSwipes.length - 1) {
        newReasoningSwipes.add('');
      }
      if (finalReasoning != null && finalReasoning.isNotEmpty) {
        newReasoningSwipes.add(finalReasoning);
      }

      final finalMessage = lastMessage.copyWith(
        content: finalContent,
        swipes: newSwipes,
        currentSwipeIndex: newSwipes.length - 1,
        reasoning: finalReasoning,
        reasoningSwipes:
            newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
        metadata: responseMetadata,
      );
      await _chatRepository.updateMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
      await _restoreRecentMessagesPage();
    } catch (e, stackTrace) {
      _closeGenerationSession();
      if (e is ChatGenerationCancelledException) {
        state = state.copyWith(isGenerating: false);
        return;
      }
      debugPrint('❌ ChatProvider regenerateLastMessage error: $e\n$stackTrace');
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  /// Swipe to a different response variant
  Future<void> swipeMessage(String messageId, int swipeIndex) async {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    final message = state.messages[messageIndex];
    if (swipeIndex < 0 || swipeIndex >= message.swipes.length) return;

    final updatedMessage = message.copyWith(
      content: message.swipes[swipeIndex],
      currentSwipeIndex: swipeIndex,
    );

    await _chatRepository.updateMessage(updatedMessage);

    final updatedMessages = List<ChatMessage>.from(state.messages);
    updatedMessages[messageIndex] = updatedMessage;
    state = state.copyWith(messages: updatedMessages);
  }

  /// Delete a single swipe from a message (Swipe Picker)
  /// Keeps at least one swipe; adjusts the current index if needed
  Future<void> deleteSwipe(String messageId, int swipeIndex) async {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    final message = state.messages[messageIndex];
    if (message.swipes.length <= 1) return;
    if (swipeIndex < 0 || swipeIndex >= message.swipes.length) return;

    final updatedSwipes = List<String>.from(message.swipes)
      ..removeAt(swipeIndex);

    var newIndex = message.currentSwipeIndex;
    if (newIndex >= updatedSwipes.length) {
      newIndex = updatedSwipes.length - 1;
    } else if (swipeIndex < newIndex) {
      newIndex--;
    }

    final updatedMessage = message.copyWith(
      content: updatedSwipes[newIndex],
      swipes: updatedSwipes,
      currentSwipeIndex: newIndex,
      metadata: removeDataBankContextMetadataAt(
        metadata: message.metadata,
        swipeIndex: swipeIndex,
      ),
    );

    await _chatRepository.updateMessage(updatedMessage);

    final updatedMessages = List<ChatMessage>.from(state.messages);
    updatedMessages[messageIndex] = updatedMessage;
    state = state.copyWith(messages: updatedMessages);
  }

  /// Edit a message
  Future<void> editMessage(String messageId, String newContent) async {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    final message = state.messages[messageIndex];
    final updatedSwipes = List<String>.from(message.swipes);
    updatedSwipes[message.currentSwipeIndex] = newContent;

    final updatedMessage = message.copyWith(
      content: newContent,
      swipes: updatedSwipes,
    );

    await _chatRepository.updateMessage(updatedMessage);

    final updatedMessages = List<ChatMessage>.from(state.messages);
    updatedMessages[messageIndex] = updatedMessage;
    state = state.copyWith(messages: updatedMessages);
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    await _chatRepository.deleteMessage(messageId);
    state = state.copyWith(
      messages: state.messages.where((m) => m.id != messageId).toList(),
    );
  }

  /// Add an attachment to an existing message
  Future<void> addAttachmentToMessage(
    String messageId,
    ChatAttachment attachment,
  ) async {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    final message = state.messages[messageIndex];
    final updatedAttachments = [...message.attachments, attachment];

    final updatedMessage = message.copyWith(attachments: updatedAttachments);

    await _chatRepository.updateMessage(updatedMessage);

    final updatedMessages = List<ChatMessage>.from(state.messages);
    updatedMessages[messageIndex] = updatedMessage;
    state = state.copyWith(messages: updatedMessages);
  }

  /// Add a local message without triggering an LLM response.
  Future<ChatMessage?> addLocalMessage({
    required MessageRole role,
    required String content,
    List<ChatAttachment> attachments = const [],
  }) async {
    final chat = state.chat;
    if (chat == null) return null;

    final message = ChatMessage(
      id: _generateId(),
      chatId: chat.id,
      role: role,
      content: content,
      timestamp: DateTime.now(),
      swipes: [content],
      attachments: attachments,
    );
    await _chatRepository.addMessage(message);
    state = state.copyWith(messages: [...state.messages, message]);
    return message;
  }

  /// Delete a message and all messages after it
  Future<void> deleteMessageAndAfter(String messageId) async {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    // Delete all messages from this index onwards
    final messagesToDelete = state.messages.sublist(messageIndex);
    for (final msg in messagesToDelete) {
      await _chatRepository.deleteMessage(msg.id);
    }

    state = state.copyWith(messages: state.messages.sublist(0, messageIndex));
  }

  /// Regenerate a specific assistant message (adds new swipe)
  Future<void> regenerateMessage(String messageId, LLMConfig config) async {
    await _ensureAllMessagesLoaded();
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    final message = state.messages[messageIndex];
    if (message.role != MessageRole.assistant) return;

    state = state.copyWith(isGenerating: true, error: null);
    _startGenerationSession(config, ChatGenerationMode.regenerate);

    try {
      // Build context up to (but not including) this message
      final context = await _buildContextUpTo(messageIndex);
      final responseMetadata = _metadataForNewSwipe(message);

      String finalContent;
      String? finalReasoning;

      if (config.streamEnabled) {
        // Streaming mode
        final contentBuffer = StringBuffer();
        final reasoningBuffer = StringBuffer();
        await for (final chunk in _generateStreamWithPrefill(context, config)) {
          // Check if generation was cancelled
          if (_isCancelling) {
            break;
          }

          if (chunk.isReasoningChunk && chunk.reasoning != null) {
            reasoningBuffer.write(chunk.reasoning);
          }
          if (chunk.content != null) {
            contentBuffer.write(chunk.content);
          }

          final newSwipes = List<String>.from(message.swipes);
          // Check if we're still adding to the same swipe or creating new
          if (newSwipes.length == message.swipes.length) {
            newSwipes.add(contentBuffer.toString());
          } else {
            newSwipes[newSwipes.length - 1] = contentBuffer.toString();
          }

          // Handle reasoning swipes
          final newReasoningSwipes = List<String>.from(
            message.reasoningSwipes ?? [],
          );
          while (newReasoningSwipes.length < newSwipes.length - 1) {
            newReasoningSwipes.add('');
          }
          if (reasoningBuffer.isNotEmpty) {
            if (newReasoningSwipes.length < newSwipes.length) {
              newReasoningSwipes.add(reasoningBuffer.toString());
            } else {
              newReasoningSwipes[newSwipes.length - 1] =
                  reasoningBuffer.toString();
            }
          }

          final updatedMessage = message.copyWith(
            content: contentBuffer.toString(),
            swipes: newSwipes,
            currentSwipeIndex: newSwipes.length - 1,
            reasoning:
                reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
            reasoningSwipes:
                newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
            metadata: responseMetadata,
          );

          final updatedMessages = List<ChatMessage>.from(state.messages);
          updatedMessages[messageIndex] = updatedMessage;
          state = state.copyWith(messages: updatedMessages);
        }
        finalContent = contentBuffer.toString();
        finalReasoning =
            reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null;
      } else {
        // Non-streaming mode with reasoning support
        final response = await _generateWithPrefill(context, config);
        finalContent = response.content;
        finalReasoning = response.reasoning;
      }

      // Save the updated message
      final newSwipes = List<String>.from(message.swipes);
      newSwipes.add(finalContent);

      // Handle reasoning swipes for final message
      final newReasoningSwipes = List<String>.from(
        message.reasoningSwipes ?? [],
      );
      while (newReasoningSwipes.length < newSwipes.length - 1) {
        newReasoningSwipes.add('');
      }
      if (finalReasoning != null && finalReasoning.isNotEmpty) {
        newReasoningSwipes.add(finalReasoning);
      }

      final finalMessage = message.copyWith(
        content: finalContent,
        swipes: newSwipes,
        currentSwipeIndex: newSwipes.length - 1,
        reasoning: finalReasoning,
        reasoningSwipes:
            newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
        metadata: responseMetadata,
      );
      await _chatRepository.updateMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
      await _restoreRecentMessagesPage();
    } catch (e, stackTrace) {
      _closeGenerationSession();
      if (e is ChatGenerationCancelledException) {
        state = state.copyWith(isGenerating: false);
        return;
      }
      debugPrint('❌ ChatProvider swipeGenerate error: $e\n$stackTrace');
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  /// Continue from a specific message (delete all after and regenerate)
  Future<void> continueFromMessage(String messageId, LLMConfig config) async {
    await _ensureAllMessagesLoaded();
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    // Delete all messages after this one
    if (messageIndex < state.messages.length - 1) {
      final messagesToDelete = state.messages.sublist(messageIndex + 1);
      for (final msg in messagesToDelete) {
        await _chatRepository.deleteMessage(msg.id);
      }
      state = state.copyWith(
        messages: state.messages.sublist(0, messageIndex + 1),
      );
    }

    // If the message is from user, generate assistant response
    final message = state.messages[messageIndex];
    if (message.role == MessageRole.user) {
      await _generateAssistantResponse(config);
    }
  }

  /// Continue generation without user message (for "Continue" quick reply)
  Future<void> continueGeneration(LLMConfig config) async {
    if (state.chat == null) return;
    await _ensureAllMessagesLoaded();

    // For group chats, pick a character to respond
    if (state.isGroupChat) {
      final group = state.group;
      if (group == null) return;

      final activeMemberIds = group.members
          .where((m) => !m.isMuted)
          .map((m) => m.characterId)
          .toList();

      if (activeMemberIds.isEmpty) return;

      // Pick the next character in sequence
      final lastAssistantMsg = state.messages.reversed.firstWhere(
        (m) => m.role == MessageRole.assistant && m.characterId != null,
        orElse: () => state.messages.first,
      );

      String nextCharId;
      if (lastAssistantMsg.characterId != null) {
        final lastIndex = activeMemberIds.indexOf(
          lastAssistantMsg.characterId!,
        );
        final nextIndex = (lastIndex + 1) % activeMemberIds.length;
        nextCharId = activeMemberIds[nextIndex];
      } else {
        nextCharId = activeMemberIds.first;
      }

      await _generateGroupCharacterResponse(nextCharId, config);
      return;
    }

    // For single character chats
    await _generateAssistantResponse(config);
  }

  /// Impersonate: generate the next reply from the user's point of view.
  /// Returns the text for the input field; nothing is added to the chat.
  Future<String?> impersonate(LLMConfig config) async {
    if (state.chat == null) return null;
    await _ensureAllMessagesLoaded();

    state = state.copyWith(isGenerating: true, error: null);
    _startGenerationSession(config, ChatGenerationMode.impersonate);
    try {
      final context = [...await _buildContext()];
      context.add({
        'role': 'system',
        'content': '[Write the next reply from the point of view of the user '
            'persona. Write only what the user says and does, in the '
            'same style as their previous messages. Do not write for '
            'any other character. Do not add any commentary.]',
      });

      // Deliberately bypass the assistant prefill - it steers the AI's
      // voice, not the user's
      final response = await _generateWithoutPrefill(context, config);
      state = state.copyWith(isGenerating: false);
      await _restoreRecentMessagesPage();
      final text = response.content.trim();
      return text.isEmpty ? null : text;
    } catch (e) {
      _closeGenerationSession();
      if (e is ChatGenerationCancelledException) {
        state = state.copyWith(isGenerating: false);
        return null;
      }
      state = state.copyWith(isGenerating: false, error: e.toString());
      return null;
    }
  }

  /// Generate assistant response based on current context
  Future<void> _generateAssistantResponse(LLMConfig config) async {
    if (state.chat == null || state.character == null) return;

    state = state.copyWith(isGenerating: true, error: null);
    _startGenerationSession(config, ChatGenerationMode.continueResponse);

    try {
      final context = await _buildContext();
      final assistantMetadata = _newAssistantMetadata();

      // Create placeholder for assistant message
      final assistantMessage = ChatMessage(
        id: _generateId(),
        chatId: state.chat!.id,
        role: MessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        swipes: [''],
        currentSwipeIndex: 0,
        metadata: assistantMetadata,
      );

      state = state.copyWith(messages: [...state.messages, assistantMessage]);

      String finalContent;
      String? finalReasoning;

      if (config.streamEnabled) {
        // Stream the response with reasoning support
        final contentBuffer = StringBuffer();
        final reasoningBuffer = StringBuffer();
        await for (final chunk in _generateStreamWithPrefill(context, config)) {
          // Check if generation was cancelled
          if (_isCancelling) {
            break;
          }

          if (chunk.isReasoningChunk && chunk.reasoning != null) {
            reasoningBuffer.write(chunk.reasoning);
          }
          if (chunk.content != null) {
            contentBuffer.write(chunk.content);
          }
          final updatedMessage = assistantMessage.copyWith(
            content: contentBuffer.toString(),
            swipes: [contentBuffer.toString()],
            reasoning:
                reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
            reasoningSwipes: reasoningBuffer.isNotEmpty
                ? [reasoningBuffer.toString()]
                : null,
          );

          final updatedMessages = List<ChatMessage>.from(state.messages);
          updatedMessages[updatedMessages.length - 1] = updatedMessage;
          state = state.copyWith(messages: updatedMessages);
        }
        finalContent = contentBuffer.toString();
        finalReasoning =
            reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null;
      } else {
        // Non-streaming: get complete response at once with reasoning support
        final response = await _generateWithPrefill(context, config);
        finalContent = response.content;
        finalReasoning = response.reasoning;

        // Update the message with final content
        final updatedMessage = assistantMessage.copyWith(
          content: finalContent,
          swipes: [finalContent],
        );
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] = updatedMessage;
        state = state.copyWith(messages: updatedMessages);
      }

      // Save the final message
      final finalMessage = assistantMessage.copyWith(
        content: finalContent,
        swipes: [finalContent],
        reasoning: finalReasoning,
        reasoningSwipes: finalReasoning != null ? [finalReasoning] : null,
      );
      await _chatRepository.addMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
      await _restoreRecentMessagesPage();
    } catch (e, stackTrace) {
      _closeGenerationSession();
      if (e is ChatGenerationCancelledException) {
        _discardTrailingEmptyAssistantPlaceholder();
        state = state.copyWith(isGenerating: false);
        return;
      }
      debugPrint(
        '❌ ChatProvider _generateAssistantResponse error: $e\n$stackTrace',
      );
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  /// Build context for LLM
  /// This method builds the full message list according to Prompt Manager configuration
  Future<List<Map<String, dynamic>>> _buildContext({
    bool excludeLastAssistant = false,
  }) async {
    final messages = <Map<String, dynamic>>[];
    final character = state.character;
    final chat = state.chat;

    // Get chat messages - use summaries if available
    var chatMessages = state.messages;
    if (excludeLastAssistant &&
        chatMessages.isNotEmpty &&
        chatMessages.last.role == MessageRole.assistant) {
      chatMessages = chatMessages.sublist(0, chatMessages.length - 1);
    }

    // Check if we have summaries and should use them
    final summaries = chat?.summaries ?? [];
    if (summaries.isNotEmpty) {
      final lastSummary = summaries.last;
      // Get only recent messages after the last summary
      final recentMessages = _summarizationService.getRecentMessages(
        allMessages: chatMessages,
        latestSummary: lastSummary,
      );
      // Use recent messages for building context
      chatMessages = recentMessages;
      debugPrint(
        '📝 Using summary + ${chatMessages.length} recent messages for context',
      );
    }

    // Find matching World Info entries
    List<WorldInfoEntry> worldInfoEntries = [];
    if (character != null) {
      worldInfoEntries = await _findMatchingWorldInfoEntries(
        character,
        chatMessages,
      );
    }

    // Get Prompt Manager configuration
    final promptConfig = _ref.read(promptManagerProvider);
    final enabledSections = promptConfig.enabledSections;

    // Get active persona
    final persona = await _resolvePersona();

    // Get LLM config for macro context
    final llmConfig = _ref.read(llmConfigProvider);

    // Create macro context for processing
    MacroContext? macroContext;
    MacroService? macroService;
    if (character != null) {
      macroContext = MacroContext.fromData(
        character: character,
        persona: persona,
        chat: state.chat,
        messages: state.messages,
        modelName: llmConfig.model,
        providerName: llmConfig.provider.name,
        maxContextTokens: llmConfig.contextLength,
        maxResponseTokens: llmConfig.maxTokens,
      );
      macroService = MacroService(macroContext);
    }

    // Helper to process macros in text
    String processMacros(String text) => macroService?.process(text) ?? text;

    // Group world info entries by position
    final groupedEntries = _worldInfoMatcher.groupByPosition(worldInfoEntries);

    // Helper to add world info entries at a position
    void addWorldInfoAt(WorldInfoPosition position, String role) {
      final entries = groupedEntries[position];
      if (entries != null && entries.isNotEmpty) {
        for (final entry in entries) {
          messages.add({
            'role': role,
            'content':
                '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
          });
        }
      }
    }

    // Separate sections into:
    // 1. Pre-chat sections (before chatHistory)
    // 2. Chat history
    // 3. Post-chat sections (after chatHistory)
    // 4. Depth-based injections
    final preChatSections = <PromptSection>[];
    final postChatSections = <PromptSection>[];
    final depthBasedSections = <PromptSection>[];
    bool foundChatHistory = false;

    for (final section in enabledSections) {
      if (section.type == PromptSectionType.chatHistory) {
        foundChatHistory = true;
        continue;
      }

      // Check if this section has depth-based injection
      if (section.injectionPosition == 1 && section.injectionDepth != null) {
        depthBasedSections.add(section);
        continue;
      }

      if (foundChatHistory) {
        postChatSections.add(section);
      } else {
        preChatSections.add(section);
      }
    }

    // Build pre-chat messages
    for (final section in preChatSections) {
      final sectionMessages = await _buildSectionMessages(
        section,
        character,
        persona,
        worldInfoEntries,
        groupedEntries,
        processMacros,
        addWorldInfoAt,
      );
      messages.addAll(sectionMessages);
    }

    if (persona != null &&
        persona.descriptionSettings.position ==
            PersonaDescriptionPosition.afterChar) {
      final personaMessage = _buildPersonaMessage(persona, processMacros);
      if (personaMessage != null) messages.add(personaMessage);
    }

    // Add summary message if we have summaries
    if (summaries.isNotEmpty) {
      final latestSummary = summaries.last;
      final summaryMessage = _summarizationService.createSummaryMessage(
        summary: latestSummary,
        chatId: state.chat!.id,
      );
      messages.add({'role': 'assistant', 'content': summaryMessage.content});
      debugPrint(
        '📌 Added summary to context: ${latestSummary.content.substring(0, min(100, latestSummary.content.length))}...',
      );
    }

    // Add chat messages with depth-based injections
    final depthEntries = worldInfoEntries
        .where((e) => e.position == WorldInfoPosition.atDepth)
        .toList();

    // Prepare Author's Note for depth-based injection
    final authorNoteEnabled = chat?.authorNoteEnabled ?? false;
    final authorNote = chat?.authorNote ?? '';
    final authorNoteDepth = chat?.authorNoteDepth ?? 4;
    final personaPosition = persona?.descriptionSettings.position;
    final personaDepth = personaPosition == PersonaDescriptionPosition.atDepth
        ? persona!.descriptionSettings.depth
        : (personaPosition == PersonaDescriptionPosition.topAN ||
                personaPosition == PersonaDescriptionPosition.bottomAN)
            ? authorNoteDepth
            : null;

    // RAG: retrieve relevant knowledge for the latest user message
    if (chatMessages.isNotEmpty) {
      final lastUserMessage = chatMessages
          .lastWhere(
            (m) => m.role == MessageRole.user,
            orElse: () => chatMessages.last,
          )
          .content;
      final ragContext = await _ref.read(ragContextProvider)(lastUserMessage);
      if (ragContext != null && ragContext.isNotEmpty) {
        messages.add({'role': 'system', 'content': ragContext});
      }
    }
    final conversationStartIndex = messages.length;

    // Prepare character depth prompt (ST extensions.depth_prompt)
    final depthPrompt = character?.depthPrompt;
    final hasDepthPrompt = depthPrompt != null && depthPrompt.prompt.isNotEmpty;

    for (var i = 0; i < chatMessages.length; i++) {
      final msg = chatMessages[i];

      // Depth is counted from the end (most recent = depth 0)
      final depthFromEnd = chatMessages.length - 1 - i;

      if (persona != null &&
          personaDepth == depthFromEnd &&
          personaPosition != PersonaDescriptionPosition.bottomAN) {
        final personaMessage = _buildPersonaMessage(persona, processMacros);
        if (personaMessage != null) messages.add(personaMessage);
      }

      // Inject character depth prompt at its configured depth
      if (hasDepthPrompt && depthFromEnd == depthPrompt.depth) {
        messages.add({
          'role': depthPrompt.role,
          'content': processMacros(depthPrompt.prompt),
        });
      }

      // Check if any depth-based world info entries should be inserted before this message
      for (final entry in depthEntries) {
        if (entry.depth == depthFromEnd) {
          messages.add({
            'role': 'system',
            'content':
                '[World Info: ${entry.comment.isNotEmpty ? entry.comment : "Context"}]\n${processMacros(entry.content)}',
          });
        }
      }

      // Check if any depth-based prompt sections should be inserted
      for (final section in depthBasedSections) {
        if (section.injectionDepth == depthFromEnd) {
          final sectionMessages = await _buildSectionMessages(
            section,
            character,
            persona,
            worldInfoEntries,
            groupedEntries,
            processMacros,
            addWorldInfoAt,
          );
          messages.addAll(sectionMessages);
        }
      }

      // Inject Author's Note at the configured depth
      if (authorNoteEnabled &&
          authorNote.isNotEmpty &&
          depthFromEnd == authorNoteDepth) {
        final processedNote = await _processAuthorNoteMacros(authorNote);
        messages.add({
          'role': 'system',
          'content': '[Author\'s Note]\n$processedNote',
        });
      }

      if (persona != null &&
          personaDepth == depthFromEnd &&
          personaPosition == PersonaDescriptionPosition.bottomAN) {
        final personaMessage = _buildPersonaMessage(persona, processMacros);
        if (personaMessage != null) messages.add(personaMessage);
      }

      // Build message with attachments if present
      if (msg.hasAttachments && msg.role == MessageRole.user) {
        messages.add(_buildMultimodalMessage(msg));
      } else {
        messages.add({
          'role': msg.role == MessageRole.user ? 'user' : 'assistant',
          'content': msg.content,
        });
      }
    }

    // If Author's Note depth is beyond message count, insert at the start of chat
    if (authorNoteEnabled &&
        authorNote.isNotEmpty &&
        authorNoteDepth >= chatMessages.length) {
      final processedNote = await _processAuthorNoteMacros(authorNote);
      // Find where chat messages start and insert before
      final chatStartIndex = messages.length - chatMessages.length;
      if (chatStartIndex >= 0) {
        messages.insert(chatStartIndex, {
          'role': 'system',
          'content': '[Author\'s Note]\n$processedNote',
        });
      }
    }

    if (persona != null &&
        personaDepth != null &&
        personaDepth >= chatMessages.length) {
      final personaMessage = _buildPersonaMessage(persona, processMacros);
      if (personaMessage != null) {
        final chatStartIndex = messages.length - chatMessages.length;
        messages.insert(
          chatStartIndex.clamp(0, messages.length),
          personaMessage,
        );
      }
    }

    // If depth prompt depth is beyond message count, insert at the start of chat
    if (hasDepthPrompt && depthPrompt.depth >= chatMessages.length) {
      final chatStartIndex = messages.length - chatMessages.length;
      if (chatStartIndex >= 0) {
        messages.insert(chatStartIndex, {
          'role': depthPrompt.role,
          'content': processMacros(depthPrompt.prompt),
        });
      }
    }

    // Build post-chat messages
    for (final section in postChatSections) {
      final sectionMessages = await _buildSectionMessages(
        section,
        character,
        persona,
        worldInfoEntries,
        groupedEntries,
        processMacros,
        addWorldInfoAt,
      );
      messages.addAll(sectionMessages);
    }

    // Debug logging
    print('=== Built Context Messages ===');
    print('Total messages: ${messages.length}');
    print('Pre-chat sections: ${preChatSections.length}');
    print('Post-chat sections: ${postChatSections.length}');
    print('Depth-based sections: ${depthBasedSections.length}');
    print('Chat messages: ${chatMessages.length}');
    for (var i = 0; i < messages.length; i++) {
      final msg = messages[i];
      final content = msg['content'];
      String preview;
      if (content is String) {
        preview =
            content.length > 100 ? '${content.substring(0, 100)}...' : content;
      } else if (content is List) {
        preview = '[Multimodal: ${content.length} parts]';
      } else {
        preview = content.toString();
      }
      print('[$i] ${msg['role']}: $preview');
    }
    print('=== End Context Messages ===');

    return _applyContextContributors(
      messages,
      conversationStartIndex: conversationStartIndex,
    );
  }

  /// Build messages for a single prompt section
  Future<List<Map<String, dynamic>>> _buildSectionMessages(
    PromptSection section,
    Character? character,
    Persona? persona,
    List<WorldInfoEntry> worldInfoEntries,
    Map<WorldInfoPosition, List<WorldInfoEntry>> groupedEntries,
    String Function(String) processMacros,
    void Function(WorldInfoPosition, String) addWorldInfoAt,
  ) async {
    final messages = <Map<String, dynamic>>[];
    final role = section.role ?? 'system';

    switch (section.type) {
      case PromptSectionType.systemPrompt:
        final baseContent = persona?.systemPromptOverride?.isNotEmpty == true
            ? persona!.systemPromptOverride!
            : section.content?.isNotEmpty == true
                ? section.content!
                : (character?.systemPrompt.isNotEmpty == true
                    ? character!.systemPrompt
                    : PromptSection.getDefaultContent(
                        PromptSectionType.systemPrompt,
                      ));
        final embeddedPersona = persona != null &&
                persona.descriptionSettings.position ==
                    PersonaDescriptionPosition.inSystemPrompt
            ? _personaPromptText(persona, processMacros)
            : null;
        final content = embeddedPersona == null || embeddedPersona.isEmpty
            ? baseContent
            : '$baseContent\n\n$embeddedPersona';
        if (content.isNotEmpty) {
          // Add world info before system prompt (using 'before' position as proxy)
          final beforeEntries = groupedEntries[WorldInfoPosition.before];
          if (beforeEntries != null) {
            for (final entry in beforeEntries) {
              messages.add({
                'role': role,
                'content':
                    '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }

          messages.add({'role': role, 'content': processMacros(content)});

          // Add world info after system prompt (using 'after' position as proxy)
          final afterEntries = groupedEntries[WorldInfoPosition.after];
          if (afterEntries != null) {
            for (final entry in afterEntries) {
              messages.add({
                'role': role,
                'content':
                    '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
        }
        break;

      case PromptSectionType.persona:
        if (persona != null &&
            persona.descriptionSettings.position ==
                PersonaDescriptionPosition.beforeChar) {
          final personaMessage = _buildPersonaMessage(persona, processMacros);
          if (personaMessage != null) messages.add(personaMessage);
        }
        break;

      case PromptSectionType.characterDescription:
        if (character != null && character.description.isNotEmpty) {
          // Add world info before character definitions
          final beforeEntries = groupedEntries[WorldInfoPosition.before];
          if (beforeEntries != null) {
            for (final entry in beforeEntries) {
              messages.add({
                'role': role,
                'content':
                    '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }

          messages.add({
            'role': role,
            'content': 'Description:\n${processMacros(character.description)}',
          });
        }
        break;

      case PromptSectionType.characterPersonality:
        if (character != null && character.personality.isNotEmpty) {
          messages.add({
            'role': role,
            'content': 'Personality:\n${processMacros(character.personality)}',
          });
        }
        break;

      case PromptSectionType.characterScenario:
        if (character != null && character.scenario.isNotEmpty) {
          messages.add({
            'role': role,
            'content': 'Scenario:\n${processMacros(character.scenario)}',
          });

          // Add world info after character definitions
          final afterEntries = groupedEntries[WorldInfoPosition.after];
          if (afterEntries != null) {
            for (final entry in afterEntries) {
              messages.add({
                'role': role,
                'content':
                    '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
        }
        break;

      case PromptSectionType.exampleMessages:
        if (character != null && character.exampleMessages.isNotEmpty) {
          // Add world info before examples (using EMTop)
          final beforeEntries = groupedEntries[WorldInfoPosition.EMTop];
          if (beforeEntries != null) {
            for (final entry in beforeEntries) {
              messages.add({
                'role': role,
                'content':
                    '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }

          messages.add({
            'role': role,
            'content':
                'Example dialogue:\n${processMacros(character.exampleMessages)}',
          });

          // Add world info after examples (using EMBottom)
          final afterEntries = groupedEntries[WorldInfoPosition.EMBottom];
          if (afterEntries != null) {
            for (final entry in afterEntries) {
              messages.add({
                'role': role,
                'content':
                    '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
        }
        break;

      case PromptSectionType.worldInfo:
        // World info entries that don't have a specific position
        // Only include entries with outlet position (all other positions are handled elsewhere)
        final generalEntries = worldInfoEntries
            .where((e) => e.position == WorldInfoPosition.outlet)
            .toList();
        for (final entry in generalEntries) {
          messages.add({
            'role': role,
            'content':
                '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
          });
        }
        break;

      case PromptSectionType.worldInfoAfter:
        final afterEntries = groupedEntries[WorldInfoPosition.after];
        if (afterEntries != null) {
          for (final entry in afterEntries) {
            messages.add({
              'role': role,
              'content':
                  '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
            });
          }
        }
        break;

      case PromptSectionType.authorNote:
        // Author's note is handled separately with depth injection
        // ANTop = before Author's Note
        final beforeEntries = groupedEntries[WorldInfoPosition.ANTop];
        if (beforeEntries != null) {
          for (final entry in beforeEntries) {
            messages.add({
              'role': role,
              'content':
                  '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
            });
          }
        }
        // ANBottom = after Author's Note
        final afterEntries = groupedEntries[WorldInfoPosition.ANBottom];
        if (afterEntries != null) {
          for (final entry in afterEntries) {
            messages.add({
              'role': role,
              'content':
                  '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
            });
          }
        }
        break;

      case PromptSectionType.postHistoryInstructions:
        final content = persona?.postHistoryInstructions?.isNotEmpty == true
            ? persona!.postHistoryInstructions!
            : section.content?.isNotEmpty == true
                ? section.content!
                : (character?.postHistoryInstructions.isNotEmpty == true
                    ? character!.postHistoryInstructions
                    : PromptSection.getDefaultContent(
                        PromptSectionType.postHistoryInstructions,
                      ));
        if (content.isNotEmpty) {
          messages.add({'role': role, 'content': processMacros(content)});
        }
        break;

      case PromptSectionType.nsfw:
        // NSFW prompt from section content
        final content = section.content?.isNotEmpty == true
            ? section.content!
            : PromptSection.getDefaultContent(PromptSectionType.nsfw);
        if (content.isNotEmpty) {
          messages.add({'role': role, 'content': processMacros(content)});
        }
        break;

      case PromptSectionType.chatHistory:
        // Chat history is handled separately in the main loop
        break;

      case PromptSectionType.enhanceDefinitions:
        // Enhanced definitions - could add more detailed character info
        break;

      case PromptSectionType.custom:
        // Custom prompt from imported preset
        if (section.content?.isNotEmpty == true) {
          messages.add({
            'role': role,
            'content': processMacros(section.content!),
          });
        }
        break;
    }

    return messages;
  }

  String _personaPromptText(
    Persona persona,
    String Function(String) processMacros,
  ) {
    final buffer = StringBuffer('The user is ${persona.name}.');
    if (persona.description.isNotEmpty) {
      buffer.write('\nUser description: ${processMacros(persona.description)}');
    }
    return buffer.toString();
  }

  Map<String, dynamic>? _buildPersonaMessage(
    Persona persona,
    String Function(String) processMacros,
  ) {
    if (persona.name.isEmpty && persona.description.isEmpty) return null;
    return {
      'role': persona.descriptionSettings.role.name,
      'content': _personaPromptText(persona, processMacros),
    };
  }

  /// Process macros in Author's Note
  Future<String> _processAuthorNoteMacros(String note) async {
    final character = state.character;
    if (character == null) return note;

    // Get active persona
    final persona = await _resolvePersona();

    // Get LLM config
    final llmConfig = _ref.read(llmConfigProvider);

    final macroContext = MacroContext.fromData(
      character: character,
      persona: persona,
      chat: state.chat,
      messages: state.messages,
      modelName: llmConfig.model,
      providerName: llmConfig.provider.name,
    );

    return MacroService(macroContext).process(note);
  }

  /// Build context up to a specific message index (exclusive)
  Future<List<Map<String, dynamic>>> _buildContextUpTo(int messageIndex) async {
    final messages = <Map<String, dynamic>>[];
    final character = state.character;
    final chat = state.chat;

    // Get chat messages up to (but not including) the specified index
    final chatMessages = state.messages.sublist(0, messageIndex);

    // Find matching World Info entries
    List<WorldInfoEntry> worldInfoEntries = [];
    if (character != null) {
      worldInfoEntries = await _findMatchingWorldInfoEntries(
        character,
        chatMessages,
      );
    }

    // Get Prompt Manager configuration
    final promptConfig = _ref.read(promptManagerProvider);
    final enabledSections = promptConfig.enabledSections;

    // Get active persona
    final persona = await _resolvePersona();

    // Get LLM config for macro context
    final llmConfig = _ref.read(llmConfigProvider);

    // Create macro context for processing
    MacroContext? macroContext;
    MacroService? macroService;
    if (character != null) {
      macroContext = MacroContext.fromData(
        character: character,
        persona: persona,
        chat: state.chat,
        messages: chatMessages,
        modelName: llmConfig.model,
        providerName: llmConfig.provider.name,
        maxContextTokens: llmConfig.contextLength,
        maxResponseTokens: llmConfig.maxTokens,
      );
      macroService = MacroService(macroContext);
    }

    // Helper to process macros in text
    String processMacros(String text) => macroService?.process(text) ?? text;

    // Group world info entries by position
    final groupedEntries = _worldInfoMatcher.groupByPosition(worldInfoEntries);

    // Helper to add world info entries at a position
    void addWorldInfoAt(WorldInfoPosition position, String role) {
      final entries = groupedEntries[position];
      if (entries != null && entries.isNotEmpty) {
        for (final entry in entries) {
          messages.add({
            'role': role,
            'content':
                '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
          });
        }
      }
    }

    // Separate sections into pre-chat, post-chat, and depth-based
    final preChatSections = <PromptSection>[];
    final postChatSections = <PromptSection>[];
    final depthBasedSections = <PromptSection>[];
    bool foundChatHistory = false;

    for (final section in enabledSections) {
      if (section.type == PromptSectionType.chatHistory) {
        foundChatHistory = true;
        continue;
      }

      if (section.injectionPosition == 1 && section.injectionDepth != null) {
        depthBasedSections.add(section);
        continue;
      }

      if (foundChatHistory) {
        postChatSections.add(section);
      } else {
        preChatSections.add(section);
      }
    }

    // Build pre-chat messages
    for (final section in preChatSections) {
      final sectionMessages = await _buildSectionMessages(
        section,
        character,
        persona,
        worldInfoEntries,
        groupedEntries,
        processMacros,
        addWorldInfoAt,
      );
      messages.addAll(sectionMessages);
    }

    // Add summary message if we have summaries
    final summaries = chat?.summaries ?? [];
    if (summaries.isNotEmpty) {
      final latestSummary = summaries.last;
      final summaryMessage = _summarizationService.createSummaryMessage(
        summary: latestSummary,
        chatId: state.chat!.id,
      );
      messages.add({'role': 'assistant', 'content': summaryMessage.content});
      debugPrint(
        '📌 Added summary to context: ${latestSummary.content.substring(0, min(100, latestSummary.content.length))}...',
      );
    }

    // Add chat messages with depth-based injections
    final depthEntries = worldInfoEntries
        .where((e) => e.position == WorldInfoPosition.atDepth)
        .toList();

    // Prepare Author's Note for depth-based injection
    final authorNoteEnabled = chat?.authorNoteEnabled ?? false;
    final authorNote = chat?.authorNote ?? '';
    final authorNoteDepth = chat?.authorNoteDepth ?? 4;

    // RAG: retrieve relevant knowledge for the latest user message
    if (chatMessages.isNotEmpty) {
      final lastUserMessage = chatMessages
          .lastWhere(
            (m) => m.role == MessageRole.user,
            orElse: () => chatMessages.last,
          )
          .content;
      final ragContext = await _ref.read(ragContextProvider)(lastUserMessage);
      if (ragContext != null && ragContext.isNotEmpty) {
        messages.add({'role': 'system', 'content': ragContext});
      }
    }
    final conversationStartIndex = messages.length;

    // Prepare character depth prompt (ST extensions.depth_prompt)
    final depthPrompt = character?.depthPrompt;
    final hasDepthPrompt = depthPrompt != null && depthPrompt.prompt.isNotEmpty;

    for (var i = 0; i < chatMessages.length; i++) {
      final msg = chatMessages[i];

      // Depth is counted from the end (most recent = depth 0)
      final depthFromEnd = chatMessages.length - 1 - i;

      // Inject character depth prompt at its configured depth
      if (hasDepthPrompt && depthFromEnd == depthPrompt.depth) {
        messages.add({
          'role': depthPrompt.role,
          'content': processMacros(depthPrompt.prompt),
        });
      }

      // Check if any depth-based world info entries should be inserted
      for (final entry in depthEntries) {
        if (entry.depth == depthFromEnd) {
          messages.add({
            'role': 'system',
            'content':
                '[World Info: ${entry.comment.isNotEmpty ? entry.comment : "Context"}]\n${processMacros(entry.content)}',
          });
        }
      }

      // Check if any depth-based prompt sections should be inserted
      for (final section in depthBasedSections) {
        if (section.injectionDepth == depthFromEnd) {
          final sectionMessages = await _buildSectionMessages(
            section,
            character,
            persona,
            worldInfoEntries,
            groupedEntries,
            processMacros,
            addWorldInfoAt,
          );
          messages.addAll(sectionMessages);
        }
      }

      // Inject Author's Note at the configured depth
      if (authorNoteEnabled &&
          authorNote.isNotEmpty &&
          depthFromEnd == authorNoteDepth) {
        final processedNote = await _processAuthorNoteMacros(authorNote);
        messages.add({
          'role': 'system',
          'content': '[Author\'s Note]\n$processedNote',
        });
      }

      // Build message with attachments if present
      if (msg.hasAttachments && msg.role == MessageRole.user) {
        messages.add(_buildMultimodalMessage(msg));
      } else {
        messages.add({
          'role': msg.role == MessageRole.user ? 'user' : 'assistant',
          'content': msg.content,
        });
      }
    }

    // If Author's Note depth is beyond message count, insert at the start of chat
    if (authorNoteEnabled &&
        authorNote.isNotEmpty &&
        authorNoteDepth >= chatMessages.length) {
      final processedNote = await _processAuthorNoteMacros(authorNote);
      final chatStartIndex = messages.length - chatMessages.length;
      if (chatStartIndex >= 0) {
        messages.insert(chatStartIndex, {
          'role': 'system',
          'content': '[Author\'s Note]\n$processedNote',
        });
      }
    }

    // Build post-chat messages
    for (final section in postChatSections) {
      final sectionMessages = await _buildSectionMessages(
        section,
        character,
        persona,
        worldInfoEntries,
        groupedEntries,
        processMacros,
        addWorldInfoAt,
      );
      messages.addAll(sectionMessages);
    }

    return _applyContextContributors(
      messages,
      conversationStartIndex: conversationStartIndex,
    );
  }

  /// Find matching World Info entries based on chat context
  Future<List<WorldInfoEntry>> _findMatchingWorldInfoEntries(
    Character character,
    List<ChatMessage> chatMessages,
  ) async {
    // Get active world info IDs (manually enabled for this chat)
    final activeIds = _ref.read(activeWorldInfoIdsProvider);

    // Books linked to this specific chat (chat lorebooks)
    final chatLinkedIds = state.chat?.linkedWorldInfoIds ?? const <String>[];
    final persona = await _resolvePersona(characterId: character.id);
    final personaLorebookId = persona?.lorebookId;

    // Get ALL world infos and filter by enabled status
    final allWorldInfos = await _ref.read(allWorldInfosProvider.future);

    // Filter to get enabled world infos that are either:
    // 1. Global (isGlobal = true) - explicitly marked as global
    // 2. Linked to this character
    // 3. Linked to this chat (chat lorebook)
    // 4. Manually activated via activeWorldInfoIdsProvider
    // NOTE: World infos with characterId == null but isGlobal == false are NOT included
    // The user must explicitly enable isGlobal to make a world info available to all characters
    final enabledWorldInfoIds = allWorldInfos
        .where(
          (w) =>
              w.enabled &&
              (w.isGlobal ||
                  w.characterId == character.id ||
                  chatLinkedIds.contains(w.id) ||
                  w.id == personaLorebookId ||
                  activeIds.contains(w.id)),
        )
        .map((w) => w.id)
        .toList();

    // Combine with manually activated IDs
    final allWorldInfoIds = <String>{
      ...enabledWorldInfoIds,
      ...activeIds,
    }.toList();

    // Debug logging - Enhanced for troubleshooting
    debugPrint(
      '\n╔══════════════════════════════════════════════════════════════',
    );
    debugPrint('║ 🌍 WORLD INFO DEBUG - Finding matching entries');
    debugPrint(
      '╠══════════════════════════════════════════════════════════════',
    );
    debugPrint('║ Current character: ${character.name} (ID: ${character.id})');
    debugPrint('║ Active IDs from provider: $activeIds');
    debugPrint('║ Total world infos in database: ${allWorldInfos.length}');
    debugPrint(
      '╠──────────────────────────────────────────────────────────────',
    );

    for (final wi in allWorldInfos) {
      final included = allWorldInfoIds.contains(wi.id);
      final isGlobalMatch = wi.isGlobal;
      final isCharacterMatch = wi.characterId == character.id;
      final isManuallyActive = activeIds.contains(wi.id);

      final status = included ? '✅ INCLUDED' : '❌ EXCLUDED';
      final reasons = <String>[];
      if (!wi.enabled) reasons.add('disabled');
      if (isGlobalMatch) reasons.add('global (isGlobal=true)');
      if (isCharacterMatch) reasons.add('linked to this character');
      if (isManuallyActive) reasons.add('manually activated');

      debugPrint('║');
      debugPrint('║ $status ${wi.name}');
      debugPrint('║   • ID: ${wi.id}');
      debugPrint('║   • Entries: ${wi.entries.length}');
      debugPrint('║   • enabled: ${wi.enabled}');
      debugPrint('║   • isGlobal: ${wi.isGlobal}');
      debugPrint(
        '║   • characterId: ${wi.characterId ?? "null (not linked to any character)"}',
      );
      if (reasons.isNotEmpty) {
        debugPrint('║   • Reasons: ${reasons.join(", ")}');
      }
      if (!wi.enabled) {
        debugPrint('║   ⚠️ World Info is DISABLED - will not be used!');
      }
      if (!wi.isGlobal && wi.characterId == null && !isManuallyActive) {
        debugPrint(
          '║   ℹ️ Not global and not linked - enable isGlobal to use with all characters',
        );
      }
    }

    debugPrint(
      '╠──────────────────────────────────────────────────────────────',
    );
    debugPrint('║ Final world info IDs to search: $allWorldInfoIds');
    debugPrint(
      '╚══════════════════════════════════════════════════════════════\n',
    );

    if (allWorldInfoIds.isEmpty) {
      debugPrint('⚠️ No world info IDs to search - returning empty list');
      return [];
    }

    // Build context text from chat messages
    final contextBuffer = StringBuffer();
    contextBuffer.writeln(character.name);
    contextBuffer.writeln(character.description);
    contextBuffer.writeln(character.personality);
    contextBuffer.writeln(character.scenario);

    for (final msg in chatMessages) {
      contextBuffer.writeln(msg.content);
    }

    final contextText = contextBuffer.toString();
    debugPrint(
      '\n╔══════════════════════════════════════════════════════════════',
    );
    debugPrint('║ 🔍 WORLD INFO MATCHING');
    debugPrint(
      '╠══════════════════════════════════════════════════════════════',
    );
    debugPrint('║ Context text length: ${contextText.length} chars');
    debugPrint(
      '║ Context preview: ${contextText.substring(0, min(200, contextText.length))}...',
    );
    debugPrint(
      '╠──────────────────────────────────────────────────────────────',
    );

    // Find matching entries
    final matchedEntries = await _worldInfoMatcher.findMatchingEntries(
      contextText: contextText,
      worldInfoIds: allWorldInfoIds,
    );

    debugPrint('║');
    if (matchedEntries.isEmpty) {
      debugPrint('║ ⚠️ NO MATCHED ENTRIES!');
      debugPrint('║ Possible reasons:');
      debugPrint('║   • World Info is not enabled');
      debugPrint('║   • Entry is not enabled');
      debugPrint('║   • Entry is not constant and keys don\'t match context');
      debugPrint(
        '║   • World Info is not linked to this character and not global',
      );
    } else {
      debugPrint('║ ✅ MATCHED ${matchedEntries.length} ENTRIES:');
      for (final entry in matchedEntries) {
        final name = entry.comment.isNotEmpty
            ? entry.comment
            : (entry.keys.isEmpty
                ? '(constant, no keys)'
                : entry.keys.join(', '));
        final isConstant = entry.constant || entry.keys.isEmpty;
        debugPrint('║   • [${entry.position.name}] $name');
        debugPrint(
          '║     enabled=${entry.enabled}, constant=${entry.constant}, keys=${entry.keys}',
        );
        if (isConstant) {
          debugPrint('║     → Included as CONSTANT entry');
        }
        debugPrint(
          '║     Content: ${entry.content.substring(0, min(50, entry.content.length))}...',
        );
      }
    }
    debugPrint(
      '╚══════════════════════════════════════════════════════════════\n',
    );

    return matchedEntries;
  }

  /// Build a multimodal message with text and images
  Map<String, dynamic> _buildMultimodalMessage(ChatMessage msg) {
    // Build content array with text and images
    final contentParts = <Map<String, dynamic>>[];

    // Add text content if present
    if (msg.content.isNotEmpty) {
      contentParts.add({'type': 'text', 'text': msg.content});
    }

    // Add image attachments as base64
    for (final attachment in msg.attachments) {
      try {
        final file = File(attachment.path);
        if (file.existsSync()) {
          final bytes = file.readAsBytesSync();
          final base64Data = base64Encode(bytes);
          final mimeType = attachment.mimeType ?? 'image/jpeg';

          // Use OpenAI-compatible format (works with most providers)
          contentParts.add({
            'type': 'image_url',
            'image_url': {'url': 'data:$mimeType;base64,$base64Data'},
          });
        }
      } catch (e) {
        // Skip invalid attachments
        print('Error loading attachment: $e');
      }
    }

    return {'role': 'user', 'content': contentParts};
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
  }

  /// Check if summarization is needed and generate summary if threshold is reached
  Future<void> _checkAndSummarize(LLMConfig config) async {
    final chat = state.chat;
    if (chat == null) return;

    if (!config.autoSummarizeEnabled) {
      debugPrint('📝 Auto-summarization disabled');
      return;
    }

    // Check if we should summarize
    final shouldSummarize = await _summarizationService.shouldSummarize(
      messages: state.messages,
      existingSummaries: chat.summaries,
      config: config,
    );

    if (!shouldSummarize) {
      debugPrint('📝 No summarization needed');
      return;
    }

    debugPrint('🔄 Triggering auto-summarization...');

    try {
      // Get character and persona for summary context
      final character = state.character;
      final persona = await _resolvePersona();

      // Determine which messages to summarize
      final messagesToSummarize = chat.summaries.isEmpty
          ? state.messages // First summary: summarize all messages
          : _summarizationService.getRecentMessages(
              allMessages: state.messages,
              latestSummary: chat.summaries.last,
            ); // Subsequent summaries: only new messages

      if (messagesToSummarize.isEmpty) {
        debugPrint('📝 No messages to summarize');
        return;
      }

      debugPrint('📝 Summarizing ${messagesToSummarize.length} messages...');

      // Generate summary
      final summary = await _summarizationService.generateSummary(
        messages: messagesToSummarize,
        existingSummaries: chat.summaries,
        config: config,
        characterName: character?.name,
        userName: persona?.name.isNotEmpty == true ? persona!.name : 'User',
      );

      // Add summary to chat
      final updatedSummaries = [...chat.summaries, summary];
      final updatedChat = chat.copyWith(summaries: updatedSummaries);
      await _chatRepository.updateChat(updatedChat);

      // Update state
      state = state.copyWith(chat: updatedChat);

      debugPrint(
        '✅ Summary created successfully (${updatedSummaries.length} total summaries)',
      );
      debugPrint(
        '📌 Summary preview: ${summary.content.substring(0, min(100, summary.content.length))}...',
      );
    } catch (e) {
      debugPrint('❌ Failed to create summary: $e');
      // Don't fail the entire message sending if summarization fails
    }
  }

  /// Clear all messages while keeping the current chat open.
  Future<void> clearMessages() async {
    final chat = state.chat;
    if (chat == null || state.isGenerating) return;

    await _chatRepository.clearMessages(chat.id);
    final updatedChat = await _chatRepository.updateChat(
      chat.copyWith(summaries: const []),
    );
    state = state.copyWith(chat: updatedChat, messages: const []);
    _ref.invalidate(allChatsProvider);
  }

  /// Import messages into the current chat and refresh local state.
  Future<int> importMessages(
    List<ChatMessage> messages, {
    bool replaceExisting = false,
  }) async {
    if (state.chat == null || messages.isEmpty) return 0;

    final chatId = state.chat!.id;
    if (replaceExisting) {
      await _chatRepository.clearMessages(chatId);
    }

    final sortedMessages = [...messages]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final message in sortedMessages) {
      await _chatRepository.addMessage(message.copyWith(chatId: chatId));
    }

    final updatedChat = await _chatRepository.getChat(chatId);
    final updatedMessages = await _chatRepository.getMessages(chatId);

    state = state.copyWith(
      chat: updatedChat ?? state.chat,
      messages: updatedMessages,
    );

    return sortedMessages.length;
  }

  /// Create a new chat session from an imported chat result.
  Future<Chat> createChatFromImport({
    required String characterId,
    String? personaId,
    required ChatImportResult importResult,
    String? customTitle,
  }) async {
    final title = (customTitle != null && customTitle.isNotEmpty)
        ? customTitle
        : (importResult.characterName.isNotEmpty
            ? importResult.characterName
            : 'Imported Chat');

    final settings = <String, dynamic>{};
    if (importResult.model != null && importResult.model!.isNotEmpty) {
      settings['model'] = importResult.model;
    }
    if (importResult.userName.isNotEmpty) {
      settings['userName'] = importResult.userName;
    }
    if (personaId != null && personaId.isNotEmpty) {
      settings['personaId'] = personaId;
    }

    final uuid = const Uuid();
    final newChat = await _chatRepository.createChat(
      Chat(
        id: uuid.v4(),
        characterId: characterId,
        title: title,
        authorNote: importResult.authorNote ?? '',
        authorNoteDepth: importResult.authorNoteDepth ?? 4,
        authorNoteEnabled: importResult.authorNoteEnabled ??
            (importResult.authorNote != null &&
                importResult.authorNote!.isNotEmpty),
        settings: settings,
        createdAt: importResult.createDate,
        updatedAt: DateTime.now(),
      ),
    );

    final sortedMessages = [...importResult.messages]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (final msg in sortedMessages) {
      await _chatRepository.addMessage(
        msg.toChatMessage(newChat.id, uuid.v4()),
      );
    }

    _ref.invalidate(allChatsProvider);
    _ref.invalidate(pagedChatsProvider);
    _ref.invalidate(characterChatsProvider(characterId));
    return newChat;
  }

  // ============================================
  // AUTHOR'S NOTE METHODS
  // ============================================

  Future<bool> _updateChatById(
    String chatId,
    Chat Function(Chat chat) update,
  ) async {
    final chat = await _chatRepository.getChat(chatId);
    if (chat == null) return false;

    final updatedChat = await _chatRepository.updateChat(update(chat));
    if (state.chat?.id == chatId) {
      state = state.copyWith(chat: updatedChat);
    }
    return true;
  }

  /// Update Author's Note content for a specific chat.
  Future<bool> updateAuthorNote(String chatId, String content) {
    return _updateChatById(
      chatId,
      (chat) => chat.copyWith(authorNote: content),
    );
  }

  /// Update the "Start Reply With" assistant prefill for this chat
  Future<void> updateStartReplyWith(String text) async {
    if (state.chat == null) return;

    final updatedChat = state.chat!.withSetting(
      'startReplyWith',
      text.isEmpty ? null : text,
    );
    await _chatRepository.updateChat(updatedChat);
    state = state.copyWith(chat: updatedChat);
  }

  /// Opt this chat into visible moments knowledge. Off by default.
  Future<void> updateMomentsInChat(bool enabled) async {
    if (state.chat == null) return;

    final updatedChat = state.chat!.withSetting(
      'momentsInChat',
      enabled ? true : null,
    );
    await _chatRepository.updateChat(updatedChat);
    state = state.copyWith(chat: updatedChat);
  }

  /// Update the world info books linked to this chat
  Future<void> updateLinkedWorldBooks(List<String> worldInfoIds) async {
    if (state.chat == null) return;

    final updatedChat = state.chat!.withSetting(
      'linkedWorldInfoIds',
      worldInfoIds.isEmpty ? null : worldInfoIds,
    );
    await _chatRepository.updateChat(updatedChat);
    state = state.copyWith(chat: updatedChat);
  }

  /// Update Author's Note depth
  Future<bool> updateAuthorNoteDepth(String chatId, int depth) {
    return _updateChatById(
      chatId,
      (chat) => chat.copyWith(authorNoteDepth: depth),
    );
  }

  /// Toggle Author's Note enabled state
  Future<bool> toggleAuthorNote(String chatId, bool enabled) {
    return _updateChatById(
      chatId,
      (chat) => chat.copyWith(authorNoteEnabled: enabled),
    );
  }

  /// Update all Author's Note settings at once
  Future<bool> updateAuthorNoteSettings({
    required String chatId,
    String? content,
    int? depth,
    bool? enabled,
  }) {
    return _updateChatById(
      chatId,
      (chat) => chat.copyWith(
        authorNote: content ?? chat.authorNote,
        authorNoteDepth: depth ?? chat.authorNoteDepth,
        authorNoteEnabled: enabled ?? chat.authorNoteEnabled,
      ),
    );
  }

  // ============================================
  // BOOKMARK / BRANCHING METHODS
  // ============================================

  /// Get the message index for a given message ID
  int getMessageIndex(String messageId) {
    return state.messages.indexWhere((m) => m.id == messageId);
  }

  /// Get message ID at a specific index
  String? getMessageIdAt(int index) {
    if (index < 0 || index >= state.messages.length) return null;
    return state.messages[index].id;
  }

  /// Branch from a bookmark - delete messages after bookmark point and continue from there
  Future<void> branchFromBookmark(Bookmark bookmark) async {
    if (state.chat == null) return;

    // Find the message index for this bookmark
    final messageIndex = state.messages.indexWhere(
      (m) => m.id == bookmark.messageId,
    );
    if (messageIndex < 0) {
      // Message not found - might be in a different branch
      // Try to restore messages up to the bookmark's message index
      state = state.copyWith(
        error: 'Bookmark message not found in current chat',
      );
      return;
    }

    // Delete all messages after the bookmark point
    if (messageIndex < state.messages.length - 1) {
      final messagesToDelete = state.messages.sublist(messageIndex + 1);
      for (final msg in messagesToDelete) {
        await _chatRepository.deleteMessage(msg.id);
      }

      state = state.copyWith(
        messages: state.messages.sublist(0, messageIndex + 1),
      );
    }
  }

  /// Get preview of messages up to a bookmark point
  List<ChatMessage> getMessagesUpTo(String messageId) {
    final index = state.messages.indexWhere((m) => m.id == messageId);
    if (index < 0) return [];
    return state.messages.sublist(0, index + 1);
  }

  /// Check if a bookmark's message still exists in current chat
  bool isBookmarkValid(Bookmark bookmark) {
    return state.messages.any((m) => m.id == bookmark.messageId);
  }

  // ============================================
  // GROUP CHAT METHODS
  // ============================================

  /// Send a message in group chat and get responses from characters
  Future<void> sendGroupMessage(
    String content,
    LLMConfig config, {
    List<ChatAttachment> attachments = const [],
  }) async {
    if (state.chat == null || state.group == null) return;
    await _ensureAllMessagesLoaded();
    final turnStart = state.messages.length;

    // Add user message
    final userMessage = ChatMessage(
      id: _generateId(),
      chatId: state.chat!.id,
      role: MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
      swipes: [content],
      currentSwipeIndex: 0,
      attachments: attachments,
    );

    await _chatRepository.addMessage(userMessage);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      error: null,
    );

    // Determine which characters should respond based on response mode
    final responders = _selectResponders(content);

    if (state.group!.settings.effectiveResponseMode == GroupResponseMode.all &&
        responders.length > 1) {
      await _generateGroupResponsesTogether(responders, config);
    } else {
      for (final characterId in responders) {
        await _generateGroupCharacterResponse(characterId, config);
      }
    }
    final turnMessages = state.messages.skip(turnStart).toList(growable: false);
    if (turnMessages.any((message) => message.role == MessageRole.assistant)) {
      unawaited(
        _writeStoryAfterTurn(
          chatId: state.chat!.id,
          turnMessages: turnMessages,
          config: config,
        ),
      );
    }
    await _restoreRecentMessagesPage();
  }

  Future<void> _writeStoryAfterTurn({
    required String chatId,
    required List<ChatMessage> turnMessages,
    required LLMConfig config,
  }) async {
    if (!mounted) return;
    final settings = _ref.read(appSettingsProvider);
    if (settings.storyEnabled) {
      try {
        final story = _ref.read(storyServiceProvider);
        await story.extractAndWriteSilently(
          scope: await resolveStoryMemoryScope(_ref, chatId),
          chatId: chatId,
          messages: turnMessages,
          config: config,
        );
        if (!mounted) return;
        final operations = _ref.read(operationLogRepositoryProvider);
        OperationLog? chapterJob;
        if (await story.isChapterWindowDue(chatId)) {
          chapterJob = await operations.begin(
            kind: OperationKind.storyChapter,
            subjectId: chatId,
          );
        }
        if (!mounted) return;
        final chapter = await story.maybeCloseAfterTurn(
          chatId: chatId,
          config: config,
        );
        if (chapter.chapter != null) {
          if (chapterJob != null) {
            await operations.markCompleted(chapterJob);
          }
          if (mounted) {
            _ref.read(storyRevisionProvider.notifier).state++;
          }
        } else if (chapter.skipped && chapter.failure == null) {
          if (chapterJob != null) {
            await operations.markCompleted(chapterJob);
          }
        } else if (chapterJob != null) {
          await operations.markIncomplete(
            chapterJob,
            error: chapter.failure?.message ?? 'Chapter write failed.',
          );
        }
      } catch (error, stackTrace) {
        debugPrint('Story write failed: $error\n$stackTrace');
      }
      return;
    }
    if (settings.memoryAutoExtractionEnabled) {
      await _ref.read(memoryInboxProvider.notifier).extractChat(
            chatId,
            automatic: true,
            turnMessages: turnMessages,
            config: config,
          );
    }
  }

  /// Select which characters should respond based on group settings
  List<String> _selectResponders(String userMessage) {
    final group = state.group;
    if (group == null) return [];

    final activeMemberIds = group.members
        .where((m) => !m.isMuted)
        .map((m) => m.characterId)
        .toList();

    if (activeMemberIds.isEmpty) return [];

    final responseMode = group.settings.effectiveResponseMode;

    switch (responseMode) {
      case GroupResponseMode.sequential:
        // Return the next character in sequence
        final lastAssistantMsg = state.messages.reversed.firstWhere(
          (m) => m.role == MessageRole.assistant && m.characterId != null,
          orElse: () => state.messages.first,
        );

        if (lastAssistantMsg.characterId != null) {
          final lastIndex = activeMemberIds.indexOf(
            lastAssistantMsg.characterId!,
          );
          final nextIndex = (lastIndex + 1) % activeMemberIds.length;
          return [activeMemberIds[nextIndex]];
        }
        return [activeMemberIds.first];

      case GroupResponseMode.random:
        // Pick a random character
        final random = Random();
        return [activeMemberIds[random.nextInt(activeMemberIds.length)]];

      case GroupResponseMode.all:
        // All non-muted characters respond
        return activeMemberIds;

      case GroupResponseMode.manual:
        // User selects - return currently selected character if any
        final selectedId = _ref.read(selectedGroupCharacterIdProvider);
        if (selectedId != null && activeMemberIds.contains(selectedId)) {
          return [selectedId];
        }
        return [];

      case GroupResponseMode.natural:
        // AI decides based on context, trigger words, and talkativeness
        return _selectNaturalResponders(userMessage, activeMemberIds);
    }
  }

  /// Select responders using natural/AI-based selection
  List<String> _selectNaturalResponders(
    String userMessage,
    List<String> activeMemberIds,
  ) {
    final group = state.group;
    if (group == null) return [];

    final selectedResponders = <String>[];
    final random = Random();
    final lowerMessage = userMessage.toLowerCase();

    for (final member in group.members.where((m) => !m.isMuted)) {
      // Check trigger words
      bool triggered = false;
      for (final trigger in member.triggerWords) {
        if (lowerMessage.contains(trigger.toLowerCase())) {
          triggered = true;
          break;
        }
      }

      // Check character name mention
      final character = state.groupCharacters[member.characterId];
      if (character != null &&
          lowerMessage.contains(character.name.toLowerCase())) {
        triggered = true;
      }

      // If triggered, definitely respond
      if (triggered) {
        selectedResponders.add(member.characterId);
      } else {
        // Otherwise, use talkativeness probability
        if (random.nextInt(100) < member.talkativeness) {
          selectedResponders.add(member.characterId);
        }
      }
    }

    // Ensure at least one character responds
    if (selectedResponders.isEmpty && activeMemberIds.isNotEmpty) {
      // Pick the most talkative one
      final mostTalkative = group.members
          .where((m) => !m.isMuted && activeMemberIds.contains(m.characterId))
          .reduce((a, b) => a.talkativeness > b.talkativeness ? a : b);
      selectedResponders.add(mostTalkative.characterId);
    }

    return selectedResponders;
  }

  /// Generate a response from a specific character in a group chat
  Future<void> _generateGroupCharacterResponse(
    String characterId,
    LLMConfig config,
  ) async {
    state = state.copyWith(
      isGenerating: true,
      currentResponderId: characterId,
      error: null,
    );
    try {
      final prepared = await _prepareGroupResponse(characterId, config);
      if (prepared == null) return;
      state = state.copyWith(
        messages: [...state.messages, prepared.message],
        isGenerating: true,
        generatingMessageIds: {prepared.message.id},
        currentResponderId: characterId,
        error: null,
      );
      await _runPreparedGroupResponse(prepared, config);
    } catch (error, stackTrace) {
      debugPrint(
        '❌ ChatProvider group response preparation error: '
        '$error\n$stackTrace',
      );
      state = state.copyWith(error: error.toString());
    } finally {
      state = state.copyWith(
        isGenerating: false,
        generatingMessageIds: const {},
        clearCurrentResponder: true,
        error: state.error,
      );
    }
  }

  Future<void> _generateGroupResponsesTogether(
    List<String> characterIds,
    LLMConfig config,
  ) async {
    final preparedResponses = <_PreparedGroupResponse>[];
    state = state.copyWith(
      isGenerating: true,
      clearCurrentResponder: true,
      error: null,
    );
    try {
      for (final characterId in characterIds) {
        final prepared = await _prepareGroupResponse(characterId, config);
        if (prepared != null) preparedResponses.add(prepared);
      }
    } catch (error, stackTrace) {
      for (final prepared in preparedResponses) {
        prepared.session.close();
      }
      debugPrint(
        '❌ ChatProvider group response preparation error: '
        '$error\n$stackTrace',
      );
      state = state.copyWith(
        isGenerating: false,
        error: error.toString(),
      );
      return;
    }
    if (preparedResponses.isEmpty) {
      state = state.copyWith(isGenerating: false);
      return;
    }

    final messageIds =
        preparedResponses.map((prepared) => prepared.message.id).toSet();
    state = state.copyWith(
      messages: [
        ...state.messages,
        ...preparedResponses.map((prepared) => prepared.message),
      ],
      isGenerating: true,
      generatingMessageIds: messageIds,
      clearCurrentResponder: true,
      error: null,
    );

    try {
      await Future.wait(
        preparedResponses.map(
          (prepared) => _runPreparedGroupResponse(prepared, config),
        ),
      );
    } finally {
      state = state.copyWith(
        isGenerating: false,
        generatingMessageIds: const {},
        clearCurrentResponder: true,
        error: state.error,
      );
    }
  }

  Future<_PreparedGroupResponse?> _prepareGroupResponse(
    String characterId,
    LLMConfig config,
  ) async {
    final character = state.groupCharacters[characterId];
    final chat = state.chat;
    if (character == null || chat == null) return null;

    _pendingDataBankContext = null;
    final session = _generationPipeline.startSession(
      chatId: chat.id,
      characterId: characterId,
      groupId: state.group?.id ?? chat.groupId,
      mode: ChatGenerationMode.groupResponse,
      config: config,
      metadata: {
        'isGroupChat': true,
        'messageCount': state.messages.length,
      },
    );

    try {
      final context = await _buildGroupContext(
        character,
        generationSession: session,
      );
      final message = ChatMessage(
        id: _generateId(),
        chatId: chat.id,
        role: MessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        swipes: [''],
        currentSwipeIndex: 0,
        characterId: character.id,
        characterName: character.name,
        metadata: _newAssistantMetadata(),
      );
      return _PreparedGroupResponse(
        context: context,
        session: session,
        message: message,
      );
    } catch (_) {
      session.close();
      rethrow;
    }
  }

  Future<void> _runPreparedGroupResponse(
    _PreparedGroupResponse prepared,
    LLMConfig config,
  ) async {
    final assistantMessage = prepared.message;
    try {
      String finalContent;
      String? finalReasoning;

      if (config.streamEnabled) {
        final contentBuffer = StringBuffer();
        final reasoningBuffer = StringBuffer();
        await for (final chunk in _generateStreamWithPrefill(
          prepared.context,
          config,
          generationSession: prepared.session,
        )) {
          if (_isCancelling) break;
          if (chunk.isReasoningChunk && chunk.reasoning != null) {
            reasoningBuffer.write(chunk.reasoning);
          }
          if (chunk.content != null) contentBuffer.write(chunk.content);
          _replaceMessage(
            assistantMessage.id,
            assistantMessage.copyWith(
              content: contentBuffer.toString(),
              swipes: [contentBuffer.toString()],
              reasoning: reasoningBuffer.isNotEmpty
                  ? reasoningBuffer.toString()
                  : null,
              reasoningSwipes: reasoningBuffer.isNotEmpty
                  ? [reasoningBuffer.toString()]
                  : null,
            ),
          );
        }
        finalContent = contentBuffer.toString();
        finalReasoning =
            reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null;
      } else {
        final response = await _generateWithPrefill(
          prepared.context,
          config,
          generationSession: prepared.session,
        );
        finalContent = response.content;
        finalReasoning = response.reasoning;
      }

      final finalMessage = assistantMessage.copyWith(
        content: finalContent,
        swipes: [finalContent],
        reasoning: finalReasoning,
        reasoningSwipes: finalReasoning != null ? [finalReasoning] : null,
      );
      _replaceMessage(assistantMessage.id, finalMessage);
      await _chatRepository.addMessage(finalMessage);
    } on ChatGenerationCancelledException {
      _removeEmptyMessage(assistantMessage.id);
    } catch (error, stackTrace) {
      debugPrint(
        '❌ ChatProvider group response error: $error\n$stackTrace',
      );
      _removeEmptyMessage(assistantMessage.id);
      state = state.copyWith(error: error.toString());
    } finally {
      prepared.session.close();
      final generatingIds = Set<String>.from(state.generatingMessageIds)
        ..remove(assistantMessage.id);
      state = state.copyWith(
        generatingMessageIds: generatingIds,
        error: state.error,
      );
    }
  }

  void _replaceMessage(String messageId, ChatMessage replacement) {
    final index =
        state.messages.indexWhere((message) => message.id == messageId);
    if (index < 0) return;
    final messages = List<ChatMessage>.from(state.messages);
    messages[index] = replacement;
    state = state.copyWith(messages: messages);
  }

  void _removeEmptyMessage(String messageId) {
    final message = state.messages
        .where((candidate) => candidate.id == messageId)
        .firstOrNull;
    if (message == null || message.content.isNotEmpty) return;
    state = state.copyWith(
      messages: state.messages
          .where((candidate) => candidate.id != messageId)
          .toList(growable: false),
    );
  }

  /// Build context for group chat
  Future<List<Map<String, dynamic>>> _buildGroupContext(
    Character respondingCharacter, {
    ChatGenerationSession? generationSession,
  }) async {
    final messages = <Map<String, dynamic>>[];
    final group = state.group;
    if (group == null) return messages;

    // Build system prompt for group chat
    final systemPrompt = await _buildGroupSystemPrompt(respondingCharacter);
    messages.add({'role': 'system', 'content': systemPrompt});
    final conversationStartIndex = messages.length;

    // Add chat messages
    for (final msg in state.messages) {
      if (msg.role == MessageRole.user) {
        messages.add({'role': 'user', 'content': msg.content});
      } else if (msg.role == MessageRole.assistant) {
        // For group chats, include character name in the message
        final charName = msg.characterName ?? 'Unknown';
        messages.add({
          'role': 'assistant',
          'content': '[$charName]: ${msg.content}',
        });
      }
    }

    return _applyContextContributors(
      messages,
      conversationStartIndex: conversationStartIndex,
      generationSession: generationSession,
    );
  }

  /// Build system prompt for group chat
  Future<String> _buildGroupSystemPrompt(Character respondingCharacter) async {
    final buffer = StringBuffer();
    final group = state.group;
    if (group == null) return '';

    // Get active persona
    final persona = await _resolvePersona();

    // Get LLM config for macro context
    final llmConfig = _ref.read(llmConfigProvider);

    // Create macro context for processing
    final macroContext = MacroContext.fromData(
      character: respondingCharacter,
      persona: persona,
      chat: state.chat,
      messages: state.messages,
      modelName: llmConfig.model,
      providerName: llmConfig.provider.name,
      groupCharacters: state.groupCharacters.values.toList(),
    );
    final macroService = MacroService(macroContext);

    // Helper to process macros in text
    String processMacros(String text) => macroService.process(text);

    buffer.writeln('This is a group roleplay conversation.');
    buffer.writeln('You are roleplaying as ${respondingCharacter.name}.');
    buffer.writeln();

    // Add persona information
    if (persona != null && persona.name.isNotEmpty) {
      buffer.writeln('The user is ${persona.name}.');
      if (persona.description.isNotEmpty) {
        buffer.writeln(
          'User description: ${processMacros(persona.description)}',
        );
      }
      buffer.writeln();
    }

    // Describe the responding character
    buffer.writeln('=== YOUR CHARACTER: ${respondingCharacter.name} ===');
    if (respondingCharacter.description.isNotEmpty) {
      buffer.writeln(
        'Description: ${processMacros(respondingCharacter.description)}',
      );
    }
    if (respondingCharacter.personality.isNotEmpty) {
      buffer.writeln(
        'Personality: ${processMacros(respondingCharacter.personality)}',
      );
    }
    buffer.writeln();

    // Describe other characters in the group
    buffer.writeln('=== OTHER CHARACTERS IN THIS CONVERSATION ===');
    for (final entry in state.groupCharacters.entries) {
      if (entry.key != respondingCharacter.id) {
        final char = entry.value;
        buffer.writeln(
          '${char.name}: ${char.description.isNotEmpty ? processMacros(char.description) : "No description"}',
        );
      }
    }
    buffer.writeln();

    // Add scenario if the responding character has one
    if (respondingCharacter.scenario.isNotEmpty) {
      buffer.writeln(
        'Scenario: ${processMacros(respondingCharacter.scenario)}',
      );
      buffer.writeln();
    }

    // Add system prompt if the responding character has one
    if (respondingCharacter.systemPrompt.isNotEmpty) {
      buffer.writeln(processMacros(respondingCharacter.systemPrompt));
    }

    buffer.writeln();
    buffer.writeln(
      'IMPORTANT: Stay in character as ${respondingCharacter.name}. ',
    );
    buffer.writeln(
      'Do not speak for other characters. Only respond as ${respondingCharacter.name}.',
    );
    buffer.writeln(
      'Do not include your name prefix in your response - just write your dialogue/actions directly.',
    );

    return buffer.toString();
  }

  Future<void> updateLive2DStageTransform({
    required double scale,
    required double offsetX,
    required double offsetY,
  }) async {
    final character = state.character;
    final assets = character?.assets;
    final live2d = assets?.live2d;
    if (character == null || assets == null || live2d == null) return;

    final updatedCharacter = character.copyWith(
      assets: assets.copyWith(
        live2d: live2d.copyWith(
          scale: scale,
          offsetX: offsetX,
          offsetY: offsetY,
        ),
      ),
      modifiedAt: DateTime.now(),
    );
    state = state.copyWith(character: updatedCharacter);
    await _characterRepository.updateCharacter(updatedCharacter);
  }

  /// Manually trigger a specific character to respond (for manual mode)
  Future<void> triggerCharacterResponse(
    String characterId,
    LLMConfig config,
  ) async {
    if (!state.isGroupChat) return;
    await _generateGroupCharacterResponse(characterId, config);
  }
}

/// Provider for active chat
final activeChatProvider =
    StateNotifierProvider<ActiveChatNotifier, ActiveChatState>((ref) {
  ref.watch(dataBankContextRegistrationProvider);
  ref.watch(storyExtensionsProvider);
  final chatRepo = ref.watch(chatRepositoryProvider);
  final characterRepo = ref.watch(characterRepositoryProvider);
  final groupRepo = ref.watch(groupRepositoryProvider);
  final personaRepo = ref.watch(personaRepositoryProvider);
  final llmService = ref.watch(llmServiceProvider);
  final worldInfoMatcher = ref.watch(worldInfoMatcherProvider);
  final summarizationService = ref.watch(chatSummarizationServiceProvider);
  final generationPipeline = ref.watch(chatGenerationPipelineProvider);

  return ActiveChatNotifier(
    chatRepository: chatRepo,
    characterRepository: characterRepo,
    groupRepository: groupRepo,
    personaRepository: personaRepo,
    llmService: llmService,
    worldInfoMatcher: worldInfoMatcher,
    summarizationService: summarizationService,
    generationPipeline: generationPipeline,
    ref: ref,
  );
});

/// Chat list for a character
final characterChatsProvider = FutureProvider.family<List<Chat>, String>((
  ref,
  characterId,
) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChatsForCharacter(characterId);
});

/// All chats list
final allChatsProvider = FutureProvider<List<Chat>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getAllChats();
});

final pagedChatsProvider =
    AsyncNotifierProvider.autoDispose<PagedChatsNotifier, List<Chat>>(
  PagedChatsNotifier.new,
);

class PagedChatsNotifier extends AutoDisposeAsyncNotifier<List<Chat>> {
  static const _pageSize = 40;
  int _offset = 0;
  bool _hasMore = true;
  bool _loadingMore = false;

  @override
  Future<List<Chat>> build() async {
    _offset = 0;
    _hasMore = true;
    final page = await ref.read(chatRepositoryProvider).getChatsPage(
          limit: _pageSize,
          offset: 0,
        );
    _offset = page.length;
    _hasMore = page.length == _pageSize;
    return page;
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore || !state.hasValue) return;
    _loadingMore = true;
    try {
      final page = await ref.read(chatRepositoryProvider).getChatsPage(
            limit: _pageSize,
            offset: _offset,
          );
      final current = state.valueOrNull ?? const <Chat>[];
      state = AsyncData([...current, ...page]);
      _offset += page.length;
      _hasMore = page.length == _pageSize;
    } catch (error, stack) {
      state = AsyncError(error, stack);
    } finally {
      _loadingMore = false;
    }
  }
}

/// Recent chats
final recentChatsProvider = FutureProvider<List<Chat>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getRecentChats(limit: 10);
});
