import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/providers/theme_providers.dart';

class NativeTavernApp extends ConsumerWidget {
  const NativeTavernApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final activeTheme = ref.watch(activeThemeConfigProvider);
    
    return MaterialApp.router(
      title: 'NativeTavern',
      debugShowCheckedModeBanner: false,
      theme: activeTheme.toThemeData(),
      darkTheme: activeTheme.toThemeData(),
      themeMode: activeTheme.isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}