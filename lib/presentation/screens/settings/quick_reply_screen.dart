import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/quick_reply.dart';
import '../../providers/quick_reply_providers.dart';

/// Screen for managing quick replies
class QuickReplyScreen extends ConsumerWidget {
  const QuickReplyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(quickReplyConfigProvider);
    final sortedReplies = List<QuickReply>.from(config.replies)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Replies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to Default',
            onPressed: () => _showResetDialog(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Settings toggles
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Quick Replies'),
                  subtitle: const Text('Display quick reply buttons in chat'),
                  value: config.showQuickReplies,
                  onChanged: (_) {
                    ref.read(quickReplyConfigProvider.notifier).toggleShowQuickReplies();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Position Above Input'),
                  subtitle: Text(config.showAboveInput 
                      ? 'Quick replies appear above the input field'
                      : 'Quick replies appear below the input field'),
                  value: config.showAboveInput,
                  onChanged: config.showQuickReplies ? (_) {
                    ref.read(quickReplyConfigProvider.notifier).togglePosition();
                  } : null,
                ),
              ],
            ),
          ),
          
          // Quick replies list header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Quick Replies',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  onPressed: () => _showEditDialog(context, ref, null),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Reorderable list of quick replies
          Expanded(
            child: sortedReplies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quick_contacts_dialer_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No quick replies',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _showEditDialog(context, ref, null),
                          child: const Text('Add your first quick reply'),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedReplies.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex--;
                      ref.read(quickReplyConfigProvider.notifier).reorder(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final reply = sortedReplies[index];
                      return _QuickReplyTile(
                        key: ValueKey(reply.id),
                        reply: reply,
                        onEdit: () => _showEditDialog(context, ref, reply),
                        onToggle: () {
                          ref.read(quickReplyConfigProvider.notifier).toggleReply(reply.id);
                        },
                        onDelete: () => _showDeleteDialog(context, ref, reply),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, QuickReply? reply) {
    showDialog(
      context: context,
      builder: (context) => _QuickReplyEditDialog(
        reply: reply,
        onSave: (newReply) {
          if (reply == null) {
            ref.read(quickReplyConfigProvider.notifier).addReply(newReply);
          } else {
            ref.read(quickReplyConfigProvider.notifier).updateReply(newReply);
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, QuickReply reply) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quick Reply'),
        content: Text('Are you sure you want to delete "${reply.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(quickReplyConfigProvider.notifier).removeReply(reply.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Default'),
        content: const Text('This will replace all your quick replies with the default set. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(quickReplyConfigProvider.notifier).resetToDefault();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _QuickReplyTile extends StatelessWidget {
  final QuickReply reply;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _QuickReplyTile({
    super.key,
    required this.reply,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: reply.order,
          child: Icon(
            Icons.drag_handle,
            color: theme.colorScheme.outline,
          ),
        ),
        title: Text(
          reply.label,
          style: TextStyle(
            color: reply.enabled ? null : theme.colorScheme.outline,
          ),
        ),
        subtitle: Text(
          reply.message.isEmpty ? '(Continue/Empty message)' : reply.message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: reply.enabled 
                ? theme.colorScheme.onSurfaceVariant 
                : theme.colorScheme.outline,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reply.autoSend)
              Tooltip(
                message: 'Auto-send',
                child: Icon(
                  Icons.send,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            const SizedBox(width: 8),
            Switch(
              value: reply.enabled,
              onChanged: (_) => onToggle(),
            ),
            PopupMenuButton<String>(
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
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickReplyEditDialog extends StatefulWidget {
  final QuickReply? reply;
  final Function(QuickReply) onSave;

  const _QuickReplyEditDialog({
    this.reply,
    required this.onSave,
  });

  @override
  State<_QuickReplyEditDialog> createState() => _QuickReplyEditDialogState();
}

class _QuickReplyEditDialogState extends State<_QuickReplyEditDialog> {
  late final TextEditingController _labelController;
  late final TextEditingController _messageController;
  late bool _autoSend;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.reply?.label ?? '');
    _messageController = TextEditingController(text: widget.reply?.message ?? '');
    _autoSend = widget.reply?.autoSend ?? true;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reply != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Quick Reply' : 'Add Quick Reply'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Button Label',
                hintText: 'e.g., Yes, Continue, Think...',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Leave empty for continue action',
                helperText: 'Supports macros like {{user}}, {{char}}',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto-send'),
              subtitle: Text(_autoSend 
                  ? 'Message will be sent immediately'
                  : 'Message will fill the input field'),
              value: _autoSend,
              onChanged: (value) => setState(() => _autoSend = value),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _labelController.text.trim().isEmpty
              ? null
              : () {
                  final newReply = QuickReply(
                    id: widget.reply?.id ?? const Uuid().v4(),
                    label: _labelController.text.trim(),
                    message: _messageController.text,
                    enabled: widget.reply?.enabled ?? true,
                    order: widget.reply?.order ?? 999,
                    autoSend: _autoSend,
                  );
                  widget.onSave(newReply);
                  Navigator.pop(context);
                },
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}