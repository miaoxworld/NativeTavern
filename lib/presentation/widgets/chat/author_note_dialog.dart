import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';

/// Dialog for editing Author's Note settings
class AuthorNoteDialog extends ConsumerStatefulWidget {
  const AuthorNoteDialog({super.key});

  @override
  ConsumerState<AuthorNoteDialog> createState() => _AuthorNoteDialogState();
}

class _AuthorNoteDialogState extends ConsumerState<AuthorNoteDialog> {
  late TextEditingController _contentController;
  late int _depth;
  late bool _enabled;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final chat = ref.read(activeChatProvider).chat;
    _contentController = TextEditingController(text: chat?.authorNote ?? '');
    _depth = chat?.authorNoteDepth ?? 4;
    _enabled = chat?.authorNoteEnabled ?? false;
    
    _contentController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _contentController.removeListener(_onChanged);
    _contentController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _save() async {
    await ref.read(activeChatProvider.notifier).updateAuthorNoteSettings(
      content: _contentController.text,
      depth: _depth,
      enabled: _enabled,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Author\'s Note',
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Add context or instructions that will be injected into the conversation at a specific depth.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Enable toggle
              SwitchListTile(
                title: const Text('Enable Author\'s Note'),
                subtitle: const Text('Inject note into conversation context'),
                value: _enabled,
                onChanged: (value) {
                  setState(() {
                    _enabled = value;
                    _hasChanges = true;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // Depth selector
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Injection Depth',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Messages from the end where note is inserted',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: DropdownButtonFormField<int>(
                      value: _depth,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: List.generate(21, (i) => i).map((depth) {
                        return DropdownMenuItem(
                          value: depth,
                          child: Text('$depth'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _depth = value;
                            _hasChanges = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Content field
              Text(
                'Note Content',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Enter your author\'s note here...\n\n'
                        'Examples:\n'
                        '• [Style: Write in a poetic, descriptive manner]\n'
                        '• [Focus on emotional depth and character development]\n'
                        '• [{{char}} is feeling melancholic today]',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Supports macros: {{user}}, {{char}}, {{time}}, {{date}}, etc.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show the Author's Note dialog
Future<bool?> showAuthorNoteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const AuthorNoteDialog(),
  );
}