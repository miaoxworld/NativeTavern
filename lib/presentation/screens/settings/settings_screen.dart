import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/locale_provider.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/core/flags/rpg_product_ui.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/privacy/ai_data_sharing_consent_gate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

/// Settings screen - App settings only (AI config is in separate tab)
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final packageInfo = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.language),
                    label: Text(l10n.officialWebsite),
                    onPressed: () => launchUrl(
                      Uri.parse('https://nativetavern.com'),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.forum),
                    label: const Text('Discord'),
                    onPressed: () => launchUrl(
                      Uri.parse('https://discord.com/invite/URQvW2FvZa'),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16),
          _buildSectionHeader(context, l10n.user),
          _PersonaTile(),
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(l10n.cloudBackup),
            subtitle: Text(l10n.cloudBackupSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.cloudBackupSettings),
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, l10n.chats),
          ListTile(
            leading: const Icon(Icons.quickreply),
            title: Text(l10n.quickReplies),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.quickReplies),
          ),
          ListTile(
            leading: const Icon(Icons.wallpaper),
            title: Text(l10n.backgrounds),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.backgroundSettings),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.image_outlined),
            title: Text(l10n.enableEmbeddedImages),
            subtitle: Text(l10n.enableEmbeddedImagesDescription),
            value: ref.watch(appSettingsProvider).enableEmbeddedImages,
            onChanged: (value) {
              ref
                  .read(appSettingsProvider.notifier)
                  .updateEnableEmbeddedImages(value);
            },
          ),
          ListTile(
            key: const Key('memory-inbox-settings-tile'),
            leading: const Icon(Icons.memory),
            title: Text(l10n.memoryInbox),
            subtitle: Text(l10n.memoryInboxSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.memoryInbox),
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, l10n.playHub),
          const _MomentsEnabledTile(),
          const _StoryEnabledTile(),
          if (kRpgProductUiEnabled)
            ListTile(
              key: const Key('rpg-scenario-editor-settings-tile'),
              leading: const Icon(Icons.casino_outlined),
              title: Text(l10n.rpgScenarioEditor),
              subtitle: Text(l10n.rpgScenarioEditorSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.rpgScenarioEditor),
            ),
          const Divider(height: 32),
          _buildSectionHeader(context, l10n.multimedia),
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: Text(l10n.tts),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.ttsSettings),
          ),
          ListTile(
            leading: const Icon(Icons.mic),
            title: Text(l10n.stt),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.sttSettings),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l10n.translation),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.translationSettings),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: Text(l10n.imageGeneration),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.imageGenSettings),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_emotions),
            title: Text(l10n.sprites),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.spriteSettings),
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, l10n.advanced),
          ListTile(
            key: const Key('capability-diagnostics-settings-tile'),
            leading: const Icon(Icons.health_and_safety_outlined),
            title: Text(l10n.capabilityCheck),
            subtitle: Text(l10n.capabilityCheckSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.capabilityDiagnostics),
          ),
          ListTile(
            key: const Key('mcp-settings-tile'),
            leading: const Icon(Icons.extension_outlined),
            title: Text(l10n.mcpServers),
            subtitle: Text(l10n.mcpServersSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.mcpSettings),
          ),
          ListTile(
            key: const Key('tool-calling-settings-tile'),
            leading: const Icon(Icons.build_outlined),
            title: Text(l10n.toolCalling),
            subtitle: Text(l10n.toolCallingSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.toolCallingSettings),
          ),
          ListTile(
            key: const Key('storage-management-settings-tile'),
            leading: const Icon(Icons.storage_outlined),
            title: Text(l10n.storageManagement),
            subtitle: Text(l10n.storageManagementSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.storageManagement),
          ),
          ListTile(
            leading: const Icon(Icons.find_replace),
            title: Text(l10n.regex),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.regexSettings),
          ),
          ListTile(
            leading: const Icon(Icons.data_object),
            title: Text(l10n.variables),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.variablesSettings),
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(l10n.logitBias),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.logitBiasSettings),
          ),
          ListTile(
            leading: const Icon(Icons.linear_scale),
            title: Text(l10n.cfgScale),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.cfgScaleSettings),
          ),
          ListTile(
            leading: const Icon(Icons.token),
            title: Text(l10n.tokenizer),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.tokenizerSettings),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: Text(l10n.vectorStorage),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.vectorStorageSettings),
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, l10n.settings),
          const _LanguageTile(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.themeSettings),
          ),
          const _ConfirmDeleteTile(),
          const _AutoSaveTile(),
          const AiDataSharingSettingsTile(),
          const _DebugLogTile(),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: Text(l10n.statistics),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.statistics),
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, l10n.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            subtitle: Text(
              packageInfo.when(
                data: (info) => '${info.version}+${info.buildNumber}',
                loading: () => l10n.loading,
                error: (_, __) => l10n.error,
              ),
            ),
            onLongPress: () {
              final info = packageInfo.valueOrNull;
              if (info == null) return;
              final version = '${info.version}+${info.buildNumber}';
              Clipboard.setData(ClipboardData(text: version));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.copiedToClipboard}: $version'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.licenses),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
          const PrivacyPolicyTile(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _PersonaTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activePersonaAsync = ref.watch(activePersonaProvider);

    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(l10n.personas),
      subtitle: activePersonaAsync.when(
        loading: () => Text(l10n.loading),
        error: (_, __) => Text(l10n.error),
        data: (persona) => Text(persona?.name ?? l10n.default_),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(AppRoutes.personas),
      onLongPress: () {
        final personaName =
            activePersonaAsync.valueOrNull?.name ?? l10n.default_;
        Clipboard.setData(ClipboardData(text: personaName));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.copiedToClipboard}: $personaName'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

class _ConfirmDeleteTile extends ConsumerWidget {
  const _ConfirmDeleteTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);

    return SwitchListTile(
      secondary: const Icon(Icons.delete_forever),
      title: Text(l10n.delete),
      value: settings.confirmBeforeDelete,
      onChanged: (value) {
        ref.read(appSettingsProvider.notifier).updateConfirmBeforeDelete(value);
      },
    );
  }
}

class _MomentsEnabledTile extends ConsumerWidget {
  const _MomentsEnabledTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    return SwitchListTile(
      key: const Key('moments-enabled-switch'),
      secondary: const Icon(Icons.dynamic_feed_outlined),
      title: Text(l10n.moments),
      subtitle: Text(l10n.momentsEnabledSubtitle),
      value: settings.momentsEnabled,
      onChanged: (value) {
        ref.read(appSettingsProvider.notifier).updateMomentsEnabled(value);
      },
    );
  }
}

class _StoryEnabledTile extends ConsumerWidget {
  const _StoryEnabledTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    return SwitchListTile(
      key: const Key('story-enabled-switch'),
      secondary: const Icon(Icons.menu_book_outlined),
      title: Text(l10n.story),
      subtitle: Text(l10n.storyEnabledSubtitle),
      value: settings.storyEnabled,
      onChanged: (value) {
        ref.read(appSettingsProvider.notifier).updateStoryEnabled(value);
      },
    );
  }
}

class _AutoSaveTile extends ConsumerWidget {
  const _AutoSaveTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);

    return SwitchListTile(
      secondary: const Icon(Icons.save),
      title: Text(l10n.save),
      value: settings.autoSaveChats,
      onChanged: (value) {
        ref.read(appSettingsProvider.notifier).updateAutoSaveChats(value);
      },
    );
  }
}

class _DebugLogTile extends ConsumerWidget {
  const _DebugLogTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);

    return SwitchListTile(
      secondary: const Icon(Icons.bug_report),
      title: Text(l10n.debugLog),
      subtitle: Text(l10n.debugLogDescription),
      value: settings.enableDebugLog,
      onChanged: (value) {
        ref.read(appSettingsProvider.notifier).updateDebugLog(value);
      },
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    // Find the current locale's display name
    String currentLanguage = l10n.systemLanguage;
    if (currentLocale != null) {
      final supportedLocale = supportedLocales.where((sl) {
        if (currentLocale.countryCode != null) {
          return sl.locale.languageCode == currentLocale.languageCode &&
              sl.locale.countryCode == currentLocale.countryCode;
        }
        return sl.locale.languageCode == currentLocale.languageCode &&
            sl.locale.countryCode == null;
      }).firstOrNull;
      if (supportedLocale != null) {
        currentLanguage =
            '${supportedLocale.nativeName} (${supportedLocale.displayName})';
      }
    }

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(currentLanguage),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageSelector(context, ref),
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: currentLanguage));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.copiedToClipboard}: $currentLanguage'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.read(localeProvider);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    l10n.selectLanguage,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  // System default option
                  ListTile(
                    leading: const Icon(Icons.phone_android),
                    title: Text(l10n.systemLanguage),
                    trailing: currentLocale == null
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      ref.read(localeProvider.notifier).resetToSystem();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.languageChanged),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // All supported locales
                  ...supportedLocales.map((sl) {
                    final isSelected = currentLocale != null &&
                        currentLocale.languageCode == sl.locale.languageCode &&
                        currentLocale.countryCode == sl.locale.countryCode;

                    return ListTile(
                      title: Text(sl.nativeName),
                      subtitle: Text(sl.displayName),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        ref.read(localeProvider.notifier).setLocale(sl.locale);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.languageChanged),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
