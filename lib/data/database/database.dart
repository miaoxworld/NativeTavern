import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

/// Characters table
class Characters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get personality => text().withDefault(const Constant(''))();
  TextColumn get scenario => text().withDefault(const Constant(''))();
  TextColumn get firstMessage => text().withDefault(const Constant(''))();
  TextColumn get alternateGreetings => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get exampleDialogue => text().withDefault(const Constant(''))();
  TextColumn get systemPrompt => text().withDefault(const Constant(''))();
  TextColumn get postHistoryInstructions => text().withDefault(const Constant(''))();
  TextColumn get creatorNotes => text().withDefault(const Constant(''))();
  TextColumn get tags => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get creator => text().withDefault(const Constant(''))();
  TextColumn get characterVersion => text().withDefault(const Constant(''))();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get assetsJson => text().withDefault(const Constant('{}'))(); // JSON
  TextColumn get characterBookJson => text().withDefault(const Constant(''))(); // JSON for embedded lorebook
  TextColumn get extensionsJson => text().withDefault(const Constant('{}'))(); // JSON
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))(); // Favorite flag
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Chats table
class Chats extends Table {
  TextColumn get id => text()();
  TextColumn get characterId => text().references(Characters, #id)();
  TextColumn get groupId => text().nullable()();
  TextColumn get title => text().withDefault(const Constant('New Chat'))();
  TextColumn get settingsJson => text().withDefault(const Constant('{}'))(); // JSON
  TextColumn get authorNote => text().withDefault(const Constant(''))(); // Author's Note content
  IntColumn get authorNoteDepth => integer().withDefault(const Constant(4))(); // Depth for injection
  BoolColumn get authorNoteEnabled => boolean().withDefault(const Constant(false))(); // Whether enabled
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Messages table
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text().references(Chats, #id)();
  TextColumn get role => text()(); // user, assistant, system
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get swipes => text().withDefault(const Constant('[]'))(); // JSON array of strings
  IntColumn get currentSwipeIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isEdited => boolean().withDefault(const Constant(false))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))(); // JSON
  TextColumn get characterId => text().nullable()(); // For group chats - which character sent this
  TextColumn get characterName => text().nullable()(); // Cached character name
  TextColumn get attachmentsJson => text().withDefault(const Constant('[]'))(); // JSON array of attachments

  @override
  Set<Column> get primaryKey => {id};
}

/// World Info table
class WorldInfos extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isGlobal => boolean().withDefault(const Constant(false))();
  TextColumn get characterId => text().nullable().references(Characters, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// World Info Entries table
class WorldInfoEntries extends Table {
  TextColumn get id => text()();
  TextColumn get worldInfoId => text().references(WorldInfos, #id)();
  TextColumn get keys => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get secondaryKeys => text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get comment => text().withDefault(const Constant(''))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get constant => boolean().withDefault(const Constant(false))();
  BoolColumn get selective => boolean().withDefault(const Constant(false))();
  IntColumn get insertionOrder => integer().withDefault(const Constant(0))();
  BoolColumn get caseSensitive => boolean().withDefault(const Constant(false))();
  BoolColumn get matchWholeWords => boolean().withDefault(const Constant(false))();
  IntColumn get probability => integer().withDefault(const Constant(100))();
  IntColumn get position => integer().withDefault(const Constant(1))();
  IntColumn get depth => integer().withDefault(const Constant(4))();
  TextColumn get group => text().nullable()();
  IntColumn get groupWeight => integer().withDefault(const Constant(100))();
  BoolColumn get preventRecursion => boolean().withDefault(const Constant(false))();
  IntColumn get scanDepth => integer().withDefault(const Constant(1000))();
  TextColumn get extensionsJson => text().withDefault(const Constant('{}'))(); // JSON

  @override
  Set<Column> get primaryKey => {id};
}

/// LLM Configs table
class LlmConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get provider => text()();
  TextColumn get endpoint => text()();
  TextColumn get apiKey => text().nullable()();
  TextColumn get model => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  TextColumn get defaultSettingsJson => text().withDefault(const Constant('{}'))(); // JSON
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Personas table - user profiles for roleplay
class Personas extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get avatarPath => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Groups table - multi-character conversations
class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get membersJson => text().withDefault(const Constant('[]'))(); // JSON array of GroupMember
  TextColumn get settingsJson => text().withDefault(const Constant('{}'))(); // JSON GroupSettings
  TextColumn get avatarPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Bookmarks table - chat checkpoints/branches
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text().references(Chats, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get messageId => text()(); // The message this bookmark points to
  IntColumn get messageIndex => integer()(); // Index in the chat
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tags table - for categorizing characters
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()(); // Hex color string
  TextColumn get icon => text().nullable()(); // Icon name or emoji
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Character-Tags junction table
class CharacterTags extends Table {
  TextColumn get characterId => text().references(Characters, #id)();
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {characterId, tagId};
}

/// App database
@DriftDatabase(tables: [
  Characters,
  Chats,
  Messages,
  WorldInfos,
  WorldInfoEntries,
  LlmConfigs,
  Personas,
  Groups,
  Bookmarks,
  Tags,
  CharacterTags,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations
        if (from < 2) {
          // Add swipes columns to messages
          await m.addColumn(messages, messages.swipes);
          await m.addColumn(messages, messages.currentSwipeIndex);
        }
        if (from < 3) {
          // Add personas table
          await m.createTable(personas);
        }
        if (from < 4) {
          // Add groups and bookmarks tables
          await m.createTable(groups);
          await m.createTable(bookmarks);
        }
        if (from < 5) {
          // Add characterId and characterName to messages for group chats
          await m.addColumn(messages, messages.characterId);
          await m.addColumn(messages, messages.characterName);
        }
        if (from < 6) {
          // Add alternateGreetings and characterBookJson to characters
          await m.addColumn(characters, characters.alternateGreetings);
          await m.addColumn(characters, characters.characterBookJson);
        }
        if (from < 7) {
          // Add Author's Note columns to chats
          await m.addColumn(chats, chats.authorNote);
          await m.addColumn(chats, chats.authorNoteDepth);
          await m.addColumn(chats, chats.authorNoteEnabled);
        }
        if (from < 8) {
          // Add isFavorite column to characters
          await m.addColumn(characters, characters.isFavorite);
        }
        if (from < 9) {
          // Add tags and character_tags tables
          await m.createTable(tags);
          await m.createTable(characterTags);
        }
        if (from < 10) {
          // Add attachmentsJson column to messages for image attachments
          await m.addColumn(messages, messages.attachmentsJson);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'NativeTavern', 'database.sqlite'));
    
    // Ensure directory exists
    await file.parent.create(recursive: true);
    
    return NativeDatabase.createInBackground(file);
  });
}