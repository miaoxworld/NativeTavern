import 'package:native_tavern/data/models/provider_usage.dart';
import 'package:native_tavern/data/repositories/provider_usage_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/llm_usage_parser.dart';
import 'package:native_tavern/domain/services/provider_usage_remote.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:uuid/uuid.dart';

/// Records local generation usage and optionally refreshes remote credits.
class ProviderUsageService {
  ProviderUsageService({
    required ProviderUsageRepository repository,
    ProviderUsageRemoteClient? remote,
    Uuid? uuid,
    DateTime Function()? clock,
  })  : _repository = repository,
        _remote = remote ?? ProviderUsageRemoteClient(),
        _uuid = uuid ?? const Uuid(),
        _clock = clock ?? DateTime.now;

  final ProviderUsageRepository _repository;
  final ProviderUsageRemoteClient _remote;
  final Uuid _uuid;
  final DateTime Function() _clock;

  String? activeChatId;

  Future<ProviderUsageEvent?> record({
    required LLMConfig config,
    required LlmTokenUsage usage,
    String? chatId,
    DateTime? at,
  }) async {
    if (!await _shouldRecord(config)) return null;
    return _repository.record(
      ProviderUsageEvent.fromUsage(
        id: _uuid.v4(),
        config: config,
        usage: usage,
        chatId: chatId ?? activeChatId,
        createdAt: at ?? _clock(),
      ),
    );
  }

  Future<bool> _shouldRecord(LLMConfig config) async {
    if (!RegionService.isXaiUsageEndpoint(config)) return true;
    if (await RegionService.isChinaRegion()) return false;
    return true;
  }

  bool _mayRecordCached(LLMConfig config) {
    if (!RegionService.isXaiUsageEndpoint(config)) return true;
    return RegionService.allowsXaiUsageAccounting;
  }

  /// Attaches this service to [LLMService] so every parsed usage object is
  /// stored without the chat UI having to remember.
  void attachTo(LLMService llm) {
    llm.shouldRecordUsage = _mayRecordCached;
    llm.onUsage = (config, usage) {
      record(config: config, usage: usage);
    };
  }

  Future<ProviderUsageTotals> totalsFor(
    LLMConfig config, {
    DateTime? since,
    bool currentModelOnly = false,
  }) {
    return _repository.totals(
      provider: config.provider.name,
      model: currentModelOnly ? config.model : null,
      since: since,
    );
  }

  Future<ProviderUsageTotals> today(LLMConfig config) {
    final now = _clock().toUtc();
    final start = DateTime.utc(now.year, now.month, now.day);
    return totalsFor(config, since: start);
  }

  Future<RemoteProviderUsage> refreshRemote(LLMConfig config) async {
    final snapshot = await _remote.fetch(config);
    await _repository.saveRemote(snapshot);
    return snapshot;
  }

  Future<RemoteProviderUsage?> cachedRemote(String provider) {
    return _repository.latestRemote(provider);
  }
}
