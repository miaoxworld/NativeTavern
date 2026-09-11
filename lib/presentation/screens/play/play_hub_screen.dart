import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/widgets/play/ai_play_feature_gate.dart';

/// Play tab hub: four names only. No timeline, switches, or status.
class PlayHubScreen extends ConsumerWidget {
  const PlayHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.playHub)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          _PlayHubRow(
            key: const Key('play-hub-moments'),
            icon: Icons.dynamic_feed_outlined,
            title: l10n.moments,
            onTap: () {
              if (context.mounted) {
                context.push(AppRoutes.playMoments);
              }
            },
          ),
          _PlayHubRow(
            key: const Key('play-hub-story'),
            icon: Icons.menu_book_outlined,
            title: l10n.story,
            onTap: () async {
              final enabled = await ensureAiPlayFeatureEnabled(
                context,
                ref,
                AiPlayFeature.story,
              );
              if (enabled && context.mounted) {
                context.push(AppRoutes.playStory);
              }
            },
          ),
          _PlayHubRow(
            key: const Key('play-hub-world-info'),
            icon: Icons.public_outlined,
            title: l10n.worldInfo,
            onTap: () => context.push(AppRoutes.worldInfo),
          ),
          _PlayHubRow(
            key: const Key('play-hub-data-bank'),
            icon: Icons.library_books_outlined,
            title: l10n.dataBank,
            onTap: () => context.push(AppRoutes.dataBank),
          ),
        ],
      ),
    );
  }
}

class _PlayHubRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PlayHubRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      minVerticalPadding: 18,
      minTileHeight: 80,
      leading: Icon(icon, size: 32),
      title: Text(title, style: theme.textTheme.titleLarge),
      trailing: const Icon(Icons.chevron_right, size: 28),
      onTap: onTap,
    );
  }
}
