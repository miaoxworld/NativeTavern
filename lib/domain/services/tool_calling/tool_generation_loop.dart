import 'dart:async';

import 'package:native_tavern/domain/models/built_in_tool.dart';
import 'package:native_tavern/domain/models/mcp.dart';
import 'package:native_tavern/domain/models/tool_calling.dart';
import 'package:native_tavern/domain/models/tool_generation.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/mcp/mcp_client_manager.dart';
import 'package:native_tavern/domain/services/tokenizer_service.dart';
import 'package:native_tavern/domain/services/tool_calling/built_in_tool_service.dart';
import 'package:native_tavern/domain/services/tool_calling/claude_tool_calling_adapter.dart';
import 'package:native_tavern/domain/services/tool_calling/gemini_tool_calling_adapter.dart';
import 'package:native_tavern/domain/services/tool_calling/openai_tool_calling_adapter.dart';
import 'package:native_tavern/domain/services/tool_calling/tool_calling_adapter.dart';

typedef ToolGenerationTransport = Future<ToolProviderTurn> Function({
  required List<Map<String, dynamic>> baseMessages,
  required List<Map<String, dynamic>> continuationMessages,
  required LLMConfig config,
  required ToolCallingConfiguration toolConfiguration,
  required ToolCallingAdapter adapter,
  required ToolCancellationToken cancellationToken,
});

typedef ToolProgressCallback = void Function(ToolCallProgress progress);

final class ToolGenerationLoop {
  ToolGenerationLoop({
    required this.builtInTools,
    required this.mcpManager,
    required this.transport,
    TokenizerService? tokenizer,
  }) : _tokenizer = tokenizer ?? TokenizerService();

  final BuiltInToolExecutionService builtInTools;
  final McpClientManager mcpManager;
  final ToolGenerationTransport transport;
  final TokenizerService _tokenizer;

  Future<ToolGenerationResult?> run({
    required String chatId,
    required List<Map<String, dynamic>> messages,
    required LLMConfig config,
    required ToolCallingSettings settings,
    required ToolCapabilitySnapshot capabilities,
    required ToolCancellationToken cancellationToken,
    ToolApprovalHandler? requestBuiltInApproval,
    McpApprovalHandler? requestMcpApproval,
    ToolProgressCallback? onProgress,
  }) async {
    if (!settings.enabled) return null;
    final adapter = adapterForProvider(config.provider);
    if (adapter == null) return null;

    await mcpManager.initialize();
    final catalog = _catalog(settings);
    if (catalog.definitions.isEmpty) return null;

    final limits = settings.limits..validate();
    final localCancellation = ToolCancellationController();
    cancellationToken.whenCancelled(localCancellation.cancel);
    final stopwatch = Stopwatch()..start();
    final continuation = <Map<String, dynamic>>[];
    var callCount = 0;
    var toolRounds = 0;
    var estimatedTokens = 0;
    String? lastText;
    String? lastReasoning;

    try {
      while (true) {
        localCancellation.token.throwIfCancelled();
        final turn = await _withinDeadline(
          transport(
            baseMessages: messages,
            continuationMessages: continuation,
            config: config,
            toolConfiguration: ToolCallingConfiguration.enabled(
              tools: catalog.definitions,
              maxRecursionDepth: limits.maxToolRounds,
            ),
            adapter: adapter,
            cancellationToken: localCancellation.token,
          ),
          stopwatch,
          limits,
          localCancellation,
        );
        localCancellation.token.throwIfCancelled();
        lastText = turn.assistant.text;
        lastReasoning = turn.assistant.reasoning;
        estimatedTokens += _estimateTurn(turn.assistant);
        if (estimatedTokens > limits.maxTokenBudget) {
          return _limited(
            code: 'token_limit',
            message: 'Tool generation stopped at the configured token limit.',
            lastText: lastText,
            lastReasoning: lastReasoning,
            toolRounds: toolRounds,
            callCount: callCount,
            estimatedTokens: estimatedTokens,
          );
        }
        if (!turn.assistant.hasToolCalls) {
          return ToolGenerationResult(
            content: turn.assistant.text,
            reasoning: turn.assistant.reasoning,
            toolRounds: toolRounds,
            callCount: callCount,
            estimatedTokens: estimatedTokens,
          );
        }
        if (toolRounds >= limits.maxToolRounds) {
          _reportStoppedCalls(
            chatId: chatId,
            calls: turn.assistant.toolCalls,
            catalog: catalog,
            message: 'Tool round limit reached.',
            onProgress: onProgress,
          );
          return _limited(
            code: 'recursion_limit',
            message: 'Tool generation stopped at the configured round limit.',
            lastText: lastText,
            lastReasoning: lastReasoning,
            toolRounds: toolRounds,
            callCount: callCount,
            estimatedTokens: estimatedTokens,
          );
        }
        if (callCount + turn.assistant.toolCalls.length > limits.maxCalls) {
          _reportStoppedCalls(
            chatId: chatId,
            calls: turn.assistant.toolCalls,
            catalog: catalog,
            message: 'Tool call limit reached.',
            onProgress: onProgress,
          );
          return _limited(
            code: 'call_limit',
            message: 'Tool generation stopped at the configured call limit.',
            lastText: lastText,
            lastReasoning: lastReasoning,
            toolRounds: toolRounds,
            callCount: callCount,
            estimatedTokens: estimatedTokens,
          );
        }

        continuation.add(turn.continuationMessage);
        final results = <ToolResultMessage>[];
        for (final call in turn.assistant.toolCalls) {
          localCancellation.token.throwIfCancelled();
          callCount++;
          try {
            final result = await _withinDeadline(
              _execute(
                chatId: chatId,
                call: call,
                catalog: catalog,
                capabilities: capabilities,
                cancellationToken: localCancellation.token,
                requestBuiltInApproval: requestBuiltInApproval,
                requestMcpApproval: requestMcpApproval,
                onProgress: onProgress,
                maxDepth: limits.maxToolRounds,
              ),
              stopwatch,
              limits,
              localCancellation,
            );
            results.add(result);
            estimatedTokens += _tokenizer.estimateTokenCount(
              toolOutputAsText(result.output),
            );
          } on ToolProtocolException catch (error) {
            if (error.code != 'tool_timeout') rethrow;
            _reportStoppedCalls(
              chatId: chatId,
              calls: [call],
              catalog: catalog,
              message: error.message,
              onProgress: onProgress,
            );
            rethrow;
          }
          if (estimatedTokens > limits.maxTokenBudget) {
            return _limited(
              code: 'token_limit',
              message: 'Tool generation stopped at the configured token limit.',
              lastText: lastText,
              lastReasoning: lastReasoning,
              toolRounds: toolRounds,
              callCount: callCount,
              estimatedTokens: estimatedTokens,
            );
          }
        }
        continuation.addAll(results.map(adapter.encodeResult));
        toolRounds++;
      }
    } on ToolProtocolException catch (error) {
      if (error.code != 'tool_timeout') rethrow;
      return _limited(
        code: error.code,
        message: error.message,
        lastText: lastText,
        lastReasoning: lastReasoning,
        toolRounds: toolRounds,
        callCount: callCount,
        estimatedTokens: estimatedTokens,
      );
    } finally {
      stopwatch.stop();
    }
  }

  void _reportStoppedCalls({
    required String chatId,
    required Iterable<ToolCall> calls,
    required _ToolCatalog catalog,
    required String message,
    ToolProgressCallback? onProgress,
  }) {
    for (final call in calls) {
      final builtIn = catalog.builtIns[call.name];
      final mcp = catalog.mcpTools[call.name];
      onProgress?.call(
        _progress(
          chatId,
          call,
          builtIn?.accessLevel ??
              mcp?.accessLevel ??
              ToolAccessLevel.externalSideEffect,
          builtIn?.target ??
              (mcp == null
                  ? 'tool:unregistered'
                  : 'mcp:${mcp.serverId}/${mcp.name}'),
          ToolCallProgressStatus.failed,
          message,
        ),
      );
    }
  }

  static ToolCallingAdapter? adapterForProvider(LLMProvider provider) {
    return switch (provider) {
      LLMProvider.claude => const ClaudeToolCallingAdapter(),
      LLMProvider.gemini => const GeminiToolCallingAdapter(),
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
        const OpenAiToolCallingAdapter(),
      LLMProvider.ollama || LLMProvider.koboldCpp => null,
    };
  }

  _ToolCatalog _catalog(ToolCallingSettings settings) {
    final builtIns = <String, BuiltInToolDescriptor>{};
    final definitions = <ToolDefinition>[];
    for (final descriptor in builtInTools.registry.descriptors) {
      final name = descriptor.definition.name;
      if (!settings.enabledBuiltInTools.contains(name)) continue;
      builtIns[name] = descriptor;
      definitions.add(descriptor.definition);
    }

    final mcpTools = <String, McpToolDescriptor>{};
    if (mcpManager.enabled) {
      for (final tool in mcpManager.discoveredTools) {
        if (mcpManager.permissionFor(tool.serverId, tool.name) ==
            McpToolPermission.denied) {
          continue;
        }
        try {
          final definition = ToolDefinition(
            name: tool.qualifiedName,
            description: '[MCP ${tool.serverId}] ${tool.description}',
            inputSchema: tool.inputSchema,
          );
          if (builtIns.containsKey(definition.name) ||
              mcpTools.containsKey(definition.name)) {
            continue;
          }
          mcpTools[definition.name] = tool;
          definitions.add(definition);
        } on ToolProtocolException {
          continue;
        }
      }
    }
    return _ToolCatalog(
      definitions: definitions,
      builtIns: builtIns,
      mcpTools: mcpTools,
    );
  }

  Future<ToolResultMessage> _execute({
    required String chatId,
    required ToolCall call,
    required _ToolCatalog catalog,
    required ToolCapabilitySnapshot capabilities,
    required ToolCancellationToken cancellationToken,
    required int maxDepth,
    ToolApprovalHandler? requestBuiltInApproval,
    McpApprovalHandler? requestMcpApproval,
    ToolProgressCallback? onProgress,
  }) async {
    final builtIn = catalog.builtIns[call.name];
    if (builtIn != null) {
      BuiltInToolExecutionPlan plan;
      try {
        plan = builtInTools.prepare(call);
      } catch (_) {
        final progress = _progress(
          chatId,
          call,
          builtIn.accessLevel,
          builtIn.target,
          ToolCallProgressStatus.failed,
          'Tool arguments were rejected.',
        );
        onProgress?.call(progress);
        return _failed(call, 'invalid_arguments', progress.message!);
      }

      onProgress?.call(
        _progress(
          chatId,
          call,
          builtIn.accessLevel,
          builtIn.target,
          ToolCallProgressStatus.running,
        ),
      );
      var denied = false;
      var cancelled = false;
      final result = await builtInTools.execute(
        plan,
        permissions: ToolPermissionSnapshot.fromUserSettings(
          catalog.builtIns.keys,
        ),
        capabilities: capabilities,
        invocationContext: ToolInvocationContext(
          maxDepth: maxDepth,
          cancellationToken: cancellationToken,
        ),
        requestApproval: requestBuiltInApproval == null
            ? null
            : (preview) async {
                onProgress?.call(
                  _progress(
                    chatId,
                    call,
                    preview.accessLevel,
                    preview.target,
                    ToolCallProgressStatus.waitingApproval,
                  ),
                );
                final decision = await requestBuiltInApproval(preview);
                denied = decision == ToolApprovalDecision.deny;
                cancelled = decision == ToolApprovalDecision.cancel;
                if (decision == ToolApprovalDecision.approveOnce) {
                  onProgress?.call(
                    _progress(
                      chatId,
                      call,
                      preview.accessLevel,
                      preview.target,
                      ToolCallProgressStatus.running,
                    ),
                  );
                }
                return decision;
              },
      );
      onProgress?.call(
        _progress(
          chatId,
          call,
          builtIn.accessLevel,
          builtIn.target,
          cancelled
              ? ToolCallProgressStatus.cancelled
              : denied
                  ? ToolCallProgressStatus.denied
                  : _resultStatus(result),
          _resultMessage(result),
        ),
      );
      return result;
    }

    final mcpTool = catalog.mcpTools[call.name];
    if (mcpTool != null) {
      final target = 'mcp:${mcpTool.serverId}/${mcpTool.name}';
      onProgress?.call(
        _progress(
          chatId,
          call,
          mcpTool.accessLevel,
          target,
          ToolCallProgressStatus.running,
        ),
      );
      var denied = false;
      var cancelled = false;
      final result = await mcpManager.executeTool(
        serverId: mcpTool.serverId,
        call: call,
        invocationContext: ToolInvocationContext(
          maxDepth: maxDepth,
          cancellationToken: cancellationToken,
        ),
        requestApproval: requestMcpApproval == null
            ? null
            : (preview) async {
                onProgress?.call(
                  _progress(
                    chatId,
                    call,
                    preview.accessLevel,
                    preview.target,
                    ToolCallProgressStatus.waitingApproval,
                  ),
                );
                final decision = await requestMcpApproval(preview);
                denied = decision == McpApprovalDecision.deny;
                cancelled = decision == McpApprovalDecision.cancel;
                if (decision == McpApprovalDecision.allowOnce ||
                    decision == McpApprovalDecision.alwaysAllow) {
                  onProgress?.call(
                    _progress(
                      chatId,
                      call,
                      preview.accessLevel,
                      preview.target,
                      ToolCallProgressStatus.running,
                    ),
                  );
                }
                return decision;
              },
      );
      onProgress?.call(
        _progress(
          chatId,
          call,
          mcpTool.accessLevel,
          target,
          cancelled
              ? ToolCallProgressStatus.cancelled
              : denied
                  ? ToolCallProgressStatus.denied
                  : _resultStatus(result),
          _resultMessage(result),
        ),
      );
      return result;
    }

    onProgress?.call(
      _progress(
        chatId,
        call,
        ToolAccessLevel.externalSideEffect,
        'tool:unregistered',
        ToolCallProgressStatus.denied,
        'The requested tool is not enabled.',
      ),
    );
    return _failed(
      call,
      'tool_not_enabled',
      'The requested tool is not enabled.',
    );
  }

  Future<T> _withinDeadline<T>(
    Future<T> operation,
    Stopwatch stopwatch,
    ToolLoopLimits limits,
    ToolCancellationController cancellation,
  ) {
    final remaining = limits.maxElapsed - stopwatch.elapsed;
    if (remaining <= Duration.zero) {
      cancellation.cancel('Tool generation timed out.');
      throw const ToolProtocolException(
        'tool_timeout',
        'Tool generation reached its time limit.',
      );
    }
    return operation.timeout(
      remaining,
      onTimeout: () {
        cancellation.cancel('Tool generation timed out.');
        throw const ToolProtocolException(
          'tool_timeout',
          'Tool generation reached its time limit.',
        );
      },
    );
  }

  int _estimateTurn(ToolAssistantMessage message) {
    var tokens = _tokenizer.estimateTokenCount(message.text);
    if (message.reasoning case final reasoning?) {
      tokens += _tokenizer.estimateTokenCount(reasoning);
    }
    for (final call in message.toolCalls) {
      tokens += _tokenizer.estimateTokenCount(call.name);
      tokens += _tokenizer.estimateTokenCount(call.rawArguments);
    }
    return tokens;
  }
}

final class _ToolCatalog {
  const _ToolCatalog({
    required this.definitions,
    required this.builtIns,
    required this.mcpTools,
  });

  final List<ToolDefinition> definitions;
  final Map<String, BuiltInToolDescriptor> builtIns;
  final Map<String, McpToolDescriptor> mcpTools;
}

ToolCallProgress _progress(
  String chatId,
  ToolCall call,
  ToolAccessLevel accessLevel,
  String target,
  ToolCallProgressStatus status, [
  String? message,
]) {
  return ToolCallProgress(
    chatId: chatId,
    callId: call.id,
    toolName: call.name,
    accessLevel: accessLevel,
    target: target,
    status: status,
    message: message,
  );
}

ToolCallProgressStatus _resultStatus(ToolResultMessage result) {
  return switch (result.status) {
    ToolResultStatus.succeeded => ToolCallProgressStatus.succeeded,
    ToolResultStatus.failed => ToolCallProgressStatus.failed,
    ToolResultStatus.cancelled => ToolCallProgressStatus.cancelled,
  };
}

String? _resultMessage(ToolResultMessage result) {
  if (!result.isError) return null;
  final output = result.output;
  if (output is Map && output['error'] is Map) {
    final error = output['error'] as Map;
    return error['message']?.toString();
  }
  return 'Tool execution failed.';
}

ToolResultMessage _failed(ToolCall call, String code, String message) {
  return ToolResultMessage(
    callId: call.id,
    toolName: call.name,
    output: {
      'error': {'code': code, 'message': message},
    },
    status: ToolResultStatus.failed,
  );
}

ToolGenerationResult _limited({
  required String code,
  required String message,
  required String? lastText,
  required String? lastReasoning,
  required int toolRounds,
  required int callCount,
  required int estimatedTokens,
}) {
  final prefix = lastText?.trim() ?? '';
  return ToolGenerationResult(
    content: prefix.isEmpty ? message : '$prefix\n\n[$message]',
    reasoning: lastReasoning,
    toolRounds: toolRounds,
    callCount: callCount,
    estimatedTokens: estimatedTokens,
    stopCode: code,
  );
}
