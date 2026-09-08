import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/long_term_memory.dart';
import 'package:native_tavern/domain/services/long_term_memory_governance_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/memory_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';

class MemoryInboxScreen extends ConsumerStatefulWidget {
  const MemoryInboxScreen({super.key});

  @override
  ConsumerState<MemoryInboxScreen> createState() => _MemoryInboxScreenState();
}

class _MemoryInboxScreenState extends ConsumerState<MemoryInboxScreen> {
  MemoryInboxView _view = MemoryInboxView.candidates;
  String? _selectedChatId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memoryInboxProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final inbox = ref.watch(memoryInboxProvider);
    final settings = ref.watch(appSettingsProvider);
    final selectedChatId = inbox.recentChats.any(
      (chat) => chat.id == _selectedChatId,
    )
        ? _selectedChatId
        : inbox.recentChats.firstOrNull?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memoryInbox),
        actions: [
          IconButton(
            key: const Key('memory-context-settings'),
            tooltip: l10n.memoryChatContext,
            onPressed: _showContextSettings,
            icon: const Icon(Icons.psychology_outlined),
          ),
          IconButton(
            tooltip: l10n.refresh,
            onPressed: inbox.isLoading
                ? null
                : () => ref.read(memoryInboxProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            key: const Key('memory-auto-extraction-switch'),
            secondary: const Icon(Icons.auto_awesome_outlined),
            title: Text(l10n.memoryAutomaticExtraction),
            subtitle: Text(l10n.memoryAutomaticExtractionSubtitle),
            value: settings.memoryAutoExtractionEnabled,
            onChanged: (value) => ref
                .read(appSettingsProvider.notifier)
                .updateMemoryAutoExtraction(value),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    key: const Key('memory-chat-picker'),
                    initialValue: selectedChatId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.memoryRecentChat,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: inbox.recentChats
                        .map(
                          (chat) => DropdownMenuItem(
                            value: chat.id,
                            child: Text(
                              chat.title.trim().isEmpty ? chat.id : chat.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: inbox.isExtracting
                        ? null
                        : (value) => setState(() => _selectedChatId = value),
                  ),
                ),
                const SizedBox(width: 8),
                if (inbox.isExtracting)
                  IconButton.filledTonal(
                    key: const Key('memory-cancel-extraction'),
                    tooltip: l10n.memoryCancelExtraction,
                    onPressed: () => ref
                        .read(memoryInboxProvider.notifier)
                        .cancelExtraction(),
                    icon: const Icon(Icons.stop),
                  )
                else
                  IconButton.filled(
                    key: const Key('memory-extract-chat'),
                    tooltip: l10n.memoryExtractFromChat,
                    onPressed: selectedChatId == null
                        ? null
                        : () => ref
                            .read(memoryInboxProvider.notifier)
                            .extractChat(selectedChatId),
                    icon: const Icon(Icons.auto_awesome),
                  ),
              ],
            ),
          ),
          if (inbox.isExtracting) const LinearProgressIndicator(),
          if (inbox.error != null)
            _StatusBanner(
              icon: Icons.error_outline,
              message: inbox.error!,
              action: selectedChatId == null
                  ? null
                  : TextButton(
                      onPressed: () => ref
                          .read(memoryInboxProvider.notifier)
                          .extractChat(selectedChatId),
                      child: Text(l10n.retry),
                    ),
            )
          else if (inbox.lastExtraction case final result?)
            _StatusBanner(
              icon: Icons.check_circle_outline,
              message: l10n.memoryExtractionResult(
                result.candidates.length,
                result.duplicateMemoryIds.length,
                result.rejectedItems,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<MemoryInboxView>(
                segments: [
                  ButtonSegment(
                    value: MemoryInboxView.candidates,
                    icon: const Icon(Icons.inbox_outlined),
                    label: Text(
                        l10n.memoryCandidatesCount(inbox.candidates.length)),
                  ),
                  ButtonSegment(
                    value: MemoryInboxView.active,
                    icon: const Icon(Icons.memory),
                    label: Text(l10n.memoryActiveCount(inbox.active.length)),
                  ),
                  ButtonSegment(
                    value: MemoryInboxView.history,
                    icon: const Icon(Icons.history),
                    label: Text(l10n.memoryHistoryCount(inbox.history.length)),
                  ),
                ],
                selected: {_view},
                onSelectionChanged: (selection) {
                  setState(() => _view = selection.single);
                },
              ),
            ),
          ),
          Expanded(child: _buildList(inbox)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('memory-create-manual'),
        tooltip: l10n.memoryCreate,
        onPressed: inbox.recentChats.isEmpty ? null : _createManual,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: inbox.selectedIds.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          l10n.memorySelectedCount(inbox.selectedIds.length)),
                    ),
                    IconButton(
                      tooltip: l10n.memoryClearSelection,
                      onPressed: () => ref
                          .read(memoryInboxProvider.notifier)
                          .clearSelection(),
                      icon: const Icon(Icons.close),
                    ),
                    IconButton.filledTonal(
                      key: const Key('memory-batch-ignore'),
                      tooltip: l10n.memoryIgnoreSelected,
                      onPressed: () => _run(
                        () => ref
                            .read(memoryInboxProvider.notifier)
                            .ignore(inbox.selectedIds),
                      ),
                      icon: const Icon(Icons.visibility_off_outlined),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      key: const Key('memory-merge-selected'),
                      tooltip: l10n.memoryMergeSelected,
                      onPressed:
                          inbox.selectedIds.length < 2 ? null : _mergeSelected,
                      icon: const Icon(Icons.merge),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      key: const Key('memory-batch-delete'),
                      tooltip: l10n.memoryDeleteSelected,
                      onPressed: _deleteSelected,
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildList(MemoryInboxState inbox) {
    if (inbox.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final memories = switch (_view) {
      MemoryInboxView.candidates => inbox.candidates,
      MemoryInboxView.active => inbox.active,
      MemoryInboxView.history => inbox.history,
    };
    if (memories.isEmpty) {
      return Center(
        child: Icon(
          _view == MemoryInboxView.candidates
              ? Icons.inbox_outlined
              : Icons.memory_outlined,
          size: 56,
          color: Theme.of(context).colorScheme.outline,
        ),
      );
    }
    final chatTitles = <String, String>{
      for (final chat in inbox.recentChats)
        chat.id: chat.title.trim().isEmpty ? chat.id : chat.title,
    };
    return ListView.separated(
      key: Key('memory-${_view.name}-list'),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
      itemCount: memories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final memory = memories[index];
        final sourceChatId = memory.source.sourceChatId ?? memory.scope.chatId;
        return _MemoryItem(
          memory: memory,
          chatTitle: sourceChatId != null ? chatTitles[sourceChatId] : null,
          assessment: inbox.conflicts[memory.id],
          selected: inbox.selectedIds.contains(memory.id),
          selectable: _view == MemoryInboxView.candidates,
          onSelect: () =>
              ref.read(memoryInboxProvider.notifier).toggleSelected(memory.id),
          onApprove: memory.state == MemoryState.candidate
              ? () => _run(
                    () => ref
                        .read(memoryInboxProvider.notifier)
                        .approve(memory.id),
                  )
              : null,
          onEdit: memory.state == MemoryState.forgotten
              ? null
              : () => _edit(memory),
          onIgnore: memory.state == MemoryState.candidate
              ? () => _run(
                    () => ref
                        .read(memoryInboxProvider.notifier)
                        .ignore({memory.id}),
                  )
              : null,
          onLock: memory.state == MemoryState.superseded ||
                  memory.state == MemoryState.forgotten
              ? null
              : () => _run(
                    () => ref
                        .read(memoryInboxProvider.notifier)
                        .setLocked(memory.id, !memory.locked),
                  ),
          onSource: memory.source.sourceChatId == null ||
                  memory.source.sourceMessageIds.isEmpty
              ? null
              : () => _openSource(memory),
          onDelete: () => _deleteMemory(memory),
        );
      },
    );
  }

  void _showContextSettings() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final l10n = AppLocalizations.of(context);
          final settings = ref.watch(appSettingsProvider);
          final notifier = ref.read(appSettingsProvider.notifier);
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    key: const Key('memory-context-switch'),
                    secondary: const Icon(Icons.psychology_outlined),
                    title: Text(l10n.memoryUseInChat),
                    value: settings.memoryContextEnabled,
                    onChanged: notifier.updateMemoryContext,
                  ),
                  SwitchListTile(
                    key: const Key('memory-semantic-search-switch'),
                    secondary: const Icon(Icons.hub_outlined),
                    title: Text(l10n.memorySemanticReranking),
                    subtitle: Text(l10n.memoryConfiguredEmbeddingProvider),
                    value: settings.memorySemanticSearchEnabled,
                    onChanged: settings.memoryContextEnabled
                        ? notifier.updateMemorySemanticSearch
                        : null,
                  ),
                  ListTile(
                    key: const Key('memory-context-budget'),
                    leading: const Icon(Icons.data_usage_outlined),
                    title: Text(l10n.memoryContextBudget),
                    trailing: DropdownButton<int>(
                      key: const Key('memory-context-budget-menu'),
                      value: settings.memoryContextTokenBudget,
                      items: [
                        DropdownMenuItem(
                            value: 256,
                            child: Text(l10n.memoryTokensCount(256))),
                        DropdownMenuItem(
                            value: 512,
                            child: Text(l10n.memoryTokensCount(512))),
                        DropdownMenuItem(
                          value: 1024,
                          child: Text(l10n.memoryTokensCount(1024)),
                        ),
                        DropdownMenuItem(
                          value: 2048,
                          child: Text(l10n.memoryTokensCount(2048)),
                        ),
                      ],
                      onChanged: settings.memoryContextEnabled
                          ? (value) {
                              if (value != null) {
                                notifier.updateMemoryContextTokenBudget(value);
                              }
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _createManual() async {
    final chats = ref.read(memoryInboxProvider).recentChats;
    final draft = await showDialog<_MemoryDraft>(
      context: context,
      builder: (_) => _MemoryEditorDialog(
        title: AppLocalizations.of(context).memoryCreate,
        chats: chats,
      ),
    );
    if (draft == null || draft.chatId == null) return;
    await _run(
      () => ref.read(memoryInboxProvider.notifier).createManual(
            scope: MemoryScope.chat(draft.chatId!),
            kind: draft.kind,
            content: draft.content,
            identityKey: draft.identityKey,
            importance: draft.importance,
            locked: draft.locked,
          ),
    );
  }

  Future<void> _edit(LongTermMemory memory) async {
    final draft = await showDialog<_MemoryDraft>(
      context: context,
      builder: (_) => _MemoryEditorDialog(
        title: AppLocalizations.of(context).memoryEdit,
        memory: memory,
      ),
    );
    if (draft == null) return;
    await _run(
      () => ref.read(memoryInboxProvider.notifier).saveEdits(
            id: memory.id,
            kind: draft.kind,
            content: draft.content,
            identityKey: draft.identityKey,
            importance: draft.importance,
            confidence: memory.confidence,
            expiresAt: memory.expiresAt,
            locked: draft.locked,
          ),
    );
  }

  Future<void> _mergeSelected() async {
    final selected = ref.read(memoryInboxProvider).selectedIds;
    final candidates = ref
        .read(memoryInboxProvider)
        .candidates
        .where((memory) => selected.contains(memory.id))
        .toList();
    if (candidates.length < 2) return;
    final draft = await showDialog<_MemoryDraft>(
      context: context,
      builder: (_) => _MemoryEditorDialog(
        title: AppLocalizations.of(context).memoryMerge,
        memory: candidates.first,
        initialContent: candidates.map((memory) => memory.content).join(' '),
      ),
    );
    if (draft == null) return;
    await _run(
      () => ref.read(memoryInboxProvider.notifier).mergeSelected(
            kind: draft.kind,
            content: draft.content,
            identityKey: draft.identityKey,
            locked: draft.locked,
          ),
    );
  }

  void _openSource(LongTermMemory memory) {
    final chatId = memory.source.sourceChatId!;
    final messageId = memory.source.sourceMessageIds.first;
    context.push(
      '/chat/${Uri.encodeComponent(chatId)}'
      '?message=${Uri.encodeQueryComponent(messageId)}',
    );
  }

  Future<void> _deleteMemory(LongTermMemory memory) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.memoryDelete),
        content: Text(l10n.memoryDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(
        () => ref.read(memoryInboxProvider.notifier).delete(memory.id),
      );
    }
  }

  Future<void> _deleteSelected() async {
    final l10n = AppLocalizations.of(context);
    final count = ref.read(memoryInboxProvider).selectedIds.length;
    if (count == 0) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.memoryDeleteSelected),
        content: Text(l10n.memoryDeleteSelectedConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(
        () => ref.read(memoryInboxProvider.notifier).deleteSelected(),
      );
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class _MemoryItem extends StatelessWidget {
  const _MemoryItem({
    required this.memory,
    required this.assessment,
    required this.selected,
    required this.selectable,
    required this.onSelect,
    required this.onApprove,
    required this.onEdit,
    required this.onIgnore,
    required this.onLock,
    required this.onSource,
    this.onDelete,
    this.chatTitle,
  });

  final LongTermMemory memory;
  final MemoryConflictAssessment? assessment;
  final bool selected;
  final bool selectable;
  final VoidCallback onSelect;
  final VoidCallback? onApprove;
  final VoidCallback? onEdit;
  final VoidCallback? onIgnore;
  final VoidCallback? onLock;
  final VoidCallback? onSource;
  final VoidCallback? onDelete;
  final String? chatTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Card(
      key: Key('memory-item-${memory.id}'),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectable)
                  Checkbox(
                    key: Key('memory-select-${memory.id}'),
                    value: selected,
                    onChanged: (_) => onSelect(),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(_kindIcon(memory.kind), size: 20),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _kindLabel(l10n, memory.kind),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(memory.content),
                      ],
                    ),
                  ),
                ),
                if (memory.locked)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.lock, size: 18),
                  ),
              ],
            ),
            if (assessment != null &&
                assessment!.kind != MemoryConflictKind.none)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: assessment!.kind == MemoryConflictKind.locked
                      ? colors.errorContainer
                      : colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  assessment!.explanation,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  Text(
                    memory.source.origin == MemoryOrigin.generated
                        ? '${memory.source.providerId} / ${memory.source.modelId}'
                        : l10n.manual,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _memoryScopeLabel(l10n, memory.scope.kind),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (chatTitle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 11,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          const SizedBox(width: 4),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: Text(
                              chatTitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    l10n.memoryImportancePercent(
                      (memory.importance * 100).round(),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (memory.expiresAt != null)
                    Text(
                      l10n.memoryExpires(
                        memory.expiresAt!.toLocal().toString().split(' ').first,
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onApprove != null)
                  IconButton(
                    key: Key('memory-approve-${memory.id}'),
                    tooltip: l10n.memoryApprove,
                    onPressed: onApprove,
                    icon: const Icon(Icons.check_circle_outline),
                  ),
                if (onEdit != null)
                  IconButton(
                    key: Key('memory-edit-${memory.id}'),
                    tooltip: l10n.edit,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                if (onLock != null)
                  IconButton(
                    key: Key('memory-lock-${memory.id}'),
                    tooltip:
                        memory.locked ? l10n.memoryUnlock : l10n.memoryLock,
                    onPressed: onLock,
                    icon: Icon(
                        memory.locked ? Icons.lock_open : Icons.lock_outline),
                  ),
                if (onSource != null)
                  IconButton(
                    key: Key('memory-source-${memory.id}'),
                    tooltip: l10n.memoryOpenSource,
                    onPressed: onSource,
                    icon: const Icon(Icons.open_in_new),
                  ),
                if (onIgnore != null)
                  IconButton(
                    key: Key('memory-ignore-${memory.id}'),
                    tooltip: l10n.memoryIgnore,
                    onPressed: onIgnore,
                    icon: const Icon(Icons.visibility_off_outlined),
                  ),
                if (onDelete != null)
                  IconButton(
                    key: Key('memory-delete-${memory.id}'),
                    tooltip: l10n.memoryDelete,
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _MemoryDraft {
  const _MemoryDraft({
    required this.kind,
    required this.content,
    required this.identityKey,
    required this.importance,
    required this.locked,
    this.chatId,
  });

  final MemoryKind kind;
  final String content;
  final String identityKey;
  final double importance;
  final bool locked;
  final String? chatId;
}

class _MemoryEditorDialog extends StatefulWidget {
  const _MemoryEditorDialog({
    required this.title,
    this.memory,
    this.chats = const [],
    this.initialContent,
  });

  final String title;
  final LongTermMemory? memory;
  final List<Chat> chats;
  final String? initialContent;

  @override
  State<_MemoryEditorDialog> createState() => _MemoryEditorDialogState();
}

class _MemoryEditorDialogState extends State<_MemoryEditorDialog> {
  late final TextEditingController _content;
  late final TextEditingController _identity;
  late MemoryKind _kind;
  late double _importance;
  late bool _locked;
  String? _chatId;

  @override
  void initState() {
    super.initState();
    _content = TextEditingController(
      text: widget.initialContent ?? widget.memory?.content ?? '',
    );
    _identity = TextEditingController(
      text: widget.memory?.normalizedIdentityKey ?? '',
    );
    _kind = widget.memory?.kind ?? MemoryKind.other;
    _importance = widget.memory?.importance ?? LongTermMemory.defaultImportance;
    _locked = widget.memory?.locked ?? false;
    _chatId = widget.chats.firstOrNull?.id;
  }

  @override
  void dispose() {
    _content.dispose();
    _identity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.chats.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  key: const Key('memory-editor-chat'),
                  initialValue: _chatId,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.memoryChatScope),
                  items: widget.chats
                      .map(
                        (chat) => DropdownMenuItem(
                          value: chat.id,
                          child: Text(
                            chat.title.trim().isEmpty ? chat.id : chat.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _chatId = value),
                ),
                const SizedBox(height: 12),
              ],
              DropdownButtonFormField<MemoryKind>(
                key: const Key('memory-editor-kind'),
                initialValue: _kind,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.memoryKind),
                items: MemoryKind.values
                    .map(
                      (kind) => DropdownMenuItem(
                        value: kind,
                        child: Text(_kindLabel(l10n, kind)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _kind = value ?? _kind),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('memory-editor-content'),
                controller: _content,
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: l10n.memoryLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('memory-editor-identity'),
                controller: _identity,
                decoration: InputDecoration(
                  labelText: l10n.memoryIdentityKey,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(l10n.memoryImportance),
                  Expanded(
                    child: Slider(
                      value: _importance,
                      divisions: 10,
                      label: '${(_importance * 100).round()}%',
                      onChanged: (value) => setState(() => _importance = value),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.memoryLocked),
                value: _locked,
                onChanged: (value) => setState(() => _locked = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('memory-editor-save'),
          onPressed: _content.text.trim().isEmpty ||
                  (widget.chats.isNotEmpty && _chatId == null)
              ? null
              : () => Navigator.pop(
                    context,
                    _MemoryDraft(
                      kind: _kind,
                      content: _content.text.trim(),
                      identityKey: _identity.text.trim(),
                      importance: _importance,
                      locked: _locked,
                      chatId: _chatId,
                    ),
                  ),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

String _kindLabel(AppLocalizations l10n, MemoryKind kind) {
  return switch (kind) {
    MemoryKind.personFact => l10n.memoryKindPersonFact,
    MemoryKind.relationship => l10n.memoryKindRelationship,
    MemoryKind.event => l10n.memoryKindEvent,
    MemoryKind.commitment => l10n.memoryKindCommitment,
    MemoryKind.preference => l10n.memoryKindPreference,
    MemoryKind.location => l10n.memoryKindLocation,
    MemoryKind.other => l10n.memoryKindOther,
  };
}

String _memoryScopeLabel(AppLocalizations l10n, MemoryScopeKind kind) {
  return switch (kind) {
    MemoryScopeKind.character => l10n.character,
    MemoryScopeKind.characterPersona => l10n.memoryScopeCharacterPersona,
    MemoryScopeKind.chat => l10n.chat,
    MemoryScopeKind.group => l10n.memoryScopeGroup,
  };
}

IconData _kindIcon(MemoryKind kind) {
  return switch (kind) {
    MemoryKind.personFact => Icons.person_outline,
    MemoryKind.relationship => Icons.people_outline,
    MemoryKind.event => Icons.event_outlined,
    MemoryKind.commitment => Icons.handshake_outlined,
    MemoryKind.preference => Icons.favorite_border,
    MemoryKind.location => Icons.place_outlined,
    MemoryKind.other => Icons.notes,
  };
}
