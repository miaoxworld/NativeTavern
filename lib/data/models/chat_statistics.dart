import 'package:flutter/foundation.dart';

/// Statistics for a single chat session
@immutable
class ChatStatistics {
  final String chatId;
  final int totalMessages;
  final int userMessages;
  final int assistantMessages;
  final int systemMessages;
  final int totalTokensUsed;
  final int promptTokens;
  final int completionTokens;
  final Duration totalGenerationTime;
  final int generationCount;
  final DateTime? firstMessageAt;
  final DateTime? lastMessageAt;

  const ChatStatistics({
    required this.chatId,
    this.totalMessages = 0,
    this.userMessages = 0,
    this.assistantMessages = 0,
    this.systemMessages = 0,
    this.totalTokensUsed = 0,
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalGenerationTime = Duration.zero,
    this.generationCount = 0,
    this.firstMessageAt,
    this.lastMessageAt,
  });

  /// Average generation time per response
  Duration get averageGenerationTime {
    if (generationCount == 0) return Duration.zero;
    return Duration(
      milliseconds: totalGenerationTime.inMilliseconds ~/ generationCount,
    );
  }

  /// Average tokens per message
  double get averageTokensPerMessage {
    if (totalMessages == 0) return 0;
    return totalTokensUsed / totalMessages;
  }

  /// Chat duration (time between first and last message)
  Duration get chatDuration {
    if (firstMessageAt == null || lastMessageAt == null) return Duration.zero;
    return lastMessageAt!.difference(firstMessageAt!);
  }

  ChatStatistics copyWith({
    String? chatId,
    int? totalMessages,
    int? userMessages,
    int? assistantMessages,
    int? systemMessages,
    int? totalTokensUsed,
    int? promptTokens,
    int? completionTokens,
    Duration? totalGenerationTime,
    int? generationCount,
    DateTime? firstMessageAt,
    DateTime? lastMessageAt,
  }) {
    return ChatStatistics(
      chatId: chatId ?? this.chatId,
      totalMessages: totalMessages ?? this.totalMessages,
      userMessages: userMessages ?? this.userMessages,
      assistantMessages: assistantMessages ?? this.assistantMessages,
      systemMessages: systemMessages ?? this.systemMessages,
      totalTokensUsed: totalTokensUsed ?? this.totalTokensUsed,
      promptTokens: promptTokens ?? this.promptTokens,
      completionTokens: completionTokens ?? this.completionTokens,
      totalGenerationTime: totalGenerationTime ?? this.totalGenerationTime,
      generationCount: generationCount ?? this.generationCount,
      firstMessageAt: firstMessageAt ?? this.firstMessageAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'totalMessages': totalMessages,
      'userMessages': userMessages,
      'assistantMessages': assistantMessages,
      'systemMessages': systemMessages,
      'totalTokensUsed': totalTokensUsed,
      'promptTokens': promptTokens,
      'completionTokens': completionTokens,
      'totalGenerationTimeMs': totalGenerationTime.inMilliseconds,
      'generationCount': generationCount,
      'firstMessageAt': firstMessageAt?.toIso8601String(),
      'lastMessageAt': lastMessageAt?.toIso8601String(),
    };
  }

  factory ChatStatistics.fromJson(Map<String, dynamic> json) {
    return ChatStatistics(
      chatId: json['chatId'] as String,
      totalMessages: json['totalMessages'] as int? ?? 0,
      userMessages: json['userMessages'] as int? ?? 0,
      assistantMessages: json['assistantMessages'] as int? ?? 0,
      systemMessages: json['systemMessages'] as int? ?? 0,
      totalTokensUsed: json['totalTokensUsed'] as int? ?? 0,
      promptTokens: json['promptTokens'] as int? ?? 0,
      completionTokens: json['completionTokens'] as int? ?? 0,
      totalGenerationTime: Duration(
        milliseconds: json['totalGenerationTimeMs'] as int? ?? 0,
      ),
      generationCount: json['generationCount'] as int? ?? 0,
      firstMessageAt: json['firstMessageAt'] != null
          ? DateTime.parse(json['firstMessageAt'] as String)
          : null,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
    );
  }
}

/// Global app statistics
@immutable
class AppStatistics {
  final int totalChats;
  final int totalMessages;
  final int totalTokensUsed;
  final Duration totalGenerationTime;
  final int totalGenerations;
  final int totalCharacters;
  final int totalGroups;
  final DateTime? appFirstUsed;

  const AppStatistics({
    this.totalChats = 0,
    this.totalMessages = 0,
    this.totalTokensUsed = 0,
    this.totalGenerationTime = Duration.zero,
    this.totalGenerations = 0,
    this.totalCharacters = 0,
    this.totalGroups = 0,
    this.appFirstUsed,
  });

  /// Average tokens per generation
  double get averageTokensPerGeneration {
    if (totalGenerations == 0) return 0;
    return totalTokensUsed / totalGenerations;
  }

  /// Average generation time
  Duration get averageGenerationTime {
    if (totalGenerations == 0) return Duration.zero;
    return Duration(
      milliseconds: totalGenerationTime.inMilliseconds ~/ totalGenerations,
    );
  }

  AppStatistics copyWith({
    int? totalChats,
    int? totalMessages,
    int? totalTokensUsed,
    Duration? totalGenerationTime,
    int? totalGenerations,
    int? totalCharacters,
    int? totalGroups,
    DateTime? appFirstUsed,
  }) {
    return AppStatistics(
      totalChats: totalChats ?? this.totalChats,
      totalMessages: totalMessages ?? this.totalMessages,
      totalTokensUsed: totalTokensUsed ?? this.totalTokensUsed,
      totalGenerationTime: totalGenerationTime ?? this.totalGenerationTime,
      totalGenerations: totalGenerations ?? this.totalGenerations,
      totalCharacters: totalCharacters ?? this.totalCharacters,
      totalGroups: totalGroups ?? this.totalGroups,
      appFirstUsed: appFirstUsed ?? this.appFirstUsed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalChats': totalChats,
      'totalMessages': totalMessages,
      'totalTokensUsed': totalTokensUsed,
      'totalGenerationTimeMs': totalGenerationTime.inMilliseconds,
      'totalGenerations': totalGenerations,
      'totalCharacters': totalCharacters,
      'totalGroups': totalGroups,
      'appFirstUsed': appFirstUsed?.toIso8601String(),
    };
  }

  factory AppStatistics.fromJson(Map<String, dynamic> json) {
    return AppStatistics(
      totalChats: json['totalChats'] as int? ?? 0,
      totalMessages: json['totalMessages'] as int? ?? 0,
      totalTokensUsed: json['totalTokensUsed'] as int? ?? 0,
      totalGenerationTime: Duration(
        milliseconds: json['totalGenerationTimeMs'] as int? ?? 0,
      ),
      totalGenerations: json['totalGenerations'] as int? ?? 0,
      totalCharacters: json['totalCharacters'] as int? ?? 0,
      totalGroups: json['totalGroups'] as int? ?? 0,
      appFirstUsed: json['appFirstUsed'] != null
          ? DateTime.parse(json['appFirstUsed'] as String)
          : null,
    );
  }
}

/// Generation result with timing info
@immutable
class GenerationResult {
  final String content;
  final int promptTokens;
  final int completionTokens;
  final Duration generationTime;
  final String? model;
  final DateTime timestamp;

  const GenerationResult({
    required this.content,
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.generationTime = Duration.zero,
    this.model,
    required this.timestamp,
  });

  int get totalTokens => promptTokens + completionTokens;
}