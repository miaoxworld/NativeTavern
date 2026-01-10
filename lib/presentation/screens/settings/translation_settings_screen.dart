import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/translation_service.dart';
import 'package:native_tavern/presentation/providers/translation_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for translation settings
class TranslationSettingsScreen extends ConsumerWidget {
  const TranslationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(translationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translationSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: AppLocalizations.of(context)!.resetToDefaults,
            onPressed: () {
              ref.read(translationSettingsProvider.notifier).reset();
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
          // Enable/Disable toggle
          _buildSection(
            context,
            title: AppLocalizations.of(context)!.general,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.enableTranslation),
                subtitle: Text(AppLocalizations.of(context)!.translateMessagesAutomatically),
                value: settings.enabled,
                onChanged: (value) {
                  ref.read(translationSettingsProvider.notifier).setEnabled(value);
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.translateAiResponses),
                subtitle: Text(AppLocalizations.of(context)!.translateAiResponses),
                value: settings.autoTranslateIncoming,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(translationSettingsProvider.notifier).setAutoTranslateIncoming(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.translateUserMessages),
                subtitle: Text(AppLocalizations.of(context)!.translateUserMessages),
                value: settings.autoTranslateOutgoing,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(translationSettingsProvider.notifier).setAutoTranslateOutgoing(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: const Text('Show Original'),
                subtitle: const Text('Display original text alongside translation'),
                value: settings.showOriginal,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(translationSettingsProvider.notifier).setShowOriginal(value);
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
                title: Text(AppLocalizations.of(context)!.translationProvider),
                subtitle: Text(settings.provider.displayName),
                trailing: DropdownButton<TranslationProvider>(
                  value: settings.provider,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(translationSettingsProvider.notifier).setProvider(value);
                          }
                        }
                      : null,
                  items: TranslationProvider.values.map((provider) {
                    return DropdownMenuItem(
                      value: provider,
                      child: Text(provider.displayName),
                    );
                  }).toList(),
                ),
              ),
              if (settings.provider != TranslationProvider.libre) ...[
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
              // Source language
              ListTile(
                title: Text(AppLocalizations.of(context)!.sourceLanguage),
                subtitle: Text(
                  TranslationLanguage.fromCode(settings.sourceLanguage)?.name ?? 
                  settings.sourceLanguage,
                ),
                trailing: DropdownButton<String>(
                  value: settings.sourceLanguage,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(translationSettingsProvider.notifier).setSourceLanguage(value);
                          }
                        }
                      : null,
                  items: TranslationLanguage.supportedLanguages.map((lang) {
                    return DropdownMenuItem(
                      value: lang.code,
                      child: Text(lang.name),
                    );
                  }).toList(),
                ),
              ),

              // Swap button
              Center(
                child: IconButton(
                  icon: const Icon(Icons.swap_vert),
                  tooltip: 'Swap languages',
                  onPressed: settings.enabled && settings.sourceLanguage != 'auto'
                      ? () {
                          ref.read(translationSettingsProvider.notifier).swapLanguages();
                        }
                      : null,
                ),
              ),

              // Target language
              ListTile(
                title: Text(AppLocalizations.of(context)!.targetLanguage),
                subtitle: Text(
                  TranslationLanguage.fromCode(settings.targetLanguage)?.name ?? 
                  settings.targetLanguage,
                ),
                trailing: DropdownButton<String>(
                  value: settings.targetLanguage,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(translationSettingsProvider.notifier).setTargetLanguage(value);
                          }
                        }
                      : null,
                  items: TranslationLanguage.targetLanguages.map((lang) {
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
              _TranslationTestWidget(enabled: settings.enabled),
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
                title: Text('About Translation'),
                subtitle: Text(
                  'Translation allows you to communicate in different languages. '
                  'Messages can be automatically translated or translated on demand.',
                ),
              ),
              if (settings.provider == TranslationProvider.google)
                const ListTile(
                  leading: Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: Text('Google Translate'),
                  subtitle: Text(
                    'Uses Google Cloud Translation API. '
                    'Requires an API key from Google Cloud Console.',
                  ),
                ),
              if (settings.provider == TranslationProvider.deepl)
                const ListTile(
                  leading: Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: Text('DeepL'),
                  subtitle: Text(
                    'High-quality neural machine translation. '
                    'Requires an API key from deepl.com',
                  ),
                ),
              if (settings.provider == TranslationProvider.libre)
                const ListTile(
                  leading: Icon(Icons.public, color: AppTheme.textMuted),
                  title: Text('LibreTranslate'),
                  subtitle: Text(
                    'Free and open-source translation. '
                    'Can be self-hosted or use public instances.',
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

  void _showApiKeyDialog(BuildContext context, WidgetRef ref, TranslationSettings settings) {
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
              ref.read(translationSettingsProvider.notifier).setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

/// Widget for testing translation
class _TranslationTestWidget extends ConsumerStatefulWidget {
  final bool enabled;

  const _TranslationTestWidget({required this.enabled});

  @override
  ConsumerState<_TranslationTestWidget> createState() => _TranslationTestWidgetState();
}

class _TranslationTestWidgetState extends ConsumerState<_TranslationTestWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationState = ref.watch(translationStateProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.enterTextToTokenize,
              hintText: AppLocalizations.of(context)!.enterTextToTokenize,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
            enabled: widget.enabled,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.enabled && _controller.text.isNotEmpty
                ? () {
                    ref.read(translationStateProvider.notifier).translate(_controller.text);
                  }
                : null,
            icon: translationState.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.translate),
            label: Text(AppLocalizations.of(context)!.translation),
          ),
          if (translationState.result != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: AppTheme.accentColor),
                      const SizedBox(width: 8),
                      Text(
                        '${translationState.result!.sourceLanguage} → ${translationState.result!.targetLanguage}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translationState.result!.translatedText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
          if (translationState.error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      translationState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Translate button widget for messages
class TranslateButton extends ConsumerWidget {
  final String text;
  final void Function(TranslationResult)? onTranslated;
  final double size;

  const TranslateButton({
    super.key,
    required this.text,
    this.onTranslated,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(translationSettingsProvider);

    if (!settings.enabled) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(Icons.translate, size: size),
      tooltip: 'Translate',
      onPressed: () async {
        final result = await ref.read(translateProvider)(text);
        if (result != null && onTranslated != null) {
          onTranslated!(result);
        }
      },
    );
  }
}

/// Inline translation display widget
class TranslationDisplay extends StatelessWidget {
  final TranslationResult result;
  final bool showOriginal;

  const TranslationDisplay({
    super.key,
    required this.result,
    this.showOriginal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.translate, size: 14, color: AppTheme.accentColor),
              const SizedBox(width: 4),
              Text(
                'Translated from ${_getLanguageName(result.sourceLanguage)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(result.translatedText),
          if (showOriginal) ...[
            const SizedBox(height: 8),
            Text(
              'Original: ${result.originalText}',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    return TranslationLanguage.fromCode(code)?.name ?? code;
  }
}