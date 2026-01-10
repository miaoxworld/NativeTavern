import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/sprite.dart';
import 'package:native_tavern/presentation/providers/sprite_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Widget for displaying character expression sprites
class SpriteDisplay extends ConsumerWidget {
  final String characterId;
  final String messageContent;
  final bool isStreaming;

  const SpriteDisplay({
    super.key,
    required this.characterId,
    required this.messageContent,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(spriteSettingsProvider);
    
    // Don't show if disabled
    if (!settings.enabled) return const SizedBox.shrink();
    
    // Don't show during streaming if setting is off
    if (isStreaming && !settings.showDuringStreaming) {
      return const SizedBox.shrink();
    }

    final spriteAsync = ref.watch(
      messageSpriteProvider(MessageSpriteParams(
        characterId: characterId,
        messageContent: messageContent,
      )),
    );

    return spriteAsync.when(
      data: (sprite) {
        if (sprite == null) return const SizedBox.shrink();
        return _SpriteImage(
          sprite: sprite,
          settings: settings,
          isStreaming: isStreaming,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Internal widget for displaying the sprite image
class _SpriteImage extends StatefulWidget {
  final Sprite sprite;
  final SpriteSettings settings;
  final bool isStreaming;

  const _SpriteImage({
    required this.sprite,
    required this.settings,
    required this.isStreaming,
  });

  @override
  State<_SpriteImage> createState() => _SpriteImageState();
}

class _SpriteImageState extends State<_SpriteImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String? _previousSpritePath;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.settings.transitionDurationMs),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
    _previousSpritePath = widget.sprite.imagePath;
  }

  @override
  void didUpdateWidget(_SpriteImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Animate when sprite changes
    if (widget.sprite.imagePath != _previousSpritePath &&
        widget.settings.animateTransitions) {
      _controller.reset();
      _controller.forward();
      _previousSpritePath = widget.sprite.imagePath;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.sprite.imagePath);
    
    Widget imageWidget = Image.file(
      file,
      width: widget.settings.size,
      height: widget.settings.size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: widget.settings.size,
          height: widget.settings.size,
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(
              Icons.broken_image,
              color: AppTheme.textMuted,
            ),
          ),
        );
      },
    );

    // Apply opacity
    if (widget.settings.opacity < 1.0) {
      imageWidget = Opacity(
        opacity: widget.settings.opacity,
        child: imageWidget,
      );
    }

    // Apply animation if enabled
    if (widget.settings.animateTransitions) {
      imageWidget = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: imageWidget,
      );
    }

    // Add emotion label
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        imageWidget,
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.darkCard.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getEmotionDisplayName(widget.sprite.emotion),
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  String _getEmotionDisplayName(String emotion) {
    final spriteEmotion = SpriteEmotion.fromId(emotion);
    return spriteEmotion?.displayName ?? emotion;
  }
}

/// Floating sprite display that can be positioned anywhere on screen
class FloatingSpriteDisplay extends ConsumerWidget {
  final String characterId;
  final String messageContent;
  final bool isStreaming;

  const FloatingSpriteDisplay({
    super.key,
    required this.characterId,
    required this.messageContent,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(spriteSettingsProvider);
    
    if (!settings.enabled) return const SizedBox.shrink();
    if (isStreaming && !settings.showDuringStreaming) {
      return const SizedBox.shrink();
    }

    final spriteAsync = ref.watch(
      messageSpriteProvider(MessageSpriteParams(
        characterId: characterId,
        messageContent: messageContent,
      )),
    );

    return spriteAsync.when(
      data: (sprite) {
        if (sprite == null) return const SizedBox.shrink();
        
        return Positioned(
          left: settings.position == SpritePosition.floatingLeft ||
                  settings.position == SpritePosition.left
              ? 16
              : null,
          right: settings.position == SpritePosition.floatingRight ||
                  settings.position == SpritePosition.right
              ? 16
              : null,
          bottom: 100,
          child: _SpriteImage(
            sprite: sprite,
            settings: settings,
            isStreaming: isStreaming,
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Compact sprite display for message bubbles
class CompactSpriteDisplay extends ConsumerWidget {
  final String characterId;
  final String messageContent;
  final double size;

  const CompactSpriteDisplay({
    super.key,
    required this.characterId,
    required this.messageContent,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(spriteSettingsProvider);
    
    if (!settings.enabled) return const SizedBox.shrink();

    final spriteAsync = ref.watch(
      messageSpriteProvider(MessageSpriteParams(
        characterId: characterId,
        messageContent: messageContent,
      )),
    );

    return spriteAsync.when(
      data: (sprite) {
        if (sprite == null) return const SizedBox.shrink();
        
        final file = File(sprite.imagePath);
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Sprite preview widget for settings/management screens
class SpritePreview extends StatelessWidget {
  final Sprite sprite;
  final double size;
  final bool showLabel;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const SpritePreview({
    super.key,
    required this.sprite,
    this.size = 80,
    this.showLabel = true,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(sprite.imagePath);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: AppTheme.accentColor, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    file,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: size,
                        height: size,
                        color: AppTheme.darkCard,
                        child: const Icon(
                          Icons.broken_image,
                          color: AppTheme.textMuted,
                        ),
                      );
                    },
                  ),
                ),
                if (onDelete != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (showLabel) ...[
              const SizedBox(height: 4),
              Text(
                _getEmotionDisplayName(sprite.emotion),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getEmotionDisplayName(String emotion) {
    final spriteEmotion = SpriteEmotion.fromId(emotion);
    return spriteEmotion?.displayName ?? emotion;
  }
}

/// Grid of all sprites for a character
class SpriteGrid extends ConsumerWidget {
  final String characterId;
  final String? selectedEmotion;
  final void Function(Sprite)? onSelect;
  final void Function(Sprite)? onDelete;

  const SpriteGrid({
    super.key,
    required this.characterId,
    this.selectedEmotion,
    this.onSelect,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packAsync = ref.watch(spritePackNotifierProvider(characterId));

    return packAsync.when(
      data: (pack) {
        if (!pack.hasSprites) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noSpritesAddedYet,
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
              ],
            ),
          );
        }

        final sprites = pack.sprites.values.toList();
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: sprites.length,
          itemBuilder: (context, index) {
            final sprite = sprites[index];
            return SpritePreview(
              sprite: sprite,
              isSelected: sprite.emotion == selectedEmotion,
              onTap: onSelect != null ? () => onSelect!(sprite) : null,
              onDelete: onDelete != null ? () => onDelete!(sprite) : null,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          '${AppLocalizations.of(context)!.errorLoadingSprites}: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}