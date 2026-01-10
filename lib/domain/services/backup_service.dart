import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

/// Service for managing chat and data backups
class BackupService {
  /// Singleton instance
  static final BackupService instance = BackupService._();
  
  BackupService._();

  /// Get the backups directory
  Future<Directory> getBackupsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupsDir = Directory(path.join(appDir.path, 'NativeTavern', 'backups'));
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }
    return backupsDir;
  }

  /// Get the chat backups directory
  Future<Directory> getChatBackupsDirectory() async {
    final backupsDir = await getBackupsDirectory();
    final chatBackupsDir = Directory(path.join(backupsDir.path, 'chats'));
    if (!await chatBackupsDir.exists()) {
      await chatBackupsDir.create(recursive: true);
    }
    return chatBackupsDir;
  }

  /// Get the full backups directory
  Future<Directory> getFullBackupsDirectory() async {
    final backupsDir = await getBackupsDirectory();
    final fullBackupsDir = Directory(path.join(backupsDir.path, 'full'));
    if (!await fullBackupsDir.exists()) {
      await fullBackupsDir.create(recursive: true);
    }
    return fullBackupsDir;
  }

  // ==================== Chat Backups ====================

  /// Create a backup of a single chat
  Future<BackupInfo> backupChat({
    required String chatId,
    required String characterName,
    required List<Map<String, dynamic>> messages,
    Map<String, dynamic>? metadata,
  }) async {
    final backupsDir = await getChatBackupsDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final safeName = characterName.replaceAll(RegExp(r'[^\w\s-]'), '_');
    final fileName = '${safeName}_${chatId}_$timestamp.jsonl';
    final filePath = path.join(backupsDir.path, fileName);

    final file = File(filePath);
    final sink = file.openWrite();

    try {
      // Write metadata as first line if provided
      if (metadata != null) {
        sink.writeln(jsonEncode({
          'type': 'metadata',
          'chatId': chatId,
          'characterName': characterName,
          'backupDate': DateTime.now().toIso8601String(),
          ...metadata,
        }));
      }

      // Write each message as a line
      for (final message in messages) {
        sink.writeln(jsonEncode(message));
      }

      await sink.flush();
    } finally {
      await sink.close();
    }

    final stat = await file.stat();
    return BackupInfo(
      name: fileName,
      path: filePath,
      size: stat.size,
      createdAt: DateTime.now(),
      type: BackupType.chat,
      characterName: characterName,
      chatId: chatId,
    );
  }

  /// List all chat backups
  Future<List<BackupInfo>> listChatBackups() async {
    final backupsDir = await getChatBackupsDirectory();
    final backups = <BackupInfo>[];

    await for (final entity in backupsDir.list()) {
      if (entity is File && entity.path.endsWith('.jsonl')) {
        final stat = await entity.stat();
        final fileName = path.basename(entity.path);
        
        // Parse filename to extract info
        final parts = fileName.replaceAll('.jsonl', '').split('_');
        String? characterName;
        String? chatId;
        
        if (parts.length >= 3) {
          characterName = parts[0];
          chatId = parts[1];
        }

        backups.add(BackupInfo(
          name: fileName,
          path: entity.path,
          size: stat.size,
          createdAt: stat.modified,
          type: BackupType.chat,
          characterName: characterName,
          chatId: chatId,
        ));
      }
    }

    // Sort by date, newest first
    backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return backups;
  }

  /// Read a chat backup
  Future<ChatBackupData> readChatBackup(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('Backup file not found', filePath);
    }

    final lines = await file.readAsLines();
    final messages = <Map<String, dynamic>>[];
    Map<String, dynamic>? metadata;

    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      try {
        final data = jsonDecode(line) as Map<String, dynamic>;
        if (data['type'] == 'metadata') {
          metadata = data;
        } else {
          messages.add(data);
        }
      } catch (e) {
        print('BackupService: Failed to parse line: $e');
      }
    }

    return ChatBackupData(
      messages: messages,
      metadata: metadata,
    );
  }

  /// Delete a chat backup
  Future<void> deleteChatBackup(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // ==================== Full Backups ====================

  /// Create a full backup of all data
  Future<BackupInfo> createFullBackup({
    required Map<String, dynamic> characters,
    required Map<String, dynamic> chats,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> worldInfo,
    Map<String, dynamic>? additionalData,
  }) async {
    final backupsDir = await getFullBackupsDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final fileName = 'NativeTavern_backup_$timestamp.json';
    final filePath = path.join(backupsDir.path, fileName);

    final backupData = {
      'version': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'app': 'NativeTavern',
      'characters': characters,
      'chats': chats,
      'settings': settings,
      'worldInfo': worldInfo,
      if (additionalData != null) ...additionalData,
    };

    final file = File(filePath);
    await file.writeAsString(jsonEncode(backupData));

    final stat = await file.stat();
    return BackupInfo(
      name: fileName,
      path: filePath,
      size: stat.size,
      createdAt: DateTime.now(),
      type: BackupType.full,
    );
  }

  /// List all full backups
  Future<List<BackupInfo>> listFullBackups() async {
    final backupsDir = await getFullBackupsDirectory();
    final backups = <BackupInfo>[];

    await for (final entity in backupsDir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        final stat = await entity.stat();
        final fileName = path.basename(entity.path);

        backups.add(BackupInfo(
          name: fileName,
          path: entity.path,
          size: stat.size,
          createdAt: stat.modified,
          type: BackupType.full,
        ));
      }
    }

    // Sort by date, newest first
    backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return backups;
  }

  /// Read a full backup
  Future<Map<String, dynamic>> readFullBackup(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('Backup file not found', filePath);
    }

    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }

  /// Delete a full backup
  Future<void> deleteFullBackup(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // ==================== Auto-Backup ====================

  /// Check if auto-backup is needed based on settings
  bool shouldAutoBackup({
    required DateTime? lastBackup,
    required AutoBackupInterval interval,
  }) {
    if (lastBackup == null) return true;

    final now = DateTime.now();
    final diff = now.difference(lastBackup);

    switch (interval) {
      case AutoBackupInterval.hourly:
        return diff.inHours >= 1;
      case AutoBackupInterval.daily:
        return diff.inDays >= 1;
      case AutoBackupInterval.weekly:
        return diff.inDays >= 7;
      case AutoBackupInterval.monthly:
        return diff.inDays >= 30;
      case AutoBackupInterval.never:
        return false;
    }
  }

  /// Clean up old backups based on retention policy
  Future<int> cleanupOldBackups({
    required int maxBackups,
    required BackupType type,
  }) async {
    final backups = type == BackupType.chat
        ? await listChatBackups()
        : await listFullBackups();

    if (backups.length <= maxBackups) {
      return 0;
    }

    int deleted = 0;
    final toDelete = backups.skip(maxBackups).toList();

    for (final backup in toDelete) {
      try {
        if (type == BackupType.chat) {
          await deleteChatBackup(backup.path);
        } else {
          await deleteFullBackup(backup.path);
        }
        deleted++;
      } catch (e) {
        print('BackupService: Failed to delete old backup: $e');
      }
    }

    return deleted;
  }

  // ==================== Export/Import ====================

  /// Export a backup to a shareable format
  Future<String> exportBackup(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('Backup file not found', filePath);
    }
    return await file.readAsString();
  }

  /// Import a backup from string content
  Future<BackupInfo> importBackup({
    required String content,
    required String fileName,
    required BackupType type,
  }) async {
    final backupsDir = type == BackupType.chat
        ? await getChatBackupsDirectory()
        : await getFullBackupsDirectory();

    final filePath = path.join(backupsDir.path, fileName);
    final file = File(filePath);
    await file.writeAsString(content);

    final stat = await file.stat();
    return BackupInfo(
      name: fileName,
      path: filePath,
      size: stat.size,
      createdAt: DateTime.now(),
      type: type,
    );
  }

  /// Get total backup size
  Future<int> getTotalBackupSize() async {
    int totalSize = 0;

    final chatBackups = await listChatBackups();
    for (final backup in chatBackups) {
      totalSize += backup.size;
    }

    final fullBackups = await listFullBackups();
    for (final backup in fullBackups) {
      totalSize += backup.size;
    }

    return totalSize;
  }

  /// Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Backup type
enum BackupType {
  chat,
  full,
}

/// Auto-backup interval
enum AutoBackupInterval {
  never,
  hourly,
  daily,
  weekly,
  monthly,
}

extension AutoBackupIntervalExtension on AutoBackupInterval {
  String get displayName {
    switch (this) {
      case AutoBackupInterval.never:
        return 'Never';
      case AutoBackupInterval.hourly:
        return 'Hourly';
      case AutoBackupInterval.daily:
        return 'Daily';
      case AutoBackupInterval.weekly:
        return 'Weekly';
      case AutoBackupInterval.monthly:
        return 'Monthly';
    }
  }
}

/// Information about a backup
class BackupInfo {
  final String name;
  final String path;
  final int size;
  final DateTime createdAt;
  final BackupType type;
  final String? characterName;
  final String? chatId;

  const BackupInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.createdAt,
    required this.type,
    this.characterName,
    this.chatId,
  });

  String get formattedSize => BackupService.instance.formatFileSize(size);

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    
    return DateFormat('MMM d, yyyy').format(createdAt);
  }
}

/// Data from a chat backup
class ChatBackupData {
  final List<Map<String, dynamic>> messages;
  final Map<String, dynamic>? metadata;

  const ChatBackupData({
    required this.messages,
    this.metadata,
  });

  int get messageCount => messages.length;

  String? get characterName => metadata?['characterName'] as String?;
  String? get chatId => metadata?['chatId'] as String?;
  DateTime? get backupDate {
    final dateStr = metadata?['backupDate'] as String?;
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }
}