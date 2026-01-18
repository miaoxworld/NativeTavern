import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/data/models/prompt_manager.dart';
import 'package:native_tavern/domain/services/tokenizer_service.dart';

/// Represents the token usage of a single context component
class ContextComponentUsage {
  final String name;
  final int tokenCount;
  final String? content;
  final List<ContextComponentUsage>? children;
  final String? icon; // For display purposes

  const ContextComponentUsage({
    required this.name,
    required this.tokenCount,
    this.content,
    this.children,
    this.icon,
  });

  double getPercentage(int maxContext) {
    if (maxContext <= 0) return 0;
    return (tokenCount / maxContext) * 100;
  }
}

/// Represents the full context usage breakdown
class ContextUsage {
  final int totalTokens;
  final int maxContext;
  final List<ContextComponentUsage> components;
  final DateTime calculatedAt;

  const ContextUsage({
    required this.totalTokens,
    required this.maxContext,
    required this.components,
    required this.calculatedAt,
  });

  /// Get usage percentage (0-100)
  double get usagePercentage {
    if (maxContext <= 0) return 0;
    return (totalTokens / maxContext) * 100;
  }

  /// Get remaining tokens
  int get remainingTokens => maxContext - totalTokens;

  /// Check if context is over limit
  bool get isOverLimit => totalTokens > maxContext;

  /// Get color indicator based on usage
  ContextUsageLevel get level {
    final percentage = usagePercentage;
    if (percentage < 50) return ContextUsageLevel.low;
    if (percentage < 75) return ContextUsageLevel.medium;
    if (percentage < 90) return ContextUsageLevel.high;
    return ContextUsageLevel.critical;
  }
}

enum ContextUsageLevel { low, medium, high, critical }

/// Service for calculating context usage
class ContextUsageService {
  final TokenizerService _tokenizerService;

  ContextUsageService(this._tokenizerService);

  /// Comprehensive context usage calculation with full breakdown
  ContextUsage calculateDetailedUsage({
    required Chat? chat,
    required Character? character,
    required Persona? persona,
    required List<ChatMessage> messages,
    required int maxContext,
    required List<PromptSection> enabledSections,
    List<WorldInfoEntry>? worldInfoEntries,
  }) {
    final components = <ContextComponentUsage>[];

    // ============ PROMPT SECTIONS ============
    final promptSectionChildren = <ContextComponentUsage>[];
    int promptSectionTotal = 0;

    for (final section in enabledSections) {
      final sectionTokens = _calculateSectionTokens(section, character, persona);
      if (sectionTokens > 0) {
        promptSectionChildren.add(ContextComponentUsage(
          name: section.name,
          tokenCount: sectionTokens,
          icon: _getSectionIcon(section.type),
        ));
        promptSectionTotal += sectionTokens;
      }
    }

    if (promptSectionChildren.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: 'Prompt Sections',
        tokenCount: promptSectionTotal,
        children: promptSectionChildren,
        icon: 'settings',
      ));
    }

    // ============ WORLD INFO / LOREBOOK ============
    if (worldInfoEntries != null && worldInfoEntries.isNotEmpty) {
      final worldInfoTokens = _calculateWorldInfoTokens(worldInfoEntries);
      if (worldInfoTokens.tokenCount > 0) {
        components.add(worldInfoTokens);
      }
    }

    // ============ AUTHOR'S NOTE ============
    if (chat != null && chat.authorNoteEnabled && chat.authorNote.isNotEmpty) {
      final authorNoteTokens = _tokenizerService.estimateTokenCount(chat.authorNote);
      components.add(ContextComponentUsage(
        name: "Author's Note",
        tokenCount: authorNoteTokens,
        icon: 'edit_note',
      ));
    }

    // ============ SUMMARIES ============
    if (chat != null && chat.summaries.isNotEmpty) {
      final summaryChildren = <ContextComponentUsage>[];
      int summaryTotal = 0;
      
      for (int i = 0; i < chat.summaries.length; i++) {
        final summary = chat.summaries[i];
        final tokens = _tokenizerService.estimateTokenCount(summary.content);
        summaryChildren.add(ContextComponentUsage(
          name: 'Summary ${i + 1}',
          tokenCount: tokens,
        ));
        summaryTotal += tokens;
      }

      components.add(ContextComponentUsage(
        name: 'Summaries (${chat.summaries.length})',
        tokenCount: summaryTotal,
        children: summaryChildren,
        icon: 'summarize',
      ));
    }

    // ============ CHAT HISTORY ============
    final chatHistoryTokens = _calculateChatHistoryTokens(messages);
    if (chatHistoryTokens.tokenCount > 0) {
      components.add(chatHistoryTokens);
    }

    // Calculate total
    final totalTokens = components.fold<int>(
      0,
      (sum, component) => sum + component.tokenCount,
    );

    return ContextUsage(
      totalTokens: totalTokens,
      maxContext: maxContext,
      components: components,
      calculatedAt: DateTime.now(),
    );
  }

  /// Quick estimation of current context usage (faster, less accurate)
  /// Used for the compact indicator in real-time
  ContextUsage quickEstimate({
    required Chat? chat,
    required Character? character,
    required Persona? persona,
    required List<ChatMessage> messages,
    required int maxContext,
    List<PromptSection>? enabledSections,
    List<WorldInfoEntry>? worldInfoEntries,
  }) {
    final components = <ContextComponentUsage>[];

    // ============ PROMPT SECTIONS ============
    if (enabledSections != null && enabledSections.isNotEmpty) {
      final promptSectionChildren = <ContextComponentUsage>[];
      int promptSectionTotal = 0;

      for (final section in enabledSections) {
        final sectionTokens = _calculateSectionTokens(section, character, persona);
        if (sectionTokens > 0) {
          promptSectionChildren.add(ContextComponentUsage(
            name: section.name,
            tokenCount: sectionTokens,
            icon: _getSectionIcon(section.type),
          ));
          promptSectionTotal += sectionTokens;
        }
      }

      if (promptSectionChildren.isNotEmpty) {
        components.add(ContextComponentUsage(
          name: 'Prompt Sections',
          tokenCount: promptSectionTotal,
          children: promptSectionChildren,
          icon: 'settings',
        ));
      }
    } else {
      // Fallback: estimate from character data directly
      final characterComponents = _estimateCharacterComponents(character);
      if (characterComponents.isNotEmpty) {
        final total = characterComponents.fold<int>(0, (sum, c) => sum + c.tokenCount);
        components.add(ContextComponentUsage(
          name: 'Character & System',
          tokenCount: total,
          children: characterComponents,
          icon: 'person',
        ));
      }

      // Persona
      if (persona != null && persona.description.isNotEmpty) {
        components.add(ContextComponentUsage(
          name: 'Persona',
          tokenCount: _tokenizerService.estimateTokenCount(
            '${persona.name}\n${persona.description}',
          ),
          icon: 'account_circle',
        ));
      }
    }

    // ============ WORLD INFO / LOREBOOK ============
    if (worldInfoEntries != null && worldInfoEntries.isNotEmpty) {
      final worldInfoTokens = _calculateWorldInfoTokens(worldInfoEntries);
      if (worldInfoTokens.tokenCount > 0) {
        components.add(worldInfoTokens);
      }
    }

    // ============ AUTHOR'S NOTE ============
    if (chat != null && chat.authorNoteEnabled && chat.authorNote.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: "Author's Note",
        tokenCount: _tokenizerService.estimateTokenCount(chat.authorNote),
        icon: 'edit_note',
      ));
    }

    // ============ SUMMARIES ============
    if (chat != null && chat.summaries.isNotEmpty) {
      final summaryText = chat.summaries.map((s) => s.content).join('\n');
      components.add(ContextComponentUsage(
        name: 'Summaries (${chat.summaries.length})',
        tokenCount: _tokenizerService.estimateTokenCount(summaryText),
        icon: 'summarize',
      ));
    }

    // ============ CHAT HISTORY ============
    final chatHistoryTokens = _calculateChatHistoryTokens(messages);
    if (chatHistoryTokens.tokenCount > 0) {
      components.add(chatHistoryTokens);
    }

    // Calculate total
    final totalTokens = components.fold<int>(
      0,
      (sum, component) => sum + component.tokenCount,
    );

    return ContextUsage(
      totalTokens: totalTokens,
      maxContext: maxContext,
      components: components,
      calculatedAt: DateTime.now(),
    );
  }

  /// Calculate tokens for a single prompt section
  int _calculateSectionTokens(
    PromptSection section,
    Character? character,
    Persona? persona,
  ) {
    switch (section.type) {
      case PromptSectionType.systemPrompt:
        // Use custom content if available, otherwise character's system prompt
        if (section.content != null && section.content!.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(section.content!);
        }
        if (character != null && character.systemPrompt.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(character.systemPrompt);
        }
        return _tokenizerService.estimateTokenCount(
          PromptSection.getDefaultContent(PromptSectionType.systemPrompt),
        );

      case PromptSectionType.persona:
        if (persona != null && persona.name.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(
            '${persona.name}\n${persona.description}',
          );
        }
        return 0;

      case PromptSectionType.characterDescription:
        if (character != null && character.description.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(character.description);
        }
        return 0;

      case PromptSectionType.characterPersonality:
        if (character != null && character.personality.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(character.personality);
        }
        return 0;

      case PromptSectionType.characterScenario:
        if (character != null && character.scenario.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(character.scenario);
        }
        return 0;

      case PromptSectionType.exampleMessages:
        if (character != null && character.exampleMessages.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(character.exampleMessages);
        }
        return 0;

      case PromptSectionType.postHistoryInstructions:
        if (section.content != null && section.content!.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(section.content!);
        }
        if (character != null && character.postHistoryInstructions.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(character.postHistoryInstructions);
        }
        return _tokenizerService.estimateTokenCount(
          PromptSection.getDefaultContent(PromptSectionType.postHistoryInstructions),
        );

      case PromptSectionType.nsfw:
        if (section.content != null && section.content!.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(section.content!);
        }
        return _tokenizerService.estimateTokenCount(
          PromptSection.getDefaultContent(PromptSectionType.nsfw),
        );

      case PromptSectionType.custom:
        if (section.content != null && section.content!.isNotEmpty) {
          return _tokenizerService.estimateTokenCount(section.content!);
        }
        return 0;

      case PromptSectionType.worldInfo:
      case PromptSectionType.worldInfoAfter:
      case PromptSectionType.authorNote:
      case PromptSectionType.chatHistory:
      case PromptSectionType.enhanceDefinitions:
        // These are handled separately
        return 0;
    }
  }

  /// Estimate character components when no section info is available
  List<ContextComponentUsage> _estimateCharacterComponents(Character? character) {
    if (character == null) return [];

    final components = <ContextComponentUsage>[];

    if (character.systemPrompt.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: 'System Prompt',
        tokenCount: _tokenizerService.estimateTokenCount(character.systemPrompt),
      ));
    }

    if (character.description.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: 'Description',
        tokenCount: _tokenizerService.estimateTokenCount(character.description),
      ));
    }

    if (character.personality.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: 'Personality',
        tokenCount: _tokenizerService.estimateTokenCount(character.personality),
      ));
    }

    if (character.scenario.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: 'Scenario',
        tokenCount: _tokenizerService.estimateTokenCount(character.scenario),
      ));
    }

    if (character.exampleMessages.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: 'Example Messages',
        tokenCount: _tokenizerService.estimateTokenCount(character.exampleMessages),
      ));
    }

    if (character.postHistoryInstructions.isNotEmpty) {
      components.add(ContextComponentUsage(
        name: 'Post-History Instructions',
        tokenCount: _tokenizerService.estimateTokenCount(character.postHistoryInstructions),
      ));
    }

    return components;
  }

  /// Calculate world info tokens with detailed breakdown
  ContextComponentUsage _calculateWorldInfoTokens(List<WorldInfoEntry>? entries) {
    if (entries == null || entries.isEmpty) {
      return const ContextComponentUsage(name: 'World Info', tokenCount: 0);
    }

    final children = <ContextComponentUsage>[];
    int totalTokens = 0;

    // Group by world book if possible
    final groupedByBook = <String, List<WorldInfoEntry>>{};
    for (final entry in entries) {
      final bookName = entry.comment.isNotEmpty 
          ? entry.comment 
          : 'Entry ${entries.indexOf(entry) + 1}';
      if (!groupedByBook.containsKey(bookName)) {
        groupedByBook[bookName] = [];
      }
      groupedByBook[bookName]!.add(entry);
    }

    for (final entry in entries) {
      final tokens = _tokenizerService.estimateTokenCount(entry.content);
      final name = entry.comment.isNotEmpty 
          ? entry.comment 
          : (entry.keys.isNotEmpty 
              ? entry.keys.first 
              : 'Entry ${entries.indexOf(entry) + 1}');
      children.add(ContextComponentUsage(
        name: name,
        tokenCount: tokens,
      ));
      totalTokens += tokens;
    }

    return ContextComponentUsage(
      name: 'World Info (${entries.length} entries)',
      tokenCount: totalTokens,
      children: children.isNotEmpty ? children : null,
      icon: 'public',
    );
  }

  /// Calculate chat history tokens with breakdown
  ContextComponentUsage _calculateChatHistoryTokens(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return const ContextComponentUsage(name: 'Chat History', tokenCount: 0);
    }

    int userTokens = 0;
    int assistantTokens = 0;
    int userCount = 0;
    int assistantCount = 0;

    for (final message in messages) {
      final tokens = _tokenizerService.estimateTokenCount(message.content);
      if (message.role == MessageRole.user) {
        userTokens += tokens;
        userCount++;
      } else {
        assistantTokens += tokens;
        assistantCount++;
      }
    }

    final children = <ContextComponentUsage>[];

    if (userTokens > 0) {
      children.add(ContextComponentUsage(
        name: 'User ($userCount messages)',
        tokenCount: userTokens,
        icon: 'person_outline',
      ));
    }

    if (assistantTokens > 0) {
      children.add(ContextComponentUsage(
        name: 'Assistant ($assistantCount messages)',
        tokenCount: assistantTokens,
        icon: 'smart_toy',
      ));
    }

    return ContextComponentUsage(
      name: 'Chat History (${messages.length} messages)',
      tokenCount: userTokens + assistantTokens,
      children: children.isNotEmpty ? children : null,
      icon: 'chat',
    );
  }

  /// Get icon name for section type
  String _getSectionIcon(PromptSectionType type) {
    switch (type) {
      case PromptSectionType.systemPrompt:
        return 'terminal';
      case PromptSectionType.persona:
        return 'account_circle';
      case PromptSectionType.characterDescription:
        return 'description';
      case PromptSectionType.characterPersonality:
        return 'psychology';
      case PromptSectionType.characterScenario:
        return 'landscape';
      case PromptSectionType.exampleMessages:
        return 'format_quote';
      case PromptSectionType.worldInfo:
      case PromptSectionType.worldInfoAfter:
        return 'public';
      case PromptSectionType.authorNote:
        return 'edit_note';
      case PromptSectionType.postHistoryInstructions:
        return 'rule';
      case PromptSectionType.nsfw:
        return 'warning';
      case PromptSectionType.chatHistory:
        return 'chat';
      case PromptSectionType.enhanceDefinitions:
        return 'enhance';
      case PromptSectionType.custom:
        return 'tune';
    }
  }
}
