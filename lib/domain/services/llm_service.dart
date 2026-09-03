import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:native_tavern/domain/models/tool_calling.dart';
import 'package:native_tavern/domain/services/ai_data_sharing_consent_service.dart';
import 'package:native_tavern/domain/services/context_window_service.dart';
import 'package:native_tavern/domain/services/external_call_audit_service.dart';
import 'package:native_tavern/domain/services/tool_calling/tool_calling_adapter.dart';

/// LLM Provider enum
enum LLMProvider {
  openAICompatible,
  claude,
  gemini,
  openai,
  deepSeek,
  qwen,
  openRouter,
  ollama,
  lmStudio,
  koboldCpp,
  siliconFlow,
  moonshot,
  zai,
  miniMax,
  xai,
}

extension LLMProviderCapabilities on LLMProvider {
  /// Local OpenAI-compatible or native local servers that do not require a key.
  bool get isLocalServer =>
      this == LLMProvider.ollama ||
      this == LLMProvider.koboldCpp ||
      this == LLMProvider.lmStudio;

  /// LM Studio and custom OpenAI-compatible endpoints speak the Chat Completions API.
  bool get usesOpenAiChatCompletions => switch (this) {
        LLMProvider.openAICompatible ||
        LLMProvider.openai ||
        LLMProvider.deepSeek ||
        LLMProvider.qwen ||
        LLMProvider.openRouter ||
        LLMProvider.siliconFlow ||
        LLMProvider.moonshot ||
        LLMProvider.zai ||
        LLMProvider.miniMax ||
        LLMProvider.xai ||
        LLMProvider.lmStudio =>
          true,
        LLMProvider.claude ||
        LLMProvider.gemini ||
        LLMProvider.ollama ||
        LLMProvider.koboldCpp =>
          false,
      };
}

/// Provider preset for OpenAI and OpenAI-compatible endpoints.
/// Controls parameter inclusion/exclusion across different providers.
enum OpenAIProviderPreset {
  standard,
  compatible,
  openRouter,
  xai;

  /// Resolves the provider preset from the current configuration.
  /// Dual-detects xAI/Grok when provider is xai, OR when apiUrl contains
  /// 'api.x.ai' and model starts with 'grok-'.
  static OpenAIProviderPreset resolve(LLMConfig config) {
    if (config.provider == LLMProvider.xai || _isXaiGrok(config)) {
      return OpenAIProviderPreset.xai;
    }
    if (config.provider == LLMProvider.openRouter) {
      return OpenAIProviderPreset.openRouter;
    }
    if (config.provider == LLMProvider.openai) {
      return OpenAIProviderPreset.standard;
    }
    return OpenAIProviderPreset.compatible;
  }

  static bool _isXaiGrok(LLMConfig config) {
    final host = Uri.tryParse(config.apiUrl)?.host.toLowerCase() ?? '';
    final urlContainsXai = host.contains('api.x.ai') ||
        config.apiUrl.toLowerCase().contains('api.x.ai');
    final modelStartsGrok = config.model.toLowerCase().startsWith('grok-');
    return urlContainsXai && modelStartsGrok;
  }
}

/// LLM Response with content and optional reasoning/thinking
class LLMResponse {
  final String content;
  final String? reasoning;

  const LLMResponse({
    required this.content,
    this.reasoning,
  });

  bool get hasReasoning => reasoning != null && reasoning!.isNotEmpty;
}

/// Stream chunk with content and optional reasoning
class LLMStreamChunk {
  final String? content;
  final String? reasoning;
  final bool isReasoningChunk;

  const LLMStreamChunk({
    this.content,
    this.reasoning,
    this.isReasoningChunk = false,
  });
}

/// Incrementally extracts inline `<think>`-style blocks from streamed text.
///
/// Models like DeepSeek R1 served through OpenAI-compatible/local endpoints
/// embed their chain-of-thought as `<think>...</think>` at the start of the
/// content instead of using a structured reasoning field. This parser splits
/// such blocks out as reasoning so they render in the collapsible reasoning
/// UI instead of the message body.
///
/// Parsing only activates when the first non-whitespace output is an opening
/// tag - a tag appearing mid-message is treated as regular content.
class ThinkTagParser {
  static const List<String> _tagNames = [
    'thinking',
    'think',
    'thought',
    'reasoning',
  ];

  String _buffer = '';
  bool _inThink = false;
  String _activeTag = '';
  bool _decided = false; // Whether we know if this message starts with a tag
  bool _passthrough = false; // No leading tag: emit everything as content

  /// Feed a content delta; returns (content, reasoning) to emit now.
  (String, String) feed(String delta) {
    _buffer += delta;
    final content = StringBuffer();
    final reasoning = StringBuffer();

    while (_buffer.isNotEmpty) {
      if (_passthrough) {
        content.write(_buffer);
        _buffer = '';
        break;
      }

      if (!_decided) {
        // Decide whether the message starts with an opening tag
        final trimmed = _buffer.trimLeft();
        if (trimmed.isEmpty) break; // Only whitespace so far - wait
        String? matchedTag;
        var isPrefix = false;
        for (final tag in _tagNames) {
          final open = '<$tag>';
          if (trimmed.toLowerCase().startsWith(open)) {
            matchedTag = tag;
            break;
          }
          if (open.startsWith(trimmed.toLowerCase())) {
            isPrefix = true;
          }
        }
        if (matchedTag != null) {
          _decided = true;
          _inThink = true;
          _activeTag = matchedTag;
          final tagStart = _buffer.toLowerCase().indexOf('<$matchedTag>');
          _buffer = _buffer.substring(tagStart + matchedTag.length + 2);
          continue;
        }
        if (isPrefix) break; // Could still become a tag - wait for more
        _decided = true;
        _passthrough = true;
        continue;
      }

      if (_inThink) {
        final close = '</$_activeTag>';
        final idx = _buffer.toLowerCase().indexOf(close);
        if (idx >= 0) {
          reasoning.write(_buffer.substring(0, idx));
          _buffer = _buffer.substring(idx + close.length);
          // Drop a single leading newline after the block
          if (_buffer.startsWith('\n')) _buffer = _buffer.substring(1);
          _inThink = false;
          continue;
        }
        // Hold back a possible partial closing tag at the end
        final holdback = _partialSuffixLength(_buffer, close);
        if (_buffer.length > holdback) {
          reasoning.write(_buffer.substring(0, _buffer.length - holdback));
          _buffer = _buffer.substring(_buffer.length - holdback);
        }
        break;
      }

      // After the think block closed: everything is content
      content.write(_buffer);
      _buffer = '';
    }

    return (content.toString(), reasoning.toString());
  }

  /// Flush any held-back text at end of stream.
  (String, String) flush() {
    final rest = _buffer;
    _buffer = '';
    if (rest.isEmpty) return ('', '');
    return _inThink ? ('', rest) : (rest, '');
  }

  /// Length of the longest suffix of [text] that is a prefix of [token]
  int _partialSuffixLength(String text, String token) {
    final max = token.length - 1;
    for (var len = max < text.length ? max : text.length; len > 0; len--) {
      if (token.startsWith(text.substring(text.length - len).toLowerCase())) {
        return len;
      }
    }
    return 0;
  }

  /// Non-streaming variant: extract a leading think block from full text.
  /// Returns (content, reasoning) where reasoning is null if no block found.
  static (String, String?) extract(String text) {
    final match = RegExp(
      r'^\s*<(thinking|think|thought|reasoning)>([\s\S]*?)</\1>\s*',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) return (text, null);
    return (text.substring(match.end), match.group(2)!.trim());
  }
}

/// Incrementally consumes the top-level objects in a streamed JSON array.
///
/// Gemini splits its response at arbitrary byte boundaries. Keeping parsed
/// objects in the input buffer would emit them again whenever the next network
/// chunk arrives, so this decoder removes each object as soon as it completes.
class _GeminiJsonArrayObjectDecoder {
  final StringBuffer _object = StringBuffer();
  var _depth = 0;
  var _capturing = false;
  var _inString = false;
  var _escaped = false;

  Iterable<Map<String, dynamic>> add(String chunk) sync* {
    for (final codeUnit in chunk.codeUnits) {
      if (!_capturing) {
        if (codeUnit != 0x7b) continue; // {
        _capturing = true;
        _depth = 1;
        _object.writeCharCode(codeUnit);
        continue;
      }

      _object.writeCharCode(codeUnit);
      if (_inString) {
        if (_escaped) {
          _escaped = false;
        } else if (codeUnit == 0x5c) {
          _escaped = true;
        } else if (codeUnit == 0x22) {
          _inString = false;
        }
        continue;
      }

      if (codeUnit == 0x22) {
        _inString = true;
      } else if (codeUnit == 0x7b || codeUnit == 0x5b) {
        _depth++;
      } else if (codeUnit == 0x7d || codeUnit == 0x5d) {
        _depth--;
      }

      if (_depth != 0) continue;

      final decoded = jsonDecode(_object.toString());
      _object.clear();
      _capturing = false;
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException(
          'Gemini stream array element must be a JSON object.',
        );
      }
      yield decoded;
    }
  }
}

/// Reasoning effort levels (aligned with SillyTavern's REASONING_EFFORT)
class ReasoningEffort {
  static const String auto = 'auto';
  static const String min = 'min';
  static const String low = 'low';
  static const String medium = 'medium';
  static const String high = 'high';
  static const String max = 'max';

  static const List<String> values = [auto, min, low, medium, high, max];
}

/// LLM Configuration
class LLMConfig {
  final LLMProvider provider;
  final String model;
  final String apiKey;
  final String apiUrl;
  final int maxTokens;
  final int contextLength;
  final double temperature;
  final double topP;
  final int topK;
  final double frequencyPenalty;
  final double presencePenalty;
  final bool streamEnabled;

  // Advanced sampler parameters
  final double typicalP;
  final double minP;
  final double repetitionPenalty;
  final int repetitionPenaltyRange;
  final double tailFreeSampling;
  final double topA;
  final int mirostatMode;
  final double mirostatTau;
  final double mirostatEta;
  final List<String> stopSequences;
  final int seed;

  // Auto-summarization settings
  final bool autoSummarizeEnabled;
  final double autoSummarizeThreshold;

  // Reasoning/thinking effort: auto, min, low, medium, high, max
  final String reasoningEffort;

  // Claude prompt caching: caches system prompt + chat history prefix
  // to cut input token costs on subsequent turns
  final bool promptCacheEnabled;

  // Merge consecutive same-role messages (prompt post-processing).
  // Required by endpoints that enforce strict user/assistant alternation
  // (e.g. deepseek-reasoner and some proxies)
  final bool mergeConsecutiveRoles;

  /// Optional OpenRouter upstream provider. Empty means automatic routing.
  final String openRouterProvider;

  const LLMConfig({
    required this.provider,
    required this.model,
    required this.apiKey,
    required this.apiUrl,
    this.maxTokens = 8192,
    this.contextLength = 1000000,
    this.temperature = 1,
    this.topP = 0.95,
    this.topK = 40,
    this.frequencyPenalty = 0.0,
    this.presencePenalty = 0.0,
    this.streamEnabled = true,
    // Advanced defaults
    this.typicalP = 1.0,
    this.minP = 0.0,
    this.repetitionPenalty = 1.0,
    this.repetitionPenaltyRange = 0,
    this.tailFreeSampling = 1.0,
    this.topA = 0.0,
    this.mirostatMode = 0,
    this.mirostatTau = 5.0,
    this.mirostatEta = 0.1,
    this.stopSequences = const [],
    this.seed = -1,
    // Auto-summarization defaults
    this.autoSummarizeEnabled = true,
    this.autoSummarizeThreshold = 0.8,
    this.reasoningEffort = ReasoningEffort.auto,
    this.promptCacheEnabled = false,
    this.mergeConsecutiveRoles = false,
    this.openRouterProvider = '',
  });

  LLMConfig copyWith({
    LLMProvider? provider,
    String? model,
    String? apiKey,
    String? apiUrl,
    int? maxTokens,
    int? contextLength,
    double? temperature,
    double? topP,
    int? topK,
    double? frequencyPenalty,
    double? presencePenalty,
    bool? streamEnabled,
    double? typicalP,
    double? minP,
    double? repetitionPenalty,
    int? repetitionPenaltyRange,
    double? tailFreeSampling,
    double? topA,
    int? mirostatMode,
    double? mirostatTau,
    double? mirostatEta,
    List<String>? stopSequences,
    int? seed,
    bool? autoSummarizeEnabled,
    double? autoSummarizeThreshold,
    String? reasoningEffort,
    bool? promptCacheEnabled,
    bool? mergeConsecutiveRoles,
    String? openRouterProvider,
  }) {
    return LLMConfig(
      provider: provider ?? this.provider,
      model: model ?? this.model,
      apiKey: apiKey ?? this.apiKey,
      apiUrl: apiUrl ?? this.apiUrl,
      maxTokens: maxTokens ?? this.maxTokens,
      contextLength: contextLength ?? this.contextLength,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      topK: topK ?? this.topK,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      streamEnabled: streamEnabled ?? this.streamEnabled,
      typicalP: typicalP ?? this.typicalP,
      minP: minP ?? this.minP,
      repetitionPenalty: repetitionPenalty ?? this.repetitionPenalty,
      repetitionPenaltyRange:
          repetitionPenaltyRange ?? this.repetitionPenaltyRange,
      tailFreeSampling: tailFreeSampling ?? this.tailFreeSampling,
      topA: topA ?? this.topA,
      mirostatMode: mirostatMode ?? this.mirostatMode,
      mirostatTau: mirostatTau ?? this.mirostatTau,
      mirostatEta: mirostatEta ?? this.mirostatEta,
      stopSequences: stopSequences ?? this.stopSequences,
      seed: seed ?? this.seed,
      autoSummarizeEnabled: autoSummarizeEnabled ?? this.autoSummarizeEnabled,
      autoSummarizeThreshold:
          autoSummarizeThreshold ?? this.autoSummarizeThreshold,
      reasoningEffort: reasoningEffort ?? this.reasoningEffort,
      promptCacheEnabled: promptCacheEnabled ?? this.promptCacheEnabled,
      mergeConsecutiveRoles:
          mergeConsecutiveRoles ?? this.mergeConsecutiveRoles,
      openRouterProvider: openRouterProvider ?? this.openRouterProvider,
    );
  }

  Map<String, dynamic> toJson() => {
        'provider': provider.name,
        'model': model,
        'apiKey': apiKey,
        'apiUrl': apiUrl,
        'maxTokens': maxTokens,
        'contextLength': contextLength,
        'temperature': temperature,
        'topP': topP,
        'topK': topK,
        'frequencyPenalty': frequencyPenalty,
        'presencePenalty': presencePenalty,
        'streamEnabled': streamEnabled,
        'typicalP': typicalP,
        'minP': minP,
        'repetitionPenalty': repetitionPenalty,
        'repetitionPenaltyRange': repetitionPenaltyRange,
        'tailFreeSampling': tailFreeSampling,
        'topA': topA,
        'mirostatMode': mirostatMode,
        'mirostatTau': mirostatTau,
        'mirostatEta': mirostatEta,
        'stopSequences': stopSequences,
        'seed': seed,
        'autoSummarizeEnabled': autoSummarizeEnabled,
        'autoSummarizeThreshold': autoSummarizeThreshold,
        'reasoningEffort': reasoningEffort,
        'promptCacheEnabled': promptCacheEnabled,
        'mergeConsecutiveRoles': mergeConsecutiveRoles,
        'openRouterProvider': openRouterProvider,
      };

  factory LLMConfig.fromJson(Map<String, dynamic> json) => LLMConfig(
        provider: LLMProvider.values.firstWhere(
          (p) => p.name == json['provider'],
          orElse: () => LLMProvider.openai,
        ),
        model: json['model'] as String? ?? 'claude-sonnet-4.5',
        apiKey: json['apiKey'] as String? ?? '',
        apiUrl: json['apiUrl'] as String? ?? 'https://api.openai.com/v1',
        maxTokens: json['maxTokens'] as int? ?? 8192,
        contextLength: json['contextLength'] as int? ?? 1000000,
        temperature: (json['temperature'] as num?)?.toDouble() ?? 0.8,
        topP: (json['topP'] as num?)?.toDouble() ?? 0.95,
        topK: json['topK'] as int? ?? 40,
        frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble() ?? 0.0,
        presencePenalty: (json['presencePenalty'] as num?)?.toDouble() ?? 0.0,
        streamEnabled: json['streamEnabled'] as bool? ?? true,
        typicalP: (json['typicalP'] as num?)?.toDouble() ?? 1.0,
        minP: (json['minP'] as num?)?.toDouble() ?? 0.0,
        repetitionPenalty:
            (json['repetitionPenalty'] as num?)?.toDouble() ?? 1.0,
        repetitionPenaltyRange: json['repetitionPenaltyRange'] as int? ?? 0,
        tailFreeSampling: (json['tailFreeSampling'] as num?)?.toDouble() ?? 1.0,
        topA: (json['topA'] as num?)?.toDouble() ?? 0.0,
        mirostatMode: json['mirostatMode'] as int? ?? 0,
        mirostatTau: (json['mirostatTau'] as num?)?.toDouble() ?? 5.0,
        mirostatEta: (json['mirostatEta'] as num?)?.toDouble() ?? 0.1,
        stopSequences:
            (json['stopSequences'] as List<dynamic>?)?.cast<String>() ??
                const [],
        seed: json['seed'] as int? ?? -1,
        autoSummarizeEnabled: json['autoSummarizeEnabled'] as bool? ?? true,
        autoSummarizeThreshold:
            (json['autoSummarizeThreshold'] as num?)?.toDouble() ?? 0.8,
        reasoningEffort:
            json['reasoningEffort'] as String? ?? ReasoningEffort.auto,
        promptCacheEnabled: json['promptCacheEnabled'] as bool? ?? false,
        mergeConsecutiveRoles: json['mergeConsecutiveRoles'] as bool? ?? false,
        openRouterProvider: json['openRouterProvider'] as String? ?? '',
      );
}

/// LLM Service for generating responses
class LLMService {
  final Dio _dio;
  final ContextWindowService _contextWindowService = ContextWindowService();

  LLMService({
    Dio? dio,
    ExternalCallAuditRepository auditRepository =
        const NoopExternalCallAuditRepository(),
    AiDataSharingConsentRepository consentRepository =
        const AllowAllAiDataSharingConsentRepository(),
  }) : _dio = dio ?? Dio() {
    _dio.interceptors.add(ExternalCallAuditInterceptor(
      repository: auditRepository,
      capabilityId: 'llm',
      classifyData: (request) => metadataForGet(
        request,
        const {ExternalDataType.prompt, ExternalDataType.chatText},
      ),
      consentRepository: consentRepository,
    ));
  }

  /// Token for the in-flight request so cancellation actually aborts the
  /// HTTP connection (stops server-side generation/billing) instead of
  /// just abandoning the local stream
  CancelToken? _cancelToken;

  CancelToken _newCancelToken() {
    _cancelToken = CancelToken();
    return _cancelToken!;
  }

  bool _isGroqCompound(LLMConfig config) {
    final host = Uri.tryParse(config.apiUrl)?.host.toLowerCase();
    return host == 'api.groq.com' &&
        config.model.toLowerCase().contains('compound');
  }

  List<Map<String, dynamic>> _prepareOpenAIMessages(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) {
    if (!_isGroqCompound(config) ||
        messages.isEmpty ||
        messages.last['role'] != 'assistant') {
      return messages;
    }

    return [
      ...messages,
      const {'role': 'user', 'content': 'Continue.'},
    ];
  }

  /// Abort the current request, if any
  void cancelActiveRequest() {
    final token = _cancelToken;
    if (token != null && !token.isCancelled) {
      token.cancel('Cancelled by user');
    }
  }

  /// Executes one non-streaming provider turn with native tool calling.
  /// Provider-native assistant messages are returned unchanged so signatures
  /// and tool-call identities can be replayed on the next round.
  Future<ToolProviderTurn> generateToolTurn({
    required List<Map<String, dynamic>> baseMessages,
    required List<Map<String, dynamic>> continuationMessages,
    required LLMConfig config,
    required ToolCallingConfiguration toolConfiguration,
    required ToolCallingAdapter adapter,
    required ToolCancellationToken cancellationToken,
  }) async {
    cancellationToken.throwIfCancelled();
    final responseTokens = _contextWindowService.effectiveResponseTokenLimit(
      contextLength: config.contextLength,
      requestedTokens: config.maxTokens,
    );
    config = config.copyWith(maxTokens: responseTokens);
    final fittedBase = _contextWindowService
        .fit(
          baseMessages,
          contextLength: config.contextLength,
          responseTokens: responseTokens,
        )
        .messages;

    return switch (config.provider) {
      LLMProvider.claude => _generateClaudeToolTurn(
          fittedBase,
          continuationMessages,
          config,
          toolConfiguration,
          adapter,
          cancellationToken,
        ),
      LLMProvider.gemini => _generateGeminiToolTurn(
          fittedBase,
          continuationMessages,
          config,
          toolConfiguration,
          adapter,
          cancellationToken,
        ),
      LLMProvider.openAICompatible ||
      LLMProvider.openai ||
      LLMProvider.deepSeek ||
      LLMProvider.qwen ||
      LLMProvider.openRouter ||
      LLMProvider.siliconFlow ||
      LLMProvider.moonshot ||
      LLMProvider.zai ||
      LLMProvider.miniMax ||
      LLMProvider.xai ||
      LLMProvider.lmStudio =>
        _generateOpenAiToolTurn(
          fittedBase,
          continuationMessages,
          config,
          toolConfiguration,
          adapter,
          cancellationToken,
        ),
      LLMProvider.ollama ||
      LLMProvider.koboldCpp =>
        throw const ToolProtocolException(
          'unsupported_provider',
          'The selected provider does not support the tool loop.',
        ),
    };
  }

  Future<ToolProviderTurn> _generateOpenAiToolTurn(
    List<Map<String, dynamic>> baseMessages,
    List<Map<String, dynamic>> continuationMessages,
    LLMConfig config,
    ToolCallingConfiguration toolConfiguration,
    ToolCallingAdapter adapter,
    ToolCancellationToken cancellationToken,
  ) async {
    final endpoint = '${config.apiUrl}/chat/completions';
    final baseRequest = _buildOpenAIRequestBody(
      messages: [...baseMessages, ...continuationMessages],
      config: config,
    );
    final data = await _postToolJson(
      endpoint: endpoint,
      data: adapter.decorateRequest(baseRequest, toolConfiguration),
      headers: _openAiHeaders(config),
      cancellationToken: cancellationToken,
    );
    final choices = toolObjectList(data['choices']);
    final rawMessage =
        choices.isEmpty ? null : toolObject(choices.first['message']);
    if (rawMessage == null) {
      throw const ToolProtocolException(
        'invalid_provider_response',
        'The provider returned no assistant message.',
      );
    }
    return ToolProviderTurn(
      assistant: adapter.parseResponse(data),
      continuationMessage: rawMessage,
    );
  }

  Future<ToolProviderTurn> _generateClaudeToolTurn(
    List<Map<String, dynamic>> baseMessages,
    List<Map<String, dynamic>> continuationMessages,
    LLMConfig config,
    ToolCallingConfiguration toolConfiguration,
    ToolCallingAdapter adapter,
    ToolCancellationToken cancellationToken,
  ) async {
    final system = baseMessages
        .where((message) => message['role'] == 'system')
        .map((message) => message['content']?.toString() ?? '')
        .where((content) => content.isNotEmpty)
        .join('\n\n');
    final messages = _mergeNativeMessages([
      for (final message in baseMessages)
        if (message['role'] != 'system') _claudeMessage(message),
      ...continuationMessages,
    ]);
    final baseRequest = <String, dynamic>{
      'model': config.model,
      'max_tokens': config.maxTokens,
      if (system.isNotEmpty) 'system': system,
      'messages': messages,
    };
    final data = await _postToolJson(
      endpoint: '${config.apiUrl}/v1/messages',
      data: adapter.decorateRequest(baseRequest, toolConfiguration),
      headers: {
        'x-api-key': config.apiKey,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      cancellationToken: cancellationToken,
    );
    final content = data['content'];
    if (content is! List) {
      throw const ToolProtocolException(
        'invalid_provider_response',
        'Claude returned no assistant content.',
      );
    }
    return ToolProviderTurn(
      assistant: adapter.parseResponse(data),
      continuationMessage: {'role': 'assistant', 'content': content},
    );
  }

  Future<ToolProviderTurn> _generateGeminiToolTurn(
    List<Map<String, dynamic>> baseMessages,
    List<Map<String, dynamic>> continuationMessages,
    LLMConfig config,
    ToolCallingConfiguration toolConfiguration,
    ToolCallingAdapter adapter,
    ToolCancellationToken cancellationToken,
  ) async {
    final system = baseMessages
        .where((message) => message['role'] == 'system')
        .map((message) => message['content']?.toString() ?? '')
        .where((content) => content.isNotEmpty)
        .join('\n\n');
    final generationConfig = <String, dynamic>{
      'maxOutputTokens': config.maxTokens,
      'temperature': config.temperature,
      'topP': config.topP,
      'topK': config.topK,
    };
    _applyGeminiThinking(generationConfig, config);
    final baseRequest = <String, dynamic>{
      'contents': _mergeNativeMessages([
        for (final message in baseMessages)
          if (message['role'] != 'system') _geminiMessage(message),
        ...continuationMessages,
      ]),
      if (system.isNotEmpty)
        'systemInstruction': {
          'parts': [
            {'text': system},
          ],
        },
      'generationConfig': generationConfig,
    };
    final data = await _postToolJson(
      endpoint:
          '${config.apiUrl}/models/${Uri.encodeComponent(config.model)}:generateContent?key=${Uri.encodeQueryComponent(config.apiKey)}',
      data: adapter.decorateRequest(baseRequest, toolConfiguration),
      headers: {'Content-Type': 'application/json'},
      cancellationToken: cancellationToken,
    );
    final candidates = toolObjectList(data['candidates']);
    final content =
        candidates.isEmpty ? null : toolObject(candidates.first['content']);
    if (content == null) {
      throw const ToolProtocolException(
        'invalid_provider_response',
        'Gemini returned no assistant content.',
      );
    }
    return ToolProviderTurn(
      assistant: adapter.parseResponse(data),
      continuationMessage: {...content, 'role': content['role'] ?? 'model'},
    );
  }

  Future<Map<String, dynamic>> _postToolJson({
    required String endpoint,
    required Map<String, dynamic> data,
    required Map<String, String> headers,
    required ToolCancellationToken cancellationToken,
  }) async {
    final cancelToken = _newCancelToken();
    cancellationToken.whenCancelled((reason) {
      if (!cancelToken.isCancelled) cancelToken.cancel(reason);
    });
    try {
      final response = await _dio.post<Object?>(
        endpoint,
        options: Options(headers: headers, validateStatus: (_) => true),
        data: data,
        cancelToken: cancelToken,
      );
      cancellationToken.throwIfCancelled();
      final status = response.statusCode;
      if (status == null || status < 200 || status >= 300) {
        throw ToolProtocolException(
          'provider_http_error',
          'The tool request failed with HTTP ${status ?? 'unknown'}.',
        );
      }
      final body = response.data;
      if (body is Map<String, dynamic>) return body;
      if (body is Map) return Map<String, dynamic>.from(body);
      throw const ToolProtocolException(
        'invalid_provider_response',
        'The provider returned a non-object response.',
      );
    } on DioException catch (error) {
      if (cancellationToken.isCancelled ||
          error.type == DioExceptionType.cancel ||
          CancelToken.isCancel(error)) {
        throw const ToolProtocolException(
          'cancelled',
          'Tool generation was cancelled.',
        );
      }
      throw const ToolProtocolException(
        'provider_request_failed',
        'The tool request could not reach the provider.',
      );
    }
  }

  static Map<String, dynamic> _claudeMessage(Map<String, dynamic> message) {
    final role = message['role'] == 'assistant' ? 'assistant' : 'user';
    final content = message['content'];
    return {
      'role': role,
      'content': content is List
          ? content
          : [
              {'type': 'text', 'text': content?.toString() ?? ''},
            ],
    };
  }

  static Map<String, dynamic> _geminiMessage(Map<String, dynamic> message) {
    final role = message['role'] == 'assistant' ? 'model' : 'user';
    final content = message['content'];
    return {
      'role': role,
      'parts': content is List
          ? content
          : [
              {'text': content?.toString() ?? ''},
            ],
    };
  }

  static List<Map<String, dynamic>> _mergeNativeMessages(
    Iterable<Map<String, dynamic>> source,
  ) {
    final result = <Map<String, dynamic>>[];
    for (final message in source) {
      final role = message['role'];
      final partsKey = message.containsKey('parts') ? 'parts' : 'content';
      final parts = message[partsKey];
      final previous = result.isEmpty ? null : result.last;
      if (previous != null &&
          previous['role'] == role &&
          previous[partsKey] is List &&
          parts is List) {
        previous[partsKey] = [...(previous[partsKey] as List), ...parts];
      } else {
        result.add(Map<String, dynamic>.from(message));
      }
    }
    return result;
  }

  /// Claude models that use adaptive thinking (effort string instead of budget tokens)
  /// Aligned with SillyTavern's isAdaptiveModel detection
  static bool _isClaudeAdaptiveModel(String model) {
    // ST enables adaptive thinking by default only for Opus 4.7+;
    // newer Claude 5 family models are adaptive as well
    return RegExp(r'^claude-(opus-4-7|opus-5|sonnet-5|fable-5)')
        .hasMatch(model);
  }

  /// Apply Claude extended/adaptive thinking based on reasoningEffort.
  /// Ported from SillyTavern's calculateClaudeBudgetTokens.
  void _applyClaudeThinking(
    Map<String, dynamic> requestData,
    LLMConfig config, {
    required bool stream,
  }) {
    final effort = config.reasoningEffort;
    if (effort == ReasoningEffort.auto) return;

    // Thinking mode rejects assistant prefill: convert a trailing
    // assistant message to user (mirrors ST's fixThinkingPrefill)
    final messages = requestData['messages'];
    if (messages is List && messages.isNotEmpty) {
      final last = messages.last;
      if (last is Map && last['role'] == 'assistant') {
        messages[messages.length - 1] = {...last, 'role': 'user'};
      }
    }

    if (_isClaudeAdaptiveModel(config.model)) {
      // Adaptive thinking (Opus 4.6+): effort string, like Gemini 3
      final String level;
      switch (effort) {
        case ReasoningEffort.min:
        case ReasoningEffort.low:
          level = 'low';
          break;
        case ReasoningEffort.medium:
          level = 'medium';
          break;
        case ReasoningEffort.high:
          level = 'high';
          break;
        case ReasoningEffort.max:
          level = 'max';
          break;
        default:
          return;
      }
      requestData['thinking'] = {'type': 'adaptive'};
      requestData['output_config'] = {'effort': level};
      return;
    }

    // Traditional extended thinking: numeric budget tokens
    final maxTokens = requestData['max_tokens'] as int;
    int budget;
    switch (effort) {
      case ReasoningEffort.min:
        budget = 1024;
        break;
      case ReasoningEffort.low:
        budget = (maxTokens * 0.1).floor();
        break;
      case ReasoningEffort.medium:
        budget = (maxTokens * 0.25).floor();
        break;
      case ReasoningEffort.high:
        budget = (maxTokens * 0.5).floor();
        break;
      case ReasoningEffort.max:
        budget = (maxTokens * 0.95).floor();
        break;
      default:
        return;
    }
    if (budget < 1024) budget = 1024;
    if (!stream && budget > 21333) budget = 21333;

    // Claude thinking requires headroom above the budget
    if (maxTokens <= 1024) {
      requestData['max_tokens'] = maxTokens + 1024;
    }
    requestData['thinking'] = {
      'type': 'enabled',
      'budget_tokens': budget,
    };
  }

  /// Apply Gemini thinkingConfig based on reasoningEffort.
  /// Ported from SillyTavern's calculateGoogleBudgetTokens.
  void _applyGeminiThinking(
    Map<String, dynamic> generationConfig,
    LLMConfig config,
  ) {
    final effort = config.reasoningEffort;
    if (effort == ReasoningEffort.auto) return;

    final model = config.model;
    final maxTokens = generationConfig['maxOutputTokens'] as int;
    final thinkingConfig = <String, dynamic>{'includeThoughts': true};

    // Gemini 3.x models use thinkingLevel strings
    if (RegExp(r'gemini-3[.\d]*-pro').hasMatch(model)) {
      thinkingConfig['thinkingLevel'] =
          (effort == ReasoningEffort.high || effort == ReasoningEffort.max)
              ? 'high'
              : 'low';
    } else if (RegExp(r'gemini-3[.\d]*-flash').hasMatch(model)) {
      final String level;
      switch (effort) {
        case ReasoningEffort.min:
          level = 'minimal';
          break;
        case ReasoningEffort.low:
          level = 'low';
          break;
        case ReasoningEffort.medium:
          level = 'medium';
          break;
        default:
          level = 'high';
      }
      thinkingConfig['thinkingLevel'] = level;
    } else if (model.contains('flash') || model.contains('pro')) {
      // Gemini 2.x: numeric thinkingBudget
      final isPro = !model.contains('flash');
      final isFlashLite = model.contains('flash-lite');
      int budget;
      switch (effort) {
        case ReasoningEffort.min:
          budget = isPro ? 128 : 0;
          break;
        case ReasoningEffort.low:
          budget = (maxTokens * 0.1).floor();
          break;
        case ReasoningEffort.medium:
          budget = (maxTokens * 0.25).floor();
          break;
        case ReasoningEffort.high:
          budget = (maxTokens * 0.5).floor();
          break;
        case ReasoningEffort.max:
          budget = maxTokens;
          break;
        default:
          return;
      }
      final cap = isPro ? 32768 : 24576;
      if (budget > cap) budget = cap;
      if (isPro && budget < 128) budget = 128;
      if (isFlashLite && budget < 512) budget = 512;
      thinkingConfig['thinkingBudget'] = budget;
    } else {
      return;
    }

    generationConfig['thinkingConfig'] = thinkingConfig;
  }

  /// Apply Claude prompt caching (cache_control breakpoints).
  ///
  /// Marks the system prompt and the second-to-last user message with
  /// ephemeral cache_control so the stable prefix of the conversation is
  /// cached between turns (mirrors ST's system-prompt cache + cachingAtDepth).
  void _applyClaudePromptCaching(
    Map<String, dynamic> requestData,
    LLMConfig config,
  ) {
    if (!config.promptCacheEnabled) return;

    const cacheControl = {'type': 'ephemeral'};

    // System prompt -> text block with cache_control
    final system = requestData['system'];
    if (system is String && system.isNotEmpty) {
      requestData['system'] = [
        {'type': 'text', 'text': system, 'cache_control': cacheControl},
      ];
    }

    // Mark the second-to-last user message so the history prefix caches
    // incrementally as the chat grows
    final messages = requestData['messages'];
    if (messages is List) {
      final userIndexes = <int>[];
      for (var i = 0; i < messages.length; i++) {
        final msg = messages[i];
        if (msg is Map && msg['role'] == 'user') userIndexes.add(i);
      }
      if (userIndexes.length >= 2) {
        final target = userIndexes[userIndexes.length - 2];
        final msg = Map<String, dynamic>.from(messages[target] as Map);
        final content = msg['content'];
        if (content is String) {
          msg['content'] = [
            {'type': 'text', 'text': content, 'cache_control': cacheControl},
          ];
          messages[target] = msg;
        } else if (content is List && content.isNotEmpty) {
          final lastBlock = Map<String, dynamic>.from(content.last as Map);
          lastBlock['cache_control'] = cacheControl;
          content[content.length - 1] = lastBlock;
        }
      }
    }
  }

  /// Apply reasoning effort for OpenAI-compatible endpoints
  void _applyOpenAIReasoning(
    Map<String, dynamic> requestData,
    LLMConfig config,
  ) {
    final effort = config.reasoningEffort;
    if (effort == ReasoningEffort.auto) return;

    if (config.provider == LLMProvider.openRouter) {
      // OpenRouter uses a nested reasoning object with low/medium/high
      final String level;
      switch (effort) {
        case ReasoningEffort.min:
        case ReasoningEffort.low:
          level = 'low';
          break;
        case ReasoningEffort.medium:
          level = 'medium';
          break;
        default:
          level = 'high';
      }
      requestData['reasoning'] = {'effort': level};
      return;
    }

    // OpenAI-style reasoning_effort: minimal/low/medium/high
    final String value;
    switch (effort) {
      case ReasoningEffort.min:
        value = 'minimal';
        break;
      case ReasoningEffort.max:
        value = 'high';
        break;
      default:
        value = effort;
    }
    requestData['reasoning_effort'] = value;
  }

  /// Log a message to the console
  /// Always calls debugPrint so DebugLogService can capture logs in all build modes
  void _log(String message, {String? error, StackTrace? stackTrace}) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] LLMService: $message';

    debugPrint(logMessage);
    if (error != null) {
      debugPrint('  Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('  StackTrace: $stackTrace');
    }

    // Also log to developer console for better visibility
    developer.log(
      message,
      name: 'LLMService',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log request details
  void _logRequest(
      String endpoint, Map<String, dynamic> data, LLMConfig config) {
    _log('═══════════════════════════════════════════════════════════════');
    _log('📤 REQUEST to ${config.provider.name}');
    _log('───────────────────────────────────────────────────────────────');
    _log('Endpoint: $endpoint');
    _log('Model: ${config.model}');
    _log('Max Tokens: ${config.maxTokens}');
    _log('Temperature: ${config.temperature}');
    _log('Top P: ${config.topP}');
    _log('Top K: ${config.topK}');
    _log('Frequency Penalty: ${config.frequencyPenalty}');
    _log('Presence Penalty: ${config.presencePenalty}');
    _log('Stream: ${config.streamEnabled}');
    _log('───────────────────────────────────────────────────────────────');

    // Log messages
    final messages = data['messages'] as List<dynamic>?;
    if (messages != null) {
      _log('Messages (${messages.length}):');
      for (int i = 0; i < messages.length; i++) {
        final msg = messages[i] as Map<String, dynamic>;
        final role = msg['role'] as String? ?? 'unknown';
        final contentValue = msg['content'];
        String preview;
        if (contentValue is String) {
          preview = contentValue.length > 200
              ? '${contentValue.substring(0, 200)}...'
              : contentValue;
        } else if (contentValue is List) {
          // Multimodal content - summarize the parts
          final parts = contentValue.map((p) {
            if (p is Map<String, dynamic>) {
              final type = p['type'] as String?;
              if (type == 'text')
                return 'text: ${(p['text'] as String? ?? '').substring(0, (p['text'] as String? ?? '').length.clamp(0, 50))}...';
              if (type == 'image_url') return 'image';
              return type ?? 'unknown';
            }
            return p.toString();
          }).join(', ');
          preview = '[Multimodal: $parts]';
        } else {
          preview = contentValue?.toString() ?? '';
        }
        _log('  [$i] $role: $preview');
      }
    }

    // Log system message for Claude (string, or blocks when caching is on)
    final systemValue = data['system'];
    final system = systemValue is String
        ? systemValue
        : systemValue is List
            ? systemValue
                .whereType<Map>()
                .map((b) => b['text'] ?? '')
                .join('\n')
            : null;
    if (system != null) {
      final preview =
          system.length > 200 ? '${system.substring(0, 200)}...' : system;
      _log('System: $preview');
    }

    // Log prompt for KoboldCpp
    final prompt = data['prompt'] as String?;
    if (prompt != null) {
      final preview =
          prompt.length > 500 ? '${prompt.substring(0, 500)}...' : prompt;
      _log('Prompt: $preview');
    }

    _log('───────────────────────────────────────────────────────────────');
    //   _log('Full Request JSON:');
    //   try {
    //     final encoder = const JsonEncoder.withIndent('  ');
    //     final jsonStr = encoder.convert(data);
    //     // Split into lines for better readability
    //     for (final line in jsonStr.split('\n')) {
    //       _log(line);
    //     }
    //   } catch (e) {
    //     _log('(Could not serialize request: $e)');
    //   }
    //   _log('═══════════════════════════════════════════════════════════════');
  }

  /// Log response details
  void _logResponse(String provider, dynamic responseData,
      {int? statusCode, String? contentPreview}) {
    _log('═══════════════════════════════════════════════════════════════');
    _log('📥 RESPONSE from $provider');
    _log('───────────────────────────────────────────────────────────────');
    if (statusCode != null) {
      _log('Status Code: $statusCode');
    }
    if (contentPreview != null) {
      _log('Content Preview: $contentPreview');
    }
    _log('───────────────────────────────────────────────────────────────');
    _log('Full Response:');
    try {
      if (responseData is Map || responseData is List) {
        const encoder = JsonEncoder.withIndent('  ');
        final jsonStr = encoder.convert(responseData);
        for (final line in jsonStr.split('\n')) {
          _log(line);
        }
      } else {
        _log(responseData.toString());
      }
    } catch (e) {
      _log('(Could not serialize response: $e)');
    }
    _log('═══════════════════════════════════════════════════════════════');
  }

  /// Log streaming chunk
  void _logStreamChunk(String provider, String chunk,
      {bool isFirst = false, bool isLast = false}) {
    if (isFirst) {
      _log('📥 STREAM START from $provider');
    }
    if (chunk.isNotEmpty) {
      // Only log significant chunks to avoid spam
      if (chunk.length > 1 || isFirst || isLast) {
        _log('  chunk: "${chunk.replaceAll('\n', '\\n')}"');
      }
    }
    if (isLast) {
      _log('📥 STREAM END from $provider');
    }
  }

  /// Log stream completion with full content
  void _logStreamComplete(String provider, String fullContent) {
    _log('═══════════════════════════════════════════════════════════════');
    _log('📥 STREAM COMPLETE from $provider');
    _log('───────────────────────────────────────────────────────────────');
    _log('Total Length: ${fullContent.length} characters');
    _log('Full Content:');
    _log(fullContent);
    _log('═══════════════════════════════════════════════════════════════');
  }

  /// Generate a response (non-streaming) - content only for backward compatibility
  Future<String> generate(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final response = await generateWithReasoning(messages, config);
    return response.content;
  }

  /// Generate a response with reasoning/thinking support (non-streaming)
  Future<LLMResponse> generateWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final response = await _generateWithReasoningRaw(messages, config);
    // Fallback: extract inline <think> blocks for providers without
    // structured reasoning fields (local models, R1 via compatible APIs)
    if (!response.hasReasoning) {
      final (content, reasoning) = ThinkTagParser.extract(response.content);
      if (reasoning != null) {
        return LLMResponse(content: content, reasoning: reasoning);
      }
    }
    return response;
  }

  /// Merge consecutive same-role messages (prompt post-processing).
  /// String contents are joined with double newlines; multimodal (list)
  /// contents are never merged.
  List<Map<String, dynamic>> _mergeConsecutiveRoles(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) {
    if (!config.mergeConsecutiveRoles || messages.isEmpty) return messages;

    final merged = <Map<String, dynamic>>[];
    for (final msg in messages) {
      final prev = merged.isNotEmpty ? merged.last : null;
      if (prev != null &&
          prev['role'] == msg['role'] &&
          prev['content'] is String &&
          msg['content'] is String) {
        merged[merged.length - 1] = {
          ...prev,
          'content': '${prev['content']}\n\n${msg['content']}',
        };
      } else {
        merged.add(msg);
      }
    }
    return merged;
  }

  Future<LLMResponse> _generateWithReasoningRaw(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final responseTokens = _contextWindowService.effectiveResponseTokenLimit(
      contextLength: config.contextLength,
      requestedTokens: config.maxTokens,
    );
    config = config.copyWith(maxTokens: responseTokens);
    messages = _contextWindowService
        .fit(
          messages,
          contextLength: config.contextLength,
          responseTokens: responseTokens,
        )
        .messages;
    messages = _mergeConsecutiveRoles(messages, config);
    switch (config.provider) {
      case LLMProvider.deepSeek:
      case LLMProvider.qwen:
      case LLMProvider.siliconFlow:
      case LLMProvider.moonshot:
      case LLMProvider.zai:
      case LLMProvider.miniMax:
      case LLMProvider.openAICompatible:
      case LLMProvider.openai:
      case LLMProvider.xai:
      case LLMProvider.lmStudio:
        return _generateOpenAIWithReasoning(messages, config);
      case LLMProvider.claude:
        return _generateClaudeWithReasoning(messages, config);
      case LLMProvider.openRouter:
        return _generateOpenAIWithReasoning(messages, config);
      case LLMProvider.gemini:
        return _generateGeminiWithReasoning(messages, config);
      case LLMProvider.ollama:
        return _generateOllamaWithReasoning(messages, config);
      case LLMProvider.koboldCpp:
        return _generateKoboldWithReasoning(messages, config);
    }
  }

  /// Generate a streaming response (content only, for backward compatibility)
  Stream<String> generateStream(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    await for (final chunk in generateStreamWithReasoning(messages, config)) {
      if (chunk.content != null) {
        yield chunk.content!;
      }
    }
  }

  /// Generate a streaming response with reasoning/thinking support.
  /// Content deltas are run through [ThinkTagParser] so inline <think>
  /// blocks stream into the reasoning UI instead of the message body.
  Stream<LLMStreamChunk> generateStreamWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final parser = ThinkTagParser();
    try {
      await for (final chunk
          in _generateStreamWithReasoningRaw(messages, config)) {
        final text = chunk.content;
        if (text != null && text.isNotEmpty) {
          final (content, reasoning) = parser.feed(text);
          if (reasoning.isNotEmpty) {
            yield LLMStreamChunk(reasoning: reasoning, isReasoningChunk: true);
          }
          if (content.isNotEmpty) {
            yield LLMStreamChunk(content: content);
          }
        } else {
          yield chunk;
        }
      }
    } on DioException catch (e) {
      // User-initiated cancel: end the stream quietly, keep partial output
      if (e.type == DioExceptionType.cancel || CancelToken.isCancel(e)) {
        _log('Stream cancelled by user');
      } else {
        rethrow;
      }
    }
    final (content, reasoning) = parser.flush();
    if (reasoning.isNotEmpty) {
      yield LLMStreamChunk(reasoning: reasoning, isReasoningChunk: true);
    }
    if (content.isNotEmpty) {
      yield LLMStreamChunk(content: content);
    }
  }

  Stream<LLMStreamChunk> _generateStreamWithReasoningRaw(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) {
    final responseTokens = _contextWindowService.effectiveResponseTokenLimit(
      contextLength: config.contextLength,
      requestedTokens: config.maxTokens,
    );
    config = config.copyWith(maxTokens: responseTokens);
    messages = _contextWindowService
        .fit(
          messages,
          contextLength: config.contextLength,
          responseTokens: responseTokens,
        )
        .messages;
    messages = _mergeConsecutiveRoles(messages, config);
    switch (config.provider) {
      case LLMProvider.deepSeek:
      case LLMProvider.qwen:
      case LLMProvider.siliconFlow:
      case LLMProvider.moonshot:
      case LLMProvider.zai:
      case LLMProvider.miniMax:
      case LLMProvider.openAICompatible:
      case LLMProvider.openai:
      case LLMProvider.xai:
      case LLMProvider.lmStudio:
        return _streamOpenAIWithReasoning(messages, config);
      case LLMProvider.claude:
        return _streamClaudeWithReasoning(messages, config);
      case LLMProvider.openRouter:
        return _streamOpenAIWithReasoning(messages, config); // Same as OpenAI
      case LLMProvider.gemini:
        return _streamGeminiWithReasoning(messages, config);
      case LLMProvider.ollama:
        return _streamOllamaWithReasoning(messages, config);
      case LLMProvider.koboldCpp:
        return _streamKoboldWithReasoning(messages, config);
    }
  }

  /// Test connection to the API
  /// Returns a success message or throws an exception with error details
  Future<String> testConnection(LLMConfig config) async {
    _log('Testing connection to ${config.provider.name} at ${config.apiUrl}');
    _log(
        'API Key: ${config.apiKey.isEmpty ? "(empty)" : "${config.apiKey.substring(0, 8)}..."}');

    try {
      switch (config.provider) {
        case LLMProvider.openRouter:
        case LLMProvider.deepSeek:
        case LLMProvider.qwen:
        case LLMProvider.siliconFlow:
        case LLMProvider.moonshot:
        case LLMProvider.zai:
        case LLMProvider.miniMax:
        case LLMProvider.lmStudio:
          final url = '${config.apiUrl}/models';
          _log('Sending GET request to $url');
          final headers = <String, String>{};
          if (config.apiKey.isNotEmpty) {
            headers['Authorization'] = 'Bearer ${config.apiKey}';
          }
          final response = await _dio.get(
            url,
            options: Options(
              headers: headers,
              validateStatus: (status) => true,
            ),
          );
          _log('Response status: ${response.statusCode}');
          _log('Response data: ${response.data}');
          if (response.statusCode == 200) {
            final data = response.data as Map<String, dynamic>?;
            final modelCount = (data?['data'] as List?)?.length ?? 0;
            final result = 'Connected! Found $modelCount LM Studio models';
            _log('Success: $result');
            return result;
          }
          _log('Error: Cannot connect to LM Studio');
          throw Exception('Cannot connect to LM Studio at ${config.apiUrl}');

        case LLMProvider.openAICompatible:
        case LLMProvider.openai:
        case LLMProvider.xai:
          if (config.apiKey.isEmpty) {
            _log('Error: API key is empty');
            throw Exception('API key is required');
          }
          _log('Sending GET request to ${config.apiUrl}/models');
          final response = await _dio.get(
            '${config.apiUrl}/models',
            options: Options(
              headers: {'Authorization': 'Bearer ${config.apiKey}'},
              validateStatus: (status) => true, // Accept all status codes
            ),
          );
          _log('Response status: ${response.statusCode}');
          _log('Response data: ${response.data}');

          if (response.statusCode == 200) {
            final data = response.data as Map<String, dynamic>?;
            final modelCount = (data?['data'] as List?)?.length ?? 0;
            final result = 'Connected! Found $modelCount models';
            _log('Success: $result');
            return result;
          } else if (response.statusCode == 401) {
            _log('Error: Invalid API key (401)');
            throw Exception('Invalid API key (401 Unauthorized)');
          } else if (response.statusCode == 403) {
            _log('Error: Access denied (403)');
            throw Exception('Access denied (403 Forbidden)');
          } else {
            final errorMsg = _extractErrorMessage(response.data);
            _log('Error: HTTP ${response.statusCode} - $errorMsg');
            throw Exception('HTTP ${response.statusCode}: $errorMsg');
          }

        case LLMProvider.claude:
          if (config.apiKey.isEmpty) {
            _log('Error: API key is empty');
            throw Exception('API key is required');
          }
          // Claude doesn't have a models endpoint, try a minimal messages request
          final url = '${config.apiUrl}/v1/messages';
          _log('Sending POST request to $url');
          final response = await _dio.post(
            url,
            options: Options(
              headers: {
                'x-api-key': config.apiKey,
                'anthropic-version': '2023-06-01',
                'Content-Type': 'application/json',
              },
              validateStatus: (status) => true,
            ),
            data: {
              'model': config.model.isNotEmpty
                  ? config.model
                  : 'claude-sonnet-4-5-20250929',
              'max_tokens': 1,
              'messages': [
                {'role': 'user', 'content': 'Hi'}
              ],
            },
          );
          _log('Response status: ${response.statusCode}');
          _log('Response data: ${response.data}');

          // Claude returns 200 for success, 401 for invalid key
          if (response.statusCode == 200) {
            _log('Success: Connected to Claude API');
            return 'Connected to Claude API!';
          } else if (response.statusCode == 401) {
            _log('Error: Invalid API key (401)');
            throw Exception('Invalid API key (401 Unauthorized)');
          } else if (response.statusCode == 400) {
            // 400 can mean the request worked but had issues - still connected
            _log(
                'Success: Connected to Claude API (400 response but connection works)');
            return 'Connected to Claude API!';
          } else {
            final errorMsg = _extractErrorMessage(response.data);
            _log('Error: HTTP ${response.statusCode} - $errorMsg');
            throw Exception('HTTP ${response.statusCode}: $errorMsg');
          }

        case LLMProvider.gemini:
          if (config.apiKey.isEmpty) {
            _log('Error: API key is empty');
            throw Exception('API key is required');
          }
          final url = '${config.apiUrl}/models?key=${config.apiKey}';
          _log('Sending GET request to ${config.apiUrl}/models');
          final response = await _dio.get(
            url,
            options: Options(validateStatus: (status) => true),
          );
          _log('Response status: ${response.statusCode}');
          _log('Response data: ${response.data}');

          if (response.statusCode == 200) {
            final data = response.data as Map<String, dynamic>?;
            final modelCount = (data?['models'] as List?)?.length ?? 0;
            final result = 'Connected! Found $modelCount models';
            _log('Success: $result');
            return result;
          } else if (response.statusCode == 400 || response.statusCode == 403) {
            _log('Error: Invalid API key');
            throw Exception('Invalid API key');
          } else {
            final errorMsg = _extractErrorMessage(response.data);
            _log('Error: HTTP ${response.statusCode} - $errorMsg');
            throw Exception('HTTP ${response.statusCode}: $errorMsg');
          }

        case LLMProvider.ollama:
          final url = '${config.apiUrl}/api/tags';
          _log('Sending GET request to $url');
          final response = await _dio.get(
            url,
            options: Options(validateStatus: (status) => true),
          );
          _log('Response status: ${response.statusCode}');
          _log('Response data: ${response.data}');

          if (response.statusCode == 200) {
            final data = response.data as Map<String, dynamic>?;
            final modelCount = (data?['models'] as List?)?.length ?? 0;
            final result = 'Connected! Found $modelCount local models';
            _log('Success: $result');
            return result;
          } else {
            _log('Error: Cannot connect to Ollama');
            throw Exception('Cannot connect to Ollama at ${config.apiUrl}');
          }

        case LLMProvider.koboldCpp:
          final url = '${config.apiUrl}/api/v1/model';
          _log('Sending GET request to $url');
          final response = await _dio.get(
            url,
            options: Options(validateStatus: (status) => true),
          );
          _log('Response status: ${response.statusCode}');
          _log('Response data: ${response.data}');

          if (response.statusCode == 200) {
            final data = response.data as Map<String, dynamic>?;
            final modelName = data?['result'] as String? ?? 'Unknown';
            final result = 'Connected! Model: $modelName';
            _log('Success: $result');
            return result;
          } else {
            _log('Error: Cannot connect to KoboldCpp');
            throw Exception('Cannot connect to KoboldCpp at ${config.apiUrl}');
          }
      }
    } on DioException catch (e, stackTrace) {
      _log('DioException: ${e.type}', error: e.message, stackTrace: stackTrace);
      _log('DioException details: ${e.error}');
      _log('DioException response: ${e.response?.data}');

      // Use the new formatter for better error messages
      final errorMessage = _formatDioException(e);
      throw Exception(errorMessage);
    } catch (e, stackTrace) {
      if (e is Exception) {
        _log('Exception: $e', stackTrace: stackTrace);
        rethrow;
      }
      _log('Unexpected error: $e', stackTrace: stackTrace);
      throw Exception('Unexpected error: $e');
    }
  }

  /// Extract error message from API response
  String _extractErrorMessage(dynamic data) {
    if (data == null) return 'No response';
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      // OpenAI format: { "error": { "message": "...", "type": "...", "code": "..." } }
      if (data['error'] is Map) {
        final errorMap = data['error'] as Map;
        final message = errorMap['message']?.toString() ?? 'Unknown error';
        final type = errorMap['type']?.toString();
        final code = errorMap['code']?.toString();

        final parts = [message];
        if (type != null) parts.add('[Type: $type]');
        if (code != null) parts.add('[Code: $code]');

        return parts.join(' ');
      }
      // Generic format
      return data['message']?.toString() ??
          data['error']?.toString() ??
          jsonEncode(data); // Show full JSON if no specific message
    }
    return data.toString();
  }

  /// Format DioException into user-friendly error message
  String _formatDioException(DioException e) {
    final buffer = StringBuffer();

    // Add exception type
    buffer.write('Network Error');

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        buffer.write(' (Connection Timeout)');
        break;
      case DioExceptionType.sendTimeout:
        buffer.write(' (Send Timeout)');
        break;
      case DioExceptionType.receiveTimeout:
        buffer.write(' (Receive Timeout)');
        break;
      case DioExceptionType.badResponse:
        buffer.write(' (HTTP ${e.response?.statusCode})');
        break;
      case DioExceptionType.cancel:
        buffer.write(' (Request Cancelled)');
        break;
      case DioExceptionType.connectionError:
        buffer.write(' (Connection Error)');
        break;
      case DioExceptionType.unknown:
        buffer.write(' (Unknown)');
        break;
      default:
        buffer.write(' (${e.type})');
    }

    final requestUri = e.requestOptions.uri;
    final sanitizedUri = requestUri.hasScheme
        ? Uri(
            scheme: requestUri.scheme,
            host: requestUri.host,
            port: requestUri.hasPort ? requestUri.port : null,
            path: requestUri.path,
          ).toString()
        : requestUri.path;
    if (sanitizedUri.isNotEmpty) {
      buffer.write('\n\nRequest: $sanitizedUri');
    }

    if (e.response?.statusCode == 404) {
      buffer.write(
        '\n\nCheck the Base URL in provider settings. Use the API root only '
        '(for example, https://host/v1) and remove endpoint suffixes such as '
        '/models or /chat/completions.',
      );
    }

    // Add server response if available
    if (e.response?.data != null) {
      buffer.write('\n\nServer Response:\n');
      buffer.write(_extractErrorMessage(e.response!.data));
    } else if (e.message != null) {
      buffer.write('\n\n');
      buffer.write(e.message!);
    }

    // Add underlying error if available
    if (e.error != null && e.error.toString() != e.message) {
      buffer.write('\n\nDetails: ${e.error}');
    }

    return buffer.toString();
  }

  /// Get available models
  Future<List<String>> getAvailableModels(LLMConfig config) async {
    _log('Fetching available models for ${config.provider.name}');

    try {
      switch (config.provider) {
        case LLMProvider.openRouter:
        case LLMProvider.deepSeek:
        case LLMProvider.qwen:
        case LLMProvider.siliconFlow:
        case LLMProvider.moonshot:
        case LLMProvider.zai:
        case LLMProvider.miniMax:
        case LLMProvider.openAICompatible:
        case LLMProvider.openai:
        case LLMProvider.xai:
        case LLMProvider.lmStudio:
          _log('Fetching models from ${config.apiUrl}/models');
          final headers = <String, String>{};
          if (config.apiKey.isNotEmpty) {
            headers['Authorization'] = 'Bearer ${config.apiKey}';
          }
          final response = await _dio.get(
            '${config.apiUrl}/models',
            options: Options(headers: headers),
          );
          _log('Models response status: ${response.statusCode}');
          final data = response.data as Map<String, dynamic>;
          final models = (data['data'] as List<dynamic>?) ?? [];
          _log('Total models: ${models.length}');
          // Return all models without filtering
          final modelIds = models
              .map((m) => (m as Map<String, dynamic>)['id'] as String)
              .toList();
          modelIds.sort();
          _log('Returning ${modelIds.length} models');
          return modelIds;

        case LLMProvider.claude:
          // Try the Anthropic models endpoint, fall back to known models
          try {
            final response = await _dio.get(
              '${config.apiUrl}/v1/models',
              options: Options(
                headers: {
                  'x-api-key': config.apiKey,
                  'anthropic-version': '2023-06-01',
                },
              ),
            );
            final data = response.data as Map<String, dynamic>;
            final models = (data['data'] as List<dynamic>?) ?? [];
            if (models.isNotEmpty) {
              final modelIds = models
                  .map((m) => (m as Map<String, dynamic>)['id'] as String)
                  .toList();
              _log('Returning ${modelIds.length} Claude models from API');
              return modelIds;
            }
          } catch (e) {
            _log('Claude models endpoint failed, using predefined list: $e');
          }
          _log('Returning predefined Claude models');
          return [
            'claude-opus-4-7',
            'claude-opus-4-6',
            'claude-sonnet-4-6',
            'claude-opus-4-5',
            'claude-sonnet-4-5-20250929',
            'claude-haiku-4-5-20251001',
            'claude-opus-4-1-20250805',
          ];

        case LLMProvider.gemini:
          _log('Fetching Gemini models from ${config.apiUrl}/models');
          final response = await _dio.get(
            '${config.apiUrl}/models?key=${config.apiKey}',
          );
          _log('Gemini models response status: ${response.statusCode}');
          final data = response.data as Map<String, dynamic>;
          final models = (data['models'] as List<dynamic>?) ?? [];
          _log('Gemini total models: ${models.length}');
          // Extract model names without filtering
          final modelIds = models.map((m) {
            final name = (m as Map<String, dynamic>)['name'] as String;
            // Remove 'models/' prefix
            return name.startsWith('models/') ? name.substring(7) : name;
          }).toList();
          modelIds.sort();
          _log('Returning ${modelIds.length} Gemini models');
          return modelIds;

        case LLMProvider.ollama:
          _log('Fetching Ollama models from ${config.apiUrl}/api/tags');
          final response = await _dio.get('${config.apiUrl}/api/tags');
          _log('Ollama models response status: ${response.statusCode}');
          final data = response.data as Map<String, dynamic>;
          final models = (data['models'] as List<dynamic>?) ?? [];
          final modelNames = models
              .map((m) => (m as Map<String, dynamic>)['name'] as String)
              .toList();
          modelNames.sort();
          _log('Ollama models: ${modelNames.length}');
          return modelNames;

        case LLMProvider.koboldCpp:
          // KoboldCpp uses a single loaded model
          _log('Fetching KoboldCpp model from ${config.apiUrl}/api/v1/model');
          try {
            final response = await _dio.get('${config.apiUrl}/api/v1/model');
            _log('KoboldCpp model response status: ${response.statusCode}');
            final data = response.data as Map<String, dynamic>;
            final modelName = data['result'] as String?;
            if (modelName != null && modelName.isNotEmpty) {
              _log('KoboldCpp model: $modelName');
              return [modelName];
            }
          } catch (e) {
            _log('KoboldCpp model fetch error: $e');
          }
          return [];
      }
    } catch (e, stackTrace) {
      _log('Error fetching models: $e', stackTrace: stackTrace);
      return [];
    }
  }

  /// Get upstream providers available for the selected OpenRouter model.
  Future<List<String>> getOpenRouterProviders(LLMConfig config) async {
    if (config.provider != LLMProvider.openRouter || config.model.isEmpty) {
      return const [];
    }
    final encodedModel =
        config.model.split('/').map(Uri.encodeComponent).join('/');
    final endpoint = '${config.apiUrl}/models/$encodedModel/endpoints';
    final response = await _dio.get(
      endpoint,
      options: Options(
        headers: config.apiKey.isEmpty
            ? null
            : {'Authorization': 'Bearer ${config.apiKey}'},
        validateStatus: (status) => true,
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'HTTP ${response.statusCode}: ${_extractErrorMessage(response.data)}',
      );
    }
    final data = response.data as Map<String, dynamic>?;
    final modelData = data?['data'] as Map<String, dynamic>?;
    final endpoints = modelData?['endpoints'] as List<dynamic>? ?? const [];
    final providers = endpoints
        .whereType<Map<String, dynamic>>()
        .map((endpoint) => endpoint['provider_name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return providers;
  }

  void _applyOpenRouterRouting(
    Map<String, dynamic> requestData,
    LLMConfig config,
  ) {
    if (config.provider == LLMProvider.openRouter &&
        config.openRouterProvider.isNotEmpty) {
      requestData['provider'] = {
        'order': [config.openRouterProvider],
        'allow_fallbacks': true,
      };
    }
  }

  static void _applyExtendedSamplerParameters(
    Map<String, dynamic> requestData,
    LLMConfig config,
  ) {
    if (config.topK > 0) requestData['top_k'] = config.topK;
    if (config.repetitionPenalty != 1.0) {
      requestData['repetition_penalty'] = config.repetitionPenalty;
    }
    if (config.minP > 0.0) requestData['min_p'] = config.minP;
    if (config.topA > 0.0) requestData['top_a'] = config.topA;
    if (config.typicalP != 1.0) requestData['typical_p'] = config.typicalP;
    if (config.tailFreeSampling != 1.0) {
      requestData['tfs_z'] = config.tailFreeSampling;
    }
  }

  Map<String, String> _openAiHeaders(LLMConfig config) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (config.apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${config.apiKey}';
    }
    return headers;
  }

  Map<String, dynamic> _buildOpenAIRequestBody({
    required List<Map<String, dynamic>> messages,
    required LLMConfig config,
    bool stream = false,
  }) {
    final preset = OpenAIProviderPreset.resolve(config);

    final requestData = <String, dynamic>{
      'model': config.model,
      'messages': _prepareOpenAIMessages(messages, config),
      'max_tokens': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
    };

    if (stream) {
      requestData['stream'] = true;
    }

    switch (preset) {
      case OpenAIProviderPreset.xai:
        // xAI / Grok rejects presence_penalty and extended samplers with HTTP 400
        if (config.frequencyPenalty != 0.0) {
          requestData['frequency_penalty'] = config.frequencyPenalty;
        }
        if (config.stopSequences.isNotEmpty) {
          requestData['stop'] = config.stopSequences;
        }
        if (config.seed != -1) {
          requestData['seed'] = config.seed;
        }
        break;

      case OpenAIProviderPreset.standard:
        requestData['frequency_penalty'] = config.frequencyPenalty;
        requestData['presence_penalty'] = config.presencePenalty;
        if (config.stopSequences.isNotEmpty) {
          requestData['stop'] = config.stopSequences;
        }
        if (config.seed != -1) {
          requestData['seed'] = config.seed;
        }
        _applyOpenAIReasoning(requestData, config);
        break;

      case OpenAIProviderPreset.openRouter:
        requestData['frequency_penalty'] = config.frequencyPenalty;
        requestData['presence_penalty'] = config.presencePenalty;
        if (config.stopSequences.isNotEmpty) {
          requestData['stop'] = config.stopSequences;
        }
        if (config.seed != -1) {
          requestData['seed'] = config.seed;
        }
        _applyOpenRouterRouting(requestData, config);
        _applyExtendedSamplerParameters(requestData, config);
        _applyOpenAIReasoning(requestData, config);
        break;

      case OpenAIProviderPreset.compatible:
        requestData['frequency_penalty'] = config.frequencyPenalty;
        requestData['presence_penalty'] = config.presencePenalty;
        if (config.stopSequences.isNotEmpty) {
          requestData['stop'] = config.stopSequences;
        }
        if (config.seed != -1) {
          requestData['seed'] = config.seed;
        }
        _applyExtendedSamplerParameters(requestData, config);
        _applyOpenAIReasoning(requestData, config);
        break;
    }

    return requestData;
  }

  // OpenAI / OpenAI-compatible with reasoning support
  Future<LLMResponse> _generateOpenAIWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final endpoint = '${config.apiUrl}/chat/completions';
    final requestData = _buildOpenAIRequestBody(
      messages: messages,
      config: config,
    );

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: _openAiHeaders(config),
        validateStatus: (status) => true, // Accept all status codes
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    // Check for HTTP errors
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      _log('HTTP Error: ${response.statusCode}');
      _log('Response data: ${response.data}');

      final errorMsg = _extractErrorMessage(response.data);
      throw Exception(
        'HTTP ${response.statusCode} at $endpoint. Check the API base URL and selected model.\n$errorMsg',
      );
    }

    final data = response.data as Map<String, dynamic>;
    String content = '';
    String? reasoning;
    final choices = data['choices'] as List<dynamic>?;
    if (choices != null && choices.isNotEmpty) {
      final message = (choices[0] as Map<String, dynamic>)['message']
          as Map<String, dynamic>?;
      content = message?['content'] as String? ?? '';
      // DeepSeek and some providers use reasoning_content for thinking
      reasoning = message?['reasoning_content'] as String?;
      // Also check for thought field (some providers)
      reasoning ??= message?['thought'] as String?;
      // Fallback: inline <think> tags in content (R1 via compatible endpoints)
      if (reasoning == null || reasoning.isEmpty) {
        final (extractedContent, extractedReasoning) =
            ThinkTagParser.extract(content);
        if (extractedReasoning != null) {
          content = extractedContent;
          reasoning = extractedReasoning;
        }
      }
    }

    _logResponse(config.provider.name, data,
        statusCode: response.statusCode,
        contentPreview:
            content.length > 100 ? '${content.substring(0, 100)}...' : content);

    return LLMResponse(content: content, reasoning: reasoning);
  }

  Stream<String> _streamOpenAI(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final endpoint = '${config.apiUrl}/chat/completions';
    final requestData = _buildOpenAIRequestBody(
      messages: messages,
      config: config,
      stream: true,
    );

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: _openAiHeaders(config),
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;

    await for (final chunk in stream) {
      buffer.write(chunk);
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.startsWith('data: ') && !line.contains('[DONE]')) {
          try {
            final json = jsonDecode(line.substring(6)) as Map<String, dynamic>;
            final choices = json['choices'] as List<dynamic>?;
            if (choices != null && choices.isNotEmpty) {
              final choice = choices[0] as Map<String, dynamic>;

              // Check for finish_reason and log the raw data when present
              final finishReason = choice['finish_reason'];
              if (finishReason != null) {
                _log(
                    '═══════════════════════════════════════════════════════════════');
                _log('🏁 STREAM FINISH - finish_reason: $finishReason');
                _log(
                    '───────────────────────────────────────────────────────────────');
                _log('Raw JSON: ${line.substring(6)}');
                _log(
                    '═══════════════════════════════════════════════════════════════');
              }

              final delta = choice['delta'] as Map<String, dynamic>?;
              final content = delta?['content'] as String?;
              if (content != null) {
                _logStreamChunk(config.provider.name, content,
                    isFirst: isFirst);
                isFirst = false;
                fullContent.write(content);
                yield content;
              }
            }
          } catch (e) {
            // Skip malformed lines but log them
            _log('Skipping malformed JSON line: $e');
          }
        }
      }
      // Keep incomplete line for next iteration
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
  }

  // Claude with thinking support
  Future<LLMResponse> _generateClaudeWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final systemMessage = messages.firstWhere(
      (m) => m['role'] == 'system',
      orElse: () => {'role': 'system', 'content': ''},
    );
    final chatMessages = messages.where((m) => m['role'] != 'system').toList();

    final endpoint = '${config.apiUrl}/v1/messages';
    final requestData = <String, dynamic>{
      'model': config.model,
      'max_tokens': config.maxTokens,
      'system': systemMessage['content'],
      'messages': chatMessages,
    };
    _applyClaudeThinking(requestData, config, stream: false);
    _applyClaudePromptCaching(requestData, config);

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {
          'x-api-key': config.apiKey,
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        },
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final data = response.data as Map<String, dynamic>;
    String content = '';
    String? reasoning;
    final contentList = data['content'] as List<dynamic>?;
    if (contentList != null && contentList.isNotEmpty) {
      // Claude can return multiple content blocks, some may be 'thinking' type
      for (final block in contentList) {
        final blockMap = block as Map<String, dynamic>;
        final blockType = blockMap['type'] as String?;
        if (blockType == 'thinking') {
          // This is a thinking/reasoning block
          reasoning =
              (reasoning ?? '') + (blockMap['thinking'] as String? ?? '');
        } else if (blockType == 'text') {
          // Regular text content
          content += blockMap['text'] as String? ?? '';
        }
      }
      // Fallback: if no text block found, try first block's text
      if (content.isEmpty && contentList.isNotEmpty) {
        content =
            (contentList[0] as Map<String, dynamic>)['text'] as String? ?? '';
      }
    }

    _logResponse(config.provider.name, data,
        statusCode: response.statusCode,
        contentPreview:
            content.length > 100 ? '${content.substring(0, 100)}...' : content);

    return LLMResponse(content: content, reasoning: reasoning);
  }

  Stream<String> _streamClaude(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final systemMessage = messages.firstWhere(
      (m) => m['role'] == 'system',
      orElse: () => {'role': 'system', 'content': ''},
    );
    final chatMessages = messages.where((m) => m['role'] != 'system').toList();

    final endpoint = '${config.apiUrl}/v1/messages';
    final requestData = <String, dynamic>{
      'model': config.model,
      'max_tokens': config.maxTokens,
      'system': systemMessage['content'],
      'messages': chatMessages,
      'stream': true,
    };
    _applyClaudeThinking(requestData, config, stream: true);
    _applyClaudePromptCaching(requestData, config);

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {
          'x-api-key': config.apiKey,
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;

    await for (final chunk in stream) {
      buffer.write(chunk);
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.startsWith('data: ')) {
          try {
            final json = jsonDecode(line.substring(6)) as Map<String, dynamic>;
            if (json['type'] == 'content_block_delta') {
              final delta = json['delta'] as Map<String, dynamic>?;
              final text = delta?['text'] as String?;
              if (text != null) {
                _logStreamChunk(config.provider.name, text, isFirst: isFirst);
                isFirst = false;
                fullContent.write(text);
                yield text;
              }
            }
          } catch (e) {
            // Skip malformed lines but log them
            _log('Skipping malformed JSON line: $e');
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
  }

  // Gemini with thought support
  Future<LLMResponse> _generateGeminiWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final contents = messages
        .map((m) => {
              'role': m['role'] == 'assistant' ? 'model' : m['role'],
              'parts': [
                {'text': m['content']}
              ],
            })
        .toList();

    final endpoint =
        '${config.apiUrl}/models/${config.model}:generateContent?key=${config.apiKey}';
    final generationConfig = <String, dynamic>{
      'maxOutputTokens': config.maxTokens,
      'temperature': config.temperature,
      'topP': config.topP,
      'topK': config.topK,
    };
    _applyGeminiThinking(generationConfig, config);
    final requestData = {
      'contents': contents,
      'generationConfig': generationConfig,
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final data = response.data as Map<String, dynamic>;
    String content = '';
    String? reasoning;
    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates != null && candidates.isNotEmpty) {
      final contentData = (candidates[0] as Map<String, dynamic>)['content']
          as Map<String, dynamic>?;
      final parts = contentData?['parts'] as List<dynamic>?;
      if (parts != null && parts.isNotEmpty) {
        // Gemini may have thought in separate parts
        for (final part in parts) {
          final partMap = part as Map<String, dynamic>;
          if (partMap.containsKey('thought')) {
            reasoning =
                (reasoning ?? '') + (partMap['thought'] as String? ?? '');
          }
          if (partMap.containsKey('text')) {
            content += partMap['text'] as String? ?? '';
          }
        }
      }
    }

    _logResponse(config.provider.name, data,
        statusCode: response.statusCode,
        contentPreview:
            content.length > 100 ? '${content.substring(0, 100)}...' : content);

    return LLMResponse(content: content, reasoning: reasoning);
  }

  Stream<String> _streamGemini(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    // Gemini streaming is complex, fallback to non-streaming
    final response = await _generateGeminiWithReasoning(messages, config);
    _logStreamComplete(config.provider.name, response.content);
    yield response.content;
  }

  // Ollama with reasoning support
  Future<LLMResponse> _generateOllamaWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final endpoint = '${config.apiUrl}/api/chat';
    final requestData = {
      'model': config.model,
      'messages': messages,
      'stream': false,
      'options': {
        'num_predict': config.maxTokens,
        'temperature': config.temperature,
        'top_p': config.topP,
        'top_k': config.topK,
        'repeat_penalty': config.repetitionPenalty,
        'stop': config.stopSequences,
        'seed': config.seed != -1 ? config.seed : null,
        'mirostat': config.mirostatMode,
        'mirostat_tau': config.mirostatTau,
        'mirostat_eta': config.mirostatEta,
        'tfs_z': config.tailFreeSampling,
        'typical_p': config.typicalP,
        'min_p': config.minP,
      },
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final data = response.data as Map<String, dynamic>;
    final message = data['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String? ?? '';
    // Ollama may return thinking in a separate field for some models
    final reasoning =
        message?['thinking'] as String? ?? message?['reasoning'] as String?;

    _logResponse(config.provider.name, data,
        statusCode: response.statusCode,
        contentPreview:
            content.length > 100 ? '${content.substring(0, 100)}...' : content);

    return LLMResponse(content: content, reasoning: reasoning);
  }

  Stream<String> _streamOllama(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final endpoint = '${config.apiUrl}/api/chat';
    final requestData = {
      'model': config.model,
      'messages': messages,
      'stream': true,
      'options': {
        'num_predict': config.maxTokens,
        'temperature': config.temperature,
        'top_p': config.topP,
        'top_k': config.topK,
      },
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;

    await for (final chunk in stream) {
      buffer.write(chunk);
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.isNotEmpty) {
          try {
            final json = jsonDecode(line) as Map<String, dynamic>;
            final message = json['message'] as Map<String, dynamic>?;
            final content = message?['content'] as String?;
            if (content != null) {
              _logStreamChunk(config.provider.name, content, isFirst: isFirst);
              isFirst = false;
              fullContent.write(content);
              yield content;
            }
          } catch (e) {
            // Skip malformed lines but log them
            _log('Skipping malformed JSON line: $e');
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
  }

  // KoboldCpp (typically doesn't support reasoning)
  Future<LLMResponse> _generateKoboldWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    // Build prompt from messages
    final prompt = _buildKoboldPrompt(messages);

    final endpoint = '${config.apiUrl}/api/v1/generate';
    final requestData = {
      'prompt': prompt,
      'max_length': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
      'top_k': config.topK,
      'rep_pen': config.repetitionPenalty,
      'rep_pen_range': config.repetitionPenaltyRange,
      'typical': config.typicalP,
      'tfs': config.tailFreeSampling,
      'mirostat': config.mirostatMode,
      'mirostat_tau': config.mirostatTau,
      'mirostat_eta': config.mirostatEta,
      'stop_sequence': config.stopSequences,
      'seed': config.seed != -1 ? config.seed : -1,
      'min_p': config.minP,
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final data = response.data as Map<String, dynamic>;
    String content = '';
    final results = data['results'] as List<dynamic>?;
    if (results != null && results.isNotEmpty) {
      content = (results[0] as Map<String, dynamic>)['text'] as String? ?? '';
    }

    _logResponse(config.provider.name, data,
        statusCode: response.statusCode,
        contentPreview:
            content.length > 100 ? '${content.substring(0, 100)}...' : content);

    // KoboldCpp doesn't typically return reasoning content
    return LLMResponse(content: content, reasoning: null);
  }

  Stream<String> _streamKobold(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    // KoboldCpp SSE streaming
    final prompt = _buildKoboldPrompt(messages);

    final endpoint = '${config.apiUrl}/api/extra/generate/stream';
    final requestData = {
      'prompt': prompt,
      'max_length': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
      'top_k': config.topK,
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;

    await for (final chunk in stream) {
      buffer.write(chunk);
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.startsWith('data: ')) {
          try {
            final json = jsonDecode(line.substring(6)) as Map<String, dynamic>;
            final token = json['token'] as String?;
            if (token != null) {
              _logStreamChunk(config.provider.name, token, isFirst: isFirst);
              isFirst = false;
              fullContent.write(token);
              yield token;
            }
          } catch (e) {
            // Skip malformed lines but log them
            _log('Skipping malformed JSON line: $e');
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
  }

  String _buildKoboldPrompt(List<Map<String, dynamic>> messages) {
    final buffer = StringBuffer();
    for (final msg in messages) {
      final role = msg['role'];
      final content = msg['content'] ?? '';
      if (role == 'system') {
        buffer.writeln(content);
        buffer.writeln();
      } else if (role == 'user') {
        buffer.writeln('User: $content');
      } else if (role == 'assistant') {
        buffer.writeln('Assistant: $content');
      }
    }
    buffer.write('Assistant:');
    return buffer.toString();
  }

  // ============================================
  // STREAMING WITH REASONING SUPPORT
  // ============================================

  /// OpenAI streaming with reasoning support (for o1/o3 models)
  Stream<LLMStreamChunk> _streamOpenAIWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    try {
      final endpoint = '${config.apiUrl}/chat/completions';
      final requestData = _buildOpenAIRequestBody(
        messages: messages,
        config: config,
        stream: true,
      );

      _logRequest(endpoint, requestData, config);

      final response = await _dio.post<ResponseBody>(
        endpoint,
        options: Options(
          headers: _openAiHeaders(config),
          responseType: ResponseType.stream,
          validateStatus: (status) => true, // Accept all status codes
        ),
        data: requestData,
        cancelToken: _newCancelToken(),
      );

      // Check for HTTP errors before processing stream
      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        _log('HTTP Error in stream: ${response.statusCode}');
        // For streaming, we need to read the error from the response body
        final errorBytes = await response.data!.stream.toList();
        final errorData = utf8.decode(errorBytes.expand((x) => x).toList());
        _log('Error response: $errorData');

        try {
          final errorJson = jsonDecode(errorData);
          final errorMsg = _extractErrorMessage(errorJson);
          throw Exception(
            'HTTP ${response.statusCode} at $endpoint. Check the API base URL and selected model.\n$errorMsg',
          );
        } catch (e) {
          if (e is Exception && e.toString().contains('HTTP')) {
            rethrow;
          }
          throw Exception(
            'HTTP ${response.statusCode} at $endpoint. Check the API base URL and selected model.\n$errorData',
          );
        }
      }

      final stream =
          response.data!.stream.cast<List<int>>().transform(utf8.decoder);
      final buffer = StringBuffer();
      final fullContent = StringBuffer();
      final fullReasoning = StringBuffer();
      var isFirst = true;

      await for (final chunk in stream) {
        buffer.write(chunk);
        final lines = buffer.toString().split('\n');
        buffer.clear();

        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i];
          if (line.startsWith('data: ') && !line.contains('[DONE]')) {
            try {
              final json =
                  jsonDecode(line.substring(6)) as Map<String, dynamic>;
              final choices = json['choices'] as List<dynamic>?;
              if (choices != null && choices.isNotEmpty) {
                final choice = choices[0] as Map<String, dynamic>;
                final delta = choice['delta'] as Map<String, dynamic>?;

                // Check for finish_reason and log the raw data when present
                final finishReason = choice['finish_reason'];
                if (finishReason != null) {
                  _log(
                      '═══════════════════════════════════════════════════════════════');
                  _log('🏁 STREAM FINISH - finish_reason: $finishReason');
                  _log(
                      '───────────────────────────────────────────────────────────────');
                  _log('Raw JSON: ${line.substring(6)}');
                  _log(
                      '═══════════════════════════════════════════════════════════════');
                }

                // Check for reasoning_content (OpenAI o1/o3 models)
                final reasoningContent = delta?['reasoning_content'] as String?;
                if (reasoningContent != null) {
                  _logStreamChunk(
                      config.provider.name, '[reasoning] $reasoningContent',
                      isFirst: isFirst);
                  isFirst = false;
                  fullReasoning.write(reasoningContent);
                  yield LLMStreamChunk(
                      reasoning: reasoningContent, isReasoningChunk: true);
                }

                // Regular content
                final content = delta?['content'] as String?;
                if (content != null) {
                  _logStreamChunk(config.provider.name, content,
                      isFirst: isFirst);
                  isFirst = false;
                  fullContent.write(content);
                  yield LLMStreamChunk(content: content);
                }
              }
            } catch (e) {
              // Skip malformed lines
              _log('Skipping malformed JSON line: $e');
            }
          }
        }
        if (lines.isNotEmpty) {
          buffer.write(lines.last);
        }
      }

      _logStreamComplete(config.provider.name, fullContent.toString());
      if (fullReasoning.isNotEmpty) {
        _log('Reasoning content: ${fullReasoning.toString()}');
      }
    } on DioException catch (e, stackTrace) {
      _log('DioException in stream: ${e.type}',
          error: e.message, stackTrace: stackTrace);
      _log('DioException response: ${e.response?.data}');

      final errorMessage = _formatDioException(e);
      throw Exception(errorMessage);
    } catch (e, stackTrace) {
      _log('Error in stream: $e', stackTrace: stackTrace);
      throw Exception('Stream error: $e');
    }
  }

  /// Claude streaming with thinking support
  Stream<LLMStreamChunk> _streamClaudeWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final systemMessage = messages.firstWhere(
      (m) => m['role'] == 'system',
      orElse: () => {'role': 'system', 'content': ''},
    );
    final chatMessages = messages.where((m) => m['role'] != 'system').toList();

    final endpoint = '${config.apiUrl}/v1/messages';
    final requestData = <String, dynamic>{
      'model': config.model,
      'max_tokens': config.maxTokens,
      'system': systemMessage['content'],
      'messages': chatMessages,
      'stream': true,
    };
    _applyClaudeThinking(requestData, config, stream: true);
    _applyClaudePromptCaching(requestData, config);

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {
          'x-api-key': config.apiKey,
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    final fullThinking = StringBuffer();
    var isFirst = true;
    var currentBlockType = ''; // Track current content block type

    await for (final chunk in stream) {
      buffer.write(chunk);
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.startsWith('data: ')) {
          try {
            final json = jsonDecode(line.substring(6)) as Map<String, dynamic>;
            final eventType = json['type'] as String?;

            // Track content block type for thinking blocks
            if (eventType == 'content_block_start') {
              final contentBlock =
                  json['content_block'] as Map<String, dynamic>?;
              currentBlockType = contentBlock?['type'] as String? ?? '';
            }

            if (eventType == 'content_block_delta') {
              final delta = json['delta'] as Map<String, dynamic>?;
              final deltaType = delta?['type'] as String?;

              // Check for thinking delta (Claude's extended thinking)
              if (deltaType == 'thinking_delta') {
                final thinking = delta?['thinking'] as String?;
                if (thinking != null) {
                  _logStreamChunk(config.provider.name, '[thinking] $thinking',
                      isFirst: isFirst);
                  isFirst = false;
                  fullThinking.write(thinking);
                  yield LLMStreamChunk(
                      reasoning: thinking, isReasoningChunk: true);
                }
              }
              // Regular text delta
              else if (deltaType == 'text_delta') {
                final text = delta?['text'] as String?;
                if (text != null) {
                  // Check if this is inside a thinking block
                  if (currentBlockType == 'thinking') {
                    _logStreamChunk(config.provider.name, '[thinking] $text',
                        isFirst: isFirst);
                    isFirst = false;
                    fullThinking.write(text);
                    yield LLMStreamChunk(
                        reasoning: text, isReasoningChunk: true);
                  } else {
                    _logStreamChunk(config.provider.name, text,
                        isFirst: isFirst);
                    isFirst = false;
                    fullContent.write(text);
                    yield LLMStreamChunk(content: text);
                  }
                }
              }
            }

            if (eventType == 'content_block_stop') {
              currentBlockType = '';
            }
          } catch (e) {
            // Skip malformed lines but log them
            _log('Skipping malformed JSON line: $e');
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
    if (fullThinking.isNotEmpty) {
      _log('Thinking content: ${fullThinking.toString()}');
    }
  }

  /// Gemini streaming with thought support
  Stream<LLMStreamChunk> _streamGeminiWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    // Gemini 2.0 Flash Thinking returns thought in a separate part
    final contents = messages
        .map((m) => {
              'role': m['role'] == 'assistant' ? 'model' : m['role'],
              'parts': [
                {'text': m['content']}
              ],
            })
        .toList();

    final endpoint =
        '${config.apiUrl}/models/${config.model}:streamGenerateContent?key=${config.apiKey}';
    final generationConfig = <String, dynamic>{
      'maxOutputTokens': config.maxTokens,
      'temperature': config.temperature,
      'topP': config.topP,
      'topK': config.topK,
    };
    _applyGeminiThinking(generationConfig, config);
    final requestData = {
      'contents': contents,
      'generationConfig': generationConfig,
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final decoder = _GeminiJsonArrayObjectDecoder();
    final fullContent = StringBuffer();
    final fullThought = StringBuffer();
    var isFirst = true;

    await for (final chunk in stream) {
      for (final json in decoder.add(chunk)) {
        final candidates = json['candidates'] as List<dynamic>?;
        if (candidates == null || candidates.isEmpty) continue;

        final candidate = candidates[0] as Map<String, dynamic>;
        final content = candidate['content'] as Map<String, dynamic>?;
        final contentParts = content?['parts'] as List<dynamic>?;
        if (contentParts == null) continue;

        for (final contentPart in contentParts) {
          if (contentPart is! Map<String, dynamic>) continue;

          final text = contentPart['text'] as String?;
          final thoughtValue = contentPart['thought'];
          final String? thought;
          if (thoughtValue is String && thoughtValue.isNotEmpty) {
            thought = thoughtValue;
          } else if (thoughtValue == true) {
            thought = text;
          } else {
            thought = null;
          }
          if (thought != null && thought.isNotEmpty) {
            _logStreamChunk(
              config.provider.name,
              '[thought] $thought',
              isFirst: isFirst,
            );
            isFirst = false;
            fullThought.write(thought);
            yield LLMStreamChunk(
              reasoning: thought,
              isReasoningChunk: true,
            );
          } else if (text != null && text.isNotEmpty) {
            _logStreamChunk(
              config.provider.name,
              text,
              isFirst: isFirst,
            );
            isFirst = false;
            fullContent.write(text);
            yield LLMStreamChunk(content: text);
          }
        }
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
    if (fullThought.isNotEmpty) {
      _log('Thought content: ${fullThought.toString()}');
    }
  }

  /// Ollama streaming with reasoning support
  Stream<LLMStreamChunk> _streamOllamaWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final endpoint = '${config.apiUrl}/api/chat';
    final requestData = {
      'model': config.model,
      'messages': messages,
      'stream': true,
      'options': {
        'num_predict': config.maxTokens,
        'temperature': config.temperature,
        'top_p': config.topP,
        'top_k': config.topK,
        'repeat_penalty': config.repetitionPenalty,
        'stop': config.stopSequences,
        'seed': config.seed != -1 ? config.seed : null,
        'mirostat': config.mirostatMode,
        'mirostat_tau': config.mirostatTau,
        'mirostat_eta': config.mirostatEta,
        'tfs_z': config.tailFreeSampling,
        'typical_p': config.typicalP,
        'min_p': config.minP,
      },
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;

    await for (final chunk in stream) {
      buffer.write(chunk);
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.isNotEmpty) {
          try {
            final json = jsonDecode(line) as Map<String, dynamic>;
            final message = json['message'] as Map<String, dynamic>?;
            final content = message?['content'] as String?;
            if (content != null) {
              _logStreamChunk(config.provider.name, content, isFirst: isFirst);
              isFirst = false;
              fullContent.write(content);
              yield LLMStreamChunk(content: content);
            }
          } catch (e) {
            // Skip malformed lines but log them
            _log('Skipping malformed JSON line: $e');
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
  }

  /// KoboldCpp streaming (no reasoning support)
  Stream<LLMStreamChunk> _streamKoboldWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final prompt = _buildKoboldPrompt(messages);

    final endpoint = '${config.apiUrl}/api/extra/generate/stream';
    final requestData = {
      'prompt': prompt,
      'max_length': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
      'top_k': config.topK,
      'rep_pen': config.repetitionPenalty,
      'rep_pen_range': config.repetitionPenaltyRange,
      'typical': config.typicalP,
      'tfs': config.tailFreeSampling,
      'mirostat': config.mirostatMode,
      'mirostat_tau': config.mirostatTau,
      'mirostat_eta': config.mirostatEta,
      'stop_sequence': config.stopSequences,
      'seed': config.seed != -1 ? config.seed : -1,
      'min_p': config.minP,
    };

    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.stream,
      ),
      data: requestData,
      cancelToken: _newCancelToken(),
    );

    final stream =
        response.data!.stream.cast<List<int>>().transform(utf8.decoder);
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;

    await for (final chunk in stream) {
      buffer.write(chunk);
      final lines = buffer.toString().split('\n');
      buffer.clear();

      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.startsWith('data: ')) {
          try {
            final json = jsonDecode(line.substring(6)) as Map<String, dynamic>;
            final token = json['token'] as String?;
            if (token != null) {
              _logStreamChunk(config.provider.name, token, isFirst: isFirst);
              isFirst = false;
              fullContent.write(token);
              yield LLMStreamChunk(content: token);
            }
          } catch (e) {
            // Skip malformed lines but log them
            _log('Skipping malformed JSON line: $e');
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }

    _logStreamComplete(config.provider.name, fullContent.toString());
  }
}
