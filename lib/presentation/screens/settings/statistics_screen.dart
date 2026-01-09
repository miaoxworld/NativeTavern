import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/chat_statistics.dart';
import '../../providers/statistics_providers.dart';
import '../../theme/app_theme.dart';

/// Screen for viewing app and chat statistics
class StatisticsScreen extends ConsumerWidget {
  final String? chatId;

  const StatisticsScreen({super.key, this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatId != null ? 'Chat Statistics' : 'App Statistics'),
        actions: [
          if (chatId == null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset statistics',
              onPressed: () => _showResetConfirmation(context, ref),
            ),
        ],
      ),
      body: chatId != null
          ? _ChatStatisticsView(chatId: chatId!)
          : const _AppStatisticsView(),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Statistics'),
        content: const Text(
          'Are you sure you want to reset all statistics? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(appStatisticsProvider.notifier).reset();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Statistics reset')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _AppStatisticsView extends ConsumerWidget {
  const _AppStatisticsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(appStatisticsProvider);
    final summary = ref.watch(statisticsSummaryProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overview card
        _StatisticsCard(
          title: 'Overview',
          icon: Icons.dashboard,
          children: [
            _StatRow(
              label: 'First Used',
              value: stats.appFirstUsed != null
                  ? _formatDate(stats.appFirstUsed!)
                  : 'Unknown',
            ),
            _StatRow(
              label: 'Total Characters',
              value: summary.characterCount.toString(),
            ),
            _StatRow(
              label: 'Total Chats',
              value: stats.totalChats.toString(),
            ),
            _StatRow(
              label: 'Total Groups',
              value: stats.totalGroups.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Messages card
        _StatisticsCard(
          title: 'Messages',
          icon: Icons.message,
          children: [
            _StatRow(
              label: 'Total Messages',
              value: _formatNumber(stats.totalMessages),
            ),
            _StatRow(
              label: 'Total Generations',
              value: _formatNumber(stats.totalGenerations),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tokens card
        _StatisticsCard(
          title: 'Token Usage',
          icon: Icons.token,
          children: [
            _StatRow(
              label: 'Total Tokens Used',
              value: _formatNumber(stats.totalTokensUsed),
            ),
            _StatRow(
              label: 'Avg Tokens/Generation',
              value: stats.averageTokensPerGeneration.toStringAsFixed(1),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Performance card
        _StatisticsCard(
          title: 'Performance',
          icon: Icons.speed,
          children: [
            _StatRow(
              label: 'Total Generation Time',
              value: _formatDuration(stats.totalGenerationTime),
            ),
            _StatRow(
              label: 'Avg Generation Time',
              value: _formatDuration(stats.averageGenerationTime),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChatStatisticsView extends ConsumerWidget {
  final String chatId;

  const _ChatStatisticsView({required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(computedChatStatisticsProvider(chatId));

    return statsAsync.when(
      data: (stats) => _buildStatsList(context, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildStatsList(BuildContext context, ChatStatistics stats) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Messages card
        _StatisticsCard(
          title: 'Messages',
          icon: Icons.message,
          children: [
            _StatRow(
              label: 'Total Messages',
              value: stats.totalMessages.toString(),
            ),
            _StatRow(
              label: 'User Messages',
              value: stats.userMessages.toString(),
            ),
            _StatRow(
              label: 'Assistant Messages',
              value: stats.assistantMessages.toString(),
            ),
            _StatRow(
              label: 'System Messages',
              value: stats.systemMessages.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Timeline card
        _StatisticsCard(
          title: 'Timeline',
          icon: Icons.timeline,
          children: [
            _StatRow(
              label: 'First Message',
              value: stats.firstMessageAt != null
                  ? _formatDateTime(stats.firstMessageAt!)
                  : 'N/A',
            ),
            _StatRow(
              label: 'Last Message',
              value: stats.lastMessageAt != null
                  ? _formatDateTime(stats.lastMessageAt!)
                  : 'N/A',
            ),
            _StatRow(
              label: 'Chat Duration',
              value: _formatDuration(stats.chatDuration),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tokens card
        _StatisticsCard(
          title: 'Token Usage',
          icon: Icons.token,
          children: [
            _StatRow(
              label: 'Total Tokens',
              value: _formatNumber(stats.totalTokensUsed),
            ),
            _StatRow(
              label: 'Prompt Tokens',
              value: _formatNumber(stats.promptTokens),
            ),
            _StatRow(
              label: 'Completion Tokens',
              value: _formatNumber(stats.completionTokens),
            ),
            _StatRow(
              label: 'Avg Tokens/Message',
              value: stats.averageTokensPerMessage.toStringAsFixed(1),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Performance card
        _StatisticsCard(
          title: 'Generation Performance',
          icon: Icons.speed,
          children: [
            _StatRow(
              label: 'Total Generations',
              value: stats.generationCount.toString(),
            ),
            _StatRow(
              label: 'Total Generation Time',
              value: _formatDuration(stats.totalGenerationTime),
            ),
            _StatRow(
              label: 'Avg Generation Time',
              value: _formatDuration(stats.averageGenerationTime),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _StatisticsCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}

String _formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    return '${duration.inDays}d ${duration.inHours % 24}h';
  } else if (duration.inHours > 0) {
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
  } else if (duration.inSeconds > 0) {
    return '${duration.inSeconds}.${(duration.inMilliseconds % 1000) ~/ 100}s';
  } else if (duration.inMilliseconds > 0) {
    return '${duration.inMilliseconds}ms';
  }
  return '0s';
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _formatDateTime(DateTime date) {
  return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}