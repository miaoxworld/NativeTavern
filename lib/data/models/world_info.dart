import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_info.freezed.dart';
part 'world_info.g.dart';

/// Role for World Info entry message
enum WorldInfoRole {
  @JsonValue(0)
  system,
  @JsonValue(1)
  user,
  @JsonValue(2)
  assistant,
}

/// Character filter type for World Info entry
enum WorldInfoCharacterFilterType {
  /// No filter - entry applies to all characters
  none,
  /// Include only specified characters
  include,
  /// Exclude specified characters
  exclude,
}

/// Character filter for World Info entry
@freezed
class WorldInfoCharacterFilter with _$WorldInfoCharacterFilter {
  const factory WorldInfoCharacterFilter({
    @Default(WorldInfoCharacterFilterType.none)
    WorldInfoCharacterFilterType type,
    /// List of character IDs to include/exclude
    @Default([]) List<String> characterIds,
    /// List of tag names to include/exclude
    @Default([]) List<String> tags,
  }) = _WorldInfoCharacterFilter;

  factory WorldInfoCharacterFilter.fromJson(Map<String, dynamic> json) =>
      _$WorldInfoCharacterFilterFromJson(json);
}

/// Timed effects for World Info entry
/// Controls sticky, cooldown, and delay behavior
@freezed
class WorldInfoTimedEffects with _$WorldInfoTimedEffects {
  const factory WorldInfoTimedEffects({
    /// Sticky duration - entry stays active for N messages after trigger
    /// 0 = not sticky (default)
    @Default(0) int sticky,
    
    /// Cooldown duration - entry cannot trigger again for N messages
    /// 0 = no cooldown (default)
    @Default(0) int cooldown,
    
    /// Delay - entry only triggers after N messages since chat start
    /// 0 = no delay (default)
    @Default(0) int delay,
    
    // === Runtime state (not persisted) ===
    
    /// Current sticky counter (decrements each message)
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0) int stickyCounter,
    
    /// Current cooldown counter (decrements each message)
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(0) int cooldownCounter,
    
    /// Whether entry is currently active due to sticky
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false) bool isSticky,
    
    /// Whether entry is currently on cooldown
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false) bool isOnCooldown,
  }) = _WorldInfoTimedEffects;

  factory WorldInfoTimedEffects.fromJson(Map<String, dynamic> json) =>
      _$WorldInfoTimedEffectsFromJson(json);
}

/// World Info / Lorebook model
/// Compatible with SillyTavern's world info format
@freezed
class WorldInfo with _$WorldInfo {
  const factory WorldInfo({
    required String id,
    required String name,
    String? description,
    @Default([]) List<WorldInfoEntry> entries,
    @Default(true) bool enabled,
    @Default(false) bool isGlobal,
    String? characterId, // If bound to a specific character
    required DateTime createdAt,
    required DateTime modifiedAt,
    
    // === New fields for SillyTavern compatibility ===
    
    /// Default scan depth for entries (can be overridden per entry)
    @Default(4) int defaultScanDepth,
    
    /// Whether to use recursive scanning
    @Default(true) bool recursiveScanning,
    
    /// Maximum recursion depth
    @Default(3) int maxRecursionDepth,
    
    /// Whether entries can trigger other entries
    @Default(true) bool allowEntryCascade,
    
    /// Tags for organization
    @Default([]) List<String> tags,
    
    /// Creator notes (not sent to AI)
    @Default('') String creatorNotes,
  }) = _WorldInfo;

  factory WorldInfo.fromJson(Map<String, dynamic> json) => _$WorldInfoFromJson(json);
}

/// World Info Entry
@freezed
class WorldInfoEntry with _$WorldInfoEntry {
  const factory WorldInfoEntry({
    required String id,
    required String worldInfoId,
    @Default([]) List<String> keys,
    @Default([]) List<String> secondaryKeys,
    @Default('') String content,
    @Default('') String comment,
    @Default(true) bool enabled,
    @Default(false) bool constant, // Always included
    @Default(false) bool selective, // Requires secondary key
    @Default(0) int insertionOrder,
    @Default(false) bool caseSensitive,
    @Default(false) bool matchWholeWords,
    @Default(false) bool useGroupScoring,
    @Default(false) bool automationId,
    @Default(0) int probability, // 0-100, 0 = always trigger
    @Default(WorldInfoPosition.before) WorldInfoPosition position,
    @Default(0) int depth, // For depth-based insertion
    String? group, // Grouping for mutual exclusivity
    @Default(0) int groupWeight,
    @Default(false) bool preventRecursion,
    @Default(false) bool delayUntilRecursion,
    @Default(0) int scanDepth,
    @Default({}) Map<String, dynamic> extensions,
    
    // === New fields for SillyTavern compatibility ===
    
    /// Role for this entry's content (system, user, assistant)
    @Default(WorldInfoRole.system) WorldInfoRole role,
    
    /// Timed effects (sticky, cooldown, delay)
    @Default(WorldInfoTimedEffects()) WorldInfoTimedEffects timedEffects,
    
    /// Character filter - which characters this entry applies to
    @Default(WorldInfoCharacterFilter()) WorldInfoCharacterFilter characterFilter,
    
    /// Group override - priority within group (higher = more priority)
    @Default(0) int groupOverride,
    
    /// Whether to exclude from recursion scanning
    @Default(false) bool excludeRecursion,
    
    /// Whether probability is used (if false, always triggers when matched)
    @Default(false) bool useProbability,
    
    /// Vectorized content for semantic search
    String? vectorized,
    
    /// Display index for UI ordering
    @Default(0) int displayIndex,
    
    /// Whether entry is favorited
    @Default(false) bool isFavorite,
  }) = _WorldInfoEntry;

  factory WorldInfoEntry.fromJson(Map<String, dynamic> json) => _$WorldInfoEntryFromJson(json);
}

/// Extension methods for WorldInfoEntry
extension WorldInfoEntryExtension on WorldInfoEntry {
  /// Check if entry should trigger based on probability
  bool shouldTriggerByProbability() {
    if (!useProbability || probability <= 0) return true;
    if (probability >= 100) return true;
    return (DateTime.now().millisecondsSinceEpoch % 100) < probability;
  }
  
  /// Check if entry applies to a specific character
  bool appliesToCharacter(String characterId, List<String> characterTags) {
    switch (characterFilter.type) {
      case WorldInfoCharacterFilterType.none:
        return true;
      case WorldInfoCharacterFilterType.include:
        // Check if character ID is in the include list
        if (characterFilter.characterIds.contains(characterId)) return true;
        // Check if any character tag matches
        return characterFilter.tags.any((tag) => characterTags.contains(tag));
      case WorldInfoCharacterFilterType.exclude:
        // Check if character ID is in the exclude list
        if (characterFilter.characterIds.contains(characterId)) return false;
        // Check if any character tag matches
        if (characterFilter.tags.any((tag) => characterTags.contains(tag))) return false;
        return true;
    }
  }
  
  /// Check if entry is currently available (not on cooldown, delay met)
  bool isAvailable(int messageCount) {
    // Check delay
    if (timedEffects.delay > 0 && messageCount < timedEffects.delay) {
      return false;
    }
    // Check cooldown
    if (timedEffects.isOnCooldown) {
      return false;
    }
    return true;
  }
  
  /// Check if entry is currently sticky (should be included regardless of trigger)
  bool get isCurrentlySticky => timedEffects.isSticky && timedEffects.stickyCounter > 0;
}

/// World Info insertion position
/// Matches SillyTavern's world_info_position exactly
enum WorldInfoPosition {
  @JsonValue(0)
  before,         // ↑Char - Before Character Definition (also: beforeCharDefs)
  @JsonValue(1)
  after,          // ↓Char - After Character Definition (also: afterCharDefs)
  @JsonValue(2)
  ANTop,          // ↑AT - Before Author's Note (also: beforeAuthorNote)
  @JsonValue(3)
  ANBottom,       // ↓AT - After Author's Note (also: afterAuthorNote)
  @JsonValue(4)
  atDepth,        // @D - At specific depth in chat history
  @JsonValue(5)
  EMTop,          // ↑EM - Before Example Messages (also: beforeExample)
  @JsonValue(6)
  EMBottom,       // ↓EM - After Example Messages (also: afterExample)
  @JsonValue(7)
  outlet,         // Outlet - Named outlet for insertion
}

// Backwards compatibility - static getters for old names
// These are used internally in NativeTavern for prompt building
class WorldInfoPositionAlias {
  static const WorldInfoPosition beforeCharDefs = WorldInfoPosition.before;
  static const WorldInfoPosition afterCharDefs = WorldInfoPosition.after;
  static const WorldInfoPosition beforeAuthorNote = WorldInfoPosition.ANTop;
  static const WorldInfoPosition afterAuthorNote = WorldInfoPosition.ANBottom;
  static const WorldInfoPosition beforeExample = WorldInfoPosition.EMTop;
  static const WorldInfoPosition afterExample = WorldInfoPosition.EMBottom;
  // Additional positions used in prompt building (map to closest equivalent)
  static const WorldInfoPosition beforeSystemPrompt = WorldInfoPosition.before;
  static const WorldInfoPosition afterSystemPrompt = WorldInfoPosition.after;
}

/// World Info export format for SillyTavern compatibility
@freezed
class WorldInfoExport with _$WorldInfoExport {
  const factory WorldInfoExport({
    required Map<String, WorldInfoEntryExport> entries,
  }) = _WorldInfoExport;

  factory WorldInfoExport.fromJson(Map<String, dynamic> json) => _$WorldInfoExportFromJson(json);
}

@freezed
class WorldInfoEntryExport with _$WorldInfoEntryExport {
  const factory WorldInfoEntryExport({
    required int uid,
    required List<String> key,
    @JsonKey(name: 'keysecondary') @Default([]) List<String> keySecondary,
    required String content,
    @Default('') String comment,
    @Default(false) bool selective,
    @Default(false) bool constant,
    @Default(0) int order,
    @Default(0) int position,
    @Default(false) bool disable,
    @Default(false) bool excludeRecursion,
    @Default(false) bool preventRecursion,
    @Default(false) bool delayUntilRecursion,
    @Default(0) int probability,
    @Default(false) bool useProbability,
    @Default(4) int depth,
    @Default('') String group,
    @Default(100) int groupOverride,
    @Default(false) bool groupWeight,
    @Default(0) int scanDepth,
    @Default(false) bool caseSensitive,
    @Default(false) bool matchWholeWords,
    @Default(false) bool useGroupScoring,
    @Default('') String automationId,
    @Default('') String role,
    @Default('') String vectorized,
    @Default({}) Map<String, dynamic> extensions,
    // Timed effects
    @Default(0) int sticky,
    @Default(0) int cooldown,
    @Default(0) int delay,
    // Character filter
    @JsonKey(name: 'character_filter') Map<String, dynamic>? characterFilter,
  }) = _WorldInfoEntryExport;

  factory WorldInfoEntryExport.fromJson(Map<String, dynamic> json) => _$WorldInfoEntryExportFromJson(json);
}

/// Helper class for managing World Info timed effects state
class WorldInfoTimedEffectsManager {
  final Map<String, WorldInfoTimedEffects> _entryStates = {};
  
  /// Get current state for an entry
  WorldInfoTimedEffects getState(String entryId, WorldInfoTimedEffects defaults) {
    return _entryStates[entryId] ?? defaults;
  }
  
  /// Update state after entry triggers
  void onEntryTriggered(String entryId, WorldInfoTimedEffects config) {
    final current = _entryStates[entryId] ?? config;
    _entryStates[entryId] = current.copyWith(
      stickyCounter: config.sticky,
      isSticky: config.sticky > 0,
      cooldownCounter: config.cooldown,
      isOnCooldown: config.cooldown > 0,
    );
  }
  
  /// Update all states after a message is processed
  void onMessageProcessed() {
    for (final entryId in _entryStates.keys.toList()) {
      final state = _entryStates[entryId]!;
      
      // Decrement sticky counter
      int newStickyCounter = state.stickyCounter > 0 ? state.stickyCounter - 1 : 0;
      bool newIsSticky = newStickyCounter > 0;
      
      // Decrement cooldown counter
      int newCooldownCounter = state.cooldownCounter > 0 ? state.cooldownCounter - 1 : 0;
      bool newIsOnCooldown = newCooldownCounter > 0;
      
      _entryStates[entryId] = state.copyWith(
        stickyCounter: newStickyCounter,
        isSticky: newIsSticky,
        cooldownCounter: newCooldownCounter,
        isOnCooldown: newIsOnCooldown,
      );
      
      // Remove entry from tracking if no active effects
      if (!newIsSticky && !newIsOnCooldown) {
        _entryStates.remove(entryId);
      }
    }
  }
  
  /// Check if entry is currently sticky
  bool isSticky(String entryId) {
    return _entryStates[entryId]?.isSticky ?? false;
  }
  
  /// Check if entry is on cooldown
  bool isOnCooldown(String entryId) {
    return _entryStates[entryId]?.isOnCooldown ?? false;
  }
  
  /// Reset all states
  void reset() {
    _entryStates.clear();
  }
}

/// Convert WorldInfoEntry to export format
WorldInfoEntryExport worldInfoEntryToExport(WorldInfoEntry entry, int uid) {
  return WorldInfoEntryExport(
    uid: uid,
    key: entry.keys,
    keySecondary: entry.secondaryKeys,
    content: entry.content,
    comment: entry.comment,
    selective: entry.selective,
    constant: entry.constant,
    order: entry.insertionOrder,
    position: entry.position.index,
    disable: !entry.enabled,
    excludeRecursion: entry.excludeRecursion,
    preventRecursion: entry.preventRecursion,
    delayUntilRecursion: entry.delayUntilRecursion,
    probability: entry.probability,
    useProbability: entry.useProbability,
    depth: entry.depth,
    group: entry.group ?? '',
    groupOverride: entry.groupOverride,
    groupWeight: entry.groupWeight > 0,
    scanDepth: entry.scanDepth,
    caseSensitive: entry.caseSensitive,
    matchWholeWords: entry.matchWholeWords,
    useGroupScoring: entry.useGroupScoring,
    automationId: entry.automationId ? entry.id : '',
    role: entry.role.index.toString(),
    vectorized: entry.vectorized ?? '',
    extensions: entry.extensions,
    sticky: entry.timedEffects.sticky,
    cooldown: entry.timedEffects.cooldown,
    delay: entry.timedEffects.delay,
    characterFilter: entry.characterFilter.type != WorldInfoCharacterFilterType.none
        ? {
            'type': entry.characterFilter.type.name,
            'characterIds': entry.characterFilter.characterIds,
            'tags': entry.characterFilter.tags,
          }
        : null,
  );
}

/// Convert export format to WorldInfoEntry
WorldInfoEntry worldInfoEntryFromExport(
  WorldInfoEntryExport export,
  String worldInfoId,
  String entryId,
) {
  // Parse role
  WorldInfoRole role = WorldInfoRole.system;
  if (export.role.isNotEmpty) {
    final roleIndex = int.tryParse(export.role);
    if (roleIndex != null && roleIndex >= 0 && roleIndex < WorldInfoRole.values.length) {
      role = WorldInfoRole.values[roleIndex];
    }
  }
  
  // Parse character filter
  WorldInfoCharacterFilter characterFilter = const WorldInfoCharacterFilter();
  if (export.characterFilter != null) {
    final filterType = export.characterFilter!['type'] as String?;
    characterFilter = WorldInfoCharacterFilter(
      type: filterType == 'include'
          ? WorldInfoCharacterFilterType.include
          : filterType == 'exclude'
              ? WorldInfoCharacterFilterType.exclude
              : WorldInfoCharacterFilterType.none,
      characterIds: List<String>.from(export.characterFilter!['characterIds'] ?? []),
      tags: List<String>.from(export.characterFilter!['tags'] ?? []),
    );
  }
  
  return WorldInfoEntry(
    id: entryId,
    worldInfoId: worldInfoId,
    keys: export.key,
    secondaryKeys: export.keySecondary,
    content: export.content,
    comment: export.comment,
    enabled: !export.disable,
    constant: export.constant,
    selective: export.selective,
    insertionOrder: export.order,
    position: WorldInfoPosition.values[export.position.clamp(0, WorldInfoPosition.values.length - 1)],
    depth: export.depth,
    probability: export.probability,
    useProbability: export.useProbability,
    group: export.group.isEmpty ? null : export.group,
    groupWeight: export.groupWeight ? 1 : 0,
    groupOverride: export.groupOverride,
    scanDepth: export.scanDepth,
    caseSensitive: export.caseSensitive,
    matchWholeWords: export.matchWholeWords,
    useGroupScoring: export.useGroupScoring,
    automationId: export.automationId.isNotEmpty,
    preventRecursion: export.preventRecursion,
    excludeRecursion: export.excludeRecursion,
    delayUntilRecursion: export.delayUntilRecursion,
    role: role,
    vectorized: export.vectorized.isEmpty ? null : export.vectorized,
    extensions: export.extensions,
    timedEffects: WorldInfoTimedEffects(
      sticky: export.sticky,
      cooldown: export.cooldown,
      delay: export.delay,
    ),
    characterFilter: characterFilter,
  );
}
