import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget to display images extracted from text content
class ExtractedImagesWidget extends ConsumerWidget {
  final String text;
  final double maxHeight;
  final EdgeInsets padding;

  const ExtractedImagesWidget({
    super.key,
    required this.text,
    this.maxHeight = 300,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(appSettingsProvider).enableEmbeddedImages) {
      return const SizedBox.shrink();
    }
    final urls = ImageGenerationService.extractImageUrls(text);

    // Filter out URLs that are already in Markdown image syntax (they will be rendered by markdown)
    final standAloneUrls = urls.where((url) {
      // Skip if URL is part of Markdown image syntax
      if (text.contains('![$url') || text.contains('($url)')) return false;
      // Skip data URLs (they're embedded)
      if (url.startsWith('data:')) return false;
      return true;
    }).toList();

    if (standAloneUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final url in standAloneUrls)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildImageCard(context, url),
            ),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, String url) {
    return GestureDetector(
      onTap: () => _openFullScreen(context, url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: AppTheme.darkBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(
              height: 200,
              color: AppTheme.darkBackground,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(strokeWidth: 2),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).loadingImage,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 100,
              color: AppTheme.darkBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.broken_image, color: AppTheme.textMuted),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).imageLoadFailed,
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () async {
                      final uri = Uri.tryParse(url);
                      if (uri != null) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(AppLocalizations.of(context).openInBrowser),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => _FullScreenImageDialog(imageUrl: url),
    );
  }
}

/// Full screen image viewer dialog
class _FullScreenImageDialog extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageDialog({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Dismiss on tap background
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black87),
          ),
          // Image with zoom
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child:
                      Icon(Icons.broken_image, color: Colors.white, size: 64),
                ),
              ),
            ),
          ),
          // Close button
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Open in browser button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton.icon(
                icon: const Icon(Icons.open_in_new, color: Colors.white),
                label: Text(
                  AppLocalizations.of(context).openInBrowser,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final uri = Uri.tryParse(imageUrl);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Provider for checking if text contains extractable image URLs
final hasExtractableImagesProvider = Provider.family<bool, String>((ref, text) {
  final urls = ImageGenerationService.extractImageUrls(text);
  // Filter out markdown/html embedded images
  return urls.any((url) {
    if (text.contains('![$url') || text.contains('($url)')) return false;
    if (url.startsWith('data:')) return false;
    return true;
  });
});
