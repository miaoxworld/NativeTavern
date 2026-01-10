import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Home screen showing recent chats
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NativeTavern'),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups),
            tooltip: 'Group Chats',
            onPressed: () => context.push(AppRoutes.groups),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Import',
            onPressed: () => context.push(AppRoutes.import_),
          ),
        ],
      ),
      body: const _ChatListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.characters),
        icon: const Icon(Icons.add),
        label: const Text('New Chat'),
      ),
    );
  }
}

class _ChatListView extends ConsumerWidget {
  const _ChatListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(allChatsProvider);

    return chatsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading chats: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(allChatsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (chats) {
        if (chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(height: 16),
                Text(
                  'No chats yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start a new conversation with a character',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.characters),
                  icon: const Icon(Icons.people),
                  label: const Text('Browse Characters'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(allChatsProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return _ChatListTile(chat: chat);
            },
          ),
        );
      },
    );
  }
}

class _ChatListTile extends ConsumerWidget {
  final Chat chat;

  const _ChatListTile({required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(_characterForChatProvider(chat.characterId));
    final lastMessageAsync = ref.watch(_lastMessageProvider(chat.id));

    return Card(
      child: ListTile(
        leading: characterAsync.when(
          loading: () => const CircleAvatar(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, __) => const CircleAvatar(child: Icon(Icons.person)),
          data: (character) {
            final avatarPath = character?.assets?.avatarPath;
            if (avatarPath != null && avatarPath.isNotEmpty) {
              return CircleAvatar(
                backgroundImage: AssetImage(avatarPath),
                onBackgroundImageError: (_, __) {},
              );
            }
            return CircleAvatar(
              backgroundColor: AppTheme.accentColor.withValues(alpha: 0.2),
              child: Text(
                character?.name.isNotEmpty == true ? character!.name[0].toUpperCase() : '?',
                style: const TextStyle(color: AppTheme.accentColor),
              ),
            );
          },
        ),
        title: characterAsync.when(
          loading: () => const Text('Loading...'),
          error: (_, __) => Text(chat.title),
          data: (character) => Text(character?.name ?? chat.title),
        ),
        subtitle: lastMessageAsync.when(
          loading: () => const Text('...'),
          error: (_, __) => const Text('No messages'),
          data: (message) => Text(
            message?.content ?? 'No messages yet',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(chat.updatedAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                  ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20),
              padding: EdgeInsets.zero,
              onSelected: (value) => _handleMenuAction(context, ref, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Navigate to chat screen
          context.push('/chat/${chat.id}');
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) {
      // Today - show time
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      // Show date
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(chatRepositoryProvider).deleteChat(chat.id);
              ref.invalidate(allChatsProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat deleted')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Provider to get character for a chat
final _characterForChatProvider = FutureProvider.family((ref, String characterId) async {
  final repo = ref.watch(characterRepositoryProvider);
  return repo.getCharacter(characterId);
});

/// Provider to get last message for a chat
final _lastMessageProvider = FutureProvider.family((ref, String chatId) async {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getLastMessage(chatId);
});