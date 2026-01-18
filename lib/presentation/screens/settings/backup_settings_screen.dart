import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/domain/services/backup_service.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
import 'package:native_tavern/domain/services/google_drive_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/backup_providers.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Screen for managing backups (local + cloud)
class BackupSettingsScreen extends ConsumerStatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  ConsumerState<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends ConsumerState<BackupSettingsScreen> {
  bool _isAutoLoggingIn = false;
  
  @override
  void initState() {
    super.initState();
    // Try to auto-login to Google Drive if previously signed in
    _tryAutoLoginGoogleDrive();
  }
  
  Future<void> _tryAutoLoginGoogleDrive() async {
    // If already signed in, no need to do anything
    if (ref.read(googleDriveSignedInProvider)) return;
    
    setState(() => _isAutoLoggingIn = true);
    
    try {
      // Try silent sign-in only (won't show UI if no cached credentials)
      final service = GoogleDriveService.instance;
      final success = await service.trySilentSignIn();
      
      if (success && mounted) {
        ref.read(googleDriveSignedInProvider.notifier).state = true;
        ref.invalidate(googleDriveUserProvider);
        ref.invalidate(googleDriveBackupsProvider);
      }
    } catch (e) {
      debugPrint('Auto login to Google Drive failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isAutoLoggingIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localSettings = ref.watch(backupSettingsProvider);
    final cloudSettings = ref.watch(cloudBackupSettingsProvider);
    final localOperationState = ref.watch(backupOperationProvider);
    final cloudOperationState = ref.watch(cloudBackupOperationProvider);
    final chatBackupsAsync = ref.watch(chatBackupsProvider);
    final fullBackupsAsync = ref.watch(fullBackupsProvider);
    final totalSizeAsync = ref.watch(totalBackupSizeProvider);
    final iCloudAvailable = ref.watch(iCloudAvailableProvider);
    final iCloudBackupsAsync = ref.watch(iCloudBackupsProvider);
    final isGoogleDriveSignedIn = ref.watch(googleDriveSignedInProvider);
    final googleDriveBackupsAsync = ref.watch(googleDriveBackupsProvider);
    
    final isLoading = localOperationState.isLoading || cloudOperationState.isLoading;
    final currentOperation = localOperationState.currentOperation ?? cloudOperationState.currentOperation;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.backupAndRestore),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: () {
              ref.invalidate(chatBackupsProvider);
              ref.invalidate(fullBackupsProvider);
              ref.invalidate(totalBackupSizeProvider);
              ref.invalidate(iCloudBackupsProvider);
              ref.invalidate(iCloudAvailableProvider);
              ref.invalidate(googleDriveBackupsProvider);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(currentOperation ?? l10n.processing),
                  if (cloudOperationState.progress != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: cloudOperationState.progress,
                        backgroundColor: AppTheme.darkCard,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(cloudOperationState.progress! * 100).toInt()}%',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Auto-backup settings (affects both local and cloud)
                _buildSection(
                  context: context,
                  title: l10n.autoBackup,
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.backup_outlined),
                      title: Text(l10n.enableAutoBackup),
                      subtitle: Text(l10n.automaticallyBackupChats),
                      value: localSettings.autoBackupEnabled,
                      onChanged: (value) {
                        ref.read(backupSettingsProvider.notifier).setAutoBackupEnabled(value);
                        // Also sync to cloud settings
                        ref.read(cloudBackupSettingsProvider.notifier).setAutoSyncEnabled(value);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(l10n.backupInterval),
                      subtitle: Text(localSettings.autoBackupInterval.displayName),
                      trailing: DropdownButton<AutoBackupInterval>(
                        value: localSettings.autoBackupInterval,
                        onChanged: localSettings.autoBackupEnabled
                            ? (value) {
                                if (value != null) {
                                  ref.read(backupSettingsProvider.notifier).setAutoBackupInterval(value);
                                }
                              }
                            : null,
                        items: AutoBackupInterval.values.map((interval) {
                          return DropdownMenuItem(
                            value: interval,
                            child: Text(interval.displayName),
                          );
                        }).toList(),
                      ),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.exit_to_app),
                      title: Text(l10n.backupOnExit),
                      subtitle: Text(l10n.createBackupWhenClosingApp),
                      value: localSettings.backupOnExit,
                      onChanged: (value) {
                        ref.read(backupSettingsProvider.notifier).setBackupOnExit(value);
                      },
                    ),
                    if (localSettings.lastAutoBackup != null)
                      ListTile(
                        leading: const Icon(Icons.access_time, color: AppTheme.textMuted),
                        title: Text(l10n.lastAutoBackup),
                        subtitle: Text(_formatDateTime(context, localSettings.lastAutoBackup!)),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Google Drive section
                _buildSection(
                  context: context,
                  title: 'Google Drive',
                  children: [
                    if (_isAutoLoggingIn)
                      const ListTile(
                        leading: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        title: Text('Connecting to Google Drive...'),
                      )
                    else if (!isGoogleDriveSignedIn) ...[
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
                                    backgroundImage: NetworkImage(userInfo['photoUrl']!),
                                  )
                                : const CircleAvatar(child: Icon(Icons.person)),
                            title: Text(userInfo['displayName'] ?? 'Google User'),
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
                        leading: const Icon(Icons.cloud_upload, color: Colors.green),
                        title: Text(l10n.backupToGoogleDrive),
                        subtitle: cloudSettings.lastGoogleDriveSync != null
                            ? Text(l10n.lastSync(_formatDateTime(context, cloudSettings.lastGoogleDriveSync!)))
                            : Text(l10n.neverSynced),
                        trailing: ElevatedButton.icon(
                          icon: const Icon(Icons.backup, size: 18),
                          label: Text(l10n.backup),
                          onPressed: () => _backupToGoogleDrive(context, ref),
                        ),
                      ),
                      // Google Drive backups list
                      googleDriveBackupsAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
                          ),
                        ),
                        data: (backups) {
                          if (backups.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Text(
                                  l10n.noCloudBackups,
                                  style: const TextStyle(color: AppTheme.textMuted),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: backups.take(3).map((backup) => _GoogleDriveBackupTile(
                              backup: backup,
                              onRestore: () => _showGoogleDriveRestoreDialog(context, ref, backup),
                              onDelete: () => _confirmDeleteGoogleDriveBackup(context, ref, backup),
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // iCloud section (iOS/macOS only)
                if (Platform.isIOS || Platform.isMacOS)
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
                                value: cloudSettings.iCloudEnabled,
                                onChanged: (value) {
                                  ref.read(cloudBackupSettingsProvider.notifier).setICloudEnabled(value);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.cloud_upload, color: Colors.blue),
                                title: Text(l10n.backupToICloud),
                                subtitle: cloudSettings.lastICloudSync != null
                                    ? Text(l10n.lastSync(_formatDateTime(context, cloudSettings.lastICloudSync!)))
                                    : Text(l10n.neverSynced),
                                trailing: ElevatedButton.icon(
                                  icon: const Icon(Icons.backup, size: 18),
                                  label: Text(l10n.backup),
                                  onPressed: () => _backupToICloud(context, ref),
                                ),
                              ),
                              // iCloud backups list
                              iCloudBackupsAsync.when(
                                loading: () => const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                                error: (error, _) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
                                  ),
                                ),
                                data: (backups) {
                                  if (backups.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Center(
                                        child: Text(
                                          l10n.noCloudBackups,
                                          style: const TextStyle(color: AppTheme.textMuted),
                                        ),
                                      ),
                                    );
                                  }
                                  return Column(
                                    children: backups.take(3).map((backup) => _CloudBackupTile(
                                      backup: backup,
                                      onRestore: () => _showRestoreDialog(context, ref, backup),
                                      onDelete: () => _confirmDeleteCloudBackup(context, ref, backup),
                                    )).toList(),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                if (Platform.isIOS || Platform.isMacOS)
                  const SizedBox(height: 16),

                // Local backup storage info
                _buildSection(
                  context: context,
                  title: l10n.storage,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.storage, color: AppTheme.accentColor),
                      title: Text(l10n.totalBackupSize),
                      subtitle: totalSizeAsync.when(
                        loading: () => Text(l10n.calculating),
                        error: (_, __) => Text(l10n.error),
                        data: (size) => Text(BackupService.instance.formatFileSize(size)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Retention settings
                _buildSection(
                  context: context,
                  title: l10n.retention,
                  children: [
                    ListTile(
                      title: Text(l10n.maxChatBackups),
                      subtitle: Text(l10n.keepUpToChatBackups(localSettings.maxChatBackups)),
                      trailing: SizedBox(
                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: localSettings.maxChatBackups.toString()),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onSubmitted: (value) {
                            final num = int.tryParse(value);
                            if (num != null && num > 0) {
                              ref.read(backupSettingsProvider.notifier).setMaxChatBackups(num);
                            }
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(l10n.maxFullBackups),
                      subtitle: Text(l10n.keepUpToFullBackups(localSettings.maxFullBackups)),
                      trailing: SizedBox(
                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: localSettings.maxFullBackups.toString()),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onSubmitted: (value) {
                            final num = int.tryParse(value);
                            if (num != null && num > 0) {
                              ref.read(backupSettingsProvider.notifier).setMaxFullBackups(num);
                            }
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cleaning_services),
                      title: Text(l10n.cleanupOldBackups),
                      subtitle: Text(l10n.deleteBackupsExceedingLimits),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          final deleted = await ref.read(backupOperationProvider.notifier).cleanupOldBackups();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.deletedOldBackups(deleted))),
                            );
                          }
                        },
                        child: Text(l10n.cleanup),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Local Chat backups
                _buildSection(
                  context: context,
                  title: l10n.chatBackups,
                  children: [
                    chatBackupsAsync.when(
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
                                  const Icon(Icons.backup, size: 48, color: AppTheme.textMuted),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.noChatBackups,
                                    style: const TextStyle(color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: backups.take(10).map((backup) => _BackupTile(
                            backup: backup,
                            onView: () => _viewBackup(context, ref, backup),
                            onDelete: () => _confirmDeleteBackup(context, ref, backup),
                          )).toList(),
                        );
                      },
                    ),
                    if (chatBackupsAsync.valueOrNull?.isNotEmpty == true &&
                        chatBackupsAsync.valueOrNull!.length > 10)
                      TextButton(
                        onPressed: () => _showAllBackups(context, ref, BackupType.chat),
                        child: Text(l10n.viewAllBackups(chatBackupsAsync.valueOrNull!.length)),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Local Full backups
                _buildSection(
                  context: context,
                  title: l10n.fullBackups,
                  children: [
                    fullBackupsAsync.when(
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
                                  const Icon(Icons.backup, size: 48, color: AppTheme.textMuted),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.noFullBackups,
                                    style: const TextStyle(color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: backups.map((backup) => _BackupTile(
                            backup: backup,
                            onView: () => _viewBackup(context, ref, backup),
                            onDelete: () => _confirmDeleteBackup(context, ref, backup),
                          )).toList(),
                        );
                      },
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
                      subtitle: Text(cloudSettings.defaultRestoreMode.description),
                      trailing: DropdownButton<RestoreMode>(
                        value: cloudSettings.defaultRestoreMode,
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

                // Info section
                _buildSection(
                  context: context,
                  title: l10n.information,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: AppTheme.accentColor),
                      title: Text(l10n.aboutBackups),
                      subtitle: Text(l10n.aboutBackupsDescription),
                    ),
                    ListTile(
                      leading: const Icon(Icons.folder, color: AppTheme.textMuted),
                      title: Text(l10n.backupLocation),
                      subtitle: const Text('Documents/NativeTavern/backups/'),
                    ),
                  ],
                ),

                // Error display
                if (localOperationState.error != null || cloudOperationState.error != null) ...[
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
                            localOperationState.error ?? cloudOperationState.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            ref.read(backupOperationProvider.notifier).clearError();
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

  void _viewBackup(BuildContext context, WidgetRef ref, BackupInfo backup) async {
    final service = ref.read(backupServiceProvider);
    
    try {
      if (backup.type == BackupType.chat) {
        final data = await service.readChatBackup(backup.path);
        if (context.mounted) {
          _showBackupContent(context, backup, data.messages);
        }
      } else {
        final data = await service.readFullBackup(backup.path);
        if (context.mounted) {
          _showBackupContent(context, backup, [data]);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).errorReadingBackup(e.toString()))),
        );
      }
    }
  }

  void _showBackupContent(BuildContext context, BackupInfo backup, List<dynamic> content) {
    final encoder = JsonEncoder.withIndent('  ');
    final jsonContent = encoder.convert(content);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(backup.name),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              jsonContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).close),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonContent));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context).copiedToClipboard)),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(AppLocalizations.of(context).copy),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBackup(BuildContext context, WidgetRef ref, BackupInfo backup) {
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
              if (backup.type == BackupType.chat) {
                await ref.read(backupOperationProvider.notifier).deleteChatBackup(backup.path);
              } else {
                await ref.read(backupOperationProvider.notifier).deleteFullBackup(backup.path);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showAllBackups(BuildContext context, WidgetRef ref, BackupType type) {
    final backupsAsync = type == BackupType.chat
        ? ref.read(chatBackupsProvider)
        : ref.read(fullBackupsProvider);

    backupsAsync.whenData((backups) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppTheme.darkCard,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${type == BackupType.chat ? 'Chat' : 'Full'} Backups (${backups.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: backups.length,
                  itemBuilder: (context, index) {
                    final backup = backups[index];
                    return _BackupTile(
                      backup: backup,
                      onView: () {
                        Navigator.pop(context);
                        _viewBackup(context, ref, backup);
                      },
                      onDelete: () {
                        Navigator.pop(context);
                        _confirmDeleteBackup(context, ref, backup);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ============ Cloud Backup Methods ============
  
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
  
  void _showRestoreDialog(BuildContext context, WidgetRef ref, CloudBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);
    
    showDialog(
      context: context,
      builder: (context) => _RestoreDialog(
        backupName: backup.name,
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
  
  void _confirmDeleteCloudBackup(BuildContext context, WidgetRef ref, CloudBackupInfo backup) {
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
  
  // ============ Google Drive Methods ============
  
  void _signInToGoogleDrive(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final success = await ref.read(cloudBackupOperationProvider.notifier).signInToGoogleDrive();
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.signedInSuccessfully)),
      );
    }
  }
  
  void _signOutFromGoogleDrive(WidgetRef ref) async {
    await ref.read(cloudBackupOperationProvider.notifier).signOutFromGoogleDrive();
  }
  
  void _backupToGoogleDrive(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    
    // Get actual data from database
    final db = ref.read(databaseProvider);
    final dbBackupService = DatabaseBackupService(db);
    final data = await dbBackupService.exportAllData();

    final result = await ref.read(cloudBackupOperationProvider.notifier).uploadToGoogleDrive(data);
    
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupCreated)),
      );
    }
  }
  
  void _showGoogleDriveRestoreDialog(BuildContext context, WidgetRef ref, GoogleDriveBackupInfo backup) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(cloudBackupSettingsProvider);
    
    showDialog(
      context: context,
      builder: (context) => _RestoreDialog(
        backupName: backup.name,
        defaultMode: settings.defaultRestoreMode,
        onRestore: (mode) async {
          Navigator.pop(context);
          
          // Get database service
          final db = ref.read(databaseProvider);
          final dbBackupService = DatabaseBackupService(db);
          final localData = await dbBackupService.exportAllData();
          
          final result = await ref.read(cloudBackupOperationProvider.notifier).downloadFromGoogleDrive(
            fileId: backup.id,
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
  
  void _confirmDeleteGoogleDriveBackup(BuildContext context, WidgetRef ref, GoogleDriveBackupInfo backup) {
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
              await ref.read(cloudBackupOperationProvider.notifier).deleteGoogleDriveBackup(backup.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
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
}

/// Tile for displaying a backup
class _BackupTile extends StatelessWidget {
  final BackupInfo backup;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _BackupTile({
    required this.backup,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        backup.type == BackupType.chat ? Icons.chat : Icons.backup,
        color: backup.type == BackupType.chat ? Colors.blue : Colors.green,
      ),
      title: Text(
        backup.characterName ?? backup.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${backup.formattedSize} • ${backup.formattedDate}',
        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.visibility, size: 20),
            onPressed: onView,
            tooltip: AppLocalizations.of(context).view,
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: onDelete,
            tooltip: AppLocalizations.of(context).delete,
          ),
        ],
      ),
      onTap: onView,
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
  final String backupName;
  final RestoreMode defaultMode;
  final void Function(RestoreMode mode) onRestore;

  const _RestoreDialog({
    required this.backupName,
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
          Text('${l10n.selectRestoreMode}:'),
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