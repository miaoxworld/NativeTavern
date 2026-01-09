import 'dart:convert';

/// Types of chat backgrounds
enum BackgroundType {
  none,
  color,
  gradient,
  image,
}

/// Chat background configuration
class ChatBackground {
  final BackgroundType type;
  final String? color; // Hex color for solid color background
  final List<String>? gradientColors; // Hex colors for gradient
  final double? gradientAngle; // Angle for linear gradient (0-360)
  final String? imagePath; // Local path to image
  final String? imageUrl; // URL for remote image
  final double opacity; // Background opacity (0.0 - 1.0)
  final bool blur; // Whether to blur the background
  final double blurAmount; // Blur amount (0-20)

  const ChatBackground({
    this.type = BackgroundType.none,
    this.color,
    this.gradientColors,
    this.gradientAngle,
    this.imagePath,
    this.imageUrl,
    this.opacity = 1.0,
    this.blur = false,
    this.blurAmount = 5.0,
  });

  /// Default (no background)
  static const ChatBackground none = ChatBackground(type: BackgroundType.none);

  /// Create a solid color background
  factory ChatBackground.color(String hexColor, {double opacity = 1.0}) {
    return ChatBackground(
      type: BackgroundType.color,
      color: hexColor,
      opacity: opacity,
    );
  }

  /// Create a gradient background
  factory ChatBackground.gradient(
    List<String> colors, {
    double angle = 180,
    double opacity = 1.0,
  }) {
    return ChatBackground(
      type: BackgroundType.gradient,
      gradientColors: colors,
      gradientAngle: angle,
      opacity: opacity,
    );
  }

  /// Create an image background from local path
  factory ChatBackground.imagePath(
    String path, {
    double opacity = 1.0,
    bool blur = false,
    double blurAmount = 5.0,
  }) {
    return ChatBackground(
      type: BackgroundType.image,
      imagePath: path,
      opacity: opacity,
      blur: blur,
      blurAmount: blurAmount,
    );
  }

  /// Create an image background from URL
  factory ChatBackground.imageUrl(
    String url, {
    double opacity = 1.0,
    bool blur = false,
    double blurAmount = 5.0,
  }) {
    return ChatBackground(
      type: BackgroundType.image,
      imageUrl: url,
      opacity: opacity,
      blur: blur,
      blurAmount: blurAmount,
    );
  }

  ChatBackground copyWith({
    BackgroundType? type,
    String? color,
    List<String>? gradientColors,
    double? gradientAngle,
    String? imagePath,
    String? imageUrl,
    double? opacity,
    bool? blur,
    double? blurAmount,
  }) {
    return ChatBackground(
      type: type ?? this.type,
      color: color ?? this.color,
      gradientColors: gradientColors ?? this.gradientColors,
      gradientAngle: gradientAngle ?? this.gradientAngle,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
      blurAmount: blurAmount ?? this.blurAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'color': color,
      'gradientColors': gradientColors,
      'gradientAngle': gradientAngle,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'opacity': opacity,
      'blur': blur,
      'blurAmount': blurAmount,
    };
  }

  factory ChatBackground.fromJson(Map<String, dynamic> json) {
    return ChatBackground(
      type: BackgroundType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => BackgroundType.none,
      ),
      color: json['color'] as String?,
      gradientColors: (json['gradientColors'] as List<dynamic>?)?.cast<String>(),
      gradientAngle: (json['gradientAngle'] as num?)?.toDouble(),
      imagePath: json['imagePath'] as String?,
      imageUrl: json['imageUrl'] as String?,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      blur: json['blur'] as bool? ?? false,
      blurAmount: (json['blurAmount'] as num?)?.toDouble() ?? 5.0,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory ChatBackground.fromJsonString(String jsonString) {
    return ChatBackground.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatBackground &&
        other.type == type &&
        other.color == color &&
        other.imagePath == imagePath &&
        other.imageUrl == imageUrl &&
        other.opacity == opacity;
  }

  @override
  int get hashCode => Object.hash(type, color, imagePath, imageUrl, opacity);
}

/// Preset backgrounds
class BackgroundPresets {
  static const List<ChatBackground> gradients = [
    ChatBackground(
      type: BackgroundType.gradient,
      gradientColors: ['#1a1a2e', '#16213e'],
      gradientAngle: 180,
    ),
    ChatBackground(
      type: BackgroundType.gradient,
      gradientColors: ['#0f0c29', '#302b63', '#24243e'],
      gradientAngle: 135,
    ),
    ChatBackground(
      type: BackgroundType.gradient,
      gradientColors: ['#232526', '#414345'],
      gradientAngle: 180,
    ),
    ChatBackground(
      type: BackgroundType.gradient,
      gradientColors: ['#2c3e50', '#3498db'],
      gradientAngle: 135,
    ),
    ChatBackground(
      type: BackgroundType.gradient,
      gradientColors: ['#1f1c2c', '#928dab'],
      gradientAngle: 180,
    ),
    ChatBackground(
      type: BackgroundType.gradient,
      gradientColors: ['#0f2027', '#203a43', '#2c5364'],
      gradientAngle: 135,
    ),
  ];

  static const List<ChatBackground> solidColors = [
    ChatBackground(type: BackgroundType.color, color: '#1a1a1a'),
    ChatBackground(type: BackgroundType.color, color: '#1e1e2e'),
    ChatBackground(type: BackgroundType.color, color: '#2d2d44'),
    ChatBackground(type: BackgroundType.color, color: '#1a1a2e'),
    ChatBackground(type: BackgroundType.color, color: '#0d1117'),
    ChatBackground(type: BackgroundType.color, color: '#161b22'),
  ];
}