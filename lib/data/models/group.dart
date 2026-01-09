/// Group chat model for multi-character conversations
class Group {
  final String id;
  final String name;
  final String? description;
  final List<GroupMember> members;
  final GroupSettings settings;
  final String? avatarPath;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const Group({
    required this.id,
    required this.name,
    this.description,
    this.members = const [],
    this.settings = const GroupSettings(),
    this.avatarPath,
    required this.createdAt,
    required this.modifiedAt,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    List<GroupMember>? members,
    GroupSettings? settings,
    String? avatarPath,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      settings: settings ?? this.settings,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'members': members.map((m) => m.toJson()).toList(),
        'settings': settings.toJson(),
        'avatarPath': avatarPath,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt.toIso8601String(),
      };

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        members: (json['members'] as List<dynamic>?)
                ?.map((m) => GroupMember.fromJson(m as Map<String, dynamic>))
                .toList() ??
            [],
        settings: json['settings'] != null
            ? GroupSettings.fromJson(json['settings'] as Map<String, dynamic>)
            : const GroupSettings(),
        avatarPath: json['avatarPath'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      );

  /// Get active (non-muted) members
  List<GroupMember> get activeMembers => members.where((m) => !m.isMuted).toList();
}

/// Member in a group chat
class GroupMember {
  final String characterId;
  final bool isMuted;
  final int talkativeness; // 0-100, affects selection probability
  final int triggerProbability; // 0-100
  final List<String> triggerWords; // Words that trigger this character
  final int insertionOrder; // Order in the list

  const GroupMember({
    required this.characterId,
    this.isMuted = false,
    this.talkativeness = 50,
    this.triggerProbability = 100,
    this.triggerWords = const [],
    this.insertionOrder = 0,
  });

  GroupMember copyWith({
    String? characterId,
    bool? isMuted,
    int? talkativeness,
    int? triggerProbability,
    List<String>? triggerWords,
    int? insertionOrder,
  }) {
    return GroupMember(
      characterId: characterId ?? this.characterId,
      isMuted: isMuted ?? this.isMuted,
      talkativeness: talkativeness ?? this.talkativeness,
      triggerProbability: triggerProbability ?? this.triggerProbability,
      triggerWords: triggerWords ?? this.triggerWords,
      insertionOrder: insertionOrder ?? this.insertionOrder,
    );
  }

  Map<String, dynamic> toJson() => {
        'characterId': characterId,
        'isMuted': isMuted,
        'talkativeness': talkativeness,
        'triggerProbability': triggerProbability,
        'triggerWords': triggerWords,
        'insertionOrder': insertionOrder,
      };

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
        characterId: json['characterId'] as String,
        isMuted: json['isMuted'] as bool? ?? false,
        talkativeness: json['talkativeness'] as int? ?? 50,
        triggerProbability: json['triggerProbability'] as int? ?? 100,
        triggerWords: (json['triggerWords'] as List<dynamic>?)?.cast<String>() ?? [],
        insertionOrder: json['insertionOrder'] as int? ?? 0,
      );
}

/// Group chat settings
class GroupSettings {
  final GroupResponseMode responseMode;
  final int autoModeDelay; // Milliseconds between auto-responses
  final bool allowSelfResponse; // Can a character respond to themselves
  final bool hideDisabledMembers;
  final int maxResponses; // Max responses per turn (0 = unlimited)

  const GroupSettings({
    this.responseMode = GroupResponseMode.sequential,
    this.autoModeDelay = 5000,
    this.allowSelfResponse = false,
    this.hideDisabledMembers = true,
    this.maxResponses = 1,
  });

  GroupSettings copyWith({
    GroupResponseMode? responseMode,
    int? autoModeDelay,
    bool? allowSelfResponse,
    bool? hideDisabledMembers,
    int? maxResponses,
  }) {
    return GroupSettings(
      responseMode: responseMode ?? this.responseMode,
      autoModeDelay: autoModeDelay ?? this.autoModeDelay,
      allowSelfResponse: allowSelfResponse ?? this.allowSelfResponse,
      hideDisabledMembers: hideDisabledMembers ?? this.hideDisabledMembers,
      maxResponses: maxResponses ?? this.maxResponses,
    );
  }

  Map<String, dynamic> toJson() => {
        'responseMode': responseMode.name,
        'autoModeDelay': autoModeDelay,
        'allowSelfResponse': allowSelfResponse,
        'hideDisabledMembers': hideDisabledMembers,
        'maxResponses': maxResponses,
      };

  factory GroupSettings.fromJson(Map<String, dynamic> json) => GroupSettings(
        responseMode: GroupResponseMode.values.firstWhere(
          (m) => m.name == json['responseMode'],
          orElse: () => GroupResponseMode.sequential,
        ),
        autoModeDelay: json['autoModeDelay'] as int? ?? 5000,
        allowSelfResponse: json['allowSelfResponse'] as bool? ?? false,
        hideDisabledMembers: json['hideDisabledMembers'] as bool? ?? true,
        maxResponses: json['maxResponses'] as int? ?? 1,
      );
}

/// How characters take turns in group chats
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