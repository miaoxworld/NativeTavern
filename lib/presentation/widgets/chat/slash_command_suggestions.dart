import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/services/slash_command_service.dart';
import '../../theme/app_theme.dart';

/// Widget that shows slash command suggestions
class SlashCommandSuggestions extends ConsumerWidget {
  final String input;
  final Function(SlashCommand) onSelect;
  final VoidCallback onDismiss;

  const SlashCommandSuggestions({
    super.key,
    required this.input,
    required this.onSelect,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slashService = ref.watch(slashCommandServiceProvider);
    final suggestions = slashService.getSuggestions(input);

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal,
                  size: 16,
                  color: AppTheme.accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Commands',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Suggestions list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final command = suggestions[index];
                return _CommandSuggestionTile(
                  command: command,
                  onTap: () => onSelect(command),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CommandSuggestionTile extends StatelessWidget {
  final SlashCommand command;
  final VoidCallback onTap;

  const _CommandSuggestionTile({
    required this.command,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '/${command.name}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    command.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (command.aliases.isNotEmpty)
                    Text(
                      'Aliases: ${command.aliases.map((a) => '/$a').join(', ')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline help dialog for slash commands
class SlashCommandHelpDialog extends ConsumerWidget {
  const SlashCommandHelpDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slashService = ref.watch(slashCommandServiceProvider);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.terminal, color: AppTheme.accentColor),
          SizedBox(width: 8),
          Text('Slash Commands'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: SlashCommands.all.length,
          itemBuilder: (context, index) {
            final command = SlashCommands.all[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '/${command.name}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentColor,
                          ),
                        ),
                      ),
                      if (command.aliases.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          command.aliases.map((a) => '/$a').join(', '),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    command.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    command.usage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}