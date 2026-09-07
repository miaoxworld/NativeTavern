import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/services/story_play_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/providers/memory_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/story_providers.dart';
import 'package:native_tavern/presentation/providers/story_timeline_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/presentation/screens/play/story_models.dart';

class StoryScreen extends ConsumerWidget {
  const StoryScreen({super.key, this.initialChatId});

  final String? initialChatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chapters = ref.watch(storyTimelineProvider);
    final visibleChapters = _visibleItems(chapters.valueOrNull ?? const []);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.story),
        actions: [
          if (visibleChapters.isNotEmpty)
            IconButton(
              tooltip: l10n.storySearch,
              onPressed: () => _search(context, visibleChapters),
              icon: const Icon(Icons.search),
            ),
          IconButton(
            key: const Key('story-jot-note'),
            tooltip: l10n.storyJotNote,
            onPressed: () => _showJotNoteSheet(
              context,
              ref,
              visibleChapters,
              preferredChatId: initialChatId,
            ),
            icon: const Icon(Icons.edit_note_outlined),
          ),
          IconButton(
            key: const Key('story-open-inbox'),
            tooltip: l10n.memoryInbox,
            onPressed: () => context.push(AppRoutes.memoryInbox),
            icon: const Icon(Icons.inbox_outlined),
          ),
        ],
      ),
      body: chapters.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (allItems) {
          final items = _visibleItems(allItems);
          if (items.isEmpty) {
            return _StoryEmptyState(
              onGoToChat: () => context.go(AppRoutes.home),
            );
          }
          return _StoryLibrary(items: items);
        },
      ),
    );
  }

  List<StoryChapterTimelineItem> _visibleItems(
    List<StoryChapterTimelineItem> allItems,
  ) {
    final chatId = initialChatId;
    if (chatId == null) return allItems;
    final selected =
        allItems.where((item) => item.chatId == chatId).firstOrNull;
    if (selected == null) return const [];
    final rootId = selected.effectiveRootChatId;
    return allItems
        .where((item) => item.effectiveRootChatId == rootId)
        .toList(growable: false);
  }

  Future<void> _search(
    BuildContext context,
    List<StoryChapterTimelineItem> items,
  ) async {
    final selected = await showSearch<StoryChapterTimelineItem?>(
      context: context,
      delegate: _StorySearchDelegate(
        items,
        searchFieldLabel: AppLocalizations.of(context).storySearch,
      ),
    );
    if (selected != null && context.mounted) context.push(selected.chatPath);
  }
}

class _StoryEmptyState extends StatelessWidget {
  const _StoryEmptyState({required this.onGoToChat});

  final VoidCallback onGoToChat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.storyEmptyHint,
              key: const Key('story-empty-hint'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('story-go-to-chat'),
              onPressed: onGoToChat,
              child: Text(l10n.storyGoToChat),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryLibrary extends StatelessWidget {
  const _StoryLibrary({required this.items});

  final List<StoryChapterTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    final roots = <String, List<StoryChapterTimelineItem>>{};
    for (final item in items) {
      roots.putIfAbsent(item.effectiveRootChatId, () => []).add(item);
    }
    return ListView.separated(
      key: const Key('story-chapter-timeline'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      itemCount: roots.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) =>
          _StoryRoot(items: roots.values.elementAt(index)),
    );
  }
}

class _StoryRoot extends ConsumerWidget {
  const _StoryRoot({required this.items});

  final List<StoryChapterTimelineItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final branches = <String, List<StoryChapterTimelineItem>>{};
    for (final item in items) {
      branches.putIfAbsent(item.chatId, () => []).add(item);
    }
    for (final branch in branches.values) {
      branch.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    final branchEntries = branches.entries.toList(growable: false)
      ..sort((left, right) {
        final leftItem = left.value.first;
        final rightItem = right.value.first;
        final leftRoot = leftItem.chatId == leftItem.effectiveRootChatId;
        final rightRoot = rightItem.chatId == rightItem.effectiveRootChatId;
        if (leftRoot != rightRoot) return leftRoot ? -1 : 1;
        return (leftItem.forkOrdinal ?? -1)
            .compareTo(rightItem.forkOrdinal ?? -1);
      });
    final rootItem = items
        .where((item) => item.chatId == item.effectiveRootChatId)
        .firstOrNull;
    final rootChatId = rootItem?.chatId ?? items.first.effectiveRootChatId;
    final title =
        rootItem?.chatTitle ?? items.first.chatTitle ?? items.first.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            IconButton(
              tooltip: l10n.storyRename,
              onPressed: () => _renameStoryDialog(
                context,
                ref,
                rootChatId: rootChatId,
                currentTitle: title,
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
            if (branches.length >= 2)
              IconButton(
                tooltip: l10n.storyCompare,
                onPressed: () => _compare(context, ref, branches),
                icon: const Icon(Icons.compare_arrows),
              ),
          ],
        ),
        const SizedBox(height: 8),
        for (var index = 0; index < branchEntries.length; index++) ...[
          _StoryBranch(
            title: branchEntries[index].value.first.effectiveBranchTitle,
            isRoot: branchEntries[index].value.first.parentChatId == null,
            items: branchEntries[index].value,
          ),
          if (index < branchEntries.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Future<void> _renameStoryDialog(
    BuildContext context,
    WidgetRef ref, {
    required String rootChatId,
    required String currentTitle,
  }) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: currentTitle);
    var isGenerating = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.storyRenameTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.storyRename,
                  hintText: l10n.storyTitleHint,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: isGenerating
                    ? null
                    : () async {
                        setState(() => isGenerating = true);
                        try {
                          final config = ref.read(llmConfigProvider);
                          final generated = await ref
                              .read(storyPlayServiceProvider)
                              .generateStoryTitle(
                                rootChatId: rootChatId,
                                config: config,
                              );
                          if (generated.isNotEmpty) {
                            controller.text = generated;
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        } finally {
                          if (dialogContext.mounted) {
                            setState(() => isGenerating = false);
                          }
                        }
                      },
                icon: isGenerating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  isGenerating
                      ? l10n.storyGeneratingTitle
                      : l10n.storyGenerateTitle,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () async {
                final newTitle = controller.text.trim();
                if (newTitle.isNotEmpty && newTitle != currentTitle) {
                  try {
                    await ref
                        .read(storyPlayServiceProvider)
                        .renameStory(rootChatId: rootChatId, newTitle: newTitle);
                    ref.read(storyRevisionProvider.notifier).state++;
                    ref.invalidate(allChatsProvider);
                    ref.read(memoryInboxProvider.notifier).refresh();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.storyTitleUpdated)),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                }
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _compare(
    BuildContext context,
    WidgetRef ref,
    Map<String, List<StoryChapterTimelineItem>> branches,
  ) async {
    final choices = branches.entries
        .map(
          (entry) => (
            id: entry.key,
            title: entry.value.first.effectiveBranchTitle,
          ),
        )
        .toList(growable: false);
    var leftId = choices[0].id;
    var rightId = choices[1].id;
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context).storyCompare),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LinePicker(
                label: AppLocalizations.of(context).storyLeftLine,
                value: leftId,
                choices: choices,
                onChanged: (value) => setState(() => leftId = value),
              ),
              const SizedBox(height: 12),
              _LinePicker(
                label: AppLocalizations.of(context).storyRightLine,
                value: rightId,
                choices: choices,
                onChanged: (value) => setState(() => rightId = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: leftId == rightId
                  ? null
                  : () => Navigator.pop(dialogContext, true),
              child: Text(AppLocalizations.of(context).storyCompare),
            ),
          ],
        ),
      ),
    );
    if (accepted != true || !context.mounted) return;
    try {
      final comparison = await ref.read(storyPlayServiceProvider).compare(
            leftChatId: leftId,
            rightChatId: rightId,
          );
      if (!context.mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _StoryComparisonSheet(comparison: comparison),
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }
}

class _LinePicker extends StatelessWidget {
  const _LinePicker({
    required this.label,
    required this.value,
    required this.choices,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<({String id, String title})> choices;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final choice in choices)
          DropdownMenuItem(value: choice.id, child: Text(choice.title)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _StoryBranch extends StatelessWidget {
  const _StoryBranch({
    required this.title,
    required this.isRoot,
    required this.items,
  });

  final String title;
  final bool isRoot;
  final List<StoryChapterTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(isRoot ? Icons.timeline : Icons.call_split, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isRoot ? l10n.storyOriginalLine : title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Divider(height: 1),
            _StoryChapterTile(chapter: items[index]),
          ],
        ],
      ),
    );
  }
}

class _StoryChapterTile extends ConsumerWidget {
  const _StoryChapterTile({required this.chapter});

  final StoryChapterTimelineItem chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final narrative = chapter.narrative;
    final keyEvents = narrative.keyEvents.isEmpty
        ? <String>[chapter.summary]
        : narrative.keyEvents;
    return Padding(
      key: Key('story-chapter-${chapter.id}'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => context.push(chapter.chatPath),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(chapter.summary),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat.yMMMd().format(chapter.createdAt.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _NarrativeSection(title: l10n.storyKeyEvents, items: keyEvents),
          if (narrative.stateChanges.isNotEmpty)
            _NarrativeSection(
              title: l10n.storyStateChanges,
              items: narrative.stateChanges,
            ),
          if (narrative.openThreads.isNotEmpty)
            _NarrativeSection(
              title: l10n.storyOpenThreads,
              items: narrative.openThreads,
            ),
          if (narrative.nextSteps.isNotEmpty)
            _NarrativeSection(
              title: l10n.storyNextSteps,
              items: narrative.nextSteps,
            ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              TextButton.icon(
                onPressed: () => _continueStory(context),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.storyContinue),
              ),
              TextButton.icon(
                onPressed: () => _forkStory(context, ref),
                icon: const Icon(Icons.call_split),
                label: Text(l10n.storyFork),
              ),
              IconButton(
                tooltip: l10n.storyViewSource,
                onPressed: () => context.push(chapter.chatPath),
                icon: const Icon(Icons.history),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _direction(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final choices = [
      ...chapter.narrative.openThreads,
      ...chapter.narrative.nextSteps,
    ];
    if (choices.isEmpty) return l10n.storyDefaultDirection;
    if (choices.length == 1) return choices.single;
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final choice in choices)
              ListTile(
                title: Text(choice),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pop(context, choice),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _continueStory(BuildContext context) async {
    final direction = await _direction(context);
    if (direction == null || !context.mounted) return;
    final draft = AppLocalizations.of(context).storyContinueDraft(
      chapter.title,
      direction,
    );
    context.push(
      Uri(
        path: '/chat/${chapter.chatId}',
        queryParameters: {'draft': draft},
      ).toString(),
    );
  }

  Future<void> _forkStory(BuildContext context, WidgetRef ref) async {
    final direction = await _direction(context);
    if (direction == null || !context.mounted) return;
    final controller = TextEditingController();
    final branchName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).storyFork),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).storyBranchName,
            hintText: AppLocalizations.of(context).storyBranchNameHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(AppLocalizations.of(context).storyCreateBranch),
          ),
        ],
      ),
    );
    controller.dispose();
    if (branchName == null || branchName.isEmpty || !context.mounted) return;
    try {
      final result = await ref.read(storyPlayServiceProvider).forkFromChapter(
            chapterId: chapter.id,
            branchTitle: branchName,
          );
      ref.read(storyRevisionProvider.notifier).state++;
      if (!context.mounted) return;
      final draft = AppLocalizations.of(context).storyContinueDraft(
        chapter.title,
        direction,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context).storyForkCreated(branchName)),
        ),
      );
      context.push(
        Uri(
          path: '/chat/${result.chat.id}',
          queryParameters: {'draft': draft},
        ).toString(),
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }
}

class _NarrativeSection extends StatelessWidget {
  const _NarrativeSection({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('• $item'),
            ),
        ],
      ),
    );
  }
}

class _StoryComparisonSheet extends StatelessWidget {
  const _StoryComparisonSheet({required this.comparison});

  final StoryBranchComparison comparison;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.storyConsequencesAfterFork,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final left = _OutcomeColumn(outcome: comparison.left);
                  final right = _OutcomeColumn(outcome: comparison.right);
                  if (constraints.maxWidth < 600) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [left, const Divider(height: 32), right],
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: left),
                        const VerticalDivider(width: 32),
                        Expanded(child: right),
                      ],
                    ),
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

class _OutcomeColumn extends StatelessWidget {
  const _OutcomeColumn({required this.outcome});

  final StoryBranchOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          outcome.line.branchTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (outcome.chapters.isEmpty)
          Text(l10n.storyNoOutcome)
        else
          for (final chapter in outcome.chapters)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(chapter.summary),
                ],
              ),
            ),
        if (outcome.stateChanges.isNotEmpty)
          _NarrativeSection(
            title: l10n.storyStateChanges,
            items: outcome.stateChanges,
          ),
        if (outcome.openThreads.isNotEmpty)
          _NarrativeSection(
            title: l10n.storyOpenThreads,
            items: outcome.openThreads,
          ),
      ],
    );
  }
}

Future<void> _showJotNoteSheet(
  BuildContext context,
  WidgetRef ref,
  List<StoryChapterTimelineItem> items, {
  String? preferredChatId,
}) async {
  final l10n = AppLocalizations.of(context);
  var chats = <Chat>[];
  try {
    chats = await ref.read(chatRepositoryProvider).getAllChats();
  } catch (_) {
    // Tests may supply a timeline without a database-backed repository.
  }
  if (!context.mounted) return;
  final knownChats = {for (final chat in chats) chat.id: chat};
  for (final item in items) {
    knownChats.putIfAbsent(
      item.chatId,
      () => Chat(
        id: item.chatId,
        characterId: '',
        title: item.chatTitle ?? item.effectiveBranchTitle,
        createdAt: item.createdAt,
        updatedAt: item.createdAt,
      ),
    );
  }
  final controller = TextEditingController();
  String? selectedChatId =
      preferredChatId != null && knownChats.containsKey(preferredChatId)
          ? preferredChatId
          : knownChats.keys.firstOrNull;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          4,
          16,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.storyJotNote,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (knownChats.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: selectedChatId,
                decoration: InputDecoration(labelText: l10n.storySelectLine),
                items: [
                  for (final chat in knownChats.values)
                    DropdownMenuItem(value: chat.id, child: Text(chat.title)),
                ],
                onChanged: (value) => setState(() => selectedChatId = value),
              )
            else
              Text(l10n.storyNoChats),
            const SizedBox(height: 12),
            TextField(
              key: const Key('story-jot-note-field'),
              controller: controller,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: l10n.storyJotNoteHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                key: const Key('story-jot-note-save'),
                onPressed: () async {
                  final note = controller.text.trim();
                  final chatId = selectedChatId;
                  if (note.isEmpty || chatId == null) {
                    Navigator.pop(sheetContext);
                    return;
                  }
                  try {
                    await ref.read(storyPlayServiceProvider).jotNote(
                          chatId: chatId,
                          note: note,
                        );
                    ref.read(storyRevisionProvider.notifier).state++;
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.storyNoteSaved)),
                    );
                  } catch (error) {
                    if (sheetContext.mounted) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  }
                },
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  controller.dispose();
}

class _StorySearchDelegate extends SearchDelegate<StoryChapterTimelineItem?> {
  _StorySearchDelegate(this.items, {required String searchFieldLabel})
      : super(searchFieldLabel: searchFieldLabel);

  final List<StoryChapterTimelineItem> items;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
            onPressed: () => query = '',
            icon: const Icon(Icons.clear),
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) {
    final needle = query.trim().toLowerCase();
    final matches = needle.isEmpty
        ? items
        : items.where((item) {
            final haystack = [
              item.title,
              item.summary,
              ...item.narrative.keyEvents,
              ...item.narrative.stateChanges,
              ...item.narrative.openThreads,
            ].join('\n').toLowerCase();
            return haystack.contains(needle);
          }).toList(growable: false);
    if (matches.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context).storyNoSearchResults),
      );
    }
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final item = matches[index];
        return ListTile(
          title: Text(item.title),
          subtitle: Text(
            item.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => close(context, item),
        );
      },
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
