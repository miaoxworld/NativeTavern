import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/variables_service.dart';
import 'package:native_tavern/presentation/providers/variables_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for managing variables
class VariablesSettingsScreen extends ConsumerWidget {
  final String? chatId;

  const VariablesSettingsScreen({super.key, this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalVars = ref.watch(globalVariablesProvider);
    final localVars = chatId != null ? ref.watch(localVariablesProvider(chatId!)) : <String, dynamic>{};

    return Scaffold(
      appBar: AppBar(
        title: Text(chatId != null ? AppLocalizations.of(context)!.chatVariables : AppLocalizations.of(context)!.variables),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.addVariable,
            onPressed: () => _showAddVariableDialog(context, ref),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_global',
                child: ListTile(
                  leading: Icon(Icons.delete_sweep),
                  title: Text('Clear Global Variables'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (chatId != null)
                const PopupMenuItem(
                  value: 'clear_local',
                  child: ListTile(
                    leading: Icon(Icons.delete_sweep),
                    title: Text('Clear Local Variables'),
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
          // Info section
          _buildSection(
            title: 'About Variables',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text('Variable System'),
                subtitle: Text(
                  'Variables store values that can be used in macros. '
                  'Global variables persist across all chats, while local variables are per-chat.',
                ),
              ),
              const ListTile(
                leading: Icon(Icons.code, color: AppTheme.textMuted),
                title: Text('Macro Usage'),
                subtitle: Text(
                  '{{getvar::name}} - Get local variable\n'
                  '{{setvar::name::value}} - Set local variable\n'
                  '{{getglobalvar::name}} - Get global variable\n'
                  '{{setglobalvar::name::value}} - Set global variable',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Global variables
          _buildSection(
            title: 'Global Variables (${globalVars.length})',
            children: [
              if (globalVars.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.data_object, size: 48, color: AppTheme.textMuted),
                        SizedBox(height: 16),
                        Text(
                          'No global variables',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...globalVars.entries.map((entry) => _VariableTile(
                  name: entry.key,
                  value: entry.value,
                  isGlobal: true,
                  onEdit: () => _showEditVariableDialog(context, ref, entry.key, entry.value, true),
                  onDelete: () => _confirmDeleteVariable(context, ref, entry.key, true),
                  onIncrement: () => ref.read(globalVariablesProvider.notifier).increment(entry.key),
                  onDecrement: () => ref.read(globalVariablesProvider.notifier).decrement(entry.key),
                )),
            ],
          ),

          if (chatId != null) ...[
            const SizedBox(height: 16),

            // Local variables
            _buildSection(
              title: 'Local Variables (${localVars.length})',
              children: [
                if (localVars.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.data_object, size: 48, color: AppTheme.textMuted),
                          SizedBox(height: 16),
                          Text(
                            'No local variables for this chat',
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...localVars.entries.map((entry) => _VariableTile(
                    name: entry.key,
                    value: entry.value,
                    isGlobal: false,
                    onEdit: () => _showEditVariableDialog(context, ref, entry.key, entry.value, false),
                    onDelete: () => _confirmDeleteVariable(context, ref, entry.key, false),
                    onIncrement: () => ref.read(localVariablesProvider(chatId!).notifier).increment(entry.key),
                    onDecrement: () => ref.read(localVariablesProvider(chatId!).notifier).decrement(entry.key),
                  )),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Test section
          _buildSection(
            title: 'Test',
            children: [
              _VariableTestWidget(chatId: chatId),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
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
      case 'clear_global':
        _confirmClearVariables(context, ref, true);
        break;
      case 'clear_local':
        if (chatId != null) {
          _confirmClearVariables(context, ref, false);
        }
        break;
    }
  }

  void _showAddVariableDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    bool isGlobal = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Variable'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Variable Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (chatId != null)
                Row(
                  children: [
                    const Text('Scope: '),
                    ChoiceChip(
                      label: const Text('Global'),
                      selected: isGlobal,
                      onSelected: (selected) => setState(() => isGlobal = true),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Local'),
                      selected: !isGlobal,
                      onSelected: (selected) => setState(() => isGlobal = false),
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final value = valueController.text;
                if (name.isNotEmpty) {
                  if (isGlobal) {
                    ref.read(globalVariablesProvider.notifier).setVariable(name, value);
                  } else if (chatId != null) {
                    ref.read(localVariablesProvider(chatId!).notifier).setVariable(name, value);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditVariableDialog(BuildContext context, WidgetRef ref, String name, dynamic value, bool isGlobal) {
    final valueController = TextEditingController(text: value?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit "$name"'),
        content: TextField(
          controller: valueController,
          decoration: const InputDecoration(
            labelText: 'Value',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newValue = valueController.text;
              if (isGlobal) {
                ref.read(globalVariablesProvider.notifier).setVariable(name, newValue);
              } else if (chatId != null) {
                ref.read(localVariablesProvider(chatId!).notifier).setVariable(name, newValue);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteVariable(BuildContext context, WidgetRef ref, String name, bool isGlobal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Variable'),
        content: Text('Delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isGlobal) {
                ref.read(globalVariablesProvider.notifier).deleteVariable(name);
              } else if (chatId != null) {
                ref.read(localVariablesProvider(chatId!).notifier).deleteVariable(name);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmClearVariables(BuildContext context, WidgetRef ref, bool isGlobal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear ${isGlobal ? 'Global' : 'Local'} Variables'),
        content: Text('This will delete all ${isGlobal ? 'global' : 'local'} variables. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isGlobal) {
                ref.read(globalVariablesProvider.notifier).clearAll();
              } else if (chatId != null) {
                ref.read(localVariablesProvider(chatId!).notifier).clearAll();
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

/// Tile for displaying a variable
class _VariableTile extends StatelessWidget {
  final String name;
  final dynamic value;
  final bool isGlobal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _VariableTile({
    required this.name,
    required this.value,
    required this.isGlobal,
    required this.onEdit,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  });

  String get _valueType {
    if (value == null) return 'null';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is String) {
      final num = double.tryParse(value as String);
      if (num != null) return 'number';
      return 'string';
    }
    if (value is List) return 'array';
    if (value is Map) return 'object';
    return value.runtimeType.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isGlobal ? Icons.public : Icons.chat_bubble_outline,
        color: isGlobal ? AppTheme.accentColor : Colors.orange,
      ),
      title: Row(
        children: [
          Text(name),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _valueType,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textMuted,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        value?.toString() ?? 'null',
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: onDecrement,
            tooltip: 'Decrement',
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: onIncrement,
            tooltip: 'Increment',
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      onTap: onEdit,
    );
  }
}

/// Widget for testing variable macros
class _VariableTestWidget extends ConsumerStatefulWidget {
  final String? chatId;

  const _VariableTestWidget({this.chatId});

  @override
  ConsumerState<_VariableTestWidget> createState() => _VariableTestWidgetState();
}

class _VariableTestWidgetState extends ConsumerState<_VariableTestWidget> {
  final _inputController = TextEditingController();
  String? _result;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    final service = ref.read(variablesServiceProvider);
    final result = await service.processVariableMacros(
      _inputController.text,
      chatId: widget.chatId,
    );
    setState(() {
      _result = result;
    });
    // Refresh providers to show any changes
    ref.read(globalVariablesProvider.notifier).refresh();
    if (widget.chatId != null) {
      ref.read(localVariablesProvider(widget.chatId!).notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              labelText: 'Test Input',
              hintText: '{{setvar::counter::0}} Counter: {{getvar::counter}}',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _test,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Process Macros'),
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check, size: 16, color: AppTheme.accentColor),
                      SizedBox(width: 8),
                      Text(
                        'Result',
                        style: TextStyle(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: SelectableText(
                      _result!.isEmpty ? '(empty string)' : _result!,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _result!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied to clipboard')),
                          );
                        },
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}