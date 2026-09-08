import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/domain/services/image_prompt_composer.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/image_gen_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Dialog for generating images from message content
class ImageGenerationDialog extends ConsumerStatefulWidget {
  /// The base prompt (usually from message content)
  final String basePrompt;

  /// Optional character name for context
  final String? characterName;

  /// Optional character tags for image prompt context
  final List<String> characterTags;

  /// Optional chat tags for image prompt context
  final List<String> chatTags;

  /// Optional lorebook tags for image prompt context
  final List<String> lorebookTags;

  /// The generation mode
  final ImageGenMode mode;

  /// When true, ask the chat model to fill the prompt after the dialog opens.
  final bool autoCompose;

  const ImageGenerationDialog({
    super.key,
    required this.basePrompt,
    this.characterName,
    this.characterTags = const [],
    this.chatTags = const [],
    this.lorebookTags = const [],
    this.mode = ImageGenMode.free,
    this.autoCompose = false,
  });

  @override
  ConsumerState<ImageGenerationDialog> createState() =>
      _ImageGenerationDialogState();

  /// Show the dialog and return the generated image (if any)
  static Future<ImageGenResult?> show(
    BuildContext context, {
    required String basePrompt,
    String? characterName,
    List<String> characterTags = const [],
    List<String> chatTags = const [],
    List<String> lorebookTags = const [],
    ImageGenMode mode = ImageGenMode.free,
    bool autoCompose = false,
  }) {
    return showDialog<ImageGenResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImageGenerationDialog(
        basePrompt: basePrompt,
        characterName: characterName,
        characterTags: characterTags,
        chatTags: chatTags,
        lorebookTags: lorebookTags,
        mode: mode,
        autoCompose: autoCompose,
      ),
    );
  }
}

class _ImageGenerationDialogState extends ConsumerState<ImageGenerationDialog> {
  late TextEditingController _promptController;
  late TextEditingController _negativePromptController;
  bool _isGenerating = false;
  bool _isComposingPrompt = false;
  double _progress = 0.0;
  String? _error;
  Uint8List? _generatedImage;
  final _composer = const ImagePromptComposer();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(imageGenSettingsProvider);
    _promptController =
        TextEditingController(text: _buildInitialPrompt(settings));

    var initialNeg = settings.defaultNegativePrompt ?? '';
    if (settings.negativePromptExtension != null &&
        settings.negativePromptExtension!.trim().isNotEmpty) {
      initialNeg = ImagePromptComposer.combinePrompt(
        initialNeg,
        settings.negativePromptExtension!,
      );
    }
    _negativePromptController = TextEditingController(text: initialNeg);

    if (widget.autoCompose) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fillPromptWithAi();
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _negativePromptController.dispose();
    super.dispose();
  }

  String _buildInitialPrompt(ImageGenSettings settings) {
    final basePrompt = widget.basePrompt.trim();

    String prompt;
    switch (widget.mode) {
      case ImageGenMode.character:
        prompt =
            'full body portrait, ${widget.characterName ?? "character"}, $basePrompt';
      case ImageGenMode.face:
        prompt =
            'close up portrait, ${widget.characterName ?? "character"}, $basePrompt';
      case ImageGenMode.background:
        prompt = 'background, scene, $basePrompt';
      case ImageGenMode.lastMessage:
      case ImageGenMode.scenario:
      case ImageGenMode.free:
        prompt = basePrompt;
    }

    if (settings.includeChatAndTagContext) {
      final allTags = <String>{
        ...widget.characterTags
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty),
        ...widget.chatTags.map((t) => t.trim()).where((t) => t.isNotEmpty),
        ...widget.lorebookTags
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty),
      };
      if (allTags.isNotEmpty && !prompt.contains(allTags.first)) {
        prompt =
            ImagePromptComposer.combinePrompt(prompt, allTags.join(', '));
      }
    }

    if (settings.positivePromptExtension != null &&
        settings.positivePromptExtension!.trim().isNotEmpty) {
      prompt = ImagePromptComposer.combinePrompt(
        prompt,
        settings.positivePromptExtension!,
      );
    }

    return prompt;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(imageGenSettingsProvider);

    return AlertDialog(
      backgroundColor: AppTheme.darkCard,
      title: Row(
        children: [
          const Icon(Icons.image, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.generateImagesUsingAi,
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
          ),
          if (!settings.enabled)
            Tooltip(
              message: l10n.notConfigured,
              child: const Icon(Icons.warning, color: Colors.orange, size: 20),
            ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider info
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cloud,
                        size: 16, color: AppTheme.textMuted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        settings.provider.displayName,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _isGenerating
                          ? null
                          : () => _showDimensionsDialog(context, settings),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${settings.defaultWidth}x${settings.defaultHeight}',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.tune,
                                size: 12, color: AppTheme.primaryColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (settings.includeChatAndTagContext &&
                  (widget.characterTags.isNotEmpty ||
                      widget.chatTags.isNotEmpty ||
                      widget.lorebookTags.isNotEmpty)) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    ...widget.characterTags.map((t) =>
                        _buildTagChip(t, Icons.person, Colors.lightBlueAccent)),
                    ...widget.chatTags.map((t) => _buildTagChip(
                        t, Icons.chat_bubble_outline, Colors.purpleAccent)),
                    ...widget.lorebookTags.map(
                        (t) => _buildTagChip(t, Icons.book, Colors.amberAccent)),
                  ],
                ),
              ],
              const SizedBox(height: 12),

              // Model selector
              _buildModelSelector(settings),
              const SizedBox(height: 16),

              // Prompt
              Row(
                children: [
                  Text(
                    l10n.prompt,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    key: const Key('image-gen-fill-prompt'),
                    onPressed: _isGenerating || _isComposingPrompt
                        ? null
                        : _fillPromptWithAi,
                    icon: _isComposingPrompt
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_fix_high, size: 16),
                    label: Text(l10n.fillImagePromptWithAi),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _promptController,
                maxLines: 4,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: l10n.enterPromptToGenerate,
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                enabled: !_isGenerating && !_isComposingPrompt,
              ),
              const SizedBox(height: 16),

              // Negative prompt (collapsible)
              ExpansionTile(
                title: Text(
                  l10n.negativePrompt,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                children: [
                  TextField(
                    controller: _negativePromptController,
                    maxLines: 2,
                    style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: l10n.enterTermsToAvoid,
                      hintStyle: const TextStyle(color: AppTheme.textMuted),
                      filled: true,
                      fillColor: AppTheme.darkBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    enabled: !_isGenerating,
                  ),
                ],
              ),

              // Progress indicator
              if (_isGenerating) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppTheme.darkBackground,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              // Error message
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Generated image preview
              if (_generatedImage != null) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    _generatedImage!,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isGenerating ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        if (_generatedImage != null)
          ElevatedButton.icon(
            onPressed: () {
              // Return the result with the generated image
              Navigator.of(context).pop(ImageGenResult(
                images: [_generatedImage!],
                prompt: _promptController.text,
                seed: DateTime.now().millisecondsSinceEpoch,
              ));
            },
            icon: const Icon(Icons.check),
            label: Text(l10n.save),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: _isGenerating || !settings.enabled ? null : _generate,
            icon: _isGenerating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(_isGenerating ? l10n.generating : l10n.generate),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildTagChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }

  void _showDimensionsDialog(BuildContext context, ImageGenSettings settings) {
    final widthController =
        TextEditingController(text: settings.defaultWidth.toString());
    final heightController =
        TextEditingController(text: settings.defaultHeight.toString());
    final l10n = AppLocalizations.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkCard,
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

  Future<void> _fillPromptWithAi() async {
    final l10n = AppLocalizations.of(context);
    final config = ref.read(llmConfigProvider);
    if (config.apiKey.isEmpty && config.apiUrl.isEmpty) {
      setState(() => _error = l10n.configureNow);
      return;
    }

    setState(() {
      _isComposingPrompt = true;
      _error = null;
    });

    try {
      final settings = ref.read(imageGenSettingsProvider);
      final sceneText = widget.basePrompt.trim().isEmpty
          ? _promptController.text
          : widget.basePrompt;
      final generated = await ref.read(llmServiceProvider).generate(
            _composer.composeMessages(
              sceneText: sceneText,
              characterName: widget.characterName,
              characterTags: settings.includeChatAndTagContext
                  ? widget.characterTags
                  : const [],
              chatTags: settings.includeChatAndTagContext
                  ? widget.chatTags
                  : const [],
              lorebookTags: settings.includeChatAndTagContext
                  ? widget.lorebookTags
                  : const [],
              positiveExtension: settings.positivePromptExtension,
            ),
            config,
          );
      final prompt = _composer.normalizeModelOutput(generated);
      if (!mounted) return;
      _promptController.text = prompt.isEmpty
          ? _composer.fallbackPrompt(
              sceneText: sceneText,
              characterName: widget.characterName,
              characterTags: settings.includeChatAndTagContext
                  ? widget.characterTags
                  : const [],
              chatTags: settings.includeChatAndTagContext
                  ? widget.chatTags
                  : const [],
              lorebookTags: settings.includeChatAndTagContext
                  ? widget.lorebookTags
                  : const [],
              positiveExtension: settings.positivePromptExtension,
            )
          : prompt;
    } catch (error) {
      if (!mounted) return;
      final settings = ref.read(imageGenSettingsProvider);
      _promptController.text = _composer.fallbackPrompt(
        sceneText: widget.basePrompt,
        characterName: widget.characterName,
        characterTags: settings.includeChatAndTagContext
            ? widget.characterTags
            : const [],
        chatTags:
            settings.includeChatAndTagContext ? widget.chatTags : const [],
        lorebookTags: settings.includeChatAndTagContext
            ? widget.lorebookTags
            : const [],
        positiveExtension: settings.positivePromptExtension,
      );
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _isComposingPrompt = false);
      }
    }
  }

  Future<void> _generate() async {
    final settings = ref.read(imageGenSettingsProvider);
    final service = ref.read(imageGenServiceProvider);

    setState(() {
      _isGenerating = true;
      _progress = 0.0;
      _error = null;
      _generatedImage = null;
    });

    // Set up progress callback
    service.onProgress = (progress) {
      if (mounted) {
        setState(() => _progress = progress);
      }
    };

    service.onError = (error) {
      if (mounted) {
        setState(() {
          _error = error;
          _isGenerating = false;
        });
      }
    };

    try {
      final result = await service.generate(ImageGenRequest(
        prompt: _promptController.text,
        negativePrompt: _negativePromptController.text.isNotEmpty
            ? _negativePromptController.text
            : null,
        width: settings.defaultWidth,
        height: settings.defaultHeight,
        steps: settings.defaultSteps,
        cfgScale: settings.defaultCfgScale,
        sampler: settings.defaultSampler,
        mode: widget.mode,
        model: settings.model, // Use currently selected model
      ));

      if (mounted) {
        if (result != null && result.images.isNotEmpty) {
          setState(() {
            _generatedImage = result.images.first;
            _isGenerating = false;
          });
        } else {
          setState(() {
            _error = 'No image generated';
            _isGenerating = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isGenerating = false;
        });
      }
    }
  }

  /// Build model selector dropdown
  Widget _buildModelSelector(ImageGenSettings settings) {
    final availableModels = ref.watch(availableModelsProvider);
    final currentModel = settings.model;

    return Row(
      children: [
        const Icon(Icons.memory, size: 16, color: AppTheme.textMuted),
        const SizedBox(width: 8),
        const Text(
          'Model:',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppTheme.darkBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: availableModels.contains(currentModel)
                    ? currentModel
                    : null,
                isExpanded: true,
                isDense: true,
                dropdownColor: AppTheme.darkCard,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 12,
                ),
                hint: Text(
                  currentModel,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                items: availableModels.map((model) {
                  return DropdownMenuItem<String>(
                    value: model,
                    child: Text(
                      model,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: _isGenerating
                    ? null
                    : (value) {
                        if (value != null) {
                          ref
                              .read(imageGenSettingsProvider.notifier)
                              .setModel(value);
                        }
                      },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
