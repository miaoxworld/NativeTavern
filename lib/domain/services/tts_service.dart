import 'package:flutter/foundation.dart';

/// TTS Provider types
enum TTSProvider {
  system('system', 'System TTS'),
  elevenlabs('elevenlabs', 'ElevenLabs'),
  azure('azure', 'Azure Speech'),
  ;

  final String id;
  final String displayName;

  const TTSProvider(this.id, this.displayName);

  static TTSProvider? fromId(String id) {
    try {
      return TTSProvider.values.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// TTS Voice configuration
class TTSVoice {
  final String id;
  final String name;
  final String? language;
  final String? gender;
  final TTSProvider provider;

  const TTSVoice({
    required this.id,
    required this.name,
    this.language,
    this.gender,
    required this.provider,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'language': language,
        'gender': gender,
        'provider': provider.id,
      };

  factory TTSVoice.fromJson(Map<String, dynamic> json) => TTSVoice(
        id: json['id'] as String,
        name: json['name'] as String,
        language: json['language'] as String?,
        gender: json['gender'] as String?,
        provider: TTSProvider.fromId(json['provider'] as String) ?? TTSProvider.system,
      );
}

/// TTS Settings
class TTSSettings {
  final bool enabled;
  final TTSProvider provider;
  final String? voiceId;
  final double rate;
  final double pitch;
  final double volume;
  final bool autoPlay;
  final bool queueMessages;
  final String? apiKey;
  final String? apiEndpoint;

  const TTSSettings({
    this.enabled = false,
    this.provider = TTSProvider.system,
    this.voiceId,
    this.rate = 1.0,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.autoPlay = false,
    this.queueMessages = true,
    this.apiKey,
    this.apiEndpoint,
  });

  TTSSettings copyWith({
    bool? enabled,
    TTSProvider? provider,
    String? voiceId,
    double? rate,
    double? pitch,
    double? volume,
    bool? autoPlay,
    bool? queueMessages,
    String? apiKey,
    String? apiEndpoint,
  }) {
    return TTSSettings(
      enabled: enabled ?? this.enabled,
      provider: provider ?? this.provider,
      voiceId: voiceId ?? this.voiceId,
      rate: rate ?? this.rate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      autoPlay: autoPlay ?? this.autoPlay,
      queueMessages: queueMessages ?? this.queueMessages,
      apiKey: apiKey ?? this.apiKey,
      apiEndpoint: apiEndpoint ?? this.apiEndpoint,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'provider': provider.id,
        'voiceId': voiceId,
        'rate': rate,
        'pitch': pitch,
        'volume': volume,
        'autoPlay': autoPlay,
        'queueMessages': queueMessages,
        'apiKey': apiKey,
        'apiEndpoint': apiEndpoint,
      };

  factory TTSSettings.fromJson(Map<String, dynamic> json) => TTSSettings(
        enabled: json['enabled'] as bool? ?? false,
        provider: TTSProvider.fromId(json['provider'] as String? ?? 'system') ?? TTSProvider.system,
        voiceId: json['voiceId'] as String?,
        rate: (json['rate'] as num?)?.toDouble() ?? 1.0,
        pitch: (json['pitch'] as num?)?.toDouble() ?? 1.0,
        volume: (json['volume'] as num?)?.toDouble() ?? 1.0,
        autoPlay: json['autoPlay'] as bool? ?? false,
        queueMessages: json['queueMessages'] as bool? ?? true,
        apiKey: json['apiKey'] as String?,
        apiEndpoint: json['apiEndpoint'] as String?,
      );
}

/// Character voice settings
class CharacterVoiceSettings {
  final String characterId;
  final String? voiceId;
  final double? rate;
  final double? pitch;
  final double? volume;

  const CharacterVoiceSettings({
    required this.characterId,
    this.voiceId,
    this.rate,
    this.pitch,
    this.volume,
  });

  Map<String, dynamic> toJson() => {
        'characterId': characterId,
        'voiceId': voiceId,
        'rate': rate,
        'pitch': pitch,
        'volume': volume,
      };

  factory CharacterVoiceSettings.fromJson(Map<String, dynamic> json) => CharacterVoiceSettings(
        characterId: json['characterId'] as String,
        voiceId: json['voiceId'] as String?,
        rate: (json['rate'] as num?)?.toDouble(),
        pitch: (json['pitch'] as num?)?.toDouble(),
        volume: (json['volume'] as num?)?.toDouble(),
      );
}

/// TTS Service for text-to-speech functionality
class TTSService {
  bool _isInitialized = false;
  bool _isSpeaking = false;
  final List<String> _queue = [];
  TTSSettings _settings = const TTSSettings();
  final Map<String, CharacterVoiceSettings> _characterVoices = {};

  /// Available voices (populated after initialization)
  List<TTSVoice> _availableVoices = [];

  /// Callbacks
  VoidCallback? onStart;
  VoidCallback? onComplete;
  VoidCallback? onCancel;
  void Function(String)? onError;

  bool get isInitialized => _isInitialized;
  bool get isSpeaking => _isSpeaking;
  List<TTSVoice> get availableVoices => _availableVoices;
  TTSSettings get settings => _settings;

  /// Initialize the TTS service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // For system TTS, we would use flutter_tts package
      // For now, we'll set up the structure and add actual implementation later
      _availableVoices = _getDefaultVoices();
      _isInitialized = true;
    } catch (e) {
      onError?.call('Failed to initialize TTS: $e');
    }
  }

  /// Get default system voices (placeholder)
  List<TTSVoice> _getDefaultVoices() {
    return [
      const TTSVoice(
        id: 'default',
        name: 'Default',
        language: 'en-US',
        gender: 'neutral',
        provider: TTSProvider.system,
      ),
      const TTSVoice(
        id: 'en-us-female',
        name: 'English (US) Female',
        language: 'en-US',
        gender: 'female',
        provider: TTSProvider.system,
      ),
      const TTSVoice(
        id: 'en-us-male',
        name: 'English (US) Male',
        language: 'en-US',
        gender: 'male',
        provider: TTSProvider.system,
      ),
      const TTSVoice(
        id: 'en-gb-female',
        name: 'English (UK) Female',
        language: 'en-GB',
        gender: 'female',
        provider: TTSProvider.system,
      ),
      const TTSVoice(
        id: 'en-gb-male',
        name: 'English (UK) Male',
        language: 'en-GB',
        gender: 'male',
        provider: TTSProvider.system,
      ),
    ];
  }

  /// Update settings
  void updateSettings(TTSSettings settings) {
    _settings = settings;
  }

  /// Set character voice settings
  void setCharacterVoice(CharacterVoiceSettings voiceSettings) {
    _characterVoices[voiceSettings.characterId] = voiceSettings;
  }

  /// Get character voice settings
  CharacterVoiceSettings? getCharacterVoice(String characterId) {
    return _characterVoices[characterId];
  }

  /// Speak text
  Future<void> speak(String text, {String? characterId}) async {
    if (!_isInitialized || !_settings.enabled) return;
    if (text.isEmpty) return;

    // Clean text for TTS (remove markdown, special characters, etc.)
    final cleanText = _cleanTextForTTS(text);
    if (cleanText.isEmpty) return;

    if (_settings.queueMessages) {
      _queue.add(cleanText);
      if (!_isSpeaking) {
        await _processQueue(characterId: characterId);
      }
    } else {
      await stop();
      await _speakText(cleanText, characterId: characterId);
    }
  }

  /// Process the speech queue
  Future<void> _processQueue({String? characterId}) async {
    while (_queue.isNotEmpty) {
      final text = _queue.removeAt(0);
      await _speakText(text, characterId: characterId);
    }
  }

  /// Actually speak the text
  Future<void> _speakText(String text, {String? characterId}) async {
    _isSpeaking = true;
    onStart?.call();

    try {
      // Get voice settings (character-specific or default)
      final charVoice = characterId != null ? _characterVoices[characterId] : null;
      final voiceId = charVoice?.voiceId ?? _settings.voiceId;
      final rate = charVoice?.rate ?? _settings.rate;
      final pitch = charVoice?.pitch ?? _settings.pitch;
      final volume = charVoice?.volume ?? _settings.volume;

      // Here we would call the actual TTS implementation
      // For now, simulate with a delay
      debugPrint('TTS: Speaking "$text" with voice=$voiceId, rate=$rate, pitch=$pitch, volume=$volume');
      
      // Simulate speech duration based on text length
      final duration = Duration(milliseconds: text.length * 50);
      await Future.delayed(duration);

      onComplete?.call();
    } catch (e) {
      onError?.call('TTS error: $e');
    } finally {
      _isSpeaking = false;
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    _queue.clear();
    if (_isSpeaking) {
      _isSpeaking = false;
      onCancel?.call();
    }
  }

  /// Pause speaking
  Future<void> pause() async {
    // Would pause the current speech
    debugPrint('TTS: Pause');
  }

  /// Resume speaking
  Future<void> resume() async {
    // Would resume the paused speech
    debugPrint('TTS: Resume');
  }

  /// Clean text for TTS
  String _cleanTextForTTS(String text) {
    var cleaned = text;

    // Remove markdown formatting
    cleaned = cleaned.replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1'); // Bold
    cleaned = cleaned.replaceAll(RegExp(r'\*([^*]+)\*'), r'$1'); // Italic
    cleaned = cleaned.replaceAll(RegExp(r'__([^_]+)__'), r'$1'); // Underline
    cleaned = cleaned.replaceAll(RegExp(r'~~([^~]+)~~'), r'$1'); // Strikethrough
    cleaned = cleaned.replaceAll(RegExp(r'`([^`]+)`'), r'$1'); // Code
    cleaned = cleaned.replaceAll(RegExp(r'```[^`]*```'), ''); // Code blocks

    // Remove links but keep text
    cleaned = cleaned.replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1');

    // Remove HTML tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]+>'), '');

    // Remove action markers but keep content
    cleaned = cleaned.replaceAll(RegExp(r'\*([^*]+)\*'), r'$1');

    // Remove multiple spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    // Remove leading/trailing whitespace
    cleaned = cleaned.trim();

    return cleaned;
  }

  /// Preview voice with sample text
  Future<void> previewVoice(String voiceId, {String? sampleText}) async {
    final text = sampleText ?? 'Hello! This is a preview of the selected voice.';
    final originalVoice = _settings.voiceId;
    
    _settings = _settings.copyWith(voiceId: voiceId);
    await _speakText(text);
    _settings = _settings.copyWith(voiceId: originalVoice);
  }

  /// Dispose the service
  void dispose() {
    stop();
    _isInitialized = false;
  }
}