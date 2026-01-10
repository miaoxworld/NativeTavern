import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/presentation/providers/image_gen_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for image generation settings
class ImageGenSettingsScreen extends ConsumerWidget {
  const ImageGenSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(imageGenSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.imageGeneration),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: AppLocalizations.of(context)!.resetToDefaults,
            onPressed: () {
              ref.read(imageGenSettingsProvider.notifier).reset();
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
            context: context,
            title: AppLocalizations.of(context)!.general,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.enableImageGeneration),
                subtitle: Text(AppLocalizations.of(context)!.generateImagesUsingAi),
                value: settings.enabled,
                onChanged: (value) {
                  ref.read(imageGenSettingsProvider.notifier).setEnabled(value);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Provider selection
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.provider,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.imageGenerationProvider),
                subtitle: Text(settings.provider.displayName),
                trailing: DropdownButton<ImageGenProvider>(
                  value: settings.provider,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(imageGenSettingsProvider.notifier).setProvider(value);
                          }
                        }
                      : null,
                  items: ImageGenProvider.values.map((provider) {
                    return DropdownMenuItem(
                      value: provider,
                      child: Text(provider.displayName),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.apiEndpoint),
                subtitle: Text(
                  settings.apiEndpoint?.isNotEmpty == true
                      ? settings.apiEndpoint!
                      : AppLocalizations.of(context)!.notConfigured,
                ),
                trailing: const Icon(Icons.edit),
                onTap: settings.enabled
                    ? () => _showEndpointDialog(context, ref, settings)
                    : null,
              ),
              if (settings.provider == ImageGenProvider.dalle)
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
          ),

          const SizedBox(height: 16),

          // Default parameters
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.defaultParameters,
            children: [
              // Size presets
              ListTile(
                title: Text(AppLocalizations.of(context)!.imageSize),
                subtitle: Text('${settings.defaultWidth} × ${settings.defaultHeight}'),
                trailing: DropdownButton<ImageAspectRatio>(
                  value: ImageAspectRatio.presets.firstWhere(
                    (p) => p.width == settings.defaultWidth && p.height == settings.defaultHeight,
                    orElse: () => ImageAspectRatio.presets.first,
                  ),
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(imageGenSettingsProvider.notifier).setDefaultWidth(value.width);
                            ref.read(imageGenSettingsProvider.notifier).setDefaultHeight(value.height);
                          }
                        }
                      : null,
                  items: ImageAspectRatio.presets.map((preset) {
                    return DropdownMenuItem(
                      value: preset,
                      child: Text(preset.name),
                    );
                  }).toList(),
                ),
              ),

              // Steps slider
              ListTile(
                title: Text(AppLocalizations.of(context)!.steps),
                subtitle: Slider(
                  value: settings.defaultSteps.toDouble(),
                  min: 1,
                  max: 150,
                  divisions: 149,
                  label: '${settings.defaultSteps}',
                  onChanged: settings.enabled
                      ? (value) {
                          ref.read(imageGenSettingsProvider.notifier).setDefaultSteps(value.round());
                        }
                      : null,
                ),
                trailing: Text(
                  '${settings.defaultSteps}',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              // CFG Scale slider
              ListTile(
                title: Text(AppLocalizations.of(context)!.cfgScale),
                subtitle: Slider(
                  value: settings.defaultCfgScale,
                  min: 1.0,
                  max: 30.0,
                  divisions: 58,
                  label: settings.defaultCfgScale.toStringAsFixed(1),
                  onChanged: settings.enabled
                      ? (value) {
                          ref.read(imageGenSettingsProvider.notifier).setDefaultCfgScale(value);
                        }
                      : null,
                ),
                trailing: Text(
                  settings.defaultCfgScale.toStringAsFixed(1),
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              // Sampler dropdown
              ListTile(
                title: Text(AppLocalizations.of(context)!.sampler),
                subtitle: Text(
                  ImageGenSampler.samplers
                      .firstWhere(
                        (s) => s.id == settings.defaultSampler,
                        orElse: () => ImageGenSampler.samplers.first,
                      )
                      .name,
                ),
                trailing: DropdownButton<String>(
                  value: settings.defaultSampler,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(imageGenSettingsProvider.notifier).setDefaultSampler(value);
                          }
                        }
                      : null,
                  items: ImageGenSampler.samplers.map((sampler) {
                    return DropdownMenuItem(
                      value: sampler.id,
                      child: Text(sampler.name),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Negative prompt
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.negativePrompt,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: TextEditingController(text: settings.defaultNegativePrompt),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.defaultNegativePrompt,
                    hintText: AppLocalizations.of(context)!.enterTermsToAvoid,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  enabled: settings.enabled,
                  onChanged: (value) {
                    ref.read(imageGenSettingsProvider.notifier).setDefaultNegativePrompt(value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Test section
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.test,
            children: [
              _ImageGenTestWidget(enabled: settings.enabled),
            ],
          ),

          const SizedBox(height: 16),

          // Info section
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.information,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text(AppLocalizations.of(context)!.aboutImageGeneration),
                subtitle: Text(AppLocalizations.of(context)!.aboutImageGenerationDescription),
              ),
              ListTile(
                leading: const Icon(Icons.terminal, color: AppTheme.textMuted),
                title: Text(AppLocalizations.of(context)!.imagineCommand),
                subtitle: Text(AppLocalizations.of(context)!.imagineCommandUsage),
              ),
              if (settings.provider == ImageGenProvider.stableDiffusion)
                ListTile(
                  leading: const Icon(Icons.computer, color: AppTheme.textMuted),
                  title: Text(AppLocalizations.of(context)!.stableDiffusion),
                  subtitle: Text(AppLocalizations.of(context)!.stableDiffusionDescription),
                ),
              if (settings.provider == ImageGenProvider.dalle)
                ListTile(
                  leading: const Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: Text(AppLocalizations.of(context)!.dalle),
                  subtitle: Text(AppLocalizations.of(context)!.dalleDescription),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
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

  void _showApiKeyDialog(BuildContext context, WidgetRef ref, ImageGenSettings settings) {
    final controller = TextEditingController(text: settings.apiKey);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.apiKey),
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
              ref.read(imageGenSettingsProvider.notifier).setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showEndpointDialog(BuildContext context, WidgetRef ref, ImageGenSettings settings) {
    final controller = TextEditingController(text: settings.apiEndpoint);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.apiEndpoint),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.apiEndpointUrl,
            hintText: _getEndpointHint(settings.provider),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(imageGenSettingsProvider.notifier).setApiEndpoint(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  String _getEndpointHint(ImageGenProvider provider) {
    switch (provider) {
      case ImageGenProvider.stableDiffusion:
      case ImageGenProvider.automatic1111:
        return 'http://localhost:7860';
      case ImageGenProvider.comfyui:
        return 'http://localhost:8188';
      case ImageGenProvider.dalle:
        return 'https://api.openai.com/v1';
    }
  }
}

/// Widget for testing image generation
class _ImageGenTestWidget extends ConsumerStatefulWidget {
  final bool enabled;

  const _ImageGenTestWidget({required this.enabled});

  @override
  ConsumerState<_ImageGenTestWidget> createState() => _ImageGenTestWidgetState();
}

class _ImageGenTestWidgetState extends ConsumerState<_ImageGenTestWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genState = ref.watch(imageGenStateProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.prompt,
              hintText: AppLocalizations.of(context)!.enterPromptToGenerate,
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            enabled: widget.enabled && !genState.isGenerating,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.enabled && _controller.text.isNotEmpty && !genState.isGenerating
                ? () {
                    final settings = ref.read(imageGenSettingsProvider);
                    ref.read(imageGenStateProvider.notifier).generate(
                      ImageGenRequest(
                        prompt: _controller.text,
                        negativePrompt: settings.defaultNegativePrompt,
                        width: settings.defaultWidth,
                        height: settings.defaultHeight,
                        steps: settings.defaultSteps,
                        cfgScale: settings.defaultCfgScale,
                        sampler: settings.defaultSampler,
                      ),
                    );
                  }
                : null,
            icon: genState.isGenerating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.image),
            label: Text(genState.isGenerating ? AppLocalizations.of(context)!.generating : AppLocalizations.of(context)!.generate),
          ),
          
          // Progress bar
          if (genState.isGenerating) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: genState.progress),
            const SizedBox(height: 8),
            Text(
              '${(genState.progress * 100).round()}%',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ],

          // Result
          if (genState.result != null) ...[
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
                        AppLocalizations.of(context)!.generationComplete,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Prompt: ${genState.result!.prompt}'),
                  Text(
                    'Seed: ${genState.result!.seed}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  if (genState.result!.images.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    // Would display the generated image here
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.imageWouldBeDisplayed,
                          style: const TextStyle(color: AppTheme.textMuted),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Error
          if (genState.error != null) ...[
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
                      genState.error!,
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