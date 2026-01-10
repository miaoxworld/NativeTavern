import 'dart:collection';
import 'package:native_tavern/data/models/tokenizer.dart';

/// Service for tokenization operations
class TokenizerService {
  /// Characters per token ratio for estimation
  static const double charsPerTokenRatio = 3.35;

  /// LRU cache for tokenization results
  final _cache = _LRUCache<String, TokenizationResult>(maxSize: 100);

  /// Estimate token count based on character count
  int estimateTokenCount(String text) {
    if (text.isEmpty) return 0;
    return (text.length / charsPerTokenRatio).ceil();
  }

  /// Tokenize text using the specified tokenizer
  /// Note: In a real implementation, this would call actual tokenizer libraries
  /// For now, we provide estimation and mock tokenization
  Future<TokenizationResult> tokenize(
    String text,
    TokenizerType tokenizer, {
    bool useCache = true,
  }) async {
    if (text.isEmpty) {
      return TokenizationResult(
        originalText: text,
        tokenizer: tokenizer,
        tokens: [],
        tokenCount: 0,
        timestamp: DateTime.now(),
      );
    }

    // Check cache
    final cacheKey = '${tokenizer.name}:$text';
    if (useCache && _cache.containsKey(cacheKey)) {
      return _cache.get(cacheKey)!;
    }

    // Perform tokenization based on type
    TokenizationResult result;
    switch (tokenizer) {
      case TokenizerType.none:
        result = _estimateTokenization(text);
        break;
      case TokenizerType.bestMatch:
        // In real implementation, would detect best tokenizer
        result = _estimateTokenization(text);
        break;
      default:
        // For actual tokenizers, we'd call the appropriate library
        // For now, use word-based approximation
        result = _wordBasedTokenization(text, tokenizer);
        break;
    }

    // Cache result
    if (useCache) {
      _cache.put(cacheKey, result);
    }

    return result;
  }

  /// Estimate tokenization based on character count
  TokenizationResult _estimateTokenization(String text) {
    final tokenCount = estimateTokenCount(text);
    
    // Create pseudo-tokens based on words
    final words = text.split(RegExp(r'\s+'));
    final tokens = <Token>[];
    int offset = 0;
    int tokenId = 0;

    for (final word in words) {
      if (word.isNotEmpty) {
        tokens.add(Token(
          id: tokenId++,
          text: word,
          byteOffset: offset,
          byteLength: word.length,
        ));
        offset += word.length + 1; // +1 for space
      }
    }

    return TokenizationResult(
      originalText: text,
      tokenizer: TokenizerType.none,
      tokens: tokens,
      tokenCount: tokenCount,
      timestamp: DateTime.now(),
    );
  }

  /// Word-based tokenization approximation
  TokenizationResult _wordBasedTokenization(String text, TokenizerType tokenizer) {
    final tokens = <Token>[];
    int tokenId = 0;
    int offset = 0;

    // Split into words and punctuation
    final pattern = RegExp(r"(\s+|[^\s\w]|\w+)");
    final matches = pattern.allMatches(text);

    for (final match in matches) {
      final tokenText = match.group(0)!;
      if (tokenText.trim().isNotEmpty || tokenText.contains('\n')) {
        tokens.add(Token(
          id: tokenId++,
          text: tokenText,
          byteOffset: offset,
          byteLength: tokenText.length,
        ));
      }
      offset += tokenText.length;
    }

    return TokenizationResult(
      originalText: text,
      tokenizer: tokenizer,
      tokens: tokens,
      tokenCount: tokens.length,
      timestamp: DateTime.now(),
    );
  }

  /// Decode token IDs back to text
  /// Note: In real implementation, would use actual tokenizer
  Future<String> decode(List<int> tokenIds, TokenizerType tokenizer) async {
    // This is a placeholder - real implementation would use actual tokenizer
    return tokenIds.map((id) => '[token:$id]').join('');
  }

  /// Get token IDs for text
  Future<List<int>> encode(String text, TokenizerType tokenizer) async {
    final result = await tokenize(text, tokenizer);
    return result.tokens.map((t) => t.id).toList();
  }

  /// Calculate statistics for tokenized text
  TokenStatistics getStatistics(TokenizationResult result) {
    return TokenStatistics.fromTokens(result.tokens);
  }

  /// Clear the tokenization cache
  void clearCache() {
    _cache.clear();
  }

  /// Get best matching tokenizer for an API/model
  TokenizerType getBestTokenizer(String api, String? model) {
    // Determine best tokenizer based on API and model
    switch (api.toLowerCase()) {
      case 'openai':
        return TokenizerType.openai;
      case 'anthropic':
      case 'claude':
        return TokenizerType.claude;
      case 'google':
      case 'gemini':
        return TokenizerType.gemma;
      case 'cohere':
        return TokenizerType.commandR;
      case 'mistral':
        if (model?.toLowerCase().contains('nemo') ?? false) {
          return TokenizerType.nemo;
        }
        return TokenizerType.mistral;
      case 'deepseek':
        return TokenizerType.deepseek;
      case 'qwen':
      case 'alibaba':
        return TokenizerType.qwen2;
      default:
        // Check model name for hints
        if (model != null) {
          final modelLower = model.toLowerCase();
          if (modelLower.contains('llama-3') || modelLower.contains('llama3')) {
            return TokenizerType.llama3;
          }
          if (modelLower.contains('llama')) {
            return TokenizerType.llama;
          }
          if (modelLower.contains('mistral')) {
            return TokenizerType.mistral;
          }
          if (modelLower.contains('gpt')) {
            return TokenizerType.openai;
          }
        }
        return TokenizerType.none;
    }
  }

  /// Get help text for tokenizer feature
  String getHelpText() {
    return '''
**Tokenization** is the process of breaking text into smaller units (tokens) that AI models can process.

**Why it matters:**
- AI models have token limits (context window)
- Pricing is often based on token count
- Different models use different tokenizers

**Token Types:**
- Words: "hello" → 1 token
- Subwords: "tokenization" → multiple tokens
- Special characters: punctuation, spaces
- Numbers: may be split into digits

**Estimation:**
When exact tokenization isn't available, we estimate using ~3.35 characters per token.

**Tips:**
- Shorter prompts = fewer tokens = lower cost
- Code often uses more tokens than prose
- Non-English text may use more tokens
''';
  }
}

/// Simple LRU cache implementation
class _LRUCache<K, V> {
  final int maxSize;
  final _cache = LinkedHashMap<K, V>();

  _LRUCache({required this.maxSize});

  bool containsKey(K key) => _cache.containsKey(key);

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;
    
    // Move to end (most recently used)
    final value = _cache.remove(key);
    _cache[key] = value as V;
    return value;
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= maxSize) {
      // Remove oldest entry
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  void clear() {
    _cache.clear();
  }
}