import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/data/models/provider_usage.dart';
import 'package:uuid/uuid.dart';

/// Persists per-generation token usage and the last remote credit snapshot.
class ProviderUsageRepository {
  ProviderUsageRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<ProviderUsageEvent> record(ProviderUsageEvent event) async {
    final id = event.id.isEmpty ? _uuid.v4() : event.id;
    await _db.customStatement(
      '''
      INSERT INTO provider_usage_events (
        id, provider, model, prompt_tokens, completion_tokens, total_tokens,
        cached_tokens, reasoning_tokens, cost_usd, source, chat_id, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        id,
        event.provider,
        event.model,
        event.promptTokens,
        event.completionTokens,
        event.totalTokens,
        event.cachedTokens,
        event.reasoningTokens,
        event.costUsd,
        event.source.name,
        event.chatId,
        event.createdAt.millisecondsSinceEpoch,
      ],
    );
    return event.id == id ? event : ProviderUsageEvent(
      id: id,
      provider: event.provider,
      model: event.model,
      promptTokens: event.promptTokens,
      completionTokens: event.completionTokens,
      totalTokens: event.totalTokens,
      cachedTokens: event.cachedTokens,
      reasoningTokens: event.reasoningTokens,
      costUsd: event.costUsd,
      source: event.source,
      chatId: event.chatId,
      createdAt: event.createdAt,
    );
  }

  Future<List<ProviderUsageEvent>> listEvents({
    String? provider,
    DateTime? since,
    int limit = 500,
  }) async {
    final clauses = <String>[];
    final variables = <Variable>[];
    if (provider != null && provider.isNotEmpty) {
      clauses.add('provider = ?');
      variables.add(Variable<String>(provider));
    }
    if (since != null) {
      clauses.add('created_at >= ?');
      variables.add(Variable<int>(since.millisecondsSinceEpoch));
    }
    final where = clauses.isEmpty ? '' : 'WHERE ${clauses.join(' AND ')}';
    final rows = await _db.customSelect(
      'SELECT * FROM provider_usage_events $where '
      'ORDER BY created_at DESC LIMIT ?',
      variables: [...variables, Variable<int>(limit)],
    ).get();
    return rows.map(_eventFromRow).toList(growable: false);
  }

  Future<ProviderUsageTotals> totals({
    required String provider,
    String? model,
    DateTime? since,
  }) async {
    final clauses = <String>['provider = ?'];
    final variables = <Variable>[Variable<String>(provider)];
    if (model != null && model.isNotEmpty) {
      clauses.add('model = ?');
      variables.add(Variable<String>(model));
    }
    if (since != null) {
      clauses.add('created_at >= ?');
      variables.add(Variable<int>(since.millisecondsSinceEpoch));
    }
    final row = await _db.customSelect(
      '''
      SELECT
        COUNT(*) AS generation_count,
        COALESCE(SUM(prompt_tokens), 0) AS prompt_tokens,
        COALESCE(SUM(completion_tokens), 0) AS completion_tokens,
        COALESCE(SUM(total_tokens), 0) AS total_tokens,
        SUM(cost_usd) AS cost_usd,
        MIN(created_at) AS first_at,
        MAX(created_at) AS last_at
      FROM provider_usage_events
      WHERE ${clauses.join(' AND ')}
      ''',
      variables: variables,
    ).getSingle();
    return ProviderUsageTotals(
      provider: provider,
      model: model,
      promptTokens: row.read<int>('prompt_tokens'),
      completionTokens: row.read<int>('completion_tokens'),
      totalTokens: row.read<int>('total_tokens'),
      generationCount: row.read<int>('generation_count'),
      costUsd: row.data['cost_usd'] == null
          ? null
          : (row.data['cost_usd'] as num).toDouble(),
      firstAt: _date(row.data['first_at']),
      lastAt: _date(row.data['last_at']),
    );
  }

  Future<void> saveRemote(RemoteProviderUsage snapshot) async {
    await _db.customStatement(
      '''
      INSERT OR REPLACE INTO provider_usage_remote (
        provider, payload_json, fetched_at
      ) VALUES (?, ?, ?)
      ''',
      [
        snapshot.provider,
        jsonEncode(snapshot.toJson()),
        snapshot.fetchedAt.millisecondsSinceEpoch,
      ],
    );
  }

  Future<RemoteProviderUsage?> latestRemote(String provider) async {
    final row = await _db.customSelect(
      'SELECT payload_json FROM provider_usage_remote WHERE provider = ?',
      variables: [Variable<String>(provider)],
    ).getSingleOrNull();
    if (row == null) return null;
    final json = jsonDecode(row.read<String>('payload_json'));
    if (json is! Map<String, dynamic>) return null;
    return RemoteProviderUsage.fromJson(json);
  }

  ProviderUsageEvent _eventFromRow(QueryRow row) {
    return ProviderUsageEvent(
      id: row.read<String>('id'),
      provider: row.read<String>('provider'),
      model: row.read<String>('model'),
      promptTokens: row.read<int>('prompt_tokens'),
      completionTokens: row.read<int>('completion_tokens'),
      totalTokens: row.read<int>('total_tokens'),
      cachedTokens: row.read<int>('cached_tokens'),
      reasoningTokens: row.read<int>('reasoning_tokens'),
      costUsd: row.data['cost_usd'] == null
          ? null
          : (row.data['cost_usd'] as num).toDouble(),
      source: ProviderUsageSource.values.firstWhere(
        (value) => value.name == row.read<String>('source'),
        orElse: () => ProviderUsageSource.local,
      ),
      chatId: row.data['chat_id'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.read<int>('created_at')),
    );
  }

  DateTime? _date(Object? value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    return null;
  }
}
