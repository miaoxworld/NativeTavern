import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

/// Cloud provider type
enum CloudProvider {
  googleDrive,
  iCloud,
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
enum CloudBackupStatus {
  idle,
  syncing,
  uploading,
  downloading,
  success,
  error,
}

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
  
  CloudBackupService._();
  
  /// Get the cloud backups cache directory
  Future<Directory> getCloudCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(path.join(appDir.path, 'NativeTavern', 'cloud_cache'));
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
      // On iOS/macOS, iCloud container is accessible via file system
      // The ubiquity container path pattern for our app
      
      if (Platform.isMacOS) {
        final homeDir = Platform.environment['HOME'] ?? '';
        // iCloud container path format: ~/Library/Mobile Documents/iCloud~<container_id>/Documents
        // Our container ID: iCloud.com.miaomiaoxworld.nativetavern
        // The path uses ~ instead of . for the container prefix
        final iCloudPath = path.join(
          homeDir,
          'Library',
          'Mobile Documents',
          'iCloud~com~miaomiaoxworld~nativetavern',
          'Documents',
        );
        final iCloudDir = Directory(iCloudPath);
        
        print('CloudBackupService: Checking iCloud path: $iCloudPath');
        
        if (await iCloudDir.exists()) {
          print('CloudBackupService: iCloud directory exists');
          return iCloudDir;
        }
        
        // Try creating it (will only work if iCloud container is properly configured)
        try {
          await iCloudDir.create(recursive: true);
          print('CloudBackupService: Created iCloud directory');
          return iCloudDir;
        } catch (e) {
          print('CloudBackupService: Failed to create iCloud directory: $e');
          // iCloud container may not be available, this is expected for development
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
          print('CloudBackupService: Failed to create iOS iCloud directory: $e');
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
  
  /// Create a backup file for cloud upload
  Future<File> createCloudBackupFile({
    required Map<String, dynamic> data,
    required CloudProvider provider,
  }) async {
    final cacheDir = await getCloudCacheDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final fileName = 'NativeTavern_cloud_backup_$timestamp.ntb'; // .ntb = NativeTavern Backup
    final filePath = path.join(cacheDir.path, fileName);
    
    // Create backup package with metadata
    final backupPackage = {
      'version': 2,
      'app': 'NativeTavern',
      'createdAt': DateTime.now().toIso8601String(),
      'provider': provider.name,
      'data': data,
    };
    
    final file = File(filePath);
    await file.writeAsString(jsonEncode(backupPackage));
    
    return file;
  }
  
  /// Upload backup to iCloud
  Future<CloudBackupInfo?> uploadToICloud({
    required File backupFile,
    void Function(double progress)? onProgress,
  }) async {
    final iCloudDir = await getICloudDirectory();
    if (iCloudDir == null) {
      throw Exception('iCloud is not available');
    }
    
    try {
      onProgress?.call(0.0);
      
      final fileName = path.basename(backupFile.path);
      final targetPath = path.join(iCloudDir.path, fileName);
      
      // Copy file to iCloud directory
      final targetFile = await backupFile.copy(targetPath);
      
      onProgress?.call(1.0);
      
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
        if (entity is File && entity.path.endsWith('.ntb')) {
          final stat = await entity.stat();
          final fileName = path.basename(entity.path);
          
          backups.add(CloudBackupInfo(
            id: fileName.hashCode.toString(),
            name: fileName,
            size: stat.size,
            createdAt: stat.modified,
            provider: CloudProvider.iCloud,
            remotePath: entity.path,
          ));
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
  }) async {
    if (backup.remotePath == null) {
      throw Exception('Backup remote path is null');
    }
    
    onProgress?.call(0.0);
    
    final file = File(backup.remotePath!);
    if (!await file.exists()) {
      throw Exception('Backup file not found');
    }
    
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    
    onProgress?.call(1.0);
    
    return data;
  }
  
  /// Delete backup from iCloud
  Future<void> deleteICloudBackup(CloudBackupInfo backup) async {
    if (backup.remotePath == null) {
      return;
    }
    
    final file = File(backup.remotePath!);
    if (await file.exists()) {
      await file.delete();
    }
  }
  
  /// Export backup file for Google Drive (user will use file picker)
  Future<File> exportForGoogleDrive({
    required Map<String, dynamic> data,
  }) async {
    return createCloudBackupFile(
      data: data,
      provider: CloudProvider.googleDrive,
    );
  }
  
  /// Import backup from file (for Google Drive)
  Future<Map<String, dynamic>> importFromFile(File file) async {
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;
    
    // Validate backup format
    if (data['app'] != 'NativeTavern') {
      throw Exception('Invalid backup file: not a NativeTavern backup');
    }
    
    return data;
  }
  
  /// Merge backup data with local data
  Future<MergeResult> mergeData({
    required Map<String, dynamic> backupData,
    required Map<String, dynamic> localData,
    required RestoreMode mode,
  }) async {
    final result = MergeResult();
    
    // Get the actual data from backup package
    final backupItems = backupData['data'] as Map<String, dynamic>? ?? backupData;
    
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
            
            if (backupTime != null && localTime != null && backupTime.isAfter(localTime)) {
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
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
  
  int get totalAdded => charactersAdded + chatsAdded + messagesAdded + worldInfoAdded;
  int get totalUpdated => charactersUpdated + chatsUpdated + messagesUpdated + worldInfoUpdated;
  int get totalSkipped => charactersSkipped + chatsSkipped + messagesSkipped + worldInfoSkipped;
  
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
