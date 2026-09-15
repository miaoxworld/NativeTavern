enum CapabilityId {
  llm,
  systemTts,
  systemStt,
  embedding,
  imageGeneration,
  mcp,
  live2d,
}

enum CapabilityRequirement {
  builtIn,
  currentAi,
  permission,
  download,
  externalService,
}

enum CapabilityAvailability {
  ready,
  disabled,
  needsConfiguration,
  needsPermission,
  permissionDenied,
  needsDownload,
  offline,
  unsupported,
}

enum CapabilityPermissionState { notRequired, unknown, granted, denied }

enum CapabilityNetworkState { unknown, online, offline }

enum CapabilityFixKind { openSettings, requestPermission, retry }

class CapabilityDescriptor {
  final CapabilityId id;
  final String name;
  final String description;
  final CapabilityRequirement requirement;
  final String? settingsRoute;

  const CapabilityDescriptor({
    required this.id,
    required this.name,
    required this.description,
    required this.requirement,
    this.settingsRoute,
  });
}

class CapabilityDiagnosticInput {
  final CapabilityId id;
  final bool enabled;
  final bool configured;
  final bool supported;
  final bool downloaded;
  final bool requiresNetwork;
  final String? configurationIssue;

  const CapabilityDiagnosticInput({
    required this.id,
    this.enabled = true,
    this.configured = true,
    this.supported = true,
    this.downloaded = true,
    this.requiresNetwork = false,
    this.configurationIssue,
  });
}

class CapabilityRuntimeSignals {
  final CapabilityNetworkState network;
  final Map<CapabilityId, CapabilityPermissionState> permissions;

  const CapabilityRuntimeSignals({
    this.network = CapabilityNetworkState.unknown,
    this.permissions = const {},
  });

  CapabilityPermissionState permissionFor(CapabilityId id) {
    return permissions[id] ?? CapabilityPermissionState.notRequired;
  }
}

class CapabilityDiagnosticResult {
  final CapabilityDescriptor capability;
  final CapabilityAvailability availability;
  final String message;
  final CapabilityFixKind? fixKind;

  const CapabilityDiagnosticResult({
    required this.capability,
    required this.availability,
    required this.message,
    this.fixKind,
  });

  bool get isReady => availability == CapabilityAvailability.ready;
}

class CapabilityDiagnosticReport {
  final List<CapabilityDiagnosticResult> results;

  const CapabilityDiagnosticReport(this.results);

  int get readyCount => results.where((result) => result.isReady).length;
  int get attentionCount => results.length - readyCount;

  CapabilityDiagnosticResult resultFor(CapabilityId id) {
    return results.firstWhere((result) => result.capability.id == id);
  }
}

class CapabilityRegistry {
  final Map<CapabilityId, CapabilityDescriptor> _capabilities;

  CapabilityRegistry([Iterable<CapabilityDescriptor> capabilities = const []])
      : _capabilities = {
          for (final capability in capabilities) capability.id: capability,
        } {
    if (_capabilities.length != capabilities.length) {
      throw ArgumentError('Capability IDs must be unique.');
    }
  }

  factory CapabilityRegistry.nativeTavern() {
    return CapabilityRegistry(const [
      CapabilityDescriptor(
        id: CapabilityId.llm,
        name: 'Current AI',
        description: 'Chat generation connection',
        requirement: CapabilityRequirement.currentAi,
        settingsRoute: '/ai-config',
      ),
      CapabilityDescriptor(
        id: CapabilityId.systemTts,
        name: 'System speech',
        description: 'Device text-to-speech',
        requirement: CapabilityRequirement.builtIn,
        settingsRoute: '/tts-settings',
      ),
      CapabilityDescriptor(
        id: CapabilityId.systemStt,
        name: 'Voice input',
        description: 'Device speech recognition',
        requirement: CapabilityRequirement.permission,
        settingsRoute: '/stt-settings',
      ),
      CapabilityDescriptor(
        id: CapabilityId.embedding,
        name: 'Semantic search',
        description: 'Optional embedding connection',
        requirement: CapabilityRequirement.externalService,
        settingsRoute: '/vector-storage-settings',
      ),
      CapabilityDescriptor(
        id: CapabilityId.imageGeneration,
        name: 'Image generation',
        description: 'Optional image connection',
        requirement: CapabilityRequirement.externalService,
        settingsRoute: '/image-gen-settings',
      ),
      CapabilityDescriptor(
        id: CapabilityId.mcp,
        name: 'MCP tools',
        description: 'External tool servers',
        requirement: CapabilityRequirement.externalService,
        settingsRoute: '/mcp-settings',
      ),
      CapabilityDescriptor(
        id: CapabilityId.live2d,
        name: 'Live2D',
        description: 'Bundled character rendering',
        requirement: CapabilityRequirement.builtIn,
        settingsRoute: '/characters',
      ),
    ]);
  }

  List<CapabilityDescriptor> get capabilities =>
      List.unmodifiable(_capabilities.values);

  CapabilityDescriptor? find(CapabilityId id) => _capabilities[id];

  CapabilityDiagnosticReport diagnose(
    Iterable<CapabilityDiagnosticInput> inputs,
    CapabilityRuntimeSignals signals,
  ) {
    final byId = {for (final input in inputs) input.id: input};
    return CapabilityDiagnosticReport([
      for (final descriptor in capabilities)
        _diagnose(
          descriptor,
          byId[descriptor.id] ??
              CapabilityDiagnosticInput(
                id: descriptor.id,
                configured: false,
                supported: false,
              ),
          signals,
        ),
    ]);
  }

  CapabilityDiagnosticResult _diagnose(
    CapabilityDescriptor descriptor,
    CapabilityDiagnosticInput input,
    CapabilityRuntimeSignals signals,
  ) {
    if (!input.supported) {
      return _result(
        descriptor,
        CapabilityAvailability.unsupported,
        'Not available in this build',
      );
    }
    if (!input.enabled) {
      return _result(
        descriptor,
        CapabilityAvailability.disabled,
        'Off',
        fixKind: descriptor.settingsRoute == null
            ? null
            : CapabilityFixKind.openSettings,
      );
    }

    if (descriptor.requirement == CapabilityRequirement.permission) {
      switch (signals.permissionFor(descriptor.id)) {
        case CapabilityPermissionState.denied:
          return _result(
            descriptor,
            CapabilityAvailability.permissionDenied,
            'Permission denied',
            fixKind: descriptor.settingsRoute == null
                ? null
                : CapabilityFixKind.openSettings,
          );
        case CapabilityPermissionState.unknown:
          return _result(
            descriptor,
            CapabilityAvailability.needsPermission,
            'Permission required',
            fixKind: CapabilityFixKind.requestPermission,
          );
        case CapabilityPermissionState.granted:
        case CapabilityPermissionState.notRequired:
          break;
      }
    }

    if (descriptor.requirement == CapabilityRequirement.download &&
        !input.downloaded) {
      return _result(
        descriptor,
        CapabilityAvailability.needsDownload,
        'Download required',
        fixKind: descriptor.settingsRoute == null
            ? null
            : CapabilityFixKind.openSettings,
      );
    }

    if (!input.configured) {
      return _result(
        descriptor,
        CapabilityAvailability.needsConfiguration,
        input.configurationIssue ?? 'Configuration required',
        fixKind: descriptor.settingsRoute == null
            ? null
            : CapabilityFixKind.openSettings,
      );
    }

    if (input.requiresNetwork &&
        signals.network == CapabilityNetworkState.offline) {
      return _result(
        descriptor,
        CapabilityAvailability.offline,
        'Unavailable while offline',
        fixKind: CapabilityFixKind.retry,
      );
    }

    return _result(
      descriptor,
      CapabilityAvailability.ready,
      input.requiresNetwork ? 'Configured' : 'Available',
    );
  }

  CapabilityDiagnosticResult _result(
    CapabilityDescriptor capability,
    CapabilityAvailability availability,
    String message, {
    CapabilityFixKind? fixKind,
  }) {
    return CapabilityDiagnosticResult(
      capability: capability,
      availability: availability,
      message: message,
      fixKind: fixKind,
    );
  }
}
