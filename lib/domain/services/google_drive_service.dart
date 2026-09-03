import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:intl/intl.dart';

enum GoogleDriveBackupUploadPart { data, media }

/// Google Drive backup info
class GoogleDriveBackupInfo {
  final String id;
  final String name;
  final int size;
  final DateTime createdAt;
  final DateTime? modifiedAt;

  const GoogleDriveBackupInfo({
    required this.id,
    required this.name,
    required this.size,
    required this.createdAt,
    this.modifiedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'size': size,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt?.toIso8601String(),
      };

  factory GoogleDriveBackupInfo.fromDriveFile(drive.File file) {
    return GoogleDriveBackupInfo(
      id: file.id ?? '',
      name: file.name ?? 'Unknown',
      size: int.tryParse(file.size ?? '0') ?? 0,
      createdAt: file.createdTime ?? DateTime.now(),
      modifiedAt: file.modifiedTime,
    );
  }
}

/// Service for Google Drive API integration
class GoogleDriveService {
  static final GoogleDriveService instance = GoogleDriveService._();
  String? lastMediaWarning;

  GoogleDriveService._();

  /// Client IDs from config
  ///
  /// IMPORTANT: For macOS/Desktop, you MUST use a "Web application" type
  /// OAuth client ID from Google Cloud Console (NOT Desktop type).
  ///
  /// Steps to create:
  /// 1. Go to Google Cloud Console -> APIs & Services -> Credentials
  /// 2. Create OAuth client ID -> Select "Web application"
  /// 3. Add authorized redirect URI: http://localhost
  /// 4. Use the generated Client ID here
  ///
  /// Desktop type OAuth clients require client_secret which is not supported.
  static String? _configuredWebClientId;
  static const _defaultWebClientId =
      '1077961567755-p0khm1rtqf9d16mjp1ckccb17nc8qlef.apps.googleusercontent.com';
  static const _iosClientId =
      '1077961567755-u0fmbqpg1j94kn3nt0sq7v9ehfalc80g.apps.googleusercontent.com';

  /// Set the web client ID at runtime (useful for loading from config)
  static void setWebClientId(String clientId) {
    _configuredWebClientId = clientId;
  }

  static String get webClientId =>
      _configuredWebClientId ?? _defaultWebClientId;

  /// Folder name in Google Drive for backups
  static const _backupFolderName = 'NativeTavern Backups';

  GoogleSignIn? _googleSignIn;
  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;
  String? _backupFolderId;

  /// Initialize Google Sign-In
  GoogleSignIn _getGoogleSignIn() {
    if (_googleSignIn != null) return _googleSignIn!;

    if (Platform.isIOS) {
      // iOS uses iOS client ID, configured in Info.plist
      _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          drive.DriveApi.driveFileScope,
        ],
      );
    } else if (Platform.isMacOS) {
      // macOS also uses iOS type OAuth client ID (Apple platforms share the same type)
      // The iOS client ID must be configured with the app's Bundle ID
      _googleSignIn = GoogleSignIn(
        clientId: _iosClientId,
        scopes: [
          'email',
          drive.DriveApi.driveFileScope,
        ],
      );
    } else if (Platform.isAndroid) {
      _googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        scopes: [
          'email',
          drive.DriveApi.driveFileScope,
        ],
      );
    } else {
      _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          drive.DriveApi.driveFileScope,
        ],
      );
    }

    return _googleSignIn!;
  }

  /// Check if user is signed in
  bool get isSignedIn => _currentUser != null;

  /// Get current user email
  String? get currentUserEmail => _currentUser?.email;

  /// Get current user display name
  String? get currentUserDisplayName => _currentUser?.displayName;

  /// Get current user photo URL
  String? get currentUserPhotoUrl => _currentUser?.photoUrl;

  /// Sign in to Google
  Future<bool> signIn() async {
    try {
      final googleSignIn = _getGoogleSignIn();

      // Try silent sign in first
      _currentUser = await googleSignIn.signInSilently();

      // If silent sign in failed, do interactive sign in
      _currentUser ??= await googleSignIn.signIn();

      if (_currentUser == null) {
        debugPrint('GoogleDriveService: Sign in cancelled');
        return false;
      }

      debugPrint('GoogleDriveService: Signed in as ${_currentUser!.email}');

      // Initialize Drive API
      await _initDriveApi();

      return true;
    } catch (e) {
      debugPrint('GoogleDriveService: Sign in error: $e');
      _currentUser = null;
      _driveApi = null;
      _backupFolderId = null;
      rethrow;
    }
  }

  /// Try silent sign in only (no UI) - used for auto-login on page load
  /// Returns true if successfully signed in silently, false otherwise
  Future<bool> trySilentSignIn() async {
    try {
      final googleSignIn = _getGoogleSignIn();

      // Only try silent sign in, don't show UI
      _currentUser = await googleSignIn.signInSilently();

      if (_currentUser == null) {
        debugPrint(
            'GoogleDriveService: Silent sign in failed - no cached credentials');
        return false;
      }

      debugPrint(
          'GoogleDriveService: Silently signed in as ${_currentUser!.email}');

      // Initialize Drive API
      await _initDriveApi();

      return true;
    } catch (e) {
      debugPrint('GoogleDriveService: Silent sign in error: $e');
      return false;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _getGoogleSignIn().signOut();
      _currentUser = null;
      _driveApi = null;
      _backupFolderId = null;
      debugPrint('GoogleDriveService: Signed out');
    } catch (e) {
      debugPrint('GoogleDriveService: Sign out error: $e');
    }
  }

  /// Initialize Drive API client
  Future<void> _initDriveApi() async {
    if (_currentUser == null) return;

    try {
      final httpClient = await _getGoogleSignIn().authenticatedClient();
      if (httpClient == null) {
        throw StateError('Failed to initialize Google Drive authentication');
      }

      _driveApi = drive.DriveApi(httpClient);
      debugPrint('GoogleDriveService: Drive API initialized');

      // Get or create backup folder
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) {
        throw StateError('Failed to initialize the Google Drive backup folder');
      }
    } catch (e) {
      debugPrint('GoogleDriveService: Drive API init error: $e');
      _driveApi = null;
      rethrow;
    }
  }

  /// Get or create the backup folder in Google Drive
  Future<String?> _getOrCreateBackupFolder() async {
    if (_driveApi == null) return null;
    if (_backupFolderId != null) return _backupFolderId;

    try {
      // Search for existing folder
      const query =
          "name='$_backupFolderName' and mimeType='application/vnd.google-apps.folder' and trashed=false";
      final response = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      if (response.files != null && response.files!.isNotEmpty) {
        _backupFolderId = response.files!.first.id;
        debugPrint('GoogleDriveService: Found backup folder: $_backupFolderId');
        return _backupFolderId;
      }

      // Create new folder
      final folder = drive.File()
        ..name = _backupFolderName
        ..mimeType = 'application/vnd.google-apps.folder';

      final createdFolder = await _driveApi!.files.create(folder);
      _backupFolderId = createdFolder.id;
      debugPrint('GoogleDriveService: Created backup folder: $_backupFolderId');

      return _backupFolderId;
    } catch (e) {
      debugPrint('GoogleDriveService: Get/create folder error: $e');
      rethrow;
    }
  }

  /// List all backups in Google Drive
  Future<List<GoogleDriveBackupInfo>> listBackups() async {
    if (_driveApi == null) {
      debugPrint('GoogleDriveService: Drive API not initialized');
      return [];
    }

    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return [];

      final query =
          "'$folderId' in parents and trashed=false and (name contains '.ntb' or name contains '.ntx')";
      final response = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        orderBy: 'modifiedTime desc',
        $fields: 'files(id, name, size, createdTime, modifiedTime)',
      );

      if (response.files == null) return [];

      return response.files!
          .map((f) => GoogleDriveBackupInfo.fromDriveFile(f))
          .toList();
    } catch (e) {
      debugPrint('GoogleDriveService: List backups error: $e');
      return [];
    }
  }

  /// Upload backup to Google Drive
  Future<GoogleDriveBackupInfo?> uploadBackup({
    required Map<String, dynamic> data,
    void Function(double progress)? onProgress,
  }) async {
    if (_driveApi == null) {
      debugPrint('GoogleDriveService: Drive API not initialized');
      return null;
    }

    try {
      onProgress?.call(0.0);

      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) {
        debugPrint('GoogleDriveService: Failed to get backup folder');
        return null;
      }

      // Create backup data
      final timestamp =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final fileName = 'NativeTavern_backup_$timestamp.ntb';

      final backupPackage = {
        'version': 2,
        'app': 'NativeTavern',
        'createdAt': DateTime.now().toIso8601String(),
        'provider': 'googleDrive',
        'data': data,
      };

      final content = jsonEncode(backupPackage);
      final bytes = utf8.encode(content);

      onProgress?.call(0.3);

      // Create file metadata
      final fileMetadata = drive.File()
        ..name = fileName
        ..parents = [folderId]
        ..mimeType = 'application/json';

      // Upload file
      final media = drive.Media(
        Stream.value(bytes),
        bytes.length,
      );

      final uploadedFile = await _driveApi!.files.create(
        fileMetadata,
        uploadMedia: media,
        $fields: 'id, name, size, createdTime, modifiedTime',
      );

      onProgress?.call(1.0);

      debugPrint('GoogleDriveService: Uploaded backup: ${uploadedFile.id}');
      return GoogleDriveBackupInfo.fromDriveFile(uploadedFile);
    } catch (e) {
      debugPrint('GoogleDriveService: Upload error: $e');
      return null;
    }
  }

  /// Upload a canonical JSON backup and its optional media sidecar. The JSON
  /// upload completes first; a sidecar error does not invalidate that backup.
  Future<GoogleDriveBackupInfo?> uploadBackupFiles({
    required File dataFile,
    File? mediaFile,
    void Function(double progress)? onProgress,
    void Function(GoogleDriveBackupUploadPart part)? onPartChanged,
  }) async {
    lastMediaWarning = null;
    if (_driveApi == null) return null;
    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return null;
      onPartChanged?.call(GoogleDriveBackupUploadPart.data);
      onProgress?.call(0);
      final dataBytes = await dataFile.readAsBytes();
      final uploaded = await _uploadBytes(
        folderId: folderId,
        fileName: dataFile.uri.pathSegments.last,
        mimeType: 'application/json',
        bytes: dataBytes,
      );
      onProgress?.call(mediaFile == null ? 1 : 0.7);
      if (mediaFile != null) {
        try {
          onPartChanged?.call(GoogleDriveBackupUploadPart.media);
          await _uploadBytes(
            folderId: folderId,
            fileName: mediaFile.uri.pathSegments.last,
            mimeType: 'application/zip',
            bytes: await mediaFile.readAsBytes(),
          );
        } catch (error) {
          debugPrint('GoogleDriveService: Optional media upload error: $error');
          lastMediaWarning =
              'The data backup succeeded, but media upload failed.';
        }
      }
      onProgress?.call(1);
      return GoogleDriveBackupInfo.fromDriveFile(uploaded);
    } catch (error) {
      debugPrint('GoogleDriveService: Backup file upload error: $error');
      return null;
    }
  }

  Future<drive.File> _uploadBytes({
    required String folderId,
    required String fileName,
    required String mimeType,
    required List<int> bytes,
  }) {
    final metadata = drive.File()
      ..name = fileName
      ..parents = [folderId]
      ..mimeType = mimeType;
    return _driveApi!.files.create(
      metadata,
      uploadMedia: drive.Media(Stream.value(bytes), bytes.length),
      $fields: 'id, name, size, createdTime, modifiedTime',
    );
  }

  /// Creates or replaces a file with a stable name, used for automatic sync.
  Future<GoogleDriveBackupInfo?> upsertNamedFile({
    required String fileName,
    required File source,
    String mimeType = 'application/x-nativetavern-package',
  }) async {
    if (_driveApi == null) return null;
    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return null;
      final existing = await _findFileId(folderId, fileName);
      final bytes = await source.readAsBytes();
      final media = drive.Media(Stream.value(bytes), bytes.length);
      late drive.File uploaded;
      if (existing != null) {
        uploaded = await _driveApi!.files.update(
          drive.File()..name = fileName,
          existing,
          uploadMedia: media,
          $fields: 'id, name, size, createdTime, modifiedTime',
        );
      } else {
        uploaded = await _uploadBytes(
          folderId: folderId,
          fileName: fileName,
          mimeType: mimeType,
          bytes: bytes,
        );
      }
      return GoogleDriveBackupInfo.fromDriveFile(uploaded);
    } catch (error) {
      debugPrint('GoogleDriveService: Upsert named file error: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> readNamedJson(String fileName) async {
    if (_driveApi == null) return null;
    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return null;
      final id = await _findFileId(folderId, fileName);
      if (id == null) return null;
      final response = await _driveApi!.files.get(
        id,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;
      final bytes = <int>[];
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
      }
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return decoded.cast<String, dynamic>();
    } catch (error) {
      debugPrint('GoogleDriveService: Read named JSON error: $error');
    }
    return null;
  }

  Future<bool> upsertNamedJson(
    String fileName,
    Map<String, dynamic> data,
  ) async {
    if (_driveApi == null) return false;
    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return false;
      final bytes = utf8.encode(jsonEncode(data));
      final existing = await _findFileId(folderId, fileName);
      final media = drive.Media(Stream.value(bytes), bytes.length);
      if (existing != null) {
        await _driveApi!.files.update(
          drive.File()..name = fileName,
          existing,
          uploadMedia: media,
        );
      } else {
        await _uploadBytes(
          folderId: folderId,
          fileName: fileName,
          mimeType: 'application/json',
          bytes: bytes,
        );
      }
      return true;
    } catch (error) {
      debugPrint('GoogleDriveService: Upsert named JSON error: $error');
      return false;
    }
  }

  Future<GoogleDriveBackupInfo?> findNamedFile(String fileName) async {
    if (_driveApi == null) return null;
    try {
      final folderId = await _getOrCreateBackupFolder();
      if (folderId == null) return null;
      final id = await _findFileId(folderId, fileName);
      if (id == null) return null;
      final file = await _driveApi!.files.get(
        id,
        $fields: 'id, name, size, createdTime, modifiedTime',
      ) as drive.File;
      return GoogleDriveBackupInfo.fromDriveFile(file);
    } catch (error) {
      debugPrint('GoogleDriveService: Find named file error: $error');
      return null;
    }
  }

  Future<String?> _findFileId(String folderId, String fileName) async {
    if (fileName.contains("'")) return null;
    final response = await _driveApi!.files.list(
      q: "'$folderId' in parents and trashed=false and name='$fileName'",
      spaces: 'drive',
      $fields: 'files(id, name)',
    );
    final files = response.files;
    if (files == null || files.isEmpty) return null;
    return files.first.id;
  }

  /// Downloads a Drive file to a local path so `.ntx` zip backups can be parsed.
  Future<File?> downloadToFile({
    required String fileId,
    required File destination,
  }) async {
    if (_driveApi == null) return null;
    try {
      final response = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;
      final bytes = <int>[];
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
      }
      await destination.parent.create(recursive: true);
      await destination.writeAsBytes(bytes, flush: true);
      return destination;
    } catch (error) {
      debugPrint('GoogleDriveService: Download to file error: $error');
      return null;
    }
  }

  /// Download backup from Google Drive
  Future<Map<String, dynamic>?> downloadBackup({
    required String fileId,
    void Function(double progress)? onProgress,
  }) async {
    if (_driveApi == null) {
      debugPrint('GoogleDriveService: Drive API not initialized');
      return null;
    }

    try {
      onProgress?.call(0.0);

      // Download file
      final response = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      onProgress?.call(0.5);

      // Read content
      final bytes = <int>[];
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
      }

      final content = utf8.decode(bytes);
      final data = jsonDecode(content) as Map<String, dynamic>;

      onProgress?.call(1.0);

      debugPrint('GoogleDriveService: Downloaded backup from: $fileId');
      return data;
    } catch (e) {
      debugPrint('GoogleDriveService: Download error: $e');
      return null;
    }
  }

  /// Downloads the optional media file linked by the JSON backup metadata.
  Future<List<int>?> downloadCompanionMedia({
    required String backupFileId,
    required String fileName,
  }) async {
    if (_driveApi == null || fileName.contains("'")) return null;
    try {
      final backup = await _driveApi!.files.get(
        backupFileId,
        $fields: 'parents',
      ) as drive.File;
      final parents = backup.parents;
      final parentId =
          parents == null || parents.isEmpty ? null : parents.first;
      if (parentId == null) return null;
      final response = await _driveApi!.files.list(
        q: "'$parentId' in parents and trashed=false and name='$fileName'",
        spaces: 'drive',
        $fields: 'files(id)',
      );
      final files = response.files;
      final companionId =
          files == null || files.isEmpty ? null : files.first.id;
      if (companionId == null) return null;
      final media = await _driveApi!.files.get(
        companionId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;
      final bytes = <int>[];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }
      return bytes;
    } catch (error) {
      debugPrint('GoogleDriveService: Media download error: $error');
      return null;
    }
  }

  /// Delete backup from Google Drive
  Future<bool> deleteBackup(String fileId) async {
    if (_driveApi == null) {
      debugPrint('GoogleDriveService: Drive API not initialized');
      return false;
    }

    try {
      try {
        final backup = await _driveApi!.files.get(
          fileId,
          $fields: 'name, parents',
        ) as drive.File;
        final name = backup.name;
        final parents = backup.parents;
        final parentId =
            parents == null || parents.isEmpty ? null : parents.first;
        if (name != null && parentId != null && name.endsWith('.ntb')) {
          final mediaName = '${name.substring(0, name.length - 4)}.ntm';
          final companions = await _driveApi!.files.list(
            q: "'$parentId' in parents and trashed=false and name='$mediaName'",
            spaces: 'drive',
            $fields: 'files(id)',
          );
          for (final companion in companions.files ?? const <drive.File>[]) {
            if (companion.id != null) {
              await _driveApi!.files.delete(companion.id!);
            }
          }
        }
      } catch (error) {
        debugPrint('GoogleDriveService: Optional media delete error: $error');
      }
      await _driveApi!.files.delete(fileId);
      debugPrint('GoogleDriveService: Deleted backup: $fileId');
      return true;
    } catch (e) {
      debugPrint('GoogleDriveService: Delete error: $e');
      return false;
    }
  }

  /// Get total backup size
  Future<int> getTotalBackupSize() async {
    final backups = await listBackups();
    return backups.fold<int>(0, (sum, b) => sum + b.size);
  }
}
