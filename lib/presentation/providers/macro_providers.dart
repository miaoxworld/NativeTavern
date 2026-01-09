import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/domain/services/macro_service.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';

/// Provider for creating a MacroContext based on current chat state
final macroContextProvider = Provider<MacroContext>((ref) {
  final chatState = ref.watch(activeChatProvider);
  final personaState = ref.watch(activePersonaProvider);
  final llmConfig = ref.watch(llmConfigProvider);
  
  final persona = personaState.valueOrNull;
  
  return MacroContext.fromData(
    character: chatState.character,
    persona: persona,
    chat: chatState.chat,
    messages: chatState.messages,
    modelName: llmConfig.model,
    providerName: llmConfig.provider.name,
  );
});

/// Provider for MacroService with current context
final macroServiceProvider = Provider<MacroService>((ref) {
  final context = ref.watch(macroContextProvider);
  return MacroService(context);
});

/// Extension provider to process macros with custom context
final macroProcessorProvider = Provider.family<String Function(String), MacroContext>((ref, context) {
  return (text) => MacroService(context).process(text);
});

/// Provider for processing text with macros using current context
final processTextWithMacrosProvider = Provider<String Function(String)>((ref) {
  final service = ref.watch(macroServiceProvider);
  return (text) => service.process(text);
});

/// Create a MacroContext for a specific character and chat scenario
MacroContext createMacroContext({
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
  return MacroContext.fromData(
    character: character,
    persona: persona,
    chat: chat,
    messages: messages,
    currentInput: currentInput,
    modelName: modelName,
    providerName: providerName,
    originalPrompt: originalPrompt,
    groupCharacters: groupCharacters,
  );
}

/// Process a text string with macros using provided context components
String processMacros(
  String text, {
  Character? character,
  Persona? persona,
  Chat? chat,
  List<ChatMessage>? messages,
  String? currentInput,
  String? modelName,
  String? providerName,
}) {
  final context = createMacroContext(
    character: character,
    persona: persona,
    chat: chat,
    messages: messages,
    currentInput: currentInput,
    modelName: modelName,
    providerName: providerName,
  );
  
  return MacroService(context).process(text);
}

/// Mixin for adding macro processing capability to notifiers
mixin MacroProcessingMixin {
  /// Process all macros in a string
  String processMacros(String text, MacroContext context) {
    return MacroService(context).process(text);
  }
  
  /// Process macros in a list of chat messages (for display)
  List<Map<String, String>> processMessagesWithMacros(
    List<Map<String, String>> messages,
    MacroContext context,
  ) {
    final service = MacroService(context);
    return messages.map((msg) {
      return {
        'role': msg['role']!,
        'content': service.process(msg['content']!),
      };
    }).toList();
  }
}