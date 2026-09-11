import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/models/vector_storage.dart';
import 'package:native_tavern/domain/services/capability_registry.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/stt_service.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/presentation/providers/capability_providers.dart';
import 'package:native_tavern/presentation/providers/mcp_providers.dart';

void main() {
  group('CapabilityRegistry', () {
    test('registers all NativeTavern capability families', () {
      final registry = CapabilityRegistry.nativeTavern();

      expect(
        registry.capabilities.map((capability) => capability.id).toSet(),
        CapabilityId.values.toSet(),
      );
      expect(
        registry.find(CapabilityId.llm)?.requirement,
        CapabilityRequirement.currentAi,
      );
      expect(
        registry.find(CapabilityId.systemStt)?.requirement,
        CapabilityRequirement.permission,
      );
      expect(
        registry.find(CapabilityId.embedding)?.requirement,
        CapabilityRequirement.externalService,
      );
    });

    test('rejects duplicate IDs', () {
      const descriptor = CapabilityDescriptor(
        id: CapabilityId.llm,
        name: 'AI',
        description: 'AI',
        requirement: CapabilityRequirement.currentAi,
      );

      expect(
        () => CapabilityRegistry(const [descriptor, descriptor]),
        throwsArgumentError,
      );
    });

    test('reports permission denial and offline degradation', () {
      final registry = CapabilityRegistry.nativeTavern();
      const inputs = [
        CapabilityDiagnosticInput(
          id: CapabilityId.llm,
          requiresNetwork: true,
        ),
        CapabilityDiagnosticInput(id: CapabilityId.systemTts),
        CapabilityDiagnosticInput(id: CapabilityId.systemStt),
        CapabilityDiagnosticInput(id: CapabilityId.embedding),
        CapabilityDiagnosticInput(id: CapabilityId.imageGeneration),
        CapabilityDiagnosticInput(id: CapabilityId.mcp),
        CapabilityDiagnosticInput(id: CapabilityId.live2d),
      ];
      final onlineReport = registry.diagnose(
        inputs,
        const CapabilityRuntimeSignals(
          network: CapabilityNetworkState.online,
          permissions: {
            CapabilityId.systemStt: CapabilityPermissionState.granted,
          },
        ),
      );
      final offlineReport = registry.diagnose(
        inputs,
        const CapabilityRuntimeSignals(
          network: CapabilityNetworkState.offline,
          permissions: {
            CapabilityId.systemStt: CapabilityPermissionState.denied,
          },
        ),
      );

      expect(
        onlineReport.resultFor(CapabilityId.llm).availability,
        CapabilityAvailability.ready,
      );
      expect(
        offlineReport.resultFor(CapabilityId.llm).availability,
        CapabilityAvailability.offline,
      );
      expect(
        offlineReport.resultFor(CapabilityId.systemStt).availability,
        CapabilityAvailability.permissionDenied,
      );
      expect(
        offlineReport.resultFor(CapabilityId.live2d).availability,
        CapabilityAvailability.ready,
      );
    });

    test('supports the download-required state', () {
      final registry = CapabilityRegistry(const [
        CapabilityDescriptor(
          id: CapabilityId.live2d,
          name: 'Downloaded renderer',
          description: 'Renderer package',
          requirement: CapabilityRequirement.download,
          settingsRoute: '/download',
        ),
      ]);

      final result = registry.diagnose(
        const [
          CapabilityDiagnosticInput(
            id: CapabilityId.live2d,
            downloaded: false,
          ),
        ],
        const CapabilityRuntimeSignals(),
      ).resultFor(CapabilityId.live2d);

      expect(result.availability, CapabilityAvailability.needsDownload);
      expect(result.fixKind, CapabilityFixKind.openSettings);
    });
  });

  group('CapabilityInputFactory', () {
    test('requires complete remote configuration but keeps local AI offline',
        () {
      const incompleteRemote = LLMConfig(
        provider: LLMProvider.claude,
        model: 'claude-test',
        apiKey: '',
        apiUrl: 'https://api.example.com',
      );
      const local = LLMConfig(
        provider: LLMProvider.ollama,
        model: 'local-model',
        apiKey: '',
        apiUrl: 'http://localhost:11434',
      );

      final remoteInputs = CapabilityInputFactory.create(
        llm: incompleteRemote,
        tts: const TTSSettings(),
        stt: const STTSettings(),
        vector: const VectorStorageSettings(),
        image: const ImageGenSettings(),
        mcp: const McpManagementState(),
      );
      final localInputs = CapabilityInputFactory.create(
        llm: local,
        tts: const TTSSettings(enabled: true),
        stt: const STTSettings(enabled: true),
        vector: const VectorStorageSettings(),
        image: const ImageGenSettings(),
        mcp: const McpManagementState(),
      );

      final remoteLlm = remoteInputs.firstWhere(
        (input) => input.id == CapabilityId.llm,
      );
      final localLlm = localInputs.firstWhere(
        (input) => input.id == CapabilityId.llm,
      );
      expect(remoteLlm.configured, isFalse);
      expect(remoteLlm.requiresNetwork, isTrue);
      expect(localLlm.configured, isTrue);
      expect(localLlm.requiresNetwork, isFalse);
    });
  });
}
