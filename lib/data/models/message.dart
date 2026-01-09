import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// Message role enum
enum MessageRole {
  @JsonValue('user')
  user,
  @JsonValue('assistant')
  assistant,
  @JsonValue('system')
  system,
}

/// Chat message model
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String chatId,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
    @Default(false) bool isEdited,
    @Default(false) bool isHidden,
    MessageMetadata? metadata,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}

/// Message metadata for additional info
@freezed
class MessageMetadata with _$MessageMetadata {
  const factory MessageMetadata({
    // Token counts
    int? promptTokens,
    int? completionTokens,
    int? totalTokens,
    
    // Generation info
    String? model,
    double? temperature,
    int? maxTokens,
    
    // Swipe support (multiple regenerations)
    @Default([]) List<String> swipes,
    @Default(0) int currentSwipeIndex,
    
    // Reasoning/thinking content (for models like Claude/o1)
    String? reasoning,
    
    // Extra data
    @Default({}) Map<String, dynamic> extra,
  }) = _MessageMetadata;

  factory MessageMetadata.fromJson(Map<String, dynamic> json) => _$MessageMetadataFromJson(json);
}

/// Extension for Message utilities
extension MessageExtension on Message {
  /// Get display content (current swipe if available)
  String get displayContent {
    if (metadata?.swipes.isNotEmpty == true) {
      final index = metadata!.currentSwipeIndex;
      if (index >= 0 && index < metadata!.swipes.length) {
        return metadata!.swipes[index];
      }
    }
    return content;
  }
  
  /// Check if message has multiple swipes
  bool get hasSwipes => (metadata?.swipes.length ?? 0) > 1;
  
  /// Get total swipe count
  int get swipeCount => metadata?.swipes.length ?? 1;
}