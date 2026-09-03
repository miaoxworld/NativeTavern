import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/data/repositories/world_info_repository.dart';
import 'package:native_tavern/data/models/live2d.dart';
import 'package:native_tavern/domain/services/import_service.dart';
import 'package:native_tavern/domain/services/character_regex_import_service.dart';
import 'package:native_tavern/domain/services/live2d_import_service.dart';
import 'package:native_tavern/domain/services/live2d_service.dart';
import 'package:native_tavern/domain/services/url_import_service.dart';
import 'package:path/path.dart' as p;
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/providers/regex_providers.dart';
import 'package:native_tavern/presentation/providers/external_call_audit_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:uuid/uuid.dart';
import 'package:native_tavern/domain/services/chat_export_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';

/// Import service provider
final importServiceProvider = Provider<ImportService>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// URL import service provider
final urlImportServiceProvider = Provider<UrlImportService>((ref) {
  final importService = ref.watch(importServiceProvider);
  return UrlImportService(
    importService,
    auditRepository: ref.watch(externalCallAuditRepositoryProvider),
  );
});

/// Import result for a single file or URL
class ImportResult {
  final String fileName;
  final String filePath;
  final Character? character;
  final String? error;
  final bool isProcessing;
  final UrlSource? urlSource;

  const ImportResult({
    required this.fileName,
    required this.filePath,
    this.character,
    this.error,
    this.isProcessing = false,
    this.urlSource,
  });

  ImportResult copyWith({
    Character? character,
    String? error,
    bool? isProcessing,
    UrlSource? urlSource,
  }) {
    return ImportResult(
      fileName: fileName,
      filePath: filePath,
      character: character ?? this.character,
      error: error,
      isProcessing: isProcessing ?? this.isProcessing,
      urlSource: urlSource ?? this.urlSource,
    );
  }
}

/// Import state
class ImportState {
  final bool isLoading;
  final String? error;
  final List<ImportResult> results;
  final int totalFiles;
  final int processedFiles;

  const ImportState({
    this.isLoading = false,
    this.error,
    this.results = const [],
    this.totalFiles = 0,
    this.processedFiles = 0,
  });

  bool get hasResults => results.isNotEmpty;
  int get successCount => results.where((r) => r.character != null).length;
  int get errorCount => results.where((r) => r.error != null).length;

  ImportState copyWith({
    bool? isLoading,
    String? error,
    List<ImportResult>? results,
    int? totalFiles,
    int? processedFiles,
  }) {
    return ImportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      results: results ?? this.results,
      totalFiles: totalFiles ?? this.totalFiles,
      processedFiles: processedFiles ?? this.processedFiles,
    );
  }
}

/// Import state notifier
class ImportNotifier extends StateNotifier<ImportState> {
  final ImportService _importService;
  final UrlImportService _urlImportService;
  final Live2DImportService _live2dImportService;
  final Live2DService _live2dService;
  final ImagePicker _imagePicker = ImagePicker();

  ImportNotifier(
    this._importService,
    this._urlImportService,
    this._live2dImportService,
    this._live2dService,
  ) : super(const ImportState());

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'png',
          'charx',
          'json',
          'jsonl',
          'zip',
          'skel',
          'atlas',
          'ntb',
          'ntm',
          'ntx',
        ],
        allowMultiple: true, // Enable batch import
      );

      if (result != null && result.files.isNotEmpty) {
        await loadFiles(result.files
            .where((f) => f.path != null)
            .map((f) => f.path!)
            .toList());
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick file: $e');
    }
  }

  /// Pick character card image from photo gallery (for mobile)
  Future<void> pickFromGallery() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 4096,
        maxHeight: 4096,
      );

      if (images.isNotEmpty) {
        await loadFiles(images.map((img) => img.path).toList());
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to pick from gallery: $e',
      );
    }
  }

  Future<void> loadFiles(List<String> paths) async {
    if (paths.isEmpty) return;

    // Initialize results with all file paths
    final results = paths.map((path) {
      final fileName = path.split('/').last;
      return ImportResult(
        fileName: fileName,
        filePath: path,
        isProcessing: true,
      );
    }).toList();

    state = state.copyWith(
      isLoading: true,
      error: null,
      results: results,
      totalFiles: paths.length,
      processedFiles: 0,
    );

    // Process each file
    for (int i = 0; i < paths.length; i++) {
      final path = paths[i];
      try {
        final extension = path.split('.').last.toLowerCase();
        Character? character;

        switch (extension) {
          case 'png':
            character = await _importService.importFromPng(path);
            break;
          case 'charx':
            character = await _importService.importFromCharX(path);
            break;
          case 'json':
            final file = File(path);
            final json = await file.readAsString();
            character = await _importService.importFromJson(json);
            break;
          case 'jsonl':
            final chatImport = await ChatExportService().importFromPath(path);
            if (chatImport != null) {
              character = Character(
                id: const Uuid().v4(),
                name: chatImport.characterName,
                description:
                    'Imported Chat History (${chatImport.messages.length} messages)',
                personality: '',
                firstMessage: chatImport.messages.isNotEmpty
                    ? chatImport.messages.first.content
                    : '',
                scenario: '',
                exampleMessages: '',
                creatorNotes: 'Imported from ${path.split('/').last}',
                systemPrompt: '',
                postHistoryInstructions: '',
                tags: const ['chat-history'],
                creator: chatImport.userName,
                version: '1.0',
                alternateGreetings: const [],
                extensions: {
                  'chatImport': true,
                  'chatImportPath': path,
                },
                createdAt: chatImport.createDate,
                modifiedAt: DateTime.now(),
              );
            }
            break;
          case 'zip':
            character = await _importZip(path);
            break;
          case 'skel':
          case 'atlas':
            character = await _importLive2DAsCharacter(
              () => _live2dImportService.importSpineFiles([File(path)]),
            );
            break;
          case 'ntb':
          case 'ntx':
            final file = File(path);
            final ntbChars = extension == 'ntx'
                ? await _importService
                    .importCharactersFromNtx(await file.readAsBytes())
                : await _importService
                    .importCharactersFromNtb(await file.readAsString());
            if (ntbChars.isNotEmpty) {
              character = ntbChars.first;
              final baseName = p.basename(path);
              for (int cIdx = 1; cIdx < ntbChars.length; cIdx++) {
                results.add(ImportResult(
                  fileName: '${ntbChars[cIdx].name} ($baseName)',
                  filePath: path,
                  character: ntbChars[cIdx],
                  isProcessing: false,
                ));
              }
            }
            break;
          default:
            throw Exception('Unsupported file format: $extension');
        }

        // Update result with character
        final updatedResults = List<ImportResult>.from(state.results);
        updatedResults[i] = updatedResults[i].copyWith(
          character: character,
          isProcessing: false,
        );

        state = state.copyWith(
          results: updatedResults,
          processedFiles: i + 1,
        );
      } catch (e) {
        // Update result with error
        final updatedResults = List<ImportResult>.from(state.results);
        updatedResults[i] = updatedResults[i].copyWith(
          error: e.toString(),
          isProcessing: false,
        );

        state = state.copyWith(
          results: updatedResults,
          processedFiles: i + 1,
        );
      }
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> importFromUrl(String url) async {
    if (url.trim().isEmpty) return;

    final source = _urlImportService.identifySource(url);
    final sourceName = _urlImportService.getSourceDisplayName(source);

    final results = [
      ImportResult(
        fileName: sourceName,
        filePath: url,
        isProcessing: true,
        urlSource: source,
      ),
    ];

    state = state.copyWith(
      isLoading: true,
      error: null,
      results: results,
      totalFiles: 1,
      processedFiles: 0,
    );

    try {
      final result = await _urlImportService.importFromUrl(url);
      final updatedResults = [
        results[0].copyWith(
          character: result.character,
          isProcessing: false,
          urlSource: result.source,
        ),
      ];
      state = state.copyWith(
        results: updatedResults,
        processedFiles: 1,
        isLoading: false,
      );
    } catch (e) {
      final updatedResults = [
        results[0].copyWith(
          error: e.toString(),
          isProcessing: false,
        ),
      ];
      state = state.copyWith(
        results: updatedResults,
        processedFiles: 1,
        isLoading: false,
      );
    }
  }

  void clear() {
    state = const ImportState();
  }

  Future<Character> _importZip(String path) async {
    try {
      return await _importService.importFromCharX(path);
    } catch (error) {
      if (!_isMissingCharxPayload(error)) rethrow;
      return _importLive2DAsCharacter(
        () => _live2dImportService.importZip(File(path)),
      );
    }
  }

  bool _isMissingCharxPayload(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('card.json') ||
        message.contains('no character data');
  }

  Future<Character> _importLive2DAsCharacter(
    Future<List<Live2DModelDefinition>> Function() importModels,
  ) async {
    final models = await importModels();
    if (models.isEmpty) {
      throw const Live2DImportException(
        'No Cubism or Spine model was found in the selected files.',
      );
    }
    final definition = models.first;
    Live2DModelManifest manifest;
    try {
      manifest = await _live2dService.loadManifest(definition);
    } catch (_) {
      manifest = Live2DModelManifest(
        format: definition.format,
        version: definition.format == Live2DModelFormat.spine ? 4 : 3,
        mocFile: '',
        textures: const [],
        atlasFileName: definition.atlasFileName,
      );
    }
    return _importService.createCharacterFromLive2D(
      definition: definition,
      config: Live2DConfig.fromDefinition(definition, manifest),
      avatarBytes: await _live2dAvatarBytes(definition, manifest),
    );
  }

  Future<List<int>?> _live2dAvatarBytes(
    Live2DModelDefinition definition,
    Live2DModelManifest manifest,
  ) async {
    if (definition.source != Live2DModelSource.appData) return null;
    final directory = p.join(
      _importService.dataPath,
      definition.modelDirectory,
    );
    final candidates = [
      ...manifest.textures,
      if (definition.atlasFileName != null)
        p.setExtension(definition.atlasFileName!, '.png'),
      p.setExtension(definition.modelFileName, '.png'),
    ];
    for (final candidate in candidates) {
      final file = File(p.join(directory, p.basename(candidate)));
      if (file.existsSync()) return file.readAsBytes();
    }
    return null;
  }
}

/// Import state provider
final importStateProvider =
    StateNotifierProvider<ImportNotifier, ImportState>((ref) {
  final importService = ref.watch(importServiceProvider);
  final urlImportService = ref.watch(urlImportServiceProvider);
  return ImportNotifier(
    importService,
    urlImportService,
    ref.watch(live2DImportServiceProvider),
    ref.watch(live2DServiceProvider),
  );
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
      final pending = ref.read(pendingImportFilePathProvider);
      if (pending != null) {
        ref.read(pendingImportFilePathProvider.notifier).state = null;
        ref.read(importStateProvider.notifier).loadFiles([pending]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(importStateProvider);
    final l10n = AppLocalizations.of(context)!;
    ref.listen<String?>(pendingImportFilePathProvider, (previous, next) {
      if (next == null || next == previous) return;
      ref.read(pendingImportFilePathProvider.notifier).state = null;
      ref.read(importStateProvider.notifier).loadFiles([next]);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.importCharacter),
        actions: [
          if (importState.hasResults)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(importStateProvider.notifier).clear(),
              tooltip: l10n.clear,
            ),
        ],
      ),
      body: importState.hasResults
          ? _BatchImportResults(
              results: importState.results,
              isLoading: importState.isLoading,
              totalFiles: importState.totalFiles,
              processedFiles: importState.processedFiles,
              onImportAll: () => _importAllCharacters(context, ref),
            )
          : _FilePickerView(
              isLoading: importState.isLoading,
              error: importState.error,
              onPickFile: () =>
                  ref.read(importStateProvider.notifier).pickFile(),
              onPickFromGallery: () =>
                  ref.read(importStateProvider.notifier).pickFromGallery(),
              onImportUrl: (url) =>
                  ref.read(importStateProvider.notifier).importFromUrl(url),
            ),
    );
  }

  Future<void> _importAllCharacters(BuildContext context, WidgetRef ref) async {
    final importState = ref.read(importStateProvider);
    if (!importState.hasResults) return;

    final l10n = AppLocalizations.of(context)!;
    int successCount = 0;
    int errorCount = 0;

    for (final result in importState.results) {
      if (result.character == null) continue;

      try {
        // Add the character
        final character = await ref
            .read(characterListProvider.notifier)
            .addCharacter(result.character!);

        final embeddedRegex = parseEmbeddedRegexScripts(
          result.character!.extensions,
          characterId: character.id,
        );
        await ref
            .read(characterRegexScriptsProvider(character.id).notifier)
            .importEmbeddedScripts(embeddedRegex);

        // If the character has an embedded lorebook, create a WorldInfo for it
        if (result.character!.characterBook != null &&
            result.character!.characterBook!.entries.isNotEmpty) {
          await _importEmbeddedLorebook(
            ref,
            character.id,
            result.character!.characterBook!,
            result.character!.name,
          );
        }

        successCount++;
      } catch (e) {
        errorCount++;
      }
    }

    if (context.mounted) {
      // Show summary message
      final message = successCount > 0
          ? errorCount > 0
              ? l10n.importSummaryMixed(successCount, errorCount)
              : l10n.importSummarySuccess(successCount)
          : l10n.importSummaryFailed;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: errorCount > 0 ? Colors.orange : Colors.green,
        ),
      );

      // Clear and go back if any successful
      if (successCount > 0) {
        ref.read(importStateProvider.notifier).clear();
        context.pop();
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
      description:
          characterBook.description ?? 'Embedded lorebook from $characterName',
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
          position = WorldInfoPosition.before; // Before Character Definition
          break;
        case 1:
          position = WorldInfoPosition.after; // After Character Definition
          break;
        default:
          position = WorldInfoPosition.after;
      }

      await worldInfoRepo.addEntry(
        worldInfoId: worldInfo.id,
        keys: entry.keys,
        content: entry.content,
        secondaryKeys:
            entry.secondaryKeys.isNotEmpty ? entry.secondaryKeys : null,
        comment: entry.name.isNotEmpty ? entry.name : entry.comment,
        position: position,
        depth: 4, // Default depth
      );
    }
  }
}

class _FilePickerView extends StatefulWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback onPickFile;
  final VoidCallback onPickFromGallery;
  final ValueChanged<String> onImportUrl;

  const _FilePickerView({
    required this.isLoading,
    required this.error,
    required this.onPickFile,
    required this.onPickFromGallery,
    required this.onImportUrl,
  });

  @override
  State<_FilePickerView> createState() => _FilePickerViewState();
}

class _FilePickerViewState extends State<_FilePickerView> {
  final _urlController = TextEditingController();
  bool _showUrlInput = false;

  bool get _isMobile => Platform.isIOS || Platform.isAndroid;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _handleUrlImport() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      widget.onImportUrl(url);
    }
  }

  Future<void> _pasteAndImport() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.trim().isNotEmpty) {
      _urlController.text = data.text!.trim();
      _handleUrlImport();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Local file import section
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
                    if (widget.isLoading)
                      const CircularProgressIndicator()
                    else ...[
                      const Icon(
                        Icons.file_upload_outlined,
                        size: 64,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.selectCharacterCardFiles,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!
                            .supportedCharacterCardFormats,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                      ),
                      const SizedBox(height: 24),
                      if (_isMobile) ...[
                        ElevatedButton.icon(
                          onPressed: widget.onPickFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: Text(
                              AppLocalizations.of(context)!.chooseFromGallery),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 48),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: widget.onPickFile,
                          icon: const Icon(Icons.folder_open),
                          label:
                              Text(AppLocalizations.of(context)!.browseFiles),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(200, 48),
                          ),
                        ),
                      ] else
                        ElevatedButton.icon(
                          onPressed: widget.onPickFile,
                          icon: const Icon(Icons.folder_open),
                          label:
                              Text(AppLocalizations.of(context)!.browseFiles),
                        ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () =>
                            context.push(AppRoutes.cloudBackupSettings),
                        icon: const Icon(Icons.backup_outlined, size: 18),
                        label:
                            Text(AppLocalizations.of(context)!.importNtbBackup),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // URL import section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                    InkWell(
                      onTap: () =>
                          setState(() => _showUrlInput = !_showUrlInput),
                      child: Row(
                        children: [
                          const Icon(Icons.link,
                              size: 24, color: AppTheme.accentColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.importFromUrl,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Icon(
                            _showUrlInput
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: AppTheme.textMuted,
                          ),
                        ],
                      ),
                    ),
                    if (_showUrlInput) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .enterCharacterCardUrl,
                          hintStyle: const TextStyle(color: AppTheme.textMuted),
                          prefixIcon: const Icon(Icons.link, size: 20),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.content_paste, size: 20),
                                onPressed: _pasteAndImport,
                                tooltip: AppLocalizations.of(context)!
                                    .pasteAndImport,
                              ),
                              IconButton(
                                icon: const Icon(Icons.download, size: 20),
                                onPressed:
                                    widget.isLoading ? null : _handleUrlImport,
                                tooltip: AppLocalizations.of(context)!.import,
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _handleUrlImport(),
                        enabled: !widget.isLoading,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.supportedCommunities,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: const [
                          _CommunityChip(
                              name: 'NativeTavern',
                              url: 'https://nativetavern.com',
                              isPrimary: true),
                          _CommunityChip(
                              name: 'Chub.ai',
                              url: 'https://chub.ai/characters'),
                          _CommunityChip(
                              name: 'JanitorAI', url: 'https://janitorai.com'),
                          _CommunityChip(
                              name: 'Pygmalion', url: 'https://pygmalion.chat'),
                          _CommunityChip(
                              name: 'RisuRealm',
                              url: 'https://realm.risuai.net'),
                          _CommunityChip(
                              name: 'AICharacterCards',
                              url: 'https://aicharactercards.com'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.publicCardLinksSupported,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textMuted,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              if (widget.error != null) ...[
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
                          widget.error!,
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
          description:
              AppLocalizations.of(context)!.characterDataEmbeddedInImage,
        ),
        const SizedBox(height: 8),
        _FormatTile(
          icon: Icons.archive,
          title: AppLocalizations.of(context)!.charxArchive,
          description:
              AppLocalizations.of(context)!.zipArchiveWithCharacterData,
        ),
        const SizedBox(height: 8),
        _FormatTile(
          icon: Icons.code,
          title: AppLocalizations.of(context)!.json,
          description: AppLocalizations.of(context)!.plainCharacterCardJson,
        ),
        const SizedBox(height: 8),
        _FormatTile(
          icon: Icons.link,
          title: AppLocalizations.of(context)!.communityLinks,
          description:
              'NativeTavern, Chub.ai, JanitorAI, Pygmalion, RisuRealm, AICharacterCards',
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

class _CommunityChip extends StatelessWidget {
  final String name;
  final String url;
  final bool isPrimary;

  const _CommunityChip({
    required this.name,
    required this.url,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(
        isPrimary ? Icons.star : Icons.open_in_new,
        size: 14,
        color: isPrimary ? AppTheme.accentColor : AppTheme.textMuted,
      ),
      label: Text(
        name,
        style: TextStyle(
          fontSize: 12,
          color: isPrimary ? AppTheme.accentColor : null,
          fontWeight: isPrimary ? FontWeight.bold : null,
        ),
      ),
      side: isPrimary
          ? const BorderSide(color: AppTheme.accentColor, width: 1)
          : null,
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    );
  }
}

class _BatchImportResults extends StatelessWidget {
  final List<ImportResult> results;
  final bool isLoading;
  final int totalFiles;
  final int processedFiles;
  final VoidCallback onImportAll;

  const _BatchImportResults({
    required this.results,
    required this.isLoading,
    required this.totalFiles,
    required this.processedFiles,
    required this.onImportAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final successCount = results.where((r) => r.character != null).length;
    final errorCount = results.where((r) => r.error != null).length;
    final processingCount = results.where((r) => r.isProcessing).length;

    return Column(
      children: [
        // Progress header
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.darkCard,
          child: Column(
            children: [
              if (isLoading) ...[
                const LinearProgressIndicator(),
                const SizedBox(height: 12),
                Text(
                  l10n.processingProgress(processedFiles, totalFiles),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      icon: Icons.check_circle,
                      label: l10n.importSuccessLabel,
                      count: successCount,
                      color: Colors.green,
                    ),
                    _StatChip(
                      icon: Icons.error,
                      label: l10n.importFailureLabel,
                      count: errorCount,
                      color: Colors.red,
                    ),
                    _StatChip(
                      icon: Icons.folder,
                      label: l10n.totalLabel,
                      count: totalFiles,
                      color: AppTheme.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (successCount > 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onImportAll,
                      icon: const Icon(Icons.download),
                      label: Text(l10n.importAllCharacters(successCount)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _ImportResultCard(result: result);
            },
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textMuted,
              ),
        ),
      ],
    );
  }
}

class _ImportResultCard extends StatelessWidget {
  final ImportResult result;

  const _ImportResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status icon
            _buildStatusIcon(),
            const SizedBox(width: 16),

            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.character?.name ?? result.fileName,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (result.urlSource != null)
                    Row(
                      children: [
                        const Icon(Icons.link,
                            size: 12, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            result.fileName,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textMuted,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      result.fileName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  // Show embedded lorebook indicator
                  if (result.character?.characterBook != null &&
                      result.character!.characterBook!.entries.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.auto_stories,
                            size: 14, color: AppTheme.accentColor),
                        const SizedBox(width: 4),
                        Text(
                          l10n.entriesCount(
                            result.character!.characterBook!.entries.length,
                          ),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.accentColor,
                                  ),
                        ),
                      ],
                    ),
                  ],
                  if (result.error != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (result.isProcessing) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (result.character != null) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 32);
    } else if (result.error != null) {
      return const Icon(Icons.error, color: Colors.red, size: 32);
    } else {
      return const Icon(Icons.help_outline,
          color: AppTheme.textMuted, size: 32);
    }
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                          ),
                        ],
                        if (character.version.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Version: ${character.version}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
              title: AppLocalizations.of(context)!.description,
              content: character.description,
            ),

          // Personality
          if (character.personality.isNotEmpty)
            _ExpandableSection(
              title: AppLocalizations.of(context)!.personality,
              content: character.personality,
            ),

          // Scenario
          if (character.scenario.isNotEmpty)
            _ExpandableSection(
              title: AppLocalizations.of(context)!.scenario,
              content: character.scenario,
            ),

          // First message
          if (character.firstMessage.isNotEmpty)
            _ExpandableSection(
              title: AppLocalizations.of(context)!.firstMessage,
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
                        Icon(Icons.format_list_bulleted,
                            size: 20, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.alternateGreetingsCount(
                              character.alternateGreetings.length),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.accentColor,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...character.alternateGreetings
                        .asMap()
                        .entries
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${e.key + 1}. ${e.value.length > 100 ? '${e.value.substring(0, 100)}...' : e.value}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.textMuted,
                                    ),
                              ),
                            )),
                  ],
                ),
              ),
            ),

          // Embedded lorebook
          if (character.characterBook != null &&
              character.characterBook!.entries.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_stories,
                            size: 20, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.embeddedLorebookEntries(
                              character.characterBook!.entries.length),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
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
                      '${AppLocalizations.of(context)!.keywords}: ${character.characterBook!.entries.expand((e) => e.keys).take(10).join(", ")}${character.characterBook!.entries.expand((e) => e.keys).length > 10 ? "..." : ""}',
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
              title: AppLocalizations.of(context)!.exampleMessages,
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
