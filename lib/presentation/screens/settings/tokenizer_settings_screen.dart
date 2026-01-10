import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/tokenizer.dart';
import 'package:native_tavern/domain/services/tokenizer_service.dart';
import 'package:native_tavern/presentation/providers/tokenizer_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Settings and visualization screen for tokenizer
class TokenizerSettingsScreen extends ConsumerStatefulWidget {
  const TokenizerSettingsScreen({super.key});

  @override
  ConsumerState<TokenizerSettingsScreen> createState() => _TokenizerSettingsScreenState();
}

class _TokenizerSettingsScreenState extends ConsumerState<TokenizerSettingsScreen> {
  final _textController = TextEditingController();
  String _inputText = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(tokenizerSettingsProvider);
    final service = ref.watch(tokenizerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokenizer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context, service),
            tooltip: 'Help',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Settings section
          _buildSectionHeader(context, 'Settings'),
          const SizedBox(height: 8),
          
          // Tokenizer selector
          DropdownButtonFormField<TokenizerType>(
            value: settings.selectedTokenizer,
            decoration: const InputDecoration(
              labelText: 'Tokenizer',
              border: OutlineInputBorder(),
            ),
            items: TokenizerType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.displayName),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) {
                ref.read(tokenizerSettingsProvider.notifier).setSelectedTokenizer(type);
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            settings.selectedTokenizer.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Show Token Count'),
            subtitle: const Text('Display token count in chat input'),
            value: settings.showTokenCount,
            onChanged: (value) {
              ref.read(tokenizerSettingsProvider.notifier).setShowTokenCount(value);
            },
          ),
          SwitchListTile(
            title: const Text('Show Token Visualization'),
            subtitle: const Text('Highlight individual tokens'),
            value: settings.showTokenVisualization,
            onChanged: (value) {
              ref.read(tokenizerSettingsProvider.notifier).setShowTokenVisualization(value);
            },
          ),
          SwitchListTile(
            title: const Text('Cache Results'),
            subtitle: const Text('Cache tokenization for performance'),
            value: settings.cacheResults,
            onChanged: (value) {
              ref.read(tokenizerSettingsProvider.notifier).setCacheResults(value);
            },
          ),

          const Divider(height: 32),

          // Visualization section
          _buildSectionHeader(context, 'Token Visualization'),
          const SizedBox(height: 16),
          
          // Input text field
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Enter text to tokenize',
              hintText: 'Type or paste text here...',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            onChanged: (value) {
              setState(() {
                _inputText = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Quick estimate
          if (_inputText.isNotEmpty) ...[
            _QuickEstimate(text: _inputText),
            const SizedBox(height: 16),
          ],

          // Tokenization result
          if (_inputText.isNotEmpty)
            _TokenizationResultView(
              text: _inputText,
              tokenizer: settings.selectedTokenizer,
            ),

          const SizedBox(height: 32),
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

  void _showHelpDialog(BuildContext context, TokenizerService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tokenizer Help'),
        content: SingleChildScrollView(
          child: Text(service.getHelpText()),
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

/// Quick token count estimate widget
class _QuickEstimate extends ConsumerWidget {
  final String text;

  const _QuickEstimate({required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estimate = ref.watch(tokenCountEstimateProvider(text));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.speed,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Estimate'),
                  Text(
                    '~$estimate tokens',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              '${text.length} chars',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tokenization result visualization
class _TokenizationResultView extends ConsumerWidget {
  final String text;
  final TokenizerType tokenizer;

  const _TokenizationResultView({
    required this.text,
    required this.tokenizer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = TokenizationRequest(text: text, tokenizer: tokenizer);
    final resultAsync = ref.watch(tokenizationResultProvider(request));

    return resultAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error: $error'),
        ),
      ),
      data: (result) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Statistics card
          _StatisticsCard(result: result),
          const SizedBox(height: 16),
          
          // Token visualization
          _TokenVisualization(result: result),
        ],
      ),
    );
  }
}

/// Statistics card for tokenization result
class _StatisticsCard extends ConsumerWidget {
  final TokenizationResult result;

  const _StatisticsCard({required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(tokenizerServiceProvider);
    final stats = service.getStatistics(result);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                  label: 'Total Tokens',
                  value: result.tokenCount.toString(),
                  icon: Icons.token,
                ),
                _StatItem(
                  label: 'Unique',
                  value: stats.uniqueTokens.toString(),
                  icon: Icons.fingerprint,
                ),
                _StatItem(
                  label: 'Chars/Token',
                  value: result.charToTokenRatio.toStringAsFixed(2),
                  icon: Icons.text_fields,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatItem(
                  label: 'Avg Length',
                  value: stats.avgTokenLength.toStringAsFixed(1),
                  icon: Icons.straighten,
                ),
                _StatItem(
                  label: 'Longest',
                  value: '${stats.longestToken} chars',
                  icon: Icons.expand,
                ),
                _StatItem(
                  label: 'Shortest',
                  value: '${stats.shortestToken} chars',
                  icon: Icons.compress,
                ),
              ],
            ),
            if (stats.tokenFrequency.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Most Common Tokens',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: stats.getTopTokens(10).map((entry) {
                  return Chip(
                    label: Text(
                      '"${_escapeToken(entry.key)}" (${entry.value})',
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _escapeToken(String token) {
    return token
        .replaceAll('\n', '↵')
        .replaceAll('\t', '→')
        .replaceAll(' ', '␣');
  }
}

/// Single statistic item
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

/// Token visualization widget
class _TokenVisualization extends StatelessWidget {
  final TokenizationResult result;

  const _TokenVisualization({required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.tokens.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Token Breakdown',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${result.tokens.length} tokens',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: result.tokens.asMap().entries.map((entry) {
                final index = entry.key;
                final token = entry.value;
                return _TokenChip(
                  token: token,
                  index: index,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single token chip
class _TokenChip extends StatelessWidget {
  final Token token;
  final int index;

  const _TokenChip({
    required this.token,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    final color = colors[index % colors.length];

    return Tooltip(
      message: 'Token ID: ${token.id}\nLength: ${token.text.length} chars',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          _escapeToken(token.text),
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            color: color.shade700,
          ),
        ),
      ),
    );
  }

  String _escapeToken(String text) {
    if (text.isEmpty) return '∅';
    return text
        .replaceAll('\n', '↵')
        .replaceAll('\t', '→')
        .replaceAll(' ', '␣');
  }
}

extension on Color {
  Color get shade700 {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
  }
}