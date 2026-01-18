import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';

/// Service for SQLite-based database backup and restore
/// This is more reliable than JSON-based backup as it preserves all data types and relationships
class SqliteBackupService {
  static SqliteBackupService? _instance;
  static SqliteBackupService get instance => _instance ??= SqliteBackupService._();
  
  SqliteBackupService._();
  
  /// Get the database file path
  Future<File> getDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, 'NativeTavern', 'database.sqlite'));
  }
  
  /// Get WAL and SHM files (SQLite journal files)
  Future<List<File>> getJournalFiles() async {
    final dbFile = await getDatabaseFile();
    final walFile = File('${dbFile.path}-wal');
    final shmFile = File('${dbFile.path}-shm');
    
    final files = <File>[];
    if (await walFile.exists()) files.add(walFile);
    if (await shmFile.exists()) files.add(shmFile);
    return files;
  }
  
  /// Create a backup of the SQLite database
  /// Returns a zip file containing the database and journal files
  Future<File> createBackup({String? customName}) async {
    final dbFile = await getDatabaseFile();
    if (!await dbFile.exists()) {
      throw Exception('Database file not found');
    }
    
    // Create backup directory
    final cacheDir = await getTemporaryDirectory();
    final backupDir = Directory(p.join(cacheDir.path, 'backups'));
    await backupDir.create(recursive: true);
    
    // Generate backup filename
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final backupName = customName ?? 'NativeTavern_backup_$timestamp';
    final backupFile = File(p.join(backupDir.path, '$backupName.ntbackup'));
    
    debugPrint('[SqliteBackup] Creating backup: ${backupFile.path}');
    
    // Read database file
    final dbBytes = await dbFile.readAsBytes();
    
    // Create archive
    final archive = Archive();
    
    // Add database file
    archive.addFile(ArchiveFile('database.sqlite', dbBytes.length, dbBytes));
    
    // Add WAL and SHM files if they exist
    final journalFiles = await getJournalFiles();
    for (final jFile in journalFiles) {
      final bytes = await jFile.readAsBytes();
      final name = p.basename(jFile.path);
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
      debugPrint('[SqliteBackup] Added journal file: $name');
    }
    
    // Add metadata
    final metadata = {
      'version': 1,
      'created_at': DateTime.now().toIso8601String(),
      'app_version': '1.0.0',
      'schema_version': 12,
    };
    final metadataJson = metadata.toString();
    archive.addFile(ArchiveFile('metadata.json', metadataJson.length, metadataJson.codeUnits));
    
    // Encode and write
    final zipBytes = ZipEncoder().encode(archive);
    if (zipBytes == null) {
      throw Exception('Failed to create backup archive');
    }
    
    await backupFile.writeAsBytes(zipBytes);
    debugPrint('[SqliteBackup] Backup created: ${backupFile.path} (${zipBytes.length} bytes)');
    
    return backupFile;
  }
  
  /// Restore database from a backup file
  /// Mode: 'replace' = completely replace current database
  ///       'merge' = attach backup db and merge data (not implemented yet)
  Future<void> restoreBackup({
    required File backupFile,
    String mode = 'replace',
  }) async {
    debugPrint('[SqliteBackup] Restoring from: ${backupFile.path}');
    
    // Read and decode archive
    final bytes = await backupFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    
    // Extract database file
    ArchiveFile? dbArchiveFile;
    for (final file in archive) {
      if (file.name == 'database.sqlite') {
        dbArchiveFile = file;
        break;
      }
    }
    
    if (dbArchiveFile == null) {
      throw Exception('Invalid backup file: database.sqlite not found');
    }
    
    final dbFile = await getDatabaseFile();
    
    if (mode == 'replace') {
      // Create backup of current database before replacing
      final backupDir = dbFile.parent;
      final backupPath = p.join(backupDir.path, 'database_before_restore_${DateTime.now().millisecondsSinceEpoch}.sqlite');
      if (await dbFile.exists()) {
        await dbFile.copy(backupPath);
        debugPrint('[SqliteBackup] Current database backed up to: $backupPath');
      }
      
      // Delete journal files first
      final journalFiles = await getJournalFiles();
      for (final jFile in journalFiles) {
        await jFile.delete();
        debugPrint('[SqliteBackup] Deleted journal file: ${jFile.path}');
      }
      
      // Write new database file
      await dbFile.writeAsBytes(dbArchiveFile.content as List<int>);
      debugPrint('[SqliteBackup] Database restored');
      
      // Restore journal files if present in backup
      for (final file in archive) {
        if (file.name.endsWith('-wal') || file.name.endsWith('-shm')) {
          final jFile = File('${dbFile.path}${file.name.substring(file.name.lastIndexOf('-'))}');
          await jFile.writeAsBytes(file.content as List<int>);
          debugPrint('[SqliteBackup] Restored journal file: ${jFile.path}');
        }
      }
    } else {
      throw Exception('Merge mode not yet implemented. Please use replace mode.');
    }
  }
  
  /// Get backup file size
  int getBackupSize(File backupFile) {
    return backupFile.lengthSync();
  }
  
  /// Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
