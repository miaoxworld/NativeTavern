import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/presentation/providers/image_gen_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Screen for image generation settings
class ImageGenSettingsScreen extends ConsumerWidget {
  const ImageGenSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(imageGenSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Generation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: () {
              ref.read(imageGenSettingsProvider.notifier).reset();
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
                title: const Text('Enable Image Generation'),
                subtitle: const Text('Generate images using AI'),
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
            title: 'Provider',
            children: [
              ListTile(
                title: const Text('Image Generation Provider'),
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
                title: const Text('API Endpoint'),
                subtitle: Text(
                  settings.apiEndpoint?.isNotEmpty == true
                      ? settings.apiEndpoint!
                      : 'Not configured',
                ),
                trailing: const Icon(Icons.edit),
                onTap: settings.enabled
                    ? () => _showEndpointDialog(context, ref, settings)
                    : null,
              ),
              if (settings.provider == ImageGenProvider.dalle)
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
          ),

          const SizedBox(height: 16),

          // Default parameters
          _buildSection(
            title: 'Default Parameters',
            children: [
              // Size presets
              ListTile(
                title: const Text('Image Size'),
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
                title: const Text('Steps'),
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
                title: const Text('CFG Scale'),
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
                title: const Text('Sampler'),
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
            title: 'Negative Prompt',
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: TextEditingController(text: settings.defaultNegativePrompt),
                  decoration: const InputDecoration(
                    labelText: 'Default Negative Prompt',
                    hintText: 'Enter terms to avoid in generated images',
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
            title: 'Test',
            children: [
              _ImageGenTestWidget(enabled: settings.enabled),
            ],
          ),

          const SizedBox(height: 16),

          // Info section
          _buildSection(
            title: 'Information',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text('About Image Generation'),
                subtitle: Text(
                  'Generate images using AI models. Use the /imagine command in chat '
                  'or generate character portraits from the character editor.',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.terminal, color: AppTheme.textMuted),
                title: Text('/imagine Command'),
                subtitle: Text(
                  'Usage: /imagine <prompt> [--width N] [--height N] [--steps N] [--cfg N] [--seed N]',
                ),
              ),
              if (settings.provider == ImageGenProvider.stableDiffusion)
                const ListTile(
                  leading: Icon(Icons.computer, color: AppTheme.textMuted),
                  title: Text('Stable Diffusion'),
                  subtitle: Text(
                    'Connect to a local or remote Stable Diffusion WebUI instance. '
                    'Requires the API to be enabled.',
                  ),
                ),
              if (settings.provider == ImageGenProvider.dalle)
                const ListTile(
                  leading: Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: Text('DALL-E'),
                  subtitle: Text(
                    'OpenAI\'s DALL-E image generation. '
                    'Requires an API key from OpenAI.',
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

  void _showApiKeyDialog(BuildContext context, WidgetRef ref, ImageGenSettings settings) {
    final controller = TextEditingController(text: settings.apiKey);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Key'),
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
              ref.read(imageGenSettingsProvider.notifier).setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
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
        title: const Text('API Endpoint'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Endpoint URL',
            hintText: _getEndpointHint(settings.provider),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(imageGenSettingsProvider.notifier).setApiEndpoint(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
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
            decoration: const InputDecoration(
              labelText: 'Prompt',
              hintText: 'Enter a prompt to generate an image',
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
            label: Text(genState.isGenerating ? 'Generating...' : 'Generate'),
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
                  const Row(
                    children: [
                      Icon(Icons.check, size: 16, color: AppTheme.accentColor),
                      SizedBox(width: 8),
                      Text(
                        'Generation Complete',
                        style: TextStyle(
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
                      child: const Center(
                        child: Text(
                          'Image would be displayed here',
                          style: TextStyle(color: AppTheme.textMuted),
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