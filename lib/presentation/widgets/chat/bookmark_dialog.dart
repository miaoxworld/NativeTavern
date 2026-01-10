import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/bookmark.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/presentation/providers/bookmark_providers.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Dialog for creating a new bookmark
class CreateBookmarkDialog extends ConsumerStatefulWidget {
  final String chatId;
  final String messageId;
  final int messageIndex;

  const CreateBookmarkDialog({
    super.key,
    required this.chatId,
    required this.messageId,
    required this.messageIndex,
  });

  @override
  ConsumerState<CreateBookmarkDialog> createState() => _CreateBookmarkDialogState();
}

class _CreateBookmarkDialogState extends ConsumerState<CreateBookmarkDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Checkpoint ${widget.messageIndex + 1}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createBookmark() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isCreating = true);

    final bookmark = await ref.read(bookmarkNotifierProvider.notifier).createBookmark(
      name: _nameController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      messageId: widget.messageId,
      messageIndex: widget.messageIndex,
    );

    if (mounted) {
      Navigator.pop(context, bookmark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.createBookmark),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.bookmarkName,
              hintText: AppLocalizations.of(context)!.enterNameForCheckpoint,
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.descriptionOptional,
              hintText: AppLocalizations.of(context)!.addDescription,
              border: const OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.createCheckpointAtMessage(widget.messageIndex + 1),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createBookmark,
          child: _isCreating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context)!.create),
        ),
      ],
    );
  }
}

/// Dialog for viewing and managing bookmarks
class BookmarksListDialog extends ConsumerWidget {
  final String chatId;

  const BookmarksListDialog({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkState = ref.watch(bookmarkNotifierProvider);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.bookmark, color: AppTheme.accentColor),
          const SizedBox(width: 8),
          Text(AppLocalizations.of(context)!.bookmarks),
          const Spacer(),
          Text(
            '${bookmarkState.bookmarks.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        height: 400,
        child: bookmarkState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : bookmarkState.bookmarks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 64,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noBookmarksYet,
                          style: const TextStyle(color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.longPressMessageToBookmark,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: bookmarkState.bookmarks.length,
                    itemBuilder: (context, index) {
                      final bookmark = bookmarkState.bookmarks[index];
                      return _BookmarkTile(
                        bookmark: bookmark,
                        onTap: () => _branchFromBookmark(context, ref, bookmark),
                        onDelete: () => _deleteBookmark(context, ref, bookmark),
                      );
                    },
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }

  void _branchFromBookmark(BuildContext context, WidgetRef ref, Bookmark bookmark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.branchFromBookmark),
        content: Text(
          AppLocalizations.of(context)!.branchFromBookmarkWarning(bookmark.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.branch),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(activeChatProvider.notifier).branchFromBookmark(bookmark);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.branchedFrom(bookmark.name))),
        );
      }
    }
  }

  void _deleteBookmark(BuildContext context, WidgetRef ref, Bookmark bookmark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteBookmark),
        content: Text(AppLocalizations.of(context)!.deleteBookmarkConfirmation(bookmark.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(bookmarkNotifierProvider.notifier).deleteBookmark(bookmark.id);
    }
  }
}

class _BookmarkTile extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BookmarkTile({
    required this.bookmark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.bookmark, color: AppTheme.accentColor),
        title: Text(bookmark.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bookmark.description != null && bookmark.description!.isNotEmpty)
              Text(
                bookmark.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              AppLocalizations.of(context)!.messageIndexAndDate(bookmark.messageIndex + 1, _formatDate(bookmark.createdAt)),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.call_split, color: AppTheme.primaryColor),
              tooltip: AppLocalizations.of(context)!.branchFromHere,
              onPressed: onTap,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: AppLocalizations.of(context)!.delete,
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${date.month}/${date.day}';
  }
}

/// Preview widget showing messages up to a bookmark
class BookmarkPreviewDialog extends ConsumerWidget {
  final Bookmark bookmark;

  const BookmarkPreviewDialog({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(activeChatProvider);
    final previewMessages = ref.read(activeChatProvider.notifier).getMessagesUpTo(bookmark.messageId);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.preview, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.previewBookmark(bookmark.name),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: previewMessages.isEmpty
            ? Center(
                child: Text(
                  AppLocalizations.of(context)!.messageNotFoundInChat,
                  style: TextStyle(color: AppTheme.textMuted),
                ),
              )
            : ListView.builder(
                itemCount: previewMessages.length,
                itemBuilder: (context, index) {
                  final message = previewMessages[index];
                  final isUser = message.role == MessageRole.user;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser 
                          ? AppTheme.accentColor.withValues(alpha: 0.2)
                          : AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUser
                              ? AppLocalizations.of(context)!.you
                              : (message.characterName ?? chatState.character?.name ?? AppLocalizations.of(context)!.assistant),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isUser ? AppTheme.accentColor : AppTheme.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
          child: Text(AppLocalizations.of(context)!.close),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            ref.read(activeChatProvider.notifier).branchFromBookmark(bookmark);
          },
          icon: const Icon(Icons.call_split),
          label: Text(AppLocalizations.of(context)!.branchFromHere),
        ),
      ],
    );
  }
}