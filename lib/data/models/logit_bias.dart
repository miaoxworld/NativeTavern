import 'dart:convert';
import 'package:uuid/uuid.dart';

/// Represents a single logit bias entry
class LogitBiasEntry {
  final String id;
  final String text;
  final double value;
  final bool enabled;

  const LogitBiasEntry({
    required this.id,
    required this.text,
    required this.value,
    this.enabled = true,
  });

  factory LogitBiasEntry.create({
    String? text,
    double? value,
  }) {
    return LogitBiasEntry(
      id: const Uuid().v4(),
      text: text ?? '',
      value: value ?? 0.0,
      enabled: true,
    );
  }

  factory LogitBiasEntry.fromJson(Map<String, dynamic> json) {
    return LogitBiasEntry(
      id: json['id'] as String? ?? const Uuid().v4(),
      text: json['text'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'value': value,
      'enabled': enabled,
    };
  }

  LogitBiasEntry copyWith({
    String? id,
    String? text,
    double? value,
    bool? enabled,
  }) {
    return LogitBiasEntry(
      id: id ?? this.id,
      text: text ?? this.text,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogitBiasEntry &&
        other.id == id &&
        other.text == text &&
        other.value == value &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => Object.hash(id, text, value, enabled);

  @override
  String toString() => 'LogitBiasEntry(id: $id, text: $text, value: $value, enabled: $enabled)';
}

/// Represents a preset of logit bias entries
class LogitBiasPreset {
  final String id;
  final String name;
  final List<LogitBiasEntry> entries;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LogitBiasPreset({
    required this.id,
    required this.name,
    required this.entries,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LogitBiasPreset.create({
    required String name,
    List<LogitBiasEntry>? entries,
  }) {
    final now = DateTime.now();
    return LogitBiasPreset(
      id: const Uuid().v4(),
      name: name,
      entries: entries ?? [],
      createdAt: now,
      updatedAt: now,
    );
  }

  factory LogitBiasPreset.fromJson(Map<String, dynamic> json) {
    return LogitBiasPreset(
      id: json['id'] as String? ?? const Uuid().v4(),
      name: json['name'] as String? ?? 'Unnamed Preset',
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => LogitBiasEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'entries': entries.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LogitBiasPreset copyWith({
    String? id,
    String? name,
    List<LogitBiasEntry>? entries,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LogitBiasPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      entries: entries ?? this.entries,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogitBiasPreset && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LogitBiasPreset(id: $id, name: $name, entries: ${entries.length})';
}

/// Settings for logit bias feature
class LogitBiasSettings {
  final bool enabled;
  final String? activePresetId;
  final List<LogitBiasPreset> presets;

  const LogitBiasSettings({
    this.enabled = false,
    this.activePresetId,
    this.presets = const [],
  });

  factory LogitBiasSettings.fromJson(Map<String, dynamic> json) {
    return LogitBiasSettings(
      enabled: json['enabled'] as bool? ?? false,
      activePresetId: json['activePresetId'] as String?,
      presets: (json['presets'] as List<dynamic>?)
              ?.map((e) => LogitBiasPreset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'activePresetId': activePresetId,
      'presets': presets.map((e) => e.toJson()).toList(),
    };
  }

  LogitBiasSettings copyWith({
    bool? enabled,
    String? activePresetId,
    List<LogitBiasPreset>? presets,
    bool clearActivePreset = false,
  }) {
    return LogitBiasSettings(
      enabled: enabled ?? this.enabled,
      activePresetId: clearActivePreset ? null : (activePresetId ?? this.activePresetId),
      presets: presets ?? this.presets,
    );
  }

  LogitBiasPreset? get activePreset {
    if (activePresetId == null) return null;
    try {
      return presets.firstWhere((p) => p.id == activePresetId);
    } catch (_) {
      return null;
    }
  }

  List<LogitBiasEntry> get activeEntries {
    final preset = activePreset;
    if (preset == null || !enabled) return [];
    return preset.entries.where((e) => e.enabled && e.text.isNotEmpty).toList();
  }

  static String serialize(LogitBiasSettings settings) {
    return jsonEncode(settings.toJson());
  }

  static LogitBiasSettings deserialize(String json) {
    return LogitBiasSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}

/// Input format types for logit bias text
enum LogitBiasInputFormat {
  /// Normal text - will be tokenized with leading space
  text,
  /// Verbatim text in {braces} - tokenized exactly as written
  verbatim,
  /// Raw token IDs in [brackets] - JSON array of integers
  tokenIds,
}

/// Parsed logit bias entry with resolved format
class ParsedLogitBiasEntry {
  final LogitBiasInputFormat format;
  final String originalText;
  final String processedText;
  final List<int>? tokenIds;
  final double value;

  const ParsedLogitBiasEntry({
    required this.format,
    required this.originalText,
    required this.processedText,
    this.tokenIds,
    required this.value,
  });
}