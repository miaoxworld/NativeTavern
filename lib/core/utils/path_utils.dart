import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Utilities for handling file paths on mobile platforms
/// Mobile platforms (iOS/Android) have sandbox that changes root path on each app restart
/// We need to store relative paths and resolve them at runtime
class PathUtils {
  static const String _relativePath = 'NativeTavern';

  /// Get the base application documents directory
  static Future<String> getAppDocumentsPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }

  /// Get the NativeTavern data directory
  static Future<String> getDataPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dataPath = p.join(appDir.path, _relativePath);
    final dir = Directory(dataPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dataPath;
  }

  /// Convert absolute path to relative path (for storage)
  /// Returns path relative to NativeTavern folder
  static Future<String> toRelativePath(String absolutePath) async {
    final dataPath = await getDataPath();
    if (absolutePath.startsWith(dataPath)) {
      // Remove the data path prefix, keeping the relative part
      final relative = absolutePath.substring(dataPath.length);
      // Remove leading slash if present
      return relative.startsWith('/') || relative.startsWith('\\')
          ? relative.substring(1)
          : relative;
    }
    // If not in our data path, return as-is (shouldn't happen)
    return absolutePath;
  }

  /// Convert relative path to absolute path (for file access)
  /// Takes path relative to NativeTavern folder and returns full absolute path
  /// Also handles legacy absolute paths from old app versions
  static Future<String> toAbsolutePath(String relativePath) async {
    final dataPath = await getDataPath();

    // If already absolute, need to handle carefully
    if (p.isAbsolute(relativePath)) {
      final file = File(relativePath);
      if (await file.exists()) {
        return relativePath; // Already valid absolute path - use it
      }

      // File doesn't exist - this is likely an old absolute path from previous app launch
      // Extract the relative portion after 'NativeTavern'
      final pathParts = p.split(relativePath);

      // Find 'NativeTavern' in the path
      final nativeIndex = pathParts.indexOf(_relativePath);
      if (nativeIndex >= 0 && nativeIndex < pathParts.length - 1) {
        // Reconstruct relative path from NativeTavern folder onwards
        final relParts = pathParts.sublist(nativeIndex + 1);
        final newRelativePath = p.joinAll(relParts);
        final newAbsolutePath = p.join(dataPath, newRelativePath);

        // Check if file exists at new location
        if (await File(newAbsolutePath).exists()) {
          return newAbsolutePath;
        }
      }

      // Try common fallback patterns for avatar images
      final fileName = p.basename(relativePath);

      // Try in avatars folder
      final avatarPath = p.join(dataPath, 'avatars', fileName);
      if (await File(avatarPath).exists()) {
        return avatarPath;
      }

      // Try in backgrounds folder
      final bgPath = p.join(dataPath, 'backgrounds', fileName);
      if (await File(bgPath).exists()) {
        return bgPath;
      }

      // Try in sprites folder (check all character folders)
      final spritesDir = Directory(p.join(dataPath, 'sprites'));
      if (await spritesDir.exists()) {
        await for (final entity in spritesDir.list()) {
          if (entity is Directory) {
            final spritePath = p.join(entity.path, fileName);
            if (await File(spritePath).exists()) {
              return spritePath;
            }
          }
        }
      }

      // If nothing found, return the new path anyway (will show error in UI)
      return p.join(dataPath, 'avatars', fileName);
    }

    // Relative path - simply join with data path
    return p.join(dataPath, relativePath);
  }

  /// Normalize a path for storage (convert to relative if in our data directory)
  static Future<String> normalizePath(String path) async {
    if (!p.isAbsolute(path)) {
      return path; // Already relative
    }
    return await toRelativePath(path);
  }
}
