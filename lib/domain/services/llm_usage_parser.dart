/// Token usage extracted from a provider response body.
class LlmTokenUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final int cachedTokens;
  final int reasoningTokens;
  final double? costUsd;

  const LlmTokenUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    this.cachedTokens = 0,
    this.reasoningTokens = 0,
    this.costUsd,
  });

  bool get isEmpty =>
      promptTokens <= 0 && completionTokens <= 0 && totalTokens <= 0;

  LlmTokenUsage operator +(LlmTokenUsage other) {
    return LlmTokenUsage(
      promptTokens: promptTokens + other.promptTokens,
      completionTokens: completionTokens + other.completionTokens,
      totalTokens: totalTokens + other.totalTokens,
      cachedTokens: cachedTokens + other.cachedTokens,
      reasoningTokens: reasoningTokens + other.reasoningTokens,
      costUsd: costUsd == null && other.costUsd == null
          ? null
          : (costUsd ?? 0) + (other.costUsd ?? 0),
    );
  }

  /// Prefers later non-zero fields so Claude `message_start` input tokens
  /// can combine with a later `message_delta` output count.
  LlmTokenUsage mergedWith(LlmTokenUsage later) {
    final prompt =
        later.promptTokens > 0 ? later.promptTokens : promptTokens;
    final completion = later.completionTokens > 0
        ? later.completionTokens
        : completionTokens;
    final cached = later.cachedTokens > 0 ? later.cachedTokens : cachedTokens;
    final reasoning =
        later.reasoningTokens > 0 ? later.reasoningTokens : reasoningTokens;
    final total = later.totalTokens > 0
        ? later.totalTokens
        : (prompt + completion);
    return LlmTokenUsage(
      promptTokens: prompt,
      completionTokens: completion,
      totalTokens: total,
      cachedTokens: cached,
      reasoningTokens: reasoning,
      costUsd: later.costUsd ?? costUsd,
    );
  }

  Map<String, dynamic> toJson() => {
        'promptTokens': promptTokens,
        'completionTokens': completionTokens,
        'totalTokens': totalTokens,
        if (cachedTokens > 0) 'cachedTokens': cachedTokens,
        if (reasoningTokens > 0) 'reasoningTokens': reasoningTokens,
        if (costUsd != null) 'costUsd': costUsd,
      };

  factory LlmTokenUsage.fromJson(Map<String, dynamic> json) {
    return LlmTokenUsage(
      promptTokens: _int(json['promptTokens']) ?? 0,
      completionTokens: _int(json['completionTokens']) ?? 0,
      totalTokens: _int(json['totalTokens']) ?? 0,
      cachedTokens: _int(json['cachedTokens']) ?? 0,
      reasoningTokens: _int(json['reasoningTokens']) ?? 0,
      costUsd: _double(json['costUsd']),
    );
  }

  @override
  String toString() =>
      'LlmTokenUsage(prompt: $promptTokens, completion: $completionTokens, '
      'total: $totalTokens, cost: $costUsd)';
}

/// Parses usage objects from OpenAI-compatible, Claude, Gemini, and
/// OpenRouter response JSON. Returns null when no usage is present.
class LlmUsageParser {
  const LlmUsageParser();

  static LlmTokenUsage? parse(Object? raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);

    final usage = map['usage'] ??
        map['usageMetadata'] ??
        map['usage_metadata'] ??
        (map['data'] is Map ? (map['data'] as Map)['usage'] : null);
    if (usage is Map) {
      final parsed = _fromUsageMap(Map<String, dynamic>.from(usage));
      if (parsed != null) return parsed;
    }

    if (map['message'] is Map) {
      final nested = parse(map['message']);
      if (nested != null) return nested;
    }

    final promptEval = _int(map['prompt_eval_count']);
    final evalCount = _int(map['eval_count']);
    if (promptEval != null || evalCount != null) {
      final prompt = promptEval ?? 0;
      final completion = evalCount ?? 0;
      if (prompt > 0 || completion > 0) {
        return LlmTokenUsage(
          promptTokens: prompt,
          completionTokens: completion,
          totalTokens: prompt + completion,
        );
      }
    }

    // Some Gemini payloads put usageMetadata next to candidates.
    final nested = map['response'] ?? map['result'];
    if (nested is Map) {
      return parse(nested);
    }
    return null;
  }

  static LlmTokenUsage? _fromUsageMap(Map<String, dynamic> usage) {
    final prompt = _int(usage['prompt_tokens']) ??
        _int(usage['promptTokens']) ??
        _int(usage['input_tokens']) ??
        _int(usage['inputTokens']) ??
        _int(usage['promptTokenCount']);
    final completion = _int(usage['completion_tokens']) ??
        _int(usage['completionTokens']) ??
        _int(usage['output_tokens']) ??
        _int(usage['outputTokens']) ??
        _int(usage['candidatesTokenCount']) ??
        _int(usage['completionTokenCount']);
    final total = _int(usage['total_tokens']) ??
        _int(usage['totalTokens']) ??
        _int(usage['totalTokenCount']);

    if (prompt == null && completion == null && total == null) {
      return null;
    }

    final promptValue = prompt ?? 0;
    final completionValue = completion ?? 0;
    final totalValue = total ?? (promptValue + completionValue);

    final details = usage['prompt_tokens_details'] is Map
        ? Map<String, dynamic>.from(usage['prompt_tokens_details'] as Map)
        : usage['promptTokensDetails'] is Map
            ? Map<String, dynamic>.from(usage['promptTokensDetails'] as Map)
            : const <String, dynamic>{};
    final completionDetails = usage['completion_tokens_details'] is Map
        ? Map<String, dynamic>.from(usage['completion_tokens_details'] as Map)
        : usage['completionTokensDetails'] is Map
            ? Map<String, dynamic>.from(usage['completionTokensDetails'] as Map)
            : const <String, dynamic>{};

    final cached = _int(usage['cached_tokens']) ??
        _int(usage['cache_read_input_tokens']) ??
        _int(usage['cachedTokens']) ??
        _int(details['cached_tokens']) ??
        _int(details['cachedTokens']) ??
        0;
    final reasoning = _int(usage['reasoning_tokens']) ??
        _int(usage['reasoningTokens']) ??
        _int(completionDetails['reasoning_tokens']) ??
        _int(completionDetails['reasoningTokens']) ??
        0;

    final cost = _double(usage['cost']) ??
        _double(usage['total_cost']) ??
        (usage['cost_details'] is Map
            ? _double((usage['cost_details'] as Map)['upstream_inference_cost'])
            : null);

    if (promptValue <= 0 && completionValue <= 0 && totalValue <= 0) {
      return null;
    }

    return LlmTokenUsage(
      promptTokens: promptValue,
      completionTokens: completionValue,
      totalTokens: totalValue,
      cachedTokens: cached,
      reasoningTokens: reasoning,
      costUsd: cost,
    );
  }
}

int? _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _double(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
