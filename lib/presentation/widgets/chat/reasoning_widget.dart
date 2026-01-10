import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/chat/message_content_widget.dart';

/// A collapsible widget that displays AI reasoning/thinking content
/// 
/// This widget shows the chain-of-thought or thinking process from AI models
/// like Claude (extended thinking), OpenAI o1/o3 (reasoning), DeepSeek (thinking),
/// and Gemini 2.0 Flash Thinking.
class ReasoningWidget extends StatefulWidget {
  /// The reasoning/thinking content to display
  final String reasoning;
  
  /// Whether the widget should start expanded
  final bool initiallyExpanded;
  
  /// Optional label for the reasoning section
  final String label;
  
  /// Text color for the content
  final Color? textColor;

  const ReasoningWidget({
    super.key,
    required this.reasoning,
    this.initiallyExpanded = false,
    this.label = 'Thinking',
    this.textColor,
  });

  @override
  State<ReasoningWidget> createState() => _ReasoningWidgetState();
}

class _ReasoningWidgetState extends State<ReasoningWidget>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(_expandAnimation);
    
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _copyReasoning() {
    Clipboard.setData(ClipboardData(text: widget.reasoning));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reasoning copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reasoning.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getAccentColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (always visible)
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
              bottom: Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Thinking icon with animation
                  _buildThinkingIcon(),
                  const SizedBox(width: 8),
                  // Label
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: _getAccentColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // Character count
                  Text(
                    '${widget.reasoning.length} chars',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Copy button
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 16,
                      color: AppTheme.textMuted,
                    ),
                    onPressed: _copyReasoning,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    tooltip: 'Copy reasoning',
                  ),
                  // Expand/collapse arrow
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: _getAccentColor(),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: _getAccentColor().withValues(alpha: 0.2),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: MessageContentWidget(
                    content: widget.reasoning,
                    textColor: widget.textColor ?? AppTheme.textSecondary,
                    fontSize: 13,
                    selectable: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingIcon() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: _getAccentColor().withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.psychology,
        size: 16,
        color: _getAccentColor(),
      ),
    );
  }

  Color _getAccentColor() {
    // Use a distinct color for reasoning/thinking
    return const Color(0xFF9C7CF4); // Purple/violet for thinking
  }
}

/// A streaming version of the reasoning widget that shows content as it arrives
class StreamingReasoningWidget extends StatefulWidget {
  /// The reasoning/thinking content being streamed
  final String reasoning;
  
  /// Whether streaming is still in progress
  final bool isStreaming;
  
  /// Optional label for the reasoning section
  final String label;

  const StreamingReasoningWidget({
    super.key,
    required this.reasoning,
    this.isStreaming = false,
    this.label = 'Thinking',
  });

  @override
  State<StreamingReasoningWidget> createState() => _StreamingReasoningWidgetState();
}

class _StreamingReasoningWidgetState extends State<StreamingReasoningWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isStreaming) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StreamingReasoningWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isStreaming && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isStreaming && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reasoning.isEmpty && !widget.isStreaming) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getAccentColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Animated thinking icon
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: widget.isStreaming ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _getAccentColor().withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.psychology,
                          size: 16,
                          color: _getAccentColor(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Label with streaming indicator
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: _getAccentColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      if (widget.isStreaming) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _getAccentColor(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Character count
                Text(
                  '${widget.reasoning.length} chars',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Content (always visible during streaming)
          if (widget.reasoning.isNotEmpty) ...[
            Divider(
              height: 1,
              color: _getAccentColor().withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: MessageContentWidget(
                content: widget.reasoning,
                textColor: AppTheme.textSecondary,
                fontSize: 13,
                selectable: true,
              ),
            ),
          ] else if (widget.isStreaming) ...[
            Divider(
              height: 1,
              color: _getAccentColor().withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Thinking...',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getAccentColor() {
    return const Color(0xFF9C7CF4); // Purple/violet for thinking
  }
}