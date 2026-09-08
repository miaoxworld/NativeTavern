import 'package:flutter/services.dart';

/// One file discovered in the private iCloud sync folder.
class ICloudSyncQueryItem {
  final String name;
  final String path;
  final bool downloaded;

  const ICloudSyncQueryItem({
    required this.name,
    required this.path,
    this.downloaded = false,
  });
}

/// Result of an NSMetadataQuery over the private ubiquity data scope.
class ICloudSyncQueryResult {
  final bool completed;
  final String? directory;
  final List<ICloudSyncQueryItem> files;

  const ICloudSyncQueryResult({
    required this.completed,
    this.directory,
    this.files = const [],
  });

  ICloudSyncQueryItem? itemNamed(String name) {
    for (final file in files) {
      if (file.name == name) return file;
    }
    return null;
  }
}

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

  /// Discover sync files that may not be materialized locally yet.
  Future<ICloudSyncQueryResult?> querySyncFiles() async {
    try {
      final raw = await _channel.invokeMethod<dynamic>('querySyncFiles');
      if (raw is! Map) return null;
      final files = <ICloudSyncQueryItem>[];
      final rawFiles = raw['files'];
      if (rawFiles is List) {
        for (final entry in rawFiles) {
          if (entry is! Map) continue;
          final name = entry['name'] as String?;
          final path = entry['path'] as String?;
          if (name == null || path == null || path.isEmpty) continue;
          files.add(
            ICloudSyncQueryItem(
              name: name,
              path: path,
              downloaded: entry['downloaded'] as bool? ?? false,
            ),
          );
        }
      }
      return ICloudSyncQueryResult(
        completed: raw['completed'] as bool? ?? false,
        directory: raw['directory'] as String?,
        files: files,
      );
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<bool> prefetchSyncFiles() async {
    try {
      final result = await _channel.invokeMethod<bool>('prefetchSyncFiles');
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
