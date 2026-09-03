import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/chat_background.dart';
import 'package:native_tavern/data/models/live2d.dart';
import 'package:native_tavern/data/models/rpg/rpg.dart';
import 'package:native_tavern/core/flags/rpg_product_ui.dart';
import 'package:native_tavern/presentation/widgets/export_destination_sheet.dart';
import 'package:native_tavern/domain/services/chat_export_service.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/domain/services/markdown_hotkey_service.dart';
import 'package:native_tavern/domain/services/rpg_scenario_package_service.dart';
import 'package:native_tavern/domain/services/slash_command_service.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/controllers/chat_tts_autoplay_controller.dart';
import 'package:native_tavern/presentation/providers/bookmark_providers.dart';
import 'package:native_tavern/presentation/providers/background_providers.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/providers/chat_extension_providers.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/quick_reply_providers.dart';
import 'package:native_tavern/presentation/providers/rpg_chat_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/story_providers.dart';
import 'package:native_tavern/presentation/providers/tts_providers.dart';
import 'package:native_tavern/presentation/providers/world_info_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/screens/ai_config/ai_config_screen.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/chat/author_note_dialog.dart';
import 'package:native_tavern/presentation/widgets/chat/bookmark_dialog.dart';
import 'package:native_tavern/presentation/widgets/chat/data_bank_citation_preview.dart';
import 'package:native_tavern/presentation/widgets/chat/chat_background_widget.dart';
import 'package:native_tavern/presentation/widgets/chat/chat_voice_input_button.dart';
import 'package:native_tavern/presentation/widgets/chat/message_content_widget.dart';
import 'package:native_tavern/presentation/widgets/chat/memory_context_usage_sheet.dart';
import 'package:native_tavern/presentation/widgets/chat/quick_reply_bar.dart';
import 'package:native_tavern/presentation/widgets/common/adaptive_popup_menu.dart';
import 'package:native_tavern/presentation/widgets/play/ai_play_feature_gate.dart';
import 'package:native_tavern/presentation/widgets/chat/markdown_input_field.dart';
import 'package:native_tavern/presentation/widgets/chat/reasoning_widget.dart';
import 'package:native_tavern/presentation/widgets/chat/slash_command_suggestions.dart';
import 'package:native_tavern/presentation/widgets/chat/context_usage_indicator.dart';
import 'package:native_tavern/presentation/providers/context_usage_providers.dart';
import 'package:native_tavern/presentation/providers/image_gen_providers.dart';
import 'package:native_tavern/presentation/widgets/chat/image_generation_dialog.dart';
import 'package:native_tavern/presentation/widgets/common/character_avatar_image.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/presentation/widgets/chat/visual_novel_message_view.dart';
import 'package:native_tavern/presentation/widgets/chat/tts_playback_controls.dart';
import 'package:native_tavern/presentation/widgets/chat/tool_activity_panel.dart';
import 'package:native_tavern/presentation/widgets/chat/sprite_display.dart';
import 'package:native_tavern/presentation/widgets/live2d/live2d_character_view.dart';
import 'package:native_tavern/presentation/widgets/live2d/live2d_stage_gestures.dart';
import 'package:native_tavern/presentation/widgets/rpg/rpg_game_panel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../widgets/chat/swipe_picker_sheet.dart';

/// Provider for chat export service
final chatExportServiceProvider = Provider<ChatExportService>((ref) {
  return ChatExportService();
});

/// Chat screen for conversations
class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String? initialMessageId;
  final String? initialDraft;

  const ChatScreen({
    super.key,
    required this.chatId,
    this.initialMessageId,
    this.initialDraft,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  static final Object _importRpg = Object();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showSlashSuggestions = false;
  bool _showInputMenu = false;
  final LayerLink _inputMenuLayerLink = LayerLink();
  final List<ChatAttachment> _pendingAttachments = [];
  final ImagePicker _imagePicker = ImagePicker();
  final ChatTTSAutoPlayController _ttsAutoPlayController =
      ChatTTSAutoPlayController();
  final Live2DCharacterController _live2DController =
      Live2DCharacterController();
  late final TTSStopAction _stopTts;
  final Map<String, GlobalKey<_MessageBubbleState>> _messageKeys = {};
  bool _initialMessageJumpScheduled = false;
  String? _highlightedMessageId;

  @override
  void initState() {
    super.initState();
    _stopTts = ref.read(ttsStopProvider);
    // Load chat and bookmarks when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(activeChatProvider.notifier).loadChat(widget.chatId);
      ref.read(bookmarkNotifierProvider.notifier).loadBookmarks(widget.chatId);
      ref.read(rpgChatProvider(widget.chatId).notifier).load();
      // Refresh context usage to ensure fresh calculation
      // This handles cases where world info was updated while not in chat
      refreshContextUsageProviders(ref);
      final draft = widget.initialDraft?.trim();
      if (draft != null && draft.isNotEmpty) {
        _messageController.text = draft;
      }
    });

    // Listen for text changes to show/hide slash command suggestions
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _messageController.text;
    final shouldShow = text.startsWith('/') && !text.contains(' ');
    if (shouldShow != _showSlashSuggestions) {
      setState(() => _showSlashSuggestions = shouldShow);
    }
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chatId != widget.chatId ||
        oldWidget.initialMessageId != widget.initialMessageId) {
      _initialMessageJumpScheduled = false;
      _highlightedMessageId = null;
      _messageKeys.clear();
    }
  }

  void _scheduleInitialMessageJump(List<ChatMessage> messages) {
    final targetId = widget.initialMessageId;
    if (_initialMessageJumpScheduled || targetId == null || messages.isEmpty) {
      return;
    }
    final actualIndex = messages.indexWhere(
      (message) => message.id == targetId,
    );
    if (actualIndex < 0) return;
    _initialMessageJumpScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !_scrollController.hasClients) return;
      final reversedIndex = messages.length - 1 - actualIndex;
      final denominator = math.max(1, messages.length - 1);
      final estimatedOffset = _scrollController.position.maxScrollExtent *
          reversedIndex /
          denominator;
      _scrollController.jumpTo(
        estimatedOffset.clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        ),
      );

      for (var attempt = 0; attempt < 4 && mounted; attempt++) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
        final targetContext = _messageKeys[targetId]?.currentContext;
        if (targetContext == null || !targetContext.mounted) continue;
        await Scrollable.ensureVisible(
          targetContext,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        if (!mounted) return;
        setState(() => _highlightedMessageId = targetId);
        Future<void>.delayed(const Duration(seconds: 2), () {
          if (mounted && _highlightedMessageId == targetId) {
            setState(() => _highlightedMessageId = null);
          }
        });
        return;
      }
    });
  }

  void _setInputMenuVisible(bool visible) {
    if (_showInputMenu == visible) return;
    setState(() => _showInputMenu = visible);
  }

  Future<void> _saveLive2DTransform(
    String characterId,
    Live2DStageTransform transform,
  ) async {
    try {
      await ref.read(activeChatProvider.notifier).updateLive2DStageTransform(
            scale: transform.scale,
            offsetX: transform.offsetX,
            offsetY: transform.offsetY,
          );
      ref.invalidate(characterDetailProvider(characterId));
    } catch (error) {
      if (mounted) _showSnackBar(error.toString());
    }
  }

  @override
  void dispose() {
    unawaited(_stopTts(ownerId: widget.chatId));
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Scroll to bottom with animation (for new messages)
  /// With reverse: true ListView, position 0 is the bottom (newest messages)
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0, // With reverse: true, position 0 is the bottom
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Scroll to bottom immediately without animation (for initial load)
  /// With reverse: true ListView, position 0 is the bottom (newest messages)
  void _scrollToBottomImmediate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          0,
        ); // With reverse: true, position 0 is the bottom
      }
    });
  }

  /// Check if API is properly configured
  bool _isApiConfigured(LLMConfig config) {
    // Local providers (Ollama, LM Studio, KoboldCpp) don't need API key
    if (config.provider.isLocalServer) {
      return config.apiUrl.isNotEmpty;
    }
    // Cloud providers need API key
    return config.apiKey.isNotEmpty && config.apiUrl.isNotEmpty;
  }

  /// Show dialog to guide user to configure API
  void _showApiConfigurationDialog() {
    final parentContext = context;
    final l10n = AppLocalizations.of(context);
    final hideRestricted = RegionService.hidesRestrictedAiProviders(
      isChinaRegion: ref.read(isChinaRegionProvider).valueOrNull ?? false,
      languageCode: Localizations.localeOf(context).languageCode,
    );
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.settings, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(l10n.apiNotConfigured),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.apiNotConfiguredMessage),
            const SizedBox(height: 16),
            Text(
              l10n.supportedProviders,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('• ${l10n.claude} (Anthropic)'),
            Text('• ${l10n.openRouter}'),
            Text('• ${l10n.gemini} (Google)'),
            if (!hideRestricted) Text('• ${l10n.xai}'),
            Text('• ${l10n.ollama} (${l10n.local})'),
            Text('• ${l10n.lmStudio} (${l10n.local})'),
            Text('• ${l10n.koboldCpp} (${l10n.local})'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.later),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Use go instead of push because /ai-config is inside ShellRoute
              parentContext.go('/ai-config');
            },
            icon: const Icon(Icons.settings),
            label: Text(l10n.configureNow),
          ),
        ],
      ),
    );
  }

  /// Show model selector dialog
  void _showModelSelector() async {
    final l10n = AppLocalizations.of(context);
    final llmConfig = ref.read(llmConfigProvider);
    final llmService = ref.read(llmServiceProvider);

    // Show loading dialog while fetching models
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.loadingModels),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Fetch available models
      final models = await llmService.getAvailableModels(llmConfig);

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (models.isEmpty) {
        _showSnackBar(l10n.noModelsAvailable);
        return;
      }

      // Show model selection dialog
      final selectedModel = await showDialog<String>(
        context: context,
        builder: (context) => _ModelSelectorDialog(
          models: models,
          currentModel: llmConfig.model,
          providerName: llmConfig.provider.name,
        ),
      );

      if (selectedModel != null && selectedModel != llmConfig.model) {
        ref.read(llmConfigProvider.notifier).updateModel(selectedModel);
        _showSnackBar(l10n.modelChangedTo(selectedModel));
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showSnackBar(l10n.failedToLoadModels(e.toString()));
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    final hasAttachments = _pendingAttachments.isNotEmpty;

    // Allow sending if there's content OR attachments
    if (content.isEmpty && !hasAttachments) return;

    // Check if it's a slash command (only if no attachments)
    if (content.startsWith('/') && !hasAttachments) {
      await _handleSlashCommand(content);
      return;
    }

    final config = ref.read(llmConfigProvider);

    // Check if API is configured
    if (!_isApiConfigured(config)) {
      _showApiConfigurationDialog();
      return;
    }

    // Capture attachments before clearing
    final attachments = List<ChatAttachment>.from(_pendingAttachments);

    _messageController.clear();
    setState(() {
      _showSlashSuggestions = false;
      _pendingAttachments.clear();
    });

    // Hide keyboard on mobile platforms
    _focusNode.unfocus();

    await ref
        .read(activeChatProvider.notifier)
        .sendMessage(content, config, attachments: attachments);
    _scrollToBottom();
  }

  Future<void> _toggleRpgMode() async {
    final controller = ref.read(rpgChatProvider(widget.chatId).notifier);
    final rpgState = ref.read(rpgChatProvider(widget.chatId));
    try {
      if (rpgState.enabled) {
        await controller.setEnabled(false);
      } else if (rpgState.hasSession) {
        await controller.setEnabled(true);
      } else {
        await _showRpgScenarioPicker();
      }
    } catch (error) {
      if (mounted) _showSnackBar(error.toString());
    }
  }

  Future<void> _showRpgScenarioPicker() async {
    final controller = ref.read(rpgChatProvider(widget.chatId).notifier);
    final scenarios = await controller.listScenarios();
    if (!mounted) return;
    final selected = await showModalBottomSheet<Object>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).chooseRpgScenario,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext, _importRpg),
                      icon: const Icon(Icons.file_open_outlined),
                      tooltip: AppLocalizations.of(context).importScenario,
                    ),
                  ],
                ),
              ),
              if (scenarios.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    AppLocalizations.of(context).noSavedScenarios,
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: scenarios.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final scenario = scenarios[index];
                      return ListTile(
                        leading: const Icon(Icons.sports_esports_outlined),
                        title: Text(scenario.metadata.name),
                        subtitle: Text(
                          '${scenario.metadata.id} · ${scenario.metadata.version}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => Navigator.pop(sheetContext, scenario),
                      );
                    },
                  ),
                ),
              ListTile(
                key: const Key('rpg-import-scenario'),
                leading: const Icon(Icons.file_open_outlined),
                title:
                    Text(AppLocalizations.of(context).rpgImportScenarioPackage),
                onTap: () => Navigator.pop(sheetContext, _importRpg),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected is RpgScenario) {
      await controller.enable(selected);
    } else if (selected == _importRpg) {
      await _importRpgScenario();
    }
  }

  Future<void> _importRpgScenario() async {
    final selection = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: RpgScenarioPackageService.supportedExtensions,
      withData: true,
    );
    if (selection == null || selection.files.isEmpty) return;
    final file = selection.files.single;
    final bytes = file.bytes ??
        (file.path == null ? null : await File(file.path!).readAsBytes());
    if (bytes == null) {
      throw StateError(
        AppLocalizations.of(context).rpgSelectedScenarioUnreadable,
      );
    }
    final result = await const RpgScenarioPackageService().importBytesAsync(
      bytes,
      fileName: file.name,
    );
    if (!result.isValid) {
      throw StateError(
          result.issues.map((issue) => issue.toString()).join('\n'));
    }
    await ref
        .read(rpgChatProvider(widget.chatId).notifier)
        .enable(result.scenario!);
  }

  Future<void> _handleSlashCommand(String input) async {
    final slashService = ref.read(slashCommandServiceProvider);
    final result = slashService.parse(input);

    if (!result.isCommand) {
      // Not a command, send as regular message
      final config = ref.read(llmConfigProvider);
      if (!_isApiConfigured(config)) {
        _showApiConfigurationDialog();
        return;
      }
      _messageController.clear();
      setState(() => _showSlashSuggestions = false);

      // Hide keyboard on mobile platforms
      _focusNode.unfocus();

      await ref.read(activeChatProvider.notifier).sendMessage(input, config);
      _scrollToBottom();
      return;
    }

    if (result.error != null) {
      _showCommandError(result.error!);
      return;
    }

    final command = result.command!;
    final argument = result.argument;

    _messageController.clear();
    setState(() => _showSlashSuggestions = false);

    // Hide keyboard on mobile platforms
    _focusNode.unfocus();

    await _executeCommand(command, argument);
  }

  Future<void> _executeCommand(SlashCommand command, String? argument) async {
    final l10n = AppLocalizations.of(context);
    final config = ref.read(llmConfigProvider);
    final chatNotifier = ref.read(activeChatProvider.notifier);
    final chatState = ref.read(activeChatProvider);

    switch (command.name) {
      case 'continue':
        if (!_isApiConfigured(config)) {
          _showApiConfigurationDialog();
          return;
        }
        await chatNotifier.continueGeneration(config);
        _scrollToBottom();
        break;

      case 'regenerate':
        if (!_isApiConfigured(config)) {
          _showApiConfigurationDialog();
          return;
        }
        await chatNotifier.regenerateLastMessage(config);
        _scrollToBottom();
        break;

      case 'swipe':
        _handleSwipeCommand(argument);
        break;

      case 'persona':
        context.go('/personas');
        break;

      case 'sys':
        if (argument != null && argument.isNotEmpty) {
          // Send as system/narrator message
          _showSystemMessage(argument);
        }
        break;

      case 'bg':
        context.push(AppRoutes.backgroundSettings);
        break;

      case 'impersonate':
        await _handleImpersonate();
        break;

      case 'imagine':
        await _handleImagineCommand(argument);
        break;

      case 'delswipe':
        if (chatState.messages.isNotEmpty) {
          final lastMessage = chatState.messages.last;
          if (lastMessage.swipes.length > 1) {
            await chatNotifier.deleteSwipe(
              lastMessage.id,
              lastMessage.currentSwipeIndex,
            );
            if (mounted) {
              _showSnackBar(AppLocalizations.of(context)!.swipeDeleted);
            }
          } else {
            _showSnackBar(AppLocalizations.of(context)!.noAlternateSwipes);
          }
        }
        break;

      case 'help':
        _showHelpDialog(argument);
        break;

      case 'clear':
        _showClearConfirmation();
        break;

      case 'edit':
        if (argument != null &&
            argument.isNotEmpty &&
            chatState.messages.isNotEmpty) {
          final lastMessage = chatState.messages.last;
          await chatNotifier.editMessage(lastMessage.id, argument);
        }
        break;

      case 'delete':
        if (chatState.messages.isNotEmpty) {
          final count = int.tryParse(argument ?? '1') ?? 1;
          for (var i = 0; i < count && chatState.messages.isNotEmpty; i++) {
            final lastMessage = ref.read(activeChatProvider).messages.last;
            await chatNotifier.deleteMessage(lastMessage.id);
          }
        }
        break;

      case 'bookmark':
        if (chatState.messages.isNotEmpty) {
          final lastMessage = chatState.messages.last;
          final lastIndex = chatState.messages.length - 1;
          _showCreateBookmarkDialog(lastMessage.id, lastIndex);
        }
        break;

      case 'note':
        if (argument != null && argument.isNotEmpty) {
          await chatNotifier.updateAuthorNoteSettings(
            chatId: widget.chatId,
            content: argument,
            enabled: true,
          );
          _showSnackBar(l10n.authorsNoteUpdated);
        } else {
          showAuthorNoteDialog(context, widget.chatId);
        }
        break;
    }
  }

  Future<void> _handleImagineCommand(String? argument) async {
    final l10n = AppLocalizations.of(context);
    final settings = ref.read(imageGenSettingsProvider);
    if (!settings.enabled) {
      _showSnackBar('${l10n.imageGeneration}: ${l10n.configureNow}');
      return;
    }

    final request = ref.read(parseImagineCommandProvider)(
      '/imagine ${argument ?? ''}',
    );
    if (request == null) {
      _showCommandError(SlashCommands.imagine.usage);
      return;
    }

    _showSnackBar(l10n.imageGeneration);
    final result =
        await ref.read(imageGenStateProvider.notifier).generate(request);
    if (!mounted) return;
    if (result == null || result.images.isEmpty) {
      final error = ref.read(imageGenStateProvider).error;
      _showCommandError(error ?? l10n.noImageGenerated);
      return;
    }

    try {
      final attachments = await _saveGeneratedImages(result);
      await ref.read(activeChatProvider.notifier).addLocalMessage(
            role: MessageRole.user,
            content: request.prompt,
            attachments: attachments,
          );
      _showSnackBar('${l10n.generationComplete} (${attachments.length})');
      _scrollToBottom();
    } catch (error) {
      _showCommandError(l10n.failedToSaveImage('$error'));
    }
  }

  Future<List<ChatAttachment>> _saveGeneratedImages(
    ImageGenResult result,
  ) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDocDir.path, 'chat_images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final attachments = <ChatAttachment>[];
    for (final imageBytes in result.images) {
      final imageId = const Uuid().v4();
      final fileName = '$imageId.${result.format}';
      final filePath = p.join(imagesDir.path, fileName);
      await File(filePath).writeAsBytes(imageBytes);
      attachments.add(
        ChatAttachment(
          id: imageId,
          path: filePath,
          mimeType: 'image/${result.format}',
          sizeBytes: imageBytes.length,
        ),
      );
    }
    return attachments;
  }

  void _handleSwipeCommand(String? argument) {
    final l10n = AppLocalizations.of(context);
    final chatState = ref.read(activeChatProvider);
    if (chatState.messages.isEmpty) return;

    final lastMessage = chatState.messages.last;
    if (lastMessage.swipes.length <= 1) {
      _showSnackBar(l10n.noSwipesAvailable);
      return;
    }

    int newIndex = lastMessage.currentSwipeIndex;

    if (argument == null || argument.isEmpty || argument == 'right') {
      newIndex = (newIndex + 1) % lastMessage.swipes.length;
    } else if (argument == 'left') {
      newIndex = (newIndex - 1 + lastMessage.swipes.length) %
          lastMessage.swipes.length;
    } else {
      final parsed = int.tryParse(argument);
      if (parsed != null &&
          parsed >= 1 &&
          parsed <= lastMessage.swipes.length) {
        newIndex = parsed - 1;
      }
    }

    ref
        .read(activeChatProvider.notifier)
        .swipeMessage(lastMessage.id, newIndex);
  }

  void _showSystemMessage(String content) {
    final l10n = AppLocalizations.of(context);
    // For now, just show a snackbar. In the future, this could inject a system message
    _showSnackBar('${l10n.system}: $content');
  }

  void _showHelpDialog(String? commandName) {
    if (commandName != null && commandName.isNotEmpty) {
      final slashService = ref.read(slashCommandServiceProvider);
      final l10n = AppLocalizations.of(context);
      final help = slashService.getCommandHelp(commandName);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('/$commandName'),
          content: Text(help),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.close),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const SlashCommandHelpDialog(),
      );
    }
  }

  void _showCommandError(String error) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(l10n.commandError),
          ],
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  /// "Start Reply With" dialog: assistant prefill for this chat
  void _showStartReplyWithDialog() {
    final l10n = AppLocalizations.of(context)!;
    final chat = ref.read(activeChatProvider).chat;
    final controller = TextEditingController(text: chat?.startReplyWith ?? '');

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.startReplyWith),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.startReplyWithHint),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(activeChatProvider.notifier)
                  .updateStartReplyWith(controller.text.trim());
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  /// Impersonate: generate a user reply and put it in the input field
  Future<void> _handleImpersonate() async {
    final config = ref.read(llmConfigProvider);
    if (!_isApiConfigured(config)) {
      _showApiConfigurationDialog();
      return;
    }

    final text =
        await ref.read(activeChatProvider.notifier).impersonate(config);
    if (!mounted) return;
    if (text != null) {
      _messageController.text = text;
      _messageController.selection = TextSelection.collapsed(
        offset: text.length,
      );
    }
  }

  /// Chat lorebooks: multi-select world books active only in this chat
  void _showChatLorebooksDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, _) {
          final worldInfosAsync = ref.watch(allWorldInfosProvider);
          final chat = ref.watch(activeChatProvider).chat;
          final linked = chat?.linkedWorldInfoIds ?? const <String>[];

          return AlertDialog(
            title: Text(l10n.chatLorebooks),
            content: SizedBox(
              width: double.maxFinite,
              child: worldInfosAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('$e'),
                data: (worldInfos) {
                  if (worldInfos.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(l10n.chatLorebooksHint),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: worldInfos
                        .map(
                          (wi) => CheckboxListTile(
                            title: Text(wi.name),
                            subtitle: Text(
                              l10n.chatLorebooksHint,
                              style: const TextStyle(fontSize: 11),
                            ),
                            value: linked.contains(wi.id),
                            onChanged: (checked) {
                              final updated = List<String>.from(linked);
                              if (checked == true) {
                                updated.add(wi.id);
                              } else {
                                updated.remove(wi.id);
                              }
                              ref
                                  .read(activeChatProvider.notifier)
                                  .updateLinkedWorldBooks(updated);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.close),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _onSlashCommandSelected(SlashCommand command) {
    // Fill in the command with a space for argument
    _messageController.text = '/${command.name} ';
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
    setState(() => _showSlashSuggestions = false);
    _focusNode.requestFocus();
  }

  Future<void> _regenerateMessage() async {
    final config = ref.read(llmConfigProvider);

    // Check if API is configured
    if (!_isApiConfigured(config)) {
      _showApiConfigurationDialog();
      return;
    }

    await ref.read(ttsStopProvider)(ownerId: widget.chatId);
    await ref.read(activeChatProvider.notifier).regenerateLastMessage(config);
    _scrollToBottom();
  }

  void _handleChatTTSChange(ActiveChatState? previous, ActiveChatState next) {
    if (!mounted) return;
    final action = _ttsAutoPlayController.evaluate(
      previous: previous,
      next: next,
      settings: ref.read(ttsSettingsProvider),
    );
    switch (action.kind) {
      case ChatTTSActionKind.none:
        return;
      case ChatTTSActionKind.stop:
        unawaited(ref.read(ttsStopProvider)(ownerId: widget.chatId));
      case ChatTTSActionKind.speak:
        unawaited(
          ref.read(ttsSpeakProvider)(
            action.text!,
            characterId: action.characterId,
            ownerId: widget.chatId,
            sourceId: action.sourceId,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(rpgChatExtensionsProvider);
    final chatState = ref.watch(activeChatProvider);
    final llmConfig = ref.watch(llmConfigProvider);
    final isConfigured = _isApiConfigured(llmConfig);

    // Scroll to bottom when new messages arrive or when chat finishes loading
    ref.listen(activeChatProvider, (previous, next) {
      if (!mounted) return;
      // Scroll to bottom when:
      // 1. New messages are added during conversation
      // 2. Chat finishes loading (transitions from loading to loaded with messages)
      final messageCountChanged =
          previous?.messages.length != next.messages.length;
      final olderMessagesLoaded = previous != null &&
          next.messages.length > previous.messages.length &&
          previous.messages.isNotEmpty &&
          next.messages.last.id == previous.messages.last.id &&
          next.messages.first.id != previous.messages.first.id;
      final loadingFinished = previous?.isLoading == true &&
          next.isLoading == false &&
          next.messages.isNotEmpty;

      if ((messageCountChanged && !olderMessagesLoaded) || loadingFinished) {
        _scrollToBottomImmediate();
      }
      _handleChatTTSChange(previous, next);
    });

    return Scaffold(
      appBar: _buildAppBar(chatState),
      body: ChatBackgroundWidget(
        characterId: chatState.character?.id,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                // API not configured banner
                if (!isConfigured) _buildApiConfigBanner(),

                // Error banner
                if (chatState.error != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.withValues(alpha: 0.2),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            chatState.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            // Clear error
                          },
                        ),
                      ],
                    ),
                  ),

                // Messages list
                Expanded(
                  child: chatState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildMessagesArea(chatState),
                ),

                if (kRpgProductUiEnabled)
                  RpgGamePanel(
                    chatId: widget.chatId,
                    onDisable: _toggleRpgMode,
                  ),

                ToolActivityPanel(chatId: widget.chatId),

                // Slash command suggestions
                if (_showSlashSuggestions)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SlashCommandSuggestions(
                      input: _messageController.text,
                      onSelect: _onSlashCommandSelected,
                      onDismiss: () =>
                          setState(() => _showSlashSuggestions = false),
                    ),
                  ),

                // Input area
                _buildInputArea(chatState),
              ],
            ),
            if (_showInputMenu) _buildInputMenuOverlay(chatState),
          ],
        ),
      ),
    );
  }

  Widget _buildApiConfigBanner() {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.primaryColor.withValues(alpha: 0.15),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.apiNotConfigured,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  l10n.configureApiProvider,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            // Use go instead of push because /ai-config is inside ShellRoute
            onPressed: () => context.go('/ai-config'),
            child: Text(l10n.configure),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ActiveChatState chatState) {
    final l10n = AppLocalizations.of(context);
    final hasAuthorNote = chatState.chat?.authorNoteEnabled == true &&
        (chatState.chat?.authorNote.isNotEmpty ?? false);
    final llmConfig = ref.watch(llmConfigProvider);
    final rpgState = ref.watch(rpgChatProvider(widget.chatId));
    final hasStory = ref
            .watch(storyChaptersProvider(widget.chatId))
            .valueOrNull
            ?.isNotEmpty ==
        true;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chatState.group?.name ?? chatState.character?.name ?? l10n.chat,
            style: const TextStyle(fontSize: 16),
          ),
          // Model selector - tap to change model
          GestureDetector(
            onTap: () => _showModelSelector(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  llmConfig.model.isEmpty ? l10n.selectModel : llmConfig.model,
                  style: TextStyle(
                    fontSize: 12,
                    color: chatState.isGenerating
                        ? AppTheme.textMuted
                        : AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.expand_more,
                  size: 14,
                  color: chatState.isGenerating
                      ? AppTheme.textMuted
                      : AppTheme.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ChatTTSPlaybackControls(ownerId: widget.chatId),
        if (kRpgProductUiEnabled)
          IconButton(
            key: const Key('rpg-mode-toggle'),
            icon: Icon(
              rpgState.enabled
                  ? Icons.sports_esports
                  : Icons.sports_esports_outlined,
              color: rpgState.enabled ? AppTheme.accentColor : null,
            ),
            tooltip:
                rpgState.enabled ? l10n.rpgDisableMode : l10n.rpgEnableMode,
            onPressed: rpgState.isLoading ? null : _toggleRpgMode,
          ),
        // Author's Note button
        IconButton(
          icon: Icon(
            Icons.note_alt_outlined,
            color: hasAuthorNote ? AppTheme.accentColor : null,
          ),
          tooltip: l10n.authorsNote,
          onPressed: () => showAuthorNoteDialog(context, widget.chatId),
        ),
        // Bookmarks button
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          tooltip: l10n.bookmarks,
          onPressed: () => _showBookmarksDialog(context),
        ),
        // Live2D supplies a visual stage even when no image background is set.
        if (ref
                    .watch(effectiveBackgroundProvider(chatState.character?.id))
                    .valueOrNull
                    ?.type ==
                BackgroundType.image ||
            chatState.character?.assets?.live2d?.enabled == true)
          IconButton(
            icon: Icon(
              ref.watch(appSettingsProvider.select((s) => s.chatLayoutMode)) ==
                      'bubble'
                  ? Icons.auto_stories // Novel mode icon
                  : Icons.chat_bubble, // Bubble mode icon
            ),
            tooltip: l10n.switchLayout,
            onPressed: () {
              final currentMode = ref.read(appSettingsProvider).chatLayoutMode;
              final newMode =
                  currentMode == 'bubble' ? 'visualNovel' : 'bubble';
              ref
                  .read(appSettingsProvider.notifier)
                  .updateChatLayoutMode(newMode);
            },
          ),
        if (chatState.messages.isNotEmpty &&
            chatState.messages.last.role == MessageRole.assistant &&
            !chatState.isGenerating)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.regenerate,
            onPressed: _regenerateMessage,
          ),
        AdaptivePopupMenuButton<String>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: chatState.isGroupChat ? 'group' : 'character',
              child: ListTile(
                leading: Icon(
                  chatState.isGroupChat ? Icons.groups : Icons.person,
                ),
                title: Text(
                  chatState.isGroupChat ? l10n.editGroup : l10n.viewCharacter,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            if (chatState.character != null)
              const PopupMenuItem(
                value: 'live2d',
                child: ListTile(
                  leading: Icon(Icons.animation),
                  title: Text('Live2D'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            PopupMenuItem(
              value: 'author_note',
              child: ListTile(
                leading: Icon(
                  Icons.note_alt,
                  color: hasAuthorNote ? AppTheme.accentColor : null,
                ),
                title: Text(l10n.authorsNote),
                subtitle: Text(
                  hasAuthorNote ? l10n.enabled : l10n.disabled,
                  style: TextStyle(
                    color: hasAuthorNote
                        ? AppTheme.accentColor
                        : AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'start_reply_with',
              child: ListTile(
                leading: Icon(
                  Icons.format_quote,
                  color: (ref
                              .read(activeChatProvider)
                              .chat
                              ?.startReplyWith
                              .isNotEmpty ??
                          false)
                      ? AppTheme.accentColor
                      : null,
                ),
                title: Text(l10n.startReplyWith),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'impersonate',
              child: ListTile(
                leading: const Icon(Icons.theater_comedy),
                title: Text(l10n.impersonate),
                subtitle: Text(
                  l10n.impersonateHint,
                  style: const TextStyle(fontSize: 12),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              key: const Key('moments-in-chat-menu'),
              value: 'moments_in_chat',
              child: ListTile(
                leading: Icon(
                  Icons.dynamic_feed_outlined,
                  color: chatState.chat?.momentsInChat == true
                      ? AppTheme.accentColor
                      : null,
                ),
                title: Text(l10n.momentsInChat),
                subtitle: Text(
                  chatState.chat?.momentsInChat == true
                      ? l10n.enabled
                      : l10n.disabled,
                  style: TextStyle(
                    color: chatState.chat?.momentsInChat == true
                        ? AppTheme.accentColor
                        : AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'chat_lorebooks',
              child: ListTile(
                leading: Icon(
                  Icons.public,
                  color: (ref
                              .read(activeChatProvider)
                              .chat
                              ?.linkedWorldInfoIds
                              .isNotEmpty ??
                          false)
                      ? AppTheme.accentColor
                      : null,
                ),
                title: Text(l10n.chatLorebooks),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'bookmarks',
              child: ListTile(
                leading: const Icon(
                  Icons.bookmark,
                  color: AppTheme.accentColor,
                ),
                title: Text(l10n.bookmarks),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            if (hasStory)
              PopupMenuItem(
                value: 'story',
                child: ListTile(
                  leading: const Icon(Icons.auto_stories_outlined),
                  title: Text(l10n.story),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            PopupMenuItem(
              key: const Key('memory-usage-menu'),
              value: 'memory_usage',
              child: ListTile(
                leading: const Icon(Icons.psychology_outlined),
                title: Text(l10n.memoryUsed),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: const Icon(Icons.upload),
                title: Text(l10n.exportChat),
                subtitle: Text(l10n.saveAsJsonl),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'import',
              child: ListTile(
                leading: const Icon(Icons.download),
                title: Text(l10n.importChat),
                subtitle: Text(l10n.chooseFile),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'clear',
              child: ListTile(
                leading: const Icon(Icons.delete_sweep, color: Colors.orange),
                title: Text(l10n.clearMessages),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) async {
            switch (value) {
              case 'character':
                final characterId = chatState.character?.id;
                if (characterId != null) {
                  context.push('/characters/$characterId');
                }
                break;
              case 'group':
                final groupId = chatState.group?.id;
                if (groupId != null) {
                  context.push('/groups/$groupId');
                }
                break;
              case 'author_note':
                showAuthorNoteDialog(context, widget.chatId);
                break;
              case 'live2d':
                final characterId = chatState.character?.id;
                if (characterId != null) {
                  context.push('/characters/$characterId/live2d');
                }
                break;
              case 'start_reply_with':
                _showStartReplyWithDialog();
                break;
              case 'impersonate':
                _handleImpersonate();
                break;
              case 'moments_in_chat':
                unawaited(
                  ref.read(activeChatProvider.notifier).updateMomentsInChat(
                        chatState.chat?.momentsInChat != true,
                      ),
                );
                break;
              case 'chat_lorebooks':
                _showChatLorebooksDialog();
                break;
              case 'bookmarks':
                _showBookmarksDialog(context);
                break;
              case 'story':
                final enabled = await ensureAiPlayFeatureEnabled(
                  context,
                  ref,
                  AiPlayFeature.story,
                );
                if (enabled && mounted) {
                  context.push(
                    Uri(
                      path: AppRoutes.playStory,
                      queryParameters: {'chat': widget.chatId},
                    ).toString(),
                  );
                }
                break;
              case 'memory_usage':
                _showMemoryUsage();
                break;
              case 'export':
                _showExportDialog();
                break;
              case 'import':
                _showImportDialog();
                break;
              case 'clear':
                _showClearConfirmation();
                break;
            }
          },
        ),
      ],
    );
  }

  void _showMemoryUsage() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => MemoryContextUsageSheet(chatId: widget.chatId),
    );
  }

  Widget _buildEmptyState(ActiveChatState chatState) {
    final l10n = AppLocalizations.of(context);
    final character = chatState.character;
    final group = chatState.group;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (group != null)
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.groups, size: 50),
            )
          else if (character?.assets?.avatarPath != null)
            CharacterAvatarCircle(
              imagePath: character!.assets!.avatarPath!,
              radius: 50,
              errorBuilder: (_, __, ___) => const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            )
          else
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 16),
          Text(
            group?.name ?? character?.name ?? l10n.chat,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.startConversation,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea(ActiveChatState chatState) {
    final layoutMode = ref.watch(
      appSettingsProvider.select((s) => s.chatLayoutMode),
    );
    final backgroundAsync = ref.watch(
      effectiveBackgroundProvider(chatState.character?.id),
    );
    final background = backgroundAsync.valueOrNull ?? ChatBackground.none;
    final hasBackground = background.type == BackgroundType.image;
    final hasLive2D = chatState.character?.assets?.live2d?.enabled == true;

    if (chatState.messages.isEmpty) {
      if (!hasLive2D) return _buildEmptyState(chatState);
      return Live2DBackgroundTapRegion(
        onTap: _handleLive2DBackgroundTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: _buildLive2DStage(chatState, interactive: false),
              ),
            ),
            _buildEmptyState(chatState),
          ],
        ),
      );
    }

    if (widget.initialMessageId != null) {
      return _buildMessageList(chatState);
    }

    if (layoutMode == 'visualNovel' && (hasBackground || hasLive2D)) {
      return _buildVisualNovelView(chatState);
    }

    if (hasLive2D) {
      final character = chatState.character!;
      final live2d = character.assets!.live2d!;
      return Live2DTwoFingerGestureRegion(
        initialTransform: Live2DStageTransform.constrained(
          scale: live2d.scale,
          offsetX: live2d.offsetX,
          offsetY: live2d.offsetY,
        ),
        onTransformEnd: (transform) {
          unawaited(_saveLive2DTransform(character.id, transform));
        },
        builder: (context, transform) => Live2DBackgroundTapRegion(
          onTap: _handleLive2DBackgroundTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: _buildLive2DStage(
                    chatState,
                    configOverride: live2d.copyWith(
                      scale: transform.scale,
                      offsetX: transform.offsetX,
                      offsetY: transform.offsetY,
                    ),
                    interactive: false,
                    persistTransform: false,
                  ),
                ),
              ),
              _buildMessageList(chatState),
            ],
          ),
        ),
      );
    }

    return _buildMessageList(chatState);
  }

  Widget _buildVisualNovelView(ActiveChatState chatState) {
    final character = chatState.character;
    final live2d = character?.assets?.live2d;

    Widget buildContent(Live2DConfig? configOverride) {
      return Live2DBackgroundTapRegion(
        onTap: _handleLive2DBackgroundTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (live2d?.enabled == true)
              Positioned.fill(
                child: IgnorePointer(
                  child: _buildLive2DStage(
                    chatState,
                    configOverride: configOverride,
                    interactive: false,
                    persistTransform: false,
                  ),
                ),
              ),
            Column(
              children: [
                const Expanded(child: SizedBox.shrink()),
                VisualNovelMessageView(
                  messages: chatState.messages,
                  character: chatState.character,
                  characterForMessage: chatState.characterForMessage,
                  isGenerating: chatState.isGenerating,
                  onLongPress: (message) => _showMessageOptionsForVisualNovel(
                    context,
                    message,
                    chatState,
                  ),
                  onSwipe: (swipeIndex, messageId) {
                    ref
                        .read(activeChatProvider.notifier)
                        .swipeMessage(messageId, swipeIndex);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (character == null || live2d?.enabled != true) {
      return buildContent(null);
    }

    return Live2DTwoFingerGestureRegion(
      initialTransform: Live2DStageTransform.constrained(
        scale: live2d!.scale,
        offsetX: live2d.offsetX,
        offsetY: live2d.offsetY,
      ),
      onTransformEnd: (transform) {
        unawaited(_saveLive2DTransform(character.id, transform));
      },
      builder: (context, transform) => buildContent(
        live2d.copyWith(
          scale: transform.scale,
          offsetX: transform.offsetX,
          offsetY: transform.offsetY,
        ),
      ),
    );
  }

  void _handleLive2DBackgroundTap(Offset position) {
    unawaited(
      _live2DController.handleTapAt(position).then((played) {
        debugPrint(
          '[Live2D] Chat tap at $position: '
          'attached=${_live2DController.isAttached}, '
          'ready=${_live2DController.isReady}, played=$played',
        );
      }),
    );
  }

  Widget _buildLive2DStage(
    ActiveChatState chatState, {
    Live2DConfig? configOverride,
    bool interactive = true,
    bool persistTransform = true,
  }) {
    final character = chatState.character;
    final live2d = configOverride ?? character?.assets?.live2d;
    if (character == null || live2d?.enabled != true) {
      return const SizedBox.shrink();
    }

    ChatMessage? latestAssistantMessage;
    for (final message in chatState.messages.reversed) {
      if (message.role == MessageRole.assistant) {
        latestAssistantMessage = message;
        break;
      }
    }

    return Consumer(
      builder: (context, ttsRef, _) {
        final ttsEnabled = ttsRef.watch(
          ttsSettingsProvider.select((settings) => settings.enabled),
        );
        final playback = ttsRef.watch(ttsPlaybackStateProvider);
        final matchesStage = playback.ownerId == widget.chatId &&
            (playback.characterId == null ||
                playback.characterId == character.id);
        final stagePlayback = !ttsEnabled
            ? null
            : matchesStage
                ? playback
                : TTSPlaybackState(sequence: playback.sequence);

        return Live2DCharacterView(
          config: live2d!,
          controller: _live2DController,
          isSpeaking: chatState.isGenerating,
          responseText: latestAssistantMessage?.content ?? '',
          ttsPlayback: stagePlayback,
          interactive: interactive,
          resetOnDoubleTap: false,
          onTransformChanged: persistTransform
              ? (transform) {
                  unawaited(_saveLive2DTransform(character.id, transform));
                }
              : null,
          fallback: latestAssistantMessage == null
              ? const SizedBox.shrink()
              : Align(
                  alignment: Alignment.center,
                  child: SpriteDisplay(
                    characterId: character.id,
                    messageContent: latestAssistantMessage.content,
                    isStreaming: chatState.isGenerating,
                  ),
                ),
        );
      },
    );
  }

  void _showMessageOptionsForVisualNovel(
    BuildContext context,
    ChatMessage message,
    ActiveChatState chatState,
  ) {
    final l10n = AppLocalizations.of(context);
    final config = ref.read(llmConfigProvider);
    final isAssistant = message.role == MessageRole.assistant;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(l10n.copy),
              onTap: () {
                Navigator.pop(context);
                // Copy to clipboard
                final content = message.content;
                if (content.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: content));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(context);
                _showEditMessageDialog(message);
              },
            ),
            if (isAssistant)
              ListTile(
                leading: const Icon(Icons.volume_up_outlined),
                title: Text(l10n.readAloud),
                onTap: () {
                  Navigator.pop(context);
                  unawaited(
                    ref.read(ttsSpeakProvider)(
                      message.content,
                      characterId:
                          message.characterId ?? chatState.character?.id,
                      ownerId: widget.chatId,
                      sourceId: message.id,
                    ),
                  );
                },
              ),
            if (isAssistant)
              ListTile(
                leading: const Icon(Icons.refresh),
                title: Text(l10n.regenerate),
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(activeChatProvider.notifier)
                      .regenerateMessage(message.id, config);
                },
              ),
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: Text(l10n.continueFromHere),
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(activeChatProvider.notifier)
                    .continueFromMessage(message.id, config);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(message.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(ActiveChatState chatState) {
    if (widget.initialMessageId != null &&
        !chatState.messages
            .any((message) => message.id == widget.initialMessageId) &&
        chatState.hasOlderMessages &&
        !chatState.isLoadingOlderMessages) {
      unawaited(ref.read(activeChatProvider.notifier).loadOlderMessages());
    }
    _scheduleInitialMessageJump(chatState.messages);
    final config = ref.read(llmConfigProvider);
    final backgroundAsync = ref.watch(
      effectiveBackgroundProvider(chatState.character?.id),
    );
    final background = backgroundAsync.valueOrNull ?? ChatBackground.none;
    final hasBackground = background.type != BackgroundType.none ||
        chatState.character?.assets?.live2d?.enabled == true;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.depth != 0 ||
            notification.metrics.axis != Axis.vertical ||
            !chatState.hasOlderMessages ||
            chatState.isLoadingOlderMessages) {
          return false;
        }
        // With reverse=true, maxScrollExtent is the oldest-message end.
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 160) {
          unawaited(
            ref.read(activeChatProvider.notifier).loadOlderMessages(),
          );
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        reverse:
            true, // Build from bottom up - newest messages at bottom, always visible
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: chatState.messages.length +
            (chatState.hasOlderMessages || chatState.isLoadingOlderMessages
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index == chatState.messages.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: chatState.isLoadingOlderMessages
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          }
          // With reverse: true, we need to reverse the index to maintain correct message order
          // index 0 in reversed list = last message (newest) = should be at bottom
          final actualIndex = chatState.messages.length - 1 - index;
          final message = chatState.messages[actualIndex];
          final isLast = actualIndex == chatState.messages.length - 1;

          final layoutMode = ref.watch(
            appSettingsProvider.select((s) => s.chatLayoutMode),
          );

          return _MessageBubble(
            key: _messageKeys.putIfAbsent(
              message.id,
              () => GlobalKey<_MessageBubbleState>(),
            ),
            message: message,
            messageIndex:
                actualIndex, // Use actual index for bookmarks and other features
            chatId: widget.chatId,
            character: chatState.characterForMessage(message),
            isGenerating: chatState.generatingMessageIds.contains(message.id) ||
                (isLast &&
                    message.role == MessageRole.assistant &&
                    chatState.isGenerating &&
                    chatState.generatingMessageIds.isEmpty),
            isLast: isLast,
            hasBackground: hasBackground,
            bubbleOpacity: background.bubbleOpacity,
            layoutMode: layoutMode,
            highlighted: _highlightedMessageId == message.id,
            onSwipe: (swipeIndex) {
              ref
                  .read(activeChatProvider.notifier)
                  .swipeMessage(message.id, swipeIndex);
            },
            onDeleteSwipe: (swipeIndex) {
              return ref
                  .read(activeChatProvider.notifier)
                  .deleteSwipe(message.id, swipeIndex);
            },
            onEdit: (newContent) {
              ref
                  .read(activeChatProvider.notifier)
                  .editMessage(message.id, newContent);
            },
            onDelete: () {
              _showDeleteConfirmation(message.id);
            },
            onRegenerate: message.role == MessageRole.assistant
                ? () {
                    ref
                        .read(activeChatProvider.notifier)
                        .regenerateMessage(message.id, config);
                  }
                : null,
            onContinueFromHere: () {
              ref
                  .read(activeChatProvider.notifier)
                  .continueFromMessage(message.id, config);
            },
            onDeleteAndAfter: () {
              _showDeleteAndAfterConfirmation(message.id);
            },
            onCreateBookmark: () {
              _showCreateBookmarkDialog(message.id, actualIndex);
            },
            onGenerateImage: ref.read(imageGenSettingsProvider).enabled
                ? () {
                    _showImageGenerationDialog(message, chatState.character);
                  }
                : null,
          );
        },
      ),
    );
  }

  Future<void> _showEditMessageDialog(ChatMessage message) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: message.content);
    final updated = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.edit),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (updated != null) {
      await ref
          .read(activeChatProvider.notifier)
          .editMessage(message.id, updated);
    }
  }

  void _showBookmarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BookmarksListDialog(chatId: widget.chatId),
    );
  }

  Future<void> _openImagineFromInput(ActiveChatState chatState) async {
    final typed = _messageController.text.trim();
    final lastAssistant =
        chatState.messages.reversed.cast<ChatMessage?>().firstWhere(
              (message) => message?.role == MessageRole.assistant,
              orElse: () => null,
            );
    final result = await ImageGenerationDialog.show(
      context,
      basePrompt: typed.isNotEmpty ? typed : (lastAssistant?.content ?? ''),
      characterName: chatState.character?.name,
      mode: ImageGenMode.free,
      autoCompose: typed.isEmpty,
    );
    if (result != null && result.images.isNotEmpty && mounted) {
      await _attachGeneratedImagesToNewMessage(result);
    }
  }

  Future<void> _attachGeneratedImagesToNewMessage(ImageGenResult result) async {
    final l10n = AppLocalizations.of(context);
    try {
      final attachments = await _saveGeneratedImages(result);
      await ref.read(activeChatProvider.notifier).addLocalMessage(
            role: MessageRole.user,
            content: result.prompt,
            attachments: attachments,
          );
      _showSnackBar('${l10n.generationComplete} (${attachments.length})');
      _scrollToBottom();
    } catch (error) {
      _showCommandError(l10n.failedToSaveImage('$error'));
    }
  }

  void _showImageGenerationDialog(
    ChatMessage message,
    Character? character,
  ) async {
    final result = await ImageGenerationDialog.show(
      context,
      basePrompt: message.content,
      characterName: character?.name,
      mode: message.role == MessageRole.assistant
          ? ImageGenMode.lastMessage
          : ImageGenMode.free,
      autoCompose: message.role == MessageRole.assistant,
    );

    if (result != null && result.images.isNotEmpty && mounted) {
      final l10n = AppLocalizations.of(context);

      // Save each image to local storage and add as attachment to the message
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory(p.join(appDocDir.path, 'chat_images'));
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        for (int i = 0; i < result.images.length; i++) {
          final imageBytes = result.images[i];
          final imageId = const Uuid().v4();
          final fileName = '${imageId}.${result.format}';
          final filePath = p.join(imagesDir.path, fileName);

          // Save image to file
          final file = File(filePath);
          await file.writeAsBytes(imageBytes);

          // Create attachment
          final attachment = ChatAttachment(
            id: imageId,
            path: filePath,
            mimeType: 'image/${result.format}',
            sizeBytes: imageBytes.length,
          );

          // Add attachment to message
          await ref
              .read(activeChatProvider.notifier)
              .addAttachmentToMessage(message.id, attachment);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.imagesAdded(result.images.length),
            ),
          ),
        );
      } catch (e) {
        debugPrint('Failed to save generated image: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(content: Text(l10n.failedToSaveImage('$e'))),
        );
      }
    }
  }

  void _showCreateBookmarkDialog(String messageId, int messageIndex) async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (context) => CreateBookmarkDialog(
        chatId: widget.chatId,
        messageId: messageId,
        messageIndex: messageIndex,
      ),
    );

    if (result != null && mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.bookmarkCreated)));
    }
  }

  void _showDeleteConfirmation(String messageId) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMessage),
        content: Text(l10n.deleteMessageConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activeChatProvider.notifier).deleteMessage(messageId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showDeleteAndAfterConfirmation(String messageId) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMessages),
        content: Text(l10n.deleteMessagesConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(activeChatProvider.notifier)
                  .deleteMessageAndAfter(messageId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteAll),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplyBar(ActiveChatState chatState) {
    final quickReplyConfig = ref.watch(quickReplyConfigProvider);

    // Don't show if generating or if quick replies are disabled
    if (chatState.isGenerating || !quickReplyConfig.showQuickReplies) {
      return const SizedBox.shrink();
    }

    return QuickReplyBar(
      onQuickReply: (message, autoSend) => _handleQuickReply(message, autoSend),
    );
  }

  void _handleQuickReply(String message, bool autoSend) {
    final config = ref.read(llmConfigProvider);

    // Check if API is configured
    if (!_isApiConfigured(config)) {
      _showApiConfigurationDialog();
      return;
    }

    if (message.isEmpty) {
      // Empty message means "continue" - just generate without user message
      _focusNode.unfocus(); // Hide keyboard
      ref.read(activeChatProvider.notifier).continueGeneration(config);
      _scrollToBottom();
    } else if (autoSend) {
      // Auto-send: send the message immediately
      _focusNode.unfocus(); // Hide keyboard
      ref.read(activeChatProvider.notifier).sendMessage(message, config);
      _scrollToBottom();
    } else {
      // Fill input field
      _messageController.text = message;
      _focusNode.requestFocus();
    }
  }

  Widget _buildInputArea(ActiveChatState chatState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        border: Border(top: BorderSide(color: AppTheme.darkDivider)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pending attachments preview
            if (_pendingAttachments.isNotEmpty) _buildAttachmentsPreview(),
            // Input row with menu button
            CompositedTransformTarget(
              link: _inputMenuLayerLink,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Menu button
                  IconButton(
                    icon: Icon(
                      _showInputMenu ? Icons.close : Icons.menu,
                      size: 24,
                      color: _showInputMenu
                          ? AppTheme.primaryColor
                          : AppTheme.textMuted,
                    ),
                    onPressed: () => _setInputMenuVisible(!_showInputMenu),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Input field
                  Expanded(
                    child: MarkdownInputField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      maxLines: 5,
                      minLines: 1,
                      hintText: AppLocalizations.of(context).typeMessage,
                      onSubmitted: Platform.isIOS || Platform.isAndroid
                          ? null
                          : (_) => _sendMessage(),
                      textInputAction: Platform.isIOS || Platform.isAndroid
                          ? TextInputAction.newline
                          : TextInputAction.send,
                      showToolbar: false,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).typeMessage,
                        filled: true,
                        fillColor: AppTheme.darkBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChatVoiceInputButton(
                    controller: _messageController,
                    onAutoSend: _sendMessage,
                  ),
                  // Show stop button when generating, send button otherwise
                  if (chatState.isGenerating)
                    IconButton.filled(
                      onPressed: () => ref
                          .read(activeChatProvider.notifier)
                          .cancelGeneration(),
                      icon: const Icon(Icons.stop_circle),
                      style: IconButton.styleFrom(backgroundColor: Colors.red),
                      tooltip: AppLocalizations.of(context).stopGenerating,
                    )
                  else
                    IconButton.filled(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send),
                      tooltip: AppLocalizations.of(context).send,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputMenuOverlay(ActiveChatState chatState) {
    final quickReplyConfig = ref.watch(quickReplyConfigProvider);
    final enabledReplies = ref.watch(enabledQuickRepliesProvider);
    final showQuickReplies = quickReplyConfig.showQuickReplies &&
        enabledReplies.isNotEmpty &&
        !chatState.isGenerating;
    final width = math.max(0.0, MediaQuery.sizeOf(context).width - 32);

    return Positioned.fill(
      child: Align(
        alignment: Alignment.topLeft,
        child: CompositedTransformFollower(
          link: _inputMenuLayerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.bottomLeft,
          offset: const Offset(0, -12),
          child: SizedBox(
            width: width,
            child: Material(
              color: Colors.transparent,
              elevation: 8,
              child: _buildInputMenuPanel(showQuickReplies, chatState),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the expandable menu panel above the input field
  Widget _buildInputMenuPanel(
    bool showQuickReplies,
    ActiveChatState chatState,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Core tools
          Row(
            children: [
              // Image attachment
              _InputMenuButton(
                icon: Icons.image,
                label: AppLocalizations.of(context).attachImage,
                onTap: () {
                  _showAttachmentOptions();
                  _setInputMenuVisible(false);
                },
              ),
              const SizedBox(width: 8),
              // Markdown formatting
              _InputMenuButton(
                icon: Icons.text_format,
                label: AppLocalizations.of(context).formatting,
                onTap: () => _showFormattingMenu(),
              ),
              const SizedBox(width: 8),
              if (ref.watch(imageGenSettingsProvider).enabled)
                _InputMenuButton(
                  key: const Key('chat-input-imagine'),
                  icon: Icons.auto_awesome,
                  label: AppLocalizations.of(context).imagine,
                  onTap: () {
                    _setInputMenuVisible(false);
                    _openImagineFromInput(chatState);
                  },
                ),
              if (ref.watch(imageGenSettingsProvider).enabled)
                const SizedBox(width: 8),
              // Context usage indicator
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.darkCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 18,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(child: ContextUsageIndicator()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Row 2: Quick replies (if enabled)
          if (showQuickReplies) ...[
            const SizedBox(height: 12),
            _buildQuickRepliesInMenu(),
          ],
        ],
      ),
    );
  }

  /// Build quick replies inside the menu panel
  Widget _buildQuickRepliesInMenu() {
    final enabledReplies = ref.watch(enabledQuickRepliesProvider);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: enabledReplies
          .map(
            (reply) => InkWell(
              onTap: () {
                _handleQuickReply(reply.message, reply.autoSend);
                _setInputMenuVisible(false);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.darkCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.darkDivider),
                ),
                child: Text(
                  reply.label,
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// Show markdown formatting popup menu
  void _showFormattingMenu() {
    // Get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    // Position the menu above the input area (near the bottom of the screen)
    showMenu<MarkdownFormat>(
      context: context,
      position: RelativeRect.fromLTRB(
        16, // left padding
        screenSize.height - 350, // show above input area
        16, // right padding
        100, // bottom padding
      ),
      items: [
        _buildFormattingMenuItem(MarkdownFormat.bold, Icons.format_bold, null),
        _buildFormattingMenuItem(
          MarkdownFormat.italic,
          Icons.format_italic,
          null,
        ),
        _buildFormattingMenuItem(
          MarkdownFormat.underline,
          Icons.format_underline,
          null,
        ),
        _buildFormattingMenuItem(
          MarkdownFormat.strikethrough,
          Icons.strikethrough_s,
          null,
        ),
        const PopupMenuDivider(),
        _buildFormattingMenuItem(MarkdownFormat.inlineCode, Icons.code, null),
        _buildFormattingMenuItem(
          MarkdownFormat.codeBlock,
          Icons.integration_instructions,
          null,
        ),
        const PopupMenuDivider(),
        _buildFormattingMenuItem(MarkdownFormat.link, Icons.link, null),
        _buildFormattingMenuItem(
          MarkdownFormat.quote,
          Icons.format_quote,
          null,
        ),
        const PopupMenuDivider(),
        _buildFormattingMenuItem(
          MarkdownFormat.bulletList,
          Icons.format_list_bulleted,
          null,
        ),
        _buildFormattingMenuItem(
          MarkdownFormat.numberedList,
          Icons.format_list_numbered,
          null,
        ),
      ],
    ).then((format) {
      if (format != null) {
        _applyMarkdownFormat(format);
      }
    });
  }

  PopupMenuItem<MarkdownFormat> _buildFormattingMenuItem(
    MarkdownFormat format,
    IconData icon,
    String? shortcut,
  ) {
    return PopupMenuItem<MarkdownFormat>(
      value: format,
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 12),
          Text(format.displayName),
          if (shortcut != null) ...[
            const Spacer(),
            Text(
              shortcut,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  /// Apply markdown formatting to the input field
  void _applyMarkdownFormat(MarkdownFormat format) {
    var currentValue = _messageController.value;
    if (!currentValue.selection.isValid) {
      currentValue = currentValue.copyWith(
        selection: TextSelection.collapsed(offset: currentValue.text.length),
      );
      _messageController.value = currentValue;
    }

    final newValue = MarkdownHotkeyService.applyFormat(
      value: currentValue,
      format: format,
    );
    _messageController.value = newValue;
    _focusNode.requestFocus();
  }

  /// Build preview of pending attachments
  Widget _buildAttachmentsPreview() {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pendingAttachments.length,
        itemBuilder: (context, index) {
          final attachment = _pendingAttachments[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(attachment.path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: AppTheme.darkCard,
                      child: const Icon(
                        Icons.broken_image,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => _removeAttachment(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Check if running on desktop platform
  bool get _isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// Show attachment options (camera or gallery/files)
  void _showAttachmentOptions() {
    debugPrint('📎 _showAttachmentOptions called, isDesktop: $_isDesktop');

    // On desktop, directly open file picker
    if (_isDesktop) {
      debugPrint('📎 Opening file picker for desktop...');
      _pickImageFromFiles();
      return;
    }

    final l10n = AppLocalizations.of(context);
    // On mobile, show options sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppTheme.primaryColor,
              ),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppTheme.accentColor,
              ),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Pick image from files using FilePicker (for desktop)
  Future<void> _pickImageFromFiles() async {
    final l10n = AppLocalizations.of(context);
    debugPrint('📎 _pickImageFromFiles called');
    try {
      debugPrint('📎 Calling FilePicker.platform.pickFiles...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        dialogTitle: l10n.selectImages,
      );

      debugPrint('📎 FilePicker result: $result');

      if (result != null && result.files.isNotEmpty) {
        debugPrint('📎 Got ${result.files.length} files');
        for (final file in result.files) {
          debugPrint('📎 File: ${file.name}, path: ${file.path}');
          if (file.path != null) {
            await _addAttachmentFromPath(file.path!);
          }
        }
      } else {
        debugPrint('📎 No files selected or result is null');
      }
    } catch (e, stackTrace) {
      final l10n = AppLocalizations.of(context);
      debugPrint('📎 FilePicker error: $e');
      debugPrint('📎 Stack trace: $stackTrace');
      _showSnackBar(l10n.failedToPickImage(e.toString()));
    }
  }

  /// Pick image from gallery (for mobile)
  Future<void> _pickImageFromGallery() async {
    try {
      final images = await _imagePicker.pickMultiImage(
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      for (final image in images) {
        await _addAttachmentFromXFile(image);
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      _showSnackBar(l10n.failedToPickImage(e.toString()));
    }
  }

  /// Take photo with camera (for mobile)
  Future<void> _takePhoto() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null) {
        await _addAttachmentFromXFile(image);
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      _showSnackBar(l10n.failedToTakePhoto(e.toString()));
    }
  }

  /// Add an attachment from a file path
  Future<void> _addAttachmentFromPath(String filePath) async {
    try {
      // Copy file to app's documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(
        p.join(appDir.path, 'NativeTavern', 'attachments'),
      );
      await attachmentsDir.create(recursive: true);

      final uuid = const Uuid();
      final extension = p.extension(filePath);
      final newFileName = '${uuid.v4()}$extension';
      final newPath = p.join(attachmentsDir.path, newFileName);

      // Copy file
      final sourceFile = File(filePath);
      await sourceFile.copy(newPath);

      // Get file info
      final fileInfo = await File(newPath).stat();

      final attachment = ChatAttachment(
        id: uuid.v4(),
        path: newPath,
        mimeType: _getMimeType(extension),
        sizeBytes: fileInfo.size,
      );

      setState(() {
        _pendingAttachments.add(attachment);
      });
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      _showSnackBar(l10n.failedToAddAttachment(e.toString()));
    }
  }

  /// Add an attachment from XFile (for mobile image_picker)
  Future<void> _addAttachmentFromXFile(XFile file) async {
    try {
      // Copy file to app's documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(
        p.join(appDir.path, 'NativeTavern', 'attachments'),
      );
      await attachmentsDir.create(recursive: true);

      final uuid = const Uuid();
      final extension = p.extension(file.path);
      final newFileName = '${uuid.v4()}$extension';
      final newPath = p.join(attachmentsDir.path, newFileName);

      // Copy file
      final bytes = await file.readAsBytes();
      await File(newPath).writeAsBytes(bytes);

      // Get file info
      final fileInfo = await File(newPath).stat();

      final attachment = ChatAttachment(
        id: uuid.v4(),
        path: newPath,
        mimeType: _getMimeType(extension),
        sizeBytes: fileInfo.size,
      );

      setState(() {
        _pendingAttachments.add(attachment);
      });
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      _showSnackBar(l10n.failedToAddAttachment(e.toString()));
    }
  }

  /// Remove an attachment
  void _removeAttachment(int index) {
    setState(() {
      _pendingAttachments.removeAt(index);
    });
  }

  /// Get MIME type from file extension
  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg';
    }
  }

  void _showExportDialog() {
    final l10n = AppLocalizations.of(context);
    final chatState = ref.read(activeChatProvider);
    if (chatState.chat == null || chatState.character == null) {
      _showSnackBar(l10n.noChatToExport);
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.upload, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(l10n.exportChat),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.exportChatWith(chatState.character!.name),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.messagesCount(chatState.messages.length),
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(l10n.chooseExportFormat),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _exportChat(useJsonl: false);
            },
            child: Text(l10n.json),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _exportChat(useJsonl: true);
            },
            child: Text(l10n.jsonlStFormat),
          ),
        ],
      ),
    );
  }

  Future<void> _exportChat({bool useJsonl = true}) async {
    final chatState = ref.read(activeChatProvider);
    if (chatState.chat == null || chatState.character == null) return;

    final exportService = ref.read(chatExportServiceProvider);
    final activePersonaAsync = ref.read(activePersonaProvider);
    final userName = activePersonaAsync.valueOrNull?.name ??
        AppLocalizations.of(context).user;

    try {
      final content = useJsonl
          ? await exportService.exportToJsonl(
              chatState.chat!,
              chatState.messages,
              chatState.character!,
              userName: userName,
            )
          : await exportService.exportToJson(
              chatState.chat!,
              chatState.messages,
              chatState.character!,
              userName: userName,
            );
      final extension = useJsonl ? 'jsonl' : 'json';
      final fileName =
          '${chatState.character!.name}_${chatState.chat!.id}.$extension';
      if (!mounted) return;
      await exportTextWithDestination(
        context: context,
        fileName: fileName,
        content: content,
        subject: 'Chat with ${chatState.character!.name}',
        allowedExtensions: [extension],
        mimeType: 'application/json',
      );
    } catch (e) {
      final l10n = AppLocalizations.of(context);
      _showSnackBar(l10n.exportFailed(e.toString()));
    }
  }

  void _showImportDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.download, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(l10n.importChat),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.importChatHistory),
            const SizedBox(height: 16),
            Text(
              l10n.supportedFormats,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('• ${l10n.jsonlSillyTavernFormat}'),
            Text('• ${l10n.jsonNativeTavernFormat}'),
            const SizedBox(height: 16),
            Text(
              l10n.importNote,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _importChat();
            },
            icon: const Icon(Icons.folder_open),
            label: Text(l10n.chooseFile),
          ),
        ],
      ),
    );
  }

  Future<void> _importChat() async {
    final l10n = AppLocalizations.of(context);
    final exportService = ref.read(chatExportServiceProvider);

    try {
      final result = await exportService.importFromFile();
      if (result == null) {
        _showSnackBar(l10n.noFileSelected);
        return;
      }

      if (!mounted) return;

      bool replaceExisting = false;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.importConfirmation),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.character}: ${result.characterName}'),
                Text('${l10n.user}: ${result.userName}'),
                if (result.model != null && result.model!.isNotEmpty)
                  Text('Model: ${result.model}'),
                Text('${l10n.messages}: ${result.messages.length}'),
                Text(
                  '${l10n.date}: ${result.createDate.toString().split('.')[0]}',
                ),
                if (result.authorNote != null && result.authorNote!.isNotEmpty)
                  Text('${l10n.hasAuthorsNote}: ${l10n.yes}'),
                const Divider(height: 24),
                RadioListTile<bool>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Append to conversation'),
                  subtitle: const Text('Add messages after existing ones'),
                  value: false,
                  groupValue: replaceExisting,
                  onChanged: (val) =>
                      setDialogState(() => replaceExisting = val ?? false),
                ),
                RadioListTile<bool>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Replace all existing messages',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text(
                      'Clears current chat and loads imported session'),
                  value: true,
                  groupValue: replaceExisting,
                  onChanged: (val) =>
                      setDialogState(() => replaceExisting = val ?? true),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.import),
              ),
            ],
          ),
        ),
      );

      if (confirmed != true || !mounted) return;

      final chatState = ref.read(activeChatProvider);
      if (chatState.chat == null) {
        _showSnackBar(l10n.noActiveChat);
        return;
      }

      final chatNotifier = ref.read(activeChatProvider.notifier);
      final uuid = const Uuid();
      final importedCount = await chatNotifier.importMessages(
        result.messages.map((importedMsg) {
          return importedMsg.toChatMessage(chatState.chat!.id, uuid.v4());
        }).toList(),
        replaceExisting: replaceExisting,
      );

      // Update author's note if present
      if (result.authorNote != null && result.authorNote!.isNotEmpty) {
        await chatNotifier.updateAuthorNoteSettings(
          chatId: widget.chatId,
          content: result.authorNote,
          depth: result.authorNoteDepth,
          enabled: result.authorNoteEnabled == true ? true : null,
        );
      }

      _showSnackBar(l10n.importedMessages(importedCount));
      _scrollToBottom();
    } catch (e) {
      _showSnackBar(l10n.importFailed(e.toString()));
    }
  }

  void _showClearConfirmation() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearMessages),
        content: Text(l10n.clearMessagesConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(activeChatProvider.notifier).clearMessages();
                if (mounted) {
                  _showSnackBar(l10n.messagesCleared);
                }
              } catch (error) {
                if (mounted) {
                  _showSnackBar('${l10n.error}: $error');
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final int messageIndex;
  final String chatId;
  final Character? character;
  final bool isGenerating;
  final bool isLast;
  final bool hasBackground;
  final double bubbleOpacity;
  final String layoutMode;
  final bool highlighted;
  final void Function(int) onSwipe;
  final Future<void> Function(int)? onDeleteSwipe;
  final void Function(String) onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRegenerate;
  final VoidCallback onContinueFromHere;
  final VoidCallback onDeleteAndAfter;
  final VoidCallback onCreateBookmark;
  final VoidCallback? onGenerateImage;

  const _MessageBubble({
    super.key,
    required this.message,
    required this.messageIndex,
    required this.chatId,
    required this.character,
    required this.isGenerating,
    required this.isLast,
    this.hasBackground = false,
    this.bubbleOpacity = 0.8,
    this.layoutMode = 'bubble',
    this.highlighted = false,
    required this.onSwipe,
    this.onDeleteSwipe,
    required this.onEdit,
    required this.onDelete,
    this.onRegenerate,
    required this.onContinueFromHere,
    required this.onDeleteAndAfter,
    required this.onCreateBookmark,
    this.onGenerateImage,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.message.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == MessageRole.user;
    final hasSwipes = widget.message.swipes.length > 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[_buildAvatar(), const SizedBox(width: 8)],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  onLongPress: () => _showMessageOptions(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: _buildMessageDecoration(isUser),
                    child: _isEditing
                        ? _buildEditField()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Show image attachments if available
                              if (widget.message.hasAttachments)
                                _buildAttachments(),
                              // Show reasoning/thinking content if available
                              if (!isUser && widget.message.hasReasoning)
                                _buildReasoningSection(),
                              if (widget.isGenerating &&
                                  widget.message.content.isEmpty)
                                const _TypingIndicator()
                              else
                                MessageContentWidget(
                                  content: widget.message.content,
                                  textColor: isUser
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                  selectable: true,
                                  onLongPress: () =>
                                      _showMessageOptions(context),
                                  isStreaming: widget.isGenerating,
                                  messageId: widget.message.id,
                                ),
                              if (!isUser && !widget.isGenerating)
                                DataBankCitationPreview(
                                  message: widget.message,
                                ),
                            ],
                          ),
                  ),
                ),

                // Swipe controls
                if (hasSwipes && !widget.isGenerating)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 20),
                          onPressed: widget.message.currentSwipeIndex > 0
                              ? () => widget.onSwipe(
                                    widget.message.currentSwipeIndex - 1,
                                  )
                              : null,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        GestureDetector(
                          // Long press opens the Swipe Picker (ST 1.17+)
                          onLongPress: () => _openSwipePicker(context),
                          onTap: () => _openSwipePicker(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '${widget.message.currentSwipeIndex + 1}/${widget.message.swipes.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppTheme.textMuted),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 20),
                          onPressed: widget.message.currentSwipeIndex <
                                  widget.message.swipes.length - 1
                              ? () => widget.onSwipe(
                                    widget.message.currentSwipeIndex + 1,
                                  )
                              : null,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                if (!isUser && !widget.isGenerating)
                  ChatTTSMessageButton(
                    text: widget.message.content,
                    ownerId: widget.chatId,
                    sourceId: widget.message.id,
                    characterId:
                        widget.message.characterId ?? widget.character?.id,
                  ),
                if (isUser && !_isEditing && !widget.isGenerating)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    tooltip: AppLocalizations.of(context).edit,
                    onPressed: () {
                      _editController.text = widget.message.content;
                      setState(() => _isEditing = true);
                    },
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _openSwipePicker(BuildContext context) {
    SwipePickerSheet.show(
      context,
      message: widget.message,
      onSelect: (index) => widget.onSwipe(index),
      onDelete: (index) async {
        await widget.onDeleteSwipe?.call(index);
      },
    );
  }

  BoxDecoration _buildMessageDecoration(bool isUser) {
    final isTransparent = widget.layoutMode == 'transparent';

    if (isTransparent && widget.hasBackground) {
      // Transparent mode: very light background with blur effect
      return BoxDecoration(
        color: isUser
            ? AppTheme.accentColor.withValues(alpha: 0.35)
            : Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.highlighted
              ? Theme.of(context).colorScheme.tertiary
              : isUser
                  ? AppTheme.accentColor.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.3),
          width: widget.highlighted ? 3 : 1,
        ),
        // Glass morphism effect
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
    } else {
      // Classic bubble mode
      return BoxDecoration(
        color: isUser
            ? (widget.hasBackground
                ? AppTheme.accentColor.withValues(alpha: widget.bubbleOpacity)
                : AppTheme.accentColor)
            : (widget.hasBackground
                ? AppTheme.darkCard.withValues(alpha: widget.bubbleOpacity)
                : AppTheme.darkCard),
        borderRadius: BorderRadius.circular(16),
        border: widget.highlighted
            ? Border.all(
                color: Theme.of(context).colorScheme.tertiary,
                width: 3,
              )
            : null,
      );
    }
  }

  Widget _buildAvatar() {
    if (widget.character?.assets?.avatarPath != null) {
      return CharacterAvatarCircle(
        imagePath: widget.character!.assets!.avatarPath!,
        radius: 16,
        errorBuilder: (_, __, ___) =>
            const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
      );
    }
    return const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16));
  }

  /// Build the reasoning/thinking section for AI messages
  Widget _buildReasoningSection() {
    final l10n = AppLocalizations.of(context);
    final reasoning = widget.message.currentReasoning;
    if (reasoning == null || reasoning.isEmpty) {
      return const SizedBox.shrink();
    }

    // During streaming, show the streaming version
    if (widget.isGenerating && widget.isLast) {
      return StreamingReasoningWidget(
        reasoning: reasoning,
        isStreaming: true,
        label: l10n.thinking,
      );
    }

    // For completed messages, show the collapsible version
    return ReasoningWidget(
      reasoning: reasoning,
      initiallyExpanded: false,
      label: l10n.thinking,
    );
  }

  /// Build image attachments grid for messages
  Widget _buildAttachments() {
    final attachments = widget.message.attachments;
    if (attachments.isEmpty) return const SizedBox.shrink();

    // For single image, show larger preview
    if (attachments.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () => _showImagePreview(attachments[0]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250, maxHeight: 200),
              child: Image.file(
                File(attachments[0].path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 100,
                  color: AppTheme.darkBackground,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // For multiple images, show a grid
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: attachments.map((attachment) {
          return GestureDetector(
            onTap: () => _showImagePreview(attachment),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(attachment.path),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: AppTheme.darkBackground,
                  child: const Icon(
                    Icons.broken_image,
                    size: 20,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Show full-screen image preview
  void _showImagePreview(ChatAttachment attachment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(attachment.path),
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 200,
                      height: 200,
                      color: AppTheme.darkCard,
                      child: const Icon(
                        Icons.broken_image,
                        size: 48,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField() {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        TextField(
          controller: _editController,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => setState(() => _isEditing = false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                widget.onEdit(_editController.text);
                setState(() => _isEditing = false);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ],
    );
  }

  void _showMessageOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAssistant = widget.message.role == MessageRole.assistant;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // Copy
            ListTile(
              leading: const Icon(Icons.copy, color: AppTheme.textSecondary),
              title: Text(l10n.copy),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: widget.message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.copiedToClipboard),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),

            // Edit
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.textSecondary),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(context);
                _editController.text = widget.message.content;
                setState(() => _isEditing = true);
              },
            ),

            // Regenerate (only for assistant messages)
            if (isAssistant && widget.onRegenerate != null)
              ListTile(
                leading: const Icon(
                  Icons.refresh,
                  color: AppTheme.primaryColor,
                ),
                title: Text(l10n.regenerate),
                subtitle: Text(l10n.generateNewResponse),
                onTap: () {
                  Navigator.pop(context);
                  widget.onRegenerate!();
                },
              ),

            // Continue from here
            ListTile(
              leading: const Icon(
                Icons.play_arrow,
                color: AppTheme.accentColor,
              ),
              title: Text(l10n.continueFromHere),
              subtitle: Text(
                widget.message.role == MessageRole.user
                    ? l10n.deleteMessagesAfterAndRegenerate
                    : l10n.deleteMessagesAfterThis,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onContinueFromHere();
              },
            ),

            // Create bookmark
            ListTile(
              leading: const Icon(
                Icons.bookmark_add,
                color: AppTheme.accentColor,
              ),
              title: Text(l10n.createBookmark),
              subtitle: Text(l10n.saveAsCheckpoint),
              onTap: () {
                Navigator.pop(context);
                widget.onCreateBookmark();
              },
            ),

            // Generate image (if enabled)
            if (widget.onGenerateImage != null)
              ListTile(
                leading: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.primaryColor,
                ),
                title: Text(l10n.generateImagesUsingAi),
                onTap: () {
                  Navigator.pop(context);
                  widget.onGenerateImage!();
                },
              ),

            const Divider(),

            // Delete this message
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.orange),
              title: Text(l10n.deleteThisMessage),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete();
              },
            ),

            // Delete this and all after
            if (!widget.isLast)
              ListTile(
                leading: const Icon(Icons.delete_sweep, color: Colors.red),
                title: Text(
                  l10n.deleteThisAndAllAfter,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onDeleteAndAfter();
                },
              ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = ((_controller.value + delay) % 1.0);
            final size = 4.0 + (animationValue * 4.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Dialog for selecting a model from available models
class _ModelSelectorDialog extends StatefulWidget {
  final List<String> models;
  final String currentModel;
  final String providerName;

  const _ModelSelectorDialog({
    required this.models,
    required this.currentModel,
    required this.providerName,
  });

  @override
  State<_ModelSelectorDialog> createState() => _ModelSelectorDialogState();
}

class _ModelSelectorDialogState extends State<_ModelSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredModels = [];

  @override
  void initState() {
    super.initState();
    _filteredModels = widget.models;
    _searchController.addListener(_filterModels);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterModels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredModels = widget.models;
      } else {
        _filteredModels = widget.models
            .where((model) => model.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: AppTheme.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.smart_toy, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        l10n.selectModel,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.provider}: ${widget.providerName}',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchModels,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  filled: true,
                  fillColor: AppTheme.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Model list
            Flexible(
              child: _filteredModels.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          l10n.noModelsMatchSearch,
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredModels.length,
                      itemBuilder: (context, index) {
                        final model = _filteredModels[index];
                        final isSelected = model == widget.currentModel;

                        return ListTile(
                          leading: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isSelected
                                ? AppTheme.accentColor
                                : AppTheme.textMuted,
                            size: 20,
                          ),
                          title: Text(
                            model,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppTheme.accentColor
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: AppTheme.accentColor.withValues(
                            alpha: 0.1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onTap: () => Navigator.pop(context, model),
                        );
                      },
                    ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button widget for the input menu panel
class _InputMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _InputMenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
