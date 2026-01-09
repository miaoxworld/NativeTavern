import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget that renders message content with support for both Markdown and HTML
///
/// This widget automatically detects whether the content contains HTML tags
/// and renders using the appropriate renderer. It supports:
/// - Markdown: bold, italic, strikethrough, code blocks, lists, links, etc.
/// - HTML: common tags like <b>, <i>, <u>, <s>, <br>, <p>, <div>, <span>, etc.
/// - Mixed content: HTML takes precedence when detected
/// - Text selection with context menu (copy, select all)
class MessageContentWidget extends StatefulWidget {
  final String content;
  final Color textColor;
  final bool selectable;
  final double? fontSize;
  final VoidCallback? onCopy;
  final void Function(String)? onCopySelection;

  const MessageContentWidget({
    super.key,
    required this.content,
    required this.textColor,
    this.selectable = true,
    this.fontSize,
    this.onCopy,
    this.onCopySelection,
  });

  @override
  State<MessageContentWidget> createState() => _MessageContentWidgetState();
}

class _MessageContentWidgetState extends State<MessageContentWidget> {
  String? _selectedText;

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
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, size: 20),
              SizedBox(width: 8),
              Text('Copy'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'copy_all',
          child: Row(
            children: [
              Icon(Icons.select_all, size: 20),
              SizedBox(width: 8),
              Text('Copy All'),
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
    final hasMarkdown = _containsMarkdown(widget.content);

    Widget contentWidget;
    
    // If content has HTML, use HTML renderer (it handles mixed content better)
    if (hasHtml) {
      contentWidget = _buildHtmlContent(context);
    }
    // If content has Markdown, use Markdown renderer
    else if (hasMarkdown) {
      contentWidget = _buildMarkdownContent(context);
    }
    // Plain text - use simple selectable text
    else {
      contentWidget = _buildPlainText(context);
    }

    // Wrap with gesture detector for context menu
    return GestureDetector(
      onSecondaryTapDown: (details) => _showContextMenu(context, details.globalPosition),
      onLongPressStart: (details) => _showContextMenu(context, details.globalPosition),
      child: contentWidget,
    );
  }

  Widget _buildHtmlContent(BuildContext context) {
    final effectiveFontSize = widget.fontSize ?? 14.0;
    
    return Html(
      data: widget.content,
      style: {
        '*': Style(
          color: widget.textColor,
          fontSize: FontSize(effectiveFontSize),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'p': Style(
          margin: Margins.only(bottom: 8),
        ),
        'b': Style(
          fontWeight: FontWeight.bold,
        ),
        'strong': Style(
          fontWeight: FontWeight.bold,
        ),
        'i': Style(
          fontStyle: FontStyle.italic,
        ),
        'em': Style(
          fontStyle: FontStyle.italic,
        ),
        'u': Style(
          textDecoration: TextDecoration.underline,
        ),
        's': Style(
          textDecoration: TextDecoration.lineThrough,
        ),
        'del': Style(
          textDecoration: TextDecoration.lineThrough,
        ),
        'code': Style(
          backgroundColor: AppTheme.darkBackground.withValues(alpha: 0.5),
          fontFamily: 'monospace',
          fontSize: FontSize(effectiveFontSize * 0.9),
          padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
        ),
        'pre': Style(
          backgroundColor: AppTheme.darkBackground.withValues(alpha: 0.5),
          padding: HtmlPaddings.all(12),
          margin: Margins.symmetric(vertical: 8),
        ),
        'blockquote': Style(
          border: Border(
            left: BorderSide(
              color: AppTheme.primaryColor,
              width: 3,
            ),
          ),
          padding: HtmlPaddings.only(left: 12),
          margin: Margins.symmetric(vertical: 8),
          fontStyle: FontStyle.italic,
          color: AppTheme.textSecondary,
        ),
        'a': Style(
          color: AppTheme.primaryColor,
          textDecoration: TextDecoration.underline,
        ),
        'h1': Style(
          fontSize: FontSize(effectiveFontSize * 1.8),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 16, bottom: 8),
        ),
        'h2': Style(
          fontSize: FontSize(effectiveFontSize * 1.5),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 14, bottom: 6),
        ),
        'h3': Style(
          fontSize: FontSize(effectiveFontSize * 1.3),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 12, bottom: 4),
        ),
        'h4': Style(
          fontSize: FontSize(effectiveFontSize * 1.1),
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 10, bottom: 4),
        ),
        'ul': Style(
          margin: Margins.only(left: 16, top: 4, bottom: 4),
        ),
        'ol': Style(
          margin: Margins.only(left: 16, top: 4, bottom: 4),
        ),
        'li': Style(
          margin: Margins.only(bottom: 2),
        ),
        'hr': Style(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.darkDivider,
              width: 1,
            ),
          ),
          margin: Margins.symmetric(vertical: 12),
        ),
        'mark': Style(
          backgroundColor: Colors.yellow.withValues(alpha: 0.3),
        ),
        'sub': Style(
          fontSize: FontSize(effectiveFontSize * 0.75),
          verticalAlign: VerticalAlign.sub,
        ),
        'sup': Style(
          fontSize: FontSize(effectiveFontSize * 0.75),
          verticalAlign: VerticalAlign.sup,
        ),
        'small': Style(
          fontSize: FontSize(effectiveFontSize * 0.85),
        ),
        'center': Style(
          textAlign: TextAlign.center,
        ),
      },
      onLinkTap: (url, _, __) {
        if (url != null) {
          _launchUrl(url);
        }
      },
    );
  }

  Widget _buildMarkdownContent(BuildContext context) {
    final effectiveFontSize = widget.fontSize ?? 14.0;
    
    return SelectionArea(
      onSelectionChanged: (selection) {
        _selectedText = selection?.plainText;
      },
      child: MarkdownBody(
        data: widget.content,
        selectable: widget.selectable,
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