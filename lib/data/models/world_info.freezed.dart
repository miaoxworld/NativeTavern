// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorldInfo _$WorldInfoFromJson(Map<String, dynamic> json) {
  return _WorldInfo.fromJson(json);
}

/// @nodoc
mixin _$WorldInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<WorldInfoEntry> get entries => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  bool get isGlobal => throw _privateConstructorUsedError;
  String? get characterId =>
      throw _privateConstructorUsedError; // If bound to a specific character
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get modifiedAt => throw _privateConstructorUsedError;

  /// Serializes this WorldInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldInfoCopyWith<WorldInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldInfoCopyWith<$Res> {
  factory $WorldInfoCopyWith(WorldInfo value, $Res Function(WorldInfo) then) =
      _$WorldInfoCopyWithImpl<$Res, WorldInfo>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<WorldInfoEntry> entries,
      bool enabled,
      bool isGlobal,
      String? characterId,
      DateTime createdAt,
      DateTime modifiedAt});
}

/// @nodoc
class _$WorldInfoCopyWithImpl<$Res, $Val extends WorldInfo>
    implements $WorldInfoCopyWith<$Res> {
  _$WorldInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? entries = null,
    Object? enabled = null,
    Object? isGlobal = null,
    Object? characterId = freezed,
    Object? createdAt = null,
    Object? modifiedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<WorldInfoEntry>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isGlobal: null == isGlobal
          ? _value.isGlobal
          : isGlobal // ignore: cast_nullable_to_non_nullable
              as bool,
      characterId: freezed == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: null == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldInfoImplCopyWith<$Res>
    implements $WorldInfoCopyWith<$Res> {
  factory _$$WorldInfoImplCopyWith(
          _$WorldInfoImpl value, $Res Function(_$WorldInfoImpl) then) =
      __$$WorldInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<WorldInfoEntry> entries,
      bool enabled,
      bool isGlobal,
      String? characterId,
      DateTime createdAt,
      DateTime modifiedAt});
}

/// @nodoc
class __$$WorldInfoImplCopyWithImpl<$Res>
    extends _$WorldInfoCopyWithImpl<$Res, _$WorldInfoImpl>
    implements _$$WorldInfoImplCopyWith<$Res> {
  __$$WorldInfoImplCopyWithImpl(
      _$WorldInfoImpl _value, $Res Function(_$WorldInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? entries = null,
    Object? enabled = null,
    Object? isGlobal = null,
    Object? characterId = freezed,
    Object? createdAt = null,
    Object? modifiedAt = null,
  }) {
    return _then(_$WorldInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<WorldInfoEntry>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isGlobal: null == isGlobal
          ? _value.isGlobal
          : isGlobal // ignore: cast_nullable_to_non_nullable
              as bool,
      characterId: freezed == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: null == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldInfoImpl implements _WorldInfo {
  const _$WorldInfoImpl(
      {required this.id,
      required this.name,
      this.description,
      final List<WorldInfoEntry> entries = const [],
      this.enabled = true,
      this.isGlobal = false,
      this.characterId,
      required this.createdAt,
      required this.modifiedAt})
      : _entries = entries;

  factory _$WorldInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  final List<WorldInfoEntry> _entries;
  @override
  @JsonKey()
  List<WorldInfoEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool isGlobal;
  @override
  final String? characterId;
// If bound to a specific character
  @override
  final DateTime createdAt;
  @override
  final DateTime modifiedAt;

  @override
  String toString() {
    return 'WorldInfo(id: $id, name: $name, description: $description, entries: $entries, enabled: $enabled, isGlobal: $isGlobal, characterId: $characterId, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.isGlobal, isGlobal) ||
                other.isGlobal == isGlobal) &&
            (identical(other.characterId, characterId) ||
                other.characterId == characterId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_entries),
      enabled,
      isGlobal,
      characterId,
      createdAt,
      modifiedAt);

  /// Create a copy of WorldInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldInfoImplCopyWith<_$WorldInfoImpl> get copyWith =>
      __$$WorldInfoImplCopyWithImpl<_$WorldInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldInfoImplToJson(
      this,
    );
  }
}

abstract class _WorldInfo implements WorldInfo {
  const factory _WorldInfo(
      {required final String id,
      required final String name,
      final String? description,
      final List<WorldInfoEntry> entries,
      final bool enabled,
      final bool isGlobal,
      final String? characterId,
      required final DateTime createdAt,
      required final DateTime modifiedAt}) = _$WorldInfoImpl;

  factory _WorldInfo.fromJson(Map<String, dynamic> json) =
      _$WorldInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<WorldInfoEntry> get entries;
  @override
  bool get enabled;
  @override
  bool get isGlobal;
  @override
  String? get characterId; // If bound to a specific character
  @override
  DateTime get createdAt;
  @override
  DateTime get modifiedAt;

  /// Create a copy of WorldInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldInfoImplCopyWith<_$WorldInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorldInfoEntry _$WorldInfoEntryFromJson(Map<String, dynamic> json) {
  return _WorldInfoEntry.fromJson(json);
}

/// @nodoc
mixin _$WorldInfoEntry {
  String get id => throw _privateConstructorUsedError;
  String get worldInfoId => throw _privateConstructorUsedError;
  List<String> get keys => throw _privateConstructorUsedError;
  List<String> get secondaryKeys => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  bool get constant => throw _privateConstructorUsedError; // Always included
  bool get selective =>
      throw _privateConstructorUsedError; // Requires secondary key
  int get insertionOrder => throw _privateConstructorUsedError;
  bool get caseSensitive => throw _privateConstructorUsedError;
  bool get matchWholeWords => throw _privateConstructorUsedError;
  bool get useGroupScoring => throw _privateConstructorUsedError;
  bool get automationId => throw _privateConstructorUsedError;
  int get probability =>
      throw _privateConstructorUsedError; // 0-100, 0 = always trigger
  WorldInfoPosition get position => throw _privateConstructorUsedError;
  int get depth =>
      throw _privateConstructorUsedError; // For depth-based insertion
  String? get group =>
      throw _privateConstructorUsedError; // Grouping for mutual exclusivity
  int get groupWeight => throw _privateConstructorUsedError;
  bool get preventRecursion => throw _privateConstructorUsedError;
  bool get delayUntilRecursion => throw _privateConstructorUsedError;
  int get scanDepth => throw _privateConstructorUsedError;
  Map<String, dynamic> get extensions => throw _privateConstructorUsedError;

  /// Serializes this WorldInfoEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldInfoEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldInfoEntryCopyWith<WorldInfoEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldInfoEntryCopyWith<$Res> {
  factory $WorldInfoEntryCopyWith(
          WorldInfoEntry value, $Res Function(WorldInfoEntry) then) =
      _$WorldInfoEntryCopyWithImpl<$Res, WorldInfoEntry>;
  @useResult
  $Res call(
      {String id,
      String worldInfoId,
      List<String> keys,
      List<String> secondaryKeys,
      String content,
      String comment,
      bool enabled,
      bool constant,
      bool selective,
      int insertionOrder,
      bool caseSensitive,
      bool matchWholeWords,
      bool useGroupScoring,
      bool automationId,
      int probability,
      WorldInfoPosition position,
      int depth,
      String? group,
      int groupWeight,
      bool preventRecursion,
      bool delayUntilRecursion,
      int scanDepth,
      Map<String, dynamic> extensions});
}

/// @nodoc
class _$WorldInfoEntryCopyWithImpl<$Res, $Val extends WorldInfoEntry>
    implements $WorldInfoEntryCopyWith<$Res> {
  _$WorldInfoEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldInfoEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? worldInfoId = null,
    Object? keys = null,
    Object? secondaryKeys = null,
    Object? content = null,
    Object? comment = null,
    Object? enabled = null,
    Object? constant = null,
    Object? selective = null,
    Object? insertionOrder = null,
    Object? caseSensitive = null,
    Object? matchWholeWords = null,
    Object? useGroupScoring = null,
    Object? automationId = null,
    Object? probability = null,
    Object? position = null,
    Object? depth = null,
    Object? group = freezed,
    Object? groupWeight = null,
    Object? preventRecursion = null,
    Object? delayUntilRecursion = null,
    Object? scanDepth = null,
    Object? extensions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      worldInfoId: null == worldInfoId
          ? _value.worldInfoId
          : worldInfoId // ignore: cast_nullable_to_non_nullable
              as String,
      keys: null == keys
          ? _value.keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      secondaryKeys: null == secondaryKeys
          ? _value.secondaryKeys
          : secondaryKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      constant: null == constant
          ? _value.constant
          : constant // ignore: cast_nullable_to_non_nullable
              as bool,
      selective: null == selective
          ? _value.selective
          : selective // ignore: cast_nullable_to_non_nullable
              as bool,
      insertionOrder: null == insertionOrder
          ? _value.insertionOrder
          : insertionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      caseSensitive: null == caseSensitive
          ? _value.caseSensitive
          : caseSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      matchWholeWords: null == matchWholeWords
          ? _value.matchWholeWords
          : matchWholeWords // ignore: cast_nullable_to_non_nullable
              as bool,
      useGroupScoring: null == useGroupScoring
          ? _value.useGroupScoring
          : useGroupScoring // ignore: cast_nullable_to_non_nullable
              as bool,
      automationId: null == automationId
          ? _value.automationId
          : automationId // ignore: cast_nullable_to_non_nullable
              as bool,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as int,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as WorldInfoPosition,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
      groupWeight: null == groupWeight
          ? _value.groupWeight
          : groupWeight // ignore: cast_nullable_to_non_nullable
              as int,
      preventRecursion: null == preventRecursion
          ? _value.preventRecursion
          : preventRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      delayUntilRecursion: null == delayUntilRecursion
          ? _value.delayUntilRecursion
          : delayUntilRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      scanDepth: null == scanDepth
          ? _value.scanDepth
          : scanDepth // ignore: cast_nullable_to_non_nullable
              as int,
      extensions: null == extensions
          ? _value.extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldInfoEntryImplCopyWith<$Res>
    implements $WorldInfoEntryCopyWith<$Res> {
  factory _$$WorldInfoEntryImplCopyWith(_$WorldInfoEntryImpl value,
          $Res Function(_$WorldInfoEntryImpl) then) =
      __$$WorldInfoEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String worldInfoId,
      List<String> keys,
      List<String> secondaryKeys,
      String content,
      String comment,
      bool enabled,
      bool constant,
      bool selective,
      int insertionOrder,
      bool caseSensitive,
      bool matchWholeWords,
      bool useGroupScoring,
      bool automationId,
      int probability,
      WorldInfoPosition position,
      int depth,
      String? group,
      int groupWeight,
      bool preventRecursion,
      bool delayUntilRecursion,
      int scanDepth,
      Map<String, dynamic> extensions});
}

/// @nodoc
class __$$WorldInfoEntryImplCopyWithImpl<$Res>
    extends _$WorldInfoEntryCopyWithImpl<$Res, _$WorldInfoEntryImpl>
    implements _$$WorldInfoEntryImplCopyWith<$Res> {
  __$$WorldInfoEntryImplCopyWithImpl(
      _$WorldInfoEntryImpl _value, $Res Function(_$WorldInfoEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldInfoEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? worldInfoId = null,
    Object? keys = null,
    Object? secondaryKeys = null,
    Object? content = null,
    Object? comment = null,
    Object? enabled = null,
    Object? constant = null,
    Object? selective = null,
    Object? insertionOrder = null,
    Object? caseSensitive = null,
    Object? matchWholeWords = null,
    Object? useGroupScoring = null,
    Object? automationId = null,
    Object? probability = null,
    Object? position = null,
    Object? depth = null,
    Object? group = freezed,
    Object? groupWeight = null,
    Object? preventRecursion = null,
    Object? delayUntilRecursion = null,
    Object? scanDepth = null,
    Object? extensions = null,
  }) {
    return _then(_$WorldInfoEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      worldInfoId: null == worldInfoId
          ? _value.worldInfoId
          : worldInfoId // ignore: cast_nullable_to_non_nullable
              as String,
      keys: null == keys
          ? _value._keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      secondaryKeys: null == secondaryKeys
          ? _value._secondaryKeys
          : secondaryKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      constant: null == constant
          ? _value.constant
          : constant // ignore: cast_nullable_to_non_nullable
              as bool,
      selective: null == selective
          ? _value.selective
          : selective // ignore: cast_nullable_to_non_nullable
              as bool,
      insertionOrder: null == insertionOrder
          ? _value.insertionOrder
          : insertionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      caseSensitive: null == caseSensitive
          ? _value.caseSensitive
          : caseSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      matchWholeWords: null == matchWholeWords
          ? _value.matchWholeWords
          : matchWholeWords // ignore: cast_nullable_to_non_nullable
              as bool,
      useGroupScoring: null == useGroupScoring
          ? _value.useGroupScoring
          : useGroupScoring // ignore: cast_nullable_to_non_nullable
              as bool,
      automationId: null == automationId
          ? _value.automationId
          : automationId // ignore: cast_nullable_to_non_nullable
              as bool,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as int,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as WorldInfoPosition,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String?,
      groupWeight: null == groupWeight
          ? _value.groupWeight
          : groupWeight // ignore: cast_nullable_to_non_nullable
              as int,
      preventRecursion: null == preventRecursion
          ? _value.preventRecursion
          : preventRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      delayUntilRecursion: null == delayUntilRecursion
          ? _value.delayUntilRecursion
          : delayUntilRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      scanDepth: null == scanDepth
          ? _value.scanDepth
          : scanDepth // ignore: cast_nullable_to_non_nullable
              as int,
      extensions: null == extensions
          ? _value._extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldInfoEntryImpl implements _WorldInfoEntry {
  const _$WorldInfoEntryImpl(
      {required this.id,
      required this.worldInfoId,
      final List<String> keys = const [],
      final List<String> secondaryKeys = const [],
      this.content = '',
      this.comment = '',
      this.enabled = true,
      this.constant = false,
      this.selective = false,
      this.insertionOrder = 0,
      this.caseSensitive = false,
      this.matchWholeWords = false,
      this.useGroupScoring = false,
      this.automationId = false,
      this.probability = 0,
      this.position = WorldInfoPosition.beforeCharDefs,
      this.depth = 0,
      this.group,
      this.groupWeight = 0,
      this.preventRecursion = false,
      this.delayUntilRecursion = false,
      this.scanDepth = 0,
      final Map<String, dynamic> extensions = const {}})
      : _keys = keys,
        _secondaryKeys = secondaryKeys,
        _extensions = extensions;

  factory _$WorldInfoEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldInfoEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String worldInfoId;
  final List<String> _keys;
  @override
  @JsonKey()
  List<String> get keys {
    if (_keys is EqualUnmodifiableListView) return _keys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keys);
  }

  final List<String> _secondaryKeys;
  @override
  @JsonKey()
  List<String> get secondaryKeys {
    if (_secondaryKeys is EqualUnmodifiableListView) return _secondaryKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryKeys);
  }

  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String comment;
  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool constant;
// Always included
  @override
  @JsonKey()
  final bool selective;
// Requires secondary key
  @override
  @JsonKey()
  final int insertionOrder;
  @override
  @JsonKey()
  final bool caseSensitive;
  @override
  @JsonKey()
  final bool matchWholeWords;
  @override
  @JsonKey()
  final bool useGroupScoring;
  @override
  @JsonKey()
  final bool automationId;
  @override
  @JsonKey()
  final int probability;
// 0-100, 0 = always trigger
  @override
  @JsonKey()
  final WorldInfoPosition position;
  @override
  @JsonKey()
  final int depth;
// For depth-based insertion
  @override
  final String? group;
// Grouping for mutual exclusivity
  @override
  @JsonKey()
  final int groupWeight;
  @override
  @JsonKey()
  final bool preventRecursion;
  @override
  @JsonKey()
  final bool delayUntilRecursion;
  @override
  @JsonKey()
  final int scanDepth;
  final Map<String, dynamic> _extensions;
  @override
  @JsonKey()
  Map<String, dynamic> get extensions {
    if (_extensions is EqualUnmodifiableMapView) return _extensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extensions);
  }

  @override
  String toString() {
    return 'WorldInfoEntry(id: $id, worldInfoId: $worldInfoId, keys: $keys, secondaryKeys: $secondaryKeys, content: $content, comment: $comment, enabled: $enabled, constant: $constant, selective: $selective, insertionOrder: $insertionOrder, caseSensitive: $caseSensitive, matchWholeWords: $matchWholeWords, useGroupScoring: $useGroupScoring, automationId: $automationId, probability: $probability, position: $position, depth: $depth, group: $group, groupWeight: $groupWeight, preventRecursion: $preventRecursion, delayUntilRecursion: $delayUntilRecursion, scanDepth: $scanDepth, extensions: $extensions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldInfoEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.worldInfoId, worldInfoId) ||
                other.worldInfoId == worldInfoId) &&
            const DeepCollectionEquality().equals(other._keys, _keys) &&
            const DeepCollectionEquality()
                .equals(other._secondaryKeys, _secondaryKeys) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.constant, constant) ||
                other.constant == constant) &&
            (identical(other.selective, selective) ||
                other.selective == selective) &&
            (identical(other.insertionOrder, insertionOrder) ||
                other.insertionOrder == insertionOrder) &&
            (identical(other.caseSensitive, caseSensitive) ||
                other.caseSensitive == caseSensitive) &&
            (identical(other.matchWholeWords, matchWholeWords) ||
                other.matchWholeWords == matchWholeWords) &&
            (identical(other.useGroupScoring, useGroupScoring) ||
                other.useGroupScoring == useGroupScoring) &&
            (identical(other.automationId, automationId) ||
                other.automationId == automationId) &&
            (identical(other.probability, probability) ||
                other.probability == probability) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.groupWeight, groupWeight) ||
                other.groupWeight == groupWeight) &&
            (identical(other.preventRecursion, preventRecursion) ||
                other.preventRecursion == preventRecursion) &&
            (identical(other.delayUntilRecursion, delayUntilRecursion) ||
                other.delayUntilRecursion == delayUntilRecursion) &&
            (identical(other.scanDepth, scanDepth) ||
                other.scanDepth == scanDepth) &&
            const DeepCollectionEquality()
                .equals(other._extensions, _extensions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        worldInfoId,
        const DeepCollectionEquality().hash(_keys),
        const DeepCollectionEquality().hash(_secondaryKeys),
        content,
        comment,
        enabled,
        constant,
        selective,
        insertionOrder,
        caseSensitive,
        matchWholeWords,
        useGroupScoring,
        automationId,
        probability,
        position,
        depth,
        group,
        groupWeight,
        preventRecursion,
        delayUntilRecursion,
        scanDepth,
        const DeepCollectionEquality().hash(_extensions)
      ]);

  /// Create a copy of WorldInfoEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldInfoEntryImplCopyWith<_$WorldInfoEntryImpl> get copyWith =>
      __$$WorldInfoEntryImplCopyWithImpl<_$WorldInfoEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldInfoEntryImplToJson(
      this,
    );
  }
}

abstract class _WorldInfoEntry implements WorldInfoEntry {
  const factory _WorldInfoEntry(
      {required final String id,
      required final String worldInfoId,
      final List<String> keys,
      final List<String> secondaryKeys,
      final String content,
      final String comment,
      final bool enabled,
      final bool constant,
      final bool selective,
      final int insertionOrder,
      final bool caseSensitive,
      final bool matchWholeWords,
      final bool useGroupScoring,
      final bool automationId,
      final int probability,
      final WorldInfoPosition position,
      final int depth,
      final String? group,
      final int groupWeight,
      final bool preventRecursion,
      final bool delayUntilRecursion,
      final int scanDepth,
      final Map<String, dynamic> extensions}) = _$WorldInfoEntryImpl;

  factory _WorldInfoEntry.fromJson(Map<String, dynamic> json) =
      _$WorldInfoEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get worldInfoId;
  @override
  List<String> get keys;
  @override
  List<String> get secondaryKeys;
  @override
  String get content;
  @override
  String get comment;
  @override
  bool get enabled;
  @override
  bool get constant; // Always included
  @override
  bool get selective; // Requires secondary key
  @override
  int get insertionOrder;
  @override
  bool get caseSensitive;
  @override
  bool get matchWholeWords;
  @override
  bool get useGroupScoring;
  @override
  bool get automationId;
  @override
  int get probability; // 0-100, 0 = always trigger
  @override
  WorldInfoPosition get position;
  @override
  int get depth; // For depth-based insertion
  @override
  String? get group; // Grouping for mutual exclusivity
  @override
  int get groupWeight;
  @override
  bool get preventRecursion;
  @override
  bool get delayUntilRecursion;
  @override
  int get scanDepth;
  @override
  Map<String, dynamic> get extensions;

  /// Create a copy of WorldInfoEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldInfoEntryImplCopyWith<_$WorldInfoEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorldInfoExport _$WorldInfoExportFromJson(Map<String, dynamic> json) {
  return _WorldInfoExport.fromJson(json);
}

/// @nodoc
mixin _$WorldInfoExport {
  Map<String, WorldInfoEntryExport> get entries =>
      throw _privateConstructorUsedError;

  /// Serializes this WorldInfoExport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldInfoExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldInfoExportCopyWith<WorldInfoExport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldInfoExportCopyWith<$Res> {
  factory $WorldInfoExportCopyWith(
          WorldInfoExport value, $Res Function(WorldInfoExport) then) =
      _$WorldInfoExportCopyWithImpl<$Res, WorldInfoExport>;
  @useResult
  $Res call({Map<String, WorldInfoEntryExport> entries});
}

/// @nodoc
class _$WorldInfoExportCopyWithImpl<$Res, $Val extends WorldInfoExport>
    implements $WorldInfoExportCopyWith<$Res> {
  _$WorldInfoExportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldInfoExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as Map<String, WorldInfoEntryExport>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldInfoExportImplCopyWith<$Res>
    implements $WorldInfoExportCopyWith<$Res> {
  factory _$$WorldInfoExportImplCopyWith(_$WorldInfoExportImpl value,
          $Res Function(_$WorldInfoExportImpl) then) =
      __$$WorldInfoExportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, WorldInfoEntryExport> entries});
}

/// @nodoc
class __$$WorldInfoExportImplCopyWithImpl<$Res>
    extends _$WorldInfoExportCopyWithImpl<$Res, _$WorldInfoExportImpl>
    implements _$$WorldInfoExportImplCopyWith<$Res> {
  __$$WorldInfoExportImplCopyWithImpl(
      _$WorldInfoExportImpl _value, $Res Function(_$WorldInfoExportImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldInfoExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
  }) {
    return _then(_$WorldInfoExportImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as Map<String, WorldInfoEntryExport>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldInfoExportImpl implements _WorldInfoExport {
  const _$WorldInfoExportImpl(
      {required final Map<String, WorldInfoEntryExport> entries})
      : _entries = entries;

  factory _$WorldInfoExportImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldInfoExportImplFromJson(json);

  final Map<String, WorldInfoEntryExport> _entries;
  @override
  Map<String, WorldInfoEntryExport> get entries {
    if (_entries is EqualUnmodifiableMapView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_entries);
  }

  @override
  String toString() {
    return 'WorldInfoExport(entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldInfoExportImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_entries));

  /// Create a copy of WorldInfoExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldInfoExportImplCopyWith<_$WorldInfoExportImpl> get copyWith =>
      __$$WorldInfoExportImplCopyWithImpl<_$WorldInfoExportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldInfoExportImplToJson(
      this,
    );
  }
}

abstract class _WorldInfoExport implements WorldInfoExport {
  const factory _WorldInfoExport(
          {required final Map<String, WorldInfoEntryExport> entries}) =
      _$WorldInfoExportImpl;

  factory _WorldInfoExport.fromJson(Map<String, dynamic> json) =
      _$WorldInfoExportImpl.fromJson;

  @override
  Map<String, WorldInfoEntryExport> get entries;

  /// Create a copy of WorldInfoExport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldInfoExportImplCopyWith<_$WorldInfoExportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorldInfoEntryExport _$WorldInfoEntryExportFromJson(Map<String, dynamic> json) {
  return _WorldInfoEntryExport.fromJson(json);
}

/// @nodoc
mixin _$WorldInfoEntryExport {
  int get uid => throw _privateConstructorUsedError;
  List<String> get key => throw _privateConstructorUsedError;
  @JsonKey(name: 'keysecondary')
  List<String> get keySecondary => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  bool get selective => throw _privateConstructorUsedError;
  bool get constant => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  bool get disable => throw _privateConstructorUsedError;
  bool get excludeRecursion => throw _privateConstructorUsedError;
  bool get preventRecursion => throw _privateConstructorUsedError;
  bool get delayUntilRecursion => throw _privateConstructorUsedError;
  int get probability => throw _privateConstructorUsedError;
  bool get useProbability => throw _privateConstructorUsedError;
  int get depth => throw _privateConstructorUsedError;
  String get group => throw _privateConstructorUsedError;
  int get groupOverride => throw _privateConstructorUsedError;
  bool get groupWeight => throw _privateConstructorUsedError;
  int get scanDepth => throw _privateConstructorUsedError;
  bool get caseSensitive => throw _privateConstructorUsedError;
  bool get matchWholeWords => throw _privateConstructorUsedError;
  bool get useGroupScoring => throw _privateConstructorUsedError;
  String get automationId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get vectorized => throw _privateConstructorUsedError;
  Map<String, dynamic> get extensions => throw _privateConstructorUsedError;

  /// Serializes this WorldInfoEntryExport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldInfoEntryExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldInfoEntryExportCopyWith<WorldInfoEntryExport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldInfoEntryExportCopyWith<$Res> {
  factory $WorldInfoEntryExportCopyWith(WorldInfoEntryExport value,
          $Res Function(WorldInfoEntryExport) then) =
      _$WorldInfoEntryExportCopyWithImpl<$Res, WorldInfoEntryExport>;
  @useResult
  $Res call(
      {int uid,
      List<String> key,
      @JsonKey(name: 'keysecondary') List<String> keySecondary,
      String content,
      String comment,
      bool selective,
      bool constant,
      int order,
      int position,
      bool disable,
      bool excludeRecursion,
      bool preventRecursion,
      bool delayUntilRecursion,
      int probability,
      bool useProbability,
      int depth,
      String group,
      int groupOverride,
      bool groupWeight,
      int scanDepth,
      bool caseSensitive,
      bool matchWholeWords,
      bool useGroupScoring,
      String automationId,
      String role,
      String vectorized,
      Map<String, dynamic> extensions});
}

/// @nodoc
class _$WorldInfoEntryExportCopyWithImpl<$Res,
        $Val extends WorldInfoEntryExport>
    implements $WorldInfoEntryExportCopyWith<$Res> {
  _$WorldInfoEntryExportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldInfoEntryExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? key = null,
    Object? keySecondary = null,
    Object? content = null,
    Object? comment = null,
    Object? selective = null,
    Object? constant = null,
    Object? order = null,
    Object? position = null,
    Object? disable = null,
    Object? excludeRecursion = null,
    Object? preventRecursion = null,
    Object? delayUntilRecursion = null,
    Object? probability = null,
    Object? useProbability = null,
    Object? depth = null,
    Object? group = null,
    Object? groupOverride = null,
    Object? groupWeight = null,
    Object? scanDepth = null,
    Object? caseSensitive = null,
    Object? matchWholeWords = null,
    Object? useGroupScoring = null,
    Object? automationId = null,
    Object? role = null,
    Object? vectorized = null,
    Object? extensions = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as int,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as List<String>,
      keySecondary: null == keySecondary
          ? _value.keySecondary
          : keySecondary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      selective: null == selective
          ? _value.selective
          : selective // ignore: cast_nullable_to_non_nullable
              as bool,
      constant: null == constant
          ? _value.constant
          : constant // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      disable: null == disable
          ? _value.disable
          : disable // ignore: cast_nullable_to_non_nullable
              as bool,
      excludeRecursion: null == excludeRecursion
          ? _value.excludeRecursion
          : excludeRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      preventRecursion: null == preventRecursion
          ? _value.preventRecursion
          : preventRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      delayUntilRecursion: null == delayUntilRecursion
          ? _value.delayUntilRecursion
          : delayUntilRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as int,
      useProbability: null == useProbability
          ? _value.useProbability
          : useProbability // ignore: cast_nullable_to_non_nullable
              as bool,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      groupOverride: null == groupOverride
          ? _value.groupOverride
          : groupOverride // ignore: cast_nullable_to_non_nullable
              as int,
      groupWeight: null == groupWeight
          ? _value.groupWeight
          : groupWeight // ignore: cast_nullable_to_non_nullable
              as bool,
      scanDepth: null == scanDepth
          ? _value.scanDepth
          : scanDepth // ignore: cast_nullable_to_non_nullable
              as int,
      caseSensitive: null == caseSensitive
          ? _value.caseSensitive
          : caseSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      matchWholeWords: null == matchWholeWords
          ? _value.matchWholeWords
          : matchWholeWords // ignore: cast_nullable_to_non_nullable
              as bool,
      useGroupScoring: null == useGroupScoring
          ? _value.useGroupScoring
          : useGroupScoring // ignore: cast_nullable_to_non_nullable
              as bool,
      automationId: null == automationId
          ? _value.automationId
          : automationId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      vectorized: null == vectorized
          ? _value.vectorized
          : vectorized // ignore: cast_nullable_to_non_nullable
              as String,
      extensions: null == extensions
          ? _value.extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldInfoEntryExportImplCopyWith<$Res>
    implements $WorldInfoEntryExportCopyWith<$Res> {
  factory _$$WorldInfoEntryExportImplCopyWith(_$WorldInfoEntryExportImpl value,
          $Res Function(_$WorldInfoEntryExportImpl) then) =
      __$$WorldInfoEntryExportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int uid,
      List<String> key,
      @JsonKey(name: 'keysecondary') List<String> keySecondary,
      String content,
      String comment,
      bool selective,
      bool constant,
      int order,
      int position,
      bool disable,
      bool excludeRecursion,
      bool preventRecursion,
      bool delayUntilRecursion,
      int probability,
      bool useProbability,
      int depth,
      String group,
      int groupOverride,
      bool groupWeight,
      int scanDepth,
      bool caseSensitive,
      bool matchWholeWords,
      bool useGroupScoring,
      String automationId,
      String role,
      String vectorized,
      Map<String, dynamic> extensions});
}

/// @nodoc
class __$$WorldInfoEntryExportImplCopyWithImpl<$Res>
    extends _$WorldInfoEntryExportCopyWithImpl<$Res, _$WorldInfoEntryExportImpl>
    implements _$$WorldInfoEntryExportImplCopyWith<$Res> {
  __$$WorldInfoEntryExportImplCopyWithImpl(_$WorldInfoEntryExportImpl _value,
      $Res Function(_$WorldInfoEntryExportImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldInfoEntryExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? key = null,
    Object? keySecondary = null,
    Object? content = null,
    Object? comment = null,
    Object? selective = null,
    Object? constant = null,
    Object? order = null,
    Object? position = null,
    Object? disable = null,
    Object? excludeRecursion = null,
    Object? preventRecursion = null,
    Object? delayUntilRecursion = null,
    Object? probability = null,
    Object? useProbability = null,
    Object? depth = null,
    Object? group = null,
    Object? groupOverride = null,
    Object? groupWeight = null,
    Object? scanDepth = null,
    Object? caseSensitive = null,
    Object? matchWholeWords = null,
    Object? useGroupScoring = null,
    Object? automationId = null,
    Object? role = null,
    Object? vectorized = null,
    Object? extensions = null,
  }) {
    return _then(_$WorldInfoEntryExportImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as int,
      key: null == key
          ? _value._key
          : key // ignore: cast_nullable_to_non_nullable
              as List<String>,
      keySecondary: null == keySecondary
          ? _value._keySecondary
          : keySecondary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      selective: null == selective
          ? _value.selective
          : selective // ignore: cast_nullable_to_non_nullable
              as bool,
      constant: null == constant
          ? _value.constant
          : constant // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      disable: null == disable
          ? _value.disable
          : disable // ignore: cast_nullable_to_non_nullable
              as bool,
      excludeRecursion: null == excludeRecursion
          ? _value.excludeRecursion
          : excludeRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      preventRecursion: null == preventRecursion
          ? _value.preventRecursion
          : preventRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      delayUntilRecursion: null == delayUntilRecursion
          ? _value.delayUntilRecursion
          : delayUntilRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      probability: null == probability
          ? _value.probability
          : probability // ignore: cast_nullable_to_non_nullable
              as int,
      useProbability: null == useProbability
          ? _value.useProbability
          : useProbability // ignore: cast_nullable_to_non_nullable
              as bool,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as String,
      groupOverride: null == groupOverride
          ? _value.groupOverride
          : groupOverride // ignore: cast_nullable_to_non_nullable
              as int,
      groupWeight: null == groupWeight
          ? _value.groupWeight
          : groupWeight // ignore: cast_nullable_to_non_nullable
              as bool,
      scanDepth: null == scanDepth
          ? _value.scanDepth
          : scanDepth // ignore: cast_nullable_to_non_nullable
              as int,
      caseSensitive: null == caseSensitive
          ? _value.caseSensitive
          : caseSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
      matchWholeWords: null == matchWholeWords
          ? _value.matchWholeWords
          : matchWholeWords // ignore: cast_nullable_to_non_nullable
              as bool,
      useGroupScoring: null == useGroupScoring
          ? _value.useGroupScoring
          : useGroupScoring // ignore: cast_nullable_to_non_nullable
              as bool,
      automationId: null == automationId
          ? _value.automationId
          : automationId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      vectorized: null == vectorized
          ? _value.vectorized
          : vectorized // ignore: cast_nullable_to_non_nullable
              as String,
      extensions: null == extensions
          ? _value._extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldInfoEntryExportImpl implements _WorldInfoEntryExport {
  const _$WorldInfoEntryExportImpl(
      {required this.uid,
      required final List<String> key,
      @JsonKey(name: 'keysecondary') final List<String> keySecondary = const [],
      required this.content,
      this.comment = '',
      this.selective = false,
      this.constant = false,
      this.order = 0,
      this.position = 0,
      this.disable = false,
      this.excludeRecursion = false,
      this.preventRecursion = false,
      this.delayUntilRecursion = false,
      this.probability = 0,
      this.useProbability = false,
      this.depth = 4,
      this.group = '',
      this.groupOverride = 100,
      this.groupWeight = false,
      this.scanDepth = 0,
      this.caseSensitive = false,
      this.matchWholeWords = false,
      this.useGroupScoring = false,
      this.automationId = '',
      this.role = '',
      this.vectorized = '',
      final Map<String, dynamic> extensions = const {}})
      : _key = key,
        _keySecondary = keySecondary,
        _extensions = extensions;

  factory _$WorldInfoEntryExportImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldInfoEntryExportImplFromJson(json);

  @override
  final int uid;
  final List<String> _key;
  @override
  List<String> get key {
    if (_key is EqualUnmodifiableListView) return _key;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_key);
  }

  final List<String> _keySecondary;
  @override
  @JsonKey(name: 'keysecondary')
  List<String> get keySecondary {
    if (_keySecondary is EqualUnmodifiableListView) return _keySecondary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keySecondary);
  }

  @override
  final String content;
  @override
  @JsonKey()
  final String comment;
  @override
  @JsonKey()
  final bool selective;
  @override
  @JsonKey()
  final bool constant;
  @override
  @JsonKey()
  final int order;
  @override
  @JsonKey()
  final int position;
  @override
  @JsonKey()
  final bool disable;
  @override
  @JsonKey()
  final bool excludeRecursion;
  @override
  @JsonKey()
  final bool preventRecursion;
  @override
  @JsonKey()
  final bool delayUntilRecursion;
  @override
  @JsonKey()
  final int probability;
  @override
  @JsonKey()
  final bool useProbability;
  @override
  @JsonKey()
  final int depth;
  @override
  @JsonKey()
  final String group;
  @override
  @JsonKey()
  final int groupOverride;
  @override
  @JsonKey()
  final bool groupWeight;
  @override
  @JsonKey()
  final int scanDepth;
  @override
  @JsonKey()
  final bool caseSensitive;
  @override
  @JsonKey()
  final bool matchWholeWords;
  @override
  @JsonKey()
  final bool useGroupScoring;
  @override
  @JsonKey()
  final String automationId;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey()
  final String vectorized;
  final Map<String, dynamic> _extensions;
  @override
  @JsonKey()
  Map<String, dynamic> get extensions {
    if (_extensions is EqualUnmodifiableMapView) return _extensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extensions);
  }

  @override
  String toString() {
    return 'WorldInfoEntryExport(uid: $uid, key: $key, keySecondary: $keySecondary, content: $content, comment: $comment, selective: $selective, constant: $constant, order: $order, position: $position, disable: $disable, excludeRecursion: $excludeRecursion, preventRecursion: $preventRecursion, delayUntilRecursion: $delayUntilRecursion, probability: $probability, useProbability: $useProbability, depth: $depth, group: $group, groupOverride: $groupOverride, groupWeight: $groupWeight, scanDepth: $scanDepth, caseSensitive: $caseSensitive, matchWholeWords: $matchWholeWords, useGroupScoring: $useGroupScoring, automationId: $automationId, role: $role, vectorized: $vectorized, extensions: $extensions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldInfoEntryExportImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other._key, _key) &&
            const DeepCollectionEquality()
                .equals(other._keySecondary, _keySecondary) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.selective, selective) ||
                other.selective == selective) &&
            (identical(other.constant, constant) ||
                other.constant == constant) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.disable, disable) || other.disable == disable) &&
            (identical(other.excludeRecursion, excludeRecursion) ||
                other.excludeRecursion == excludeRecursion) &&
            (identical(other.preventRecursion, preventRecursion) ||
                other.preventRecursion == preventRecursion) &&
            (identical(other.delayUntilRecursion, delayUntilRecursion) ||
                other.delayUntilRecursion == delayUntilRecursion) &&
            (identical(other.probability, probability) ||
                other.probability == probability) &&
            (identical(other.useProbability, useProbability) ||
                other.useProbability == useProbability) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.groupOverride, groupOverride) ||
                other.groupOverride == groupOverride) &&
            (identical(other.groupWeight, groupWeight) ||
                other.groupWeight == groupWeight) &&
            (identical(other.scanDepth, scanDepth) ||
                other.scanDepth == scanDepth) &&
            (identical(other.caseSensitive, caseSensitive) ||
                other.caseSensitive == caseSensitive) &&
            (identical(other.matchWholeWords, matchWholeWords) ||
                other.matchWholeWords == matchWholeWords) &&
            (identical(other.useGroupScoring, useGroupScoring) ||
                other.useGroupScoring == useGroupScoring) &&
            (identical(other.automationId, automationId) ||
                other.automationId == automationId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.vectorized, vectorized) ||
                other.vectorized == vectorized) &&
            const DeepCollectionEquality()
                .equals(other._extensions, _extensions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uid,
        const DeepCollectionEquality().hash(_key),
        const DeepCollectionEquality().hash(_keySecondary),
        content,
        comment,
        selective,
        constant,
        order,
        position,
        disable,
        excludeRecursion,
        preventRecursion,
        delayUntilRecursion,
        probability,
        useProbability,
        depth,
        group,
        groupOverride,
        groupWeight,
        scanDepth,
        caseSensitive,
        matchWholeWords,
        useGroupScoring,
        automationId,
        role,
        vectorized,
        const DeepCollectionEquality().hash(_extensions)
      ]);

  /// Create a copy of WorldInfoEntryExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldInfoEntryExportImplCopyWith<_$WorldInfoEntryExportImpl>
      get copyWith =>
          __$$WorldInfoEntryExportImplCopyWithImpl<_$WorldInfoEntryExportImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldInfoEntryExportImplToJson(
      this,
    );
  }
}

abstract class _WorldInfoEntryExport implements WorldInfoEntryExport {
  const factory _WorldInfoEntryExport(
      {required final int uid,
      required final List<String> key,
      @JsonKey(name: 'keysecondary') final List<String> keySecondary,
      required final String content,
      final String comment,
      final bool selective,
      final bool constant,
      final int order,
      final int position,
      final bool disable,
      final bool excludeRecursion,
      final bool preventRecursion,
      final bool delayUntilRecursion,
      final int probability,
      final bool useProbability,
      final int depth,
      final String group,
      final int groupOverride,
      final bool groupWeight,
      final int scanDepth,
      final bool caseSensitive,
      final bool matchWholeWords,
      final bool useGroupScoring,
      final String automationId,
      final String role,
      final String vectorized,
      final Map<String, dynamic> extensions}) = _$WorldInfoEntryExportImpl;

  factory _WorldInfoEntryExport.fromJson(Map<String, dynamic> json) =
      _$WorldInfoEntryExportImpl.fromJson;

  @override
  int get uid;
  @override
  List<String> get key;
  @override
  @JsonKey(name: 'keysecondary')
  List<String> get keySecondary;
  @override
  String get content;
  @override
  String get comment;
  @override
  bool get selective;
  @override
  bool get constant;
  @override
  int get order;
  @override
  int get position;
  @override
  bool get disable;
  @override
  bool get excludeRecursion;
  @override
  bool get preventRecursion;
  @override
  bool get delayUntilRecursion;
  @override
  int get probability;
  @override
  bool get useProbability;
  @override
  int get depth;
  @override
  String get group;
  @override
  int get groupOverride;
  @override
  bool get groupWeight;
  @override
  int get scanDepth;
  @override
  bool get caseSensitive;
  @override
  bool get matchWholeWords;
  @override
  bool get useGroupScoring;
  @override
  String get automationId;
  @override
  String get role;
  @override
  String get vectorized;
  @override
  Map<String, dynamic> get extensions;

  /// Create a copy of WorldInfoEntryExport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldInfoEntryExportImplCopyWith<_$WorldInfoEntryExportImpl>
      get copyWith => throw _privateConstructorUsedError;
}
