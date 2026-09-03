import 'package:native_tavern/domain/models/built_in_tool.dart';

enum ToolCallProgressStatus {
  waitingApproval,
  running,
  succeeded,
  failed,
  denied,
  cancelled,
}

final class ToolLoopLimits {
  const ToolLoopLimits({
    this.maxToolRounds = 4,
    this.maxCalls = 8,
    this.maxElapsed = const Duration(seconds: 60),
    this.maxTokenBudget = 8192,
  });

  final int maxToolRounds;
  final int maxCalls;
  final Duration maxElapsed;
  final int maxTokenBudget;

  void validate() {
    if (maxToolRounds < 1 || maxToolRounds > 16) {
      throw const FormatException('Tool rounds must be between 1 and 16.');
    }
    if (maxCalls < 1 || maxCalls > 64) {
      throw const FormatException('Tool calls must be between 1 and 64.');
    }
    if (maxElapsed < const Duration(seconds: 5) ||
        maxElapsed > const Duration(minutes: 10)) {
      throw const FormatException(
        'Tool timeout must be between 5 and 600 seconds.',
      );
    }
    if (maxTokenBudget < 256 || maxTokenBudget > 65536) {
      throw const FormatException(
        'Tool token budget must be between 256 and 65536.',
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'maxToolRounds': maxToolRounds,
        'maxCalls': maxCalls,
        'maxElapsedSeconds': maxElapsed.inSeconds,
        'maxTokenBudget': maxTokenBudget,
      };

  factory ToolLoopLimits.fromJson(Map<String, dynamic> json) {
    final value = ToolLoopLimits(
      maxToolRounds: json['maxToolRounds'] as int? ?? 4,
      maxCalls: json['maxCalls'] as int? ?? 8,
      maxElapsed: Duration(seconds: json['maxElapsedSeconds'] as int? ?? 60),
      maxTokenBudget: json['maxTokenBudget'] as int? ?? 8192,
    );
    value.validate();
    return value;
  }
}

final class ToolCallingSettings {
  ToolCallingSettings({
    this.enabled = false,
    Iterable<String> enabledBuiltInTools = const [],
    this.limits = const ToolLoopLimits(),
  }) : enabledBuiltInTools = Set<String>.unmodifiable(
          enabledBuiltInTools
              .map((name) => name.trim())
              .where((name) => name.isNotEmpty),
        ) {
    limits.validate();
  }

  final bool enabled;
  final Set<String> enabledBuiltInTools;
  final ToolLoopLimits limits;

  ToolCallingSettings copyWith({
    bool? enabled,
    Iterable<String>? enabledBuiltInTools,
    ToolLoopLimits? limits,
  }) {
    return ToolCallingSettings(
      enabled: enabled ?? this.enabled,
      enabledBuiltInTools: enabledBuiltInTools ?? this.enabledBuiltInTools,
      limits: limits ?? this.limits,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': 1,
        'enabled': enabled,
        'enabledBuiltInTools': enabledBuiltInTools.toList()..sort(),
        'limits': limits.toJson(),
      };

  factory ToolCallingSettings.fromJson(Map<String, dynamic> json) {
    return ToolCallingSettings(
      enabled: json['enabled'] as bool? ?? false,
      enabledBuiltInTools:
          (json['enabledBuiltInTools'] as List<dynamic>? ?? const [])
              .whereType<String>(),
      limits: json['limits'] is Map
          ? ToolLoopLimits.fromJson(
              Map<String, dynamic>.from(json['limits'] as Map),
            )
          : const ToolLoopLimits(),
    );
  }
}

final class ToolCallProgress {
  const ToolCallProgress({
    required this.chatId,
    required this.callId,
    required this.toolName,
    required this.accessLevel,
    required this.target,
    required this.status,
    this.message,
  });

  final String chatId;
  final String callId;
  final String toolName;
  final ToolAccessLevel accessLevel;
  final String target;
  final ToolCallProgressStatus status;
  final String? message;

  ToolCallProgress copyWith({ToolCallProgressStatus? status, String? message}) {
    return ToolCallProgress(
      chatId: chatId,
      callId: callId,
      toolName: toolName,
      accessLevel: accessLevel,
      target: target,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

final class ToolGenerationResult {
  const ToolGenerationResult({
    required this.content,
    required this.reasoning,
    required this.toolRounds,
    required this.callCount,
    required this.estimatedTokens,
    this.stopCode,
  });

  final String content;
  final String? reasoning;
  final int toolRounds;
  final int callCount;
  final int estimatedTokens;
  final String? stopCode;
}
