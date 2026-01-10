import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'User'),
          _PersonaTile(),
          
          const Divider(height: 32),
          _buildSectionHeader(context, 'Chat Settings'),
          ListTile(
            leading: const Icon(Icons.quickreply),
            title: const Text('Quick Replies'),
            subtitle: const Text('Customizable reply buttons'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.quickReplies),
          ),
          ListTile(
            leading: const Icon(Icons.wallpaper),
            title: const Text('Chat Background'),
            subtitle: const Text('Customize chat appearance'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.backgroundSettings),
          ),
          
          const Divider(height: 32),
          _buildSectionHeader(context, 'Multimedia'),
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Text-to-Speech'),
            subtitle: const Text('Voice synthesis settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.ttsSettings),
          ),
          ListTile(
            leading: const Icon(Icons.mic),
            title: const Text('Speech-to-Text'),
            subtitle: const Text('Voice input settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.sttSettings),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text('Translation'),
            subtitle: const Text('Message translation settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.translationSettings),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Image Generation'),
            subtitle: const Text('AI image generation settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.imageGenSettings),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_emotions),
            title: const Text('Expression Sprites'),
            subtitle: const Text('Character emotion sprites'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.spriteSettings),
          ),
          
          const Divider(height: 32),
          _buildSectionHeader(context, 'Advanced'),
          ListTile(
            leading: const Icon(Icons.find_replace),
            title: const Text('Regex Scripts'),
            subtitle: const Text('Find/replace patterns in messages'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.regexSettings),
          ),
          ListTile(
            leading: const Icon(Icons.data_object),
            title: const Text('Variables'),
            subtitle: const Text('Global and local variable storage'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.variablesSettings),
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('Logit Bias'),
            subtitle: const Text('Adjust token probabilities'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.logitBiasSettings),
          ),
          ListTile(
            leading: const Icon(Icons.linear_scale),
            title: const Text('CFG Scale'),
            subtitle: const Text('Classifier-Free Guidance settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.cfgScaleSettings),
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Token Probabilities'),
            subtitle: const Text('View logprobs for AI responses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.logprobsSettings),
          ),
          ListTile(
            leading: const Icon(Icons.token),
            title: const Text('Tokenizer'),
            subtitle: const Text('Token visualization and counting'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.tokenizerSettings),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Vector Storage / RAG'),
            subtitle: const Text('Knowledge base and retrieval'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.vectorStorageSettings),
          ),
          
          const Divider(height: 32),
          _buildSectionHeader(context, 'App Settings'),
          const _LanguageTile(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Themes'),
            subtitle: const Text('Customize app colors'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.themeSettings),
          ),
          const _ConfirmDeleteTile(),
          const _AutoSaveTile(),
          
          const Divider(height: 32),
          _buildSectionHeader(context, 'Data'),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('Data Directory'),
            subtitle: const Text('View and manage app data'),
            onTap: () {
              // Open data directory
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Restore'),
            subtitle: const Text('Export or import all data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.backupSettings),
          ),
          
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Statistics'),
            subtitle: const Text('View usage statistics'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.statistics),
          ),
          
          const Divider(height: 32),
          _buildSectionHeader(context, 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0 (Build 1)'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('GitHub'),
            subtitle: const Text('View source code'),
            onTap: () {
              // Open GitHub
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Licenses'),
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
    final activePersonaAsync = ref.watch(activePersonaProvider);

    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text('Active Persona'),
      subtitle: activePersonaAsync.when(
        loading: () => const Text('Loading...'),
        error: (_, __) => const Text('Error loading persona'),
        data: (persona) => Text(persona?.name ?? 'Default'),
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
    final settings = ref.watch(appSettingsProvider);

    return SwitchListTile(
      secondary: const Icon(Icons.delete_forever),
      title: const Text('Confirm Before Delete'),
      subtitle: const Text('Show confirmation dialog'),
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
    final settings = ref.watch(appSettingsProvider);

    return SwitchListTile(
      secondary: const Icon(Icons.save),
      title: const Text('Auto-Save Chats'),
      subtitle: const Text('Automatically save messages'),
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
    final currentLocale = ref.watch(localeProvider);
    
    // Find the current locale's display name
    String currentLanguage = 'System Default';
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
      title: const Text('Language'),
      subtitle: Text(currentLanguage),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageSelector(context, ref),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref) {
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
                  const Text(
                    'Select Language',
                    style: TextStyle(
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
                    title: const Text('System Default'),
                    trailing: currentLocale == null
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      ref.read(localeProvider.notifier).resetToSystem();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Language set to system default'),
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
                            content: Text('Language changed to ${sl.displayName}'),
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