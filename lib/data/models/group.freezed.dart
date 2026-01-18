// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<GroupMember> get members => throw _privateConstructorUsedError;
  GroupSettings get settings => throw _privateConstructorUsedError;
  String? get avatarPath => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get modifiedAt =>
      throw _privateConstructorUsedError; // === New fields for SillyTavern compatibility ===
  /// Tags for organization
  List<String> get tags => throw _privateConstructorUsedError;

  /// Whether this is a favorite group
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Creator notes (not sent to AI)
  String get creatorNotes => throw _privateConstructorUsedError;

  /// Group-specific world info/lorebook ID
  String? get lorebookId => throw _privateConstructorUsedError;

  /// Group-specific scenario (overrides character scenarios)
  String? get scenario => throw _privateConstructorUsedError;

  /// Group-specific first message
  String? get firstMessage => throw _privateConstructorUsedError;

  /// Chat metadata for the current chat
  Map<String, dynamic> get chatMetadata => throw _privateConstructorUsedError;

  /// Past chats metadata
  List<GroupChatInfo> get pastChats => throw _privateConstructorUsedError;

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<GroupMember> members,
      GroupSettings settings,
      String? avatarPath,
      DateTime createdAt,
      DateTime modifiedAt,
      List<String> tags,
      bool isFavorite,
      String creatorNotes,
      String? lorebookId,
      String? scenario,
      String? firstMessage,
      Map<String, dynamic> chatMetadata,
      List<GroupChatInfo> pastChats});

  $GroupSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? members = null,
    Object? settings = null,
    Object? avatarPath = freezed,
    Object? createdAt = null,
    Object? modifiedAt = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? creatorNotes = null,
    Object? lorebookId = freezed,
    Object? scenario = freezed,
    Object? firstMessage = freezed,
    Object? chatMetadata = null,
    Object? pastChats = null,
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
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as GroupSettings,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: null == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      creatorNotes: null == creatorNotes
          ? _value.creatorNotes
          : creatorNotes // ignore: cast_nullable_to_non_nullable
              as String,
      lorebookId: freezed == lorebookId
          ? _value.lorebookId
          : lorebookId // ignore: cast_nullable_to_non_nullable
              as String?,
      scenario: freezed == scenario
          ? _value.scenario
          : scenario // ignore: cast_nullable_to_non_nullable
              as String?,
      firstMessage: freezed == firstMessage
          ? _value.firstMessage
          : firstMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      chatMetadata: null == chatMetadata
          ? _value.chatMetadata
          : chatMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      pastChats: null == pastChats
          ? _value.pastChats
          : pastChats // ignore: cast_nullable_to_non_nullable
              as List<GroupChatInfo>,
    ) as $Val);
  }

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupSettingsCopyWith<$Res> get settings {
    return $GroupSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupImplCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$GroupImplCopyWith(
          _$GroupImpl value, $Res Function(_$GroupImpl) then) =
      __$$GroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<GroupMember> members,
      GroupSettings settings,
      String? avatarPath,
      DateTime createdAt,
      DateTime modifiedAt,
      List<String> tags,
      bool isFavorite,
      String creatorNotes,
      String? lorebookId,
      String? scenario,
      String? firstMessage,
      Map<String, dynamic> chatMetadata,
      List<GroupChatInfo> pastChats});

  @override
  $GroupSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$GroupImplCopyWithImpl<$Res>
    extends _$GroupCopyWithImpl<$Res, _$GroupImpl>
    implements _$$GroupImplCopyWith<$Res> {
  __$$GroupImplCopyWithImpl(
      _$GroupImpl _value, $Res Function(_$GroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? members = null,
    Object? settings = null,
    Object? avatarPath = freezed,
    Object? createdAt = null,
    Object? modifiedAt = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? creatorNotes = null,
    Object? lorebookId = freezed,
    Object? scenario = freezed,
    Object? firstMessage = freezed,
    Object? chatMetadata = null,
    Object? pastChats = null,
  }) {
    return _then(_$GroupImpl(
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
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<GroupMember>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as GroupSettings,
      avatarPath: freezed == avatarPath
          ? _value.avatarPath
          : avatarPath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: null == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      creatorNotes: null == creatorNotes
          ? _value.creatorNotes
          : creatorNotes // ignore: cast_nullable_to_non_nullable
              as String,
      lorebookId: freezed == lorebookId
          ? _value.lorebookId
          : lorebookId // ignore: cast_nullable_to_non_nullable
              as String?,
      scenario: freezed == scenario
          ? _value.scenario
          : scenario // ignore: cast_nullable_to_non_nullable
              as String?,
      firstMessage: freezed == firstMessage
          ? _value.firstMessage
          : firstMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      chatMetadata: null == chatMetadata
          ? _value._chatMetadata
          : chatMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      pastChats: null == pastChats
          ? _value._pastChats
          : pastChats // ignore: cast_nullable_to_non_nullable
              as List<GroupChatInfo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupImpl implements _Group {
  const _$GroupImpl(
      {required this.id,
      required this.name,
      this.description,
      final List<GroupMember> members = const [],
      this.settings = const GroupSettings(),
      this.avatarPath,
      required this.createdAt,
      required this.modifiedAt,
      final List<String> tags = const [],
      this.isFavorite = false,
      this.creatorNotes = '',
      this.lorebookId,
      this.scenario,
      this.firstMessage,
      final Map<String, dynamic> chatMetadata = const {},
      final List<GroupChatInfo> pastChats = const []})
      : _members = members,
        _tags = tags,
        _chatMetadata = chatMetadata,
        _pastChats = pastChats;

  factory _$GroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  final List<GroupMember> _members;
  @override
  @JsonKey()
  List<GroupMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  @JsonKey()
  final GroupSettings settings;
  @override
  final String? avatarPath;
  @override
  final DateTime createdAt;
  @override
  final DateTime modifiedAt;
// === New fields for SillyTavern compatibility ===
  /// Tags for organization
  final List<String> _tags;
// === New fields for SillyTavern compatibility ===
  /// Tags for organization
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Whether this is a favorite group
  @override
  @JsonKey()
  final bool isFavorite;

  /// Creator notes (not sent to AI)
  @override
  @JsonKey()
  final String creatorNotes;

  /// Group-specific world info/lorebook ID
  @override
  final String? lorebookId;

  /// Group-specific scenario (overrides character scenarios)
  @override
  final String? scenario;

  /// Group-specific first message
  @override
  final String? firstMessage;

  /// Chat metadata for the current chat
  final Map<String, dynamic> _chatMetadata;

  /// Chat metadata for the current chat
  @override
  @JsonKey()
  Map<String, dynamic> get chatMetadata {
    if (_chatMetadata is EqualUnmodifiableMapView) return _chatMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_chatMetadata);
  }

  /// Past chats metadata
  final List<GroupChatInfo> _pastChats;

  /// Past chats metadata
  @override
  @JsonKey()
  List<GroupChatInfo> get pastChats {
    if (_pastChats is EqualUnmodifiableListView) return _pastChats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pastChats);
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, description: $description, members: $members, settings: $settings, avatarPath: $avatarPath, createdAt: $createdAt, modifiedAt: $modifiedAt, tags: $tags, isFavorite: $isFavorite, creatorNotes: $creatorNotes, lorebookId: $lorebookId, scenario: $scenario, firstMessage: $firstMessage, chatMetadata: $chatMetadata, pastChats: $pastChats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.avatarPath, avatarPath) ||
                other.avatarPath == avatarPath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.creatorNotes, creatorNotes) ||
                other.creatorNotes == creatorNotes) &&
            (identical(other.lorebookId, lorebookId) ||
                other.lorebookId == lorebookId) &&
            (identical(other.scenario, scenario) ||
                other.scenario == scenario) &&
            (identical(other.firstMessage, firstMessage) ||
                other.firstMessage == firstMessage) &&
            const DeepCollectionEquality()
                .equals(other._chatMetadata, _chatMetadata) &&
            const DeepCollectionEquality()
                .equals(other._pastChats, _pastChats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_members),
      settings,
      avatarPath,
      createdAt,
      modifiedAt,
      const DeepCollectionEquality().hash(_tags),
      isFavorite,
      creatorNotes,
      lorebookId,
      scenario,
      firstMessage,
      const DeepCollectionEquality().hash(_chatMetadata),
      const DeepCollectionEquality().hash(_pastChats));

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      __$$GroupImplCopyWithImpl<_$GroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupImplToJson(
      this,
    );
  }
}

abstract class _Group implements Group {
  const factory _Group(
      {required final String id,
      required final String name,
      final String? description,
      final List<GroupMember> members,
      final GroupSettings settings,
      final String? avatarPath,
      required final DateTime createdAt,
      required final DateTime modifiedAt,
      final List<String> tags,
      final bool isFavorite,
      final String creatorNotes,
      final String? lorebookId,
      final String? scenario,
      final String? firstMessage,
      final Map<String, dynamic> chatMetadata,
      final List<GroupChatInfo> pastChats}) = _$GroupImpl;

  factory _Group.fromJson(Map<String, dynamic> json) = _$GroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<GroupMember> get members;
  @override
  GroupSettings get settings;
  @override
  String? get avatarPath;
  @override
  DateTime get createdAt;
  @override
  DateTime get modifiedAt; // === New fields for SillyTavern compatibility ===
  /// Tags for organization
  @override
  List<String> get tags;

  /// Whether this is a favorite group
  @override
  bool get isFavorite;

  /// Creator notes (not sent to AI)
  @override
  String get creatorNotes;

  /// Group-specific world info/lorebook ID
  @override
  String? get lorebookId;

  /// Group-specific scenario (overrides character scenarios)
  @override
  String? get scenario;

  /// Group-specific first message
  @override
  String? get firstMessage;

  /// Chat metadata for the current chat
  @override
  Map<String, dynamic> get chatMetadata;

  /// Past chats metadata
  @override
  List<GroupChatInfo> get pastChats;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) {
  return _GroupMember.fromJson(json);
}

/// @nodoc
mixin _$GroupMember {
  String get characterId => throw _privateConstructorUsedError;
  bool get isMuted => throw _privateConstructorUsedError;
  int get talkativeness =>
      throw _privateConstructorUsedError; // 0-100, affects selection probability
  int get triggerProbability => throw _privateConstructorUsedError; // 0-100
  List<String> get triggerWords =>
      throw _privateConstructorUsedError; // Words that trigger this character
  int get insertionOrder =>
      throw _privateConstructorUsedError; // Order in the list
// === New fields for SillyTavern compatibility ===
  /// Depth prompt for this member (inserted at specific depth)
  String? get depthPrompt => throw _privateConstructorUsedError;

  /// Depth at which to insert the depth prompt
  int get depthPromptDepth => throw _privateConstructorUsedError;

  /// Role for depth prompt (system, user, assistant)
  GroupMemberDepthRole get depthPromptRole =>
      throw _privateConstructorUsedError;

  /// Whether this member is currently active in the conversation
  bool get isActive => throw _privateConstructorUsedError;

  /// Custom display name override
  String? get displayNameOverride => throw _privateConstructorUsedError;

  /// Custom avatar override
  String? get avatarOverride => throw _privateConstructorUsedError;

  /// Member-specific extensions data
  Map<String, dynamic> get extensions => throw _privateConstructorUsedError;

  /// Serializes this GroupMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMemberCopyWith<GroupMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMemberCopyWith<$Res> {
  factory $GroupMemberCopyWith(
          GroupMember value, $Res Function(GroupMember) then) =
      _$GroupMemberCopyWithImpl<$Res, GroupMember>;
  @useResult
  $Res call(
      {String characterId,
      bool isMuted,
      int talkativeness,
      int triggerProbability,
      List<String> triggerWords,
      int insertionOrder,
      String? depthPrompt,
      int depthPromptDepth,
      GroupMemberDepthRole depthPromptRole,
      bool isActive,
      String? displayNameOverride,
      String? avatarOverride,
      Map<String, dynamic> extensions});
}

/// @nodoc
class _$GroupMemberCopyWithImpl<$Res, $Val extends GroupMember>
    implements $GroupMemberCopyWith<$Res> {
  _$GroupMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? characterId = null,
    Object? isMuted = null,
    Object? talkativeness = null,
    Object? triggerProbability = null,
    Object? triggerWords = null,
    Object? insertionOrder = null,
    Object? depthPrompt = freezed,
    Object? depthPromptDepth = null,
    Object? depthPromptRole = null,
    Object? isActive = null,
    Object? displayNameOverride = freezed,
    Object? avatarOverride = freezed,
    Object? extensions = null,
  }) {
    return _then(_value.copyWith(
      characterId: null == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      talkativeness: null == talkativeness
          ? _value.talkativeness
          : talkativeness // ignore: cast_nullable_to_non_nullable
              as int,
      triggerProbability: null == triggerProbability
          ? _value.triggerProbability
          : triggerProbability // ignore: cast_nullable_to_non_nullable
              as int,
      triggerWords: null == triggerWords
          ? _value.triggerWords
          : triggerWords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      insertionOrder: null == insertionOrder
          ? _value.insertionOrder
          : insertionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      depthPrompt: freezed == depthPrompt
          ? _value.depthPrompt
          : depthPrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      depthPromptDepth: null == depthPromptDepth
          ? _value.depthPromptDepth
          : depthPromptDepth // ignore: cast_nullable_to_non_nullable
              as int,
      depthPromptRole: null == depthPromptRole
          ? _value.depthPromptRole
          : depthPromptRole // ignore: cast_nullable_to_non_nullable
              as GroupMemberDepthRole,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayNameOverride: freezed == displayNameOverride
          ? _value.displayNameOverride
          : displayNameOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarOverride: freezed == avatarOverride
          ? _value.avatarOverride
          : avatarOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      extensions: null == extensions
          ? _value.extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupMemberImplCopyWith<$Res>
    implements $GroupMemberCopyWith<$Res> {
  factory _$$GroupMemberImplCopyWith(
          _$GroupMemberImpl value, $Res Function(_$GroupMemberImpl) then) =
      __$$GroupMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String characterId,
      bool isMuted,
      int talkativeness,
      int triggerProbability,
      List<String> triggerWords,
      int insertionOrder,
      String? depthPrompt,
      int depthPromptDepth,
      GroupMemberDepthRole depthPromptRole,
      bool isActive,
      String? displayNameOverride,
      String? avatarOverride,
      Map<String, dynamic> extensions});
}

/// @nodoc
class __$$GroupMemberImplCopyWithImpl<$Res>
    extends _$GroupMemberCopyWithImpl<$Res, _$GroupMemberImpl>
    implements _$$GroupMemberImplCopyWith<$Res> {
  __$$GroupMemberImplCopyWithImpl(
      _$GroupMemberImpl _value, $Res Function(_$GroupMemberImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? characterId = null,
    Object? isMuted = null,
    Object? talkativeness = null,
    Object? triggerProbability = null,
    Object? triggerWords = null,
    Object? insertionOrder = null,
    Object? depthPrompt = freezed,
    Object? depthPromptDepth = null,
    Object? depthPromptRole = null,
    Object? isActive = null,
    Object? displayNameOverride = freezed,
    Object? avatarOverride = freezed,
    Object? extensions = null,
  }) {
    return _then(_$GroupMemberImpl(
      characterId: null == characterId
          ? _value.characterId
          : characterId // ignore: cast_nullable_to_non_nullable
              as String,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      talkativeness: null == talkativeness
          ? _value.talkativeness
          : talkativeness // ignore: cast_nullable_to_non_nullable
              as int,
      triggerProbability: null == triggerProbability
          ? _value.triggerProbability
          : triggerProbability // ignore: cast_nullable_to_non_nullable
              as int,
      triggerWords: null == triggerWords
          ? _value._triggerWords
          : triggerWords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      insertionOrder: null == insertionOrder
          ? _value.insertionOrder
          : insertionOrder // ignore: cast_nullable_to_non_nullable
              as int,
      depthPrompt: freezed == depthPrompt
          ? _value.depthPrompt
          : depthPrompt // ignore: cast_nullable_to_non_nullable
              as String?,
      depthPromptDepth: null == depthPromptDepth
          ? _value.depthPromptDepth
          : depthPromptDepth // ignore: cast_nullable_to_non_nullable
              as int,
      depthPromptRole: null == depthPromptRole
          ? _value.depthPromptRole
          : depthPromptRole // ignore: cast_nullable_to_non_nullable
              as GroupMemberDepthRole,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayNameOverride: freezed == displayNameOverride
          ? _value.displayNameOverride
          : displayNameOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarOverride: freezed == avatarOverride
          ? _value.avatarOverride
          : avatarOverride // ignore: cast_nullable_to_non_nullable
              as String?,
      extensions: null == extensions
          ? _value._extensions
          : extensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMemberImpl implements _GroupMember {
  const _$GroupMemberImpl(
      {required this.characterId,
      this.isMuted = false,
      this.talkativeness = 50,
      this.triggerProbability = 100,
      final List<String> triggerWords = const [],
      this.insertionOrder = 0,
      this.depthPrompt,
      this.depthPromptDepth = 4,
      this.depthPromptRole = GroupMemberDepthRole.system,
      this.isActive = true,
      this.displayNameOverride,
      this.avatarOverride,
      final Map<String, dynamic> extensions = const {}})
      : _triggerWords = triggerWords,
        _extensions = extensions;

  factory _$GroupMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMemberImplFromJson(json);

  @override
  final String characterId;
  @override
  @JsonKey()
  final bool isMuted;
  @override
  @JsonKey()
  final int talkativeness;
// 0-100, affects selection probability
  @override
  @JsonKey()
  final int triggerProbability;
// 0-100
  final List<String> _triggerWords;
// 0-100
  @override
  @JsonKey()
  List<String> get triggerWords {
    if (_triggerWords is EqualUnmodifiableListView) return _triggerWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggerWords);
  }

// Words that trigger this character
  @override
  @JsonKey()
  final int insertionOrder;
// Order in the list
// === New fields for SillyTavern compatibility ===
  /// Depth prompt for this member (inserted at specific depth)
  @override
  final String? depthPrompt;

  /// Depth at which to insert the depth prompt
  @override
  @JsonKey()
  final int depthPromptDepth;

  /// Role for depth prompt (system, user, assistant)
  @override
  @JsonKey()
  final GroupMemberDepthRole depthPromptRole;

  /// Whether this member is currently active in the conversation
  @override
  @JsonKey()
  final bool isActive;

  /// Custom display name override
  @override
  final String? displayNameOverride;

  /// Custom avatar override
  @override
  final String? avatarOverride;

  /// Member-specific extensions data
  final Map<String, dynamic> _extensions;

  /// Member-specific extensions data
  @override
  @JsonKey()
  Map<String, dynamic> get extensions {
    if (_extensions is EqualUnmodifiableMapView) return _extensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extensions);
  }

  @override
  String toString() {
    return 'GroupMember(characterId: $characterId, isMuted: $isMuted, talkativeness: $talkativeness, triggerProbability: $triggerProbability, triggerWords: $triggerWords, insertionOrder: $insertionOrder, depthPrompt: $depthPrompt, depthPromptDepth: $depthPromptDepth, depthPromptRole: $depthPromptRole, isActive: $isActive, displayNameOverride: $displayNameOverride, avatarOverride: $avatarOverride, extensions: $extensions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMemberImpl &&
            (identical(other.characterId, characterId) ||
                other.characterId == characterId) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.talkativeness, talkativeness) ||
                other.talkativeness == talkativeness) &&
            (identical(other.triggerProbability, triggerProbability) ||
                other.triggerProbability == triggerProbability) &&
            const DeepCollectionEquality()
                .equals(other._triggerWords, _triggerWords) &&
            (identical(other.insertionOrder, insertionOrder) ||
                other.insertionOrder == insertionOrder) &&
            (identical(other.depthPrompt, depthPrompt) ||
                other.depthPrompt == depthPrompt) &&
            (identical(other.depthPromptDepth, depthPromptDepth) ||
                other.depthPromptDepth == depthPromptDepth) &&
            (identical(other.depthPromptRole, depthPromptRole) ||
                other.depthPromptRole == depthPromptRole) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayNameOverride, displayNameOverride) ||
                other.displayNameOverride == displayNameOverride) &&
            (identical(other.avatarOverride, avatarOverride) ||
                other.avatarOverride == avatarOverride) &&
            const DeepCollectionEquality()
                .equals(other._extensions, _extensions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      characterId,
      isMuted,
      talkativeness,
      triggerProbability,
      const DeepCollectionEquality().hash(_triggerWords),
      insertionOrder,
      depthPrompt,
      depthPromptDepth,
      depthPromptRole,
      isActive,
      displayNameOverride,
      avatarOverride,
      const DeepCollectionEquality().hash(_extensions));

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMemberImplCopyWith<_$GroupMemberImpl> get copyWith =>
      __$$GroupMemberImplCopyWithImpl<_$GroupMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMemberImplToJson(
      this,
    );
  }
}

abstract class _GroupMember implements GroupMember {
  const factory _GroupMember(
      {required final String characterId,
      final bool isMuted,
      final int talkativeness,
      final int triggerProbability,
      final List<String> triggerWords,
      final int insertionOrder,
      final String? depthPrompt,
      final int depthPromptDepth,
      final GroupMemberDepthRole depthPromptRole,
      final bool isActive,
      final String? displayNameOverride,
      final String? avatarOverride,
      final Map<String, dynamic> extensions}) = _$GroupMemberImpl;

  factory _GroupMember.fromJson(Map<String, dynamic> json) =
      _$GroupMemberImpl.fromJson;

  @override
  String get characterId;
  @override
  bool get isMuted;
  @override
  int get talkativeness; // 0-100, affects selection probability
  @override
  int get triggerProbability; // 0-100
  @override
  List<String> get triggerWords; // Words that trigger this character
  @override
  int get insertionOrder; // Order in the list
// === New fields for SillyTavern compatibility ===
  /// Depth prompt for this member (inserted at specific depth)
  @override
  String? get depthPrompt;

  /// Depth at which to insert the depth prompt
  @override
  int get depthPromptDepth;

  /// Role for depth prompt (system, user, assistant)
  @override
  GroupMemberDepthRole get depthPromptRole;

  /// Whether this member is currently active in the conversation
  @override
  bool get isActive;

  /// Custom display name override
  @override
  String? get displayNameOverride;

  /// Custom avatar override
  @override
  String? get avatarOverride;

  /// Member-specific extensions data
  @override
  Map<String, dynamic> get extensions;

  /// Create a copy of GroupMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMemberImplCopyWith<_$GroupMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupSettings _$GroupSettingsFromJson(Map<String, dynamic> json) {
  return _GroupSettings.fromJson(json);
}

/// @nodoc
mixin _$GroupSettings {
  /// Activation strategy (how to select next speaker)
  GroupActivationStrategy get activationStrategy =>
      throw _privateConstructorUsedError;

  /// Generation mode (how to handle responses)
  GroupGenerationMode get generationMode => throw _privateConstructorUsedError;

  /// Delay between auto-responses in milliseconds
  int get autoModeDelay => throw _privateConstructorUsedError;

  /// Can a character respond to themselves
  bool get allowSelfResponse => throw _privateConstructorUsedError;

  /// Hide disabled/muted members from UI
  bool get hideDisabledMembers => throw _privateConstructorUsedError;

  /// Max responses per turn (0 = unlimited)
  int get maxResponses =>
      throw _privateConstructorUsedError; // === Legacy field mapping ===
  /// Response mode (legacy, maps to activationStrategy)
  @JsonKey(includeFromJson: false, includeToJson: false)
  GroupResponseMode? get responseMode =>
      throw _privateConstructorUsedError; // === New fields for SillyTavern compatibility ===
  /// Whether to auto-select next speaker
  bool get autoSelectSpeaker => throw _privateConstructorUsedError;

  /// Whether to show character names in messages
  bool get showCharacterNames => throw _privateConstructorUsedError;

  /// Whether to allow user to speak as characters
  bool get allowUserAsCharacter => throw _privateConstructorUsedError;

  /// Minimum messages before same character can speak again
  int get minMessagesBetweenSameSpeaker => throw _privateConstructorUsedError;

  /// Whether to use character-specific prompts
  bool get useCharacterPrompts => throw _privateConstructorUsedError;

  /// Whether to merge consecutive messages from same character
  bool get mergeConsecutiveMessages => throw _privateConstructorUsedError;

  /// Group-specific system prompt (prepended to character prompts)
  String get groupSystemPrompt => throw _privateConstructorUsedError;

  /// Whether to include group scenario in prompts
  bool get includeGroupScenario => throw _privateConstructorUsedError;

  /// Whether to include member list in prompts
  bool get includeMemberList => throw _privateConstructorUsedError;

  /// Format for member list
  String get memberListFormat => throw _privateConstructorUsedError;

  /// Whether to favor triggered characters
  bool get favorTriggeredCharacters => throw _privateConstructorUsedError;

  /// Weight multiplier for triggered characters
  double get triggeredCharacterWeight => throw _privateConstructorUsedError;

  /// Serializes this GroupSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupSettingsCopyWith<GroupSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupSettingsCopyWith<$Res> {
  factory $GroupSettingsCopyWith(
          GroupSettings value, $Res Function(GroupSettings) then) =
      _$GroupSettingsCopyWithImpl<$Res, GroupSettings>;
  @useResult
  $Res call(
      {GroupActivationStrategy activationStrategy,
      GroupGenerationMode generationMode,
      int autoModeDelay,
      bool allowSelfResponse,
      bool hideDisabledMembers,
      int maxResponses,
      @JsonKey(includeFromJson: false, includeToJson: false)
      GroupResponseMode? responseMode,
      bool autoSelectSpeaker,
      bool showCharacterNames,
      bool allowUserAsCharacter,
      int minMessagesBetweenSameSpeaker,
      bool useCharacterPrompts,
      bool mergeConsecutiveMessages,
      String groupSystemPrompt,
      bool includeGroupScenario,
      bool includeMemberList,
      String memberListFormat,
      bool favorTriggeredCharacters,
      double triggeredCharacterWeight});
}

/// @nodoc
class _$GroupSettingsCopyWithImpl<$Res, $Val extends GroupSettings>
    implements $GroupSettingsCopyWith<$Res> {
  _$GroupSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activationStrategy = null,
    Object? generationMode = null,
    Object? autoModeDelay = null,
    Object? allowSelfResponse = null,
    Object? hideDisabledMembers = null,
    Object? maxResponses = null,
    Object? responseMode = freezed,
    Object? autoSelectSpeaker = null,
    Object? showCharacterNames = null,
    Object? allowUserAsCharacter = null,
    Object? minMessagesBetweenSameSpeaker = null,
    Object? useCharacterPrompts = null,
    Object? mergeConsecutiveMessages = null,
    Object? groupSystemPrompt = null,
    Object? includeGroupScenario = null,
    Object? includeMemberList = null,
    Object? memberListFormat = null,
    Object? favorTriggeredCharacters = null,
    Object? triggeredCharacterWeight = null,
  }) {
    return _then(_value.copyWith(
      activationStrategy: null == activationStrategy
          ? _value.activationStrategy
          : activationStrategy // ignore: cast_nullable_to_non_nullable
              as GroupActivationStrategy,
      generationMode: null == generationMode
          ? _value.generationMode
          : generationMode // ignore: cast_nullable_to_non_nullable
              as GroupGenerationMode,
      autoModeDelay: null == autoModeDelay
          ? _value.autoModeDelay
          : autoModeDelay // ignore: cast_nullable_to_non_nullable
              as int,
      allowSelfResponse: null == allowSelfResponse
          ? _value.allowSelfResponse
          : allowSelfResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      hideDisabledMembers: null == hideDisabledMembers
          ? _value.hideDisabledMembers
          : hideDisabledMembers // ignore: cast_nullable_to_non_nullable
              as bool,
      maxResponses: null == maxResponses
          ? _value.maxResponses
          : maxResponses // ignore: cast_nullable_to_non_nullable
              as int,
      responseMode: freezed == responseMode
          ? _value.responseMode
          : responseMode // ignore: cast_nullable_to_non_nullable
              as GroupResponseMode?,
      autoSelectSpeaker: null == autoSelectSpeaker
          ? _value.autoSelectSpeaker
          : autoSelectSpeaker // ignore: cast_nullable_to_non_nullable
              as bool,
      showCharacterNames: null == showCharacterNames
          ? _value.showCharacterNames
          : showCharacterNames // ignore: cast_nullable_to_non_nullable
              as bool,
      allowUserAsCharacter: null == allowUserAsCharacter
          ? _value.allowUserAsCharacter
          : allowUserAsCharacter // ignore: cast_nullable_to_non_nullable
              as bool,
      minMessagesBetweenSameSpeaker: null == minMessagesBetweenSameSpeaker
          ? _value.minMessagesBetweenSameSpeaker
          : minMessagesBetweenSameSpeaker // ignore: cast_nullable_to_non_nullable
              as int,
      useCharacterPrompts: null == useCharacterPrompts
          ? _value.useCharacterPrompts
          : useCharacterPrompts // ignore: cast_nullable_to_non_nullable
              as bool,
      mergeConsecutiveMessages: null == mergeConsecutiveMessages
          ? _value.mergeConsecutiveMessages
          : mergeConsecutiveMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      groupSystemPrompt: null == groupSystemPrompt
          ? _value.groupSystemPrompt
          : groupSystemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      includeGroupScenario: null == includeGroupScenario
          ? _value.includeGroupScenario
          : includeGroupScenario // ignore: cast_nullable_to_non_nullable
              as bool,
      includeMemberList: null == includeMemberList
          ? _value.includeMemberList
          : includeMemberList // ignore: cast_nullable_to_non_nullable
              as bool,
      memberListFormat: null == memberListFormat
          ? _value.memberListFormat
          : memberListFormat // ignore: cast_nullable_to_non_nullable
              as String,
      favorTriggeredCharacters: null == favorTriggeredCharacters
          ? _value.favorTriggeredCharacters
          : favorTriggeredCharacters // ignore: cast_nullable_to_non_nullable
              as bool,
      triggeredCharacterWeight: null == triggeredCharacterWeight
          ? _value.triggeredCharacterWeight
          : triggeredCharacterWeight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupSettingsImplCopyWith<$Res>
    implements $GroupSettingsCopyWith<$Res> {
  factory _$$GroupSettingsImplCopyWith(
          _$GroupSettingsImpl value, $Res Function(_$GroupSettingsImpl) then) =
      __$$GroupSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {GroupActivationStrategy activationStrategy,
      GroupGenerationMode generationMode,
      int autoModeDelay,
      bool allowSelfResponse,
      bool hideDisabledMembers,
      int maxResponses,
      @JsonKey(includeFromJson: false, includeToJson: false)
      GroupResponseMode? responseMode,
      bool autoSelectSpeaker,
      bool showCharacterNames,
      bool allowUserAsCharacter,
      int minMessagesBetweenSameSpeaker,
      bool useCharacterPrompts,
      bool mergeConsecutiveMessages,
      String groupSystemPrompt,
      bool includeGroupScenario,
      bool includeMemberList,
      String memberListFormat,
      bool favorTriggeredCharacters,
      double triggeredCharacterWeight});
}

/// @nodoc
class __$$GroupSettingsImplCopyWithImpl<$Res>
    extends _$GroupSettingsCopyWithImpl<$Res, _$GroupSettingsImpl>
    implements _$$GroupSettingsImplCopyWith<$Res> {
  __$$GroupSettingsImplCopyWithImpl(
      _$GroupSettingsImpl _value, $Res Function(_$GroupSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activationStrategy = null,
    Object? generationMode = null,
    Object? autoModeDelay = null,
    Object? allowSelfResponse = null,
    Object? hideDisabledMembers = null,
    Object? maxResponses = null,
    Object? responseMode = freezed,
    Object? autoSelectSpeaker = null,
    Object? showCharacterNames = null,
    Object? allowUserAsCharacter = null,
    Object? minMessagesBetweenSameSpeaker = null,
    Object? useCharacterPrompts = null,
    Object? mergeConsecutiveMessages = null,
    Object? groupSystemPrompt = null,
    Object? includeGroupScenario = null,
    Object? includeMemberList = null,
    Object? memberListFormat = null,
    Object? favorTriggeredCharacters = null,
    Object? triggeredCharacterWeight = null,
  }) {
    return _then(_$GroupSettingsImpl(
      activationStrategy: null == activationStrategy
          ? _value.activationStrategy
          : activationStrategy // ignore: cast_nullable_to_non_nullable
              as GroupActivationStrategy,
      generationMode: null == generationMode
          ? _value.generationMode
          : generationMode // ignore: cast_nullable_to_non_nullable
              as GroupGenerationMode,
      autoModeDelay: null == autoModeDelay
          ? _value.autoModeDelay
          : autoModeDelay // ignore: cast_nullable_to_non_nullable
              as int,
      allowSelfResponse: null == allowSelfResponse
          ? _value.allowSelfResponse
          : allowSelfResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      hideDisabledMembers: null == hideDisabledMembers
          ? _value.hideDisabledMembers
          : hideDisabledMembers // ignore: cast_nullable_to_non_nullable
              as bool,
      maxResponses: null == maxResponses
          ? _value.maxResponses
          : maxResponses // ignore: cast_nullable_to_non_nullable
              as int,
      responseMode: freezed == responseMode
          ? _value.responseMode
          : responseMode // ignore: cast_nullable_to_non_nullable
              as GroupResponseMode?,
      autoSelectSpeaker: null == autoSelectSpeaker
          ? _value.autoSelectSpeaker
          : autoSelectSpeaker // ignore: cast_nullable_to_non_nullable
              as bool,
      showCharacterNames: null == showCharacterNames
          ? _value.showCharacterNames
          : showCharacterNames // ignore: cast_nullable_to_non_nullable
              as bool,
      allowUserAsCharacter: null == allowUserAsCharacter
          ? _value.allowUserAsCharacter
          : allowUserAsCharacter // ignore: cast_nullable_to_non_nullable
              as bool,
      minMessagesBetweenSameSpeaker: null == minMessagesBetweenSameSpeaker
          ? _value.minMessagesBetweenSameSpeaker
          : minMessagesBetweenSameSpeaker // ignore: cast_nullable_to_non_nullable
              as int,
      useCharacterPrompts: null == useCharacterPrompts
          ? _value.useCharacterPrompts
          : useCharacterPrompts // ignore: cast_nullable_to_non_nullable
              as bool,
      mergeConsecutiveMessages: null == mergeConsecutiveMessages
          ? _value.mergeConsecutiveMessages
          : mergeConsecutiveMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      groupSystemPrompt: null == groupSystemPrompt
          ? _value.groupSystemPrompt
          : groupSystemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      includeGroupScenario: null == includeGroupScenario
          ? _value.includeGroupScenario
          : includeGroupScenario // ignore: cast_nullable_to_non_nullable
              as bool,
      includeMemberList: null == includeMemberList
          ? _value.includeMemberList
          : includeMemberList // ignore: cast_nullable_to_non_nullable
              as bool,
      memberListFormat: null == memberListFormat
          ? _value.memberListFormat
          : memberListFormat // ignore: cast_nullable_to_non_nullable
              as String,
      favorTriggeredCharacters: null == favorTriggeredCharacters
          ? _value.favorTriggeredCharacters
          : favorTriggeredCharacters // ignore: cast_nullable_to_non_nullable
              as bool,
      triggeredCharacterWeight: null == triggeredCharacterWeight
          ? _value.triggeredCharacterWeight
          : triggeredCharacterWeight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupSettingsImpl implements _GroupSettings {
  const _$GroupSettingsImpl(
      {this.activationStrategy = GroupActivationStrategy.natural,
      this.generationMode = GroupGenerationMode.swap,
      this.autoModeDelay = 5000,
      this.allowSelfResponse = false,
      this.hideDisabledMembers = true,
      this.maxResponses = 1,
      @JsonKey(includeFromJson: false, includeToJson: false) this.responseMode,
      this.autoSelectSpeaker = true,
      this.showCharacterNames = true,
      this.allowUserAsCharacter = true,
      this.minMessagesBetweenSameSpeaker = 0,
      this.useCharacterPrompts = true,
      this.mergeConsecutiveMessages = false,
      this.groupSystemPrompt = '',
      this.includeGroupScenario = true,
      this.includeMemberList = true,
      this.memberListFormat = '{{char}} is present in this conversation.',
      this.favorTriggeredCharacters = true,
      this.triggeredCharacterWeight = 2.0});

  factory _$GroupSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupSettingsImplFromJson(json);

  /// Activation strategy (how to select next speaker)
  @override
  @JsonKey()
  final GroupActivationStrategy activationStrategy;

  /// Generation mode (how to handle responses)
  @override
  @JsonKey()
  final GroupGenerationMode generationMode;

  /// Delay between auto-responses in milliseconds
  @override
  @JsonKey()
  final int autoModeDelay;

  /// Can a character respond to themselves
  @override
  @JsonKey()
  final bool allowSelfResponse;

  /// Hide disabled/muted members from UI
  @override
  @JsonKey()
  final bool hideDisabledMembers;

  /// Max responses per turn (0 = unlimited)
  @override
  @JsonKey()
  final int maxResponses;
// === Legacy field mapping ===
  /// Response mode (legacy, maps to activationStrategy)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final GroupResponseMode? responseMode;
// === New fields for SillyTavern compatibility ===
  /// Whether to auto-select next speaker
  @override
  @JsonKey()
  final bool autoSelectSpeaker;

  /// Whether to show character names in messages
  @override
  @JsonKey()
  final bool showCharacterNames;

  /// Whether to allow user to speak as characters
  @override
  @JsonKey()
  final bool allowUserAsCharacter;

  /// Minimum messages before same character can speak again
  @override
  @JsonKey()
  final int minMessagesBetweenSameSpeaker;

  /// Whether to use character-specific prompts
  @override
  @JsonKey()
  final bool useCharacterPrompts;

  /// Whether to merge consecutive messages from same character
  @override
  @JsonKey()
  final bool mergeConsecutiveMessages;

  /// Group-specific system prompt (prepended to character prompts)
  @override
  @JsonKey()
  final String groupSystemPrompt;

  /// Whether to include group scenario in prompts
  @override
  @JsonKey()
  final bool includeGroupScenario;

  /// Whether to include member list in prompts
  @override
  @JsonKey()
  final bool includeMemberList;

  /// Format for member list
  @override
  @JsonKey()
  final String memberListFormat;

  /// Whether to favor triggered characters
  @override
  @JsonKey()
  final bool favorTriggeredCharacters;

  /// Weight multiplier for triggered characters
  @override
  @JsonKey()
  final double triggeredCharacterWeight;

  @override
  String toString() {
    return 'GroupSettings(activationStrategy: $activationStrategy, generationMode: $generationMode, autoModeDelay: $autoModeDelay, allowSelfResponse: $allowSelfResponse, hideDisabledMembers: $hideDisabledMembers, maxResponses: $maxResponses, responseMode: $responseMode, autoSelectSpeaker: $autoSelectSpeaker, showCharacterNames: $showCharacterNames, allowUserAsCharacter: $allowUserAsCharacter, minMessagesBetweenSameSpeaker: $minMessagesBetweenSameSpeaker, useCharacterPrompts: $useCharacterPrompts, mergeConsecutiveMessages: $mergeConsecutiveMessages, groupSystemPrompt: $groupSystemPrompt, includeGroupScenario: $includeGroupScenario, includeMemberList: $includeMemberList, memberListFormat: $memberListFormat, favorTriggeredCharacters: $favorTriggeredCharacters, triggeredCharacterWeight: $triggeredCharacterWeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupSettingsImpl &&
            (identical(other.activationStrategy, activationStrategy) ||
                other.activationStrategy == activationStrategy) &&
            (identical(other.generationMode, generationMode) ||
                other.generationMode == generationMode) &&
            (identical(other.autoModeDelay, autoModeDelay) ||
                other.autoModeDelay == autoModeDelay) &&
            (identical(other.allowSelfResponse, allowSelfResponse) ||
                other.allowSelfResponse == allowSelfResponse) &&
            (identical(other.hideDisabledMembers, hideDisabledMembers) ||
                other.hideDisabledMembers == hideDisabledMembers) &&
            (identical(other.maxResponses, maxResponses) ||
                other.maxResponses == maxResponses) &&
            (identical(other.responseMode, responseMode) ||
                other.responseMode == responseMode) &&
            (identical(other.autoSelectSpeaker, autoSelectSpeaker) ||
                other.autoSelectSpeaker == autoSelectSpeaker) &&
            (identical(other.showCharacterNames, showCharacterNames) ||
                other.showCharacterNames == showCharacterNames) &&
            (identical(other.allowUserAsCharacter, allowUserAsCharacter) ||
                other.allowUserAsCharacter == allowUserAsCharacter) &&
            (identical(other.minMessagesBetweenSameSpeaker,
                    minMessagesBetweenSameSpeaker) ||
                other.minMessagesBetweenSameSpeaker ==
                    minMessagesBetweenSameSpeaker) &&
            (identical(other.useCharacterPrompts, useCharacterPrompts) ||
                other.useCharacterPrompts == useCharacterPrompts) &&
            (identical(
                    other.mergeConsecutiveMessages, mergeConsecutiveMessages) ||
                other.mergeConsecutiveMessages == mergeConsecutiveMessages) &&
            (identical(other.groupSystemPrompt, groupSystemPrompt) ||
                other.groupSystemPrompt == groupSystemPrompt) &&
            (identical(other.includeGroupScenario, includeGroupScenario) ||
                other.includeGroupScenario == includeGroupScenario) &&
            (identical(other.includeMemberList, includeMemberList) ||
                other.includeMemberList == includeMemberList) &&
            (identical(other.memberListFormat, memberListFormat) ||
                other.memberListFormat == memberListFormat) &&
            (identical(
                    other.favorTriggeredCharacters, favorTriggeredCharacters) ||
                other.favorTriggeredCharacters == favorTriggeredCharacters) &&
            (identical(
                    other.triggeredCharacterWeight, triggeredCharacterWeight) ||
                other.triggeredCharacterWeight == triggeredCharacterWeight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        activationStrategy,
        generationMode,
        autoModeDelay,
        allowSelfResponse,
        hideDisabledMembers,
        maxResponses,
        responseMode,
        autoSelectSpeaker,
        showCharacterNames,
        allowUserAsCharacter,
        minMessagesBetweenSameSpeaker,
        useCharacterPrompts,
        mergeConsecutiveMessages,
        groupSystemPrompt,
        includeGroupScenario,
        includeMemberList,
        memberListFormat,
        favorTriggeredCharacters,
        triggeredCharacterWeight
      ]);

  /// Create a copy of GroupSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupSettingsImplCopyWith<_$GroupSettingsImpl> get copyWith =>
      __$$GroupSettingsImplCopyWithImpl<_$GroupSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupSettingsImplToJson(
      this,
    );
  }
}

abstract class _GroupSettings implements GroupSettings {
  const factory _GroupSettings(
      {final GroupActivationStrategy activationStrategy,
      final GroupGenerationMode generationMode,
      final int autoModeDelay,
      final bool allowSelfResponse,
      final bool hideDisabledMembers,
      final int maxResponses,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final GroupResponseMode? responseMode,
      final bool autoSelectSpeaker,
      final bool showCharacterNames,
      final bool allowUserAsCharacter,
      final int minMessagesBetweenSameSpeaker,
      final bool useCharacterPrompts,
      final bool mergeConsecutiveMessages,
      final String groupSystemPrompt,
      final bool includeGroupScenario,
      final bool includeMemberList,
      final String memberListFormat,
      final bool favorTriggeredCharacters,
      final double triggeredCharacterWeight}) = _$GroupSettingsImpl;

  factory _GroupSettings.fromJson(Map<String, dynamic> json) =
      _$GroupSettingsImpl.fromJson;

  /// Activation strategy (how to select next speaker)
  @override
  GroupActivationStrategy get activationStrategy;

  /// Generation mode (how to handle responses)
  @override
  GroupGenerationMode get generationMode;

  /// Delay between auto-responses in milliseconds
  @override
  int get autoModeDelay;

  /// Can a character respond to themselves
  @override
  bool get allowSelfResponse;

  /// Hide disabled/muted members from UI
  @override
  bool get hideDisabledMembers;

  /// Max responses per turn (0 = unlimited)
  @override
  int get maxResponses; // === Legacy field mapping ===
  /// Response mode (legacy, maps to activationStrategy)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  GroupResponseMode?
      get responseMode; // === New fields for SillyTavern compatibility ===
  /// Whether to auto-select next speaker
  @override
  bool get autoSelectSpeaker;

  /// Whether to show character names in messages
  @override
  bool get showCharacterNames;

  /// Whether to allow user to speak as characters
  @override
  bool get allowUserAsCharacter;

  /// Minimum messages before same character can speak again
  @override
  int get minMessagesBetweenSameSpeaker;

  /// Whether to use character-specific prompts
  @override
  bool get useCharacterPrompts;

  /// Whether to merge consecutive messages from same character
  @override
  bool get mergeConsecutiveMessages;

  /// Group-specific system prompt (prepended to character prompts)
  @override
  String get groupSystemPrompt;

  /// Whether to include group scenario in prompts
  @override
  bool get includeGroupScenario;

  /// Whether to include member list in prompts
  @override
  bool get includeMemberList;

  /// Format for member list
  @override
  String get memberListFormat;

  /// Whether to favor triggered characters
  @override
  bool get favorTriggeredCharacters;

  /// Weight multiplier for triggered characters
  @override
  double get triggeredCharacterWeight;

  /// Create a copy of GroupSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupSettingsImplCopyWith<_$GroupSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupChatInfo _$GroupChatInfoFromJson(Map<String, dynamic> json) {
  return _GroupChatInfo.fromJson(json);
}

/// @nodoc
mixin _$GroupChatInfo {
  String get chatId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastMessageAt => throw _privateConstructorUsedError;
  int get messageCount => throw _privateConstructorUsedError;
  String? get previewText => throw _privateConstructorUsedError;

  /// Serializes this GroupChatInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupChatInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupChatInfoCopyWith<GroupChatInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupChatInfoCopyWith<$Res> {
  factory $GroupChatInfoCopyWith(
          GroupChatInfo value, $Res Function(GroupChatInfo) then) =
      _$GroupChatInfoCopyWithImpl<$Res, GroupChatInfo>;
  @useResult
  $Res call(
      {String chatId,
      String name,
      DateTime createdAt,
      DateTime lastMessageAt,
      int messageCount,
      String? previewText});
}

/// @nodoc
class _$GroupChatInfoCopyWithImpl<$Res, $Val extends GroupChatInfo>
    implements $GroupChatInfoCopyWith<$Res> {
  _$GroupChatInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupChatInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? lastMessageAt = null,
    Object? messageCount = null,
    Object? previewText = freezed,
  }) {
    return _then(_value.copyWith(
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessageAt: null == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      previewText: freezed == previewText
          ? _value.previewText
          : previewText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupChatInfoImplCopyWith<$Res>
    implements $GroupChatInfoCopyWith<$Res> {
  factory _$$GroupChatInfoImplCopyWith(
          _$GroupChatInfoImpl value, $Res Function(_$GroupChatInfoImpl) then) =
      __$$GroupChatInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String chatId,
      String name,
      DateTime createdAt,
      DateTime lastMessageAt,
      int messageCount,
      String? previewText});
}

/// @nodoc
class __$$GroupChatInfoImplCopyWithImpl<$Res>
    extends _$GroupChatInfoCopyWithImpl<$Res, _$GroupChatInfoImpl>
    implements _$$GroupChatInfoImplCopyWith<$Res> {
  __$$GroupChatInfoImplCopyWithImpl(
      _$GroupChatInfoImpl _value, $Res Function(_$GroupChatInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupChatInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? lastMessageAt = null,
    Object? messageCount = null,
    Object? previewText = freezed,
  }) {
    return _then(_$GroupChatInfoImpl(
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessageAt: null == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messageCount: null == messageCount
          ? _value.messageCount
          : messageCount // ignore: cast_nullable_to_non_nullable
              as int,
      previewText: freezed == previewText
          ? _value.previewText
          : previewText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupChatInfoImpl implements _GroupChatInfo {
  const _$GroupChatInfoImpl(
      {required this.chatId,
      required this.name,
      required this.createdAt,
      required this.lastMessageAt,
      this.messageCount = 0,
      this.previewText});

  factory _$GroupChatInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupChatInfoImplFromJson(json);

  @override
  final String chatId;
  @override
  final String name;
  @override
  final DateTime createdAt;
  @override
  final DateTime lastMessageAt;
  @override
  @JsonKey()
  final int messageCount;
  @override
  final String? previewText;

  @override
  String toString() {
    return 'GroupChatInfo(chatId: $chatId, name: $name, createdAt: $createdAt, lastMessageAt: $lastMessageAt, messageCount: $messageCount, previewText: $previewText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatInfoImpl &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.previewText, previewText) ||
                other.previewText == previewText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, chatId, name, createdAt,
      lastMessageAt, messageCount, previewText);

  /// Create a copy of GroupChatInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupChatInfoImplCopyWith<_$GroupChatInfoImpl> get copyWith =>
      __$$GroupChatInfoImplCopyWithImpl<_$GroupChatInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupChatInfoImplToJson(
      this,
    );
  }
}

abstract class _GroupChatInfo implements GroupChatInfo {
  const factory _GroupChatInfo(
      {required final String chatId,
      required final String name,
      required final DateTime createdAt,
      required final DateTime lastMessageAt,
      final int messageCount,
      final String? previewText}) = _$GroupChatInfoImpl;

  factory _GroupChatInfo.fromJson(Map<String, dynamic> json) =
      _$GroupChatInfoImpl.fromJson;

  @override
  String get chatId;
  @override
  String get name;
  @override
  DateTime get createdAt;
  @override
  DateTime get lastMessageAt;
  @override
  int get messageCount;
  @override
  String? get previewText;

  /// Create a copy of GroupChatInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupChatInfoImplCopyWith<_$GroupChatInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupExport _$GroupExportFromJson(Map<String, dynamic> json) {
  return _GroupExport.fromJson(json);
}

/// @nodoc
mixin _$GroupExport {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get members =>
      throw _privateConstructorUsedError; // Character IDs/names
  @JsonKey(name: 'activation_strategy')
  int get activationStrategy => throw _privateConstructorUsedError;
  @JsonKey(name: 'generation_mode')
  int get generationMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'disabled_members')
  List<String> get disabledMembers => throw _privateConstructorUsedError;
  @JsonKey(name: 'chat_metadata')
  Map<String, dynamic> get chatMetadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'past_metadata')
  Map<String, dynamic> get pastMetadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'fav')
  bool get fav => throw _privateConstructorUsedError;
  @JsonKey(name: 'chat_id')
  String? get chatId => throw _privateConstructorUsedError;
  @JsonKey(name: 'chats')
  List<String> get chats => throw _privateConstructorUsedError;

  /// Serializes this GroupExport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupExportCopyWith<GroupExport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupExportCopyWith<$Res> {
  factory $GroupExportCopyWith(
          GroupExport value, $Res Function(GroupExport) then) =
      _$GroupExportCopyWithImpl<$Res, GroupExport>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<String> members,
      @JsonKey(name: 'activation_strategy') int activationStrategy,
      @JsonKey(name: 'generation_mode') int generationMode,
      @JsonKey(name: 'disabled_members') List<String> disabledMembers,
      @JsonKey(name: 'chat_metadata') Map<String, dynamic> chatMetadata,
      @JsonKey(name: 'past_metadata') Map<String, dynamic> pastMetadata,
      @JsonKey(name: 'fav') bool fav,
      @JsonKey(name: 'chat_id') String? chatId,
      @JsonKey(name: 'chats') List<String> chats});
}

/// @nodoc
class _$GroupExportCopyWithImpl<$Res, $Val extends GroupExport>
    implements $GroupExportCopyWith<$Res> {
  _$GroupExportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? members = null,
    Object? activationStrategy = null,
    Object? generationMode = null,
    Object? disabledMembers = null,
    Object? chatMetadata = null,
    Object? pastMetadata = null,
    Object? fav = null,
    Object? chatId = freezed,
    Object? chats = null,
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
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activationStrategy: null == activationStrategy
          ? _value.activationStrategy
          : activationStrategy // ignore: cast_nullable_to_non_nullable
              as int,
      generationMode: null == generationMode
          ? _value.generationMode
          : generationMode // ignore: cast_nullable_to_non_nullable
              as int,
      disabledMembers: null == disabledMembers
          ? _value.disabledMembers
          : disabledMembers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      chatMetadata: null == chatMetadata
          ? _value.chatMetadata
          : chatMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      pastMetadata: null == pastMetadata
          ? _value.pastMetadata
          : pastMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      fav: null == fav
          ? _value.fav
          : fav // ignore: cast_nullable_to_non_nullable
              as bool,
      chatId: freezed == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String?,
      chats: null == chats
          ? _value.chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupExportImplCopyWith<$Res>
    implements $GroupExportCopyWith<$Res> {
  factory _$$GroupExportImplCopyWith(
          _$GroupExportImpl value, $Res Function(_$GroupExportImpl) then) =
      __$$GroupExportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      List<String> members,
      @JsonKey(name: 'activation_strategy') int activationStrategy,
      @JsonKey(name: 'generation_mode') int generationMode,
      @JsonKey(name: 'disabled_members') List<String> disabledMembers,
      @JsonKey(name: 'chat_metadata') Map<String, dynamic> chatMetadata,
      @JsonKey(name: 'past_metadata') Map<String, dynamic> pastMetadata,
      @JsonKey(name: 'fav') bool fav,
      @JsonKey(name: 'chat_id') String? chatId,
      @JsonKey(name: 'chats') List<String> chats});
}

/// @nodoc
class __$$GroupExportImplCopyWithImpl<$Res>
    extends _$GroupExportCopyWithImpl<$Res, _$GroupExportImpl>
    implements _$$GroupExportImplCopyWith<$Res> {
  __$$GroupExportImplCopyWithImpl(
      _$GroupExportImpl _value, $Res Function(_$GroupExportImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? members = null,
    Object? activationStrategy = null,
    Object? generationMode = null,
    Object? disabledMembers = null,
    Object? chatMetadata = null,
    Object? pastMetadata = null,
    Object? fav = null,
    Object? chatId = freezed,
    Object? chats = null,
  }) {
    return _then(_$GroupExportImpl(
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
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activationStrategy: null == activationStrategy
          ? _value.activationStrategy
          : activationStrategy // ignore: cast_nullable_to_non_nullable
              as int,
      generationMode: null == generationMode
          ? _value.generationMode
          : generationMode // ignore: cast_nullable_to_non_nullable
              as int,
      disabledMembers: null == disabledMembers
          ? _value._disabledMembers
          : disabledMembers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      chatMetadata: null == chatMetadata
          ? _value._chatMetadata
          : chatMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      pastMetadata: null == pastMetadata
          ? _value._pastMetadata
          : pastMetadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      fav: null == fav
          ? _value.fav
          : fav // ignore: cast_nullable_to_non_nullable
              as bool,
      chatId: freezed == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String?,
      chats: null == chats
          ? _value._chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupExportImpl implements _GroupExport {
  const _$GroupExportImpl(
      {required this.id,
      required this.name,
      this.description,
      final List<String> members = const [],
      @JsonKey(name: 'activation_strategy') this.activationStrategy = 0,
      @JsonKey(name: 'generation_mode') this.generationMode = 0,
      @JsonKey(name: 'disabled_members')
      final List<String> disabledMembers = const [],
      @JsonKey(name: 'chat_metadata')
      final Map<String, dynamic> chatMetadata = const {},
      @JsonKey(name: 'past_metadata')
      final Map<String, dynamic> pastMetadata = const {},
      @JsonKey(name: 'fav') this.fav = false,
      @JsonKey(name: 'chat_id') this.chatId,
      @JsonKey(name: 'chats') final List<String> chats = const []})
      : _members = members,
        _disabledMembers = disabledMembers,
        _chatMetadata = chatMetadata,
        _pastMetadata = pastMetadata,
        _chats = chats;

  factory _$GroupExportImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupExportImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  final List<String> _members;
  @override
  @JsonKey()
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

// Character IDs/names
  @override
  @JsonKey(name: 'activation_strategy')
  final int activationStrategy;
  @override
  @JsonKey(name: 'generation_mode')
  final int generationMode;
  final List<String> _disabledMembers;
  @override
  @JsonKey(name: 'disabled_members')
  List<String> get disabledMembers {
    if (_disabledMembers is EqualUnmodifiableListView) return _disabledMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disabledMembers);
  }

  final Map<String, dynamic> _chatMetadata;
  @override
  @JsonKey(name: 'chat_metadata')
  Map<String, dynamic> get chatMetadata {
    if (_chatMetadata is EqualUnmodifiableMapView) return _chatMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_chatMetadata);
  }

  final Map<String, dynamic> _pastMetadata;
  @override
  @JsonKey(name: 'past_metadata')
  Map<String, dynamic> get pastMetadata {
    if (_pastMetadata is EqualUnmodifiableMapView) return _pastMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pastMetadata);
  }

  @override
  @JsonKey(name: 'fav')
  final bool fav;
  @override
  @JsonKey(name: 'chat_id')
  final String? chatId;
  final List<String> _chats;
  @override
  @JsonKey(name: 'chats')
  List<String> get chats {
    if (_chats is EqualUnmodifiableListView) return _chats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chats);
  }

  @override
  String toString() {
    return 'GroupExport(id: $id, name: $name, description: $description, members: $members, activationStrategy: $activationStrategy, generationMode: $generationMode, disabledMembers: $disabledMembers, chatMetadata: $chatMetadata, pastMetadata: $pastMetadata, fav: $fav, chatId: $chatId, chats: $chats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupExportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.activationStrategy, activationStrategy) ||
                other.activationStrategy == activationStrategy) &&
            (identical(other.generationMode, generationMode) ||
                other.generationMode == generationMode) &&
            const DeepCollectionEquality()
                .equals(other._disabledMembers, _disabledMembers) &&
            const DeepCollectionEquality()
                .equals(other._chatMetadata, _chatMetadata) &&
            const DeepCollectionEquality()
                .equals(other._pastMetadata, _pastMetadata) &&
            (identical(other.fav, fav) || other.fav == fav) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            const DeepCollectionEquality().equals(other._chats, _chats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_members),
      activationStrategy,
      generationMode,
      const DeepCollectionEquality().hash(_disabledMembers),
      const DeepCollectionEquality().hash(_chatMetadata),
      const DeepCollectionEquality().hash(_pastMetadata),
      fav,
      chatId,
      const DeepCollectionEquality().hash(_chats));

  /// Create a copy of GroupExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupExportImplCopyWith<_$GroupExportImpl> get copyWith =>
      __$$GroupExportImplCopyWithImpl<_$GroupExportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupExportImplToJson(
      this,
    );
  }
}

abstract class _GroupExport implements GroupExport {
  const factory _GroupExport(
      {required final String id,
      required final String name,
      final String? description,
      final List<String> members,
      @JsonKey(name: 'activation_strategy') final int activationStrategy,
      @JsonKey(name: 'generation_mode') final int generationMode,
      @JsonKey(name: 'disabled_members') final List<String> disabledMembers,
      @JsonKey(name: 'chat_metadata') final Map<String, dynamic> chatMetadata,
      @JsonKey(name: 'past_metadata') final Map<String, dynamic> pastMetadata,
      @JsonKey(name: 'fav') final bool fav,
      @JsonKey(name: 'chat_id') final String? chatId,
      @JsonKey(name: 'chats') final List<String> chats}) = _$GroupExportImpl;

  factory _GroupExport.fromJson(Map<String, dynamic> json) =
      _$GroupExportImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  List<String> get members; // Character IDs/names
  @override
  @JsonKey(name: 'activation_strategy')
  int get activationStrategy;
  @override
  @JsonKey(name: 'generation_mode')
  int get generationMode;
  @override
  @JsonKey(name: 'disabled_members')
  List<String> get disabledMembers;
  @override
  @JsonKey(name: 'chat_metadata')
  Map<String, dynamic> get chatMetadata;
  @override
  @JsonKey(name: 'past_metadata')
  Map<String, dynamic> get pastMetadata;
  @override
  @JsonKey(name: 'fav')
  bool get fav;
  @override
  @JsonKey(name: 'chat_id')
  String? get chatId;
  @override
  @JsonKey(name: 'chats')
  List<String> get chats;

  /// Create a copy of GroupExport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupExportImplCopyWith<_$GroupExportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
