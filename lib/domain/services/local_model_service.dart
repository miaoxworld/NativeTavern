import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:native_tavern/domain/services/llm_service.dart';

class LocalModelDetails {
  final String name;
  final int? contextLength;
  final String? systemPrompt;
  final String? template;

  LocalModelDetails({
    required this.name,
    this.contextLength,
    this.systemPrompt,
    this.template,
  });
}

class OllamaPullProgress {
  final String status;
  final String? digest;
  final int total;
  final int completed;

  OllamaPullProgress({
    required this.status,
    this.digest,
    this.total = 0,
    this.completed = 0,
  });

  double get percent => total > 0 ? completed / total : 0.0;
}

class LocalModelService {
  final http.Client _client;

  LocalModelService({http.Client? client}) : _client = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // OLLAMA API
  // ---------------------------------------------------------------------------

  /// Gets detailed info about an Ollama model, including its architecture context window length.
  Future<LocalModelDetails> getOllamaModelDetails(
      LLMConfig config, String modelName) async {
    final uri = Uri.parse('${config.apiUrl.replaceAll(RegExp(r'/$'), '')}/api/show');
    final response =
        await _client.post(uri, body: jsonEncode({'name': modelName}));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to get Ollama model details: ${response.statusCode}');
    }
    
    final data = jsonDecode(response.body);
    int? contextLength;
    
    // Parse context length from model_info
    final modelInfo = data['model_info'];
    if (modelInfo != null && modelInfo is Map) {
      for (final key in modelInfo.keys) {
        if (key.toString().endsWith('.context_length')) {
          contextLength = modelInfo[key] as int?;
          break;
        }
      }
    }

    // Check parameters if num_ctx is explicitly set
    final parameters = data['parameters'] as String?;
    if (parameters != null) {
      final numCtxMatch = RegExp(r'num_ctx\s+(\d+)').firstMatch(parameters);
      if (numCtxMatch != null) {
        contextLength = int.tryParse(numCtxMatch.group(1)!);
      }
    }

    return LocalModelDetails(
      name: modelName,
      contextLength: contextLength,
      systemPrompt: data['system'] as String?,
      template: data['template'] as String?,
    );
  }

  /// Extracts the model name from a string, supporting hf.co tags and full urls.
  String _normalizeModelName(String modelName) {
    if (modelName.startsWith('https://huggingface.co/')) {
      return modelName.replaceFirst('https://huggingface.co/', 'hf.co/');
    }
    return modelName;
  }

  /// Pulls a model from Ollama, supporting regular models and Hugging Face repositories.
  Future<void> pullModel(
    LLMConfig config,
    String modelName, {
    void Function(OllamaPullProgress)? onProgress,
  }) async {
    final uri = Uri.parse('${config.apiUrl.replaceAll(RegExp(r'/$'), '')}/api/pull');
    final normalizedName = _normalizeModelName(modelName);

    final request = http.Request('POST', uri)
      ..body = jsonEncode({'name': normalizedName, 'stream': true});

    final response = await _client.send(request);

    if (response.statusCode != 200) {
      throw Exception('Failed to pull Ollama model: ${response.statusCode}');
    }

    await for (final chunk in response.stream.transform(utf8.decoder)) {
      final lines = chunk.split('\n');
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          final data = jsonDecode(line);
          if (onProgress != null) {
            onProgress(OllamaPullProgress(
              status: data['status'] as String? ?? 'Downloading...',
              digest: data['digest'] as String?,
              total: data['total'] as int? ?? 0,
              completed: data['completed'] as int? ?? 0,
            ));
          }
        } catch (_) {}
      }
    }
  }

  /// Creates a new derivative model in Ollama via a Modelfile.
  Future<void> createDerivativeModel(
    LLMConfig config, {
    required String newModel,
    required String baseModel,
    String? systemPrompt,
    int? contextLength,
    double? temperature,
    double? topP,
    List<String>? stopSequences,
    String? template,
    void Function(String)? onProgress,
  }) async {
    final uri = Uri.parse('${config.apiUrl.replaceAll(RegExp(r'/$'), '')}/api/create');
    final normalizedBaseName = _normalizeModelName(baseModel);

    final modelfile = StringBuffer();
    modelfile.writeln('FROM $normalizedBaseName');

    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      modelfile.writeln('SYSTEM """\n$systemPrompt\n"""');
    }
    if (template != null && template.isNotEmpty) {
      modelfile.writeln('TEMPLATE """\n$template\n"""');
    }
    if (contextLength != null) {
      modelfile.writeln('PARAMETER num_ctx $contextLength');
    }
    if (temperature != null) {
      modelfile.writeln('PARAMETER temperature $temperature');
    }
    if (topP != null) {
      modelfile.writeln('PARAMETER top_p $topP');
    }
    if (stopSequences != null) {
      for (final stop in stopSequences) {
        modelfile.writeln('PARAMETER stop "$stop"');
      }
    }

    final request = http.Request('POST', uri)
      ..body = jsonEncode({
        'name': newModel,
        'modelfile': modelfile.toString(),
        'stream': true,
      });

    final response = await _client.send(request);
    if (response.statusCode != 200) {
      throw Exception('Failed to create model: ${response.statusCode}');
    }

    await for (final chunk in response.stream.transform(utf8.decoder)) {
      final lines = chunk.split('\n');
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          final data = jsonDecode(line);
          if (onProgress != null && data['status'] != null) {
            onProgress(data['status'] as String);
          }
        } catch (_) {}
      }
    }
  }

  Future<void> deleteModel(LLMConfig config, String modelName) async {
    final uri = Uri.parse('${config.apiUrl.replaceAll(RegExp(r'/$'), '')}/api/delete');
    final request = http.Request('DELETE', uri)
      ..body = jsonEncode({'name': modelName});
    final response = await _client.send(request);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete model: ${response.statusCode}');
    }
  }

  // ---------------------------------------------------------------------------
  // LM STUDIO & LLAMA.CPP API
  // ---------------------------------------------------------------------------

  Future<int?> getLMStudioContextLimit(LLMConfig config) async {
    try {
      final baseUrl = config.apiUrl.replaceAll(RegExp(r'/v1/?$'), '');
      final uri = Uri.parse('$baseUrl/api/v1/models');
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dataList = data['data'] as List?;
        if (dataList != null) {
          for (final item in dataList) {
            if (item['id'] == config.model) {
              return item['config']?['context_length'] as int?;
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<int?> getLlamaCppContextLimit(LLMConfig config) async {
    try {
      final uri = Uri.parse('${config.apiUrl.replaceAll(RegExp(r'/$'), '')}/props');
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['default_generation_settings']?['n_ctx'] as int?;
      }
    } catch (_) {}
    return null;
  }

  // ---------------------------------------------------------------------------
  // UNIFIED CONTEXT LIMIT DETECTION
  // ---------------------------------------------------------------------------

  Future<int?> detectContextLimit(LLMConfig config, String modelName) async {
    try {
      if (config.provider == LLMProvider.ollama) {
        final details = await getOllamaModelDetails(config, modelName);
        return details.contextLength;
      } else if (config.provider == LLMProvider.koboldCpp) {
        return await getLlamaCppContextLimit(config);
      } else if (config.provider == LLMProvider.lmStudio) {
        return await getLMStudioContextLimit(config);
      }
    } catch (_) {}
    return null;
  }
}
