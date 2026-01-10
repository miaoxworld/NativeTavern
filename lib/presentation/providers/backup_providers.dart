import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/domain/services/backup_service.dart';

/// Provider for the backup service singleton
final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService.instance;
});

/// Provider for backup settings
final backupSettingsProvider = StateNotifierProvider<BackupSettingsNotifier, BackupSettings>((ref) {
  return BackupSettingsNotifier();
});

/// Backup settings
class BackupSettings {
  final bool autoBackupEnabled;
  final AutoBackupInterval autoBackupInterval;
  final int maxChatBackups;
  final int maxFullBackups;
  final DateTime? lastAutoBackup;
  final bool backupOnExit;

  const BackupSettings({
    this.autoBackupEnabled = false,
    this.autoBackupInterval = AutoBackupInterval.daily,
    this.maxChatBackups = 50,
    this.maxFullBackups = 10,
    this.lastAutoBackup,
    this.backupOnExit = false,
  });

  BackupSettings copyWith({
    bool? autoBackupEnabled,
    AutoBackupInterval? autoBackupInterval,
    int? maxChatBackups,
    int? maxFullBackups,
    DateTime? lastAutoBackup,
    bool? backupOnExit,
  }) {
    return BackupSettings(
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      autoBackupInterval: autoBackupInterval ?? this.autoBackupInterval,
      maxChatBackups: maxChatBackups ?? this.maxChatBackups,
      maxFullBackups: maxFullBackups ?? this.maxFullBackups,
      lastAutoBackup: lastAutoBackup ?? this.lastAutoBackup,
      backupOnExit: backupOnExit ?? this.backupOnExit,
    );
  }

  Map<String, dynamic> toJson() => {
    'autoBackupEnabled': autoBackupEnabled,
    'autoBackupInterval': autoBackupInterval.name,
    'maxChatBackups': maxChatBackups,
    'maxFullBackups': maxFullBackups,
    'lastAutoBackup': lastAutoBackup?.toIso8601String(),
    'backupOnExit': backupOnExit,
  };

  factory BackupSettings.fromJson(Map<String, dynamic> json) {
    return BackupSettings(
      autoBackupEnabled: json['autoBackupEnabled'] as bool? ?? false,
      autoBackupInterval: AutoBackupInterval.values.firstWhere(
        (i) => i.name == json['autoBackupInterval'],
        orElse: () => AutoBackupInterval.daily,
      ),
      maxChatBackups: json['maxChatBackups'] as int? ?? 50,
      maxFullBackups: json['maxFullBackups'] as int? ?? 10,
      lastAutoBackup: json['lastAutoBackup'] != null
          ? DateTime.tryParse(json['lastAutoBackup'] as String)
          : null,
      backupOnExit: json['backupOnExit'] as bool? ?? false,
    );
  }
}

/// Notifier for backup settings
class BackupSettingsNotifier extends StateNotifier<BackupSettings> {
  static const _storageKey = 'backup_settings';
  
  BackupSettingsNotifier() : super(const BackupSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) {
          state = BackupSettings.fromJson(decoded);
        }
      }
    } catch (e) {
      print('Error loading backup settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(state.toJson()));
    } catch (e) {
      print('Error saving backup settings: $e');
    }
  }

  void setAutoBackupEnabled(bool value) {
    state = state.copyWith(autoBackupEnabled: value);
    _saveSettings();
  }

  void setAutoBackupInterval(AutoBackupInterval value) {
    state = state.copyWith(autoBackupInterval: value);
    _saveSettings();
  }

  void setMaxChatBackups(int value) {
    state = state.copyWith(maxChatBackups: value);
    _saveSettings();
  }

  void setMaxFullBackups(int value) {
    state = state.copyWith(maxFullBackups: value);
    _saveSettings();
  }

  void setBackupOnExit(bool value) {
    state = state.copyWith(backupOnExit: value);
    _saveSettings();
  }

  void updateLastAutoBackup() {
    state = state.copyWith(lastAutoBackup: DateTime.now());
    _saveSettings();
  }

  void reset() {
    state = const BackupSettings();
    _saveSettings();
  }
}

/// Provider for chat backups list
final chatBackupsProvider = FutureProvider<List<BackupInfo>>((ref) async {
  final service = ref.watch(backupServiceProvider);
  return service.listChatBackups();
});

/// Provider for full backups list
final fullBackupsProvider = FutureProvider<List<BackupInfo>>((ref) async {
  final service = ref.watch(backupServiceProvider);
  return service.listFullBackups();
});

/// Provider for total backup size
final totalBackupSizeProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(backupServiceProvider);
  return service.getTotalBackupSize();
});

/// Provider for backup operations state
final backupOperationProvider = StateNotifierProvider<BackupOperationNotifier, BackupOperationState>((ref) {
  return BackupOperationNotifier(ref);
});

/// State for backup operations
class BackupOperationState {
  final bool isLoading;
  final String? currentOperation;
  final double? progress;
  final String? error;
  final BackupInfo? lastBackup;

  const BackupOperationState({
    this.isLoading = false,
    this.currentOperation,
    this.progress,
    this.error,
    this.lastBackup,
  });

  BackupOperationState copyWith({
    bool? isLoading,
    String? currentOperation,
    double? progress,
    String? error,
    BackupInfo? lastBackup,
  }) {
    return BackupOperationState(
      isLoading: isLoading ?? this.isLoading,
      currentOperation: currentOperation,
      progress: progress,
      error: error,
      lastBackup: lastBackup ?? this.lastBackup,
    );
  }
}

/// Notifier for backup operations
class BackupOperationNotifier extends StateNotifier<BackupOperationState> {
  final Ref _ref;
  
  BackupOperationNotifier(this._ref) : super(const BackupOperationState());

  BackupService get _service => _ref.read(backupServiceProvider);

  /// Create a chat backup
  Future<BackupInfo?> backupChat({
    required String chatId,
    required String characterName,
    required List<Map<String, dynamic>> messages,
    Map<String, dynamic>? metadata,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Creating chat backup...',
      error: null,
    );

    try {
      final backup = await _service.backupChat(
        chatId: chatId,
        characterName: characterName,
        messages: messages,
        metadata: metadata,
      );

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        lastBackup: backup,
      );

      // Refresh the backups list
      _ref.invalidate(chatBackupsProvider);
      _ref.invalidate(totalBackupSizeProvider);

      return backup;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Delete a chat backup
  Future<bool> deleteChatBackup(String filePath) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Deleting backup...',
      error: null,
    );

    try {
      await _service.deleteChatBackup(filePath);

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
      );

      // Refresh the backups list
      _ref.invalidate(chatBackupsProvider);
      _ref.invalidate(totalBackupSizeProvider);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Create a full backup
  Future<BackupInfo?> createFullBackup({
    required Map<String, dynamic> characters,
    required Map<String, dynamic> chats,
    required Map<String, dynamic> settings,
    required Map<String, dynamic> worldInfo,
  }) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Creating full backup...',
      error: null,
    );

    try {
      final backup = await _service.createFullBackup(
        characters: characters,
        chats: chats,
        settings: settings,
        worldInfo: worldInfo,
      );

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        lastBackup: backup,
      );

      // Refresh the backups list
      _ref.invalidate(fullBackupsProvider);
      _ref.invalidate(totalBackupSizeProvider);

      // Update last backup time
      _ref.read(backupSettingsProvider.notifier).updateLastAutoBackup();

      return backup;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Delete a full backup
  Future<bool> deleteFullBackup(String filePath) async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Deleting backup...',
      error: null,
    );

    try {
      await _service.deleteFullBackup(filePath);

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
      );

      // Refresh the backups list
      _ref.invalidate(fullBackupsProvider);
      _ref.invalidate(totalBackupSizeProvider);

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Cleanup old backups
  Future<int> cleanupOldBackups() async {
    state = state.copyWith(
      isLoading: true,
      currentOperation: 'Cleaning up old backups...',
      error: null,
    );

    try {
      final settings = _ref.read(backupSettingsProvider);
      
      int deleted = 0;
      deleted += await _service.cleanupOldBackups(
        maxBackups: settings.maxChatBackups,
        type: BackupType.chat,
      );
      deleted += await _service.cleanupOldBackups(
        maxBackups: settings.maxFullBackups,
        type: BackupType.full,
      );

      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
      );

      // Refresh the backups list
      _ref.invalidate(chatBackupsProvider);
      _ref.invalidate(fullBackupsProvider);
      _ref.invalidate(totalBackupSizeProvider);

      return deleted;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        currentOperation: null,
        error: e.toString(),
      );
      return 0;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}