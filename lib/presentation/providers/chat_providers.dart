import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/bookmark.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/group.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/data/models/prompt_manager.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/persona_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/macro_service.dart';
import 'package:native_tavern/presentation/providers/group_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/prompt_manager_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
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
  final Map<String, Character> groupCharacters; // Character cache for group chats
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isGenerating;
  final String? error;
  final String? currentResponderId; // Which character is currently responding (group chat)

  const ActiveChatState({
    this.chat,
    this.character,
    this.group,
    this.groupCharacters = const {},
    this.messages = const [],
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
    this.currentResponderId,
  });

  /// Check if this is a group chat
  bool get isGroupChat => group != null;

  ActiveChatState copyWith({
    Chat? chat,
    Character? character,
    Group? group,
    bool clearGroup = false,
    Map<String, Character>? groupCharacters,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isGenerating,
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
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
      currentResponderId: clearCurrentResponder ? null : (currentResponderId ?? this.currentResponderId),
    );
  }
}

/// Active chat notifier
class ActiveChatNotifier extends StateNotifier<ActiveChatState> {
  final ChatRepository _chatRepository;
  final CharacterRepository _characterRepository;
  final PersonaRepository _personaRepository;
  final LLMService _llmService;
  final WorldInfoMatcher _worldInfoMatcher;
  final Ref _ref;

  ActiveChatNotifier({
    required ChatRepository chatRepository,
    required CharacterRepository characterRepository,
    required PersonaRepository personaRepository,
    required LLMService llmService,
    required WorldInfoMatcher worldInfoMatcher,
    required Ref ref,
  })  : _chatRepository = chatRepository,
        _characterRepository = characterRepository,
        _personaRepository = personaRepository,
        _llmService = llmService,
        _worldInfoMatcher = worldInfoMatcher,
        _ref = ref,
        super(const ActiveChatState());

  /// Load a chat by ID
  Future<void> loadChat(String chatId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final chat = await _chatRepository.getChat(chatId);
      if (chat == null) {
        state = state.copyWith(isLoading: false, error: 'Chat not found');
        return;
      }

      final character = await _characterRepository.getCharacter(chat.characterId);
      final messages = await _chatRepository.getMessages(chatId);

      // Check if this is a group chat
      if (chat.isGroupChat) {
        final groupsAsync = _ref.read(groupListProvider);
        final groups = groupsAsync.valueOrNull ?? [];
        final group = groups.firstWhere(
          (g) => g.id == chat.groupId,
          orElse: () => throw Exception('Group not found'),
        );
        
        // Load all group member characters
        final groupChars = <String, Character>{};
        for (final member in group.members) {
          final char = await _characterRepository.getCharacter(member.characterId);
          if (char != null) {
            groupChars[char.id] = char;
          }
        }
        
        state = state.copyWith(
          chat: chat,
          character: character,
          group: group,
          groupCharacters: groupChars,
          messages: messages,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          chat: chat,
          character: character,
          clearGroup: true,
          groupCharacters: const {},
          messages: messages,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create a new chat with a character
  Future<String?> createChat(String characterId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final character = await _characterRepository.getCharacter(characterId);
      if (character == null) {
        state = state.copyWith(isLoading: false, error: 'Character not found');
        return null;
      }

      final chat = Chat(
        id: _generateId(),
        characterId: characterId,
        title: 'Chat with ${character.name}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _chatRepository.createChat(chat);

      // Add first message (greeting) if character has one
      if (character.firstMessage.isNotEmpty) {
        // Get active persona for macro processing
        final activePersonaId = _ref.read(activePersonaIdProvider);
        Persona? persona;
        if (activePersonaId != null) {
          persona = await _personaRepository.getPersona(activePersonaId);
        }
        persona ??= await _personaRepository.getDefaultPersona();
        
        // Process macros in the greeting
        final macroContext = MacroContext.fromData(
          character: character,
          persona: persona,
          chat: chat,
          messages: [],
        );
        final processedGreeting = MacroService(macroContext).process(character.firstMessage);
        
        final greeting = ChatMessage(
          id: _generateId(),
          chatId: chat.id,
          role: MessageRole.assistant,
          content: processedGreeting,
          timestamp: DateTime.now(),
          swipes: [processedGreeting],
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
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Create a new group chat
  Future<String?> createGroupChat(Group group) async {
    if (group.members.isEmpty) return null;
    
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load all member characters
      final groupChars = <String, Character>{};
      for (final member in group.members) {
        final char = await _characterRepository.getCharacter(member.characterId);
        if (char != null) {
          groupChars[char.id] = char;
        }
      }
      
      if (groupChars.isEmpty) {
        state = state.copyWith(isLoading: false, error: 'No valid characters in group');
        return null;
      }
      
      // Use first member as the "primary" character
      final firstCharId = group.members.first.characterId;
      final firstChar = groupChars[firstCharId]!;

      final chat = Chat(
        id: _generateId(),
        characterId: firstCharId,
        groupId: group.id,
        title: 'Chat with ${group.name}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _chatRepository.createChat(chat);

      // Get active persona for macro processing
      final activePersonaId = _ref.read(activePersonaIdProvider);
      Persona? persona;
      if (activePersonaId != null) {
        persona = await _personaRepository.getPersona(activePersonaId);
      }
      persona ??= await _personaRepository.getDefaultPersona();
      
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
          final processedGreeting = MacroService(macroContext).process(char.firstMessage);
          
          final greeting = ChatMessage(
            id: _generateId(),
            chatId: chat.id,
            role: MessageRole.assistant,
            content: processedGreeting,
            timestamp: DateTime.now(),
            swipes: [processedGreeting],
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
    } catch (e) {
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

    // Prepare context for LLM
    final context = await _buildContext();

    try {
      // Create placeholder for assistant message
      final assistantMessage = ChatMessage(
        id: _generateId(),
        chatId: state.chat!.id,
        role: MessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        swipes: [''],
        currentSwipeIndex: 0,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
      );

      // Stream the response with reasoning support
      final contentBuffer = StringBuffer();
      final reasoningBuffer = StringBuffer();
      await for (final chunk in _llmService.generateStreamWithReasoning(context, config)) {
        if (chunk.isReasoningChunk && chunk.reasoning != null) {
          reasoningBuffer.write(chunk.reasoning);
        }
        if (chunk.content != null) {
          contentBuffer.write(chunk.content);
        }
        final updatedMessage = assistantMessage.copyWith(
          content: contentBuffer.toString(),
          swipes: [contentBuffer.toString()],
          reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
          reasoningSwipes: reasoningBuffer.isNotEmpty ? [reasoningBuffer.toString()] : null,
        );
        
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] = updatedMessage;
        state = state.copyWith(messages: updatedMessages);
      }

      // Save the final message
      final finalMessage = assistantMessage.copyWith(
        content: contentBuffer.toString(),
        swipes: [contentBuffer.toString()],
        reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
        reasoningSwipes: reasoningBuffer.isNotEmpty ? [reasoningBuffer.toString()] : null,
      );
      await _chatRepository.addMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: e.toString(),
      );
    }
  }

  /// Regenerate the last assistant message
  Future<void> regenerateLastMessage(LLMConfig config) async {
    if (state.messages.isEmpty) return;
    
    final lastMessage = state.messages.last;
    if (lastMessage.role != MessageRole.assistant) return;

    state = state.copyWith(isGenerating: true, error: null);

    try {
      final context = await _buildContext(excludeLastAssistant: true);
      
      final contentBuffer = StringBuffer();
      final reasoningBuffer = StringBuffer();
      await for (final chunk in _llmService.generateStreamWithReasoning(context, config)) {
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
        final newReasoningSwipes = List<String>.from(lastMessage.reasoningSwipes ?? []);
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
          reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
          reasoningSwipes: newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
        );
        
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] = updatedMessage;
        state = state.copyWith(messages: updatedMessages);
      }

      // Save the updated message
      final newSwipes = List<String>.from(lastMessage.swipes);
      newSwipes.add(contentBuffer.toString());
      
      // Handle reasoning swipes for final message
      final newReasoningSwipes = List<String>.from(lastMessage.reasoningSwipes ?? []);
      while (newReasoningSwipes.length < newSwipes.length - 1) {
        newReasoningSwipes.add('');
      }
      if (reasoningBuffer.isNotEmpty) {
        newReasoningSwipes.add(reasoningBuffer.toString());
      }
      
      final finalMessage = lastMessage.copyWith(
        content: contentBuffer.toString(),
        swipes: newSwipes,
        currentSwipeIndex: newSwipes.length - 1,
        reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
        reasoningSwipes: newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
      );
      await _chatRepository.updateMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
    } catch (e) {
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

  /// Delete a message and all messages after it
  Future<void> deleteMessageAndAfter(String messageId) async {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    // Delete all messages from this index onwards
    final messagesToDelete = state.messages.sublist(messageIndex);
    for (final msg in messagesToDelete) {
      await _chatRepository.deleteMessage(msg.id);
    }

    state = state.copyWith(
      messages: state.messages.sublist(0, messageIndex),
    );
  }

  /// Regenerate a specific assistant message (adds new swipe)
  Future<void> regenerateMessage(String messageId, LLMConfig config) async {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex < 0) return;

    final message = state.messages[messageIndex];
    if (message.role != MessageRole.assistant) return;

    state = state.copyWith(isGenerating: true, error: null);

    try {
      // Build context up to (but not including) this message
      final context = await _buildContextUpTo(messageIndex);
      
      final contentBuffer = StringBuffer();
      final reasoningBuffer = StringBuffer();
      await for (final chunk in _llmService.generateStreamWithReasoning(context, config)) {
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
        final newReasoningSwipes = List<String>.from(message.reasoningSwipes ?? []);
        while (newReasoningSwipes.length < newSwipes.length - 1) {
          newReasoningSwipes.add('');
        }
        if (reasoningBuffer.isNotEmpty) {
          if (newReasoningSwipes.length < newSwipes.length) {
            newReasoningSwipes.add(reasoningBuffer.toString());
          } else {
            newReasoningSwipes[newSwipes.length - 1] = reasoningBuffer.toString();
          }
        }
        
        final updatedMessage = message.copyWith(
          content: contentBuffer.toString(),
          swipes: newSwipes,
          currentSwipeIndex: newSwipes.length - 1,
          reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
          reasoningSwipes: newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
        );
        
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[messageIndex] = updatedMessage;
        state = state.copyWith(messages: updatedMessages);
      }

      // Save the updated message
      final newSwipes = List<String>.from(message.swipes);
      newSwipes.add(contentBuffer.toString());
      
      // Handle reasoning swipes for final message
      final newReasoningSwipes = List<String>.from(message.reasoningSwipes ?? []);
      while (newReasoningSwipes.length < newSwipes.length - 1) {
        newReasoningSwipes.add('');
      }
      if (reasoningBuffer.isNotEmpty) {
        newReasoningSwipes.add(reasoningBuffer.toString());
      }
      
      final finalMessage = message.copyWith(
        content: contentBuffer.toString(),
        swipes: newSwipes,
        currentSwipeIndex: newSwipes.length - 1,
        reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
        reasoningSwipes: newReasoningSwipes.isNotEmpty ? newReasoningSwipes : null,
      );
      await _chatRepository.updateMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(isGenerating: false, error: e.toString());
    }
  }

  /// Continue from a specific message (delete all after and regenerate)
  Future<void> continueFromMessage(String messageId, LLMConfig config) async {
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
      final lastAssistantMsg = state.messages.reversed
          .firstWhere(
            (m) => m.role == MessageRole.assistant && m.characterId != null,
            orElse: () => state.messages.first,
          );
      
      String nextCharId;
      if (lastAssistantMsg.characterId != null) {
        final lastIndex = activeMemberIds.indexOf(lastAssistantMsg.characterId!);
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

  /// Generate assistant response based on current context
  Future<void> _generateAssistantResponse(LLMConfig config) async {
    if (state.chat == null || state.character == null) return;

    state = state.copyWith(isGenerating: true, error: null);

    try {
      final context = await _buildContext();
      
      // Create placeholder for assistant message
      final assistantMessage = ChatMessage(
        id: _generateId(),
        chatId: state.chat!.id,
        role: MessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        swipes: [''],
        currentSwipeIndex: 0,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
      );

      // Stream the response with reasoning support
      final contentBuffer = StringBuffer();
      final reasoningBuffer = StringBuffer();
      await for (final chunk in _llmService.generateStreamWithReasoning(context, config)) {
        if (chunk.isReasoningChunk && chunk.reasoning != null) {
          reasoningBuffer.write(chunk.reasoning);
        }
        if (chunk.content != null) {
          contentBuffer.write(chunk.content);
        }
        final updatedMessage = assistantMessage.copyWith(
          content: contentBuffer.toString(),
          swipes: [contentBuffer.toString()],
          reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
          reasoningSwipes: reasoningBuffer.isNotEmpty ? [reasoningBuffer.toString()] : null,
        );
        
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] = updatedMessage;
        state = state.copyWith(messages: updatedMessages);
      }

      // Save the final message
      final finalMessage = assistantMessage.copyWith(
        content: contentBuffer.toString(),
        swipes: [contentBuffer.toString()],
        reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
        reasoningSwipes: reasoningBuffer.isNotEmpty ? [reasoningBuffer.toString()] : null,
      );
      await _chatRepository.addMessage(finalMessage);

      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: e.toString(),
      );
    }
  }

  /// Build context for LLM
  /// This method builds the full message list according to Prompt Manager configuration
  Future<List<Map<String, String>>> _buildContext({bool excludeLastAssistant = false}) async {
    final messages = <Map<String, String>>[];
    final character = state.character;
    final chat = state.chat;

    // Get chat messages
    var chatMessages = state.messages;
    if (excludeLastAssistant && chatMessages.isNotEmpty &&
        chatMessages.last.role == MessageRole.assistant) {
      chatMessages = chatMessages.sublist(0, chatMessages.length - 1);
    }

    // Find matching World Info entries
    List<WorldInfoEntry> worldInfoEntries = [];
    if (character != null) {
      worldInfoEntries = await _findMatchingWorldInfoEntries(character, chatMessages);
    }

    // Get Prompt Manager configuration
    final promptConfig = _ref.read(promptManagerProvider);
    final enabledSections = promptConfig.enabledSections;

    // Get active persona
    final activePersonaId = _ref.read(activePersonaIdProvider);
    Persona? persona;
    if (activePersonaId != null) {
      persona = await _personaRepository.getPersona(activePersonaId);
    }
    persona ??= await _personaRepository.getDefaultPersona();

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
            'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
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
        section, character, persona, worldInfoEntries, groupedEntries, processMacros, addWorldInfoAt,
      );
      messages.addAll(sectionMessages);
    }

    // Add chat messages with depth-based injections
    final depthEntries = worldInfoEntries
        .where((e) => e.position == WorldInfoPosition.atDepth)
        .toList();
    
    // Prepare Author's Note for depth-based injection
    final authorNoteEnabled = chat?.authorNoteEnabled ?? false;
    final authorNote = chat?.authorNote ?? '';
    final authorNoteDepth = chat?.authorNoteDepth ?? 4;
    
    for (var i = 0; i < chatMessages.length; i++) {
      final msg = chatMessages[i];
      
      // Depth is counted from the end (most recent = depth 0)
      final depthFromEnd = chatMessages.length - 1 - i;
      
      // Check if any depth-based world info entries should be inserted before this message
      for (final entry in depthEntries) {
        if (entry.depth == depthFromEnd) {
          messages.add({
            'role': 'system',
            'content': '[World Info: ${entry.comment.isNotEmpty ? entry.comment : "Context"}]\n${processMacros(entry.content)}',
          });
        }
      }
      
      // Check if any depth-based prompt sections should be inserted
      for (final section in depthBasedSections) {
        if (section.injectionDepth == depthFromEnd) {
          final sectionMessages = await _buildSectionMessages(
            section, character, persona, worldInfoEntries, groupedEntries, processMacros, addWorldInfoAt,
          );
          messages.addAll(sectionMessages);
        }
      }
      
      // Inject Author's Note at the configured depth
      if (authorNoteEnabled && authorNote.isNotEmpty && depthFromEnd == authorNoteDepth) {
        final processedNote = await _processAuthorNoteMacros(authorNote);
        messages.add({
          'role': 'system',
          'content': '[Author\'s Note]\n$processedNote',
        });
      }
      
      messages.add({
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.content,
      });
    }
    
    // If Author's Note depth is beyond message count, insert at the start of chat
    if (authorNoteEnabled && authorNote.isNotEmpty && authorNoteDepth >= chatMessages.length) {
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

    // Build post-chat messages
    for (final section in postChatSections) {
      final sectionMessages = await _buildSectionMessages(
        section, character, persona, worldInfoEntries, groupedEntries, processMacros, addWorldInfoAt,
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
      final preview = msg['content']!.length > 100
          ? '${msg['content']!.substring(0, 100)}...'
          : msg['content']!;
      print('[$i] ${msg['role']}: $preview');
    }
    print('=== End Context Messages ===');

    return messages;
  }

  /// Build messages for a single prompt section
  Future<List<Map<String, String>>> _buildSectionMessages(
    PromptSection section,
    Character? character,
    Persona? persona,
    List<WorldInfoEntry> worldInfoEntries,
    Map<WorldInfoPosition, List<WorldInfoEntry>> groupedEntries,
    String Function(String) processMacros,
    void Function(WorldInfoPosition, String) addWorldInfoAt,
  ) async {
    final messages = <Map<String, String>>[];
    final role = section.role ?? 'system';
    
    switch (section.type) {
      case PromptSectionType.systemPrompt:
        // Use custom content from section if available, otherwise use character's system prompt
        final content = section.content?.isNotEmpty == true
            ? section.content!
            : (character?.systemPrompt.isNotEmpty == true
                ? character!.systemPrompt
                : PromptSection.getDefaultContent(PromptSectionType.systemPrompt));
        if (content.isNotEmpty) {
          // Add world info before system prompt
          final beforeEntries = groupedEntries[WorldInfoPosition.beforeSystemPrompt];
          if (beforeEntries != null) {
            for (final entry in beforeEntries) {
              messages.add({
                'role': role,
                'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
          
          messages.add({'role': role, 'content': processMacros(content)});
          
          // Add world info after system prompt
          final afterEntries = groupedEntries[WorldInfoPosition.afterSystemPrompt];
          if (afterEntries != null) {
            for (final entry in afterEntries) {
              messages.add({
                'role': role,
                'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
        }
        break;
        
      case PromptSectionType.persona:
        if (persona != null && persona.name.isNotEmpty) {
          final buffer = StringBuffer();
          buffer.writeln('The user is ${persona.name}.');
          if (persona.description.isNotEmpty) {
            buffer.writeln('User description: ${processMacros(persona.description)}');
          }
          messages.add({'role': role, 'content': buffer.toString().trim()});
        }
        break;
        
      case PromptSectionType.characterDescription:
        if (character != null && character.description.isNotEmpty) {
          // Add world info before character definitions
          final beforeEntries = groupedEntries[WorldInfoPosition.beforeCharDefs];
          if (beforeEntries != null) {
            for (final entry in beforeEntries) {
              messages.add({
                'role': role,
                'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
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
          final afterEntries = groupedEntries[WorldInfoPosition.afterCharDefs];
          if (afterEntries != null) {
            for (final entry in afterEntries) {
              messages.add({
                'role': role,
                'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
        }
        break;
        
      case PromptSectionType.exampleMessages:
        if (character != null && character.exampleMessages.isNotEmpty) {
          // Add world info before examples
          final beforeEntries = groupedEntries[WorldInfoPosition.beforeExample];
          if (beforeEntries != null) {
            for (final entry in beforeEntries) {
              messages.add({
                'role': role,
                'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
          
          messages.add({
            'role': role,
            'content': 'Example dialogue:\n${processMacros(character.exampleMessages)}',
          });
          
          // Add world info after examples
          final afterEntries = groupedEntries[WorldInfoPosition.afterExample];
          if (afterEntries != null) {
            for (final entry in afterEntries) {
              messages.add({
                'role': role,
                'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
              });
            }
          }
        }
        break;
        
      case PromptSectionType.worldInfo:
        // World info entries that don't have a specific position
        final generalEntries = worldInfoEntries.where((e) =>
          e.position != WorldInfoPosition.atDepth &&
          e.position != WorldInfoPosition.beforeSystemPrompt &&
          e.position != WorldInfoPosition.afterSystemPrompt &&
          e.position != WorldInfoPosition.beforeCharDefs &&
          e.position != WorldInfoPosition.afterCharDefs &&
          e.position != WorldInfoPosition.beforeExample &&
          e.position != WorldInfoPosition.afterExample &&
          e.position != WorldInfoPosition.beforeAuthorNote &&
          e.position != WorldInfoPosition.afterAuthorNote
        ).toList();
        for (final entry in generalEntries) {
          messages.add({
            'role': role,
            'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
          });
        }
        break;
        
      case PromptSectionType.worldInfoAfter:
        final afterEntries = groupedEntries[WorldInfoPosition.afterCharDefs];
        if (afterEntries != null) {
          for (final entry in afterEntries) {
            messages.add({
              'role': role,
              'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
            });
          }
        }
        break;
        
      case PromptSectionType.authorNote:
        // Author's note is handled separately with depth injection
        final beforeEntries = groupedEntries[WorldInfoPosition.beforeAuthorNote];
        if (beforeEntries != null) {
          for (final entry in beforeEntries) {
            messages.add({
              'role': role,
              'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
            });
          }
        }
        final afterEntries = groupedEntries[WorldInfoPosition.afterAuthorNote];
        if (afterEntries != null) {
          for (final entry in afterEntries) {
            messages.add({
              'role': role,
              'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
            });
          }
        }
        break;
        
      case PromptSectionType.postHistoryInstructions:
        // Use custom content from section if available
        final content = section.content?.isNotEmpty == true
            ? section.content!
            : (character?.postHistoryInstructions.isNotEmpty == true
                ? character!.postHistoryInstructions
                : PromptSection.getDefaultContent(PromptSectionType.postHistoryInstructions));
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
          messages.add({'role': role, 'content': processMacros(section.content!)});
        }
        break;
    }
    
    return messages;
  }
  
  /// Process macros in Author's Note
  Future<String> _processAuthorNoteMacros(String note) async {
    final character = state.character;
    if (character == null) return note;
    
    // Get active persona
    final activePersonaId = _ref.read(activePersonaIdProvider);
    Persona? persona;
    if (activePersonaId != null) {
      persona = await _personaRepository.getPersona(activePersonaId);
    }
    persona ??= await _personaRepository.getDefaultPersona();
    
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
  Future<List<Map<String, String>>> _buildContextUpTo(int messageIndex) async {
    final messages = <Map<String, String>>[];
    final character = state.character;
    final chat = state.chat;

    // Get chat messages up to (but not including) the specified index
    final chatMessages = state.messages.sublist(0, messageIndex);

    // Find matching World Info entries
    List<WorldInfoEntry> worldInfoEntries = [];
    if (character != null) {
      worldInfoEntries = await _findMatchingWorldInfoEntries(character, chatMessages);
    }

    // Get Prompt Manager configuration
    final promptConfig = _ref.read(promptManagerProvider);
    final enabledSections = promptConfig.enabledSections;

    // Get active persona
    final activePersonaId = _ref.read(activePersonaIdProvider);
    Persona? persona;
    if (activePersonaId != null) {
      persona = await _personaRepository.getPersona(activePersonaId);
    }
    persona ??= await _personaRepository.getDefaultPersona();

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
            'content': '[${entry.comment.isNotEmpty ? entry.comment : "World Info"}]\n${processMacros(entry.content)}',
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
        section, character, persona, worldInfoEntries, groupedEntries, processMacros, addWorldInfoAt,
      );
      messages.addAll(sectionMessages);
    }

    // Add chat messages with depth-based injections
    final depthEntries = worldInfoEntries
        .where((e) => e.position == WorldInfoPosition.atDepth)
        .toList();
    
    // Prepare Author's Note for depth-based injection
    final authorNoteEnabled = chat?.authorNoteEnabled ?? false;
    final authorNote = chat?.authorNote ?? '';
    final authorNoteDepth = chat?.authorNoteDepth ?? 4;
    
    for (var i = 0; i < chatMessages.length; i++) {
      final msg = chatMessages[i];
      
      // Depth is counted from the end (most recent = depth 0)
      final depthFromEnd = chatMessages.length - 1 - i;
      
      // Check if any depth-based world info entries should be inserted
      for (final entry in depthEntries) {
        if (entry.depth == depthFromEnd) {
          messages.add({
            'role': 'system',
            'content': '[World Info: ${entry.comment.isNotEmpty ? entry.comment : "Context"}]\n${processMacros(entry.content)}',
          });
        }
      }
      
      // Check if any depth-based prompt sections should be inserted
      for (final section in depthBasedSections) {
        if (section.injectionDepth == depthFromEnd) {
          final sectionMessages = await _buildSectionMessages(
            section, character, persona, worldInfoEntries, groupedEntries, processMacros, addWorldInfoAt,
          );
          messages.addAll(sectionMessages);
        }
      }
      
      // Inject Author's Note at the configured depth
      if (authorNoteEnabled && authorNote.isNotEmpty && depthFromEnd == authorNoteDepth) {
        final processedNote = await _processAuthorNoteMacros(authorNote);
        messages.add({
          'role': 'system',
          'content': '[Author\'s Note]\n$processedNote',
        });
      }
      
      messages.add({
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.content,
      });
    }
    
    // If Author's Note depth is beyond message count, insert at the start of chat
    if (authorNoteEnabled && authorNote.isNotEmpty && authorNoteDepth >= chatMessages.length) {
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
        section, character, persona, worldInfoEntries, groupedEntries, processMacros, addWorldInfoAt,
      );
      messages.addAll(sectionMessages);
    }

    return messages;
  }

  /// Find matching World Info entries based on chat context
  Future<List<WorldInfoEntry>> _findMatchingWorldInfoEntries(
    Character character,
    List<ChatMessage> chatMessages,
  ) async {
    // Get active world info IDs (global + character-specific + manually enabled)
    final activeIds = _ref.read(activeWorldInfoIdsProvider);
    
    // Get global world infos
    final globalWorldInfos = await _ref.read(globalWorldInfosProvider.future);
    final globalIds = globalWorldInfos.map((w) => w.id).toList();
    
    // Get character-specific world infos
    final characterWorldInfos = await _ref.read(
      characterWorldInfosProvider(character.id).future,
    );
    final characterIds = characterWorldInfos.map((w) => w.id).toList();
    
    // Combine all active world info IDs
    final allWorldInfoIds = <String>{...activeIds, ...globalIds, ...characterIds}.toList();
    
    if (allWorldInfoIds.isEmpty) return [];
    
    // Build context text from chat messages
    final contextBuffer = StringBuffer();
    contextBuffer.writeln(character.name);
    contextBuffer.writeln(character.description);
    contextBuffer.writeln(character.personality);
    contextBuffer.writeln(character.scenario);
    
    for (final msg in chatMessages) {
      contextBuffer.writeln(msg.content);
    }
    
    // Find matching entries
    return _worldInfoMatcher.findMatchingEntries(
      contextText: contextBuffer.toString(),
      worldInfoIds: allWorldInfoIds,
    );
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
           (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
  }

  /// Clear the current chat
  void clearChat() {
    state = const ActiveChatState();
  }

  // ============================================
  // AUTHOR'S NOTE METHODS
  // ============================================

  /// Update Author's Note content
  Future<void> updateAuthorNote(String content) async {
    if (state.chat == null) return;
    
    final updatedChat = state.chat!.copyWith(authorNote: content);
    await _chatRepository.updateChat(updatedChat);
    state = state.copyWith(chat: updatedChat);
  }

  /// Update Author's Note depth
  Future<void> updateAuthorNoteDepth(int depth) async {
    if (state.chat == null) return;
    
    final updatedChat = state.chat!.copyWith(authorNoteDepth: depth);
    await _chatRepository.updateChat(updatedChat);
    state = state.copyWith(chat: updatedChat);
  }

  /// Toggle Author's Note enabled state
  Future<void> toggleAuthorNote(bool enabled) async {
    if (state.chat == null) return;
    
    final updatedChat = state.chat!.copyWith(authorNoteEnabled: enabled);
    await _chatRepository.updateChat(updatedChat);
    state = state.copyWith(chat: updatedChat);
  }

  /// Update all Author's Note settings at once
  Future<void> updateAuthorNoteSettings({
    String? content,
    int? depth,
    bool? enabled,
  }) async {
    if (state.chat == null) return;
    
    final updatedChat = state.chat!.copyWith(
      authorNote: content ?? state.chat!.authorNote,
      authorNoteDepth: depth ?? state.chat!.authorNoteDepth,
      authorNoteEnabled: enabled ?? state.chat!.authorNoteEnabled,
    );
    await _chatRepository.updateChat(updatedChat);
    state = state.copyWith(chat: updatedChat);
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
    final messageIndex = state.messages.indexWhere((m) => m.id == bookmark.messageId);
    if (messageIndex < 0) {
      // Message not found - might be in a different branch
      // Try to restore messages up to the bookmark's message index
      state = state.copyWith(error: 'Bookmark message not found in current chat');
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
    
    // Generate responses from each selected character
    for (final characterId in responders) {
      await _generateGroupCharacterResponse(characterId, config);
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
    
    switch (group.settings.responseMode) {
      case GroupResponseMode.sequential:
        // Return the next character in sequence
        final lastAssistantMsg = state.messages.reversed
            .firstWhere(
              (m) => m.role == MessageRole.assistant && m.characterId != null,
              orElse: () => state.messages.first,
            );
        
        if (lastAssistantMsg.characterId != null) {
          final lastIndex = activeMemberIds.indexOf(lastAssistantMsg.characterId!);
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
  List<String> _selectNaturalResponders(String userMessage, List<String> activeMemberIds) {
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
  Future<void> _generateGroupCharacterResponse(String characterId, LLMConfig config) async {
    final character = state.groupCharacters[characterId];
    if (character == null || state.chat == null) return;

    state = state.copyWith(
      isGenerating: true,
      currentResponderId: characterId,
      error: null,
    );

    try {
      final context = await _buildGroupContext(character);
      
      // Create placeholder for assistant message
      final assistantMessage = ChatMessage(
        id: _generateId(),
        chatId: state.chat!.id,
        role: MessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        swipes: [''],
        currentSwipeIndex: 0,
        characterId: character.id,
        characterName: character.name,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
      );

      // Stream the response with reasoning support
      final contentBuffer = StringBuffer();
      final reasoningBuffer = StringBuffer();
      await for (final chunk in _llmService.generateStreamWithReasoning(context, config)) {
        if (chunk.isReasoningChunk && chunk.reasoning != null) {
          reasoningBuffer.write(chunk.reasoning);
        }
        if (chunk.content != null) {
          contentBuffer.write(chunk.content);
        }
        final updatedMessage = assistantMessage.copyWith(
          content: contentBuffer.toString(),
          swipes: [contentBuffer.toString()],
          reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
          reasoningSwipes: reasoningBuffer.isNotEmpty ? [reasoningBuffer.toString()] : null,
        );
        
        final updatedMessages = List<ChatMessage>.from(state.messages);
        updatedMessages[updatedMessages.length - 1] = updatedMessage;
        state = state.copyWith(messages: updatedMessages);
      }

      // Save the final message
      final finalMessage = assistantMessage.copyWith(
        content: contentBuffer.toString(),
        swipes: [contentBuffer.toString()],
        reasoning: reasoningBuffer.isNotEmpty ? reasoningBuffer.toString() : null,
        reasoningSwipes: reasoningBuffer.isNotEmpty ? [reasoningBuffer.toString()] : null,
      );
      await _chatRepository.addMessage(finalMessage);

      state = state.copyWith(
        isGenerating: false,
        clearCurrentResponder: true,
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        clearCurrentResponder: true,
        error: e.toString(),
      );
    }
  }

  /// Build context for group chat
  Future<List<Map<String, String>>> _buildGroupContext(Character respondingCharacter) async {
    final messages = <Map<String, String>>[];
    final group = state.group;
    if (group == null) return messages;

    // Build system prompt for group chat
    final systemPrompt = await _buildGroupSystemPrompt(respondingCharacter);
    messages.add({'role': 'system', 'content': systemPrompt});

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

    return messages;
  }

  /// Build system prompt for group chat
  Future<String> _buildGroupSystemPrompt(Character respondingCharacter) async {
    final buffer = StringBuffer();
    final group = state.group;
    if (group == null) return '';

    // Get active persona
    final activePersonaId = _ref.read(activePersonaIdProvider);
    Persona? persona;
    if (activePersonaId != null) {
      persona = await _personaRepository.getPersona(activePersonaId);
    }
    persona ??= await _personaRepository.getDefaultPersona();

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
        buffer.writeln('User description: ${processMacros(persona.description)}');
      }
      buffer.writeln();
    }

    // Describe the responding character
    buffer.writeln('=== YOUR CHARACTER: ${respondingCharacter.name} ===');
    if (respondingCharacter.description.isNotEmpty) {
      buffer.writeln('Description: ${processMacros(respondingCharacter.description)}');
    }
    if (respondingCharacter.personality.isNotEmpty) {
      buffer.writeln('Personality: ${processMacros(respondingCharacter.personality)}');
    }
    buffer.writeln();

    // Describe other characters in the group
    buffer.writeln('=== OTHER CHARACTERS IN THIS CONVERSATION ===');
    for (final entry in state.groupCharacters.entries) {
      if (entry.key != respondingCharacter.id) {
        final char = entry.value;
        buffer.writeln('${char.name}: ${char.description.isNotEmpty ? processMacros(char.description) : "No description"}');
      }
    }
    buffer.writeln();

    // Add scenario if the responding character has one
    if (respondingCharacter.scenario.isNotEmpty) {
      buffer.writeln('Scenario: ${processMacros(respondingCharacter.scenario)}');
      buffer.writeln();
    }

    // Add system prompt if the responding character has one
    if (respondingCharacter.systemPrompt.isNotEmpty) {
      buffer.writeln(processMacros(respondingCharacter.systemPrompt));
    }

    buffer.writeln();
    buffer.writeln('IMPORTANT: Stay in character as ${respondingCharacter.name}. ');
    buffer.writeln('Do not speak for other characters. Only respond as ${respondingCharacter.name}.');
    buffer.writeln('Do not include your name prefix in your response - just write your dialogue/actions directly.');

    return buffer.toString();
  }

  /// Manually trigger a specific character to respond (for manual mode)
  Future<void> triggerCharacterResponse(String characterId, LLMConfig config) async {
    if (!state.isGroupChat) return;
    await _generateGroupCharacterResponse(characterId, config);
  }
}

/// Provider for active chat
final activeChatProvider = StateNotifierProvider<ActiveChatNotifier, ActiveChatState>((ref) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  final characterRepo = ref.watch(characterRepositoryProvider);
  final personaRepo = ref.watch(personaRepositoryProvider);
  final llmService = ref.watch(llmServiceProvider);
  final worldInfoMatcher = ref.watch(worldInfoMatcherProvider);

  return ActiveChatNotifier(
    chatRepository: chatRepo,
    characterRepository: characterRepo,
    personaRepository: personaRepo,
    llmService: llmService,
    worldInfoMatcher: worldInfoMatcher,
    ref: ref,
  );
});

/// Chat list for a character
final characterChatsProvider = FutureProvider.family<List<Chat>, String>((ref, characterId) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getChatsForCharacter(characterId);
});

/// All chats list
final allChatsProvider = FutureProvider<List<Chat>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getAllChats();
});

/// Recent chats
final recentChatsProvider = FutureProvider<List<Chat>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getRecentChats(limit: 10);
});