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
      throw _privateConstructorUsedError; // === System prompt wrapping ===
  String get systemPrefix => throw _privateConstructorUsedError;
  String get systemSuffix =>
      throw _privateConstructorUsedError; // === User message wrapping ===
  String get userPrefix => throw _privateConstructorUsedError;
  String get userSuffix =>
      throw _privateConstructorUsedError; // === Assistant message wrapping ===
  String get assistantPrefix => throw _privateConstructorUsedError;
  String get assistantSuffix =>
      throw _privateConstructorUsedError; // === First message handling ===
  /// Different format for first user message
  String? get firstUserPrefix => throw _privateConstructorUsedError;
  String? get firstUserSuffix => throw _privateConstructorUsedError;

  /// Different format for first assistant message
  String? get firstAssistantPrefix => throw _privateConstructorUsedError;
  String? get firstAssistantSuffix =>
      throw _privateConstructorUsedError; // === Last message handling ===
  /// Different format for last user message (before generation)
  String? get lastUserPrefix => throw _privateConstructorUsedError;
  String? get lastUserSuffix => throw _privateConstructorUsedError;

  /// Different format for last assistant message
  String? get lastAssistantPrefix => throw _privateConstructorUsedError;
  String? get lastAssistantSuffix =>
      throw _privateConstructorUsedError; // === Input/Output sequences (SillyTavern compatibility) ===
  /// Input sequence (alternative to userPrefix)
  String get inputSequence => throw _privateConstructorUsedError;

  /// Output sequence (alternative to assistantPrefix)
  String get outputSequence => throw _privateConstructorUsedError;

  /// First input sequence
  String get firstInputSequence => throw _privateConstructorUsedError;

  /// First output sequence
  String get firstOutputSequence => throw _privateConstructorUsedError;

  /// Last input sequence
  String get lastInputSequence => throw _privateConstructorUsedError;

  /// Last output sequence
  String get lastOutputSequence =>
      throw _privateConstructorUsedError; // === Story string formatting ===
  /// Prefix for story string (character description, scenario, etc.)
  String get storyStringPrefix => throw _privateConstructorUsedError;

  /// Suffix for story string
  String get storyStringSuffix =>
      throw _privateConstructorUsedError; // === Chat formatting ===
  /// Separator between chat messages
  String get chatSeparator => throw _privateConstructorUsedError;

  /// String to mark start of chat
  String get chatStart =>
      throw _privateConstructorUsedError; // === User alignment message ===
  /// Message to align user expectations (inserted before first user message)
  String get userAlignmentMessage =>
      throw _privateConstructorUsedError; // === Stop sequences ===
  List<String> get stopSequences =>
      throw _privateConstructorUsedError; // === Behavior options ===
  /// Whether this is a built-in template
  bool get isBuiltIn => throw _privateConstructorUsedError;

  /// Whether this is the default template
  bool get isDefault => throw _privateConstructorUsedError;

  /// Regex pattern for auto-activation based on model name
  String? get activationRegex => throw _privateConstructorUsedError;

  /// Whether to bind to context (use context template settings)
  bool get bindToContext => throw _privateConstructorUsedError;

  /// Whether to skip example messages
  bool get skipExamples => throw _privateConstructorUsedError;

  /// Names behavior (none, force, always)
  InstructNamesBehavior get namesBehavior => throw _privateConstructorUsedError;

  /// Whether system messages use same format as user
  bool get systemSameAsUser => throw _privateConstructorUsedError;

  /// Whether to use sequences as stop strings
  bool get sequencesAsStopStrings => throw _privateConstructorUsedError;

  /// Whether to enable macro substitution in sequences
  bool get macroSubstitution => throw _privateConstructorUsedError;

  /// Whether to wrap sequences in newlines
  bool get wrapInNewlines => throw _privateConstructorUsedError;

  /// Whether to include names in prompts
  bool get includeNames => throw _privateConstructorUsedError;

  /// Format string for names (e.g., "{{name}}: ")
  String get nameFormat => throw _privateConstructorUsedError;

  /// Whether to force names for all messages
  bool get forceNames =>
      throw _privateConstructorUsedError; // === Timestamps ===
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
      String? firstUserPrefix,
      String? firstUserSuffix,
      String? firstAssistantPrefix,
      String? firstAssistantSuffix,
      String? lastUserPrefix,
      String? lastUserSuffix,
      String? lastAssistantPrefix,
      String? lastAssistantSuffix,
      String inputSequence,
      String outputSequence,
      String firstInputSequence,
      String firstOutputSequence,
      String lastInputSequence,
      String lastOutputSequence,
      String storyStringPrefix,
      String storyStringSuffix,
      String chatSeparator,
      String chatStart,
      String userAlignmentMessage,
      List<String> stopSequences,
      bool isBuiltIn,
      bool isDefault,
      String? activationRegex,
      bool bindToContext,
      bool skipExamples,
      InstructNamesBehavior namesBehavior,
      bool systemSameAsUser,
      bool sequencesAsStopStrings,
      bool macroSubstitution,
      bool wrapInNewlines,
      bool includeNames,
      String nameFormat,
      bool forceNames,
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
    Object? firstUserPrefix = freezed,
    Object? firstUserSuffix = freezed,
    Object? firstAssistantPrefix = freezed,
    Object? firstAssistantSuffix = freezed,
    Object? lastUserPrefix = freezed,
    Object? lastUserSuffix = freezed,
    Object? lastAssistantPrefix = freezed,
    Object? lastAssistantSuffix = freezed,
    Object? inputSequence = null,
    Object? outputSequence = null,
    Object? firstInputSequence = null,
    Object? firstOutputSequence = null,
    Object? lastInputSequence = null,
    Object? lastOutputSequence = null,
    Object? storyStringPrefix = null,
    Object? storyStringSuffix = null,
    Object? chatSeparator = null,
    Object? chatStart = null,
    Object? userAlignmentMessage = null,
    Object? stopSequences = null,
    Object? isBuiltIn = null,
    Object? isDefault = null,
    Object? activationRegex = freezed,
    Object? bindToContext = null,
    Object? skipExamples = null,
    Object? namesBehavior = null,
    Object? systemSameAsUser = null,
    Object? sequencesAsStopStrings = null,
    Object? macroSubstitution = null,
    Object? wrapInNewlines = null,
    Object? includeNames = null,
    Object? nameFormat = null,
    Object? forceNames = null,
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
      firstUserPrefix: freezed == firstUserPrefix
          ? _value.firstUserPrefix
          : firstUserPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstUserSuffix: freezed == firstUserSuffix
          ? _value.firstUserSuffix
          : firstUserSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAssistantPrefix: freezed == firstAssistantPrefix
          ? _value.firstAssistantPrefix
          : firstAssistantPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAssistantSuffix: freezed == firstAssistantSuffix
          ? _value.firstAssistantSuffix
          : firstAssistantSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUserPrefix: freezed == lastUserPrefix
          ? _value.lastUserPrefix
          : lastUserPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUserSuffix: freezed == lastUserSuffix
          ? _value.lastUserSuffix
          : lastUserSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAssistantPrefix: freezed == lastAssistantPrefix
          ? _value.lastAssistantPrefix
          : lastAssistantPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAssistantSuffix: freezed == lastAssistantSuffix
          ? _value.lastAssistantSuffix
          : lastAssistantSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      inputSequence: null == inputSequence
          ? _value.inputSequence
          : inputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      outputSequence: null == outputSequence
          ? _value.outputSequence
          : outputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstInputSequence: null == firstInputSequence
          ? _value.firstInputSequence
          : firstInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstOutputSequence: null == firstOutputSequence
          ? _value.firstOutputSequence
          : firstOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastInputSequence: null == lastInputSequence
          ? _value.lastInputSequence
          : lastInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastOutputSequence: null == lastOutputSequence
          ? _value.lastOutputSequence
          : lastOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      storyStringPrefix: null == storyStringPrefix
          ? _value.storyStringPrefix
          : storyStringPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      storyStringSuffix: null == storyStringSuffix
          ? _value.storyStringSuffix
          : storyStringSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      chatSeparator: null == chatSeparator
          ? _value.chatSeparator
          : chatSeparator // ignore: cast_nullable_to_non_nullable
              as String,
      chatStart: null == chatStart
          ? _value.chatStart
          : chatStart // ignore: cast_nullable_to_non_nullable
              as String,
      userAlignmentMessage: null == userAlignmentMessage
          ? _value.userAlignmentMessage
          : userAlignmentMessage // ignore: cast_nullable_to_non_nullable
              as String,
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
      activationRegex: freezed == activationRegex
          ? _value.activationRegex
          : activationRegex // ignore: cast_nullable_to_non_nullable
              as String?,
      bindToContext: null == bindToContext
          ? _value.bindToContext
          : bindToContext // ignore: cast_nullable_to_non_nullable
              as bool,
      skipExamples: null == skipExamples
          ? _value.skipExamples
          : skipExamples // ignore: cast_nullable_to_non_nullable
              as bool,
      namesBehavior: null == namesBehavior
          ? _value.namesBehavior
          : namesBehavior // ignore: cast_nullable_to_non_nullable
              as InstructNamesBehavior,
      systemSameAsUser: null == systemSameAsUser
          ? _value.systemSameAsUser
          : systemSameAsUser // ignore: cast_nullable_to_non_nullable
              as bool,
      sequencesAsStopStrings: null == sequencesAsStopStrings
          ? _value.sequencesAsStopStrings
          : sequencesAsStopStrings // ignore: cast_nullable_to_non_nullable
              as bool,
      macroSubstitution: null == macroSubstitution
          ? _value.macroSubstitution
          : macroSubstitution // ignore: cast_nullable_to_non_nullable
              as bool,
      wrapInNewlines: null == wrapInNewlines
          ? _value.wrapInNewlines
          : wrapInNewlines // ignore: cast_nullable_to_non_nullable
              as bool,
      includeNames: null == includeNames
          ? _value.includeNames
          : includeNames // ignore: cast_nullable_to_non_nullable
              as bool,
      nameFormat: null == nameFormat
          ? _value.nameFormat
          : nameFormat // ignore: cast_nullable_to_non_nullable
              as String,
      forceNames: null == forceNames
          ? _value.forceNames
          : forceNames // ignore: cast_nullable_to_non_nullable
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
      String? firstUserPrefix,
      String? firstUserSuffix,
      String? firstAssistantPrefix,
      String? firstAssistantSuffix,
      String? lastUserPrefix,
      String? lastUserSuffix,
      String? lastAssistantPrefix,
      String? lastAssistantSuffix,
      String inputSequence,
      String outputSequence,
      String firstInputSequence,
      String firstOutputSequence,
      String lastInputSequence,
      String lastOutputSequence,
      String storyStringPrefix,
      String storyStringSuffix,
      String chatSeparator,
      String chatStart,
      String userAlignmentMessage,
      List<String> stopSequences,
      bool isBuiltIn,
      bool isDefault,
      String? activationRegex,
      bool bindToContext,
      bool skipExamples,
      InstructNamesBehavior namesBehavior,
      bool systemSameAsUser,
      bool sequencesAsStopStrings,
      bool macroSubstitution,
      bool wrapInNewlines,
      bool includeNames,
      String nameFormat,
      bool forceNames,
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
    Object? firstUserPrefix = freezed,
    Object? firstUserSuffix = freezed,
    Object? firstAssistantPrefix = freezed,
    Object? firstAssistantSuffix = freezed,
    Object? lastUserPrefix = freezed,
    Object? lastUserSuffix = freezed,
    Object? lastAssistantPrefix = freezed,
    Object? lastAssistantSuffix = freezed,
    Object? inputSequence = null,
    Object? outputSequence = null,
    Object? firstInputSequence = null,
    Object? firstOutputSequence = null,
    Object? lastInputSequence = null,
    Object? lastOutputSequence = null,
    Object? storyStringPrefix = null,
    Object? storyStringSuffix = null,
    Object? chatSeparator = null,
    Object? chatStart = null,
    Object? userAlignmentMessage = null,
    Object? stopSequences = null,
    Object? isBuiltIn = null,
    Object? isDefault = null,
    Object? activationRegex = freezed,
    Object? bindToContext = null,
    Object? skipExamples = null,
    Object? namesBehavior = null,
    Object? systemSameAsUser = null,
    Object? sequencesAsStopStrings = null,
    Object? macroSubstitution = null,
    Object? wrapInNewlines = null,
    Object? includeNames = null,
    Object? nameFormat = null,
    Object? forceNames = null,
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
      firstUserPrefix: freezed == firstUserPrefix
          ? _value.firstUserPrefix
          : firstUserPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstUserSuffix: freezed == firstUserSuffix
          ? _value.firstUserSuffix
          : firstUserSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAssistantPrefix: freezed == firstAssistantPrefix
          ? _value.firstAssistantPrefix
          : firstAssistantPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAssistantSuffix: freezed == firstAssistantSuffix
          ? _value.firstAssistantSuffix
          : firstAssistantSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUserPrefix: freezed == lastUserPrefix
          ? _value.lastUserPrefix
          : lastUserPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUserSuffix: freezed == lastUserSuffix
          ? _value.lastUserSuffix
          : lastUserSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAssistantPrefix: freezed == lastAssistantPrefix
          ? _value.lastAssistantPrefix
          : lastAssistantPrefix // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAssistantSuffix: freezed == lastAssistantSuffix
          ? _value.lastAssistantSuffix
          : lastAssistantSuffix // ignore: cast_nullable_to_non_nullable
              as String?,
      inputSequence: null == inputSequence
          ? _value.inputSequence
          : inputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      outputSequence: null == outputSequence
          ? _value.outputSequence
          : outputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstInputSequence: null == firstInputSequence
          ? _value.firstInputSequence
          : firstInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstOutputSequence: null == firstOutputSequence
          ? _value.firstOutputSequence
          : firstOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastInputSequence: null == lastInputSequence
          ? _value.lastInputSequence
          : lastInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastOutputSequence: null == lastOutputSequence
          ? _value.lastOutputSequence
          : lastOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      storyStringPrefix: null == storyStringPrefix
          ? _value.storyStringPrefix
          : storyStringPrefix // ignore: cast_nullable_to_non_nullable
              as String,
      storyStringSuffix: null == storyStringSuffix
          ? _value.storyStringSuffix
          : storyStringSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      chatSeparator: null == chatSeparator
          ? _value.chatSeparator
          : chatSeparator // ignore: cast_nullable_to_non_nullable
              as String,
      chatStart: null == chatStart
          ? _value.chatStart
          : chatStart // ignore: cast_nullable_to_non_nullable
              as String,
      userAlignmentMessage: null == userAlignmentMessage
          ? _value.userAlignmentMessage
          : userAlignmentMessage // ignore: cast_nullable_to_non_nullable
              as String,
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
      activationRegex: freezed == activationRegex
          ? _value.activationRegex
          : activationRegex // ignore: cast_nullable_to_non_nullable
              as String?,
      bindToContext: null == bindToContext
          ? _value.bindToContext
          : bindToContext // ignore: cast_nullable_to_non_nullable
              as bool,
      skipExamples: null == skipExamples
          ? _value.skipExamples
          : skipExamples // ignore: cast_nullable_to_non_nullable
              as bool,
      namesBehavior: null == namesBehavior
          ? _value.namesBehavior
          : namesBehavior // ignore: cast_nullable_to_non_nullable
              as InstructNamesBehavior,
      systemSameAsUser: null == systemSameAsUser
          ? _value.systemSameAsUser
          : systemSameAsUser // ignore: cast_nullable_to_non_nullable
              as bool,
      sequencesAsStopStrings: null == sequencesAsStopStrings
          ? _value.sequencesAsStopStrings
          : sequencesAsStopStrings // ignore: cast_nullable_to_non_nullable
              as bool,
      macroSubstitution: null == macroSubstitution
          ? _value.macroSubstitution
          : macroSubstitution // ignore: cast_nullable_to_non_nullable
              as bool,
      wrapInNewlines: null == wrapInNewlines
          ? _value.wrapInNewlines
          : wrapInNewlines // ignore: cast_nullable_to_non_nullable
              as bool,
      includeNames: null == includeNames
          ? _value.includeNames
          : includeNames // ignore: cast_nullable_to_non_nullable
              as bool,
      nameFormat: null == nameFormat
          ? _value.nameFormat
          : nameFormat // ignore: cast_nullable_to_non_nullable
              as String,
      forceNames: null == forceNames
          ? _value.forceNames
          : forceNames // ignore: cast_nullable_to_non_nullable
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
      this.firstUserPrefix,
      this.firstUserSuffix,
      this.firstAssistantPrefix,
      this.firstAssistantSuffix,
      this.lastUserPrefix,
      this.lastUserSuffix,
      this.lastAssistantPrefix,
      this.lastAssistantSuffix,
      this.inputSequence = '',
      this.outputSequence = '',
      this.firstInputSequence = '',
      this.firstOutputSequence = '',
      this.lastInputSequence = '',
      this.lastOutputSequence = '',
      this.storyStringPrefix = '',
      this.storyStringSuffix = '',
      this.chatSeparator = '',
      this.chatStart = '',
      this.userAlignmentMessage = '',
      final List<String> stopSequences = const [],
      this.isBuiltIn = false,
      this.isDefault = false,
      this.activationRegex,
      this.bindToContext = false,
      this.skipExamples = false,
      this.namesBehavior = InstructNamesBehavior.none,
      this.systemSameAsUser = false,
      this.sequencesAsStopStrings = true,
      this.macroSubstitution = true,
      this.wrapInNewlines = true,
      this.includeNames = false,
      this.nameFormat = '{{name}}: ',
      this.forceNames = false,
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
// === System prompt wrapping ===
  @override
  @JsonKey()
  final String systemPrefix;
  @override
  @JsonKey()
  final String systemSuffix;
// === User message wrapping ===
  @override
  @JsonKey()
  final String userPrefix;
  @override
  @JsonKey()
  final String userSuffix;
// === Assistant message wrapping ===
  @override
  @JsonKey()
  final String assistantPrefix;
  @override
  @JsonKey()
  final String assistantSuffix;
// === First message handling ===
  /// Different format for first user message
  @override
  final String? firstUserPrefix;
  @override
  final String? firstUserSuffix;

  /// Different format for first assistant message
  @override
  final String? firstAssistantPrefix;
  @override
  final String? firstAssistantSuffix;
// === Last message handling ===
  /// Different format for last user message (before generation)
  @override
  final String? lastUserPrefix;
  @override
  final String? lastUserSuffix;

  /// Different format for last assistant message
  @override
  final String? lastAssistantPrefix;
  @override
  final String? lastAssistantSuffix;
// === Input/Output sequences (SillyTavern compatibility) ===
  /// Input sequence (alternative to userPrefix)
  @override
  @JsonKey()
  final String inputSequence;

  /// Output sequence (alternative to assistantPrefix)
  @override
  @JsonKey()
  final String outputSequence;

  /// First input sequence
  @override
  @JsonKey()
  final String firstInputSequence;

  /// First output sequence
  @override
  @JsonKey()
  final String firstOutputSequence;

  /// Last input sequence
  @override
  @JsonKey()
  final String lastInputSequence;

  /// Last output sequence
  @override
  @JsonKey()
  final String lastOutputSequence;
// === Story string formatting ===
  /// Prefix for story string (character description, scenario, etc.)
  @override
  @JsonKey()
  final String storyStringPrefix;

  /// Suffix for story string
  @override
  @JsonKey()
  final String storyStringSuffix;
// === Chat formatting ===
  /// Separator between chat messages
  @override
  @JsonKey()
  final String chatSeparator;

  /// String to mark start of chat
  @override
  @JsonKey()
  final String chatStart;
// === User alignment message ===
  /// Message to align user expectations (inserted before first user message)
  @override
  @JsonKey()
  final String userAlignmentMessage;
// === Stop sequences ===
  final List<String> _stopSequences;
// === Stop sequences ===
  @override
  @JsonKey()
  List<String> get stopSequences {
    if (_stopSequences is EqualUnmodifiableListView) return _stopSequences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stopSequences);
  }

// === Behavior options ===
  /// Whether this is a built-in template
  @override
  @JsonKey()
  final bool isBuiltIn;

  /// Whether this is the default template
  @override
  @JsonKey()
  final bool isDefault;

  /// Regex pattern for auto-activation based on model name
  @override
  final String? activationRegex;

  /// Whether to bind to context (use context template settings)
  @override
  @JsonKey()
  final bool bindToContext;

  /// Whether to skip example messages
  @override
  @JsonKey()
  final bool skipExamples;

  /// Names behavior (none, force, always)
  @override
  @JsonKey()
  final InstructNamesBehavior namesBehavior;

  /// Whether system messages use same format as user
  @override
  @JsonKey()
  final bool systemSameAsUser;

  /// Whether to use sequences as stop strings
  @override
  @JsonKey()
  final bool sequencesAsStopStrings;

  /// Whether to enable macro substitution in sequences
  @override
  @JsonKey()
  final bool macroSubstitution;

  /// Whether to wrap sequences in newlines
  @override
  @JsonKey()
  final bool wrapInNewlines;

  /// Whether to include names in prompts
  @override
  @JsonKey()
  final bool includeNames;

  /// Format string for names (e.g., "{{name}}: ")
  @override
  @JsonKey()
  final String nameFormat;

  /// Whether to force names for all messages
  @override
  @JsonKey()
  final bool forceNames;
// === Timestamps ===
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'InstructTemplate(id: $id, name: $name, description: $description, systemPrefix: $systemPrefix, systemSuffix: $systemSuffix, userPrefix: $userPrefix, userSuffix: $userSuffix, assistantPrefix: $assistantPrefix, assistantSuffix: $assistantSuffix, firstUserPrefix: $firstUserPrefix, firstUserSuffix: $firstUserSuffix, firstAssistantPrefix: $firstAssistantPrefix, firstAssistantSuffix: $firstAssistantSuffix, lastUserPrefix: $lastUserPrefix, lastUserSuffix: $lastUserSuffix, lastAssistantPrefix: $lastAssistantPrefix, lastAssistantSuffix: $lastAssistantSuffix, inputSequence: $inputSequence, outputSequence: $outputSequence, firstInputSequence: $firstInputSequence, firstOutputSequence: $firstOutputSequence, lastInputSequence: $lastInputSequence, lastOutputSequence: $lastOutputSequence, storyStringPrefix: $storyStringPrefix, storyStringSuffix: $storyStringSuffix, chatSeparator: $chatSeparator, chatStart: $chatStart, userAlignmentMessage: $userAlignmentMessage, stopSequences: $stopSequences, isBuiltIn: $isBuiltIn, isDefault: $isDefault, activationRegex: $activationRegex, bindToContext: $bindToContext, skipExamples: $skipExamples, namesBehavior: $namesBehavior, systemSameAsUser: $systemSameAsUser, sequencesAsStopStrings: $sequencesAsStopStrings, macroSubstitution: $macroSubstitution, wrapInNewlines: $wrapInNewlines, includeNames: $includeNames, nameFormat: $nameFormat, forceNames: $forceNames, createdAt: $createdAt, updatedAt: $updatedAt)';
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
            (identical(other.firstUserPrefix, firstUserPrefix) ||
                other.firstUserPrefix == firstUserPrefix) &&
            (identical(other.firstUserSuffix, firstUserSuffix) ||
                other.firstUserSuffix == firstUserSuffix) &&
            (identical(other.firstAssistantPrefix, firstAssistantPrefix) ||
                other.firstAssistantPrefix == firstAssistantPrefix) &&
            (identical(other.firstAssistantSuffix, firstAssistantSuffix) ||
                other.firstAssistantSuffix == firstAssistantSuffix) &&
            (identical(other.lastUserPrefix, lastUserPrefix) ||
                other.lastUserPrefix == lastUserPrefix) &&
            (identical(other.lastUserSuffix, lastUserSuffix) ||
                other.lastUserSuffix == lastUserSuffix) &&
            (identical(other.lastAssistantPrefix, lastAssistantPrefix) ||
                other.lastAssistantPrefix == lastAssistantPrefix) &&
            (identical(other.lastAssistantSuffix, lastAssistantSuffix) ||
                other.lastAssistantSuffix == lastAssistantSuffix) &&
            (identical(other.inputSequence, inputSequence) ||
                other.inputSequence == inputSequence) &&
            (identical(other.outputSequence, outputSequence) ||
                other.outputSequence == outputSequence) &&
            (identical(other.firstInputSequence, firstInputSequence) ||
                other.firstInputSequence == firstInputSequence) &&
            (identical(other.firstOutputSequence, firstOutputSequence) ||
                other.firstOutputSequence == firstOutputSequence) &&
            (identical(other.lastInputSequence, lastInputSequence) ||
                other.lastInputSequence == lastInputSequence) &&
            (identical(other.lastOutputSequence, lastOutputSequence) ||
                other.lastOutputSequence == lastOutputSequence) &&
            (identical(other.storyStringPrefix, storyStringPrefix) ||
                other.storyStringPrefix == storyStringPrefix) &&
            (identical(other.storyStringSuffix, storyStringSuffix) ||
                other.storyStringSuffix == storyStringSuffix) &&
            (identical(other.chatSeparator, chatSeparator) ||
                other.chatSeparator == chatSeparator) &&
            (identical(other.chatStart, chatStart) ||
                other.chatStart == chatStart) &&
            (identical(other.userAlignmentMessage, userAlignmentMessage) ||
                other.userAlignmentMessage == userAlignmentMessage) &&
            const DeepCollectionEquality()
                .equals(other._stopSequences, _stopSequences) &&
            (identical(other.isBuiltIn, isBuiltIn) ||
                other.isBuiltIn == isBuiltIn) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.activationRegex, activationRegex) ||
                other.activationRegex == activationRegex) &&
            (identical(other.bindToContext, bindToContext) ||
                other.bindToContext == bindToContext) &&
            (identical(other.skipExamples, skipExamples) ||
                other.skipExamples == skipExamples) &&
            (identical(other.namesBehavior, namesBehavior) ||
                other.namesBehavior == namesBehavior) &&
            (identical(other.systemSameAsUser, systemSameAsUser) ||
                other.systemSameAsUser == systemSameAsUser) &&
            (identical(other.sequencesAsStopStrings, sequencesAsStopStrings) ||
                other.sequencesAsStopStrings == sequencesAsStopStrings) &&
            (identical(other.macroSubstitution, macroSubstitution) ||
                other.macroSubstitution == macroSubstitution) &&
            (identical(other.wrapInNewlines, wrapInNewlines) ||
                other.wrapInNewlines == wrapInNewlines) &&
            (identical(other.includeNames, includeNames) ||
                other.includeNames == includeNames) &&
            (identical(other.nameFormat, nameFormat) ||
                other.nameFormat == nameFormat) &&
            (identical(other.forceNames, forceNames) ||
                other.forceNames == forceNames) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
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
        firstUserPrefix,
        firstUserSuffix,
        firstAssistantPrefix,
        firstAssistantSuffix,
        lastUserPrefix,
        lastUserSuffix,
        lastAssistantPrefix,
        lastAssistantSuffix,
        inputSequence,
        outputSequence,
        firstInputSequence,
        firstOutputSequence,
        lastInputSequence,
        lastOutputSequence,
        storyStringPrefix,
        storyStringSuffix,
        chatSeparator,
        chatStart,
        userAlignmentMessage,
        const DeepCollectionEquality().hash(_stopSequences),
        isBuiltIn,
        isDefault,
        activationRegex,
        bindToContext,
        skipExamples,
        namesBehavior,
        systemSameAsUser,
        sequencesAsStopStrings,
        macroSubstitution,
        wrapInNewlines,
        includeNames,
        nameFormat,
        forceNames,
        createdAt,
        updatedAt
      ]);

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
      final String? firstUserPrefix,
      final String? firstUserSuffix,
      final String? firstAssistantPrefix,
      final String? firstAssistantSuffix,
      final String? lastUserPrefix,
      final String? lastUserSuffix,
      final String? lastAssistantPrefix,
      final String? lastAssistantSuffix,
      final String inputSequence,
      final String outputSequence,
      final String firstInputSequence,
      final String firstOutputSequence,
      final String lastInputSequence,
      final String lastOutputSequence,
      final String storyStringPrefix,
      final String storyStringSuffix,
      final String chatSeparator,
      final String chatStart,
      final String userAlignmentMessage,
      final List<String> stopSequences,
      final bool isBuiltIn,
      final bool isDefault,
      final String? activationRegex,
      final bool bindToContext,
      final bool skipExamples,
      final InstructNamesBehavior namesBehavior,
      final bool systemSameAsUser,
      final bool sequencesAsStopStrings,
      final bool macroSubstitution,
      final bool wrapInNewlines,
      final bool includeNames,
      final String nameFormat,
      final bool forceNames,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$InstructTemplateImpl;

  factory _InstructTemplate.fromJson(Map<String, dynamic> json) =
      _$InstructTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description; // === System prompt wrapping ===
  @override
  String get systemPrefix;
  @override
  String get systemSuffix; // === User message wrapping ===
  @override
  String get userPrefix;
  @override
  String get userSuffix; // === Assistant message wrapping ===
  @override
  String get assistantPrefix;
  @override
  String get assistantSuffix; // === First message handling ===
  /// Different format for first user message
  @override
  String? get firstUserPrefix;
  @override
  String? get firstUserSuffix;

  /// Different format for first assistant message
  @override
  String? get firstAssistantPrefix;
  @override
  String? get firstAssistantSuffix; // === Last message handling ===
  /// Different format for last user message (before generation)
  @override
  String? get lastUserPrefix;
  @override
  String? get lastUserSuffix;

  /// Different format for last assistant message
  @override
  String? get lastAssistantPrefix;
  @override
  String?
      get lastAssistantSuffix; // === Input/Output sequences (SillyTavern compatibility) ===
  /// Input sequence (alternative to userPrefix)
  @override
  String get inputSequence;

  /// Output sequence (alternative to assistantPrefix)
  @override
  String get outputSequence;

  /// First input sequence
  @override
  String get firstInputSequence;

  /// First output sequence
  @override
  String get firstOutputSequence;

  /// Last input sequence
  @override
  String get lastInputSequence;

  /// Last output sequence
  @override
  String get lastOutputSequence; // === Story string formatting ===
  /// Prefix for story string (character description, scenario, etc.)
  @override
  String get storyStringPrefix;

  /// Suffix for story string
  @override
  String get storyStringSuffix; // === Chat formatting ===
  /// Separator between chat messages
  @override
  String get chatSeparator;

  /// String to mark start of chat
  @override
  String get chatStart; // === User alignment message ===
  /// Message to align user expectations (inserted before first user message)
  @override
  String get userAlignmentMessage; // === Stop sequences ===
  @override
  List<String> get stopSequences; // === Behavior options ===
  /// Whether this is a built-in template
  @override
  bool get isBuiltIn;

  /// Whether this is the default template
  @override
  bool get isDefault;

  /// Regex pattern for auto-activation based on model name
  @override
  String? get activationRegex;

  /// Whether to bind to context (use context template settings)
  @override
  bool get bindToContext;

  /// Whether to skip example messages
  @override
  bool get skipExamples;

  /// Names behavior (none, force, always)
  @override
  InstructNamesBehavior get namesBehavior;

  /// Whether system messages use same format as user
  @override
  bool get systemSameAsUser;

  /// Whether to use sequences as stop strings
  @override
  bool get sequencesAsStopStrings;

  /// Whether to enable macro substitution in sequences
  @override
  bool get macroSubstitution;

  /// Whether to wrap sequences in newlines
  @override
  bool get wrapInNewlines;

  /// Whether to include names in prompts
  @override
  bool get includeNames;

  /// Format string for names (e.g., "{{name}}: ")
  @override
  String get nameFormat;

  /// Whether to force names for all messages
  @override
  bool get forceNames; // === Timestamps ===
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

InstructTemplateExport _$InstructTemplateExportFromJson(
    Map<String, dynamic> json) {
  return _InstructTemplateExport.fromJson(json);
}

/// @nodoc
mixin _$InstructTemplateExport {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_prompt')
  String get systemPrompt => throw _privateConstructorUsedError;
  @JsonKey(name: 'input_sequence')
  String get inputSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'output_sequence')
  String get outputSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_output_sequence')
  String get firstOutputSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_output_sequence')
  String get lastOutputSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_sequence')
  String get systemSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'stop_sequence')
  String get stopSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'separator_sequence')
  String get separatorSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'wrap')
  bool get wrap => throw _privateConstructorUsedError;
  @JsonKey(name: 'macro')
  bool get macro => throw _privateConstructorUsedError;
  @JsonKey(name: 'names')
  bool get names => throw _privateConstructorUsedError;
  @JsonKey(name: 'names_force_groups')
  bool get namesForceGroups => throw _privateConstructorUsedError;
  @JsonKey(name: 'activation_regex')
  String get activationRegex => throw _privateConstructorUsedError;
  @JsonKey(name: 'skip_examples')
  bool get skipExamples => throw _privateConstructorUsedError;
  @JsonKey(name: 'output_suffix')
  String get outputSuffix => throw _privateConstructorUsedError;
  @JsonKey(name: 'input_suffix')
  String get inputSuffix => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_suffix')
  String get systemSuffix => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_alignment_message')
  String get userAlignmentMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_same_as_user')
  bool get systemSameAsUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_system_sequence')
  String get lastSystemSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_input_sequence')
  String get firstInputSequence => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_input_sequence')
  String get lastInputSequence => throw _privateConstructorUsedError;

  /// Serializes this InstructTemplateExport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstructTemplateExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstructTemplateExportCopyWith<InstructTemplateExport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstructTemplateExportCopyWith<$Res> {
  factory $InstructTemplateExportCopyWith(InstructTemplateExport value,
          $Res Function(InstructTemplateExport) then) =
      _$InstructTemplateExportCopyWithImpl<$Res, InstructTemplateExport>;
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'system_prompt') String systemPrompt,
      @JsonKey(name: 'input_sequence') String inputSequence,
      @JsonKey(name: 'output_sequence') String outputSequence,
      @JsonKey(name: 'first_output_sequence') String firstOutputSequence,
      @JsonKey(name: 'last_output_sequence') String lastOutputSequence,
      @JsonKey(name: 'system_sequence') String systemSequence,
      @JsonKey(name: 'stop_sequence') String stopSequence,
      @JsonKey(name: 'separator_sequence') String separatorSequence,
      @JsonKey(name: 'wrap') bool wrap,
      @JsonKey(name: 'macro') bool macro,
      @JsonKey(name: 'names') bool names,
      @JsonKey(name: 'names_force_groups') bool namesForceGroups,
      @JsonKey(name: 'activation_regex') String activationRegex,
      @JsonKey(name: 'skip_examples') bool skipExamples,
      @JsonKey(name: 'output_suffix') String outputSuffix,
      @JsonKey(name: 'input_suffix') String inputSuffix,
      @JsonKey(name: 'system_suffix') String systemSuffix,
      @JsonKey(name: 'user_alignment_message') String userAlignmentMessage,
      @JsonKey(name: 'system_same_as_user') bool systemSameAsUser,
      @JsonKey(name: 'last_system_sequence') String lastSystemSequence,
      @JsonKey(name: 'first_input_sequence') String firstInputSequence,
      @JsonKey(name: 'last_input_sequence') String lastInputSequence});
}

/// @nodoc
class _$InstructTemplateExportCopyWithImpl<$Res,
        $Val extends InstructTemplateExport>
    implements $InstructTemplateExportCopyWith<$Res> {
  _$InstructTemplateExportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstructTemplateExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? systemPrompt = null,
    Object? inputSequence = null,
    Object? outputSequence = null,
    Object? firstOutputSequence = null,
    Object? lastOutputSequence = null,
    Object? systemSequence = null,
    Object? stopSequence = null,
    Object? separatorSequence = null,
    Object? wrap = null,
    Object? macro = null,
    Object? names = null,
    Object? namesForceGroups = null,
    Object? activationRegex = null,
    Object? skipExamples = null,
    Object? outputSuffix = null,
    Object? inputSuffix = null,
    Object? systemSuffix = null,
    Object? userAlignmentMessage = null,
    Object? systemSameAsUser = null,
    Object? lastSystemSequence = null,
    Object? firstInputSequence = null,
    Object? lastInputSequence = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      inputSequence: null == inputSequence
          ? _value.inputSequence
          : inputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      outputSequence: null == outputSequence
          ? _value.outputSequence
          : outputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstOutputSequence: null == firstOutputSequence
          ? _value.firstOutputSequence
          : firstOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastOutputSequence: null == lastOutputSequence
          ? _value.lastOutputSequence
          : lastOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      systemSequence: null == systemSequence
          ? _value.systemSequence
          : systemSequence // ignore: cast_nullable_to_non_nullable
              as String,
      stopSequence: null == stopSequence
          ? _value.stopSequence
          : stopSequence // ignore: cast_nullable_to_non_nullable
              as String,
      separatorSequence: null == separatorSequence
          ? _value.separatorSequence
          : separatorSequence // ignore: cast_nullable_to_non_nullable
              as String,
      wrap: null == wrap
          ? _value.wrap
          : wrap // ignore: cast_nullable_to_non_nullable
              as bool,
      macro: null == macro
          ? _value.macro
          : macro // ignore: cast_nullable_to_non_nullable
              as bool,
      names: null == names
          ? _value.names
          : names // ignore: cast_nullable_to_non_nullable
              as bool,
      namesForceGroups: null == namesForceGroups
          ? _value.namesForceGroups
          : namesForceGroups // ignore: cast_nullable_to_non_nullable
              as bool,
      activationRegex: null == activationRegex
          ? _value.activationRegex
          : activationRegex // ignore: cast_nullable_to_non_nullable
              as String,
      skipExamples: null == skipExamples
          ? _value.skipExamples
          : skipExamples // ignore: cast_nullable_to_non_nullable
              as bool,
      outputSuffix: null == outputSuffix
          ? _value.outputSuffix
          : outputSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      inputSuffix: null == inputSuffix
          ? _value.inputSuffix
          : inputSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      systemSuffix: null == systemSuffix
          ? _value.systemSuffix
          : systemSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      userAlignmentMessage: null == userAlignmentMessage
          ? _value.userAlignmentMessage
          : userAlignmentMessage // ignore: cast_nullable_to_non_nullable
              as String,
      systemSameAsUser: null == systemSameAsUser
          ? _value.systemSameAsUser
          : systemSameAsUser // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSystemSequence: null == lastSystemSequence
          ? _value.lastSystemSequence
          : lastSystemSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstInputSequence: null == firstInputSequence
          ? _value.firstInputSequence
          : firstInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastInputSequence: null == lastInputSequence
          ? _value.lastInputSequence
          : lastInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstructTemplateExportImplCopyWith<$Res>
    implements $InstructTemplateExportCopyWith<$Res> {
  factory _$$InstructTemplateExportImplCopyWith(
          _$InstructTemplateExportImpl value,
          $Res Function(_$InstructTemplateExportImpl) then) =
      __$$InstructTemplateExportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'system_prompt') String systemPrompt,
      @JsonKey(name: 'input_sequence') String inputSequence,
      @JsonKey(name: 'output_sequence') String outputSequence,
      @JsonKey(name: 'first_output_sequence') String firstOutputSequence,
      @JsonKey(name: 'last_output_sequence') String lastOutputSequence,
      @JsonKey(name: 'system_sequence') String systemSequence,
      @JsonKey(name: 'stop_sequence') String stopSequence,
      @JsonKey(name: 'separator_sequence') String separatorSequence,
      @JsonKey(name: 'wrap') bool wrap,
      @JsonKey(name: 'macro') bool macro,
      @JsonKey(name: 'names') bool names,
      @JsonKey(name: 'names_force_groups') bool namesForceGroups,
      @JsonKey(name: 'activation_regex') String activationRegex,
      @JsonKey(name: 'skip_examples') bool skipExamples,
      @JsonKey(name: 'output_suffix') String outputSuffix,
      @JsonKey(name: 'input_suffix') String inputSuffix,
      @JsonKey(name: 'system_suffix') String systemSuffix,
      @JsonKey(name: 'user_alignment_message') String userAlignmentMessage,
      @JsonKey(name: 'system_same_as_user') bool systemSameAsUser,
      @JsonKey(name: 'last_system_sequence') String lastSystemSequence,
      @JsonKey(name: 'first_input_sequence') String firstInputSequence,
      @JsonKey(name: 'last_input_sequence') String lastInputSequence});
}

/// @nodoc
class __$$InstructTemplateExportImplCopyWithImpl<$Res>
    extends _$InstructTemplateExportCopyWithImpl<$Res,
        _$InstructTemplateExportImpl>
    implements _$$InstructTemplateExportImplCopyWith<$Res> {
  __$$InstructTemplateExportImplCopyWithImpl(
      _$InstructTemplateExportImpl _value,
      $Res Function(_$InstructTemplateExportImpl) _then)
      : super(_value, _then);

  /// Create a copy of InstructTemplateExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? systemPrompt = null,
    Object? inputSequence = null,
    Object? outputSequence = null,
    Object? firstOutputSequence = null,
    Object? lastOutputSequence = null,
    Object? systemSequence = null,
    Object? stopSequence = null,
    Object? separatorSequence = null,
    Object? wrap = null,
    Object? macro = null,
    Object? names = null,
    Object? namesForceGroups = null,
    Object? activationRegex = null,
    Object? skipExamples = null,
    Object? outputSuffix = null,
    Object? inputSuffix = null,
    Object? systemSuffix = null,
    Object? userAlignmentMessage = null,
    Object? systemSameAsUser = null,
    Object? lastSystemSequence = null,
    Object? firstInputSequence = null,
    Object? lastInputSequence = null,
  }) {
    return _then(_$InstructTemplateExportImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      systemPrompt: null == systemPrompt
          ? _value.systemPrompt
          : systemPrompt // ignore: cast_nullable_to_non_nullable
              as String,
      inputSequence: null == inputSequence
          ? _value.inputSequence
          : inputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      outputSequence: null == outputSequence
          ? _value.outputSequence
          : outputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstOutputSequence: null == firstOutputSequence
          ? _value.firstOutputSequence
          : firstOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastOutputSequence: null == lastOutputSequence
          ? _value.lastOutputSequence
          : lastOutputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      systemSequence: null == systemSequence
          ? _value.systemSequence
          : systemSequence // ignore: cast_nullable_to_non_nullable
              as String,
      stopSequence: null == stopSequence
          ? _value.stopSequence
          : stopSequence // ignore: cast_nullable_to_non_nullable
              as String,
      separatorSequence: null == separatorSequence
          ? _value.separatorSequence
          : separatorSequence // ignore: cast_nullable_to_non_nullable
              as String,
      wrap: null == wrap
          ? _value.wrap
          : wrap // ignore: cast_nullable_to_non_nullable
              as bool,
      macro: null == macro
          ? _value.macro
          : macro // ignore: cast_nullable_to_non_nullable
              as bool,
      names: null == names
          ? _value.names
          : names // ignore: cast_nullable_to_non_nullable
              as bool,
      namesForceGroups: null == namesForceGroups
          ? _value.namesForceGroups
          : namesForceGroups // ignore: cast_nullable_to_non_nullable
              as bool,
      activationRegex: null == activationRegex
          ? _value.activationRegex
          : activationRegex // ignore: cast_nullable_to_non_nullable
              as String,
      skipExamples: null == skipExamples
          ? _value.skipExamples
          : skipExamples // ignore: cast_nullable_to_non_nullable
              as bool,
      outputSuffix: null == outputSuffix
          ? _value.outputSuffix
          : outputSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      inputSuffix: null == inputSuffix
          ? _value.inputSuffix
          : inputSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      systemSuffix: null == systemSuffix
          ? _value.systemSuffix
          : systemSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      userAlignmentMessage: null == userAlignmentMessage
          ? _value.userAlignmentMessage
          : userAlignmentMessage // ignore: cast_nullable_to_non_nullable
              as String,
      systemSameAsUser: null == systemSameAsUser
          ? _value.systemSameAsUser
          : systemSameAsUser // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSystemSequence: null == lastSystemSequence
          ? _value.lastSystemSequence
          : lastSystemSequence // ignore: cast_nullable_to_non_nullable
              as String,
      firstInputSequence: null == firstInputSequence
          ? _value.firstInputSequence
          : firstInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
      lastInputSequence: null == lastInputSequence
          ? _value.lastInputSequence
          : lastInputSequence // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InstructTemplateExportImpl implements _InstructTemplateExport {
  const _$InstructTemplateExportImpl(
      {required this.name,
      @JsonKey(name: 'system_prompt') this.systemPrompt = '',
      @JsonKey(name: 'input_sequence') this.inputSequence = '',
      @JsonKey(name: 'output_sequence') this.outputSequence = '',
      @JsonKey(name: 'first_output_sequence') this.firstOutputSequence = '',
      @JsonKey(name: 'last_output_sequence') this.lastOutputSequence = '',
      @JsonKey(name: 'system_sequence') this.systemSequence = '',
      @JsonKey(name: 'stop_sequence') this.stopSequence = '',
      @JsonKey(name: 'separator_sequence') this.separatorSequence = '',
      @JsonKey(name: 'wrap') this.wrap = true,
      @JsonKey(name: 'macro') this.macro = true,
      @JsonKey(name: 'names') this.names = false,
      @JsonKey(name: 'names_force_groups') this.namesForceGroups = true,
      @JsonKey(name: 'activation_regex') this.activationRegex = '',
      @JsonKey(name: 'skip_examples') this.skipExamples = false,
      @JsonKey(name: 'output_suffix') this.outputSuffix = '',
      @JsonKey(name: 'input_suffix') this.inputSuffix = '',
      @JsonKey(name: 'system_suffix') this.systemSuffix = '',
      @JsonKey(name: 'user_alignment_message') this.userAlignmentMessage = '',
      @JsonKey(name: 'system_same_as_user') this.systemSameAsUser = false,
      @JsonKey(name: 'last_system_sequence') this.lastSystemSequence = '',
      @JsonKey(name: 'first_input_sequence') this.firstInputSequence = '',
      @JsonKey(name: 'last_input_sequence') this.lastInputSequence = ''});

  factory _$InstructTemplateExportImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstructTemplateExportImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'system_prompt')
  final String systemPrompt;
  @override
  @JsonKey(name: 'input_sequence')
  final String inputSequence;
  @override
  @JsonKey(name: 'output_sequence')
  final String outputSequence;
  @override
  @JsonKey(name: 'first_output_sequence')
  final String firstOutputSequence;
  @override
  @JsonKey(name: 'last_output_sequence')
  final String lastOutputSequence;
  @override
  @JsonKey(name: 'system_sequence')
  final String systemSequence;
  @override
  @JsonKey(name: 'stop_sequence')
  final String stopSequence;
  @override
  @JsonKey(name: 'separator_sequence')
  final String separatorSequence;
  @override
  @JsonKey(name: 'wrap')
  final bool wrap;
  @override
  @JsonKey(name: 'macro')
  final bool macro;
  @override
  @JsonKey(name: 'names')
  final bool names;
  @override
  @JsonKey(name: 'names_force_groups')
  final bool namesForceGroups;
  @override
  @JsonKey(name: 'activation_regex')
  final String activationRegex;
  @override
  @JsonKey(name: 'skip_examples')
  final bool skipExamples;
  @override
  @JsonKey(name: 'output_suffix')
  final String outputSuffix;
  @override
  @JsonKey(name: 'input_suffix')
  final String inputSuffix;
  @override
  @JsonKey(name: 'system_suffix')
  final String systemSuffix;
  @override
  @JsonKey(name: 'user_alignment_message')
  final String userAlignmentMessage;
  @override
  @JsonKey(name: 'system_same_as_user')
  final bool systemSameAsUser;
  @override
  @JsonKey(name: 'last_system_sequence')
  final String lastSystemSequence;
  @override
  @JsonKey(name: 'first_input_sequence')
  final String firstInputSequence;
  @override
  @JsonKey(name: 'last_input_sequence')
  final String lastInputSequence;

  @override
  String toString() {
    return 'InstructTemplateExport(name: $name, systemPrompt: $systemPrompt, inputSequence: $inputSequence, outputSequence: $outputSequence, firstOutputSequence: $firstOutputSequence, lastOutputSequence: $lastOutputSequence, systemSequence: $systemSequence, stopSequence: $stopSequence, separatorSequence: $separatorSequence, wrap: $wrap, macro: $macro, names: $names, namesForceGroups: $namesForceGroups, activationRegex: $activationRegex, skipExamples: $skipExamples, outputSuffix: $outputSuffix, inputSuffix: $inputSuffix, systemSuffix: $systemSuffix, userAlignmentMessage: $userAlignmentMessage, systemSameAsUser: $systemSameAsUser, lastSystemSequence: $lastSystemSequence, firstInputSequence: $firstInputSequence, lastInputSequence: $lastInputSequence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstructTemplateExportImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.systemPrompt, systemPrompt) ||
                other.systemPrompt == systemPrompt) &&
            (identical(other.inputSequence, inputSequence) ||
                other.inputSequence == inputSequence) &&
            (identical(other.outputSequence, outputSequence) ||
                other.outputSequence == outputSequence) &&
            (identical(other.firstOutputSequence, firstOutputSequence) ||
                other.firstOutputSequence == firstOutputSequence) &&
            (identical(other.lastOutputSequence, lastOutputSequence) ||
                other.lastOutputSequence == lastOutputSequence) &&
            (identical(other.systemSequence, systemSequence) ||
                other.systemSequence == systemSequence) &&
            (identical(other.stopSequence, stopSequence) ||
                other.stopSequence == stopSequence) &&
            (identical(other.separatorSequence, separatorSequence) ||
                other.separatorSequence == separatorSequence) &&
            (identical(other.wrap, wrap) || other.wrap == wrap) &&
            (identical(other.macro, macro) || other.macro == macro) &&
            (identical(other.names, names) || other.names == names) &&
            (identical(other.namesForceGroups, namesForceGroups) ||
                other.namesForceGroups == namesForceGroups) &&
            (identical(other.activationRegex, activationRegex) ||
                other.activationRegex == activationRegex) &&
            (identical(other.skipExamples, skipExamples) ||
                other.skipExamples == skipExamples) &&
            (identical(other.outputSuffix, outputSuffix) ||
                other.outputSuffix == outputSuffix) &&
            (identical(other.inputSuffix, inputSuffix) ||
                other.inputSuffix == inputSuffix) &&
            (identical(other.systemSuffix, systemSuffix) ||
                other.systemSuffix == systemSuffix) &&
            (identical(other.userAlignmentMessage, userAlignmentMessage) ||
                other.userAlignmentMessage == userAlignmentMessage) &&
            (identical(other.systemSameAsUser, systemSameAsUser) ||
                other.systemSameAsUser == systemSameAsUser) &&
            (identical(other.lastSystemSequence, lastSystemSequence) ||
                other.lastSystemSequence == lastSystemSequence) &&
            (identical(other.firstInputSequence, firstInputSequence) ||
                other.firstInputSequence == firstInputSequence) &&
            (identical(other.lastInputSequence, lastInputSequence) ||
                other.lastInputSequence == lastInputSequence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        systemPrompt,
        inputSequence,
        outputSequence,
        firstOutputSequence,
        lastOutputSequence,
        systemSequence,
        stopSequence,
        separatorSequence,
        wrap,
        macro,
        names,
        namesForceGroups,
        activationRegex,
        skipExamples,
        outputSuffix,
        inputSuffix,
        systemSuffix,
        userAlignmentMessage,
        systemSameAsUser,
        lastSystemSequence,
        firstInputSequence,
        lastInputSequence
      ]);

  /// Create a copy of InstructTemplateExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstructTemplateExportImplCopyWith<_$InstructTemplateExportImpl>
      get copyWith => __$$InstructTemplateExportImplCopyWithImpl<
          _$InstructTemplateExportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstructTemplateExportImplToJson(
      this,
    );
  }
}

abstract class _InstructTemplateExport implements InstructTemplateExport {
  const factory _InstructTemplateExport(
      {required final String name,
      @JsonKey(name: 'system_prompt') final String systemPrompt,
      @JsonKey(name: 'input_sequence') final String inputSequence,
      @JsonKey(name: 'output_sequence') final String outputSequence,
      @JsonKey(name: 'first_output_sequence') final String firstOutputSequence,
      @JsonKey(name: 'last_output_sequence') final String lastOutputSequence,
      @JsonKey(name: 'system_sequence') final String systemSequence,
      @JsonKey(name: 'stop_sequence') final String stopSequence,
      @JsonKey(name: 'separator_sequence') final String separatorSequence,
      @JsonKey(name: 'wrap') final bool wrap,
      @JsonKey(name: 'macro') final bool macro,
      @JsonKey(name: 'names') final bool names,
      @JsonKey(name: 'names_force_groups') final bool namesForceGroups,
      @JsonKey(name: 'activation_regex') final String activationRegex,
      @JsonKey(name: 'skip_examples') final bool skipExamples,
      @JsonKey(name: 'output_suffix') final String outputSuffix,
      @JsonKey(name: 'input_suffix') final String inputSuffix,
      @JsonKey(name: 'system_suffix') final String systemSuffix,
      @JsonKey(name: 'user_alignment_message')
      final String userAlignmentMessage,
      @JsonKey(name: 'system_same_as_user') final bool systemSameAsUser,
      @JsonKey(name: 'last_system_sequence') final String lastSystemSequence,
      @JsonKey(name: 'first_input_sequence') final String firstInputSequence,
      @JsonKey(name: 'last_input_sequence')
      final String lastInputSequence}) = _$InstructTemplateExportImpl;

  factory _InstructTemplateExport.fromJson(Map<String, dynamic> json) =
      _$InstructTemplateExportImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'system_prompt')
  String get systemPrompt;
  @override
  @JsonKey(name: 'input_sequence')
  String get inputSequence;
  @override
  @JsonKey(name: 'output_sequence')
  String get outputSequence;
  @override
  @JsonKey(name: 'first_output_sequence')
  String get firstOutputSequence;
  @override
  @JsonKey(name: 'last_output_sequence')
  String get lastOutputSequence;
  @override
  @JsonKey(name: 'system_sequence')
  String get systemSequence;
  @override
  @JsonKey(name: 'stop_sequence')
  String get stopSequence;
  @override
  @JsonKey(name: 'separator_sequence')
  String get separatorSequence;
  @override
  @JsonKey(name: 'wrap')
  bool get wrap;
  @override
  @JsonKey(name: 'macro')
  bool get macro;
  @override
  @JsonKey(name: 'names')
  bool get names;
  @override
  @JsonKey(name: 'names_force_groups')
  bool get namesForceGroups;
  @override
  @JsonKey(name: 'activation_regex')
  String get activationRegex;
  @override
  @JsonKey(name: 'skip_examples')
  bool get skipExamples;
  @override
  @JsonKey(name: 'output_suffix')
  String get outputSuffix;
  @override
  @JsonKey(name: 'input_suffix')
  String get inputSuffix;
  @override
  @JsonKey(name: 'system_suffix')
  String get systemSuffix;
  @override
  @JsonKey(name: 'user_alignment_message')
  String get userAlignmentMessage;
  @override
  @JsonKey(name: 'system_same_as_user')
  bool get systemSameAsUser;
  @override
  @JsonKey(name: 'last_system_sequence')
  String get lastSystemSequence;
  @override
  @JsonKey(name: 'first_input_sequence')
  String get firstInputSequence;
  @override
  @JsonKey(name: 'last_input_sequence')
  String get lastInputSequence;

  /// Create a copy of InstructTemplateExport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstructTemplateExportImplCopyWith<_$InstructTemplateExportImpl>
      get copyWith => throw _privateConstructorUsedError;
}
