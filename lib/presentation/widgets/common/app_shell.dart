import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/widgets/common/app_viewport.dart';

/// Main navigation follows the system's bar edge or the available width.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowLayout = WindowLayoutScope.maybeOf(context);
        final edge = windowLayout?.supportsVerticalBars == true
            ? windowLayout?.verticalBarEdge
            : constraints.maxWidth >= 600
                ? VerticalBarEdge.left
                : null;
        final railWidth =
            windowLayout?.barWidth != null && windowLayout!.barWidth > 0
                ? windowLayout.barWidth
                : 96.0;
        return Scaffold(
          // Keep the routed child in the same element slot as bars move.
          body: Row(
            textDirection: TextDirection.ltr,
            children: [
              SizedBox(
                width: edge == VerticalBarEdge.left ? railWidth : 0,
                child: edge == VerticalBarEdge.left
                    ? const _AppNavigation(vertical: true)
                    : null,
              ),
              Expanded(child: child),
              SizedBox(
                width: edge == VerticalBarEdge.right ? railWidth : 0,
                child: edge == VerticalBarEdge.right
                    ? const _AppNavigation(vertical: true)
                    : null,
              ),
            ],
          ),
          bottomNavigationBar:
              edge == null ? const _AppNavigation(vertical: false) : null,
        );
      },
    );
  }
}

class _AppNavigation extends StatelessWidget {
  const _AppNavigation({required this.vertical});

  final bool vertical;

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/characters')) {
      return 1;
    }
    if (location.startsWith('/play') || location.startsWith('/world-info')) {
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
        context.go(AppRoutes.play);
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
    final l10n = AppLocalizations.of(context);

    final destinations = [
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
        icon: const Icon(Icons.explore_outlined),
        selectedIcon: const Icon(Icons.explore),
        label: l10n.playHub,
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
    ];

    if (!vertical) {
      return NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: destinations,
      );
    }
    final layout = WindowLayoutScope.maybeOf(context);
    final sharedBar = layout != null && layout.barWidth > 0;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: sharedBar ? layout.barPadding : EdgeInsets.zero,
        child: SafeArea(
          top: !sharedBar,
          bottom: !sharedBar,
          left: !sharedBar,
          right: !sharedBar,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: SizedBox(
                height: math.max(
                    constraints.maxHeight,
                    destinations.length *
                            96 *
                            MediaQuery.textScalerOf(context).scale(1) +
                        16),
                child: NavigationRail(
                  minWidth: sharedBar ? layout.barWidth : 96,
                  groupAlignment: -1,
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      _onItemTapped(context, index),
                  destinations: [
                    for (final destination in destinations)
                      NavigationRailDestination(
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                        padding: sharedBar ? EdgeInsets.zero : null,
                        label: Text(destination.label,
                            textAlign: TextAlign.center),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
