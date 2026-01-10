import 'dart:convert';

/// Supported tokenizer types
enum TokenizerType {
  none,
  gpt2,
  openai,
  llama,
  llama3,
  mistral,
  claude,
  gemma,
  qwen2,
  deepseek,
  commandR,
  nemo,
  bestMatch,
}

/// Extension for tokenizer display names and info
extension TokenizerTypeExtension on TokenizerType {
  String get displayName {
    switch (this) {
      case TokenizerType.none:
        return 'None (Estimate)';
      case TokenizerType.gpt2:
        return 'GPT-2';
      case TokenizerType.openai:
        return 'OpenAI (tiktoken)';
      case TokenizerType.llama:
        return 'LLaMA';
      case TokenizerType.llama3:
        return 'LLaMA 3';
      case TokenizerType.mistral:
        return 'Mistral';
      case TokenizerType.claude:
        return 'Claude';
      case TokenizerType.gemma:
        return 'Gemma';
      case TokenizerType.qwen2:
        return 'Qwen 2';
      case TokenizerType.deepseek:
        return 'DeepSeek';
      case TokenizerType.commandR:
        return 'Command R';
      case TokenizerType.nemo:
        return 'Nemo';
      case TokenizerType.bestMatch:
        return 'Best Match (Auto)';
    }
  }

  String get description {
    switch (this) {
      case TokenizerType.none:
        return 'Estimates tokens based on character count (~3.35 chars/token)';
      case TokenizerType.gpt2:
        return 'Original GPT-2 tokenizer (50,257 vocab)';
      case TokenizerType.openai:
        return 'OpenAI tiktoken for GPT-3.5/4 models';
      case TokenizerType.llama:
        return 'LLaMA 1/2 tokenizer (32,000 vocab)';
      case TokenizerType.llama3:
        return 'LLaMA 3 tokenizer (128,256 vocab)';
      case TokenizerType.mistral:
        return 'Mistral tokenizer';
      case TokenizerType.claude:
        return 'Anthropic Claude tokenizer';
      case TokenizerType.gemma:
        return 'Google Gemma tokenizer';
      case TokenizerType.qwen2:
        return 'Alibaba Qwen 2 tokenizer';
      case TokenizerType.deepseek:
        return 'DeepSeek tokenizer';
      case TokenizerType.commandR:
        return 'Cohere Command R tokenizer';
      case TokenizerType.nemo:
        return 'Mistral Nemo tokenizer';
      case TokenizerType.bestMatch:
        return 'Automatically selects based on current API/model';
    }
  }

  bool get supportsEncoding {
    switch (this) {
      case TokenizerType.none:
      case TokenizerType.bestMatch:
        return false;
      default:
        return true;
    }
  }
}

/// Represents a single token with its ID and text
class Token {
  final int id;
  final String text;
  final int? byteOffset;
  final int? byteLength;

  const Token({
    required this.id,
    required this.text,
    this.byteOffset,
    this.byteLength,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      byteOffset: json['byteOffset'] as int?,
      byteLength: json['byteLength'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      if (byteOffset != null) 'byteOffset': byteOffset,
      if (byteLength != null) 'byteLength': byteLength,
    };
  }
}

/// Result of tokenization
class TokenizationResult {
  final String originalText;
  final TokenizerType tokenizer;
  final List<Token> tokens;
  final int tokenCount;
  final DateTime timestamp;

  const TokenizationResult({
    required this.originalText,
    required this.tokenizer,
    required this.tokens,
    required this.tokenCount,
    required this.timestamp,
  });

  factory TokenizationResult.fromJson(Map<String, dynamic> json) {
    return TokenizationResult(
      originalText: json['originalText'] as String? ?? '',
      tokenizer: TokenizerType.values.firstWhere(
        (t) => t.name == json['tokenizer'],
        orElse: () => TokenizerType.none,
      ),
      tokens: (json['tokens'] as List<dynamic>?)
              ?.map((e) => Token.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tokenCount: json['tokenCount'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'tokenizer': tokenizer.name,
      'tokens': tokens.map((t) => t.toJson()).toList(),
      'tokenCount': tokenCount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Get character to token ratio
  double get charToTokenRatio {
    if (tokenCount == 0) return 0;
    return originalText.length / tokenCount;
  }
}

/// Settings for tokenizer feature
class TokenizerSettings {
  final TokenizerType selectedTokenizer;
  final bool showTokenCount;
  final bool showTokenVisualization;
  final bool cacheResults;

  const TokenizerSettings({
    this.selectedTokenizer = TokenizerType.bestMatch,
    this.showTokenCount = true,
    this.showTokenVisualization = false,
    this.cacheResults = true,
  });

  factory TokenizerSettings.fromJson(Map<String, dynamic> json) {
    return TokenizerSettings(
      selectedTokenizer: TokenizerType.values.firstWhere(
        (t) => t.name == json['selectedTokenizer'],
        orElse: () => TokenizerType.bestMatch,
      ),
      showTokenCount: json['showTokenCount'] as bool? ?? true,
      showTokenVisualization: json['showTokenVisualization'] as bool? ?? false,
      cacheResults: json['cacheResults'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedTokenizer': selectedTokenizer.name,
      'showTokenCount': showTokenCount,
      'showTokenVisualization': showTokenVisualization,
      'cacheResults': cacheResults,
    };
  }

  TokenizerSettings copyWith({
    TokenizerType? selectedTokenizer,
    bool? showTokenCount,
    bool? showTokenVisualization,
    bool? cacheResults,
  }) {
    return TokenizerSettings(
      selectedTokenizer: selectedTokenizer ?? this.selectedTokenizer,
      showTokenCount: showTokenCount ?? this.showTokenCount,
      showTokenVisualization: showTokenVisualization ?? this.showTokenVisualization,
      cacheResults: cacheResults ?? this.cacheResults,
    );
  }

  static String serialize(TokenizerSettings settings) {
    return jsonEncode(settings.toJson());
  }

  static TokenizerSettings deserialize(String json) {
    return TokenizerSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}

/// Token statistics for analysis
class TokenStatistics {
  final int totalTokens;
  final int uniqueTokens;
  final double avgTokenLength;
  final Map<String, int> tokenFrequency;
  final int longestToken;
  final int shortestToken;

  const TokenStatistics({
    required this.totalTokens,
    required this.uniqueTokens,
    required this.avgTokenLength,
    required this.tokenFrequency,
    required this.longestToken,
    required this.shortestToken,
  });

  factory TokenStatistics.fromTokens(List<Token> tokens) {
    if (tokens.isEmpty) {
      return const TokenStatistics(
        totalTokens: 0,
        uniqueTokens: 0,
        avgTokenLength: 0,
        tokenFrequency: {},
        longestToken: 0,
        shortestToken: 0,
      );
    }

    final frequency = <String, int>{};
    int totalLength = 0;
    int longest = 0;
    int shortest = tokens.first.text.length;

    for (final token in tokens) {
      frequency[token.text] = (frequency[token.text] ?? 0) + 1;
      totalLength += token.text.length;
      if (token.text.length > longest) longest = token.text.length;
      if (token.text.length < shortest) shortest = token.text.length;
    }

    return TokenStatistics(
      totalTokens: tokens.length,
      uniqueTokens: frequency.length,
      avgTokenLength: totalLength / tokens.length,
      tokenFrequency: frequency,
      longestToken: longest,
      shortestToken: shortest,
    );
  }

  /// Get top N most frequent tokens
  List<MapEntry<String, int>> getTopTokens(int n) {
    final sorted = tokenFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(n).toList();
  }
}