import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// LLM Provider enum
enum LLMProvider {
  openai,
  claude,
  openRouter,
  gemini,
  ollama,
  koboldCpp,
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

/// LLM Configuration
class LLMConfig {
  final LLMProvider provider;
  final String model;
  final String apiKey;
  final String apiUrl;
  final int maxTokens;
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

  const LLMConfig({
    required this.provider,
    required this.model,
    required this.apiKey,
    required this.apiUrl,
    this.maxTokens = 1000000,
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
  });

  LLMConfig copyWith({
    LLMProvider? provider,
    String? model,
    String? apiKey,
    String? apiUrl,
    int? maxTokens,
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
  }) {
    return LLMConfig(
      provider: provider ?? this.provider,
      model: model ?? this.model,
      apiKey: apiKey ?? this.apiKey,
      apiUrl: apiUrl ?? this.apiUrl,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      topK: topK ?? this.topK,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      streamEnabled: streamEnabled ?? this.streamEnabled,
      typicalP: typicalP ?? this.typicalP,
      minP: minP ?? this.minP,
      repetitionPenalty: repetitionPenalty ?? this.repetitionPenalty,
      repetitionPenaltyRange: repetitionPenaltyRange ?? this.repetitionPenaltyRange,
      tailFreeSampling: tailFreeSampling ?? this.tailFreeSampling,
      topA: topA ?? this.topA,
      mirostatMode: mirostatMode ?? this.mirostatMode,
      mirostatTau: mirostatTau ?? this.mirostatTau,
      mirostatEta: mirostatEta ?? this.mirostatEta,
      stopSequences: stopSequences ?? this.stopSequences,
      seed: seed ?? this.seed,
    );
  }

  Map<String, dynamic> toJson() => {
        'provider': provider.name,
        'model': model,
        'apiKey': apiKey,
        'apiUrl': apiUrl,
        'maxTokens': maxTokens,
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
      };

  factory LLMConfig.fromJson(Map<String, dynamic> json) => LLMConfig(
        provider: LLMProvider.values.firstWhere(
          (p) => p.name == json['provider'],
          orElse: () => LLMProvider.openai,
        ),
        model: json['model'] as String? ?? 'gpt-4o',
        apiKey: json['apiKey'] as String? ?? '',
        apiUrl: json['apiUrl'] as String? ?? 'https://api.openai.com/v1',
        maxTokens: json['maxTokens'] as int? ?? 1000000,
        temperature: (json['temperature'] as num?)?.toDouble() ?? 0.8,
        topP: (json['topP'] as num?)?.toDouble() ?? 0.95,
        topK: json['topK'] as int? ?? 40,
        frequencyPenalty: (json['frequencyPenalty'] as num?)?.toDouble() ?? 0.0,
        presencePenalty: (json['presencePenalty'] as num?)?.toDouble() ?? 0.0,
        streamEnabled: json['streamEnabled'] as bool? ?? true,
        typicalP: (json['typicalP'] as num?)?.toDouble() ?? 1.0,
        minP: (json['minP'] as num?)?.toDouble() ?? 0.0,
        repetitionPenalty: (json['repetitionPenalty'] as num?)?.toDouble() ?? 1.0,
        repetitionPenaltyRange: json['repetitionPenaltyRange'] as int? ?? 0,
        tailFreeSampling: (json['tailFreeSampling'] as num?)?.toDouble() ?? 1.0,
        topA: (json['topA'] as num?)?.toDouble() ?? 0.0,
        mirostatMode: json['mirostatMode'] as int? ?? 0,
        mirostatTau: (json['mirostatTau'] as num?)?.toDouble() ?? 5.0,
        mirostatEta: (json['mirostatEta'] as num?)?.toDouble() ?? 0.1,
        stopSequences: (json['stopSequences'] as List<dynamic>?)?.cast<String>() ?? const [],
        seed: json['seed'] as int? ?? -1,
      );
}

/// LLM Service for generating responses
class LLMService {
  final Dio _dio = Dio();
  
  /// Log a message to the console
  void _log(String message, {String? error, StackTrace? stackTrace}) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] LLMService: $message';
    
    if (kDebugMode) {
      debugPrint(logMessage);
      if (error != null) {
        debugPrint('  Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('  StackTrace: $stackTrace');
      }
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
  void _logRequest(String endpoint, Map<String, dynamic> data, LLMConfig config) {
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
        final content = msg['content'] as String? ?? '';
        final preview = content.length > 200 ? '${content.substring(0, 200)}...' : content;
        _log('  [$i] $role: $preview');
      }
    }
    
    // Log system message for Claude
    final system = data['system'] as String?;
    if (system != null) {
      final preview = system.length > 200 ? '${system.substring(0, 200)}...' : system;
      _log('System: $preview');
    }
    
    // Log prompt for KoboldCpp
    final prompt = data['prompt'] as String?;
    if (prompt != null) {
      final preview = prompt.length > 500 ? '${prompt.substring(0, 500)}...' : prompt;
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
  void _logResponse(String provider, dynamic responseData, {int? statusCode, String? contentPreview}) {
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
        final encoder = const JsonEncoder.withIndent('  ');
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
  void _logStreamChunk(String provider, String chunk, {bool isFirst = false, bool isLast = false}) {
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

  /// Generate a response (non-streaming)
  Future<String> generate(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    switch (config.provider) {
      case LLMProvider.openai:
        return _generateOpenAI(messages, config);
      case LLMProvider.claude:
        return _generateClaude(messages, config);
      case LLMProvider.openRouter:
        return _generateOpenRouter(messages, config);
      case LLMProvider.gemini:
        return _generateGemini(messages, config);
      case LLMProvider.ollama:
        return _generateOllama(messages, config);
      case LLMProvider.koboldCpp:
        return _generateKobold(messages, config);
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

  /// Generate a streaming response with reasoning/thinking support
  Stream<LLMStreamChunk> generateStreamWithReasoning(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) {
    switch (config.provider) {
      case LLMProvider.openai:
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
    _log('API Key: ${config.apiKey.isEmpty ? "(empty)" : "${config.apiKey.substring(0, 8)}..."}');
    
    try {
      switch (config.provider) {
        case LLMProvider.openai:
        case LLMProvider.openRouter:
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
              'model': config.model.isNotEmpty ? config.model : 'claude-3-5-sonnet-20241022',
              'max_tokens': 1,
              'messages': [{'role': 'user', 'content': 'Hi'}],
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
            _log('Success: Connected to Claude API (400 response but connection works)');
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
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout - check if the server is running');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error - check URL: ${config.apiUrl}');
      } else if (e.type == DioExceptionType.unknown) {
        final message = e.message ?? e.error?.toString() ?? 'Unknown error';
        throw Exception('Network error: $message');
      }
      throw Exception('Request failed: ${e.message}');
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
      // OpenAI format
      if (data['error'] is Map) {
        return (data['error'] as Map)['message']?.toString() ?? 'Unknown error';
      }
      // Claude format
      if (data['error'] is Map) {
        return (data['error'] as Map)['message']?.toString() ?? 'Unknown error';
      }
      // Generic
      return data['message']?.toString() ??
             data['error']?.toString() ??
             data.toString();
    }
    return data.toString();
  }

  /// Get available models
  Future<List<String>> getAvailableModels(LLMConfig config) async {
    _log('Fetching available models for ${config.provider.name}');
    
    try {
      switch (config.provider) {
        case LLMProvider.openai:
        case LLMProvider.openRouter:
          _log('Fetching models from ${config.apiUrl}/models');
          final response = await _dio.get(
            '${config.apiUrl}/models',
            options: Options(
              headers: {'Authorization': 'Bearer ${config.apiKey}'},
            ),
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
          // Claude doesn't have a models endpoint, return known models
          _log('Returning predefined Claude models');
          return [
            'claude-3-5-sonnet-20241022',
            'claude-3-5-haiku-20241022',
            'claude-3-opus-20240229',
            'claude-3-sonnet-20240229',
            'claude-3-haiku-20240307',
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
          final modelIds = models
              .map((m) {
                final name = (m as Map<String, dynamic>)['name'] as String;
                // Remove 'models/' prefix
                return name.startsWith('models/') ? name.substring(7) : name;
              })
              .toList();
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

  // OpenAI
  Future<String> _generateOpenAI(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final endpoint = '${config.apiUrl}/chat/completions';
    final requestData = {
      'model': config.model,
      'messages': messages,
      'max_tokens': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
      'frequency_penalty': config.frequencyPenalty,
      'presence_penalty': config.presencePenalty,
    };
    
    _logRequest(endpoint, requestData, config);
    
    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
        },
      ),
      data: requestData,
    );

    final data = response.data as Map<String, dynamic>;
    String content = '';
    final choices = data['choices'] as List<dynamic>?;
    if (choices != null && choices.isNotEmpty) {
      final message = (choices[0] as Map<String, dynamic>)['message'] as Map<String, dynamic>?;
      content = message?['content'] as String? ?? '';
    }
    
    _logResponse(config.provider.name, data,
      statusCode: response.statusCode,
      contentPreview: content.length > 100 ? '${content.substring(0, 100)}...' : content);
    
    return content;
  }

  Stream<String> _streamOpenAI(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    final endpoint = '${config.apiUrl}/chat/completions';
    final requestData = {
      'model': config.model,
      'messages': messages,
      'max_tokens': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
      'frequency_penalty': config.frequencyPenalty,
      'presence_penalty': config.presencePenalty,
      'stream': true,
    };
    
    _logRequest(endpoint, requestData, config);
    
    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.stream,
      ),
      data: requestData,
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
      final lines = buffer.toString().split('\n');
      buffer.clear();
      
      for (int i = 0; i < lines.length - 1; i++) {
        final line = lines[i];
        if (line.startsWith('data: ') && !line.contains('[DONE]')) {
          try {
            final json = jsonDecode(line.substring(6)) as Map<String, dynamic>;
            final choices = json['choices'] as List<dynamic>?;
            if (choices != null && choices.isNotEmpty) {
              final delta = (choices[0] as Map<String, dynamic>)['delta'] as Map<String, dynamic>?;
              final content = delta?['content'] as String?;
              if (content != null) {
                _logStreamChunk(config.provider.name, content, isFirst: isFirst);
                isFirst = false;
                fullContent.write(content);
                yield content;
              }
            }
          } catch (e) {
            // Skip malformed lines
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

  // Claude
  Future<String> _generateClaude(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final systemMessage = messages.firstWhere(
      (m) => m['role'] == 'system',
      orElse: () => {'role': 'system', 'content': ''},
    );
    final chatMessages = messages.where((m) => m['role'] != 'system').toList();

    final endpoint = '${config.apiUrl}/v1/messages';
    final requestData = {
      'model': config.model,
      'max_tokens': config.maxTokens,
      'system': systemMessage['content'],
      'messages': chatMessages,
    };
    
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
    );

    final data = response.data as Map<String, dynamic>;
    String content = '';
    final contentList = data['content'] as List<dynamic>?;
    if (contentList != null && contentList.isNotEmpty) {
      content = (contentList[0] as Map<String, dynamic>)['text'] as String? ?? '';
    }
    
    _logResponse(config.provider.name, data,
      statusCode: response.statusCode,
      contentPreview: content.length > 100 ? '${content.substring(0, 100)}...' : content);
    
    return content;
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
    final requestData = {
      'model': config.model,
      'max_tokens': config.maxTokens,
      'system': systemMessage['content'],
      'messages': chatMessages,
      'stream': true,
    };
    
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
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
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
            // Skip malformed lines
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }
    
    _logStreamComplete(config.provider.name, fullContent.toString());
  }

  // OpenRouter (uses OpenAI format)
  Future<String> _generateOpenRouter(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    return _generateOpenAI(messages, config);
  }

  // Gemini
  Future<String> _generateGemini(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async {
    final contents = messages.map((m) => {
      'role': m['role'] == 'assistant' ? 'model' : m['role'],
      'parts': [{'text': m['content']}],
    }).toList();

    final endpoint = '${config.apiUrl}/models/${config.model}:generateContent?key=${config.apiKey}';
    final requestData = {
      'contents': contents,
      'generationConfig': {
        'maxOutputTokens': config.maxTokens,
        'temperature': config.temperature,
        'topP': config.topP,
        'topK': config.topK,
      },
    };
    
    _logRequest(endpoint, requestData, config);

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: requestData,
    );

    final data = response.data as Map<String, dynamic>;
    String content = '';
    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates != null && candidates.isNotEmpty) {
      final contentData = (candidates[0] as Map<String, dynamic>)['content'] as Map<String, dynamic>?;
      final parts = contentData?['parts'] as List<dynamic>?;
      if (parts != null && parts.isNotEmpty) {
        content = (parts[0] as Map<String, dynamic>)['text'] as String? ?? '';
      }
    }
    
    _logResponse(config.provider.name, data,
      statusCode: response.statusCode,
      contentPreview: content.length > 100 ? '${content.substring(0, 100)}...' : content);
    
    return content;
  }

  Stream<String> _streamGemini(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) async* {
    // Gemini streaming is complex, fallback to non-streaming
    final content = await _generateGemini(messages, config);
    _logStreamComplete(config.provider.name, content);
    yield content;
  }

  // Ollama
  Future<String> _generateOllama(
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
      },
    };
    
    _logRequest(endpoint, requestData, config);
    
    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: requestData,
    );

    final data = response.data as Map<String, dynamic>;
    final message = data['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String? ?? '';
    
    _logResponse(config.provider.name, data,
      statusCode: response.statusCode,
      contentPreview: content.length > 100 ? '${content.substring(0, 100)}...' : content);
    
    return content;
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
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
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
            // Skip malformed lines
          }
        }
      }
      if (lines.isNotEmpty) {
        buffer.write(lines.last);
      }
    }
    
    _logStreamComplete(config.provider.name, fullContent.toString());
  }

  // KoboldCpp
  Future<String> _generateKobold(
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
    };
    
    _logRequest(endpoint, requestData, config);

    final response = await _dio.post(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: requestData,
    );

    final data = response.data as Map<String, dynamic>;
    String content = '';
    final results = data['results'] as List<dynamic>?;
    if (results != null && results.isNotEmpty) {
      content = (results[0] as Map<String, dynamic>)['text'] as String? ?? '';
    }
    
    _logResponse(config.provider.name, data,
      statusCode: response.statusCode,
      contentPreview: content.length > 100 ? '${content.substring(0, 100)}...' : content);
    
    return content;
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
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
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
            // Skip malformed lines
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
    final endpoint = '${config.apiUrl}/chat/completions';
    final requestData = {
      'model': config.model,
      'messages': messages,
      'max_tokens': config.maxTokens,
      'temperature': config.temperature,
      'top_p': config.topP,
      'frequency_penalty': config.frequencyPenalty,
      'presence_penalty': config.presencePenalty,
      'stream': true,
    };
    
    _logRequest(endpoint, requestData, config);
    
    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${config.apiKey}',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.stream,
      ),
      data: requestData,
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    final fullReasoning = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
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
              final delta = choice['delta'] as Map<String, dynamic>?;
              
              // Check for reasoning_content (OpenAI o1/o3 models)
              final reasoningContent = delta?['reasoning_content'] as String?;
              if (reasoningContent != null) {
                _logStreamChunk(config.provider.name, '[reasoning] $reasoningContent', isFirst: isFirst);
                isFirst = false;
                fullReasoning.write(reasoningContent);
                yield LLMStreamChunk(reasoning: reasoningContent, isReasoningChunk: true);
              }
              
              // Regular content
              final content = delta?['content'] as String?;
              if (content != null) {
                _logStreamChunk(config.provider.name, content, isFirst: isFirst);
                isFirst = false;
                fullContent.write(content);
                yield LLMStreamChunk(content: content);
              }
            }
          } catch (e) {
            // Skip malformed lines
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
    final requestData = {
      'model': config.model,
      'max_tokens': config.maxTokens,
      'system': systemMessage['content'],
      'messages': chatMessages,
      'stream': true,
    };
    
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
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    final fullThinking = StringBuffer();
    var isFirst = true;
    var currentBlockType = ''; // Track current content block type
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
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
              final contentBlock = json['content_block'] as Map<String, dynamic>?;
              currentBlockType = contentBlock?['type'] as String? ?? '';
            }
            
            if (eventType == 'content_block_delta') {
              final delta = json['delta'] as Map<String, dynamic>?;
              final deltaType = delta?['type'] as String?;
              
              // Check for thinking delta (Claude's extended thinking)
              if (deltaType == 'thinking_delta') {
                final thinking = delta?['thinking'] as String?;
                if (thinking != null) {
                  _logStreamChunk(config.provider.name, '[thinking] $thinking', isFirst: isFirst);
                  isFirst = false;
                  fullThinking.write(thinking);
                  yield LLMStreamChunk(reasoning: thinking, isReasoningChunk: true);
                }
              }
              // Regular text delta
              else if (deltaType == 'text_delta') {
                final text = delta?['text'] as String?;
                if (text != null) {
                  // Check if this is inside a thinking block
                  if (currentBlockType == 'thinking') {
                    _logStreamChunk(config.provider.name, '[thinking] $text', isFirst: isFirst);
                    isFirst = false;
                    fullThinking.write(text);
                    yield LLMStreamChunk(reasoning: text, isReasoningChunk: true);
                  } else {
                    _logStreamChunk(config.provider.name, text, isFirst: isFirst);
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
            // Skip malformed lines
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
    final contents = messages.map((m) => {
      'role': m['role'] == 'assistant' ? 'model' : m['role'],
      'parts': [{'text': m['content']}],
    }).toList();

    final endpoint = '${config.apiUrl}/models/${config.model}:streamGenerateContent?key=${config.apiKey}';
    final requestData = {
      'contents': contents,
      'generationConfig': {
        'maxOutputTokens': config.maxTokens,
        'temperature': config.temperature,
        'topP': config.topP,
        'topK': config.topK,
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
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    final fullThought = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
      
      // Gemini streams JSON array chunks
      try {
        // Try to parse accumulated buffer as JSON
        var jsonStr = buffer.toString().trim();
        // Remove leading [ if present
        if (jsonStr.startsWith('[')) {
          jsonStr = jsonStr.substring(1);
        }
        // Remove trailing ] if present
        if (jsonStr.endsWith(']')) {
          jsonStr = jsonStr.substring(0, jsonStr.length - 1);
        }
        // Split by },{ to get individual objects
        final parts = jsonStr.split(RegExp(r'\}\s*,\s*\{'));
        
        for (var i = 0; i < parts.length; i++) {
          var part = parts[i];
          if (i > 0) part = '{$part';
          if (i < parts.length - 1) part = '$part}';
          
          try {
            final json = jsonDecode(part) as Map<String, dynamic>;
            final candidates = json['candidates'] as List<dynamic>?;
            if (candidates != null && candidates.isNotEmpty) {
              final candidate = candidates[0] as Map<String, dynamic>;
              final content = candidate['content'] as Map<String, dynamic>?;
              final contentParts = content?['parts'] as List<dynamic>?;
              
              if (contentParts != null) {
                for (final contentPart in contentParts) {
                  final partMap = contentPart as Map<String, dynamic>;
                  
                  // Check for thought (Gemini 2.0 Flash Thinking)
                  final thought = partMap['thought'] as String?;
                  if (thought != null) {
                    _logStreamChunk(config.provider.name, '[thought] $thought', isFirst: isFirst);
                    isFirst = false;
                    fullThought.write(thought);
                    yield LLMStreamChunk(reasoning: thought, isReasoningChunk: true);
                  }
                  
                  // Regular text
                  final text = partMap['text'] as String?;
                  if (text != null) {
                    _logStreamChunk(config.provider.name, text, isFirst: isFirst);
                    isFirst = false;
                    fullContent.write(text);
                    yield LLMStreamChunk(content: text);
                  }
                }
              }
            }
          } catch (e) {
            // Part not yet complete, continue
          }
        }
      } catch (e) {
        // Buffer not yet parseable, continue accumulating
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
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
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
            // Skip malformed lines
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
    };
    
    _logRequest(endpoint, requestData, config);

    final response = await _dio.post<ResponseBody>(
      endpoint,
      options: Options(
        headers: {'Content-Type': 'application/json'},
        responseType: ResponseType.stream,
      ),
      data: requestData,
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();
    final fullContent = StringBuffer();
    var isFirst = true;
    
    await for (final bytes in stream) {
      buffer.write(utf8.decode(bytes));
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
            // Skip malformed lines
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