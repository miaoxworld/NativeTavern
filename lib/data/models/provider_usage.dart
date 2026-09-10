import 'package:equatable/equatable.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/llm_usage_parser.dart';

/// Where a usage row came from.
enum ProviderUsageSource { local, remote }

/// One generation's token usage, stored so widgets and settings can
/// show spend without depending on SharedPreferences counters.
class ProviderUsageEvent extends Equatable {
  final String id;
  final String provider;
  final String model;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final int cachedTokens;
  final int reasoningTokens;
  final double? costUsd;
  final ProviderUsageSource source;
  final String? chatId;
  final DateTime createdAt;

  const ProviderUsageEvent({
    required this.id,
    required this.provider,
    required this.model,
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    this.cachedTokens = 0,
    this.reasoningTokens = 0,
    this.costUsd,
    this.source = ProviderUsageSource.local,
    this.chatId,
    required this.createdAt,
  });

  factory ProviderUsageEvent.fromUsage({
    required String id,
    required LLMConfig config,
    required LlmTokenUsage usage,
    String? chatId,
    DateTime? createdAt,
    ProviderUsageSource source = ProviderUsageSource.local,
  }) {
    return ProviderUsageEvent(
      id: id,
      provider: config.provider.name,
      model: config.model,
      promptTokens: usage.promptTokens,
      completionTokens: usage.completionTokens,
      totalTokens: usage.totalTokens,
      cachedTokens: usage.cachedTokens,
      reasoningTokens: usage.reasoningTokens,
      costUsd: usage.costUsd,
      source: source,
      chatId: chatId,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'provider': provider,
        'model': model,
        'promptTokens': promptTokens,
        'completionTokens': completionTokens,
        'totalTokens': totalTokens,
        'cachedTokens': cachedTokens,
        'reasoningTokens': reasoningTokens,
        if (costUsd != null) 'costUsd': costUsd,
        'source': source.name,
        if (chatId != null) 'chatId': chatId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProviderUsageEvent.fromJson(Map<String, dynamic> json) {
    return ProviderUsageEvent(
      id: json['id'] as String,
      provider: json['provider'] as String? ?? '',
      model: json['model'] as String? ?? '',
      promptTokens: json['promptTokens'] as int? ?? 0,
      completionTokens: json['completionTokens'] as int? ?? 0,
      totalTokens: json['totalTokens'] as int? ?? 0,
      cachedTokens: json['cachedTokens'] as int? ?? 0,
      reasoningTokens: json['reasoningTokens'] as int? ?? 0,
      costUsd: (json['costUsd'] as num?)?.toDouble(),
      source: ProviderUsageSource.values.firstWhere(
        (value) => value.name == json['source'],
        orElse: () => ProviderUsageSource.local,
      ),
      chatId: json['chatId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        provider,
        model,
        promptTokens,
        completionTokens,
        totalTokens,
        cachedTokens,
        reasoningTokens,
        costUsd,
        source,
        chatId,
        createdAt,
      ];
}

/// Aggregated usage for a provider/model window.
class ProviderUsageTotals extends Equatable {
  final String provider;
  final String? model;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final int generationCount;
  final double? costUsd;
  final DateTime? firstAt;
  final DateTime? lastAt;

  const ProviderUsageTotals({
    required this.provider,
    this.model,
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
    this.generationCount = 0,
    this.costUsd,
    this.firstAt,
    this.lastAt,
  });

  ProviderUsageTotals add(ProviderUsageEvent event) {
    return ProviderUsageTotals(
      provider: provider,
      model: model,
      promptTokens: promptTokens + event.promptTokens,
      completionTokens: completionTokens + event.completionTokens,
      totalTokens: totalTokens + event.totalTokens,
      generationCount: generationCount + 1,
      costUsd: costUsd == null && event.costUsd == null
          ? null
          : (costUsd ?? 0) + (event.costUsd ?? 0),
      firstAt: firstAt == null || event.createdAt.isBefore(firstAt!)
          ? event.createdAt
          : firstAt,
      lastAt: lastAt == null || event.createdAt.isAfter(lastAt!)
          ? event.createdAt
          : lastAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'provider': provider,
        if (model != null) 'model': model,
        'promptTokens': promptTokens,
        'completionTokens': completionTokens,
        'totalTokens': totalTokens,
        'generationCount': generationCount,
        if (costUsd != null) 'costUsd': costUsd,
        if (firstAt != null) 'firstAt': firstAt!.toIso8601String(),
        if (lastAt != null) 'lastAt': lastAt!.toIso8601String(),
      };

  factory ProviderUsageTotals.fromJson(Map<String, dynamic> json) {
    return ProviderUsageTotals(
      provider: json['provider'] as String,
      model: json['model'] as String?,
      promptTokens: json['promptTokens'] as int? ?? 0,
      completionTokens: json['completionTokens'] as int? ?? 0,
      totalTokens: json['totalTokens'] as int? ?? 0,
      generationCount: json['generationCount'] as int? ?? 0,
      costUsd: (json['costUsd'] as num?)?.toDouble(),
      firstAt: json['firstAt'] != null
          ? DateTime.parse(json['firstAt'] as String)
          : null,
      lastAt: json['lastAt'] != null
          ? DateTime.parse(json['lastAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        provider,
        model,
        promptTokens,
        completionTokens,
        totalTokens,
        generationCount,
        costUsd,
        firstAt,
        lastAt,
      ];
}

enum RemoteUsageKind { credits, balance, quota, unsupported }

/// Last remote credit/balance snapshot for a provider that exposes one.
class RemoteProviderUsage extends Equatable {
  final String provider;
  final RemoteUsageKind kind;
  final bool supported;
  final bool ok;
  final double? remaining;
  final double? used;
  final double? limit;
  final String? currency;
  final String? unit;
  final String? detail;
  final DateTime fetchedAt;

  const RemoteProviderUsage({
    required this.provider,
    required this.kind,
    required this.supported,
    required this.ok,
    this.remaining,
    this.used,
    this.limit,
    this.currency,
    this.unit,
    this.detail,
    required this.fetchedAt,
  });

  factory RemoteProviderUsage.unsupported(String provider, {DateTime? at}) {
    return RemoteProviderUsage(
      provider: provider,
      kind: RemoteUsageKind.unsupported,
      supported: false,
      ok: true,
      fetchedAt: at ?? DateTime.now(),
    );
  }

  factory RemoteProviderUsage.error(String provider, String detail,
      {DateTime? at}) {
    return RemoteProviderUsage(
      provider: provider,
      kind: RemoteUsageKind.credits,
      supported: true,
      ok: false,
      detail: detail,
      fetchedAt: at ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'kind': kind.name,
        'supported': supported,
        'ok': ok,
        if (remaining != null) 'remaining': remaining,
        if (used != null) 'used': used,
        if (limit != null) 'limit': limit,
        if (currency != null) 'currency': currency,
        if (unit != null) 'unit': unit,
        if (detail != null) 'detail': detail,
        'fetchedAt': fetchedAt.toIso8601String(),
      };

  factory RemoteProviderUsage.fromJson(Map<String, dynamic> json) {
    return RemoteProviderUsage(
      provider: json['provider'] as String,
      kind: RemoteUsageKind.values.firstWhere(
        (value) => value.name == json['kind'],
        orElse: () => RemoteUsageKind.credits,
      ),
      supported: json['supported'] as bool? ?? false,
      ok: json['ok'] as bool? ?? false,
      remaining: (json['remaining'] as num?)?.toDouble(),
      used: (json['used'] as num?)?.toDouble(),
      limit: (json['limit'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      unit: json['unit'] as String?,
      detail: json['detail'] as String?,
      fetchedAt: DateTime.parse(json['fetchedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        provider,
        kind,
        supported,
        ok,
        remaining,
        used,
        limit,
        currency,
        unit,
        detail,
        fetchedAt,
      ];
}
