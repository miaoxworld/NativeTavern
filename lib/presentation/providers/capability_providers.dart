import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/network_status_probe.dart';
import 'package:native_tavern/data/models/vector_storage.dart';
import 'package:native_tavern/domain/services/capability_registry.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/stt_service.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/presentation/providers/image_gen_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/stt_providers.dart';
import 'package:native_tavern/presentation/providers/tts_providers.dart';
import 'package:native_tavern/presentation/providers/vector_storage_providers.dart';

final capabilityRegistryProvider = Provider<CapabilityRegistry>((ref) {
  return CapabilityRegistry.nativeTavern();
});

final localNetworkProbeProvider = Provider<Future<bool?> Function()>((ref) {
  return probeLocalNetworkAvailability;
});

final microphonePermissionProbeProvider =
    Provider<Future<CapabilityPermissionState> Function()>((ref) {
  final service = ref.watch(sttServiceProvider);
  return () async {
    try {
      if (await service.hasPermission()) {
        return CapabilityPermissionState.granted;
      }
      return service.permissionRequestAttempted
          ? CapabilityPermissionState.denied
          : CapabilityPermissionState.unknown;
    } catch (_) {
      return CapabilityPermissionState.unknown;
    }
  };
});

final capabilityRuntimeSignalsProvider =
    FutureProvider<CapabilityRuntimeSignals>((ref) async {
  final sttSettings = ref.watch(sttSettingsProvider);
  final networkResult = await ref.watch(localNetworkProbeProvider)();
  final network = switch (networkResult) {
    true => CapabilityNetworkState.online,
    false => CapabilityNetworkState.offline,
    null => CapabilityNetworkState.unknown,
  };

  var microphonePermission = CapabilityPermissionState.notRequired;
  if (sttSettings.enabled && sttSettings.provider == STTProvider.system) {
    microphonePermission = await ref.watch(
      microphonePermissionProbeProvider,
    )();
  }

  return CapabilityRuntimeSignals(
    network: network,
    permissions: {CapabilityId.systemStt: microphonePermission},
  );
});

final capabilityDiagnosticInputsProvider =
    Provider<List<CapabilityDiagnosticInput>>((ref) {
  return CapabilityInputFactory.create(
    llm: ref.watch(llmConfigProvider),
    tts: ref.watch(ttsSettingsProvider),
    stt: ref.watch(sttSettingsProvider),
    vector: ref.watch(vectorStorageSettingsProvider),
    image: ref.watch(imageGenSettingsProvider),
  );
});

final capabilityDiagnosticsProvider =
    Provider<AsyncValue<CapabilityDiagnosticReport>>((ref) {
  final registry = ref.watch(capabilityRegistryProvider);
  final inputs = ref.watch(capabilityDiagnosticInputsProvider);
  return ref
      .watch(capabilityRuntimeSignalsProvider)
      .whenData((signals) => registry.diagnose(inputs, signals));
});

abstract class CapabilityInputFactory {
  static List<CapabilityDiagnosticInput> create({
    required LLMConfig llm,
    required TTSSettings tts,
    required STTSettings stt,
    required VectorStorageSettings vector,
    required ImageGenSettings image,
  }) {
    final llmLocalProvider = llm.provider.isLocalServer;
    final llmNeedsKey =
        !llmLocalProvider && llm.provider != LLMProvider.openAICompatible;
    final llmNeedsModel = llm.provider != LLMProvider.koboldCpp;
    final llmConfigured = _validHttpEndpoint(llm.apiUrl) &&
        (!llmNeedsModel || llm.model.trim().isNotEmpty) &&
        (!llmNeedsKey || llm.apiKey.trim().isNotEmpty);

    final vectorKeyRequired = {
      EmbeddingProvider.openai,
      EmbeddingProvider.cohere,
      EmbeddingProvider.gemini,
      EmbeddingProvider.siliconflow,
    }.contains(vector.embeddingProvider);
    final vectorEndpoint = vector.embeddingEndpoint?.trim().isNotEmpty == true
        ? vector.embeddingEndpoint!
        : vector.embeddingProvider.defaultEndpoint;
    final vectorConfigured = _validHttpEndpoint(vectorEndpoint) &&
        (!vectorKeyRequired ||
            vector.embeddingApiKey?.trim().isNotEmpty == true);

    final imageConfigured = _validHttpEndpoint(image.effectiveEndpoint) &&
        (!image.provider.requiresApiKey ||
            image.apiKey?.trim().isNotEmpty == true) &&
        (image.provider.isLocalProvider || image.model.trim().isNotEmpty);

    return [
      CapabilityDiagnosticInput(
        id: CapabilityId.llm,
        configured: llmConfigured,
        requiresNetwork: !llmLocalProvider && !_isLocalEndpoint(llm.apiUrl),
        configurationIssue:
            llmConfigured ? null : 'Complete the current AI connection',
      ),
      CapabilityDiagnosticInput(
        id: CapabilityId.systemTts,
        enabled: tts.enabled && tts.provider == TTSProvider.system,
      ),
      CapabilityDiagnosticInput(
        id: CapabilityId.systemStt,
        enabled: stt.enabled && stt.provider == STTProvider.system,
      ),
      CapabilityDiagnosticInput(
        id: CapabilityId.embedding,
        enabled: vector.enabled,
        supported: vector.embeddingProvider != EmbeddingProvider.local,
        configured: vectorConfigured,
        requiresNetwork: vector.embeddingProvider != EmbeddingProvider.ollama &&
            !_isLocalEndpoint(vectorEndpoint),
        configurationIssue:
            vectorConfigured ? null : 'Complete the embedding connection',
      ),
      CapabilityDiagnosticInput(
        id: CapabilityId.imageGeneration,
        enabled: image.enabled,
        configured: imageConfigured,
        requiresNetwork: !image.provider.isLocalProvider &&
            !_isLocalEndpoint(image.effectiveEndpoint),
        configurationIssue:
            imageConfigured ? null : 'Complete the image connection',
      ),
      const CapabilityDiagnosticInput(
        id: CapabilityId.mcp,
        configured: false,
        supported: false,
      ),
      const CapabilityDiagnosticInput(id: CapabilityId.live2d),
    ];
  }

  static bool _validHttpEndpoint(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static bool _isLocalEndpoint(String value) {
    final host = Uri.tryParse(value.trim())?.host.toLowerCase();
    return host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '::1' ||
        host?.endsWith('.local') == true;
  }
}
