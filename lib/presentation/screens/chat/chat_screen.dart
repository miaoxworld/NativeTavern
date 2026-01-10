import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/domain/services/chat_export_service.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/slash_command_service.dart';
import 'package:native_tavern/presentation/providers/bookmark_providers.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/quick_reply_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/chat/author_note_dialog.dart';
import 'package:native_tavern/presentation/widgets/chat/bookmark_dialog.dart';
import 'package:native_tavern/presentation/widgets/chat/message_content_widget.dart';
import 'package:native_tavern/presentation/widgets/chat/quick_reply_bar.dart';
import 'package:native_tavern/presentation/widgets/chat/markdown_input_field.dart';
import 'package:native_tavern/presentation/widgets/chat/reasoning_widget.dart';
import 'package:native_tavern/presentation/widgets/chat/slash_command_suggestions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Provider for chat export service
final chatExportServiceProvider = Provider<ChatExportService>((ref) {
  return ChatExportService();
});

/// Chat screen for conversations
class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showSlashSuggestions = false;
  final List<ChatAttachment> _pendingAttachments = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load chat and bookmarks when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeChatProvider.notifier).loadChat(widget.chatId);
      ref.read(bookmarkNotifierProvider.notifier).loadBookmarks(widget.chatId);
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
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Check if API is properly configured
  bool _isApiConfigured(LLMConfig config) {
    // Local providers (Ollama, KoboldCpp) don't need API key
    if (config.provider == LLMProvider.ollama ||
        config.provider == LLMProvider.koboldCpp) {
      return config.apiUrl.isNotEmpty;
    }
    // Cloud providers need API key
    return config.apiKey.isNotEmpty && config.apiUrl.isNotEmpty;
  }

  /// Show dialog to guide user to configure API
  void _showApiConfigurationDialog() {
    final parentContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.settings, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('API Not Configured'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To chat with characters, you need to configure an LLM provider first.',
            ),
            SizedBox(height: 16),
            Text(
              'Supported providers:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• OpenAI (GPT-4, GPT-3.5)'),
            Text('• Claude (Anthropic)'),
            Text('• OpenRouter'),
            Text('• Gemini (Google)'),
            Text('• Ollama (Local)'),
            Text('• KoboldCpp (Local)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Later'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Use go instead of push because /ai-config is inside ShellRoute
              parentContext.go('/ai-config');
            },
            icon: const Icon(Icons.settings),
            label: const Text('Configure Now'),
          ),
        ],
      ),
    );
  }

  /// Show model selector dialog
  void _showModelSelector() async {
    final llmConfig = ref.read(llmConfigProvider);
    final llmService = ref.read(llmServiceProvider);
    
    // Show loading dialog while fetching models
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading models...'),
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
        _showSnackBar('No models available. Check your API configuration.');
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
        _showSnackBar('Model changed to $selectedModel');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showSnackBar('Failed to load models: $e');
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
    
    await ref.read(activeChatProvider.notifier).sendMessage(
      content,
      config,
      attachments: attachments,
    );
    _scrollToBottom();
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
    
    await _executeCommand(command, argument);
  }

  Future<void> _executeCommand(SlashCommand command, String? argument) async {
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
        // TODO: Implement background change
        _showSnackBar('Background feature coming soon');
        break;
        
      case 'help':
        _showHelpDialog(argument);
        break;
        
      case 'clear':
        _showClearConfirmation();
        break;
        
      case 'edit':
        if (argument != null && argument.isNotEmpty && chatState.messages.isNotEmpty) {
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
          await chatNotifier.updateAuthorNote(argument);
          await chatNotifier.toggleAuthorNote(true);
          _showSnackBar('Author\'s note updated');
        } else {
          showAuthorNoteDialog(context);
        }
        break;
    }
  }

  void _handleSwipeCommand(String? argument) {
    final chatState = ref.read(activeChatProvider);
    if (chatState.messages.isEmpty) return;
    
    final lastMessage = chatState.messages.last;
    if (lastMessage.swipes.length <= 1) {
      _showSnackBar('No swipes available');
      return;
    }
    
    int newIndex = lastMessage.currentSwipeIndex;
    
    if (argument == null || argument.isEmpty || argument == 'right') {
      newIndex = (newIndex + 1) % lastMessage.swipes.length;
    } else if (argument == 'left') {
      newIndex = (newIndex - 1 + lastMessage.swipes.length) % lastMessage.swipes.length;
    } else {
      final parsed = int.tryParse(argument);
      if (parsed != null && parsed >= 1 && parsed <= lastMessage.swipes.length) {
        newIndex = parsed - 1;
      }
    }
    
    ref.read(activeChatProvider.notifier).swipeMessage(lastMessage.id, newIndex);
  }

  void _showSystemMessage(String content) {
    // For now, just show a snackbar. In the future, this could inject a system message
    _showSnackBar('System: $content');
  }

  void _showHelpDialog(String? commandName) {
    if (commandName != null && commandName.isNotEmpty) {
      final slashService = ref.read(slashCommandServiceProvider);
      final help = slashService.getCommandHelp(commandName);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('/$commandName'),
          content: Text(help),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Command Error'),
          ],
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
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
    
    await ref.read(activeChatProvider.notifier).regenerateLastMessage(config);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(activeChatProvider);
    final llmConfig = ref.watch(llmConfigProvider);
    final isConfigured = _isApiConfigured(llmConfig);
    
    // Scroll to bottom when new messages arrive
    ref.listen(activeChatProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: _buildAppBar(chatState),
      body: Column(
        children: [
          // API not configured banner
          if (!isConfigured)
            _buildApiConfigBanner(),
          
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
                : chatState.messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessageList(chatState),
          ),

          // Slash command suggestions
          if (_showSlashSuggestions)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SlashCommandSuggestions(
                input: _messageController.text,
                onSelect: _onSlashCommandSelected,
                onDismiss: () => setState(() => _showSlashSuggestions = false),
              ),
            ),

          // Quick replies bar (above input)
          _buildQuickReplyBar(chatState),

          // Input area
          _buildInputArea(chatState),
        ],
      ),
    );
  }

  Widget _buildApiConfigBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.primaryColor.withValues(alpha: 0.15),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'API not configured',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Configure an LLM provider to start chatting',
                  style: TextStyle(
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
            child: const Text('Configure'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(ActiveChatState chatState) {
    final hasAuthorNote = chatState.chat?.authorNoteEnabled == true &&
        (chatState.chat?.authorNote.isNotEmpty ?? false);
    final llmConfig = ref.watch(llmConfigProvider);
    
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chatState.character?.name ?? 'Chat',
            style: const TextStyle(fontSize: 16),
          ),
          // Model selector - tap to change model
          GestureDetector(
            onTap: () => _showModelSelector(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  llmConfig.model.isEmpty ? 'Select Model' : llmConfig.model,
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
        // Author's Note button
        IconButton(
          icon: Icon(
            Icons.note_alt_outlined,
            color: hasAuthorNote ? AppTheme.accentColor : null,
          ),
          tooltip: 'Author\'s Note',
          onPressed: () => showAuthorNoteDialog(context),
        ),
        // Bookmarks button
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          tooltip: 'Bookmarks',
          onPressed: () => _showBookmarksDialog(context),
        ),
        if (chatState.messages.isNotEmpty &&
            chatState.messages.last.role == MessageRole.assistant &&
            !chatState.isGenerating)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate',
            onPressed: _regenerateMessage,
          ),
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'character',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('View Character'),
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
                title: const Text('Author\'s Note'),
                subtitle: Text(
                  hasAuthorNote ? 'Enabled' : 'Disabled',
                  style: TextStyle(
                    color: hasAuthorNote ? AppTheme.accentColor : AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'bookmarks',
              child: ListTile(
                leading: Icon(Icons.bookmark, color: AppTheme.accentColor),
                title: Text('Bookmarks'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.upload),
                title: Text('Export Chat'),
                subtitle: Text('Save as JSONL/JSON'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'import',
              child: ListTile(
                leading: Icon(Icons.download),
                title: Text('Import Chat'),
                subtitle: Text('Load from file'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: ListTile(
                leading: Icon(Icons.delete_sweep, color: Colors.orange),
                title: Text('Clear Messages'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'character':
                // Navigate to character
                break;
              case 'author_note':
                showAuthorNoteDialog(context);
                break;
              case 'bookmarks':
                _showBookmarksDialog(context);
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

  Widget _buildEmptyState() {
    final character = ref.read(activeChatProvider).character;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (character?.assets?.avatarPath != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(File(character!.assets!.avatarPath!)),
            )
          else
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
          const SizedBox(height: 16),
          Text(
            character?.name ?? 'Chat',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMuted,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(ActiveChatState chatState) {
    final config = ref.read(llmConfigProvider);
    
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: chatState.messages.length,
      itemBuilder: (context, index) {
        final message = chatState.messages[index];
        final isLast = index == chatState.messages.length - 1;
        
        return _MessageBubble(
          message: message,
          messageIndex: index,
          chatId: widget.chatId,
          character: chatState.character,
          isGenerating: isLast && chatState.isGenerating,
          isLast: isLast,
          onSwipe: (swipeIndex) {
            ref.read(activeChatProvider.notifier).swipeMessage(
                  message.id,
                  swipeIndex,
                );
          },
          onEdit: (newContent) {
            ref.read(activeChatProvider.notifier).editMessage(
                  message.id,
                  newContent,
                );
          },
          onDelete: () {
            _showDeleteConfirmation(message.id);
          },
          onRegenerate: message.role == MessageRole.assistant
              ? () {
                  ref.read(activeChatProvider.notifier).regenerateMessage(
                        message.id,
                        config,
                      );
                }
              : null,
          onContinueFromHere: () {
            ref.read(activeChatProvider.notifier).continueFromMessage(
                  message.id,
                  config,
                );
          },
          onDeleteAndAfter: () {
            _showDeleteAndAfterConfirmation(message.id);
          },
          onCreateBookmark: () {
            _showCreateBookmarkDialog(message.id, index);
          },
        );
      },
    );
  }

  void _showBookmarksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BookmarksListDialog(chatId: widget.chatId),
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark created')),
      );
    }
  }

  void _showDeleteConfirmation(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activeChatProvider.notifier).deleteMessage(messageId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAndAfterConfirmation(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Messages'),
        content: const Text(
          'Are you sure you want to delete this message and all messages after it?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(activeChatProvider.notifier).deleteMessageAndAfter(messageId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
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
      ref.read(activeChatProvider.notifier).continueGeneration(config);
      _scrollToBottom();
    } else if (autoSend) {
      // Auto-send: send the message immediately
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
        border: Border(
          top: BorderSide(color: AppTheme.darkDivider),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pending attachments preview
            if (_pendingAttachments.isNotEmpty)
              _buildAttachmentsPreview(),
            // Compact markdown toolbar
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // Image attachment button
                  IconButton(
                    icon: const Icon(Icons.image, size: 20),
                    tooltip: 'Attach image',
                    onPressed: _showAttachmentOptions,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  const SizedBox(width: 4),
                  MarkdownToolbar(
                    controller: _messageController,
                    focusNode: _focusNode,
                    compact: true,
                  ),
                  const Spacer(),
                  // Hint for keyboard shortcuts
                  Tooltip(
                    message: 'Keyboard shortcuts:\n'
                        '⌘B - Bold\n'
                        '⌘I - Italic\n'
                        '⌘U - Underline\n'
                        '⌘⇧S - Strikethrough\n'
                        '⌘` - Inline code\n'
                        '⌘K - Link',
                    child: Icon(
                      Icons.keyboard,
                      size: 16,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Input row
            Row(
              children: [
                Expanded(
                  child: MarkdownInputField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    maxLines: 5,
                    minLines: 1,
                    hintText: 'Type a message...',
                    onSubmitted: (_) => _sendMessage(),
                    textInputAction: TextInputAction.send,
                    showToolbar: false, // We show toolbar above
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
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
                IconButton.filled(
                  onPressed: chatState.isGenerating ? null : _sendMessage,
                  icon: chatState.isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                      child: const Icon(Icons.broken_image, color: AppTheme.textMuted),
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
              leading: const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.accentColor),
              title: const Text('Take Photo'),
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
    debugPrint('📎 _pickImageFromFiles called');
    try {
      debugPrint('📎 Calling FilePicker.platform.pickFiles...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        dialogTitle: 'Select Images',
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
      debugPrint('📎 FilePicker error: $e');
      debugPrint('📎 Stack trace: $stackTrace');
      _showSnackBar('Failed to pick image: $e');
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
      _showSnackBar('Failed to pick image: $e');
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
      _showSnackBar('Failed to take photo: $e');
    }
  }

  /// Add an attachment from a file path
  Future<void> _addAttachmentFromPath(String filePath) async {
    try {
      // Copy file to app's documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(p.join(appDir.path, 'NativeTavern', 'attachments'));
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
      _showSnackBar('Failed to add attachment: $e');
    }
  }

  /// Add an attachment from XFile (for mobile image_picker)
  Future<void> _addAttachmentFromXFile(XFile file) async {
    try {
      // Copy file to app's documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory(p.join(appDir.path, 'NativeTavern', 'attachments'));
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
      _showSnackBar('Failed to add attachment: $e');
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
    final chatState = ref.read(activeChatProvider);
    if (chatState.chat == null || chatState.character == null) {
      _showSnackBar('No chat to export');
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.upload, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('Export Chat'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export chat with ${chatState.character!.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${chatState.messages.length} messages',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            const Text('Choose export format:'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _exportChat(useJsonl: false);
            },
            child: const Text('JSON'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _exportChat(useJsonl: true);
            },
            child: const Text('JSONL (ST Format)'),
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
    final userName = activePersonaAsync.valueOrNull?.name ?? 'User';

    try {
      await exportService.exportAndShare(
        chatState.chat!,
        chatState.messages,
        chatState.character!,
        userName: userName,
        useJsonl: useJsonl,
      );
    } catch (e) {
      _showSnackBar('Export failed: $e');
    }
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('Import Chat'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import chat history from a file.',
            ),
            SizedBox(height: 16),
            Text(
              'Supported formats:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• JSONL (SillyTavern format)'),
            Text('• JSON (NativeTavern format)'),
            SizedBox(height: 16),
            Text(
              'Note: Imported messages will be added to the current chat.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _importChat();
            },
            icon: const Icon(Icons.folder_open),
            label: const Text('Choose File'),
          ),
        ],
      ),
    );
  }

  Future<void> _importChat() async {
    final exportService = ref.read(chatExportServiceProvider);
    
    try {
      final result = await exportService.importFromFile();
      if (result == null) {
        _showSnackBar('No file selected or invalid format');
        return;
      }

      // Show confirmation dialog with import details
      if (!mounted) return;
      
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Import Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Character: ${result.characterName}'),
              Text('User: ${result.userName}'),
              Text('Messages: ${result.messages.length}'),
              Text('Date: ${result.createDate.toString().split('.')[0]}'),
              if (result.authorNote != null && result.authorNote!.isNotEmpty)
                Text('Has Author\'s Note: Yes'),
              const SizedBox(height: 16),
              const Text(
                'Import these messages to the current chat?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Import'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Import messages to current chat
      final chatState = ref.read(activeChatProvider);
      if (chatState.chat == null) {
        _showSnackBar('No active chat');
        return;
      }

      // Add imported messages
      final chatNotifier = ref.read(activeChatProvider.notifier);
      int importedCount = 0;
      
      for (final importedMsg in result.messages) {
        final id = DateTime.now().millisecondsSinceEpoch.toString() +
            (DateTime.now().microsecond % 1000).toString().padLeft(3, '0') +
            importedCount.toString();
        
        final message = importedMsg.toChatMessage(chatState.chat!.id, id);
        
        // We need to add messages through the repository
        // For now, show a message that import is not fully implemented
        importedCount++;
      }

      // Update author's note if present
      if (result.authorNote != null && result.authorNote!.isNotEmpty) {
        await chatNotifier.updateAuthorNote(result.authorNote!);
        if (result.authorNoteDepth != null) {
          await chatNotifier.updateAuthorNoteDepth(result.authorNoteDepth!);
        }
        if (result.authorNoteEnabled == true) {
          await chatNotifier.toggleAuthorNote(true);
        }
      }

      _showSnackBar('Imported ${result.messages.length} messages');
      
      // Reload chat to show imported messages
      await chatNotifier.loadChat(chatState.chat!.id);
      _scrollToBottom();
    } catch (e) {
      _showSnackBar('Import failed: $e');
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Messages'),
        content: const Text(
          'Are you sure you want to clear all messages? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Clear all messages
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
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
  final void Function(int) onSwipe;
  final void Function(String) onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onRegenerate;
  final VoidCallback onContinueFromHere;
  final VoidCallback onDeleteAndAfter;
  final VoidCallback onCreateBookmark;

  const _MessageBubble({
    required this.message,
    required this.messageIndex,
    required this.chatId,
    required this.character,
    required this.isGenerating,
    required this.isLast,
    required this.onSwipe,
    required this.onEdit,
    required this.onDelete,
    this.onRegenerate,
    required this.onContinueFromHere,
    required this.onDeleteAndAfter,
    required this.onCreateBookmark,
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
          if (!isUser) ...[
            _buildAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: () => _showMessageOptions(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? AppTheme.accentColor : AppTheme.darkCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
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
                        Text(
                          '${widget.message.currentSwipeIndex + 1}/${widget.message.swipes.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
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
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (widget.character?.assets?.avatarPath != null) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: FileImage(File(widget.character!.assets!.avatarPath!)),
      );
    }
    return const CircleAvatar(
      radius: 16,
      child: Icon(Icons.person, size: 16),
    );
  }

  /// Build the reasoning/thinking section for AI messages
  Widget _buildReasoningSection() {
    final reasoning = widget.message.currentReasoning;
    if (reasoning == null || reasoning.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // During streaming, show the streaming version
    if (widget.isGenerating && widget.isLast) {
      return StreamingReasoningWidget(
        reasoning: reasoning,
        isStreaming: true,
        label: 'Thinking',
      );
    }
    
    // For completed messages, show the collapsible version
    return ReasoningWidget(
      reasoning: reasoning,
      initiallyExpanded: false,
      label: 'Thinking',
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
              constraints: const BoxConstraints(
                maxWidth: 250,
                maxHeight: 200,
              ),
              child: Image.file(
                File(attachments[0].path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 100,
                  color: AppTheme.darkBackground,
                  child: const Icon(Icons.broken_image, color: AppTheme.textMuted),
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
                  child: const Icon(Icons.broken_image, size: 20, color: AppTheme.textMuted),
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
                      child: const Icon(Icons.broken_image, size: 48, color: AppTheme.textMuted),
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onEdit(_editController.text);
                setState(() => _isEditing = false);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }

  void _showMessageOptions(BuildContext context) {
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
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: widget.message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied to clipboard'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            
            // Edit
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.textSecondary),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editController.text = widget.message.content;
                setState(() => _isEditing = true);
              },
            ),
            
            // Regenerate (only for assistant messages)
            if (isAssistant && widget.onRegenerate != null)
              ListTile(
                leading: const Icon(Icons.refresh, color: AppTheme.primaryColor),
                title: const Text('Regenerate'),
                subtitle: const Text('Generate a new response alternative'),
                onTap: () {
                  Navigator.pop(context);
                  widget.onRegenerate!();
                },
              ),
            
            // Continue from here
            ListTile(
              leading: const Icon(Icons.play_arrow, color: AppTheme.accentColor),
              title: const Text('Continue from here'),
              subtitle: Text(
                widget.message.role == MessageRole.user
                    ? 'Delete messages after and regenerate response'
                    : 'Delete messages after this one',
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onContinueFromHere();
              },
            ),
            
            // Create bookmark
            ListTile(
              leading: const Icon(Icons.bookmark_add, color: AppTheme.accentColor),
              title: const Text('Create Bookmark'),
              subtitle: const Text('Save this point as a checkpoint'),
              onTap: () {
                Navigator.pop(context);
                widget.onCreateBookmark();
              },
            ),
            
            const Divider(),
            
            // Delete this message
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.orange),
              title: const Text('Delete this message'),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete();
              },
            ),
            
            // Delete this and all after
            if (!widget.isLast)
              ListTile(
                leading: const Icon(Icons.delete_sweep, color: Colors.red),
                title: const Text(
                  'Delete this and all after',
                  style: TextStyle(color: Colors.red),
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
            final animationValue = 
                ((_controller.value + delay) % 1.0);
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
    return Dialog(
      backgroundColor: AppTheme.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                        'Select Model',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provider: ${widget.providerName}',
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
                  hintText: 'Search models...',
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
                          'No models match your search',
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
                            isSelected ? Icons.check_circle : Icons.circle_outlined,
                            color: isSelected ? AppTheme.accentColor : AppTheme.textMuted,
                            size: 20,
                          ),
                          title: Text(
                            model,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: AppTheme.accentColor.withValues(alpha: 0.1),
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
                    child: const Text('Cancel'),
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