import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Screen for managing user personas
class PersonasScreen extends ConsumerWidget {
  const PersonasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personasAsync = ref.watch(personaNotifierProvider);
    final activePersonaAsync = ref.watch(activePersonaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Persona',
            onPressed: () => _showCreatePersonaDialog(context, ref),
          ),
        ],
      ),
      body: personasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(personaNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (personas) {
          if (personas.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          final activePersona = activePersonaAsync.valueOrNull;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: personas.length,
            itemBuilder: (context, index) {
              final persona = personas[index];
              final isActive = activePersona?.id == persona.id;

              return _PersonaCard(
                persona: persona,
                isActive: isActive,
                onTap: () => _setActivePersona(ref, persona.id),
                onEdit: () => _showEditPersonaDialog(context, ref, persona),
                onDelete: persona.isDefault
                    ? null
                    : () => _showDeleteConfirmation(context, ref, persona),
                onSetDefault: persona.isDefault
                    ? null
                    : () => _setDefaultPersona(ref, persona.id),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          const Text(
            'No personas yet',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a persona to represent yourself in chats',
            style: TextStyle(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreatePersonaDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Create Persona'),
          ),
        ],
      ),
    );
  }

  void _showCreatePersonaDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _PersonaDialog(
        title: 'Create Persona',
        onSave: (name, description, avatarPath) async {
          await ref.read(personaNotifierProvider.notifier).createPersona(
                name: name,
                description: description,
                avatarPath: avatarPath,
              );
        },
      ),
    );
  }

  void _showEditPersonaDialog(BuildContext context, WidgetRef ref, Persona persona) {
    showDialog(
      context: context,
      builder: (context) => _PersonaDialog(
        title: 'Edit Persona',
        initialName: persona.name,
        initialDescription: persona.description,
        initialAvatarPath: persona.avatarPath,
        onSave: (name, description, avatarPath) async {
          await ref.read(personaNotifierProvider.notifier).updatePersona(
                persona.copyWith(
                  name: name,
                  description: description,
                  avatarPath: avatarPath,
                ),
              );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Persona persona) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Persona'),
        content: Text('Are you sure you want to delete "${persona.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(personaNotifierProvider.notifier).deletePersona(persona.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setActivePersona(WidgetRef ref, String id) {
    ref.read(personaNotifierProvider.notifier).setActivePersona(id);
  }

  void _setDefaultPersona(WidgetRef ref, String id) {
    ref.read(personaNotifierProvider.notifier).setDefaultPersona(id);
  }
}

/// Card widget for displaying a persona
class _PersonaCard extends StatelessWidget {
  final Persona persona;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const _PersonaCard({
    required this.persona,
    required this.isActive,
    required this.onTap,
    required this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isActive ? AppTheme.primaryColor.withValues(alpha: 0.15) : AppTheme.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? const BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(),
              const SizedBox(width: 16),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            persona.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (persona.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (isActive && !persona.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (persona.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        persona.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppTheme.textMuted),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                    case 'default':
                      onSetDefault?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  if (onSetDefault != null)
                    const PopupMenuItem(
                      value: 'default',
                      child: ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Set as Default'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (persona.avatarPath != null) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: FileImage(File(persona.avatarPath!)),
      );
    }
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
      child: Text(
        persona.name.isNotEmpty ? persona.name[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}

/// Dialog for creating/editing a persona
class _PersonaDialog extends StatefulWidget {
  final String title;
  final String? initialName;
  final String? initialDescription;
  final String? initialAvatarPath;
  final Future<void> Function(String name, String description, String? avatarPath) onSave;

  const _PersonaDialog({
    required this.title,
    this.initialName,
    this.initialDescription,
    this.initialAvatarPath,
    required this.onSave,
  });

  @override
  State<_PersonaDialog> createState() => _PersonaDialogState();
}

class _PersonaDialogState extends State<_PersonaDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _avatarPath;
  bool _isSaving = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    _avatarPath = widget.initialAvatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Check if running on desktop platform
  bool get _isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar picker
            _buildAvatarPicker(),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter persona name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe this persona (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            const Text(
              'The description will be included in the system prompt to help the AI understand who you are.',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _showAvatarOptions,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              backgroundImage: _avatarPath != null
                  ? FileImage(File(_avatarPath!))
                  : null,
              child: _avatarPath == null
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.primaryColor,
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showAvatarOptions,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.darkCard,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions() {
    // On desktop, directly open file picker
    if (_isDesktop) {
      _pickImageFromFiles();
      return;
    }
    
    // On mobile, show options sheet
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
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.accentColor),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            if (_avatarPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Avatar', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _avatarPath = null);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Pick image from files using FilePicker (for desktop)
  Future<void> _pickImageFromFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        dialogTitle: 'Select Avatar Image',
      );
      
      if (result != null && result.files.isNotEmpty && result.files.first.path != null) {
        await _saveAvatarImage(result.files.first.path!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  /// Pick image from gallery (for mobile)
  Future<void> _pickImageFromGallery() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        await _saveAvatarImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  /// Take photo with camera (for mobile)
  Future<void> _takePhoto() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        await _saveAvatarImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take photo: $e')),
        );
      }
    }
  }

  /// Save avatar image to app's documents directory
  Future<void> _saveAvatarImage(String sourcePath) async {
    try {
      // Copy file to app's documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final avatarsDir = Directory(p.join(appDir.path, 'NativeTavern', 'avatars', 'personas'));
      await avatarsDir.create(recursive: true);
      
      const uuid = Uuid();
      final extension = p.extension(sourcePath);
      final newFileName = '${uuid.v4()}$extension';
      final newPath = p.join(avatarsDir.path, newFileName);
      
      // Copy file
      final sourceFile = File(sourcePath);
      await sourceFile.copy(newPath);
      
      setState(() {
        _avatarPath = newPath;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save avatar: $e')),
        );
      }
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.onSave(name, _descriptionController.text.trim(), _avatarPath);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }
}