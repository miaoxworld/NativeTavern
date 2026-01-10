import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/presentation/providers/world_info_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      String jsonString;

      if (file.bytes != null) {
        jsonString = utf8.decode(file.bytes!);
      } else if (file.path != null) {
        jsonString = await File(file.path!).readAsString();
      } else {
        throw Exception('Could not read file');
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Ensure required fields have default values to prevent null casting errors
      final sanitizedJson = {
        'id': json['id'] ?? 'imported_${DateTime.now().millisecondsSinceEpoch}',
        'name': json['name'] as String? ?? 'Imported Lorebook',
        'description': json['description'] as String?,
        'entries': json['entries'] ?? [],
        'enabled': json['enabled'] ?? true,
        'isGlobal': json['isGlobal'] ?? false,
        'characterId': json['characterId'] as String?,
        'createdAt': json['createdAt'] ?? DateTime.now().toIso8601String(),
        'modifiedAt': json['modifiedAt'] ?? DateTime.now().toIso8601String(),
      };
      
      final worldInfo = WorldInfo.fromJson(sanitizedJson);

      await ref.read(worldInfoNotifierProvider.notifier).createWorldInfo(
        name: worldInfo.name,
        description: worldInfo.description,
        isGlobal: worldInfo.isGlobal,
      );

      // Import entries
      final createdWorldInfos = ref.read(worldInfoNotifierProvider).valueOrNull ?? [];
      final createdWorldInfo = createdWorldInfos.firstWhere((w) => w.name == worldInfo.name);
      
      for (final entry in worldInfo.entries) {
        await ref.read(worldInfoNotifierProvider.notifier).addEntry(
          worldInfoId: createdWorldInfo.id,
          keys: entry.keys,
          content: entry.content,
          comment: entry.comment,
          secondaryKeys: entry.secondaryKeys,
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.importedAndApplied(worldInfo.name))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.importFailed(e.toString())}')),
        );
      }
    }
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
        onSave: (keys, content, comment, secondaryKeys) async {
          if (entry == null) {
            await ref.read(worldInfoNotifierProvider.notifier).addEntry(
              worldInfoId: _worldInfo.id,
              keys: keys,
              content: content,
              comment: comment,
              secondaryKeys: secondaryKeys,
            );
          } else {
            await ref.read(worldInfoNotifierProvider.notifier).updateEntry(
              entry.copyWith(
                keys: keys,
                content: content,
                comment: comment,
                secondaryKeys: secondaryKeys,
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
                      _buildBadge(AppLocalizations.of(context)!.constant, Colors.orange),
                    if (entry.selective)
                      _buildBadge(AppLocalizations.of(context)!.selective, Colors.purple),
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
  }

  @override
  void dispose() {
    _keysController.dispose();
    _secondaryKeysController.dispose();
    _contentController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  labelText: AppLocalizations.of(context)!.keywordsCommaSeparated,
                  hintText: AppLocalizations.of(context)!.keywordsHint,
                  border: const OutlineInputBorder(),
                  helperText: AppLocalizations.of(context)!.entryActivatesWhenKeywordFound,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _secondaryKeysController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.secondaryKeysOptional,
                  hintText: AppLocalizations.of(context)!.secondaryKeysHint,
                  border: const OutlineInputBorder(),
                  helperText: AppLocalizations.of(context)!.bothPrimaryAndSecondaryMustMatch,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.commentOptional,
                  hintText: AppLocalizations.of(context)!.noteForThisEntry,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.contentLabel,
                  hintText: AppLocalizations.of(context)!.contextToInjectWhenMatches,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
              ),
            ],
          ),
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
    final keys = _keysController.text
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();

    if (keys.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterAtLeastOneKeyword)),
      );
      return;
    }

    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterContent)),
      );
      return;
    }

    final secondaryKeys = _secondaryKeysController.text
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();

    setState(() => _isSaving = true);

    try {
      await widget.onSave(
        keys,
        content,
        _commentController.text.trim(),
        secondaryKeys,
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