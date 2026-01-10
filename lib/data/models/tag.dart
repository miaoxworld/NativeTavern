import 'package:flutter/material.dart';

/// Tag model for categorizing characters
class Tag {
  final String id;
  final String name;
  final String? color; // Hex color string like "#FF5733"
  final String? icon; // Icon name or emoji
  final DateTime createdAt;

  const Tag({
    required this.id,
    required this.name,
    this.color,
    this.icon,
    required this.createdAt,
  });

  Tag copyWith({
    String? id,
    String? name,
    String? color,
    String? icon,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'icon': icon,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['id'] as String,
        name: json['name'] as String,
        color: json['color'] as String?,
        icon: json['icon'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );

  /// Get the color as a Flutter Color object
  Color get colorValue {
    if (color == null || color!.isEmpty) {
      return Colors.grey;
    }
    try {
      final hex = color!.replaceFirst('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return Colors.grey;
  }

  /// Convert a Color to hex string
  static String colorToHex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Tag(id: $id, name: $name, color: $color)';
}

/// Predefined tag colors for quick selection
class TagColors {
  static const List<Color> presetColors = [
    Color(0xFFE57373), // Red
    Color(0xFFFF8A65), // Deep Orange
    Color(0xFFFFB74D), // Orange
    Color(0xFFFFD54F), // Amber
    Color(0xFFFFF176), // Yellow
    Color(0xFFDCE775), // Lime
    Color(0xFFAED581), // Light Green
    Color(0xFF81C784), // Green
    Color(0xFF4DB6AC), // Teal
    Color(0xFF4DD0E1), // Cyan
    Color(0xFF4FC3F7), // Light Blue
    Color(0xFF64B5F6), // Blue
    Color(0xFF7986CB), // Indigo
    Color(0xFF9575CD), // Deep Purple
    Color(0xFFBA68C8), // Purple
    Color(0xFFF06292), // Pink
    Color(0xFF90A4AE), // Blue Grey
    Color(0xFFA1887F), // Brown
  ];

  static Color getRandomColor() {
    return presetColors[DateTime.now().millisecond % presetColors.length];
  }
}