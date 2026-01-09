import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/data/models/group.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/presentation/providers/group_providers.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  GroupResponseMode _responseMode = GroupResponseMode.natural;
  bool _isLoading = true;
  Group? _group;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadGroup();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadGroup() async {
    final groupsAsync = ref.read(groupListProvider);
    final groups = groupsAsync.valueOrNull ?? [];
    
    try {
      final group = groups.firstWhere(
        (g) => g.id == widget.groupId,
      );
      
      setState(() {
        _group = group;
        _nameController.text = group.name;
        _descriptionController.text = group.description ?? '';
        _responseMode = group.settings.responseMode;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveGroup() async {
    if (_group == null) return;

    final updatedGroup = _group!.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      settings: _group!.settings.copyWith(responseMode: _responseMode),
      modifiedAt: DateTime.now(),
    );

    await ref.read(groupListProvider.notifier).updateGroup(updatedGroup);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group saved')),
      );
    }
  }

  Future<void> _deleteGroup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Are you sure you want to delete "${_group?.name}"?'),
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

    if (confirmed == true && _group != null) {
      await ref.read(groupListProvider.notifier).deleteGroup(_group!.id);
      if (mounted) {
        context.go('/groups');
      }
    }
  }

  Future<void> _addMember() async {
    final charactersAsync = ref.read(characterListProvider);
    final characters = charactersAsync.valueOrNull ?? [];
    final currentMemberIds = _group?.members.map((m) => m.characterId).toSet() ?? {};
    final availableCharacters = characters.where((c) => !currentMemberIds.contains(c.id)).toList();

    if (availableCharacters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more characters available to add')),
      );
      return;
    }

    final selected = await showDialog<Character>(
      context: context,
      builder: (context) => _AddMemberDialog(characters: availableCharacters),
    );

    if (selected != null && _group != null) {
      await ref.read(groupListProvider.notifier).addMemberToGroup(
        _group!.id,
        selected.id,
      );
      await _loadGroup();
    }
  }

  Future<void> _removeMember(String characterId) async {
    if (_group == null) return;
    
    await ref.read(groupListProvider.notifier).removeMemberFromGroup(
      _group!.id,
      characterId,
    );
    await _loadGroup();
  }

  Future<void> _toggleMemberMute(String characterId) async {
    if (_group == null) return;
    
    final member = _group!.members.firstWhere((m) => m.characterId == characterId);
    await ref.read(groupListProvider.notifier).updateMember(
      _group!.id,
      member.copyWith(isMuted: !member.isMuted),
    );
    await _loadGroup();
  }

  Future<void> _editMemberSettings(GroupMember member) async {
    final result = await showDialog<GroupMember>(
      context: context,
      builder: (context) => _MemberSettingsDialog(member: member),
    );

    if (result != null && _group != null) {
      await ref.read(groupListProvider.notifier).updateMember(_group!.id, result);
      await _loadGroup();
    }
  }

  void _startGroupChat() {
    ref.read(activeGroupIdProvider.notifier).state = _group?.id;
    // Navigate to group chat - we'll use the first member as initial character
    if (_group != null && _group!.members.isNotEmpty) {
      context.go('/chat/${_group!.members.first.characterId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_group == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Group not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_group!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Start Chat',
            onPressed: _group!.members.isNotEmpty ? _startGroupChat : null,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveGroup,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: _deleteGroup,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Group Info Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Group Info',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Response Mode Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Response Mode',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'How characters take turns responding',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ...GroupResponseMode.values.map((mode) => RadioListTile<GroupResponseMode>(
                    title: Text(_getResponseModeTitle(mode)),
                    subtitle: Text(_getResponseModeDescription(mode)),
                    value: mode,
                    groupValue: _responseMode,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _responseMode = value);
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Members Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Members (${_group!.members.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add Member',
                        onPressed: _addMember,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_group!.members.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No members yet. Add characters to this group.'),
                    )
                  else
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _group!.members.length,
                      onReorder: (oldIndex, newIndex) async {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final member = _group!.members[oldIndex];
                        final newMembers = List<GroupMember>.from(_group!.members);
                        newMembers.removeAt(oldIndex);
                        newMembers.insert(newIndex, member);
                        
                        final updatedGroup = _group!.copyWith(members: newMembers);
                        await ref.read(groupListProvider.notifier).updateGroup(updatedGroup);
                        await _loadGroup();
                      },
                      itemBuilder: (context, index) {
                        final member = _group!.members[index];
                        return _MemberTile(
                          key: ValueKey(member.characterId),
                          member: member,
                          characterRepository: ref.read(characterRepositoryProvider),
                          onToggleMute: () => _toggleMemberMute(member.characterId),
                          onEdit: () => _editMemberSettings(member),
                          onRemove: () => _removeMember(member.characterId),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getResponseModeTitle(GroupResponseMode mode) {
    switch (mode) {
      case GroupResponseMode.sequential:
        return 'Sequential';
      case GroupResponseMode.random:
        return 'Random';
      case GroupResponseMode.all:
        return 'All at Once';
      case GroupResponseMode.manual:
        return 'Manual';
      case GroupResponseMode.natural:
        return 'Natural';
    }
  }

  String _getResponseModeDescription(GroupResponseMode mode) {
    switch (mode) {
      case GroupResponseMode.sequential:
        return 'Characters respond in order';
      case GroupResponseMode.random:
        return 'Random character responds each turn';
      case GroupResponseMode.all:
        return 'All non-muted characters respond';
      case GroupResponseMode.manual:
        return 'You select which character responds';
      case GroupResponseMode.natural:
        return 'AI decides based on context and trigger words';
    }
  }
}

class _MemberTile extends StatelessWidget {
  final GroupMember member;
  final CharacterRepository characterRepository;
  final VoidCallback onToggleMute;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _MemberTile({
    super.key,
    required this.member,
    required this.characterRepository,
    required this.onToggleMute,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character?>(
      future: characterRepository.getCharacter(member.characterId),
      builder: (context, snapshot) {
        final character = snapshot.data;
        final name = character?.name ?? 'Unknown';
        final avatar = character?.assets?.avatarPath;

        return ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReorderableDragStartListener(
                index: 0,
                child: const Icon(Icons.drag_handle),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundImage: avatar != null ? AssetImage(avatar) : null,
                child: avatar == null ? Text(name[0].toUpperCase()) : null,
              ),
            ],
          ),
          title: Text(
            name,
            style: TextStyle(
              decoration: member.isMuted ? TextDecoration.lineThrough : null,
              color: member.isMuted ? Colors.grey : null,
            ),
          ),
          subtitle: Text(
            'Talkativeness: ${member.talkativeness}% ${member.triggerWords.isNotEmpty ? '• Triggers: ${member.triggerWords.join(", ")}' : ''}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  member.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: member.isMuted ? Colors.grey : null,
                ),
                tooltip: member.isMuted ? 'Unmute' : 'Mute',
                onPressed: onToggleMute,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: 'Remove',
                onPressed: onRemove,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddMemberDialog extends StatelessWidget {
  final List<Character> characters;

  const _AddMemberDialog({required this.characters});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Member'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return ListTile(
              leading: _buildAvatar(character),
              title: Text(character.name),
              subtitle: character.creatorNotes != null
                  ? Text(
                      character.creatorNotes!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              onTap: () => Navigator.pop(context, character),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildAvatar(Character character) {
    final avatarPath = character.assets?.avatarPath;
    if (avatarPath != null) {
      return CircleAvatar(
        backgroundImage: AssetImage(avatarPath),
      );
    }
    return CircleAvatar(
      child: Text(character.name[0].toUpperCase()),
    );
  }
}

class _MemberSettingsDialog extends StatefulWidget {
  final GroupMember member;

  const _MemberSettingsDialog({required this.member});

  @override
  State<_MemberSettingsDialog> createState() => _MemberSettingsDialogState();
}

class _MemberSettingsDialogState extends State<_MemberSettingsDialog> {
  late double _talkativeness;
  late TextEditingController _triggerWordsController;

  @override
  void initState() {
    super.initState();
    _talkativeness = widget.member.talkativeness.toDouble();
    _triggerWordsController = TextEditingController(
      text: widget.member.triggerWords.join(', '),
    );
  }

  @override
  void dispose() {
    _triggerWordsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Member Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Talkativeness: ${_talkativeness.round()}%'),
          Slider(
            value: _talkativeness,
            min: 0,
            max: 100,
            divisions: 20,
            label: '${_talkativeness.round()}%',
            onChanged: (value) {
              setState(() => _talkativeness = value);
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Higher values make the character more likely to respond.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _triggerWordsController,
            decoration: const InputDecoration(
              labelText: 'Trigger Words',
              hintText: 'word1, word2, word3',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Character will respond when these words appear in messages.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final triggerWords = _triggerWordsController.text
                .split(',')
                .map((w) => w.trim())
                .where((w) => w.isNotEmpty)
                .toList();
            
            Navigator.pop(
              context,
              widget.member.copyWith(
                talkativeness: _talkativeness.round(),
                triggerWords: triggerWords,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}