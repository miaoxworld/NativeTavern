import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/domain/services/context_usage_service.dart';
import 'package:native_tavern/domain/services/tokenizer_service.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/prompt_manager_providers.dart';
import 'package:native_tavern/presentation/providers/world_info_providers.dart';

/// Provider for context usage service
final contextUsageServiceProvider = Provider<ContextUsageService>((ref) {
  final tokenizerService = TokenizerService();
  return ContextUsageService(tokenizerService);
});

/// Cached context usage to preserve value during generation
ContextUsage? _cachedContextUsage;

/// Cached world info entries to preserve value during generation
List<WorldInfoEntry>? _cachedWorldInfoEntries;

/// Cached detailed context usage to preserve value during generation
ContextUsage? _cachedDetailedContextUsage;

/// Clear all context usage caches
/// Call this when entering chat screen to ensure fresh calculation
void clearContextUsageCache() {
  _cachedContextUsage = null;
  _cachedWorldInfoEntries = null;
  _cachedDetailedContextUsage = null;
}

/// Refresh context usage providers
/// Call this when entering chat screen or when world info changes
void refreshContextUsageProviders(WidgetRef ref) {
  // Clear caches first
  clearContextUsageCache();
  // Invalidate the providers to trigger recalculation
  ref.invalidate(matchedWorldInfoEntriesProvider);
  ref.invalidate(detailedContextUsageProvider);
}

/// Provider for matched world info entries in current chat
/// This calculates which world info entries would be included in the context
/// During generation (isGenerating = true), returns cached value to avoid expensive recalculation
final matchedWorldInfoEntriesProvider = FutureProvider<List<WorldInfoEntry>>((ref) async {
  final chatState = ref.watch(activeChatProvider);
  
  // Skip recalculation during generation, return cached value
  if (chatState.isGenerating) {
    return _cachedWorldInfoEntries ?? [];
  }
  
  final worldInfoMatcher = ref.watch(worldInfoMatcherProvider);
  final activeWorldInfoIds = ref.watch(activeWorldInfoIdsProvider);
  // Use worldInfoNotifierProvider instead of allWorldInfosProvider
  // This ensures updates (including enabled/disabled toggle) trigger recalculation
  final worldInfosAsync = ref.watch(worldInfoNotifierProvider);
  
  // Handle loading/error states
  final allWorldInfos = worldInfosAsync.valueOrNull ?? [];

  if (chatState.character == null) {
    _cachedWorldInfoEntries = [];
    return [];
  }

  final character = chatState.character!;
  final messages = chatState.messages;

  // Build context text from messages for keyword matching
  final contextText = messages.map((m) => m.content).join('\n');

  // Get enabled world info IDs (same logic as in chat_providers.dart)
  final enabledWorldInfoIds = allWorldInfos
      .where((w) => w.enabled && (
          w.isGlobal ||
          w.characterId == character.id ||
          w.characterId == null ||  // Not linked to any character = available to all
          activeWorldInfoIds.contains(w.id)
      ))
      .map((w) => w.id)
      .toList();

  final allWorldInfoIds = <String>{...enabledWorldInfoIds, ...activeWorldInfoIds}.toList();

  if (allWorldInfoIds.isEmpty) {
    _cachedWorldInfoEntries = [];
    return [];
  }

  // Find matching entries
  final matchedEntries = await worldInfoMatcher.findMatchingEntries(
    contextText: contextText,
    worldInfoIds: allWorldInfoIds,
  );

  // Cache the result
  _cachedWorldInfoEntries = matchedEntries;
  return matchedEntries;
});

/// Provider for quick context usage estimation
/// Only recalculates when not generating (data has been finalized)
/// During generation, returns cached value to avoid performance impact
final contextUsageProvider = Provider<ContextUsage?>((ref) {
  final chatState = ref.watch(activeChatProvider);
  
  // Skip recalculation during generation, return cached value
  if (chatState.isGenerating) {
    return _cachedContextUsage;
  }
  
  final llmConfig = ref.watch(llmConfigProvider);
  final activePersona = ref.watch(activePersonaProvider);
  final promptConfig = ref.watch(promptManagerProvider);
  final service = ref.watch(contextUsageServiceProvider);
  // Watch matched world info (async value)
  final worldInfoAsync = ref.watch(matchedWorldInfoEntriesProvider);

  if (chatState.chat == null) {
    _cachedContextUsage = null;
    return null;
  }

  final persona = activePersona.valueOrNull;
  final worldInfoEntries = worldInfoAsync.valueOrNull ?? [];

  final usage = service.quickEstimate(
    chat: chatState.chat,
    character: chatState.character,
    persona: persona,
    messages: chatState.messages,
    maxContext: llmConfig.contextLength,
    enabledSections: promptConfig.enabledSections,
    worldInfoEntries: worldInfoEntries,
  );
  
  // Cache the result
  _cachedContextUsage = usage;
  return usage;
});

/// Provider for detailed context usage (async, more accurate)
/// Only recalculates when not generating (data has been finalized)
/// During generation, returns cached value
final detailedContextUsageProvider = FutureProvider<ContextUsage?>((ref) async {
  final chatState = ref.watch(activeChatProvider);
  
  // Skip recalculation during generation, return cached value
  if (chatState.isGenerating) {
    return _cachedDetailedContextUsage;
  }
  
  final llmConfig = ref.watch(llmConfigProvider);
  final activePersona = await ref.watch(activePersonaProvider.future);
  final promptConfig = ref.watch(promptManagerProvider);
  final service = ref.watch(contextUsageServiceProvider);
  final worldInfoEntries = await ref.watch(matchedWorldInfoEntriesProvider.future);

  if (chatState.chat == null) {
    _cachedDetailedContextUsage = null;
    return null;
  }

  final usage = service.calculateDetailedUsage(
    chat: chatState.chat,
    character: chatState.character,
    persona: activePersona,
    messages: chatState.messages,
    maxContext: llmConfig.contextLength,
    enabledSections: promptConfig.enabledSections,
    worldInfoEntries: worldInfoEntries,
  );
  
  // Cache the result
  _cachedDetailedContextUsage = usage;
  return usage;
});
