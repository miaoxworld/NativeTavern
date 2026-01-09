// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get chatId => throw _privateConstructorUsedError;
  MessageRole get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;
  bool get isHidden => throw _privateConstructorUsedError;
  MessageMetadata? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      String chatId,
      MessageRole role,
      String content,
      DateTime timestamp,
      bool isEdited,
      bool isHidden,
      MessageMetadata? metadata});

  $MessageMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? isEdited = null,
    Object? isHidden = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isHidden: null == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as MessageMetadata?,
    ) as $Val);
  }

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageMetadataCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $MessageMetadataCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String chatId,
      MessageRole role,
      String content,
      DateTime timestamp,
      bool isEdited,
      bool isHidden,
      MessageMetadata? metadata});

  @override
  $MessageMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? isEdited = null,
    Object? isHidden = null,
    Object? metadata = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MessageRole,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
      isHidden: null == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as MessageMetadata?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.chatId,
      required this.role,
      required this.content,
      required this.timestamp,
      this.isEdited = false,
      this.isHidden = false,
      this.metadata});

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  final String chatId;
  @override
  final MessageRole role;
  @override
  final String content;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isEdited;
  @override
  @JsonKey()
  final bool isHidden;
  @override
  final MessageMetadata? metadata;

  @override
  String toString() {
    return 'Message(id: $id, chatId: $chatId, role: $role, content: $content, timestamp: $timestamp, isEdited: $isEdited, isHidden: $isHidden, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, chatId, role, content,
      timestamp, isEdited, isHidden, metadata);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final String id,
      required final String chatId,
      required final MessageRole role,
      required final String content,
      required final DateTime timestamp,
      final bool isEdited,
      final bool isHidden,
      final MessageMetadata? metadata}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  String get chatId;
  @override
  MessageRole get role;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  bool get isEdited;
  @override
  bool get isHidden;
  @override
  MessageMetadata? get metadata;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageMetadata _$MessageMetadataFromJson(Map<String, dynamic> json) {
  return _MessageMetadata.fromJson(json);
}

/// @nodoc
mixin _$MessageMetadata {
// Token counts
  int? get promptTokens => throw _privateConstructorUsedError;
  int? get completionTokens => throw _privateConstructorUsedError;
  int? get totalTokens => throw _privateConstructorUsedError; // Generation info
  String? get model => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  int? get maxTokens =>
      throw _privateConstructorUsedError; // Swipe support (multiple regenerations)
  List<String> get swipes => throw _privateConstructorUsedError;
  int get currentSwipeIndex =>
      throw _privateConstructorUsedError; // Reasoning/thinking content (for models like Claude/o1)
  String? get reasoning => throw _privateConstructorUsedError; // Extra data
  Map<String, dynamic> get extra => throw _privateConstructorUsedError;

  /// Serializes this MessageMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageMetadataCopyWith<MessageMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageMetadataCopyWith<$Res> {
  factory $MessageMetadataCopyWith(
          MessageMetadata value, $Res Function(MessageMetadata) then) =
      _$MessageMetadataCopyWithImpl<$Res, MessageMetadata>;
  @useResult
  $Res call(
      {int? promptTokens,
      int? completionTokens,
      int? totalTokens,
      String? model,
      double? temperature,
      int? maxTokens,
      List<String> swipes,
      int currentSwipeIndex,
      String? reasoning,
      Map<String, dynamic> extra});
}

/// @nodoc
class _$MessageMetadataCopyWithImpl<$Res, $Val extends MessageMetadata>
    implements $MessageMetadataCopyWith<$Res> {
  _$MessageMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promptTokens = freezed,
    Object? completionTokens = freezed,
    Object? totalTokens = freezed,
    Object? model = freezed,
    Object? temperature = freezed,
    Object? maxTokens = freezed,
    Object? swipes = null,
    Object? currentSwipeIndex = null,
    Object? reasoning = freezed,
    Object? extra = null,
  }) {
    return _then(_value.copyWith(
      promptTokens: freezed == promptTokens
          ? _value.promptTokens
          : promptTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      completionTokens: freezed == completionTokens
          ? _value.completionTokens
          : completionTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTokens: freezed == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTokens: freezed == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      swipes: null == swipes
          ? _value.swipes
          : swipes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentSwipeIndex: null == currentSwipeIndex
          ? _value.currentSwipeIndex
          : currentSwipeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      extra: null == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageMetadataImplCopyWith<$Res>
    implements $MessageMetadataCopyWith<$Res> {
  factory _$$MessageMetadataImplCopyWith(_$MessageMetadataImpl value,
          $Res Function(_$MessageMetadataImpl) then) =
      __$$MessageMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? promptTokens,
      int? completionTokens,
      int? totalTokens,
      String? model,
      double? temperature,
      int? maxTokens,
      List<String> swipes,
      int currentSwipeIndex,
      String? reasoning,
      Map<String, dynamic> extra});
}

/// @nodoc
class __$$MessageMetadataImplCopyWithImpl<$Res>
    extends _$MessageMetadataCopyWithImpl<$Res, _$MessageMetadataImpl>
    implements _$$MessageMetadataImplCopyWith<$Res> {
  __$$MessageMetadataImplCopyWithImpl(
      _$MessageMetadataImpl _value, $Res Function(_$MessageMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? promptTokens = freezed,
    Object? completionTokens = freezed,
    Object? totalTokens = freezed,
    Object? model = freezed,
    Object? temperature = freezed,
    Object? maxTokens = freezed,
    Object? swipes = null,
    Object? currentSwipeIndex = null,
    Object? reasoning = freezed,
    Object? extra = null,
  }) {
    return _then(_$MessageMetadataImpl(
      promptTokens: freezed == promptTokens
          ? _value.promptTokens
          : promptTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      completionTokens: freezed == completionTokens
          ? _value.completionTokens
          : completionTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTokens: freezed == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      maxTokens: freezed == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int?,
      swipes: null == swipes
          ? _value._swipes
          : swipes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentSwipeIndex: null == currentSwipeIndex
          ? _value.currentSwipeIndex
          : currentSwipeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      reasoning: freezed == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      extra: null == extra
          ? _value._extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageMetadataImpl implements _MessageMetadata {
  const _$MessageMetadataImpl(
      {this.promptTokens,
      this.completionTokens,
      this.totalTokens,
      this.model,
      this.temperature,
      this.maxTokens,
      final List<String> swipes = const [],
      this.currentSwipeIndex = 0,
      this.reasoning,
      final Map<String, dynamic> extra = const {}})
      : _swipes = swipes,
        _extra = extra;

  factory _$MessageMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageMetadataImplFromJson(json);

// Token counts
  @override
  final int? promptTokens;
  @override
  final int? completionTokens;
  @override
  final int? totalTokens;
// Generation info
  @override
  final String? model;
  @override
  final double? temperature;
  @override
  final int? maxTokens;
// Swipe support (multiple regenerations)
  final List<String> _swipes;
// Swipe support (multiple regenerations)
  @override
  @JsonKey()
  List<String> get swipes {
    if (_swipes is EqualUnmodifiableListView) return _swipes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_swipes);
  }

  @override
  @JsonKey()
  final int currentSwipeIndex;
// Reasoning/thinking content (for models like Claude/o1)
  @override
  final String? reasoning;
// Extra data
  final Map<String, dynamic> _extra;
// Extra data
  @override
  @JsonKey()
  Map<String, dynamic> get extra {
    if (_extra is EqualUnmodifiableMapView) return _extra;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extra);
  }

  @override
  String toString() {
    return 'MessageMetadata(promptTokens: $promptTokens, completionTokens: $completionTokens, totalTokens: $totalTokens, model: $model, temperature: $temperature, maxTokens: $maxTokens, swipes: $swipes, currentSwipeIndex: $currentSwipeIndex, reasoning: $reasoning, extra: $extra)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageMetadataImpl &&
            (identical(other.promptTokens, promptTokens) ||
                other.promptTokens == promptTokens) &&
            (identical(other.completionTokens, completionTokens) ||
                other.completionTokens == completionTokens) &&
            (identical(other.totalTokens, totalTokens) ||
                other.totalTokens == totalTokens) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            const DeepCollectionEquality().equals(other._swipes, _swipes) &&
            (identical(other.currentSwipeIndex, currentSwipeIndex) ||
                other.currentSwipeIndex == currentSwipeIndex) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            const DeepCollectionEquality().equals(other._extra, _extra));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      promptTokens,
      completionTokens,
      totalTokens,
      model,
      temperature,
      maxTokens,
      const DeepCollectionEquality().hash(_swipes),
      currentSwipeIndex,
      reasoning,
      const DeepCollectionEquality().hash(_extra));

  /// Create a copy of MessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageMetadataImplCopyWith<_$MessageMetadataImpl> get copyWith =>
      __$$MessageMetadataImplCopyWithImpl<_$MessageMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageMetadataImplToJson(
      this,
    );
  }
}

abstract class _MessageMetadata implements MessageMetadata {
  const factory _MessageMetadata(
      {final int? promptTokens,
      final int? completionTokens,
      final int? totalTokens,
      final String? model,
      final double? temperature,
      final int? maxTokens,
      final List<String> swipes,
      final int currentSwipeIndex,
      final String? reasoning,
      final Map<String, dynamic> extra}) = _$MessageMetadataImpl;

  factory _MessageMetadata.fromJson(Map<String, dynamic> json) =
      _$MessageMetadataImpl.fromJson;

// Token counts
  @override
  int? get promptTokens;
  @override
  int? get completionTokens;
  @override
  int? get totalTokens; // Generation info
  @override
  String? get model;
  @override
  double? get temperature;
  @override
  int? get maxTokens; // Swipe support (multiple regenerations)
  @override
  List<String> get swipes;
  @override
  int get currentSwipeIndex; // Reasoning/thinking content (for models like Claude/o1)
  @override
  String? get reasoning; // Extra data
  @override
  Map<String, dynamic> get extra;

  /// Create a copy of MessageMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageMetadataImplCopyWith<_$MessageMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
