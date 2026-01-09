import 'dart:convert';

/// A quick reply button that can be used to quickly send predefined messages
class QuickReply {
  final String id;
  final String label;
  final String message;
  final bool enabled;
  final int order;
  final bool autoSend; // If true, sends immediately; if false, fills input field

  const QuickReply({
    required this.id,
    required this.label,
    required this.message,
    this.enabled = true,
    this.order = 0,
    this.autoSend = true,
  });

  QuickReply copyWith({
    String? id,
    String? label,
    String? message,
    bool? enabled,
    int? order,
    bool? autoSend,
  }) {
    return QuickReply(
      id: id ?? this.id,
      label: label ?? this.label,
      message: message ?? this.message,
      enabled: enabled ?? this.enabled,
      order: order ?? this.order,
      autoSend: autoSend ?? this.autoSend,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'message': message,
      'enabled': enabled,
      'order': order,
      'autoSend': autoSend,
    };
  }

  factory QuickReply.fromJson(Map<String, dynamic> json) {
    return QuickReply(
      id: json['id'] as String,
      label: json['label'] as String,
      message: json['message'] as String,
      enabled: json['enabled'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
      autoSend: json['autoSend'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuickReply && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Configuration for quick replies
class QuickReplyConfig {
  final List<QuickReply> replies;
  final bool showQuickReplies;
  final bool showAboveInput; // If true, shows above input; if false, shows below

  const QuickReplyConfig({
    this.replies = const [],
    this.showQuickReplies = true,
    this.showAboveInput = true,
  });

  /// Default quick replies
  static QuickReplyConfig get defaultConfig {
    return const QuickReplyConfig(
      replies: [
        QuickReply(
          id: 'continue',
          label: 'Continue',
          message: '',
          order: 0,
          autoSend: true,
        ),
        QuickReply(
          id: 'yes',
          label: 'Yes',
          message: 'Yes',
          order: 1,
          autoSend: true,
        ),
        QuickReply(
          id: 'no',
          label: 'No',
          message: 'No',
          order: 2,
          autoSend: true,
        ),
        QuickReply(
          id: 'okay',
          label: 'Okay',
          message: 'Okay',
          order: 3,
          autoSend: true,
        ),
        QuickReply(
          id: 'describe',
          label: 'Describe',
          message: '*{{user}} looks around, taking in the surroundings*',
          order: 4,
          autoSend: true,
        ),
        QuickReply(
          id: 'think',
          label: 'Think',
          message: '*{{user}} pauses to think*',
          order: 5,
          autoSend: true,
        ),
      ],
      showQuickReplies: true,
      showAboveInput: true,
    );
  }

  QuickReplyConfig copyWith({
    List<QuickReply>? replies,
    bool? showQuickReplies,
    bool? showAboveInput,
  }) {
    return QuickReplyConfig(
      replies: replies ?? this.replies,
      showQuickReplies: showQuickReplies ?? this.showQuickReplies,
      showAboveInput: showAboveInput ?? this.showAboveInput,
    );
  }

  /// Get enabled replies sorted by order
  List<QuickReply> get enabledReplies {
    return replies.where((r) => r.enabled).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Add a new quick reply
  QuickReplyConfig addReply(QuickReply reply) {
    final newReplies = List<QuickReply>.from(replies)..add(reply);
    return copyWith(replies: newReplies);
  }

  /// Update an existing quick reply
  QuickReplyConfig updateReply(QuickReply reply) {
    final newReplies = replies.map((r) => r.id == reply.id ? reply : r).toList();
    return copyWith(replies: newReplies);
  }

  /// Remove a quick reply
  QuickReplyConfig removeReply(String id) {
    final newReplies = replies.where((r) => r.id != id).toList();
    return copyWith(replies: newReplies);
  }

  /// Reorder replies
  QuickReplyConfig reorder(int oldIndex, int newIndex) {
    final sortedReplies = List<QuickReply>.from(replies)
      ..sort((a, b) => a.order.compareTo(b.order));
    
    final item = sortedReplies.removeAt(oldIndex);
    sortedReplies.insert(newIndex, item);
    
    // Update order values
    final reorderedReplies = <QuickReply>[];
    for (int i = 0; i < sortedReplies.length; i++) {
      reorderedReplies.add(sortedReplies[i].copyWith(order: i));
    }
    
    return copyWith(replies: reorderedReplies);
  }

  /// Toggle a reply's enabled state
  QuickReplyConfig toggleReply(String id) {
    final newReplies = replies.map((r) {
      if (r.id == id) {
        return r.copyWith(enabled: !r.enabled);
      }
      return r;
    }).toList();
    return copyWith(replies: newReplies);
  }

  Map<String, dynamic> toJson() {
    return {
      'replies': replies.map((r) => r.toJson()).toList(),
      'showQuickReplies': showQuickReplies,
      'showAboveInput': showAboveInput,
    };
  }

  factory QuickReplyConfig.fromJson(Map<String, dynamic> json) {
    return QuickReplyConfig(
      replies: (json['replies'] as List<dynamic>?)
              ?.map((r) => QuickReply.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      showQuickReplies: json['showQuickReplies'] as bool? ?? true,
      showAboveInput: json['showAboveInput'] as bool? ?? true,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory QuickReplyConfig.fromJsonString(String jsonString) {
    return QuickReplyConfig.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}