import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/backup_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/backup_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Screen for managing backups
class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(backupSettingsProvider);
    final operationState = ref.watch(backupOperationProvider);
    final chatBackupsAsync = ref.watch(chatBackupsProvider);
    final fullBackupsAsync = ref.watch(fullBackupsProvider);
    final totalSizeAsync = ref.watch(totalBackupSizeProvider);

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
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Storage info
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
                    if (settings.lastAutoBackup != null)
                      ListTile(
                        leading: const Icon(Icons.schedule, color: AppTheme.textMuted),
                        title: Text(l10n.lastAutoBackup),
                        subtitle: Text(_formatDateTime(context, settings.lastAutoBackup!)),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Auto-backup settings
                _buildSection(
                  context: context,
                  title: l10n.autoBackup,
                  children: [
                    SwitchListTile(
                      title: Text(l10n.enableAutoBackup),
                      subtitle: Text(l10n.automaticallyBackupChats),
                      value: settings.autoBackupEnabled,
                      onChanged: (value) {
                        ref.read(backupSettingsProvider.notifier).setAutoBackupEnabled(value);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.backupInterval),
                      subtitle: Text(settings.autoBackupInterval.displayName),
                      trailing: DropdownButton<AutoBackupInterval>(
                        value: settings.autoBackupInterval,
                        onChanged: settings.autoBackupEnabled
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
                      title: Text(l10n.backupOnExit),
                      subtitle: Text(l10n.createBackupWhenClosingApp),
                      value: settings.backupOnExit,
                      onChanged: (value) {
                        ref.read(backupSettingsProvider.notifier).setBackupOnExit(value);
                      },
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
                      subtitle: Text(l10n.keepUpToChatBackups(settings.maxChatBackups)),
                      trailing: SizedBox(
                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: settings.maxChatBackups.toString()),
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
                      subtitle: Text(l10n.keepUpToFullBackups(settings.maxFullBackups)),
                      trailing: SizedBox(
                        width: 80,
                        child: TextField(
                          controller: TextEditingController(text: settings.maxFullBackups.toString()),
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

                // Chat backups
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

                // Full backups
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
                            ref.read(backupOperationProvider.notifier).clearError();
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