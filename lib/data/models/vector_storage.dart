import 'dart:convert';
import 'dart:math' as math;
import 'package:uuid/uuid.dart';

/// Represents a document chunk with its embedding
class VectorDocument {
  final String id;
  final String content;
  final List<double>? embedding;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const VectorDocument({
    required this.id,
    required this.content,
    this.embedding,
    this.metadata = const {},
    required this.createdAt,
  });

  factory VectorDocument.create({
    required String content,
    List<double>? embedding,
    Map<String, dynamic>? metadata,
  }) {
    return VectorDocument(
      id: const Uuid().v4(),
      content: content,
      embedding: embedding,
      metadata: metadata ?? {},
      createdAt: DateTime.now(),
    );
  }

  factory VectorDocument.fromJson(Map<String, dynamic> json) {
    return VectorDocument(
      id: json['id'] as String? ?? const Uuid().v4(),
      content: json['content'] as String? ?? '',
      embedding: (json['embedding'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'embedding': embedding,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  VectorDocument copyWith({
    String? id,
    String? content,
    List<double>? embedding,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return VectorDocument(
      id: id ?? this.id,
      content: content ?? this.content,
      embedding: embedding ?? this.embedding,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Represents a vector collection (like a database table)
class VectorCollection {
  final String id;
  final String name;
  final String? description;
  final int dimensions;
  final List<VectorDocument> documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VectorCollection({
    required this.id,
    required this.name,
    this.description,
    required this.dimensions,
    this.documents = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory VectorCollection.create({
    required String name,
    String? description,
    int dimensions = 1536, // OpenAI default
  }) {
    final now = DateTime.now();
    return VectorCollection(
      id: const Uuid().v4(),
      name: name,
      description: description,
      dimensions: dimensions,
      documents: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  factory VectorCollection.fromJson(Map<String, dynamic> json) {
    return VectorCollection(
      id: json['id'] as String? ?? const Uuid().v4(),
      name: json['name'] as String? ?? 'Unnamed',
      description: json['description'] as String?,
      dimensions: json['dimensions'] as int? ?? 1536,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => VectorDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dimensions': dimensions,
      'documents': documents.map((d) => d.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  VectorCollection copyWith({
    String? id,
    String? name,
    String? description,
    int? dimensions,
    List<VectorDocument>? documents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VectorCollection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dimensions: dimensions ?? this.dimensions,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  int get documentCount => documents.length;
}

/// Search result with similarity score
class VectorSearchResult {
  final VectorDocument document;
  final double similarity;
  final double distance;

  const VectorSearchResult({
    required this.document,
    required this.similarity,
    required this.distance,
  });

  /// Similarity as percentage
  String get similarityPercent => '${(similarity * 100).toStringAsFixed(1)}%';
}

/// Settings for vector storage / RAG
class VectorStorageSettings {
  final bool enabled;
  final String? activeCollectionId;
  final int topK;
  final double similarityThreshold;
  final bool includeInPrompt;
  final String promptTemplate;
  final EmbeddingProvider embeddingProvider;
  final String? embeddingModel;

  const VectorStorageSettings({
    this.enabled = false,
    this.activeCollectionId,
    this.topK = 5,
    this.similarityThreshold = 0.7,
    this.includeInPrompt = true,
    this.promptTemplate = defaultPromptTemplate,
    this.embeddingProvider = EmbeddingProvider.openai,
    this.embeddingModel,
  });

  static const defaultPromptTemplate = '''
Relevant context from knowledge base:
{{context}}

Use the above context to help answer the user's question if relevant.
''';

  factory VectorStorageSettings.fromJson(Map<String, dynamic> json) {
    return VectorStorageSettings(
      enabled: json['enabled'] as bool? ?? false,
      activeCollectionId: json['activeCollectionId'] as String?,
      topK: json['topK'] as int? ?? 5,
      similarityThreshold: (json['similarityThreshold'] as num?)?.toDouble() ?? 0.7,
      includeInPrompt: json['includeInPrompt'] as bool? ?? true,
      promptTemplate: json['promptTemplate'] as String? ?? defaultPromptTemplate,
      embeddingProvider: EmbeddingProvider.values.firstWhere(
        (e) => e.name == json['embeddingProvider'],
        orElse: () => EmbeddingProvider.openai,
      ),
      embeddingModel: json['embeddingModel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'activeCollectionId': activeCollectionId,
      'topK': topK,
      'similarityThreshold': similarityThreshold,
      'includeInPrompt': includeInPrompt,
      'promptTemplate': promptTemplate,
      'embeddingProvider': embeddingProvider.name,
      'embeddingModel': embeddingModel,
    };
  }

  VectorStorageSettings copyWith({
    bool? enabled,
    String? activeCollectionId,
    int? topK,
    double? similarityThreshold,
    bool? includeInPrompt,
    String? promptTemplate,
    EmbeddingProvider? embeddingProvider,
    String? embeddingModel,
    bool clearActiveCollection = false,
  }) {
    return VectorStorageSettings(
      enabled: enabled ?? this.enabled,
      activeCollectionId: clearActiveCollection ? null : (activeCollectionId ?? this.activeCollectionId),
      topK: topK ?? this.topK,
      similarityThreshold: similarityThreshold ?? this.similarityThreshold,
      includeInPrompt: includeInPrompt ?? this.includeInPrompt,
      promptTemplate: promptTemplate ?? this.promptTemplate,
      embeddingProvider: embeddingProvider ?? this.embeddingProvider,
      embeddingModel: embeddingModel ?? this.embeddingModel,
    );
  }

  static String serialize(VectorStorageSettings settings) {
    return jsonEncode(settings.toJson());
  }

  static VectorStorageSettings deserialize(String json) {
    return VectorStorageSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }
}

/// Embedding provider options
enum EmbeddingProvider {
  openai,
  cohere,
  local,
  custom,
}

extension EmbeddingProviderExtension on EmbeddingProvider {
  String get displayName {
    switch (this) {
      case EmbeddingProvider.openai:
        return 'OpenAI';
      case EmbeddingProvider.cohere:
        return 'Cohere';
      case EmbeddingProvider.local:
        return 'Local (Sentence Transformers)';
      case EmbeddingProvider.custom:
        return 'Custom API';
    }
  }

  String get defaultModel {
    switch (this) {
      case EmbeddingProvider.openai:
        return 'text-embedding-3-small';
      case EmbeddingProvider.cohere:
        return 'embed-english-v3.0';
      case EmbeddingProvider.local:
        return 'all-MiniLM-L6-v2';
      case EmbeddingProvider.custom:
        return '';
    }
  }

  int get defaultDimensions {
    switch (this) {
      case EmbeddingProvider.openai:
        return 1536;
      case EmbeddingProvider.cohere:
        return 1024;
      case EmbeddingProvider.local:
        return 384;
      case EmbeddingProvider.custom:
        return 768;
    }
  }
}

/// Text chunking strategy
enum ChunkingStrategy {
  /// Fixed size chunks with overlap
  fixedSize,
  /// Split by sentences
  sentence,
  /// Split by paragraphs
  paragraph,
  /// Split by semantic boundaries
  semantic,
}

extension ChunkingStrategyExtension on ChunkingStrategy {
  String get displayName {
    switch (this) {
      case ChunkingStrategy.fixedSize:
        return 'Fixed Size';
      case ChunkingStrategy.sentence:
        return 'Sentence';
      case ChunkingStrategy.paragraph:
        return 'Paragraph';
      case ChunkingStrategy.semantic:
        return 'Semantic';
    }
  }

  String get description {
    switch (this) {
      case ChunkingStrategy.fixedSize:
        return 'Split text into fixed-size chunks with overlap';
      case ChunkingStrategy.sentence:
        return 'Split text at sentence boundaries';
      case ChunkingStrategy.paragraph:
        return 'Split text at paragraph boundaries';
      case ChunkingStrategy.semantic:
        return 'Split text at semantic boundaries (experimental)';
    }
  }
}

/// Chunking options
class ChunkingOptions {
  final ChunkingStrategy strategy;
  final int chunkSize;
  final int chunkOverlap;

  const ChunkingOptions({
    this.strategy = ChunkingStrategy.fixedSize,
    this.chunkSize = 500,
    this.chunkOverlap = 50,
  });

  factory ChunkingOptions.fromJson(Map<String, dynamic> json) {
    return ChunkingOptions(
      strategy: ChunkingStrategy.values.firstWhere(
        (s) => s.name == json['strategy'],
        orElse: () => ChunkingStrategy.fixedSize,
      ),
      chunkSize: json['chunkSize'] as int? ?? 500,
      chunkOverlap: json['chunkOverlap'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy.name,
      'chunkSize': chunkSize,
      'chunkOverlap': chunkOverlap,
    };
  }
}

/// Utility class for vector math operations
class VectorMath {
  /// Calculate cosine similarity between two vectors
  static double cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must have the same length');
    }

    double dotProduct = 0;
    double normA = 0;
    double normB = 0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) return 0;
    return dotProduct / (math.sqrt(normA) * math.sqrt(normB));
  }

  /// Calculate Euclidean distance between two vectors
  static double euclideanDistance(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw ArgumentError('Vectors must have the same length');
    }

    double sum = 0;
    for (int i = 0; i < a.length; i++) {
      final diff = a[i] - b[i];
      sum += diff * diff;
    }
    return math.sqrt(sum);
  }

  /// Normalize a vector to unit length
  static List<double> normalize(List<double> vector) {
    double norm = 0;
    for (final v in vector) {
      norm += v * v;
    }
    norm = math.sqrt(norm);
    if (norm == 0) return vector;
    return vector.map((v) => v / norm).toList();
  }
}