import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/quick_reply.dart';
import '../../providers/quick_reply_providers.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.quickReplies),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: AppLocalizations.of(context)!.resetToDefault,
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
                  title: Text(AppLocalizations.of(context)!.showQuickReplies),
                  subtitle: Text(AppLocalizations.of(context)!.displayQuickReplyButtons),
                  value: config.showQuickReplies,
                  onChanged: (_) {
                    ref.read(quickReplyConfigProvider.notifier).toggleShowQuickReplies();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.positionAboveInput),
                  subtitle: Text(config.showAboveInput
                      ? AppLocalizations.of(context)!.quickRepliesAboveInput
                      : AppLocalizations.of(context)!.quickRepliesBelowInput),
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
                  AppLocalizations.of(context)!.quickReplies,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(AppLocalizations.of(context)!.add),
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
                          AppLocalizations.of(context)!.noQuickReplies,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _showEditDialog(context, ref, null),
                          child: Text(AppLocalizations.of(context)!.addYourFirstQuickReply),
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
        title: Text(AppLocalizations.of(context)!.deleteQuickReply),
        content: Text(AppLocalizations.of(context)!.deleteQuickReplyQuestion(reply.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(quickReplyConfigProvider.notifier).removeReply(reply.id);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetToDefault),
        content: Text(AppLocalizations.of(context)!.resetToDefaultQuestion2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(quickReplyConfigProvider.notifier).resetToDefault();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.reset),
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
          reply.message.isEmpty ? AppLocalizations.of(context)!.continueOrEmpty : reply.message,
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
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(AppLocalizations.of(context)!.edit),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(AppLocalizations.of(context)!.delete),
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
      title: Text(isEditing ? AppLocalizations.of(context)!.editQuickReplyLabel : AppLocalizations.of(context)!.addQuickReply),
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
          child: Text(AppLocalizations.of(context)!.cancel),
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
          child: Text(isEditing ? AppLocalizations.of(context)!.save : AppLocalizations.of(context)!.add),
        ),
      ],
    );
  }
}