import 'dart:async';

import 'package:native_tavern/domain/services/llm_service.dart';

/// Cached provider ping used by the Status home-screen widget.
///
/// Cloud providers without an API key are not pinged (`null` → "needs key").
/// A failed or timed-out ping is cached as unreachable for [ttl].
class ProviderReachability {
  ProviderReachability({
    required Future<bool> Function(LLMConfig config) ping,
    Duration timeout = const Duration(seconds: 3),
    Duration ttl = const Duration(minutes: 15),
    DateTime Function()? clock,
  })  : _ping = ping,
        _timeout = timeout,
        _ttl = ttl,
        _clock = clock ?? DateTime.now;

  factory ProviderReachability.fromLlm(
    LLMService llm, {
    Duration timeout = const Duration(seconds: 3),
    Duration ttl = const Duration(minutes: 15),
    DateTime Function()? clock,
  }) {
    return ProviderReachability(
      ping: (config) async {
        await llm.testConnection(config);
        return true;
      },
      timeout: timeout,
      ttl: ttl,
      clock: clock,
    );
  }

  final Future<bool> Function(LLMConfig config) _ping;
  final Duration _timeout;
  final Duration _ttl;
  final DateTime Function() _clock;

  final Map<String, _CacheEntry> _cache = {};

  static String cacheKey(LLMConfig config) {
    return '${config.provider.name}|${config.apiUrl}|${config.model}';
  }

  /// `true` reachable, `false` unreachable, `null` skipped (needs a key).
  Future<bool?> isReachable(
    LLMConfig config, {
    bool force = false,
  }) async {
    if (!config.provider.isLocalServer && config.apiKey.trim().isEmpty) {
      return null;
    }
    final key = cacheKey(config);
    final now = _clock();
    if (!force) {
      final cached = _cache[key];
      if (cached != null && now.difference(cached.at) < _ttl) {
        return cached.ok;
      }
    }
    try {
      final ok = await _ping(config).timeout(_timeout);
      _cache[key] = _CacheEntry(ok: ok, at: now);
      return ok;
    } catch (_) {
      _cache[key] = _CacheEntry(ok: false, at: now);
      return false;
    }
  }

  void clear() => _cache.clear();
}

class _CacheEntry {
  const _CacheEntry({required this.ok, required this.at});

  final bool ok;
  final DateTime at;
}
