import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/chat/html_webview_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Widget that renders message content with support for Markdown
///
/// This widget renders content using Markdown renderer. For complex HTML content
/// (with flexbox, grid, shadows, etc.), it uses WebView for full CSS support.
/// Simple HTML tags are converted to Markdown equivalents.
/// - Markdown: bold, italic, strikethrough, code blocks, lists, links, etc.
/// - Complex HTML: rendered via WebView for full CSS support
/// - Text selection with context menu (copy, select all)
class MessageContentWidget extends StatefulWidget {
  final String content;
  final Color textColor;
  final bool selectable;
  final double? fontSize;
  final VoidCallback? onCopy;
  final void Function(String)? onCopySelection;
  final VoidCallback? onLongPress;
  /// Whether the message is currently being streamed (AI is still generating)
  /// When true, WebView will not be used even for complex HTML to avoid rendering issues
  final bool isStreaming;
  /// Optional message ID for tracking content changes and forcing re-renders
  final String? messageId;

  const MessageContentWidget({
    super.key,
    required this.content,
    required this.textColor,
    this.selectable = true,
    this.fontSize,
    this.onCopy,
    this.onCopySelection,
    this.onLongPress,
    this.isStreaming = false,
    this.messageId,
  });

  @override
  State<MessageContentWidget> createState() => _MessageContentWidgetState();
}

class _MessageContentWidgetState extends State<MessageContentWidget> {
  String? _selectedText;
  /// Content key for forcing WebView re-render after streaming ends
  int _contentVersion = 0;

  @override
  void didUpdateWidget(MessageContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Detect when streaming ends - this is the key moment to re-render
    if (oldWidget.isStreaming && !widget.isStreaming) {
      // Streaming just ended, increment content version to force WebView reload
      setState(() {
        _contentVersion++;
      });
    }
  }

  /// Check if content contains HTML tags
  bool _containsHtml(String text) {
    // Common HTML tags used in SillyTavern
    final htmlPattern = RegExp(
      r'<\s*(b|i|u|s|em|strong|br|p|div|span|a|ul|ol|li|h[1-6]|blockquote|pre|code|hr|img|table|tr|td|th|font|center|sub|sup|mark|del|ins|small|big|q|cite|abbr|details|summary)(\s|>|/>)',
      caseSensitive: false,
    );
    return htmlPattern.hasMatch(text);
  }

  /// Check if content contains Markdown syntax
  bool _containsMarkdown(String text) {
    // Simple check: if text contains any common Markdown markers, use Markdown renderer
    // The Markdown renderer will handle the actual parsing
    
    // Check for bold/italic markers
    if (text.contains('**') || text.contains('__')) return true;
    if (text.contains('~~')) return true; // Strikethrough
    if (text.contains('`')) return true; // Code
    
    // Check for single asterisk italic: *text* (but not * alone or **)
    // Match pattern: space or start, *, non-space, content, non-space, *, space or end
    if (RegExp(r'(?:^|[\s\(])\*[^\s*].*?[^\s*]\*(?:[\s\)\.,!?]|$)').hasMatch(text)) return true;
    // Also match short italic like *a*
    if (RegExp(r'(?:^|[\s\(])\*[^\s*]\*(?:[\s\)\.,!?]|$)').hasMatch(text)) return true;
    
    // Check for single underscore italic: _text_
    if (RegExp(r'(?:^|[\s\(])_[^\s_].*?[^\s_]_(?:[\s\)\.,!?]|$)').hasMatch(text)) return true;
    if (RegExp(r'(?:^|[\s\(])_[^\s_]_(?:[\s\)\.,!?]|$)').hasMatch(text)) return true;
    
    // Check for headers
    if (RegExp(r'^#{1,6}\s', multiLine: true).hasMatch(text)) return true;
    
    // Check for lists
    if (RegExp(r'^\s*[-*+]\s', multiLine: true).hasMatch(text)) return true;
    if (RegExp(r'^\s*\d+\.\s', multiLine: true).hasMatch(text)) return true;
    
    // Check for links and images
    if (RegExp(r'\[([^\]]+)\]\(([^)]+)\)').hasMatch(text)) return true;
    
    // Check for blockquote
    if (RegExp(r'^>\s', multiLine: true).hasMatch(text)) return true;
    
    // Check for horizontal rule
    if (RegExp(r'^---+$', multiLine: true).hasMatch(text)) return true;
    
    return false;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.copiedToClipboard),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    // If onLongPress callback is provided, use it instead of showing copy menu
    if (widget.onLongPress != null) {
      widget.onLongPress!();
      return;
    }
    
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'copy',
          child: Row(
            children: [
              const Icon(Icons.copy, size: 20),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.copy),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'copy_all',
          child: Row(
            children: [
              const Icon(Icons.select_all, size: 20),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.copyAll),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'copy') {
        if (_selectedText != null && _selectedText!.isNotEmpty) {
          _copyToClipboard(_selectedText!);
          widget.onCopySelection?.call(_selectedText!);
        } else {
          _copyToClipboard(widget.content);
          widget.onCopy?.call();
        }
      } else if (value == 'copy_all') {
        _copyToClipboard(widget.content);
        widget.onCopy?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasHtml = _containsHtml(widget.content);

    Widget contentWidget;
    
    // If content has complex HTML (flexbox, grid, shadows, etc.) AND streaming is complete,
    // use WebView for full CSS support. During streaming, always use Markdown to avoid
    // rendering issues with constantly updating content.
    if (hasHtml && !widget.isStreaming && isComplexHtml(widget.content)) {
      // Generate a content key that changes when streaming ends, forcing a re-render
      final contentKey = '${widget.messageId ?? widget.content.hashCode}_v$_contentVersion';
      contentWidget = HtmlWebViewWidget(
        htmlContent: widget.content,
        textColor: widget.textColor,
        fontSize: widget.fontSize,
        onLongPress: widget.onLongPress,
        contentKey: contentKey,
      );
    }
    // For all other content (including simple HTML), convert to Markdown and render
    else {
      // Convert HTML to Markdown-friendly format
      final processedContent = hasHtml ? _convertHtmlToMarkdown(widget.content) : widget.content;
      contentWidget = _buildMarkdownContent(context, processedContent);
    }

    // Wrap with gesture detector for context menu (except for WebView which handles its own)
    if (hasHtml && !widget.isStreaming && isComplexHtml(widget.content)) {
      return contentWidget;
    }
    
    return GestureDetector(
      onSecondaryTapDown: (details) => _showContextMenu(context, details.globalPosition),
      onLongPressStart: (details) => _showContextMenu(context, details.globalPosition),
      child: contentWidget,
    );
  }
  
  /// Convert simple HTML tags to Markdown equivalents
  String _convertHtmlToMarkdown(String html) {
    var result = html;
    
    // Convert bold tags
    result = result.replaceAllMapped(
      RegExp(r'<(b|strong)>(.*?)</\1>', caseSensitive: false, dotAll: true),
      (m) => '**${m.group(2)}**',
    );
    
    // Convert italic tags
    result = result.replaceAllMapped(
      RegExp(r'<(i|em)>(.*?)</\1>', caseSensitive: false, dotAll: true),
      (m) => '*${m.group(2)}*',
    );
    
    // Convert underline to bold (Markdown doesn't have underline)
    result = result.replaceAllMapped(
      RegExp(r'<u>(.*?)</u>', caseSensitive: false, dotAll: true),
      (m) => '**${m.group(1)}**',
    );
    
    // Convert strikethrough
    result = result.replaceAllMapped(
      RegExp(r'<(s|del|strike)>(.*?)</\1>', caseSensitive: false, dotAll: true),
      (m) => '~~${m.group(2)}~~',
    );
    
    // Convert code tags
    result = result.replaceAllMapped(
      RegExp(r'<code>(.*?)</code>', caseSensitive: false, dotAll: true),
      (m) => '`${m.group(1)}`',
    );
    
    // Convert pre tags to code blocks
    result = result.replaceAllMapped(
      RegExp(r'<pre>(.*?)</pre>', caseSensitive: false, dotAll: true),
      (m) => '\n```\n${m.group(1)}\n```\n',
    );
    
    // Convert headers
    result = result.replaceAllMapped(
      RegExp(r'<h1[^>]*>(.*?)</h1>', caseSensitive: false, dotAll: true),
      (m) => '\n# ${m.group(1)}\n',
    );
    result = result.replaceAllMapped(
      RegExp(r'<h2[^>]*>(.*?)</h2>', caseSensitive: false, dotAll: true),
      (m) => '\n## ${m.group(1)}\n',
    );
    result = result.replaceAllMapped(
      RegExp(r'<h3[^>]*>(.*?)</h3>', caseSensitive: false, dotAll: true),
      (m) => '\n### ${m.group(1)}\n',
    );
    result = result.replaceAllMapped(
      RegExp(r'<h4[^>]*>(.*?)</h4>', caseSensitive: false, dotAll: true),
      (m) => '\n#### ${m.group(1)}\n',
    );
    result = result.replaceAllMapped(
      RegExp(r'<h5[^>]*>(.*?)</h5>', caseSensitive: false, dotAll: true),
      (m) => '\n##### ${m.group(1)}\n',
    );
    result = result.replaceAllMapped(
      RegExp(r'<h6[^>]*>(.*?)</h6>', caseSensitive: false, dotAll: true),
      (m) => '\n###### ${m.group(1)}\n',
    );
    
    // Convert links
    result = result.replaceAllMapped(
      RegExp(r'<a[^>]*href="([^"]*)"[^>]*>(.*?)</a>', caseSensitive: false, dotAll: true),
      (m) => '[${m.group(2)}](${m.group(1)})',
    );
    
    // Convert images - keep as Markdown image syntax
    result = result.replaceAllMapped(
      RegExp(r'<img[^>]*src="([^"]*)"[^>]*/?\s*>', caseSensitive: false),
      (m) => '![image](${m.group(1)})',
    );
    
    // Convert blockquote
    result = result.replaceAllMapped(
      RegExp(r'<blockquote[^>]*>(.*?)</blockquote>', caseSensitive: false, dotAll: true),
      (m) {
        final content = m.group(1) ?? '';
        final lines = content.split('\n').map((line) => '> ${line.trim()}').join('\n');
        return '\n$lines\n';
      },
    );
    
    // Convert horizontal rule
    result = result.replaceAll(RegExp(r'<hr\s*/?\s*>', caseSensitive: false), '\n---\n');
    
    // Convert line breaks
    result = result.replaceAll(RegExp(r'<br\s*/?\s*>', caseSensitive: false), '\n');
    
    // Convert paragraphs
    result = result.replaceAllMapped(
      RegExp(r'<p[^>]*>(.*?)</p>', caseSensitive: false, dotAll: true),
      (m) => '\n${m.group(1)}\n',
    );
    
    // Convert divs to paragraphs
    result = result.replaceAllMapped(
      RegExp(r'<div[^>]*>(.*?)</div>', caseSensitive: false, dotAll: true),
      (m) => '\n${m.group(1)}\n',
    );
    
    // Convert unordered lists
    result = result.replaceAllMapped(
      RegExp(r'<ul[^>]*>(.*?)</ul>', caseSensitive: false, dotAll: true),
      (m) {
        final content = m.group(1) ?? '';
        return content.replaceAllMapped(
          RegExp(r'<li[^>]*>(.*?)</li>', caseSensitive: false, dotAll: true),
          (li) => '- ${li.group(1)?.trim()}\n',
        );
      },
    );
    
    // Convert ordered lists
    result = result.replaceAllMapped(
      RegExp(r'<ol[^>]*>(.*?)</ol>', caseSensitive: false, dotAll: true),
      (m) {
        final content = m.group(1) ?? '';
        var index = 1;
        return content.replaceAllMapped(
          RegExp(r'<li[^>]*>(.*?)</li>', caseSensitive: false, dotAll: true),
          (li) => '${index++}. ${li.group(1)?.trim()}\n',
        );
      },
    );
    
    // Remove remaining HTML tags (span, font, center, etc.)
    result = result.replaceAll(RegExp(r'<[^>]+>'), '');
    
    // Clean up multiple newlines
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    
    // Decode HTML entities
    result = _decodeHtmlEntities(result);
    
    return result.trim();
  }
  
  /// Decode common HTML entities
  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–')
        .replaceAll('&hellip;', '…')
        .replaceAll('&copy;', '©')
        .replaceAll('&reg;', '®')
        .replaceAll('&trade;', '™');
  }

  Widget _buildMarkdownContent(BuildContext context, String content) {
    final effectiveFontSize = widget.fontSize ?? 14.0;
    
    return SelectionArea(
      onSelectionChanged: (selection) {
        _selectedText = selection?.plainText;
      },
      child: MarkdownBody(
        data: content,
        selectable: widget.selectable,
        shrinkWrap: true,
        softLineBreak: true, // Enable soft line breaks for proper text wrapping
        imageBuilder: (uri, title, alt) {
          // Custom image builder using CachedNetworkImage
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: uri.toString(),
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: AppTheme.darkBackground,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: AppTheme.darkBackground,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.broken_image, color: AppTheme.textMuted),
                      const SizedBox(height: 4),
                      Text(
                        'Image failed to load',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize,
          ),
          strong: TextStyle(
            color: widget.textColor,
            fontWeight: FontWeight.bold,
          ),
          em: TextStyle(
            color: widget.textColor,
            fontStyle: FontStyle.italic,
          ),
          del: TextStyle(
            color: widget.textColor,
            decoration: TextDecoration.lineThrough,
          ),
          code: TextStyle(
            color: widget.textColor,
            backgroundColor: AppTheme.darkBackground.withValues(alpha: 0.5),
            fontFamily: 'monospace',
            fontSize: effectiveFontSize * 0.9,
          ),
          codeblockDecoration: BoxDecoration(
            color: AppTheme.darkBackground.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          codeblockPadding: const EdgeInsets.all(12),
          blockquote: TextStyle(
            color: AppTheme.textSecondary,
            fontStyle: FontStyle.italic,
          ),
          blockquoteDecoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppTheme.primaryColor,
                width: 3,
              ),
            ),
          ),
          blockquotePadding: const EdgeInsets.only(left: 12),
          h1: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize * 1.8,
            fontWeight: FontWeight.bold,
          ),
          h2: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize * 1.5,
            fontWeight: FontWeight.bold,
          ),
          h3: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize * 1.3,
            fontWeight: FontWeight.bold,
          ),
          h4: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize * 1.1,
            fontWeight: FontWeight.bold,
          ),
          h5: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize,
            fontWeight: FontWeight.bold,
          ),
          h6: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize * 0.9,
            fontWeight: FontWeight.bold,
          ),
          a: TextStyle(
            color: AppTheme.primaryColor,
            decoration: TextDecoration.underline,
          ),
          listBullet: TextStyle(
            color: widget.textColor,
          ),
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppTheme.darkDivider,
                width: 1,
              ),
            ),
          ),
        ),
        onTapLink: (text, href, title) {
          if (href != null) {
            _launchUrl(href);
          }
        },
      ),
    );
  }

  Widget _buildPlainText(BuildContext context) {
    final effectiveFontSize = widget.fontSize ?? 14.0;
    
    if (widget.selectable) {
      return SelectionArea(
        onSelectionChanged: (selection) {
          _selectedText = selection?.plainText;
        },
        child: Text(
          widget.content,
          style: TextStyle(
            color: widget.textColor,
            fontSize: effectiveFontSize,
          ),
        ),
      );
    }
    
    return Text(
      widget.content,
      style: TextStyle(
        color: widget.textColor,
        fontSize: effectiveFontSize,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}