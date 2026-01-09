import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/quick_reply.dart';
import '../../providers/quick_reply_providers.dart';

/// A horizontal bar of quick reply buttons
class QuickReplyBar extends ConsumerWidget {
  final Function(String message, bool autoSend) onQuickReply;

  const QuickReplyBar({
    super.key,
    required this.onQuickReply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showQuickReplies = ref.watch(showQuickRepliesProvider);
    final enabledReplies = ref.watch(enabledQuickRepliesProvider);

    if (!showQuickReplies || enabledReplies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: enabledReplies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final reply = enabledReplies[index];
          return _QuickReplyButton(
            reply: reply,
            onTap: () => onQuickReply(reply.message, reply.autoSend),
          );
        },
      ),
    );
  }
}

class _QuickReplyButton extends StatelessWidget {
  final QuickReply reply;
  final VoidCallback onTap;

  const _QuickReplyButton({
    required this.reply,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: Text(
              reply.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}