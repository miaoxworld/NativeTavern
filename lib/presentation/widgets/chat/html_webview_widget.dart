import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget that renders HTML content using a WebView for full CSS support
///
/// This widget uses flutter_inappwebview to render complex HTML content
/// with full CSS support including flexbox, grid, shadows, transitions, etc.
class HtmlWebViewWidget extends StatefulWidget {
  final String htmlContent;
  final Color backgroundColor;
  final Color textColor;
  final double? fontSize;
  final VoidCallback? onLongPress;

  const HtmlWebViewWidget({
    super.key,
    required this.htmlContent,
    this.backgroundColor = Colors.transparent,
    this.textColor = AppTheme.textPrimary,
    this.fontSize,
    this.onLongPress,
  });

  @override
  State<HtmlWebViewWidget> createState() => _HtmlWebViewWidgetState();
}

class _HtmlWebViewWidgetState extends State<HtmlWebViewWidget> {
  double _contentHeight = 300; // Initial height - larger default
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto-hide loading after timeout
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = widget.fontSize ?? 14.0;
    final textColorHex = _colorToHex(widget.textColor);
    // Use dark background for better visibility
    const bgColorHex = 'transparent';
    
    // Wrap HTML content with proper styling
    final fullHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * {
      box-sizing: border-box;
      -webkit-tap-highlight-color: transparent;
    }
    html, body {
      margin: 0;
      padding: 8px;
      background-color: $bgColorHex;
      color: $textColorHex;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: ${effectiveFontSize}px;
      line-height: 1.5;
      overflow-x: hidden;
      word-wrap: break-word;
    }
    img {
      max-width: 100%;
      height: auto;
      border-radius: 8px;
      display: block;
    }
    a {
      color: #7C4DFF;
      text-decoration: underline;
    }
    h1, h2, h3, h4, h5, h6 {
      margin-top: 0.5em;
      margin-bottom: 0.3em;
      font-weight: bold;
    }
    h1 { font-size: 1.8em; }
    h2 { font-size: 1.5em; }
    h3 { font-size: 1.3em; }
    h4 { font-size: 1.1em; }
    p {
      margin: 0 0 0.5em 0;
    }
    /* Support for card-like divs */
    div[style*="border"] {
      overflow: hidden;
    }
    /* Dark theme scrollbar */
    ::-webkit-scrollbar {
      width: 6px;
      height: 6px;
    }
    ::-webkit-scrollbar-track {
      background: transparent;
    }
    ::-webkit-scrollbar-thumb {
      background: rgba(255,255,255,0.2);
      border-radius: 3px;
    }
  </style>
</head>
<body>
${widget.htmlContent}
<script>
  // Send content height to Flutter after rendering
  function sendHeight() {
    try {
      const height = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);
      if (window.flutter_inappwebview) {
        window.flutter_inappwebview.callHandler('contentHeight', height);
      }
    } catch (e) {
      console.error('Error sending height:', e);
    }
  }
  
  // Wait for all images to load before measuring height
  function waitForImages() {
    const images = document.querySelectorAll('img');
    if (images.length === 0) {
      sendHeight();
      return;
    }
    
    let loadedCount = 0;
    const totalImages = images.length;
    
    function checkAllLoaded() {
      loadedCount++;
      if (loadedCount >= totalImages) {
        // All images loaded, send height
        setTimeout(sendHeight, 100);
      }
    }
    
    images.forEach(function(img) {
      if (img.complete) {
        checkAllLoaded();
      } else {
        img.onload = checkAllLoaded;
        img.onerror = checkAllLoaded; // Count errors too to avoid hanging
      }
    });
    
    // Fallback: send height after timeout even if images haven't loaded
    setTimeout(sendHeight, 5000);
  }
  
  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', waitForImages);
  } else {
    waitForImages();
  }
  
  // Also send height after window load (includes all resources)
  window.onload = function() {
    setTimeout(sendHeight, 100);
    setTimeout(sendHeight, 500);
  };
  
  // Periodic height updates for dynamic content
  setTimeout(sendHeight, 1000);
  setTimeout(sendHeight, 2000);
  setTimeout(sendHeight, 3000);
</script>
</body>
</html>
''';

    if (_hasError) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: Colors.orange),
            const SizedBox(height: 8),
            Text(
              'Failed to render HTML content',
              style: TextStyle(color: widget.textColor),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
          ],
        ),
      );
    }

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _contentHeight,
        child: Stack(
          children: [
            InAppWebView(
              initialData: InAppWebViewInitialData(
                data: fullHtml,
                mimeType: 'text/html',
                encoding: 'utf-8',
                baseUrl: WebUri('about:blank'),
              ),
              initialSettings: InAppWebViewSettings(
                transparentBackground: true,
                disableHorizontalScroll: true,
                disableVerticalScroll: false, // Allow vertical scroll for long content
                supportZoom: false,
                javaScriptEnabled: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                useShouldOverrideUrlLoading: true,
                // iOS specific settings
                allowsBackForwardNavigationGestures: false,
                iframeAllowFullscreen: false,
              ),
              onWebViewCreated: (controller) {
                debugPrint('🌐 WebView created');
                // Add JavaScript handler for content height
                controller.addJavaScriptHandler(
                  handlerName: 'contentHeight',
                  callback: (args) {
                    debugPrint('🌐 Received height: $args');
                    if (args.isNotEmpty && mounted) {
                      final height = (args[0] as num).toDouble();
                      if (height > 0) {
                        setState(() {
                          _contentHeight = height + 32; // Add padding
                          _isLoading = false;
                        });
                      }
                    }
                  },
                );
              },
              onLoadStart: (controller, url) {
                debugPrint('🌐 WebView load start: $url');
              },
              onLoadStop: (controller, url) async {
                debugPrint('🌐 WebView load stop: $url');
                if (mounted) {
                  setState(() => _isLoading = false);
                }
                // Trigger height calculation
                await controller.evaluateJavascript(source: 'sendHeight();');
              },
              onLoadError: (controller, url, code, message) {
                debugPrint('🌐 WebView error: $code - $message');
                if (mounted) {
                  setState(() {
                    _hasError = true;
                    _errorMessage = message;
                    _isLoading = false;
                  });
                }
              },
              onConsoleMessage: (controller, consoleMessage) {
                debugPrint('🌐 Console: ${consoleMessage.message}');
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url;
                if (url != null && url.toString() != 'about:blank') {
                  // Open external links in browser
                  final uri = Uri.tryParse(url.toString());
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: AppTheme.darkCard,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(strokeWidth: 2),
                        SizedBox(height: 8),
                        Text(
                          'Loading content...',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _colorToHex(Color color) {
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    return 'rgba($r, $g, $b, ${color.a})';
  }
}

/// Check if HTML content is complex enough to warrant WebView rendering
bool isComplexHtml(String html) {
  // Check for complex CSS features that flutter_html doesn't support well
  final complexPatterns = [
    RegExp(r'display:\s*flex', caseSensitive: false),
    RegExp(r'display:\s*grid', caseSensitive: false),
    RegExp(r'box-shadow:', caseSensitive: false),
    RegExp(r'transition:', caseSensitive: false),
    RegExp(r'transform:', caseSensitive: false),
    RegExp(r'animation:', caseSensitive: false),
    RegExp(r'@keyframes', caseSensitive: false),
    RegExp(r'object-fit:', caseSensitive: false),
    RegExp(r'background:\s*linear-gradient', caseSensitive: false),
    RegExp(r'background:\s*radial-gradient', caseSensitive: false),
  ];
  
  for (final pattern in complexPatterns) {
    if (pattern.hasMatch(html)) {
      return true;
    }
  }
  
  // Check for multiple nested divs with styles (likely a complex layout)
  final styledDivCount = RegExp(r'<div[^>]*style="[^"]*"[^>]*>', caseSensitive: false)
      .allMatches(html)
      .length;
  if (styledDivCount >= 3) {
    return true;
  }
  
  return false;
}