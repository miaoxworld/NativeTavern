import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/character_filter_providers.dart';
import '../../theme/app_theme.dart';

/// Filter bar for character list
class CharacterFilterBar extends ConsumerWidget {
  const CharacterFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(characterFilterProvider);
    final allTagsAsync = ref.watch(allTagsProvider);

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
                  isLabelVisible: filterState.selectedTags.isNotEmpty,
                  label: Text('${filterState.selectedTags.length}'),
                  child: const Icon(Icons.filter_list),
                ),
                tooltip: 'Filter by tags',
                onPressed: () => _showTagFilterSheet(context, ref, allTagsAsync),
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
                  ...filterState.selectedTags.map((tag) => _FilterChip(
                    label: tag,
                    icon: Icons.label,
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
    AsyncValue<List<String>> allTagsAsync,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
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
    final allTagsAsync = ref.watch(allTagsProvider);
    final tagCountsAsync = ref.watch(tagCountsProvider);

    return SafeArea(
      child: Column(
        children: [
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
                if (filterState.selectedTags.isNotEmpty)
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
            child: allTagsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (tags) {
                if (tags.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.label_off, size: 48, color: AppTheme.textMuted),
                        SizedBox(height: 16),
                        Text(
                          'No tags found',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add tags to your characters to filter them',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  controller: scrollController,
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    final tag = tags[index];
                    final isSelected = filterState.selectedTags.contains(tag);
                    final count = tagCountsAsync.valueOrNull?[tag] ?? 0;
                    
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (_) {
                        ref.read(characterFilterProvider.notifier).toggleTag(tag);
                      },
                      title: Text(tag),
                      subtitle: Text('$count character${count == 1 ? '' : 's'}'),
                      secondary: const Icon(Icons.label),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                );
              },
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
                  filterState.selectedTags.isEmpty
                      ? 'Done'
                      : 'Apply (${filterState.selectedTags.length} selected)',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}