/// Sprite model for character expression images
class Sprite {
  final String id;
  final String characterId;
  final String emotion;
  final String imagePath;
  final int priority;
  final DateTime createdAt;

  const Sprite({
    required this.id,
    required this.characterId,
    required this.emotion,
    required this.imagePath,
    this.priority = 0,
    required this.createdAt,
  });

  Sprite copyWith({
    String? id,
    String? characterId,
    String? emotion,
    String? imagePath,
    int? priority,
    DateTime? createdAt,
  }) {
    return Sprite(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      emotion: emotion ?? this.emotion,
      imagePath: imagePath ?? this.imagePath,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'characterId': characterId,
        'emotion': emotion,
        'imagePath': imagePath,
        'priority': priority,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Sprite.fromJson(Map<String, dynamic> json) => Sprite(
        id: json['id'] as String,
        characterId: json['characterId'] as String,
        emotion: json['emotion'] as String,
        imagePath: json['imagePath'] as String,
        priority: json['priority'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Standard emotions for sprite expressions
enum SpriteEmotion {
  neutral('neutral', 'Neutral', ['default', 'normal', 'calm']),
  happy('happy', 'Happy', ['smile', 'joy', 'glad', 'pleased', 'cheerful', 'laugh', 'grin']),
  sad('sad', 'Sad', ['unhappy', 'depressed', 'melancholy', 'sorrow', 'cry', 'tears']),
  angry('angry', 'Angry', ['mad', 'furious', 'rage', 'annoyed', 'irritated', 'frustrated']),
  surprised('surprised', 'Surprised', ['shock', 'amazed', 'astonished', 'startled', 'wow']),
  scared('scared', 'Scared', ['fear', 'afraid', 'terrified', 'frightened', 'nervous', 'anxious']),
  disgusted('disgusted', 'Disgusted', ['disgust', 'gross', 'revolted', 'sick']),
  confused('confused', 'Confused', ['puzzled', 'bewildered', 'uncertain', 'unsure']),
  embarrassed('embarrassed', 'Embarrassed', ['blush', 'shy', 'flustered', 'awkward']),
  excited('excited', 'Excited', ['thrilled', 'eager', 'enthusiastic', 'hyped']),
  loving('loving', 'Loving', ['love', 'affection', 'adore', 'heart', 'romantic']),
  thinking('thinking', 'Thinking', ['ponder', 'consider', 'contemplate', 'hmm']),
  smug('smug', 'Smug', ['confident', 'proud', 'satisfied', 'cocky']),
  tired('tired', 'Tired', ['sleepy', 'exhausted', 'weary', 'drowsy', 'yawn']),
  bored('bored', 'Bored', ['uninterested', 'dull', 'meh']),
  ;

  final String id;
  final String displayName;
  final List<String> keywords;

  const SpriteEmotion(this.id, this.displayName, this.keywords);

  /// Get all keywords including the emotion id itself
  List<String> get allKeywords => [id, ...keywords];

  /// Find emotion by id
  static SpriteEmotion? fromId(String id) {
    try {
      return SpriteEmotion.values.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Character sprite pack containing all expressions
class SpritePack {
  final String characterId;
  final Map<String, Sprite> sprites; // emotion -> sprite
  final String? defaultEmotion;

  const SpritePack({
    required this.characterId,
    this.sprites = const {},
    this.defaultEmotion,
  });

  /// Get sprite for a specific emotion, falling back to default or neutral
  Sprite? getSprite(String emotion) {
    return sprites[emotion] ?? 
           sprites[defaultEmotion ?? 'neutral'] ?? 
           sprites.values.firstOrNull;
  }

  /// Check if pack has any sprites
  bool get hasSprites => sprites.isNotEmpty;

  /// Get list of available emotions
  List<String> get availableEmotions => sprites.keys.toList();

  SpritePack copyWith({
    String? characterId,
    Map<String, Sprite>? sprites,
    String? defaultEmotion,
  }) {
    return SpritePack(
      characterId: characterId ?? this.characterId,
      sprites: sprites ?? this.sprites,
      defaultEmotion: defaultEmotion ?? this.defaultEmotion,
    );
  }

  Map<String, dynamic> toJson() => {
        'characterId': characterId,
        'sprites': sprites.map((k, v) => MapEntry(k, v.toJson())),
        'defaultEmotion': defaultEmotion,
      };

  factory SpritePack.fromJson(Map<String, dynamic> json) => SpritePack(
        characterId: json['characterId'] as String,
        sprites: (json['sprites'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, Sprite.fromJson(v as Map<String, dynamic>)),
            ) ??
            {},
        defaultEmotion: json['defaultEmotion'] as String?,
      );
}

/// Sprite display settings
class SpriteSettings {
  final bool enabled;
  final double size;
  final SpritePosition position;
  final double opacity;
  final bool showDuringStreaming;
  final bool animateTransitions;
  final int transitionDurationMs;

  const SpriteSettings({
    this.enabled = true,
    this.size = 150.0,
    this.position = SpritePosition.left,
    this.opacity = 1.0,
    this.showDuringStreaming = true,
    this.animateTransitions = true,
    this.transitionDurationMs = 300,
  });

  SpriteSettings copyWith({
    bool? enabled,
    double? size,
    SpritePosition? position,
    double? opacity,
    bool? showDuringStreaming,
    bool? animateTransitions,
    int? transitionDurationMs,
  }) {
    return SpriteSettings(
      enabled: enabled ?? this.enabled,
      size: size ?? this.size,
      position: position ?? this.position,
      opacity: opacity ?? this.opacity,
      showDuringStreaming: showDuringStreaming ?? this.showDuringStreaming,
      animateTransitions: animateTransitions ?? this.animateTransitions,
      transitionDurationMs: transitionDurationMs ?? this.transitionDurationMs,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'size': size,
        'position': position.name,
        'opacity': opacity,
        'showDuringStreaming': showDuringStreaming,
        'animateTransitions': animateTransitions,
        'transitionDurationMs': transitionDurationMs,
      };

  factory SpriteSettings.fromJson(Map<String, dynamic> json) => SpriteSettings(
        enabled: json['enabled'] as bool? ?? true,
        size: (json['size'] as num?)?.toDouble() ?? 150.0,
        position: SpritePosition.values.firstWhere(
          (p) => p.name == json['position'],
          orElse: () => SpritePosition.left,
        ),
        opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
        showDuringStreaming: json['showDuringStreaming'] as bool? ?? true,
        animateTransitions: json['animateTransitions'] as bool? ?? true,
        transitionDurationMs: json['transitionDurationMs'] as int? ?? 300,
      );
}

/// Position for sprite display
enum SpritePosition {
  left,
  right,
  center,
  floatingLeft,
  floatingRight,
}