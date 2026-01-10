import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_tavern/data/models/sprite.dart';
import 'package:native_tavern/presentation/providers/sprite_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/chat/sprite_display.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Screen for managing sprite settings
class SpriteSettingsScreen extends ConsumerWidget {
  const SpriteSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(spriteSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expression Sprites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: () {
              ref.read(spriteSettingsProvider.notifier).reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable/Disable toggle
          _buildSection(
            title: 'General',
            children: [
              SwitchListTile(
                title: const Text('Enable Sprites'),
                subtitle: const Text('Show character expression images in chat'),
                value: settings.enabled,
                onChanged: (value) {
                  ref.read(spriteSettingsProvider.notifier).setEnabled(value);
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Display settings
          _buildSection(
            title: 'Display',
            children: [
              // Size slider
              ListTile(
                title: const Text('Sprite Size'),
                subtitle: Slider(
                  value: settings.size,
                  min: 50,
                  max: 400,
                  divisions: 35,
                  label: '${settings.size.round()}px',
                  onChanged: settings.enabled
                      ? (value) {
                          ref.read(spriteSettingsProvider.notifier).setSize(value);
                        }
                      : null,
                ),
                trailing: Text(
                  '${settings.size.round()}px',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              // Position dropdown
              ListTile(
                title: const Text('Position'),
                subtitle: const Text('Where to display sprites'),
                trailing: DropdownButton<SpritePosition>(
                  value: settings.position,
                  onChanged: settings.enabled
                      ? (value) {
                          if (value != null) {
                            ref.read(spriteSettingsProvider.notifier).setPosition(value);
                          }
                        }
                      : null,
                  items: SpritePosition.values.map((pos) {
                    return DropdownMenuItem(
                      value: pos,
                      child: Text(_getPositionName(pos)),
                    );
                  }).toList(),
                ),
              ),

              // Opacity slider
              ListTile(
                title: const Text('Opacity'),
                subtitle: Slider(
                  value: settings.opacity,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: '${(settings.opacity * 100).round()}%',
                  onChanged: settings.enabled
                      ? (value) {
                          ref.read(spriteSettingsProvider.notifier).setOpacity(value);
                        }
                      : null,
                ),
                trailing: Text(
                  '${(settings.opacity * 100).round()}%',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Animation settings
          _buildSection(
            title: 'Animation',
            children: [
              SwitchListTile(
                title: const Text('Animate Transitions'),
                subtitle: const Text('Smooth fade when sprite changes'),
                value: settings.animateTransitions,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(spriteSettingsProvider.notifier).setAnimateTransitions(value);
                      }
                    : null,
              ),

              ListTile(
                title: const Text('Transition Duration'),
                subtitle: Slider(
                  value: settings.transitionDurationMs.toDouble(),
                  min: 0,
                  max: 1000,
                  divisions: 10,
                  label: '${settings.transitionDurationMs}ms',
                  onChanged: settings.enabled && settings.animateTransitions
                      ? (value) {
                          ref.read(spriteSettingsProvider.notifier)
                              .setTransitionDuration(value.round());
                        }
                      : null,
                ),
                trailing: Text(
                  '${settings.transitionDurationMs}ms',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              SwitchListTile(
                title: const Text('Show During Streaming'),
                subtitle: const Text('Display sprites while AI is generating'),
                value: settings.showDuringStreaming,
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(spriteSettingsProvider.notifier).setShowDuringStreaming(value);
                      }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Emotion detection info
          _buildSection(
            title: 'Emotion Detection',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppTheme.accentColor),
                title: Text('How it works'),
                subtitle: Text(
                  'Sprites are automatically selected based on emotion keywords detected in messages. '
                  'Action text like *smiles* or *laughs* is prioritized.',
                ),
              ),
              const Divider(),
              ExpansionTile(
                title: const Text('Supported Emotions'),
                children: SpriteEmotion.values.map((emotion) {
                  return ListTile(
                    dense: true,
                    title: Text(emotion.displayName),
                    subtitle: Text(
                      emotion.keywords.take(5).join(', ') +
                          (emotion.keywords.length > 5 ? '...' : ''),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  );
                }).toList(),
              ),
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

  String _getPositionName(SpritePosition position) {
    switch (position) {
      case SpritePosition.left:
        return 'Left';
      case SpritePosition.right:
        return 'Right';
      case SpritePosition.center:
        return 'Center';
      case SpritePosition.floatingLeft:
        return 'Floating Left';
      case SpritePosition.floatingRight:
        return 'Floating Right';
    }
  }
}

/// Screen for managing sprites for a specific character
class CharacterSpritesScreen extends ConsumerStatefulWidget {
  final String characterId;
  final String characterName;

  const CharacterSpritesScreen({
    super.key,
    required this.characterId,
    required this.characterName,
  });

  @override
  ConsumerState<CharacterSpritesScreen> createState() => _CharacterSpritesScreenState();
}

class _CharacterSpritesScreenState extends ConsumerState<CharacterSpritesScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedEmotion;

  @override
  Widget build(BuildContext context) {
    final packAsync = ref.watch(spritePackNotifierProvider(widget.characterId));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.characterName} Sprites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Import from folder',
            onPressed: _importFromFolder,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_all',
                child: ListTile(
                  leading: Icon(Icons.delete_sweep, color: Colors.red),
                  title: Text('Delete All Sprites'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete_all') {
                _confirmDeleteAll();
              }
            },
          ),
        ],
      ),
      body: packAsync.when(
        data: (pack) => _buildContent(pack),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSprite,
        icon: const Icon(Icons.add_photo_alternate),
        label: const Text('Add Sprite'),
      ),
    );
  }

  Widget _buildContent(SpritePack pack) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats card
        Card(
          color: AppTheme.darkCard,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.image, color: AppTheme.accentColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${pack.sprites.length} sprites',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (pack.defaultEmotion != null)
                        Text(
                          'Default: ${pack.defaultEmotion}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Sprites grid
        if (pack.hasSprites) ...[
          const Text(
            'Sprites',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SpriteGrid(
            characterId: widget.characterId,
            selectedEmotion: _selectedEmotion,
            onSelect: (sprite) {
              setState(() => _selectedEmotion = sprite.emotion);
              _showSpriteOptions(sprite);
            },
            onDelete: (sprite) => _confirmDeleteSprite(sprite),
          ),
        ] else ...[
          const SizedBox(height: 48),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 64,
                  color: AppTheme.textMuted.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No sprites yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add expression images for this character',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  Future<void> _addSprite() async {
    // First, select emotion
    final emotion = await _selectEmotion();
    if (emotion == null) return;

    // Then, pick image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // Add sprite
    await ref.read(spritePackNotifierProvider(widget.characterId).notifier)
        .addSprite(emotion, File(image.path));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $emotion sprite')),
      );
    }
  }

  Future<String?> _selectEmotion() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Emotion'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SpriteEmotion.values.length,
            itemBuilder: (context, index) {
              final emotion = SpriteEmotion.values[index];
              return ListTile(
                title: Text(emotion.displayName),
                subtitle: Text(
                  emotion.keywords.take(3).join(', '),
                  style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
                onTap: () => Navigator.pop(context, emotion.id),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSpriteOptions(Sprite sprite) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            
            // Preview
            SpritePreview(
              sprite: sprite,
              size: 120,
              showLabel: true,
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.star, color: AppTheme.accentColor),
              title: const Text('Set as Default'),
              onTap: () {
                Navigator.pop(context);
                ref.read(spritePackNotifierProvider(widget.characterId).notifier)
                    .setDefaultEmotion(sprite.emotion);
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Change Emotion'),
              onTap: () async {
                Navigator.pop(context);
                final newEmotion = await _selectEmotion();
                if (newEmotion != null && newEmotion != sprite.emotion) {
                  // Remove old and add new
                  await ref.read(spritePackNotifierProvider(widget.characterId).notifier)
                      .removeSprite(sprite.emotion);
                  await ref.read(spritePackNotifierProvider(widget.characterId).notifier)
                      .addSprite(newEmotion, File(sprite.imagePath));
                }
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteSprite(sprite);
              },
            ),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSprite(Sprite sprite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sprite'),
        content: Text('Delete the ${sprite.emotion} sprite?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(spritePackNotifierProvider(widget.characterId).notifier)
                  .removeSprite(sprite.emotion);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Sprites'),
        content: const Text(
          'Are you sure you want to delete all sprites for this character? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(spritePackNotifierProvider(widget.characterId).notifier)
                  .deleteAll();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Future<void> _importFromFolder() async {
    // Show info dialog about import
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Sprites'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import sprites from a folder. Files should be named with emotion keywords:',
            ),
            SizedBox(height: 12),
            Text('• happy.png, smile.jpg', style: TextStyle(fontSize: 12)),
            Text('• sad.png, cry.jpg', style: TextStyle(fontSize: 12)),
            Text('• angry.png, mad.jpg', style: TextStyle(fontSize: 12)),
            Text('• neutral.png, default.jpg', style: TextStyle(fontSize: 12)),
            SizedBox(height: 12),
            Text(
              'Supported formats: PNG, JPG, GIF, WebP',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Select Folder'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Note: Folder picking requires file_picker package
    // For now, show a message that this feature requires additional setup
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Folder import requires file_picker package'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}