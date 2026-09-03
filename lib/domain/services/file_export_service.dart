import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Result of saving a file through the system Files/Documents picker
/// and/or the app's local Backups folder.
class FileExportOutcome {
  final File? filesAppFile;
  final File? appBackupFile;
  final bool cancelled;
  final String? error;

  const FileExportOutcome({
    this.filesAppFile,
    this.appBackupFile,
    this.cancelled = false,
    this.error,
  });

  bool get savedToFilesApp => filesAppFile != null;
  bool get savedToAppBackups => appBackupFile != null;
  bool get succeeded => savedToFilesApp || savedToAppBackups;
}

/// Saves exported files to a user-chosen folder in the system Files app.
/// Combined backups fall back to `NativeTavern/Backups` only when that
/// chosen-folder save cannot be completed.
class FileExportService {
  static const MethodChannel _visibilityChannel =
      MethodChannel('com.nativetavern/file_open');

  static const appDataFolderName = 'NativeTavern';
  static const backupsFolderName = 'Backups';

  FileExportService({
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _documentsDirectoryProvider =
            documentsDirectoryProvider ?? getApplicationDocumentsDirectory;

  factory FileExportService.forTesting({
    required Directory documentsDirectory,
  }) {
    return FileExportService(
      documentsDirectoryProvider: () async => documentsDirectory,
    );
  }

  final Future<Directory> Function() _documentsDirectoryProvider;

  /// Cloud-style backup file name, e.g. `NativeTavern_cloud_backup_2026-09-01_12-00-00.ntx`.
  static String cloudBackupFileName({
    String extension = 'ntx',
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
      path.join(documents.path, appDataFolderName, backupsFolderName),
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    await prepareBackupFolderVisibility();
    return dir;
  }

  /// Asks the platform to expose only the Backups folder in the system Files app.
  Future<void> prepareBackupFolderVisibility() async {
    try {
      await _visibilityChannel.invokeMethod<String>('prepareBackupVisibility');
    } catch (error) {
      debugPrint('FileExportService: prepareBackupVisibility failed: $error');
    }
  }

  Future<File> copyToAppBackups(
    File source, {
    String? fileName,
  }) async {
    final dir = await getAppBackupsDirectory();
    final name = fileName ?? path.basename(source.path);
    final dest = File(path.join(dir.path, name));
    if (path.equals(source.path, dest.path)) return dest;
    return source.copy(dest.path);
  }

  Future<File> writeToAppBackups({
    required String fileName,
    required List<int> bytes,
  }) async {
    final dir = await getAppBackupsDirectory();
    final dest = File(path.join(dir.path, fileName));
    await dest.writeAsBytes(bytes, flush: true);
    return dest;
  }

  /// Save [bytes] through the system Files / document picker.
  ///
  /// On iOS and Android the picker writes [bytes] itself. On desktop the
  /// returned path is written here. Returns null if the user cancels.
  /// Throws if the user chose a location but the file could not be written.
  Future<File?> saveToFilesApp({
    required String fileName,
    required List<int> bytes,
    List<String>? allowedExtensions,
    String? dialogTitle,
  }) async {
    final payload = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
    final result = await FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      bytes: payload,
      type: allowedExtensions == null || allowedExtensions.isEmpty
          ? FileType.any
          : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result == null || result.isEmpty) return null;

    final dest = File(result);
    if (Platform.isIOS || Platform.isAndroid) {
      // The plugin already wrote [bytes] into the user-chosen location.
      return dest;
    }
    await dest.parent.create(recursive: true);
    await dest.writeAsBytes(payload, flush: true);
    return dest;
  }

  /// Save a backup to a user-chosen folder. `NativeTavern/Backups` is used
  /// only when that chosen-folder save cannot be completed.
  Future<FileExportOutcome> exportBackup({
    required File source,
    String? fileName,
    List<String>? allowedExtensions,
    String? dialogTitle,
  }) async {
    final name = fileName ?? path.basename(source.path);
    final bytes = await source.readAsBytes();

    try {
      final filesApp = await saveToFilesApp(
        fileName: name,
        bytes: bytes,
        allowedExtensions: allowedExtensions,
        dialogTitle: dialogTitle,
      );
      return resolveBackupExport(
        source: source,
        fileName: name,
        chosenFile: filesApp,
      );
    } catch (error) {
      debugPrint('FileExportService: Files app save failed: $error');
      return resolveBackupExport(
        source: source,
        fileName: name,
        saveError: error,
      );
    }
  }

  /// Decides whether a backup belongs in the chosen folder or the app
  /// Backups fallback. A user cancel never writes to Backups.
  @visibleForTesting
  Future<FileExportOutcome> resolveBackupExport({
    required File source,
    required String fileName,
    File? chosenFile,
    Object? saveError,
  }) async {
    if (chosenFile != null && saveError == null) {
      return FileExportOutcome(filesAppFile: chosenFile);
    }
    if (saveError == null) {
      return const FileExportOutcome(cancelled: true);
    }

    try {
      final appCopy = await copyToAppBackups(source, fileName: fileName);
      return FileExportOutcome(
        appBackupFile: appCopy,
        error: saveError.toString(),
      );
    } catch (fallbackError) {
      debugPrint('FileExportService: Backups fallback failed: $fallbackError');
      return FileExportOutcome(error: fallbackError.toString());
    }
  }

  /// Save an arbitrary export to the system Files app.
  Future<FileExportOutcome> exportFile({
    required String fileName,
    required List<int> bytes,
    List<String>? allowedExtensions,
    String? dialogTitle,
  }) async {
    try {
      final filesApp = await saveToFilesApp(
        fileName: fileName,
        bytes: bytes,
        allowedExtensions: allowedExtensions,
        dialogTitle: dialogTitle,
      );
      return FileExportOutcome(
        filesAppFile: filesApp,
        cancelled: filesApp == null,
      );
    } catch (error) {
      debugPrint('FileExportService: Files app save failed: $error');
      return FileExportOutcome(error: error.toString());
    }
  }

  Future<void> shareFiles({
    required List<File> files,
    String? subject,
    String? mimeType,
    Rect? sharePositionOrigin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          for (final file in files)
            XFile(
              file.path,
              mimeType: mimeType,
              name: path.basename(file.path),
            ),
        ],
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}

final fileExportService = FileExportService();
