import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/stt_service.dart';
import 'package:native_tavern/presentation/providers/stt_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for STT settings
class STTSettingsScreen extends ConsumerWidget {
  const STTSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(sttSettingsProvider);
    final isListening = ref.watch(sttListeningProvider);
    final availableAsync = ref.watch(sttAvailableProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.speechToText),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: AppLocalizations.of(context)!.resetToDefaults,
            onPressed: () {
              ref.read(sttSettingsProvider.notifier).reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.settingsResetToDefaults)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Availability status
          availableAsync.when(
            data: (available) => available
                ? const SizedBox.shrink()
                : Card(
                    color: Colors.orange.withValues(alpha: 0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.speechRecognitionNotAvailable,
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Enable/Disable toggle
          _buildSection(
            context,
            title: AppLocalizations.of(context)!.general,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.enableStt),
                subtitle: Text(AppLocalizations.of(context)!.useVoiceInputForMessages),
                value: settings.enabled,
                onChanged: (value) {
                  ref.read(sttSettingsProvider.notifier).setEnabled(value);
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.autoSendStt),
                subtitle: Text(AppLocalizations.of(context)!.automaticallySendAfterSpeaking),
                value: settings.autoSend,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(sttSettingsProvider.notifier).setAutoSend(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.continuousListening),
                subtitle: Text(AppLocalizations.of(context)!.keepListeningAfterPhrase),
                value: settings.continuousListening,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(sttSettingsProvider.notifier).setContinuousListening(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.showPartialResults),
                subtitle: Text(AppLocalizations.of(context)!.displayTextAsYouSpeak),
                value: settings.showPartialResults,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(sttSettingsProvider.notifier).setShowPartialResults(value);
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Provider selection
          _buildSection(
            context,
            title: AppLocalizations.of(context)!.provider,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.sttProvider),
                subtitle: Text(settings.provider.displayName),
                trailing: DropdownButton<STTProvider>(
                  value: settings.provider,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(sttSettingsProvider.notifier).setProvider(value);
                          }
                        }
                      : null,
                  items: STTProvider.values.map((provider) {
                    return DropdownMenuItem(
                      value: provider,
                      child: Text(provider.displayName),
                    );
                  }).toList(),
                ),
              ),
              if (settings.provider != STTProvider.system) ...[
                ListTile(
                  title: Text(AppLocalizations.of(context)!.apiKey),
                  subtitle: Text(
                    settings.apiKey?.isNotEmpty == true
                        ? '••••••••${settings.apiKey!.substring(settings.apiKey!.length - 4)}'
                        : AppLocalizations.of(context)!.notConfigured,
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

          // Language selection
          _buildSection(
            context,
            title: AppLocalizations.of(context)!.language,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.recognitionLanguage),
                subtitle: Text(
                  STTLanguage.fromCode(settings.language)?.name ?? settings.language,
                ),
                trailing: DropdownButton<String>(
                  value: settings.language,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(sttSettingsProvider.notifier).setLanguage(value);
                          }
                        }
                      : null,
                  items: STTLanguage.supportedLanguages.map((lang) {
                    return DropdownMenuItem(
                      value: lang.code,
                      child: Text(lang.name),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Test section
          _buildSection(
            context,
            title: AppLocalizations.of(context)!.test,
            children: [
              ListTile(
                leading: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  color: isListening ? Colors.red : AppTheme.accentColor,
                ),
                title: Text(isListening ? AppLocalizations.of(context)!.stopListening : AppLocalizations.of(context)!.testVoiceInput),
                subtitle: Text(
                  isListening
                      ? AppLocalizations.of(context)!.tapToStop
                      : AppLocalizations.of(context)!.tapToTestSpeechRecognition,
                ),
                onTap: settings.enabled
                    ? () async {
                        await ref.read(sttToggleListeningProvider)();
                      }
                    : null,
              ),
              // Show current result
              Consumer(
                builder: (context, ref, _) {
                  final result = ref.watch(sttResultProvider);
                  if (result == null) return const SizedBox.shrink();
                  
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: result.isFinal
                              ? AppTheme.accentColor
                              : AppTheme.textMuted,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                result.isFinal ? Icons.check : Icons.more_horiz,
                                size: 16,
                                color: result.isFinal
                                    ? AppTheme.accentColor
                                    : AppTheme.textMuted,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                result.isFinal ? AppLocalizations.of(context)!.final_ : AppLocalizations.of(context)!.listening,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: result.isFinal
                                      ? AppTheme.accentColor
                                      : AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.text.isEmpty ? '...' : result.text,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Info section
          _buildSection(
            context,
            title: AppLocalizations.of(context)!.information,
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text('About STT'),
                subtitle: Text(
                  'Speech-to-Text allows you to dictate messages using your voice. '
                  'Tap the microphone button in the chat input to start speaking.',
                ),
              ),
              if (settings.provider == STTProvider.system)
                const ListTile(
                  leading: Icon(Icons.phone_android, color: AppTheme.textMuted),
                  title: Text('System STT'),
                  subtitle: Text(
                    'Using your device\'s built-in speech recognition. '
                    'Accuracy depends on your system settings.',
                  ),
                ),
              if (settings.provider == STTProvider.whisper)
                const ListTile(
                  leading: Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: Text('Whisper'),
                  subtitle: Text(
                    'OpenAI\'s Whisper model for high-accuracy transcription. '
                    'Requires an API key.',
                  ),
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

  void _showApiKeyDialog(BuildContext context, WidgetRef ref, STTSettings settings) {
    final controller = TextEditingController(text: settings.apiKey);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${settings.provider.displayName} ${AppLocalizations.of(context)!.apiKey}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.apiKey,
            hintText: AppLocalizations.of(context)!.enterApiKey,
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(sttSettingsProvider.notifier).setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

/// Voice input button widget for chat input
class VoiceInputButton extends ConsumerWidget {
  final void Function(String text)? onResult;
  final double size;

  const VoiceInputButton({
    super.key,
    this.onResult,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(sttSettingsProvider);
    final isListening = ref.watch(sttListeningProvider);

    if (!settings.enabled) return const SizedBox.shrink();

    // Listen for final results
    ref.listen(sttResultProvider, (previous, next) {
      if (next != null && next.isFinal && onResult != null) {
        onResult!(next.text);
        ref.read(sttClearResultProvider)();
      }
    });

    return IconButton(
      icon: Icon(
        isListening ? Icons.mic : Icons.mic_none,
        size: size,
        color: isListening ? Colors.red : null,
      ),
      tooltip: isListening ? AppLocalizations.of(context)!.stopListening : AppLocalizations.of(context)!.voiceInput,
      onPressed: () async {
        await ref.read(sttToggleListeningProvider)();
      },
    );
  }
}

/// Animated voice input button with visual feedback
class AnimatedVoiceInputButton extends ConsumerStatefulWidget {
  final void Function(String text)? onResult;
  final double size;

  const AnimatedVoiceInputButton({
    super.key,
    this.onResult,
    this.size = 48,
  });

  @override
  ConsumerState<AnimatedVoiceInputButton> createState() => _AnimatedVoiceInputButtonState();
}

class _AnimatedVoiceInputButtonState extends ConsumerState<AnimatedVoiceInputButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(sttSettingsProvider);
    final isListening = ref.watch(sttListeningProvider);

    if (!settings.enabled) return const SizedBox.shrink();

    // Animate when listening
    if (isListening && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!isListening && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }

    // Listen for final results
    ref.listen(sttResultProvider, (previous, next) {
      if (next != null && next.isFinal && widget.onResult != null) {
        widget.onResult!(next.text);
        ref.read(sttClearResultProvider)();
      }
    });

    return GestureDetector(
      onTap: () async {
        await ref.read(sttToggleListeningProvider)();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: isListening ? _scaleAnimation.value : 1.0,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isListening
                    ? Colors.red.withValues(alpha: 0.2)
                    : AppTheme.accentColor.withValues(alpha: 0.2),
                border: Border.all(
                  color: isListening ? Colors.red : AppTheme.accentColor,
                  width: 2,
                ),
              ),
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: widget.size * 0.5,
                color: isListening ? Colors.red : AppTheme.accentColor,
              ),
            ),
          );
        },
      ),
    );
  }
}