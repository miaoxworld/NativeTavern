import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/app_theme_config.dart';
import '../../providers/theme_providers.dart';
import '../../theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for managing app themes
class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allThemes = ref.watch(allThemesProvider);
    final activeThemeId = ref.watch(activeThemeIdProvider);
    // ignore: unused_local_variable
    final customThemes = ref.watch(customThemesProvider);

    // Separate built-in and custom themes
    final builtInThemes = allThemes.where((t) => t.isBuiltIn).toList();
    final userThemes = allThemes.where((t) => !t.isBuiltIn).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.themes),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: AppLocalizations.of(context)!.createCustomTheme,
            onPressed: () => _showCreateThemeDialog(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Built-in themes
          _buildSectionHeader(context, AppLocalizations.of(context)!.builtInThemes),
          const SizedBox(height: 12),
          _buildThemeGrid(context, ref, builtInThemes, activeThemeId),
          
          if (userThemes.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Custom Themes'),
            const SizedBox(height: 12),
            _buildThemeGrid(context, ref, userThemes, activeThemeId, isCustom: true),
          ],
          
          const SizedBox(height: 32),
          
          // Theme preview
          _buildSectionHeader(context, 'Preview'),
          const SizedBox(height: 12),
          _buildThemePreview(context, ref),
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

  Widget _buildThemeGrid(
    BuildContext context,
    WidgetRef ref,
    List<AppThemeConfig> themes,
    String activeThemeId, {
    bool isCustom = false,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final isActive = theme.id == activeThemeId;
        
        return _ThemeCard(
          theme: theme,
          isActive: isActive,
          isCustom: isCustom,
          onTap: () {
            ref.read(activeThemeIdProvider.notifier).setActiveTheme(theme.id);
          },
          onEdit: isCustom ? () => _showEditThemeDialog(context, ref, theme) : null,
          onDelete: isCustom ? () => _showDeleteConfirmation(context, ref, theme) : null,
        );
      },
    );
  }

  Widget _buildThemePreview(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeConfigProvider);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 200,
        color: activeTheme.background,
        child: Column(
          children: [
            // App bar preview
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: activeTheme.surface,
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: activeTheme.textPrimary, size: 20),
                  const SizedBox(width: 16),
                  Text(
                    'Chat Preview',
                    style: TextStyle(
                      color: activeTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.more_vert, color: activeTheme.textPrimary, size: 20),
                ],
              ),
            ),
            // Chat preview
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Assistant message
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: activeTheme.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Hello! How can I help you today?',
                        style: TextStyle(color: activeTheme.textPrimary, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // User message
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: activeTheme.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Tell me a story!',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Input preview
            Container(
              padding: const EdgeInsets.all(12),
              color: activeTheme.card,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: activeTheme.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Type a message...',
                        style: TextStyle(color: activeTheme.textSecondary, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: activeTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => _ThemeEditorDialog(
        onSave: (AppThemeConfig theme) {
          ref.read(customThemesProvider.notifier).addTheme(theme);
          ref.read(activeThemeIdProvider.notifier).setActiveTheme(theme.id);
        },
      ),
    );
  }

  void _showEditThemeDialog(BuildContext context, WidgetRef ref, AppThemeConfig theme) {
    showDialog<void>(
      context: context,
      builder: (context) => _ThemeEditorDialog(
        theme: theme,
        onSave: (AppThemeConfig updatedTheme) {
          ref.read(customThemesProvider.notifier).updateTheme(updatedTheme);
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, AppThemeConfig theme) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Theme'),
        content: Text('Are you sure you want to delete "${theme.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final activeId = ref.read(activeThemeIdProvider);
              if (activeId == theme.id) {
                ref.read(activeThemeIdProvider.notifier).setActiveTheme(BuiltInThemes.defaultDark.id);
              }
              ref.read(customThemesProvider.notifier).deleteTheme(theme.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final AppThemeConfig theme;
  final bool isActive;
  final bool isCustom;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _ThemeCard({
    required this.theme,
    required this.isActive,
    required this.isCustom,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: AppTheme.accentColor, width: 3)
              : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Color preview
            Expanded(
              child: Container(
                color: theme.background,
                child: Column(
                  children: [
                    // Top bar
                    Container(
                      height: 20,
                      color: theme.surface,
                    ),
                    // Content area
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              width: 40,
                              decoration: BoxDecoration(
                                color: theme.card,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 16,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: theme.accent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom bar
                    Container(
                      height: 16,
                      color: theme.card,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: theme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Name
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: AppTheme.darkCard,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      theme.name,
                      style: const TextStyle(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isActive)
                    const Icon(Icons.check_circle, size: 14, color: AppTheme.accentColor),
                  if (isCustom && !isActive)
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      iconSize: 14,
                      icon: const Icon(Icons.more_vert, size: 14),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') onEdit?.call();
                        if (value == 'delete') onDelete?.call();
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeEditorDialog extends StatefulWidget {
  final AppThemeConfig? theme;
  final void Function(AppThemeConfig) onSave;

  const _ThemeEditorDialog({
    this.theme,
    required this.onSave,
  });

  @override
  State<_ThemeEditorDialog> createState() => _ThemeEditorDialogState();
}

class _ThemeEditorDialogState extends State<_ThemeEditorDialog> {
  late TextEditingController _nameController;
  late bool _isDark;
  late String _primaryColor;
  late String _accentColor;
  late String _backgroundColor;
  late String _surfaceColor;
  late String _cardColor;

  @override
  void initState() {
    super.initState();
    final theme = widget.theme ?? BuiltInThemes.defaultDark;
    _nameController = TextEditingController(text: widget.theme?.name ?? 'My Theme');
    _isDark = theme.isDark;
    _primaryColor = theme.primaryColor;
    _accentColor = theme.accentColor;
    _backgroundColor = theme.backgroundColor;
    _surfaceColor = theme.surfaceColor;
    _cardColor = theme.cardColor;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.theme != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Theme' : 'Create Theme'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Theme Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDark,
              onChanged: (value) => setState(() => _isDark = value),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            _ColorPickerTile(
              label: 'Primary Color',
              color: _primaryColor,
              onChanged: (color) => setState(() => _primaryColor = color),
            ),
            _ColorPickerTile(
              label: 'Accent Color',
              color: _accentColor,
              onChanged: (color) => setState(() => _accentColor = color),
            ),
            _ColorPickerTile(
              label: 'Background',
              color: _backgroundColor,
              onChanged: (color) => setState(() => _backgroundColor = color),
            ),
            _ColorPickerTile(
              label: 'Surface',
              color: _surfaceColor,
              onChanged: (color) => setState(() => _surfaceColor = color),
            ),
            _ColorPickerTile(
              label: 'Card',
              color: _cardColor,
              onChanged: (color) => setState(() => _cardColor = color),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final theme = AppThemeConfig(
              id: widget.theme?.id ?? const Uuid().v4(),
              name: _nameController.text.trim(),
              isDark: _isDark,
              primaryColor: _primaryColor,
              accentColor: _accentColor,
              backgroundColor: _backgroundColor,
              surfaceColor: _surfaceColor,
              cardColor: _cardColor,
              textPrimaryColor: _isDark ? '#FFFFFF' : '#171717',
              textSecondaryColor: _isDark ? '#A3A3A3' : '#737373',
              dividerColor: _isDark ? '#404040' : '#E5E5E5',
              isBuiltIn: false,
            );
            widget.onSave(theme);
            Navigator.pop(context);
          },
          child: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}

class _ColorPickerTile extends StatelessWidget {
  final String label;
  final String color;
  final void Function(String) onChanged;

  const _ColorPickerTile({
    required this.label,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          GestureDetector(
            onTap: () => _showColorPicker(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppThemeConfig.hexToColor(color),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    final controller = TextEditingController(text: color);
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select $label'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Hex Color',
                hintText: '#RRGGBB',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '#6366F1', '#8B5CF6', '#EC4899', '#EF4444',
                '#F97316', '#EAB308', '#22C55E', '#06B6D4',
                '#3B82F6', '#000000', '#1A1A1A', '#FFFFFF',
              ].map((c) => GestureDetector(
                onTap: () {
                  controller.text = c;
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppThemeConfig.hexToColor(c),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              onChanged(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}