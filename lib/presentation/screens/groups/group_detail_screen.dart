import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/data/models/group.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/presentation/providers/group_providers.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

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
        SnackBar(content: Text(AppLocalizations.of(context)!.groupSaved)),
      );
    }
  }

  Future<void> _deleteGroup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteGroup),
        content: Text(AppLocalizations.of(context)!.deleteGroupAndChats(_group?.name ?? '')),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.noMoreCharactersAvailable)),
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
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.loading)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_group == null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.error)),
        body: Center(child: Text(AppLocalizations.of(context)!.characterNotFoundMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_group!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: AppLocalizations.of(context)!.startChatAction,
            onPressed: _group!.members.isNotEmpty ? _startGroupChat : null,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: AppLocalizations.of(context)!.save,
            onPressed: _saveGroup,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: AppLocalizations.of(context)!.delete,
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
                    AppLocalizations.of(context)!.groupInfo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.descriptionOptionalLabel,
                      border: const OutlineInputBorder(),
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
                    AppLocalizations.of(context)!.responseMode,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.howCharactersTakeTurns,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ...GroupResponseMode.values.map((mode) => RadioListTile<GroupResponseMode>(
                    title: Text(_getResponseModeTitle(mode, context)),
                    subtitle: Text(_getResponseModeDescription(mode, context)),
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
                        AppLocalizations.of(context)!.membersCount(_group!.members.length),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: AppLocalizations.of(context)!.addMember,
                        onPressed: _addMember,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_group!.members.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(AppLocalizations.of(context)!.noMembersYet),
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

  String _getResponseModeTitle(GroupResponseMode mode, BuildContext context) {
    switch (mode) {
      case GroupResponseMode.sequential:
        return AppLocalizations.of(context)!.sequential;
      case GroupResponseMode.random:
        return AppLocalizations.of(context)!.random;
      case GroupResponseMode.all:
        return AppLocalizations.of(context)!.allAtOnce;
      case GroupResponseMode.manual:
        return AppLocalizations.of(context)!.manual;
      case GroupResponseMode.natural:
        return AppLocalizations.of(context)!.natural;
    }
  }

  String _getResponseModeDescription(GroupResponseMode mode, BuildContext context) {
    switch (mode) {
      case GroupResponseMode.sequential:
        return AppLocalizations.of(context)!.charactersRespondInOrder;
      case GroupResponseMode.random:
        return AppLocalizations.of(context)!.randomCharacterResponds;
      case GroupResponseMode.all:
        return AppLocalizations.of(context)!.allNonMutedCharactersRespond;
      case GroupResponseMode.manual:
        return AppLocalizations.of(context)!.youSelectWhoResponds;
      case GroupResponseMode.natural:
        return AppLocalizations.of(context)!.aiDecidesBasedOnContext;
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
            '${AppLocalizations.of(context)!.talkativenessPercent(member.talkativeness)} ${member.triggerWords.isNotEmpty ? '• ${AppLocalizations.of(context)!.triggers(member.triggerWords.join(", "))}' : ''}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  member.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: member.isMuted ? Colors.grey : null,
                ),
                tooltip: member.isMuted ? AppLocalizations.of(context)!.unmute : AppLocalizations.of(context)!.mute,
                onPressed: onToggleMute,
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: AppLocalizations.of(context)!.settings,
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: AppLocalizations.of(context)!.removeMember,
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
      title: Text(AppLocalizations.of(context)!.addMemberToGroup),
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
          child: Text(AppLocalizations.of(context)!.cancel),
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
      title: Text(AppLocalizations.of(context)!.memberSettings),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.talkativenessLabel(_talkativeness.round())),
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
          Text(
            AppLocalizations.of(context)!.higherValuesMoreLikely,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _triggerWordsController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.triggerWords,
              hintText: AppLocalizations.of(context)!.triggerWordsHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.characterWillRespondWhenTriggered,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
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
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}