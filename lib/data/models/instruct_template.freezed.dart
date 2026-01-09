// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instruct_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InstructTemplate _$InstructTemplateFromJson(Map<String, dynamic> json) {
  return _InstructTemplate.fromJson(json);
}

/// @nodoc
mixin _$InstructTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description =>
      throw _privateConstructorUsedError; // System prompt wrapping
  String get systemPrefix => throw _privateConstructorUsedError;
  String get systemSuffix =>
      throw _privateConstructorUsedError; // User message wrapping
  String get userPrefix => throw _privateConstructorUsedError;
  String get userSuffix =>
      throw _privateConstructorUsedError; // Assistant message wrapping
  String get assistantPrefix => throw _privateConstructorUsedError;
  String get assistantSuffix =>
      throw _privateConstructorUsedError; // First message handling (optional different format for first assistant message)
  String? get firstAssistantPrefix => throw _privateConstructorUsedError;
  String? get firstAssistantSuffix =>
      throw _privateConstructorUsedError; // Stop sequences
  List<String> get stopSequences =>
      throw _privateConstructorUsedError; // Whether this is a built-in template
  bool get isBuiltIn =>
      throw _privateConstructorUsedError; // Whether this is the default template
  bool get isDefault => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this InstructTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstructTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstructTemplateCopyWith<InstructTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstructTemplateCopyWith<$Res> {
  factory $InstructTemplateCopyWith(
          InstructTemplate value, $Res Function(InstructTemplate) then) =
      _$InstructTemplateCopyWithImpl<$Res, InstructTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String systemPrefix,
      String systemSuffix,
      String userPrefix,
      String userSuffix,
      String assistantPrefix,
      String assistantSuffix,
      String? firstAssistantPrefix,
      String? firstAssistantSuffix,
      List<String> stopSequences,
      bool isBuiltIn,
      bool isDefault,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$InstructTemplateCopyWithImpl<$Res, $Val extends InstructTemplate>
    implements $InstructTemplateCopyWith<$Res> {
  _$InstructTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstructTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? systemPrefix = null,
    Object? systemSuffix = null,
    Object? userPrefix = null,
    Object? userSuffix = null,
    Object? assistantPrefix = null,
    Object? assistantSuffix = null,
    Object? firstAssistantPrefix = freezed,
    Object? firstAssistantSuffix = freezed,
    Object? stopSequences = null,
    Object? isBuiltIn = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      systemPrefix: null == systemPrefix
          ? _value.systemPrefix
          : systemPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      systemSuffix: null == systemSuffix
          ? _value.systemSuffix
          : systemSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      userPrefix: null == userPrefix
          ? _value.userPrefix
          : userPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      userSuffix: null == userSuffix
          ? _value.userSuffix
          : userSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      assistantPrefix: null == assistantPrefix
          ? _value.assistantPrefix
          : assistantPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      assistantSuffix: null == assistantSuffix
          ? _value.assistantSuffix
          : assistantSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      firstAssistantPrefix: freezed == firstAssistantPrefix
          ? _value.firstAssistantPrefix
          : firstAssistantPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAssistantSuffix: freezed == firstAssistantSuffix
          ? _value.firstAssistantSuffix
          : firstAssistantSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      stopSequences: null == stopSequences
          ? _value.stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBuiltIn: null == isBuiltIn
          ? _value.isBuiltIn
          : isBuiltIn // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstructTemplateImplCopyWith<$Res>
    implements $InstructTemplateCopyWith<$Res> {
  factory _$$InstructTemplateImplCopyWith(_$InstructTemplateImpl value,
          $Res Function(_$InstructTemplateImpl) then) =
      __$$InstructTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String systemPrefix,
      String systemSuffix,
      String userPrefix,
      String userSuffix,
      String assistantPrefix,
      String assistantSuffix,
      String? firstAssistantPrefix,
      String? firstAssistantSuffix,
      List<String> stopSequences,
      bool isBuiltIn,
      bool isDefault,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$InstructTemplateImplCopyWithImpl<$Res>
    extends _$InstructTemplateCopyWithImpl<$Res, _$InstructTemplateImpl>
    implements _$$InstructTemplateImplCopyWith<$Res> {
  __$$InstructTemplateImplCopyWithImpl(_$InstructTemplateImpl _value,
      $Res Function(_$InstructTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InstructTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? systemPrefix = null,
    Object? systemSuffix = null,
    Object? userPrefix = null,
    Object? userSuffix = null,
    Object? assistantPrefix = null,
    Object? assistantSuffix = null,
    Object? firstAssistantPrefix = freezed,
    Object? firstAssistantSuffix = freezed,
    Object? stopSequences = null,
    Object? isBuiltIn = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$InstructTemplateImpl(
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
      systemPrefix: null == systemPrefix
          ? _value.systemPrefix
          : systemPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      systemSuffix: null == systemSuffix
          ? _value.systemSuffix
          : systemSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      userPrefix: null == userPrefix
          ? _value.userPrefix
          : userPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      userSuffix: null == userSuffix
          ? _value.userSuffix
          : userSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      assistantPrefix: null == assistantPrefix
          ? _value.assistantPrefix
          : assistantPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      assistantSuffix: null == assistantSuffix
          ? _value.assistantSuffix
          : assistantSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      firstAssistantPrefix: freezed == firstAssistantPrefix
          ? _value.firstAssistantPrefix
          : firstAssistantPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAssistantSuffix: freezed == firstAssistantSuffix
          ? _value.firstAssistantSuffix
          : firstAssistantSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      stopSequences: null == stopSequences
          ? _value._stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBuiltIn: null == isBuiltIn
          ? _value.isBuiltIn
          : isBuiltIn // ignore: cast_nullable_to_non_nullable
              as bool,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstructTemplateImpl implements _InstructTemplate {
  const _$InstructTemplateImpl(
      {required this.id,
      required this.name,
      this.description = '',
      this.systemPrefix = '',
      this.systemSuffix = '',
      this.userPrefix = '',
      this.userSuffix = '',
      this.assistantPrefix = '',
      this.assistantSuffix = '',
      this.firstAssistantPrefix,
      this.firstAssistantSuffix,
      final List<String> stopSequences = const [],
      this.isBuiltIn = false,
      this.isDefault = false,
      required this.createdAt,
      required this.updatedAt})
      : _stopSequences = stopSequences;

  factory _$InstructTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstructTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
// System prompt wrapping
  @override
  @JsonKey()
  final String systemPrefix;
  @override
  @JsonKey()
  final String systemSuffix;
// User message wrapping
  @override
  @JsonKey()
  final String userPrefix;
  @override
  @JsonKey()
  final String userSuffix;
// Assistant message wrapping
  @override
  @JsonKey()
  final String assistantPrefix;
  @override
  @JsonKey()
  final String assistantSuffix;
// First message handling (optional different format for first assistant message)
  @override
  final String? firstAssistantPrefix;
  @override
  final String? firstAssistantSuffix;
// Stop sequences
  final List<String> _stopSequences;
// Stop sequences
  @override
  @JsonKey()
  List<String> get stopSequences {
    if (_stopSequences is EqualUnmodifiableListView) return _stopSequences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stopSequences);
  }

// Whether this is a built-in template
  @override
  @JsonKey()
  final bool isBuiltIn;
// Whether this is the default template
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'InstructTemplate(id: $id, name: $name, description: $description, systemPrefix: $systemPrefix, systemSuffix: $systemSuffix, userPrefix: $userPrefix, userSuffix: $userSuffix, assistantPrefix: $assistantPrefix, assistantSuffix: $assistantSuffix, firstAssistantPrefix: $firstAssistantPrefix, firstAssistantSuffix: $firstAssistantSuffix, stopSequences: $stopSequences, isBuiltIn: $isBuiltIn, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstructTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.systemPrefix, systemPrefix) ||
                other.systemPrefix == systemPrefix) &&
            (identical(other.systemSuffix, systemSuffix) ||
                other.systemSuffix == systemSuffix) &&
            (identical(other.userPrefix, userPrefix) ||
                other.userPrefix == userPrefix) &&
            (identical(other.userSuffix, userSuffix) ||
                other.userSuffix == userSuffix) &&
            (identical(other.assistantPrefix, assistantPrefix) ||
                other.assistantPrefix == assistantPrefix) &&
            (identical(other.assistantSuffix, assistantSuffix) ||
                other.assistantSuffix == assistantSuffix) &&
            (identical(other.firstAssistantPrefix, firstAssistantPrefix) ||
                other.firstAssistantPrefix == firstAssistantPrefix) &&
            (identical(other.firstAssistantSuffix, firstAssistantSuffix) ||
                other.firstAssistantSuffix == firstAssistantSuffix) &&
            const DeepCollectionEquality()
                .equals(other._stopSequences, _stopSequences) &&
            (identical(other.isBuiltIn, isBuiltIn) ||
                other.isBuiltIn == isBuiltIn) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      systemPrefix,
      systemSuffix,
      userPrefix,
      userSuffix,
      assistantPrefix,
      assistantSuffix,
      firstAssistantPrefix,
      firstAssistantSuffix,
      const DeepCollectionEquality().hash(_stopSequences),
      isBuiltIn,
      isDefault,
      createdAt,
      updatedAt);

  /// Create a copy of InstructTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstructTemplateImplCopyWith<_$InstructTemplateImpl> get copyWith =>
      __$$InstructTemplateImplCopyWithImpl<_$InstructTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstructTemplateImplToJson(
      this,
    );
  }
}

abstract class _InstructTemplate implements InstructTemplate {
  const factory _InstructTemplate(
      {required final String id,
      required final String name,
      final String description,
      final String systemPrefix,
      final String systemSuffix,
      final String userPrefix,
      final String userSuffix,
      final String assistantPrefix,
      final String assistantSuffix,
      final String? firstAssistantPrefix,
      final String? firstAssistantSuffix,
      final List<String> stopSequences,
      final bool isBuiltIn,
      final bool isDefault,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$InstructTemplateImpl;

  factory _InstructTemplate.fromJson(Map<String, dynamic> json) =
      _$InstructTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description; // System prompt wrapping
  @override
  String get systemPrefix;
  @override
  String get systemSuffix; // User message wrapping
  @override
  String get userPrefix;
  @override
  String get userSuffix; // Assistant message wrapping
  @override
  String get assistantPrefix;
  @override
  String
      get assistantSuffix; // First message handling (optional different format for first assistant message)
  @override
  String? get firstAssistantPrefix;
  @override
  String? get firstAssistantSuffix; // Stop sequences
  @override
  List<String> get stopSequences; // Whether this is a built-in template
  @override
  bool get isBuiltIn; // Whether this is the default template
  @override
  bool get isDefault;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of InstructTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstructTemplateImplCopyWith<_$InstructTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
