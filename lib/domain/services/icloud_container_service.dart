import 'package:flutter/services.dart';

/// Native iCloud Documents container access (iOS / macOS).
///
/// Dart cannot resolve the ubiquity container URL on its own. The iOS
/// `FileManager.url(forUbiquityContainerIdentifier:)` API is required for
/// cross-device iCloud Drive syncing.
class ICloudContainerService {
  static const _channel = MethodChannel('com.nativetavern/icloud');
  static const defaultContainerId = 'iCloud.com.miaomiaoxworld.nativetavern';

  const ICloudContainerService();

  Future<String?> getContainerDocumentsPath() async {
    try {
      final path = await _channel.invokeMethod<String>('getContainerPath');
      if (path == null || path.isEmpty) return null;
      return path;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> ensureDownloaded(String filePath) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'ensureDownloaded',
        {'path': filePath},
      );
      return result ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> copyIntoContainer({
    required String sourcePath,
    required String fileName,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'copyFile',
        {
          'sourcePath': sourcePath,
          'fileName': fileName,
        },
      );
      return result ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
