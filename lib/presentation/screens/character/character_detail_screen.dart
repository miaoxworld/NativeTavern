import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Provider for loading a single character by ID
final characterDetailProvider = FutureProvider.family<Character?, String>((ref, id) async {
  final repo = ref.watch(characterRepositoryProvider);
  return repo.getCharacter(id);
});

/// Character detail screen
class CharacterDetailScreen extends ConsumerWidget {
  final String characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterDetailProvider(characterId));
    
    return characterAsync.when(
      data: (character) {
        if (character == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Character Not Found')),
            body: const Center(
              child: Text('Character not found'),
            ),
          );
        }
        return _CharacterDetailContent(character: character);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

class _CharacterDetailContent extends ConsumerStatefulWidget {
  final Character character;

  const _CharacterDetailContent({required this.character});

  @override
  ConsumerState<_CharacterDetailContent> createState() => _CharacterDetailContentState();
}

class _CharacterDetailContentState extends ConsumerState<_CharacterDetailContent> {
  bool _isCreatingChat = false;

  Future<void> _startChat() async {
    if (_isCreatingChat) return;
    
    setState(() => _isCreatingChat = true);
    
    try {
      final chatId = await ref.read(activeChatProvider.notifier).createChat(widget.character.id);
      
      if (chatId != null && mounted) {
        context.push('/chat/$chatId');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create chat')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingChat = false);
      }
    }
  }

  Future<void> _handleMenuAction(String action, Character character) async {
    switch (action) {
      case 'delete':
        await _confirmDelete(character);
        break;
      case 'duplicate':
        await _duplicateCharacter(character);
        break;
      case 'export':
        // TODO: Implement PNG export
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PNG export coming soon')),
        );
        break;
      case 'export_charx':
        // TODO: Implement CharX export
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CharX export coming soon')),
        );
        break;
    }
  }

  Future<void> _confirmDelete(Character character) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Are you sure you want to delete "${character.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final repo = ref.read(characterRepositoryProvider);
        await repo.deleteCharacter(character.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${character.name} deleted')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: $e')),
          );
        }
      }
    }
  }

  Future<void> _duplicateCharacter(Character character) async {
    try {
      final repo = ref.read(characterRepositoryProvider);
      final newCharacter = character.copyWith(
        id: '',
        name: '${character.name} (copy)',
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
      );
      await repo.createCharacter(newCharacter);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${character.name} duplicated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to duplicate: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                character.name,
                style: const TextStyle(
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              background: _buildAvatarBackground(character),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/characters/${character.id}/edit'),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, character),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'export',
                    child: Text('Export as PNG'),
                  ),
                  const PopupMenuItem(
                    value: 'export_charx',
                    child: Text('Export as CharX'),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Text('Duplicate'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  if (character.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: character.tags.map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      )).toList(),
                    ),
                  if (character.tags.isNotEmpty) const SizedBox(height: 16),
                  
                  // Creator info
                  Row(
                    children: [
                      if (character.creator.isNotEmpty) ...[
                        const Icon(Icons.person_outline, size: 16, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'by ${character.creator}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (character.version.isNotEmpty) ...[
                        const Icon(Icons.update, size: 16, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'v${character.version}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description section
                  if (character.description.isNotEmpty)
                    _SectionCard(
                      title: 'Description',
                      content: character.description,
                      icon: Icons.description,
                    ),
                  if (character.description.isNotEmpty) const SizedBox(height: 16),
                  
                  // Personality section
                  if (character.personality.isNotEmpty)
                    _SectionCard(
                      title: 'Personality',
                      content: character.personality,
                      icon: Icons.psychology,
                    ),
                  if (character.personality.isNotEmpty) const SizedBox(height: 16),
                  
                  // Scenario section
                  if (character.scenario.isNotEmpty)
                    _SectionCard(
                      title: 'Scenario',
                      content: character.scenario,
                      icon: Icons.movie,
                    ),
                  if (character.scenario.isNotEmpty) const SizedBox(height: 16),
                  
                  // First message section
                  if (character.firstMessage.isNotEmpty)
                    _SectionCard(
                      title: 'First Message',
                      content: character.firstMessage,
                      icon: Icons.chat_bubble,
                    ),
                  if (character.firstMessage.isNotEmpty) const SizedBox(height: 16),
                  
                  // Alternate greetings section
                  if (character.alternateGreetings.isNotEmpty) ...[
                    _AlternateGreetingsCard(
                      greetings: character.alternateGreetings,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Example messages section
                  if (character.exampleMessages.isNotEmpty)
                    _SectionCard(
                      title: 'Example Messages',
                      content: character.exampleMessages,
                      icon: Icons.format_quote,
                    ),
                  if (character.exampleMessages.isNotEmpty) const SizedBox(height: 16),
                  
                  // System prompt section
                  if (character.systemPrompt.isNotEmpty)
                    _SectionCard(
                      title: 'System Prompt',
                      content: character.systemPrompt,
                      icon: Icons.settings_suggest,
                    ),
                  if (character.systemPrompt.isNotEmpty) const SizedBox(height: 16),
                  
                  // Post-history instructions section
                  if (character.postHistoryInstructions.isNotEmpty)
                    _SectionCard(
                      title: 'Post-History Instructions',
                      content: character.postHistoryInstructions,
                      icon: Icons.rule,
                    ),
                  if (character.postHistoryInstructions.isNotEmpty) const SizedBox(height: 16),
                  
                  // Creator notes section
                  if (character.creatorNotes.isNotEmpty)
                    _SectionCard(
                      title: 'Creator Notes',
                      content: character.creatorNotes,
                      icon: Icons.note,
                    ),
                  if (character.creatorNotes.isNotEmpty) const SizedBox(height: 16),
                  
                  // Embedded Lorebook section
                  if (character.characterBook != null &&
                      character.characterBook!.entries.isNotEmpty)
                    _CharacterBookCard(
                      characterBook: character.characterBook!,
                    ),
                  if (character.characterBook != null &&
                      character.characterBook!.entries.isNotEmpty)
                    const SizedBox(height: 16),
                  
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCreatingChat ? null : _startChat,
        icon: _isCreatingChat
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.chat),
        label: Text(_isCreatingChat ? 'Creating...' : 'Start Chat'),
      ),
    );
  }

  Widget _buildAvatarBackground(Character character) {
    if (character.assets?.avatarPath != null) {
      final file = File(character.assets!.avatarPath!);
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _defaultBackground(),
          ),
          // Gradient overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return _defaultBackground();
  }

  Widget _defaultBackground() {
    return Container(
      color: AppTheme.darkCard,
      child: const Center(
        child: Icon(
          Icons.person,
          size: 120,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }
}

class _SectionCard extends StatefulWidget {
  final String title;
  final String content;
  final IconData icon;
  final int maxLines;

  const _SectionCard({
    required this.title,
    required this.content,
    required this.icon,
    this.maxLines = 10,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final lines = widget.content.split('\n');
    final shouldShowExpand = lines.length > widget.maxLines || widget.content.length > 500;
    final displayContent = _expanded || !shouldShowExpand
        ? widget.content
        : '${widget.content.substring(0, widget.content.length.clamp(0, 500))}...';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 20, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                  ),
                ),
                if (shouldShowExpand)
                  IconButton(
                    icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    tooltip: _expanded ? 'Show less' : 'Show more',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              displayContent,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlternateGreetingsCard extends StatelessWidget {
  final List<String> greetings;

  const _AlternateGreetingsCard({required this.greetings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.waving_hand, size: 20, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Alternate Greetings (${greetings.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...greetings.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.darkSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.darkDivider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Greeting ${entry.key + 1}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.value.length > 200
                          ? '${entry.value.substring(0, 200)}...'
                          : entry.value,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _CharacterBookCard extends StatelessWidget {
  final CharacterBook characterBook;

  const _CharacterBookCard({required this.characterBook});

  @override
  Widget build(BuildContext context) {
    final enabledEntries = characterBook.entries.where((e) => e.enabled).length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_stories, size: 20, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        characterBook.name ?? 'Embedded Lorebook',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                      ),
                      Text(
                        '$enabledEntries of ${characterBook.entries.length} entries enabled',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (characterBook.description != null &&
                characterBook.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                characterBook.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            ...characterBook.entries.take(5).map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: entry.enabled ? AppTheme.darkSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: entry.enabled ? AppTheme.primaryColor.withValues(alpha: 0.3) : AppTheme.darkDivider,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          entry.enabled ? Icons.check_circle : Icons.cancel,
                          size: 14,
                          color: entry.enabled ? Colors.green : AppTheme.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            entry.name.isNotEmpty ? entry.name : entry.keys.join(', '),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: entry.enabled ? null : AppTheme.textMuted,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (entry.keys.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        children: entry.keys.take(5).map((key) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            key,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        )).toList(),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      entry.content.length > 100
                          ? '${entry.content.substring(0, 100)}...'
                          : entry.content,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )),
            if (characterBook.entries.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '... and ${characterBook.entries.length - 5} more entries',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}