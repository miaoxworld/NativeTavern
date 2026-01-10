import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/backup_service.dart';
import 'package:native_tavern/presentation/providers/backup_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Screen for managing backups
class BackupSettingsScreen extends ConsumerWidget {
  const BackupSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(backupSettingsProvider);
    final operationState = ref.watch(backupOperationProvider);
    final chatBackupsAsync = ref.watch(chatBackupsProvider);
    final fullBackupsAsync = ref.watch(fullBackupsProvider);
    final totalSizeAsync = ref.watch(totalBackupSizeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
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
                  Text(operationState.currentOperation ?? 'Processing...'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Storage info
                _buildSection(
                  title: 'Storage',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.storage, color: AppTheme.accentColor),
                      title: const Text('Total Backup Size'),
                      subtitle: totalSizeAsync.when(
                        loading: () => const Text('Calculating...'),
                        error: (_, __) => const Text('Error'),
                        data: (size) => Text(BackupService.instance.formatFileSize(size)),
                      ),
                    ),
                    if (settings.lastAutoBackup != null)
                      ListTile(
                        leading: const Icon(Icons.schedule, color: AppTheme.textMuted),
                        title: const Text('Last Auto-Backup'),
                        subtitle: Text(_formatDateTime(settings.lastAutoBackup!)),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Auto-backup settings
                _buildSection(
                  title: 'Auto-Backup',
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Auto-Backup'),
                      subtitle: const Text('Automatically backup chats'),
                      value: settings.autoBackupEnabled,
                      onChanged: (value) {
                        ref.read(backupSettingsProvider.notifier).setAutoBackupEnabled(value);
                      },
                    ),
                    ListTile(
                      title: const Text('Backup Interval'),
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
                      title: const Text('Backup on Exit'),
                      subtitle: const Text('Create backup when closing app'),
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
                  title: 'Retention',
                  children: [
                    ListTile(
                      title: const Text('Max Chat Backups'),
                      subtitle: Text('Keep up to ${settings.maxChatBackups} chat backups'),
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
                      title: const Text('Max Full Backups'),
                      subtitle: Text('Keep up to ${settings.maxFullBackups} full backups'),
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
                      title: const Text('Cleanup Old Backups'),
                      subtitle: const Text('Delete backups exceeding limits'),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          final deleted = await ref.read(backupOperationProvider.notifier).cleanupOldBackups();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Deleted $deleted old backups')),
                            );
                          }
                        },
                        child: const Text('Cleanup'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Chat backups
                _buildSection(
                  title: 'Chat Backups',
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
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.backup, size: 48, color: AppTheme.textMuted),
                                  SizedBox(height: 16),
                                  Text(
                                    'No chat backups',
                                    style: TextStyle(color: AppTheme.textMuted),
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
                        child: Text('View all ${chatBackupsAsync.valueOrNull!.length} backups'),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Full backups
                _buildSection(
                  title: 'Full Backups',
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
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.backup, size: 48, color: AppTheme.textMuted),
                                  SizedBox(height: 16),
                                  Text(
                                    'No full backups',
                                    style: TextStyle(color: AppTheme.textMuted),
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
                  title: 'Information',
                  children: [
                    const ListTile(
                      leading: Icon(Icons.info_outline, color: AppTheme.accentColor),
                      title: Text('About Backups'),
                      subtitle: Text(
                        'Chat backups save individual conversations. '
                        'Full backups include all characters, chats, settings, and world info.',
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.folder, color: AppTheme.textMuted),
                      title: Text('Backup Location'),
                      subtitle: Text('Documents/NativeTavern/backups/'),
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} minutes ago';
    if (diff.inDays < 1) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

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
          SnackBar(content: Text('Error reading backup: $e')),
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
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonContent));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBackup(BuildContext context, WidgetRef ref, BackupInfo backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Backup'),
        content: Text('Delete "${backup.name}"?\n\nThis cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Delete'),
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
            tooltip: 'View',
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      onTap: onView,
    );
  }
}