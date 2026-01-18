import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona.freezed.dart';
part 'persona.g.dart';

/// Lock type for persona - determines when persona is locked to a chat/character
enum PersonaLockType {
  /// No lock - persona can be changed freely
  none,
  /// Locked to current chat - persona persists for this chat only
  chat,
  /// Locked to character - persona is always used with this character
  character,
  /// Default lock - this is the default persona
  defaultLock,
}

/// Position for persona description in the prompt
enum PersonaDescriptionPosition {
  /// Before character description
  beforeChar,
  /// After character description  
  afterChar,
  /// At specific depth in chat history
  atDepth,
  /// In system prompt
  inSystemPrompt,
  /// Top of Author's Note
  topAN,
  /// Bottom of Author's Note
  bottomAN,
}

/// Role for persona description message
enum PersonaDescriptionRole {
  system,
  user,
  assistant,
}

/// Connection between persona and character/group
@freezed
class PersonaConnection with _$PersonaConnection {
  const factory PersonaConnection({
    /// Character ID this persona is connected to (null for groups)
    String? characterId,
    /// Group ID this persona is connected to (null for characters)
    String? groupId,
    /// Lock type for this connection
    @Default(PersonaLockType.none) PersonaLockType lockType,
  }) = _PersonaConnection;

  factory PersonaConnection.fromJson(Map<String, dynamic> json) =>
      _$PersonaConnectionFromJson(json);
}

/// Persona description settings
@freezed
class PersonaDescriptionSettings with _$PersonaDescriptionSettings {
  const factory PersonaDescriptionSettings({
    /// Position where description is inserted
    @Default(PersonaDescriptionPosition.beforeChar)
    PersonaDescriptionPosition position,
    /// Depth for atDepth position (0 = after last message)
    @Default(0) int depth,
    /// Role for the description message
    @Default(PersonaDescriptionRole.system) PersonaDescriptionRole role,
  }) = _PersonaDescriptionSettings;

  factory PersonaDescriptionSettings.fromJson(Map<String, dynamic> json) =>
      _$PersonaDescriptionSettingsFromJson(json);
}

/// Persona model - represents a user profile for roleplay
@freezed
class Persona with _$Persona {
  const factory Persona({
    required String id,
    required String name,
    @Default('') String description,
    String? avatarPath,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
    
    // === New fields for SillyTavern compatibility ===
    
    /// Connections to characters/groups
    @Default([]) List<PersonaConnection> connections,
    
    /// Description settings (position, depth, role)
    @Default(PersonaDescriptionSettings())
    PersonaDescriptionSettings descriptionSettings,
    
    /// Persona-specific lorebook/world info ID
    /// If set, this world info is activated when persona is active
    String? lorebookId,
    
    /// Custom system prompt override for this persona
    String? systemPromptOverride,
    
    /// Custom post-history instructions for this persona
    String? postHistoryInstructions,
    
    /// Tags for organization
    @Default([]) List<String> tags,
    
    /// Creator notes (not sent to AI)
    @Default('') String creatorNotes,
    
    /// Favorite status
    @Default(false) bool isFavorite,
  }) = _Persona;

  factory Persona.fromJson(Map<String, dynamic> json) => _$PersonaFromJson(json);
}

/// Extension methods for Persona
extension PersonaExtension on Persona {
  /// Check if persona is connected to a specific character
  bool isConnectedToCharacter(String characterId) {
    return connections.any((c) => c.characterId == characterId);
  }

  /// Check if persona is connected to a specific group
  bool isConnectedToGroup(String groupId) {
    return connections.any((c) => c.groupId == groupId);
  }

  /// Get connection for a specific character
  PersonaConnection? getCharacterConnection(String characterId) {
    try {
      return connections.firstWhere((c) => c.characterId == characterId);
    } catch (_) {
      return null;
    }
  }

  /// Get connection for a specific group
  PersonaConnection? getGroupConnection(String groupId) {
    try {
      return connections.firstWhere((c) => c.groupId == groupId);
    } catch (_) {
      return null;
    }
  }

  /// Check if persona is locked to a chat
  bool get isLockedToChat {
    return connections.any((c) => c.lockType == PersonaLockType.chat);
  }

  /// Check if persona is locked to a character
  bool get isLockedToCharacter {
    return connections.any((c) => c.lockType == PersonaLockType.character);
  }
}

/// Default persona for new users
Persona createDefaultPersona() {
  final now = DateTime.now();
  return Persona(
    id: 'default',
    name: 'User',
    description: '',
    isDefault: true,
    createdAt: now,
    updatedAt: now,
  );
}

/// Create a persona from SillyTavern format
Persona personaFromSillyTavern(Map<String, dynamic> json) {
  final now = DateTime.now();
  
  // Parse description position
  PersonaDescriptionPosition position = PersonaDescriptionPosition.beforeChar;
  if (json['description_position'] != null) {
    switch (json['description_position']) {
      case 0:
        position = PersonaDescriptionPosition.inSystemPrompt;
        break;
      case 1:
        position = PersonaDescriptionPosition.beforeChar;
        break;
      case 2:
        position = PersonaDescriptionPosition.afterChar;
        break;
      case 3:
        position = PersonaDescriptionPosition.topAN;
        break;
      case 4:
        position = PersonaDescriptionPosition.bottomAN;
        break;
      case 5:
        position = PersonaDescriptionPosition.atDepth;
        break;
    }
  }
  
  // Parse description role
  PersonaDescriptionRole role = PersonaDescriptionRole.system;
  if (json['description_role'] != null) {
    switch (json['description_role']) {
      case 0:
        role = PersonaDescriptionRole.system;
        break;
      case 1:
        role = PersonaDescriptionRole.user;
        break;
      case 2:
        role = PersonaDescriptionRole.assistant;
        break;
    }
  }
  
  return Persona(
    id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: json['name'] ?? 'Unknown',
    description: json['description'] ?? '',
    avatarPath: json['avatar'],
    isDefault: json['default'] ?? false,
    createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at']) ?? now 
        : now,
    updatedAt: now,
    descriptionSettings: PersonaDescriptionSettings(
      position: position,
      depth: json['description_depth'] ?? 0,
      role: role,
    ),
    lorebookId: json['lorebook'],
    tags: json['tags'] != null 
        ? List<String>.from(json['tags']) 
        : [],
    creatorNotes: json['creator_notes'] ?? '',
  );
}

/// Convert persona to SillyTavern format
Map<String, dynamic> personaToSillyTavern(Persona persona) {
  // Convert position to SillyTavern format
  int positionValue = 1; // default: before char
  switch (persona.descriptionSettings.position) {
    case PersonaDescriptionPosition.inSystemPrompt:
      positionValue = 0;
      break;
    case PersonaDescriptionPosition.beforeChar:
      positionValue = 1;
      break;
    case PersonaDescriptionPosition.afterChar:
      positionValue = 2;
      break;
    case PersonaDescriptionPosition.topAN:
      positionValue = 3;
      break;
    case PersonaDescriptionPosition.bottomAN:
      positionValue = 4;
      break;
    case PersonaDescriptionPosition.atDepth:
      positionValue = 5;
      break;
  }
  
  // Convert role to SillyTavern format
  int roleValue = 0; // default: system
  switch (persona.descriptionSettings.role) {
    case PersonaDescriptionRole.system:
      roleValue = 0;
      break;
    case PersonaDescriptionRole.user:
      roleValue = 1;
      break;
    case PersonaDescriptionRole.assistant:
      roleValue = 2;
      break;
  }
  
  return {
    'id': persona.id,
    'name': persona.name,
    'description': persona.description,
    'avatar': persona.avatarPath,
    'default': persona.isDefault,
    'created_at': persona.createdAt.toIso8601String(),
    'description_position': positionValue,
    'description_depth': persona.descriptionSettings.depth,
    'description_role': roleValue,
    'lorebook': persona.lorebookId,
    'tags': persona.tags,
    'creator_notes': persona.creatorNotes,
  };
}
