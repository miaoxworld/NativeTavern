import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:intl/intl.dart';

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
  static const _defaultWebClientId = '1077961567755-p0khm1rtqf9d16mjp1ckccb17nc8qlef.apps.googleusercontent.com';
  static const _iosClientId = '1077961567755-u0fmbqpg1j94kn3nt0sq7v9ehfalc80g.apps.googleusercontent.com';
  
  /// Set the web client ID at runtime (useful for loading from config)
  static void setWebClientId(String clientId) {
    _configuredWebClientId = clientId;
  }
  
  static String get webClientId => _configuredWebClientId ?? _defaultWebClientId;
  
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
    } else {
      // Android and other platforms
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
        debugPrint('GoogleDriveService: Failed to get authenticated client');
        return;
      }
      
      _driveApi = drive.DriveApi(httpClient);
      debugPrint('GoogleDriveService: Drive API initialized');
      
      // Get or create backup folder
      await _getOrCreateBackupFolder();
    } catch (e) {
      debugPrint('GoogleDriveService: Drive API init error: $e');
    }
  }
  
  /// Get or create the backup folder in Google Drive
  Future<String?> _getOrCreateBackupFolder() async {
    if (_driveApi == null) return null;
    if (_backupFolderId != null) return _backupFolderId;
    
    try {
      // Search for existing folder
      final query = "name='$_backupFolderName' and mimeType='application/vnd.google-apps.folder' and trashed=false";
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
      return null;
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
      
      final query = "'$folderId' in parents and trashed=false and name contains '.ntb'";
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
      final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
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
  
  /// Delete backup from Google Drive
  Future<bool> deleteBackup(String fileId) async {
    if (_driveApi == null) {
      debugPrint('GoogleDriveService: Drive API not initialized');
      return false;
    }
    
    try {
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
