
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/instruct_template.dart';
import '../../../domain/services/llm_service.dart';
import '../../providers/ai_preset_providers.dart';
import '../../providers/instruct_providers.dart';
import '../../providers/settings_providers.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// AI Configuration screen - top-level entry for all AI-related settings
class AIConfigScreen extends ConsumerWidget {
  const AIConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePreset = ref.watch(activeAIPresetProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aiConfiguration),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: AppLocalizations.of(context)!.importPreset,
            onPressed: () => context.push(AppRoutes.aiPresets),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Active Preset Banner
          if (activePreset != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.2),
                    AppTheme.accentColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.activePreset,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        Text(
                          activePreset.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.aiPresets),
                    child: Text(AppLocalizations.of(context)!.change),
                  ),
                ],
              ),
            ),

          _buildSectionHeader(context, AppLocalizations.of(context)!.presetsAndTemplates),
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: Text(AppLocalizations.of(context)!.aiPresets),
            subtitle: Text(activePreset?.name ?? AppLocalizations.of(context)!.noPresetSelected),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.aiPresets),
          ),
          const _InstructTemplateTile(),
          ListTile(
            leading: const Icon(Icons.reorder),
            title: Text(AppLocalizations.of(context)!.promptManager),
            subtitle: Text(AppLocalizations.of(context)!.orderAndTogglePromptSections),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.promptManager),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, AppLocalizations.of(context)!.llmConnection),
          const _LLMProviderTile(),
          const _ApiKeyTile(),
          const _ApiUrlTile(),
          const _ModelTile(),
          const _ConnectionTestTile(),

          const Divider(height: 32),
          _buildSectionHeader(context, AppLocalizations.of(context)!.generationSettings),
          const _MaxTokensTile(),
          const _TemperatureTile(),
          const _TopPTile(),
          const _StreamingTile(),
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(AppLocalizations.of(context)!.advancedSamplerSettings),
            subtitle: Text(AppLocalizations.of(context)!.fullControlOverSampling),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.advancedSettings),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _InstructTemplateTile extends ConsumerWidget {
  const _InstructTemplateTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTemplate = ref.watch(activeInstructTemplateProvider);
    final allTemplates = ref.watch(allInstructTemplatesProvider);

    return ListTile(
      leading: const Icon(Icons.code),
      title: Text(AppLocalizations.of(context)!.instructTemplate),
      subtitle: Text(activeTemplate.name),
      onTap: () => _showTemplatePicker(context, ref, activeTemplate, allTemplates),
    );
  }

  void _showTemplatePicker(
    BuildContext context,
    WidgetRef ref,
    InstructTemplate activeTemplate,
    List<InstructTemplate> allTemplates,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)!.selectInstructTemplate,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocalizations.of(context)!.instructTemplateDescription,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: allTemplates.length,
                  itemBuilder: (context, index) {
                    final template = allTemplates[index];
                    final isSelected = template.id == activeTemplate.id;

                    return ListTile(
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
                      ),
                      title: Text(
                        template.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        template.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        ref.read(activeInstructTemplateIdProvider.notifier).state =
                            template.id;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LLMProviderTile extends ConsumerWidget {
  const _LLMProviderTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(llmConfigProvider);

    return ListTile(
      leading: const Icon(Icons.cloud),
      title: Text(AppLocalizations.of(context)!.provider),
      subtitle: Text(_providerName(config.provider)),
      onTap: () => _showProviderPicker(context, ref, config),
    );
  }

  String _providerName(LLMProvider provider) {
    switch (provider) {
      case LLMProvider.openai:
        return 'OpenAI';
      case LLMProvider.claude:
        return 'Claude (Anthropic)';
      case LLMProvider.openRouter:
        return 'OpenRouter';
      case LLMProvider.gemini:
        return 'Gemini (Google)';
      case LLMProvider.ollama:
        return 'Ollama (Local)';
      case LLMProvider.koboldCpp:
        return 'KoboldCpp (Local)';
    }
  }

  void _showProviderPicker(BuildContext context, WidgetRef ref, LLMConfig config) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.selectLlmProvider,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...LLMProvider.values.map((provider) => RadioListTile<LLMProvider>(
                  title: Text(_providerName(provider)),
                  subtitle: Text(_providerDescription(provider)),
                  value: provider,
                  groupValue: config.provider,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(llmConfigProvider.notifier).updateProvider(value);
                      Navigator.pop(context);
                    }
                  },
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _providerDescription(LLMProvider provider) {
    switch (provider) {
      case LLMProvider.openai:
        return 'GPT-4, GPT-3.5 Turbo';
      case LLMProvider.claude:
        return 'Claude 3.5, Claude 3';
      case LLMProvider.openRouter:
        return 'Multiple providers';
      case LLMProvider.gemini:
        return 'Gemini 1.5 Pro, Flash';
      case LLMProvider.ollama:
        return 'Local models';
      case LLMProvider.koboldCpp:
        return 'GGUF models';
    }
  }
}

class _ApiKeyTile extends ConsumerStatefulWidget {
  const _ApiKeyTile();

  @override
  ConsumerState<_ApiKeyTile> createState() => _ApiKeyTileState();
}


class _ApiKeyTileState extends ConsumerState<_ApiKeyTile> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(llmConfigProvider);
    final isLocal =
        config.provider == LLMProvider.ollama || config.provider == LLMProvider.koboldCpp;

    if (isLocal) return const SizedBox.shrink();

    return ListTile(
      leading: const Icon(Icons.key),
      title: Text(AppLocalizations.of(context)!.apiKey),
      subtitle: Text(
        config.apiKey.isEmpty
            ? AppLocalizations.of(context)!.notSet
            : _obscureText
                ? '••••••••${config.apiKey.length > 8 ? config.apiKey.substring(config.apiKey.length - 4) : ''}'
                : config.apiKey,
      ),
      trailing: IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
      onTap: () => _showApiKeyDialog(context, ref, config),
    );
  }

  void _showApiKeyDialog(BuildContext context, WidgetRef ref, LLMConfig config) {
    final controller = TextEditingController(text: config.apiKey);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.apiKey),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.enterApiKey,
            hintText: 'sk-...',
          ),
          obscureText: true,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(llmConfigProvider.notifier).updateApiKey(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

class _ApiUrlTile extends ConsumerWidget {
  const _ApiUrlTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(llmConfigProvider);

    return ListTile(
      leading: const Icon(Icons.link),
      title: Text(AppLocalizations.of(context)!.apiUrl),
      subtitle: Text(config.apiUrl),
      onTap: () => _showApiUrlDialog(context, ref, config),
    );
  }

  void _showApiUrlDialog(BuildContext context, WidgetRef ref, LLMConfig config) {
    final controller = TextEditingController(text: config.apiUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.apiUrl),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.apiEndpointUrl,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(llmConfigProvider.notifier).updateApiUrl(controller.text);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

class _ModelTile extends ConsumerStatefulWidget {
  const _ModelTile();

  @override
  ConsumerState<_ModelTile> createState() => _ModelTileState();
}

class _ModelTileState extends ConsumerState<_ModelTile> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(llmConfigProvider);
    final modelFetchState = ref.watch(modelFetchProvider);

    ref.listen<ModelFetchState>(modelFetchProvider, (previous, next) {
      if (next.status == ModelFetchStatus.success && next.models.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showModelListSheet(context, ref, config, next.models);
          }
        });
      } else if (next.status == ModelFetchStatus.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.errorMessage ?? AppLocalizations.of(context)!.failedToFetchModels),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    });

    return ListTile(
      leading: const Icon(Icons.memory),
      title: Text(AppLocalizations.of(context)!.model),
      subtitle: _buildSubtitle(config, modelFetchState),
      trailing: modelFetchState.status == ModelFetchStatus.loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.arrow_drop_down),
      onTap: modelFetchState.status == ModelFetchStatus.loading
          ? null
          : () => _showModelPicker(context, ref, config, modelFetchState),
    );
  }

  Widget _buildSubtitle(LLMConfig config, ModelFetchState modelFetchState) {
    if (modelFetchState.status == ModelFetchStatus.loading) {
      return Text(AppLocalizations.of(context)!.fetchingModels);
    }
    return Text(config.model.isEmpty ? AppLocalizations.of(context)!.notSet : config.model);
  }

  void _showModelPicker(BuildContext context, WidgetRef ref, LLMConfig config,
      ModelFetchState modelFetchState) {
    if (modelFetchState.status == ModelFetchStatus.success &&
        modelFetchState.models.isNotEmpty) {
      _showModelListSheet(context, ref, config, modelFetchState.models);
    } else {
      _showModelInputDialog(context, ref, config);
    }
  }

  void _showModelListSheet(
      BuildContext context, WidgetRef ref, LLMConfig config, List<String> models) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _ModelSelectionSheet(
        models: models,
        selectedModel: config.model,
        onModelSelected: (model) {
          ref.read(llmConfigProvider.notifier).updateModel(model);
          Navigator.pop(sheetContext);
        },
        onRefresh: () {
          Navigator.pop(sheetContext);
          final currentConfig = ref.read(llmConfigProvider);
          ref.read(modelFetchProvider.notifier).fetchModels(currentConfig);
        },
        onManualEntry: () {
          Navigator.pop(sheetContext);
          final currentConfig = ref.read(llmConfigProvider);
          _showManualInputDialog(context, ref, currentConfig);
        },
      ),
    );
  }

  void _showModelInputDialog(BuildContext context, WidgetRef ref, LLMConfig config) {
    final controller = TextEditingController(text: config.model);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.model),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.modelName,
                hintText: 'e.g., gpt-4o',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.cloud_download),
                label: Text(AppLocalizations.of(context)!.fetchAvailableModels),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  final currentConfig = ref.read(llmConfigProvider);
                  ref.read(modelFetchProvider.notifier).fetchModels(currentConfig);
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.fetchModelsDescription,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(llmConfigProvider.notifier).updateModel(controller.text);
              Navigator.pop(dialogContext);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showManualInputDialog(BuildContext context, WidgetRef ref, LLMConfig config) {
    final controller = TextEditingController(text: config.model);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.enterModelName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.modelName,
            hintText: 'e.g., gpt-4o',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(llmConfigProvider.notifier).updateModel(controller.text);
              Navigator.pop(dialogContext);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

class _ConnectionTestTile extends ConsumerWidget {
  const _ConnectionTestTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(connectionTestProvider);
    final config = ref.watch(llmConfigProvider);

    return ListTile(
      leading: Icon(
        _getStatusIcon(testState.status),
        color: _getStatusColor(testState.status),
      ),
      title: Text(AppLocalizations.of(context)!.testConnection),
      subtitle: Text(_getStatusText(context, testState)),
      trailing: testState.status == ConnectionStatus.testing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: testState.status == ConnectionStatus.testing
          ? null
          : () => ref.read(connectionTestProvider.notifier).testConnection(config),
    );
  }

  IconData _getStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.idle:
        return Icons.help_outline;
      case ConnectionStatus.testing:
        return Icons.sync;
      case ConnectionStatus.success:
        return Icons.check_circle;
      case ConnectionStatus.error:
        return Icons.error;
    }
  }

  Color _getStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.idle:
        return AppTheme.textMuted;
      case ConnectionStatus.testing:
        return AppTheme.accentColor;
      case ConnectionStatus.success:
        return Colors.green;
      case ConnectionStatus.error:
        return Colors.red;
    }
  }

  String _getStatusText(BuildContext context, ConnectionTestState state) {
    final l10n = AppLocalizations.of(context)!;
    switch (state.status) {
      case ConnectionStatus.idle:
        return l10n.tapToTestConnection;
      case ConnectionStatus.testing:
        return l10n.testing;
      case ConnectionStatus.success:
        return state.message ?? l10n.connected;
      case ConnectionStatus.error:
        return state.message ?? l10n.connectionFailedSimple;
    }
  }
}

class _MaxTokensTile extends ConsumerWidget {
  const _MaxTokensTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(llmConfigProvider);

    return ListTile(
      leading: const Icon(Icons.format_list_numbered),
      title: Text(AppLocalizations.of(context)!.maxTokens),
      subtitle: Text('${config.maxTokens}'),
      onTap: () => _showMaxTokensDialog(context, ref, config),
    );
  }

  void _showMaxTokensDialog(BuildContext context, WidgetRef ref, LLMConfig config) {
    final controller = TextEditingController(text: config.maxTokens.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.maxTokens),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.maximumTokensToGenerate,
            hintText: '1000000',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                ref.read(llmConfigProvider.notifier).updateMaxTokens(value);
              }
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

class _TemperatureTile extends ConsumerWidget {
  const _TemperatureTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(llmConfigProvider);

    return ListTile(
      leading: const Icon(Icons.thermostat),
      title: Text(AppLocalizations.of(context)!.temperature),
      subtitle: Slider(
        value: config.temperature,
        min: 0.0,
        max: 2.0,
        divisions: 40,
        label: config.temperature.toStringAsFixed(2),
        onChanged: (value) {
          ref.read(llmConfigProvider.notifier).updateTemperature(value);
        },
      ),
    );
  }
}

class _TopPTile extends ConsumerWidget {
  const _TopPTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(llmConfigProvider);

    return ListTile(
      leading: const Icon(Icons.pie_chart),
      title: Text(AppLocalizations.of(context)!.topP),
      subtitle: Slider(
        value: config.topP,
        min: 0.0,
        max: 1.0,
        divisions: 20,
        label: config.topP.toStringAsFixed(2),
        onChanged: (value) {
          ref.read(llmConfigProvider.notifier).updateTopP(value);
        },
      ),
    );
  }
}

class _StreamingTile extends ConsumerWidget {
  const _StreamingTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(llmConfigProvider);

    return SwitchListTile(
      secondary: const Icon(Icons.stream),
      title: Text(AppLocalizations.of(context)!.streaming),
      subtitle: Text(AppLocalizations.of(context)!.showResponseAsItGenerates),
      value: config.streamEnabled,
      onChanged: (value) {
        ref.read(llmConfigProvider.notifier).updateStreamEnabled(value);
      },
    );
  }
}

/// Model selection sheet with search functionality
class _ModelSelectionSheet extends StatefulWidget {
  final List<String> models;
  final String selectedModel;
  final void Function(String model) onModelSelected;
  final VoidCallback onRefresh;
  final VoidCallback onManualEntry;

  const _ModelSelectionSheet({
    required this.models,
    required this.selectedModel,
    required this.onModelSelected,
    required this.onRefresh,
    required this.onManualEntry,
  });

  @override
  State<_ModelSelectionSheet> createState() => _ModelSelectionSheetState();
}

class _ModelSelectionSheetState extends State<_ModelSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredModels = [];

  @override
  void initState() {
    super.initState();
    _filteredModels = widget.models;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredModels = widget.models;
      } else {
        _filteredModels =
            widget.models.where((model) => model.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.selectModelCount(widget.models.length),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: AppLocalizations.of(context)!.refreshModels,
                    onPressed: widget.onRefresh,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: AppLocalizations.of(context)!.enterManually,
                    onPressed: widget.onManualEntry,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchModels,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_filteredModels.length} of ${widget.models.length} models',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                  ),
                ),
              ),
            const Divider(height: 1),
            Expanded(
              child: _filteredModels.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 48, color: AppTheme.textMuted),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.noModelsFound,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.tryDifferentSearchTerm,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filteredModels.length,
                      itemBuilder: (_, index) {
                        final model = _filteredModels[index];
                        final isSelected = model == widget.selectedModel;
                        return ListTile(
                          title: Text(
                            model,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppTheme.accentColor : null,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check, color: AppTheme.accentColor)
                              : null,
                          onTap: () => widget.onModelSelected(model),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}