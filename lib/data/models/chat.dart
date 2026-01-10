/// Chat session model
class Chat {
  final String id;
  final String characterId;
  final String? groupId; // For group chats
  final String title;
  final String authorNote; // Author's Note content
  final int authorNoteDepth; // Depth for injection (messages from end)
  final bool authorNoteEnabled; // Whether Author's Note is active
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.characterId,
    this.groupId,
    required this.title,
    this.authorNote = '',
    this.authorNoteDepth = 4,
    this.authorNoteEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if this is a group chat
  bool get isGroupChat => groupId != null;

  Chat copyWith({
    String? id,
    String? characterId,
    String? groupId,
    bool clearGroupId = false,
    String? title,
    String? authorNote,
    int? authorNoteDepth,
    bool? authorNoteEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      groupId: clearGroupId ? null : (groupId ?? this.groupId),
      title: title ?? this.title,
      authorNote: authorNote ?? this.authorNote,
      authorNoteDepth: authorNoteDepth ?? this.authorNoteDepth,
      authorNoteEnabled: authorNoteEnabled ?? this.authorNoteEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'characterId': characterId,
        'groupId': groupId,
        'title': title,
        'authorNote': authorNote,
        'authorNoteDepth': authorNoteDepth,
        'authorNoteEnabled': authorNoteEnabled,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'] as String,
        characterId: json['characterId'] as String,
        groupId: json['groupId'] as String?,
        title: json['title'] as String? ?? 'New Chat',
        authorNote: json['authorNote'] as String? ?? '',
        authorNoteDepth: json['authorNoteDepth'] as int? ?? 4,
        authorNoteEnabled: json['authorNoteEnabled'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

/// Message role enum
enum MessageRole {
  user,
  assistant,
  system,
}

/// Image attachment for chat messages
class ChatAttachment {
  final String id;
  final String path; // Local file path
  final String? mimeType;
  final int? width;
  final int? height;
  final int? sizeBytes;

  const ChatAttachment({
    required this.id,
    required this.path,
    this.mimeType,
    this.width,
    this.height,
    this.sizeBytes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    if (mimeType != null) 'mimeType': mimeType,
    if (width != null) 'width': width,
    if (height != null) 'height': height,
    if (sizeBytes != null) 'sizeBytes': sizeBytes,
  };

  factory ChatAttachment.fromJson(Map<String, dynamic> json) => ChatAttachment(
    id: json['id'] as String,
    path: json['path'] as String,
    mimeType: json['mimeType'] as String?,
    width: json['width'] as int?,
    height: json['height'] as int?,
    sizeBytes: json['sizeBytes'] as int?,
  );
}

/// Chat message model
class ChatMessage {
  final String id;
  final String chatId;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final List<String> swipes;
  final int currentSwipeIndex;
  final String? characterId; // For group chats - which character sent this message
  final String? characterName; // Cached character name for display
  final String? reasoning; // Chain of Thought / Thinking content from LLM
  final List<String>? reasoningSwipes; // Reasoning content for each swipe
  final List<ChatAttachment> attachments; // Image attachments

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    required this.timestamp,
    this.swipes = const [],
    this.currentSwipeIndex = 0,
    this.characterId,
    this.characterName,
    this.reasoning,
    this.reasoningSwipes,
    this.attachments = const [],
  });

  /// Get the current reasoning content (for current swipe)
  String? get currentReasoning {
    if (reasoningSwipes != null &&
        currentSwipeIndex >= 0 &&
        currentSwipeIndex < reasoningSwipes!.length) {
      return reasoningSwipes![currentSwipeIndex];
    }
    return reasoning;
  }

  /// Check if this message has reasoning/thinking content
  bool get hasReasoning =>
      (reasoning != null && reasoning!.isNotEmpty) ||
      (reasoningSwipes != null && reasoningSwipes!.any((r) => r.isNotEmpty));

  /// Check if this message has image attachments
  bool get hasAttachments => attachments.isNotEmpty;

  ChatMessage copyWith({
    String? id,
    String? chatId,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
    List<String>? swipes,
    int? currentSwipeIndex,
    String? characterId,
    String? characterName,
    String? reasoning,
    List<String>? reasoningSwipes,
    List<ChatAttachment>? attachments,
    bool clearCharacterId = false,
    bool clearCharacterName = false,
    bool clearReasoning = false,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      swipes: swipes ?? this.swipes,
      currentSwipeIndex: currentSwipeIndex ?? this.currentSwipeIndex,
      characterId: clearCharacterId ? null : (characterId ?? this.characterId),
      characterName: clearCharacterName ? null : (characterName ?? this.characterName),
      reasoning: clearReasoning ? null : (reasoning ?? this.reasoning),
      reasoningSwipes: clearReasoning ? null : (reasoningSwipes ?? this.reasoningSwipes),
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'role': role.name,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'swipes': swipes,
        'currentSwipeIndex': currentSwipeIndex,
        'characterId': characterId,
        'characterName': characterName,
        if (reasoning != null) 'reasoning': reasoning,
        if (reasoningSwipes != null) 'reasoningSwipes': reasoningSwipes,
        if (attachments.isNotEmpty) 'attachments': attachments.map((a) => a.toJson()).toList(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        chatId: json['chatId'] as String,
        role: MessageRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => MessageRole.user,
        ),
        content: json['content'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        swipes: (json['swipes'] as List<dynamic>?)?.cast<String>() ?? [],
        currentSwipeIndex: json['currentSwipeIndex'] as int? ?? 0,
        characterId: json['characterId'] as String?,
        characterName: json['characterName'] as String?,
        reasoning: json['reasoning'] as String?,
        reasoningSwipes: (json['reasoningSwipes'] as List<dynamic>?)?.cast<String>(),
        attachments: (json['attachments'] as List<dynamic>?)
            ?.map((a) => ChatAttachment.fromJson(a as Map<String, dynamic>))
            .toList() ?? [],
      );
}