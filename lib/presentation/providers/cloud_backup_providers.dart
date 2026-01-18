import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/google_drive_service.dart';

/// Provider for cloud backup service
final cloudBackupServiceProvider = Provider<CloudBackupService>((ref) {
  return CloudBackupService.instance;
});

/// Provider for Google Drive service
final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  return GoogleDriveService.instance;
});

/// Provider for checking iCloud availability
final iCloudAvailableProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(cloudBackupServiceProvider);
  return service.isICloudAvailable();
});

/// Provider for checking if user is signed into Google Drive
final googleDriveSignedInProvider = StateProvider<bool>((ref) {
  return GoogleDriveService.instance.isSignedIn;
});

/// Provider for Google Drive user info
final googleDriveUserProvider = Provider<Map<String, String?>>((ref) {
  final service = GoogleDriveService.instance;
  return {
    'email': service.currentUserEmail,
    'displayName': service.currentUserDisplayName,
    'photoUrl': service.currentUserPhotoUrl,
  };
});

/// Provider for iCloud backups list
final iCloudBackupsProvider = FutureProvider<List<CloudBackupInfo>>((ref) async {
  final service = ref.watch(cloudBackupServiceProvider);
  return service.listICloudBackups();
});

/// Provider for Google Drive backups list
final googleDriveBackupsProvider = FutureProvider<List<GoogleDriveBackupInfo>>((ref) async {
  final isSignedIn = ref.watch(googleDriveSignedInProvider);
  if (!isSignedIn) return [];
  
  final service = ref.watch(googleDriveServiceProvider);
  return service.listBackups();
});


/// Cloud backup settings
class CloudBackupSettings {
  final bool iCloudEnabled;
  final bool googleDriveEnabled;
  final bool autoSyncEnabled;
  final DateTime? lastICloudSync;
  final DateTime? lastGoogleDriveSync;
  final RestoreMode defaultRestoreMode;
  
  const CloudBackupSettings({
    this.iCloudEnabled = false,
    this.googleDriveEnabled = false,
    this.autoSyncEnabled = false,
    this.lastICloudSync,
    this.lastGoogleDriveSync,
    this.defaultRestoreMode = RestoreMode.merge,
  });
  
  CloudBackupSettings copyWith({
    bool? iCloudEnabled,
    bool? googleDriveEnabled,
    bool? autoSyncEnabled,
    DateTime? lastICloudSync,
    DateTime? lastGoogleDriveSync,
    RestoreMode? defaultRestoreMode,
  }) {
    return CloudBackupSettings(
      iCloudEnabled: iCloudEnabled ?? this.iCloudEnabled,
      googleDriveEnabled: googleDriveEnabled ?? this.googleDriveEnabled,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      lastICloudSync: lastICloudSync ?? this.lastICloudSync,
      lastGoogleDriveSync: lastGoogleDriveSync ?? this.lastGoogleDriveSync,
      defaultRestoreMode: defaultRestoreMode ?? this.defaultRestoreMode,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'iCloudEnabled': iCloudEnabled,
    'googleDriveEnabled': googleDriveEnabled,
    'autoSyncEnabled': autoSyncEnabled,
    'lastICloudSync': lastICloudSync?.toIso8601String(),
    'lastGoogleDriveSync': lastGoogleDriveSync?.toIso8601String(),
    'defaultRestoreMode': defaultRestoreMode.name,
  };
  
  factory CloudBackupSettings.fromJson(Map<String, dynamic> json) {
    return CloudBackupSettings(
      iCloudEnabled: json['iCloudEnabled'] as bool? ?? false,
      googleDriveEnabled: json['googleDriveEnabled'] as bool? ?? false,
      autoSyncEnabled: json['autoSyncEnabled'] as bool? ?? false,
      lastICloudSync: json['lastICloudSync'] != null 
          ? DateTime.tryParse(json['lastICloudSync'] as String) 
          : null,
      lastGoogleDriveSync: json['lastGoogleDriveSync'] != null 
          ? DateTime.tryParse(json['lastGoogleDriveSync'] as String) 
          : null,
      defaultRestoreMode: RestoreMode.values.firstWhere(
        (m) => m.name == json['defaultRestoreMode'],
        orElse: () => RestoreMode.merge,
      ),
    );
  }
}

/// Provider for cloud backup settings
final cloudBackupSettingsProvider = StateNotifierProvider<CloudBackupSettingsNotifier, CloudBackupSettings>((ref) {
  return CloudBackupSettingsNotifier();
});

/// Notifier for cloud backup settings
class CloudBackupSettingsNotifier extends StateNotifier<CloudBackupSettings> {
  static const _storageKey = 'cloud_backup_settings';
  
  CloudBackupSettingsNotifier() : super(const CloudBackupSettings()) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) {
          state = CloudBackupSettings.fromJson(decoded);
        }
      }
    } catch (e) {
      print('Error loading cloud backup settings: $e');
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(state.toJson()));
    } catch (e) {
      print('Error saving cloud backup settings: $e');
    }
  }
  
  void setICloudEnabled(bool value) {
    state = state.copyWith(iCloudEnabled: value);
    _saveSettings();
  }
  
  void setGoogleDriveEnabled(bool value) {
    state = state.copyWith(googleDriveEnabled: value);
    _saveSettings();
  }
  
  void setAutoSyncEnabled(bool value) {
    state = state.copyWith(autoSyncEnabled: value);
    _saveSettings();
  }
  
  void setDefaultRestoreMode(RestoreMode mode) {
    state = state.copyWith(defaultRestoreMode: mode);
    _saveSettings();
  }
  
  void updateLastICloudSync() {
    state = state.copyWith(lastICloudSync: DateTime.now());
    _saveSettings();
  }
  
  void updateLastGoogleDriveSync() {
    state = state.copyWith(lastGoogleDriveSync: DateTime.now());
    _saveSettings();
  }
}

/// Cloud backup operation state
class CloudBackupOperationState {
  final bool isLoading;
  final String? currentOperation;
  final double? progress;
  final String? error;
  final CloudBackupStatus status;
  
  const CloudBackupOperationState({
    this.isLoading = false,
    this.currentOperation,
    this.progress,
    this.error,
    this.status = CloudBackupStatus.idle,
  });
  
  CloudBackupOperationState copyWith({
    bool? isLoading,
    String? currentOperation,
    double? progress,
    String? error,
    CloudBackupStatus? status,
  }) {
    return CloudBackupOperationState(
      isLoading: isLoading ?? this.isLoading,
      currentOperation: currentOperation,
      progress: progress,
      error: error,
      status: status ?? this.status,
    );
  }
}

/// Provider for cloud backup operations
final cloudBackupOperationProvider = StateNotifierProvider<CloudBackupOperationNotifier, CloudBackupOperationState>((ref) {
  return CloudBackupOperationNotifier(ref);
});

/// Notifier for cloud backup operations
class CloudBackupOperationNotifier extends StateNotifier<CloudBackupOperationState> {
  final Ref _ref;
  
  CloudBackupOperationNotifier(this._ref) : super(const CloudBackupOperationState());
  
  CloudBackupService get _service => _ref.read(cloudBackupServiceProvider);
  
  /// Upload backup to iCloud
  Future<CloudBackupInfo?> uploadToICloud(Map<String, dynamic> data) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Creating backup for iCloud...',
      status: CloudBackupStatus.uploading,
      error: null,
    );
    
    try {
      // Create backup file
      final file = await _service.createCloudBackupFile(
        data: data,
        provider: CloudProvider.iCloud,
      );
      
      state = state.copyWith(
        currentOperation: 'Uploading to iCloud...',
        progress: 0.5,
      );
      
      // Upload to iCloud
      final backup = await _service.uploadToICloud(
        backupFile: file,
        onProgress: (progress) {
          state = state.copyWith(progress: 0.5 + progress * 0.5);
        },
      );
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: CloudBackupStatus.success,
      );
      
      // Update settings
      _ref.read(cloudBackupSettingsProvider.notifier).updateLastICloudSync();
      
      // Refresh backups list
      _ref.invalidate(iCloudBackupsProvider);
      
      return backup;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] uploadToICloud error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return null;
    }
  }
  
  /// Download and restore from iCloud
  Future<MergeResult?> downloadFromICloud({
    required CloudBackupInfo backup,
    required RestoreMode mode,
    required Map<String, dynamic> localData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode) restoreCallback,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Downloading from iCloud...',
      status: CloudBackupStatus.downloading,
      error: null,
    );
    
    try {
      // Download backup
      final backupData = await _service.downloadFromICloud(
        backup: backup,
        onProgress: (progress) {
          state = state.copyWith(progress: progress * 0.5);
        },
      );
      
      state = state.copyWith(
        currentOperation: 'Restoring data...',
        progress: 0.5,
      );
      
      // Merge/restore data
      final mergeResult = await _service.mergeData(
        backupData: backupData,
        localData: localData,
        mode: mode,
      );
      
      // Apply restored data
      await restoreCallback(backupData, mode);
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: CloudBackupStatus.success,
      );
      
      return mergeResult;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] downloadFromICloud error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return null;
    }
  }
  
  /// Delete backup from iCloud
  Future<bool> deleteICloudBackup(CloudBackupInfo backup) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Deleting backup...',
      error: null,
    );
    
    try {
      await _service.deleteICloudBackup(backup);
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        status: CloudBackupStatus.success,
      );
      
      // Refresh backups list
      _ref.invalidate(iCloudBackupsProvider);
      
      return true;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] deleteICloudBackup error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return false;
    }
  }
  
  /// Export backup to file (for Google Drive)
  Future<File?> exportToFile(Map<String, dynamic> data) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Creating backup file...',
      status: CloudBackupStatus.uploading,
      error: null,
    );
    
    try {
      final file = await _service.exportForGoogleDrive(data: data);
      
      // Let user pick destination
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save backup to Google Drive or other location',
        fileName: file.uri.pathSegments.last,
        type: FileType.any,
      );
      
      if (result != null) {
        final destFile = await file.copy(result);
        
        state = state.copyWith(
          isLoading: false,
          currentOperation: null,
          status: CloudBackupStatus.success,
        );
        
        _ref.read(cloudBackupSettingsProvider.notifier).updateLastGoogleDriveSync();
        
        return destFile;
      }
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        status: CloudBackupStatus.idle,
      );
      
      return null;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] exportToFile error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return null;
    }
  }
  
  /// Import backup from file (for Google Drive)
  Future<MergeResult?> importFromFile({
    required RestoreMode mode,
    required Map<String, dynamic> localData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode) restoreCallback,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Selecting file...',
      status: CloudBackupStatus.downloading,
      error: null,
    );
    
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        dialogTitle: 'Select backup file from Google Drive or other location',
      );
      
      if (result == null || result.files.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          currentOperation: null,
          status: CloudBackupStatus.idle,
        );
        return null;
      }
      
      final filePath = result.files.first.path;
      if (filePath == null) {
        throw Exception('No file selected');
      }
      
      state = state.copyWith(
        currentOperation: 'Reading backup file...',
        progress: 0.3,
      );
      
      final file = File(filePath);
      final backupData = await _service.importFromFile(file);
      
      state = state.copyWith(
        currentOperation: 'Restoring data...',
        progress: 0.6,
      );
      
      // Merge/restore data
      final mergeResult = await _service.mergeData(
        backupData: backupData,
        localData: localData,
        mode: mode,
      );
      
      // Apply restored data
      await restoreCallback(backupData, mode);
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: CloudBackupStatus.success,
      );
      
      return mergeResult;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] importFromFile error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return null;
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null, status: CloudBackupStatus.idle);
  }
  
  // ============ Google Drive Methods ============
  
  GoogleDriveService get _googleDriveService => _ref.read(googleDriveServiceProvider);
  
  /// Sign in to Google Drive
  Future<bool> signInToGoogleDrive() async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Signing in to Google...',
      error: null,
    );
    
    try {
      final success = await _googleDriveService.signIn();
      
      if (success) {
        _ref.read(googleDriveSignedInProvider.notifier).state = true;
        _ref.invalidate(googleDriveUserProvider);
        _ref.invalidate(googleDriveBackupsProvider);
      }
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        status: success ? CloudBackupStatus.success : CloudBackupStatus.idle,
      );
      
      return success;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] signInToGoogleDrive error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return false;
    }
  }
  
  /// Sign out from Google Drive
  Future<void> signOutFromGoogleDrive() async {
    await _googleDriveService.signOut();
    _ref.read(googleDriveSignedInProvider.notifier).state = false;
    _ref.invalidate(googleDriveUserProvider);
    _ref.invalidate(googleDriveBackupsProvider);
  }
  
  /// Upload backup to Google Drive
  Future<GoogleDriveBackupInfo?> uploadToGoogleDrive(Map<String, dynamic> data) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Uploading to Google Drive...',
      status: CloudBackupStatus.uploading,
      error: null,
    );
    
    try {
      final backup = await _googleDriveService.uploadBackup(
        data: data,
        onProgress: (progress) {
          state = state.copyWith(progress: progress);
        },
      );
      
      if (backup != null) {
        _ref.read(cloudBackupSettingsProvider.notifier).updateLastGoogleDriveSync();
        _ref.invalidate(googleDriveBackupsProvider);
      }
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: backup != null ? CloudBackupStatus.success : CloudBackupStatus.error,
        error: backup == null ? 'Failed to upload backup' : null,
      );
      
      return backup;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] uploadToGoogleDrive error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return null;
    }
  }
  
  /// Download and restore from Google Drive
  Future<MergeResult?> downloadFromGoogleDrive({
    required String fileId,
    required RestoreMode mode,
    required Map<String, dynamic> localData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode) restoreCallback,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Downloading from Google Drive...',
      status: CloudBackupStatus.downloading,
      error: null,
    );
    
    try {
      // Download backup
      final backupData = await _googleDriveService.downloadBackup(
        fileId: fileId,
        onProgress: (progress) {
          state = state.copyWith(progress: progress * 0.5);
        },
      );
      
      if (backupData == null) {
        throw Exception('Failed to download backup');
      }
      
      state = state.copyWith(
        currentOperation: 'Restoring data...',
        progress: 0.5,
      );
      
      // Merge/restore data
      final mergeResult = await _service.mergeData(
        backupData: backupData,
        localData: localData,
        mode: mode,
      );
      
      // Apply restored data
      await restoreCallback(backupData, mode);
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: CloudBackupStatus.success,
      );
      
      return mergeResult;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] downloadFromGoogleDrive error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return null;
    }
  }
  
  /// Delete backup from Google Drive
  Future<bool> deleteGoogleDriveBackup(String fileId) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Deleting backup...',
      error: null,
    );
    
    try {
      final success = await _googleDriveService.deleteBackup(fileId);
      
      if (success) {
        _ref.invalidate(googleDriveBackupsProvider);
      }
      
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        status: success ? CloudBackupStatus.success : CloudBackupStatus.error,
        error: success ? null : 'Failed to delete backup',
      );
      
      return success;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] deleteGoogleDriveBackup error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return false;
    }
  }
}
