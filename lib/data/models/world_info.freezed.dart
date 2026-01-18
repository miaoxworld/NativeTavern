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

WorldInfoCharacterFilter _$WorldInfoCharacterFilterFromJson(
    Map<String, dynamic> json) {
  return _WorldInfoCharacterFilter.fromJson(json);
}

/// @nodoc
mixin _$WorldInfoCharacterFilter {
  WorldInfoCharacterFilterType get type => throw _privateConstructorUsedError;

  /// List of character IDs to include/exclude
  List<String> get characterIds => throw _privateConstructorUsedError;

  /// List of tag names to include/exclude
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this WorldInfoCharacterFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldInfoCharacterFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldInfoCharacterFilterCopyWith<WorldInfoCharacterFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldInfoCharacterFilterCopyWith<$Res> {
  factory $WorldInfoCharacterFilterCopyWith(WorldInfoCharacterFilter value,
          $Res Function(WorldInfoCharacterFilter) then) =
      _$WorldInfoCharacterFilterCopyWithImpl<$Res, WorldInfoCharacterFilter>;
  @useResult
  $Res call(
      {WorldInfoCharacterFilterType type,
      List<String> characterIds,
      List<String> tags});
}

/// @nodoc
class _$WorldInfoCharacterFilterCopyWithImpl<$Res,
        $Val extends WorldInfoCharacterFilter>
    implements $WorldInfoCharacterFilterCopyWith<$Res> {
  _$WorldInfoCharacterFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldInfoCharacterFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? characterIds = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorldInfoCharacterFilterType,
      characterIds: null == characterIds
          ? _value.characterIds
          : characterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldInfoCharacterFilterImplCopyWith<$Res>
    implements $WorldInfoCharacterFilterCopyWith<$Res> {
  factory _$$WorldInfoCharacterFilterImplCopyWith(
          _$WorldInfoCharacterFilterImpl value,
          $Res Function(_$WorldInfoCharacterFilterImpl) then) =
      __$$WorldInfoCharacterFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WorldInfoCharacterFilterType type,
      List<String> characterIds,
      List<String> tags});
}

/// @nodoc
class __$$WorldInfoCharacterFilterImplCopyWithImpl<$Res>
    extends _$WorldInfoCharacterFilterCopyWithImpl<$Res,
        _$WorldInfoCharacterFilterImpl>
    implements _$$WorldInfoCharacterFilterImplCopyWith<$Res> {
  __$$WorldInfoCharacterFilterImplCopyWithImpl(
      _$WorldInfoCharacterFilterImpl _value,
      $Res Function(_$WorldInfoCharacterFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldInfoCharacterFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? characterIds = null,
    Object? tags = null,
  }) {
    return _then(_$WorldInfoCharacterFilterImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorldInfoCharacterFilterType,
      characterIds: null == characterIds
          ? _value._characterIds
          : characterIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldInfoCharacterFilterImpl implements _WorldInfoCharacterFilter {
  const _$WorldInfoCharacterFilterImpl(
      {this.type = WorldInfoCharacterFilterType.none,
      final List<String> characterIds = const [],
      final List<String> tags = const []})
      : _characterIds = characterIds,
        _tags = tags;

  factory _$WorldInfoCharacterFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldInfoCharacterFilterImplFromJson(json);

  @override
  @JsonKey()
  final WorldInfoCharacterFilterType type;

  /// List of character IDs to include/exclude
  final List<String> _characterIds;

  /// List of character IDs to include/exclude
  @override
  @JsonKey()
  List<String> get characterIds {
    if (_characterIds is EqualUnmodifiableListView) return _characterIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_characterIds);
  }

  /// List of tag names to include/exclude
  final List<String> _tags;

  /// List of tag names to include/exclude
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'WorldInfoCharacterFilter(type: $type, characterIds: $characterIds, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldInfoCharacterFilterImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._characterIds, _characterIds) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      const DeepCollectionEquality().hash(_characterIds),
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of WorldInfoCharacterFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldInfoCharacterFilterImplCopyWith<_$WorldInfoCharacterFilterImpl>
      get copyWith => __$$WorldInfoCharacterFilterImplCopyWithImpl<
          _$WorldInfoCharacterFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldInfoCharacterFilterImplToJson(
      this,
    );
  }
}

abstract class _WorldInfoCharacterFilter implements WorldInfoCharacterFilter {
  const factory _WorldInfoCharacterFilter(
      {final WorldInfoCharacterFilterType type,
      final List<String> characterIds,
      final List<String> tags}) = _$WorldInfoCharacterFilterImpl;

  factory _WorldInfoCharacterFilter.fromJson(Map<String, dynamic> json) =
      _$WorldInfoCharacterFilterImpl.fromJson;

  @override
  WorldInfoCharacterFilterType get type;

  /// List of character IDs to include/exclude
  @override
  List<String> get characterIds;

  /// List of tag names to include/exclude
  @override
  List<String> get tags;

  /// Create a copy of WorldInfoCharacterFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldInfoCharacterFilterImplCopyWith<_$WorldInfoCharacterFilterImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorldInfoTimedEffects _$WorldInfoTimedEffectsFromJson(
    Map<String, dynamic> json) {
  return _WorldInfoTimedEffects.fromJson(json);
}

/// @nodoc
mixin _$WorldInfoTimedEffects {
  /// Sticky duration - entry stays active for N messages after trigger
  /// 0 = not sticky (default)
  int get sticky => throw _privateConstructorUsedError;

  /// Cooldown duration - entry cannot trigger again for N messages
  /// 0 = no cooldown (default)
  int get cooldown => throw _privateConstructorUsedError;

  /// Delay - entry only triggers after N messages since chat start
  /// 0 = no delay (default)
  int get delay =>
      throw _privateConstructorUsedError; // === Runtime state (not persisted) ===
  /// Current sticky counter (decrements each message)
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get stickyCounter => throw _privateConstructorUsedError;

  /// Current cooldown counter (decrements each message)
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get cooldownCounter => throw _privateConstructorUsedError;

  /// Whether entry is currently active due to sticky
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSticky => throw _privateConstructorUsedError;

  /// Whether entry is currently on cooldown
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isOnCooldown => throw _privateConstructorUsedError;

  /// Serializes this WorldInfoTimedEffects to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorldInfoTimedEffects
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorldInfoTimedEffectsCopyWith<WorldInfoTimedEffects> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorldInfoTimedEffectsCopyWith<$Res> {
  factory $WorldInfoTimedEffectsCopyWith(WorldInfoTimedEffects value,
          $Res Function(WorldInfoTimedEffects) then) =
      _$WorldInfoTimedEffectsCopyWithImpl<$Res, WorldInfoTimedEffects>;
  @useResult
  $Res call(
      {int sticky,
      int cooldown,
      int delay,
      @JsonKey(includeFromJson: false, includeToJson: false) int stickyCounter,
      @JsonKey(includeFromJson: false, includeToJson: false)
      int cooldownCounter,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSticky,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool isOnCooldown});
}

/// @nodoc
class _$WorldInfoTimedEffectsCopyWithImpl<$Res,
        $Val extends WorldInfoTimedEffects>
    implements $WorldInfoTimedEffectsCopyWith<$Res> {
  _$WorldInfoTimedEffectsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorldInfoTimedEffects
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sticky = null,
    Object? cooldown = null,
    Object? delay = null,
    Object? stickyCounter = null,
    Object? cooldownCounter = null,
    Object? isSticky = null,
    Object? isOnCooldown = null,
  }) {
    return _then(_value.copyWith(
      sticky: null == sticky
          ? _value.sticky
          : sticky // ignore: cast_nullable_to_non_nullable
              as int,
      cooldown: null == cooldown
          ? _value.cooldown
          : cooldown // ignore: cast_nullable_to_non_nullable
              as int,
      delay: null == delay
          ? _value.delay
          : delay // ignore: cast_nullable_to_non_nullable
              as int,
      stickyCounter: null == stickyCounter
          ? _value.stickyCounter
          : stickyCounter // ignore: cast_nullable_to_non_nullable
              as int,
      cooldownCounter: null == cooldownCounter
          ? _value.cooldownCounter
          : cooldownCounter // ignore: cast_nullable_to_non_nullable
              as int,
      isSticky: null == isSticky
          ? _value.isSticky
          : isSticky // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnCooldown: null == isOnCooldown
          ? _value.isOnCooldown
          : isOnCooldown // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorldInfoTimedEffectsImplCopyWith<$Res>
    implements $WorldInfoTimedEffectsCopyWith<$Res> {
  factory _$$WorldInfoTimedEffectsImplCopyWith(
          _$WorldInfoTimedEffectsImpl value,
          $Res Function(_$WorldInfoTimedEffectsImpl) then) =
      __$$WorldInfoTimedEffectsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int sticky,
      int cooldown,
      int delay,
      @JsonKey(includeFromJson: false, includeToJson: false) int stickyCounter,
      @JsonKey(includeFromJson: false, includeToJson: false)
      int cooldownCounter,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isSticky,
      @JsonKey(includeFromJson: false, includeToJson: false)
      bool isOnCooldown});
}

/// @nodoc
class __$$WorldInfoTimedEffectsImplCopyWithImpl<$Res>
    extends _$WorldInfoTimedEffectsCopyWithImpl<$Res,
        _$WorldInfoTimedEffectsImpl>
    implements _$$WorldInfoTimedEffectsImplCopyWith<$Res> {
  __$$WorldInfoTimedEffectsImplCopyWithImpl(_$WorldInfoTimedEffectsImpl _value,
      $Res Function(_$WorldInfoTimedEffectsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorldInfoTimedEffects
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sticky = null,
    Object? cooldown = null,
    Object? delay = null,
    Object? stickyCounter = null,
    Object? cooldownCounter = null,
    Object? isSticky = null,
    Object? isOnCooldown = null,
  }) {
    return _then(_$WorldInfoTimedEffectsImpl(
      sticky: null == sticky
          ? _value.sticky
          : sticky // ignore: cast_nullable_to_non_nullable
              as int,
      cooldown: null == cooldown
          ? _value.cooldown
          : cooldown // ignore: cast_nullable_to_non_nullable
              as int,
      delay: null == delay
          ? _value.delay
          : delay // ignore: cast_nullable_to_non_nullable
              as int,
      stickyCounter: null == stickyCounter
          ? _value.stickyCounter
          : stickyCounter // ignore: cast_nullable_to_non_nullable
              as int,
      cooldownCounter: null == cooldownCounter
          ? _value.cooldownCounter
          : cooldownCounter // ignore: cast_nullable_to_non_nullable
              as int,
      isSticky: null == isSticky
          ? _value.isSticky
          : isSticky // ignore: cast_nullable_to_non_nullable
              as bool,
      isOnCooldown: null == isOnCooldown
          ? _value.isOnCooldown
          : isOnCooldown // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorldInfoTimedEffectsImpl implements _WorldInfoTimedEffects {
  const _$WorldInfoTimedEffectsImpl(
      {this.sticky = 0,
      this.cooldown = 0,
      this.delay = 0,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.stickyCounter = 0,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.cooldownCounter = 0,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isSticky = false,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.isOnCooldown = false});

  factory _$WorldInfoTimedEffectsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorldInfoTimedEffectsImplFromJson(json);

  /// Sticky duration - entry stays active for N messages after trigger
  /// 0 = not sticky (default)
  @override
  @JsonKey()
  final int sticky;

  /// Cooldown duration - entry cannot trigger again for N messages
  /// 0 = no cooldown (default)
  @override
  @JsonKey()
  final int cooldown;

  /// Delay - entry only triggers after N messages since chat start
  /// 0 = no delay (default)
  @override
  @JsonKey()
  final int delay;
// === Runtime state (not persisted) ===
  /// Current sticky counter (decrements each message)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int stickyCounter;

  /// Current cooldown counter (decrements each message)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int cooldownCounter;

  /// Whether entry is currently active due to sticky
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSticky;

  /// Whether entry is currently on cooldown
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isOnCooldown;

  @override
  String toString() {
    return 'WorldInfoTimedEffects(sticky: $sticky, cooldown: $cooldown, delay: $delay, stickyCounter: $stickyCounter, cooldownCounter: $cooldownCounter, isSticky: $isSticky, isOnCooldown: $isOnCooldown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorldInfoTimedEffectsImpl &&
            (identical(other.sticky, sticky) || other.sticky == sticky) &&
            (identical(other.cooldown, cooldown) ||
                other.cooldown == cooldown) &&
            (identical(other.delay, delay) || other.delay == delay) &&
            (identical(other.stickyCounter, stickyCounter) ||
                other.stickyCounter == stickyCounter) &&
            (identical(other.cooldownCounter, cooldownCounter) ||
                other.cooldownCounter == cooldownCounter) &&
            (identical(other.isSticky, isSticky) ||
                other.isSticky == isSticky) &&
            (identical(other.isOnCooldown, isOnCooldown) ||
                other.isOnCooldown == isOnCooldown));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sticky, cooldown, delay,
      stickyCounter, cooldownCounter, isSticky, isOnCooldown);

  /// Create a copy of WorldInfoTimedEffects
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorldInfoTimedEffectsImplCopyWith<_$WorldInfoTimedEffectsImpl>
      get copyWith => __$$WorldInfoTimedEffectsImplCopyWithImpl<
          _$WorldInfoTimedEffectsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorldInfoTimedEffectsImplToJson(
      this,
    );
  }
}

abstract class _WorldInfoTimedEffects implements WorldInfoTimedEffects {
  const factory _WorldInfoTimedEffects(
      {final int sticky,
      final int cooldown,
      final int delay,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final int stickyCounter,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final int cooldownCounter,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final bool isSticky,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final bool isOnCooldown}) = _$WorldInfoTimedEffectsImpl;

  factory _WorldInfoTimedEffects.fromJson(Map<String, dynamic> json) =
      _$WorldInfoTimedEffectsImpl.fromJson;

  /// Sticky duration - entry stays active for N messages after trigger
  /// 0 = not sticky (default)
  @override
  int get sticky;

  /// Cooldown duration - entry cannot trigger again for N messages
  /// 0 = no cooldown (default)
  @override
  int get cooldown;

  /// Delay - entry only triggers after N messages since chat start
  /// 0 = no delay (default)
  @override
  int get delay; // === Runtime state (not persisted) ===
  /// Current sticky counter (decrements each message)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get stickyCounter;

  /// Current cooldown counter (decrements each message)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get cooldownCounter;

  /// Whether entry is currently active due to sticky
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSticky;

  /// Whether entry is currently on cooldown
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isOnCooldown;

  /// Create a copy of WorldInfoTimedEffects
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldInfoTimedEffectsImplCopyWith<_$WorldInfoTimedEffectsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

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
  DateTime get modifiedAt =>
      throw _privateConstructorUsedError; // === New fields for SillyTavern compatibility ===
  /// Default scan depth for entries (can be overridden per entry)
  int get defaultScanDepth => throw _privateConstructorUsedError;

  /// Whether to use recursive scanning
  bool get recursiveScanning => throw _privateConstructorUsedError;

  /// Maximum recursion depth
  int get maxRecursionDepth => throw _privateConstructorUsedError;

  /// Whether entries can trigger other entries
  bool get allowEntryCascade => throw _privateConstructorUsedError;

  /// Tags for organization
  List<String> get tags => throw _privateConstructorUsedError;

  /// Creator notes (not sent to AI)
  String get creatorNotes => throw _privateConstructorUsedError;

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
      DateTime modifiedAt,
      int defaultScanDepth,
      bool recursiveScanning,
      int maxRecursionDepth,
      bool allowEntryCascade,
      List<String> tags,
      String creatorNotes});
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
    Object? defaultScanDepth = null,
    Object? recursiveScanning = null,
    Object? maxRecursionDepth = null,
    Object? allowEntryCascade = null,
    Object? tags = null,
    Object? creatorNotes = null,
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
      defaultScanDepth: null == defaultScanDepth
          ? _value.defaultScanDepth
          : defaultScanDepth // ignore: cast_nullable_to_non_nullable
              as int,
      recursiveScanning: null == recursiveScanning
          ? _value.recursiveScanning
          : recursiveScanning // ignore: cast_nullable_to_non_nullable
              as bool,
      maxRecursionDepth: null == maxRecursionDepth
          ? _value.maxRecursionDepth
          : maxRecursionDepth // ignore: cast_nullable_to_non_nullable
              as int,
      allowEntryCascade: null == allowEntryCascade
          ? _value.allowEntryCascade
          : allowEntryCascade // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      creatorNotes: null == creatorNotes
          ? _value.creatorNotes
          : creatorNotes // ignore: cast_nullable_to_non_nullable
              as String,
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
      DateTime modifiedAt,
      int defaultScanDepth,
      bool recursiveScanning,
      int maxRecursionDepth,
      bool allowEntryCascade,
      List<String> tags,
      String creatorNotes});
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
    Object? defaultScanDepth = null,
    Object? recursiveScanning = null,
    Object? maxRecursionDepth = null,
    Object? allowEntryCascade = null,
    Object? tags = null,
    Object? creatorNotes = null,
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
      defaultScanDepth: null == defaultScanDepth
          ? _value.defaultScanDepth
          : defaultScanDepth // ignore: cast_nullable_to_non_nullable
              as int,
      recursiveScanning: null == recursiveScanning
          ? _value.recursiveScanning
          : recursiveScanning // ignore: cast_nullable_to_non_nullable
              as bool,
      maxRecursionDepth: null == maxRecursionDepth
          ? _value.maxRecursionDepth
          : maxRecursionDepth // ignore: cast_nullable_to_non_nullable
              as int,
      allowEntryCascade: null == allowEntryCascade
          ? _value.allowEntryCascade
          : allowEntryCascade // ignore: cast_nullable_to_non_nullable
              as bool,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      creatorNotes: null == creatorNotes
          ? _value.creatorNotes
          : creatorNotes // ignore: cast_nullable_to_non_nullable
              as String,
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
      required this.modifiedAt,
      this.defaultScanDepth = 4,
      this.recursiveScanning = true,
      this.maxRecursionDepth = 3,
      this.allowEntryCascade = true,
      final List<String> tags = const [],
      this.creatorNotes = ''})
      : _entries = entries,
        _tags = tags;

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
// === New fields for SillyTavern compatibility ===
  /// Default scan depth for entries (can be overridden per entry)
  @override
  @JsonKey()
  final int defaultScanDepth;

  /// Whether to use recursive scanning
  @override
  @JsonKey()
  final bool recursiveScanning;

  /// Maximum recursion depth
  @override
  @JsonKey()
  final int maxRecursionDepth;

  /// Whether entries can trigger other entries
  @override
  @JsonKey()
  final bool allowEntryCascade;

  /// Tags for organization
  final List<String> _tags;

  /// Tags for organization
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Creator notes (not sent to AI)
  @override
  @JsonKey()
  final String creatorNotes;

  @override
  String toString() {
    return 'WorldInfo(id: $id, name: $name, description: $description, entries: $entries, enabled: $enabled, isGlobal: $isGlobal, characterId: $characterId, createdAt: $createdAt, modifiedAt: $modifiedAt, defaultScanDepth: $defaultScanDepth, recursiveScanning: $recursiveScanning, maxRecursionDepth: $maxRecursionDepth, allowEntryCascade: $allowEntryCascade, tags: $tags, creatorNotes: $creatorNotes)';
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
                other.modifiedAt == modifiedAt) &&
            (identical(other.defaultScanDepth, defaultScanDepth) ||
                other.defaultScanDepth == defaultScanDepth) &&
            (identical(other.recursiveScanning, recursiveScanning) ||
                other.recursiveScanning == recursiveScanning) &&
            (identical(other.maxRecursionDepth, maxRecursionDepth) ||
                other.maxRecursionDepth == maxRecursionDepth) &&
            (identical(other.allowEntryCascade, allowEntryCascade) ||
                other.allowEntryCascade == allowEntryCascade) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.creatorNotes, creatorNotes) ||
                other.creatorNotes == creatorNotes));
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
      modifiedAt,
      defaultScanDepth,
      recursiveScanning,
      maxRecursionDepth,
      allowEntryCascade,
      const DeepCollectionEquality().hash(_tags),
      creatorNotes);

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
      required final DateTime modifiedAt,
      final int defaultScanDepth,
      final bool recursiveScanning,
      final int maxRecursionDepth,
      final bool allowEntryCascade,
      final List<String> tags,
      final String creatorNotes}) = _$WorldInfoImpl;

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
  DateTime get modifiedAt; // === New fields for SillyTavern compatibility ===
  /// Default scan depth for entries (can be overridden per entry)
  @override
  int get defaultScanDepth;

  /// Whether to use recursive scanning
  @override
  bool get recursiveScanning;

  /// Maximum recursion depth
  @override
  int get maxRecursionDepth;

  /// Whether entries can trigger other entries
  @override
  bool get allowEntryCascade;

  /// Tags for organization
  @override
  List<String> get tags;

  /// Creator notes (not sent to AI)
  @override
  String get creatorNotes;

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
  Map<String, dynamic> get extensions =>
      throw _privateConstructorUsedError; // === New fields for SillyTavern compatibility ===
  /// Role for this entry's content (system, user, assistant)
  WorldInfoRole get role => throw _privateConstructorUsedError;

  /// Timed effects (sticky, cooldown, delay)
  WorldInfoTimedEffects get timedEffects => throw _privateConstructorUsedError;

  /// Character filter - which characters this entry applies to
  WorldInfoCharacterFilter get characterFilter =>
      throw _privateConstructorUsedError;

  /// Group override - priority within group (higher = more priority)
  int get groupOverride => throw _privateConstructorUsedError;

  /// Whether to exclude from recursion scanning
  bool get excludeRecursion => throw _privateConstructorUsedError;

  /// Whether probability is used (if false, always triggers when matched)
  bool get useProbability => throw _privateConstructorUsedError;

  /// Vectorized content for semantic search
  String? get vectorized => throw _privateConstructorUsedError;

  /// Display index for UI ordering
  int get displayIndex => throw _privateConstructorUsedError;

  /// Whether entry is favorited
  bool get isFavorite => throw _privateConstructorUsedError;

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
      Map<String, dynamic> extensions,
      WorldInfoRole role,
      WorldInfoTimedEffects timedEffects,
      WorldInfoCharacterFilter characterFilter,
      int groupOverride,
      bool excludeRecursion,
      bool useProbability,
      String? vectorized,
      int displayIndex,
      bool isFavorite});

  $WorldInfoTimedEffectsCopyWith<$Res> get timedEffects;
  $WorldInfoCharacterFilterCopyWith<$Res> get characterFilter;
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
    Object? role = null,
    Object? timedEffects = null,
    Object? characterFilter = null,
    Object? groupOverride = null,
    Object? excludeRecursion = null,
    Object? useProbability = null,
    Object? vectorized = freezed,
    Object? displayIndex = null,
    Object? isFavorite = null,
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
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as WorldInfoRole,
      timedEffects: null == timedEffects
          ? _value.timedEffects
          : timedEffects // ignore: cast_nullable_to_non_nullable
              as WorldInfoTimedEffects,
      characterFilter: null == characterFilter
          ? _value.characterFilter
          : characterFilter // ignore: cast_nullable_to_non_nullable
              as WorldInfoCharacterFilter,
      groupOverride: null == groupOverride
          ? _value.groupOverride
          : groupOverride // ignore: cast_nullable_to_non_nullable
              as int,
      excludeRecursion: null == excludeRecursion
          ? _value.excludeRecursion
          : excludeRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      useProbability: null == useProbability
          ? _value.useProbability
          : useProbability // ignore: cast_nullable_to_non_nullable
              as bool,
      vectorized: freezed == vectorized
          ? _value.vectorized
          : vectorized // ignore: cast_nullable_to_non_nullable
              as String?,
      displayIndex: null == displayIndex
          ? _value.displayIndex
          : displayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of WorldInfoEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorldInfoTimedEffectsCopyWith<$Res> get timedEffects {
    return $WorldInfoTimedEffectsCopyWith<$Res>(_value.timedEffects, (value) {
      return _then(_value.copyWith(timedEffects: value) as $Val);
    });
  }

  /// Create a copy of WorldInfoEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorldInfoCharacterFilterCopyWith<$Res> get characterFilter {
    return $WorldInfoCharacterFilterCopyWith<$Res>(_value.characterFilter,
        (value) {
      return _then(_value.copyWith(characterFilter: value) as $Val);
    });
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
      Map<String, dynamic> extensions,
      WorldInfoRole role,
      WorldInfoTimedEffects timedEffects,
      WorldInfoCharacterFilter characterFilter,
      int groupOverride,
      bool excludeRecursion,
      bool useProbability,
      String? vectorized,
      int displayIndex,
      bool isFavorite});

  @override
  $WorldInfoTimedEffectsCopyWith<$Res> get timedEffects;
  @override
  $WorldInfoCharacterFilterCopyWith<$Res> get characterFilter;
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
    Object? role = null,
    Object? timedEffects = null,
    Object? characterFilter = null,
    Object? groupOverride = null,
    Object? excludeRecursion = null,
    Object? useProbability = null,
    Object? vectorized = freezed,
    Object? displayIndex = null,
    Object? isFavorite = null,
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
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as WorldInfoRole,
      timedEffects: null == timedEffects
          ? _value.timedEffects
          : timedEffects // ignore: cast_nullable_to_non_nullable
              as WorldInfoTimedEffects,
      characterFilter: null == characterFilter
          ? _value.characterFilter
          : characterFilter // ignore: cast_nullable_to_non_nullable
              as WorldInfoCharacterFilter,
      groupOverride: null == groupOverride
          ? _value.groupOverride
          : groupOverride // ignore: cast_nullable_to_non_nullable
              as int,
      excludeRecursion: null == excludeRecursion
          ? _value.excludeRecursion
          : excludeRecursion // ignore: cast_nullable_to_non_nullable
              as bool,
      useProbability: null == useProbability
          ? _value.useProbability
          : useProbability // ignore: cast_nullable_to_non_nullable
              as bool,
      vectorized: freezed == vectorized
          ? _value.vectorized
          : vectorized // ignore: cast_nullable_to_non_nullable
              as String?,
      displayIndex: null == displayIndex
          ? _value.displayIndex
          : displayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
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
      this.position = WorldInfoPosition.before,
      this.depth = 0,
      this.group,
      this.groupWeight = 0,
      this.preventRecursion = false,
      this.delayUntilRecursion = false,
      this.scanDepth = 0,
      final Map<String, dynamic> extensions = const {},
      this.role = WorldInfoRole.system,
      this.timedEffects = const WorldInfoTimedEffects(),
      this.characterFilter = const WorldInfoCharacterFilter(),
      this.groupOverride = 0,
      this.excludeRecursion = false,
      this.useProbability = false,
      this.vectorized,
      this.displayIndex = 0,
      this.isFavorite = false})
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

// === New fields for SillyTavern compatibility ===
  /// Role for this entry's content (system, user, assistant)
  @override
  @JsonKey()
  final WorldInfoRole role;

  /// Timed effects (sticky, cooldown, delay)
  @override
  @JsonKey()
  final WorldInfoTimedEffects timedEffects;

  /// Character filter - which characters this entry applies to
  @override
  @JsonKey()
  final WorldInfoCharacterFilter characterFilter;

  /// Group override - priority within group (higher = more priority)
  @override
  @JsonKey()
  final int groupOverride;

  /// Whether to exclude from recursion scanning
  @override
  @JsonKey()
  final bool excludeRecursion;

  /// Whether probability is used (if false, always triggers when matched)
  @override
  @JsonKey()
  final bool useProbability;

  /// Vectorized content for semantic search
  @override
  final String? vectorized;

  /// Display index for UI ordering
  @override
  @JsonKey()
  final int displayIndex;

  /// Whether entry is favorited
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'WorldInfoEntry(id: $id, worldInfoId: $worldInfoId, keys: $keys, secondaryKeys: $secondaryKeys, content: $content, comment: $comment, enabled: $enabled, constant: $constant, selective: $selective, insertionOrder: $insertionOrder, caseSensitive: $caseSensitive, matchWholeWords: $matchWholeWords, useGroupScoring: $useGroupScoring, automationId: $automationId, probability: $probability, position: $position, depth: $depth, group: $group, groupWeight: $groupWeight, preventRecursion: $preventRecursion, delayUntilRecursion: $delayUntilRecursion, scanDepth: $scanDepth, extensions: $extensions, role: $role, timedEffects: $timedEffects, characterFilter: $characterFilter, groupOverride: $groupOverride, excludeRecursion: $excludeRecursion, useProbability: $useProbability, vectorized: $vectorized, displayIndex: $displayIndex, isFavorite: $isFavorite)';
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
                .equals(other._extensions, _extensions) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.timedEffects, timedEffects) ||
                other.timedEffects == timedEffects) &&
            (identical(other.characterFilter, characterFilter) ||
                other.characterFilter == characterFilter) &&
            (identical(other.groupOverride, groupOverride) ||
                other.groupOverride == groupOverride) &&
            (identical(other.excludeRecursion, excludeRecursion) ||
                other.excludeRecursion == excludeRecursion) &&
            (identical(other.useProbability, useProbability) ||
                other.useProbability == useProbability) &&
            (identical(other.vectorized, vectorized) ||
                other.vectorized == vectorized) &&
            (identical(other.displayIndex, displayIndex) ||
                other.displayIndex == displayIndex) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
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
        const DeepCollectionEquality().hash(_extensions),
        role,
        timedEffects,
        characterFilter,
        groupOverride,
        excludeRecursion,
        useProbability,
        vectorized,
        displayIndex,
        isFavorite
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
      final Map<String, dynamic> extensions,
      final WorldInfoRole role,
      final WorldInfoTimedEffects timedEffects,
      final WorldInfoCharacterFilter characterFilter,
      final int groupOverride,
      final bool excludeRecursion,
      final bool useProbability,
      final String? vectorized,
      final int displayIndex,
      final bool isFavorite}) = _$WorldInfoEntryImpl;

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
  Map<String, dynamic>
      get extensions; // === New fields for SillyTavern compatibility ===
  /// Role for this entry's content (system, user, assistant)
  @override
  WorldInfoRole get role;

  /// Timed effects (sticky, cooldown, delay)
  @override
  WorldInfoTimedEffects get timedEffects;

  /// Character filter - which characters this entry applies to
  @override
  WorldInfoCharacterFilter get characterFilter;

  /// Group override - priority within group (higher = more priority)
  @override
  int get groupOverride;

  /// Whether to exclude from recursion scanning
  @override
  bool get excludeRecursion;

  /// Whether probability is used (if false, always triggers when matched)
  @override
  bool get useProbability;

  /// Vectorized content for semantic search
  @override
  String? get vectorized;

  /// Display index for UI ordering
  @override
  int get displayIndex;

  /// Whether entry is favorited
  @override
  bool get isFavorite;

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
  Map<String, dynamic> get extensions =>
      throw _privateConstructorUsedError; // Timed effects
  int get sticky => throw _privateConstructorUsedError;
  int get cooldown => throw _privateConstructorUsedError;
  int get delay => throw _privateConstructorUsedError; // Character filter
  @JsonKey(name: 'character_filter')
  Map<String, dynamic>? get characterFilter =>
      throw _privateConstructorUsedError;

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
      Map<String, dynamic> extensions,
      int sticky,
      int cooldown,
      int delay,
      @JsonKey(name: 'character_filter')
      Map<String, dynamic>? characterFilter});
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
    Object? sticky = null,
    Object? cooldown = null,
    Object? delay = null,
    Object? characterFilter = freezed,
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
      sticky: null == sticky
          ? _value.sticky
          : sticky // ignore: cast_nullable_to_non_nullable
              as int,
      cooldown: null == cooldown
          ? _value.cooldown
          : cooldown // ignore: cast_nullable_to_non_nullable
              as int,
      delay: null == delay
          ? _value.delay
          : delay // ignore: cast_nullable_to_non_nullable
              as int,
      characterFilter: freezed == characterFilter
          ? _value.characterFilter
          : characterFilter // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      Map<String, dynamic> extensions,
      int sticky,
      int cooldown,
      int delay,
      @JsonKey(name: 'character_filter')
      Map<String, dynamic>? characterFilter});
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
    Object? sticky = null,
    Object? cooldown = null,
    Object? delay = null,
    Object? characterFilter = freezed,
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
      sticky: null == sticky
          ? _value.sticky
          : sticky // ignore: cast_nullable_to_non_nullable
              as int,
      cooldown: null == cooldown
          ? _value.cooldown
          : cooldown // ignore: cast_nullable_to_non_nullable
              as int,
      delay: null == delay
          ? _value.delay
          : delay // ignore: cast_nullable_to_non_nullable
              as int,
      characterFilter: freezed == characterFilter
          ? _value._characterFilter
          : characterFilter // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      final Map<String, dynamic> extensions = const {},
      this.sticky = 0,
      this.cooldown = 0,
      this.delay = 0,
      @JsonKey(name: 'character_filter')
      final Map<String, dynamic>? characterFilter})
      : _key = key,
        _keySecondary = keySecondary,
        _extensions = extensions,
        _characterFilter = characterFilter;

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

// Timed effects
  @override
  @JsonKey()
  final int sticky;
  @override
  @JsonKey()
  final int cooldown;
  @override
  @JsonKey()
  final int delay;
// Character filter
  final Map<String, dynamic>? _characterFilter;
// Character filter
  @override
  @JsonKey(name: 'character_filter')
  Map<String, dynamic>? get characterFilter {
    final value = _characterFilter;
    if (value == null) return null;
    if (_characterFilter is EqualUnmodifiableMapView) return _characterFilter;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WorldInfoEntryExport(uid: $uid, key: $key, keySecondary: $keySecondary, content: $content, comment: $comment, selective: $selective, constant: $constant, order: $order, position: $position, disable: $disable, excludeRecursion: $excludeRecursion, preventRecursion: $preventRecursion, delayUntilRecursion: $delayUntilRecursion, probability: $probability, useProbability: $useProbability, depth: $depth, group: $group, groupOverride: $groupOverride, groupWeight: $groupWeight, scanDepth: $scanDepth, caseSensitive: $caseSensitive, matchWholeWords: $matchWholeWords, useGroupScoring: $useGroupScoring, automationId: $automationId, role: $role, vectorized: $vectorized, extensions: $extensions, sticky: $sticky, cooldown: $cooldown, delay: $delay, characterFilter: $characterFilter)';
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
                .equals(other._extensions, _extensions) &&
            (identical(other.sticky, sticky) || other.sticky == sticky) &&
            (identical(other.cooldown, cooldown) ||
                other.cooldown == cooldown) &&
            (identical(other.delay, delay) || other.delay == delay) &&
            const DeepCollectionEquality()
                .equals(other._characterFilter, _characterFilter));
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
        const DeepCollectionEquality().hash(_extensions),
        sticky,
        cooldown,
        delay,
        const DeepCollectionEquality().hash(_characterFilter)
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
          final Map<String, dynamic> extensions,
          final int sticky,
          final int cooldown,
          final int delay,
          @JsonKey(name: 'character_filter')
          final Map<String, dynamic>? characterFilter}) =
      _$WorldInfoEntryExportImpl;

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
  Map<String, dynamic> get extensions; // Timed effects
  @override
  int get sticky;
  @override
  int get cooldown;
  @override
  int get delay; // Character filter
  @override
  @JsonKey(name: 'character_filter')
  Map<String, dynamic>? get characterFilter;

  /// Create a copy of WorldInfoEntryExport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorldInfoEntryExportImplCopyWith<_$WorldInfoEntryExportImpl>
      get copyWith => throw _privateConstructorUsedError;
}
