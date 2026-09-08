import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/data/repositories/world_info_repository.dart';
import 'package:native_tavern/domain/models/built_in_tool.dart';
import 'package:native_tavern/domain/models/tool_calling.dart';
import 'package:native_tavern/domain/services/capability_registry.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/domain/services/tool_calling/tool_execution_audit_service.dart';
import 'package:native_tavern/domain/services/variables_service.dart';

abstract class BuiltInToolExecutor {
  BuiltInToolDescriptor get descriptor;

  Map<String, dynamic> validateArguments(Map<String, dynamic> arguments);

  Future<Object?> execute(
    Map<String, dynamic> arguments,
    ToolInvocationContext context,
  );

  Future<Object?> dryRun(
    Map<String, dynamic> arguments,
    ToolInvocationContext context,
  ) async {
    throw const BuiltInToolException(
      'dry_run_unsupported',
      'This tool does not support dry-run.',
    );
  }
}

final class BuiltInToolRegistry {
  final Object _identity = Object();
  final Map<String, BuiltInToolExecutor> _executors;

  BuiltInToolRegistry(Iterable<BuiltInToolExecutor> executors)
      : _executors = _indexExecutors(executors);

  factory BuiltInToolRegistry.nativeTavern({
    required ToolImageGenerator imageGenerator,
    required ToolVariableReader variableReader,
    required ToolWorldInfoSource worldInfoSource,
    math.Random? random,
  }) {
    return BuiltInToolRegistry([
      GenerateImageToolExecutor(imageGenerator),
      RollDiceToolExecutor(random: random),
      ReadVariableToolExecutor(variableReader),
      SearchWorldInfoToolExecutor(worldInfoSource),
    ]);
  }

  List<BuiltInToolDescriptor> get descriptors => List.unmodifiable(
        _executors.values.map((executor) => executor.descriptor),
      );

  List<ToolDefinition> get definitions => List.unmodifiable(
        _executors.values.map((executor) => executor.descriptor.definition),
      );

  BuiltInToolDescriptor? descriptorFor(String toolName) {
    return _executors[toolName]?.descriptor;
  }

  BuiltInToolExecutor? _executorFor(String toolName) => _executors[toolName];

  static Map<String, BuiltInToolExecutor> _indexExecutors(
    Iterable<BuiltInToolExecutor> executors,
  ) {
    final result = <String, BuiltInToolExecutor>{};
    for (final executor in executors) {
      final name = executor.descriptor.definition.name;
      if (result.containsKey(name)) {
        throw ArgumentError.value(name, 'executors', 'Duplicate tool name.');
      }
      result[name] = executor;
    }
    return Map<String, BuiltInToolExecutor>.unmodifiable(result);
  }
}

final class BuiltInToolExecutionPlan {
  final Object _registryIdentity;
  final BuiltInToolExecutor _executor;
  final Map<String, dynamic> _arguments;
  final ToolExecutionPreview preview;

  BuiltInToolExecutionPlan._(
    this._registryIdentity,
    this._executor,
    Map<String, dynamic> arguments,
    this.preview,
  ) : _arguments = copyToolJsonObject(arguments);
}

final class BuiltInToolExecutionService {
  final BuiltInToolRegistry registry;
  final ToolExecutionAuditRepository auditRepository;
  final DateTime Function() _clock;

  BuiltInToolExecutionService({
    required this.registry,
    this.auditRepository = const NoopToolExecutionAuditRepository(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  BuiltInToolExecutionPlan prepare(ToolCall call, {bool dryRun = false}) {
    if (call.status != ToolCallStatus.ready) {
      throw BuiltInToolException(
        'invalid_tool_call',
        call.status == ToolCallStatus.cancelled
            ? 'A cancelled tool call cannot be prepared.'
            : 'Tool arguments must be valid before execution.',
      );
    }
    final executor = registry._executorFor(call.name);
    if (executor == null) {
      throw const BuiltInToolException(
        'unknown_tool',
        'The requested built-in tool is not registered.',
      );
    }
    final descriptor = executor.descriptor;
    if (dryRun && !descriptor.supportsDryRun) {
      throw const BuiltInToolException(
        'dry_run_unsupported',
        'This tool does not support dry-run.',
      );
    }

    final arguments = executor.validateArguments(call.arguments);
    final preview = ToolExecutionPreview(
      callId: call.id,
      toolName: call.name,
      accessLevel: descriptor.accessLevel,
      target: descriptor.target,
      parameters: arguments,
      requiredCapabilities: descriptor.requiredCapabilities,
      dataScopes: descriptor.dataScopes,
      requiresConfirmation: descriptor.requiresOneTimeApproval && !dryRun,
      supportsDryRun: descriptor.supportsDryRun,
      dryRun: dryRun,
    );
    return BuiltInToolExecutionPlan._(
      registry._identity,
      executor,
      arguments,
      preview,
    );
  }

  Future<ToolResultMessage> execute(
    BuiltInToolExecutionPlan plan, {
    ToolPermissionSnapshot permissions = ToolPermissionSnapshot.none,
    ToolCapabilitySnapshot capabilities = ToolCapabilitySnapshot.none,
    ToolInvocationContext? invocationContext,
    ToolApprovalHandler? requestApproval,
  }) async {
    final stopwatch = Stopwatch()..start();
    final preview = plan.preview;
    final descriptor = plan._executor.descriptor;
    final context = invocationContext ??
        ToolInvocationContext(
          maxDepth: 1,
          cancellationToken: ToolCancellationController().token,
        );
    var authorizationSource = ToolAuthorizationSource.none;

    if (!identical(plan._registryIdentity, registry._identity)) {
      return _finish(
        preview: preview,
        descriptor: descriptor,
        arguments: plan._arguments,
        stopwatch: stopwatch,
        authorizationSource: authorizationSource,
        outcome: ToolExecutionOutcome.denied,
        status: ToolResultStatus.failed,
        errorCode: 'invalid_execution_plan',
        errorMessage: 'The execution plan belongs to another registry.',
      );
    }

    try {
      context.cancellationToken.throwIfCancelled();
      if (!permissions.allows(preview.toolName)) {
        return _finish(
          preview: preview,
          descriptor: descriptor,
          arguments: plan._arguments,
          stopwatch: stopwatch,
          authorizationSource: authorizationSource,
          outcome: ToolExecutionOutcome.denied,
          status: ToolResultStatus.failed,
          errorCode: 'permission_denied',
          errorMessage: 'The tool is disabled in user settings.',
        );
      }
      authorizationSource = ToolAuthorizationSource.userSettings;

      if (preview.dryRun) {
        final output = await plan._executor.dryRun(plan._arguments, context);
        context.cancellationToken.throwIfCancelled();
        return _finish(
          preview: preview,
          descriptor: descriptor,
          arguments: plan._arguments,
          stopwatch: stopwatch,
          authorizationSource: ToolAuthorizationSource.dryRun,
          outcome: ToolExecutionOutcome.dryRun,
          status: ToolResultStatus.succeeded,
          output: output,
        );
      }

      if (!capabilities.satisfies(descriptor.requiredCapabilities)) {
        return _finish(
          preview: preview,
          descriptor: descriptor,
          arguments: plan._arguments,
          stopwatch: stopwatch,
          authorizationSource: authorizationSource,
          outcome: ToolExecutionOutcome.failed,
          status: ToolResultStatus.failed,
          errorCode: 'capability_unavailable',
          errorMessage: 'A required capability is unavailable.',
        );
      }

      if (descriptor.requiresOneTimeApproval) {
        if (requestApproval == null) {
          return _finish(
            preview: preview,
            descriptor: descriptor,
            arguments: plan._arguments,
            stopwatch: stopwatch,
            authorizationSource: authorizationSource,
            outcome: ToolExecutionOutcome.denied,
            status: ToolResultStatus.failed,
            errorCode: 'approval_required',
            errorMessage: 'This tool requires one-time user approval.',
          );
        }
        final decision = await requestApproval(preview);
        context.cancellationToken.throwIfCancelled();
        switch (decision) {
          case ToolApprovalDecision.approveOnce:
            authorizationSource = ToolAuthorizationSource.oneTimeApproval;
          case ToolApprovalDecision.deny:
            return _finish(
              preview: preview,
              descriptor: descriptor,
              arguments: plan._arguments,
              stopwatch: stopwatch,
              authorizationSource: authorizationSource,
              outcome: ToolExecutionOutcome.denied,
              status: ToolResultStatus.failed,
              errorCode: 'approval_denied',
              errorMessage: 'The user denied this tool call.',
            );
          case ToolApprovalDecision.cancel:
            return _finish(
              preview: preview,
              descriptor: descriptor,
              arguments: plan._arguments,
              stopwatch: stopwatch,
              authorizationSource: authorizationSource,
              outcome: ToolExecutionOutcome.cancelled,
              status: ToolResultStatus.cancelled,
              errorCode: 'cancelled',
              errorMessage: 'The user cancelled this tool call.',
            );
        }
      }

      final output = await plan._executor.execute(plan._arguments, context);
      context.cancellationToken.throwIfCancelled();
      return _finish(
        preview: preview,
        descriptor: descriptor,
        arguments: plan._arguments,
        stopwatch: stopwatch,
        authorizationSource: authorizationSource,
        outcome: ToolExecutionOutcome.succeeded,
        status: ToolResultStatus.succeeded,
        output: output,
      );
    } on ToolProtocolException catch (error) {
      final cancelled = error.code == 'cancelled';
      return _finish(
        preview: preview,
        descriptor: descriptor,
        arguments: plan._arguments,
        stopwatch: stopwatch,
        authorizationSource: authorizationSource,
        outcome: cancelled
            ? ToolExecutionOutcome.cancelled
            : ToolExecutionOutcome.failed,
        status:
            cancelled ? ToolResultStatus.cancelled : ToolResultStatus.failed,
        errorCode: error.code,
        errorMessage: cancelled
            ? 'Tool execution was cancelled.'
            : 'Tool execution failed protocol validation.',
      );
    } on BuiltInToolException catch (error) {
      return _finish(
        preview: preview,
        descriptor: descriptor,
        arguments: plan._arguments,
        stopwatch: stopwatch,
        authorizationSource: authorizationSource,
        outcome: ToolExecutionOutcome.failed,
        status: ToolResultStatus.failed,
        errorCode: error.code,
        errorMessage: error.message,
      );
    } catch (_) {
      return _finish(
        preview: preview,
        descriptor: descriptor,
        arguments: plan._arguments,
        stopwatch: stopwatch,
        authorizationSource: authorizationSource,
        outcome: ToolExecutionOutcome.failed,
        status: ToolResultStatus.failed,
        errorCode: 'execution_failed',
        errorMessage: 'Tool execution failed.',
      );
    }
  }

  Future<ToolResultMessage> _finish({
    required ToolExecutionPreview preview,
    required BuiltInToolDescriptor descriptor,
    required Map<String, dynamic> arguments,
    required Stopwatch stopwatch,
    required ToolAuthorizationSource authorizationSource,
    required ToolExecutionOutcome outcome,
    required ToolResultStatus status,
    Object? output,
    String? errorCode,
    String? errorMessage,
  }) async {
    stopwatch.stop();
    final record = ToolExecutionAuditRecord(
      timestamp: _clock().toUtc(),
      callIdFingerprint: fingerprintToolCallId(preview.callId),
      toolName: preview.toolName,
      accessLevel: preview.accessLevel,
      parameterSummary: summarizeToolArguments(
        arguments,
        sensitiveArgumentNames: descriptor.sensitiveArgumentNames,
      ),
      target: preview.target,
      authorizationSource: authorizationSource,
      result: outcome,
      errorCode: errorCode,
      durationMilliseconds: stopwatch.elapsedMilliseconds,
    );
    try {
      await auditRepository.record(record);
    } catch (_) {
      // Audit storage failure must not misreport an already executed side effect.
    }

    final resultOutput = errorCode == null
        ? output
        : {
            'error': {
              'code': errorCode,
              'message': errorMessage ?? 'Tool execution failed.',
            },
          };
    return ToolResultMessage(
      callId: preview.callId,
      toolName: preview.toolName,
      output: resultOutput,
      status: status,
    );
  }
}

abstract interface class ToolImageGenerator {
  bool get isAvailable;

  Future<ImageGenResult?> generate(
    ImageGenRequest request,
    ToolCancellationToken cancellationToken,
  );
}

final class ImageGenerationServiceToolImageGenerator
    implements ToolImageGenerator {
  final ImageGenerationService service;

  const ImageGenerationServiceToolImageGenerator(this.service);

  @override
  bool get isAvailable {
    final settings = service.settings;
    if (!settings.enabled) return false;
    return !settings.provider.requiresApiKey ||
        (settings.apiKey?.trim().isNotEmpty ?? false);
  }

  @override
  Future<ImageGenResult?> generate(
    ImageGenRequest request,
    ToolCancellationToken cancellationToken,
  ) async {
    cancellationToken.throwIfCancelled();
    final cancelToken = CancelToken();
    cancellationToken.whenCancelled((reason) {
      if (!cancelToken.isCancelled) cancelToken.cancel();
    });
    final result = await service.generate(request, cancelToken: cancelToken);
    cancellationToken.throwIfCancelled();
    return result;
  }
}

final class GenerateImageToolExecutor extends BuiltInToolExecutor {
  static const toolName = 'generate_image';
  final ToolImageGenerator _generator;

  GenerateImageToolExecutor(this._generator);

  @override
  BuiltInToolDescriptor get descriptor => BuiltInToolDescriptor(
        definition: ToolDefinition(
          name: toolName,
          description:
              'Generate an image with the configured image provider. '
              'Incorporate active character, lorebook, and chat scene tags into the prompt for rich visual fidelity.',
          inputSchema: const {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'prompt': {'type': 'string', 'minLength': 1, 'maxLength': 8000},
              'negative_prompt': {'type': 'string', 'maxLength': 8000},
              'width': {'type': 'integer', 'minimum': 64, 'maximum': 4096},
              'height': {'type': 'integer', 'minimum': 64, 'maximum': 4096},
              'steps': {'type': 'integer', 'minimum': 1, 'maximum': 150},
              'cfg_scale': {'type': 'number', 'minimum': 0, 'maximum': 30},
              'sampler': {'type': 'string', 'maxLength': 64},
              'scheduler': {'type': 'string', 'maxLength': 64},
              'model': {'type': 'string', 'maxLength': 128},
              'seed': {'type': 'integer', 'minimum': -1, 'maximum': 2147483647},
              'batch_size': {'type': 'integer', 'minimum': 1, 'maximum': 4},
            },
            'required': ['prompt'],
          },
        ),
        accessLevel: ToolAccessLevel.externalSideEffect,
        requiredCapabilities: const {CapabilityId.imageGeneration},
        dataScopes: const {
          ToolDataScope.imagePrompt,
          ToolDataScope.generatedImage
        },
        supportsDryRun: true,
        target: 'configured:image-generation-provider',
        sensitiveArgumentNames: const {'prompt', 'negative_prompt'},
      );

  @override
  Map<String, dynamic> validateArguments(Map<String, dynamic> arguments) {
    const allowed = {
      'prompt',
      'negative_prompt',
      'width',
      'height',
      'steps',
      'cfg_scale',
      'sampler',
      'scheduler',
      'model',
      'seed',
      'batch_size',
    };
    final input = _StrictToolArguments(arguments, allowed);
    final width =
        input.optionalInt('width', minimum: 64, maximum: 4096) ?? 1024;
    final height =
        input.optionalInt('height', minimum: 64, maximum: 4096) ?? 1024;
    if (width % 8 != 0 || height % 8 != 0) {
      throw const BuiltInToolException(
        'invalid_arguments',
        'Image width and height must be divisible by 8.',
      );
    }
    return {
      'prompt': input.requiredString('prompt', maxLength: 8000),
      if (input.optionalString('negative_prompt', maxLength: 8000)
          case final value?)
        'negative_prompt': value,
      'width': width,
      'height': height,
      'steps': input.optionalInt('steps', minimum: 1, maximum: 150) ?? 20,
      'cfg_scale':
          input.optionalDouble('cfg_scale', minimum: 0, maximum: 30) ?? 7.0,
      'sampler': input.optionalString('sampler', maxLength: 64) ?? 'euler_a',
      if (input.optionalString('scheduler', maxLength: 64) case final value?)
        'scheduler': value,
      if (input.optionalString('model', maxLength: 128) case final value?)
        'model': value,
      if (input.optionalInt('seed', minimum: -1, maximum: 0x7fffffff)
          case final value?)
        'seed': value,
      'batch_size':
          input.optionalInt('batch_size', minimum: 1, maximum: 4) ?? 1,
    };
  }

  @override
  Future<Object?> dryRun(
    Map<String, dynamic> arguments,
    ToolInvocationContext context,
  ) async {
    context.cancellationToken.throwIfCancelled();
    return {
      'dry_run': true,
      'target': descriptor.target,
      'prompt_length': (arguments['prompt'] as String).length,
      'negative_prompt_length':
          (arguments['negative_prompt'] as String?)?.length ?? 0,
      'width': arguments['width'],
      'height': arguments['height'],
      'steps': arguments['steps'],
      'batch_size': arguments['batch_size'],
      'would_execute': false,
    };
  }

  @override
  Future<Object?> execute(
    Map<String, dynamic> arguments,
    ToolInvocationContext context,
  ) async {
    if (!_generator.isAvailable) {
      throw const BuiltInToolException(
        'capability_unavailable',
        'Image generation is not configured or enabled.',
      );
    }
    final request = ImageGenRequest(
      prompt: arguments['prompt'] as String,
      negativePrompt: arguments['negative_prompt'] as String?,
      width: arguments['width'] as int,
      height: arguments['height'] as int,
      steps: arguments['steps'] as int,
      cfgScale: arguments['cfg_scale'] as double,
      sampler: arguments['sampler'] as String,
      scheduler: arguments['scheduler'] as String?,
      model: arguments['model'] as String?,
      seed: arguments['seed'] as int?,
      batchSize: arguments['batch_size'] as int,
    );
    final result = await _generator.generate(
      request,
      context.cancellationToken,
    );
    if (result == null || !result.hasImages) {
      throw const BuiltInToolException(
        'no_image_generated',
        'The image provider returned no image.',
      );
    }

    final savedPaths = <String>[];
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDocDir.path, 'chat_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      for (final imageBytes in result.images) {
        final imageId = const Uuid().v4();
        final fileName = '$imageId.${result.format}';
        final filePath = p.join(imagesDir.path, fileName);
        await File(filePath).writeAsBytes(imageBytes);
        savedPaths.add(filePath);
      }
    } catch (_) {
      // Non-fatal if local persistence fails
    }

    return {
      'generated': true,
      'image_count': result.images.length + result.imageUrls.length,
      'embedded_image_count': result.images.length,
      'remote_image_count': result.imageUrls.length,
      if (savedPaths.isNotEmpty) 'saved_file_paths': savedPaths,
      if (savedPaths.isNotEmpty)
        'markdown_image': savedPaths
            .map((path) => '![generated image](file://$path)')
            .join('\n'),
      'total_bytes': result.images.fold<int>(
        0,
        (total, image) => total + image.length,
      ),
      'seed': result.seed,
      'format': result.format,
    };
  }
}

final class RollDiceToolExecutor extends BuiltInToolExecutor {
  static const toolName = 'roll_dice';
  final math.Random _random;

  RollDiceToolExecutor({math.Random? random})
      : _random = random ?? math.Random.secure();

  @override
  BuiltInToolDescriptor get descriptor => BuiltInToolDescriptor(
        definition: ToolDefinition(
          name: toolName,
          description: 'Roll one or more local dice with an optional modifier.',
          inputSchema: const {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'count': {'type': 'integer', 'minimum': 1, 'maximum': 100},
              'sides': {'type': 'integer', 'minimum': 2, 'maximum': 1000},
              'modifier': {
                'type': 'integer',
                'minimum': -1000000,
                'maximum': 1000000,
              },
            },
            'required': ['sides'],
          },
        ),
        accessLevel: ToolAccessLevel.readOnly,
        dataScopes: const {ToolDataScope.randomValue},
        target: 'local:secure-random',
      );

  @override
  Map<String, dynamic> validateArguments(Map<String, dynamic> arguments) {
    final input = _StrictToolArguments(arguments, const {
      'count',
      'sides',
      'modifier',
    });
    return {
      'count': input.optionalInt('count', minimum: 1, maximum: 100) ?? 1,
      'sides': input.requiredInt('sides', minimum: 2, maximum: 1000),
      'modifier':
          input.optionalInt('modifier', minimum: -1000000, maximum: 1000000) ??
              0,
    };
  }

  @override
  Future<Object?> execute(
    Map<String, dynamic> arguments,
    ToolInvocationContext context,
  ) async {
    final count = arguments['count'] as int;
    final sides = arguments['sides'] as int;
    final modifier = arguments['modifier'] as int;
    final rolls = <int>[];
    for (var index = 0; index < count; index++) {
      context.cancellationToken.throwIfCancelled();
      rolls.add(_random.nextInt(sides) + 1);
    }
    final subtotal = rolls.fold<int>(0, (sum, roll) => sum + roll);
    return {
      'notation':
          '${count}d$sides${modifier == 0 ? '' : modifier > 0 ? '+$modifier' : modifier}',
      'rolls': rolls,
      'modifier': modifier,
      'total': subtotal + modifier,
    };
  }
}

final class ToolVariableReadResult {
  final bool found;
  final Object? value;

  const ToolVariableReadResult({required this.found, this.value});
}

abstract interface class ToolVariableReader {
  Future<ToolVariableReadResult> readGlobal(String name, {String? index});

  Future<ToolVariableReadResult> readLocal(
    String chatId,
    String name, {
    String? index,
  });
}

final class VariablesServiceToolVariableReader implements ToolVariableReader {
  final VariablesService service;

  const VariablesServiceToolVariableReader(this.service);

  @override
  Future<ToolVariableReadResult> readGlobal(
    String name, {
    String? index,
  }) async {
    final found = service.existsGlobalVariable(name);
    return ToolVariableReadResult(
      found: found,
      value: found ? service.getGlobalVariable(name, index: index) : null,
    );
  }

  @override
  Future<ToolVariableReadResult> readLocal(
    String chatId,
    String name, {
    String? index,
  }) async {
    final found = service.existsLocalVariable(chatId, name);
    return ToolVariableReadResult(
      found: found,
      value:
          found ? service.getLocalVariable(chatId, name, index: index) : null,
    );
  }
}

final class ReadVariableToolExecutor extends BuiltInToolExecutor {
  static const toolName = 'read_variable';
  final ToolVariableReader _reader;

  ReadVariableToolExecutor(this._reader);

  @override
  BuiltInToolDescriptor get descriptor => BuiltInToolDescriptor(
        definition: ToolDefinition(
          name: toolName,
          description: 'Read one global or chat-local variable.',
          inputSchema: const {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'scope': {
                'type': 'string',
                'enum': ['global', 'local'],
              },
              'name': {'type': 'string', 'minLength': 1, 'maxLength': 128},
              'chat_id': {'type': 'string', 'maxLength': 128},
              'index': {'type': 'string', 'maxLength': 128},
            },
            'required': ['scope', 'name'],
          },
        ),
        accessLevel: ToolAccessLevel.readOnly,
        dataScopes: const {
          ToolDataScope.variableName,
          ToolDataScope.variableValue
        },
        target: 'local:variables',
        sensitiveArgumentNames: const {'name', 'chat_id', 'index'},
      );

  @override
  Map<String, dynamic> validateArguments(Map<String, dynamic> arguments) {
    final input = _StrictToolArguments(arguments, const {
      'scope',
      'name',
      'chat_id',
      'index',
    });
    final scope = input.requiredString(
      'scope',
      maxLength: 16,
      allowedValues: const {'global', 'local'},
    );
    final name = input.requiredString('name', maxLength: 128);
    final chatId = input.optionalIdentifier('chat_id');
    final index = input.optionalString('index', maxLength: 128);
    if (scope == 'local' && chatId == null) {
      throw const BuiltInToolException(
        'invalid_arguments',
        'chat_id is required for local variables.',
      );
    }
    if (scope == 'global' && chatId != null) {
      throw const BuiltInToolException(
        'invalid_arguments',
        'chat_id is not allowed for global variables.',
      );
    }
    return {
      'scope': scope,
      'name': name,
      if (chatId != null) 'chat_id': chatId,
      if (index != null) 'index': index,
    };
  }

  @override
  Future<Object?> execute(
    Map<String, dynamic> arguments,
    ToolInvocationContext context,
  ) async {
    context.cancellationToken.throwIfCancelled();
    final scope = arguments['scope'] as String;
    final name = arguments['name'] as String;
    final index = arguments['index'] as String?;
    final result = scope == 'global'
        ? await _reader.readGlobal(name, index: index)
        : await _reader.readLocal(
            arguments['chat_id'] as String,
            name,
            index: index,
          );
    context.cancellationToken.throwIfCancelled();
    final bounded = _boundedJsonValue(result.value);
    return {
      'scope': scope,
      'name': name,
      'found': result.found,
      'value': bounded.value,
      'truncated': bounded.truncated,
    };
  }
}

abstract interface class ToolWorldInfoSource {
  Future<List<WorldInfo>> readAllowedWorldInfos({
    String? worldInfoId,
    String? characterId,
  });
}

final class WorldInfoRepositoryToolWorldInfoSource
    implements ToolWorldInfoSource {
  final WorldInfoRepository repository;

  const WorldInfoRepositoryToolWorldInfoSource(this.repository);

  @override
  Future<List<WorldInfo>> readAllowedWorldInfos({
    String? worldInfoId,
    String? characterId,
  }) async {
    final worldInfos = <WorldInfo>[
      ...await repository.getGlobalWorldInfos(),
      if (characterId != null)
        ...await repository.getWorldInfosForCharacter(characterId),
    ];
    final unique = <String, WorldInfo>{
      for (final worldInfo in worldInfos) worldInfo.id: worldInfo,
    };
    return unique.values
        .where((worldInfo) => worldInfo.enabled)
        .where(
          (worldInfo) => worldInfoId == null || worldInfo.id == worldInfoId,
        )
        .toList(growable: false);
  }
}

final class SearchWorldInfoToolExecutor extends BuiltInToolExecutor {
  static const toolName = 'search_world_info';
  static const _maxContentLength = 2000;
  final ToolWorldInfoSource _source;

  SearchWorldInfoToolExecutor(this._source);

  @override
  BuiltInToolDescriptor get descriptor => BuiltInToolDescriptor(
        definition: ToolDefinition(
          name: toolName,
          description: 'Search enabled global or character-scoped world info.',
          inputSchema: const {
            'type': 'object',
            'additionalProperties': false,
            'properties': {
              'query': {'type': 'string', 'minLength': 1, 'maxLength': 500},
              'world_info_id': {'type': 'string', 'maxLength': 128},
              'character_id': {'type': 'string', 'maxLength': 128},
              'limit': {'type': 'integer', 'minimum': 1, 'maximum': 10},
            },
            'required': ['query'],
          },
        ),
        accessLevel: ToolAccessLevel.readOnly,
        dataScopes: const {
          ToolDataScope.worldInfoQuery,
          ToolDataScope.worldInfoContent,
        },
        target: 'local:world-info',
        sensitiveArgumentNames: const {'query'},
      );

  @override
  Map<String, dynamic> validateArguments(Map<String, dynamic> arguments) {
    final input = _StrictToolArguments(arguments, const {
      'query',
      'world_info_id',
      'character_id',
      'limit',
    });
    return {
      'query': input.requiredString('query', maxLength: 500),
      if (input.optionalIdentifier('world_info_id') case final value?)
        'world_info_id': value,
      if (input.optionalIdentifier('character_id') case final value?)
        'character_id': value,
      'limit': input.optionalInt('limit', minimum: 1, maximum: 10) ?? 5,
    };
  }

  @override
  Future<Object?> execute(
    Map<String, dynamic> arguments,
    ToolInvocationContext context,
  ) async {
    context.cancellationToken.throwIfCancelled();
    final query = (arguments['query'] as String).toLowerCase();
    final worldInfos = await _source.readAllowedWorldInfos(
      worldInfoId: arguments['world_info_id'] as String?,
      characterId: arguments['character_id'] as String?,
    );
    context.cancellationToken.throwIfCancelled();
    final matches = <_WorldInfoMatch>[];
    for (final worldInfo in worldInfos) {
      for (final entry in worldInfo.entries) {
        context.cancellationToken.throwIfCancelled();
        if (!entry.enabled) continue;
        final score = _matchScore(worldInfo, entry, query);
        if (score == 0) continue;
        matches.add(_WorldInfoMatch(worldInfo, entry, score));
      }
    }
    matches.sort((left, right) {
      final byScore = right.score.compareTo(left.score);
      if (byScore != 0) return byScore;
      final byOrder = left.entry.insertionOrder.compareTo(
        right.entry.insertionOrder,
      );
      if (byOrder != 0) return byOrder;
      return left.entry.id.compareTo(right.entry.id);
    });
    final limit = arguments['limit'] as int;
    final selected = matches.take(limit);
    return {
      'match_count': matches.length,
      'results': [
        for (final match in selected)
          {
            'world_info_id': match.worldInfo.id,
            'world_info_name': _clip(match.worldInfo.name, 256),
            'entry_id': match.entry.id,
            'keys': [
              for (final key in match.entry.keys.take(16)) _clip(key, 256),
            ],
            'content': _clip(match.entry.content, _maxContentLength),
            'truncated': match.entry.content.length > _maxContentLength,
          },
      ],
    };
  }

  int _matchScore(WorldInfo worldInfo, WorldInfoEntry entry, String query) {
    var score = 0;
    for (final key in entry.keys) {
      final normalized = key.toLowerCase();
      if (normalized == query) {
        score = math.max(score, 100);
      } else if (normalized.contains(query) || query.contains(normalized)) {
        score = math.max(score, 80);
      }
    }
    if (entry.secondaryKeys.any((key) => key.toLowerCase().contains(query))) {
      score = math.max(score, 60);
    }
    if (entry.comment.toLowerCase().contains(query)) {
      score = math.max(score, 50);
    }
    if (entry.content.toLowerCase().contains(query)) {
      score = math.max(score, 40);
    }
    if (worldInfo.name.toLowerCase().contains(query) ||
        (worldInfo.description?.toLowerCase().contains(query) ?? false)) {
      score = math.max(score, 20);
    }
    return score;
  }
}

final class _WorldInfoMatch {
  final WorldInfo worldInfo;
  final WorldInfoEntry entry;
  final int score;

  const _WorldInfoMatch(this.worldInfo, this.entry, this.score);
}

final class _StrictToolArguments {
  static final RegExp _unsafeControlCharacters = RegExp(
    r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]',
  );
  static final RegExp _identifier = RegExp(
    r'^[A-Za-z0-9][A-Za-z0-9._:-]{0,127}$',
  );

  final Map<String, dynamic> _values;

  _StrictToolArguments(Map<String, dynamic> values, Set<String> allowed)
      : _values = values {
    final unknown = values.keys.where((key) => !allowed.contains(key)).toList();
    if (unknown.isNotEmpty) {
      throw const BuiltInToolException(
        'invalid_arguments',
        'Tool arguments contain unsupported fields.',
      );
    }
  }

  String requiredString(
    String key, {
    required int maxLength,
    Set<String>? allowedValues,
  }) {
    final value = _values[key];
    if (value is! String || value.trim().isEmpty) {
      throw BuiltInToolException(
        'invalid_arguments',
        '$key must be a non-empty string.',
      );
    }
    _validateString(key, value, maxLength);
    if (allowedValues != null && !allowedValues.contains(value)) {
      throw BuiltInToolException(
        'invalid_arguments',
        '$key contains an unsupported value.',
      );
    }
    return value;
  }

  String? optionalString(String key, {required int maxLength}) {
    final value = _values[key];
    if (value == null) return null;
    if (value is! String) {
      throw BuiltInToolException('invalid_arguments', '$key must be a string.');
    }
    _validateString(key, value, maxLength);
    return value;
  }

  String? optionalIdentifier(String key) {
    final value = optionalString(key, maxLength: 128);
    if (value == null) return null;
    if (!_identifier.hasMatch(value) || value.contains('..')) {
      throw BuiltInToolException(
        'invalid_arguments',
        '$key must be an opaque identifier, not a path.',
      );
    }
    return value;
  }

  int requiredInt(String key, {required int minimum, required int maximum}) {
    final value = optionalInt(key, minimum: minimum, maximum: maximum);
    if (value == null) {
      throw BuiltInToolException(
        'invalid_arguments',
        '$key must be an integer.',
      );
    }
    return value;
  }

  int? optionalInt(String key, {required int minimum, required int maximum}) {
    final value = _values[key];
    if (value == null) return null;
    if (value is! int || value < minimum || value > maximum) {
      throw BuiltInToolException(
        'invalid_arguments',
        '$key must be an integer between $minimum and $maximum.',
      );
    }
    return value;
  }

  double? optionalDouble(
    String key, {
    required double minimum,
    required double maximum,
  }) {
    final value = _values[key];
    if (value == null) return null;
    if (value is! num ||
        !value.isFinite ||
        value < minimum ||
        value > maximum) {
      throw BuiltInToolException(
        'invalid_arguments',
        '$key must be a number between $minimum and $maximum.',
      );
    }
    return value.toDouble();
  }

  void _validateString(String key, String value, int maxLength) {
    if (value.length > maxLength || _unsafeControlCharacters.hasMatch(value)) {
      throw BuiltInToolException(
        'invalid_arguments',
        '$key exceeds its length limit or contains control characters.',
      );
    }
  }
}

final class _BoundedJsonValue {
  final Object? value;
  final bool truncated;

  const _BoundedJsonValue(this.value, this.truncated);
}

_BoundedJsonValue _boundedJsonValue(Object? value, {int depth = 0}) {
  if (value == null || value is bool || value is num) {
    return _BoundedJsonValue(value, false);
  }
  if (depth >= 8) return const _BoundedJsonValue('[truncated]', true);
  if (value is String) {
    if (value.length <= 16000) return _BoundedJsonValue(value, false);
    return _BoundedJsonValue('${value.substring(0, 16000)}[truncated]', true);
  }
  if (value is List) {
    var truncated = value.length > 100;
    final result = <Object?>[];
    for (final item in value.take(100)) {
      final bounded = _boundedJsonValue(item, depth: depth + 1);
      result.add(bounded.value);
      truncated = truncated || bounded.truncated;
    }
    return _BoundedJsonValue(result, truncated);
  }
  if (value is Map) {
    var truncated = value.length > 100;
    final result = <String, Object?>{};
    for (final entry in value.entries.take(100)) {
      if (entry.key is! String) {
        truncated = true;
        continue;
      }
      final bounded = _boundedJsonValue(entry.value, depth: depth + 1);
      result[entry.key as String] = bounded.value;
      truncated = truncated || bounded.truncated;
    }
    return _BoundedJsonValue(result, truncated);
  }
  final text = value.toString();
  return _BoundedJsonValue(_clip(text, 16000), text.length > 16000);
}

String _clip(String value, int maximumLength) {
  return value.length <= maximumLength
      ? value
      : value.substring(0, maximumLength);
}
