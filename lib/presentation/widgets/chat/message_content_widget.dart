import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/chat/html_webview_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

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
  final VoidCallback? onLongPress;
  /// Whether the message is currently being streamed (AI is still generating)
  /// When true, WebView will not be used even for complex HTML to avoid rendering issues
  final bool isStreaming;

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
    final hasMarkdown = _containsMarkdown(widget.content);

    Widget contentWidget;
    
    // If content has complex HTML (flexbox, grid, shadows, etc.) AND streaming is complete,
    // use WebView for full CSS support. During streaming, always use flutter_html to avoid
    // rendering issues with constantly updating content.
    if (hasHtml && !widget.isStreaming && isComplexHtml(widget.content)) {
      contentWidget = HtmlWebViewWidget(
        htmlContent: widget.content,
        textColor: widget.textColor,
        fontSize: widget.fontSize,
        onLongPress: widget.onLongPress,
      );
    }
    // If content has HTML (simple or streaming), use flutter_html renderer
    else if (hasHtml) {
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
        'div': Style(
          margin: Margins.only(bottom: 12),
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
        'img': Style(
          width: Width(100, Unit.percent),
          margin: Margins.symmetric(vertical: 8),
        ),
      },
      extensions: [
        // Custom image extension for better image handling with CachedNetworkImage
        ImageExtension(
          builder: (extensionContext) {
            final src = extensionContext.attributes['src'];
            if (src == null || src.isEmpty) {
              return const SizedBox.shrink();
            }
            
            // Parse style attribute for dimensions
            final style = extensionContext.attributes['style'] ?? '';
            double? width;
            double? height;
            
            // Extract width from style
            final widthMatch = RegExp(r'width:\s*(\d+)').firstMatch(style);
            if (widthMatch != null) {
              width = double.tryParse(widthMatch.group(1) ?? '');
            }
            
            // Extract height from style
            final heightMatch = RegExp(r'height:\s*(\d+)').firstMatch(style);
            if (heightMatch != null) {
              height = double.tryParse(heightMatch.group(1) ?? '');
            }
            
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: src,
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: width ?? double.infinity,
                  height: height ?? 150,
                  color: AppTheme.darkBackground,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: width ?? double.infinity,
                  height: height ?? 150,
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
            );
          },
        ),
      ],
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