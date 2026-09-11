import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/domain/services/stt_service.dart';
import 'package:native_tavern/presentation/screens/ai_config/ai_config_screen.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/stt_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

class STTSettingsScreen extends ConsumerWidget {
  const STTSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(sttSettingsProvider);
    final session = ref.watch(sttSessionProvider);
    final available = ref.watch(sttAvailableProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.speechToText),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: l10n.resetToDefaults,
            onPressed: () {
              ref.read(sttSettingsProvider.notifier).reset();
              ref.read(sttSessionProvider.notifier).clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsResetToDefaults)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (session.message != null && _isFailure(session.phase))
            _StatusPanel(
              message: session.message!,
              actionLabel:
                  session.phase == STTSessionPhase.permissionPermanentlyDenied
                      ? l10n.openSystemSettings
                      : null,
              onAction:
                  session.phase == STTSessionPhase.permissionPermanentlyDenied
                      ? () => unawaited(
                            ref
                                .read(sttSessionProvider.notifier)
                                .openPermissionSettings(),
                          )
                      : null,
            ),
          if (settings.provider.isRemote && !settings.isConfigured)
            _StatusPanel(message: l10n.sttConfigurationRequired),
          if (settings.provider == STTProvider.system)
            available.when(
              data: (value) => value
                  ? const SizedBox.shrink()
                  : _StatusPanel(message: l10n.speechRecognitionNotAvailable),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          _Section(
            title: l10n.general,
            children: [
              SwitchListTile(
                title: Text(l10n.enableStt),
                subtitle: Text(l10n.useVoiceInputForMessages),
                value: settings.enabled,
                onChanged: ref.read(sttSettingsProvider.notifier).setEnabled,
              ),
              SwitchListTile(
                title: Text(l10n.autoSendStt),
                subtitle: Text(l10n.automaticallySendAfterSpeaking),
                value: settings.autoSend,
                onChanged: settings.enabled
                    ? ref.read(sttSettingsProvider.notifier).setAutoSend
                    : null,
              ),
              SwitchListTile(
                title: Text(l10n.continuousListening),
                subtitle: Text(l10n.keepListeningAfterPhrase),
                value: settings.continuousListening,
                onChanged:
                    settings.enabled && settings.provider == STTProvider.system
                        ? ref
                            .read(sttSettingsProvider.notifier)
                            .setContinuousListening
                        : null,
              ),
              SwitchListTile(
                title: Text(l10n.showPartialResults),
                subtitle: Text(l10n.displayTextAsYouSpeak),
                value: settings.showPartialResults,
                onChanged:
                    settings.enabled && settings.provider == STTProvider.system
                        ? ref
                            .read(sttSettingsProvider.notifier)
                            .setShowPartialResults
                        : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: l10n.provider,
            children: [
              ListTile(
                title: Text(l10n.sttProvider),
                subtitle: Text(settings.provider.displayName),
                trailing: DropdownButton<STTProvider>(
                  value: settings.provider,
                  onChanged: settings.enabled
                      ? (provider) {
                          if (provider != null) {
                            ref
                                .read(sttSettingsProvider.notifier)
                                .setProvider(provider);
                          }
                        }
                      : null,
                  items: [
                    for (final provider in STTProvider.values.where((provider) {
                      final hide = RegionService.hidesRestrictedAiProviders(
                        isChinaRegion:
                            ref.watch(isChinaRegionProvider).valueOrNull ??
                                false,
                        languageCode:
                            Localizations.localeOf(context).languageCode,
                      );
                      if (!hide) return true;
                      if (provider == settings.provider) return true;
                      return !RegionService.isRestrictedSttId(provider.id);
                    }))
                      DropdownMenuItem(
                        value: provider,
                        child: Text(provider.displayName),
                      ),
                  ],
                ),
              ),
              if (settings.provider.isRemote)
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: Text(l10n.apiEndpoint),
                  subtitle: Text(_providerSummary(settings, l10n)),
                  trailing: const Icon(Icons.edit),
                  enabled: settings.enabled,
                  onTap: settings.enabled
                      ? () => _showProviderConfiguration(
                            context,
                            ref,
                            settings,
                          )
                      : null,
                ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: l10n.language,
            children: [
              ListTile(
                title: Text(l10n.recognitionLanguage),
                subtitle: Text(
                  STTLanguage.fromCode(settings.language)?.name ??
                      settings.language,
                ),
                trailing: DropdownButton<String>(
                  value: settings.language,
                  onChanged: settings.enabled
                      ? (language) {
                          if (language != null) {
                            ref
                                .read(sttSettingsProvider.notifier)
                                .setLanguage(language);
                          }
                        }
                      : null,
                  items: [
                    for (final language in STTLanguage.supportedLanguages)
                      DropdownMenuItem(
                        value: language.code,
                        child: Text(language.name),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: l10n.test,
            children: [
              ListTile(
                leading: Icon(
                  session.isActive ? Icons.stop_circle : Icons.mic_none,
                  color: session.isActive ? Colors.red : AppTheme.accentColor,
                ),
                title: Text(
                  session.isActive ? l10n.stopListening : l10n.testVoiceInput,
                ),
                subtitle: Text(_sessionSubtitle(session, l10n)),
                enabled: settings.enabled &&
                    (!settings.provider.isRemote || settings.isConfigured),
                onTap: settings.enabled &&
                        (!settings.provider.isRemote || settings.isConfigured)
                    ? ref.read(sttSessionProvider.notifier).toggle
                    : null,
              ),
              if (session.result != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.darkDivider),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(session.result!.text),
                    ),
                  ),
                ),
              if (session.isActive)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: ref.read(sttSessionProvider.notifier).cancel,
                    icon: const Icon(Icons.close),
                    label: Text(l10n.cancelVoiceInput),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: l10n.information,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: AppTheme.accentColor,
                ),
                title: Text(l10n.aboutStt),
                subtitle: Text(l10n.aboutSttDescription),
              ),
              if (settings.provider == STTProvider.system)
                ListTile(
                  leading: const Icon(
                    Icons.offline_bolt_outlined,
                    color: AppTheme.textMuted,
                  ),
                  title: Text(l10n.systemStt),
                  subtitle: Text(
                    '${l10n.systemSttDescription}\n${l10n.systemSttOfflineNote}',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isFailure(STTSessionPhase phase) =>
      phase == STTSessionPhase.failed ||
      phase == STTSessionPhase.unavailable ||
      phase == STTSessionPhase.permissionDenied ||
      phase == STTSessionPhase.permissionPermanentlyDenied;

  String _providerSummary(STTSettings settings, AppLocalizations l10n) {
    final endpoint = settings.apiEndpoint?.trim();
    final key = settings.apiKey?.trim() ?? '';
    final keySuffix = key.isEmpty
        ? l10n.notConfigured
        : '...${key.substring(key.length > 4 ? key.length - 4 : 0)}';
    if (settings.provider == STTProvider.selfHosted) {
      return endpoint?.isNotEmpty == true ? endpoint! : l10n.notConfigured;
    }
    return '${endpoint?.isNotEmpty == true ? endpoint : settings.effectiveEndpoint} · $keySuffix';
  }

  String _sessionSubtitle(
    STTSessionState session,
    AppLocalizations l10n,
  ) {
    return switch (session.phase) {
      STTSessionPhase.requestingPermission => l10n.processing,
      STTSessionPhase.listening => l10n.listening,
      STTSessionPhase.processing => l10n.processing,
      _ => l10n.tapToTestSpeechRecognition,
    };
  }

  Future<void> _showProviderConfiguration(
    BuildContext context,
    WidgetRef ref,
    STTSettings settings,
  ) async {
    final endpointController = TextEditingController(
      text: settings.apiEndpoint,
    );
    final keyController = TextEditingController(text: settings.apiKey);
    final modelController = TextEditingController(text: settings.model);
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(settings.provider.displayName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: endpointController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: l10n.apiEndpoint,
                  hintText: settings.effectiveEndpoint,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: keyController,
                obscureText: true,
                decoration: InputDecoration(labelText: l10n.apiKey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: modelController,
                decoration: InputDecoration(labelText: l10n.model),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final notifier = ref.read(sttSettingsProvider.notifier);
              notifier.setApiEndpoint(endpointController.text);
              notifier.setApiKey(keyController.text);
              notifier.setModel(modelController.text);
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    endpointController.dispose();
    keyController.dispose();
    modelController.dispose();
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.darkCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({this.message = '', this.actionLabel, this.onAction});

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.orange.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
              if (onAction != null)
                TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ),
        ),
      ),
    );
  }
}
