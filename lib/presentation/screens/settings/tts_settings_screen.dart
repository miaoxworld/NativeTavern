import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/region_service.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/presentation/providers/tts_providers.dart';
import 'package:native_tavern/presentation/screens/ai_config/ai_config_screen.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for TTS settings
class TTSSettingsScreen extends ConsumerWidget {
  const TTSSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(ttsSettingsProvider);
    final isSpeaking = ref.watch(ttsSpeakingProvider);
    final voicesAsync = ref.watch(availableVoicesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).textToSpeech),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: AppLocalizations.of(context).resetToDefaults,
            onPressed: () {
              ref.read(ttsSettingsProvider.notifier).reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        AppLocalizations.of(context).settingsResetToDefaults)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable/Disable toggle
          _buildSection(
            context,
            title: AppLocalizations.of(context).general,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context).enableTts),
                subtitle:
                    Text(AppLocalizations.of(context).readAiResponsesAloud),
                value: settings.enabled,
                onChanged: (value) {
                  ref.read(ttsSettingsProvider.notifier).setEnabled(value);
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context).autoPlay),
                subtitle: Text(
                    AppLocalizations.of(context).automaticallyPlayResponses),
                value: settings.autoPlay,
                onChanged: settings.enabled
                    ? (value) {
                        ref
                            .read(ttsSettingsProvider.notifier)
                            .setAutoPlay(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: Text(l10n.queueMessages),
                subtitle: Text(l10n.queueMessagesDescription),
                value: settings.queueMessages,
                onChanged: settings.enabled
                    ? (value) {
                        ref
                            .read(ttsSettingsProvider.notifier)
                            .setQueueMessages(value);
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Provider selection
          _buildSection(
            context,
            title: AppLocalizations.of(context).provider,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context).ttsProvider),
                subtitle: Text(settings.provider.displayName),
                trailing: DropdownButton<TTSProvider>(
                  value: settings.provider,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref
                                .read(ttsSettingsProvider.notifier)
                                .setProvider(value);
                          }
                        }
                      : null,
                  items: TTSProvider.values.where((provider) {
                    final hide = RegionService.hidesRestrictedAiProviders(
                      isChinaRegion:
                          ref.watch(isChinaRegionProvider).valueOrNull ?? false,
                      languageCode:
                          Localizations.localeOf(context).languageCode,
                    );
                    if (!hide) return true;
                    if (provider == settings.provider) return true;
                    return !RegionService.isRestrictedTtsId(provider.id);
                  }).map((provider) {
                    return DropdownMenuItem(
                      value: provider,
                      child: Text(provider.displayName),
                    );
                  }).toList(),
                ),
              ),
              if (settings.provider != TTSProvider.system) ...[
                ListTile(
                  title: Text(AppLocalizations.of(context).apiKey),
                  subtitle: Text(
                    settings.apiKey?.isNotEmpty == true
                        ? '••••••••${settings.apiKey!.length > 4 ? settings.apiKey!.substring(settings.apiKey!.length - 4) : settings.apiKey}'
                        : AppLocalizations.of(context).notConfigured,
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: settings.enabled
                      ? () => _showApiKeyDialog(context, ref, settings)
                      : null,
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).apiEndpoint),
                  subtitle: Text(_remoteEndpointSummary(settings)),
                  trailing: const Icon(Icons.edit),
                  onTap: settings.enabled
                      ? () => _showApiEndpointDialog(context, ref, settings)
                      : null,
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Voice selection
          _buildSection(
            context,
            title: AppLocalizations.of(context).voice,
            children: [
              voicesAsync.when(
                data: (voices) => ListTile(
                  title: Text(AppLocalizations.of(context).voice),
                  subtitle: Text(
                    voices
                        .firstWhere(
                          (v) => v.id == settings.voiceId,
                          orElse: () => voices.first,
                        )
                        .name,
                  ),
                  trailing: DropdownButton<String>(
                    value: settings.voiceId ?? voices.first.id,
                    onChanged: settings.enabled
                        ? (value) {
                            ref
                                .read(ttsSettingsProvider.notifier)
                                .setVoiceId(value);
                          }
                        : null,
                    items: voices.map((voice) {
                      return DropdownMenuItem(
                        value: voice.id,
                        child: Text(voice.name),
                      );
                    }).toList(),
                  ),
                ),
                loading: () => ListTile(
                  title: Text(l10n.voice),
                  subtitle: Text(l10n.loadingVoices),
                  trailing: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, __) => ListTile(
                  title: Text(l10n.voice),
                  subtitle: Text(l10n.failedToLoadVoices),
                  trailing: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Voice parameters
          _buildSection(
            context,
            title: AppLocalizations.of(context).voiceSettings,
            children: [
              // Rate slider
              ListTile(
                title: Text(AppLocalizations.of(context).speed),
                subtitle: Slider(
                  value: settings.rate,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: '${settings.rate.toStringAsFixed(1)}x',
                  onChanged: settings.enabled
                      ? (value) {
                          ref.read(ttsSettingsProvider.notifier).setRate(value);
                        }
                      : null,
                ),
                trailing: Text(
                  '${settings.rate.toStringAsFixed(1)}x',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              // Pitch slider
              ListTile(
                title: Text(AppLocalizations.of(context).pitch),
                subtitle: Slider(
                  value: settings.pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: '${settings.pitch.toStringAsFixed(1)}x',
                  onChanged: settings.enabled
                      ? (value) {
                          ref
                              .read(ttsSettingsProvider.notifier)
                              .setPitch(value);
                        }
                      : null,
                ),
                trailing: Text(
                  '${settings.pitch.toStringAsFixed(1)}x',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              // Volume slider
              ListTile(
                title: Text(AppLocalizations.of(context).volume),
                subtitle: Slider(
                  value: settings.volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(settings.volume * 100).round()}%',
                  onChanged: settings.enabled
                      ? (value) {
                          ref
                              .read(ttsSettingsProvider.notifier)
                              .setVolume(value);
                        }
                      : null,
                ),
                trailing: Text(
                  '${(settings.volume * 100).round()}%',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Test section
          _buildSection(
            context,
            title: AppLocalizations.of(context).test,
            children: [
              ListTile(
                leading: Icon(
                  isSpeaking ? Icons.stop : Icons.play_arrow,
                  color: AppTheme.accentColor,
                ),
                title: Text(isSpeaking
                    ? AppLocalizations.of(context).stopListening
                    : AppLocalizations.of(context).testVoice),
                subtitle: Text(AppLocalizations.of(context).testVoice),
                onTap: settings.enabled
                    ? () async {
                        if (isSpeaking) {
                          await ref.read(ttsStopProvider)();
                        } else {
                          await ref.read(ttsSpeakProvider)(l10n.ttsTestPhrase);
                        }
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Info section
          _buildSection(
            context,
            title: AppLocalizations.of(context).information,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text(l10n.aboutTts),
                subtitle: Text(l10n.aboutTtsDescription),
              ),
              if (settings.provider == TTSProvider.system)
                ListTile(
                  leading: const Icon(Icons.phone_android,
                      color: AppTheme.textMuted),
                  title: Text(l10n.systemTts),
                  subtitle: Text(l10n.systemTtsDetails),
                ),
              if (settings.provider == TTSProvider.elevenlabs)
                ListTile(
                  leading: const Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: const Text('ElevenLabs'),
                  subtitle: Text(l10n.elevenLabsDescription),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
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

  Future<void> _showApiKeyDialog(
    BuildContext context,
    WidgetRef ref,
    TTSSettings settings,
  ) async {
    final controller = TextEditingController(text: settings.apiKey);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            '${settings.provider.displayName} ${AppLocalizations.of(context).apiKey}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).apiKey,
            hintText: AppLocalizations.of(context).enterApiKey,
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(ttsSettingsProvider.notifier).setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).save),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  String _remoteEndpointSummary(TTSSettings settings) {
    final configured = settings.apiEndpoint?.trim();
    if (configured?.isNotEmpty == true) return configured!;
    return switch (settings.provider) {
      TTSProvider.elevenlabs => 'https://api.elevenlabs.io',
      TTSProvider.azure =>
        'https://${settings.providerOptions['region'] ?? 'eastus'}.tts.speech.microsoft.com',
      TTSProvider.volcengine => 'https://openspeech.bytedance.com/api/v1/tts',
      TTSProvider.gptSovits => 'http://127.0.0.1:9880',
      TTSProvider.openaiCompatible => 'https://api.openai.com/v1',
      TTSProvider.system => '',
    };
  }

  Future<void> _showApiEndpointDialog(
    BuildContext context,
    WidgetRef ref,
    TTSSettings settings,
  ) async {
    final controller = TextEditingController(text: settings.apiEndpoint);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          '${settings.provider.displayName} ${AppLocalizations.of(context).apiEndpoint}',
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).apiEndpoint,
            hintText: _remoteEndpointSummary(settings),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(ttsSettingsProvider.notifier)
                  .setApiEndpoint(controller.text.trim());
              Navigator.pop(dialogContext);
            },
            child: Text(AppLocalizations.of(context).save),
          ),
        ],
      ),
    );
    controller.dispose();
  }
}

/// Widget for TTS button in chat messages
class TTSMessageButton extends ConsumerWidget {
  final String text;
  final String? characterId;
  final double size;

  const TTSMessageButton({
    super.key,
    required this.text,
    this.characterId,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(ttsSettingsProvider);
    final isSpeaking = ref.watch(ttsSpeakingProvider);

    if (!settings.enabled) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(
        isSpeaking ? Icons.stop : Icons.volume_up,
        size: size,
      ),
      tooltip: isSpeaking
          ? AppLocalizations.of(context).stopSpeaking
          : AppLocalizations.of(context).readAloud,
      onPressed: () async {
        if (isSpeaking) {
          await ref.read(ttsStopProvider)();
        } else {
          await ref.read(ttsSpeakProvider)(text, characterId: characterId);
        }
      },
    );
  }
}

/// Compact TTS controls for chat
class TTSControls extends ConsumerWidget {
  const TTSControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(ttsSettingsProvider);
    final isSpeaking = ref.watch(ttsSpeakingProvider);

    if (!settings.enabled) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isSpeaking)
          IconButton(
            icon: const Icon(Icons.stop, size: 20),
            tooltip: AppLocalizations.of(context).stopSpeaking,
            onPressed: () => ref.read(ttsStopProvider)(),
          ),
        Icon(
          Icons.volume_up,
          size: 16,
          color: settings.enabled ? AppTheme.accentColor : AppTheme.textMuted,
        ),
      ],
    );
  }
}
