import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/tag.dart';
import 'package:native_tavern/presentation/providers/tag_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Screen for managing tags
class TagsScreen extends ConsumerStatefulWidget {
  const TagsScreen({super.key});

  @override
  ConsumerState<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> {
  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagNotifierProvider);
    final usageCountsAsync = ref.watch(tagUsageCountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Tag',
            onPressed: () => _showCreateTagDialog(context),
          ),
        ],
      ),
      body: tagsAsync.when(
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
                onPressed: () => ref.read(tagNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (tags) {
          if (tags.isEmpty) {
            return _buildEmptyState();
          }

          final usageCounts = usageCountsAsync.valueOrNull ?? {};

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              final usageCount = usageCounts[tag.id] ?? 0;
              return _TagListItem(
                tag: tag,
                usageCount: usageCount,
                onEdit: () => _showEditTagDialog(context, tag),
                onDelete: () => _showDeleteConfirmation(context, tag),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.label_outline,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No tags yet',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create tags to organize your characters',
            style: TextStyle(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateTagDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Tag'),
          ),
        ],
      ),
    );
  }

  void _showCreateTagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _TagEditDialog(
        onSave: (name, color, icon) async {
          await ref.read(tagNotifierProvider.notifier).createTag(
                name: name,
                color: color,
                icon: icon,
              );
        },
      ),
    );
  }

  void _showEditTagDialog(BuildContext context, Tag tag) {
    showDialog(
      context: context,
      builder: (context) => _TagEditDialog(
        tag: tag,
        onSave: (name, color, icon) async {
          await ref.read(tagNotifierProvider.notifier).updateTag(
                tag.copyWith(name: name, color: color, icon: icon),
              );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Tag tag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tag'),
        content: Text(
          'Are you sure you want to delete the tag "${tag.name}"?\n\n'
          'This will remove the tag from all characters.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(tagNotifierProvider.notifier).deleteTag(tag.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// List item for a tag
class _TagListItem extends StatelessWidget {
  final Tag tag;
  final int usageCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TagListItem({
    required this.tag,
    required this.usageCount,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: tag.colorValue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: tag.icon != null && tag.icon!.isNotEmpty
                ? Text(
                    tag.icon!,
                    style: const TextStyle(fontSize: 20),
                  )
                : Icon(
                    Icons.label,
                    color: tag.colorValue,
                  ),
          ),
        ),
        title: Text(tag.name),
        subtitle: Text(
          '$usageCount character${usageCount == 1 ? '' : 's'}',
          style: TextStyle(color: AppTheme.textMuted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: tag.colorValue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog for creating/editing a tag
class _TagEditDialog extends StatefulWidget {
  final Tag? tag;
  final Future<void> Function(String name, String? color, String? icon) onSave;

  const _TagEditDialog({
    this.tag,
    required this.onSave,
  });

  @override
  State<_TagEditDialog> createState() => _TagEditDialogState();
}

class _TagEditDialogState extends State<_TagEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _iconController;
  late Color _selectedColor;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag?.name ?? '');
    _iconController = TextEditingController(text: widget.tag?.icon ?? '');
    _selectedColor = widget.tag?.colorValue ?? TagColors.getRandomColor();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tag != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Tag' : 'Create Tag'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tag Name',
                hintText: 'Enter tag name',
              ),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _iconController,
              decoration: const InputDecoration(
                labelText: 'Icon (emoji)',
                hintText: 'Enter an emoji (optional)',
              ),
              maxLength: 2,
            ),
            const SizedBox(height: 16),
            const Text(
              'Color',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TagColors.presetColors.map((color) {
                final isSelected = color.toARGB32() == _selectedColor.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text('Preview: '),
                  const SizedBox(width: 8),
                  _buildTagChip(),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  Widget _buildTagChip() {
    final name = _nameController.text.isEmpty ? 'Tag' : _nameController.text;
    final icon = _iconController.text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _selectedColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _selectedColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon.isNotEmpty) ...[
            Text(icon),
            const SizedBox(width: 4),
          ],
          Text(
            name,
            style: TextStyle(
              color: _selectedColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tag name')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onSave(
        name,
        Tag.colorToHex(_selectedColor),
        _iconController.text.isEmpty ? null : _iconController.text,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

/// Widget for displaying a tag chip
class TagChip extends StatelessWidget {
  final Tag tag;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TagChip({
    super.key,
    required this.tag,
    this.selected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? tag.colorValue.withValues(alpha: 0.3)
              : tag.colorValue.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? tag.colorValue : tag.colorValue.withValues(alpha: 0.5),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tag.icon != null && tag.icon!.isNotEmpty) ...[
              Text(tag.icon!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
            ],
            Text(
              tag.name,
              style: TextStyle(
                color: tag.colorValue,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: tag.colorValue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget for selecting tags for a character
class TagSelector extends ConsumerWidget {
  final String characterId;
  final void Function(List<String> tagIds)? onChanged;

  const TagSelector({
    super.key,
    required this.characterId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTagsAsync = ref.watch(tagNotifierProvider);
    final characterTagsAsync = ref.watch(characterTagsProvider(characterId));

    return allTagsAsync.when<Widget>(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (List<Tag> allTags) {
        if (allTags.isEmpty) {
          return const Text('No tags available');
        }

        return characterTagsAsync.when<Widget>(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (List<Tag> characterTags) {
            final selectedIds = characterTags.map((Tag t) => t.id).toSet();

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allTags.map((Tag tag) {
                final isSelected = selectedIds.contains(tag.id);
                return TagChip(
                  tag: tag,
                  selected: isSelected,
                  onTap: () async {
                    if (isSelected) {
                      await ref
                          .read(tagNotifierProvider.notifier)
                          .removeTagFromCharacter(characterId, tag.id);
                    } else {
                      await ref
                          .read(tagNotifierProvider.notifier)
                          .addTagToCharacter(characterId, tag.id);
                    }
                    final List<Tag> newTags = await ref
                        .read(tagRepositoryProvider)
                        .getTagsForCharacter(characterId);
                    final List<String> tagIds = newTags.map((Tag t) => t.id).toList();
                    onChanged?.call(tagIds);
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}