import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Screen for cloud backup settings (Google Drive & iCloud)
class CloudBackupScreen extends ConsumerWidget {
  const CloudBackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(cloudBackupSettingsProvider);
    final operationState = ref.watch(cloudBackupOperationProvider);
    final iCloudAvailable = ref.watch(iCloudAvailableProvider);
    final iCloudBackupsAsync = ref.watch(iCloudBackupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cloudBackup),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: () {
              ref.invalidate(iCloudBackupsProvider);
              ref.invalidate(iCloudAvailableProvider);
            },
          ),
        ],
      ),
      body: operationState.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(operationState.currentOperation ?? l10n.processing),
                  if (operationState.progress != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: operationState.progress,
                        backgroundColor: AppTheme.darkCard,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(operationState.progress! * 100).toInt()}%',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Cloud backup info
                _buildSection(
                  context: context,
                  title: l10n.cloudBackupInfo,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cloud_outlined, color: AppTheme.accentColor),
                      title: Text(l10n.cloudBackupDescription),
                      subtitle: Text(l10n.cloudBackupSubtitle),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // iCloud section (iOS/macOS only)
                if (Platform.isIOS || Platform.isMacOS) ...[
                  _buildSection(
                    context: context,
                    title: 'iCloud',
                    children: [
                      iCloudAvailable.when(
                        loading: () => const ListTile(
                          leading: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          title: Text('Checking iCloud availability...'),
                        ),
                        error: (_, __) => ListTile(
                          leading: const Icon(Icons.error, color: Colors.red),
                          title: Text(l10n.iCloudNotAvailable),
                          subtitle: Text(l10n.iCloudNotAvailableDescription),
                        ),
                        data: (available) {
                          if (!available) {
                            return ListTile(
                              leading: const Icon(Icons.cloud_off, color: AppTheme.textMuted),
                              title: Text(l10n.iCloudNotAvailable),
                              subtitle: Text(l10n.iCloudNotAvailableDescription),
                            );
                          }

                          return Column(
                            children: [
                              SwitchListTile(
                                title: Text(l10n.enableICloudBackup),
                                subtitle: Text(l10n.enableICloudBackupDescription),
                                value: settings.iCloudEnabled,
                                onChanged: (value) {
                                  ref.read(cloudBackupSettingsProvider.notifier).setICloudEnabled(value);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.cloud_upload, color: Colors.blue),
                                title: Text(l10n.backupToICloud),
                                subtitle: settings.lastICloudSync != null
                                    ? Text(l10n.lastSync(_formatDateTime(context, settings.lastICloudSync!)))
                                    : Text(l10n.neverSynced),
                                trailing: ElevatedButton.icon(
                                  icon: const Icon(Icons.backup, size: 18),
                                  label: Text(l10n.backup),
                                  onPressed: () => _backupToICloud(context, ref),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // iCloud backups list
                  _buildSection(
                    context: context,
                    title: l10n.iCloudBackups,
                    children: [
                      iCloudBackupsAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
                          ),
                        ),
                        data: (backups) {
                          if (backups.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Icon(Icons.cloud_outlined, size: 48, color: AppTheme.textMuted),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.noCloudBackups,
                                      style: const TextStyle(color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: backups.map((backup) => _CloudBackupTile(
                              backup: backup,
                              onRestore: () => _showRestoreDialog(context, ref, backup),
                              onDelete: () => _confirmDeleteBackup(context, ref, backup),
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],

                // Google Drive section
                _buildSection(
                  context: context,
                  title: 'Google Drive',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.folder_outlined, color: Colors.orange),
                      title: Text(l10n.googleDriveExport),
                      subtitle: Text(l10n.googleDriveExportDescription),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file, size: 18),
                        label: Text(l10n.export),
                        onPressed: () => _exportToFile(context, ref),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_download, color: Colors.green),
                      title: Text(l10n.googleDriveImport),
                      subtitle: Text(l10n.googleDriveImportDescription),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.download, size: 18),
                        label: Text(l10n.import_action),
                        onPressed: () => _showImportDialog(context, ref),
                      ),
                    ),
                    if (settings.lastGoogleDriveSync != null)
                      ListTile(
                        leading: const Icon(Icons.schedule, color: AppTheme.textMuted),
                        title: Text(l10n.lastSync(_formatDateTime(context, settings.lastGoogleDriveSync!))),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Restore settings
                _buildSection(
                  context: context,
                  title: l10n.restoreSettings,
                  children: [
                    ListTile(
                      title: Text(l10n.defaultRestoreMode),
                      subtitle: Text(settings.defaultRestoreMode.description),
                      trailing: DropdownButton<RestoreMode>(
                        value: settings.defaultRestoreMode,
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(cloudBackupSettingsProvider.notifier).setDefaultRestoreMode(value);
                          }
                        },
                        items: RestoreMode.values.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(mode.displayName),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Information section
                _buildSection(
                  context: context,
                  title: l10n.information,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppTheme.accentColor),
                      title: Text(l10n.aboutRestoreModes),
                      subtitle: Text(l10n.aboutRestoreModesDescription),
                    ),
                  ],
                ),

                // Error display
                if (operationState.error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            operationState.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            ref.read(cloudBackupOperationProvider.notifier).clearError();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: AppTheme.darkCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inHours < 1) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);

    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }

  void _backupToICloud(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    
    // Get actual data from database
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    final data = await dbBackupService.exportAllData();

    final result = await ref.read(cloudBackupOperationProvider.notifier).uploadToICloud(data);
    
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupCreated)),
      );
    }
  }

  void _exportToFile(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    
    // Get actual data from database
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    final data = await dbBackupService.exportAllData();

    final result = await ref.read(cloudBackupOperationProvider.notifier).exportToFile(data);
    
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupExported)),
      );
    }
  }


  void _showRestoreDialog(BuildContext context, WidgetRef ref, CloudBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);
    
    showDialog(
      context: context,
      builder: (context) => _RestoreDialog(
        backup: backup,
        defaultMode: settings.defaultRestoreMode,
        onRestore: (mode) async {
          Navigator.pop(context);
          
          // Get database service
          final db = ref.read(databaseProvider);
          final dbBackupService = DatabaseBackupService(db);
          final localData = await dbBackupService.exportAllData();
          
          final result = await ref.read(cloudBackupOperationProvider.notifier).downloadFromICloud(
            backup: backup,
            mode: mode,
            localData: localData,
            restoreCallback: (data, restoreMode) async {
              // Actually restore data to database
              final importMode = _convertToImportMode(restoreMode);
              final actualData = data['data'] as Map<String, dynamic>? ?? data;
              await dbBackupService.importData(
                data: actualData,
                mode: importMode,
              );
            },
          );
          
          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.restoreComplete(
                  result.totalAdded,
                  result.totalUpdated,
                  result.totalSkipped,
                )),
              ),
            );
          }
        },
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);
    
    showDialog(
      context: context,
      builder: (context) => _ImportDialog(
        defaultMode: settings.defaultRestoreMode,
        onImport: (mode) async {
          Navigator.pop(context);
          
          // Get database service
          final db = ref.read(databaseProvider);
          final dbBackupService = DatabaseBackupService(db);
          final localData = await dbBackupService.exportAllData();
          
          final result = await ref.read(cloudBackupOperationProvider.notifier).importFromFile(
            mode: mode,
            localData: localData,
            restoreCallback: (data, restoreMode) async {
              // Actually restore data to database
              final importMode = _convertToImportMode(restoreMode);
              final actualData = data['data'] as Map<String, dynamic>? ?? data;
              await dbBackupService.importData(
                data: actualData,
                mode: importMode,
              );
            },
          );
          
          if (result != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.restoreComplete(
                  result.totalAdded,
                  result.totalUpdated,
                  result.totalSkipped,
                )),
              ),
            );
          }
        },
      ),
    );
  }
  
  /// Convert cloud RestoreMode to database ImportMode
  ImportMode _convertToImportMode(RestoreMode mode) {
    switch (mode) {
      case RestoreMode.replace:
        return ImportMode.replace;
      case RestoreMode.merge:
        return ImportMode.merge;
      case RestoreMode.addNewOnly:
        return ImportMode.addNewOnly;
    }
  }


  void _confirmDeleteBackup(BuildContext context, WidgetRef ref, CloudBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteBackup),
        content: Text(l10n.deleteBackupConfirmation(backup.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(cloudBackupOperationProvider.notifier).deleteICloudBackup(backup);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

/// Tile for displaying a cloud backup
class _CloudBackupTile extends StatelessWidget {
  final CloudBackupInfo backup;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const _CloudBackupTile({
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return ListTile(
      leading: Icon(
        backup.provider == CloudProvider.iCloud ? Icons.cloud : Icons.folder,
        color: backup.provider == CloudProvider.iCloud ? Colors.blue : Colors.orange,
      ),
      title: Text(
        backup.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${CloudBackupService.instance.formatFileSize(backup.size)} • ${_formatDate(backup.createdAt)}',
        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.restore, size: 20),
            onPressed: onRestore,
            tooltip: l10n.restoreBackup,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: onDelete,
            tooltip: l10n.delete,
          ),
        ],
      ),
      onTap: onRestore,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${date.month}/${date.day}/${date.year}';
  }
}

/// Dialog for selecting restore mode
class _RestoreDialog extends ConsumerStatefulWidget {
  final CloudBackupInfo backup;
  final RestoreMode defaultMode;
  final void Function(RestoreMode mode) onRestore;

  const _RestoreDialog({
    required this.backup,
    required this.defaultMode,
    required this.onRestore,
  });

  @override
  ConsumerState<_RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends ConsumerState<_RestoreDialog> {
  late RestoreMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.defaultMode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.restoreBackup),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.selectRestoreMode),
          const SizedBox(height: 16),
          ...RestoreMode.values.map((mode) => RadioListTile<RestoreMode>(
            title: Text(mode.displayName),
            subtitle: Text(mode.description),
            value: mode,
            groupValue: _selectedMode,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedMode = value);
              }
            },
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.restoreWarning,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => widget.onRestore(_selectedMode),
          child: Text(l10n.restore),
        ),
      ],
    );
  }
}

/// Dialog for importing a backup file
class _ImportDialog extends ConsumerStatefulWidget {
  final RestoreMode defaultMode;
  final void Function(RestoreMode mode) onImport;

  const _ImportDialog({
    required this.defaultMode,
    required this.onImport,
  });

  @override
  ConsumerState<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends ConsumerState<_ImportDialog> {
  late RestoreMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.defaultMode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.importBackup),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.selectRestoreMode),
          const SizedBox(height: 16),
          ...RestoreMode.values.map((mode) => RadioListTile<RestoreMode>(
            title: Text(mode.displayName),
            subtitle: Text(mode.description),
            value: mode,
            groupValue: _selectedMode,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedMode = value);
              }
            },
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.restoreWarning,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.folder_open, size: 18),
          label: Text(l10n.selectFileAndImport),
          onPressed: () => widget.onImport(_selectedMode),
        ),
      ],
    );
  }
}
