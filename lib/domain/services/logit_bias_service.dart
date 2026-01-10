import 'dart:convert';
import 'package:native_tavern/data/models/logit_bias.dart';

/// Service for processing logit bias entries
class LogitBiasService {
  /// Cache for processed bias results
  final Map<String, List<Map<String, dynamic>>> _cache = {};

  /// Parse a logit bias entry text to determine its format
  ParsedLogitBiasEntry parseEntry(LogitBiasEntry entry) {
    final text = entry.text.trim();
    
    if (text.isEmpty) {
      return ParsedLogitBiasEntry(
        format: LogitBiasInputFormat.text,
        originalText: entry.text,
        processedText: '',
        value: entry.value,
      );
    }

    // Check for verbatim format: {text}
    if (text.startsWith('{') && text.endsWith('}')) {
      final verbatimText = text.substring(1, text.length - 1);
      return ParsedLogitBiasEntry(
        format: LogitBiasInputFormat.verbatim,
        originalText: entry.text,
        processedText: verbatimText,
        value: entry.value,
      );
    }

    // Check for raw token IDs format: [1, 2, 3]
    if (text.startsWith('[') && text.endsWith(']')) {
      try {
        final tokens = jsonDecode(text) as List<dynamic>;
        if (tokens.every((t) => t is int)) {
          return ParsedLogitBiasEntry(
            format: LogitBiasInputFormat.tokenIds,
            originalText: entry.text,
            processedText: text,
            tokenIds: tokens.cast<int>(),
            value: entry.value,
          );
        }
      } catch (_) {
        // Not valid JSON, treat as text
      }
    }

    // Default: text with leading space (for word boundary)
    return ParsedLogitBiasEntry(
      format: LogitBiasInputFormat.text,
      originalText: entry.text,
      processedText: ' $text',
      value: entry.value,
    );
  }

  /// Process logit bias entries for API request
  /// Returns a list of bias objects suitable for the API
  List<Map<String, dynamic>> processEntries(
    List<LogitBiasEntry> entries,
    TokenizerType tokenizerType,
    List<int> Function(String text, TokenizerType type) tokenizeFunction,
  ) {
    final cacheKey = _generateCacheKey(entries, tokenizerType);
    
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final result = <Map<String, dynamic>>[];

    for (final entry in entries) {
      if (!entry.enabled || entry.text.trim().isEmpty) continue;

      final parsed = parseEntry(entry);
      List<int> tokens;

      switch (parsed.format) {
        case LogitBiasInputFormat.verbatim:
          // Tokenize exactly as written
          tokens = tokenizeFunction(parsed.processedText, tokenizerType);
          break;
        case LogitBiasInputFormat.tokenIds:
          // Use raw token IDs directly
          tokens = parsed.tokenIds ?? [];
          break;
        case LogitBiasInputFormat.text:
          // Tokenize with leading space
          tokens = tokenizeFunction(parsed.processedText, tokenizerType);
          break;
      }

      if (tokens.isNotEmpty) {
        result.add(_createBiasObject(parsed.value, tokens));
      }
    }

    _cache[cacheKey] = result;
    return result;
  }

  /// Create a bias object for the API
  Map<String, dynamic> _createBiasObject(double bias, List<int> tokens) {
    // OpenAI format: map of token_id -> bias
    // Other APIs may need different formats
    return {
      'bias': bias,
      'tokens': tokens,
    };
  }

  /// Generate OpenAI-compatible logit bias map
  Map<String, double> toOpenAIFormat(
    List<LogitBiasEntry> entries,
    List<int> Function(String text, TokenizerType type) tokenizeFunction,
  ) {
    final result = <String, double>{};

    for (final entry in entries) {
      if (!entry.enabled || entry.text.trim().isEmpty) continue;

      final parsed = parseEntry(entry);
      List<int> tokens;

      switch (parsed.format) {
        case LogitBiasInputFormat.verbatim:
          tokens = tokenizeFunction(parsed.processedText, TokenizerType.openai);
          break;
        case LogitBiasInputFormat.tokenIds:
          tokens = parsed.tokenIds ?? [];
          break;
        case LogitBiasInputFormat.text:
          tokens = tokenizeFunction(parsed.processedText, TokenizerType.openai);
          break;
      }

      // OpenAI uses string keys for token IDs
      for (final token in tokens) {
        result[token.toString()] = parsed.value;
      }
    }

    return result;
  }

  /// Generate Anthropic-compatible logit bias (if supported)
  List<Map<String, dynamic>> toAnthropicFormat(
    List<LogitBiasEntry> entries,
    List<int> Function(String text, TokenizerType type) tokenizeFunction,
  ) {
    // Anthropic doesn't currently support logit bias
    // This is a placeholder for future support
    return [];
  }

  /// Clear the cache
  void clearCache() {
    _cache.clear();
  }

  /// Clear cache for specific entries
  void invalidateCache(List<LogitBiasEntry> entries, TokenizerType tokenizerType) {
    final cacheKey = _generateCacheKey(entries, tokenizerType);
    _cache.remove(cacheKey);
  }

  String _generateCacheKey(List<LogitBiasEntry> entries, TokenizerType tokenizerType) {
    final entriesHash = entries
        .where((e) => e.enabled)
        .map((e) => '${e.text}:${e.value}')
        .join('|');
    return '${tokenizerType.name}:$entriesHash';
  }

  /// Validate a logit bias entry
  LogitBiasValidationResult validateEntry(LogitBiasEntry entry) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check value range
    if (entry.value < -100 || entry.value > 100) {
      errors.add('Bias value must be between -100 and 100');
    } else if (entry.value < -10 || entry.value > 10) {
      warnings.add('Extreme bias values may produce unexpected results');
    }

    // Check text format
    final text = entry.text.trim();
    if (text.isEmpty && entry.enabled) {
      warnings.add('Empty text will be ignored');
    }

    // Check for token ID format
    if (text.startsWith('[') && text.endsWith(']')) {
      try {
        final tokens = jsonDecode(text) as List<dynamic>;
        if (!tokens.every((t) => t is int)) {
          errors.add('Token ID array must contain only integers');
        }
        if (tokens.any((t) => t is int && t < 0)) {
          errors.add('Token IDs must be non-negative');
        }
      } catch (_) {
        errors.add('Invalid JSON array format for token IDs');
      }
    }

    return LogitBiasValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Get description of the input format
  String getFormatDescription(LogitBiasInputFormat format) {
    switch (format) {
      case LogitBiasInputFormat.text:
        return 'Text (with leading space for word boundary)';
      case LogitBiasInputFormat.verbatim:
        return 'Verbatim text (tokenized exactly as written)';
      case LogitBiasInputFormat.tokenIds:
        return 'Raw token IDs';
    }
  }

  /// Get help text for logit bias input
  String getHelpText() {
    return '''
Logit Bias adjusts the probability of specific tokens appearing in the output.

**Input Formats:**
- **Plain text**: Tokenized with a leading space (e.g., "hello" → " hello")
- **{Verbatim}**: Tokenized exactly as written (e.g., "{Hello}" → "Hello")
- **[Token IDs]**: Raw token IDs as JSON array (e.g., "[1234, 5678]")

**Bias Values:**
- **Positive values** (0 to 100): Increase likelihood of token
- **Negative values** (-100 to 0): Decrease likelihood of token
- **-100**: Effectively ban the token
- **100**: Effectively force the token

**Tips:**
- Use small values (-5 to 5) for subtle adjustments
- Extreme values may cause incoherent output
- Different tokenizers produce different token IDs
''';
  }
}

/// Result of validating a logit bias entry
class LogitBiasValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  const LogitBiasValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });
}

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

/// Extension to get tokenizer display names
extension TokenizerTypeExtension on TokenizerType {
  String get displayName {
    switch (this) {
      case TokenizerType.none:
        return 'None';
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
}