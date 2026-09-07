import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:native_tavern/domain/services/ai_data_sharing_consent_service.dart';
import 'package:native_tavern/domain/services/external_call_audit_service.dart';
import 'package:native_tavern/domain/services/voice_adapter_contract.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as speech;

enum STTProvider {
  system('system', 'System STT'),
  elevenLabs('elevenlabs', 'ElevenLabs'),
  openAICompatible('openai_compatible', 'OAI Compatible'),
  selfHosted('self_hosted', 'Self-hosted'),
  ;

  const STTProvider(this.id, this.displayName);

  final String id;
  final String displayName;

  bool get isRemote => this != STTProvider.system;

  static STTProvider? fromId(String id) {
    // Older builds stored the unfinished provider as "whisper".
    if (id == 'whisper' || id == 'azure') return STTProvider.openAICompatible;
    for (final provider in values) {
      if (provider.id == id) return provider;
    }
    return null;
  }
}

@immutable
class STTSettings {
  const STTSettings({
    this.enabled = false,
    this.provider = STTProvider.system,
    this.language = 'en-US',
    this.continuousListening = false,
    this.autoSend = false,
    this.showPartialResults = true,
    this.apiKey,
    this.apiEndpoint,
    this.model,
    this.requestTimeout = defaultVoiceRequestTimeout,
  });

  final bool enabled;
  final STTProvider provider;
  final String language;
  final bool continuousListening;
  final bool autoSend;
  final bool showPartialResults;
  final String? apiKey;
  final String? apiEndpoint;
  final String? model;
  final Duration requestTimeout;

  bool get isConfigured {
    final endpoint = Uri.tryParse(effectiveEndpoint);
    final hasValidEndpoint = endpoint != null &&
        (endpoint.scheme == 'http' || endpoint.scheme == 'https') &&
        endpoint.host.isNotEmpty;
    switch (provider) {
      case STTProvider.system:
        return true;
      case STTProvider.elevenLabs:
      case STTProvider.openAICompatible:
        return hasValidEndpoint && apiKey?.trim().isNotEmpty == true;
      case STTProvider.selfHosted:
        return hasValidEndpoint;
    }
  }

  String get effectiveEndpoint {
    final configured = apiEndpoint?.trim();
    if (configured?.isNotEmpty == true) return configured!;
    return switch (provider) {
      STTProvider.elevenLabs => 'https://api.elevenlabs.io',
      STTProvider.openAICompatible => 'https://api.openai.com/v1',
      _ => '',
    };
  }

  STTSettings copyWith({
    bool? enabled,
    STTProvider? provider,
    String? language,
    bool? continuousListening,
    bool? autoSend,
    bool? showPartialResults,
    String? apiKey,
    String? apiEndpoint,
    String? model,
    Duration? requestTimeout,
  }) {
    return STTSettings(
      enabled: enabled ?? this.enabled,
      provider: provider ?? this.provider,
      language: language ?? this.language,
      continuousListening: continuousListening ?? this.continuousListening,
      autoSend: autoSend ?? this.autoSend,
      showPartialResults: showPartialResults ?? this.showPartialResults,
      apiKey: apiKey ?? this.apiKey,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
      model: model ?? this.model,
      requestTimeout: requestTimeout ?? this.requestTimeout,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'provider': provider.id,
        'language': language,
        'continuousListening': continuousListening,
        'autoSend': autoSend,
        'showPartialResults': showPartialResults,
        'apiKey': apiKey,
        'apiEndpoint': apiEndpoint,
        'model': model,
        'requestTimeoutSeconds': requestTimeout.inSeconds,
      };

  factory STTSettings.fromJson(Map<String, dynamic> json) => STTSettings(
        enabled: json['enabled'] as bool? ?? false,
        provider: STTProvider.fromId(json['provider'] as String? ?? 'system') ??
            STTProvider.system,
        language: json['language'] as String? ?? 'en-US',
        continuousListening: json['continuousListening'] as bool? ?? false,
        autoSend: json['autoSend'] as bool? ?? false,
        showPartialResults: json['showPartialResults'] as bool? ?? true,
        apiKey: json['apiKey'] as String?,
        apiEndpoint: json['apiEndpoint'] as String?,
        model: json['model'] as String?,
        requestTimeout: Duration(
          seconds: json['requestTimeoutSeconds'] as int? ??
              defaultVoiceRequestTimeout.inSeconds,
        ),
      );
}

class STTLanguage {
  const STTLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  final String code;
  final String name;
  final String nativeName;

  static const List<STTLanguage> supportedLanguages = [
    STTLanguage(code: 'en-US', name: 'English (US)', nativeName: 'English'),
    STTLanguage(code: 'en-GB', name: 'English (UK)', nativeName: 'English'),
    STTLanguage(code: 'es-ES', name: 'Spanish (Spain)', nativeName: 'Español'),
    STTLanguage(code: 'es-MX', name: 'Spanish (Mexico)', nativeName: 'Español'),
    STTLanguage(code: 'fr-FR', name: 'French', nativeName: 'Français'),
    STTLanguage(code: 'de-DE', name: 'German', nativeName: 'Deutsch'),
    STTLanguage(code: 'it-IT', name: 'Italian', nativeName: 'Italiano'),
    STTLanguage(
      code: 'pt-BR',
      name: 'Portuguese (Brazil)',
      nativeName: 'Português',
    ),
    STTLanguage(
      code: 'pt-PT',
      name: 'Portuguese (Portugal)',
      nativeName: 'Português',
    ),
    STTLanguage(code: 'ru-RU', name: 'Russian', nativeName: 'Русский'),
    STTLanguage(code: 'ja-JP', name: 'Japanese', nativeName: '日本語'),
    STTLanguage(code: 'ko-KR', name: 'Korean', nativeName: '한국어'),
    STTLanguage(
      code: 'zh-CN',
      name: 'Chinese (Simplified)',
      nativeName: '简体中文',
    ),
    STTLanguage(
      code: 'zh-TW',
      name: 'Chinese (Traditional)',
      nativeName: '繁體中文',
    ),
    STTLanguage(code: 'ar-SA', name: 'Arabic', nativeName: 'العربية'),
    STTLanguage(code: 'hi-IN', name: 'Hindi', nativeName: 'हिन्दी'),
  ];

  static STTLanguage? fromCode(String code) {
    for (final language in supportedLanguages) {
      if (language.code == code) return language;
    }
    return null;
  }
}

@immutable
class STTResult {
  const STTResult({
    required this.text,
    this.isFinal = false,
    this.confidence = 1,
  });

  final String text;
  final bool isFinal;
  final double confidence;

  STTResult asFinal() => STTResult(
        text: text,
        isFinal: true,
        confidence: confidence,
      );
}

enum STTSessionPhase {
  idle,
  requestingPermission,
  listening,
  processing,
  completed,
  cancelled,
  failed,
  unavailable,
  permissionDenied,
  permissionPermanentlyDenied,
}

@immutable
class STTSessionState {
  const STTSessionState({
    this.sessionId,
    this.phase = STTSessionPhase.idle,
    this.result,
    this.errorKind,
    this.message,
    this.sequence = 0,
  });

  final int? sessionId;
  final STTSessionPhase phase;
  final STTResult? result;
  final VoiceAdapterErrorKind? errorKind;
  final String? message;
  final int sequence;

  bool get isActive =>
      phase == STTSessionPhase.requestingPermission ||
      phase == STTSessionPhase.listening ||
      phase == STTSessionPhase.processing;

  STTSessionState copyWith({
    int? sessionId,
    STTSessionPhase? phase,
    STTResult? result,
    bool clearResult = false,
    VoiceAdapterErrorKind? errorKind,
    bool clearError = false,
    String? message,
    int? sequence,
  }) {
    return STTSessionState(
      sessionId: sessionId ?? this.sessionId,
      phase: phase ?? this.phase,
      result: clearResult ? null : (result ?? this.result),
      errorKind: clearError ? null : (errorKind ?? this.errorKind),
      message: clearError ? null : (message ?? this.message),
      sequence: sequence ?? this.sequence,
    );
  }
}

enum STTPermissionState { granted, denied, permanentlyDenied, unavailable }

abstract interface class STTPermissionGateway {
  Future<STTPermissionState> check();
  Future<STTPermissionState> request();
  Future<bool> openSettings();
}

class PlatformSTTPermissionGateway implements STTPermissionGateway {
  const PlatformSTTPermissionGateway();

  @override
  Future<STTPermissionState> check() async {
    final micState = _map(await Permission.microphone.status);
    if (micState != STTPermissionState.granted) {
      return micState;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return _map(await Permission.speech.status);
    }
    return STTPermissionState.granted;
  }

  @override
  Future<STTPermissionState> request() async {
    final microphone = await Permission.microphone.request();
    final microphoneState = _map(microphone);
    if (microphoneState != STTPermissionState.granted) {
      return microphoneState;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return _map(await Permission.speech.request());
    }
    return STTPermissionState.granted;
  }

  @override
  Future<bool> openSettings() => openAppSettings();

  STTPermissionState _map(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return STTPermissionState.granted;
    }
    if (status.isPermanentlyDenied) {
      return STTPermissionState.permanentlyDenied;
    }
    if (status.isRestricted) return STTPermissionState.unavailable;
    return STTPermissionState.denied;
  }
}

abstract interface class SystemSTTBackend {
  Future<bool> initialize({
    required ValueChanged<String> onError,
    required ValueChanged<String> onStatus,
  });
  bool get isAvailable;
  Future<void> listen({
    required ValueChanged<STTResult> onResult,
    required String localeId,
    required bool partialResults,
    required bool continuous,
  });
  Future<void> stop();
  Future<void> cancel();
}

class SpeechToTextBackend implements SystemSTTBackend {
  SpeechToTextBackend([speech.SpeechToText? recognizer])
      : _recognizer = recognizer ?? speech.SpeechToText();

  final speech.SpeechToText _recognizer;

  @override
  bool get isAvailable => _recognizer.isAvailable;

  @override
  Future<bool> initialize({
    required ValueChanged<String> onError,
    required ValueChanged<String> onStatus,
  }) {
    return _recognizer.initialize(
      onError: (SpeechRecognitionError error) => onError(error.errorMsg),
      onStatus: onStatus,
    );
  }

  @override
  Future<void> listen({
    required ValueChanged<STTResult> onResult,
    required String localeId,
    required bool partialResults,
    required bool continuous,
  }) async {
    await _recognizer.listen(
      onResult: (SpeechRecognitionResult result) => onResult(
        STTResult(
          text: result.recognizedWords,
          isFinal: result.finalResult,
          confidence: result.confidence > 0 ? result.confidence : 1,
        ),
      ),
      listenOptions: speech.SpeechListenOptions(
        localeId: localeId.replaceAll('-', '_'),
        partialResults: partialResults,
        cancelOnError: true,
        listenMode: continuous
            ? speech.ListenMode.dictation
            : speech.ListenMode.confirmation,
      ),
    );
  }

  @override
  Future<void> stop() => _recognizer.stop();

  @override
  Future<void> cancel() => _recognizer.cancel();
}

abstract interface class STTAudioRecorder {
  Future<void> start();
  Future<String?> stop();
  Future<void> cancel();
  Future<void> dispose();
}

class RecordSTTAudioRecorder implements STTAudioRecorder {
  RecordSTTAudioRecorder([AudioRecorder? recorder])
      : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;

  @override
  Future<void> start() async {
    final directory = await getTemporaryDirectory();
    final path = p.join(
      directory.path,
      'stt_${DateTime.now().microsecondsSinceEpoch}.wav',
    );
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      ),
      path: path,
    );
  }

  @override
  Future<String?> stop() => _recorder.stop();

  @override
  Future<void> cancel() => _recorder.cancel();

  @override
  Future<void> dispose() => _recorder.dispose();
}

abstract interface class RemoteSTTBackend {
  Future<STTResult> transcribe({
    required String audioPath,
    required STTSettings settings,
    required CancelToken cancelToken,
  });
}

class DioRemoteSTTBackend implements RemoteSTTBackend {
  DioRemoteSTTBackend({
    Dio? dio,
    ExternalCallAuditRepository auditRepository =
        const NoopExternalCallAuditRepository(),
    AiDataSharingConsentRepository consentRepository =
        const AllowAllAiDataSharingConsentRepository(),
  }) : _dio = dio ?? Dio() {
    _dio.interceptors.add(
      ExternalCallAuditInterceptor(
        repository: auditRepository,
        capabilityId: 'stt',
        classifyData: (_) => const {ExternalDataType.audio},
        consentRepository: consentRepository,
      ),
    );
  }

  final Dio _dio;

  @override
  Future<STTResult> transcribe({
    required String audioPath,
    required STTSettings settings,
    required CancelToken cancelToken,
  }) async {
    if (!settings.isConfigured) {
      throw const VoiceAdapterException(
        VoiceAdapterErrorKind.configuration,
        'Complete the selected speech-to-text provider configuration',
      );
    }

    try {
      final endpoint =
          settings.effectiveEndpoint.replaceAll(RegExp(r'/+$'), '');
      final file = await MultipartFile.fromFile(
        audioPath,
        filename: p.basename(audioPath),
      );
      late final String url;
      late final Map<String, Object?> headers;
      late final FormData data;
      if (settings.provider == STTProvider.elevenLabs) {
        url = endpoint.endsWith('/v1')
            ? '$endpoint/speech-to-text'
            : '$endpoint/v1/speech-to-text';
        headers = {'xi-api-key': settings.apiKey!.trim()};
        data = FormData.fromMap({
          'file': file,
          'model_id': settings.model?.trim().isNotEmpty == true
              ? settings.model!.trim()
              : 'scribe_v1',
          'language_code': settings.language.split('-').first,
        });
      } else {
        url = endpoint.endsWith('/audio/transcriptions')
            ? endpoint
            : '$endpoint/audio/transcriptions';
        headers = settings.apiKey?.trim().isNotEmpty == true
            ? {'Authorization': 'Bearer ${settings.apiKey!.trim()}'}
            : const {};
        data = FormData.fromMap({
          'file': file,
          'model': settings.model?.trim().isNotEmpty == true
              ? settings.model!.trim()
              : 'whisper-1',
          'language': settings.language.split('-').first,
        });
      }
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: data,
        cancelToken: cancelToken,
        options: voiceRequestOptions(
          headers: headers,
          timeout: settings.requestTimeout,
          contentType: 'multipart/form-data',
        ),
      );
      final text = response.data?['text']?.toString().trim() ?? '';
      if (text.isEmpty) {
        throw const VoiceAdapterException(
          VoiceAdapterErrorKind.service,
          'Speech-to-text provider returned no transcript',
        );
      }
      return STTResult(text: text, isFinal: true);
    } catch (error) {
      throw normalizeVoiceAdapterError(error, operation: 'Transcription');
    }
  }
}

class STTService with WidgetsBindingObserver {
  STTService({
    SystemSTTBackend? systemBackend,
    STTPermissionGateway? permissionGateway,
    STTAudioRecorder? recorder,
    RemoteSTTBackend? remoteBackend,
    Dio? dio,
    ExternalCallAuditRepository auditRepository =
        const NoopExternalCallAuditRepository(),
    AiDataSharingConsentRepository consentRepository =
        const AllowAllAiDataSharingConsentRepository(),
  })  : _systemBackend = systemBackend ?? SpeechToTextBackend(),
        _permissionGateway =
            permissionGateway ?? const PlatformSTTPermissionGateway(),
        _recorder = recorder ?? RecordSTTAudioRecorder(),
        _remoteBackend = remoteBackend ??
            DioRemoteSTTBackend(
              dio: dio,
              auditRepository: auditRepository,
              consentRepository: consentRepository,
            );

  final SystemSTTBackend _systemBackend;
  final STTPermissionGateway _permissionGateway;
  final STTAudioRecorder _recorder;
  final RemoteSTTBackend _remoteBackend;
  final StreamController<STTSessionState> _states =
      StreamController<STTSessionState>.broadcast(sync: true);

  STTSettings _settings = const STTSettings();
  STTSessionState _state = const STTSessionState();
  bool _systemInitialized = false;
  bool _permissionRequestAttempted = false;
  bool _observerRegistered = false;
  bool _disposed = false;
  int _generation = 0;
  int _nextSessionId = 1;
  CancelToken? _remoteCancelToken;

  bool get isInitialized => _systemInitialized;
  bool get isListening => _state.phase == STTSessionPhase.listening;
  bool get permissionRequestAttempted => _permissionRequestAttempted;
  STTSettings get settings => _settings;
  STTSessionState get state => _state;
  Stream<STTSessionState> get states => _states.stream;

  void updateSettings(STTSettings settings) {
    final mustCancel = _state.isActive &&
        (!settings.enabled || settings.provider != _settings.provider);
    _settings = settings;
    if (mustCancel) unawaited(cancelListening());
  }

  Future<bool> hasPermission() async =>
      await _permissionGateway.check() == STTPermissionState.granted;

  Future<bool> openPermissionSettings() => _permissionGateway.openSettings();

  Future<void> initialize() async {
    if (_disposed || _systemInitialized) return;
    final permission = await _requestPermission();
    if (permission != STTPermissionState.granted) {
      _emitPermissionFailure(permission);
      return;
    }
    await _initializeSystemBackend();
  }

  Future<bool> isAvailable() async {
    if (_settings.provider.isRemote) return _settings.isConfigured;
    final permission = await _permissionGateway.check();
    if (permission != STTPermissionState.granted) return true;
    await _initializeSystemBackend();
    return _systemInitialized && _systemBackend.isAvailable;
  }

  Future<void> startListening() async {
    if (_disposed || !_settings.enabled || _state.isActive) return;
    final generation = ++_generation;
    final sessionId = _nextSessionId++;
    _emit(
      STTSessionState(
        sessionId: sessionId,
        phase: STTSessionPhase.requestingPermission,
      ),
    );

    if (_settings.provider.isRemote && !_settings.isConfigured) {
      _emit(
        _state.copyWith(
          phase: STTSessionPhase.failed,
          errorKind: VoiceAdapterErrorKind.configuration,
          message:
              'Complete the selected speech-to-text provider configuration',
        ),
      );
      return;
    }

    final permission = await _requestPermission();
    if (!_isCurrent(generation)) return;
    if (permission != STTPermissionState.granted) {
      _emitPermissionFailure(permission);
      return;
    }

    if (_settings.provider == STTProvider.system) {
      await _startSystemSession(generation);
    } else {
      await _startRemoteSession(generation);
    }
  }

  Future<STTPermissionState> _requestPermission() async {
    _permissionRequestAttempted = true;
    try {
      return await _permissionGateway.request();
    } catch (_) {
      return STTPermissionState.unavailable;
    }
  }

  Future<void> _initializeSystemBackend() async {
    if (_systemInitialized || _disposed) return;
    try {
      _systemInitialized = await _systemBackend.initialize(
        onError: _handleSystemError,
        onStatus: _handleSystemStatus,
      );
      _registerObserver();
    } catch (error) {
      _systemInitialized = false;
      _failUnavailable('Speech recognition unavailable: $error');
    }
  }

  Future<void> _startSystemSession(int generation) async {
    await _initializeSystemBackend();
    if (!_isCurrent(generation)) return;
    if (!_systemInitialized || !_systemBackend.isAvailable) {
      _failUnavailable('Speech recognition is unavailable on this device');
      return;
    }
    try {
      _emit(_state.copyWith(phase: STTSessionPhase.listening));
      await _systemBackend.listen(
        onResult: (result) => _handleSystemResult(result, generation),
        localeId: _settings.language,
        partialResults: _settings.showPartialResults,
        continuous: _settings.continuousListening,
      );
    } catch (error) {
      if (_isCurrent(generation)) {
        _fail(
            normalizeVoiceAdapterError(error, operation: 'Speech recognition'));
      }
    }
  }

  Future<void> _startRemoteSession(int generation) async {
    try {
      await _recorder.start();
      if (!_isCurrent(generation)) {
        await _recorder.cancel();
        return;
      }
      _registerObserver();
      _emit(_state.copyWith(phase: STTSessionPhase.listening));
    } catch (error) {
      if (_isCurrent(generation)) {
        _fail(normalizeVoiceAdapterError(error, operation: 'Audio recording'));
      }
    }
  }

  void _handleSystemResult(STTResult result, int generation) {
    if (!_isCurrent(generation) || !_state.isActive) return;
    _emit(
      _state.copyWith(
        phase: result.isFinal
            ? STTSessionPhase.completed
            : STTSessionPhase.listening,
        result: result,
        clearError: true,
      ),
    );
  }

  void _handleSystemError(String message) {
    if (!_state.isActive) return;
    _fail(
      VoiceAdapterException(
        VoiceAdapterErrorKind.service,
        'Speech recognition failed: $message',
      ),
    );
  }

  void _handleSystemStatus(String status) {
    if (status != 'done' && status != 'notListening') return;
    if (_state.phase == STTSessionPhase.listening ||
        _state.phase == STTSessionPhase.processing) {
      _completeSystemSession();
    }
  }

  Future<void> stopListening() async {
    if (!_state.isActive) return;
    final generation = _generation;
    if (_state.phase == STTSessionPhase.requestingPermission) {
      await cancelListening();
      return;
    }
    _emit(_state.copyWith(phase: STTSessionPhase.processing));
    if (_settings.provider == STTProvider.system) {
      try {
        await _systemBackend.stop();
        if (_isCurrent(generation) &&
            _state.phase == STTSessionPhase.processing) {
          _completeSystemSession();
        }
      } catch (error) {
        if (_isCurrent(generation)) {
          _fail(normalizeVoiceAdapterError(error,
              operation: 'Speech recognition'));
        }
      }
      return;
    }

    String? audioPath;
    CancelToken? requestToken;
    try {
      audioPath = await _recorder.stop();
      if (!_isCurrent(generation)) return;
      if (audioPath == null || audioPath.isEmpty) {
        throw const VoiceAdapterException(
          VoiceAdapterErrorKind.service,
          'Audio recording returned no file',
        );
      }
      requestToken = CancelToken();
      _remoteCancelToken = requestToken;
      final result = await _remoteBackend.transcribe(
        audioPath: audioPath,
        settings: _settings,
        cancelToken: requestToken,
      );
      if (_isCurrent(generation)) {
        _emit(
          _state.copyWith(
            phase: STTSessionPhase.completed,
            result: result.asFinal(),
            clearError: true,
          ),
        );
      }
    } catch (error) {
      if (_isCurrent(generation)) {
        final normalized =
            normalizeVoiceAdapterError(error, operation: 'Transcription');
        if (normalized.kind == VoiceAdapterErrorKind.cancelled) {
          _emit(_state.copyWith(phase: STTSessionPhase.cancelled));
        } else {
          _fail(normalized);
        }
      }
    } finally {
      if (identical(_remoteCancelToken, requestToken)) {
        _remoteCancelToken = null;
      }
      if (audioPath != null) {
        try {
          await File(audioPath).delete();
        } catch (_) {
          // Recorder implementations may own cleanup or use virtual paths.
        }
      }
    }
  }

  void _completeSystemSession() {
    final result = _state.result;
    _emit(
      _state.copyWith(
        phase: STTSessionPhase.completed,
        result: result?.asFinal(),
        clearError: true,
      ),
    );
  }

  Future<void> toggleListening() async {
    if (_state.isActive) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  Future<void> cancelListening() async {
    if (!_state.isActive) return;
    ++_generation;
    _remoteCancelToken?.cancel('Speech input cancelled');
    _emit(
      _state.copyWith(
        phase: STTSessionPhase.cancelled,
        clearResult: true,
        clearError: true,
      ),
    );
    try {
      if (_settings.provider == STTProvider.system) {
        await _systemBackend.cancel();
      } else {
        await _recorder.cancel();
      }
    } catch (_) {
      // Cancellation is terminal even when platform cleanup fails.
    }
  }

  void clearResult() {
    if (_state.isActive) return;
    _emit(const STTSessionState());
  }

  void _emitPermissionFailure(STTPermissionState permission) {
    final phase = switch (permission) {
      STTPermissionState.permanentlyDenied =>
        STTSessionPhase.permissionPermanentlyDenied,
      STTPermissionState.unavailable => STTSessionPhase.unavailable,
      _ => STTSessionPhase.permissionDenied,
    };
    _emit(
      _state.copyWith(
        phase: phase,
        clearResult: true,
        errorKind: permission == STTPermissionState.unavailable
            ? VoiceAdapterErrorKind.unavailable
            : VoiceAdapterErrorKind.service,
        message: switch (permission) {
          STTPermissionState.permanentlyDenied =>
            'Microphone permission is permanently denied',
          STTPermissionState.unavailable =>
            'Speech input is unavailable on this device',
          _ => 'Microphone permission was denied',
        },
      ),
    );
  }

  void _failUnavailable(String message) {
    _emit(
      _state.copyWith(
        phase: STTSessionPhase.unavailable,
        errorKind: VoiceAdapterErrorKind.unavailable,
        message: message,
      ),
    );
  }

  void _fail(VoiceAdapterException error) {
    _emit(
      _state.copyWith(
        phase: STTSessionPhase.failed,
        errorKind: error.kind,
        message: error.message,
      ),
    );
  }

  bool _isCurrent(int generation) => !_disposed && generation == _generation;

  void _registerObserver() {
    if (_observerRegistered) return;
    WidgetsBinding.instance.addObserver(this);
    _observerRegistered = true;
  }

  void _emit(STTSessionState next) {
    if (_disposed) return;
    _state = next.copyWith(sequence: _state.sequence + 1);
    if (!_states.isClosed) _states.add(_state);
  }

  /// Audio route changes are owned by the OS and must not end a valid session.
  void handleAudioRouteChanged() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed && _state.isActive) {
      unawaited(cancelListening());
    }
  }

  void dispose() {
    if (_disposed) return;
    if (_observerRegistered) {
      WidgetsBinding.instance.removeObserver(this);
      _observerRegistered = false;
    }
    if (_state.isActive) unawaited(cancelListening());
    _disposed = true;
    _remoteCancelToken?.cancel('Speech service disposed');
    unawaited(_recorder.dispose());
    unawaited(_states.close());
  }
}
