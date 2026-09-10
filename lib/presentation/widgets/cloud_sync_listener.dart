import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
import 'package:native_tavern/domain/services/google_drive_service.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';

/// Keeps iCloud / Google Drive snapshots current across app launches.
class CloudSyncListener extends ConsumerStatefulWidget {
  final Widget child;

  const CloudSyncListener({super.key, required this.child});

  @override
  ConsumerState<CloudSyncListener> createState() => _CloudSyncListenerState();
}

class _CloudSyncListenerState extends ConsumerState<CloudSyncListener>
    with WidgetsBindingObserver {
  var _ready = false;
  Timer? _periodicSync;
  AppLifecycleState _lifecycle = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    if (!mounted) return;
    await ref.read(cloudBackupSettingsProvider.notifier).ready.timeout(
          const Duration(seconds: 5),
          onTimeout: () {},
        );
    if (!mounted) return;
    await _waitUntilSetupFinished();
    if (!mounted) return;
    if (ref.read(cloudSyncSetupProvider).status !=
        CloudSyncSetupStatus.finished) {
      return;
    }
    final signedIn = await GoogleDriveService.instance.trySilentSignIn();
    if (mounted && signedIn) {
      ref.read(googleDriveSignedInProvider.notifier).state = true;
      final settings = ref.read(cloudBackupSettingsProvider);
      if (settings.autoSyncEnabled && !settings.googleDriveEnabled) {
        ref
            .read(cloudBackupSettingsProvider.notifier)
            .setGoogleDriveEnabled(true);
      }
    }
    _ready = true;
    _syncPeriodicTimer(ref.read(cloudBackupSettingsProvider));
    await _pullAndPush();
  }

  void _syncPeriodicTimer(CloudBackupSettings settings) {
    _periodicSync?.cancel();
    _periodicSync = null;
    if (!settings.autoSyncEnabled) return;
    final interval = settings.syncSchedule.interval;
    if (interval == null) return;
    _periodicSync = Timer.periodic(interval, (_) {
      if (_lifecycle == AppLifecycleState.resumed) {
        _pullAndPush();
      }
    });
  }

  DatabaseBackupService get _dbBackup =>
      DatabaseBackupService(ref.read(databaseProvider));

  Future<void> _waitUntilSetupFinished() async {
    while (mounted) {
      final status = ref.read(cloudSyncSetupProvider).status;
      if (status == CloudSyncSetupStatus.finished ||
          status == CloudSyncSetupStatus.available) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _pullAndPush() async {
    if (!_ready || !mounted) return;
    if (ref.read(cloudSyncSetupProvider).status !=
        CloudSyncSetupStatus.finished) {
      return;
    }
    await ref.read(cloudBackupOperationProvider.notifier).runAutoSync(
          loadData: _dbBackup.exportAllData,
          restoreCallback: (data, mode) async {
            final actualData = data['data'] as Map<String, dynamic>? ?? data;
            await _dbBackup.importData(
              data: actualData,
              mode: switch (mode) {
                RestoreMode.replace => ImportMode.replace,
                RestoreMode.merge => ImportMode.merge,
                RestoreMode.addNewOnly => ImportMode.addNewOnly,
              },
            );
          },
        );
  }

  Future<void> _push() async {
    if (!_ready || !mounted) return;
    if (ref.read(cloudSyncSetupProvider).status !=
        CloudSyncSetupStatus.finished) {
      return;
    }
    await ref.read(cloudBackupOperationProvider.notifier).pushAutoSync(
          loadData: _dbBackup.exportAllData,
        );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycle = state;
    switch (state) {
      case AppLifecycleState.resumed:
        _pullAndPush();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _push();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    _periodicSync?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CloudBackupSettings>(cloudBackupSettingsProvider, (prev, next) {
      if (!_ready) return;
      _syncPeriodicTimer(next);
      if (next.autoSyncEnabled && prev?.autoSyncEnabled != true) {
        _pullAndPush();
      }
    });
    return widget.child;
  }
}
