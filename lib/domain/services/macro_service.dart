import 'dart:math';
import 'package:intl/intl.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/persona.dart';

/// Service for expanding macros in text
/// Supports SillyTavern-compatible macros: {{user}}, {{char}}, {{time}}, etc.
class MacroService {
  final Random _random = Random();
  
  /// Context for macro expansion
  final MacroContext context;
  
  MacroService(this.context);
  
  /// Process all macros in the given text
  String process(String text) {
    if (text.isEmpty) return text;
    
    String result = text;
    
    // Process macros in order of complexity (more specific first)
    result = _processRandomMacros(result);
    result = _processConditionalMacros(result);
    result = _processTimeDateMacros(result);
    result = _processCharacterMacros(result);
    result = _processUserMacros(result);
    result = _processChatMacros(result);
    result = _processSpecialMacros(result);
    
    return result;
  }
  
  /// Process {{user}} and related user macros
  String _processUserMacros(String text) {
    String result = text;
    
    // {{user}} - User's display name
    result = result.replaceAll(
      RegExp(r'\{\{user\}\}', caseSensitive: false),
      context.userName,
    );
    
    // {{persona}} - Same as {{user}} for compatibility
    result = result.replaceAll(
      RegExp(r'\{\{persona\}\}', caseSensitive: false),
      context.userName,
    );
    
    // {{user_description}} or {{persona_description}} - User's description/personality
    result = result.replaceAll(
      RegExp(r'\{\{user_description\}\}', caseSensitive: false),
      context.userDescription,
    );
    result = result.replaceAll(
      RegExp(r'\{\{persona_description\}\}', caseSensitive: false),
      context.userDescription,
    );
    
    return result;
  }
  
  /// Process {{char}} and related character macros
  String _processCharacterMacros(String text) {
    String result = text;
    
    // {{char}} - Character's name
    result = result.replaceAll(
      RegExp(r'\{\{char\}\}', caseSensitive: false),
      context.characterName,
    );
    
    // {{charname}} - Same as {{char}}
    result = result.replaceAll(
      RegExp(r'\{\{charname\}\}', caseSensitive: false),
      context.characterName,
    );
    
    // {{char_version}} or {{version}} - Character's version field
    result = result.replaceAll(
      RegExp(r'\{\{char_version\}\}', caseSensitive: false),
      context.characterVersion,
    );
    result = result.replaceAll(
      RegExp(r'\{\{version\}\}', caseSensitive: false),
      context.characterVersion,
    );
    
    // {{description}} - Character's description
    result = result.replaceAll(
      RegExp(r'\{\{description\}\}', caseSensitive: false),
      context.characterDescription,
    );
    
    // {{personality}} - Character's personality
    result = result.replaceAll(
      RegExp(r'\{\{personality\}\}', caseSensitive: false),
      context.characterPersonality,
    );
    
    // {{scenario}} - Character's scenario
    result = result.replaceAll(
      RegExp(r'\{\{scenario\}\}', caseSensitive: false),
      context.characterScenario,
    );
    
    // {{first_mes}} or {{greeting}} - Character's first message
    result = result.replaceAll(
      RegExp(r'\{\{first_mes\}\}', caseSensitive: false),
      context.characterFirstMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{greeting\}\}', caseSensitive: false),
      context.characterFirstMessage,
    );
    
    // {{mes_example}} or {{examples}} - Character's example dialogues
    result = result.replaceAll(
      RegExp(r'\{\{mes_example\}\}', caseSensitive: false),
      context.characterExamples,
    );
    result = result.replaceAll(
      RegExp(r'\{\{examples\}\}', caseSensitive: false),
      context.characterExamples,
    );
    
    // {{system_prompt}} or {{char_system_prompt}} - Character's system prompt
    result = result.replaceAll(
      RegExp(r'\{\{system_prompt\}\}', caseSensitive: false),
      context.characterSystemPrompt,
    );
    result = result.replaceAll(
      RegExp(r'\{\{char_system_prompt\}\}', caseSensitive: false),
      context.characterSystemPrompt,
    );
    
    // {{post_history_instructions}} - Character's post-history instructions
    result = result.replaceAll(
      RegExp(r'\{\{post_history_instructions\}\}', caseSensitive: false),
      context.postHistoryInstructions,
    );
    
    // {{jailbreak}} - Alias for post_history_instructions
    result = result.replaceAll(
      RegExp(r'\{\{jailbreak\}\}', caseSensitive: false),
      context.postHistoryInstructions,
    );
    
    return result;
  }
  
  /// Process time and date macros
  String _processTimeDateMacros(String text) {
    String result = text;
    final now = DateTime.now();
    
    // {{time}} - Current time (HH:mm)
    result = result.replaceAll(
      RegExp(r'\{\{time\}\}', caseSensitive: false),
      DateFormat('HH:mm').format(now),
    );
    
    // {{time_12h}} - Current time in 12-hour format
    result = result.replaceAll(
      RegExp(r'\{\{time_12h\}\}', caseSensitive: false),
      DateFormat('hh:mm a').format(now),
    );
    
    // {{date}} - Current date (YYYY-MM-DD)
    result = result.replaceAll(
      RegExp(r'\{\{date\}\}', caseSensitive: false),
      DateFormat('yyyy-MM-dd').format(now),
    );
    
    // {{date_local}} - Current date in local format
    result = result.replaceAll(
      RegExp(r'\{\{date_local\}\}', caseSensitive: false),
      DateFormat.yMMMd().format(now),
    );
    
    // {{weekday}} - Current day of week
    result = result.replaceAll(
      RegExp(r'\{\{weekday\}\}', caseSensitive: false),
      DateFormat('EEEE').format(now),
    );
    
    // {{day}} - Day of month
    result = result.replaceAll(
      RegExp(r'\{\{day\}\}', caseSensitive: false),
      now.day.toString(),
    );
    
    // {{month}} - Month name
    result = result.replaceAll(
      RegExp(r'\{\{month\}\}', caseSensitive: false),
      DateFormat('MMMM').format(now),
    );
    
    // {{year}} - Year
    result = result.replaceAll(
      RegExp(r'\{\{year\}\}', caseSensitive: false),
      now.year.toString(),
    );
    
    // {{datetime}} - Full datetime
    result = result.replaceAll(
      RegExp(r'\{\{datetime\}\}', caseSensitive: false),
      DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
    );
    
    // {{iso_date}} - ISO 8601 datetime
    result = result.replaceAll(
      RegExp(r'\{\{iso_date\}\}', caseSensitive: false),
      now.toIso8601String(),
    );
    
    return result;
  }
  
  /// Process chat-related macros
  String _processChatMacros(String text) {
    String result = text;
    
    // {{lastMessage}} or {{last_message}} - Last message content
    result = result.replaceAll(
      RegExp(r'\{\{lastMessage\}\}', caseSensitive: false),
      context.lastMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{last_message\}\}', caseSensitive: false),
      context.lastMessage,
    );
    
    // {{lastUserMessage}} or {{last_user_message}} - Last user message
    result = result.replaceAll(
      RegExp(r'\{\{lastUserMessage\}\}', caseSensitive: false),
      context.lastUserMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{last_user_message\}\}', caseSensitive: false),
      context.lastUserMessage,
    );
    
    // {{lastCharMessage}} or {{last_char_message}} - Last character message
    result = result.replaceAll(
      RegExp(r'\{\{lastCharMessage\}\}', caseSensitive: false),
      context.lastCharacterMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{last_char_message\}\}', caseSensitive: false),
      context.lastCharacterMessage,
    );
    
    // {{messageCount}} or {{message_count}} - Total message count
    result = result.replaceAll(
      RegExp(r'\{\{messageCount\}\}', caseSensitive: false),
      context.messageCount.toString(),
    );
    result = result.replaceAll(
      RegExp(r'\{\{message_count\}\}', caseSensitive: false),
      context.messageCount.toString(),
    );
    
    // {{chatId}} or {{chat_id}} - Chat ID
    result = result.replaceAll(
      RegExp(r'\{\{chatId\}\}', caseSensitive: false),
      context.chatId,
    );
    result = result.replaceAll(
      RegExp(r'\{\{chat_id\}\}', caseSensitive: false),
      context.chatId,
    );
    
    return result;
  }
  
  /// Process random macros
  String _processRandomMacros(String text) {
    String result = text;
    
    // {{random}} - Random number 0-100
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{random\}\}', caseSensitive: false),
      (match) => _random.nextInt(101).toString(),
    );
    
    // {{random::min::max}} - Random number between min and max
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{random::(\d+)::(\d+)\}\}', caseSensitive: false),
      (match) {
        final min = int.parse(match.group(1)!);
        final max = int.parse(match.group(2)!);
        if (min >= max) return min.toString();
        return (min + _random.nextInt(max - min + 1)).toString();
      },
    );
    
    // {{roll::dice}} - Roll dice (e.g., {{roll::d20}}, {{roll::2d6}})
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{roll::(\d*)d(\d+)\}\}', caseSensitive: false),
      (match) {
        final count = match.group(1)!.isEmpty ? 1 : int.parse(match.group(1)!);
        final sides = int.parse(match.group(2)!);
        if (sides <= 0) return '0';
        
        int total = 0;
        for (int i = 0; i < count; i++) {
          total += _random.nextInt(sides) + 1;
        }
        return total.toString();
      },
    );
    
    // {{pick::option1::option2::option3}} - Pick random option
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{pick::([^}]+)\}\}', caseSensitive: false),
      (match) {
        final options = match.group(1)!.split('::');
        if (options.isEmpty) return '';
        return options[_random.nextInt(options.length)];
      },
    );
    
    // {{uuid}} - Generate UUID
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{uuid\}\}', caseSensitive: false),
      (match) => _generateUuid(),
    );
    
    return result;
  }
  
  /// Process conditional macros
  String _processConditionalMacros(String text) {
    String result = text;
    
    // {{if::condition::then}} - Simple if
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{if::([^:]*?)::([^}]*?)\}\}', caseSensitive: false),
      (match) {
        final condition = match.group(1)!.trim();
        final thenValue = match.group(2)!;
        
        if (_evaluateCondition(condition)) {
          return thenValue;
        }
        return '';
      },
    );
    
    // {{if::condition::then::else}} - If-else
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{if::([^:]*?)::([^:]*?)::([^}]*?)\}\}', caseSensitive: false),
      (match) {
        final condition = match.group(1)!.trim();
        final thenValue = match.group(2)!;
        final elseValue = match.group(3)!;
        
        if (_evaluateCondition(condition)) {
          return thenValue;
        }
        return elseValue;
      },
    );
    
    return result;
  }
  
  /// Process special/utility macros
  String _processSpecialMacros(String text) {
    String result = text;
    
    // {{newline}} or {{nl}} - Newline character
    result = result.replaceAll(
      RegExp(r'\{\{newline\}\}', caseSensitive: false),
      '\n',
    );
    result = result.replaceAll(
      RegExp(r'\{\{nl\}\}', caseSensitive: false),
      '\n',
    );
    
    // {{trim}} - Remove surrounding whitespace (marker only)
    result = result.replaceAll(
      RegExp(r'\{\{trim\}\}', caseSensitive: false),
      '',
    );
    
    // {{noop}} - No operation (useful for testing)
    result = result.replaceAll(
      RegExp(r'\{\{noop\}\}', caseSensitive: false),
      '',
    );
    
    // {{original}} - For use in prompt overrides
    result = result.replaceAll(
      RegExp(r'\{\{original\}\}', caseSensitive: false),
      context.originalPrompt,
    );
    
    // {{input}} - Current user input
    result = result.replaceAll(
      RegExp(r'\{\{input\}\}', caseSensitive: false),
      context.currentInput,
    );
    
    // {{model}} - Current model name
    result = result.replaceAll(
      RegExp(r'\{\{model\}\}', caseSensitive: false),
      context.modelName,
    );
    
    // {{provider}} - Current provider name
    result = result.replaceAll(
      RegExp(r'\{\{provider\}\}', caseSensitive: false),
      context.providerName,
    );
    
    // {{idle_duration}} - Time since last message (in minutes)
    result = result.replaceAll(
      RegExp(r'\{\{idle_duration\}\}', caseSensitive: false),
      context.idleDuration.toString(),
    );
    
    return result;
  }
  
  /// Evaluate a simple condition
  bool _evaluateCondition(String condition) {
    if (condition.isEmpty) return false;
    
    // Check for negation
    if (condition.startsWith('!')) {
      return !_evaluateCondition(condition.substring(1).trim());
    }
    
    // Check for comparison operators
    if (condition.contains('==')) {
      final parts = condition.split('==');
      if (parts.length == 2) {
        return parts[0].trim() == parts[1].trim();
      }
    }
    
    if (condition.contains('!=')) {
      final parts = condition.split('!=');
      if (parts.length == 2) {
        return parts[0].trim() != parts[1].trim();
      }
    }
    
    // Simple truthy check - non-empty string is true
    return condition.isNotEmpty && condition != '0' && condition.toLowerCase() != 'false';
  }
  
  /// Helper to replace all matches with callback function
  String _replaceAllWithCallback(
    String text,
    RegExp regex,
    String Function(Match) callback,
  ) {
    return text.replaceAllMapped(regex, callback);
  }
  
  /// Generate a simple UUID v4
  String _generateUuid() {
    final random = Random();
    const hexDigits = '0123456789abcdef';
    
    final uuid = List<String>.generate(36, (i) {
      if (i == 8 || i == 13 || i == 18 || i == 23) {
        return '-';
      }
      if (i == 14) {
        return '4'; // Version 4
      }
      if (i == 19) {
        return hexDigits[(random.nextInt(4) + 8)]; // Variant bits
      }
      return hexDigits[random.nextInt(16)];
    });
    
    return uuid.join();
  }
}

/// Context data for macro expansion
class MacroContext {
  // User/Persona data
  final String userName;
  final String userDescription;
  
  // Character data
  final String characterName;
  final String characterDescription;
  final String characterPersonality;
  final String characterScenario;
  final String characterFirstMessage;
  final String characterExamples;
  final String characterSystemPrompt;
  final String characterVersion;
  final String postHistoryInstructions;
  
  // Chat data
  final String chatId;
  final int messageCount;
  final String lastMessage;
  final String lastUserMessage;
  final String lastCharacterMessage;
  
  // Current state
  final String currentInput;
  final String originalPrompt;
  final String modelName;
  final String providerName;
  final int idleDuration;
  
  // Group chat data (optional)
  final List<String> groupCharacterNames;
  
  const MacroContext({
    this.userName = 'User',
    this.userDescription = '',
    this.characterName = 'Assistant',
    this.characterDescription = '',
    this.characterPersonality = '',
    this.characterScenario = '',
    this.characterFirstMessage = '',
    this.characterExamples = '',
    this.characterSystemPrompt = '',
    this.characterVersion = '',
    this.postHistoryInstructions = '',
    this.chatId = '',
    this.messageCount = 0,
    this.lastMessage = '',
    this.lastUserMessage = '',
    this.lastCharacterMessage = '',
    this.currentInput = '',
    this.originalPrompt = '',
    this.modelName = '',
    this.providerName = '',
    this.idleDuration = 0,
    this.groupCharacterNames = const [],
  });
  
  /// Create MacroContext from character, persona, and chat data
  factory MacroContext.fromData({
    Character? character,
    Persona? persona,
    Chat? chat,
    List<ChatMessage>? messages,
    String? currentInput,
    String? modelName,
    String? providerName,
    String? originalPrompt,
    List<Character>? groupCharacters,
  }) {
    // Get last messages
    String lastMessage = '';
    String lastUserMessage = '';
    String lastCharMessage = '';
    
    if (messages != null && messages.isNotEmpty) {
      lastMessage = messages.last.content;
      
      for (final msg in messages.reversed) {
        if (msg.role == MessageRole.user && lastUserMessage.isEmpty) {
          lastUserMessage = msg.content;
        } else if (msg.role == MessageRole.assistant && lastCharMessage.isEmpty) {
          lastCharMessage = msg.content;
        }
        
        if (lastUserMessage.isNotEmpty && lastCharMessage.isNotEmpty) {
          break;
        }
      }
    }
    
    // Calculate idle duration
    int idleDuration = 0;
    if (messages != null && messages.isNotEmpty) {
      final lastMsgTime = messages.last.timestamp;
      idleDuration = DateTime.now().difference(lastMsgTime).inMinutes;
    }
    
    return MacroContext(
      userName: persona?.name ?? 'User',
      userDescription: persona?.description ?? '',
      characterName: character?.name ?? 'Assistant',
      characterDescription: character?.description ?? '',
      characterPersonality: character?.personality ?? '',
      characterScenario: character?.scenario ?? '',
      characterFirstMessage: character?.firstMessage ?? '',
      characterExamples: character?.exampleMessages ?? '',
      characterSystemPrompt: character?.systemPrompt ?? '',
      characterVersion: character?.version ?? '',
      postHistoryInstructions: character?.postHistoryInstructions ?? '',
      chatId: chat?.id ?? '',
      messageCount: messages?.length ?? 0,
      lastMessage: lastMessage,
      lastUserMessage: lastUserMessage,
      lastCharacterMessage: lastCharMessage,
      currentInput: currentInput ?? '',
      originalPrompt: originalPrompt ?? '',
      modelName: modelName ?? '',
      providerName: providerName ?? '',
      idleDuration: idleDuration,
      groupCharacterNames: groupCharacters?.map((c) => c.name).toList() ?? [],
    );
  }
  
  MacroContext copyWith({
    String? userName,
    String? userDescription,
    String? characterName,
    String? characterDescription,
    String? characterPersonality,
    String? characterScenario,
    String? characterFirstMessage,
    String? characterExamples,
    String? characterSystemPrompt,
    String? characterVersion,
    String? postHistoryInstructions,
    String? chatId,
    int? messageCount,
    String? lastMessage,
    String? lastUserMessage,
    String? lastCharacterMessage,
    String? currentInput,
    String? originalPrompt,
    String? modelName,
    String? providerName,
    int? idleDuration,
    List<String>? groupCharacterNames,
  }) {
    return MacroContext(
      userName: userName ?? this.userName,
      userDescription: userDescription ?? this.userDescription,
      characterName: characterName ?? this.characterName,
      characterDescription: characterDescription ?? this.characterDescription,
      characterPersonality: characterPersonality ?? this.characterPersonality,
      characterScenario: characterScenario ?? this.characterScenario,
      characterFirstMessage: characterFirstMessage ?? this.characterFirstMessage,
      characterExamples: characterExamples ?? this.characterExamples,
      characterSystemPrompt: characterSystemPrompt ?? this.characterSystemPrompt,
      characterVersion: characterVersion ?? this.characterVersion,
      postHistoryInstructions: postHistoryInstructions ?? this.postHistoryInstructions,
      chatId: chatId ?? this.chatId,
      messageCount: messageCount ?? this.messageCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastUserMessage: lastUserMessage ?? this.lastUserMessage,
      lastCharacterMessage: lastCharacterMessage ?? this.lastCharacterMessage,
      currentInput: currentInput ?? this.currentInput,
      originalPrompt: originalPrompt ?? this.originalPrompt,
      modelName: modelName ?? this.modelName,
      providerName: providerName ?? this.providerName,
      idleDuration: idleDuration ?? this.idleDuration,
      groupCharacterNames: groupCharacterNames ?? this.groupCharacterNames,
    );
  }
}

/// Extension to easily process macros on strings
extension MacroStringExtension on String {
  /// Process all macros in this string using the given context
  String processMacros(MacroContext context) {
    return MacroService(context).process(this);
  }
}