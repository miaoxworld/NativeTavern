import 'dart:convert';
import 'package:native_tavern/data/models/vector_storage.dart';

/// Service for vector storage and RAG operations
class VectorStorageService {
  /// In-memory storage for collections
  final Map<String, VectorCollection> _collections = {};

  /// Get all collections
  List<VectorCollection> get collections => _collections.values.toList();

  /// Get a collection by ID
  VectorCollection? getCollection(String id) => _collections[id];

  /// Create a new collection
  VectorCollection createCollection({
    required String name,
    String? description,
    int dimensions = 1536,
  }) {
    final collection = VectorCollection.create(
      name: name,
      description: description,
      dimensions: dimensions,
    );
    _collections[collection.id] = collection;
    return collection;
  }

  /// Update a collection
  void updateCollection(VectorCollection collection) {
    _collections[collection.id] = collection;
  }

  /// Delete a collection
  void deleteCollection(String id) {
    _collections.remove(id);
  }

  /// Add a document to a collection
  VectorDocument addDocument({
    required String collectionId,
    required String content,
    List<double>? embedding,
    Map<String, dynamic>? metadata,
  }) {
    final collection = _collections[collectionId];
    if (collection == null) {
      throw Exception('Collection not found: $collectionId');
    }

    final document = VectorDocument.create(
      content: content,
      embedding: embedding,
      metadata: metadata,
    );

    final updatedCollection = collection.copyWith(
      documents: [...collection.documents, document],
    );
    _collections[collectionId] = updatedCollection;

    return document;
  }

  /// Add multiple documents to a collection
  List<VectorDocument> addDocuments({
    required String collectionId,
    required List<String> contents,
    List<List<double>>? embeddings,
    List<Map<String, dynamic>>? metadataList,
  }) {
    final documents = <VectorDocument>[];
    for (int i = 0; i < contents.length; i++) {
      final doc = addDocument(
        collectionId: collectionId,
        content: contents[i],
        embedding: embeddings != null && i < embeddings.length ? embeddings[i] : null,
        metadata: metadataList != null && i < metadataList.length ? metadataList[i] : null,
      );
      documents.add(doc);
    }
    return documents;
  }

  /// Remove a document from a collection
  void removeDocument(String collectionId, String documentId) {
    final collection = _collections[collectionId];
    if (collection == null) return;

    final updatedDocuments = collection.documents
        .where((d) => d.id != documentId)
        .toList();

    _collections[collectionId] = collection.copyWith(documents: updatedDocuments);
  }

  /// Update document embedding
  void updateDocumentEmbedding(
    String collectionId,
    String documentId,
    List<double> embedding,
  ) {
    final collection = _collections[collectionId];
    if (collection == null) return;

    final updatedDocuments = collection.documents.map((d) {
      if (d.id == documentId) {
        return d.copyWith(embedding: embedding);
      }
      return d;
    }).toList();

    _collections[collectionId] = collection.copyWith(documents: updatedDocuments);
  }

  /// Search for similar documents
  List<VectorSearchResult> search({
    required String collectionId,
    required List<double> queryEmbedding,
    int topK = 5,
    double? similarityThreshold,
  }) {
    final collection = _collections[collectionId];
    if (collection == null) return [];

    final results = <VectorSearchResult>[];

    for (final document in collection.documents) {
      if (document.embedding == null) continue;

      final similarity = VectorMath.cosineSimilarity(
        queryEmbedding,
        document.embedding!,
      );

      if (similarityThreshold != null && similarity < similarityThreshold) {
        continue;
      }

      results.add(VectorSearchResult(
        document: document,
        similarity: similarity,
        distance: 1 - similarity,
      ));
    }

    // Sort by similarity (highest first)
    results.sort((a, b) => b.similarity.compareTo(a.similarity));

    return results.take(topK).toList();
  }

  /// Chunk text into smaller pieces
  List<String> chunkText(String text, ChunkingOptions options) {
    switch (options.strategy) {
      case ChunkingStrategy.fixedSize:
        return _chunkByFixedSize(text, options.chunkSize, options.chunkOverlap);
      case ChunkingStrategy.sentence:
        return _chunkBySentence(text, options.chunkSize);
      case ChunkingStrategy.paragraph:
        return _chunkByParagraph(text);
      case ChunkingStrategy.semantic:
        // Semantic chunking would require more sophisticated NLP
        // Fall back to sentence chunking
        return _chunkBySentence(text, options.chunkSize);
    }
  }

  List<String> _chunkByFixedSize(String text, int chunkSize, int overlap) {
    final chunks = <String>[];
    int start = 0;

    while (start < text.length) {
      int end = start + chunkSize;
      if (end > text.length) end = text.length;

      // Try to break at word boundary
      if (end < text.length) {
        final lastSpace = text.lastIndexOf(' ', end);
        if (lastSpace > start) {
          end = lastSpace;
        }
      }

      chunks.add(text.substring(start, end).trim());
      start = end - overlap;
      if (start < 0) start = 0;
      if (start >= text.length) break;
    }

    return chunks.where((c) => c.isNotEmpty).toList();
  }

  List<String> _chunkBySentence(String text, int maxChunkSize) {
    // Simple sentence splitting
    final sentencePattern = RegExp(r'[.!?]+\s+');
    final sentences = text.split(sentencePattern);
    
    final chunks = <String>[];
    var currentChunk = StringBuffer();

    for (final sentence in sentences) {
      if (currentChunk.length + sentence.length > maxChunkSize && currentChunk.isNotEmpty) {
        chunks.add(currentChunk.toString().trim());
        currentChunk = StringBuffer();
      }
      currentChunk.write('$sentence. ');
    }

    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk.toString().trim());
    }

    return chunks.where((c) => c.isNotEmpty).toList();
  }

  List<String> _chunkByParagraph(String text) {
    return text
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }

  /// Generate context string from search results
  String generateContext(
    List<VectorSearchResult> results, {
    String separator = '\n\n---\n\n',
    int? maxLength,
  }) {
    final buffer = StringBuffer();
    
    for (int i = 0; i < results.length; i++) {
      if (i > 0) buffer.write(separator);
      
      final content = results[i].document.content;
      if (maxLength != null && buffer.length + content.length > maxLength) {
        // Truncate if exceeding max length
        final remaining = maxLength - buffer.length;
        if (remaining > 100) {
          buffer.write(content.substring(0, remaining - 3));
          buffer.write('...');
        }
        break;
      }
      
      buffer.write(content);
    }

    return buffer.toString();
  }

  /// Format context using template
  String formatContextWithTemplate(
    List<VectorSearchResult> results,
    String template,
  ) {
    final context = generateContext(results);
    return template.replaceAll('{{context}}', context);
  }

  /// Export collection to JSON
  String exportCollection(String collectionId) {
    final collection = _collections[collectionId];
    if (collection == null) {
      throw Exception('Collection not found');
    }
    return const JsonEncoder.withIndent('  ').convert(collection.toJson());
  }

  /// Import collection from JSON
  VectorCollection importCollection(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final collection = VectorCollection.fromJson(data);
    _collections[collection.id] = collection;
    return collection;
  }

  /// Get statistics for a collection
  CollectionStatistics getStatistics(String collectionId) {
    final collection = _collections[collectionId];
    if (collection == null) {
      return const CollectionStatistics(
        documentCount: 0,
        embeddedCount: 0,
        totalCharacters: 0,
        avgDocumentLength: 0,
      );
    }

    int embeddedCount = 0;
    int totalChars = 0;

    for (final doc in collection.documents) {
      if (doc.embedding != null) embeddedCount++;
      totalChars += doc.content.length;
    }

    return CollectionStatistics(
      documentCount: collection.documentCount,
      embeddedCount: embeddedCount,
      totalCharacters: totalChars,
      avgDocumentLength: collection.documentCount > 0
          ? totalChars / collection.documentCount
          : 0,
    );
  }

  /// Clear all collections
  void clearAll() {
    _collections.clear();
  }

  /// Get help text
  String getHelpText() {
    return '''
**Vector Storage / RAG** (Retrieval-Augmented Generation) enhances AI responses with relevant context from your knowledge base.

**How it works:**
1. **Add documents** to a collection
2. **Generate embeddings** for each document
3. **Search** for relevant documents based on your query
4. **Inject context** into the AI prompt

**Key Concepts:**
- **Embeddings**: Numerical representations of text that capture meaning
- **Similarity**: How closely two pieces of text relate
- **Chunking**: Breaking large documents into smaller pieces

**Use Cases:**
- Character lore and backstory
- World-building information
- Reference documents
- FAQ and knowledge bases

**Tips:**
- Keep chunks focused on single topics
- Use descriptive metadata for filtering
- Adjust similarity threshold based on results
- Higher topK = more context but more tokens
''';
  }
}

/// Statistics for a collection
class CollectionStatistics {
  final int documentCount;
  final int embeddedCount;
  final int totalCharacters;
  final double avgDocumentLength;

  const CollectionStatistics({
    required this.documentCount,
    required this.embeddedCount,
    required this.totalCharacters,
    required this.avgDocumentLength,
  });

  double get embeddingCoverage {
    if (documentCount == 0) return 0;
    return embeddedCount / documentCount;
  }

  String get embeddingCoveragePercent => '${(embeddingCoverage * 100).toStringAsFixed(1)}%';
}