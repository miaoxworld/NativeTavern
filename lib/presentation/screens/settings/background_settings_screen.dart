import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../data/models/chat_background.dart';
import '../../providers/background_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/chat/chat_background_widget.dart';

/// Screen for managing chat backgrounds
class BackgroundSettingsScreen extends ConsumerStatefulWidget {
  final String? characterId; // If set, editing character-specific background

  const BackgroundSettingsScreen({super.key, this.characterId});

  @override
  ConsumerState<BackgroundSettingsScreen> createState() => _BackgroundSettingsScreenState();
}

class _BackgroundSettingsScreenState extends ConsumerState<BackgroundSettingsScreen> {
  late ChatBackground _currentBackground;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentBackground();
  }

  void _loadCurrentBackground() {
    if (widget.characterId != null) {
      final charBg = ref.read(characterBackgroundProvider(widget.characterId!));
      _currentBackground = charBg ?? ChatBackground.none;
    } else {
      _currentBackground = ref.read(globalBackgroundProvider);
    }
  }

  Future<void> _saveBackground(ChatBackground background) async {
    setState(() => _currentBackground = background);
    
    if (widget.characterId != null) {
      await ref.read(characterBackgroundProvider(widget.characterId!).notifier)
          .setBackground(background);
    } else {
      await ref.read(globalBackgroundProvider.notifier).setBackground(background);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCharacterSpecific = widget.characterId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isCharacterSpecific ? 'Character Background' : 'Chat Background'),
        actions: [
          if (_currentBackground.type != BackgroundType.none)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear background',
              onPressed: () => _saveBackground(ChatBackground.none),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preview
          _buildPreviewSection(),
          const SizedBox(height: 24),

          // Preset gradients
          _buildSectionHeader('Gradient Presets'),
          const SizedBox(height: 8),
          _buildGradientPresets(),
          const SizedBox(height: 24),

          // Solid colors
          _buildSectionHeader('Solid Colors'),
          const SizedBox(height: 8),
          _buildColorPresets(),
          const SizedBox(height: 24),

          // Custom image
          _buildSectionHeader('Custom Image'),
          const SizedBox(height: 8),
          _buildImageSection(),
          const SizedBox(height: 24),

          // Adjustments
          if (_currentBackground.type != BackgroundType.none) ...[
            _buildSectionHeader('Adjustments'),
            const SizedBox(height: 8),
            _buildAdjustments(),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppTheme.accentColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_currentBackground.type != BackgroundType.none)
              _BackgroundPreviewFull(background: _currentBackground)
            else
              Container(
                color: AppTheme.darkBackground,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallpaper, size: 48, color: AppTheme.textMuted),
                      SizedBox(height: 8),
                      Text(
                        'No background selected',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            // Sample chat bubbles overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.darkCard.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Hello! How are you?',
                      style: TextStyle(color: AppTheme.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'I\'m doing great!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientPresets() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        BackgroundPreview(
          background: ChatBackground.none,
          selected: _currentBackground.type == BackgroundType.none,
          onTap: () => _saveBackground(ChatBackground.none),
        ),
        ...BackgroundPresets.gradients.map((bg) => BackgroundPreview(
          background: bg,
          selected: _currentBackground.type == BackgroundType.gradient &&
              _currentBackground.gradientColors?.join(',') == bg.gradientColors?.join(','),
          onTap: () => _saveBackground(bg),
        )),
      ],
    );
  }

  Widget _buildColorPresets() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: BackgroundPresets.solidColors.map((bg) => BackgroundPreview(
        background: bg,
        selected: _currentBackground.type == BackgroundType.color &&
            _currentBackground.color == bg.color,
        onTap: () => _saveBackground(bg),
      )).toList(),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Choose Image'),
                onPressed: _isLoading ? null : _pickImage,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.link),
                label: const Text('From URL'),
                onPressed: _isLoading ? null : _showUrlDialog,
              ),
            ),
          ],
        ),
        if (_currentBackground.type == BackgroundType.image) ...[
          const SizedBox(height: 12),
          Text(
            _currentBackground.imagePath != null
                ? 'Local image: ${p.basename(_currentBackground.imagePath!)}'
                : _currentBackground.imageUrl != null
                    ? 'URL: ${_currentBackground.imageUrl}'
                    : 'No image',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildAdjustments() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Opacity slider
            Row(
              children: [
                const Icon(Icons.opacity, size: 20),
                const SizedBox(width: 12),
                const Text('Opacity'),
                const Spacer(),
                Text('${(_currentBackground.opacity * 100).round()}%'),
              ],
            ),
            Slider(
              value: _currentBackground.opacity,
              min: 0.1,
              max: 1.0,
              divisions: 18,
              onChanged: (value) {
                _saveBackground(_currentBackground.copyWith(opacity: value));
              },
            ),
            const Divider(),
            
            // Blur toggle
            SwitchListTile(
              title: const Text('Blur Effect'),
              subtitle: const Text('Apply blur to the background'),
              value: _currentBackground.blur,
              onChanged: (value) {
                _saveBackground(_currentBackground.copyWith(blur: value));
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            // Blur amount slider
            if (_currentBackground.blur) ...[
              Row(
                children: [
                  const Icon(Icons.blur_on, size: 20),
                  const SizedBox(width: 12),
                  const Text('Blur Amount'),
                  const Spacer(),
                  Text('${_currentBackground.blurAmount.round()}'),
                ],
              ),
              Slider(
                value: _currentBackground.blurAmount,
                min: 1,
                max: 20,
                divisions: 19,
                onChanged: (value) {
                  _saveBackground(_currentBackground.copyWith(blurAmount: value));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          // Copy to app directory
          final appDir = await getApplicationDocumentsDirectory();
          final bgDir = Directory(p.join(appDir.path, 'NativeTavern', 'backgrounds'));
          await bgDir.create(recursive: true);

          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
          final destPath = p.join(bgDir.path, fileName);
          await File(file.path!).copy(destPath);

          await _saveBackground(ChatBackground.imagePath(
            destPath,
            opacity: _currentBackground.opacity,
            blur: _currentBackground.blur,
            blurAmount: _currentBackground.blurAmount,
          ));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showUrlDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter image URL',
            hintText: 'https://example.com/image.jpg',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                _saveBackground(ChatBackground.imageUrl(
                  url,
                  opacity: _currentBackground.opacity,
                  blur: _currentBackground.blur,
                  blurAmount: _currentBackground.blurAmount,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _BackgroundPreviewFull extends StatelessWidget {
  final ChatBackground background;

  const _BackgroundPreviewFull({required this.background});

  @override
  Widget build(BuildContext context) {
    switch (background.type) {
      case BackgroundType.none:
        return Container(color: AppTheme.darkBackground);

      case BackgroundType.color:
        return Container(color: _parseColor(background.color));

      case BackgroundType.gradient:
        final colors = background.gradientColors ?? ['#000000', '#333333'];
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors.map(_parseColor).toList(),
            ),
          ),
        );

      case BackgroundType.image:
        if (background.imagePath != null) {
          return Opacity(
            opacity: background.opacity,
            child: Image.file(
              File(background.imagePath!),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
            ),
          );
        }
        if (background.imageUrl != null) {
          return Opacity(
            opacity: background.opacity,
            child: Image.network(
              background.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
            ),
          );
        }
        return Container(color: Colors.grey[800]);
    }
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent;
    }

    String hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}