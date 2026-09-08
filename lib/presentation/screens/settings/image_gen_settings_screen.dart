import 'dart:typed_data';
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.imageGeneration),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: l10n.resetToDefaults,
            onPressed: () {
              ref.read(imageGenSettingsProvider.notifier).reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        l10n.settingsResetToDefaults)),
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
            title: l10n.general,
            children: [
              SwitchListTile(
                title:
                    Text(l10n.enableImageGeneration),
                subtitle:
                    Text(l10n.generateImagesUsingAi),
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
            title: l10n.provider,
            children: [
              ListTile(
                title:
                    Text(l10n.imageGenerationProvider),
                subtitle: Text(settings.provider.displayName),
                trailing: DropdownButton<ImageGenProvider>(
                  value: settings.provider,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref
                                .read(imageGenSettingsProvider.notifier)
                                .setProvider(value);
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
                title: Text(l10n.apiEndpoint),
                subtitle: Text(
                  settings.apiEndpoint?.isNotEmpty == true
                      ? settings.apiEndpoint!
                      : l10n.notConfigured,
                ),
                trailing: const Icon(Icons.edit),
                onTap: settings.enabled
                    ? () => _showEndpointDialog(context, ref, settings)
                    : null,
              ),
              if (settings.provider.requiresApiKey)
                ListTile(
                  title: Text(l10n.apiKey),
                  subtitle: Text(
                    settings.apiKey?.isNotEmpty == true
                        ? '••••••••${settings.apiKey!.substring(settings.apiKey!.length - 4)}'
                        : l10n.notConfigured,
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: settings.enabled
                      ? () => _showApiKeyDialog(context, ref, settings)
                      : null,
                ),
              if (settings.provider == ImageGenProvider.automatic1111 ||
                  settings.provider == ImageGenProvider.comfyui)
                ListTile(
                  title: Text(l10n.authHeader),
                  subtitle: Text(
                    settings.authHeaderValue?.isNotEmpty == true
                        ? '${settings.authHeaderName?.isNotEmpty == true ? settings.authHeaderName! : "Authorization"}: ••••••••'
                        : l10n.notConfigured,
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: settings.enabled
                      ? () => _showAuthHeaderDialog(context, ref, settings)
                      : null,
                ),
              // Model selection
              _buildModelSelector(context, ref, settings),
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
                subtitle: Text(
                    '${settings.defaultWidth} × ${settings.defaultHeight}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<ImageAspectRatio>(
                      value: ImageAspectRatio.presets.firstWhere(
                        (p) =>
                            p.width == settings.defaultWidth &&
                            p.height == settings.defaultHeight,
                        orElse: () => ImageAspectRatio.custom(
                          settings.defaultWidth,
                          settings.defaultHeight,
                        ),
                      ),
                      onChanged: settings.enabled
                          ? (value) {
                              if (value != null) {
                                ref
                                    .read(imageGenSettingsProvider.notifier)
                                    .setCustomDimensions(
                                      value.width,
                                      value.height,
                                    );
                              }
                            }
                          : null,
                      items: [
                        ...ImageAspectRatio.presets.map((preset) {
                          return DropdownMenuItem(
                            value: preset,
                            child: Text(preset.name),
                          );
                        }),
                        if (!ImageAspectRatio.presets.any((p) =>
                            p.width == settings.defaultWidth &&
                            p.height == settings.defaultHeight))
                          DropdownMenuItem(
                            value: ImageAspectRatio.custom(
                              settings.defaultWidth,
                              settings.defaultHeight,
                            ),
                            child: Text(
                              '${AppLocalizations.of(context)!.customDimensions} (${settings.defaultWidth}×${settings.defaultHeight})',
                            ),
                          ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, size: 20),
                      tooltip: AppLocalizations.of(context)!.customDimensions,
                      onPressed: settings.enabled
                          ? () => _showCustomDimensionsDialog(
                              context, ref, settings)
                          : null,
                    ),
                  ],
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
                          ref
                              .read(imageGenSettingsProvider.notifier)
                              .setDefaultSteps(value.round());
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
                          ref
                              .read(imageGenSettingsProvider.notifier)
                              .setDefaultCfgScale(value);
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
                            ref
                                .read(imageGenSettingsProvider.notifier)
                                .setDefaultSampler(value);
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
                  controller: TextEditingController(
                      text: settings.defaultNegativePrompt),
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.defaultNegativePrompt,
                    hintText: AppLocalizations.of(context)!.enterTermsToAvoid,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  enabled: settings.enabled,
                  onChanged: (value) {
                    ref
                        .read(imageGenSettingsProvider.notifier)
                        .setDefaultNegativePrompt(value);
                  },
                ),
              ),
            ],
          ),

          // NovelAI specific settings
          if (settings.provider == ImageGenProvider.novelai) ...[
            const SizedBox(height: 16),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context).novelAiSettings,
              children: [
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).anlasGuard),
                  subtitle: Text(
                    AppLocalizations.of(context).anlasGuardDescription,
                  ),
                  value: settings.novelaiAnlasGuard,
                  onChanged: settings.enabled
                      ? (value) {
                          ref
                              .read(imageGenSettingsProvider.notifier)
                              .setNovelaiAnlasGuard(value);
                        }
                      : null,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).smea),
                  subtitle: Text(AppLocalizations.of(context).smeaDescription),
                  value: settings.novelaiSm,
                  onChanged: settings.enabled
                      ? (value) {
                          ref
                              .read(imageGenSettingsProvider.notifier)
                              .setNovelaiSm(value);
                        }
                      : null,
                ),
                if (settings.novelaiSm)
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context).smeaDynamic),
                    subtitle: Text(
                      AppLocalizations.of(context).smeaDynamicDescription,
                    ),
                    value: settings.novelaiSmDyn,
                    onChanged: settings.enabled
                        ? (value) {
                            ref
                                .read(imageGenSettingsProvider.notifier)
                                .setNovelaiSmDyn(value);
                          }
                        : null,
                  ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).decrisper),
                  subtitle: Text(
                    AppLocalizations.of(context).decrisperDescription,
                  ),
                  value: settings.novelaiDecrisper,
                  onChanged: settings.enabled
                      ? (value) {
                          ref
                              .read(imageGenSettingsProvider.notifier)
                              .setNovelaiDecrisper(value);
                        }
                      : null,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).varietyPlus),
                  subtitle: Text(
                    AppLocalizations.of(context).varietyPlusDescription,
                  ),
                  value: settings.novelaiVarietyBoost,
                  onChanged: settings.enabled
                      ? (value) {
                          ref
                              .read(imageGenSettingsProvider.notifier)
                              .setNovelaiVarietyBoost(value);
                        }
                      : null,
                ),
              ],
            ),
          ],

          // OpenAI (gpt-image) specific settings
          if (settings.provider == ImageGenProvider.openai) ...[
            const SizedBox(height: 16),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.gptImageSettings,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.qualityLabel),
                  subtitle: Text(settings.openaiQuality == 'hd'
                      ? AppLocalizations.of(context)!.qualityHighDescription
                      : AppLocalizations.of(context)!.qualityAutoDescription),
                  trailing: DropdownButton<String>(
                    value: settings.openaiQuality,
                    onChanged: settings.enabled
                        ? (value) {
                            if (value != null) {
                              ref
                                  .read(imageGenSettingsProvider.notifier)
                                  .setOpenaiQuality(value);
                            }
                          }
                        : null,
                    items: [
                      DropdownMenuItem(
                          value: 'standard',
                          child:
                              Text(AppLocalizations.of(context)!.effortAuto)),
                      DropdownMenuItem(
                          value: 'hd',
                          child:
                              Text(AppLocalizations.of(context)!.effortHigh)),
                    ],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Prompt extensions
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.positivePromptExtension,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: TextEditingController(
                      text: settings.positivePromptExtension ?? ''),
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.positivePromptExtension,
                    hintText: AppLocalizations.of(context)!
                        .positivePromptExtensionHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  enabled: settings.enabled,
                  onChanged: (value) {
                    ref
                        .read(imageGenSettingsProvider.notifier)
                        .setPositivePromptExtension(
                            value.trim().isEmpty ? null : value.trim());
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: TextEditingController(
                      text: settings.negativePromptExtension ?? ''),
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.negativePromptExtension,
                    hintText: AppLocalizations.of(context)!
                        .negativePromptExtensionHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  enabled: settings.enabled,
                  onChanged: (value) {
                    ref
                        .read(imageGenSettingsProvider.notifier)
                        .setNegativePromptExtension(
                            value.trim().isEmpty ? null : value.trim());
                  },
                ),
              ),
              SwitchListTile(
                title:
                    Text(AppLocalizations.of(context)!.includeChatAndTagContext),
                subtitle: Text(
                  AppLocalizations.of(context)!
                      .includeChatAndTagContextDescription,
                ),
                value: settings.includeChatAndTagContext,
                onChanged: settings.enabled
                    ? (value) {
                        ref
                            .read(imageGenSettingsProvider.notifier)
                            .setIncludeChatAndTagContext(value);
                      }
                    : null,
              ),
            ],
          ),

          // Test section
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.testGeneration,
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
                leading:
                    const Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text(AppLocalizations.of(context)!.aboutImageGeneration),
                subtitle: Text(AppLocalizations.of(context)!
                    .aboutImageGenerationDescription),
              ),
              ListTile(
                leading: const Icon(Icons.terminal, color: AppTheme.textMuted),
                title: Text(AppLocalizations.of(context)!.imagineCommand),
                subtitle:
                    Text(AppLocalizations.of(context)!.imagineCommandUsage),
              ),
              if (settings.provider == ImageGenProvider.automatic1111)
                ListTile(
                  leading:
                      const Icon(Icons.computer, color: AppTheme.textMuted),
                  title: Text(AppLocalizations.of(context)!.stableDiffusion),
                  subtitle: Text(
                      AppLocalizations.of(context)!.stableDiffusionDescription),
                ),
              if (settings.provider == ImageGenProvider.openai)
                ListTile(
                  leading: const Icon(Icons.cloud, color: AppTheme.textMuted),
                  title: const Text('GPT-Image'),
                  subtitle: Text(
                    AppLocalizations.of(context).gptImageApiDescription,
                  ),
                ),
              if (settings.provider == ImageGenProvider.openaiChat)
                ListTile(
                  leading: const Icon(Icons.chat, color: AppTheme.textMuted),
                  title: Text(AppLocalizations.of(context).oaiCompatibleChat),
                  subtitle: Text(
                    AppLocalizations.of(context).oaiCompatibleChatDescription,
                  ),
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

  Widget _buildModelSelector(
      BuildContext context, WidgetRef ref, ImageGenSettings settings) {
    final availableModels = ref.watch(availableModelsProvider);
    final fetchedState = ref.watch(fetchedModelsProvider);
    final supportsFetching = settings.provider.supportsFetchingModels;

    // Determine the current model value
    final currentModel = availableModels.contains(settings.model)
        ? settings.model
        : (availableModels.isNotEmpty
            ? availableModels.first
            : settings.provider.defaultModel);

    return ListTile(
      title: Text(AppLocalizations.of(context)!.model),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ImageGenProvider.getModelDisplayName(currentModel)),
          if (fetchedState.error != null)
            Text(
              AppLocalizations.of(context).errorFetchingModels,
              style: const TextStyle(color: Colors.orange, fontSize: 12),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (supportsFetching)
            IconButton(
              icon: fetchedState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh, size: 20),
              tooltip: AppLocalizations.of(context).refreshModels,
              onPressed: settings.enabled && !fetchedState.isLoading
                  ? () => ref.read(fetchedModelsProvider.notifier).fetchModels()
                  : null,
            ),
          DropdownButton<String>(
            value: availableModels.contains(currentModel) ? currentModel : null,
            hint: Text(currentModel),
            onChanged: settings.enabled
                ? (value) {
                    if (value != null) {
                      ref
                          .read(imageGenSettingsProvider.notifier)
                          .setModel(value);
                    }
                  }
                : null,
            items: availableModels.map((model) {
              return DropdownMenuItem(
                value: model,
                child: Text(
                  ImageGenProvider.getModelDisplayName(model),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showApiKeyDialog(
      BuildContext context, WidgetRef ref, ImageGenSettings settings) {
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
              ref
                  .read(imageGenSettingsProvider.notifier)
                  .setApiKey(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showEndpointDialog(
      BuildContext context, WidgetRef ref, ImageGenSettings settings) {
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
              ref
                  .read(imageGenSettingsProvider.notifier)
                  .setApiEndpoint(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showAuthHeaderDialog(
      BuildContext context, WidgetRef ref, ImageGenSettings settings) {
    final nameController =
        TextEditingController(text: settings.authHeaderName);
    final valueController =
        TextEditingController(text: settings.authHeaderValue);
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.authHeader),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.authHeaderSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.authHeaderName,
                hintText: l10n.authHeaderNameHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: valueController,
              decoration: InputDecoration(
                labelText: l10n.authHeaderValue,
                hintText: l10n.authHeaderValueHint,
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(imageGenSettingsProvider.notifier).setAuthHeader(
                    name: nameController.text.trim().isEmpty
                        ? null
                        : nameController.text.trim(),
                    value: valueController.text.trim().isEmpty
                        ? null
                        : valueController.text.trim(),
                  );
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showCustomDimensionsDialog(
      BuildContext context, WidgetRef ref, ImageGenSettings settings) {
    final widthController =
        TextEditingController(text: settings.defaultWidth.toString());
    final heightController =
        TextEditingController(text: settings.defaultHeight.toString());
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customDimensions),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widthController,
              decoration: InputDecoration(
                labelText: l10n.customWidth,
                helperText: '64 - 4096 (e.g. 512, 768, 1024)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: heightController,
              decoration: InputDecoration(
                labelText: l10n.customHeight,
                helperText: '64 - 4096 (e.g. 512, 768, 1024)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final w =
                  int.tryParse(widthController.text) ?? settings.defaultWidth;
              final h =
                  int.tryParse(heightController.text) ?? settings.defaultHeight;
              ref
                  .read(imageGenSettingsProvider.notifier)
                  .setCustomDimensions(w, h);
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  String _getEndpointHint(ImageGenProvider provider) {
    // Just return the provider's default endpoint
    return provider.defaultEndpoint;
  }
}

/// Widget for testing image generation
class _ImageGenTestWidget extends ConsumerStatefulWidget {
  final bool enabled;

  const _ImageGenTestWidget({required this.enabled});

  @override
  ConsumerState<_ImageGenTestWidget> createState() =>
      _ImageGenTestWidgetState();
}

class _ImageGenTestWidgetState extends ConsumerState<_ImageGenTestWidget> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
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
              labelText: AppLocalizations.of(context)!.positivePrompt,
              hintText: AppLocalizations.of(context)!.enterPromptToGenerate,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
            enabled: widget.enabled && !genState.isGenerating,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.enabled &&
                    _controller.text.isNotEmpty &&
                    !genState.isGenerating
                ? () {
                    final settings = ref.read(imageGenSettingsProvider);
                    var prompt = _controller.text;
                    if (settings.positivePromptExtension != null &&
                        settings.positivePromptExtension!.trim().isNotEmpty) {
                      prompt =
                          '$prompt, ${settings.positivePromptExtension!.trim()}';
                    }
                    var negative = settings.defaultNegativePrompt;
                    if (settings.negativePromptExtension != null &&
                        settings.negativePromptExtension!.trim().isNotEmpty) {
                      negative = negative != null && negative.trim().isNotEmpty
                          ? '$negative, ${settings.negativePromptExtension!.trim()}'
                          : settings.negativePromptExtension!.trim();
                    }
                    ref.read(imageGenStateProvider.notifier).generate(
                          ImageGenRequest(
                            prompt: prompt,
                            negativePrompt: negative,
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
            label: Text(genState.isGenerating
                ? AppLocalizations.of(context)!.generating
                : AppLocalizations.of(context)!.generate),
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
                      const Icon(Icons.check,
                          size: 16, color: AppTheme.accentColor),
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
                  Text(AppLocalizations.of(context)
                      .generatedPrompt(genState.result!.prompt)),
                  Text(
                    AppLocalizations.of(context)
                        .generatedSeed(genState.result!.seed.toString()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  if (genState.result!.images.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)
                          .imagesGenerated(genState.result!.images.length),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Display generated images
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: genState.result!.images.length,
                        itemBuilder: (context, index) {
                          final imageData = genState.result!.images[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () =>
                                  _showFullScreenImage(context, imageData),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  imageData,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 200,
                                      height: 200,
                                      color: AppTheme.darkCard,
                                      child: const Center(
                                        child: Icon(Icons.broken_image,
                                            color: AppTheme.textMuted),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
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

  void _showFullScreenImage(BuildContext context, Uint8List imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Dismiss on tap background
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(color: Colors.black87),
            ),
            // Image with zoom
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.memory(
                  imageData,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
