import 'dart:async';
import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A physical edge, intentionally independent of the UI's reading direction.
enum VerticalBarEdge { left, right }

class WindowLayoutScope extends InheritedWidget {
  const WindowLayoutScope({
    super.key,
    required this.supportsVerticalBars,
    required this.verticalBarEdge,
    this.barWidth = 0,
    this.barPadding = EdgeInsets.zero,
    required super.child,
  });

  final bool supportsVerticalBars;
  final VerticalBarEdge? verticalBarEdge;

  /// Nonzero when custom controls share the physical system bar column.
  final double barWidth;
  final EdgeInsets barPadding;

  static WindowLayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WindowLayoutScope>();

  @override
  bool updateShouldNotify(WindowLayoutScope oldWidget) =>
      supportsVerticalBars != oldWidget.supportsVerticalBars ||
      verticalBarEdge != oldWidget.verticalBarEdge ||
      barWidth != oldWidget.barWidth ||
      barPadding != oldWidget.barPadding;
}

/// Keeps the routed tree mounted while its window and reserved regions change.
///
/// UIKit geometry is measured in the Flutter host view's coordinates. Never
/// apply a snapshot to a differently sized Flutter frame during a transition.
/// Custom screens share the largest unobstructed pane when a fold is active.
class AppViewport extends StatefulWidget {
  const AppViewport({
    super.key,
    required this.child,
    this.shareVerticalBar = false,
  });

  static const channelName = 'com.nativetavern/window_geometry';
  final Widget child;

  /// Enable only for routes whose custom bars avoid native reserved regions.
  final bool shareVerticalBar;

  @override
  State<AppViewport> createState() => _AppViewportState();
}

class _AppViewportState extends State<AppViewport> with WidgetsBindingObserver {
  static const _channel = MethodChannel(AppViewport.channelName);
  _WindowGeometry? _geometry;
  int _revision = 0;
  bool _refreshScheduled = false;

  late final bool _usesNativeGeometry;

  @override
  void initState() {
    super.initState();
    _usesNativeGeometry =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    WidgetsBinding.instance.addObserver(this);
    if (_usesNativeGeometry) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'geometryChanged') {
          _revision++;
          _updateGeometry(call.arguments);
        }
      });
      unawaited(_refreshGeometry());
    }
  }

  void _updateGeometry(Object? value) {
    if (!mounted) return;
    final geometry = _WindowGeometry.parse(value);
    if (geometry != null) setState(() => _geometry = geometry);
  }

  Future<void> _refreshGeometry() async {
    final revision = ++_revision;
    try {
      final value = await _channel.invokeMethod<Object?>('getGeometry');
      if (mounted && revision == _revision) _updateGeometry(value);
    } on MissingPluginException {
      // Older hosts and non-iOS widget harnesses still resize using Flutter.
    } on PlatformException {
      // Continue using the current Flutter window metrics if UIKit is busy.
    }
  }

  @override
  void didChangeMetrics() {
    if (!_usesNativeGeometry || _refreshScheduled) return;
    _refreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshScheduled = false;
      if (mounted) unawaited(_refreshGeometry());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_usesNativeGeometry) _channel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final geometry = _geometry;
    final matchesWindow = geometry != null &&
        (geometry.size.width - media.size.width).abs() < 1 &&
        (geometry.size.height - media.size.height).abs() < 1;
    final effectiveMedia = matchesWindow
        ? media.copyWith(
            displayFeatures: [...media.displayFeatures, ...geometry.features],
          )
        : media;
    final theme = Theme.of(context);
    final edge = matchesWindow ? geometry.edge : null;
    final barWidth = switch (edge) {
      VerticalBarEdge.left => media.padding.left,
      VerticalBarEdge.right => media.padding.right,
      null => 0.0,
    };
    final bar = widget.shareVerticalBar && barWidth >= kMinInteractiveDimension
        ? Rect.fromLTWH(
            edge == VerticalBarEdge.left ? 0 : media.size.width - barWidth,
            0,
            barWidth,
            media.size.height,
          )
        : null;
    final bounds = _unobstructedBounds(effectiveMedia, bar: bar);
    final sharesBar = bar != null && bounds.overlaps(bar);
    final localMedia = effectiveMedia.removeDisplayFeatures(bounds);
    final barTop = sharesBar
        ? effectiveMedia.displayFeatures
            .where((feature) =>
                feature.type == DisplayFeatureType.cutout &&
                feature.bounds.overlaps(bar.intersect(bounds)))
            .fold(
                bounds.top + localMedia.padding.top,
                (bottom, feature) => bottom > feature.bounds.bottom
                    ? bottom
                    : feature.bounds.bottom)
        : bounds.top;

    return WindowLayoutScope(
      supportsVerticalBars: matchesWindow && geometry.supportsVerticalBars,
      verticalBarEdge: edge,
      barWidth: sharesBar ? barWidth : 0,
      barPadding: sharesBar
          ? EdgeInsets.only(
              top: barTop - bounds.top + 8,
              bottom: localMedia.padding.bottom,
            )
          : EdgeInsets.zero,
      // Continue the side-bar surface under the system status column. Keep
      // controls inset, and the unused fold pane on the content background.
      child: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: edge == VerticalBarEdge.left ? media.padding.left : 0,
              child: ColoredBox(color: theme.colorScheme.surface),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: edge == VerticalBarEdge.right ? media.padding.right : 0,
              child: ColoredBox(color: theme.colorScheme.surface),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                bounds.left,
                bounds.top,
                media.size.width - bounds.right,
                media.size.height - bounds.bottom,
              ),
              child: MediaQuery(
                data: localMedia.copyWith(
                  size: bounds.size,
                  padding: sharesBar
                      ? localMedia.padding.copyWith(
                          left: edge == VerticalBarEdge.left
                              ? 0
                              : localMedia.padding.left,
                          right: edge == VerticalBarEdge.right
                              ? 0
                              : localMedia.padding.right,
                        )
                      : localMedia.padding,
                  viewPadding: sharesBar
                      ? localMedia.viewPadding.copyWith(
                          left: edge == VerticalBarEdge.left
                              ? 0
                              : localMedia.viewPadding.left,
                          right: edge == VerticalBarEdge.right
                              ? 0
                              : localMedia.viewPadding.right,
                        )
                      : localMedia.viewPadding,
                  displayFeatures: [
                    for (final feature in effectiveMedia.displayFeatures)
                      if (bounds.overlaps(feature.bounds))
                        DisplayFeature(
                          bounds: feature.bounds.shift(-bounds.topLeft),
                          type: feature.type,
                          state: feature.state,
                        ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Rect _unobstructedBounds(MediaQueryData media, {Rect? bar}) {
    final window = Rect.fromLTRB(
        bar?.left == 0 ? 0 : media.padding.left,
        0,
        bar?.right == media.size.width
            ? media.size.width
            : media.size.width - media.padding.right,
        media.size.height);
    var candidates = [window];
    for (final feature in media.displayFeatures) {
      // Status indicators and the camera reserve only the upper part of the
      // column. Its controls handle those occlusions rather than excluding
      // the entire column from the page.
      if (bar != null &&
          feature.type == DisplayFeatureType.cutout &&
          bar.intersect(feature.bounds) == feature.bounds) {
        continue;
      }
      if (feature.bounds.shortestSide == 0 &&
          feature.state != DisplayFeatureState.postureHalfOpened) {
        continue;
      }
      final obstacle = feature.bounds.intersect(window);
      if (obstacle.width < 0 || obstacle.height < 0 || obstacle == window) {
        continue;
      }
      final next = <Rect>[];
      for (final pane in candidates) {
        if (!pane.overlaps(obstacle)) {
          next.add(pane);
          continue;
        }
        // Keeping maximal rectangles also handles cameras that do not span an
        // entire edge; DisplayFeatureSubScreen only handles full divisions.
        final options = [
          Rect.fromLTRB(pane.left, pane.top, pane.right, obstacle.top),
          Rect.fromLTRB(pane.left, obstacle.bottom, pane.right, pane.bottom),
          Rect.fromLTRB(pane.left, pane.top, obstacle.left, pane.bottom),
          Rect.fromLTRB(obstacle.right, pane.top, pane.right, pane.bottom),
        ];
        next.addAll(options.map((r) => r.intersect(pane)).where(
              (r) => r.width > 0 && r.height > 0,
            ));
      }
      if (next.isNotEmpty) candidates = next;
    }
    // For equally sized panes, prefer the bottom/right pane for interaction.
    return candidates
        .reduce((a, b) => a.width * a.height > b.width * b.height ? a : b);
  }
}

class _WindowGeometry {
  const _WindowGeometry(
      this.size, this.supportsVerticalBars, this.edge, this.features);

  final Size size;
  final bool supportsVerticalBars;
  final VerticalBarEdge? edge;
  final List<DisplayFeature> features;

  static double? _number(Object? value) =>
      value is num && value.isFinite ? value.toDouble() : null;

  static _WindowGeometry? parse(Object? value) {
    if (value is! Map) return null;
    final width = _number(value['width']);
    final height = _number(value['height']);
    if (width == null || height == null || width <= 0 || height <= 0) {
      return null;
    }
    final edge = switch (value['verticalBarEdge']) {
      'left' => VerticalBarEdge.left,
      'right' => VerticalBarEdge.right,
      _ => null,
    };
    final features = <DisplayFeature>[];
    final regions = value['regions'];
    if (regions is List) {
      for (final region in regions) {
        if (region is! Map) continue;
        final x = _number(region['x']);
        final y = _number(region['y']);
        final w = _number(region['width']);
        final h = _number(region['height']);
        final kind = region['kind'];
        if (x == null ||
            y == null ||
            w == null ||
            h == null ||
            w < 0 ||
            h < 0 ||
            (kind != 'division' && kind != 'occlusion')) {
          continue;
        }
        features.add(DisplayFeature(
          bounds: Rect.fromLTWH(x, y, w, h),
          type: kind == 'division'
              ? DisplayFeatureType.fold
              : DisplayFeatureType.cutout,
          state: kind == 'division'
              ? DisplayFeatureState.postureHalfOpened
              : DisplayFeatureState.unknown,
        ));
      }
    }
    return _WindowGeometry(Size(width, height),
        value['supportsVerticalBars'] == true, edge, features);
  }
}
