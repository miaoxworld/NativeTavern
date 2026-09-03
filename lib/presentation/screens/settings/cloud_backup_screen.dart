import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/core/utils/share_utils.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
import 'package:native_tavern/domain/services/google_drive_service.dart';
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
    final isGoogleDriveSignedIn = ref.watch(googleDriveSignedInProvider);
    final googleDriveBackupsAsync = ref.watch(googleDriveBackupsProvider);

    final pendingOpenedPath = ref.watch(pendingBackupImportPathProvider);
    if (pendingOpenedPath != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (ref.read(pendingBackupImportPathProvider) != pendingOpenedPath) {
          return;
        }
        _importFromOpenedPath(context, ref, pendingOpenedPath);
      });
    }

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
                  Text(_operationStageLabel(l10n, operationState)),
                  if (operationState.progress != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: operationState.progress,
                        backgroundColor: AppTheme.darkCard,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.accentColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(operationState.progress! * 100).toInt()}%',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 12),
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
                      leading: const Icon(Icons.cloud_outlined,
                          color: AppTheme.accentColor),
                      title: Text(l10n.cloudBackupDescription),
                      subtitle: Text(l10n.cloudBackupSubtitle),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.sync),
                      title: Text(l10n.enableCrossDeviceSync),
                      subtitle: Text(l10n.enableCrossDeviceSyncDescription),
                      value: settings.autoSyncEnabled,
                      onChanged: (value) async {
                        if (value && !Platform.isIOS && !Platform.isMacOS) {
                          final ready = await _ensureGoogleDriveSyncReady(
                            context,
                            ref,
                          );
                          if (!ready) return;
                        }
                        ref
                            .read(cloudBackupSettingsProvider.notifier)
                            .setAutoSyncEnabled(value);
                        if (value) {
                          await _runManualAutoSync(context, ref);
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.sync_alt,
                          color: AppTheme.accentColor),
                      title: Text(l10n.syncNow),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.sync, size: 18),
                        label: Text(l10n.syncNow),
                        onPressed: () => _runManualAutoSync(context, ref),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildSection(
                  context: context,
                  title: l10n.backupContents,
                  children: [
                    CheckboxListTile(
                      value: true,
                      onChanged: null,
                      secondary: const Icon(Icons.description_outlined),
                      title: Text(l10n.allTextData),
                      subtitle: Text(l10n.allTextDataDescription),
                    ),
                    SwitchListTile(
                      value: settings.includeCharacterImages,
                      onChanged: ref
                          .read(cloudBackupSettingsProvider.notifier)
                          .setIncludeCharacterImages,
                      secondary: const Icon(Icons.account_box_outlined),
                      title: Text(l10n.characterCardImages),
                      subtitle: Text(l10n.characterCardImagesDescription),
                    ),
                    SwitchListTile(
                      value: settings.includeWorldInfoImages,
                      onChanged: ref
                          .read(cloudBackupSettingsProvider.notifier)
                          .setIncludeWorldInfoImages,
                      secondary: const Icon(Icons.public_outlined),
                      title: Text(l10n.worldBookImages),
                      subtitle: Text(l10n.worldBookImagesDescription),
                    ),
                    SwitchListTile(
                      value: settings.includeConversationImages,
                      onChanged: ref
                          .read(cloudBackupSettingsProvider.notifier)
                          .setIncludeConversationImages,
                      secondary: const Icon(Icons.photo_library_outlined),
                      title: Text(l10n.conversationImages),
                      subtitle: Text(l10n.conversationImagesDescription),
                    ),
                    SwitchListTile(
                      value: settings.includeBackgrounds,
                      onChanged: ref
                          .read(cloudBackupSettingsProvider.notifier)
                          .setIncludeBackgrounds,
                      secondary: const Icon(Icons.wallpaper_outlined),
                      title: Text(l10n.backgroundImages),
                      subtitle: Text(l10n.backgroundImagesDescription),
                    ),
                    SwitchListTile(
                      value: settings.includeLive2D,
                      onChanged: ref
                          .read(cloudBackupSettingsProvider.notifier)
                          .setIncludeLive2D,
                      secondary: const Icon(Icons.view_in_ar_outlined),
                      title: Text(l10n.live2DBackup),
                      subtitle: Text(l10n.live2DModelsBackupDescription),
                    ),
                    ListTile(
                      leading: const Icon(Icons.link_outlined),
                      title: Text(l10n.independentMediaBackup),
                      subtitle: Text(l10n.independentMediaBackupDescription),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Local & File Backup section (.ntx / .ntb)
                _buildSection(
                  context: context,
                  title: l10n.localBackup,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.folder_zip_outlined,
                          color: AppTheme.accentColor),
                      title: Text(l10n.exportNtxBackup),
                      subtitle: Text(l10n.exportNtxBackupSubtitle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.save_alt),
                            tooltip: l10n.exportToFiles,
                            onPressed: () => _exportBackupToFile(
                              context,
                              ref,
                              combined: true,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            tooltip: l10n.shareBackup,
                            onPressed: () => _shareBackup(
                              context,
                              ref,
                              combined: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.description_outlined,
                          color: AppTheme.accentColor),
                      title: Text(l10n.exportNtbBackup),
                      subtitle: Text(l10n.exportNtbBackupSubtitle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.save_alt),
                            tooltip: l10n.exportToFiles,
                            onPressed: () => _exportBackupToFile(
                              context,
                              ref,
                              combined: false,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            tooltip: l10n.shareBackup,
                            onPressed: () => _shareBackup(
                              context,
                              ref,
                              combined: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_open_outlined,
                          color: Colors.teal),
                      title: Text(l10n.importNtxBackup),
                      subtitle: Text(l10n.importNtxBackupSubtitle),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.file_open, size: 18),
                        label: Text(l10n.import_action),
                        onPressed: () => _importFromFile(context, ref),
                      ),
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
                        loading: () => ListTile(
                          leading: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          title: Text(l10n.checkingICloud),
                        ),
                        error: (_, __) => ListTile(
                          leading: const Icon(Icons.error, color: Colors.red),
                          title: Text(l10n.iCloudNotAvailable),
                          subtitle: Text(l10n.iCloudNotAvailableDescription),
                        ),
                        data: (available) {
                          if (!available) {
                            return ListTile(
                              leading: const Icon(Icons.cloud_off,
                                  color: AppTheme.textMuted),
                              title: Text(l10n.iCloudNotAvailable),
                              subtitle:
                                  Text(l10n.iCloudNotAvailableDescription),
                            );
                          }

                          return Column(
                            children: [
                              SwitchListTile(
                                title: Text(l10n.enableICloudBackup),
                                subtitle:
                                    Text(l10n.enableICloudBackupDescription),
                                value: settings.iCloudEnabled,
                                onChanged: (value) {
                                  ref
                                      .read(
                                          cloudBackupSettingsProvider.notifier)
                                      .setICloudEnabled(value);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.cloud_upload,
                                    color: Colors.blue),
                                title: Text(l10n.backupToICloud),
                                subtitle: settings.lastICloudSync != null
                                    ? Text(l10n.lastSync(_formatDateTime(
                                        context, settings.lastICloudSync!)))
                                    : Text(l10n.neverSynced),
                                trailing: ElevatedButton.icon(
                                  icon: const Icon(Icons.backup, size: 18),
                                  label: Text(l10n.backup),
                                  onPressed: () =>
                                      _backupToICloud(context, ref),
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
                            child: Text('${l10n.error}: $error',
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ),
                        data: (backups) {
                          if (backups.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Icon(Icons.cloud_outlined,
                                        size: 48, color: AppTheme.textMuted),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.noCloudBackups,
                                      style: const TextStyle(
                                          color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: backups
                                .map((backup) => _CloudBackupTile(
                                      backup: backup,
                                      onRestore: () => _showRestoreDialog(
                                          context, ref, backup),
                                      onDelete: () => _confirmDeleteBackup(
                                          context, ref, backup),
                                    ))
                                .toList(),
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
                    SwitchListTile(
                      secondary: const Icon(Icons.cloud, color: Colors.green),
                      title: Text(l10n.enableGoogleDriveBackup),
                      subtitle: Text(l10n.enableGoogleDriveBackupDescription),
                      value:
                          settings.googleDriveEnabled && isGoogleDriveSignedIn,
                      onChanged: (value) => _setGoogleDriveBackupEnabled(
                        context,
                        ref,
                        value,
                      ),
                    ),
                    // Sign in/out section
                    if (!isGoogleDriveSignedIn) ...[
                      ListTile(
                        leading: const Icon(Icons.login, color: Colors.blue),
                        title: Text(l10n.signInToGoogleDrive),
                        subtitle: Text(l10n.signInToGoogleDriveDescription),
                        trailing: ElevatedButton.icon(
                          icon: const Icon(Icons.login, size: 18),
                          label: Text(l10n.signIn),
                          onPressed: () => _signInToGoogleDrive(context, ref),
                        ),
                      ),
                    ] else ...[
                      // User info
                      Builder(
                        builder: (context) {
                          final userInfo = ref.watch(googleDriveUserProvider);
                          return ListTile(
                            leading: userInfo['photoUrl'] != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userInfo['photoUrl']!),
                                  )
                                : const CircleAvatar(child: Icon(Icons.person)),
                            title:
                                Text(userInfo['displayName'] ?? 'Google User'),
                            subtitle: Text(userInfo['email'] ?? ''),
                            trailing: TextButton(
                              onPressed: () => _signOutFromGoogleDrive(ref),
                              child: Text(l10n.signOut),
                            ),
                          );
                        },
                      ),
                      // Backup button
                      ListTile(
                        leading:
                            const Icon(Icons.cloud_upload, color: Colors.green),
                        title: Text(l10n.backupToGoogleDrive),
                        subtitle: settings.lastGoogleDriveSync != null
                            ? Text(l10n.lastSync(_formatDateTime(
                                context, settings.lastGoogleDriveSync!)))
                            : Text(l10n.neverSynced),
                        trailing: ElevatedButton.icon(
                          icon: const Icon(Icons.backup, size: 18),
                          label: Text(l10n.backup),
                          onPressed: () => _backupToGoogleDrive(context, ref),
                        ),
                      ),
                    ],
                  ],
                ),

                // Google Drive backups list (only when signed in)
                if (isGoogleDriveSignedIn) ...[
                  const SizedBox(height: 16),
                  _buildSection(
                    context: context,
                    title: l10n.googleDriveBackups,
                    children: [
                      googleDriveBackupsAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text('${l10n.error}: $error',
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ),
                        data: (backups) {
                          if (backups.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Column(
                                  children: [
                                    const Icon(Icons.cloud_outlined,
                                        size: 48, color: AppTheme.textMuted),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.noCloudBackups,
                                      style: const TextStyle(
                                          color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: backups
                                .map((backup) => _GoogleDriveBackupTile(
                                      backup: backup,
                                      onRestore: () =>
                                          _showGoogleDriveRestoreDialog(
                                              context, ref, backup),
                                      onDelete: () =>
                                          _confirmDeleteGoogleDriveBackup(
                                              context, ref, backup),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // Restore settings
                _buildSection(
                  context: context,
                  title: l10n.restoreSettings,
                  children: [
                    ListTile(
                      title: Text(l10n.defaultRestoreMode),
                      subtitle: Text(_restoreModeDescription(
                        settings.defaultRestoreMode,
                        l10n,
                      )),
                      trailing: DropdownButton<RestoreMode>(
                        value: settings.defaultRestoreMode,
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(cloudBackupSettingsProvider.notifier)
                                .setDefaultRestoreMode(value);
                          }
                        },
                        items: RestoreMode.values.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(_restoreModeName(mode, l10n)),
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
                      leading: const Icon(Icons.info_outline,
                          color: AppTheme.accentColor),
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
                            ref
                                .read(cloudBackupOperationProvider.notifier)
                                .clearError();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                if (operationState.warning != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l10n.mediaBackupPartialSuccess)),
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

  Future<void> _runManualAutoSync(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    await ref.read(cloudBackupOperationProvider.notifier).runAutoSync(
          loadData: dbBackupService.exportAllData,
          restoreCallback: (data, restoreMode) async {
            final importMode = _convertToImportMode(restoreMode);
            final actualData = data['data'] as Map<String, dynamic>? ?? data;
            await dbBackupService.importData(
              data: actualData,
              mode: importMode,
            );
          },
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.crossDeviceSyncComplete)),
      );
    }
  }

  void _backupToICloud(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);

    // Get actual data from database
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    final result = await ref
        .read(cloudBackupOperationProvider.notifier)
        .uploadToICloud(dbBackupService.exportAllData);

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupCreated)),
      );
    }
  }

  void _showRestoreDialog(
      BuildContext context, WidgetRef ref, CloudBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);

    showDialog<void>(
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

          final result = await ref
              .read(cloudBackupOperationProvider.notifier)
              .downloadFromICloud(
                backup: backup,
                mode: mode,
                localData: localData,
                restoreCallback: (data, restoreMode) async {
                  // Actually restore data to database
                  final importMode = _convertToImportMode(restoreMode);
                  final actualData =
                      data['data'] as Map<String, dynamic>? ?? data;
                  await dbBackupService.importData(
                    data: actualData,
                    mode: importMode,
                  );
                },
              );

          if (result != null && context.mounted) {
            final operation = ref.read(cloudBackupOperationProvider);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_restoreResultMessage(
                  l10n: l10n,
                  added: result.totalAdded,
                  updated: result.totalUpdated,
                  skipped: result.totalSkipped,
                  operation: operation,
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

  void _confirmDeleteBackup(
      BuildContext context, WidgetRef ref, CloudBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
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
              await ref
                  .read(cloudBackupOperationProvider.notifier)
                  .deleteICloudBackup(backup);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  // ============ Google Drive Methods ============

  Future<bool> _ensureGoogleDriveSyncReady(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (ref.read(googleDriveSignedInProvider)) {
      ref
          .read(cloudBackupSettingsProvider.notifier)
          .setGoogleDriveEnabled(true);
      return true;
    }
    final signedIn = await ref
        .read(cloudBackupOperationProvider.notifier)
        .signInToGoogleDrive();
    if (signedIn) {
      ref
          .read(cloudBackupSettingsProvider.notifier)
          .setGoogleDriveEnabled(true);
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.signedInSuccessfully)),
        );
      }
    }
    return signedIn;
  }

  Future<void> _setGoogleDriveBackupEnabled(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    if (!enabled) {
      ref
          .read(cloudBackupSettingsProvider.notifier)
          .setGoogleDriveEnabled(false);
      return;
    }
    final ready = await _ensureGoogleDriveSyncReady(context, ref);
    if (ready && ref.read(cloudBackupSettingsProvider).autoSyncEnabled) {
      await _runManualAutoSync(context, ref);
    }
  }

  void _signInToGoogleDrive(BuildContext context, WidgetRef ref) async {
    await _ensureGoogleDriveSyncReady(context, ref);
  }

  void _signOutFromGoogleDrive(WidgetRef ref) async {
    await ref
        .read(cloudBackupOperationProvider.notifier)
        .signOutFromGoogleDrive();
  }

  void _backupToGoogleDrive(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);

    // Get actual data from database
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    final result = await ref
        .read(cloudBackupOperationProvider.notifier)
        .uploadToGoogleDrive(dbBackupService.exportAllData);

    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupCreated)),
      );
    }
  }

  void _showGoogleDriveRestoreDialog(
      BuildContext context, WidgetRef ref, GoogleDriveBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);

    showDialog<void>(
      context: context,
      builder: (context) => _RestoreDialog(
        backup: CloudBackupInfo(
          id: backup.id,
          name: backup.name,
          size: backup.size,
          createdAt: backup.createdAt,
          provider: CloudProvider.googleDrive,
          remotePath: backup.id,
        ),
        defaultMode: settings.defaultRestoreMode,
        onRestore: (mode) async {
          Navigator.pop(context);

          // Get database service
          final db = ref.read(databaseProvider);
          final dbBackupService = DatabaseBackupService(db);
          final localData = await dbBackupService.exportAllData();

          final result = await ref
              .read(cloudBackupOperationProvider.notifier)
              .downloadFromGoogleDrive(
                fileId: backup.id,
                mode: mode,
                localData: localData,
                restoreCallback: (data, restoreMode) async {
                  // Actually restore data to database
                  final importMode = _convertToImportMode(restoreMode);
                  final actualData =
                      data['data'] as Map<String, dynamic>? ?? data;
                  await dbBackupService.importData(
                    data: actualData,
                    mode: importMode,
                  );
                },
              );

          if (result != null && context.mounted) {
            final operation = ref.read(cloudBackupOperationProvider);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_restoreResultMessage(
                  l10n: l10n,
                  added: result.totalAdded,
                  updated: result.totalUpdated,
                  skipped: result.totalSkipped,
                  operation: operation,
                )),
              ),
            );
          }
        },
      ),
    );
  }

  void _confirmDeleteGoogleDriveBackup(
      BuildContext context, WidgetRef ref, GoogleDriveBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
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
              await ref
                  .read(cloudBackupOperationProvider.notifier)
                  .deleteGoogleDriveBackup(backup.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _exportBackupToFile(
    BuildContext context,
    WidgetRef ref, {
    bool combined = true,
  }) async {
    final l10n = AppLocalizations.of(context);
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    final localData = await dbBackupService.exportAllData();

    final result = await ref
        .read(cloudBackupOperationProvider.notifier)
        .exportBackupToFile(data: localData, combined: combined);

    if (result != null && result.succeeded && context.mounted) {
      final message = result.savedToFilesApp
          ? l10n.backupSavedToFilesApp
          : l10n.backupSavedToAppFolder;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _shareBackup(
    BuildContext context,
    WidgetRef ref, {
    bool combined = true,
  }) async {
    final l10n = AppLocalizations.of(context);
    final origin = sharePositionOrigin(context);
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    final localData = await dbBackupService.exportAllData();

    final success =
        await ref.read(cloudBackupOperationProvider.notifier).shareBackup(
              data: localData,
              sharePositionOrigin: origin,
              combined: combined,
            );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupExported)),
      );
    }
  }

  void _importFromOpenedPath(
    BuildContext context,
    WidgetRef ref,
    String filePath,
  ) {
    ref.read(pendingBackupImportPathProvider.notifier).state = null;
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);

    showDialog<void>(
      context: context,
      builder: (context) => _RestoreDialog(
        backup: CloudBackupInfo(
          id: 'opened_file',
          name: filePath.split('/').last,
          size: 0,
          createdAt: DateTime.now(),
          provider: CloudProvider.googleDrive,
        ),
        defaultMode: settings.defaultRestoreMode,
        onRestore: (mode) async {
          Navigator.pop(context);

          final db = ref.read(databaseProvider);
          final dbBackupService = DatabaseBackupService(db);
          final localData = await dbBackupService.exportAllData();

          final result = await ref
              .read(cloudBackupOperationProvider.notifier)
              .importFromPath(
                filePath: filePath,
                mode: mode,
                localData: localData,
                restoreCallback: (data, restoreMode) async {
                  final importMode = _convertToImportMode(restoreMode);
                  final actualData =
                      data['data'] as Map<String, dynamic>? ?? data;
                  await dbBackupService.importData(
                    data: actualData,
                    mode: importMode,
                  );
                },
              );

          if (result != null && context.mounted) {
            final operation = ref.read(cloudBackupOperationProvider);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_restoreResultMessage(
                  l10n: l10n,
                  added: result.totalAdded,
                  updated: result.totalUpdated,
                  skipped: result.totalSkipped,
                  operation: operation,
                )),
              ),
            );
          }
        },
      ),
    );
  }

  void _importFromFile(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);

    showDialog<void>(
      context: context,
      builder: (context) => _RestoreDialog(
        backup: CloudBackupInfo(
          id: 'local_file',
          name: l10n.importNtbBackup,
          size: 0,
          createdAt: DateTime.now(),
          provider: CloudProvider.googleDrive,
        ),
        defaultMode: settings.defaultRestoreMode,
        onRestore: (mode) async {
          Navigator.pop(context);

          final db = ref.read(databaseProvider);
          final dbBackupService = DatabaseBackupService(db);
          final localData = await dbBackupService.exportAllData();

          final result = await ref
              .read(cloudBackupOperationProvider.notifier)
              .importFromFile(
                mode: mode,
                localData: localData,
                restoreCallback: (data, restoreMode) async {
                  final importMode = _convertToImportMode(restoreMode);
                  final actualData =
                      data['data'] as Map<String, dynamic>? ?? data;
                  await dbBackupService.importData(
                    data: actualData,
                    mode: importMode,
                  );
                },
              );

          if (result != null && context.mounted) {
            final operation = ref.read(cloudBackupOperationProvider);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_restoreResultMessage(
                  l10n: l10n,
                  added: result.totalAdded,
                  updated: result.totalUpdated,
                  skipped: result.totalSkipped,
                  operation: operation,
                )),
              ),
            );
          }
        },
      ),
    );
  }
}

String _restoreModeName(RestoreMode mode, AppLocalizations l10n) =>
    switch (mode) {
      RestoreMode.replace => l10n.restoreModeReplace,
      RestoreMode.merge => l10n.restoreModeMerge,
      RestoreMode.addNewOnly => l10n.restoreModeAddNewOnly,
    };

String _operationStageLabel(
  AppLocalizations l10n,
  CloudBackupOperationState operation,
) {
  final stage = operation.stage;
  if (stage == null) return operation.currentOperation ?? l10n.processing;
  return switch (stage) {
    CloudBackupOperationStage.preparingData => l10n.backupStagePreparingData,
    CloudBackupOperationStage.scanningMedia => l10n.backupStageScanningMedia,
    CloudBackupOperationStage.compressingMedia =>
      l10n.backupStageCompressingMedia(
        operation.processedItems ?? 0,
        operation.totalItems ?? 0,
      ),
    CloudBackupOperationStage.uploadingData => l10n.backupStageUploadingData,
    CloudBackupOperationStage.uploadingMedia => l10n.backupStageUploadingMedia,
    CloudBackupOperationStage.downloadingData =>
      l10n.backupStageDownloadingData,
    CloudBackupOperationStage.downloadingMedia =>
      l10n.backupStageDownloadingMedia,
    CloudBackupOperationStage.verifyingMedia => l10n.backupStageVerifyingMedia,
    CloudBackupOperationStage.restoringMedia => l10n.backupStageRestoringMedia(
        operation.processedItems ?? 0,
        operation.totalItems ?? 0,
      ),
    CloudBackupOperationStage.restoringData => l10n.backupStageRestoringData,
  };
}

String _restoreModeDescription(RestoreMode mode, AppLocalizations l10n) =>
    switch (mode) {
      RestoreMode.replace => l10n.restoreModeReplaceDescription,
      RestoreMode.merge => l10n.restoreModeMergeDescription,
      RestoreMode.addNewOnly => l10n.restoreModeAddNewOnlyDescription,
    };

String _restoreResultMessage({
  required AppLocalizations l10n,
  required int added,
  required int updated,
  required int skipped,
  required CloudBackupOperationState operation,
}) {
  final lines = [l10n.restoreComplete(added, updated, skipped)];
  if (operation.warning != null) {
    lines.add(l10n.mediaBackupPartialSuccess);
  } else if (operation.mediaRestoredFiles != null) {
    lines.add(l10n.mediaRestoreComplete(operation.mediaRestoredFiles!));
  } else if (operation.mediaIncluded == false) {
    lines.add(l10n.mediaNotIncludedInBackup);
  }
  final categoryNames = operation.mediaCategories
      ?.map((category) => switch (category) {
            CloudMediaCategory.characterImages => l10n.characterCardImages,
            CloudMediaCategory.worldInfoImages => l10n.worldBookImages,
            CloudMediaCategory.conversationImages => l10n.conversationImages,
            CloudMediaCategory.backgrounds => l10n.backgroundImages,
            CloudMediaCategory.live2d => l10n.live2DBackup,
          })
      .toList();
  if (categoryNames != null && categoryNames.isNotEmpty) {
    lines.add('${l10n.backupContents}: ${categoryNames.join(', ')}');
  }
  return lines.join('\n');
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
        color: backup.provider == CloudProvider.iCloud
            ? Colors.blue
            : Colors.orange,
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

/// Tile for displaying a Google Drive backup
class _GoogleDriveBackupTile extends StatelessWidget {
  final GoogleDriveBackupInfo backup;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  const _GoogleDriveBackupTile({
    required this.backup,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListTile(
      leading: const Icon(Icons.cloud, color: Colors.green),
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
                title: Text(_restoreModeName(mode, l10n)),
                subtitle: Text(_restoreModeDescription(mode, l10n)),
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
