import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Asks on first launch whether to import an existing iCloud / Drive snapshot.
class CloudSyncSetupGate extends ConsumerWidget {
  final Widget child;

  const CloudSyncSetupGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(cloudSyncSetupProvider);
    if (setup.status != CloudSyncSetupStatus.available) {
      return child;
    }
    return CloudSyncSetupScreen(provider: setup.provider);
  }
}

class CloudSyncSetupScreen extends ConsumerStatefulWidget {
  final CloudProvider? provider;

  const CloudSyncSetupScreen({super.key, this.provider});

  @override
  ConsumerState<CloudSyncSetupScreen> createState() =>
      _CloudSyncSetupScreenState();
}

class _CloudSyncSetupScreenState extends ConsumerState<CloudSyncSetupScreen> {
  var _busy = false;
  String? _error;

  DatabaseBackupService get _dbBackup =>
      DatabaseBackupService(ref.read(databaseProvider));

  Future<void> _import() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    ref.read(cloudBackupSettingsProvider.notifier).setAutoSyncEnabled(true);
    final imported =
        await ref.read(cloudBackupOperationProvider.notifier).importExistingCloudSync(
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
    if (!mounted) return;
    if (!imported) {
      setState(() {
        _busy = false;
        _error = AppLocalizations.of(context).cloudSyncSetupError;
      });
      return;
    }
    await ref.read(cloudSyncSetupProvider.notifier).markFinished();
  }

  Future<void> _startFresh() async {
    setState(() => _busy = true);
    await ref.read(cloudSyncSetupProvider.notifier).markFinished();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final providerName = widget.provider == CloudProvider.googleDrive
        ? 'Google Drive'
        : 'iCloud';
    final foundLabel = widget.provider == CloudProvider.googleDrive
        ? l10n.cloudSyncSetupFoundOnGoogleDrive
        : l10n.cloudSyncSetupFoundOnICloud;

    return Scaffold(
      key: const Key('cloud-sync-setup-screen'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              children: [
                Icon(
                  widget.provider == CloudProvider.googleDrive
                      ? Icons.cloud_outlined
                      : Icons.cloud_sync_outlined,
                  size: 52,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.cloudSyncSetupTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  foundLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.cloudSyncSetupBody(providerName),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 28),
                if (_error != null) ...[
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                ],
                FilledButton(
                  onPressed: _busy ? null : _import,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(
                    _busy
                        ? l10n.cloudSyncSetupImporting
                        : l10n.cloudSyncSetupImport,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.cloudSyncSetupImportDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _busy ? null : _startFresh,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(l10n.cloudSyncSetupStartFresh),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.cloudSyncSetupStartFreshDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
