/// Regex script model for find/replace patterns in messages
/// Based on SillyTavern's regex extension

/// Where the regex script should be applied
enum RegexPlacement {
  /// User input before sending
  userInput,
  /// AI output after receiving
  aiOutput,
  /// Slash command processing
  slashCommand,
  /// World info entries
  worldInfo,
  /// Reasoning/thinking blocks
  reasoning,
}

/// Script scope/type
enum RegexScriptType {
  /// Global scripts (app-wide)
  global,
  /// Character-scoped scripts
  character,
  /// Chat-scoped scripts
  chat,
}

/// How to substitute parameters in the find regex
enum SubstituteRegex {
  /// No substitution
  none,
  /// Raw substitution (macros expanded as-is)
  raw,
  /// Escaped substitution (special regex chars escaped)
  escaped,
}

/// A regex script for find/replace operations
class RegexScript {
  /// Unique identifier
  final String id;
  
  /// Display name for the script
  final String scriptName;
  
  /// Description of what the script does
  final String? description;
  
  /// Whether the script is disabled
  final bool disabled;
  
  /// The regex pattern to find
  final String findRegex;
  
  /// The replacement string (supports $1, $2, etc. for capture groups)
  final String replaceString;
  
  /// Strings to trim from matches
  final List<String> trimStrings;
  
  /// Where this script applies
  final List<RegexPlacement> placement;
  
  /// Script type/scope
  final RegexScriptType scriptType;
  
  /// Only apply to markdown rendering
  final bool markdownOnly;
  
  /// Only apply during prompt generation
  final bool promptOnly;
  
  /// Run on message edit
  final bool runOnEdit;
  
  /// How to substitute macros in the find regex
  final SubstituteRegex substituteRegex;
  
  /// Minimum message depth to apply (-1 for no limit)
  final int? minDepth;
  
  /// Maximum message depth to apply (-1 for no limit)
  final int? maxDepth;
  
  /// Order for script execution (lower = earlier)
  final int order;
  
  /// Associated character ID (for character-scoped scripts)
  final String? characterId;
  
  /// Associated chat ID (for chat-scoped scripts)
  final String? chatId;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last modified timestamp
  final DateTime updatedAt;

  const RegexScript({
    required this.id,
    required this.scriptName,
    this.description,
    this.disabled = false,
    required this.findRegex,
    required this.replaceString,
    this.trimStrings = const [],
    required this.placement,
    this.scriptType = RegexScriptType.global,
    this.markdownOnly = false,
    this.promptOnly = false,
    this.runOnEdit = false,
    this.substituteRegex = SubstituteRegex.none,
    this.minDepth,
    this.maxDepth,
    this.order = 0,
    this.characterId,
    this.chatId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  RegexScript copyWith({
    String? id,
    String? scriptName,
    String? description,
    bool? disabled,
    String? findRegex,
    String? replaceString,
    List<String>? trimStrings,
    List<RegexPlacement>? placement,
    RegexScriptType? scriptType,
    bool? markdownOnly,
    bool? promptOnly,
    bool? runOnEdit,
    SubstituteRegex? substituteRegex,
    int? minDepth,
    int? maxDepth,
    int? order,
    String? characterId,
    String? chatId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RegexScript(
      id: id ?? this.id,
      scriptName: scriptName ?? this.scriptName,
      description: description ?? this.description,
      disabled: disabled ?? this.disabled,
      findRegex: findRegex ?? this.findRegex,
      replaceString: replaceString ?? this.replaceString,
      trimStrings: trimStrings ?? this.trimStrings,
      placement: placement ?? this.placement,
      scriptType: scriptType ?? this.scriptType,
      markdownOnly: markdownOnly ?? this.markdownOnly,
      promptOnly: promptOnly ?? this.promptOnly,
      runOnEdit: runOnEdit ?? this.runOnEdit,
      substituteRegex: substituteRegex ?? this.substituteRegex,
      minDepth: minDepth ?? this.minDepth,
      maxDepth: maxDepth ?? this.maxDepth,
      order: order ?? this.order,
      characterId: characterId ?? this.characterId,
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scriptName': scriptName,
      'description': description,
      'disabled': disabled,
      'findRegex': findRegex,
      'replaceString': replaceString,
      'trimStrings': trimStrings,
      'placement': placement.map((p) => p.name).toList(),
      'scriptType': scriptType.name,
      'markdownOnly': markdownOnly,
      'promptOnly': promptOnly,
      'runOnEdit': runOnEdit,
      'substituteRegex': substituteRegex.name,
      'minDepth': minDepth,
      'maxDepth': maxDepth,
      'order': order,
      'characterId': characterId,
      'chatId': chatId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory RegexScript.fromJson(Map<String, dynamic> json) {
    return RegexScript(
      id: json['id'] as String,
      scriptName: json['scriptName'] as String,
      description: json['description'] as String?,
      disabled: json['disabled'] as bool? ?? false,
      findRegex: json['findRegex'] as String,
      replaceString: json['replaceString'] as String,
      trimStrings: (json['trimStrings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      placement: (json['placement'] as List<dynamic>?)
          ?.map((e) => RegexPlacement.values.firstWhere(
                (p) => p.name == e,
                orElse: () => RegexPlacement.aiOutput,
              ))
          .toList() ?? [RegexPlacement.aiOutput],
      scriptType: RegexScriptType.values.firstWhere(
        (t) => t.name == json['scriptType'],
        orElse: () => RegexScriptType.global,
      ),
      markdownOnly: json['markdownOnly'] as bool? ?? false,
      promptOnly: json['promptOnly'] as bool? ?? false,
      runOnEdit: json['runOnEdit'] as bool? ?? false,
      substituteRegex: SubstituteRegex.values.firstWhere(
        (s) => s.name == json['substituteRegex'],
        orElse: () => SubstituteRegex.none,
      ),
      minDepth: json['minDepth'] as int?,
      maxDepth: json['maxDepth'] as int?,
      order: json['order'] as int? ?? 0,
      characterId: json['characterId'] as String?,
      chatId: json['chatId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  @override
  String toString() => 'RegexScript(id: $id, name: $scriptName, find: $findRegex)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegexScript &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Extension methods for RegexPlacement
extension RegexPlacementExtension on RegexPlacement {
  String get displayName {
    switch (this) {
      case RegexPlacement.userInput:
        return 'User Input';
      case RegexPlacement.aiOutput:
        return 'AI Output';
      case RegexPlacement.slashCommand:
        return 'Slash Command';
      case RegexPlacement.worldInfo:
        return 'World Info';
      case RegexPlacement.reasoning:
        return 'Reasoning';
    }
  }

  String get description {
    switch (this) {
      case RegexPlacement.userInput:
        return 'Apply to user messages before sending';
      case RegexPlacement.aiOutput:
        return 'Apply to AI responses after receiving';
      case RegexPlacement.slashCommand:
        return 'Apply during slash command processing';
      case RegexPlacement.worldInfo:
        return 'Apply to world info entries';
      case RegexPlacement.reasoning:
        return 'Apply to reasoning/thinking blocks';
    }
  }
}

/// Extension methods for RegexScriptType
extension RegexScriptTypeExtension on RegexScriptType {
  String get displayName {
    switch (this) {
      case RegexScriptType.global:
        return 'Global';
      case RegexScriptType.character:
        return 'Character';
      case RegexScriptType.chat:
        return 'Chat';
    }
  }

  String get description {
    switch (this) {
      case RegexScriptType.global:
        return 'Applies to all chats';
      case RegexScriptType.character:
        return 'Applies only to specific character';
      case RegexScriptType.chat:
        return 'Applies only to specific chat';
    }
  }
}