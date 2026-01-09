import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/instruct_template.dart';

/// Current active instruct template ID
final activeInstructTemplateIdProvider = StateProvider<String>((ref) => 'none');

/// Active instruct template provider
final activeInstructTemplateProvider = Provider<InstructTemplate>((ref) {
  final activeId = ref.watch(activeInstructTemplateIdProvider);
  return BuiltInTemplates.getById(activeId) ?? BuiltInTemplates.none;
});

/// All available instruct templates
final allInstructTemplatesProvider = Provider<List<InstructTemplate>>((ref) {
  return BuiltInTemplates.all;
});

/// Instruct template formatter service
class InstructFormatter {
  final InstructTemplate template;

  InstructFormatter(this.template);

  /// Format a complete prompt with system, user, and assistant messages
  String formatPrompt({
    required String systemPrompt,
    required List<Map<String, String>> messages,
    bool includeAssistantPrefix = true,
  }) {
    // If template is "none", return empty (API will handle formatting)
    if (template.id == 'none') {
      return '';
    }

    final buffer = StringBuffer();

    // Add system prompt
    if (systemPrompt.isNotEmpty) {
      buffer.write(template.systemPrefix);
      buffer.write(systemPrompt);
      buffer.write(template.systemSuffix);
    }

    // Add messages
    bool isFirstAssistant = true;
    for (final message in messages) {
      final role = message['role'];
      final content = message['content'] ?? '';

      if (role == 'user') {
        buffer.write(template.userPrefix);
        buffer.write(content);
        buffer.write(template.userSuffix);
      } else if (role == 'assistant') {
        // Use first assistant prefix/suffix if available
        if (isFirstAssistant && template.firstAssistantPrefix != null) {
          buffer.write(template.firstAssistantPrefix);
          buffer.write(content);
          buffer.write(template.firstAssistantSuffix ?? template.assistantSuffix);
        } else {
          buffer.write(template.assistantPrefix);
          buffer.write(content);
          buffer.write(template.assistantSuffix);
        }
        isFirstAssistant = false;
      }
    }

    // Add assistant prefix for generation
    if (includeAssistantPrefix) {
      buffer.write(template.assistantPrefix);
    }

    return buffer.toString();
  }

  /// Get stop sequences for this template
  List<String> get stopSequences => template.stopSequences;

  /// Check if this template should be used (not "none")
  bool get shouldFormat => template.id != 'none';
}

/// Provider for instruct formatter
final instructFormatterProvider = Provider<InstructFormatter>((ref) {
  final template = ref.watch(activeInstructTemplateProvider);
  return InstructFormatter(template);
});