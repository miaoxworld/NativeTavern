// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'persona.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PersonaConnection _$PersonaConnectionFromJson(Map<String, dynamic> json) {
  return _PersonaConnection.fromJson(json);
}

/// @nodoc
mixin _$PersonaConnection {
  /// Character ID this persona is connected to (null for groups)
  String? get characterId => throw _privateConstructorUsedError;

  /// Group ID this persona is connected to (null for characters)
  String? get groupId => throw _privateConstructorUsedError;

  /// Lock type for this connection
  PersonaLockType get lockType => throw _privateConstructorUsedError;

  /// Serializes this PersonaConnection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonaConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonaConnectionCopyWith<PersonaConnection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaConnectionCopyWith<$Res> {
  factory $PersonaConnectionCopyWith(
          PersonaConnection value, $Res Function(PersonaConnection) then) =
      _$PersonaConnectionCopyWithImpl<$Res, PersonaConnection>;
  @useResult
  $Res call({String? characterId, String? groupId, PersonaLockType lockType});
}

/// @nodoc
class _$PersonaConnectionCopyWithImpl<$Res, $Val extends PersonaConnection>
    implements $PersonaConnectionCopyWith<$Res> {
  _$PersonaConnectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonaConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? characterId = freezed,
    Object? groupId = freezed,
    Object? lockType = null,
  }) {
    return _then(_value.copyWith(
      characterId: freezed == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      lockType: null == lockType
          ? _value.lockType
          : lockType // ignore: cast_nullable_to_non_nullable
              as PersonaLockType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonaConnectionImplCopyWith<$Res>
    implements $PersonaConnectionCopyWith<$Res> {
  factory _$$PersonaConnectionImplCopyWith(_$PersonaConnectionImpl value,
          $Res Function(_$PersonaConnectionImpl) then) =
      __$$PersonaConnectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? characterId, String? groupId, PersonaLockType lockType});
}

/// @nodoc
class __$$PersonaConnectionImplCopyWithImpl<$Res>
    extends _$PersonaConnectionCopyWithImpl<$Res, _$PersonaConnectionImpl>
    implements _$$PersonaConnectionImplCopyWith<$Res> {
  __$$PersonaConnectionImplCopyWithImpl(_$PersonaConnectionImpl _value,
      $Res Function(_$PersonaConnectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonaConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? characterId = freezed,
    Object? groupId = freezed,
    Object? lockType = null,
  }) {
    return _then(_$PersonaConnectionImpl(
      characterId: freezed == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      lockType: null == lockType
          ? _value.lockType
          : lockType // ignore: cast_nullable_to_non_nullable
              as PersonaLockType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonaConnectionImpl implements _PersonaConnection {
  const _$PersonaConnectionImpl(
      {this.characterId, this.groupId, this.lockType = PersonaLockType.none});

  factory _$PersonaConnectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaConnectionImplFromJson(json);

  /// Character ID this persona is connected to (null for groups)
  @override
  final String? characterId;

  /// Group ID this persona is connected to (null for characters)
  @override
  final String? groupId;

  /// Lock type for this connection
  @override
  @JsonKey()
  final PersonaLockType lockType;

  @override
  String toString() {
    return 'PersonaConnection(characterId: $characterId, groupId: $groupId, lockType: $lockType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaConnectionImpl &&
            (identical(other.characterId, characterId) ||
                other.characterId == characterId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.lockType, lockType) ||
                other.lockType == lockType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, characterId, groupId, lockType);

  /// Create a copy of PersonaConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaConnectionImplCopyWith<_$PersonaConnectionImpl> get copyWith =>
      __$$PersonaConnectionImplCopyWithImpl<_$PersonaConnectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaConnectionImplToJson(
      this,
    );
  }
}

abstract class _PersonaConnection implements PersonaConnection {
  const factory _PersonaConnection(
      {final String? characterId,
      final String? groupId,
      final PersonaLockType lockType}) = _$PersonaConnectionImpl;

  factory _PersonaConnection.fromJson(Map<String, dynamic> json) =
      _$PersonaConnectionImpl.fromJson;

  /// Character ID this persona is connected to (null for groups)
  @override
  String? get characterId;

  /// Group ID this persona is connected to (null for characters)
  @override
  String? get groupId;

  /// Lock type for this connection
  @override
  PersonaLockType get lockType;

  /// Create a copy of PersonaConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonaConnectionImplCopyWith<_$PersonaConnectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PersonaDescriptionSettings _$PersonaDescriptionSettingsFromJson(
    Map<String, dynamic> json) {
  return _PersonaDescriptionSettings.fromJson(json);
}

/// @nodoc
mixin _$PersonaDescriptionSettings {
  /// Position where description is inserted
  PersonaDescriptionPosition get position => throw _privateConstructorUsedError;

  /// Depth for atDepth position (0 = after last message)
  int get depth => throw _privateConstructorUsedError;

  /// Role for the description message
  PersonaDescriptionRole get role => throw _privateConstructorUsedError;

  /// Serializes this PersonaDescriptionSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonaDescriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonaDescriptionSettingsCopyWith<PersonaDescriptionSettings>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaDescriptionSettingsCopyWith<$Res> {
  factory $PersonaDescriptionSettingsCopyWith(PersonaDescriptionSettings value,
          $Res Function(PersonaDescriptionSettings) then) =
      _$PersonaDescriptionSettingsCopyWithImpl<$Res,
          PersonaDescriptionSettings>;
  @useResult
  $Res call(
      {PersonaDescriptionPosition position,
      int depth,
      PersonaDescriptionRole role});
}

/// @nodoc
class _$PersonaDescriptionSettingsCopyWithImpl<$Res,
        $Val extends PersonaDescriptionSettings>
    implements $PersonaDescriptionSettingsCopyWith<$Res> {
  _$PersonaDescriptionSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonaDescriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? depth = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PersonaDescriptionPosition,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as PersonaDescriptionRole,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonaDescriptionSettingsImplCopyWith<$Res>
    implements $PersonaDescriptionSettingsCopyWith<$Res> {
  factory _$$PersonaDescriptionSettingsImplCopyWith(
          _$PersonaDescriptionSettingsImpl value,
          $Res Function(_$PersonaDescriptionSettingsImpl) then) =
      __$$PersonaDescriptionSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PersonaDescriptionPosition position,
      int depth,
      PersonaDescriptionRole role});
}

/// @nodoc
class __$$PersonaDescriptionSettingsImplCopyWithImpl<$Res>
    extends _$PersonaDescriptionSettingsCopyWithImpl<$Res,
        _$PersonaDescriptionSettingsImpl>
    implements _$$PersonaDescriptionSettingsImplCopyWith<$Res> {
  __$$PersonaDescriptionSettingsImplCopyWithImpl(
      _$PersonaDescriptionSettingsImpl _value,
      $Res Function(_$PersonaDescriptionSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonaDescriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? depth = null,
    Object? role = null,
  }) {
    return _then(_$PersonaDescriptionSettingsImpl(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PersonaDescriptionPosition,
      depth: null == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as PersonaDescriptionRole,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonaDescriptionSettingsImpl implements _PersonaDescriptionSettings {
  const _$PersonaDescriptionSettingsImpl(
      {this.position = PersonaDescriptionPosition.beforeChar,
      this.depth = 0,
      this.role = PersonaDescriptionRole.system});

  factory _$PersonaDescriptionSettingsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PersonaDescriptionSettingsImplFromJson(json);

  /// Position where description is inserted
  @override
  @JsonKey()
  final PersonaDescriptionPosition position;

  /// Depth for atDepth position (0 = after last message)
  @override
  @JsonKey()
  final int depth;

  /// Role for the description message
  @override
  @JsonKey()
  final PersonaDescriptionRole role;

  @override
  String toString() {
    return 'PersonaDescriptionSettings(position: $position, depth: $depth, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaDescriptionSettingsImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, position, depth, role);

  /// Create a copy of PersonaDescriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaDescriptionSettingsImplCopyWith<_$PersonaDescriptionSettingsImpl>
      get copyWith => __$$PersonaDescriptionSettingsImplCopyWithImpl<
          _$PersonaDescriptionSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaDescriptionSettingsImplToJson(
      this,
    );
  }
}

abstract class _PersonaDescriptionSettings
    implements PersonaDescriptionSettings {
  const factory _PersonaDescriptionSettings(
      {final PersonaDescriptionPosition position,
      final int depth,
      final PersonaDescriptionRole role}) = _$PersonaDescriptionSettingsImpl;

  factory _PersonaDescriptionSettings.fromJson(Map<String, dynamic> json) =
      _$PersonaDescriptionSettingsImpl.fromJson;

  /// Position where description is inserted
  @override
  PersonaDescriptionPosition get position;

  /// Depth for atDepth position (0 = after last message)
  @override
  int get depth;

  /// Role for the description message
  @override
  PersonaDescriptionRole get role;

  /// Create a copy of PersonaDescriptionSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonaDescriptionSettingsImplCopyWith<_$PersonaDescriptionSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Persona _$PersonaFromJson(Map<String, dynamic> json) {
  return _Persona.fromJson(json);
}

/// @nodoc
mixin _$Persona {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get avatarPath => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // === New fields for SillyTavern compatibility ===
  /// Connections to characters/groups
  List<PersonaConnection> get connections => throw _privateConstructorUsedError;

  /// Description settings (position, depth, role)
  PersonaDescriptionSettings get descriptionSettings =>
      throw _privateConstructorUsedError;

  /// Persona-specific lorebook/world info ID
  /// If set, this world info is activated when persona is active
  String? get lorebookId => throw _privateConstructorUsedError;

  /// Custom system prompt override for this persona
  String? get systemPromptOverride => throw _privateConstructorUsedError;

  /// Custom post-history instructions for this persona
  String? get postHistoryInstructions => throw _privateConstructorUsedError;

  /// Tags for organization
  List<String> get tags => throw _privateConstructorUsedError;

  /// Creator notes (not sent to AI)
  String get creatorNotes => throw _privateConstructorUsedError;

  /// Favorite status
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Serializes this Persona to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonaCopyWith<Persona> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonaCopyWith<$Res> {
  factory $PersonaCopyWith(Persona value, $Res Function(Persona) then) =
      _$PersonaCopyWithImpl<$Res, Persona>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String? avatarPath,
      bool isDefault,
      DateTime createdAt,
      DateTime updatedAt,
      List<PersonaConnection> connections,
      PersonaDescriptionSettings descriptionSettings,
      String? lorebookId,
      String? systemPromptOverride,
      String? postHistoryInstructions,
      List<String> tags,
      String creatorNotes,
      bool isFavorite});

  $PersonaDescriptionSettingsCopyWith<$Res> get descriptionSettings;
}

/// @nodoc
class _$PersonaCopyWithImpl<$Res, $Val extends Persona>
    implements $PersonaCopyWith<$Res> {
  _$PersonaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? avatarPath = freezed,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? connections = null,
    Object? descriptionSettings = null,
    Object? lorebookId = freezed,
    Object? systemPromptOverride = freezed,
    Object? postHistoryInstructions = freezed,
    Object? tags = null,
    Object? creatorNotes = null,
    Object? isFavorite = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      connections: null == connections
          ? _value.connections
          : connections // ignore: cast_nullable_to_non_nullable
              as List<PersonaConnection>,
      descriptionSettings: null == descriptionSettings
          ? _value.descriptionSettings
          : descriptionSettings // ignore: cast_nullable_to_non_nullable
              as PersonaDescriptionSettings,
      lorebookId: freezed == lorebookId
          ? _value.lorebookId
          : lorebookId // ignore: cast_nullable_to_non_nullable
              as String?,
      systemPromptOverride: freezed == systemPromptOverride
          ? _value.systemPromptOverride
          : systemPromptOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      postHistoryInstructions: freezed == postHistoryInstructions
          ? _value.postHistoryInstructions
          : postHistoryInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      creatorNotes: null == creatorNotes
          ? _value.creatorNotes
          : creatorNotes // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PersonaDescriptionSettingsCopyWith<$Res> get descriptionSettings {
    return $PersonaDescriptionSettingsCopyWith<$Res>(_value.descriptionSettings,
        (value) {
      return _then(_value.copyWith(descriptionSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PersonaImplCopyWith<$Res> implements $PersonaCopyWith<$Res> {
  factory _$$PersonaImplCopyWith(
          _$PersonaImpl value, $Res Function(_$PersonaImpl) then) =
      __$$PersonaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String? avatarPath,
      bool isDefault,
      DateTime createdAt,
      DateTime updatedAt,
      List<PersonaConnection> connections,
      PersonaDescriptionSettings descriptionSettings,
      String? lorebookId,
      String? systemPromptOverride,
      String? postHistoryInstructions,
      List<String> tags,
      String creatorNotes,
      bool isFavorite});

  @override
  $PersonaDescriptionSettingsCopyWith<$Res> get descriptionSettings;
}

/// @nodoc
class __$$PersonaImplCopyWithImpl<$Res>
    extends _$PersonaCopyWithImpl<$Res, _$PersonaImpl>
    implements _$$PersonaImplCopyWith<$Res> {
  __$$PersonaImplCopyWithImpl(
      _$PersonaImpl _value, $Res Function(_$PersonaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? avatarPath = freezed,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? connections = null,
    Object? descriptionSettings = null,
    Object? lorebookId = freezed,
    Object? systemPromptOverride = freezed,
    Object? postHistoryInstructions = freezed,
    Object? tags = null,
    Object? creatorNotes = null,
    Object? isFavorite = null,
  }) {
    return _then(_$PersonaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      connections: null == connections
          ? _value._connections
          : connections // ignore: cast_nullable_to_non_nullable
              as List<PersonaConnection>,
      descriptionSettings: null == descriptionSettings
          ? _value.descriptionSettings
          : descriptionSettings // ignore: cast_nullable_to_non_nullable
              as PersonaDescriptionSettings,
      lorebookId: freezed == lorebookId
          ? _value.lorebookId
          : lorebookId // ignore: cast_nullable_to_non_nullable
              as String?,
      systemPromptOverride: freezed == systemPromptOverride
          ? _value.systemPromptOverride
          : systemPromptOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      postHistoryInstructions: freezed == postHistoryInstructions
          ? _value.postHistoryInstructions
          : postHistoryInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      creatorNotes: null == creatorNotes
          ? _value.creatorNotes
          : creatorNotes // ignore: cast_nullable_to_non_nullable
              as String,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonaImpl implements _Persona {
  const _$PersonaImpl(
      {required this.id,
      required this.name,
      this.description = '',
      this.avatarPath,
      this.isDefault = false,
      required this.createdAt,
      required this.updatedAt,
      final List<PersonaConnection> connections = const [],
      this.descriptionSettings = const PersonaDescriptionSettings(),
      this.lorebookId,
      this.systemPromptOverride,
      this.postHistoryInstructions,
      final List<String> tags = const [],
      this.creatorNotes = '',
      this.isFavorite = false})
      : _connections = connections,
        _tags = tags;

  factory _$PersonaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonaImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  final String? avatarPath;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
// === New fields for SillyTavern compatibility ===
  /// Connections to characters/groups
  final List<PersonaConnection> _connections;
// === New fields for SillyTavern compatibility ===
  /// Connections to characters/groups
  @override
  @JsonKey()
  List<PersonaConnection> get connections {
    if (_connections is EqualUnmodifiableListView) return _connections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_connections);
  }

  /// Description settings (position, depth, role)
  @override
  @JsonKey()
  final PersonaDescriptionSettings descriptionSettings;

  /// Persona-specific lorebook/world info ID
  /// If set, this world info is activated when persona is active
  @override
  final String? lorebookId;

  /// Custom system prompt override for this persona
  @override
  final String? systemPromptOverride;

  /// Custom post-history instructions for this persona
  @override
  final String? postHistoryInstructions;

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

  /// Favorite status
  @override
  @JsonKey()
  final bool isFavorite;

  @override
  String toString() {
    return 'Persona(id: $id, name: $name, description: $description, avatarPath: $avatarPath, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt, connections: $connections, descriptionSettings: $descriptionSettings, lorebookId: $lorebookId, systemPromptOverride: $systemPromptOverride, postHistoryInstructions: $postHistoryInstructions, tags: $tags, creatorNotes: $creatorNotes, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._connections, _connections) &&
            (identical(other.descriptionSettings, descriptionSettings) ||
                other.descriptionSettings == descriptionSettings) &&
            (identical(other.lorebookId, lorebookId) ||
                other.lorebookId == lorebookId) &&
            (identical(other.systemPromptOverride, systemPromptOverride) ||
                other.systemPromptOverride == systemPromptOverride) &&
            (identical(
                    other.postHistoryInstructions, postHistoryInstructions) ||
                other.postHistoryInstructions == postHistoryInstructions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.creatorNotes, creatorNotes) ||
                other.creatorNotes == creatorNotes) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      avatarPath,
      isDefault,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_connections),
      descriptionSettings,
      lorebookId,
      systemPromptOverride,
      postHistoryInstructions,
      const DeepCollectionEquality().hash(_tags),
      creatorNotes,
      isFavorite);

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      __$$PersonaImplCopyWithImpl<_$PersonaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonaImplToJson(
      this,
    );
  }
}

abstract class _Persona implements Persona {
  const factory _Persona(
      {required final String id,
      required final String name,
      final String description,
      final String? avatarPath,
      final bool isDefault,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<PersonaConnection> connections,
      final PersonaDescriptionSettings descriptionSettings,
      final String? lorebookId,
      final String? systemPromptOverride,
      final String? postHistoryInstructions,
      final List<String> tags,
      final String creatorNotes,
      final bool isFavorite}) = _$PersonaImpl;

  factory _Persona.fromJson(Map<String, dynamic> json) = _$PersonaImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String? get avatarPath;
  @override
  bool get isDefault;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // === New fields for SillyTavern compatibility ===
  /// Connections to characters/groups
  @override
  List<PersonaConnection> get connections;

  /// Description settings (position, depth, role)
  @override
  PersonaDescriptionSettings get descriptionSettings;

  /// Persona-specific lorebook/world info ID
  /// If set, this world info is activated when persona is active
  @override
  String? get lorebookId;

  /// Custom system prompt override for this persona
  @override
  String? get systemPromptOverride;

  /// Custom post-history instructions for this persona
  @override
  String? get postHistoryInstructions;

  /// Tags for organization
  @override
  List<String> get tags;

  /// Creator notes (not sent to AI)
  @override
  String get creatorNotes;

  /// Favorite status
  @override
  bool get isFavorite;

  /// Create a copy of Persona
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonaImplCopyWith<_$PersonaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
