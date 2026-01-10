import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Character list screen
class CharacterListScreen extends ConsumerStatefulWidget {
  const CharacterListScreen({super.key});

  @override
  ConsumerState<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends ConsumerState<CharacterListScreen> {
  String _searchQuery = '';
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final charactersAsync = ref.watch(characterListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.characters),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView ? l10n.listView : l10n.gridView,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.createCharacter,
            onPressed: () => context.push(AppRoutes.characterCreate),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.retry,
            onPressed: () => ref.read(characterListProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: l10n.import,
            onPressed: () => context.push(AppRoutes.import_),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          Expanded(
            child: charactersAsync.when(
              data: (characters) {
                final filtered = _searchQuery.isEmpty
                    ? characters
                    : characters.where((c) => 
                        c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        c.description.toLowerCase().contains(_searchQuery.toLowerCase())
                      ).toList();

                if (filtered.isEmpty) {
                  return const _EmptyState();
                }

                if (_isGridView) {
                  return _CharacterGridView(characters: filtered);
                } else {
                  return _CharacterListView(characters: filtered);
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('${l10n.error}: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(characterListProvider.notifier).refresh(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: l10n.searchCharacters,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ),
      ),
    );
  }
}

class _CharacterGridView extends StatelessWidget {
  final List<Character> characters;

  const _CharacterGridView({required this.characters});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return _CharacterGridCard(character: characters[index]);
      },
    );
  }
}

class _CharacterListView extends StatelessWidget {
  final List<Character> characters;

  const _CharacterListView({required this.characters});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        return _CharacterListTile(character: characters[index]);
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCharactersYet,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.importCharacter,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMuted,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.characterCreate),
                icon: const Icon(Icons.add),
                label: Text(l10n.createCharacter),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.import_),
                icon: const Icon(Icons.file_download),
                label: Text(l10n.import),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CharacterGridCard extends ConsumerWidget {
  final Character character;

  const _CharacterGridCard({required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/characters/${character.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _buildAvatar(),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (character.creator.isNotEmpty)
                      Text(
                        'by ${character.creator}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (character.assets?.avatarPath != null) {
      final file = File(character.assets!.avatarPath!);
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultAvatar(),
      );
    }
    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    final icon = _getCharacterIcon(character);
    final color = _getCharacterColor(character);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  IconData _getCharacterIcon(Character character) {
    // Check if it's a built-in character by ID
    switch (character.id) {
      case 'builtin_coding_assistant':
        return Icons.code;
      case 'builtin_image_gen_assistant':
        return Icons.image;
      case 'builtin_xiaohongshu_copywriter':
        return Icons.edit_note;
      default:
        return Icons.person;
    }
  }

  Color _getCharacterColor(Character character) {
    // Check if it's a built-in character by ID
    switch (character.id) {
      case 'builtin_coding_assistant':
        return const Color(0xFF2196F3); // Blue for coding
      case 'builtin_image_gen_assistant':
        return const Color(0xFFE91E63); // Pink for image generation
      case 'builtin_xiaohongshu_copywriter':
        return const Color(0xFFFF5722); // Orange/Red for social media
      default:
        return AppTheme.darkDivider;
    }
  }
}

class _CharacterListTile extends ConsumerWidget {
  final Character character;

  const _CharacterListTile({required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildListAvatar(),
        title: Text(character.name),
        subtitle: Text(
          character.description.isNotEmpty
              ? character.description
              : l10n.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'chat',
              child: ListTile(
                leading: const Icon(Icons.chat),
                title: Text(l10n.startChat),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => _startChat(context, ref),
            ),
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.edit),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () => context.push('/characters/${character.id}'),
            ),
            PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: const Icon(Icons.file_upload),
                title: Text(l10n.exportChat),
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {
                // TODO: Export character
              },
            ),
            PopupMenuItem(
              value: 'delete',
              onTap: () => _confirmDelete(context, ref),
              child: ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: () => context.push('/characters/${character.id}'),
      ),
    );
  }

  Future<void> _startChat(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    
    try {
      final chatId = await ref.read(activeChatProvider.notifier).createChat(character.id);
      if (chatId != null && context.mounted) {
        context.push('/chat/$chatId');
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.error)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $e')),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCharacter),
        content: Text(l10n.deleteCharacterConfirmation(character.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(characterListProvider.notifier).deleteCharacter(character.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.characterDeleted)),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildListAvatar() {
    if (character.assets?.avatarPath != null) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: FileImage(File(character.assets!.avatarPath!)),
      );
    }

    final icon = _getCharacterIcon(character);
    final color = _getCharacterColor(character);

    return CircleAvatar(
      radius: 28,
      backgroundColor: color,
      child: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  IconData _getCharacterIcon(Character character) {
    switch (character.id) {
      case 'builtin_coding_assistant':
        return Icons.code;
      case 'builtin_image_gen_assistant':
        return Icons.image;
      case 'builtin_xiaohongshu_copywriter':
        return Icons.edit_note;
      default:
        return Icons.person;
    }
  }

  Color _getCharacterColor(Character character) {
    switch (character.id) {
      case 'builtin_coding_assistant':
        return const Color(0xFF2196F3);
      case 'builtin_image_gen_assistant':
        return const Color(0xFFE91E63);
      case 'builtin_xiaohongshu_copywriter':
        return const Color(0xFFFF5722);
      default:
        return AppTheme.primaryColor;
    }
  }
}