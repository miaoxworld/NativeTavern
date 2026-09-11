import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/provider_usage.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/providers/home_widget_providers.dart';
import 'package:native_tavern/presentation/providers/locale_provider.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/theme_providers.dart';
import 'package:native_tavern/presentation/screens/ai_config/ai_config_screen.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

class HomeWidgetSettingsScreen extends ConsumerWidget {
  const HomeWidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(homeWidgetSettingsProvider);
    final config = ref.watch(llmConfigProvider);
    final usage = ref.watch(providerUsageServiceProvider);
    final characters =
        ref.watch(characterListProvider).asData?.value ?? const <Character>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeWidgets)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.homeWidgetsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.widgets_outlined),
            title: Text(l10n.homeWidgetEnabled),
            subtitle: Text(l10n.homeWidgetEnabledHint),
            value: settings.enabled,
            onChanged: (value) {
              ref
                  .read(homeWidgetSettingsProvider.notifier)
                  .update(settings.copyWith(enabled: value));
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.shuffle),
            title: Text(l10n.homeWidgetShuffleChats),
            subtitle: Text(l10n.homeWidgetShuffleChatsHint),
            value: settings.chatOrder == ChatSlideOrder.shuffled,
            onChanged: (value) {
              ref.read(homeWidgetSettingsProvider.notifier).update(
                    settings.copyWith(
                      chatOrder: value
                          ? ChatSlideOrder.shuffled
                          : ChatSlideOrder.chronological,
                    ),
                  );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.star_outline),
            title: Text(l10n.homeWidgetFavoritesOnly),
            value: settings.favoritesOnlyCharacters,
            onChanged: (value) {
              ref.read(homeWidgetSettingsProvider.notifier).update(
                    settings.copyWith(favoritesOnlyCharacters: value),
                  );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.chat_bubble_outline),
            title: Text(l10n.homeWidgetFavoriteChatsOnly),
            subtitle: Text(l10n.homeWidgetFavoriteChatsOnlyHint),
            value: settings.favoriteChatsOnly,
            onChanged: (value) {
              ref.read(homeWidgetSettingsProvider.notifier).update(
                    settings.copyWith(favoriteChatsOnly: value),
                  );
            },
          ),
          ListTile(
            leading: const Icon(Icons.push_pin_outlined),
            title: Text(l10n.homeWidgetPinCharacter),
            subtitle: Text(l10n.homeWidgetPinCharacterHint),
            trailing: SizedBox(
              width: 150,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: _pinnedValue(settings.pinnedCharacterId, characters),
                  onChanged: (value) {
                    ref.read(homeWidgetSettingsProvider.notifier).update(
                          settings.copyWith(pinnedCharacterId: value),
                        );
                  },
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.homeWidgetPinCharacterNone),
                    ),
                    ..._pinItems(settings.pinnedCharacterId, characters),
                  ],
                ),
              ),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.cloud_sync_outlined),
            title: Text(l10n.homeWidgetRefreshRemoteUsage),
            subtitle: Text(l10n.homeWidgetRefreshRemoteUsageHint),
            value: settings.refreshRemoteUsage,
            onChanged: (value) {
              ref.read(homeWidgetSettingsProvider.notifier).update(
                    settings.copyWith(refreshRemoteUsage: value),
                  );
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(l10n.homeWidgetSlideInterval),
            subtitle: Text(l10n.secondsValue(settings.slideIntervalSeconds)),
            trailing: DropdownButton<int>(
              value: settings.slideIntervalSeconds,
              onChanged: (value) {
                if (value == null) return;
                ref.read(homeWidgetSettingsProvider.notifier).update(
                      settings.copyWith(slideIntervalSeconds: value),
                    );
              },
              items: HomeWidgetSettings.slideIntervals
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(l10n.secondsValue(value)),
                    ),
                  )
                  .toList(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.forum_outlined),
            title: Text(l10n.homeWidgetMessagesPerChat),
            trailing: DropdownButton<int>(
              value: settings.messagesPerChat,
              onChanged: (value) {
                if (value == null) return;
                ref.read(homeWidgetSettingsProvider.notifier).update(
                      settings.copyWith(messagesPerChat: value),
                    );
              },
              items: HomeWidgetSettings.messagesPerChatOptions
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value'),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.providerUsage,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              l10n.providerUsageSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
          FutureBuilder<List<Object?>>(
            future: Future.wait<Object?>([
              usage.today(config),
              usage.totalsFor(config),
              usage.cachedRemote(config.provider.name),
            ]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final today = snapshot.data![0] as ProviderUsageTotals;
              final allTime = snapshot.data![1] as ProviderUsageTotals;
              final remote = snapshot.data![2] as RemoteProviderUsage?;
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.today),
                    title: Text(l10n.providerUsageToday),
                    subtitle: Text(
                      '${l10n.homeWidgetTokensToday}: ${_formatTokens(today.totalTokens)} · '
                      '${l10n.providerUsageGenerations}: ${today.generationCount}',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.all_inclusive),
                    title: Text(l10n.providerUsageAllTime),
                    subtitle: Text(
                      '${l10n.providerUsagePrompt}: ${_formatTokens(allTime.promptTokens)} · '
                      '${l10n.providerUsageCompletion}: ${_formatTokens(allTime.completionTokens)}',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: Text(l10n.providerUsageRemoteBalance),
                    subtitle: Text(
                      remote == null
                          ? l10n.homeWidgetRemoteUnsupported
                          : remote.supported
                              ? _formatRemote(remote.remaining, remote.unit)
                              : l10n.providerUsageUnsupported,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: l10n.homeWidgetRefreshRemoteUsage,
                      onPressed: () async {
                        await usage.refreshRemote(config);
                        final locale = ref.read(localeProvider);
                        final localeCode = locale?.languageCode ?? 'en';
                        final hideRestricted =
                            RegionService.hidesRestrictedAiProviders(
                          isChinaRegion:
                              ref.read(isChinaRegionProvider).valueOrNull ??
                                  false,
                          languageCode: localeCode,
                        );
                        await ref.read(homeWidgetSyncServiceProvider).publish(
                              config: config,
                              settings: settings,
                              labels: homeWidgetLabelsFromL10n(l10n),
                              locale: localeCode,
                              providerLabel: (provider) =>
                                  homeWidgetProviderLabel(
                                provider,
                                hideRestricted: hideRestricted,
                              ),
                              theme: homeWidgetThemeFromConfig(
                                ref.read(activeThemeConfigProvider),
                              ),
                              refreshRemote: true,
                            );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.homeWidgetAddHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  static String? _pinnedValue(String? pin, List<Character> characters) {
    if (pin == null || pin.isEmpty) return null;
    return pin;
  }

  static List<DropdownMenuItem<String?>> _pinItems(
    String? pin,
    List<Character> characters,
  ) {
    final items = characters
        .map(
          (character) => DropdownMenuItem<String?>(
            value: character.id,
            child: Text(
              character.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
    if (pin != null &&
        pin.isNotEmpty &&
        characters.every((character) => character.id != pin)) {
      items.insert(
        0,
        DropdownMenuItem<String?>(
          value: pin,
          child: Text(
            pin,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return items;
  }

  static String _formatTokens(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$value';
  }

  static String _formatRemote(double? remaining, String? unit) {
    if (remaining == null) return '—';
    final suffix = unit == null || unit.isEmpty ? '' : ' $unit';
    return remaining.toStringAsFixed(2) + suffix;
  }
}
