import 'package:flutter/material.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Swipe Picker (aligned with SillyTavern 1.17+):
/// browse, jump to, and delete swipes of a message.
/// Open by long-pressing the swipe counter under a message.
class SwipePickerSheet extends StatefulWidget {
  final ChatMessage message;
  final void Function(int swipeIndex) onSelect;
  final Future<void> Function(int swipeIndex) onDelete;

  const SwipePickerSheet({
    super.key,
    required this.message,
    required this.onSelect,
    required this.onDelete,
  });

  /// Show the swipe picker as a modal bottom sheet
  static Future<void> show(
    BuildContext context, {
    required ChatMessage message,
    required void Function(int swipeIndex) onSelect,
    required Future<void> Function(int swipeIndex) onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SwipePickerSheet(
        message: message,
        onSelect: onSelect,
        onDelete: onDelete,
      ),
    );
  }

  @override
  State<SwipePickerSheet> createState() => _SwipePickerSheetState();
}

class _SwipePickerSheetState extends State<SwipePickerSheet> {
  late List<String> _swipes;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _swipes = List<String>.from(widget.message.swipes);
    _currentIndex = widget.message.currentSwipeIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.swipe, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${AppLocalizations.of(context).swipes} (${_swipes.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _swipes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _buildSwipeCard(context, index),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final isCurrent = index == _currentIndex;
    final content = _swipes[index];

    return Material(
      color: isCurrent
          ? AppTheme.accentColor.withValues(alpha: 0.12)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          widget.onSelect(index);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrent
                  ? AppTheme.accentColor
                  : AppTheme.textMuted.withValues(alpha: 0.2),
              width: isCurrent ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppTheme.accentColor
                          : AppTheme.textMuted.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isCurrent ? Colors.white : AppTheme.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isCurrent) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.check_circle,
                        size: 16, color: AppTheme.accentColor),
                  ],
                  const Spacer(),
                  Text(
                    '${content.length} ${AppLocalizations.of(context).charsSuffix}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (_swipes.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: AppTheme.textMuted,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => _confirmDelete(context, index),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteSwipeQuestion),
        content: Text(
          _swipes[index].length > 200
              ? '${_swipes[index].substring(0, 200)}...'
              : _swipes[index],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await widget.onDelete(index);
    if (!mounted) return;
    setState(() {
      _swipes.removeAt(index);
      if (_currentIndex >= _swipes.length) {
        _currentIndex = _swipes.length - 1;
      } else if (index < _currentIndex) {
        _currentIndex--;
      }
      if (_swipes.length <= 1) {
        Navigator.pop(context);
      }
    });
  }
}
