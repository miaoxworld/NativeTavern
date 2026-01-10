import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Character editor screen for creating/editing characters
class CharacterEditorScreen extends ConsumerStatefulWidget {
  final String? characterId; // null for new character

  const CharacterEditorScreen({super.key, this.characterId});

  @override
  ConsumerState<CharacterEditorScreen> createState() => _CharacterEditorScreenState();
}

class _CharacterEditorScreenState extends ConsumerState<CharacterEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for all fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personalityController = TextEditingController();
  final _scenarioController = TextEditingController();
  final _firstMessageController = TextEditingController();
  final _exampleMessagesController = TextEditingController();
  final _systemPromptController = TextEditingController();
  final _postHistoryController = TextEditingController();
  final _creatorNotesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _creatorController = TextEditingController();
  final _versionController = TextEditingController();
  
  // Alternate greetings controllers
  final List<TextEditingController> _alternateGreetingControllers = [];
  
  // State
  bool _isLoading = true;
  bool _isSaving = false;
  Character? _character;
  Uint8List? _avatarData;
  String? _avatarPath;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCharacter();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _personalityController.dispose();
    _scenarioController.dispose();
    _firstMessageController.dispose();
    _exampleMessagesController.dispose();
    _systemPromptController.dispose();
    _postHistoryController.dispose();
    _creatorNotesController.dispose();
    _tagsController.dispose();
    _creatorController.dispose();
    _versionController.dispose();
    for (final controller in _alternateGreetingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCharacter() async {
    if (widget.characterId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final repo = ref.read(characterRepositoryProvider);
      final character = await repo.getCharacter(widget.characterId!);
      
      if (character != null) {
        _character = character;
        _nameController.text = character.name;
        _descriptionController.text = character.description;
        _personalityController.text = character.personality;
        _scenarioController.text = character.scenario;
        _firstMessageController.text = character.firstMessage;
        _exampleMessagesController.text = character.exampleMessages;
        _systemPromptController.text = character.systemPrompt;
        _postHistoryController.text = character.postHistoryInstructions;
        _creatorNotesController.text = character.creatorNotes;
        _tagsController.text = character.tags.join(', ');
        _creatorController.text = character.creator;
        _versionController.text = character.version;
        _avatarPath = character.assets?.avatarPath;
        
        // Load alternate greetings
        for (final greeting in character.alternateGreetings) {
          _alternateGreetingControllers.add(TextEditingController(text: greeting));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToLoadCharacter(e.toString()))),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAvatar() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        Uint8List? bytes;
        
        if (file.bytes != null) {
          bytes = file.bytes;
        } else if (file.path != null) {
          bytes = await File(file.path!).readAsBytes();
        }

        if (bytes != null) {
          setState(() {
            _avatarData = bytes;
            _hasChanges = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToPickImage(e.toString()))),
        );
      }
    }
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(characterRepositoryProvider);
      final now = DateTime.now();
      
      // Parse tags
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      
      // Get alternate greetings
      final alternateGreetings = _alternateGreetingControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      Character character;
      
      if (_character != null) {
        // Update existing character
        character = _character!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          personality: _personalityController.text,
          scenario: _scenarioController.text,
          firstMessage: _firstMessageController.text,
          alternateGreetings: alternateGreetings,
          exampleMessages: _exampleMessagesController.text,
          systemPrompt: _systemPromptController.text,
          postHistoryInstructions: _postHistoryController.text,
          creatorNotes: _creatorNotesController.text,
          tags: tags,
          creator: _creatorController.text,
          version: _versionController.text,
          modifiedAt: now,
        );
        character = await repo.updateCharacter(character);
      } else {
        // Create new character
        character = Character(
          id: '',
          name: _nameController.text,
          description: _descriptionController.text,
          personality: _personalityController.text,
          scenario: _scenarioController.text,
          firstMessage: _firstMessageController.text,
          alternateGreetings: alternateGreetings,
          exampleMessages: _exampleMessagesController.text,
          systemPrompt: _systemPromptController.text,
          postHistoryInstructions: _postHistoryController.text,
          creatorNotes: _creatorNotesController.text,
          tags: tags,
          creator: _creatorController.text,
          version: _versionController.text,
          createdAt: now,
          modifiedAt: now,
        );
        character = await repo.createCharacter(character);
      }

      // Save avatar if changed
      if (_avatarData != null) {
        await repo.saveAvatar(character.id, _avatarData!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.characterSavedSuccessfully)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToSaveCharacter(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.characterId == null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? AppLocalizations.of(context)!.createCharacter : AppLocalizations.of(context)!.editCharacter),
        actions: [
          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.circle,
                size: 12,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          TextButton.icon(
            onPressed: _isSaving ? null : _saveCharacter,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(AppLocalizations.of(context)!.save),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.basic),
            Tab(text: AppLocalizations.of(context)!.prompts),
            Tab(text: AppLocalizations.of(context)!.messages),
            Tab(text: AppLocalizations.of(context)!.meta),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              onChanged: _markChanged,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicTab(),
                  _buildPromptsTab(),
                  _buildMessagesTab(),
                  _buildMetaTab(),
                ],
              ),
            ),
    );
  }

  Widget _buildBasicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    backgroundImage: _getAvatarImage(),
                    child: _avatarData == null && _avatarPath == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Name
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.nameRequired,
              hintText: AppLocalizations.of(context)!.characterName,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!.nameIsRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.description,
              hintText: AppLocalizations.of(context)!.characterDescription,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 6,
          ),
          const SizedBox(height: 16),
          
          // Personality
          TextFormField(
            controller: _personalityController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.personality,
              hintText: AppLocalizations.of(context)!.characterPersonalityTraits,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          
          // Scenario
          TextFormField(
            controller: _scenarioController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.scenario,
              hintText: AppLocalizations.of(context)!.currentCircumstancesContext,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  ImageProvider? _getAvatarImage() {
    if (_avatarData != null) {
      return MemoryImage(_avatarData!);
    }
    if (_avatarPath != null) {
      return FileImage(File(_avatarPath!));
    }
    return null;
  }

  Widget _buildPromptsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.systemPrompt,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.customInstructionsSystemMessage,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _systemPromptController,
            decoration: const InputDecoration(
              hintText: 'You are {char}. You will...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 8,
          ),
          const SizedBox(height: 24),
          
          Text(
            AppLocalizations.of(context)!.postHistoryInstructions,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.instructionsInsertedAfterHistory,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _postHistoryController,
            decoration: const InputDecoration(
              hintText: 'Continue the roleplay as {char}...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.firstMessageGreeting,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.firstMessageSentByCharacter,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _firstMessageController,
            decoration: const InputDecoration(
              hintText: '*walks into the room* Hello, {user}!',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 8,
          ),
          const SizedBox(height: 24),
          
          // Alternate Greetings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.alternateGreetingsCount(_alternateGreetingControllers.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _addAlternateGreeting,
                tooltip: AppLocalizations.of(context)!.addAlternateGreeting,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.alternateGreetingsCanSwipe,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ..._alternateGreetingControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.greeting(index + 1),
                        hintText: AppLocalizations.of(context)!.alternativeGreetingMessage,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      onChanged: (_) => _markChanged(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeAlternateGreeting(index),
                        tooltip: AppLocalizations.of(context)!.removeGreeting,
                      ),
                      if (index > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () => _moveGreeting(index, -1),
                          tooltip: AppLocalizations.of(context)!.moveUp,
                        ),
                      if (index < _alternateGreetingControllers.length - 1)
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: () => _moveGreeting(index, 1),
                          tooltip: AppLocalizations.of(context)!.moveDown,
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
          if (_alternateGreetingControllers.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.noAlternateGreetings,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          
          Text(
            AppLocalizations.of(context)!.exampleMessages,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Example dialogue to demonstrate how the character speaks.\nFormat: <START>\n{user}: Hello\n{char}: Hi there!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _exampleMessagesController,
            decoration: const InputDecoration(
              hintText: '<START>\n{user}: How are you?\n{char}: I\'m doing well, thanks for asking!',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  void _addAlternateGreeting() {
    setState(() {
      _alternateGreetingControllers.add(TextEditingController());
      _hasChanges = true;
    });
  }

  void _removeAlternateGreeting(int index) {
    setState(() {
      _alternateGreetingControllers[index].dispose();
      _alternateGreetingControllers.removeAt(index);
      _hasChanges = true;
    });
  }

  void _moveGreeting(int index, int direction) {
    final newIndex = index + direction;
    if (newIndex < 0 || newIndex >= _alternateGreetingControllers.length) return;
    
    setState(() {
      final controller = _alternateGreetingControllers.removeAt(index);
      _alternateGreetingControllers.insert(newIndex, controller);
      _hasChanges = true;
    });
  }

  Widget _buildMetaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator Notes
          Text(
            AppLocalizations.of(context)!.creatorNotes,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.creatorNotesNotSentToAi,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _creatorNotesController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.creatorNotesHint,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          
          // Tags
          TextFormField(
            controller: _tagsController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.tags,
              hintText: AppLocalizations.of(context)!.tagsHint,
              helperText: AppLocalizations.of(context)!.tagsCommaSeparated,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          // Creator
          TextFormField(
            controller: _creatorController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.creator,
              hintText: AppLocalizations.of(context)!.yourNameOrUsername,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          
          // Version
          TextFormField(
            controller: _versionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.version,
              hintText: AppLocalizations.of(context)!.versionNumber,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          
          // Character Info Card
          if (_character != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.characterInfo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.characterId(_character!.id)),
                    Text(AppLocalizations.of(context)!.created(_character!.createdAt.toLocal().toString())),
                    Text(AppLocalizations.of(context)!.modified(_character!.modifiedAt.toLocal().toString())),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}