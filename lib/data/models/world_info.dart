import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_info.freezed.dart';
part 'world_info.g.dart';

/// World Info / Lorebook model
/// Compatible with SillyTavern's world info format
@freezed
class WorldInfo with _$WorldInfo {
  const factory WorldInfo({
    required String id,
    required String name,
    String? description,
    @Default([]) List<WorldInfoEntry> entries,
    @Default(true) bool enabled,
    @Default(false) bool isGlobal,
    String? characterId, // If bound to a specific character
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) = _WorldInfo;

  factory WorldInfo.fromJson(Map<String, dynamic> json) => _$WorldInfoFromJson(json);
}

/// World Info Entry
@freezed
class WorldInfoEntry with _$WorldInfoEntry {
  const factory WorldInfoEntry({
    required String id,
    required String worldInfoId,
    @Default([]) List<String> keys,
    @Default([]) List<String> secondaryKeys,
    @Default('') String content,
    @Default('') String comment,
    @Default(true) bool enabled,
    @Default(false) bool constant, // Always included
    @Default(false) bool selective, // Requires secondary key
    @Default(0) int insertionOrder,
    @Default(false) bool caseSensitive,
    @Default(false) bool matchWholeWords,
    @Default(false) bool useGroupScoring,
    @Default(false) bool automationId,
    @Default(0) int probability, // 0-100, 0 = always trigger
    @Default(WorldInfoPosition.beforeCharDefs) WorldInfoPosition position,
    @Default(0) int depth, // For depth-based insertion
    String? group, // Grouping for mutual exclusivity
    @Default(0) int groupWeight,
    @Default(false) bool preventRecursion,
    @Default(false) bool delayUntilRecursion,
    @Default(0) int scanDepth,
    @Default({}) Map<String, dynamic> extensions,
  }) = _WorldInfoEntry;

  factory WorldInfoEntry.fromJson(Map<String, dynamic> json) => _$WorldInfoEntryFromJson(json);
}

/// World Info insertion position
enum WorldInfoPosition {
  @JsonValue(0)
  beforeCharDefs,
  @JsonValue(1)
  afterCharDefs,
  @JsonValue(2)
  beforeExample,
  @JsonValue(3)
  afterExample,
  @JsonValue(4)
  beforeAuthorNote,
  @JsonValue(5)
  afterAuthorNote,
  @JsonValue(6)
  atDepth,
  @JsonValue(7)
  beforeSystemPrompt,
  @JsonValue(8)
  afterSystemPrompt,
}

/// World Info export format for SillyTavern compatibility
@freezed
class WorldInfoExport with _$WorldInfoExport {
  const factory WorldInfoExport({
    required Map<String, WorldInfoEntryExport> entries,
  }) = _WorldInfoExport;

  factory WorldInfoExport.fromJson(Map<String, dynamic> json) => _$WorldInfoExportFromJson(json);
}

@freezed
class WorldInfoEntryExport with _$WorldInfoEntryExport {
  const factory WorldInfoEntryExport({
    required int uid,
    required List<String> key,
    @JsonKey(name: 'keysecondary') @Default([]) List<String> keySecondary,
    required String content,
    @Default('') String comment,
    @Default(false) bool selective,
    @Default(false) bool constant,
    @Default(0) int order,
    @Default(0) int position,
    @Default(false) bool disable,
    @Default(false) bool excludeRecursion,
    @Default(false) bool preventRecursion,
    @Default(false) bool delayUntilRecursion,
    @Default(0) int probability,
    @Default(false) bool useProbability,
    @Default(4) int depth,
    @Default('') String group,
    @Default(100) int groupOverride,
    @Default(false) bool groupWeight,
    @Default(0) int scanDepth,
    @Default(false) bool caseSensitive,
    @Default(false) bool matchWholeWords,
    @Default(false) bool useGroupScoring,
    @Default('') String automationId,
    @Default('') String role,
    @Default('') String vectorized,
    @Default({}) Map<String, dynamic> extensions,
  }) = _WorldInfoEntryExport;

  factory WorldInfoEntryExport.fromJson(Map<String, dynamic> json) => _$WorldInfoEntryExportFromJson(json);
}