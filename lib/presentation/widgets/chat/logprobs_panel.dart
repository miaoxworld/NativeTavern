import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/logprobs.dart';
import 'package:native_tavern/presentation/providers/logprobs_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Panel for displaying token log probabilities
class LogprobsPanel extends ConsumerWidget {
  final String messageId;
  final VoidCallback? onClose;

  const LogprobsPanel({
    super.key,
    required this.messageId,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logprobs = ref.watch(messageLogprobProvider(messageId));
    final settings = ref.watch(logprobsSettingsProvider);
    final selectedToken = ref.watch(selectedTokenLogprobProvider);

    if (logprobs == null || logprobs.tokenLogprobs.isEmpty) {
      return _buildEmptyState(context, settings);
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(context, logprobs),
          const Divider(height: 1),
          
          // Token output view
          Expanded(
            flex: 2,
            child: _TokenOutputView(
              logprobs: logprobs,
              selectedToken: selectedToken,
              onTokenSelected: (token) {
                ref.read(selectedTokenLogprobProvider.notifier).state = 
                    selectedToken == token ? null : token;
              },
            ),
          ),
          
          // Top candidates view
          if (selectedToken != null) ...[
            const Divider(height: 1),
            Expanded(
              flex: 1,
              child: _TopCandidatesView(
                tokenLogprob: selectedToken,
                onAlternativeSelected: (alternative) {
                  // TODO: Implement reroll with alternative token
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reroll with "$alternative" not yet implemented')),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MessageLogprobs logprobs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Token Probabilities',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Spacer(),
          Text(
            '${logprobs.tokenCount} tokens',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, LogprobsSettings settings) {
    String message;
    if (!settings.requestTokenProbabilities) {
      message = 'Enable "Request token probabilities" in settings to use this feature.';
    } else {
      message = 'No token probabilities available for this message.';
    }

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

/// View for displaying tokens with their probabilities
class _TokenOutputView extends ConsumerWidget {
  final MessageLogprobs logprobs;
  final TokenLogprob? selectedToken;
  final ValueChanged<TokenLogprob> onTokenSelected;

  const _TokenOutputView({
    required this.logprobs,
    required this.selectedToken,
    required this.onTokenSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorCalculator = ref.watch(probabilityColorProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          // Continue prefix if present
          if (logprobs.continueFrom != null && logprobs.continueFrom!.isNotEmpty)
            ..._buildPrefixTokens(context, logprobs.continueFrom!),
          
          // Token spans
          ...logprobs.tokenLogprobs.asMap().entries.map((entry) {
            final index = entry.key;
            final token = entry.value;
            final isSelected = selectedToken == token;
            final tintIndex = colorCalculator.getTintIndex(index);

            return _TokenSpan(
              token: token,
              tintIndex: tintIndex,
              isSelected: isSelected,
              onTap: () => onTokenSelected(token),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildPrefixTokens(BuildContext context, String prefix) {
    final words = prefix.split(RegExp(r'\s+'));
    return words.map((word) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          '$word ',
          style: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }).toList();
  }
}

/// Single token span widget
class _TokenSpan extends StatelessWidget {
  final TokenLogprob token;
  final int tintIndex;
  final bool isSelected;
  final VoidCallback onTap;

  const _TokenSpan({
    required this.token,
    required this.tintIndex,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Convert special whitespace to visible characters
    final displayText = _toVisibleWhitespace(token.token);
    
    // Get tint color based on index
    final tintColor = _getTintColor(tintIndex);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.accentColor.withValues(alpha: 0.3)
              : tintColor.withValues(alpha: 0.15),
          border: isSelected
              ? Border.all(color: AppTheme.accentColor, width: 2)
              : null,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: isSelected
                ? AppTheme.accentColor
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  String _toVisibleWhitespace(String text) {
    return text
        .replaceAll(' ', '␣')
        .replaceAll('\n', '↵\n')
        .replaceAll('\t', '→');
  }

  Color _getTintColor(int index) {
    const colors = [
      Color(0xFF4CAF50), // Green
      Color(0xFF2196F3), // Blue
      Color(0xFFFF9800), // Orange
      Color(0xFF9C27B0), // Purple
    ];
    return colors[index % colors.length];
  }
}

/// View for displaying top candidate tokens
class _TopCandidatesView extends StatelessWidget {
  final TokenLogprob tokenLogprob;
  final ValueChanged<String> onAlternativeSelected;

  const _TopCandidatesView({
    required this.tokenLogprob,
    required this.onAlternativeSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (tokenLogprob.topCandidates.isEmpty) {
      return Center(
        child: Text(
          'No alternative tokens available',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      );
    }

    // Sort candidates by probability (highest first)
    final sortedCandidates = List<TokenCandidate>.from(tokenLogprob.topCandidates)
      ..sort((a, b) => b.logprob.compareTo(a.logprob));

    // Calculate total probability for "others"
    double totalProb = 0;
    for (final candidate in sortedCandidates) {
      if (candidate.logprob <= 0) {
        totalProb += math.exp(candidate.logprob);
      }
    }
    final othersProb = (1 - totalProb) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'Alternative Tokens',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...sortedCandidates.map((candidate) {
                final isSelected = candidate.token == tokenLogprob.token ||
                    _normalizeToken(candidate.token) == tokenLogprob.token;
                
                return _CandidateChip(
                  candidate: candidate,
                  isSelected: isSelected,
                  onTap: () => onAlternativeSelected(candidate.token),
                );
              }),
              // Others chip
              _OthersChip(probability: othersProb),
            ],
          ),
        ],
      ),
    );
  }

  String _normalizeToken(String token) {
    // Remove leading special characters used by some tokenizers
    return token.replaceAll(RegExp(r'^[▁Ġ]'), ' ');
  }
}

/// Chip for displaying a candidate token
class _CandidateChip extends StatelessWidget {
  final TokenCandidate candidate;
  final bool isSelected;
  final VoidCallback onTap;

  const _CandidateChip({
    required this.candidate,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final probability = candidate.logprob <= 0
        ? math.exp(candidate.logprob) * 100
        : candidate.logprob;

    return Material(
      color: isSelected
          ? AppTheme.accentColor.withValues(alpha: 0.2)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _toVisibleWhitespace(candidate.token),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${probability.toStringAsFixed(2)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _toVisibleWhitespace(String text) {
    return text
        .replaceAll(' ', '␣')
        .replaceAll('\n', '↵')
        .replaceAll('\t', '→');
  }
}

/// Chip for displaying "others" probability
class _OthersChip extends StatelessWidget {
  final double probability;

  const _OthersChip({required this.probability});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '<others>',
            style: TextStyle(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${probability.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

/// Settings screen for logprobs
class LogprobsSettingsScreen extends ConsumerWidget {
  const LogprobsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(logprobsSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Token Probabilities'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Request Token Probabilities'),
            subtitle: const Text('Ask the AI to return probability data'),
            value: settings.requestTokenProbabilities,
            onChanged: (value) {
              ref.read(logprobsSettingsProvider.notifier).setRequestTokenProbabilities(value);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Top Candidates Count'),
            subtitle: Text('Show top ${settings.topLogprobsCount} alternative tokens'),
            trailing: SizedBox(
              width: 100,
              child: Slider(
                value: settings.topLogprobsCount.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: settings.topLogprobsCount.toString(),
                onChanged: settings.requestTokenProbabilities
                    ? (value) {
                        ref.read(logprobsSettingsProvider.notifier).setTopLogprobsCount(value.round());
                      }
                    : null,
              ),
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Show Logprobs Panel'),
            subtitle: const Text('Display probability panel in chat'),
            value: settings.showLogprobsPanel,
            onChanged: settings.requestTokenProbabilities
                ? (value) {
                    ref.read(logprobsSettingsProvider.notifier).setShowLogprobsPanel(value);
                  }
                : null,
          ),
          const Divider(),
          ListTile(
            title: const Text('Color Intensity'),
            subtitle: Text('${(settings.colorIntensity * 100).round()}%'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: settings.colorIntensity,
                min: 0,
                max: 1,
                onChanged: settings.requestTokenProbabilities
                    ? (value) {
                        ref.read(logprobsSettingsProvider.notifier).setColorIntensity(value);
                      }
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 32),
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
                        'About Token Probabilities',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Token probabilities show how confident the AI was about each word or token '
                    'in its response. You can:\n\n'
                    '• Click on tokens to see alternatives\n'
                    '• View probability percentages\n'
                    '• Understand model confidence\n\n'
                    'Note: Not all AI backends support this feature. '
                    'Smooth streaming must be disabled to use logprobs.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}