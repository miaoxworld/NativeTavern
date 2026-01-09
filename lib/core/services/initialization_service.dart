import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Provider for database
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Initialization data returned after startup
class InitializationData {
  final AppDatabase database;
  final String dataPath;

  InitializationData({
    required this.database,
    required this.dataPath,
  });
}

/// Service responsible for initializing the app on startup
class InitializationService {
  static bool _initialized = false;
  static InitializationData? _initData;
  
  /// Initialize all core services
  static Future<InitializationData> initialize() async {
    if (_initialized && _initData != null) {
      return _initData!;
    }
    
    debugPrint('🚀 Initializing NativeTavern...');
    
    // Get data directory
    final appDir = await getApplicationDocumentsDirectory();
    final dataPath = '${appDir.path}/NativeTavern';
    
    // Ensure directories exist
    await _ensureDirectories(dataPath);
    
    // Initialize database
    final database = AppDatabase();
    
    _initData = InitializationData(
      database: database,
      dataPath: dataPath,
    );
    
    _initialized = true;
    debugPrint('✅ NativeTavern initialized successfully');
    debugPrint('📁 Data path: $dataPath');
    
    return _initData!;
  }
  
  /// Ensure all required directories exist
  static Future<void> _ensureDirectories(String basePath) async {
    final directories = [
      'characters',
      'chats',
      'worlds',
      'backgrounds',
      'avatars',
      'assets',
      'thumbnails',
      'models',
      'exports',
    ];
    
    for (final dir in directories) {
      final directory = Directory('$basePath/$dir');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        debugPrint('📁 Created directory: ${directory.path}');
      }
    }
  }
  
  /// Get the data path (must be initialized first)
  static String get dataPath {
    if (_initData == null) {
      throw StateError('InitializationService not initialized');
    }
    return _initData!.dataPath;
  }
  
  /// Get the database (must be initialized first)
  static AppDatabase get database {
    if (_initData == null) {
      throw StateError('InitializationService not initialized');
    }
    return _initData!.database;
  }
}