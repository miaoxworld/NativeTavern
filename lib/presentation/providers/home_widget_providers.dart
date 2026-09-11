import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/provider_usage_repository.dart';
import 'package:native_tavern/data/models/app_theme_config.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_bridge.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_sync_service.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/presentation/screens/ai_config/ai_config_screen.dart';
import 'package:native_tavern/domain/services/provider_reachability.dart';
import 'package:native_tavern/domain/services/provider_usage_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/providers/locale_provider.dart';
import 'package:native_tavern/presentation/providers/moment_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/theme_providers.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:drift/drift.dart' as drift;

final homeWidgetBridgeProvider = Provider<HomeWidgetBridge>((ref) {
  return HomeWidgetBridge();
});

final providerUsageRepositoryProvider =
    Provider<ProviderUsageRepository>((ref) {
  return ProviderUsageRepository(ref.watch(databaseProvider));
});

final providerUsageServiceProvider = Provider<ProviderUsageService>((ref) {
  final service = ProviderUsageService(
    repository: ref.watch(providerUsageRepositoryProvider),
  );
  service.attachTo(ref.watch(llmServiceProvider));
  return service;
});

final providerReachabilityProvider = Provider<ProviderReachability>((ref) {
  return ProviderReachability.fromLlm(ref.watch(llmServiceProvider));
});

final homeWidgetSyncServiceProvider = Provider<HomeWidgetSyncService>((ref) {
  return HomeWidgetSyncService(
    characters: ref.watch(characterRepositoryProvider),
    chats: ref.watch(chatRepositoryProvider),
    moments: ref.watch(momentRepositoryProvider),
    usage: ref.watch(providerUsageServiceProvider),
    bridge: ref.watch(homeWidgetBridgeProvider),
    reachability: ref.watch(providerReachabilityProvider),
  );
});

final homeWidgetSettingsProvider =
    StateNotifierProvider<HomeWidgetSettingsNotifier, HomeWidgetSettings>(
        (ref) {
  return HomeWidgetSettingsNotifier(
    ref.watch(databaseProvider),
  );
});

class HomeWidgetSettingsNotifier extends StateNotifier<HomeWidgetSettings> {
  HomeWidgetSettingsNotifier(this._db) : super(const HomeWidgetSettings()) {
    _load();
  }

  final AppDatabase _db;
  static const _key = 'home_widget_settings';

  Future<void> _load() async {
    final row = await (_db.select(_db.globalStates)
          ..where((table) => table.key.equals(_key)))
        .getSingleOrNull();
    if (row == null) return;
    try {
      state = HomeWidgetSettings.fromJson(
        jsonDecode(row.value) as Map<String, dynamic>,
      );
    } catch (_) {}
  }

  Future<void> _save() async {
    await _db.into(_db.globalStates).insert(
          GlobalStatesCompanion(
            key: const drift.Value(_key),
            value: drift.Value(jsonEncode(state.toJson())),
            updatedAt: drift.Value(DateTime.now()),
          ),
          mode: drift.InsertMode.insertOrReplace,
        );
  }

  void update(HomeWidgetSettings settings) {
    state = settings;
    _save();
  }
}

HomeWidgetLabels homeWidgetLabelsFromL10n(AppLocalizations l10n) {
  return HomeWidgetLabels(
    moments: l10n.homeWidgetMoments,
    chats: l10n.homeWidgetChats,
    characters: l10n.homeWidgetCharacters,
    status: l10n.homeWidgetStatus,
    emptyMoments: l10n.homeWidgetEmptyMoments,
    emptyChats: l10n.homeWidgetEmptyChats,
    emptyCharacters: l10n.homeWidgetEmptyCharacters,
    openApp: l10n.homeWidgetOpenApp,
    providerReady: l10n.homeWidgetProviderReady,
    providerNeedsKey: l10n.homeWidgetProviderNeedsKey,
    providerLocal: l10n.homeWidgetProviderLocal,
    providerUnreachable: l10n.homeWidgetProviderUnreachable,
    tokensToday: l10n.homeWidgetTokensToday,
    tokensTotal: l10n.homeWidgetTokensTotal,
    currentModel: l10n.homeWidgetCurrentModel,
    remoteCredits: l10n.homeWidgetRemoteCredits,
    remoteUnsupported: l10n.homeWidgetRemoteUnsupported,
    updated: l10n.homeWidgetUpdated,
    previous: l10n.homeWidgetPrevious,
    next: l10n.homeWidgetNext,
  );
}

HomeWidgetTheme homeWidgetThemeFromConfig(AppThemeConfig config) {
  return HomeWidgetTheme(
    isDark: config.isDark,
    primary: config.primaryColor,
    accent: config.accentColor,
    background: config.backgroundColor,
    surface: config.surfaceColor,
    card: config.cardColor,
    textPrimary: config.textPrimaryColor,
    textSecondary: config.textSecondaryColor,
  );
}

String homeWidgetProviderLabel(
  LLMProvider provider, {
  bool hideRestricted = false,
}) {
  if (hideRestricted && RegionService.isRestrictedCloudProvider(provider)) {
    return 'LLM';
  }
  return switch (provider) {
    LLMProvider.openai => 'OpenAI',
    LLMProvider.claude => 'Claude',
    LLMProvider.gemini => 'Gemini',
    LLMProvider.openRouter => 'OpenRouter',
    LLMProvider.deepSeek => 'DeepSeek',
    LLMProvider.qwen => 'Qwen',
    LLMProvider.ollama => 'Ollama',
    LLMProvider.lmStudio => 'LM Studio',
    LLMProvider.koboldCpp => 'KoboldCpp',
    LLMProvider.siliconFlow => 'SiliconFlow',
    LLMProvider.moonshot => 'Moonshot',
    LLMProvider.zai => 'Z.AI',
    LLMProvider.miniMax => 'MiniMax',
    LLMProvider.openAICompatible => 'OAI Compatible',
    LLMProvider.xai => 'xAI (Grok)',
  };
}

/// Publishes widget snapshots when chats, moments, settings, or usage change.
final homeWidgetSyncRegistrationProvider = Provider<void>((ref) {
  Timer? debounce;
  void schedule() {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 400), () async {
      final locale = ref.read(localeProvider);
      final localeCode = locale?.languageCode ?? 'en';
      final l10n = lookupAppLocalizations(locale ?? const Locale('en'));
      final hideRestricted = RegionService.hidesRestrictedAiProviders(
        isChinaRegion: ref.read(isChinaRegionProvider).valueOrNull ?? false,
        languageCode: localeCode,
      );
      await ref.read(homeWidgetSyncServiceProvider).publish(
            config: ref.read(llmConfigProvider),
            settings: ref.read(homeWidgetSettingsProvider),
            labels: homeWidgetLabelsFromL10n(l10n),
            locale: localeCode,
            providerLabel: (provider) => homeWidgetProviderLabel(
              provider,
              hideRestricted: hideRestricted,
            ),
            theme: homeWidgetThemeFromConfig(
              ref.read(activeThemeConfigProvider),
            ),
            refreshRemote: false,
          );
    });
  }

  ref.onDispose(() => debounce?.cancel());
  ref.listen(llmConfigProvider, (_, __) => schedule());
  ref.listen(homeWidgetSettingsProvider, (_, __) => schedule());
  ref.listen(characterListProvider, (_, __) => schedule());
  ref.listen(recentChatsProvider, (_, __) => schedule());
  ref.listen(momentFeedProvider, (_, __) => schedule());
  ref.listen(activeThemeConfigProvider, (_, __) => schedule());
  schedule();
});
