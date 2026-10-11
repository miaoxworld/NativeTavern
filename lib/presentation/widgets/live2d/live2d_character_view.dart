import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_live2d/flutter_live2d.dart';
import 'package:native_tavern/core/utils/path_utils.dart';
import 'package:native_tavern/data/models/live2d.dart';
import 'package:native_tavern/domain/services/emotion_detection_service.dart';
import 'package:native_tavern/domain/services/live2d_action_orchestrator.dart';
import 'package:native_tavern/domain/services/live2d_hit_test_service.dart';
import 'package:native_tavern/domain/services/live2d_ios_render_scale_service.dart';
import 'package:native_tavern/domain/services/live2d_render_lifecycle.dart';
import 'package:native_tavern/domain/services/live2d_service.dart';
import 'package:native_tavern/domain/services/live2d_tts_playback_coordinator.dart';
import 'package:native_tavern/domain/services/spine_runtime_service.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/presentation/widgets/live2d/macos_live2d_view.dart';
import 'package:native_tavern/presentation/widgets/live2d/live2d_stage_gestures.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;

export 'package:native_tavern/presentation/widgets/live2d/live2d_stage_gestures.dart'
    show Live2DStageTransform;

part 'spine_character_view.dart';

abstract interface class _NativeLive2DController {
  ValueListenable<Live2DViewState> get listenable;
  Live2DViewState get value;
  Future<void> get whenAttached;
  Future<bool> loadModel({
    required String modelDir,
    required String modelFileName,
  });
  Future<void> setRenderingPaused(bool paused);
  Future<void> startMotion({
    required String group,
    int index,
    int priority,
  });
  Future<void> setParameter(String parameterId, double value);
  Future<void> setMotionSpeed(double speed);
  Widget buildView();
  void dispose();
}

class _MobileLive2DController implements _NativeLive2DController {
  final Live2DViewController _controller = Live2DViewController();

  @override
  ValueListenable<Live2DViewState> get listenable => _controller;

  @override
  Live2DViewState get value => _controller.value;

  @override
  Future<void> get whenAttached => _controller.whenAttached;

  @override
  Future<bool> loadModel({
    required String modelDir,
    required String modelFileName,
  }) =>
      _controller.loadModel(
        modelDir: modelDir,
        modelFileName: modelFileName,
      );

  @override
  Future<void> setRenderingPaused(bool paused) =>
      _controller.setRenderingPaused(paused);

  @override
  Future<void> startMotion({
    required String group,
    int index = 0,
    int priority = 2,
  }) =>
      _controller.startMotion(
        group: group,
        index: index,
        priority: priority,
      );

  @override
  Future<void> setParameter(String parameterId, double value) =>
      _controller.setParameter(parameterId, value);

  @override
  Future<void> setMotionSpeed(double speed) =>
      _controller.setMotionSpeed(speed);

  @override
  Widget buildView() => Live2DView(controller: _controller);

  @override
  void dispose() => _controller.dispose();
}

class _MacOSLive2DController implements _NativeLive2DController {
  final MacOSLive2DViewController _controller = MacOSLive2DViewController();

  @override
  ValueListenable<Live2DViewState> get listenable => _controller;

  @override
  Live2DViewState get value => _controller.value;

  @override
  Future<void> get whenAttached => _controller.whenAttached;

  @override
  Future<bool> loadModel({
    required String modelDir,
    required String modelFileName,
  }) =>
      _controller.loadModel(
        modelDir: modelDir,
        modelFileName: modelFileName,
      );

  @override
  Future<void> setRenderingPaused(bool paused) =>
      _controller.setRenderingPaused(paused);

  @override
  Future<void> startMotion({
    required String group,
    int index = 0,
    int priority = 2,
  }) =>
      _controller.startMotion(
        group: group,
        index: index,
        priority: priority,
      );

  @override
  Future<void> setParameter(String parameterId, double value) =>
      _controller.setParameter(parameterId, value);

  @override
  Future<void> setMotionSpeed(double speed) =>
      _controller.setMotionSpeed(speed);

  @override
  Widget buildView() => MacOSLive2DView(controller: _controller);

  @override
  void dispose() => _controller.dispose();
}

/// A stable app-level controller for motion playback and future TTS lip sync.
class Live2DCharacterController {
  _NativeLive2DController? _nativeController;
  _SpineCharacterViewState? _spineState;
  Live2DActionOrchestrator? _orchestrator;
  Future<bool> Function(Offset localPosition)? _tapHandler;
  String? _loadedModelId;
  String _lipSyncParameter = 'ParamMouthOpenY';

  bool get isAttached =>
      _spineState?.isAttached ?? _nativeController?.value.isAttached ?? false;
  bool get isReady =>
      _spineState?.isReady ?? _nativeController?.value.isLoaded ?? false;
  bool get isRenderingPaused =>
      _spineState?.isRenderingPaused ??
      _nativeController?.value.isRenderingPaused ??
      false;
  String? get loadedModelId => _loadedModelId;

  void _attach(
    _NativeLive2DController controller,
    String modelId,
    String lipSyncParameter,
    Live2DActionOrchestrator orchestrator,
    Future<bool> Function(Offset localPosition) tapHandler,
  ) {
    _nativeController = controller;
    _spineState = null;
    _loadedModelId = modelId;
    _lipSyncParameter = lipSyncParameter;
    _orchestrator = orchestrator;
    _tapHandler = tapHandler;
  }

  void _attachSpine(
    _SpineCharacterViewState state,
    String modelId,
    Live2DActionOrchestrator orchestrator,
    Future<bool> Function(Offset localPosition) tapHandler,
  ) {
    _nativeController = null;
    _spineState = state;
    _loadedModelId = modelId;
    _orchestrator = orchestrator;
    _tapHandler = tapHandler;
  }

  void _detach(_NativeLive2DController controller) {
    if (identical(_nativeController, controller)) {
      _nativeController = null;
      _loadedModelId = null;
      _orchestrator = null;
      _tapHandler = null;
    }
  }

  void _detachSpine(_SpineCharacterViewState state) {
    if (identical(_spineState, state)) {
      _spineState = null;
      _loadedModelId = null;
      _orchestrator = null;
      _tapHandler = null;
    }
  }

  Future<bool> playMotion(Live2DMotionRef? motion, {int priority = 2}) async {
    final spineState = _spineState;
    if (spineState != null) {
      return spineState.playMotion(motion, priority: priority);
    }
    final controller = _nativeController;
    if (controller == null || !controller.value.isLoaded || motion == null) {
      return false;
    }
    try {
      await controller.startMotion(
        group: motion.group,
        index: motion.index,
        priority: priority,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Routes a tap from an overlaying chat surface to the attached character.
  Future<bool> handleTapAt(Offset localPosition) =>
      _tapHandler?.call(localPosition) ?? Future.value(false);

  /// Values are clamped to the standard Cubism mouth-open range.
  Future<bool> setMouthOpen(double value) async {
    if (_spineState != null) return false;
    final controller = _nativeController;
    if (controller == null || !controller.value.isLoaded) return false;
    try {
      await controller.setParameter(_lipSyncParameter, value.clamp(0, 1));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> notifyMessageStarted() =>
      _orchestrator?.onMessageStarted() ?? Future.value(false);

  Future<bool> notifySentenceBoundary() =>
      _orchestrator?.onSentenceBoundary() ?? Future.value(false);

  Future<bool> notifyResponseCompleted({String? emotion}) =>
      _orchestrator?.onResponseCompleted(emotion: emotion) ??
      Future.value(false);
}

class Live2DCharacterView extends StatefulWidget {
  final Live2DConfig config;
  final bool isSpeaking;
  final String responseText;
  final TTSPlaybackState? ttsPlayback;
  final Live2DCharacterController? controller;
  final Widget? fallback;
  final bool showStatus;
  final bool interactive;
  final bool resetOnDoubleTap;
  final VoidCallback? onReady;
  final ValueChanged<Live2DStageTransform>? onTransformChanged;

  const Live2DCharacterView({
    super.key,
    required this.config,
    this.isSpeaking = false,
    this.responseText = '',
    this.ttsPlayback,
    this.controller,
    this.fallback,
    this.showStatus = false,
    this.interactive = false,
    this.resetOnDoubleTap = true,
    this.onReady,
    this.onTransformChanged,
  });

  static bool get isPlatformSupported =>
      Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  @override
  State<Live2DCharacterView> createState() => _Live2DCharacterViewState();
}

class _Live2DCharacterViewState extends State<Live2DCharacterView>
    with WidgetsBindingObserver {
  late final _NativeLive2DController _nativeController;
  late final Live2DRenderingLifecycle _renderingLifecycle;
  late Live2DActionOrchestrator _orchestrator;
  late Live2DConfig _actionConfig;
  final Live2DHitTestService _hitTestService = const Live2DHitTestService();
  final Live2DIOSRenderScaleService _iosRenderScaleService =
      const Live2DIOSRenderScaleService();
  final Live2DSentenceBoundaryTracker _sentenceTracker =
      Live2DSentenceBoundaryTracker();
  final Live2DTTSPlaybackCoordinator _ttsPlaybackCoordinator =
      Live2DTTSPlaybackCoordinator();
  final EmotionDetectionService _emotionDetectionService =
      EmotionDetectionService();
  Timer? _scrollSaveTimer;
  String? _loadError;
  int _loadGeneration = 0;
  double _stageScale = 1;
  double _offsetX = 0;
  double _offsetY = 0;
  Live2DStageTransform? _gestureStartTransform;
  Offset? _gestureStartFocalPoint;
  bool _transformDirty = false;
  Future<void> _mouthWrites = Future<void>.value();
  Future<void> _actionWrites = Future<void>.value();
  bool _renderScaleSyncScheduled = false;

  @override
  void initState() {
    super.initState();
    _nativeController =
        Platform.isMacOS ? _MacOSLive2DController() : _MobileLive2DController();
    final appLifecycleState = WidgetsBinding.instance.lifecycleState;
    _renderingLifecycle = Live2DRenderingLifecycle(
      applyPaused: _nativeController.setRenderingPaused,
      initialPaused: appLifecycleState != null &&
          appLifecycleState != AppLifecycleState.resumed,
    );
    _actionConfig = widget.config;
    _orchestrator = _createOrchestrator(_actionConfig);
    _applyConfigTransform(widget.config);
    WidgetsBinding.instance.addObserver(this);
    if (Live2DCharacterView.isPlatformSupported &&
        widget.config.format == Live2DModelFormat.cubism) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadModel());
    }
  }

  @override
  void didUpdateWidget(Live2DCharacterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldConfig = oldWidget.config;
    final config = widget.config;
    if (oldConfig.scale != config.scale ||
        oldConfig.offsetX != config.offsetX ||
        oldConfig.offsetY != config.offsetY) {
      _applyConfigTransform(config);
    }
    if (oldConfig.format != config.format) {
      _loadGeneration++;
      widget.controller?._detach(_nativeController);
      unawaited(_renderingLifecycle.setAttached(false));
      if (config.format == Live2DModelFormat.cubism &&
          Live2DCharacterView.isPlatformSupported) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadModel());
      }
      return;
    }
    if (config.format == Live2DModelFormat.spine) return;
    if (oldConfig.modelId != config.modelId ||
        oldConfig.modelDirectory != config.modelDirectory ||
        oldConfig.modelFileName != config.modelFileName ||
        oldConfig.atlasFileName != config.atlasFileName ||
        oldConfig.source != config.source) {
      _loadModel();
      return;
    }
    if (oldConfig.motionSpeed != config.motionSpeed &&
        _nativeController.value.isLoaded) {
      unawaited(_nativeController.setMotionSpeed(config.motionSpeed));
    }
    final playback = widget.ttsPlayback;
    if (playback != null) {
      if (oldWidget.ttsPlayback?.sequence != playback.sequence) {
        _handleTTSPlaybackChanged(oldWidget.ttsPlayback, playback);
      }
    } else if (oldWidget.isSpeaking != widget.isSpeaking) {
      _handleSpeakingChanged();
    } else if (widget.isSpeaking &&
        oldWidget.responseText != widget.responseText) {
      _handleResponseTextChanged();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    final isVisible = (route?.isCurrent ?? true) && TickerMode.of(context);
    unawaited(
      _renderingLifecycle.setViewVisible(isVisible).catchError((_) {}),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    unawaited(
      _renderingLifecycle
          .setAppActive(state == AppLifecycleState.resumed)
          .catchError((_) {}),
    );
  }

  @override
  void didChangeMetrics() {
    if (!Platform.isIOS ||
        widget.config.format != Live2DModelFormat.cubism ||
        _renderScaleSyncScheduled) {
      return;
    }
    _renderScaleSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _renderScaleSyncScheduled = false;
      if (!mounted || !_nativeController.value.isAttached) return;
      unawaited(_synchronizeIOSRenderScale(_loadGeneration));
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Live2DCharacterView.isPlatformSupported &&
        widget.config.format == Live2DModelFormat.cubism) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadModel());
    }
  }

  Future<void> _loadModel() async {
    if (!Live2DCharacterView.isPlatformSupported ||
        widget.config.format != Live2DModelFormat.cubism) {
      return;
    }
    final generation = ++_loadGeneration;
    _orchestrator.reset();
    _sentenceTracker.reset(text: widget.responseText);
    _ttsPlaybackCoordinator.reset();
    if (mounted) setState(() => _loadError = null);

    try {
      await _nativeController.whenAttached;
      if (!mounted || generation != _loadGeneration) return;
      if (Platform.isIOS) {
        await _synchronizeIOSRenderScale(generation);
      }
      if (!mounted || generation != _loadGeneration) return;
      if (Platform.isAndroid && !_renderingLifecycle.isAttached) {
        // flutter_live2d reports its platform-view id before Android attaches
        // the TextureView surface. Commands sent in that gap are discarded by
        // the render hub, so let the platform view composite before loading.
        await WidgetsBinding.instance.endOfFrame;
        await WidgetsBinding.instance.endOfFrame;
      }
      if (!mounted || generation != _loadGeneration) return;
      try {
        await _renderingLifecycle.setAttached(true);
      } catch (_) {
        // A lifecycle command can be retried on the next app state change.
      }
      if (!mounted || generation != _loadGeneration) return;
      final actionModel = await _discoverActionConfig();
      if (!mounted || generation != _loadGeneration) return;
      final modelDirectory = await _resolveModelDirectory();
      final loaded = await _nativeController.loadModel(
        modelDir: modelDirectory,
        modelFileName: widget.config.modelFileName,
      );
      if (!mounted || generation != _loadGeneration) return;
      if (!loaded) {
        setState(() {
          _loadError = _nativeController.value.lastError?.message ??
              'The model could not be loaded.';
        });
        return;
      }
      await _nativeController.setMotionSpeed(widget.config.motionSpeed);
      _replaceOrchestrator(
        actionModel.config,
        tapMotions: actionModel.motions,
      );
      widget.controller?._attach(
        _nativeController,
        widget.config.modelId,
        actionModel.config.lipSyncParameter,
        _orchestrator,
        _handleTapAt,
      );
      if (Platform.isIOS) {
        await _synchronizeIOSRenderScale(generation);
      }
      if (!mounted || generation != _loadGeneration) return;
      _notifyReady();
      final playback = widget.ttsPlayback;
      if (playback?.phase == TTSPlaybackPhase.playing) {
        await _orchestrator.onMessageStarted();
        await _setMouthOpen(playback!.mouthOpen);
      } else if (playback?.phase == TTSPlaybackPhase.paused) {
        await _setMouthOpen(0);
        await _orchestrator.onPlaybackPaused();
      } else if (playback == null && widget.isSpeaking) {
        await _orchestrator.onMessageStarted();
      } else {
        await _setMouthOpen(0);
        await _orchestrator.onIdleTimeout();
      }
    } catch (error) {
      if (mounted && generation == _loadGeneration) {
        setState(() => _loadError = error.toString());
      }
    }
  }

  Future<void> _synchronizeIOSRenderScale(int generation) async {
    for (var attempt = 0; attempt < 4; attempt++) {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || generation != _loadGeneration) return;
      try {
        await _iosRenderScaleService.synchronize(
          devicePixelRatio: View.of(context).devicePixelRatio,
        );
      } catch (_) {
        // Rendering can continue at the platform default if the bridge is absent.
        return;
      }
    }
  }

  Future<String> _resolveModelDirectory() async {
    if (widget.config.source != Live2DModelSource.appData) {
      return widget.config.modelDirectory;
    }
    final dataPath = await PathUtils.getDataPath();
    return '$dataPath/${widget.config.modelDirectory}';
  }

  Future<({Live2DConfig config, List<Live2DMotionRef> motions})>
      _discoverActionConfig() async {
    try {
      final config = widget.config;
      final definition = Live2DModelDefinition(
        id: config.modelId,
        displayName: config.displayName,
        modelDirectory: config.modelDirectory,
        modelFileName: config.modelFileName,
        source: config.source,
        format: config.format,
        atlasFileName: config.atlasFileName,
      );
      final dataPath = config.source == Live2DModelSource.appData
          ? await PathUtils.getDataPath()
          : null;
      final manifest = await Live2DService(dataPath: dataPath).loadManifest(
        definition,
      );
      return (
        config: config.withActionDefaults(
          Live2DConfig.fromDefinition(definition, manifest),
          discoveredMotions: manifest.motions,
        ),
        motions: manifest.motions,
      );
    } catch (_) {
      return (
        config: widget.config,
        motions: const <Live2DMotionRef>[],
      );
    }
  }

  Live2DActionOrchestrator _createOrchestrator(
    Live2DConfig config, {
    Iterable<Live2DMotionRef> tapMotions = const [],
  }) {
    return Live2DActionOrchestrator(
      resolver: Live2DActionResolver(config, tapMotions: tapMotions),
      player: _playMotion,
      replayIdleAtMotionBoundary: !Platform.isMacOS,
    );
  }

  void _replaceOrchestrator(
    Live2DConfig config, {
    Iterable<Live2DMotionRef> tapMotions = const [],
  }) {
    _orchestrator.dispose();
    _actionConfig = config;
    _orchestrator = _createOrchestrator(
      config,
      tapMotions: tapMotions,
    );
  }

  void _handleSpeakingChanged() {
    if (widget.isSpeaking) {
      _sentenceTracker.reset(text: widget.responseText);
      unawaited(_orchestrator.onMessageStarted());
      return;
    }

    final emotion = _emotionDetectionService.detectEmotion(widget.responseText);
    unawaited(
      _orchestrator.onResponseCompleted(emotion: emotion.id),
    );
  }

  void _handleResponseTextChanged() {
    final count = _sentenceTracker.takeNewBoundaries(widget.responseText);
    for (var index = 0; index < count; index++) {
      unawaited(_orchestrator.onSentenceBoundary());
    }
  }

  void _handleTTSPlaybackChanged(
    TTSPlaybackState? previous,
    TTSPlaybackState next,
  ) {
    final update = _ttsPlaybackCoordinator.evaluate(previous, next);
    unawaited(_setMouthOpen(update.mouthOpen));
    _actionWrites = _actionWrites.then((_) async {
      switch (update.lifecycle) {
        case Live2DTTSLifecycleEvent.none:
          break;
        case Live2DTTSLifecycleEvent.started:
          await _orchestrator.onMessageStarted();
        case Live2DTTSLifecycleEvent.paused:
          await _orchestrator.onPlaybackPaused();
        case Live2DTTSLifecycleEvent.completed:
          final emotion = _emotionDetectionService.detectEmotion(next.text);
          await _orchestrator.onResponseCompleted(emotion: emotion.id);
        case Live2DTTSLifecycleEvent.stopped:
          await _orchestrator.onPlaybackStopped();
      }
      for (var index = 0; index < update.sentenceBoundaries; index++) {
        await _orchestrator.onSentenceBoundary();
      }
    }).catchError((_) {});
  }

  Future<void> _setMouthOpen(double value) {
    _mouthWrites = _mouthWrites.then((_) async {
      if (!_nativeController.value.isLoaded) return;
      try {
        await _nativeController.setParameter(
          _actionConfig.lipSyncParameter,
          value.clamp(0, 1),
        );
      } catch (_) {
        // Missing LipSync parameters degrade without affecting playback.
      }
    });
    return _mouthWrites;
  }

  Future<bool> _playMotion(Live2DMotionRef motion, int priority) async {
    if (!_nativeController.value.isLoaded) return false;
    try {
      await _nativeController.startMotion(
        group: motion.group,
        index: motion.index,
        priority: priority,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  void _handleTap(TapUpDetails details) {
    unawaited(_handleTapAt(details.localPosition));
  }

  Future<bool> _handleTapAt(Offset localPosition) {
    final size = context.size;
    if (size == null || size.isEmpty) return Future.value(false);
    final translatedX = localPosition.dx - (_offsetX * size.width);
    final translatedY = localPosition.dy - (_offsetY * size.height);
    final normalizedX =
        ((translatedX - size.width / 2) / _stageScale + size.width / 2) /
            size.width;
    final normalizedY =
        ((translatedY - size.height / 2) / _stageScale + size.height / 2) /
            size.height;
    final hit = _hitTestService.hitTest(
      hitAreas: _actionConfig.hitAreas,
      normalizedX: normalizedX,
      normalizedY: normalizedY,
    );
    return _orchestrator.onTap(hit);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _scrollSaveTimer?.cancel();
    _gestureStartTransform = _currentTransform;
    _gestureStartFocalPoint = details.localFocalPoint;
    _transformDirty = false;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final size = context.size;
    final startTransform = _gestureStartTransform;
    final startFocalPoint = _gestureStartFocalPoint;
    if (!widget.interactive ||
        size == null ||
        size.isEmpty ||
        startTransform == null ||
        startFocalPoint == null) {
      return;
    }
    final next = Live2DStageTransform.applyGesture(
      start: startTransform,
      startFocalPoint: startFocalPoint,
      currentFocalPoint: details.localFocalPoint,
      scaleDelta: details.scale,
      size: size,
    );

    setState(() {
      _stageScale = next.scale;
      _offsetX = next.offsetX;
      _offsetY = next.offsetY;
      _transformDirty = true;
    });
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _gestureStartTransform = null;
    _gestureStartFocalPoint = null;
    if (_transformDirty) _notifyTransformChanged();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.interactive || event is! PointerScrollEvent) return;
    GestureBinding.instance.pointerSignalResolver.register(event, (event) {
      final scrollEvent = event as PointerScrollEvent;
      final size = context.size;
      if (size == null || size.isEmpty) return;
      final scaleFactor = math.exp(-scrollEvent.scrollDelta.dy * 0.0015);
      _scaleAroundPoint(
        (_stageScale * scaleFactor).clamp(
          Live2DStageTransform.minScale,
          Live2DStageTransform.maxScale,
        ),
        scrollEvent.localPosition,
        size,
      );
      _scrollSaveTimer?.cancel();
      _scrollSaveTimer = Timer(
        const Duration(milliseconds: 250),
        _notifyTransformChanged,
      );
    });
  }

  void _scaleAroundPoint(double nextScale, Offset focalPoint, Size size) {
    if (nextScale == _stageScale) return;
    final next = Live2DStageTransform.applyGesture(
      start: _currentTransform,
      startFocalPoint: focalPoint,
      currentFocalPoint: focalPoint,
      scaleDelta: nextScale / _stageScale,
      size: size,
    );
    setState(() {
      _stageScale = next.scale;
      _offsetX = next.offsetX;
      _offsetY = next.offsetY;
    });
  }

  Live2DStageTransform get _currentTransform =>
      Live2DStageTransform.constrained(
        scale: _stageScale,
        offsetX: _offsetX,
        offsetY: _offsetY,
      );

  void _applyConfigTransform(Live2DConfig config) {
    final transform = Live2DStageTransform.constrained(
      scale: config.scale,
      offsetX: config.offsetX,
      offsetY: config.offsetY,
    );
    _stageScale = transform.scale;
    _offsetX = transform.offsetX;
    _offsetY = transform.offsetY;
  }

  void _resetTransform() {
    _scrollSaveTimer?.cancel();
    setState(() {
      _stageScale = 1;
      _offsetX = 0;
      _offsetY = 0;
    });
    _notifyTransformChanged();
  }

  void _notifyReady() {
    final callback = widget.onReady;
    if (callback == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  void _notifyTransformChanged() {
    _transformDirty = false;
    widget.onTransformChanged?.call(
      Live2DStageTransform(
        scale: _stageScale,
        offsetX: _offsetX,
        offsetY: _offsetY,
      ),
    );
  }

  @override
  void dispose() {
    _loadGeneration++;
    _scrollSaveTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    widget.controller?._detach(_nativeController);
    _orchestrator.dispose();
    unawaited(_stopNativeRenderer());
    super.dispose();
  }

  Future<void> _stopNativeRenderer() async {
    try {
      await _renderingLifecycle.pauseForTeardown();
    } catch (_) {}
    try {
      await _nativeController.setRenderingPaused(true);
    } catch (_) {}
    try {
      await _setMouthOpen(0);
    } catch (_) {}
    _renderingLifecycle.dispose();
    _nativeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Live2DCharacterView.isPlatformSupported) {
      return widget.fallback ??
          _StatusMessage(
            icon: Icons.phone_android,
            message: 'Live2D is available on Android, iOS, and macOS.',
            visible: widget.showStatus,
          );
    }

    if (widget.config.format == Live2DModelFormat.spine) {
      return _SpineCharacterView(
        key: ValueKey(
          '${widget.config.modelDirectory}/${widget.config.modelFileName}',
        ),
        config: widget.config,
        isSpeaking: widget.isSpeaking,
        responseText: widget.responseText,
        ttsPlayback: widget.ttsPlayback,
        controller: widget.controller,
        fallback: widget.fallback,
        showStatus: widget.showStatus,
        interactive: widget.interactive,
        resetOnDoubleTap: widget.resetOnDoubleTap,
        onReady: widget.onReady,
        onTransformChanged: widget.onTransformChanged,
      );
    }

    return ClipRect(
      child: ValueListenableBuilder<Live2DViewState>(
        valueListenable: _nativeController.listenable,
        builder: (context, state, _) {
          final error = _loadError ?? state.lastError?.message;
          if (error != null) {
            return widget.fallback ??
                _StatusMessage(
                  icon: Icons.broken_image_outlined,
                  message: error,
                  visible: widget.showStatus,
                );
          }

          Widget live2DView = _nativeController.buildView();
          final opacity = widget.config.opacity.clamp(0.0, 1.0);
          if (opacity < 1.0) {
            live2DView = Opacity(opacity: opacity, child: live2DView);
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              Listener(
                onPointerSignal: _handlePointerSignal,
                child: MouseRegion(
                  cursor: widget.interactive
                      ? SystemMouseCursors.grab
                      : MouseCursor.defer,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: _handleTap,
                    onDoubleTap: widget.interactive && widget.resetOnDoubleTap
                        ? _resetTransform
                        : null,
                    onScaleStart: widget.interactive ? _handleScaleStart : null,
                    onScaleUpdate:
                        widget.interactive ? _handleScaleUpdate : null,
                    onScaleEnd: widget.interactive ? _handleScaleEnd : null,
                    child: FractionalTranslation(
                      translation: Offset(_offsetX, _offsetY),
                      child: Transform.scale(
                        scale: _stageScale,
                        child: live2DView,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.showStatus &&
                  (state.isLoadingModel || !state.isLoaded))
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool visible;

  const _StatusMessage({
    required this.icon,
    required this.message,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
