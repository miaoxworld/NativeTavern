import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Main app shell with bottom navigation
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/characters')) {
      return 1;
    }
    if (location.startsWith('/world-info')) {
      return 2;
    }
    if (location.startsWith('/ai-config')) {
      return 3;
    }
    if (location.startsWith('/settings')) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.characters);
        break;
      case 2:
        context.go(AppRoutes.worldInfo);
        break;
      case 3:
        context.go(AppRoutes.aiConfig);
        break;
      case 4:
        context.go(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final l10n = AppLocalizations.of(context)!;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _onItemTapped(context, index),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.chat_bubble_outline),
          selectedIcon: const Icon(Icons.chat_bubble),
          label: l10n.chats,
        ),
        NavigationDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          label: l10n.characters,
        ),
        NavigationDestination(
          icon: const Icon(Icons.auto_stories_outlined),
          selectedIcon: const Icon(Icons.auto_stories),
          label: l10n.worldInfo,
        ),
        NavigationDestination(
          icon: const Icon(Icons.auto_awesome_outlined),
          selectedIcon: const Icon(Icons.auto_awesome),
          label: l10n.aiConfig,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: l10n.settings,
        ),
      ],
    );
  }
}