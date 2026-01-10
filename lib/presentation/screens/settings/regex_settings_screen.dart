import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:native_tavern/data/models/regex_script.dart';
import 'package:native_tavern/domain/services/regex_service.dart';
import 'package:native_tavern/presentation/providers/regex_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for managing regex scripts
class RegexSettingsScreen extends ConsumerWidget {
  const RegexSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(regexSettingsProvider);
    final scripts = ref.watch(globalRegexScriptsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.regexScripts),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.addScript,
            onPressed: () => _showScriptEditor(context, ref, null),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'add_presets',
                child: ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: Text(AppLocalizations.of(context)!.addPresets),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: const Icon(Icons.file_download),
                  title: Text(AppLocalizations.of(context)!.import),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: const Icon(Icons.file_upload),
                  title: Text(AppLocalizations.of(context)!.export),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'clear_all',
                child: ListTile(
                  leading: const Icon(Icons.delete_sweep, color: Colors.red),
                  title: Text(AppLocalizations.of(context)!.clearAll, style: const TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable/Disable toggle
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.general,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.enableRegexScripts),
                subtitle: Text(AppLocalizations.of(context)!.applyFindReplacePatterns),
                value: settings.enabled,
                onChanged: (value) {
                  ref.read(regexSettingsProvider.notifier).setEnabled(value);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Application settings
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.applyTo,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.userInput),
                subtitle: Text(AppLocalizations.of(context)!.applyBeforeSending),
                value: settings.applyToUserInput,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(regexSettingsProvider.notifier).setApplyToUserInput(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.aiOutput),
                subtitle: Text(AppLocalizations.of(context)!.applyToAiResponses),
                value: settings.applyToAiOutput,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(regexSettingsProvider.notifier).setApplyToAiOutput(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.slashCommandsLabel),
                subtitle: Text(AppLocalizations.of(context)!.applyDuringCommandProcessing),
                value: settings.applyToSlashCommands,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(regexSettingsProvider.notifier).setApplyToSlashCommands(value);
                      }
                    : null,
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.worldInfoLabel),
                subtitle: Text(AppLocalizations.of(context)!.applyToWorldInfoEntries),
                value: settings.applyToWorldInfo,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(regexSettingsProvider.notifier).setApplyToWorldInfo(value);
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Scripts list
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.scriptsCount(scripts.length),
            children: [
              if (scripts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.find_replace, size: 48, color: AppTheme.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.noRegexScripts,
                          style: const TextStyle(color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.tapToAddOrUseMenu,
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: scripts.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    ref.read(globalRegexScriptsProvider.notifier).reorderScripts(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final script = scripts[index];
                    return _RegexScriptTile(
                      key: ValueKey(script.id),
                      script: script,
                      onTap: () => _showScriptEditor(context, ref, script),
                      onToggle: () {
                        ref.read(globalRegexScriptsProvider.notifier).toggleScript(script.id);
                      },
                      onDelete: () => _confirmDelete(context, ref, script),
                    );
                  },
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Test section
          _buildSection(
            context: context,
            title: AppLocalizations.of(context)!.test,
            children: [
              const _RegexTestWidget(),
            ],
          ),

          const SizedBox(height: 16),

          // Info section
          _buildSection(
            context: context,
            title: 'Information',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text('About Regex Scripts'),
                subtitle: Text(
                  'Regex scripts allow you to find and replace text patterns in messages. '
                  'Use capture groups (\$1, \$2) in replacements.',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.code, color: AppTheme.textMuted),
                title: Text('Pattern Format'),
                subtitle: Text(
                  'Use /pattern/flags format (e.g., /hello/gi) or plain patterns. '
                  'Flags: i=case-insensitive, m=multiline, s=dotall',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: AppTheme.darkCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'add_presets':
        ref.read(globalRegexScriptsProvider.notifier).addPresets();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.presetScriptsAdded)),
        );
        break;
      case 'import':
        _showImportDialog(context, ref);
        break;
      case 'export':
        _showExportDialog(context, ref);
        break;
      case 'clear_all':
        _confirmClearAll(context, ref);
        break;
    }
  }

  void _showScriptEditor(BuildContext context, WidgetRef ref, RegexScript? script) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkCard,
      builder: (context) => _RegexScriptEditor(
        script: script,
        onSave: (newScript) {
          if (script == null) {
            ref.read(globalRegexScriptsProvider.notifier).addScript(newScript);
          } else {
            ref.read(globalRegexScriptsProvider.notifier).updateScript(newScript);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, RegexScript script) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteScript),
        content: Text(AppLocalizations.of(context)!.deleteScriptQuestion(script.scriptName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(globalRegexScriptsProvider.notifier).removeScript(script.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearAllScripts),
        content: Text(AppLocalizations.of(context)!.clearAllScriptsQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(globalRegexScriptsProvider.notifier).clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.clearAll),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonContent = await file.readAsString();
        
        final count = await ref.read(globalRegexScriptsProvider.notifier).importScripts(jsonContent);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.importedCount(count))),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    final json = ref.read(globalRegexScriptsProvider.notifier).exportScripts();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.exportScripts),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                json,
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: json));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.copiedToClipboard)),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(AppLocalizations.of(context)!.copy),
          ),
        ],
      ),
    );
  }
}

/// Tile for displaying a regex script
class _RegexScriptTile extends StatelessWidget {
  final RegexScript script;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _RegexScriptTile({
    super.key,
    required this.script,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.find_replace,
        color: script.disabled ? AppTheme.textMuted : AppTheme.accentColor,
      ),
      title: Text(
        script.scriptName,
        style: TextStyle(
          color: script.disabled ? AppTheme.textMuted : null,
          decoration: script.disabled ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        script.findRegex,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'monospace',
          color: AppTheme.textMuted,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              script.disabled ? Icons.toggle_off : Icons.toggle_on,
              color: script.disabled ? AppTheme.textMuted : AppTheme.accentColor,
            ),
            onPressed: onToggle,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
          const Icon(Icons.drag_handle, color: AppTheme.textMuted),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// Editor for creating/editing regex scripts
class _RegexScriptEditor extends StatefulWidget {
  final RegexScript? script;
  final void Function(RegexScript) onSave;

  const _RegexScriptEditor({
    this.script,
    required this.onSave,
  });

  @override
  State<_RegexScriptEditor> createState() => _RegexScriptEditorState();
}

class _RegexScriptEditorState extends State<_RegexScriptEditor> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _findController;
  late TextEditingController _replaceController;
  late List<RegexPlacement> _placement;
  late bool _markdownOnly;
  late bool _promptOnly;
  late bool _runOnEdit;
  late SubstituteRegex _substituteRegex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.script?.scriptName ?? '');
    _descriptionController = TextEditingController(text: widget.script?.description ?? '');
    _findController = TextEditingController(text: widget.script?.findRegex ?? '');
    _replaceController = TextEditingController(text: widget.script?.replaceString ?? '');
    _placement = widget.script?.placement ?? [RegexPlacement.aiOutput];
    _markdownOnly = widget.script?.markdownOnly ?? false;
    _promptOnly = widget.script?.promptOnly ?? false;
    _runOnEdit = widget.script?.runOnEdit ?? false;
    _substituteRegex = widget.script?.substituteRegex ?? SubstituteRegex.none;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _findController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.script == null ? AppLocalizations.of(context)!.newScript : AppLocalizations.of(context)!.editScript,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _save,
                      child: Text(AppLocalizations.of(context)!.save),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Form
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Script Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _findController,
                      decoration: const InputDecoration(
                        labelText: 'Find Pattern',
                        hintText: '/pattern/flags or plain pattern',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _replaceController,
                      decoration: const InputDecoration(
                        labelText: 'Replace With',
                        hintText: r'Use $1, $2 for capture groups',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Apply To',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: RegexPlacement.values.map((p) {
                        final selected = _placement.contains(p);
                        return FilterChip(
                          label: Text(p.displayName),
                          selected: selected,
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                _placement.add(p);
                              } else {
                                _placement.remove(p);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Options',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SwitchListTile(
                      title: const Text('Markdown Only'),
                      subtitle: const Text('Only apply during markdown rendering'),
                      value: _markdownOnly,
                      onChanged: (value) => setState(() => _markdownOnly = value),
                    ),
                    SwitchListTile(
                      title: const Text('Prompt Only'),
                      subtitle: const Text('Only apply during prompt generation'),
                      value: _promptOnly,
                      onChanged: (value) => setState(() => _promptOnly = value),
                    ),
                    SwitchListTile(
                      title: const Text('Run on Edit'),
                      subtitle: const Text('Apply when editing messages'),
                      value: _runOnEdit,
                      onChanged: (value) => setState(() => _runOnEdit = value),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<SubstituteRegex>(
                      value: _substituteRegex,
                      decoration: const InputDecoration(
                        labelText: 'Macro Substitution',
                        border: OutlineInputBorder(),
                      ),
                      items: SubstituteRegex.values.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _substituteRegex = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _save() {
    if (_nameController.text.isEmpty || _findController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and pattern are required')),
      );
      return;
    }

    final script = createRegexScript(
      scriptName: _nameController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      findRegex: _findController.text,
      replaceString: _replaceController.text,
      placement: _placement,
      markdownOnly: _markdownOnly,
      promptOnly: _promptOnly,
      runOnEdit: _runOnEdit,
      substituteRegex: _substituteRegex,
    );

    if (widget.script != null) {
      widget.onSave(script.copyWith(
        id: widget.script!.id,
        order: widget.script!.order,
        createdAt: widget.script!.createdAt,
      ));
    } else {
      widget.onSave(script);
    }
  }
}

/// Widget for testing regex patterns
class _RegexTestWidget extends ConsumerStatefulWidget {
  const _RegexTestWidget();

  @override
  ConsumerState<_RegexTestWidget> createState() => _RegexTestWidgetState();
}

class _RegexTestWidgetState extends ConsumerState<_RegexTestWidget> {
  final _patternController = TextEditingController();
  final _testController = TextEditingController();
  final _replaceController = TextEditingController();
  RegexTestResult? _result;

  @override
  void dispose() {
    _patternController.dispose();
    _testController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  void _test() {
    final service = ref.read(regexServiceProvider);
    setState(() {
      _result = service.testRegex(
        _patternController.text,
        _testController.text,
        _replaceController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _patternController,
            decoration: const InputDecoration(
              labelText: 'Pattern',
              hintText: '/pattern/flags',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _testController,
            decoration: const InputDecoration(
              labelText: 'Test String',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _replaceController,
            decoration: const InputDecoration(
              labelText: 'Replacement',
              hintText: r'$1, $2, {{match}}',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _test,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Test'),
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _result!.success
                    ? AppTheme.accentColor.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _result!.success ? AppTheme.accentColor : Colors.red,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _result!.success ? Icons.check : Icons.error,
                        size: 16,
                        color: _result!.success ? AppTheme.accentColor : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _result!.success
                            ? '${_result!.matches.length} match(es)'
                            : 'Error',
                        style: TextStyle(
                          color: _result!.success ? AppTheme.accentColor : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (_result!.error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _result!.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  if (_result!.success) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Result:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.darkBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SelectableText(
                        _result!.result,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}