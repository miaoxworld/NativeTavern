import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/context_usage_service.dart';
import 'package:native_tavern/presentation/providers/context_usage_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Compact context usage indicator for chat input area
class ContextUsageIndicator extends ConsumerWidget {
  const ContextUsageIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(contextUsageProvider);

    if (usage == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => _showDetailedUsageDialog(context, ref),
      child: _buildCompactIndicator(context, usage),
    );
  }

  Widget _buildCompactIndicator(BuildContext context, ContextUsage usage) {
    final percentage = usage.usagePercentage;
    final color = _getUsageColor(usage.level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular progress indicator
          SizedBox(
            width: 16,
            height: 16,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 2,
                  backgroundColor: AppTheme.darkDivider,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.darkDivider,
                  ),
                ),
                CircularProgressIndicator(
                  value: (percentage / 100).clamp(0.0, 1.0),
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Token count and percentage
          Text(
            '${_formatTokenCount(usage.totalTokens)} / ${_formatTokenCount(usage.maxContext)}',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${percentage.toStringAsFixed(0)}%)',
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.info_outline,
            size: 12,
            color: color.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Color _getUsageColor(ContextUsageLevel level) {
    switch (level) {
      case ContextUsageLevel.low:
        return Colors.green;
      case ContextUsageLevel.medium:
        return Colors.amber;
      case ContextUsageLevel.high:
        return Colors.orange;
      case ContextUsageLevel.critical:
        return Colors.red;
    }
  }

  String _formatTokenCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _showDetailedUsageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const ContextUsageDialog(),
    );
  }
}

/// Detailed context usage dialog showing breakdown
class ContextUsageDialog extends ConsumerWidget {
  const ContextUsageDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(contextUsageProvider);
    final l10n = AppLocalizations.of(context);

    if (usage == null) {
      return AlertDialog(
        title: Text(l10n.contextUsage),
        content: Text(l10n.noActiveChat),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      );
    }

    return AlertDialog(
      backgroundColor: AppTheme.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.analytics,
            color: _getUsageColor(usage.level),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.contextUsage,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall usage bar
            _buildOverallUsageBar(context, usage),
            const SizedBox(height: 16),
            // Usage summary
            _buildUsageSummary(context, usage, l10n),
            const SizedBox(height: 16),
            const Divider(color: AppTheme.darkDivider),
            const SizedBox(height: 8),
            // Component breakdown
            Text(
              l10n.breakdown,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // Components list
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: usage.components.map((component) {
                    return _buildComponentItem(context, component, usage);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }

  Widget _buildOverallUsageBar(BuildContext context, ContextUsage usage) {
    final percentage = usage.usagePercentage;
    final color = _getUsageColor(usage.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (percentage / 100).clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppTheme.darkDivider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (usage.isOverLimit)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'OVER LIMIT',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildUsageSummary(
    BuildContext context,
    ContextUsage usage,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            l10n.totalTokens,
            _formatTokenCount(usage.totalTokens),
            AppTheme.textPrimary,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            l10n.maxContext,
            _formatTokenCount(usage.maxContext),
            AppTheme.textSecondary,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            l10n.remaining,
            _formatTokenCount(usage.remainingTokens),
            usage.remainingTokens > 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildComponentItem(
    BuildContext context,
    ContextComponentUsage component,
    ContextUsage usage,
  ) {
    final percentage = component.getPercentage(usage.maxContext);
    final hasChildren = component.children != null && component.children!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              if (hasChildren)
                const Icon(
                  Icons.folder_outlined,
                  size: 16,
                  color: AppTheme.textMuted,
                )
              else
                const Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  component.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${_formatTokenCount(component.tokenCount)} (${percentage.toStringAsFixed(1)}%)',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Progress bar for this component
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: (percentage / 100).clamp(0.0, 1.0),
            minHeight: 3,
            backgroundColor: AppTheme.darkDivider,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getComponentColor(component.name),
            ),
          ),
        ),
        // Children items if present
        if (hasChildren)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: component.children!.map((child) {
                return _buildChildItem(context, child, usage);
              }).toList(),
            ),
          ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildChildItem(
    BuildContext context,
    ContextComponentUsage component,
    ContextUsage usage,
  ) {
    final percentage = component.getPercentage(usage.maxContext);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getComponentColor(component.name).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              component.name,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            '${_formatTokenCount(component.tokenCount)} (${percentage.toStringAsFixed(1)}%)',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Color _getUsageColor(ContextUsageLevel level) {
    switch (level) {
      case ContextUsageLevel.low:
        return Colors.green;
      case ContextUsageLevel.medium:
        return Colors.amber;
      case ContextUsageLevel.high:
        return Colors.orange;
      case ContextUsageLevel.critical:
        return Colors.red;
    }
  }

  Color _getComponentColor(String name) {
    // Assign consistent colors to component types
    final nameLower = name.toLowerCase();
    if (nameLower.contains('prompt section')) return Colors.blueGrey;
    if (nameLower.contains('system')) return Colors.blue;
    if (nameLower.contains('character') || nameLower.contains('description')) {
      return Colors.purple;
    }
    if (nameLower.contains('personality')) return Colors.deepPurple;
    if (nameLower.contains('scenario')) return Colors.indigo;
    if (nameLower.contains('persona')) return Colors.teal;
    if (nameLower.contains('world') || nameLower.contains('lore')) {
      return Colors.orange;
    }
    if (nameLower.contains('author')) return Colors.pink;
    if (nameLower.contains('example')) return Colors.brown;
    if (nameLower.contains('post-history') || nameLower.contains('jailbreak')) {
      return Colors.red;
    }
    if (nameLower.contains('nsfw')) return Colors.redAccent;
    if (nameLower.contains('chat') || nameLower.contains('history')) {
      return Colors.green;
    }
    if (nameLower.contains('summar')) return Colors.indigo;
    if (nameLower.contains('user')) return Colors.cyan;
    if (nameLower.contains('assistant')) return Colors.amber;
    if (nameLower.contains('custom')) return Colors.deepOrange;
    return AppTheme.primaryColor;
  }

  String _formatTokenCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
