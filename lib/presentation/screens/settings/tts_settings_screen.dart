import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/presentation/providers/tts_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Screen for TTS settings
class TTSSettingsScreen extends ConsumerWidget {
  const TTSSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(ttsSettingsProvider);
    final isSpeaking = ref.watch(ttsSpeakingProvider);
    final voicesAsync = ref.watch(availableVoicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text-to-Speech'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: () {
              ref.read(ttsSettingsProvider.notifier).reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
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
            title: 'General',
            children: [
              SwitchListTile(
                title: const Text('Enable TTS'),
                subtitle: const Text('Read messages aloud'),
                value: settings.enabled,
                onChanged: (value) {
                  ref.read(ttsSettingsProvider.notifier).setEnabled(value);
                },
              ),
              SwitchListTile(
                title: const Text('Auto-play'),
                subtitle: const Text('Automatically read new messages'),
                value: settings.autoPlay,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(ttsSettingsProvider.notifier).setAutoPlay(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Queue Messages'),
                subtitle: const Text('Queue multiple messages instead of interrupting'),
                value: settings.queueMessages,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(ttsSettingsProvider.notifier).setQueueMessages(value);
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Provider selection
          _buildSection(
            title: 'Provider',
            children: [
              ListTile(
                title: const Text('TTS Provider'),
                subtitle: Text(settings.provider.displayName),
                trailing: DropdownButton<TTSProvider>(
                  value: settings.provider,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(ttsSettingsProvider.notifier).setProvider(value);
                          }
                        }
                      : null,
                  items: TTSProvider.values.map((provider) {
                    return DropdownMenuItem(
                      value: provider,
                      child: Text(provider.displayName),
                    );
                  }).toList(),
                ),
              ),
              if (settings.provider != TTSProvider.system) ...[
                ListTile(
                  title: const Text('API Key'),
                  subtitle: Text(
                    settings.apiKey?.isNotEmpty == true
                        ? '••••••••${settings.apiKey!.substring(settings.apiKey!.length - 4)}'
                        : 'Not configured',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: settings.enabled
                      ? () => _showApiKeyDialog(context, ref, settings)
                      : null,
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Voice selection
          _buildSection(
            title: 'Voice',
            children: [
              voicesAsync.when(
                data: (voices) => ListTile(
                  title: const Text('Voice'),
                  subtitle: Text(
                    voices.firstWhere(
                      (v) => v.id == settings.voiceId,
                      orElse: () => voices.first,
                    ).name,
                  ),
                  trailing: DropdownButton<String>(
                    value: settings.voiceId ?? voices.first.id,
                    onChanged: settings.enabled
                        ? (value) {
                            ref.read(ttsSettingsProvider.notifier).setVoiceId(value);
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
                loading: () => const ListTile(
                  title: Text('Voice'),
                  subtitle: Text('Loading voices...'),
                  trailing: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, __) => const ListTile(
                  title: Text('Voice'),
                  subtitle: Text('Failed to load voices'),
                  trailing: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Voice parameters
          _buildSection(
            title: 'Voice Settings',
            children: [
              // Rate slider
              ListTile(
                title: const Text('Speed'),
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
                title: const Text('Pitch'),
                subtitle: Slider(
                  value: settings.pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: '${settings.pitch.toStringAsFixed(1)}x',
                  onChanged: settings.enabled
                      ? (value) {
                          ref.read(ttsSettingsProvider.notifier).setPitch(value);
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
                title: const Text('Volume'),
                subtitle: Slider(
                  value: settings.volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(settings.volume * 100).round()}%',
                  onChanged: settings.enabled
                      ? (value) {
                          ref.read(ttsSettingsProvider.notifier).setVolume(value);
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
            title: 'Test',
            children: [
              ListTile(
                leading: Icon(
                  isSpeaking ? Icons.stop : Icons.play_arrow,
                  color: AppTheme.accentColor,
                ),
                title: Text(isSpeaking ? 'Stop' : 'Test Voice'),
                subtitle: const Text('Preview the current voice settings'),
                onTap: settings.enabled
                    ? () async {
                        if (isSpeaking) {
                          await ref.read(ttsStopProvider)();
                        } else {
                          await ref.read(ttsSpeakProvider)(
                            'Hello! This is a test of the text-to-speech system. '
                            'The quick brown fox jumps over the lazy dog.',
                          );
                        }
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Info section
          _buildSection(
            title: 'Information',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text('About TTS'),
                subtitle: Text(
                  'Text-to-Speech allows you to hear messages read aloud. '
                  'You can configure different voices for different characters '
                  'in the character settings.',
                ),
              ),
              if (settings.provider == TTSProvider.system)
                const ListTile(
                  leading: Icon(Icons.phone_android, color: AppTheme.textMuted),
                  title: Text('System TTS'),
                  subtitle: Text(
                    'Using your device\'s built-in text-to-speech engine. '
                    'Available voices depend on your system settings.',
                  ),
                ),
              if (settings.provider == TTSProvider.elevenlabs)
                const ListTile(
                  leading: Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: Text('ElevenLabs'),
                  subtitle: Text(
                    'High-quality AI voices. Requires an API key from elevenlabs.io',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
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

  void _showApiKeyDialog(BuildContext context, WidgetRef ref, TTSSettings settings) {
    final controller = TextEditingController(text: settings.apiKey);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${settings.provider.displayName} API Key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'API Key',
            hintText: 'Enter your API key',
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(ttsSettingsProvider.notifier).setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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
      tooltip: isSpeaking ? 'Stop' : 'Read aloud',
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
            tooltip: 'Stop speaking',
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