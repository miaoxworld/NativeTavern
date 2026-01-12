import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/presentation/providers/world_info_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Log a message to the console
void _log(String message, {String? error, StackTrace? stackTrace}) {
  final timestamp = DateTime.now().toIso8601String();
  final logMessage = '[$timestamp] WorldInfoScreen: $message';
  
  if (kDebugMode) {
    debugPrint(logMessage);
    if (error != null) {
      debugPrint('  Error: $error');
    }
  }
  
  developer.log(
    message,
    name: 'WorldInfoScreen',
    error: error,
    stackTrace: stackTrace,
  );
}

/// Screen for managing World Info / Lorebooks
class WorldInfoScreen extends ConsumerWidget {
  const WorldInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldInfosAsync = ref.watch(worldInfoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.worldInfoLorebooks),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: AppLocalizations.of(context)!.import,
            onPressed: () => _importWorldInfo(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.createLorebook,
            onPressed: () => _showCreateDialog(context, ref),
          ),
        ],
      ),
      body: worldInfosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(worldInfoNotifierProvider.notifier).refresh(),
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
        data: (worldInfos) {
          if (worldInfos.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: worldInfos.length,
            itemBuilder: (context, index) {
              final worldInfo = worldInfos[index];
              return _WorldInfoCard(
                worldInfo: worldInfo,
                onTap: () => _openWorldInfo(context, worldInfo),
                onEdit: () => _showEditDialog(context, ref, worldInfo),
                onDelete: () => _showDeleteConfirmation(context, ref, worldInfo),
                onToggle: (enabled) {
                  ref.read(worldInfoNotifierProvider.notifier).updateWorldInfo(
                    worldInfo.copyWith(enabled: enabled),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_stories_outlined,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noLorebooksYet,
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              AppLocalizations.of(context)!.lorebooksInjectContext,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateDialog(context, ref),
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.createLorebook),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _WorldInfoDialog(
        title: AppLocalizations.of(context)!.createLorebook,
        onSave: (name, description, isGlobal) async {
          await ref.read(worldInfoNotifierProvider.notifier).createWorldInfo(
            name: name,
            description: description,
            isGlobal: isGlobal,
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, WorldInfo worldInfo) {
    showDialog(
      context: context,
      builder: (context) => _WorldInfoDialog(
        title: AppLocalizations.of(context)!.editGroup,
        initialName: worldInfo.name,
        initialDescription: worldInfo.description,
        initialIsGlobal: worldInfo.isGlobal,
        onSave: (name, description, isGlobal) async {
          await ref.read(worldInfoNotifierProvider.notifier).updateWorldInfo(
            worldInfo.copyWith(
              name: name,
              description: description,
              isGlobal: isGlobal,
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, WorldInfo worldInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteGroup),
        content: Text(AppLocalizations.of(context)!.deleteLorebookConfirmation(worldInfo.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(worldInfoNotifierProvider.notifier).deleteWorldInfo(worldInfo.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _openWorldInfo(BuildContext context, WorldInfo worldInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorldInfoEntriesScreen(worldInfo: worldInfo),
      ),
    );
  }

  Future<void> _importWorldInfo(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      _log('Starting world info import...');
      
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        _log('No file selected');
        return;
      }

      final file = result.files.first;
      _log('Selected file: ${file.name}');
      String jsonString;

      if (file.bytes != null) {
        jsonString = utf8.decode(file.bytes!);
      } else if (file.path != null) {
        jsonString = await File(file.path!).readAsString();
      } else {
        throw Exception('Could not read file');
      }

      _log('File content length: ${jsonString.length} chars');
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _log('Parsed JSON keys: ${json.keys.toList()}');
      
      // Parse entries from different formats
      final parsedEntries = _parseWorldInfoEntries(json);
      _log('Parsed ${parsedEntries.length} entries');
      
      // Get world info name
      final name = json['name']?.toString() ??
                   json['originalData']?['name']?.toString() ??
                   file.name.replaceAll('.json', '');
      final description = json['description']?.toString();
      
      _log('Creating world info: $name');
      
      await ref.read(worldInfoNotifierProvider.notifier).createWorldInfo(
        name: name,
        description: description,
        isGlobal: json['isGlobal'] == true,
      );

      // Import entries
      final createdWorldInfos = ref.read(worldInfoNotifierProvider).valueOrNull ?? [];
      final createdWorldInfo = createdWorldInfos.firstWhere((w) => w.name == name);
      
      _log('Adding ${parsedEntries.length} entries to world info: ${createdWorldInfo.id}');
      
      for (final entry in parsedEntries) {
        try {
          await ref.read(worldInfoNotifierProvider.notifier).addEntry(
            worldInfoId: createdWorldInfo.id,
            keys: entry['keys'] as List<String>,
            content: entry['content'] as String,
            comment: entry['comment'] as String? ?? '',
            secondaryKeys: entry['secondaryKeys'] as List<String>? ?? [],
          );
        } catch (e, st) {
          _log('Failed to add entry: ${entry['keys']}', error: e.toString(), stackTrace: st);
        }
      }

      _log('Import completed successfully');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.importedAndApplied(name))),
        );
      }
    } catch (e, st) {
      _log('Import failed', error: e.toString(), stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.importFailed(e.toString())}')),
        );
      }
    }
  }
  
  /// Parse world info entries from various formats (SillyTavern, NativeTavern, etc.)
  List<Map<String, dynamic>> _parseWorldInfoEntries(Map<String, dynamic> json) {
    final entries = <Map<String, dynamic>>[];
    
    // Check for SillyTavern format: entries is a Map<String, Entry>
    if (json['entries'] is Map) {
      _log('Detected SillyTavern format (entries as Map)');
      final entriesMap = json['entries'] as Map<String, dynamic>;
      
      for (final entry in entriesMap.entries) {
        try {
          final entryData = entry.value as Map<String, dynamic>;
          entries.add(_parseEntry(entryData));
        } catch (e, st) {
          _log('Failed to parse entry ${entry.key}', error: e.toString(), stackTrace: st);
        }
      }
    }
    // Check for NativeTavern format: entries is a List<Entry>
    else if (json['entries'] is List) {
      _log('Detected NativeTavern format (entries as List)');
      final entriesList = json['entries'] as List<dynamic>;
      
      for (var i = 0; i < entriesList.length; i++) {
        try {
          final entryData = entriesList[i] as Map<String, dynamic>;
          entries.add(_parseEntry(entryData));
        } catch (e, st) {
          _log('Failed to parse entry at index $i', error: e.toString(), stackTrace: st);
        }
      }
    }
    
    return entries;
  }
  
  /// Parse a single entry, handling type conversions
  Map<String, dynamic> _parseEntry(Map<String, dynamic> data) {
    // Handle keys - SillyTavern uses 'key', NativeTavern uses 'keys'
    List<String> keys;
    if (data['keys'] != null) {
      keys = _parseStringList(data['keys']);
    } else if (data['key'] != null) {
      keys = _parseStringList(data['key']);
    } else {
      keys = [];
    }
    
    // Handle secondary keys
    List<String> secondaryKeys;
    if (data['secondaryKeys'] != null) {
      secondaryKeys = _parseStringList(data['secondaryKeys']);
    } else if (data['secondary_keys'] != null) {
      secondaryKeys = _parseStringList(data['secondary_keys']);
    } else if (data['keysecondary'] != null) {
      secondaryKeys = _parseStringList(data['keysecondary']);
    } else {
      secondaryKeys = [];
    }
    
    // Handle content
    final content = data['content']?.toString() ?? '';
    
    // Handle comment
    final comment = data['comment']?.toString() ?? '';
    
    return {
      'keys': keys,
      'secondaryKeys': secondaryKeys,
      'content': content,
      'comment': comment,
    };
  }
  
  /// Safely parse a list of strings from various formats
  List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }
    if (value is String) {
      // Handle comma-separated string
      return value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }
    return [];
  }
}

/// Card widget for displaying a World Info
class _WorldInfoCard extends StatelessWidget {
  final WorldInfo worldInfo;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _WorldInfoCard({
    required this.worldInfo,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.darkCard,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: worldInfo.enabled
                      ? AppTheme.primaryColor.withValues(alpha: 0.2)
                      : AppTheme.textMuted.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_stories,
                  color: worldInfo.enabled ? AppTheme.primaryColor : AppTheme.textMuted,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            worldInfo.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (worldInfo.isGlobal)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.globalScope,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.entriesCount(worldInfo.entries.length),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    if (worldInfo.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        worldInfo.description!,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Switch(
                value: worldInfo.enabled,
                onChanged: onToggle,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppTheme.textMuted),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'export':
                      _exportWorldInfo(context, worldInfo);
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: const Icon(Icons.edit),
                      title: Text(AppLocalizations.of(context)!.edit),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'export',
                    child: ListTile(
                      leading: const Icon(Icons.file_upload),
                      title: Text(AppLocalizations.of(context)!.export),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _exportWorldInfo(BuildContext context, WorldInfo worldInfo) async {
    try {
      final json = worldInfo.toJson();
      final jsonString = const JsonEncoder.withIndent('  ').convert(json);

      final tempDir = await getTemporaryDirectory();
      final fileName = '${worldInfo.name.replaceAll(RegExp(r'[^\w\s-]'), '_')}.json';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonString);

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'NativeTavern World Info: ${worldInfo.name}',
      );
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.exportFailed(e.toString()))),
        );
      }
    }
  }
}

/// Dialog for creating/editing World Info
class _WorldInfoDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialDescription;
  final bool initialIsGlobal;
  final Future<void> Function(String name, String? description, bool isGlobal) onSave;

  const _WorldInfoDialog({
    required this.title,
    this.initialName,
    this.initialDescription,
    this.initialIsGlobal = true,
    required this.onSave,
  });

  @override
  State<_WorldInfoDialog> createState() => _WorldInfoDialogState();
}

class _WorldInfoDialogState extends State<_WorldInfoDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late bool _isGlobal;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    _isGlobal = widget.initialIsGlobal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name,
                hintText: AppLocalizations.of(context)!.enterLorebookName,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.description,
                hintText: AppLocalizations.of(context)!.optionalDescriptionHint,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.globalScope),
              subtitle: Text(AppLocalizations.of(context)!.applyToAllChats),
              value: _isGlobal,
              onChanged: (value) => setState(() => _isGlobal = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterName2)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onSave(
        name,
        _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        _isGlobal,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }
}

/// Screen for managing entries within a World Info
class WorldInfoEntriesScreen extends ConsumerStatefulWidget {
  final WorldInfo worldInfo;

  const WorldInfoEntriesScreen({super.key, required this.worldInfo});

  @override
  ConsumerState<WorldInfoEntriesScreen> createState() => _WorldInfoEntriesScreenState();
}

class _WorldInfoEntriesScreenState extends ConsumerState<WorldInfoEntriesScreen> {
  late WorldInfo _worldInfo;

  @override
  void initState() {
    super.initState();
    _worldInfo = widget.worldInfo;
  }

  void _refreshWorldInfo() async {
    final worldInfos = ref.read(worldInfoNotifierProvider).valueOrNull ?? [];
    final updated = worldInfos.firstWhere(
      (w) => w.id == _worldInfo.id,
      orElse: () => _worldInfo,
    );
    setState(() => _worldInfo = updated);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes
    ref.listen(worldInfoNotifierProvider, (previous, next) {
      _refreshWorldInfo();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_worldInfo.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.addEntry,
            onPressed: () => _showEntryDialog(context, ref, null),
          ),
        ],
      ),
      body: _worldInfo.entries.isEmpty
          ? _buildEmptyState(context)
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _worldInfo.entries.length,
              onReorder: (oldIndex, newIndex) {
                // TODO: Implement reordering
              },
              itemBuilder: (context, index) {
                final entry = _worldInfo.entries[index];
                return _WorldInfoEntryCard(
                  key: ValueKey(entry.id),
                  entry: entry,
                  onTap: () => _showEntryDialog(context, ref, entry),
                  onDelete: () => _showDeleteEntryConfirmation(context, ref, entry),
                  onToggle: (enabled) {
                    ref.read(worldInfoNotifierProvider.notifier).updateEntry(
                      entry.copyWith(enabled: enabled),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.note_add_outlined,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noEntriesYet,
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.addEntriesWithKeywords,
            style: const TextStyle(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showEntryDialog(context, ref, null),
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.addEntry),
          ),
        ],
      ),
    );
  }

  void _showEntryDialog(BuildContext context, WidgetRef ref, WorldInfoEntry? entry) {
    showDialog(
      context: context,
      builder: (context) => _WorldInfoEntryDialog(
        title: entry == null ? AppLocalizations.of(context)!.addEntry : AppLocalizations.of(context)!.editEntry,
        entry: entry,
        onSave: (keys, content, comment, secondaryKeys, position, constant, selective, insertionOrder) async {
          if (entry == null) {
            await ref.read(worldInfoNotifierProvider.notifier).addEntry(
              worldInfoId: _worldInfo.id,
              keys: keys,
              content: content,
              comment: comment,
              secondaryKeys: secondaryKeys,
              position: position,
              constant: constant,
              selective: selective,
              insertionOrder: insertionOrder,
            );
          } else {
            await ref.read(worldInfoNotifierProvider.notifier).updateEntry(
              entry.copyWith(
                keys: keys,
                content: content,
                comment: comment,
                secondaryKeys: secondaryKeys,
                position: position,
                constant: constant,
                selective: selective,
                insertionOrder: insertionOrder,
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeleteEntryConfirmation(BuildContext context, WidgetRef ref, WorldInfoEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteEntry),
        content: Text(AppLocalizations.of(context)!.deleteEntryConfirmation(entry.keys.join(", "))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(worldInfoNotifierProvider.notifier).deleteEntry(entry.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying a World Info Entry
class _WorldInfoEntryCard extends StatelessWidget {
  final WorldInfoEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _WorldInfoEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
    required this.onToggle,
  });

  void _copyToClipboard(BuildContext context) {
    final text = 'Keys: ${entry.keys.join(", ")}\n'
        '${entry.comment.isNotEmpty ? "Comment: ${entry.comment}\n" : ""}'
        'Content: ${entry.content}';
    Clipboard.setData(ClipboardData(text: text));
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n!.copiedToClipboard}: ${entry.keys.join(", ")}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.darkCard,
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _copyToClipboard(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: entry.keys.map((key) => Chip(
                        label: Text(key, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () => _copyToClipboard(context),
                    tooltip: l10n.copiedToClipboard,
                  ),
                  Switch(
                    value: entry.enabled,
                    onChanged: onToggle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
              if (entry.comment.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  entry.comment,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                entry.content,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (entry.constant || entry.selective) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (entry.constant)
                      _buildBadge(l10n.constant, Colors.orange),
                    if (entry.selective)
                      _buildBadge(l10n.selective, Colors.purple),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Dialog for creating/editing World Info Entry
class _WorldInfoEntryDialog extends StatefulWidget {
  final String title;
  final WorldInfoEntry? entry;
  final Future<void> Function(
    List<String> keys,
    String content,
    String comment,
    List<String> secondaryKeys,
    WorldInfoPosition position,
    bool constant,
    bool selective,
    int insertionOrder,
  ) onSave;

  const _WorldInfoEntryDialog({
    required this.title,
    this.entry,
    required this.onSave,
  });

  @override
  State<_WorldInfoEntryDialog> createState() => _WorldInfoEntryDialogState();
}

class _WorldInfoEntryDialogState extends State<_WorldInfoEntryDialog> {
  late TextEditingController _keysController;
  late TextEditingController _secondaryKeysController;
  late TextEditingController _contentController;
  late TextEditingController _commentController;
  late TextEditingController _orderController;
  late WorldInfoPosition _position;
  late bool _constant;
  late bool _selective;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _keysController = TextEditingController(
      text: widget.entry?.keys.join(', ') ?? '',
    );
    _secondaryKeysController = TextEditingController(
      text: widget.entry?.secondaryKeys.join(', ') ?? '',
    );
    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );
    _commentController = TextEditingController(
      text: widget.entry?.comment ?? '',
    );
    _orderController = TextEditingController(
      text: widget.entry?.insertionOrder.toString() ?? '0',
    );
    _position = widget.entry?.position ?? WorldInfoPosition.before;
    _constant = widget.entry?.constant ?? false;
    _selective = widget.entry?.selective ?? false;
  }

  @override
  void dispose() {
    _keysController.dispose();
    _secondaryKeysController.dispose();
    _contentController.dispose();
    _commentController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  String _getPositionLabel(BuildContext context, WorldInfoPosition position) {
    final l10n = AppLocalizations.of(context)!;
    switch (position) {
      case WorldInfoPosition.before:
        return l10n.beforeCharacterDefinition;  // ↑Char
      case WorldInfoPosition.after:
        return l10n.afterCharacterDefinition;   // ↓Char
      case WorldInfoPosition.ANTop:
        return l10n.beforeAuthorNote;           // ↑AT
      case WorldInfoPosition.ANBottom:
        return l10n.afterAuthorNote;            // ↓AT
      case WorldInfoPosition.atDepth:
        return l10n.atDepth;                    // @D
      case WorldInfoPosition.EMTop:
        return l10n.beforeExampleMessages;      // ↑EM
      case WorldInfoPosition.EMBottom:
        return l10n.afterExampleMessages;       // ↓EM
      case WorldInfoPosition.outlet:
        return 'Outlet';                        // Named outlet
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _keysController,
                decoration: InputDecoration(
                  labelText: l10n.keywordsCommaSeparated,
                  hintText: l10n.keywordsHint,
                  border: const OutlineInputBorder(),
                  helperText: l10n.entryActivatesWhenKeywordFound,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _secondaryKeysController,
                decoration: InputDecoration(
                  labelText: l10n.secondaryKeysOptional,
                  hintText: l10n.secondaryKeysHint,
                  border: const OutlineInputBorder(),
                  helperText: l10n.bothPrimaryAndSecondaryMustMatch,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: l10n.commentOptional,
                  hintText: l10n.noteForThisEntry,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: l10n.contentLabel,
                  hintText: l10n.contextToInjectWhenMatches,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
              ),
              const SizedBox(height: 16),
              // Position dropdown
              DropdownButtonFormField<WorldInfoPosition>(
                value: _position,
                decoration: InputDecoration(
                  labelText: l10n.insertionPosition,
                  border: const OutlineInputBorder(),
                ),
                items: WorldInfoPosition.values.map((pos) {
                  return DropdownMenuItem(
                    value: pos,
                    child: Text(_getPositionLabel(context, pos)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _position = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Insertion order
              TextField(
                controller: _orderController,
                decoration: InputDecoration(
                  labelText: l10n.insertionOrder,
                  hintText: '0',
                  border: const OutlineInputBorder(),
                  helperText: l10n.lowerOrderInsertsFirst,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Constant switch
              SwitchListTile(
                title: Text(l10n.constant),
                subtitle: Text(l10n.alwaysIncludeInPrompt),
                value: _constant,
                onChanged: (value) => setState(() => _constant = value),
                contentPadding: EdgeInsets.zero,
              ),
              // Selective switch
              SwitchListTile(
                title: Text(l10n.selective),
                subtitle: Text(l10n.requiresSecondaryKey),
                value: _selective,
                onChanged: (value) => setState(() => _selective = value),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final keys = _keysController.text
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();

    if (keys.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterAtLeastOneKeyword)),
      );
      return;
    }

    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterContent)),
      );
      return;
    }

    final secondaryKeys = _secondaryKeysController.text
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();

    final insertionOrder = int.tryParse(_orderController.text.trim()) ?? 0;

    setState(() => _isSaving = true);

    try {
      await widget.onSave(
        keys,
        content,
        _commentController.text.trim(),
        secondaryKeys,
        _position,
        _constant,
        _selective,
        insertionOrder,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }
}