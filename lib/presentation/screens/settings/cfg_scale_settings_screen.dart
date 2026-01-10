import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/cfg_scale.dart';
import 'package:native_tavern/presentation/providers/cfg_scale_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Settings screen for CFG Scale configuration
class CFGScaleSettingsScreen extends ConsumerWidget {
  final String? characterId;
  final String? chatId;

  const CFGScaleSettingsScreen({
    super.key,
    this.characterId,
    this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(cfgScaleSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CFG Scale'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Help',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(cfgScaleSettingsProvider.notifier).resetToDefaults();
            },
            tooltip: 'Reset to Defaults',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable toggle
          SwitchListTile(
            title: const Text('Enable CFG Scale'),
            subtitle: const Text('Classifier-Free Guidance for text generation'),
            value: settings.enabled,
            onChanged: (value) {
              ref.read(cfgScaleSettingsProvider.notifier).setEnabled(value);
            },
          ),
          const Divider(height: 32),

          // Global settings
          _buildSectionHeader(context, 'Global Settings'),
          const SizedBox(height: 16),
          _GuidanceScaleSlider(
            value: settings.globalGuidanceScale,
            onChanged: settings.enabled
                ? (value) {
                    ref.read(cfgScaleSettingsProvider.notifier).setGlobalGuidanceScale(value);
                  }
                : null,
          ),
          const SizedBox(height: 16),
          _PromptTextField(
            label: 'Negative Prompt',
            hint: 'Text to steer the model away from',
            value: settings.globalNegativePrompt,
            enabled: settings.enabled,
            onChanged: (value) {
              ref.read(cfgScaleSettingsProvider.notifier).setGlobalNegativePrompt(value);
            },
          ),
          const SizedBox(height: 16),
          _PromptTextField(
            label: 'Positive Prompt (Optional)',
            hint: 'Text to enhance in the output',
            value: settings.globalPositivePrompt,
            enabled: settings.enabled,
            onChanged: (value) {
              ref.read(cfgScaleSettingsProvider.notifier).setGlobalPositivePrompt(value);
            },
          ),

          // Character-specific settings (if characterId provided)
          if (characterId != null) ...[
            const Divider(height: 32),
            _CharacterCFGSection(
              characterId: characterId!,
              globalEnabled: settings.enabled,
            ),
          ],

          // Chat-specific settings (if chatId provided)
          if (chatId != null) ...[
            const Divider(height: 32),
            _ChatCFGSection(
              chatId: chatId!,
              globalEnabled: settings.enabled,
            ),
          ],

          const SizedBox(height: 32),

          // Info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'About CFG Scale',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'CFG (Classifier-Free Guidance) Scale controls how strongly the model '
                    'follows the negative prompt to avoid certain content or styles.\n\n'
                    '• Scale 1.0 = No effect (default)\n'
                    '• Scale 1.5-3.0 = Subtle guidance\n'
                    '• Scale 3.0-7.0 = Moderate guidance\n'
                    '• Scale 7.0+ = Strong guidance (may affect coherence)',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CFG Scale Help'),
        content: const SingleChildScrollView(
          child: Text(
            'Classifier-Free Guidance (CFG) Scale is a technique that allows you to '
            'guide the AI model\'s output by specifying what you want to avoid.\n\n'
            '**How it works:**\n'
            'The model generates two outputs - one with your prompt and one with the '
            'negative prompt. The final output is adjusted to move away from the '
            'negative prompt direction.\n\n'
            '**Settings Priority:**\n'
            '1. Chat-specific settings (highest)\n'
            '2. Character-specific settings\n'
            '3. Global settings (lowest)\n\n'
            '**Tips:**\n'
            '• Start with low values (1.5-2.0) and increase gradually\n'
            '• Use specific negative prompts for better results\n'
            '• High values may cause repetition or incoherence\n'
            '• Not all AI backends support CFG Scale',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Slider widget for guidance scale
class _GuidanceScaleSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const _GuidanceScaleSlider({
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Guidance Scale',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toStringAsFixed(2),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('0.1'),
            Expanded(
              child: Slider(
                value: value,
                min: 0.1,
                max: 30.0,
                divisions: 299,
                onChanged: enabled ? onChanged : null,
              ),
            ),
            const Text('30.0'),
          ],
        ),
        // Quick presets
        Wrap(
          spacing: 8,
          children: [
            _PresetChip(label: '1.0', value: 1.0, currentValue: value, onTap: onChanged),
            _PresetChip(label: '1.5', value: 1.5, currentValue: value, onTap: onChanged),
            _PresetChip(label: '2.0', value: 2.0, currentValue: value, onTap: onChanged),
            _PresetChip(label: '3.0', value: 3.0, currentValue: value, onTap: onChanged),
            _PresetChip(label: '5.0', value: 5.0, currentValue: value, onTap: onChanged),
            _PresetChip(label: '7.0', value: 7.0, currentValue: value, onTap: onChanged),
          ],
        ),
      ],
    );
  }
}

/// Chip for quick preset selection
class _PresetChip extends StatelessWidget {
  final String label;
  final double value;
  final double currentValue;
  final ValueChanged<double>? onTap;

  const _PresetChip({
    required this.label,
    required this.value,
    required this.currentValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = (currentValue - value).abs() < 0.01;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!(value) : null,
    );
  }
}

/// Text field for prompts
class _PromptTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _PromptTextField({
    required this.label,
    required this.hint,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<_PromptTextField> createState() => _PromptTextFieldState();
}

class _PromptTextFieldState extends State<_PromptTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_PromptTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: const OutlineInputBorder(),
        enabled: widget.enabled,
      ),
      maxLines: 3,
      onChanged: widget.onChanged,
    );
  }
}

/// Section for character-specific CFG settings
class _CharacterCFGSection extends ConsumerWidget {
  final String characterId;
  final bool globalEnabled;

  const _CharacterCFGSection({
    required this.characterId,
    required this.globalEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(cfgScaleSettingsProvider);
    final charSettings = settings.characterSettings.firstWhere(
      (s) => s.characterId == characterId,
      orElse: () => CharacterCFGSettings.empty(characterId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Character Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Use Character-Specific Settings'),
          subtitle: const Text('Override global settings for this character'),
          value: charSettings.useCharacterSettings,
          onChanged: globalEnabled
              ? (value) {
                  ref.read(cfgScaleSettingsProvider.notifier).updateCharacterSettings(
                        charSettings.copyWith(useCharacterSettings: value),
                      );
                }
              : null,
        ),
        if (charSettings.useCharacterSettings) ...[
          const SizedBox(height: 16),
          _GuidanceScaleSlider(
            value: charSettings.guidanceScale ?? 1.0,
            onChanged: globalEnabled
                ? (value) {
                    ref.read(cfgScaleSettingsProvider.notifier).updateCharacterSettings(
                          charSettings.copyWith(guidanceScale: value),
                        );
                  }
                : null,
          ),
          const SizedBox(height: 16),
          _PromptTextField(
            label: 'Character Negative Prompt',
            hint: 'Override global negative prompt',
            value: charSettings.negativePrompt ?? '',
            enabled: globalEnabled,
            onChanged: (value) {
              ref.read(cfgScaleSettingsProvider.notifier).updateCharacterSettings(
                    charSettings.copyWith(negativePrompt: value),
                  );
            },
          ),
        ],
      ],
    );
  }
}

/// Section for chat-specific CFG settings
class _ChatCFGSection extends ConsumerWidget {
  final String chatId;
  final bool globalEnabled;

  const _ChatCFGSection({
    required this.chatId,
    required this.globalEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatSettings = ref.watch(chatCFGSettingsProvider(chatId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chat Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: globalEnabled
                  ? () {
                      ref.read(chatCFGSettingsProvider(chatId).notifier).clearSettings();
                    }
                  : null,
              child: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'These settings override global and character settings for this chat only.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        _GuidanceScaleSlider(
          value: chatSettings.guidanceScale ?? 1.0,
          onChanged: globalEnabled
              ? (value) {
                  ref.read(chatCFGSettingsProvider(chatId).notifier).setGuidanceScale(value);
                }
              : null,
        ),
        const SizedBox(height: 16),
        _PromptTextField(
          label: 'Chat Negative Prompt',
          hint: 'Override for this chat',
          value: chatSettings.negativePrompt ?? '',
          enabled: globalEnabled,
          onChanged: (value) {
            ref.read(chatCFGSettingsProvider(chatId).notifier).setNegativePrompt(value);
          },
        ),
        const SizedBox(height: 16),
        _PromptTextField(
          label: 'Chat Positive Prompt',
          hint: 'Enhancement for this chat',
          value: chatSettings.positivePrompt ?? '',
          enabled: globalEnabled,
          onChanged: (value) {
            ref.read(chatCFGSettingsProvider(chatId).notifier).setPositivePrompt(value);
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<PromptCombineMode>(
          value: chatSettings.promptCombineMode,
          decoration: const InputDecoration(
            labelText: 'Prompt Combine Mode',
            border: OutlineInputBorder(),
          ),
          items: PromptCombineMode.values.map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(_getCombineModeLabel(mode)),
            );
          }).toList(),
          onChanged: globalEnabled
              ? (mode) {
                  if (mode != null) {
                    ref.read(chatCFGSettingsProvider(chatId).notifier).setPromptCombineMode(mode);
                  }
                }
              : null,
        ),
      ],
    );
  }

  String _getCombineModeLabel(PromptCombineMode mode) {
    switch (mode) {
      case PromptCombineMode.replace:
        return 'Replace (use chat prompt only)';
      case PromptCombineMode.prepend:
        return 'Prepend (chat + global)';
      case PromptCombineMode.append:
        return 'Append (global + chat)';
    }
  }
}