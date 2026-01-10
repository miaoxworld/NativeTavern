import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/logit_bias.dart';
import 'package:native_tavern/domain/services/logit_bias_service.dart';
import 'package:native_tavern/presentation/providers/logit_bias_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Settings screen for Logit Bias configuration
class LogitBiasSettingsScreen extends ConsumerStatefulWidget {
  const LogitBiasSettingsScreen({super.key});

  @override
  ConsumerState<LogitBiasSettingsScreen> createState() => _LogitBiasSettingsScreenState();
}

class _LogitBiasSettingsScreenState extends ConsumerState<LogitBiasSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Create default preset if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(logitBiasSettingsProvider.notifier).createDefaultPresetIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(logitBiasSettingsProvider);
    final service = ref.watch(logitBiasServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.logitBias),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context, service),
            tooltip: AppLocalizations.of(context)!.help,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable toggle
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.enableLogitBias),
            subtitle: Text(AppLocalizations.of(context)!.adjustTokenProbabilities),
            value: settings.enabled,
            onChanged: (value) {
              ref.read(logitBiasSettingsProvider.notifier).setEnabled(value);
            },
          ),
          const Divider(height: 32),

          // Preset selector
          _buildSectionHeader(context, AppLocalizations.of(context)!.presets),
          const SizedBox(height: 8),
          _PresetSelector(
            presets: settings.presets,
            activePresetId: settings.activePresetId,
            onPresetSelected: (id) {
              ref.read(logitBiasSettingsProvider.notifier).setActivePreset(id);
            },
            onAddPreset: () => _showAddPresetDialog(context),
            onEditPreset: (preset) => _showEditPresetDialog(context, preset),
            onDeletePreset: (id) => _confirmDeletePreset(context, id),
            onDuplicatePreset: (id) {
              ref.read(logitBiasSettingsProvider.notifier).duplicatePreset(id);
            },
            onExportPreset: (id) => _exportPreset(context, id),
            onImportPreset: () => _importPreset(context),
          ),

          if (settings.activePreset != null) ...[
            const Divider(height: 32),
            _buildSectionHeader(context, AppLocalizations.of(context)!.biasEntries),
            const SizedBox(height: 8),
            _BiasEntriesList(
              entries: settings.activePreset!.entries,
              onAddEntry: () {
                final entry = LogitBiasEntry.create();
                ref.read(logitBiasSettingsProvider.notifier).addEntry(entry);
              },
              onUpdateEntry: (entry) {
                ref.read(logitBiasSettingsProvider.notifier).updateEntry(entry);
              },
              onDeleteEntry: (id) {
                ref.read(logitBiasSettingsProvider.notifier).deleteEntry(id);
              },
              onToggleEntry: (id) {
                ref.read(logitBiasSettingsProvider.notifier).toggleEntry(id);
              },
              onReorder: (oldIndex, newIndex) {
                ref.read(logitBiasSettingsProvider.notifier).reorderEntries(oldIndex, newIndex);
              },
            ),
          ],

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

  void _showHelpDialog(BuildContext context, LogitBiasService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logitBiasHelp),
        content: SingleChildScrollView(
          child: Text(service.getHelpText()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void _showAddPresetDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.newPreset),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.presetName,
            hintText: AppLocalizations.of(context)!.enterPresetName,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final preset = LogitBiasPreset.create(name: controller.text.trim());
                ref.read(logitBiasSettingsProvider.notifier).addPreset(preset);
                ref.read(logitBiasSettingsProvider.notifier).setActivePreset(preset.id);
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.create),
          ),
        ],
      ),
    );
  }

  void _showEditPresetDialog(BuildContext context, LogitBiasPreset preset) {
    final controller = TextEditingController(text: preset.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editPreset),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.presetName,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final updated = preset.copyWith(name: controller.text.trim());
                ref.read(logitBiasSettingsProvider.notifier).updatePreset(updated);
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePreset(BuildContext context, String presetId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deletePreset),
        content: Text(AppLocalizations.of(context)!.deletePresetQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(logitBiasSettingsProvider.notifier).deletePreset(presetId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _exportPreset(BuildContext context, String presetId) {
    try {
      final json = ref.read(logitBiasSettingsProvider.notifier).exportPreset(presetId);
      final jsonString = const JsonEncoder.withIndent('  ').convert(json);
      Clipboard.setData(ClipboardData(text: jsonString));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.presetCopiedToClipboard)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.exportPresetFailed(e.toString()))),
      );
    }
  }

  void _importPreset(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.importPresetLabel),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.json,
            hintText: AppLocalizations.of(context)!.pastePresetJson,
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              try {
                final json = jsonDecode(controller.text) as Map<String, dynamic>;
                ref.read(logitBiasSettingsProvider.notifier).importPreset(json);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.presetImportedSuccessfully)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.importPresetFailed(e.toString()))),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.import),
          ),
        ],
      ),
    );
  }
}

/// Widget for selecting and managing presets
class _PresetSelector extends StatelessWidget {
  final List<LogitBiasPreset> presets;
  final String? activePresetId;
  final ValueChanged<String?> onPresetSelected;
  final VoidCallback onAddPreset;
  final ValueChanged<LogitBiasPreset> onEditPreset;
  final ValueChanged<String> onDeletePreset;
  final ValueChanged<String> onDuplicatePreset;
  final ValueChanged<String> onExportPreset;
  final VoidCallback onImportPreset;

  const _PresetSelector({
    required this.presets,
    required this.activePresetId,
    required this.onPresetSelected,
    required this.onAddPreset,
    required this.onEditPreset,
    required this.onDeletePreset,
    required this.onDuplicatePreset,
    required this.onExportPreset,
    required this.onImportPreset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: activePresetId,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.activePresetLabel,
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(AppLocalizations.of(context)!.none),
                  ),
                  ...presets.map((preset) => DropdownMenuItem(
                        value: preset.id,
                        child: Text(preset.name),
                      )),
                ],
                onChanged: onPresetSelected,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAddPreset,
              tooltip: AppLocalizations.of(context)!.newPreset,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (action) {
                switch (action) {
                  case 'import':
                    onImportPreset();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'import',
                  child: ListTile(
                    leading: const Icon(Icons.file_download),
                    title: Text(AppLocalizations.of(context)!.importPresetLabel),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (activePresetId != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.edit, size: 18),
                label: Text(AppLocalizations.of(context)!.rename),
                onPressed: () {
                  final preset = presets.firstWhere((p) => p.id == activePresetId);
                  onEditPreset(preset);
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.copy, size: 18),
                label: Text(AppLocalizations.of(context)!.duplicate),
                onPressed: () => onDuplicatePreset(activePresetId!),
              ),
              TextButton.icon(
                icon: const Icon(Icons.file_upload, size: 18),
                label: Text(AppLocalizations.of(context)!.export),
                onPressed: () => onExportPreset(activePresetId!),
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete, size: 18),
                label: Text(AppLocalizations.of(context)!.delete),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => onDeletePreset(activePresetId!),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Widget for displaying and editing bias entries
class _BiasEntriesList extends StatelessWidget {
  final List<LogitBiasEntry> entries;
  final VoidCallback onAddEntry;
  final ValueChanged<LogitBiasEntry> onUpdateEntry;
  final ValueChanged<String> onDeleteEntry;
  final ValueChanged<String> onToggleEntry;
  final void Function(int oldIndex, int newIndex) onReorder;

  const _BiasEntriesList({
    required this.entries,
    required this.onAddEntry,
    required this.onUpdateEntry,
    required this.onDeleteEntry,
    required this.onToggleEntry,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entries.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.tune,
                    size: 48,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noBiasEntries,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(AppLocalizations.of(context)!.addEntriesToAdjust),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(AppLocalizations.of(context)!.addEntry),
                    onPressed: onAddEntry,
                  ),
                ],
              ),
            ),
          )
        else ...[
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            onReorder: onReorder,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _BiasEntryCard(
                key: ValueKey(entry.id),
                entry: entry,
                onUpdate: onUpdateEntry,
                onDelete: () => onDeleteEntry(entry.id),
                onToggle: () => onToggleEntry(entry.id),
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.addEntry),
            onPressed: onAddEntry,
          ),
        ],
      ],
    );
  }
}

/// Card widget for a single bias entry
class _BiasEntryCard extends ConsumerStatefulWidget {
  final LogitBiasEntry entry;
  final ValueChanged<LogitBiasEntry> onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _BiasEntryCard({
    super.key,
    required this.entry,
    required this.onUpdate,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  ConsumerState<_BiasEntryCard> createState() => _BiasEntryCardState();
}

class _BiasEntryCardState extends ConsumerState<_BiasEntryCard> {
  late TextEditingController _textController;
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.entry.text);
    _valueController = TextEditingController(text: widget.entry.value.toString());
  }

  @override
  void didUpdateWidget(_BiasEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.text != widget.entry.text) {
      _textController.text = widget.entry.text;
    }
    if (oldWidget.entry.value != widget.entry.value) {
      _valueController.text = widget.entry.value.toString();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validation = ref.watch(logitBiasValidationProvider(widget.entry));
    final service = ref.watch(logitBiasServiceProvider);
    final parsed = service.parseEntry(widget.entry);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Drag handle
                ReorderableDragStartListener(
                  index: 0,
                  child: Icon(
                    Icons.drag_handle,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 8),
                // Enable toggle
                Switch(
                  value: widget.entry.enabled,
                  onChanged: (_) => widget.onToggle(),
                ),
                const SizedBox(width: 8),
                // Text input
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.textOrToken,
                      hintText: 'word, {verbatim}, or [1234]',
                      isDense: true,
                      border: const OutlineInputBorder(),
                      errorText: validation.errors.isNotEmpty ? validation.errors.first : null,
                    ),
                    enabled: widget.entry.enabled,
                    onChanged: (value) {
                      widget.onUpdate(widget.entry.copyWith(text: value));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Value input
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.bias,
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    enabled: widget.entry.enabled,
                    onChanged: (value) {
                      final parsed = double.tryParse(value);
                      if (parsed != null) {
                        widget.onUpdate(widget.entry.copyWith(value: parsed));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: widget.onDelete,
                  tooltip: AppLocalizations.of(context)!.delete,
                ),
              ],
            ),
            // Format indicator
            if (widget.entry.text.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const SizedBox(width: 48),
                  Icon(
                    _getFormatIcon(parsed.format),
                    size: 14,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    service.getFormatDescription(parsed.format),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ],
            // Warnings
            if (validation.warnings.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const SizedBox(width: 48),
                  Icon(
                    Icons.warning_amber,
                    size: 14,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      validation.warnings.first,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.orange[700],
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getFormatIcon(LogitBiasInputFormat format) {
    switch (format) {
      case LogitBiasInputFormat.text:
        return Icons.text_fields;
      case LogitBiasInputFormat.verbatim:
        return Icons.format_quote;
      case LogitBiasInputFormat.tokenIds:
        return Icons.numbers;
    }
  }
}