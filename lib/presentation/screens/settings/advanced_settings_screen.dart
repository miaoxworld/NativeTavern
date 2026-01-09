import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Advanced settings screen for full sampler control
class AdvancedSettingsScreen extends ConsumerWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(llmConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to Defaults',
            onPressed: () => _showResetConfirmation(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Basic Sampling
          _buildSectionHeader(context, 'Basic Sampling'),
          _buildSliderTile(
            context: context,
            title: 'Temperature',
            subtitle: 'Controls randomness. Higher = more creative, lower = more focused.',
            value: config.temperature,
            min: 0.0,
            max: 2.0,
            divisions: 40,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTemperature(v),
          ),
          _buildSliderTile(
            context: context,
            title: 'Top P (Nucleus Sampling)',
            subtitle: 'Cumulative probability threshold for token selection.',
            value: config.topP,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTopP(v),
          ),
          _buildIntSliderTile(
            context: context,
            title: 'Top K',
            subtitle: 'Number of top tokens to consider. 0 = disabled.',
            value: config.topK,
            min: 0,
            max: 200,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTopK(v),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, 'Advanced Sampling'),
          _buildSliderTile(
            context: context,
            title: 'Min P',
            subtitle: 'Minimum probability threshold relative to top token.',
            value: config.minP,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMinP(v),
          ),
          _buildSliderTile(
            context: context,
            title: 'Typical P',
            subtitle: 'Locally typical sampling. 1.0 = disabled.',
            value: config.typicalP,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTypicalP(v),
          ),
          _buildSliderTile(
            context: context,
            title: 'Top A',
            subtitle: 'Top-A sampling threshold. 0 = disabled.',
            value: config.topA,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTopA(v),
          ),
          _buildSliderTile(
            context: context,
            title: 'Tail Free Sampling (TFS)',
            subtitle: 'Removes low-probability tail. 1.0 = disabled.',
            value: config.tailFreeSampling,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTailFreeSampling(v),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, 'Repetition Control'),
          _buildSliderTile(
            context: context,
            title: 'Repetition Penalty',
            subtitle: 'Penalizes repeated tokens. 1.0 = no penalty.',
            value: config.repetitionPenalty,
            min: 1.0,
            max: 2.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateRepetitionPenalty(v),
          ),
          _buildIntSliderTile(
            context: context,
            title: 'Repetition Penalty Range',
            subtitle: 'How many tokens to consider. 0 = all.',
            value: config.repetitionPenaltyRange,
            min: 0,
            max: 4096,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateRepetitionPenaltyRange(v),
          ),
          _buildSliderTile(
            context: context,
            title: 'Frequency Penalty',
            subtitle: 'Penalizes tokens based on frequency in text.',
            value: config.frequencyPenalty,
            min: 0.0,
            max: 2.0,
            divisions: 40,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateFrequencyPenalty(v),
          ),
          _buildSliderTile(
            context: context,
            title: 'Presence Penalty',
            subtitle: 'Penalizes tokens that appear at all in text.',
            value: config.presencePenalty,
            min: 0.0,
            max: 2.0,
            divisions: 40,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updatePresencePenalty(v),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, 'Mirostat (Local Models)'),
          _buildMirostatModeTile(context, ref, config.mirostatMode),
          if (config.mirostatMode > 0) ...[
            _buildSliderTile(
              context: context,
              title: 'Mirostat Tau',
              subtitle: 'Target entropy/perplexity.',
              value: config.mirostatTau,
              min: 0.0,
              max: 10.0,
              divisions: 20,
              onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMirostatTau(v),
            ),
            _buildSliderTile(
              context: context,
              title: 'Mirostat Eta',
              subtitle: 'Learning rate for Mirostat.',
              value: config.mirostatEta,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMirostatEta(v),
            ),
          ],

          const Divider(height: 32),
          _buildSectionHeader(context, 'Generation Control'),
          _buildIntInputTile(
            context: context,
            ref: ref,
            title: 'Max Tokens',
            subtitle: 'Maximum tokens to generate.',
            value: config.maxTokens,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMaxTokens(v),
          ),
          _buildIntInputTile(
            context: context,
            ref: ref,
            title: 'Seed',
            subtitle: 'Random seed for reproducibility. -1 = random.',
            value: config.seed,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateSeed(v),
          ),
          _buildStopSequencesTile(context, ref, config.stopSequences),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSliderTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: const TextStyle(fontSize: 12)),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildIntSliderTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            value.toString(),
            style: TextStyle(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: const TextStyle(fontSize: 12)),
          Slider(
            value: value.toDouble().clamp(min.toDouble(), max.toDouble()),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }

  Widget _buildMirostatModeTile(BuildContext context, WidgetRef ref, int mode) {
    return ListTile(
      title: const Text('Mirostat Mode'),
      subtitle: const Text('Adaptive sampling for local models'),
      trailing: SegmentedButton<int>(
        segments: const [
          ButtonSegment(value: 0, label: Text('Off')),
          ButtonSegment(value: 1, label: Text('v1')),
          ButtonSegment(value: 2, label: Text('v2')),
        ],
        selected: {mode},
        onSelectionChanged: (selected) {
          ref.read(llmConfigProvider.notifier).updateMirostatMode(selected.first);
        },
      ),
    );
  }

  Widget _buildIntInputTile({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: SizedBox(
        width: 100,
        child: Text(
          value.toString(),
          style: TextStyle(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.end,
        ),
      ),
      onTap: () => _showIntInputDialog(context, title, value, onChanged),
    );
  }

  void _showIntInputDialog(
    BuildContext context,
    String title,
    int currentValue,
    ValueChanged<int> onChanged,
  ) {
    final controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null) {
                onChanged(value);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildStopSequencesTile(
    BuildContext context,
    WidgetRef ref,
    List<String> sequences,
  ) {
    return ListTile(
      title: const Text('Stop Sequences'),
      subtitle: Text(
        sequences.isEmpty
            ? 'No stop sequences configured'
            : sequences.join(', '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showStopSequencesDialog(context, ref, sequences),
    );
  }

  void _showStopSequencesDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> currentSequences,
  ) {
    final controller = TextEditingController(
      text: currentSequences.join('\n'),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Sequences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter one sequence per line. Generation stops when any of these are produced.',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g.\n\\n\\n\n[END]\n</s>',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final sequences = controller.text
                  .split('\n')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              ref.read(llmConfigProvider.notifier).updateStopSequences(sequences);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'This will reset all sampler settings to their default values. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(llmConfigProvider.notifier).resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}