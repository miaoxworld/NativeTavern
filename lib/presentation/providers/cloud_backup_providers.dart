import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/file_export_service.dart';
import 'package:native_tavern/domain/services/google_drive_service.dart';

/// Path of a backup file opened from the system Files app / share sheet.
final pendingBackupImportPathProvider = StateProvider<String?>((ref) => null);

/// Path of a non-backup file opened from the system for character/chat import.
final pendingImportFilePathProvider = StateProvider<String?>((ref) => null);

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
final iCloudBackupsProvider =
    FutureProvider<List<CloudBackupInfo>>((ref) async {
  final service = ref.watch(cloudBackupServiceProvider);
  return service.listICloudBackups();
});

/// Provider for Google Drive backups list
final googleDriveBackupsProvider =
    FutureProvider<List<GoogleDriveBackupInfo>>((ref) async {
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
  final bool includeCharacterImages;
  final bool includeWorldInfoImages;
  final bool includeConversationImages;
  final bool includeBackgrounds;
  final bool includeLive2D;

  const CloudBackupSettings({
    this.iCloudEnabled = false,
    this.googleDriveEnabled = false,
    this.autoSyncEnabled = false,
    this.lastICloudSync,
    this.lastGoogleDriveSync,
    this.defaultRestoreMode = RestoreMode.merge,
    this.includeCharacterImages = false,
    this.includeWorldInfoImages = false,
    this.includeConversationImages = false,
    this.includeBackgrounds = false,
    this.includeLive2D = false,
  });

  CloudBackupOptions get backupOptions => CloudBackupOptions(
        mediaCategories: {
          if (includeCharacterImages) CloudMediaCategory.characterImages,
          if (includeWorldInfoImages) CloudMediaCategory.worldInfoImages,
          if (includeConversationImages) CloudMediaCategory.conversationImages,
          if (includeBackgrounds) CloudMediaCategory.backgrounds,
          if (includeLive2D) CloudMediaCategory.live2d,
        },
      );

  CloudBackupSettings copyWith({
    bool? iCloudEnabled,
    bool? googleDriveEnabled,
    bool? autoSyncEnabled,
    DateTime? lastICloudSync,
    DateTime? lastGoogleDriveSync,
    RestoreMode? defaultRestoreMode,
    bool? includeCharacterImages,
    bool? includeWorldInfoImages,
    bool? includeConversationImages,
    bool? includeBackgrounds,
    bool? includeLive2D,
  }) {
    return CloudBackupSettings(
      iCloudEnabled: iCloudEnabled ?? this.iCloudEnabled,
      googleDriveEnabled: googleDriveEnabled ?? this.googleDriveEnabled,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      lastICloudSync: lastICloudSync ?? this.lastICloudSync,
      lastGoogleDriveSync: lastGoogleDriveSync ?? this.lastGoogleDriveSync,
      defaultRestoreMode: defaultRestoreMode ?? this.defaultRestoreMode,
      includeCharacterImages:
          includeCharacterImages ?? this.includeCharacterImages,
      includeWorldInfoImages:
          includeWorldInfoImages ?? this.includeWorldInfoImages,
      includeConversationImages:
          includeConversationImages ?? this.includeConversationImages,
      includeBackgrounds: includeBackgrounds ?? this.includeBackgrounds,
      includeLive2D: includeLive2D ?? this.includeLive2D,
    );
  }

  Map<String, dynamic> toJson() => {
        'iCloudEnabled': iCloudEnabled,
        'googleDriveEnabled': googleDriveEnabled,
        'autoSyncEnabled': autoSyncEnabled,
        'lastICloudSync': lastICloudSync?.toIso8601String(),
        'lastGoogleDriveSync': lastGoogleDriveSync?.toIso8601String(),
        'defaultRestoreMode': defaultRestoreMode.name,
        'includeCharacterImages': includeCharacterImages,
        'includeWorldInfoImages': includeWorldInfoImages,
        'includeConversationImages': includeConversationImages,
        'includeBackgrounds': includeBackgrounds,
        'includeLive2D': includeLive2D,
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
      includeCharacterImages: json['includeCharacterImages'] as bool? ?? false,
      includeWorldInfoImages: json['includeWorldInfoImages'] as bool? ?? false,
      includeConversationImages:
          json['includeConversationImages'] as bool? ?? false,
      includeBackgrounds: json['includeBackgrounds'] as bool? ?? false,
      includeLive2D: json['includeLive2D'] as bool? ?? false,
    );
  }
}

/// Provider for cloud backup settings
final cloudBackupSettingsProvider =
    StateNotifierProvider<CloudBackupSettingsNotifier, CloudBackupSettings>(
        (ref) {
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

  void setIncludeCharacterImages(bool value) {
    state = state.copyWith(includeCharacterImages: value);
    _saveSettings();
  }

  void setIncludeWorldInfoImages(bool value) {
    state = state.copyWith(includeWorldInfoImages: value);
    _saveSettings();
  }

  void setIncludeConversationImages(bool value) {
    state = state.copyWith(includeConversationImages: value);
    _saveSettings();
  }

  void setIncludeBackgrounds(bool value) {
    state = state.copyWith(includeBackgrounds: value);
    _saveSettings();
  }

  void setIncludeLive2D(bool value) {
    state = state.copyWith(includeLive2D: value);
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
enum CloudBackupOperationStage {
  preparingData,
  scanningMedia,
  compressingMedia,
  uploadingData,
  uploadingMedia,
  downloadingData,
  downloadingMedia,
  verifyingMedia,
  restoringMedia,
  restoringData,
}

const _notProvided = Object();

class CloudBackupOperationState {
  final bool isLoading;
  final String? currentOperation;
  final double? progress;
  final String? error;
  final String? warning;
  final bool? mediaIncluded;
  final int? mediaRestoredFiles;
  final Set<CloudMediaCategory>? mediaCategories;
  final CloudBackupOperationStage? stage;
  final int? processedItems;
  final int? totalItems;
  final CloudBackupStatus status;

  const CloudBackupOperationState({
    this.isLoading = false,
    this.currentOperation,
    this.progress,
    this.error,
    this.warning,
    this.mediaIncluded,
    this.mediaRestoredFiles,
    this.mediaCategories,
    this.stage,
    this.processedItems,
    this.totalItems,
    this.status = CloudBackupStatus.idle,
  });

  CloudBackupOperationState copyWith({
    bool? isLoading,
    Object? currentOperation = _notProvided,
    Object? progress = _notProvided,
    Object? error = _notProvided,
    Object? warning = _notProvided,
    Object? mediaIncluded = _notProvided,
    Object? mediaRestoredFiles = _notProvided,
    Object? mediaCategories = _notProvided,
    Object? stage = _notProvided,
    Object? processedItems = _notProvided,
    Object? totalItems = _notProvided,
    CloudBackupStatus? status,
  }) {
    return CloudBackupOperationState(
      isLoading: isLoading ?? this.isLoading,
      currentOperation: identical(currentOperation, _notProvided)
          ? this.currentOperation
          : currentOperation as String?,
      progress: identical(progress, _notProvided)
          ? this.progress
          : progress as double?,
      error: identical(error, _notProvided) ? this.error : error as String?,
      warning:
          identical(warning, _notProvided) ? this.warning : warning as String?,
      mediaIncluded: identical(mediaIncluded, _notProvided)
          ? this.mediaIncluded
          : mediaIncluded as bool?,
      mediaRestoredFiles: identical(mediaRestoredFiles, _notProvided)
          ? this.mediaRestoredFiles
          : mediaRestoredFiles as int?,
      mediaCategories: identical(mediaCategories, _notProvided)
          ? this.mediaCategories
          : mediaCategories as Set<CloudMediaCategory>?,
      stage: identical(stage, _notProvided)
          ? this.stage
          : stage as CloudBackupOperationStage?,
      processedItems: identical(processedItems, _notProvided)
          ? this.processedItems
          : processedItems as int?,
      totalItems: identical(totalItems, _notProvided)
          ? this.totalItems
          : totalItems as int?,
      status: status ?? this.status,
    );
  }
}

/// Provider for cloud backup operations
final cloudBackupOperationProvider = StateNotifierProvider<
    CloudBackupOperationNotifier, CloudBackupOperationState>((ref) {
  return CloudBackupOperationNotifier(ref);
});

/// Notifier for cloud backup operations
class CloudBackupOperationNotifier
    extends StateNotifier<CloudBackupOperationState> {
  final Ref _ref;

  CloudBackupOperationNotifier(this._ref)
      : super(const CloudBackupOperationState());

  CloudBackupService get _service => _ref.read(cloudBackupServiceProvider);

  /// Upload backup to iCloud
  Future<CloudBackupInfo?> uploadToICloud(
    Future<Map<String, dynamic>> Function() loadData,
  ) async {
    state = const CloudBackupOperationState(
      isLoading: true,
      stage: CloudBackupOperationStage.preparingData,
      progress: 0,
      status: CloudBackupStatus.uploading,
    );

    try {
      final data = await loadData();
      // Create backup file
      final settings = _ref.read(cloudBackupSettingsProvider);
      final artifacts = await _service.createCloudBackupArtifacts(
        data: data,
        provider: CloudProvider.iCloud,
        options: settings.backupOptions,
        onProgress: _handleArtifactProgress,
      );

      state = state.copyWith(
        stage: CloudBackupOperationStage.uploadingData,
        processedItems: null,
        totalItems: null,
        progress: 0.55,
      );

      // Upload to iCloud
      final backup = await _service.uploadToICloud(
        backupFile: artifacts.dataFile,
        mediaFile: artifacts.mediaFile,
        onPartChanged: (part) {
          state = state.copyWith(
            stage: part == CloudBackupTransferPart.data
                ? CloudBackupOperationStage.uploadingData
                : CloudBackupOperationStage.uploadingMedia,
          );
        },
        onProgress: (progress) {
          state = state.copyWith(progress: 0.55 + progress * 0.45);
        },
      );

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        stage: null,
        processedItems: null,
        totalItems: null,
        status: CloudBackupStatus.success,
        warning: _service.lastMediaWarning,
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
        stage: null,
        processedItems: null,
        totalItems: null,
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
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode)
        restoreCallback,
  }) async {
    state = const CloudBackupOperationState(
      isLoading: true,
      stage: CloudBackupOperationStage.downloadingData,
      progress: 0,
      status: CloudBackupStatus.downloading,
    );

    try {
      // Download backup
      final backupData = await _service.downloadFromICloud(
        backup: backup,
        onPartChanged: (part) {
          state = state.copyWith(
            stage: part == CloudBackupTransferPart.data
                ? CloudBackupOperationStage.downloadingData
                : CloudBackupOperationStage.downloadingMedia,
          );
        },
        onProgress: (progress) {
          state = state.copyWith(progress: progress * 0.6);
        },
        onMediaProgress: (processed, total) {
          final fraction = total == 0 ? 1.0 : processed / total;
          state = state.copyWith(
            stage: CloudBackupOperationStage.restoringMedia,
            processedItems: processed,
            totalItems: total,
            progress: 0.6 + fraction * 0.2,
          );
        },
      );

      state = state.copyWith(
        stage: CloudBackupOperationStage.restoringData,
        processedItems: null,
        totalItems: null,
        progress: 0.8,
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
        stage: null,
        processedItems: null,
        totalItems: null,
        status: CloudBackupStatus.success,
        warning: (backupData['_mediaRestoreWarning'] ??
            backupData['_textRestoreWarning']) as String?,
        mediaIncluded: backupData['media'] is Map,
        mediaRestoredFiles: backupData['_mediaRestoredFiles'] as int?,
        mediaCategories: _mediaCategoriesFromBackup(backupData),
      );

      return mergeResult;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] downloadFromICloud error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        stage: null,
        processedItems: null,
        totalItems: null,
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

  FileExportService get _fileExport => fileExportService;

  Future<CloudBackupArtifacts> _createLocalArtifacts({
    required Map<String, dynamic> data,
    CloudBackupOptions? options,
  }) async {
    final opts =
        options ?? _ref.read(cloudBackupSettingsProvider).backupOptions;
    return _service.exportLocalBackupArtifacts(
      data: data,
      options: opts,
      onProgress: (progress) {
        final progressValue = switch (progress.stage) {
          CloudBackupArtifactStage.scanningMedia => 0.15,
          CloudBackupArtifactStage.compressingMedia =>
            progress.totalFiles != null && progress.totalFiles! > 0
                ? 0.2 + (0.5 * (progress.processedFiles / progress.totalFiles!))
                : 0.45,
          CloudBackupArtifactStage.writingData => 0.85,
        };
        state = state.copyWith(
          currentOperation: switch (progress.stage) {
            CloudBackupArtifactStage.scanningMedia => 'Scanning media files...',
            CloudBackupArtifactStage.compressingMedia =>
              'Compressing media (${progress.processedFiles}/${progress.totalFiles ?? '?'})...',
            CloudBackupArtifactStage.writingData => 'Writing backup file...',
          },
          progress: progressValue,
        );
      },
    );
  }

  Future<File> _combinedBackupFile(CloudBackupArtifacts artifacts) async {
    if (artifacts.combinedFile != null &&
        await artifacts.combinedFile!.exists()) {
      return artifacts.combinedFile!;
    }
    return _service.packageCombinedBackup(
      dataFile: artifacts.dataFile,
      mediaFile: artifacts.mediaFile,
      mediaFileCount: artifacts.mediaFileCount,
    );
  }

  /// Export a combined `.ntx` backup to a user-chosen folder. Falls back to
  /// `NativeTavern/Backups` only when that chosen-folder save cannot complete.
  Future<FileExportOutcome?> exportBackupToFile({
    required Map<String, dynamic> data,
    CloudBackupOptions? options,
    bool combined = true,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Creating backup files...',
      status: CloudBackupStatus.uploading,
      error: null,
    );

    try {
      final artifacts = await _createLocalArtifacts(
        data: data,
        options: options,
      );
      final source =
          combined ? await _combinedBackupFile(artifacts) : artifacts.dataFile;
      final extension = path.extension(source.path).replaceFirst('.', '');
      final outcome = await _fileExport.exportBackup(
        source: source,
        fileName: path.basename(source.path),
        allowedExtensions: [extension],
        dialogTitle: combined
            ? 'Save NativeTavern Backup (.ntx)'
            : 'Save NativeTavern Backup (.ntb)',
      );

      if (!combined &&
          artifacts.mediaFile != null &&
          await artifacts.mediaFile!.exists()) {
        try {
          if (outcome.filesAppFile != null) {
            final destMedia = File(
              path.join(
                outcome.filesAppFile!.parent.path,
                path.basename(artifacts.mediaFile!.path),
              ),
            );
            await artifacts.mediaFile!.copy(destMedia.path);
          } else if (outcome.savedToAppBackups) {
            await _fileExport.copyToAppBackups(artifacts.mediaFile!);
          }
        } catch (mediaCopyErr) {
          debugPrint(
              '[CloudBackup] Could not auto-save .ntm sidecar: $mediaCopyErr');
        }
      }

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: outcome.succeeded
            ? CloudBackupStatus.success
            : CloudBackupStatus.idle,
        warning: _service.lastMediaWarning ?? outcome.error,
      );

      return outcome;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] exportBackupToFile error: $e');
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

  /// Share a combined `.ntx` backup via the native share sheet.
  Future<bool> shareBackup({
    required Map<String, dynamic> data,
    CloudBackupOptions? options,
    Rect? sharePositionOrigin,
    bool combined = true,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Preparing backup to share...',
      status: CloudBackupStatus.uploading,
      error: null,
    );

    try {
      final artifacts = await _createLocalArtifacts(
        data: data,
        options: options,
      );
      final combinedFile =
          combined ? await _combinedBackupFile(artifacts) : artifacts.dataFile;

      final filesToShare = <XFile>[
        XFile(
          combinedFile.path,
          mimeType: combined
              ? 'application/x-nativetavern-package'
              : 'application/x-nativetavern-backup',
          name: path.basename(combinedFile.path),
        ),
      ];

      if (!combined &&
          artifacts.mediaFile != null &&
          await artifacts.mediaFile!.exists()) {
        filesToShare.add(
          XFile(
            artifacts.mediaFile!.path,
            mimeType: 'application/x-nativetavern-media',
            name: path.basename(artifacts.mediaFile!.path),
          ),
        );
      }

      await SharePlus.instance.share(
        ShareParams(
          files: filesToShare,
          subject: 'NativeTavern Backup',
          sharePositionOrigin: sharePositionOrigin,
        ),
      );

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: CloudBackupStatus.success,
        warning: _service.lastMediaWarning,
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] shareBackup error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return false;
    }
  }

  /// Import backup directly from specific local file path(s)
  Future<MergeResult?> importFromPath({
    required String filePath,
    String? mediaPath,
    required RestoreMode mode,
    required Map<String, dynamic> localData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode)
        restoreCallback,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Reading backup file...',
      status: CloudBackupStatus.downloading,
      error: null,
    );

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Backup file does not exist: $filePath');
      }

      File? mediaFile = mediaPath != null ? File(mediaPath) : null;
      if (!_service.isCombinedBackupPath(filePath) &&
          (mediaFile == null || !await mediaFile.exists())) {
        final ntmCandidate = '${path.withoutExtension(filePath)}.ntm';
        final candidateFile = File(ntmCandidate);
        if (await candidateFile.exists()) {
          mediaFile = candidateFile;
        }
      }

      state = state.copyWith(
        currentOperation:
            mediaFile != null || _service.isCombinedBackupPath(filePath)
                ? 'Reading data and restoring media...'
                : 'Reading data backup...',
        progress: 0.3,
      );

      final backupData = await _service.importFromFile(
        file,
        mediaFile: mediaFile,
      );

      state = state.copyWith(
        currentOperation: 'Restoring data...',
        progress: 0.6,
      );

      final mergeResult = await _service.mergeData(
        backupData: backupData,
        localData: localData,
        mode: mode,
      );

      await restoreCallback(backupData, mode);

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        status: CloudBackupStatus.success,
        warning: (backupData['_mediaRestoreWarning'] ??
            backupData['_textRestoreWarning']) as String?,
        mediaIncluded: backupData['media'] is Map,
        mediaRestoredFiles: backupData['_mediaRestoredFiles'] as int?,
        mediaCategories: _mediaCategoriesFromBackup(backupData),
      );

      return mergeResult;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] importFromPath error: $e');
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

  /// Export backup to file (for Google Drive / local Files)
  Future<FileExportOutcome?> exportToFile(Map<String, dynamic> data) async {
    return exportBackupToFile(data: data);
  }

  /// Import backup from file (for Google Drive or local storage)
  Future<MergeResult?> importFromFile({
    required RestoreMode mode,
    required Map<String, dynamic> localData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode)
        restoreCallback,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Selecting file...',
      status: CloudBackupStatus.downloading,
      error: null,
    );

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['ntx', 'ntb', 'ntm'],
        allowMultiple: true,
        dialogTitle:
            'Select a .ntx combined backup, or a .ntb file with its matching .ntm media file',
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          currentOperation: null,
          status: CloudBackupStatus.idle,
        );
        return null;
      }

      final combinedFiles = result.files
          .where((selected) => selected.name.toLowerCase().endsWith('.ntx'))
          .toList();
      final dataFiles = result.files
          .where((selected) => selected.name.toLowerCase().endsWith('.ntb'))
          .toList();

      late final File file;
      File? selectedMediaFile;
      if (combinedFiles.length == 1 && dataFiles.isEmpty) {
        final filePath = combinedFiles.single.path;
        if (filePath == null) {
          throw Exception('The selected backup file is not locally accessible');
        }
        file = File(filePath);
      } else if (dataFiles.length == 1 && combinedFiles.isEmpty) {
        final dataSelection = dataFiles.single;
        final filePath = dataSelection.path;
        if (filePath == null) {
          throw Exception('The selected backup file is not locally accessible');
        }
        file = File(filePath);
        final expectedMediaName =
            '${path.withoutExtension(dataSelection.name)}.ntm';
        final mediaSelection = result.files.cast<PlatformFile?>().firstWhere(
              (candidate) => candidate?.name == expectedMediaName,
              orElse: () => null,
            );
        selectedMediaFile =
            mediaSelection?.path == null ? null : File(mediaSelection!.path!);
      } else {
        throw Exception(
          'Select exactly one NativeTavern .ntx combined backup, or one .ntb data backup',
        );
      }

      state = state.copyWith(
        currentOperation: selectedMediaFile == null
            ? 'Reading data backup...'
            : 'Reading data and restoring media...',
        progress: 0.3,
      );

      final backupData = await _service.importFromFile(
        file,
        mediaFile: selectedMediaFile,
      );

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
        warning: (backupData['_mediaRestoreWarning'] ??
            backupData['_textRestoreWarning']) as String?,
        mediaIncluded: backupData['media'] is Map,
        mediaRestoredFiles: backupData['_mediaRestoredFiles'] as int?,
        mediaCategories: _mediaCategoriesFromBackup(backupData),
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

  GoogleDriveService get _googleDriveService =>
      _ref.read(googleDriveServiceProvider);

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
        _ref
            .read(cloudBackupSettingsProvider.notifier)
            .setGoogleDriveEnabled(true);
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
    _ref
        .read(cloudBackupSettingsProvider.notifier)
        .setGoogleDriveEnabled(false);
    _ref.invalidate(googleDriveUserProvider);
    _ref.invalidate(googleDriveBackupsProvider);
  }

  /// Upload backup to Google Drive
  Future<GoogleDriveBackupInfo?> uploadToGoogleDrive(
    Future<Map<String, dynamic>> Function() loadData,
  ) async {
    state = const CloudBackupOperationState(
      isLoading: true,
      stage: CloudBackupOperationStage.preparingData,
      progress: 0,
      status: CloudBackupStatus.uploading,
    );

    try {
      final data = await loadData();
      final settings = _ref.read(cloudBackupSettingsProvider);
      final artifacts = await _service.createCloudBackupArtifacts(
        data: data,
        provider: CloudProvider.googleDrive,
        options: settings.backupOptions,
        onProgress: _handleArtifactProgress,
      );
      state = state.copyWith(
        stage: CloudBackupOperationStage.uploadingData,
        processedItems: null,
        totalItems: null,
        progress: 0.55,
      );
      final backup = await _googleDriveService.uploadBackupFiles(
        dataFile: artifacts.dataFile,
        mediaFile: artifacts.mediaFile,
        onPartChanged: (part) {
          state = state.copyWith(
            stage: part == GoogleDriveBackupUploadPart.data
                ? CloudBackupOperationStage.uploadingData
                : CloudBackupOperationStage.uploadingMedia,
          );
        },
        onProgress: (progress) {
          state = state.copyWith(progress: 0.55 + progress * 0.45);
        },
      );

      if (backup != null) {
        _ref
            .read(cloudBackupSettingsProvider.notifier)
            .updateLastGoogleDriveSync();
        _ref.invalidate(googleDriveBackupsProvider);
      }

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        stage: null,
        processedItems: null,
        totalItems: null,
        status: backup != null
            ? CloudBackupStatus.success
            : CloudBackupStatus.error,
        error: backup == null ? 'Failed to upload backup' : null,
        warning:
            _service.lastMediaWarning ?? _googleDriveService.lastMediaWarning,
      );

      return backup;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] uploadToGoogleDrive error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        stage: null,
        processedItems: null,
        totalItems: null,
        error: e.toString(),
        status: CloudBackupStatus.error,
      );
      return null;
    }
  }

  void _handleArtifactProgress(CloudBackupArtifactProgress update) {
    switch (update.stage) {
      case CloudBackupArtifactStage.scanningMedia:
        state = state.copyWith(
          stage: CloudBackupOperationStage.scanningMedia,
          processedItems: null,
          totalItems: null,
          progress: 0.1,
        );
        break;
      case CloudBackupArtifactStage.compressingMedia:
        final total = update.totalFiles ?? 0;
        final fraction = total == 0 ? 0.0 : update.processedFiles / total;
        state = state.copyWith(
          stage: CloudBackupOperationStage.compressingMedia,
          processedItems: update.processedFiles,
          totalItems: update.totalFiles,
          progress: 0.1 + fraction * 0.4,
        );
        break;
      case CloudBackupArtifactStage.writingData:
        state = state.copyWith(
          stage: CloudBackupOperationStage.preparingData,
          processedItems: null,
          totalItems: null,
          progress: 0.5,
        );
        break;
    }
  }

  /// Download and restore from Google Drive
  Future<MergeResult?> downloadFromGoogleDrive({
    required String fileId,
    required RestoreMode mode,
    required Map<String, dynamic> localData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode)
        restoreCallback,
  }) async {
    state = const CloudBackupOperationState(
      isLoading: true,
      stage: CloudBackupOperationStage.downloadingData,
      progress: 0,
      status: CloudBackupStatus.downloading,
    );

    try {
      Map<String, dynamic>? backupData;
      final listed = _ref.read(googleDriveBackupsProvider).valueOrNull;
      GoogleDriveBackupInfo? named;
      if (listed != null) {
        for (final item in listed) {
          if (item.id == fileId) {
            named = item;
            break;
          }
        }
      }
      if (named != null && named.name.toLowerCase().endsWith('.ntx')) {
        final cacheDir = await _service.getCloudCacheDirectory();
        final downloaded = await _googleDriveService.downloadToFile(
          fileId: fileId,
          destination: File(path.join(cacheDir.path, named.name)),
        );
        if (downloaded == null) {
          throw Exception('Failed to download backup');
        }
        backupData = await _service.importFromFile(downloaded);
      } else {
        backupData = await _googleDriveService.downloadBackup(
          fileId: fileId,
          onProgress: (progress) {
            state = state.copyWith(progress: progress * 0.5);
          },
        );
      }

      if (backupData == null) {
        throw Exception('Failed to download backup');
      }
      backupData = await _service.restoreTextStateSafely(backupData);

      final media = backupData['media'];
      if (media is Map && media['fileName'] is String) {
        state = state.copyWith(
          stage: CloudBackupOperationStage.downloadingMedia,
          progress: 0.5,
        );
        final mediaBytes = await _googleDriveService.downloadCompanionMedia(
          backupFileId: fileId,
          fileName: media['fileName'] as String,
        );
        if (mediaBytes == null) {
          backupData['_mediaRestoreWarning'] =
              'Optional media backup was not found.';
        } else {
          state = state.copyWith(
            stage: CloudBackupOperationStage.verifyingMedia,
            processedItems: 0,
            totalItems: media['fileCount'] as int?,
            progress: 0.6,
          );
          final outcome = await _service.restoreMediaBytesSafely(
            backupPackage: backupData,
            bytes: mediaBytes,
            onProgress: (processed, total) {
              final fraction = total == 0 ? 1.0 : processed / total;
              state = state.copyWith(
                stage: CloudBackupOperationStage.restoringMedia,
                processedItems: processed,
                totalItems: total,
                progress: 0.65 + fraction * 0.15,
              );
            },
          );
          backupData = outcome.backupPackage;
          backupData['_mediaRestoredFiles'] = outcome.restoredFiles;
          backupData['_mediaSkippedFiles'] = outcome.skippedFiles;
          if (outcome.warning != null) {
            backupData['_mediaRestoreWarning'] = outcome.warning;
          }
        }
      }

      state = state.copyWith(
        stage: CloudBackupOperationStage.restoringData,
        processedItems: null,
        totalItems: null,
        progress: 0.8,
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
        stage: null,
        processedItems: null,
        totalItems: null,
        status: CloudBackupStatus.success,
        warning: (backupData['_mediaRestoreWarning'] ??
            backupData['_textRestoreWarning']) as String?,
        mediaIncluded: backupData['media'] is Map,
        mediaRestoredFiles: backupData['_mediaRestoredFiles'] as int?,
        mediaCategories: _mediaCategoriesFromBackup(backupData),
      );

      return mergeResult;
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] downloadFromGoogleDrive error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        progress: null,
        stage: null,
        processedItems: null,
        totalItems: null,
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

  static const _deviceIdKey = 'cloud_sync_device_id';
  bool _autoSyncInFlight = false;

  Future<String> _deviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_deviceIdKey);
    if (id == null || id.isEmpty) {
      id = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
      await prefs.setString(_deviceIdKey, id);
    }
    return id;
  }

  Future<File> _namedSyncSnapshot(CloudBackupArtifacts artifacts) async {
    final combined = await _combinedBackupFile(artifacts);
    final dest = File(
      path.join(combined.parent.path, CloudBackupService.syncBackupFileName),
    );
    if (dest.path != combined.path) {
      if (await dest.exists()) {
        await dest.delete();
      }
      await combined.copy(dest.path);
    }
    return dest;
  }

  Map<String, dynamic> _syncMetadata(String deviceId) => {
        'deviceId': deviceId,
        'updatedAt': DateTime.now().toUtc().toIso8601String(),
        'fileName': CloudBackupService.syncBackupFileName,
      };

  bool _remoteIsNewer({
    required DateTime? remoteUpdatedAt,
    required DateTime? lastLocalSync,
    required String? remoteDeviceId,
    required String localDeviceId,
  }) {
    if (remoteUpdatedAt == null) return false;
    if (remoteDeviceId != null && remoteDeviceId == localDeviceId) {
      return false;
    }
    if (lastLocalSync == null) return true;
    return remoteUpdatedAt.isAfter(
      lastLocalSync.add(const Duration(seconds: 15)),
    );
  }

  /// Pull remote changes then push the merged local snapshot.
  Future<void> runAutoSync({
    required Future<Map<String, dynamic>> Function() loadData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode)
        restoreCallback,
    bool uploadAfterPull = true,
  }) async {
    final settings = _ref.read(cloudBackupSettingsProvider);
    if (!settings.autoSyncEnabled || _autoSyncInFlight || state.isLoading) {
      return;
    }
    _autoSyncInFlight = true;
    try {
      if (settings.iCloudEnabled) {
        await _autoSyncICloud(
          loadData: loadData,
          restoreCallback: restoreCallback,
          uploadAfterPull: uploadAfterPull,
        );
      }
      if (settings.googleDriveEnabled &&
          _ref.read(googleDriveSignedInProvider)) {
        await _autoSyncGoogleDrive(
          loadData: loadData,
          restoreCallback: restoreCallback,
          uploadAfterPull: uploadAfterPull,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] runAutoSync error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
    } finally {
      _autoSyncInFlight = false;
    }
  }

  /// Upload the current snapshot without downloading.
  Future<void> pushAutoSync({
    required Future<Map<String, dynamic>> Function() loadData,
  }) async {
    final settings = _ref.read(cloudBackupSettingsProvider);
    if (!settings.autoSyncEnabled || _autoSyncInFlight || state.isLoading) {
      return;
    }
    _autoSyncInFlight = true;
    try {
      final data = await loadData();
      final artifacts = await _service.createCloudBackupArtifacts(
        data: data,
        provider: settings.iCloudEnabled
            ? CloudProvider.iCloud
            : CloudProvider.googleDrive,
        options: settings.backupOptions,
      );
      final snapshot = await _namedSyncSnapshot(artifacts);
      final deviceId = await _deviceId();
      if (settings.iCloudEnabled) {
        await _service.uploadToICloud(backupFile: snapshot);
        await _service.writeICloudSyncMetadata(_syncMetadata(deviceId));
        _ref.read(cloudBackupSettingsProvider.notifier).updateLastICloudSync();
        _ref.invalidate(iCloudBackupsProvider);
      }
      if (settings.googleDriveEnabled &&
          _ref.read(googleDriveSignedInProvider)) {
        await _googleDriveService.upsertNamedFile(
          fileName: CloudBackupService.syncBackupFileName,
          source: snapshot,
        );
        await _googleDriveService.upsertNamedJson(
          CloudBackupService.syncMetadataFileName,
          _syncMetadata(deviceId),
        );
        _ref
            .read(cloudBackupSettingsProvider.notifier)
            .updateLastGoogleDriveSync();
        _ref.invalidate(googleDriveBackupsProvider);
      }
    } catch (e, stackTrace) {
      debugPrint('[CloudBackup] pushAutoSync error: $e');
      debugPrint('[CloudBackup] Stack trace: $stackTrace');
    } finally {
      _autoSyncInFlight = false;
    }
  }

  Future<void> _autoSyncICloud({
    required Future<Map<String, dynamic>> Function() loadData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode)
        restoreCallback,
    required bool uploadAfterPull,
  }) async {
    if (await _service.getICloudDirectory() == null) {
      return;
    }
    final settings = _ref.read(cloudBackupSettingsProvider);
    final deviceId = await _deviceId();
    final metadata = await _service.readICloudSyncMetadata();
    final remote = await _service.getICloudSyncBackup();
    final remoteUpdatedAt = metadata?['updatedAt'] != null
        ? DateTime.tryParse(metadata!['updatedAt'] as String)?.toUtc()
        : remote?.createdAt.toUtc();
    final shouldPull = _remoteIsNewer(
      remoteUpdatedAt: remoteUpdatedAt,
      lastLocalSync: settings.lastICloudSync?.toUtc(),
      remoteDeviceId: metadata?['deviceId'] as String?,
      localDeviceId: deviceId,
    );
    if (shouldPull && remote != null) {
      final localData = await loadData();
      await downloadFromICloud(
        backup: remote,
        mode: RestoreMode.merge,
        localData: localData,
        restoreCallback: restoreCallback,
      );
    }
    if (uploadAfterPull) {
      final data = await loadData();
      final artifacts = await _service.createCloudBackupArtifacts(
        data: data,
        provider: CloudProvider.iCloud,
        options: settings.backupOptions,
      );
      final snapshot = await _namedSyncSnapshot(artifacts);
      await _service.uploadToICloud(backupFile: snapshot);
      await _service.writeICloudSyncMetadata(_syncMetadata(deviceId));
      _ref.read(cloudBackupSettingsProvider.notifier).updateLastICloudSync();
      _ref.invalidate(iCloudBackupsProvider);
    }
  }

  Future<void> _autoSyncGoogleDrive({
    required Future<Map<String, dynamic>> Function() loadData,
    required Future<void> Function(Map<String, dynamic> data, RestoreMode mode)
        restoreCallback,
    required bool uploadAfterPull,
  }) async {
    final settings = _ref.read(cloudBackupSettingsProvider);
    final deviceId = await _deviceId();
    final metadata = await _googleDriveService.readNamedJson(
      CloudBackupService.syncMetadataFileName,
    );
    final remote = await _googleDriveService.findNamedFile(
      CloudBackupService.syncBackupFileName,
    );
    final remoteUpdatedAt = metadata?['updatedAt'] != null
        ? DateTime.tryParse(metadata!['updatedAt'] as String)?.toUtc()
        : remote?.modifiedAt?.toUtc() ?? remote?.createdAt.toUtc();
    final shouldPull = _remoteIsNewer(
      remoteUpdatedAt: remoteUpdatedAt,
      lastLocalSync: settings.lastGoogleDriveSync?.toUtc(),
      remoteDeviceId: metadata?['deviceId'] as String?,
      localDeviceId: deviceId,
    );
    if (shouldPull && remote != null) {
      final cacheDir = await _service.getCloudCacheDirectory();
      final downloaded = await _googleDriveService.downloadToFile(
        fileId: remote.id,
        destination: File(
          path.join(cacheDir.path, CloudBackupService.syncBackupFileName),
        ),
      );
      if (downloaded != null) {
        final localData = await loadData();
        await importFromPath(
          filePath: downloaded.path,
          mode: RestoreMode.merge,
          localData: localData,
          restoreCallback: restoreCallback,
        );
      }
    }
    if (uploadAfterPull) {
      final data = await loadData();
      final artifacts = await _service.createCloudBackupArtifacts(
        data: data,
        provider: CloudProvider.googleDrive,
        options: settings.backupOptions,
      );
      final snapshot = await _namedSyncSnapshot(artifacts);
      await _googleDriveService.upsertNamedFile(
        fileName: CloudBackupService.syncBackupFileName,
        source: snapshot,
      );
      await _googleDriveService.upsertNamedJson(
        CloudBackupService.syncMetadataFileName,
        _syncMetadata(deviceId),
      );
      _ref
          .read(cloudBackupSettingsProvider.notifier)
          .updateLastGoogleDriveSync();
      _ref.invalidate(googleDriveBackupsProvider);
    }
  }
}

Set<CloudMediaCategory> _mediaCategoriesFromBackup(
  Map<String, dynamic> backupData,
) {
  final media = backupData['media'];
  if (media is! Map || media['mediaCategories'] is! List) return const {};
  final names = (media['mediaCategories'] as List).whereType<String>().toSet();
  return CloudMediaCategory.values
      .where((category) => names.contains(category.name))
      .toSet();
}
