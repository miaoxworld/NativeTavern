import 'dart:io';
import 'package:flutter/material.dart';
import 'package:native_tavern/core/utils/path_utils.dart';

/// Widget that displays character avatar image
/// Handles both absolute and relative paths for mobile compatibility
class CharacterAvatarImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final Widget Function(BuildContext, Object?, StackTrace?)? errorBuilder;

  const CharacterAvatarImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: PathUtils.toAbsolutePath(imagePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final file = File(snapshot.data!);
          return Image.file(
            file,
            fit: fit,
            errorBuilder: errorBuilder,
          );
        } else if (snapshot.hasError) {
          // Path resolution failed, try original path as fallback
          final file = File(imagePath);
          return Image.file(
            file,
            fit: fit,
            errorBuilder: errorBuilder,
          );
        } else {
          // Loading
          return Container(
            color: Colors.grey[800],
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
      },
    );
  }
}

/// Circular avatar variant
class CharacterAvatarCircle extends StatelessWidget {
  final String imagePath;
  final double radius;
  final Widget Function(BuildContext, Object?, StackTrace?)? errorBuilder;

  const CharacterAvatarCircle({
    super.key,
    required this.imagePath,
    this.radius = 28,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: radius * 2,
      child: ClipOval(
        child: CharacterAvatarImage(
          imagePath: imagePath,
          errorBuilder: errorBuilder ??
              (_, __, ___) => CircleAvatar(
                    radius: radius,
                    child: const Icon(Icons.person),
                  ),
        ),
      ),
    );
  }
}

/// Background image variant
class CharacterBackgroundImage extends StatelessWidget {
  final String imagePath;
  final Widget Function(BuildContext, Object?, StackTrace?)? errorBuilder;

  const CharacterBackgroundImage({
    super.key,
    required this.imagePath,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: PathUtils.toAbsolutePath(imagePath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final file = File(snapshot.data!);
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder:
                errorBuilder ?? (_, __, ___) => Container(color: Colors.black),
          );
        } else if (snapshot.hasError) {
          final file = File(imagePath);
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder:
                errorBuilder ?? (_, __, ___) => Container(color: Colors.black),
          );
        } else {
          return Container(color: Colors.black);
        }
      },
    );
  }
}
