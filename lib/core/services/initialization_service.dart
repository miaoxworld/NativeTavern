import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/data/models/character.dart' as models;
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/world_info_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const String _defaultCharacterCreatedKey = 'default_character_created';
  static const String _builtInCharactersLoadedKey = 'builtin_characters_loaded';
  static const String _builtInWorldInfosLoadedKey = 'builtin_worldinfos_loaded';
  
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
    
    // Create default character if first launch
    await _ensureDefaultCharacter(database);
    
    // Load built-in characters
    await _loadBuiltInCharacters(database, dataPath);
    
    // Load built-in world infos
    await _loadBuiltInWorldInfos(database);
    
    _initialized = true;
    debugPrint('✅ NativeTavern initialized successfully');
    debugPrint('📁 Data path: $dataPath');
    
    return _initData!;
  }

  /// Ensure a default character exists on first launch
  static Future<void> _ensureDefaultCharacter(AppDatabase database) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaultCreated = prefs.getBool(_defaultCharacterCreatedKey) ?? false;
      
      if (defaultCreated) {
        debugPrint('📝 Default character already created');
        return;
      }
      
      // Get data path for repository
      final appDir = await getApplicationDocumentsDirectory();
      final dataPath = '${appDir.path}/NativeTavern';
      
      // Check if any characters exist
      final repo = CharacterRepository(database, dataPath);
      final characters = await repo.getAllCharacters();
      
      if (characters.isEmpty) {
        debugPrint('📝 Creating default character...');
        
        final now = DateTime.now();
        final defaultCharacter = models.Character(
          id: '',
          name: 'Assistant',
          description: 'A helpful AI assistant ready to chat with you.',
          personality: 'Friendly, helpful, knowledgeable, and conversational.',
          scenario: 'You are chatting with a helpful AI assistant.',
          firstMessage: 'Hello! I\'m your AI assistant. How can I help you today?',
          alternateGreetings: [
            'Hi there! What would you like to talk about?',
            'Greetings! I\'m here to assist you with anything you need.',
          ],
          exampleMessages: '',
          systemPrompt: 'You are a helpful AI assistant. Be friendly, informative, and engaging in your responses.',
          postHistoryInstructions: '',
          creatorNotes: 'This is the default character created on first launch. Feel free to edit or delete it.',
          tags: ['assistant', 'default'],
          creator: 'NativeTavern',
          version: '1.0.0',
          createdAt: now,
          modifiedAt: now,
        );
        
        await repo.createCharacter(defaultCharacter);
        debugPrint('✅ Default character created successfully');
      }
      
      // Mark as created
      await prefs.setBool(_defaultCharacterCreatedKey, true);
    } catch (e) {
      debugPrint('⚠️ Failed to create default character: $e');
    }
  }

  /// Load built-in characters from assets
  static Future<void> _loadBuiltInCharacters(AppDatabase database, String dataPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final builtInLoaded = prefs.getBool(_builtInCharactersLoadedKey) ?? false;
      
      if (builtInLoaded) {
        debugPrint('📦 Built-in characters already loaded');
        return;
      }
      
      debugPrint('📦 Loading built-in characters...');
      final repo = CharacterRepository(database, dataPath);
      await repo.loadBuiltInCharacters();
      
      // Mark as loaded
      await prefs.setBool(_builtInCharactersLoadedKey, true);
      debugPrint('✅ Built-in characters loaded successfully');
    } catch (e) {
      debugPrint('⚠️ Failed to load built-in characters: $e');
    }
  }

  /// Load built-in world infos from assets
  static Future<void> _loadBuiltInWorldInfos(AppDatabase database) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final worldInfosLoaded = prefs.getBool(_builtInWorldInfosLoadedKey) ?? false;
      
      if (worldInfosLoaded) {
        debugPrint('📚 Built-in world infos already loaded');
        return;
      }
      
      debugPrint('📚 Loading built-in world infos...');
      final repo = WorldInfoRepository(database);
      await repo.loadBuiltInWorldInfos();
      
      // Mark as loaded
      await prefs.setBool(_builtInWorldInfosLoadedKey, true);
      debugPrint('✅ Built-in world infos loaded successfully');
    } catch (e) {
      debugPrint('⚠️ Failed to load built-in world infos: $e');
    }
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