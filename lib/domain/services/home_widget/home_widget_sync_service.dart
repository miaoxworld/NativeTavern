import 'dart:async';

import 'package:native_tavern/data/models/provider_usage.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/repositories/moment_repository.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_bridge.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_snapshot_builder.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/provider_reachability.dart';
import 'package:native_tavern/domain/services/provider_usage_service.dart';

/// Builds a snapshot from live app data and pushes it to the OS widgets.
class HomeWidgetSyncService {
  HomeWidgetSyncService({
    required CharacterRepository characters,
    required ChatRepository chats,
    required MomentRepository moments,
    required ProviderUsageService usage,
    required HomeWidgetBridge bridge,
    ProviderReachability? reachability,
    HomeWidgetSnapshotBuilder? builder,
  })  : _usage = usage,
        _bridge = bridge,
        _reachability = reachability,
        _builder = builder ??
            HomeWidgetSnapshotBuilder(
              characters: characters,
              chats: chats,
              moments: moments,
              usage: usage,
            );

  final ProviderUsageService _usage;
  final HomeWidgetBridge _bridge;
  final ProviderReachability? _reachability;
  final HomeWidgetSnapshotBuilder _builder;

  Future<void> _queue = Future<void>.value();

  Future<HomeWidgetSnapshot?> publish({
    required LLMConfig config,
    required HomeWidgetSettings settings,
    required HomeWidgetLabels labels,
    required String locale,
    String Function(LLMProvider provider)? providerLabel,
    HomeWidgetTheme theme = HomeWidgetTheme.nativetavernDark,
    bool refreshRemote = false,
  }) {
    final pending = _queue.then((_) async {
      if (!settings.enabled) return null;
      RemoteProviderUsage? remote;
      if (refreshRemote && settings.refreshRemoteUsage) {
        try {
          remote = await _usage.refreshRemote(config);
        } catch (_) {
          remote = await _usage.cachedRemote(config.provider.name);
        }
      } else {
        remote = await _usage.cachedRemote(config.provider.name);
      }
      bool? reachable;
      final reachability = _reachability;
      if (reachability != null) {
        reachable = await reachability.isReachable(
          config,
          force: refreshRemote,
        );
      }
      final snapshot = await _builder.build(
        config: config,
        settings: settings,
        labels: labels,
        locale: locale,
        remote: remote,
        providerLabel: providerLabel,
        theme: theme,
        reachable: reachable,
      );
      await _bridge.publish(snapshot);
      return snapshot;
    });
    _queue = pending.then((_) {}, onError: (_) {});
    return pending;
  }
}
