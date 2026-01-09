import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
          _buildSectionHeader(context, 'App Settings'),
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
            onTap: () {
              // Open backup screen
            },
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