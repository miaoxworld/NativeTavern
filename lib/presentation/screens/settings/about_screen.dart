import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/screens/settings/settings_screen.dart';
import 'package:native_tavern/presentation/widgets/privacy/ai_data_sharing_consent_gate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final packageInfo = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
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
                    icon: const FaIcon(FontAwesomeIcons.discord, size: 20),
                    label: const Text('Discord'),
                    onPressed: () => launchUrl(
                      Uri.parse('https://discord.gg/URQvW2FvZa'),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: OutlinedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.github, size: 20),
              label: const Text('GitHub'),
              onPressed: () => launchUrl(
                Uri.parse('https://github.com/miaoxworld/NativeTavern'),
                mode: LaunchMode.externalApplication,
              ),
            ),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(l10n.contributors),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/contributors'),
          ),
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
        ],
      ),
    );
  }
}
