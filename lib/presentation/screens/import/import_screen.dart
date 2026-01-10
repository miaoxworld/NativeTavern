import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/data/repositories/world_info_repository.dart';
import 'package:native_tavern/domain/services/import_service.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Import service provider
final importServiceProvider = Provider<ImportService>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Import state
class ImportState {
  final bool isLoading;
  final String? error;
  final Character? previewCharacter;
  final String? filePath;
  final ImportFormat? format;

  const ImportState({
    this.isLoading = false,
    this.error,
    this.previewCharacter,
    this.filePath,
    this.format,
  });

  ImportState copyWith({
    bool? isLoading,
    String? error,
    Character? previewCharacter,
    String? filePath,
    ImportFormat? format,
  }) {
    return ImportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      previewCharacter: previewCharacter ?? this.previewCharacter,
      filePath: filePath ?? this.filePath,
      format: format ?? this.format,
    );
  }
}

/// Import state notifier
class ImportNotifier extends StateNotifier<ImportState> {
  final ImportService _importService;

  ImportNotifier(this._importService) : super(const ImportState());

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'charx', 'json'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          await loadFile(file.path!);
        }
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick file: $e'); // Error already handled in UI
    }
  }

  Future<void> loadFile(String path) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final extension = path.split('.').last.toLowerCase();
      ImportFormat format;

      switch (extension) {
        case 'png':
          format = ImportFormat.png;
          break;
        case 'charx':
          format = ImportFormat.charx;
          break;
        case 'json':
          format = ImportFormat.json;
          break;
        default:
          throw Exception('Unsupported file format: $extension'); // Will be caught and shown
      }

      Character? character;
      
      switch (format) {
        case ImportFormat.png:
          character = await _importService.importFromPng(path);
          break;
        case ImportFormat.charx:
          character = await _importService.importFromCharX(path);
          break;
        case ImportFormat.json:
          final file = File(path);
          final json = await file.readAsString();
          character = await _importService.importFromJson(json);
          break;
      }

      state = state.copyWith(
        isLoading: false,
        previewCharacter: character,
        filePath: path,
        format: format,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load character: $e',
      );
    }
  }

  void clear() {
    state = const ImportState();
  }
}

/// Import state provider
final importStateProvider =
    StateNotifierProvider<ImportNotifier, ImportState>((ref) {
  final importService = ref.watch(importServiceProvider);
  return ImportNotifier(importService);
});

/// Import format enum
enum ImportFormat { png, charx, json }

/// Import screen
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  @override
  void initState() {
    super.initState();
    // Clear previous import state when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(importStateProvider.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(importStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.importCharacter),
        actions: [
          if (importState.previewCharacter != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(importStateProvider.notifier).clear(),
              tooltip: AppLocalizations.of(context)!.clear,
            ),
        ],
      ),
      body: importState.previewCharacter != null
          ? _CharacterPreview(
              character: importState.previewCharacter!,
              onImport: () => _importCharacter(context, ref),
            )
          : _FilePickerView(
              isLoading: importState.isLoading,
              error: importState.error,
              onPickFile: () => ref.read(importStateProvider.notifier).pickFile(),
            ),
    );
  }

  Future<void> _importCharacter(BuildContext context, WidgetRef ref) async {
    final importState = ref.read(importStateProvider);
    if (importState.previewCharacter == null) return;

    try {
      // Add the character
      final character = await ref
          .read(characterListProvider.notifier)
          .addCharacter(importState.previewCharacter!);

      // If the character has an embedded lorebook, create a WorldInfo for it
      if (importState.previewCharacter!.characterBook != null &&
          importState.previewCharacter!.characterBook!.entries.isNotEmpty) {
        await _importEmbeddedLorebook(
          ref,
          character.id,
          importState.previewCharacter!.characterBook!,
          importState.previewCharacter!.name,
        );
      }

      if (context.mounted) {
        final hasLorebook = importState.previewCharacter!.characterBook?.entries.isNotEmpty ?? false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              hasLorebook
                  ? 'Imported "${importState.previewCharacter!.name}" with embedded lorebook!'
                  : 'Imported "${importState.previewCharacter!.name}" successfully!',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToImport(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Import embedded lorebook (character_book) as a WorldInfo entry linked to the character
  Future<void> _importEmbeddedLorebook(
    WidgetRef ref,
    String characterId,
    CharacterBook characterBook,
    String characterName,
  ) async {
    final worldInfoRepo = ref.read(worldInfoRepositoryProvider);
    
    // Create a WorldInfo entry linked to this character
    final worldInfoName = characterBook.name ?? '$characterName Lorebook';
    final worldInfo = await worldInfoRepo.createWorldInfo(
      name: worldInfoName,
      description: characterBook.description ?? 'Embedded lorebook from $characterName',
      isGlobal: false,
      characterId: characterId,
    );
    
    // Convert and add all CharacterBookEntry as WorldInfoEntry
    for (final entry in characterBook.entries) {
      // Map CharacterBookEntry position to WorldInfoPosition
      // In character card spec: 0 = before char defs, 1 = after char defs
      WorldInfoPosition position;
      switch (entry.position) {
        case 0:
          position = WorldInfoPosition.beforeCharDefs;
          break;
        case 1:
          position = WorldInfoPosition.afterCharDefs;
          break;
        default:
          position = WorldInfoPosition.afterCharDefs;
      }
      
      await worldInfoRepo.addEntry(
        worldInfoId: worldInfo.id,
        keys: entry.keys,
        content: entry.content,
        secondaryKeys: entry.secondaryKeys.isNotEmpty ? entry.secondaryKeys : null,
        comment: entry.name.isNotEmpty ? entry.name : entry.comment,
        position: position,
        depth: 4, // Default depth
      );
    }
  }
}

class _FilePickerView extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback onPickFile;

  const _FilePickerView({
    required this.isLoading,
    required this.error,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.darkDivider,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  if (isLoading)
                    const CircularProgressIndicator()
                  else ...[
                    const Icon(
                      Icons.file_upload_outlined,
                      size: 64,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a character card',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Supports PNG, CharX, and JSON formats',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: onPickFile,
                      icon: const Icon(Icons.folder_open),
                      label: Text(AppLocalizations.of(context)!.browseFiles),
                    ),
                  ],
                ],
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            _buildFormatInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.supportedFormats,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.accentColor,
              ),
        ),
        const SizedBox(height: 12),
        _FormatTile(
          icon: Icons.image,
          title: AppLocalizations.of(context)!.pngCharacterCard,
          description: AppLocalizations.of(context)!.characterDataEmbeddedInImage,
        ),
        const SizedBox(height: 8),
        _FormatTile(
          icon: Icons.archive,
          title: AppLocalizations.of(context)!.charxArchive,
          description: AppLocalizations.of(context)!.zipArchiveWithCharacterData,
        ),
        const SizedBox(height: 8),
        _FormatTile(
          icon: Icons.code,
          title: AppLocalizations.of(context)!.json,
          description: AppLocalizations.of(context)!.plainCharacterCardJson,
        ),
      ],
    );
  }
}

class _FormatTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FormatTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CharacterPreview extends StatelessWidget {
  final Character character;
  final VoidCallback onImport;

  const _CharacterPreview({
    required this.character,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar and basic info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.darkDivider,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: character.assets?.avatarPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(character.assets!.avatarPath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: AppTheme.textMuted,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (character.creator.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'by ${character.creator}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                          ),
                        ],
                        if (character.version.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Version: ${character.version}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Tags
          if (character.tags.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.tags,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.accentColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: character.tags
                          .map((tag) => Chip(
                                label: Text(tag),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Description
          if (character.description.isNotEmpty)
            _ExpandableSection(
              title: 'Description',
              content: character.description,
            ),

          // Personality
          if (character.personality.isNotEmpty)
            _ExpandableSection(
              title: 'Personality',
              content: character.personality,
            ),

          // Scenario
          if (character.scenario.isNotEmpty)
            _ExpandableSection(
              title: 'Scenario',
              content: character.scenario,
            ),

          // First message
          if (character.firstMessage.isNotEmpty)
            _ExpandableSection(
              title: 'First Message',
              content: character.firstMessage,
            ),

          // Alternate greetings
          if (character.alternateGreetings.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.format_list_bulleted, size: 20, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.alternateGreetingsCount(character.alternateGreetings.length),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.accentColor,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...character.alternateGreetings.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${e.key + 1}. ${e.value.length > 100 ? '${e.value.substring(0, 100)}...' : e.value}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                      ),
                    )),
                  ],
                ),
              ),
            ),

          // Embedded lorebook
          if (character.characterBook != null && character.characterBook!.entries.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_stories, size: 20, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.embeddedLorebookEntries(character.characterBook!.entries.length),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.accentColor,
                              ),
                        ),
                      ],
                    ),
                    if (character.characterBook!.name != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        character.characterBook!.name!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Keywords: ${character.characterBook!.entries.expand((e) => e.keys).take(10).join(", ")}${character.characterBook!.entries.expand((e) => e.keys).length > 10 ? "..." : ""}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

          // Example messages
          if (character.exampleMessages.isNotEmpty)
            _ExpandableSection(
              title: 'Example Messages',
              content: character.exampleMessages,
            ),

          // Import button
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onImport,
            icon: const Icon(Icons.download),
            label: Text(AppLocalizations.of(context)!.importCharacter),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ExpandableSection extends StatefulWidget {
  final String title;
  final String content;

  const _ExpandableSection({
    required this.title,
    required this.content,
  });

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppTheme.accentColor,
                        ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                SelectableText(
                  widget.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ] else ...[
                const SizedBox(height: 4),
                Text(
                  widget.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}