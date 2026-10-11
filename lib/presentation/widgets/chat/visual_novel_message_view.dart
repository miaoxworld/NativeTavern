import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/chat/message_content_widget.dart';
import 'package:native_tavern/presentation/widgets/chat/data_bank_citation_preview.dart';
import 'package:native_tavern/presentation/widgets/chat/reasoning_widget.dart';
import 'package:native_tavern/presentation/widgets/common/character_avatar_image.dart';

/// Visual novel style message view - displays messages at the bottom of the screen
/// with the background image visible above
class VisualNovelMessageView extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  final Character? character;
  final Character? Function(ChatMessage message)? characterForMessage;
  final bool isGenerating;
  final void Function(ChatMessage message) onLongPress;
  final void Function(int swipeIndex, String messageId) onSwipe;

  const VisualNovelMessageView({
    super.key,
    required this.messages,
    this.character,
    this.characterForMessage,
    this.isGenerating = false,
    required this.onLongPress,
    required this.onSwipe,
  });

  @override
  ConsumerState<VisualNovelMessageView> createState() =>
      _VisualNovelMessageViewState();
}

class _VisualNovelMessageViewState
    extends ConsumerState<VisualNovelMessageView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.messages.isEmpty ? 0 : widget.messages.length - 1;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didUpdateWidget(VisualNovelMessageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto scroll to latest message when new message arrives
    if (widget.messages.length > oldWidget.messages.length) {
      final newIndex = widget.messages.length - 1;
      if (_currentIndex != newIndex) {
        setState(() => _currentIndex = newIndex);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              newIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(builder: (context, constraints) {
      final availableHeight = constraints.maxHeight;
      final navigationHeight = math.min(64.0, availableHeight);
      final panelHeight = math.min(
        math.max(0.0, availableHeight - navigationHeight),
        math.max(150.0, availableHeight * 0.4),
      );
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Navigation buttons & page indicator
          SizedBox(
            height: navigationHeight,
            child: SingleChildScrollView(child: _buildNavigationBar()),
          ),
          // Message content area
          _buildMessageArea(panelHeight),
        ],
      );
    });
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: _currentIndex > 0 ? Colors.white : Colors.white38,
            ),
            onPressed: _currentIndex > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                : null,
          ),
          // Page indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.messages.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Next button
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: _currentIndex < widget.messages.length - 1
                  ? Colors.white
                  : Colors.white38,
            ),
            onPressed: _currentIndex < widget.messages.length - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageArea(double height) {
    final messagePanel = Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.messages.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          final message = widget.messages[index];
          final isLast = index == widget.messages.length - 1;
          final isGenerating = isLast && widget.isGenerating;

          return _buildMessageCard(message, isGenerating);
        },
      ),
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: messagePanel,
      ),
    );
  }

  Widget _buildMessageCard(ChatMessage message, bool isGenerating) {
    final isUser = message.role == MessageRole.user;
    final hasSwipes = message.swipes.length > 1;
    final isLast =
        widget.messages.isNotEmpty && message == widget.messages.last;

    return GestureDetector(
      onLongPress: () => widget.onLongPress(message),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker header
            _buildSpeakerHeader(message, isUser),
            const SizedBox(height: 12),
            // Show reasoning/thinking content if available (for AI messages)
            if (!isUser && message.hasReasoning)
              _buildReasoningSection(message, isGenerating && isLast),
            // Message content
            if (isGenerating && message.content.isEmpty)
              _buildTypingIndicator()
            else
              MessageContentWidget(
                content: message.content,
                textColor: Colors.white,
                selectable: true,
                onLongPress: () => widget.onLongPress(message),
                isStreaming: isGenerating,
                messageId: message.id,
              ),
            if (!isUser && !isGenerating)
              DataBankCitationPreview(message: message),
            // Swipe controls
            if (hasSwipes && !isGenerating) _buildSwipeControls(message),
          ],
        ),
      ),
    );
  }

  /// Build the reasoning/thinking section for AI messages
  Widget _buildReasoningSection(ChatMessage message, bool isStreaming) {
    final l10n = AppLocalizations.of(context);
    final reasoning = message.currentReasoning;
    if (reasoning == null || reasoning.isEmpty) {
      return const SizedBox.shrink();
    }

    // During streaming, show the streaming version
    if (isStreaming) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: StreamingReasoningWidget(
          reasoning: reasoning,
          isStreaming: true,
          label: l10n.thinking,
        ),
      );
    }

    // For completed messages, show the collapsible version
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ReasoningWidget(
        reasoning: reasoning,
        initiallyExpanded: false,
        label: l10n.thinking,
      ),
    );
  }

  Widget _buildSpeakerHeader(ChatMessage message, bool isUser) {
    final character =
        widget.characterForMessage?.call(message) ?? widget.character;
    return Row(
      children: [
        // Avatar
        if (!isUser && character?.assets?.avatarPath != null)
          CharacterAvatarCircle(
            imagePath: character!.assets!.avatarPath!,
            radius: 18,
            errorBuilder: (_, __, ___) => CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.accentColor.withValues(alpha: 0.3),
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          )
        else
          CircleAvatar(
            radius: 18,
            backgroundColor: isUser
                ? AppTheme.accentColor.withValues(alpha: 0.5)
                : AppTheme.accentColor.withValues(alpha: 0.3),
            child: Icon(
              isUser ? Icons.person : Icons.smart_toy,
              size: 18,
              color: Colors.white,
            ),
          ),
        const SizedBox(width: 10),
        // Name
        Text(
          isUser ? 'You' : (character?.name ?? 'AI'),
          style: TextStyle(
            color: isUser ? AppTheme.accentColor : Colors.amber,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Speaking indicator for generating
        if (!isUser &&
            widget.messages.isNotEmpty &&
            message == widget.messages.last &&
            widget.isGenerating)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 600 + i * 200),
              builder: (context, value, child) => Opacity(
                opacity: 0.3 + 0.7 * ((value + i / 3) % 1),
                child: child,
              ),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSwipeControls(ChatMessage message) {
    final currentSwipeIndex = message.currentSwipeIndex;
    final totalSwipes = message.swipes.length;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: currentSwipeIndex > 0 ? Colors.white70 : Colors.white24,
            ),
            onPressed: currentSwipeIndex > 0
                ? () => widget.onSwipe(currentSwipeIndex - 1, message.id)
                : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${currentSwipeIndex + 1} / $totalSwipes',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: currentSwipeIndex < totalSwipes - 1
                  ? Colors.white70
                  : Colors.white24,
            ),
            onPressed: currentSwipeIndex < totalSwipes - 1
                ? () => widget.onSwipe(currentSwipeIndex + 1, message.id)
                : null,
          ),
        ],
      ),
    );
  }
}
