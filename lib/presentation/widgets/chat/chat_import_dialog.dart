import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/persona_repository.dart';
import 'package:native_tavern/domain/services/chat_export_service.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/common/character_avatar_image.dart';

/// Interactive dialog/sheet to verify, resolve character/persona auto-assignment,
/// and import a SillyTavern chat session.
class ChatImportResolutionDialog extends ConsumerStatefulWidget {
  final ChatImportResult importResult;
  final String? initialCharacterId;

  const ChatImportResolutionDialog({
    super.key,
    required this.importResult,
    this.initialCharacterId,
  });

  static Future<Chat?> show(
    BuildContext context, {
    required ChatImportResult importResult,
    String? initialCharacterId,
  }) {
    return showModalBottomSheet<Chat>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChatImportResolutionDialog(
        importResult: importResult,
        initialCharacterId: initialCharacterId,
      ),
    );
  }

  @override
  ConsumerState<ChatImportResolutionDialog> createState() =>
      _ChatImportResolutionDialogState();
}

class _ChatImportResolutionDialogState
    extends ConsumerState<ChatImportResolutionDialog> {
  Character? _selectedCharacter;
  Persona? _selectedPersona;
  List<Character> _availableCharacters = [];
  List<Persona> _availablePersonas = [];
  bool _isLoading = true;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    _loadAndAutoAssign();
  }

  Future<void> _loadAndAutoAssign() async {
    final charRepo = ref.read(characterRepositoryProvider);
    final personaRepo = ref.read(personaRepositoryProvider);

    final characters = await charRepo.getAllCharacters();
    final personas = await personaRepo.getAllPersonas();

    Character? matchedChar;
    if (widget.initialCharacterId != null) {
      matchedChar = characters.firstWhere(
        (c) => c.id == widget.initialCharacterId,
        orElse: () => characters.first,
      );
    } else {
      final targetCharName =
          widget.importResult.characterName.trim().toLowerCase();
      for (final c in characters) {
        if (c.name.trim().toLowerCase() == targetCharName) {
          matchedChar = c;
          break;
        }
      }
      matchedChar ??= characters.cast<Character?>().firstWhere(
            (c) => c != null && c.name.toLowerCase().contains(targetCharName),
            orElse: () => null,
          );
    }

    Persona? matchedPersona;
    final targetPersonaName =
        (widget.importResult.personaName ?? widget.importResult.userName)
            .trim()
            .toLowerCase();
    for (final p in personas) {
      if (p.name.trim().toLowerCase() == targetPersonaName) {
        matchedPersona = p;
        break;
      }
    }

    if (mounted) {
      setState(() {
        _availableCharacters = characters;
        _availablePersonas = personas;
        _selectedCharacter = matchedChar;
        _selectedPersona = matchedPersona;
        _isLoading = false;
      });
    }
  }

  void _chooseCharacter() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Character for Chat',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _availableCharacters.length,
                itemBuilder: (context, index) {
                  final char = _availableCharacters[index];
                  final isSelected = char.id == _selectedCharacter?.id;
                  return ListTile(
                    leading: (char.assets?.avatarPath != null &&
                            char.assets!.avatarPath!.isNotEmpty)
                        ? CharacterAvatarCircle(
                            imagePath: char.assets!.avatarPath!,
                            radius: 20,
                          )
                        : const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                    title: Text(char.name),
                    subtitle: Text(
                      char.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle,
                            color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      setState(() => _selectedCharacter = char);
                      Navigator.pop(sheetContext);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _choosePersona() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select User Persona',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _availablePersonas.length,
                itemBuilder: (context, index) {
                  final persona = _availablePersonas[index];
                  final isSelected = persona.id == _selectedPersona?.id;
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(persona.name),
                    subtitle: Text(
                      persona.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle,
                            color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      setState(() => _selectedPersona = persona);
                      Navigator.pop(sheetContext);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performImport() async {
    if (_selectedCharacter == null) return;
    setState(() => _isImporting = true);

    try {
      final chatNotifier = ref.read(activeChatProvider.notifier);
      final newChat = await chatNotifier.createChatFromImport(
        characterId: _selectedCharacter!.id,
        personaId: _selectedPersona?.id,
        importResult: widget.importResult,
      );

      if (mounted) {
        Navigator.pop(context, newChat);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import chat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.chat_outlined, color: AppTheme.primaryColor),
                const SizedBox(width: 10),
                Text(
                  'Import Chat History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              // Summary cards
              Card(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        Icons.message,
                        '${widget.importResult.messages.length}',
                        'Messages',
                      ),
                      if (widget.importResult.model != null &&
                          widget.importResult.model!.isNotEmpty)
                        _buildStat(
                          Icons.memory,
                          widget.importResult.model!,
                          'Model',
                        ),
                      _buildStat(
                        Icons.calendar_today,
                        '${widget.importResult.createDate.month}/${widget.importResult.createDate.day}/${widget.importResult.createDate.year}',
                        'Date',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Character Assignment Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _selectedCharacter != null
                        ? theme.colorScheme.outlineVariant
                        : Colors.orange,
                    width: _selectedCharacter != null ? 1 : 1.5,
                  ),
                ),
                child: ListTile(
                  leading: (_selectedCharacter?.assets?.avatarPath != null &&
                          _selectedCharacter!.assets!.avatarPath!.isNotEmpty)
                      ? CharacterAvatarCircle(
                          imagePath: _selectedCharacter!.assets!.avatarPath!,
                          radius: 22,
                        )
                      : CircleAvatar(
                          backgroundColor: _selectedCharacter != null
                              ? AppTheme.primaryColor
                              : Colors.orange,
                          child: Icon(
                            _selectedCharacter != null
                                ? Icons.person
                                : Icons.warning,
                            color: Colors.white,
                          ),
                        ),
                  title: Text(
                    _selectedCharacter?.name ?? 'No Character Selected',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _selectedCharacter != null
                        ? (widget.importResult.characterName.isNotEmpty
                            ? 'Auto-matched with "${widget.importResult.characterName}"'
                            : 'Assigned character')
                        : 'Tap to select which character to attach this chat to',
                  ),
                  trailing: TextButton(
                    onPressed: _chooseCharacter,
                    child:
                        Text(_selectedCharacter != null ? 'Change' : 'Select'),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // User Persona Assignment Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text(
                    _selectedPersona?.name ??
                        (widget.importResult.userName.isNotEmpty
                            ? widget.importResult.userName
                            : 'Default Persona'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _selectedPersona != null
                        ? 'Assigned persona'
                        : 'Using user name from import',
                  ),
                  trailing: TextButton(
                    onPressed: _choosePersona,
                    child: const Text('Change'),
                  ),
                ),
              ),

              if (widget.importResult.authorNote != null &&
                  widget.importResult.authorNote!.isNotEmpty) ...[
                const SizedBox(height: 10),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.note_alt_outlined, size: 20),
                  title: const Text("Includes Author's Note"),
                  subtitle: Text(
                    widget.importResult.authorNote!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: (_selectedCharacter != null && !_isImporting)
                    ? _performImport
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isImporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.file_download_done),
                label: Text(
                  _isImporting ? 'Importing...' : 'Import Chat Session',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
        ),
      ],
    );
  }
}
