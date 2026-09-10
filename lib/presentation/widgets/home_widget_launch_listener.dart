import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:native_tavern/presentation/providers/home_widget_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';

/// Opens the matching in-app route when a home screen widget is tapped.
class HomeWidgetLaunchListener extends ConsumerStatefulWidget {
  final Widget child;

  const HomeWidgetLaunchListener({super.key, required this.child});

  @override
  ConsumerState<HomeWidgetLaunchListener> createState() =>
      _HomeWidgetLaunchListenerState();
}

class _HomeWidgetLaunchListenerState
    extends ConsumerState<HomeWidgetLaunchListener> {
  static const _channel = MethodChannel('com.nativetavern/home_widgets');

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_onMethodCall);
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumePending());
  }

  Future<void> _consumePending() async {
    final uri = await ref.read(homeWidgetBridgeProvider).takeLaunchUri();
    if (uri != null) _open(uri);
  }

  Future<dynamic> _onMethodCall(MethodCall call) async {
    if (call.method == 'onLaunchUri') {
      final raw = call.arguments as String?;
      final uri = raw == null ? null : Uri.tryParse(raw);
      if (uri != null) _open(uri);
    }
  }

  void _open(Uri uri) {
    final link = HomeWidgetDeepLink.tryParse(uri);
    if (link == null || !mounted) return;
    ref.read(appRouterProvider).go(link.location);
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
