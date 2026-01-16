import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/providers/theme_providers.dart';
import 'package:native_tavern/presentation/providers/locale_provider.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/domain/services/debug_log_service.dart';
import 'package:native_tavern/presentation/widgets/debug_log_overlay.dart';

/// Global navigator key for showing dialogs from anywhere
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class NativeTavernApp extends ConsumerStatefulWidget {
  const NativeTavernApp({super.key});

  @override
  ConsumerState<NativeTavernApp> createState() => _NativeTavernAppState();
}

class _NativeTavernAppState extends ConsumerState<NativeTavernApp> {
  @override
  void initState() {
    super.initState();
    // Check if debug log should be enabled on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(appSettingsProvider);
      if (settings.enableDebugLog) {
        ref.read(debugLogServiceProvider).startCapturing();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final activeTheme = ref.watch(activeThemeConfigProvider);
    final locale = ref.watch(localeProvider);
    final settings = ref.watch(appSettingsProvider);
    
    // Listen for debug log setting changes
    ref.listen<AppSettings>(appSettingsProvider, (previous, next) {
      final debugLogService = ref.read(debugLogServiceProvider);
      if (next.enableDebugLog && !debugLogService.isCapturing) {
        debugLogService.startCapturing();
      } else if (!next.enableDebugLog && debugLogService.isCapturing) {
        debugLogService.stopCapturing();
      }
    });
    
    return MaterialApp.router(
      title: 'NativeTavern',
      debugShowCheckedModeBanner: false,
      theme: activeTheme.toThemeData(),
      darkTheme: activeTheme.toThemeData(),
      themeMode: activeTheme.isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return DebugLogOverlayWrapper(
          enabled: settings.enableDebugLog,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

/// Wrapper widget that shows the debug floating ball when enabled
class DebugLogOverlayWrapper extends ConsumerStatefulWidget {
  final bool enabled;
  final Widget child;

  const DebugLogOverlayWrapper({
    super.key,
    required this.enabled,
    required this.child,
  });

  @override
  ConsumerState<DebugLogOverlayWrapper> createState() => _DebugLogOverlayWrapperState();
}

class _DebugLogOverlayWrapperState extends ConsumerState<DebugLogOverlayWrapper> {
  bool _showLogViewer = false;

  void _toggleLogViewer() {
    setState(() {
      _showLogViewer = !_showLogViewer;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final logs = ref.watch(currentLogsProvider);
    
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Stack(
              children: [
                widget.child,
                if (_showLogViewer)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _toggleLogViewer,
                      child: Container(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                if (_showLogViewer)
                  Positioned(
                    left: 16,
                    right: 16,
                    top: MediaQuery.of(context).padding.top + 50,
                    bottom: MediaQuery.of(context).padding.bottom + 100,
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: DebugLogViewerInline(onClose: _toggleLogViewer),
                    ),
                  ),
                DebugFloatingBall(
                  logCount: logs.length,
                  onTap: _toggleLogViewer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}