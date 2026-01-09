import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/chat_background.dart';
import '../../providers/background_providers.dart';

/// Widget that renders a chat background
class ChatBackgroundWidget extends ConsumerWidget {
  final String? characterId;
  final Widget child;

  const ChatBackgroundWidget({
    super.key,
    this.characterId,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final background = ref.watch(effectiveBackgroundProvider(characterId));

    if (background.type == BackgroundType.none) {
      return child;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _BackgroundRenderer(background: background),
        child,
      ],
    );
  }
}

class _BackgroundRenderer extends StatelessWidget {
  final ChatBackground background;

  const _BackgroundRenderer({required this.background});

  @override
  Widget build(BuildContext context) {
    Widget backgroundWidget;

    switch (background.type) {
      case BackgroundType.none:
        return const SizedBox.shrink();

      case BackgroundType.color:
        backgroundWidget = Container(
          color: _parseColor(background.color),
        );
        break;

      case BackgroundType.gradient:
        backgroundWidget = Container(
          decoration: BoxDecoration(
            gradient: _buildGradient(),
          ),
        );
        break;

      case BackgroundType.image:
        backgroundWidget = _buildImageBackground();
        break;
    }

    // Apply opacity
    if (background.opacity < 1.0) {
      backgroundWidget = Opacity(
        opacity: background.opacity,
        child: backgroundWidget,
      );
    }

    // Apply blur
    if (background.blur && background.blurAmount > 0) {
      backgroundWidget = Stack(
        fit: StackFit.expand,
        children: [
          backgroundWidget,
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: background.blurAmount,
              sigmaY: background.blurAmount,
            ),
            child: Container(color: Colors.transparent),
          ),
        ],
      );
    }

    return backgroundWidget;
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent;
    }

    String hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  LinearGradient _buildGradient() {
    final colors = background.gradientColors ?? ['#000000', '#333333'];
    final angle = background.gradientAngle ?? 180;

    // Convert angle to alignment
    final radians = angle * (3.14159 / 180);
    final begin = Alignment(
      -1 * (radians.isNaN ? 0 : (radians / 3.14159).abs() > 1 ? 0 : -1 * (radians / 3.14159).abs()),
      -1,
    );
    final end = Alignment(
      1 * (radians.isNaN ? 0 : (radians / 3.14159).abs() > 1 ? 0 : 1 * (radians / 3.14159).abs()),
      1,
    );

    return LinearGradient(
      begin: _angleToAlignment(angle),
      end: _angleToAlignment(angle + 180),
      colors: colors.map(_parseColor).toList(),
    );
  }

  Alignment _angleToAlignment(double angle) {
    // Normalize angle to 0-360
    angle = angle % 360;
    if (angle < 0) angle += 360;

    // Convert to radians
    final radians = angle * (3.14159 / 180);

    // Calculate x and y components
    final x = (radians - 1.5708).abs() < 0.01 ? 0.0 : -1 * (radians / 3.14159 - 0.5).clamp(-1.0, 1.0);
    final y = (radians).abs() < 0.01 || (radians - 3.14159).abs() < 0.01 ? 0.0 : -1 * ((radians - 1.5708) / 1.5708).clamp(-1.0, 1.0);

    // Simplified angle to alignment mapping
    if (angle >= 0 && angle < 45) return Alignment.topCenter;
    if (angle >= 45 && angle < 90) return Alignment.topRight;
    if (angle >= 90 && angle < 135) return Alignment.centerRight;
    if (angle >= 135 && angle < 180) return Alignment.bottomRight;
    if (angle >= 180 && angle < 225) return Alignment.bottomCenter;
    if (angle >= 225 && angle < 270) return Alignment.bottomLeft;
    if (angle >= 270 && angle < 315) return Alignment.centerLeft;
    return Alignment.topLeft;
  }

  Widget _buildImageBackground() {
    if (background.imagePath != null && background.imagePath!.isNotEmpty) {
      final file = File(background.imagePath!);
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: Colors.black);
        },
      );
    }

    if (background.imageUrl != null && background.imageUrl!.isNotEmpty) {
      return Image.network(
        background.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: Colors.black);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    }

    return Container(color: Colors.black);
  }
}

/// Preview widget for background selection
class BackgroundPreview extends StatelessWidget {
  final ChatBackground background;
  final double size;
  final bool selected;
  final VoidCallback? onTap;

  const BackgroundPreview({
    super.key,
    required this.background,
    this.size = 60,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
              : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildPreview(),
      ),
    );
  }

  Widget _buildPreview() {
    switch (background.type) {
      case BackgroundType.none:
        return Container(
          color: Colors.grey[900],
          child: const Center(
            child: Icon(Icons.block, color: Colors.grey),
          ),
        );

      case BackgroundType.color:
        return Container(
          color: _parseColor(background.color),
        );

      case BackgroundType.gradient:
        final colors = background.gradientColors ?? ['#000000', '#333333'];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors.map(_parseColor).toList(),
            ),
          ),
        );

      case BackgroundType.image:
        if (background.imagePath != null) {
          return Image.file(
            File(background.imagePath!),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
          );
        }
        if (background.imageUrl != null) {
          return Image.network(
            background.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
          );
        }
        return Container(color: Colors.grey[800]);
    }
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent;
    }

    String hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}