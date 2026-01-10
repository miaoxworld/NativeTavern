import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/locale_provider.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Settings screen - App settings only (AI config is in separate tab)
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, l10n.user),
          _PersonaTile(),
          
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
          
          const Divider(height: 32),
          _buildSectionHeader(context, 'Multimedia'),
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
          
          const Divider(height: 32),
          _buildSectionHeader(context, l10n.backup),
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(l10n.backup),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.backupSettings),
          ),
          
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
            subtitle: const Text('1.0.0 (Build 1)'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.licenses),
            onTap: () {
              showLicensePage(context: context);
            },
          ),
          
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

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    
    // Find the current locale's display name
    String currentLanguage = l10n.systemTheme;
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
        currentLanguage = '${supportedLocale.nativeName} (${supportedLocale.displayName})';
      }
    }

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(currentLanguage),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageSelector(context, ref),
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
                    title: Text(l10n.systemTheme),
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