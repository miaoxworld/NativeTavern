import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// How characters take turns in group chats
/// Aligned with SillyTavern's group_activation_strategy
enum GroupActivationStrategy {
  /// Natural language processing determines who should respond
  natural,
  /// Characters respond in list order
  list,
  /// User manually selects who responds
  manual,
  /// Pool of characters, weighted random selection
  pooled,
}

/// How group generation works
/// Aligned with SillyTavern's group_generation_mode
enum GroupGenerationMode {
  /// Swap: Replace previous character's message
  swap,
  /// Append: Add to the conversation
  append,
  /// Append Disabled: Append but don't auto-continue
  appendDisabled,
}

/// Group chat model for multi-character conversations
@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    String? description,
    @Default([]) List<GroupMember> members,
    @Default(GroupSettings()) GroupSettings settings,
    String? avatarPath,
    required DateTime createdAt,
    required DateTime modifiedAt,
    
    // === New fields for SillyTavern compatibility ===
    
    /// Tags for organization
    @Default([]) List<String> tags,
    
    /// Whether this is a favorite group
    @Default(false) bool isFavorite,
    
    /// Creator notes (not sent to AI)
    @Default('') String creatorNotes,
    
    /// Group-specific world info/lorebook ID
    String? lorebookId,
    
    /// Group-specific scenario (overrides character scenarios)
    String? scenario,
    
    /// Group-specific first message
    String? firstMessage,
    
    /// Chat metadata for the current chat
    @Default({}) Map<String, dynamic> chatMetadata,
    
    /// Past chats metadata
    @Default([]) List<GroupChatInfo> pastChats,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

/// Extension methods for Group
extension GroupExtension on Group {
  /// Get active (non-muted) members
  List<GroupMember> get activeMembers => 
      members.where((m) => !m.isMuted).toList();
  
  /// Get members sorted by insertion order
  List<GroupMember> get sortedMembers {
    final sorted = List<GroupMember>.from(members);
    sorted.sort((a, b) => a.insertionOrder.compareTo(b.insertionOrder));
    return sorted;
  }
  
  /// Get active members sorted by insertion order
  List<GroupMember> get sortedActiveMembers {
    final sorted = activeMembers;
    sorted.sort((a, b) => a.insertionOrder.compareTo(b.insertionOrder));
    return sorted;
  }
}

/// Member in a group chat
@freezed
class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String characterId,
    @Default(false) bool isMuted,
    @Default(50) int talkativeness, // 0-100, affects selection probability
    @Default(100) int triggerProbability, // 0-100
    @Default([]) List<String> triggerWords, // Words that trigger this character
    @Default(0) int insertionOrder, // Order in the list
    
    // === New fields for SillyTavern compatibility ===
    
    /// Depth prompt for this member (inserted at specific depth)
    String? depthPrompt,
    
    /// Depth at which to insert the depth prompt
    @Default(4) int depthPromptDepth,
    
    /// Role for depth prompt (system, user, assistant)
    @Default(GroupMemberDepthRole.system) GroupMemberDepthRole depthPromptRole,
    
    /// Whether this member is currently active in the conversation
    @Default(true) bool isActive,
    
    /// Custom display name override
    String? displayNameOverride,
    
    /// Custom avatar override
    String? avatarOverride,
    
    /// Member-specific extensions data
    @Default({}) Map<String, dynamic> extensions,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) => _$GroupMemberFromJson(json);
}

/// Role for group member depth prompt
enum GroupMemberDepthRole {
  system,
  user,
  assistant,
}

/// Group chat settings
@freezed
class GroupSettings with _$GroupSettings {
  const factory GroupSettings({
    /// Activation strategy (how to select next speaker)
    @Default(GroupActivationStrategy.natural) GroupActivationStrategy activationStrategy,
    
    /// Generation mode (how to handle responses)
    @Default(GroupGenerationMode.swap) GroupGenerationMode generationMode,
    
    /// Delay between auto-responses in milliseconds
    @Default(5000) int autoModeDelay,
    
    /// Can a character respond to themselves
    @Default(false) bool allowSelfResponse,
    
    /// Hide disabled/muted members from UI
    @Default(true) bool hideDisabledMembers,
    
    /// Max responses per turn (0 = unlimited)
    @Default(1) int maxResponses,
    
    // === Legacy field mapping ===
    /// Response mode (legacy, maps to activationStrategy)
    @JsonKey(includeFromJson: false, includeToJson: false)
    GroupResponseMode? responseMode,
    
    // === New fields for SillyTavern compatibility ===
    
    /// Whether to auto-select next speaker
    @Default(true) bool autoSelectSpeaker,
    
    /// Whether to show character names in messages
    @Default(true) bool showCharacterNames,
    
    /// Whether to allow user to speak as characters
    @Default(true) bool allowUserAsCharacter,
    
    /// Minimum messages before same character can speak again
    @Default(0) int minMessagesBetweenSameSpeaker,
    
    /// Whether to use character-specific prompts
    @Default(true) bool useCharacterPrompts,
    
    /// Whether to merge consecutive messages from same character
    @Default(false) bool mergeConsecutiveMessages,
    
    /// Group-specific system prompt (prepended to character prompts)
    @Default('') String groupSystemPrompt,
    
    /// Whether to include group scenario in prompts
    @Default(true) bool includeGroupScenario,
    
    /// Whether to include member list in prompts
    @Default(true) bool includeMemberList,
    
    /// Format for member list
    @Default('{{char}} is present in this conversation.') String memberListFormat,
    
    /// Whether to favor triggered characters
    @Default(true) bool favorTriggeredCharacters,
    
    /// Weight multiplier for triggered characters
    @Default(2.0) double triggeredCharacterWeight,
  }) = _GroupSettings;

  factory GroupSettings.fromJson(Map<String, dynamic> json) => _$GroupSettingsFromJson(json);
}

/// Extension methods for GroupSettings
extension GroupSettingsExtension on GroupSettings {
  /// Convert legacy responseMode to activationStrategy
  GroupActivationStrategy get effectiveActivationStrategy {
    if (responseMode != null) {
      switch (responseMode!) {
        case GroupResponseMode.sequential:
          return GroupActivationStrategy.list;
        case GroupResponseMode.random:
          return GroupActivationStrategy.pooled;
        case GroupResponseMode.all:
          return GroupActivationStrategy.list;
        case GroupResponseMode.manual:
          return GroupActivationStrategy.manual;
        case GroupResponseMode.natural:
          return GroupActivationStrategy.natural;
      }
    }
    return activationStrategy;
  }
}

/// Legacy response mode enum (for backwards compatibility)
enum GroupResponseMode {
  /// Characters respond in order
  sequential,
  /// Random character responds (weighted by talkativeness)
  random,
  /// All characters respond each turn
  all,
  /// User manually selects who responds
  manual,
  /// Natural language processing determines who should respond
  natural,
}

/// Information about a past group chat
@freezed
class GroupChatInfo with _$GroupChatInfo {
  const factory GroupChatInfo({
    required String chatId,
    required String name,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    @Default(0) int messageCount,
    String? previewText,
  }) = _GroupChatInfo;

  factory GroupChatInfo.fromJson(Map<String, dynamic> json) => _$GroupChatInfoFromJson(json);
}

/// SillyTavern group export format
@freezed
class GroupExport with _$GroupExport {
  const factory GroupExport({
    required String id,
    required String name,
    String? description,
    @Default([]) List<String> members, // Character IDs/names
    @JsonKey(name: 'activation_strategy') @Default(0) int activationStrategy,
    @JsonKey(name: 'generation_mode') @Default(0) int generationMode,
    @JsonKey(name: 'disabled_members') @Default([]) List<String> disabledMembers,
    @JsonKey(name: 'chat_metadata') @Default({}) Map<String, dynamic> chatMetadata,
    @JsonKey(name: 'past_metadata') @Default({}) Map<String, dynamic> pastMetadata,
    @JsonKey(name: 'fav') @Default(false) bool fav,
    @JsonKey(name: 'chat_id') String? chatId,
    @JsonKey(name: 'chats') @Default([]) List<String> chats,
  }) = _GroupExport;

  factory GroupExport.fromJson(Map<String, dynamic> json) => _$GroupExportFromJson(json);
}

/// Convert Group to export format
GroupExport groupToExport(Group group) {
  return GroupExport(
    id: group.id,
    name: group.name,
    description: group.description,
    members: group.members.map((m) => m.characterId).toList(),
    activationStrategy: group.settings.activationStrategy.index,
    generationMode: group.settings.generationMode.index,
    disabledMembers: group.members
        .where((m) => m.isMuted)
        .map((m) => m.characterId)
        .toList(),
    chatMetadata: group.chatMetadata,
    fav: group.isFavorite,
    chats: group.pastChats.map((c) => c.chatId).toList(),
  );
}

/// Convert export format to Group
Group groupFromExport(GroupExport export) {
  final now = DateTime.now();
  
  // Parse activation strategy
  GroupActivationStrategy activationStrategy;
  if (export.activationStrategy >= 0 && 
      export.activationStrategy < GroupActivationStrategy.values.length) {
    activationStrategy = GroupActivationStrategy.values[export.activationStrategy];
  } else {
    activationStrategy = GroupActivationStrategy.natural;
  }
  
  // Parse generation mode
  GroupGenerationMode generationMode;
  if (export.generationMode >= 0 && 
      export.generationMode < GroupGenerationMode.values.length) {
    generationMode = GroupGenerationMode.values[export.generationMode];
  } else {
    generationMode = GroupGenerationMode.swap;
  }
  
  return Group(
    id: export.id,
    name: export.name,
    description: export.description,
    members: export.members.asMap().entries.map((entry) {
      final index = entry.key;
      final characterId = entry.value;
      return GroupMember(
        characterId: characterId,
        isMuted: export.disabledMembers.contains(characterId),
        insertionOrder: index,
      );
    }).toList(),
    settings: GroupSettings(
      activationStrategy: activationStrategy,
      generationMode: generationMode,
    ),
    isFavorite: export.fav,
    chatMetadata: export.chatMetadata,
    pastChats: export.chats.map((chatId) => GroupChatInfo(
      chatId: chatId,
      name: chatId,
      createdAt: now,
      lastMessageAt: now,
    )).toList(),
    createdAt: now,
    modifiedAt: now,
  );
}
