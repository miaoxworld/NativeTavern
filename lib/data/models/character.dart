/// Character model for NativeTavern
class Character {
  final String id;
  final String name;
  final String description;
  final String personality;
  final String scenario;
  final String firstMessage;
  final List<String> alternateGreetings;
  final String exampleMessages;
  final String systemPrompt;
  final String postHistoryInstructions;
  final String creatorNotes;
  final List<String> tags;
  final String creator;
  final String version;
  final CharacterAssets? assets;
  final CharacterBook? characterBook;
  final Map<String, dynamic> extensions;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime modifiedAt;

  const Character({
    required this.id,
    required this.name,
    this.description = '',
    this.personality = '',
    this.scenario = '',
    this.firstMessage = '',
    this.alternateGreetings = const [],
    this.exampleMessages = '',
    this.systemPrompt = '',
    this.postHistoryInstructions = '',
    this.creatorNotes = '',
    this.tags = const [],
    this.creator = '',
    this.version = '',
    this.assets,
    this.characterBook,
    this.extensions = const {},
    this.isFavorite = false,
    required this.createdAt,
    required this.modifiedAt,
  });

  Character copyWith({
    String? id,
    String? name,
    String? description,
    String? personality,
    String? scenario,
    String? firstMessage,
    List<String>? alternateGreetings,
    String? exampleMessages,
    String? systemPrompt,
    String? postHistoryInstructions,
    String? creatorNotes,
    List<String>? tags,
    String? creator,
    String? version,
    CharacterAssets? assets,
    CharacterBook? characterBook,
    Map<String, dynamic>? extensions,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      personality: personality ?? this.personality,
      scenario: scenario ?? this.scenario,
      firstMessage: firstMessage ?? this.firstMessage,
      alternateGreetings: alternateGreetings ?? this.alternateGreetings,
      exampleMessages: exampleMessages ?? this.exampleMessages,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      postHistoryInstructions: postHistoryInstructions ?? this.postHistoryInstructions,
      creatorNotes: creatorNotes ?? this.creatorNotes,
      tags: tags ?? this.tags,
      creator: creator ?? this.creator,
      version: version ?? this.version,
      assets: assets ?? this.assets,
      characterBook: characterBook ?? this.characterBook,
      extensions: extensions ?? this.extensions,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'personality': personality,
        'scenario': scenario,
        'firstMessage': firstMessage,
        'alternateGreetings': alternateGreetings,
        'exampleMessages': exampleMessages,
        'systemPrompt': systemPrompt,
        'postHistoryInstructions': postHistoryInstructions,
        'creatorNotes': creatorNotes,
        'tags': tags,
        'creator': creator,
        'version': version,
        'assets': assets?.toJson(),
        'characterBook': characterBook?.toJson(),
        'extensions': extensions,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt.toIso8601String(),
      };

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        personality: json['personality'] as String? ?? '',
        scenario: json['scenario'] as String? ?? '',
        firstMessage: json['firstMessage'] as String? ?? '',
        alternateGreetings: (json['alternateGreetings'] as List<dynamic>?)?.cast<String>() ?? [],
        exampleMessages: json['exampleMessages'] as String? ?? '',
        systemPrompt: json['systemPrompt'] as String? ?? '',
        postHistoryInstructions: json['postHistoryInstructions'] as String? ?? '',
        creatorNotes: json['creatorNotes'] as String? ?? '',
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        creator: json['creator'] as String? ?? '',
        version: json['version'] as String? ?? '',
        assets: json['assets'] != null
            ? CharacterAssets.fromJson(json['assets'] as Map<String, dynamic>)
            : null,
        characterBook: json['characterBook'] != null
            ? CharacterBook.fromJson(json['characterBook'] as Map<String, dynamic>)
            : null,
        extensions: json['extensions'] as Map<String, dynamic>? ?? {},
        isFavorite: json['isFavorite'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      );
}

/// Character assets (avatar, expression packs, etc.)
class CharacterAssets {
  final String? avatarPath;
  final String? avatarUrl;
  final Map<String, String>? expressionPack;

  const CharacterAssets({
    this.avatarPath,
    this.avatarUrl,
    this.expressionPack,
  });

  CharacterAssets copyWith({
    String? avatarPath,
    String? avatarUrl,
    Map<String, String>? expressionPack,
  }) {
    return CharacterAssets(
      avatarPath: avatarPath ?? this.avatarPath,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      expressionPack: expressionPack ?? this.expressionPack,
    );
  }

  Map<String, dynamic> toJson() => {
        'avatarPath': avatarPath,
        'avatarUrl': avatarUrl,
        'expressionPack': expressionPack,
      };

  factory CharacterAssets.fromJson(Map<String, dynamic> json) => CharacterAssets(
        avatarPath: json['avatarPath'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        expressionPack: (json['expressionPack'] as Map<String, dynamic>?)?.cast<String, String>(),
      );
}

/// Embedded character lorebook (character_book in V2/V3 spec)
class CharacterBook {
  final String? name;
  final String? description;
  final bool scanDepth;
  final int tokenBudget;
  final bool recursiveScanning;
  final List<CharacterBookEntry> entries;
  final Map<String, dynamic> extensions;

  const CharacterBook({
    this.name,
    this.description,
    this.scanDepth = true,
    this.tokenBudget = 2048,
    this.recursiveScanning = false,
    this.entries = const [],
    this.extensions = const {},
  });

  CharacterBook copyWith({
    String? name,
    String? description,
    bool? scanDepth,
    int? tokenBudget,
    bool? recursiveScanning,
    List<CharacterBookEntry>? entries,
    Map<String, dynamic>? extensions,
  }) {
    return CharacterBook(
      name: name ?? this.name,
      description: description ?? this.description,
      scanDepth: scanDepth ?? this.scanDepth,
      tokenBudget: tokenBudget ?? this.tokenBudget,
      recursiveScanning: recursiveScanning ?? this.recursiveScanning,
      entries: entries ?? this.entries,
      extensions: extensions ?? this.extensions,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'scan_depth': scanDepth,
        'token_budget': tokenBudget,
        'recursive_scanning': recursiveScanning,
        'entries': entries.map((e) => e.toJson()).toList(),
        'extensions': extensions,
      };

  factory CharacterBook.fromJson(Map<String, dynamic> json) => CharacterBook(
        name: json['name'] as String?,
        description: json['description'] as String?,
        scanDepth: json['scan_depth'] as bool? ?? true,
        tokenBudget: json['token_budget'] as int? ?? 2048,
        recursiveScanning: json['recursive_scanning'] as bool? ?? false,
        entries: (json['entries'] as List<dynamic>?)
            ?.map((e) => CharacterBookEntry.fromJson(e as Map<String, dynamic>))
            .toList() ?? [],
        extensions: json['extensions'] as Map<String, dynamic>? ?? {},
      );
}

/// Entry in a character book (embedded lorebook)
class CharacterBookEntry {
  final int id;
  final List<String> keys;
  final List<String> secondaryKeys;
  final String content;
  final String comment;
  final bool enabled;
  final int insertionOrder;
  final bool caseSensitive;
  final String name;
  final int priority;
  final bool constant;
  final bool selective;
  final int position; // 0 = before char defs, 1 = after char defs
  final Map<String, dynamic> extensions;

  const CharacterBookEntry({
    required this.id,
    this.keys = const [],
    this.secondaryKeys = const [],
    this.content = '',
    this.comment = '',
    this.enabled = true,
    this.insertionOrder = 0,
    this.caseSensitive = false,
    this.name = '',
    this.priority = 10,
    this.constant = false,
    this.selective = false,
    this.position = 0,
    this.extensions = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'keys': keys,
        'secondary_keys': secondaryKeys,
        'content': content,
        'comment': comment,
        'enabled': enabled,
        'insertion_order': insertionOrder,
        'case_sensitive': caseSensitive,
        'name': name,
        'priority': priority,
        'constant': constant,
        'selective': selective,
        'position': position,
        'extensions': extensions,
      };

  factory CharacterBookEntry.fromJson(Map<String, dynamic> json) => CharacterBookEntry(
        id: json['id'] as int? ?? 0,
        keys: (json['keys'] as List<dynamic>?)?.cast<String>() ?? [],
        secondaryKeys: (json['secondary_keys'] as List<dynamic>?)?.cast<String>() ?? [],
        content: json['content'] as String? ?? '',
        comment: json['comment'] as String? ?? '',
        enabled: json['enabled'] as bool? ?? true,
        insertionOrder: json['insertion_order'] as int? ?? 0,
        caseSensitive: json['case_sensitive'] as bool? ?? false,
        name: json['name'] as String? ?? '',
        priority: json['priority'] as int? ?? 10,
        constant: json['constant'] as bool? ?? false,
        selective: json['selective'] as bool? ?? false,
        position: json['position'] as int? ?? 0,
        extensions: json['extensions'] as Map<String, dynamic>? ?? {},
      );
}