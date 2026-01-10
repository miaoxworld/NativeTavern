import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:native_tavern/data/models/sprite.dart';
import 'package:native_tavern/domain/services/emotion_detection_service.dart';
import 'package:uuid/uuid.dart';

/// Service for managing character expression sprites
class SpriteService {
  final EmotionDetectionService _emotionService;
  final Map<String, SpritePack> _spritePackCache = {};
  
  SpriteService({EmotionDetectionService? emotionService})
      : _emotionService = emotionService ?? EmotionDetectionService();

  /// Get the sprites directory for a character
  Future<Directory> getSpritesDirectory(String characterId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final spritesDir = Directory(
      p.join(appDir.path, 'NativeTavern', 'sprites', characterId),
    );
    if (!await spritesDir.exists()) {
      await spritesDir.create(recursive: true);
    }
    return spritesDir;
  }

  /// Get the sprite pack metadata file path
  Future<File> _getSpritePackFile(String characterId) async {
    final spritesDir = await getSpritesDirectory(characterId);
    return File(p.join(spritesDir.path, 'sprite_pack.json'));
  }

  /// Load sprite pack for a character
  Future<SpritePack> loadSpritePack(String characterId) async {
    // Check cache first
    if (_spritePackCache.containsKey(characterId)) {
      return _spritePackCache[characterId]!;
    }

    final packFile = await _getSpritePackFile(characterId);
    
    if (await packFile.exists()) {
      try {
        final jsonStr = await packFile.readAsString();
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        final pack = SpritePack.fromJson(json);
        _spritePackCache[characterId] = pack;
        return pack;
      } catch (e) {
        // If file is corrupted, return empty pack
        return SpritePack(characterId: characterId);
      }
    }

    // Return empty pack if no sprites exist
    return SpritePack(characterId: characterId);
  }

  /// Save sprite pack for a character
  Future<void> saveSpritePack(SpritePack pack) async {
    final packFile = await _getSpritePackFile(pack.characterId);
    final jsonStr = jsonEncode(pack.toJson());
    await packFile.writeAsString(jsonStr);
    _spritePackCache[pack.characterId] = pack;
  }

  /// Add a sprite to a character's pack
  Future<Sprite> addSprite({
    required String characterId,
    required String emotion,
    required File sourceImage,
  }) async {
    final spritesDir = await getSpritesDirectory(characterId);
    
    // Generate unique filename
    final ext = p.extension(sourceImage.path);
    final filename = '${emotion}_${DateTime.now().millisecondsSinceEpoch}$ext';
    final destPath = p.join(spritesDir.path, filename);
    
    // Copy image to sprites directory
    await sourceImage.copy(destPath);
    
    // Create sprite
    final sprite = Sprite(
      id: const Uuid().v4(),
      characterId: characterId,
      emotion: emotion,
      imagePath: destPath,
      createdAt: DateTime.now(),
    );
    
    // Update sprite pack
    final pack = await loadSpritePack(characterId);
    final updatedSprites = Map<String, Sprite>.from(pack.sprites);
    updatedSprites[emotion] = sprite;
    
    final updatedPack = pack.copyWith(sprites: updatedSprites);
    await saveSpritePack(updatedPack);
    
    return sprite;
  }

  /// Remove a sprite from a character's pack
  Future<void> removeSprite(String characterId, String emotion) async {
    final pack = await loadSpritePack(characterId);
    
    final sprite = pack.sprites[emotion];
    if (sprite != null) {
      // Delete the image file
      final file = File(sprite.imagePath);
      if (await file.exists()) {
        await file.delete();
      }
      
      // Update sprite pack
      final updatedSprites = Map<String, Sprite>.from(pack.sprites);
      updatedSprites.remove(emotion);
      
      final updatedPack = pack.copyWith(sprites: updatedSprites);
      await saveSpritePack(updatedPack);
    }
  }

  /// Set the default emotion for a character's sprite pack
  Future<void> setDefaultEmotion(String characterId, String emotion) async {
    final pack = await loadSpritePack(characterId);
    final updatedPack = pack.copyWith(defaultEmotion: emotion);
    await saveSpritePack(updatedPack);
  }

  /// Get sprite for a message based on emotion detection
  Future<Sprite?> getSpriteForMessage(
    String characterId,
    String messageContent,
  ) async {
    final pack = await loadSpritePack(characterId);
    if (!pack.hasSprites) return null;

    // First try to detect emotion from action text
    final actionEmotion = _emotionService.detectEmotionFromAction(messageContent);
    if (actionEmotion != null) {
      final sprite = pack.sprites[actionEmotion.id];
      if (sprite != null) return sprite;
    }

    // Fall back to general emotion detection
    final emotion = _emotionService.detectEmotion(messageContent);
    return pack.getSprite(emotion.id);
  }

  /// Get sprite for a specific emotion
  Future<Sprite?> getSpriteForEmotion(
    String characterId,
    String emotion,
  ) async {
    final pack = await loadSpritePack(characterId);
    return pack.getSprite(emotion);
  }

  /// Import sprites from a directory (e.g., from SillyTavern)
  Future<int> importSpritesFromDirectory(
    String characterId,
    Directory sourceDir,
  ) async {
    if (!await sourceDir.exists()) return 0;

    int importedCount = 0;
    final spritesDir = await getSpritesDirectory(characterId);
    final pack = await loadSpritePack(characterId);
    final updatedSprites = Map<String, Sprite>.from(pack.sprites);

    // List all image files in the directory
    final entities = await sourceDir.list().toList();
    
    for (final entity in entities) {
      if (entity is File) {
        final ext = p.extension(entity.path).toLowerCase();
        if (['.png', '.jpg', '.jpeg', '.gif', '.webp'].contains(ext)) {
          // Try to determine emotion from filename
          final filename = p.basenameWithoutExtension(entity.path).toLowerCase();
          String? emotion = _matchEmotionFromFilename(filename);
          
          if (emotion != null) {
            // Copy file to sprites directory
            final destFilename = '${emotion}_${DateTime.now().millisecondsSinceEpoch}$ext';
            final destPath = p.join(spritesDir.path, destFilename);
            await entity.copy(destPath);
            
            // Create sprite
            final sprite = Sprite(
              id: const Uuid().v4(),
              characterId: characterId,
              emotion: emotion,
              imagePath: destPath,
              createdAt: DateTime.now(),
            );
            
            updatedSprites[emotion] = sprite;
            importedCount++;
          }
        }
      }
    }

    if (importedCount > 0) {
      final updatedPack = pack.copyWith(sprites: updatedSprites);
      await saveSpritePack(updatedPack);
    }

    return importedCount;
  }

  /// Match emotion from filename
  String? _matchEmotionFromFilename(String filename) {
    // Check each emotion's keywords
    for (final emotion in SpriteEmotion.values) {
      for (final keyword in emotion.allKeywords) {
        if (filename.contains(keyword)) {
          return emotion.id;
        }
      }
    }
    return null;
  }

  /// Delete all sprites for a character
  Future<void> deleteAllSprites(String characterId) async {
    final spritesDir = await getSpritesDirectory(characterId);
    if (await spritesDir.exists()) {
      await spritesDir.delete(recursive: true);
    }
    _spritePackCache.remove(characterId);
  }

  /// Check if a character has any sprites
  Future<bool> hasSprites(String characterId) async {
    final pack = await loadSpritePack(characterId);
    return pack.hasSprites;
  }

  /// Get list of available emotions for a character
  Future<List<String>> getAvailableEmotions(String characterId) async {
    final pack = await loadSpritePack(characterId);
    return pack.availableEmotions;
  }

  /// Clear the sprite pack cache
  void clearCache() {
    _spritePackCache.clear();
  }

  /// Clear cache for a specific character
  void clearCacheForCharacter(String characterId) {
    _spritePackCache.remove(characterId);
  }
}