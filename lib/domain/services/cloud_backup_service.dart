import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/domain/services/icloud_container_service.dart';

/// Cloud provider type
enum CloudProvider { googleDrive, iCloud }

/// Media is optional and stored separately from the database backup.
enum CloudMediaCategory {
  characterImages,
  worldInfoImages,
  conversationImages,
  backgrounds,
  live2d,
}

class CloudBackupOptions {
  final Set<CloudMediaCategory> mediaCategories;

  const CloudBackupOptions({this.mediaCategories = const {}});

  bool includes(CloudMediaCategory category) =>
      mediaCategories.contains(category);

  Map<String, dynamic> toJson() => {
        'mediaCategories':
            mediaCategories.map((category) => category.name).toList(),
      };
}

class CloudBackupArtifacts {
  final File dataFile;
  final File? mediaFile;
  final File? combinedFile;
  final int mediaFileCount;

  const CloudBackupArtifacts({
    required this.dataFile,
    this.mediaFile,
    this.combinedFile,
    this.mediaFileCount = 0,
  });
}

class ParsedBackupFile {
  final Map<String, dynamic> package;
  final List<int>? mediaBytes;
  final bool mediaExpected;

  const ParsedBackupFile({
    required this.package,
    this.mediaBytes,
    this.mediaExpected = false,
  });
}

enum CloudBackupArtifactStage { scanningMedia, compressingMedia, writingData }

class CloudBackupArtifactProgress {
  final CloudBackupArtifactStage stage;
  final int processedFiles;
  final int? totalFiles;

  const CloudBackupArtifactProgress({
    required this.stage,
    this.processedFiles = 0,
    this.totalFiles,
  });
}

enum CloudBackupTransferPart { data, media }

class CloudMediaRestoreOutcome {
  final Map<String, dynamic> backupPackage;
  final int restoredFiles;
  final int skippedFiles;
  final String? warning;

  const CloudMediaRestoreOutcome({
    required this.backupPackage,
    this.restoredFiles = 0,
    this.skippedFiles = 0,
    this.warning,
  });
}

extension CloudProviderExtension on CloudProvider {
  String get displayName {
    switch (this) {
      case CloudProvider.googleDrive:
        return 'Google Drive';
      case CloudProvider.iCloud:
        return 'iCloud';
    }
  }

  String get icon {
    switch (this) {
      case CloudProvider.googleDrive:
        return 'google_drive';
      case CloudProvider.iCloud:
        return 'icloud';
    }
  }
}

/// Cloud backup status
enum CloudBackupStatus { idle, syncing, uploading, downloading, success, error }

/// Cloud backup info
class CloudBackupInfo {
  final String id;
  final String name;
  final int size;
  final DateTime createdAt;
  final CloudProvider provider;
  final String? remotePath;

  const CloudBackupInfo({
    required this.id,
    required this.name,
    required this.size,
    required this.createdAt,
    required this.provider,
    this.remotePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'size': size,
        'createdAt': createdAt.toIso8601String(),
        'provider': provider.name,
        'remotePath': remotePath,
      };

  factory CloudBackupInfo.fromJson(Map<String, dynamic> json) {
    return CloudBackupInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      provider: CloudProvider.values.firstWhere(
        (p) => p.name == json['provider'],
        orElse: () => CloudProvider.googleDrive,
      ),
      remotePath: json['remotePath'] as String?,
    );
  }
}

/// Restore mode for database merge
enum RestoreMode {
  /// Replace all local data with backup data
  replace,

  /// Merge backup data with local data (keep both, newer wins for conflicts)
  merge,

  /// Skip existing items, only add new ones
  addNewOnly,
}

extension RestoreModeExtension on RestoreMode {
  String get displayName {
    switch (this) {
      case RestoreMode.replace:
        return 'Replace';
      case RestoreMode.merge:
        return 'Merge';
      case RestoreMode.addNewOnly:
        return 'Add New Only';
    }
  }

  String get description {
    switch (this) {
      case RestoreMode.replace:
        return 'Replace all local data with backup data';
      case RestoreMode.merge:
        return 'Merge backup with local data (newer wins for conflicts)';
      case RestoreMode.addNewOnly:
        return 'Only add new items from backup, keep all existing data';
    }
  }
}

/// Service for managing cloud backups (Google Drive and iCloud)
class CloudBackupService {
  /// Singleton instance
  static final CloudBackupService instance = CloudBackupService._();

  /// Stable filename used for automatic cross-device sync.
  static const syncBackupFileName = 'NativeTavern_sync.ntx';
  static const syncMetadataFileName = 'NativeTavern_sync.meta.json';

  CloudBackupService._({
    Future<Directory> Function()? documentsDirectoryProvider,
    ICloudContainerService? iCloudContainerService,
  })  : _documentsDirectoryProvider =
            documentsDirectoryProvider ?? getApplicationDocumentsDirectory,
        _iCloudContainer =
            iCloudContainerService ?? const ICloudContainerService();

  factory CloudBackupService.forTesting({
    required Directory documentsDirectory,
    ICloudContainerService? iCloudContainerService,
  }) {
    return CloudBackupService._(
      documentsDirectoryProvider: () async => documentsDirectory,
      iCloudContainerService: iCloudContainerService,
    );
  }

  final Future<Directory> Function() _documentsDirectoryProvider;
  final ICloudContainerService _iCloudContainer;
  String? lastMediaWarning;

  /// Get the cloud backups cache directory
  Future<Directory> getCloudCacheDirectory() async {
    final appDir = await _documentsDirectoryProvider();
    final cacheDir = Directory(
      path.join(appDir.path, 'NativeTavern', 'cloud_cache'),
    );
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  /// Get iCloud container directory (iOS/macOS only)
  Future<Directory?> getICloudDirectory() async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      return null;
    }

    try {
      final nativePath = await _iCloudContainer.getContainerDocumentsPath();
      if (nativePath != null && nativePath.isNotEmpty) {
        final nativeDir = Directory(nativePath);
        if (!await nativeDir.exists()) {
          await nativeDir.create(recursive: true);
        }
        return nativeDir;
      }

      // On iOS/macOS, iCloud container is accessible via file system
      // The ubiquity container path pattern for our app

      if (Platform.isMacOS) {
        final homeDir = Platform.environment['HOME'] ?? '';

        // First try the app container path (sandboxed app)
        // This is where the app can write to, and it syncs with iCloud
        final containerPath =
            '/Users/${homeDir.split('/').last}/Library/Containers/com.miaomiaoxworld.nativetavern/Data/Library/Mobile Documents/iCloud~com~miaomiaoxworld~nativetavern/Documents';
        final containerDir = Directory(containerPath);

        print(
          'CloudBackupService: Checking container iCloud path: $containerPath',
        );

        if (await containerDir.exists()) {
          print('CloudBackupService: Container iCloud directory exists');
          return containerDir;
        }

        // Try creating the container path
        try {
          await containerDir.create(recursive: true);
          print('CloudBackupService: Created container iCloud directory');
          return containerDir;
        } catch (e) {
          print(
            'CloudBackupService: Failed to create container iCloud directory: $e',
          );
        }

        // Fallback: Try the system-level iCloud path (non-sandboxed or for reading)
        final systemICloudPath = path.join(
          homeDir,
          'Library',
          'Mobile Documents',
          'iCloud~com~miaomiaoxworld~nativetavern',
          'Documents',
        );
        final systemICloudDir = Directory(systemICloudPath);

        print(
          'CloudBackupService: Checking system iCloud path: $systemICloudPath',
        );

        if (await systemICloudDir.exists()) {
          print('CloudBackupService: System iCloud directory exists');
          return systemICloudDir;
        }

        // Try creating system-level path (will fail if iCloud container not configured)
        try {
          await systemICloudDir.create(recursive: true);
          print('CloudBackupService: Created system iCloud directory');
          return systemICloudDir;
        } catch (e) {
          print(
            'CloudBackupService: Failed to create system iCloud directory: $e',
          );
        }
      }

      if (Platform.isIOS) {
        // On iOS, we need to use FileManager to get the ubiquity container URL
        // For now, we'll try a similar path structure
        final appDir = await getApplicationDocumentsDirectory();

        // Check if we can access the iCloud container
        // The path on iOS is typically: /private/var/mobile/Library/Mobile Documents/iCloud~<container>/Documents
        // But we need to use the proper API to get this path

        // Try parent directory approach for iOS
        final parentDir = appDir.parent;
        final iCloudPath = path.join(
          parentDir.path,
          'Library',
          'Mobile Documents',
          'iCloud~com~miaomiaoxworld~nativetavern',
          'Documents',
        );
        final iCloudDir = Directory(iCloudPath);

        if (await iCloudDir.exists()) {
          return iCloudDir;
        }

        try {
          await iCloudDir.create(recursive: true);
          return iCloudDir;
        } catch (e) {
          print(
            'CloudBackupService: Failed to create iOS iCloud directory: $e',
          );
        }
      }

      // Fallback: Return null to indicate iCloud is not available
      // This is better than using a local directory that won't sync
      print('CloudBackupService: iCloud not available, returning null');
      return null;
    } catch (e) {
      print('CloudBackupService: Error getting iCloud directory: $e');
      return null;
    }
  }

  /// Check if Google Drive is available (requires auth)
  Future<bool> isGoogleDriveAvailable() async {
    // Google Drive integration requires OAuth setup
    // For now, we'll use file picker to let user select Google Drive folder
    return true;
  }

  /// Check if iCloud is available
  Future<bool> isICloudAvailable() async {
    if (!Platform.isIOS && !Platform.isMacOS) {
      return false;
    }

    final dir = await getICloudDirectory();
    return dir != null;
  }

  /// Get detailed iCloud status for debugging
  Future<Map<String, dynamic>> getICloudStatus() async {
    final result = <String, dynamic>{
      'available': false,
      'path': null,
      'isSystemICloud': false,
      'message': 'iCloud not available',
    };

    if (!Platform.isIOS && !Platform.isMacOS) {
      result['message'] = 'iCloud is only available on iOS and macOS';
      return result;
    }

    final dir = await getICloudDirectory();
    if (dir != null) {
      result['available'] = true;
      result['path'] = dir.path;

      // Check if it's the system-level iCloud path (truly syncs) or just container path
      final homeDir = Platform.environment['HOME'] ?? '';
      final systemPath = '$homeDir/Library/Mobile Documents';
      final systemICloudExists = await Directory(systemPath).exists();

      if (dir.path.contains('/Containers/')) {
        result['isSystemICloud'] = false;
        if (systemICloudExists) {
          result['message'] =
              'Using app container iCloud path (will sync to iCloud)';
        } else {
          result['message'] =
              'Warning: iCloud Drive may not be enabled in System Settings. Backup is saved locally but may not sync to cloud.';
        }
      } else {
        result['isSystemICloud'] = true;
        result['message'] = 'Using system iCloud Drive (syncs to cloud)';
      }
    }

    return result;
  }

  /// Create a backup file for cloud upload
  Future<File> createCloudBackupFile({
    required Map<String, dynamic> data,
    required CloudProvider provider,
  }) async {
    final artifacts = await createCloudBackupArtifacts(
      data: data,
      provider: provider,
    );
    return artifacts.dataFile;
  }

  /// Creates the normal JSON backup and, when selected, an independent media
  /// sidecar. A sidecar failure never invalidates the JSON backup.
  Future<CloudBackupArtifacts> createCloudBackupArtifacts({
    required Map<String, dynamic> data,
    required CloudProvider provider,
    CloudBackupOptions options = const CloudBackupOptions(),
    void Function(CloudBackupArtifactProgress progress)? onProgress,
  }) async {
    lastMediaWarning = null;
    final cacheDir = await getCloudCacheDirectory();
    final fileName = cloudBackupFileName(extension: 'ntb');
    final filePath = path.join(cacheDir.path, fileName);
    final documents = await _documentsDirectoryProvider();
    final nativeData = Directory(path.join(documents.path, 'NativeTavern'));
    File? mediaFile;
    var mediaFileCount = 0;

    try {
      final media = await _createMediaSidecar(
        data: data,
        options: options,
        onProgress: onProgress,
        outputFile: File(
          path.join(
            cacheDir.path,
            '${path.basenameWithoutExtension(fileName)}.ntm',
          ),
        ),
      );
      mediaFile = media.$1;
      mediaFileCount = media.$2;
    } catch (error) {
      // The text backup is canonical and must remain usable by itself.
      print('CloudBackupService: Optional media backup failed: $error');
      lastMediaWarning =
          'The data backup succeeded, but media preparation failed.';
    }

    onProgress?.call(
      const CloudBackupArtifactProgress(
        stage: CloudBackupArtifactStage.writingData,
      ),
    );

    // Create backup package with metadata
    final backupPackage = {
      'version': 2,
      'app': 'NativeTavern',
      'createdAt': DateTime.now().toIso8601String(),
      'provider': provider.name,
      'data': _sanitizeBackupValue(data),
      'preferences': await _exportPreferences(),
      'textFiles': await _exportTextFiles(nativeData),
      'storageRoots': {
        'documents': documents.path,
        'nativeData': nativeData.path,
      },
      if (mediaFile != null)
        'media': {
          'fileName': path.basename(mediaFile.path),
          'optional': true,
          'fileCount': mediaFileCount,
          ...options.toJson(),
        },
    };

    final file = File(filePath);
    await file.writeAsString(jsonEncode(backupPackage));

    File? combinedFile;
    try {
      combinedFile = await packageCombinedBackup(
        dataFile: file,
        mediaFile: mediaFile,
        mediaFileCount: mediaFileCount,
      );
    } catch (error) {
      print('CloudBackupService: Combined .ntx package failed: $error');
    }

    return CloudBackupArtifacts(
      dataFile: file,
      mediaFile: mediaFile,
      combinedFile: combinedFile,
      mediaFileCount: mediaFileCount,
    );
  }

  /// Cloud-style backup file name used for local Backups and cloud copies.
  static String cloudBackupFileName({
    String extension = 'ntb',
    DateTime? now,
  }) {
    final timestamp =
        DateFormat('yyyy-MM-dd_HH-mm-ss').format(now ?? DateTime.now());
    final normalized = extension.startsWith('.') ? extension : '.$extension';
    return 'NativeTavern_cloud_backup_$timestamp$normalized';
  }

  /// `{documents}/NativeTavern/Backups`
  Future<Directory> getAppBackupsDirectory() async {
    final documents = await _documentsDirectoryProvider();
    final dir = Directory(
      path.join(documents.path, 'NativeTavern', 'Backups'),
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Packs the JSON `.ntb` backup and optional `.ntm` media sidecar into one
  /// `.ntx` zip that the system file handlers can open as a single artifact.
  Future<File> packageCombinedBackup({
    required File dataFile,
    File? mediaFile,
    int mediaFileCount = 0,
    File? outputFile,
  }) async {
    final archive = Archive();
    final dataBytes = await dataFile.readAsBytes();
    archive.addFile(ArchiveFile('data.ntb', dataBytes.length, dataBytes));

    String? mediaName;
    if (mediaFile != null && await mediaFile.exists()) {
      final mediaBytes = await mediaFile.readAsBytes();
      mediaName = 'media.ntm';
      archive.addFile(ArchiveFile(mediaName, mediaBytes.length, mediaBytes));
    }

    final manifestBytes = utf8.encode(
      jsonEncode({
        'version': 1,
        'app': 'NativeTavern',
        'format': 'ntx',
        'createdAt': DateTime.now().toIso8601String(),
        'dataFile': 'data.ntb',
        if (mediaName != null) 'mediaFile': mediaName,
        'mediaFileCount': mediaFileCount,
      }),
    );
    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );

    final encoded = ZipEncoder().encode(archive);

    final target = outputFile ??
        File(
          path.join(
            dataFile.parent.path,
            '${path.basenameWithoutExtension(dataFile.path)}.ntx',
          ),
        );
    await target.writeAsBytes(encoded, flush: true);
    return target;
  }

  bool isCombinedBackupPath(String filePath) =>
      path.extension(filePath).toLowerCase() == '.ntx';

  bool isDataBackupPath(String filePath) =>
      path.extension(filePath).toLowerCase() == '.ntb';

  bool isMediaBackupPath(String filePath) =>
      path.extension(filePath).toLowerCase() == '.ntm';

  Future<(File?, int)> _createMediaSidecar({
    required Map<String, dynamic> data,
    required CloudBackupOptions options,
    required File outputFile,
    void Function(CloudBackupArtifactProgress progress)? onProgress,
  }) async {
    if (options.mediaCategories.isEmpty) return (null, 0);

    onProgress?.call(
      const CloudBackupArtifactProgress(
        stage: CloudBackupArtifactStage.scanningMedia,
      ),
    );

    final documents = await _documentsDirectoryProvider();
    final nativeData = Directory(path.join(documents.path, 'NativeTavern'));
    final discovered = <String, _CloudMediaSource>{};

    Future<void> addTree(
      CloudMediaCategory category,
      Directory directory, {
      bool imagesOnly = true,
    }) async {
      if (!options.includes(category) || !await directory.exists()) return;
      await for (final entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is! File) continue;
        final type = await FileSystemEntity.type(
          entity.path,
          followLinks: false,
        );
        if (type != FileSystemEntityType.file) continue;
        final extension = path.extension(entity.path).toLowerCase();
        if (imagesOnly && !_mediaExtensions.contains(extension)) continue;
        final source = _sourceForFile(entity, documents, nativeData, category);
        if (source != null) discovered[source.archivePath] = source;
      }
    }

    await addTree(
      CloudMediaCategory.characterImages,
      Directory(path.join(nativeData.path, 'avatars')),
    );
    await addTree(
      CloudMediaCategory.characterImages,
      Directory(path.join(nativeData.path, 'sprites')),
      imagesOnly: false,
    );
    await addTree(
      CloudMediaCategory.conversationImages,
      Directory(path.join(nativeData.path, 'attachments')),
    );
    await addTree(
      CloudMediaCategory.conversationImages,
      Directory(path.join(nativeData.path, 'moments')),
    );
    await addTree(
      CloudMediaCategory.conversationImages,
      Directory(path.join(documents.path, 'chat_images')),
    );
    await addTree(
      CloudMediaCategory.backgrounds,
      Directory(path.join(nativeData.path, 'backgrounds')),
    );
    await addTree(
      CloudMediaCategory.live2d,
      Directory(path.join(nativeData.path, 'live2d_models')),
      imagesOnly: false,
    );

    if (options.includes(CloudMediaCategory.worldInfoImages)) {
      final characters = data['characters'];
      final worldData = {
        'worldInfos': data['worldInfos'],
        'worldInfoEntries': data['worldInfoEntries'],
        if (characters is Map)
          'embeddedCharacterBooks': [
            for (final character in characters.values)
              if (character is Map) character['characterBookJson'],
          ],
      };
      for (final candidate in _findLocalImagePaths(worldData)) {
        final file = File(candidate);
        if (!await file.exists()) continue;
        final source = _sourceForFile(
          file,
          documents,
          nativeData,
          CloudMediaCategory.worldInfoImages,
        );
        if (source != null) discovered[source.archivePath] = source;
      }
    }

    if (discovered.isEmpty) return (null, 0);

    final archive = Archive();
    final entries = <Map<String, dynamic>>[];
    var processedFiles = 0;
    onProgress?.call(
      CloudBackupArtifactProgress(
        stage: CloudBackupArtifactStage.compressingMedia,
        totalFiles: discovered.length,
      ),
    );
    for (final source in discovered.values) {
      final bytes = await source.file.readAsBytes();
      archive.addFile(ArchiveFile(source.archivePath, bytes.length, bytes));
      entries.add({
        'archivePath': source.archivePath,
        'storageRoot': source.storageRoot,
        'relativePath': source.relativePath,
        'category': source.category.name,
        'size': bytes.length,
        'sha256': sha256.convert(bytes).toString(),
      });
      processedFiles++;
      onProgress?.call(
        CloudBackupArtifactProgress(
          stage: CloudBackupArtifactStage.compressingMedia,
          processedFiles: processedFiles,
          totalFiles: discovered.length,
        ),
      );
    }
    final manifest = utf8.encode(
      jsonEncode({
        'version': 1,
        'app': 'NativeTavern',
        'sourceRoots': {
          'documents': documents.path,
          'nativeData': nativeData.path,
        },
        'files': entries,
      }),
    );
    archive.addFile(ArchiveFile('manifest.json', manifest.length, manifest));
    final encoded = ZipEncoder().encode(archive);
    if (encoded == null) throw StateError('Failed to encode media backup');
    await outputFile.writeAsBytes(encoded, flush: true);
    return (outputFile, entries.length);
  }

  _CloudMediaSource? _sourceForFile(
    File file,
    Directory documents,
    Directory nativeData,
    CloudMediaCategory category,
  ) {
    final normalizedFile = path.normalize(path.absolute(file.path));
    final normalizedNative = path.normalize(path.absolute(nativeData.path));
    final normalizedDocuments = path.normalize(path.absolute(documents.path));
    final (root, rootName) = path.isWithin(normalizedNative, normalizedFile)
        ? (normalizedNative, 'nativeData')
        : path.isWithin(normalizedDocuments, normalizedFile)
            ? (normalizedDocuments, 'documents')
            : ('', '');
    if (root.isEmpty) return null;
    final relative = path.relative(normalizedFile, from: root);
    if (!_isSafeRelativePath(relative)) return null;
    return _CloudMediaSource(
      file: file,
      storageRoot: rootName,
      relativePath: relative,
      archivePath: ['files', rootName, ...path.split(relative)].join('/'),
      category: category,
    );
  }

  Iterable<String> _findLocalImagePaths(Object? value) sync* {
    if (value is Map) {
      for (final nested in value.values) {
        yield* _findLocalImagePaths(nested);
      }
    } else if (value is Iterable) {
      for (final nested in value) {
        yield* _findLocalImagePaths(nested);
      }
    } else if (value is String) {
      final extension =
          path.extension(Uri.tryParse(value)?.path ?? value).toLowerCase();
      if (_mediaExtensions.contains(extension) && path.isAbsolute(value)) {
        yield value;
      }
      final trimmed = value.trimLeft();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          yield* _findLocalImagePaths(jsonDecode(value));
        } catch (_) {
          // Free-form world book text is not necessarily JSON.
        }
      }
    }
  }

  static const _mediaExtensions = {
    '.png',
    '.jpg',
    '.jpeg',
    '.gif',
    '.webp',
    '.bmp',
    '.heic',
    '.avif',
  };

  Future<Map<String, dynamic>> _exportPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    final result = <String, dynamic>{};
    for (final key in preferences.getKeys()) {
      if (_isSensitiveName(key) || _excludedPreferenceKeys.contains(key)) {
        continue;
      }
      final value = preferences.get(key);
      if (value is String) {
        result[key] = _sanitizeEncodedString(value);
      } else if (value is bool || value is int || value is double) {
        result[key] = value;
      } else if (value is List<String>) {
        result[key] = value;
      }
    }
    return result;
  }

  Future<Map<String, String>> _exportTextFiles(Directory nativeData) async {
    final result = <String, String>{};
    final worldRuntime = File(path.join(nativeData.path, 'world_runtime.json'));
    if (await worldRuntime.exists()) {
      result['world_runtime.json'] =
          _sanitizeEncodedString(await worldRuntime.readAsString());
    }
    final sprites = Directory(path.join(nativeData.path, 'sprites'));
    if (await sprites.exists()) {
      await for (final entity
          in sprites.list(recursive: true, followLinks: false)) {
        if (entity is! File ||
            path.basename(entity.path) != 'sprite_pack.json') {
          continue;
        }
        final relative = path.relative(entity.path, from: nativeData.path);
        if (_isSafeRelativePath(relative)) {
          result[relative] =
              _sanitizeEncodedString(await entity.readAsString());
        }
      }
    }
    return result;
  }

  static const _excludedPreferenceKeys = {
    'cloud_backup_settings',
    'ai_data_sharing_choice',
    'ai_data_sharing_disclosure_version',
  };

  bool _isSensitiveName(String name) {
    final normalized = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return const [
      'apikey',
      'accesstoken',
      'refreshtoken',
      'authtoken',
      'authorization',
      'bearer',
      'sessionid',
      'oauth',
      'password',
      'secret',
      'credential',
      'privatekey',
      'cookie',
    ].any(normalized.contains);
  }

  Object? _sanitizeBackupValue(Object? value) {
    if (value is Map) {
      return {
        for (final entry in value.entries)
          if (!_isSensitiveName(entry.key.toString()))
            entry.key.toString(): _sanitizeBackupValue(entry.value),
      };
    }
    if (value is List) {
      return value.map(_sanitizeBackupValue).toList();
    }
    if (value is String) return _sanitizeEncodedString(value);
    return value;
  }

  String _sanitizeEncodedString(String value) {
    final trimmed = value.trimLeft();
    if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return value;
    try {
      return jsonEncode(_sanitizeBackupValue(jsonDecode(value)));
    } catch (_) {
      return value;
    }
  }

  /// Restores non-database text state. Failures are reported on the package
  /// and do not prevent the database restore callback from running.
  Future<Map<String, dynamic>> restoreTextState(
    Map<String, dynamic> backupPackage,
  ) async {
    final documents = await _documentsDirectoryProvider();
    final nativeData = Directory(path.join(documents.path, 'NativeTavern'));
    final replacements = _storageRootReplacements(
      backupPackage,
      documents,
      nativeData,
    );
    final rewritten = Map<String, dynamic>.from(
      _replacePaths(backupPackage, replacements) as Map,
    );
    var failures = 0;
    final preferencesData = rewritten['preferences'];
    if (preferencesData is Map) {
      try {
        final preferences = await SharedPreferences.getInstance();
        for (final entry in preferencesData.entries) {
          final key = entry.key.toString();
          if (_isSensitiveName(key) || _excludedPreferenceKeys.contains(key)) {
            continue;
          }
          final value = entry.value;
          final saved = switch (value) {
            String() => await preferences.setString(key, value),
            bool() => await preferences.setBool(key, value),
            int() => await preferences.setInt(key, value),
            double() => await preferences.setDouble(key, value),
            List() when value.every((item) => item is String) =>
              await preferences.setStringList(key, value.cast<String>()),
            _ => true,
          };
          if (!saved) failures++;
        }
      } catch (_) {
        failures++;
      }
    }

    final textFiles = rewritten['textFiles'];
    if (textFiles is Map) {
      for (final entry in textFiles.entries) {
        try {
          final relative = entry.key.toString();
          if (!_isAllowedTextFile(relative) || entry.value is! String) {
            throw const FormatException('Unsupported text backup path');
          }
          final file = File(path.join(nativeData.path, relative));
          await file.parent.create(recursive: true);
          await file.writeAsString(entry.value as String, flush: true);
        } catch (_) {
          failures++;
        }
      }
    }
    if (failures > 0) {
      rewritten['_textRestoreWarning'] =
          '$failures text settings or files could not be restored.';
    }
    return rewritten;
  }

  Future<Map<String, dynamic>> restoreTextStateSafely(
    Map<String, dynamic> backupPackage,
  ) async {
    try {
      return await restoreTextState(backupPackage);
    } catch (error) {
      return {
        ...backupPackage,
        '_textRestoreWarning': 'Text settings restore failed: $error',
      };
    }
  }

  bool _isAllowedTextFile(String relative) {
    if (!_isSafeRelativePath(relative)) return false;
    final normalized = path.normalize(relative);
    return normalized == 'world_runtime.json' ||
        (normalized.startsWith('sprites${path.separator}') &&
            path.basename(normalized) == 'sprite_pack.json');
  }

  Map<String, String> _storageRootReplacements(
    Map<String, dynamic> backupPackage,
    Directory documents,
    Directory nativeData,
  ) {
    final roots = backupPackage['storageRoots'];
    if (roots is! Map) return {};
    final replacements = <String, String>{};
    final oldDocuments = roots['documents'];
    final oldNativeData = roots['nativeData'];
    if (oldDocuments is String && path.isAbsolute(oldDocuments)) {
      replacements[path.normalize(oldDocuments)] =
          path.normalize(documents.path);
    }
    if (oldNativeData is String && path.isAbsolute(oldNativeData)) {
      replacements[path.normalize(oldNativeData)] =
          path.normalize(nativeData.path);
    }
    return replacements;
  }

  /// Upload backup to iCloud
  Future<CloudBackupInfo?> uploadToICloud({
    required File backupFile,
    File? mediaFile,
    void Function(double progress)? onProgress,
    void Function(CloudBackupTransferPart part)? onPartChanged,
  }) async {
    final iCloudDir = await getICloudDirectory();
    if (iCloudDir == null) {
      throw Exception('iCloud is not available');
    }

    // Log iCloud status
    final status = await getICloudStatus();
    print('CloudBackupService: iCloud status: ${status['message']}');
    print('CloudBackupService: Backup path: ${iCloudDir.path}');

    try {
      onPartChanged?.call(CloudBackupTransferPart.data);
      onProgress?.call(0.0);

      final fileName = path.basename(backupFile.path);
      final targetPath = path.join(iCloudDir.path, fileName);

      final copiedNatively = await _iCloudContainer.copyIntoContainer(
        sourcePath: backupFile.path,
        fileName: fileName,
      );
      final targetFile = File(targetPath);
      if (!copiedNatively) {
        if (await targetFile.exists()) {
          await targetFile.delete();
        }
        await backupFile.copy(targetPath);
      }

      if (mediaFile != null) {
        try {
          onPartChanged?.call(CloudBackupTransferPart.media);
          await mediaFile.copy(
            path.join(iCloudDir.path, path.basename(mediaFile.path)),
          );
        } catch (error) {
          // The data file has already succeeded and remains a valid backup.
          print(
            'CloudBackupService: Optional iCloud media upload failed: $error',
          );
          lastMediaWarning =
              'The data backup succeeded, but media upload failed.';
        }
      }

      onProgress?.call(1.0);

      print('CloudBackupService: Backup saved to: $targetPath');
      print(
        'CloudBackupService: File size: ${await targetFile.length()} bytes',
      );

      final stat = await targetFile.stat();
      return CloudBackupInfo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: fileName,
        size: stat.size,
        createdAt: DateTime.now(),
        provider: CloudProvider.iCloud,
        remotePath: targetPath,
      );
    } catch (e) {
      print('CloudBackupService: Failed to upload to iCloud: $e');
      rethrow;
    }
  }

  /// List backups from iCloud
  Future<List<CloudBackupInfo>> listICloudBackups() async {
    final iCloudDir = await getICloudDirectory();
    if (iCloudDir == null) {
      return [];
    }

    final backups = <CloudBackupInfo>[];

    try {
      await for (final entity in iCloudDir.list()) {
        if (entity is File &&
            (isDataBackupPath(entity.path) ||
                isCombinedBackupPath(entity.path))) {
          final stat = await entity.stat();
          final fileName = path.basename(entity.path);

          backups.add(
            CloudBackupInfo(
              id: fileName.hashCode.toString(),
              name: fileName,
              size: stat.size,
              createdAt: stat.modified,
              provider: CloudProvider.iCloud,
              remotePath: entity.path,
            ),
          );
        }
      }
    } catch (e) {
      print('CloudBackupService: Error listing iCloud backups: $e');
    }

    // Sort by date, newest first
    backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return backups;
  }

  /// Download backup from iCloud
  Future<Map<String, dynamic>> downloadFromICloud({
    required CloudBackupInfo backup,
    void Function(double progress)? onProgress,
    void Function(CloudBackupTransferPart part)? onPartChanged,
    void Function(int processed, int total)? onMediaProgress,
  }) async {
    if (backup.remotePath == null) {
      throw Exception('Backup remote path is null');
    }

    onPartChanged?.call(CloudBackupTransferPart.data);
    onProgress?.call(0.0);

    final file = File(backup.remotePath!);
    await _iCloudContainer.ensureDownloaded(file.path);
    if (!await file.exists()) {
      throw Exception('Backup file not found');
    }

    onProgress?.call(0.5);
    final data = await importFromFile(
      file,
      onMediaProgress: onMediaProgress,
      onPartChanged: onPartChanged,
    );
    onProgress?.call(1.0);
    return data;
  }

  Future<CloudBackupInfo?> getICloudSyncBackup() async {
    final iCloudDir = await getICloudDirectory();
    if (iCloudDir == null) return null;
    final file = File(path.join(iCloudDir.path, syncBackupFileName));
    await _iCloudContainer.ensureDownloaded(file.path);
    if (!await file.exists()) return null;
    final stat = await file.stat();
    return CloudBackupInfo(
      id: syncBackupFileName.hashCode.toString(),
      name: syncBackupFileName,
      size: stat.size,
      createdAt: stat.modified,
      provider: CloudProvider.iCloud,
      remotePath: file.path,
    );
  }

  Future<Map<String, dynamic>?> readICloudSyncMetadata() async {
    final iCloudDir = await getICloudDirectory();
    if (iCloudDir == null) return null;
    final file = File(path.join(iCloudDir.path, syncMetadataFileName));
    await _iCloudContainer.ensureDownloaded(file.path);
    if (!await file.exists()) return null;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
    } catch (_) {}
    return null;
  }

  Future<void> writeICloudSyncMetadata(Map<String, dynamic> metadata) async {
    final iCloudDir = await getICloudDirectory();
    if (iCloudDir == null) return;
    final file = File(path.join(iCloudDir.path, syncMetadataFileName));
    await file.writeAsString(jsonEncode(metadata), flush: true);
  }

  /// Delete backup from iCloud
  Future<void> deleteICloudBackup(CloudBackupInfo backup) async {
    if (backup.remotePath == null) {
      return;
    }

    final file = File(backup.remotePath!);
    if (await file.exists()) {
      try {
        if (isDataBackupPath(file.path)) {
          final data =
              jsonDecode(await file.readAsString()) as Map<String, dynamic>;
          final mediaName = _mediaFileName(data);
          if (mediaName != null) {
            final mediaFile = File(path.join(file.parent.path, mediaName));
            if (await mediaFile.exists()) await mediaFile.delete();
          }
          final combined = File(
            path.join(
              file.parent.path,
              '${path.basenameWithoutExtension(file.path)}.ntx',
            ),
          );
          if (await combined.exists()) await combined.delete();
        }
      } catch (_) {
        // Deleting the primary backup must not depend on optional metadata.
      }
      await file.delete();
    }
  }

  /// Export backup file for Google Drive (user will use file picker)
  Future<File> exportForGoogleDrive({
    required Map<String, dynamic> data,
    CloudBackupOptions options = const CloudBackupOptions(),
  }) async {
    final artifacts = await createCloudBackupArtifacts(
      data: data,
      provider: CloudProvider.googleDrive,
      options: options,
    );
    return artifacts.dataFile;
  }

  /// Create local backup artifacts (.ntb and optional .ntm) for saving or sharing
  Future<CloudBackupArtifacts> exportLocalBackupArtifacts({
    required Map<String, dynamic> data,
    CloudBackupOptions options = const CloudBackupOptions(),
    void Function(CloudBackupArtifactProgress progress)? onProgress,
  }) async {
    return createCloudBackupArtifacts(
      data: data,
      provider: CloudProvider.googleDrive,
      options: options,
      onProgress: onProgress,
    );
  }

  /// Import backup from file (`.ntx`, `.ntb`, and optional `.ntm`).
  Future<Map<String, dynamic>> importFromFile(
    File file, {
    File? mediaFile,
    void Function(int processed, int total)? onMediaProgress,
    void Function(CloudBackupTransferPart part)? onPartChanged,
  }) async {
    onPartChanged?.call(CloudBackupTransferPart.data);
    final parsed = await parseBackupFile(file, mediaFile: mediaFile);
    var data = parsed.package;

    if (data['app'] != 'NativeTavern') {
      throw Exception('Invalid backup file: not a NativeTavern backup');
    }

    data = await restoreTextStateSafely(data);
    if (parsed.mediaBytes == null) {
      if (parsed.mediaExpected) {
        data['_mediaRestoreWarning'] = 'Optional media backup was not found.';
      }
      return data;
    }

    onPartChanged?.call(CloudBackupTransferPart.media);
    final outcome = await restoreMediaBytesSafely(
      backupPackage: data,
      bytes: parsed.mediaBytes!,
      onProgress: onMediaProgress,
    );
    outcome.backupPackage['_mediaRestoredFiles'] = outcome.restoredFiles;
    outcome.backupPackage['_mediaSkippedFiles'] = outcome.skippedFiles;
    if (outcome.warning != null) {
      outcome.backupPackage['_mediaRestoreWarning'] = outcome.warning;
    }
    return outcome.backupPackage;
  }

  /// Reads a `.ntx`, `.ntb`, or `.ntm` backup without restoring it.
  Future<ParsedBackupFile> parseBackupFile(
    File file, {
    File? mediaFile,
  }) async {
    if (isCombinedBackupPath(file.path)) {
      return _parseCombinedBackup(file);
    }
    if (isMediaBackupPath(file.path)) {
      throw Exception(
        'Select a .ntx combined backup or a .ntb data backup. A .ntm media file cannot be restored on its own.',
      );
    }

    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    if (data['app'] != 'NativeTavern') {
      throw Exception('Invalid backup file: not a NativeTavern backup');
    }

    final mediaName = _mediaFileName(data);
    if (mediaName == null) {
      return ParsedBackupFile(package: data);
    }

    final resolvedMediaFile =
        mediaFile ?? File(path.join(file.parent.path, mediaName));
    if (!await resolvedMediaFile.exists()) {
      return ParsedBackupFile(package: data, mediaExpected: true);
    }
    return ParsedBackupFile(
      package: data,
      mediaBytes: await resolvedMediaFile.readAsBytes(),
      mediaExpected: true,
    );
  }

  Future<ParsedBackupFile> _parseCombinedBackup(File file) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final archiveFiles = <String, ArchiveFile>{
      for (final entry in archive.files)
        if (entry.isFile) entry.name: entry,
    };

    final manifestEntry = archiveFiles['manifest.json'];
    Map<String, dynamic> ntxManifest = const {};
    if (manifestEntry != null) {
      ntxManifest = jsonDecode(utf8.decode(_archiveBytes(manifestEntry)))
          as Map<String, dynamic>;
      if (ntxManifest['app'] != 'NativeTavern' ||
          ntxManifest['format'] != 'ntx') {
        throw const FormatException('Unsupported combined backup');
      }
    }

    final dataName = ntxManifest['dataFile'] as String? ?? 'data.ntb';
    if (path.basename(dataName) != dataName) {
      throw const FormatException('Unsafe combined backup data path');
    }
    final dataEntry = archiveFiles[dataName] ?? archiveFiles['data.ntb'];
    if (dataEntry == null) {
      throw const FormatException('Combined backup is missing data.ntb');
    }
    final package = jsonDecode(utf8.decode(_archiveBytes(dataEntry)))
        as Map<String, dynamic>;
    if (package['app'] != 'NativeTavern') {
      throw Exception('Invalid backup file: not a NativeTavern backup');
    }

    final mediaName = ntxManifest['mediaFile'] as String? ??
        _mediaFileName(package) ??
        'media.ntm';
    if (path.basename(mediaName) != mediaName) {
      throw const FormatException('Unsafe combined backup media path');
    }
    final mediaEntry = archiveFiles[mediaName] ?? archiveFiles['media.ntm'];
    return ParsedBackupFile(
      package: package,
      mediaBytes: mediaEntry == null ? null : _archiveBytes(mediaEntry),
      mediaExpected: mediaEntry != null || _mediaFileName(package) != null,
    );
  }

  String? _mediaFileName(Map<String, dynamic> backupPackage) {
    final media = backupPackage['media'];
    if (media is! Map) return null;
    final fileName = media['fileName'];
    if (fileName is! String || path.basename(fileName) != fileName) return null;
    return fileName.endsWith('.ntm') ? fileName : null;
  }

  Future<CloudMediaRestoreOutcome> restoreMediaFile({
    required Map<String, dynamic> backupPackage,
    required File mediaFile,
    void Function(int processed, int total)? onProgress,
  }) async {
    try {
      return restoreMediaBytes(
        backupPackage: backupPackage,
        bytes: await mediaFile.readAsBytes(),
        onProgress: onProgress,
      );
    } catch (error) {
      return CloudMediaRestoreOutcome(
        backupPackage: backupPackage,
        warning: 'Media restore failed: $error',
      );
    }
  }

  Future<CloudMediaRestoreOutcome> restoreMediaBytesSafely({
    required Map<String, dynamic> backupPackage,
    required List<int> bytes,
    void Function(int processed, int total)? onProgress,
  }) async {
    try {
      return await restoreMediaBytes(
        backupPackage: backupPackage,
        bytes: bytes,
        onProgress: onProgress,
      );
    } catch (error) {
      return CloudMediaRestoreOutcome(
        backupPackage: backupPackage,
        warning: 'Media restore failed: $error',
      );
    }
  }

  Future<CloudMediaRestoreOutcome> restoreMediaBytes({
    required Map<String, dynamic> backupPackage,
    required List<int> bytes,
    void Function(int processed, int total)? onProgress,
  }) async {
    final documents = await _documentsDirectoryProvider();
    final nativeData = Directory(path.join(documents.path, 'NativeTavern'));
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final archiveFiles = <String, ArchiveFile>{
      for (final entry in archive.files)
        if (entry.isFile) entry.name: entry,
    };
    final manifestEntry = archiveFiles['manifest.json'];
    if (manifestEntry == null) {
      throw const FormatException('Media manifest is missing');
    }
    final manifest = jsonDecode(utf8.decode(_archiveBytes(manifestEntry)))
        as Map<String, dynamic>;
    if (manifest['app'] != 'NativeTavern' || manifest['version'] != 1) {
      throw const FormatException('Unsupported media backup');
    }

    final sourceRoots = Map<String, dynamic>.from(
      manifest['sourceRoots'] as Map? ?? const {},
    );
    final replacements = <String, String>{};
    final oldDocuments = sourceRoots['documents'];
    final oldNativeData = sourceRoots['nativeData'];
    if (oldDocuments is String && path.isAbsolute(oldDocuments)) {
      replacements[path.normalize(oldDocuments)] = path.normalize(
        documents.path,
      );
    }
    if (oldNativeData is String && path.isAbsolute(oldNativeData)) {
      replacements[path.normalize(oldNativeData)] = path.normalize(
        nativeData.path,
      );
    }

    var restored = 0;
    var skipped = 0;
    var processed = 0;
    final restoredJsonFiles = <File>[];
    final files = manifest['files'];
    if (files is! List) throw const FormatException('Invalid media file list');
    onProgress?.call(0, files.length);
    for (final raw in files) {
      try {
        final item = Map<String, dynamic>.from(raw as Map);
        final archivePath = item['archivePath'] as String;
        final storageRoot = item['storageRoot'] as String;
        final relativePath = item['relativePath'] as String;
        if (!_isSafeRelativePath(relativePath) ||
            !archivePath.startsWith('files/$storageRoot/')) {
          throw const FormatException('Unsafe media path');
        }
        final root = switch (storageRoot) {
          'documents' => documents.path,
          'nativeData' => nativeData.path,
          _ => throw const FormatException('Unknown media storage root'),
        };
        final destinationPath = path.normalize(path.join(root, relativePath));
        if (!path.isWithin(path.normalize(root), destinationPath)) {
          throw const FormatException('Media path escapes its storage root');
        }
        final archived = archiveFiles[archivePath];
        if (archived == null) {
          throw const FormatException('Media file is missing');
        }
        final fileBytes = _archiveBytes(archived);
        if (item['size'] != fileBytes.length ||
            item['sha256'] != sha256.convert(fileBytes).toString()) {
          throw const FormatException('Media checksum mismatch');
        }
        final destination = File(destinationPath);
        await destination.parent.create(recursive: true);
        await destination.writeAsBytes(fileBytes, flush: true);
        if (path.extension(destination.path).toLowerCase() == '.json') {
          restoredJsonFiles.add(destination);
        }
        restored++;
      } catch (error) {
        skipped++;
        print('CloudBackupService: Skipped media entry: $error');
      } finally {
        processed++;
        onProgress?.call(processed, files.length);
      }
    }

    for (final file in restoredJsonFiles) {
      try {
        final original = await file.readAsString();
        final rewritten = _replacePathsInString(original, replacements);
        if (rewritten != original) {
          await file.writeAsString(rewritten, flush: true);
        }
      } catch (_) {
        // Metadata repair is best effort; the image files are still restored.
      }
    }
    final rewrittenPackage = Map<String, dynamic>.from(
      _replacePaths(backupPackage, replacements) as Map,
    );
    return CloudMediaRestoreOutcome(
      backupPackage: rewrittenPackage,
      restoredFiles: restored,
      skippedFiles: skipped,
      warning:
          skipped == 0 ? null : '$skipped media files could not be restored.',
    );
  }

  Uint8List _archiveBytes(ArchiveFile file) {
    final content = file.content;
    if (content is Uint8List) return content;
    if (content is List<int>) return Uint8List.fromList(content);
    throw const FormatException('Invalid archive entry content');
  }

  Object? _replacePaths(Object? value, Map<String, String> replacements) {
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key.toString(): _replacePaths(entry.value, replacements),
      };
    }
    if (value is List) {
      return value.map((entry) => _replacePaths(entry, replacements)).toList();
    }
    if (value is String) return _replacePathsInString(value, replacements);
    return value;
  }

  String _replacePathsInString(String value, Map<String, String> replacements) {
    var result = value;
    for (final entry in replacements.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    return result;
  }

  bool _isSafeRelativePath(String value) {
    if (value.isEmpty || path.isAbsolute(value)) return false;
    final normalized = path.normalize(value);
    return normalized != '..' &&
        !normalized.startsWith('../') &&
        !path.split(normalized).contains('..');
  }

  /// Merge backup data with local data
  Future<MergeResult> mergeData({
    required Map<String, dynamic> backupData,
    required Map<String, dynamic> localData,
    required RestoreMode mode,
  }) async {
    final result = MergeResult();

    // Get the actual data from backup package
    final backupItems =
        backupData['data'] as Map<String, dynamic>? ?? backupData;

    // Merge each data type
    if (backupItems.containsKey('characters')) {
      final mergedChars = await _mergeCollection(
        backup: backupItems['characters'] as Map<String, dynamic>? ?? {},
        local: localData['characters'] as Map<String, dynamic>? ?? {},
        mode: mode,
        idKey: 'id',
        timestampKey: 'modifiedAt',
      );
      result.charactersAdded = mergedChars.added;
      result.charactersUpdated = mergedChars.updated;
      result.charactersSkipped = mergedChars.skipped;
    }

    if (backupItems.containsKey('chats')) {
      final mergedChats = await _mergeCollection(
        backup: backupItems['chats'] as Map<String, dynamic>? ?? {},
        local: localData['chats'] as Map<String, dynamic>? ?? {},
        mode: mode,
        idKey: 'id',
        timestampKey: 'updatedAt',
      );
      result.chatsAdded = mergedChats.added;
      result.chatsUpdated = mergedChats.updated;
      result.chatsSkipped = mergedChats.skipped;
    }

    if (backupItems.containsKey('messages')) {
      final mergedMsgs = await _mergeCollection(
        backup: backupItems['messages'] as Map<String, dynamic>? ?? {},
        local: localData['messages'] as Map<String, dynamic>? ?? {},
        mode: mode,
        idKey: 'id',
        timestampKey: 'timestamp',
      );
      result.messagesAdded = mergedMsgs.added;
      result.messagesUpdated = mergedMsgs.updated;
      result.messagesSkipped = mergedMsgs.skipped;
    }

    if (backupItems.containsKey('worldInfo')) {
      final mergedWi = await _mergeCollection(
        backup: backupItems['worldInfo'] as Map<String, dynamic>? ?? {},
        local: localData['worldInfo'] as Map<String, dynamic>? ?? {},
        mode: mode,
        idKey: 'id',
        timestampKey: 'modifiedAt',
      );
      result.worldInfoAdded = mergedWi.added;
      result.worldInfoUpdated = mergedWi.updated;
      result.worldInfoSkipped = mergedWi.skipped;
    }

    return result;
  }

  /// Merge a collection of items
  Future<_MergeCollectionResult> _mergeCollection({
    required Map<String, dynamic> backup,
    required Map<String, dynamic> local,
    required RestoreMode mode,
    required String idKey,
    required String timestampKey,
  }) async {
    int added = 0;
    int updated = 0;
    int skipped = 0;

    final result = Map<String, dynamic>.from(local);

    for (final entry in backup.entries) {
      final backupItem = entry.value as Map<String, dynamic>;
      final id = backupItem[idKey] as String?;

      if (id == null) {
        skipped++;
        continue;
      }

      final localItem = local[id] as Map<String, dynamic>?;

      switch (mode) {
        case RestoreMode.replace:
          result[id] = backupItem;
          if (localItem == null) {
            added++;
          } else {
            updated++;
          }
          break;

        case RestoreMode.merge:
          if (localItem == null) {
            result[id] = backupItem;
            added++;
          } else {
            // Compare timestamps, newer wins
            final backupTime = _parseDateTime(backupItem[timestampKey]);
            final localTime = _parseDateTime(localItem[timestampKey]);

            if (backupTime != null &&
                localTime != null &&
                backupTime.isAfter(localTime)) {
              result[id] = backupItem;
              updated++;
            } else {
              skipped++;
            }
          }
          break;

        case RestoreMode.addNewOnly:
          if (localItem == null) {
            result[id] = backupItem;
            added++;
          } else {
            skipped++;
          }
          break;
      }
    }

    return _MergeCollectionResult(
      data: result,
      added: added,
      updated: updated,
      skipped: skipped,
    );
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  /// Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Result of a merge operation
class MergeResult {
  int charactersAdded = 0;
  int charactersUpdated = 0;
  int charactersSkipped = 0;

  int chatsAdded = 0;
  int chatsUpdated = 0;
  int chatsSkipped = 0;

  int messagesAdded = 0;
  int messagesUpdated = 0;
  int messagesSkipped = 0;

  int worldInfoAdded = 0;
  int worldInfoUpdated = 0;
  int worldInfoSkipped = 0;

  int get totalAdded =>
      charactersAdded + chatsAdded + messagesAdded + worldInfoAdded;
  int get totalUpdated =>
      charactersUpdated + chatsUpdated + messagesUpdated + worldInfoUpdated;
  int get totalSkipped =>
      charactersSkipped + chatsSkipped + messagesSkipped + worldInfoSkipped;

  @override
  String toString() {
    return 'MergeResult(added: $totalAdded, updated: $totalUpdated, skipped: $totalSkipped)';
  }
}

class _MergeCollectionResult {
  final Map<String, dynamic> data;
  final int added;
  final int updated;
  final int skipped;

  _MergeCollectionResult({
    required this.data,
    required this.added,
    required this.updated,
    required this.skipped,
  });
}

class _CloudMediaSource {
  final File file;
  final String storageRoot;
  final String relativePath;
  final String archivePath;
  final CloudMediaCategory category;

  const _CloudMediaSource({
    required this.file,
    required this.storageRoot,
    required this.relativePath,
    required this.archivePath,
    required this.category,
  });
}
