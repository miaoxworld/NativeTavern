import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Advanced settings screen for full sampler control
class AdvancedSettingsScreen extends ConsumerWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(llmConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.advancedSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: l10n.resetToDefaults,
            onPressed: () => _showResetConfirmation(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Basic Sampling
          _buildSectionHeader(context, l10n.basicSampling),
          _buildSliderTile(
            context: context,
            title: l10n.temperature,
            subtitle: l10n.temperatureDescription,
            value: config.temperature,
            min: 0.0,
            max: 2.0,
            divisions: 40,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTemperature(v),
          ),
          _buildSliderTile(
            context: context,
            title: l10n.topPNucleusSampling,
            subtitle: l10n.topPDescription,
            value: config.topP,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTopP(v),
          ),
          _buildIntSliderTile(
            context: context,
            title: l10n.topK,
            subtitle: l10n.topKDescription,
            value: config.topK,
            min: 0,
            max: 200,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTopK(v),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, l10n.advancedSampling),
          _buildSliderTile(
            context: context,
            title: l10n.minP,
            subtitle: l10n.minPDescription,
            value: config.minP,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMinP(v),
          ),
          _buildSliderTile(
            context: context,
            title: l10n.typicalP,
            subtitle: l10n.typicalPDescription,
            value: config.typicalP,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTypicalP(v),
          ),
          _buildSliderTile(
            context: context,
            title: l10n.topA,
            subtitle: l10n.topADescription,
            value: config.topA,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTopA(v),
          ),
          _buildSliderTile(
            context: context,
            title: l10n.tailFreeSamplingTfs,
            subtitle: l10n.tfsDescription,
            value: config.tailFreeSampling,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateTailFreeSampling(v),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, l10n.repetitionControl),
          _buildSliderTile(
            context: context,
            title: l10n.repetitionPenalty,
            subtitle: l10n.repetitionPenaltyDescription,
            value: config.repetitionPenalty,
            min: 1.0,
            max: 2.0,
            divisions: 20,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateRepetitionPenalty(v),
          ),
          _buildIntSliderTile(
            context: context,
            title: l10n.repetitionPenaltyRange,
            subtitle: l10n.repetitionPenaltyRangeDescription,
            value: config.repetitionPenaltyRange,
            min: 0,
            max: 4096,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateRepetitionPenaltyRange(v),
          ),
          _buildSliderTile(
            context: context,
            title: l10n.frequencyPenalty,
            subtitle: l10n.frequencyPenaltyDescription,
            value: config.frequencyPenalty,
            min: 0.0,
            max: 2.0,
            divisions: 40,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateFrequencyPenalty(v),
          ),
          _buildSliderTile(
            context: context,
            title: l10n.presencePenalty,
            subtitle: l10n.presencePenaltyDescription,
            value: config.presencePenalty,
            min: 0.0,
            max: 2.0,
            divisions: 40,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updatePresencePenalty(v),
          ),

          const Divider(height: 32),
          _buildSectionHeader(context, l10n.mirostatLocalModels),
          _buildMirostatModeTile(context, ref, config.mirostatMode),
          if (config.mirostatMode > 0) ...[
            _buildSliderTile(
              context: context,
              title: l10n.mirostatTau,
              subtitle: l10n.mirostatTauDescription,
              value: config.mirostatTau,
              min: 0.0,
              max: 10.0,
              divisions: 20,
              onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMirostatTau(v),
            ),
            _buildSliderTile(
              context: context,
              title: l10n.mirostatEta,
              subtitle: l10n.mirostatEtaDescription,
              value: config.mirostatEta,
              min: 0.0,
              max: 1.0,
              divisions: 20,
              onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMirostatEta(v),
            ),
          ],

          const Divider(height: 32),
          _buildSectionHeader(context, l10n.generationControl),
          _buildIntInputTile(
            context: context,
            ref: ref,
            title: l10n.maxTokens,
            subtitle: l10n.maxTokensDescription,
            value: config.maxTokens,
            onChanged: (v) => ref.read(llmConfigProvider.notifier).updateMaxTokens(v),
          ),
          _buildIntInputTile(
            context: context,
            ref: ref,
            title: l10n.seed,
            subtitle: l10n.seedDescription,
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
    final l10n = AppLocalizations.of(context);
    return ListTile(
      title: Text(l10n.mirostatMode),
      subtitle: Text(l10n.adaptiveSamplingForLocalModels),
      trailing: SegmentedButton<int>(
        segments: [
          ButtonSegment(value: 0, label: Text(l10n.off)),
          const ButtonSegment(value: 1, label: Text('v1')),
          const ButtonSegment(value: 2, label: Text('v2')),
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
    final l10n = AppLocalizations.of(context);
    return ListTile(
      title: Text(l10n.stopSequences),
      subtitle: Text(
        sequences.isEmpty
            ? l10n.noStopSequencesConfigured
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
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: currentSequences.join('\n'),
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stopSequences),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.stopSequencesDescription,
              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
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
            child: Text(l10n.cancel),
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
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetToDefaults),
        content: Text(l10n.resetConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(llmConfigProvider.notifier).resetToDefaults();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsResetToDefaults)),
              );
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}