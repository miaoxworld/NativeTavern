import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/domain/services/backup_import_selection.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
import 'package:native_tavern/domain/services/icloud_sync_conflict.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';

/// Prompts the user when this device and iCloud both changed since last sync.
class ICloudConflictGate extends ConsumerWidget {
  final Widget child;

  const ICloudConflictGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ICloudSyncConflict?>(pendingICloudConflictProvider,
        (previous, next) {
      if (next == null || !context.mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => ICloudConflictDialog(conflict: next),
      );
    });
    return child;
  }
}

class ICloudConflictDialog extends ConsumerStatefulWidget {
  final ICloudSyncConflict conflict;

  const ICloudConflictDialog({super.key, required this.conflict});

  @override
  ConsumerState<ICloudConflictDialog> createState() =>
      _ICloudConflictDialogState();
}

class _ICloudConflictDialogState extends ConsumerState<ICloudConflictDialog> {
  ICloudConflictResolution _resolution = ICloudConflictResolution.merge;
  var _characters = true;
  var _chats = true;
  var _lorebooks = true;
  var _moments = true;
  var _story = true;
  var _settings = true;
  var _secrets = true;

  BackupImportSelection get _selection => BackupImportSelection(
        characters: _characters,
        chats: _chats,
        lorebooks: _lorebooks,
        moments: _moments,
        story: _story,
        settings: _settings,
        secrets: _secrets,
      );

  Future<void> _apply() async {
    final db = ref.read(databaseProvider);
    final dbBackup = DatabaseBackupService(db);
    await ref.read(cloudBackupOperationProvider.notifier).resolveICloudConflict(
          conflict: widget.conflict,
          resolution: _resolution,
          selection: _resolution == ICloudConflictResolution.keepLocal
              ? BackupImportSelection.none
              : _resolution == ICloudConflictResolution.chooseCollections
                  ? _selection
                  : BackupImportSelection.all,
          loadData: dbBackup.exportAllData,
          restoreCallback: (data, mode) async {
            final actualData = data['data'] as Map<String, dynamic>? ?? data;
            await dbBackup.importData(
              data: actualData,
              mode: switch (mode) {
                RestoreMode.replace => ImportMode.replace,
                RestoreMode.merge => ImportMode.merge,
                RestoreMode.addNewOnly => ImportMode.addNewOnly,
              },
            );
          },
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDrive = widget.conflict.provider == CloudProvider.googleDrive;
    return AlertDialog(
      title: Text(
        isDrive
            ? l10n.googleDriveSyncConflictTitle
            : l10n.iCloudSyncConflictTitle,
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDrive
                    ? l10n.googleDriveSyncConflictBody
                    : l10n.iCloudSyncConflictBody,
              ),
              if (widget.conflict.localSnapshotPath != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.conflictSnapshotSaved,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              RadioListTile<ICloudConflictResolution>(
                value: ICloudConflictResolution.keepLocal,
                groupValue: _resolution,
                title: Text(l10n.keepThisDevice),
                onChanged: (value) => setState(() => _resolution = value!),
              ),
              RadioListTile<ICloudConflictResolution>(
                value: ICloudConflictResolution.keepRemote,
                groupValue: _resolution,
                title: Text(l10n.keepOtherDevice),
                onChanged: (value) => setState(() => _resolution = value!),
              ),
              RadioListTile<ICloudConflictResolution>(
                value: ICloudConflictResolution.merge,
                groupValue: _resolution,
                title: Text(l10n.mergeKeepBoth),
                onChanged: (value) => setState(() => _resolution = value!),
              ),
              RadioListTile<ICloudConflictResolution>(
                value: ICloudConflictResolution.chooseCollections,
                groupValue: _resolution,
                title: Text(l10n.choosePerCategory),
                onChanged: (value) => setState(() => _resolution = value!),
              ),
              if (_resolution == ICloudConflictResolution.chooseCollections)
                ..._collectionToggles(l10n),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(pendingICloudConflictProvider.notifier).state = null;
            Navigator.of(context).pop();
          },
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _apply,
          child: Text(l10n.save),
        ),
      ],
    );
  }

  List<Widget> _collectionToggles(AppLocalizations l10n) {
    return [
      CheckboxListTile(
        value: _chats,
        onChanged: (value) => setState(() => _chats = value ?? true),
        title: Text(l10n.syncCollectionChats),
      ),
      CheckboxListTile(
        value: _characters,
        onChanged: (value) => setState(() => _characters = value ?? true),
        title: Text(l10n.syncCollectionCharacters),
      ),
      CheckboxListTile(
        value: _lorebooks,
        onChanged: (value) => setState(() => _lorebooks = value ?? true),
        title: Text(l10n.syncCollectionLorebooks),
      ),
      CheckboxListTile(
        value: _moments,
        onChanged: (value) => setState(() => _moments = value ?? true),
        title: Text(l10n.syncCollectionMoments),
      ),
      CheckboxListTile(
        value: _story,
        onChanged: (value) => setState(() => _story = value ?? true),
        title: Text(l10n.syncCollectionStory),
      ),
      CheckboxListTile(
        value: _settings,
        onChanged: (value) => setState(() => _settings = value ?? true),
        title: Text(l10n.syncCollectionSettings),
      ),
      CheckboxListTile(
        value: _secrets,
        onChanged: (value) => setState(() => _secrets = value ?? true),
        title: Text(l10n.syncCollectionApiKeys),
      ),
    ];
  }
}
