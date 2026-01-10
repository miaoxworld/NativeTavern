import 'dart:convert';

/// Represents log probability data for a single token
class TokenLogprob {
  /// The token text
  final String token;
  
  /// Log probability of this token being chosen
  final double logprob;
  
  /// Top alternative tokens with their log probabilities
  final List<TokenCandidate> topCandidates;

  const TokenLogprob({
    required this.token,
    required this.logprob,
    this.topCandidates = const [],
  });

  factory TokenLogprob.fromJson(Map<String, dynamic> json) {
    return TokenLogprob(
      token: json['token'] as String? ?? '',
      logprob: (json['logprob'] as num?)?.toDouble() ?? 0.0,
      topCandidates: (json['top_logprobs'] as List<dynamic>?)
              ?.map((e) => TokenCandidate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'logprob': logprob,
      'top_logprobs': topCandidates.map((e) => e.toJson()).toList(),
    };
  }

  /// Convert log probability to percentage
  double get probability => logprob <= 0 ? (logprob * 100).exp() * 100 : logprob;

  /// Get probability as formatted string
  String get probabilityString => '${probability.toStringAsFixed(2)}%';
}

/// Represents a candidate token with its log probability
class TokenCandidate {
  final String token;
  final double logprob;

  const TokenCandidate({
    required this.token,
    required this.logprob,
  });

  factory TokenCandidate.fromJson(Map<String, dynamic> json) {
    // Handle both OpenAI format and generic format
    if (json.containsKey('token')) {
      return TokenCandidate(
        token: json['token'] as String? ?? '',
        logprob: (json['logprob'] as num?)?.toDouble() ?? 0.0,
      );
    } else {
      // Format: {"tokenText": logprob}
      final entry = json.entries.first;
      return TokenCandidate(
        token: entry.key,
        logprob: (entry.value as num?)?.toDouble() ?? 0.0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'logprob': logprob,
    };
  }

  /// Convert log probability to percentage
  double get probability => logprob <= 0 ? (logprob).exp() * 100 : logprob;

  /// Get probability as formatted string
  String get probabilityString => '${probability.toStringAsFixed(2)}%';
}

/// Log probability data for an entire message
class MessageLogprobs {
  /// Unique identifier
  final String id;
  
  /// Message ID this logprobs data belongs to
  final String messageId;
  
  /// Swipe ID if applicable
  final int? swipeId;
  
  /// API used to generate the message
  final String api;
  
  /// Token logprobs for each token in the message
  final List<TokenLogprob> tokenLogprobs;
  
  /// Continue prefix if this was a continuation
  final String? continueFrom;
  
  /// Timestamp when generated
  final DateTime createdAt;

  const MessageLogprobs({
    required this.id,
    required this.messageId,
    this.swipeId,
    required this.api,
    required this.tokenLogprobs,
    this.continueFrom,
    required this.createdAt,
  });

  factory MessageLogprobs.fromJson(Map<String, dynamic> json) {
    return MessageLogprobs(
      id: json['id'] as String? ?? '',
      messageId: json['messageId'] as String? ?? '',
      swipeId: json['swipeId'] as int?,
      api: json['api'] as String? ?? '',
      tokenLogprobs: (json['tokenLogprobs'] as List<dynamic>?)
              ?.map((e) => TokenLogprob.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      continueFrom: json['continueFrom'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageId': messageId,
      'swipeId': swipeId,
      'api': api,
      'tokenLogprobs': tokenLogprobs.map((e) => e.toJson()).toList(),
      'continueFrom': continueFrom,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Get the full text from tokens
  String get fullText => tokenLogprobs.map((t) => t.token).join('');

  /// Get total token count
  int get tokenCount => tokenLogprobs.length;

  static String serialize(MessageLogprobs logprobs) {
    return jsonEncode(logprobs.toJson());
  }

  static MessageLogprobs deserialize(String json) {
    return MessageLogprobs.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}

/// Settings for logprobs feature
class LogprobsSettings {
  /// Whether to request token probabilities from the API
  final bool requestTokenProbabilities;
  
  /// Number of top candidates to request
  final int topLogprobsCount;
  
  /// Whether to show logprobs panel in chat
  final bool showLogprobsPanel;
  
  /// Color tint intensity for probability visualization
  final double colorIntensity;

  const LogprobsSettings({
    this.requestTokenProbabilities = false,
    this.topLogprobsCount = 5,
    this.showLogprobsPanel = false,
    this.colorIntensity = 0.5,
  });

  factory LogprobsSettings.fromJson(Map<String, dynamic> json) {
    return LogprobsSettings(
      requestTokenProbabilities: json['requestTokenProbabilities'] as bool? ?? false,
      topLogprobsCount: json['topLogprobsCount'] as int? ?? 5,
      showLogprobsPanel: json['showLogprobsPanel'] as bool? ?? false,
      colorIntensity: (json['colorIntensity'] as num?)?.toDouble() ?? 0.5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestTokenProbabilities': requestTokenProbabilities,
      'topLogprobsCount': topLogprobsCount,
      'showLogprobsPanel': showLogprobsPanel,
      'colorIntensity': colorIntensity,
    };
  }

  LogprobsSettings copyWith({
    bool? requestTokenProbabilities,
    int? topLogprobsCount,
    bool? showLogprobsPanel,
    double? colorIntensity,
  }) {
    return LogprobsSettings(
      requestTokenProbabilities: requestTokenProbabilities ?? this.requestTokenProbabilities,
      topLogprobsCount: topLogprobsCount ?? this.topLogprobsCount,
      showLogprobsPanel: showLogprobsPanel ?? this.showLogprobsPanel,
      colorIntensity: colorIntensity ?? this.colorIntensity,
    );
  }

  static String serialize(LogprobsSettings settings) {
    return jsonEncode(settings.toJson());
  }

  static LogprobsSettings deserialize(String json) {
    return LogprobsSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}

/// Extension for math operations
extension _MathExtension on double {
  double exp() => 2.718281828459045 * this;
}