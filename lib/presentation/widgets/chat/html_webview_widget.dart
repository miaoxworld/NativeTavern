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
  /// Unique key to force rebuild when content changes significantly
  final String? contentKey;

  const HtmlWebViewWidget({
    super.key,
    required this.htmlContent,
    this.backgroundColor = Colors.transparent,
    this.textColor = AppTheme.textPrimary,
    this.fontSize,
    this.onLongPress,
    this.contentKey,
  });

  @override
  State<HtmlWebViewWidget> createState() => _HtmlWebViewWidgetState();
}

class _HtmlWebViewWidgetState extends State<HtmlWebViewWidget> {
  double _contentHeight = 100; // Initial height - start smaller, will expand
  final double _minHeight = 50; // Minimum height to prevent collapse
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  InAppWebViewController? _webViewController;
  int _heightUpdateCount = 0; // Track number of height updates
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    // Auto-hide loading after timeout
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void didUpdateWidget(HtmlWebViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If content key changed (e.g., streaming ended), reload content
    if (widget.contentKey != oldWidget.contentKey && widget.contentKey != null) {
      _reloadContent();
    }
  }

  void _reloadContent() async {
    if (_webViewController != null) {
      setState(() {
        _isLoading = true;
        _heightUpdateCount = 0;
        _imagesLoaded = false;
      });
      
      // Reload the WebView with updated content
      await _webViewController!.loadData(
        data: _buildHtml(),
        mimeType: 'text/html',
        encoding: 'utf-8',
        baseUrl: WebUri('about:blank'),
      );
    }
  }

  /// Request height update from JavaScript
  void _requestHeightUpdate() async {
    if (_webViewController != null && mounted) {
      try {
        await _webViewController!.evaluateJavascript(source: 'sendHeight();');
      } catch (e) {
        debugPrint('🌐 Error requesting height update: $e');
      }
    }
  }

  /// Build the complete HTML document
  String _buildHtml() {
    final effectiveFontSize = widget.fontSize ?? 14.0;
    final textColorHex = _colorToHex(widget.textColor);
    
    return '''
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
      background-color: transparent;
      color: $textColorHex;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
      font-size: ${effectiveFontSize}px;
      line-height: 1.5;
      overflow-x: hidden;
      overflow-y: hidden;
      word-wrap: break-word;
    }
    img {
      max-width: 100%;
      height: auto;
      border-radius: 8px;
      display: block;
      min-height: 50px;
      background: linear-gradient(90deg, rgba(60,60,60,0.3) 25%, rgba(80,80,80,0.3) 50%, rgba(60,60,60,0.3) 75%);
      background-size: 200% 100%;
      animation: imageLoading 1.5s infinite;
    }
    img[data-loaded="true"] {
      background: none;
      animation: none;
      min-height: auto;
    }
    @keyframes imageLoading {
      0% { background-position: 200% 0; }
      100% { background-position: -200% 0; }
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
    div[style*="border"] {
      overflow: hidden;
    }
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
  var heightSent = false;
  var lastSentHeight = 0;
  var allImagesLoaded = false;
  
  // Accurate height calculation
  function getContentHeight() {
    var bodyHeight = document.body.scrollHeight;
    var bodyOffset = document.body.offsetHeight;
    var bodyClient = document.body.clientHeight;
    var docHeight = document.documentElement.scrollHeight;
    var docOffset = document.documentElement.offsetHeight;
    
    var height = Math.max(bodyHeight, bodyOffset, bodyClient, docHeight, docOffset);
    
    // Check bounding boxes of all elements
    var allElements = document.querySelectorAll('*');
    for (var i = 0; i < allElements.length; i++) {
      var el = allElements[i];
      var rect = el.getBoundingClientRect();
      var elBottom = rect.bottom;
      if (elBottom > height) {
        height = elBottom;
      }
    }
    
    return Math.ceil(height);
  }
  
  // Send content height to Flutter
  function sendHeight() {
    try {
      var height = getContentHeight();
      if (!heightSent || Math.abs(height - lastSentHeight) > 5) {
        if (window.flutter_inappwebview) {
          console.log('Sending height: ' + height);
          window.flutter_inappwebview.callHandler('contentHeight', height);
          lastSentHeight = height;
          heightSent = true;
        }
      }
    } catch (e) {
      console.error('Error sending height:', e);
    }
  }
  
  // Notify Flutter when all images are loaded
  function notifyImagesLoaded() {
    if (!allImagesLoaded) {
      allImagesLoaded = true;
      try {
        if (window.flutter_inappwebview) {
          window.flutter_inappwebview.callHandler('imagesLoaded', true);
        }
      } catch (e) {
        console.error('Error notifying images loaded:', e);
      }
    }
  }
  
  // Force reload an image by resetting its src
  function forceReloadImage(img) {
    var src = img.src;
    if (src && src.length > 0 && !src.startsWith('data:')) {
      // Add cache-busting query parameter
      var separator = src.indexOf('?') > -1 ? '&' : '?';
      var newSrc = src + separator + '_t=' + Date.now();
      console.log('Force reloading image: ' + src);
      img.src = newSrc;
    }
  }
  
  // Check if an image is truly loaded and rendered
  function isImageReady(img) {
    // Check if it has actual dimensions
    if (!img.complete) return false;
    if (img.naturalWidth === 0 || img.naturalHeight === 0) return false;
    // Also check rendered dimensions
    var rect = img.getBoundingClientRect();
    return rect.width > 0 && rect.height > 0;
  }
  
  // Wait for all images to load with retries
  function waitForImages() {
    var images = document.querySelectorAll('img');
    console.log('Found ' + images.length + ' images to load');
    
    if (images.length === 0) {
      sendHeight();
      notifyImagesLoaded();
      return;
    }
    
    var loadedCount = 0;
    var totalImages = images.length;
    var retryAttempts = {};
    var maxRetries = 3;
    
    function imageLoaded(img, index) {
      loadedCount++;
      img.setAttribute('data-loaded', 'true');
      console.log('Image ' + index + ' loaded (' + loadedCount + '/' + totalImages + ')');
      setTimeout(sendHeight, 50);
      
      if (loadedCount >= totalImages) {
        console.log('All images loaded!');
        setTimeout(function() {
          sendHeight();
          notifyImagesLoaded();
        }, 200);
      }
    }
    
    function checkImage(img, index) {
      if (isImageReady(img)) {
        imageLoaded(img, index);
      } else if (img.complete) {
        // Image claims to be complete but has no dimensions
        // This often happens with network images - try to reload
        retryAttempts[index] = (retryAttempts[index] || 0) + 1;
        if (retryAttempts[index] <= maxRetries) {
          console.log('Image ' + index + ' complete but not rendered, retry ' + retryAttempts[index]);
          setTimeout(function() {
            if (!isImageReady(img)) {
              forceReloadImage(img);
            } else {
              imageLoaded(img, index);
            }
          }, 500 * retryAttempts[index]);
        } else {
          console.log('Image ' + index + ' failed after retries');
          img.style.minHeight = '100px';
          img.style.backgroundColor = 'rgba(100,100,100,0.3)';
          img.style.animation = 'none';
          img.setAttribute('data-loaded', 'true');
          loadedCount++;
          setTimeout(sendHeight, 50);
          if (loadedCount >= totalImages) {
            setTimeout(function() {
              sendHeight();
              notifyImagesLoaded();
            }, 200);
          }
        }
      } else {
        // Image is still loading
        img.onload = function() {
          setTimeout(function() {
            if (isImageReady(img)) {
              imageLoaded(img, index);
            } else {
              checkImage(img, index);
            }
          }, 100);
        };
        img.onerror = function() {
          console.log('Image ' + index + ' error');
          this.style.display = 'none';
          imageLoaded(img, index);
        };
      }
    }
    
    images.forEach(function(img, index) {
      checkImage(img, index);
    });
    
    // Final fallback
    setTimeout(function() {
      if (!allImagesLoaded) {
        console.log('Fallback: forcing completion after timeout');
        sendHeight();
        notifyImagesLoaded();
      }
    }, 8000);
  }
  
  // Periodic check for unloaded images
  function checkUnloadedImages() {
    var images = document.querySelectorAll('img');
    var unloaded = 0;
    images.forEach(function(img, index) {
      if (!isImageReady(img) && img.src && !img.src.startsWith('data:')) {
        unloaded++;
        console.log('Image ' + index + ' still not loaded: ' + img.src.substring(0, 50));
      }
    });
    if (unloaded > 0) {
      console.log(unloaded + ' images still unloaded');
    }
    return unloaded;
  }
  
  // Initial height calculation
  function init() {
    sendHeight();
    waitForImages();
    
    // Progressive height updates
    setTimeout(sendHeight, 100);
    setTimeout(sendHeight, 300);
    setTimeout(sendHeight, 500);
    setTimeout(sendHeight, 1000);
    setTimeout(function() {
      sendHeight();
      checkUnloadedImages();
    }, 2000);
    setTimeout(function() {
      sendHeight();
      checkUnloadedImages();
    }, 4000);
  }
  
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
  
  window.onload = function() {
    setTimeout(sendHeight, 100);
    setTimeout(sendHeight, 500);
  };
</script>
</body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    final fullHtml = _buildHtml();

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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        constraints: BoxConstraints(
          minHeight: _minHeight,
        ),
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
                disableVerticalScroll: true, // Disable scroll, we adjust container height
                supportZoom: false,
                javaScriptEnabled: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                useShouldOverrideUrlLoading: true,
                allowsBackForwardNavigationGestures: false,
                iframeAllowFullscreen: false,
              ),
              onWebViewCreated: (controller) {
                debugPrint('🌐 WebView created');
                _webViewController = controller;
                
                // Handler for content height updates
                controller.addJavaScriptHandler(
                  handlerName: 'contentHeight',
                  callback: (args) {
                    debugPrint('🌐 Received height: $args (update #$_heightUpdateCount)');
                    if (args.isNotEmpty && mounted) {
                      final height = (args[0] as num).toDouble();
                      // Validate height - must be positive and reasonable
                      if (height > 10) {
                        final newHeight = height + 24; // Add padding
                        // Only update if height increased or this is the first few updates
                        if (newHeight > _contentHeight || _heightUpdateCount < 5) {
                          setState(() {
                            _contentHeight = newHeight;
                            _heightUpdateCount++;
                            _isLoading = false;
                          });
                        }
                      }
                    }
                  },
                );
                
                // Handler for images loaded notification
                controller.addJavaScriptHandler(
                  handlerName: 'imagesLoaded',
                  callback: (args) {
                    debugPrint('🌐 Images loaded notification received');
                    if (mounted && !_imagesLoaded) {
                      setState(() {
                        _imagesLoaded = true;
                      });
                      // Request final height update after images loaded
                      Future.delayed(const Duration(milliseconds: 200), () {
                        _requestHeightUpdate();
                      });
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
                
                // Additional height checks after load
                Future.delayed(const Duration(milliseconds: 300), _requestHeightUpdate);
                Future.delayed(const Duration(milliseconds: 800), _requestHeightUpdate);
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