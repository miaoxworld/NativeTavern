import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/vector_storage.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/vector_storage_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/presentation/widgets/common/adaptive_popup_menu.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/widgets/export_destination_sheet.dart';

/// Settings screen for Vector Storage / RAG
class VectorStorageSettingsScreen extends ConsumerWidget {
  const VectorStorageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(vectorStorageSettingsProvider);
    final collections = ref.watch(vectorCollectionsProvider);
    final chatConfig = ref.watch(llmConfigProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vectorStorageRag),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: l10n.help,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable toggle
          SwitchListTile(
            title: Text(l10n.enableRag),
            subtitle: Text(l10n.retrievalAugmentedGeneration),
            value: settings.enabled,
            onChanged: (value) {
              ref
                  .read(vectorStorageSettingsProvider.notifier)
                  .setEnabled(value);
            },
          ),
          const Divider(height: 32),

          // Collections section
          _buildSectionHeader(context, l10n.collections),
          const SizedBox(height: 8),
          _CollectionsSection(
            collections: collections,
            activeCollectionId: settings.activeCollectionId,
            enabled: settings.enabled,
            onCollectionSelected: (id) {
              ref
                  .read(vectorStorageSettingsProvider.notifier)
                  .setActiveCollection(id);
            },
            onCreateCollection: () => _showCreateCollectionDialog(context, ref),
            onDeleteCollection: (id) =>
                _confirmDeleteCollection(context, ref, id),
            onExportCollection: (id) => _exportCollection(context, ref, id),
            onImportCollection: () => _importCollection(context, ref),
          ),

          const Divider(height: 32),

          // Search settings
          _buildSectionHeader(context, l10n.searchSettings),
          const SizedBox(height: 16),

          // Top K slider
          ListTile(
            title: Text(l10n.topKResults),
            subtitle: Text(l10n.topKResultsDescription(settings.topK)),
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
                        ref
                            .read(vectorStorageSettingsProvider.notifier)
                            .setTopK(value.round());
                      }
                    : null,
              ),
            ),
          ),

          // Similarity threshold slider
          ListTile(
            title: Text(l10n.similarityThreshold),
            subtitle: Text(l10n.minimumPercent(
              (settings.similarityThreshold * 100).toStringAsFixed(0),
            )),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: settings.similarityThreshold,
                min: 0,
                max: 1,
                divisions: 20,
                label:
                    '${(settings.similarityThreshold * 100).toStringAsFixed(0)}%',
                onChanged: settings.enabled
                    ? (value) {
                        ref
                            .read(vectorStorageSettingsProvider.notifier)
                            .setSimilarityThreshold(value);
                      }
                    : null,
              ),
            ),
          ),

          const Divider(height: 32),

          // Embedding settings
          _buildSectionHeader(context, l10n.embeddingProvider),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.link),
            label: Text(AppLocalizations.of(context).useCurrentChatConnection),
            onPressed: settings.enabled &&
                    chatConfig.apiUrl.trim().isNotEmpty &&
                    chatConfig.apiKey.trim().isNotEmpty
                ? () {
                    ref
                        .read(vectorStorageSettingsProvider.notifier)
                        .useChatConnection(
                          endpoint: chatConfig.apiUrl,
                          apiKey: chatConfig.apiKey,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .chatConnectionAppliedToEmbeddings),
                    ));
                  }
                : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<EmbeddingProvider>(
            value: settings.embeddingProvider,
            decoration: InputDecoration(
              labelText: l10n.provider,
              border: const OutlineInputBorder(),
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
                      ref
                          .read(vectorStorageSettingsProvider.notifier)
                          .setEmbeddingProvider(provider);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: ValueKey(
                'embedding-model-${settings.embeddingProvider.name}-${settings.embeddingModel}'),
            initialValue: settings.embeddingModel ??
                settings.embeddingProvider.defaultModel,
            decoration: InputDecoration(
              labelText: l10n.model,
              border: const OutlineInputBorder(),
            ),
            enabled: settings.enabled,
            onChanged: (value) {
              ref
                  .read(vectorStorageSettingsProvider.notifier)
                  .setEmbeddingModel(value);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: ValueKey(
                'embedding-endpoint-${settings.embeddingProvider.name}-${settings.embeddingEndpoint}'),
            initialValue: settings.embeddingEndpoint ??
                settings.embeddingProvider.defaultEndpoint,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).apiEndpoint,
              border: const OutlineInputBorder(),
            ),
            enabled: settings.enabled,
            onChanged: (value) {
              ref
                  .read(vectorStorageSettingsProvider.notifier)
                  .setEmbeddingEndpoint(value);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: ValueKey(
                'embedding-key-${settings.embeddingProvider.name}-${settings.embeddingApiKey?.isNotEmpty ?? false}'),
            initialValue: settings.embeddingApiKey ?? '',
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).apiKey,
              border: const OutlineInputBorder(),
            ),
            obscureText: true,
            enabled: settings.enabled,
            onChanged: (value) {
              ref
                  .read(vectorStorageSettingsProvider.notifier)
                  .setEmbeddingApiKey(value);
            },
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.auto_fix_high),
            label: Text(AppLocalizations.of(context).embedPendingDocuments),
            onPressed: settings.enabled && settings.activeCollectionId != null
                ? () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final l10n = AppLocalizations.of(context);
                    try {
                      final count = await ref.read(embedCollectionProvider)(
                          settings.activeCollectionId!);
                      messenger.showSnackBar(SnackBar(
                          content: Text(count > 0
                              ? l10n.embeddedDocuments('$count')
                              : l10n.allDocumentsEmbedded)));
                    } catch (e) {
                      messenger.showSnackBar(
                          SnackBar(content: Text(l10n.embeddingFailed('$e'))));
                    }
                  }
                : null,
          ),

          const Divider(height: 32),

          // Prompt settings
          _buildSectionHeader(context, l10n.promptIntegration),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(l10n.includeInPrompt),
            subtitle: Text(l10n.automaticallyAddContext),
            value: settings.includeInPrompt,
            onChanged: settings.enabled
                ? (value) {
                    ref
                        .read(vectorStorageSettingsProvider.notifier)
                        .setIncludeInPrompt(value);
                  }
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: settings.promptTemplate,
            decoration: InputDecoration(
              labelText: l10n.promptTemplate,
              hintText: l10n.useContextPlaceholder('{{context}}'),
              border: const OutlineInputBorder(),
            ),
            maxLines: 5,
            enabled: settings.enabled && settings.includeInPrompt,
            onChanged: (value) {
              ref
                  .read(vectorStorageSettingsProvider.notifier)
                  .setPromptTemplate(value);
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

  void _showHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.vectorStorageHelp),
        content: SingleChildScrollView(
          child: Text(l10n.vectorStorageHelpContent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final settings = ref.read(vectorStorageSettingsProvider);
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.createCollection),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                hintText: l10n.enterCollectionName,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: l10n.descriptionOptional,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final collection = ref
                    .read(vectorCollectionsProvider.notifier)
                    .createCollection(
                      name: nameController.text.trim(),
                      description: descController.text.trim().isEmpty
                          ? null
                          : descController.text.trim(),
                      dimensions: settings.embeddingProvider.defaultDimensions,
                    );
                ref
                    .read(vectorStorageSettingsProvider.notifier)
                    .setActiveCollection(collection.id);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.create),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCollection(
      BuildContext context, WidgetRef ref, String id) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCollection),
        content: Text(l10n.deleteCollectionConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(vectorCollectionsProvider.notifier).deleteCollection(id);
              final settings = ref.read(vectorStorageSettingsProvider);
              if (settings.activeCollectionId == id) {
                ref
                    .read(vectorStorageSettingsProvider.notifier)
                    .setActiveCollection(null);
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _exportCollection(BuildContext context, WidgetRef ref, String id) {
    final l10n = AppLocalizations.of(context);
    try {
      final json =
          ref.read(vectorCollectionsProvider.notifier).exportCollection(id);
      Clipboard.setData(ClipboardData(text: json));
      exportTextWithDestination(
        context: context,
        fileName: 'nativetavern_collection_$id.json',
        content: json,
        subject: 'NativeTavern Collection',
        allowedExtensions: const ['json'],
        mimeType: 'application/json',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.exportFailed('$e'))),
      );
    }
  }

  void _importCollection(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importCollection),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'JSON',
            hintText: l10n.pasteCollectionJson,
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              try {
                ref
                    .read(vectorCollectionsProvider.notifier)
                    .importCollection(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.collectionImported)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.importFailed('$e'))),
                );
              }
            },
            child: Text(l10n.import),
          ),
        ],
      ),
    );
  }
}

/// Section for managing collections
class _CollectionsSection extends StatelessWidget {
  static const _noCollectionValue = '__none__';

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
    final l10n = AppLocalizations.of(context);
    final selectedCollectionId = collections.any(
      (collection) => collection.id == activeCollectionId,
    )
        ? activeCollectionId
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCollectionId ?? _noCollectionValue,
                decoration: InputDecoration(
                  labelText: l10n.activeCollection,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: _noCollectionValue,
                    child: Text(l10n.none),
                  ),
                  ...collections.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(l10n.collectionWithDocumentCount(
                          c.name,
                          c.documentCount,
                        )),
                      )),
                ],
                onChanged: enabled
                    ? (value) => onCollectionSelected(
                          value == _noCollectionValue ? null : value,
                        )
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: enabled ? onCreateCollection : null,
              tooltip: l10n.createCollection,
            ),
            AdaptivePopupMenuButton<String>(
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
                PopupMenuItem(
                  value: 'import',
                  child: ListTile(
                    leading: const Icon(Icons.file_download),
                    title: Text(l10n.importCollection),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (selectedCollectionId != null) ...[
          const SizedBox(height: 8),
          _CollectionDetails(
            collectionId: selectedCollectionId,
            onExport: () => onExportCollection(selectedCollectionId),
            onDelete: () => onDeleteCollection(selectedCollectionId),
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
      orElse: () => VectorCollection.create(
        name: AppLocalizations.of(context).unknown,
      ),
    );
    final l10n = AppLocalizations.of(context);

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
                      tooltip: l10n.export,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: onDelete,
                      tooltip: l10n.delete,
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
                  label: l10n.documentsCount(stats.documentCount),
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.memory,
                  label: l10n.embeddedCount(stats.embeddingCoveragePercent),
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.text_fields,
                  label: l10n.charsCount(stats.totalCharacters),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addDocument),
                    onPressed: () => _showAddDocumentDialog(context, ref),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.list, size: 18),
                    label: Text(l10n.viewDocuments),
                    onPressed: () =>
                        _showDocumentsDialog(context, ref, collection),
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addDocument),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.content,
            hintText: l10n.enterDocumentContent,
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
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
                  SnackBar(content: Text(l10n.documentAdded)),
                );
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showDocumentsDialog(
      BuildContext context, WidgetRef ref, VectorCollection collection) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.documentsCount(collection.documentCount)),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: collection.documents.isEmpty
              ? Center(child: Text(l10n.noDocuments))
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
                          l10n.documentEmbeddingStatus(
                            doc.content.length,
                            doc.embedding != null
                                ? l10n.embedded
                                : l10n.notEmbedded,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () {
                            ref
                                .read(vectorCollectionsProvider.notifier)
                                .removeDocument(
                                  collectionId,
                                  doc.id,
                                );
                            Navigator.pop(context);
                            _showDocumentsDialog(
                                context,
                                ref,
                                ref
                                    .read(vectorCollectionsProvider)
                                    .firstWhere((c) => c.id == collectionId));
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
            child: Text(l10n.close),
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
