/// Bookmark model for chat checkpoints/branching
class Bookmark {
  final String id;
  final String chatId;
  final String name;
  final String? description;
  final String messageId; // The message this bookmark points to
  final int messageIndex; // Index in the chat at time of creation
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.chatId,
    required this.name,
    this.description,
    required this.messageId,
    required this.messageIndex,
    required this.createdAt,
  });

  Bookmark copyWith({
    String? id,
    String? chatId,
    String? name,
    String? description,
    bool clearDescription = false,
    String? messageId,
    int? messageIndex,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      messageId: messageId ?? this.messageId,
      messageIndex: messageIndex ?? this.messageIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chatId': chatId,
        'name': name,
        'description': description,
        'messageId': messageId,
        'messageIndex': messageIndex,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['id'] as String,
        chatId: json['chatId'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        messageId: json['messageId'] as String,
        messageIndex: json['messageIndex'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Branch represents a chat state from a bookmark
/// Used for branching/navigating between different chat paths
class ChatBranch {
  final Bookmark bookmark;
  final List<String> messageIds; // Messages up to and including the bookmark point
  final bool isActive;

  const ChatBranch({
    required this.bookmark,
    required this.messageIds,
    this.isActive = false,
  });

  ChatBranch copyWith({
    Bookmark? bookmark,
    List<String>? messageIds,
    bool? isActive,
  }) {
    return ChatBranch(
      bookmark: bookmark ?? this.bookmark,
      messageIds: messageIds ?? this.messageIds,
      isActive: isActive ?? this.isActive,
    );
  }
}