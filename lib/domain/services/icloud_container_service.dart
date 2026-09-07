import 'package:flutter/services.dart';

/// Native iCloud container access (iOS / macOS).
///
/// Auto-sync lives in the private ubiquity Library folder so it is not shown
/// in the Files app. Day-to-day sync uses Apple's Cloud Documents daemon,
/// not a user-picked Files location.
class ICloudContainerService {
  static const _channel = MethodChannel('com.nativetavern/icloud');
  static const defaultContainerId = 'iCloud.com.miaomiaoxworld.nativetavern';

  const ICloudContainerService();

  Future<bool> isAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<String?> getContainerDocumentsPath() async {
    return getSyncDirectoryPath();
  }

  Future<String?> getSyncDirectoryPath() async {
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

  Future<bool> hasUnresolvedConflicts(String filePath) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'hasConflicts',
        {'path': filePath},
      );
      return result ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> keepCurrentVersion(String filePath) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'keepCurrentVersion',
        {'path': filePath},
      );
      return result ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
