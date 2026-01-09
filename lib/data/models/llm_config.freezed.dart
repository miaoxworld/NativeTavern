// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LLMConfig _$LLMConfigFromJson(Map<String, dynamic> json) {
  return _LLMConfig.fromJson(json);
}

/// @nodoc
mixin _$LLMConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  LLMProvider get provider => throw _privateConstructorUsedError;
  String get endpoint => throw _privateConstructorUsedError;
  String? get apiKey => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  GenerationSettings? get defaultSettings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get modifiedAt => throw _privateConstructorUsedError;

  /// Serializes this LLMConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LLMConfigCopyWith<LLMConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LLMConfigCopyWith<$Res> {
  factory $LLMConfigCopyWith(LLMConfig value, $Res Function(LLMConfig) then) =
      _$LLMConfigCopyWithImpl<$Res, LLMConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      LLMProvider provider,
      String endpoint,
      String? apiKey,
      String? model,
      bool enabled,
      bool isDefault,
      GenerationSettings? defaultSettings,
      DateTime createdAt,
      DateTime modifiedAt});

  $GenerationSettingsCopyWith<$Res>? get defaultSettings;
}

/// @nodoc
class _$LLMConfigCopyWithImpl<$Res, $Val extends LLMConfig>
    implements $LLMConfigCopyWith<$Res> {
  _$LLMConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? endpoint = null,
    Object? apiKey = freezed,
    Object? model = freezed,
    Object? enabled = null,
    Object? isDefault = null,
    Object? defaultSettings = freezed,
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
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as LLMProvider,
      endpoint: null == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultSettings: freezed == defaultSettings
          ? _value.defaultSettings
          : defaultSettings // ignore: cast_nullable_to_non_nullable
              as GenerationSettings?,
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

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GenerationSettingsCopyWith<$Res>? get defaultSettings {
    if (_value.defaultSettings == null) {
      return null;
    }

    return $GenerationSettingsCopyWith<$Res>(_value.defaultSettings!, (value) {
      return _then(_value.copyWith(defaultSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LLMConfigImplCopyWith<$Res>
    implements $LLMConfigCopyWith<$Res> {
  factory _$$LLMConfigImplCopyWith(
          _$LLMConfigImpl value, $Res Function(_$LLMConfigImpl) then) =
      __$$LLMConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      LLMProvider provider,
      String endpoint,
      String? apiKey,
      String? model,
      bool enabled,
      bool isDefault,
      GenerationSettings? defaultSettings,
      DateTime createdAt,
      DateTime modifiedAt});

  @override
  $GenerationSettingsCopyWith<$Res>? get defaultSettings;
}

/// @nodoc
class __$$LLMConfigImplCopyWithImpl<$Res>
    extends _$LLMConfigCopyWithImpl<$Res, _$LLMConfigImpl>
    implements _$$LLMConfigImplCopyWith<$Res> {
  __$$LLMConfigImplCopyWithImpl(
      _$LLMConfigImpl _value, $Res Function(_$LLMConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? endpoint = null,
    Object? apiKey = freezed,
    Object? model = freezed,
    Object? enabled = null,
    Object? isDefault = null,
    Object? defaultSettings = freezed,
    Object? createdAt = null,
    Object? modifiedAt = null,
  }) {
    return _then(_$LLMConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as LLMProvider,
      endpoint: null == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultSettings: freezed == defaultSettings
          ? _value.defaultSettings
          : defaultSettings // ignore: cast_nullable_to_non_nullable
              as GenerationSettings?,
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
class _$LLMConfigImpl implements _LLMConfig {
  const _$LLMConfigImpl(
      {required this.id,
      required this.name,
      required this.provider,
      required this.endpoint,
      this.apiKey,
      this.model,
      this.enabled = true,
      this.isDefault = false,
      this.defaultSettings,
      required this.createdAt,
      required this.modifiedAt});

  factory _$LLMConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LLMConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final LLMProvider provider;
  @override
  final String endpoint;
  @override
  final String? apiKey;
  @override
  final String? model;
  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final GenerationSettings? defaultSettings;
  @override
  final DateTime createdAt;
  @override
  final DateTime modifiedAt;

  @override
  String toString() {
    return 'LLMConfig(id: $id, name: $name, provider: $provider, endpoint: $endpoint, apiKey: $apiKey, model: $model, enabled: $enabled, isDefault: $isDefault, defaultSettings: $defaultSettings, createdAt: $createdAt, modifiedAt: $modifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LLMConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.endpoint, endpoint) ||
                other.endpoint == endpoint) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.defaultSettings, defaultSettings) ||
                other.defaultSettings == defaultSettings) &&
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
      provider,
      endpoint,
      apiKey,
      model,
      enabled,
      isDefault,
      defaultSettings,
      createdAt,
      modifiedAt);

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LLMConfigImplCopyWith<_$LLMConfigImpl> get copyWith =>
      __$$LLMConfigImplCopyWithImpl<_$LLMConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LLMConfigImplToJson(
      this,
    );
  }
}

abstract class _LLMConfig implements LLMConfig {
  const factory _LLMConfig(
      {required final String id,
      required final String name,
      required final LLMProvider provider,
      required final String endpoint,
      final String? apiKey,
      final String? model,
      final bool enabled,
      final bool isDefault,
      final GenerationSettings? defaultSettings,
      required final DateTime createdAt,
      required final DateTime modifiedAt}) = _$LLMConfigImpl;

  factory _LLMConfig.fromJson(Map<String, dynamic> json) =
      _$LLMConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  LLMProvider get provider;
  @override
  String get endpoint;
  @override
  String? get apiKey;
  @override
  String? get model;
  @override
  bool get enabled;
  @override
  bool get isDefault;
  @override
  GenerationSettings? get defaultSettings;
  @override
  DateTime get createdAt;
  @override
  DateTime get modifiedAt;

  /// Create a copy of LLMConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LLMConfigImplCopyWith<_$LLMConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GenerationSettings _$GenerationSettingsFromJson(Map<String, dynamic> json) {
  return _GenerationSettings.fromJson(json);
}

/// @nodoc
mixin _$GenerationSettings {
  double get temperature => throw _privateConstructorUsedError;
  double get topP => throw _privateConstructorUsedError;
  int get topK => throw _privateConstructorUsedError;
  double get minP => throw _privateConstructorUsedError;
  double get typicalP => throw _privateConstructorUsedError;
  double get repetitionPenalty => throw _privateConstructorUsedError;
  double get frequencyPenalty => throw _privateConstructorUsedError;
  double get presencePenalty => throw _privateConstructorUsedError;
  int get maxTokens => throw _privateConstructorUsedError;
  int get contextLength => throw _privateConstructorUsedError;
  List<String> get stopSequences => throw _privateConstructorUsedError;
  bool get stream => throw _privateConstructorUsedError;
  int? get seed =>
      throw _privateConstructorUsedError; // Additional parameters for specific providers
  Map<String, dynamic> get extra => throw _privateConstructorUsedError;

  /// Serializes this GenerationSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenerationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenerationSettingsCopyWith<GenerationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenerationSettingsCopyWith<$Res> {
  factory $GenerationSettingsCopyWith(
          GenerationSettings value, $Res Function(GenerationSettings) then) =
      _$GenerationSettingsCopyWithImpl<$Res, GenerationSettings>;
  @useResult
  $Res call(
      {double temperature,
      double topP,
      int topK,
      double minP,
      double typicalP,
      double repetitionPenalty,
      double frequencyPenalty,
      double presencePenalty,
      int maxTokens,
      int contextLength,
      List<String> stopSequences,
      bool stream,
      int? seed,
      Map<String, dynamic> extra});
}

/// @nodoc
class _$GenerationSettingsCopyWithImpl<$Res, $Val extends GenerationSettings>
    implements $GenerationSettingsCopyWith<$Res> {
  _$GenerationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenerationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? topP = null,
    Object? topK = null,
    Object? minP = null,
    Object? typicalP = null,
    Object? repetitionPenalty = null,
    Object? frequencyPenalty = null,
    Object? presencePenalty = null,
    Object? maxTokens = null,
    Object? contextLength = null,
    Object? stopSequences = null,
    Object? stream = null,
    Object? seed = freezed,
    Object? extra = null,
  }) {
    return _then(_value.copyWith(
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
      topK: null == topK
          ? _value.topK
          : topK // ignore: cast_nullable_to_non_nullable
              as int,
      minP: null == minP
          ? _value.minP
          : minP // ignore: cast_nullable_to_non_nullable
              as double,
      typicalP: null == typicalP
          ? _value.typicalP
          : typicalP // ignore: cast_nullable_to_non_nullable
              as double,
      repetitionPenalty: null == repetitionPenalty
          ? _value.repetitionPenalty
          : repetitionPenalty // ignore: cast_nullable_to_non_nullable
              as double,
      frequencyPenalty: null == frequencyPenalty
          ? _value.frequencyPenalty
          : frequencyPenalty // ignore: cast_nullable_to_non_nullable
              as double,
      presencePenalty: null == presencePenalty
          ? _value.presencePenalty
          : presencePenalty // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      contextLength: null == contextLength
          ? _value.contextLength
          : contextLength // ignore: cast_nullable_to_non_nullable
              as int,
      stopSequences: null == stopSequences
          ? _value.stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stream: null == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as bool,
      seed: freezed == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int?,
      extra: null == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GenerationSettingsImplCopyWith<$Res>
    implements $GenerationSettingsCopyWith<$Res> {
  factory _$$GenerationSettingsImplCopyWith(_$GenerationSettingsImpl value,
          $Res Function(_$GenerationSettingsImpl) then) =
      __$$GenerationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double temperature,
      double topP,
      int topK,
      double minP,
      double typicalP,
      double repetitionPenalty,
      double frequencyPenalty,
      double presencePenalty,
      int maxTokens,
      int contextLength,
      List<String> stopSequences,
      bool stream,
      int? seed,
      Map<String, dynamic> extra});
}

/// @nodoc
class __$$GenerationSettingsImplCopyWithImpl<$Res>
    extends _$GenerationSettingsCopyWithImpl<$Res, _$GenerationSettingsImpl>
    implements _$$GenerationSettingsImplCopyWith<$Res> {
  __$$GenerationSettingsImplCopyWithImpl(_$GenerationSettingsImpl _value,
      $Res Function(_$GenerationSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenerationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? temperature = null,
    Object? topP = null,
    Object? topK = null,
    Object? minP = null,
    Object? typicalP = null,
    Object? repetitionPenalty = null,
    Object? frequencyPenalty = null,
    Object? presencePenalty = null,
    Object? maxTokens = null,
    Object? contextLength = null,
    Object? stopSequences = null,
    Object? stream = null,
    Object? seed = freezed,
    Object? extra = null,
  }) {
    return _then(_$GenerationSettingsImpl(
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
      topK: null == topK
          ? _value.topK
          : topK // ignore: cast_nullable_to_non_nullable
              as int,
      minP: null == minP
          ? _value.minP
          : minP // ignore: cast_nullable_to_non_nullable
              as double,
      typicalP: null == typicalP
          ? _value.typicalP
          : typicalP // ignore: cast_nullable_to_non_nullable
              as double,
      repetitionPenalty: null == repetitionPenalty
          ? _value.repetitionPenalty
          : repetitionPenalty // ignore: cast_nullable_to_non_nullable
              as double,
      frequencyPenalty: null == frequencyPenalty
          ? _value.frequencyPenalty
          : frequencyPenalty // ignore: cast_nullable_to_non_nullable
              as double,
      presencePenalty: null == presencePenalty
          ? _value.presencePenalty
          : presencePenalty // ignore: cast_nullable_to_non_nullable
              as double,
      maxTokens: null == maxTokens
          ? _value.maxTokens
          : maxTokens // ignore: cast_nullable_to_non_nullable
              as int,
      contextLength: null == contextLength
          ? _value.contextLength
          : contextLength // ignore: cast_nullable_to_non_nullable
              as int,
      stopSequences: null == stopSequences
          ? _value._stopSequences
          : stopSequences // ignore: cast_nullable_to_non_nullable
              as List<String>,
      stream: null == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as bool,
      seed: freezed == seed
          ? _value.seed
          : seed // ignore: cast_nullable_to_non_nullable
              as int?,
      extra: null == extra
          ? _value._extra
          : extra // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenerationSettingsImpl implements _GenerationSettings {
  const _$GenerationSettingsImpl(
      {this.temperature = 0.7,
      this.topP = 0.9,
      this.topK = 40,
      this.minP = 0.0,
      this.typicalP = 1.0,
      this.repetitionPenalty = 1.1,
      this.frequencyPenalty = 0.0,
      this.presencePenalty = 0.0,
      this.maxTokens = 512,
      this.contextLength = 4096,
      final List<String> stopSequences = const [],
      this.stream = false,
      this.seed,
      final Map<String, dynamic> extra = const {}})
      : _stopSequences = stopSequences,
        _extra = extra;

  factory _$GenerationSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenerationSettingsImplFromJson(json);

  @override
  @JsonKey()
  final double temperature;
  @override
  @JsonKey()
  final double topP;
  @override
  @JsonKey()
  final int topK;
  @override
  @JsonKey()
  final double minP;
  @override
  @JsonKey()
  final double typicalP;
  @override
  @JsonKey()
  final double repetitionPenalty;
  @override
  @JsonKey()
  final double frequencyPenalty;
  @override
  @JsonKey()
  final double presencePenalty;
  @override
  @JsonKey()
  final int maxTokens;
  @override
  @JsonKey()
  final int contextLength;
  final List<String> _stopSequences;
  @override
  @JsonKey()
  List<String> get stopSequences {
    if (_stopSequences is EqualUnmodifiableListView) return _stopSequences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stopSequences);
  }

  @override
  @JsonKey()
  final bool stream;
  @override
  final int? seed;
// Additional parameters for specific providers
  final Map<String, dynamic> _extra;
// Additional parameters for specific providers
  @override
  @JsonKey()
  Map<String, dynamic> get extra {
    if (_extra is EqualUnmodifiableMapView) return _extra;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extra);
  }

  @override
  String toString() {
    return 'GenerationSettings(temperature: $temperature, topP: $topP, topK: $topK, minP: $minP, typicalP: $typicalP, repetitionPenalty: $repetitionPenalty, frequencyPenalty: $frequencyPenalty, presencePenalty: $presencePenalty, maxTokens: $maxTokens, contextLength: $contextLength, stopSequences: $stopSequences, stream: $stream, seed: $seed, extra: $extra)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerationSettingsImpl &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.topP, topP) || other.topP == topP) &&
            (identical(other.topK, topK) || other.topK == topK) &&
            (identical(other.minP, minP) || other.minP == minP) &&
            (identical(other.typicalP, typicalP) ||
                other.typicalP == typicalP) &&
            (identical(other.repetitionPenalty, repetitionPenalty) ||
                other.repetitionPenalty == repetitionPenalty) &&
            (identical(other.frequencyPenalty, frequencyPenalty) ||
                other.frequencyPenalty == frequencyPenalty) &&
            (identical(other.presencePenalty, presencePenalty) ||
                other.presencePenalty == presencePenalty) &&
            (identical(other.maxTokens, maxTokens) ||
                other.maxTokens == maxTokens) &&
            (identical(other.contextLength, contextLength) ||
                other.contextLength == contextLength) &&
            const DeepCollectionEquality()
                .equals(other._stopSequences, _stopSequences) &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.seed, seed) || other.seed == seed) &&
            const DeepCollectionEquality().equals(other._extra, _extra));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      temperature,
      topP,
      topK,
      minP,
      typicalP,
      repetitionPenalty,
      frequencyPenalty,
      presencePenalty,
      maxTokens,
      contextLength,
      const DeepCollectionEquality().hash(_stopSequences),
      stream,
      seed,
      const DeepCollectionEquality().hash(_extra));

  /// Create a copy of GenerationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerationSettingsImplCopyWith<_$GenerationSettingsImpl> get copyWith =>
      __$$GenerationSettingsImplCopyWithImpl<_$GenerationSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenerationSettingsImplToJson(
      this,
    );
  }
}

abstract class _GenerationSettings implements GenerationSettings {
  const factory _GenerationSettings(
      {final double temperature,
      final double topP,
      final int topK,
      final double minP,
      final double typicalP,
      final double repetitionPenalty,
      final double frequencyPenalty,
      final double presencePenalty,
      final int maxTokens,
      final int contextLength,
      final List<String> stopSequences,
      final bool stream,
      final int? seed,
      final Map<String, dynamic> extra}) = _$GenerationSettingsImpl;

  factory _GenerationSettings.fromJson(Map<String, dynamic> json) =
      _$GenerationSettingsImpl.fromJson;

  @override
  double get temperature;
  @override
  double get topP;
  @override
  int get topK;
  @override
  double get minP;
  @override
  double get typicalP;
  @override
  double get repetitionPenalty;
  @override
  double get frequencyPenalty;
  @override
  double get presencePenalty;
  @override
  int get maxTokens;
  @override
  int get contextLength;
  @override
  List<String> get stopSequences;
  @override
  bool get stream;
  @override
  int? get seed; // Additional parameters for specific providers
  @override
  Map<String, dynamic> get extra;

  /// Create a copy of GenerationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerationSettingsImplCopyWith<_$GenerationSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocalModelConfig _$LocalModelConfigFromJson(Map<String, dynamic> json) {
  return _LocalModelConfig.fromJson(json);
}

/// @nodoc
mixin _$LocalModelConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get contextLength => throw _privateConstructorUsedError;
  int get batchSize => throw _privateConstructorUsedError;
  int get gpuLayers =>
      throw _privateConstructorUsedError; // For Metal/Vulkan acceleration
  int get threads => throw _privateConstructorUsedError;
  bool get useMmap => throw _privateConstructorUsedError;
  bool get useMlock => throw _privateConstructorUsedError;
  String? get chatTemplate => throw _privateConstructorUsedError;
  DateTime? get downloadedAt => throw _privateConstructorUsedError;

  /// Serializes this LocalModelConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocalModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalModelConfigCopyWith<LocalModelConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalModelConfigCopyWith<$Res> {
  factory $LocalModelConfigCopyWith(
          LocalModelConfig value, $Res Function(LocalModelConfig) then) =
      _$LocalModelConfigCopyWithImpl<$Res, LocalModelConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      String filePath,
      int fileSize,
      String? description,
      int contextLength,
      int batchSize,
      int gpuLayers,
      int threads,
      bool useMmap,
      bool useMlock,
      String? chatTemplate,
      DateTime? downloadedAt});
}

/// @nodoc
class _$LocalModelConfigCopyWithImpl<$Res, $Val extends LocalModelConfig>
    implements $LocalModelConfigCopyWith<$Res> {
  _$LocalModelConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? filePath = null,
    Object? fileSize = null,
    Object? description = freezed,
    Object? contextLength = null,
    Object? batchSize = null,
    Object? gpuLayers = null,
    Object? threads = null,
    Object? useMmap = null,
    Object? useMlock = null,
    Object? chatTemplate = freezed,
    Object? downloadedAt = freezed,
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
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contextLength: null == contextLength
          ? _value.contextLength
          : contextLength // ignore: cast_nullable_to_non_nullable
              as int,
      batchSize: null == batchSize
          ? _value.batchSize
          : batchSize // ignore: cast_nullable_to_non_nullable
              as int,
      gpuLayers: null == gpuLayers
          ? _value.gpuLayers
          : gpuLayers // ignore: cast_nullable_to_non_nullable
              as int,
      threads: null == threads
          ? _value.threads
          : threads // ignore: cast_nullable_to_non_nullable
              as int,
      useMmap: null == useMmap
          ? _value.useMmap
          : useMmap // ignore: cast_nullable_to_non_nullable
              as bool,
      useMlock: null == useMlock
          ? _value.useMlock
          : useMlock // ignore: cast_nullable_to_non_nullable
              as bool,
      chatTemplate: freezed == chatTemplate
          ? _value.chatTemplate
          : chatTemplate // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalModelConfigImplCopyWith<$Res>
    implements $LocalModelConfigCopyWith<$Res> {
  factory _$$LocalModelConfigImplCopyWith(_$LocalModelConfigImpl value,
          $Res Function(_$LocalModelConfigImpl) then) =
      __$$LocalModelConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String filePath,
      int fileSize,
      String? description,
      int contextLength,
      int batchSize,
      int gpuLayers,
      int threads,
      bool useMmap,
      bool useMlock,
      String? chatTemplate,
      DateTime? downloadedAt});
}

/// @nodoc
class __$$LocalModelConfigImplCopyWithImpl<$Res>
    extends _$LocalModelConfigCopyWithImpl<$Res, _$LocalModelConfigImpl>
    implements _$$LocalModelConfigImplCopyWith<$Res> {
  __$$LocalModelConfigImplCopyWithImpl(_$LocalModelConfigImpl _value,
      $Res Function(_$LocalModelConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? filePath = null,
    Object? fileSize = null,
    Object? description = freezed,
    Object? contextLength = null,
    Object? batchSize = null,
    Object? gpuLayers = null,
    Object? threads = null,
    Object? useMmap = null,
    Object? useMlock = null,
    Object? chatTemplate = freezed,
    Object? downloadedAt = freezed,
  }) {
    return _then(_$LocalModelConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      contextLength: null == contextLength
          ? _value.contextLength
          : contextLength // ignore: cast_nullable_to_non_nullable
              as int,
      batchSize: null == batchSize
          ? _value.batchSize
          : batchSize // ignore: cast_nullable_to_non_nullable
              as int,
      gpuLayers: null == gpuLayers
          ? _value.gpuLayers
          : gpuLayers // ignore: cast_nullable_to_non_nullable
              as int,
      threads: null == threads
          ? _value.threads
          : threads // ignore: cast_nullable_to_non_nullable
              as int,
      useMmap: null == useMmap
          ? _value.useMmap
          : useMmap // ignore: cast_nullable_to_non_nullable
              as bool,
      useMlock: null == useMlock
          ? _value.useMlock
          : useMlock // ignore: cast_nullable_to_non_nullable
              as bool,
      chatTemplate: freezed == chatTemplate
          ? _value.chatTemplate
          : chatTemplate // ignore: cast_nullable_to_non_nullable
              as String?,
      downloadedAt: freezed == downloadedAt
          ? _value.downloadedAt
          : downloadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalModelConfigImpl implements _LocalModelConfig {
  const _$LocalModelConfigImpl(
      {required this.id,
      required this.name,
      required this.filePath,
      required this.fileSize,
      this.description,
      this.contextLength = 1000000,
      this.batchSize = 512,
      this.gpuLayers = 0,
      this.threads = 4,
      this.useMmap = false,
      this.useMlock = false,
      this.chatTemplate,
      this.downloadedAt});

  factory _$LocalModelConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalModelConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String filePath;
  @override
  final int fileSize;
  @override
  final String? description;
  @override
  @JsonKey()
  final int contextLength;
  @override
  @JsonKey()
  final int batchSize;
  @override
  @JsonKey()
  final int gpuLayers;
// For Metal/Vulkan acceleration
  @override
  @JsonKey()
  final int threads;
  @override
  @JsonKey()
  final bool useMmap;
  @override
  @JsonKey()
  final bool useMlock;
  @override
  final String? chatTemplate;
  @override
  final DateTime? downloadedAt;

  @override
  String toString() {
    return 'LocalModelConfig(id: $id, name: $name, filePath: $filePath, fileSize: $fileSize, description: $description, contextLength: $contextLength, batchSize: $batchSize, gpuLayers: $gpuLayers, threads: $threads, useMmap: $useMmap, useMlock: $useMlock, chatTemplate: $chatTemplate, downloadedAt: $downloadedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalModelConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.contextLength, contextLength) ||
                other.contextLength == contextLength) &&
            (identical(other.batchSize, batchSize) ||
                other.batchSize == batchSize) &&
            (identical(other.gpuLayers, gpuLayers) ||
                other.gpuLayers == gpuLayers) &&
            (identical(other.threads, threads) || other.threads == threads) &&
            (identical(other.useMmap, useMmap) || other.useMmap == useMmap) &&
            (identical(other.useMlock, useMlock) ||
                other.useMlock == useMlock) &&
            (identical(other.chatTemplate, chatTemplate) ||
                other.chatTemplate == chatTemplate) &&
            (identical(other.downloadedAt, downloadedAt) ||
                other.downloadedAt == downloadedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      filePath,
      fileSize,
      description,
      contextLength,
      batchSize,
      gpuLayers,
      threads,
      useMmap,
      useMlock,
      chatTemplate,
      downloadedAt);

  /// Create a copy of LocalModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalModelConfigImplCopyWith<_$LocalModelConfigImpl> get copyWith =>
      __$$LocalModelConfigImplCopyWithImpl<_$LocalModelConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalModelConfigImplToJson(
      this,
    );
  }
}

abstract class _LocalModelConfig implements LocalModelConfig {
  const factory _LocalModelConfig(
      {required final String id,
      required final String name,
      required final String filePath,
      required final int fileSize,
      final String? description,
      final int contextLength,
      final int batchSize,
      final int gpuLayers,
      final int threads,
      final bool useMmap,
      final bool useMlock,
      final String? chatTemplate,
      final DateTime? downloadedAt}) = _$LocalModelConfigImpl;

  factory _LocalModelConfig.fromJson(Map<String, dynamic> json) =
      _$LocalModelConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get filePath;
  @override
  int get fileSize;
  @override
  String? get description;
  @override
  int get contextLength;
  @override
  int get batchSize;
  @override
  int get gpuLayers; // For Metal/Vulkan acceleration
  @override
  int get threads;
  @override
  bool get useMmap;
  @override
  bool get useMlock;
  @override
  String? get chatTemplate;
  @override
  DateTime? get downloadedAt;

  /// Create a copy of LocalModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalModelConfigImplCopyWith<_$LocalModelConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PromptTemplate _$PromptTemplateFromJson(Map<String, dynamic> json) {
  return _PromptTemplate.fromJson(json);
}

/// @nodoc
mixin _$PromptTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get systemPrefix => throw _privateConstructorUsedError;
  String get systemSuffix => throw _privateConstructorUsedError;
  String get userPrefix => throw _privateConstructorUsedError;
  String get userSuffix => throw _privateConstructorUsedError;
  String get assistantPrefix => throw _privateConstructorUsedError;
  String get assistantSuffix => throw _privateConstructorUsedError;
  String get firstMessagePrefix => throw _privateConstructorUsedError;
  String get lastMessageSuffix => throw _privateConstructorUsedError;
  bool get wrapInNewlines => throw _privateConstructorUsedError;

  /// Serializes this PromptTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PromptTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromptTemplateCopyWith<PromptTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptTemplateCopyWith<$Res> {
  factory $PromptTemplateCopyWith(
          PromptTemplate value, $Res Function(PromptTemplate) then) =
      _$PromptTemplateCopyWithImpl<$Res, PromptTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String systemPrefix,
      String systemSuffix,
      String userPrefix,
      String userSuffix,
      String assistantPrefix,
      String assistantSuffix,
      String firstMessagePrefix,
      String lastMessageSuffix,
      bool wrapInNewlines});
}

/// @nodoc
class _$PromptTemplateCopyWithImpl<$Res, $Val extends PromptTemplate>
    implements $PromptTemplateCopyWith<$Res> {
  _$PromptTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromptTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? systemPrefix = null,
    Object? systemSuffix = null,
    Object? userPrefix = null,
    Object? userSuffix = null,
    Object? assistantPrefix = null,
    Object? assistantSuffix = null,
    Object? firstMessagePrefix = null,
    Object? lastMessageSuffix = null,
    Object? wrapInNewlines = null,
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
      firstMessagePrefix: null == firstMessagePrefix
          ? _value.firstMessagePrefix
          : firstMessagePrefix // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageSuffix: null == lastMessageSuffix
          ? _value.lastMessageSuffix
          : lastMessageSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      wrapInNewlines: null == wrapInNewlines
          ? _value.wrapInNewlines
          : wrapInNewlines // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromptTemplateImplCopyWith<$Res>
    implements $PromptTemplateCopyWith<$Res> {
  factory _$$PromptTemplateImplCopyWith(_$PromptTemplateImpl value,
          $Res Function(_$PromptTemplateImpl) then) =
      __$$PromptTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String systemPrefix,
      String systemSuffix,
      String userPrefix,
      String userSuffix,
      String assistantPrefix,
      String assistantSuffix,
      String firstMessagePrefix,
      String lastMessageSuffix,
      bool wrapInNewlines});
}

/// @nodoc
class __$$PromptTemplateImplCopyWithImpl<$Res>
    extends _$PromptTemplateCopyWithImpl<$Res, _$PromptTemplateImpl>
    implements _$$PromptTemplateImplCopyWith<$Res> {
  __$$PromptTemplateImplCopyWithImpl(
      _$PromptTemplateImpl _value, $Res Function(_$PromptTemplateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PromptTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? systemPrefix = null,
    Object? systemSuffix = null,
    Object? userPrefix = null,
    Object? userSuffix = null,
    Object? assistantPrefix = null,
    Object? assistantSuffix = null,
    Object? firstMessagePrefix = null,
    Object? lastMessageSuffix = null,
    Object? wrapInNewlines = null,
  }) {
    return _then(_$PromptTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
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
      firstMessagePrefix: null == firstMessagePrefix
          ? _value.firstMessagePrefix
          : firstMessagePrefix // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessageSuffix: null == lastMessageSuffix
          ? _value.lastMessageSuffix
          : lastMessageSuffix // ignore: cast_nullable_to_non_nullable
              as String,
      wrapInNewlines: null == wrapInNewlines
          ? _value.wrapInNewlines
          : wrapInNewlines // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PromptTemplateImpl implements _PromptTemplate {
  const _$PromptTemplateImpl(
      {required this.id,
      required this.name,
      required this.systemPrefix,
      required this.systemSuffix,
      required this.userPrefix,
      required this.userSuffix,
      required this.assistantPrefix,
      required this.assistantSuffix,
      this.firstMessagePrefix = '',
      this.lastMessageSuffix = '',
      this.wrapInNewlines = false});

  factory _$PromptTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PromptTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String systemPrefix;
  @override
  final String systemSuffix;
  @override
  final String userPrefix;
  @override
  final String userSuffix;
  @override
  final String assistantPrefix;
  @override
  final String assistantSuffix;
  @override
  @JsonKey()
  final String firstMessagePrefix;
  @override
  @JsonKey()
  final String lastMessageSuffix;
  @override
  @JsonKey()
  final bool wrapInNewlines;

  @override
  String toString() {
    return 'PromptTemplate(id: $id, name: $name, systemPrefix: $systemPrefix, systemSuffix: $systemSuffix, userPrefix: $userPrefix, userSuffix: $userSuffix, assistantPrefix: $assistantPrefix, assistantSuffix: $assistantSuffix, firstMessagePrefix: $firstMessagePrefix, lastMessageSuffix: $lastMessageSuffix, wrapInNewlines: $wrapInNewlines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromptTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
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
            (identical(other.firstMessagePrefix, firstMessagePrefix) ||
                other.firstMessagePrefix == firstMessagePrefix) &&
            (identical(other.lastMessageSuffix, lastMessageSuffix) ||
                other.lastMessageSuffix == lastMessageSuffix) &&
            (identical(other.wrapInNewlines, wrapInNewlines) ||
                other.wrapInNewlines == wrapInNewlines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      systemPrefix,
      systemSuffix,
      userPrefix,
      userSuffix,
      assistantPrefix,
      assistantSuffix,
      firstMessagePrefix,
      lastMessageSuffix,
      wrapInNewlines);

  /// Create a copy of PromptTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromptTemplateImplCopyWith<_$PromptTemplateImpl> get copyWith =>
      __$$PromptTemplateImplCopyWithImpl<_$PromptTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PromptTemplateImplToJson(
      this,
    );
  }
}

abstract class _PromptTemplate implements PromptTemplate {
  const factory _PromptTemplate(
      {required final String id,
      required final String name,
      required final String systemPrefix,
      required final String systemSuffix,
      required final String userPrefix,
      required final String userSuffix,
      required final String assistantPrefix,
      required final String assistantSuffix,
      final String firstMessagePrefix,
      final String lastMessageSuffix,
      final bool wrapInNewlines}) = _$PromptTemplateImpl;

  factory _PromptTemplate.fromJson(Map<String, dynamic> json) =
      _$PromptTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get systemPrefix;
  @override
  String get systemSuffix;
  @override
  String get userPrefix;
  @override
  String get userSuffix;
  @override
  String get assistantPrefix;
  @override
  String get assistantSuffix;
  @override
  String get firstMessagePrefix;
  @override
  String get lastMessageSuffix;
  @override
  bool get wrapInNewlines;

  /// Create a copy of PromptTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromptTemplateImplCopyWith<_$PromptTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
