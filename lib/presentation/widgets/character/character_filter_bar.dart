import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/tag.dart';
import '../../providers/character_filter_providers.dart';
import '../../providers/tag_providers.dart';
import '../../screens/tags/tags_screen.dart';
import '../../theme/app_theme.dart';

/// Filter bar for character list
class CharacterFilterBar extends ConsumerWidget {
  const CharacterFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(characterFilterProvider);
    final newTagsAsync = ref.watch(tagNotifierProvider);
    final legacyTagsAsync = ref.watch(allLegacyTagsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and filter row
          Row(
            children: [
              // Search field
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search characters...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: filterState.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              ref.read(characterFilterProvider.notifier).setSearchQuery('');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppTheme.darkCard,
                  ),
                  onChanged: (value) {
                    ref.read(characterFilterProvider.notifier).setSearchQuery(value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Favorites toggle
              IconButton(
                icon: Icon(
                  filterState.showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                  color: filterState.showFavoritesOnly ? Colors.red : null,
                ),
                tooltip: 'Show favorites only',
                onPressed: () {
                  ref.read(characterFilterProvider.notifier).toggleFavoritesOnly();
                },
              ),
              // Sort button
              PopupMenuButton<CharacterSortOption>(
                icon: const Icon(Icons.sort),
                tooltip: 'Sort by',
                onSelected: (option) {
                  ref.read(characterFilterProvider.notifier).setSortOption(option);
                },
                itemBuilder: (context) => CharacterSortOption.values.map((option) {
                  final isSelected = filterState.sortOption == option;
                  return PopupMenuItem(
                    value: option,
                    child: Row(
                      children: [
                        if (isSelected)
                          const Icon(Icons.check, size: 18, color: AppTheme.accentColor)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(option.displayName),
                      ],
                    ),
                  );
                }).toList(),
              ),
              // Filter button (tags)
              IconButton(
                icon: Badge(
                  isLabelVisible: filterState.selectedTagIds.isNotEmpty || filterState.selectedLegacyTags.isNotEmpty,
                  label: Text('${filterState.selectedTagIds.length + filterState.selectedLegacyTags.length}'),
                  child: const Icon(Icons.filter_list),
                ),
                tooltip: 'Filter by tags',
                onPressed: () => _showTagFilterSheet(context, ref, newTagsAsync, legacyTagsAsync),
              ),
            ],
          ),
          
          // Active filters chips
          if (filterState.hasActiveFilters) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (filterState.showFavoritesOnly)
                    _FilterChip(
                      label: 'Favorites',
                      icon: Icons.favorite,
                      color: Colors.red,
                      onRemove: () {
                        ref.read(characterFilterProvider.notifier).toggleFavoritesOnly();
                      },
                    ),
                  // New tags (from Tags table)
                  ...(() {
                    final tags = newTagsAsync.valueOrNull ?? [];
                    return filterState.selectedTagIds.map((tagId) {
                      Tag? foundTag;
                      for (final t in tags) {
                        if (t.id == tagId) {
                          foundTag = t;
                          break;
                        }
                      }
                      final tag = foundTag ?? Tag(id: tagId, name: tagId, createdAt: DateTime.now());
                      return _FilterChip(
                        label: tag.name,
                        icon: Icons.label,
                        color: tag.colorValue,
                        onRemove: () {
                          ref.read(characterFilterProvider.notifier).toggleTagId(tagId);
                        },
                      );
                    }).toList();
                  })(),
                  // Legacy tags (from character.tags field)
                  ...filterState.selectedLegacyTags.map((tag) => _FilterChip(
                    label: tag,
                    icon: Icons.label_outline,
                    onRemove: () {
                      ref.read(characterFilterProvider.notifier).toggleTag(tag);
                    },
                  )),
                  if (filterState.hasActiveFilters)
                    TextButton.icon(
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: const Text('Clear all'),
                      onPressed: () {
                        ref.read(characterFilterProvider.notifier).clearFilters();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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

  void _showTagFilterSheet(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Tag>> newTagsAsync,
    AsyncValue<List<String>> legacyTagsAsync,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _TagFilterSheet(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onRemove;

  const _FilterChip({
    required this.label,
    required this.icon,
    this.color,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        avatar: Icon(icon, size: 16, color: color),
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _TagFilterSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const _TagFilterSheet({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(characterFilterProvider);
    final newTagsAsync = ref.watch(tagNotifierProvider);
    final legacyTagsAsync = ref.watch(allLegacyTagsProvider);
    final tagUsageCountsAsync = ref.watch(tagUsageCountsProvider);
    final legacyTagCountsAsync = ref.watch(tagCountsProvider);

    final totalSelected = filterState.selectedTagIds.length + filterState.selectedLegacyTags.length;

    return SafeArea(
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Filter by Tags',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.settings, size: 18),
                  label: const Text('Manage'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const TagsScreen()),
                    );
                  },
                ),
                if (totalSelected > 0)
                  TextButton(
                    onPressed: () {
                      ref.read(characterFilterProvider.notifier).clearTags();
                    },
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Tags list
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                // New Tags section (from Tags table)
                newTagsAsync.when<Widget>(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $e'),
                  ),
                  data: (List<Tag> tags) {
                    if (tags.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.label_outline, size: 48, color: AppTheme.textMuted),
                            const SizedBox(height: 8),
                            Text(
                              'No tags created yet',
                              style: TextStyle(color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Create Tags'),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(builder: (_) => const TagsScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    final usageCounts = tagUsageCountsAsync.valueOrNull ?? {};

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tags.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              'Tags',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                          ...tags.map((Tag tag) {
                            final isSelected = filterState.selectedTagIds.contains(tag.id);
                            final count = usageCounts[tag.id] ?? 0;

                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (_) {
                                ref.read(characterFilterProvider.notifier).toggleTagId(tag.id);
                              },
                              title: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: tag.colorValue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (tag.icon != null && tag.icon!.isNotEmpty) ...[
                                    Text(tag.icon!),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(tag.name),
                                ],
                              ),
                              subtitle: Text('$count character${count == 1 ? '' : 's'}'),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: tag.colorValue,
                            );
                          }),
                        ],
                      ],
                    );
                  },
                ),

                // Legacy Tags section (from character.tags field)
                legacyTagsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => const SizedBox.shrink(),
                  data: (legacyTags) {
                    if (legacyTags.isEmpty) return const SizedBox.shrink();

                    final legacyCounts = legacyTagCountsAsync.valueOrNull ?? {};

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Text(
                            'Character Tags (Legacy)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ),
                        ...legacyTags.map((tag) {
                          final isSelected = filterState.selectedLegacyTags.contains(tag);
                          final count = legacyCounts[tag] ?? 0;

                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (_) {
                              ref.read(characterFilterProvider.notifier).toggleTag(tag);
                            },
                            title: Text(tag),
                            subtitle: Text('$count character${count == 1 ? '' : 's'}'),
                            secondary: Icon(Icons.label_outline, color: AppTheme.textMuted),
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        }),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Apply button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  totalSelected == 0
                      ? 'Done'
                      : 'Apply ($totalSelected selected)',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}