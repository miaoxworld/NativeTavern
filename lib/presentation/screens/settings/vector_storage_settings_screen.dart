import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/vector_storage.dart';
import 'package:native_tavern/domain/services/vector_storage_service.dart';
import 'package:native_tavern/presentation/providers/vector_storage_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// Settings screen for Vector Storage / RAG
class VectorStorageSettingsScreen extends ConsumerWidget {
  const VectorStorageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(vectorStorageSettingsProvider);
    final collections = ref.watch(vectorCollectionsProvider);
    final service = ref.watch(vectorStorageServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vector Storage / RAG'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context, service),
            tooltip: 'Help',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable toggle
          SwitchListTile(
            title: const Text('Enable RAG'),
            subtitle: const Text('Retrieval-Augmented Generation'),
            value: settings.enabled,
            onChanged: (value) {
              ref.read(vectorStorageSettingsProvider.notifier).setEnabled(value);
            },
          ),
          const Divider(height: 32),

          // Collections section
          _buildSectionHeader(context, 'Collections'),
          const SizedBox(height: 8),
          _CollectionsSection(
            collections: collections,
            activeCollectionId: settings.activeCollectionId,
            enabled: settings.enabled,
            onCollectionSelected: (id) {
              ref.read(vectorStorageSettingsProvider.notifier).setActiveCollection(id);
            },
            onCreateCollection: () => _showCreateCollectionDialog(context, ref),
            onDeleteCollection: (id) => _confirmDeleteCollection(context, ref, id),
            onExportCollection: (id) => _exportCollection(context, ref, id),
            onImportCollection: () => _importCollection(context, ref),
          ),

          const Divider(height: 32),

          // Search settings
          _buildSectionHeader(context, 'Search Settings'),
          const SizedBox(height: 16),
          
          // Top K slider
          ListTile(
            title: const Text('Top K Results'),
            subtitle: Text('Return top ${settings.topK} most similar documents'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: settings.topK.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: settings.topK.toString(),
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(vectorStorageSettingsProvider.notifier).setTopK(value.round());
                      }
                    : null,
              ),
            ),
          ),

          // Similarity threshold slider
          ListTile(
            title: const Text('Similarity Threshold'),
            subtitle: Text('Minimum: ${(settings.similarityThreshold * 100).toStringAsFixed(0)}%'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: settings.similarityThreshold,
                min: 0,
                max: 1,
                divisions: 20,
                label: '${(settings.similarityThreshold * 100).toStringAsFixed(0)}%',
                onChanged: settings.enabled
                    ? (value) {
                        ref.read(vectorStorageSettingsProvider.notifier).setSimilarityThreshold(value);
                      }
                    : null,
              ),
            ),
          ),

          const Divider(height: 32),

          // Embedding settings
          _buildSectionHeader(context, 'Embedding Provider'),
          const SizedBox(height: 8),
          DropdownButtonFormField<EmbeddingProvider>(
            value: settings.embeddingProvider,
            decoration: const InputDecoration(
              labelText: 'Provider',
              border: OutlineInputBorder(),
            ),
            items: EmbeddingProvider.values.map((provider) {
              return DropdownMenuItem(
                value: provider,
                child: Text(provider.displayName),
              );
            }).toList(),
            onChanged: settings.enabled
                ? (provider) {
                    if (provider != null) {
                      ref.read(vectorStorageSettingsProvider.notifier).setEmbeddingProvider(provider);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: settings.embeddingModel ?? settings.embeddingProvider.defaultModel,
            decoration: const InputDecoration(
              labelText: 'Model',
              border: OutlineInputBorder(),
            ),
            enabled: settings.enabled,
            onChanged: (value) {
              ref.read(vectorStorageSettingsProvider.notifier).setEmbeddingModel(value);
            },
          ),

          const Divider(height: 32),

          // Prompt settings
          _buildSectionHeader(context, 'Prompt Integration'),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Include in Prompt'),
            subtitle: const Text('Automatically add context to AI prompts'),
            value: settings.includeInPrompt,
            onChanged: settings.enabled
                ? (value) {
                    ref.read(vectorStorageSettingsProvider.notifier).setIncludeInPrompt(value);
                  }
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: settings.promptTemplate,
            decoration: const InputDecoration(
              labelText: 'Prompt Template',
              hintText: 'Use {{context}} for retrieved content',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            enabled: settings.enabled && settings.includeInPrompt,
            onChanged: (value) {
              ref.read(vectorStorageSettingsProvider.notifier).setPromptTemplate(value);
            },
          ),

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

  void _showHelpDialog(BuildContext context, VectorStorageService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vector Storage Help'),
        content: SingleChildScrollView(
          child: Text(service.getHelpText()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final settings = ref.read(vectorStorageSettingsProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter collection name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final collection = ref.read(vectorCollectionsProvider.notifier).createCollection(
                  name: nameController.text.trim(),
                  description: descController.text.trim().isEmpty ? null : descController.text.trim(),
                  dimensions: settings.embeddingProvider.defaultDimensions,
                );
                ref.read(vectorStorageSettingsProvider.notifier).setActiveCollection(collection.id);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCollection(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: const Text('Are you sure you want to delete this collection? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(vectorCollectionsProvider.notifier).deleteCollection(id);
              final settings = ref.read(vectorStorageSettingsProvider);
              if (settings.activeCollectionId == id) {
                ref.read(vectorStorageSettingsProvider.notifier).setActiveCollection(null);
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportCollection(BuildContext context, WidgetRef ref, String id) {
    try {
      final json = ref.read(vectorCollectionsProvider.notifier).exportCollection(id);
      Clipboard.setData(ClipboardData(text: json));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Collection exported to clipboard')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  void _importCollection(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Collection'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'JSON',
            hintText: 'Paste collection JSON here',
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              try {
                ref.read(vectorCollectionsProvider.notifier).importCollection(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Collection imported successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Import failed: $e')),
                );
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}

/// Section for managing collections
class _CollectionsSection extends StatelessWidget {
  final List<VectorCollection> collections;
  final String? activeCollectionId;
  final bool enabled;
  final ValueChanged<String?> onCollectionSelected;
  final VoidCallback onCreateCollection;
  final ValueChanged<String> onDeleteCollection;
  final ValueChanged<String> onExportCollection;
  final VoidCallback onImportCollection;

  const _CollectionsSection({
    required this.collections,
    required this.activeCollectionId,
    required this.enabled,
    required this.onCollectionSelected,
    required this.onCreateCollection,
    required this.onDeleteCollection,
    required this.onExportCollection,
    required this.onImportCollection,
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
                value: activeCollectionId,
                decoration: const InputDecoration(
                  labelText: 'Active Collection',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None'),
                  ),
                  ...collections.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.name} (${c.documentCount} docs)'),
                      )),
                ],
                onChanged: enabled ? onCollectionSelected : null,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: enabled ? onCreateCollection : null,
              tooltip: 'Create Collection',
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              enabled: enabled,
              onSelected: (action) {
                switch (action) {
                  case 'import':
                    onImportCollection();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'import',
                  child: ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text('Import Collection'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (activeCollectionId != null) ...[
          const SizedBox(height: 8),
          _CollectionDetails(
            collectionId: activeCollectionId!,
            onExport: () => onExportCollection(activeCollectionId!),
            onDelete: () => onDeleteCollection(activeCollectionId!),
          ),
        ],
      ],
    );
  }
}

/// Details view for a collection
class _CollectionDetails extends ConsumerWidget {
  final String collectionId;
  final VoidCallback onExport;
  final VoidCallback onDelete;

  const _CollectionDetails({
    required this.collectionId,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(collectionStatisticsProvider(collectionId));
    final collections = ref.watch(vectorCollectionsProvider);
    final collection = collections.firstWhere(
      (c) => c.id == collectionId,
      orElse: () => VectorCollection.create(name: 'Unknown'),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  collection.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.file_upload, size: 20),
                      onPressed: onExport,
                      tooltip: 'Export',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            if (collection.description != null) ...[
              const SizedBox(height: 4),
              Text(
                collection.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _StatChip(
                  icon: Icons.description,
                  label: '${stats.documentCount} docs',
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.memory,
                  label: '${stats.embeddingCoveragePercent} embedded',
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.text_fields,
                  label: '${stats.totalCharacters} chars',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Document'),
                    onPressed: () => _showAddDocumentDialog(context, ref),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.list, size: 18),
                    label: const Text('View Documents'),
                    onPressed: () => _showDocumentsDialog(context, ref, collection),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDocumentDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Document'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Content',
            hintText: 'Enter document content',
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(vectorCollectionsProvider.notifier).addDocument(
                  collectionId: collectionId,
                  content: controller.text.trim(),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Document added')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDocumentsDialog(BuildContext context, WidgetRef ref, VectorCollection collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Documents (${collection.documentCount})'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: collection.documents.isEmpty
              ? const Center(child: Text('No documents'))
              : ListView.builder(
                  itemCount: collection.documents.length,
                  itemBuilder: (context, index) {
                    final doc = collection.documents[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          doc.content.length > 100
                              ? '${doc.content.substring(0, 100)}...'
                              : doc.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${doc.content.length} chars • ${doc.embedding != null ? "Embedded" : "Not embedded"}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () {
                            ref.read(vectorCollectionsProvider.notifier).removeDocument(
                              collectionId,
                              doc.id,
                            );
                            Navigator.pop(context);
                            _showDocumentsDialog(context, ref, 
                              ref.read(vectorCollectionsProvider).firstWhere((c) => c.id == collectionId));
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Small stat chip widget
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}