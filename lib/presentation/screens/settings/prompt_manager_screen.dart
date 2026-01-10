import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:native_tavern/data/models/prompt_manager.dart';
import 'package:native_tavern/presentation/providers/prompt_manager_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for managing prompt section order and visibility
class PromptManagerScreen extends ConsumerWidget {
  const PromptManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(promptManagerProvider);
    final sortedSections = config.sortedSections;
    final allPresets = ref.watch(allPresetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.promptManager),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: AppLocalizations.of(context)!.moreOptions,
            onSelected: (value) {
              switch (value) {
                case 'presets':
                  _showPresetsDialog(context, ref, allPresets);
                  break;
                case 'import':
                  _importPreset(context, ref);
                  break;
                case 'export':
                  _exportPreset(context, ref);
                  break;
                case 'save':
                  _saveAsPreset(context, ref);
                  break;
                case 'reset':
                  _showResetConfirmation(context, ref);
                  break;
                case 'help':
                  _showHelpDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'presets',
                child: ListTile(
                  leading: const Icon(Icons.list),
                  title: Text(AppLocalizations.of(context)!.loadPreset),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'save',
                child: ListTile(
                  leading: const Icon(Icons.save),
                  title: Text(AppLocalizations.of(context)!.saveAsPresetLabel),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'import',
                child: ListTile(
                  leading: const Icon(Icons.file_download),
                  title: Text(AppLocalizations.of(context)!.importPresetLabel),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: const Icon(Icons.file_upload),
                  title: Text(AppLocalizations.of(context)!.exportPreset),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'reset',
                child: ListTile(
                  leading: const Icon(Icons.restore),
                  title: Text(AppLocalizations.of(context)!.resetToDefault),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'help',
                child: ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(AppLocalizations.of(context)!.help),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.dragToReorder,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // Reorderable list
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: sortedSections.length,
              onReorder: (oldIndex, newIndex) {
                ref.read(promptManagerProvider.notifier).reorder(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final section = sortedSections[index];
                // Use a unique key that includes identifier for custom prompts
                final key = section.identifier != null
                    ? ValueKey('${section.identifier}_$index')
                    : ValueKey('${section.type.name}_$index');
                return _PromptSectionTile(
                  key: key,
                  section: section,
                  index: index,
                  onToggle: () {
                    // Use index-based toggle for custom prompts
                    if (section.isCustom) {
                      ref.read(promptManagerProvider.notifier).toggleSectionByIndex(index);
                    } else {
                      ref.read(promptManagerProvider.notifier).toggleSection(section.type);
                    }
                  },
                  onEdit: section.isEditable
                      ? () => _showEditContentDialog(context, ref, section, index)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPresetsDialog(BuildContext context, WidgetRef ref, List<PromptManagerPreset> presets) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.list, color: AppTheme.accentColor),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.loadPreset,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: presets.length,
                itemBuilder: (context, index) {
                  final preset = presets[index];
                  return ListTile(
                    leading: Icon(
                      preset.isBuiltIn ? Icons.lock : Icons.edit,
                      color: preset.isBuiltIn ? AppTheme.textMuted : AppTheme.accentColor,
                    ),
                    title: Text(preset.name),
                    subtitle: preset.description != null
                        ? Text(preset.description!, maxLines: 1, overflow: TextOverflow.ellipsis)
                        : null,
                    trailing: preset.isBuiltIn
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () {
                              ref.read(customPresetsProvider.notifier).deletePreset(preset.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(AppLocalizations.of(context)!.deleted(preset.name))),
                              );
                            },
                          ),
                    onTap: () {
                      ref.read(promptManagerProvider.notifier).applyPreset(preset);
                      ref.read(activePresetIdProvider.notifier).setActivePreset(preset.id);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.applied(preset.name))),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importPreset(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      String jsonString;

      if (file.bytes != null) {
        jsonString = utf8.decode(file.bytes!);
      } else if (file.path != null) {
        jsonString = await File(file.path!).readAsString();
      } else {
        throw Exception('Could not read file');
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      // Check if it's a valid preset format
      if (json['sections'] != null || json['format'] == 'native_tavern_prompt_preset') {
        // Import as preset
        final preset = await ref.read(customPresetsProvider.notifier).importPreset(json);
        ref.read(promptManagerProvider.notifier).applyPreset(preset);
        ref.read(activePresetIdProvider.notifier).setActivePreset(preset.id);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.imported(preset.name))),
          );
        }
      } else {
        throw Exception(AppLocalizations.of(context)!.invalidPresetFormatMessage);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.importPresetFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _exportPreset(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController(text: 'My Prompt Preset');

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.exportPresetTitle),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.presetNameLabel,
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: Text(AppLocalizations.of(context)!.export),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    try {
      final json = ref.read(promptManagerProvider.notifier).exportToJson(name);
      final jsonString = const JsonEncoder.withIndent('  ').convert(json);

      // Save to temp file and share
      final tempDir = await getTemporaryDirectory();
      final fileName = '${name.replaceAll(RegExp(r'[^\w\s-]'), '_')}.json';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(jsonString);

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'NativeTavern Prompt Preset: $name',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.exportPresetFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _saveAsPreset(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.saveAsPreset),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.presetName,
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.descriptionOptional,
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnterNameMessage)),
                );
                return;
              }
              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'description': descController.text.trim(),
              });
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );

    if (result == null) return;

    try {
      final config = ref.read(promptManagerProvider);
      final preset = await ref.read(customPresetsProvider.notifier).saveCurrentAsPreset(
        config,
        result['name']!,
        result['description']!.isEmpty ? null : result['description'],
      );
      ref.read(activePresetIdProvider.notifier).setActivePreset(preset.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saved(preset.name))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.saveFailedMessage(e.toString()))),
        );
      }
    }
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetToDefault),
        content: Text(AppLocalizations.of(context)!.resetToDefaultQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(promptManagerProvider.notifier).resetToDefault();
              ref.read(activePresetIdProvider.notifier).setActivePreset(null);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.resetToDefaultConfig)),
              );
            },
            child: Text(AppLocalizations.of(context)!.reset),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.promptManagerHelp),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What is the Prompt Manager?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'The Prompt Manager controls how the system prompt is built when sending messages to the AI. '
                'You can customize the order of different sections and enable/disable them.',
              ),
              SizedBox(height: 16),
              Text(
                'Section Types:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• System Prompt: Base roleplay instructions'),
              Text('• User Persona: Your character information'),
              Text('• Character Description: The AI character\'s details'),
              Text('• Character Personality: Personality traits'),
              Text('• Scenario: Current situation and setting'),
              Text('• World Info: Contextual lore from lorebooks'),
              Text('• Example Messages: Sample dialogue for style'),
              Text('• Author\'s Note: Dynamic instructions'),
              Text('• Post-History: Instructions after chat'),
              SizedBox(height: 16),
              Text(
                'Tips:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Sections at the top have higher priority'),
              Text('• Disable sections you don\'t need to save tokens'),
              Text('• Experiment with order for different results'),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showEditContentDialog(BuildContext context, WidgetRef ref, PromptSection section, int index) {
    final contentController = TextEditingController(
      text: section.content ?? PromptSection.getDefaultContent(section.type),
    );
    final nameController = TextEditingController(text: section.name);

    final displayName = section.isCustom ? section.name : PromptSection.getDisplayName(section.type);
    final description = section.isCustom
        ? 'Custom prompt from imported preset'
        : PromptSection.getDescription(section.type);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              section.isCustom ? Icons.code : Icons.edit,
              color: section.isCustom ? AppTheme.accentColor : AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Edit $displayName',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show name editor for custom prompts
                if (section.isCustom) ...[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Prompt Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (section.identifier != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${section.identifier}',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
                if (section.role != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Role: ${section.role}',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Supports macros: {{user}}, {{char}}, {{time}}, {{date}}, etc.',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: TextField(
                    controller: contentController,
                    maxLines: null,
                    minLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter prompt content...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (!section.isCustom)
            TextButton(
              onPressed: () {
                // Reset to default
                contentController.text = PromptSection.getDefaultContent(section.type);
              },
              child: const Text('Reset to Default'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () {
              final newContent = contentController.text.trim();
              final newName = nameController.text.trim();
              
              if (section.isCustom) {
                // Update custom prompt with new name and content
                ref.read(promptManagerProvider.notifier).updateSectionByIndex(
                  index,
                  section.copyWith(
                    name: newName.isNotEmpty ? newName : section.name,
                    content: newContent,
                  ),
                );
              } else {
                // Update built-in prompt content
                ref.read(promptManagerProvider.notifier).updateSectionContent(
                  section.type,
                  newContent,
                );
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Updated ${section.isCustom ? newName : displayName}'),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

class _PromptSectionTile extends StatelessWidget {
  final PromptSection section;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback? onEdit;

  const _PromptSectionTile({
    super.key,
    required this.section,
    required this.index,
    required this.onToggle,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine display name and description
    final displayName = section.isCustom
        ? section.name
        : PromptSection.getDisplayName(section.type);
    final description = section.isCustom
        ? (section.content?.isNotEmpty == true
            ? '${section.content!.substring(0, section.content!.length.clamp(0, 50))}...'
            : 'Custom prompt')
        : PromptSection.getDescription(section.type);

    // Determine icon based on type
    IconData typeIcon;
    if (section.isCustom) {
      typeIcon = Icons.code;
    } else {
      switch (section.type) {
        case PromptSectionType.systemPrompt:
          typeIcon = Icons.settings_system_daydream;
          break;
        case PromptSectionType.persona:
          typeIcon = Icons.person;
          break;
        case PromptSectionType.characterDescription:
        case PromptSectionType.characterPersonality:
          typeIcon = Icons.face;
          break;
        case PromptSectionType.characterScenario:
          typeIcon = Icons.landscape;
          break;
        case PromptSectionType.exampleMessages:
          typeIcon = Icons.chat_bubble_outline;
          break;
        case PromptSectionType.worldInfo:
        case PromptSectionType.worldInfoAfter:
          typeIcon = Icons.public;
          break;
        case PromptSectionType.authorNote:
          typeIcon = Icons.note;
          break;
        case PromptSectionType.postHistoryInstructions:
          typeIcon = Icons.history;
          break;
        case PromptSectionType.nsfw:
          typeIcon = Icons.warning;
          break;
        case PromptSectionType.chatHistory:
          typeIcon = Icons.forum;
          break;
        case PromptSectionType.enhanceDefinitions:
          typeIcon = Icons.auto_fix_high;
          break;
        default:
          typeIcon = Icons.text_snippet;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: section.enabled
          ? colorScheme.surface
          : colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.drag_handle,
                color: section.enabled ? AppTheme.textSecondary : AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Icon(
                typeIcon,
                size: 20,
                color: section.isCustom
                    ? (section.enabled ? AppTheme.accentColor : AppTheme.textMuted)
                    : (section.enabled ? AppTheme.primaryColor : AppTheme.textMuted),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(
                  color: section.enabled ? AppTheme.textPrimary : AppTheme.textMuted,
                  fontWeight: section.enabled ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (section.isCustom)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Custom',
                  style: TextStyle(
                    fontSize: 10,
                    color: section.enabled ? AppTheme.accentColor : AppTheme.textMuted,
                  ),
                ),
              ),
            if (section.isEditable && !section.isCustom)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.edit_note,
                  size: 16,
                  color: section.enabled ? AppTheme.accentColor : AppTheme.textMuted,
                ),
              ),
          ],
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: section.enabled ? AppTheme.textSecondary : AppTheme.textMuted,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: section.enabled ? AppTheme.accentColor : AppTheme.textMuted,
                ),
                onPressed: section.enabled ? onEdit : null,
                tooltip: AppLocalizations.of(context)!.edit,
              ),
            Switch(
              value: section.enabled,
              onChanged: (_) => onToggle(),
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
        onTap: onEdit != null && section.enabled ? onEdit : null,
      ),
    );
  }
}