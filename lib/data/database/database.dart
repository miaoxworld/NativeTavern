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
  TextColumn get alternateGreetings =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get exampleDialogue => text().withDefault(const Constant(''))();
  TextColumn get systemPrompt => text().withDefault(const Constant(''))();
  TextColumn get postHistoryInstructions =>
      text().withDefault(const Constant(''))();
  TextColumn get creatorNotes => text().withDefault(const Constant(''))();
  TextColumn get tags =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get creator => text().withDefault(const Constant(''))();
  TextColumn get characterVersion => text().withDefault(const Constant(''))();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get assetsJson =>
      text().withDefault(const Constant('{}'))(); // JSON
  TextColumn get characterBookJson =>
      text().withDefault(const Constant(''))(); // JSON for embedded lorebook
  TextColumn get extensionsJson =>
      text().withDefault(const Constant('{}'))(); // JSON
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))(); // Favorite flag
  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false))(); // Soft deletion marker
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
  TextColumn get settingsJson =>
      text().withDefault(const Constant('{}'))(); // JSON
  TextColumn get authorNote =>
      text().withDefault(const Constant(''))(); // Author's Note content
  IntColumn get authorNoteDepth =>
      integer().withDefault(const Constant(4))(); // Depth for injection
  BoolColumn get authorNoteEnabled =>
      boolean().withDefault(const Constant(false))(); // Whether enabled
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
  TextColumn get swipes =>
      text().withDefault(const Constant('[]'))(); // JSON array of strings
  IntColumn get currentSwipeIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isEdited => boolean().withDefault(const Constant(false))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
  TextColumn get metadataJson =>
      text().withDefault(const Constant('{}'))(); // JSON
  TextColumn get characterId =>
      text().nullable()(); // For group chats - which character sent this
  TextColumn get characterName => text().nullable()(); // Cached character name
  TextColumn get attachmentsJson =>
      text().withDefault(const Constant('[]'))(); // JSON array of attachments

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
  TextColumn get scanDepth =>
      text().nullable()(); // Default scan depth for entries
  BoolColumn get caseSensitive =>
      boolean().nullable()(); // Default case sensitivity
  BoolColumn get matchWholeWords =>
      boolean().nullable()(); // Default match whole words
  BoolColumn get useGroupScoring =>
      boolean().nullable()(); // Default group scoring
  IntColumn get recursionDepth => integer().nullable()(); // Max recursion depth
  TextColumn get extensionsJson =>
      text().withDefault(const Constant('{}'))(); // JSON extensions
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// World Info Entries table
class WorldInfoEntries extends Table {
  TextColumn get id => text()();
  TextColumn get worldInfoId => text().references(WorldInfos, #id)();
  TextColumn get keys =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get secondaryKeys =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get comment => text().withDefault(const Constant(''))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get constant => boolean().withDefault(const Constant(false))();
  BoolColumn get selective => boolean().withDefault(const Constant(false))();
  IntColumn get insertionOrder => integer().withDefault(const Constant(0))();
  BoolColumn get caseSensitive =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get matchWholeWords =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get useGroupScoring =>
      boolean().withDefault(const Constant(false))();
  TextColumn get automationId => text().withDefault(const Constant(''))();
  IntColumn get probability => integer().withDefault(const Constant(100))();
  IntColumn get position => integer().withDefault(const Constant(1))();
  IntColumn get depth => integer().withDefault(const Constant(4))();
  TextColumn get group => text().nullable()();
  IntColumn get groupWeight => integer().withDefault(const Constant(100))();
  BoolColumn get preventRecursion =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get delayUntilRecursion =>
      boolean().withDefault(const Constant(false))();
  IntColumn get scanDepth => integer().withDefault(const Constant(1000))();
  TextColumn get extensionsJson =>
      text().withDefault(const Constant('{}'))(); // JSON

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
  TextColumn get defaultSettingsJson =>
      text().withDefault(const Constant('{}'))(); // JSON
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
  TextColumn get connectionsJson => text().withDefault(const Constant('[]'))();
  TextColumn get descriptionSettingsJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get lorebookId => text().nullable()();
  TextColumn get systemPromptOverride => text().nullable()();
  TextColumn get postHistoryInstructions => text().nullable()();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get creatorNotes => text().withDefault(const Constant(''))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
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
  TextColumn get membersJson =>
      text().withDefault(const Constant('[]'))(); // JSON array of GroupMember
  TextColumn get settingsJson =>
      text().withDefault(const Constant('{}'))(); // JSON GroupSettings
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

/// Global States table - Key-Value store for app settings, active configs, etc.
/// Replaces SharedPreferences for critical data that needs to be backed up.
class GlobalStates extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()(); // JSON content
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('LongTermMemoryRow')
class LongTermMemories extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get scopeKind => text()();
  TextColumn get characterId => text()
      .nullable()
      .references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get personaId => text()
      .nullable()
      .references(Personas, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('memoryScopeChat')
  TextColumn get chatId =>
      text().nullable().references(Chats, #id, onDelete: KeyAction.cascade)();
  TextColumn get groupId =>
      text().nullable().references(Groups, #id, onDelete: KeyAction.cascade)();
  TextColumn get state => text()();
  TextColumn get content => text()();
  TextColumn get sourceOrigin => text()();
  @ReferenceName('memorySourceChat')
  TextColumn get sourceChatId =>
      text().nullable().references(Chats, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get extractedAt => dateTime().nullable()();
  TextColumn get providerId => text().nullable()();
  TextColumn get modelId => text().nullable()();
  RealColumn get importance => real()();
  RealColumn get confidence => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  BoolColumn get locked => boolean().withDefault(const Constant(false))();
  TextColumn get normalizedIdentityKey => text()();
  TextColumn get supersededByMemoryId => text().nullable().references(
        LongTermMemories,
        #id,
        onDelete: KeyAction.setNull,
        initiallyDeferred: true,
      )();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'CHECK (importance >= 0 AND importance <= 1)',
        'CHECK (confidence >= 0 AND confidence <= 1)',
        'CHECK ((state = \'superseded\') = '
            '(superseded_by_memory_id IS NOT NULL))',
        'CHECK ('
            "(scope_kind = 'character' AND character_id IS NOT NULL AND "
            'persona_id IS NULL AND chat_id IS NULL AND group_id IS NULL) OR '
            "(scope_kind = 'characterPersona' AND character_id IS NOT NULL AND "
            'persona_id IS NOT NULL AND chat_id IS NULL AND group_id IS NULL) OR '
            "(scope_kind = 'chat' AND character_id IS NULL AND "
            'persona_id IS NULL AND chat_id IS NOT NULL AND group_id IS NULL) OR '
            "(scope_kind = 'group' AND character_id IS NULL AND "
            'persona_id IS NULL AND chat_id IS NULL AND group_id IS NOT NULL)'
            ')',
      ];
}

@DataClassName('LongTermMemorySourceMessageRow')
class LongTermMemorySourceMessages extends Table {
  TextColumn get memoryId => text().references(
        LongTermMemories,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get messageId =>
      text().references(Messages, #id, onDelete: KeyAction.cascade)();
  IntColumn get ordinal => integer()();

  @override
  Set<Column> get primaryKey => {memoryId, messageId};
}

@DataClassName('RpgScenarioRow')
class RpgScenarios extends Table {
  TextColumn get id => text()();
  TextColumn get version => text()();
  IntColumn get contractSchemaVersion => integer()();
  TextColumn get scenarioJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RpgStateSnapshotRow')
class RpgStateSnapshots extends Table {
  TextColumn get id => text()();
  TextColumn get scenarioId =>
      text().references(RpgScenarios, #id, onDelete: KeyAction.cascade)();
  TextColumn get scenarioVersion => text()();
  TextColumn get branchId => text()();
  TextColumn get parentSnapshotId => text().nullable().references(
        RpgStateSnapshots,
        #id,
        onDelete: KeyAction.setNull,
        initiallyDeferred: true,
      )();
  IntColumn get turn => integer()();
  IntColumn get randomState => integer()();
  IntColumn get rollsConsumed => integer()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get stateHash => text().nullable()();
  TextColumn get snapshotJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RpgChatStateRow')
class RpgChatStates extends Table {
  TextColumn get chatId =>
      text().references(Chats, #id, onDelete: KeyAction.cascade)();
  TextColumn get scenarioId =>
      text().references(RpgScenarios, #id, onDelete: KeyAction.cascade)();
  TextColumn get currentSnapshotId => text().nullable().references(
        RpgStateSnapshots,
        #id,
        onDelete: KeyAction.setNull,
      )();
  IntColumn get turn => integer()();
  TextColumn get stateJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {chatId};
}

@DataClassName('DataBankDocumentRow')
class DataBankDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get currentVersionId => text().nullable()();
  TextColumn get processingState => text()();
  TextColumn get indexState => text()();
  TextColumn get failureJson => text().nullable()();
  TextColumn get reprocessingJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isPlaceholder =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DataBankDocumentVersionRow')
class DataBankDocumentVersions extends Table {
  TextColumn get id => text()();
  TextColumn get documentId =>
      text().references(DataBankDocuments, #id, onDelete: KeyAction.cascade)();
  IntColumn get versionNumber => integer()();
  TextColumn get supersedesVersionId => text().nullable().references(
        DataBankDocumentVersions,
        #id,
        onDelete: KeyAction.restrict,
      )();
  TextColumn get originalFileName => text()();
  TextColumn get mediaType => text()();
  IntColumn get byteSize => integer()();
  TextColumn get hashAlgorithm => text()();
  TextColumn get hashDigest => text()();
  DateTimeColumn get importedAt => dateTime()();
  TextColumn get processingState => text()();
  TextColumn get indexState => text()();
  TextColumn get failureJson => text().nullable()();
  TextColumn get reprocessingJson => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {documentId, versionNumber},
        {documentId, hashAlgorithm, hashDigest},
      ];

  @override
  List<String> get customConstraints => const [
        'CHECK (version_number >= 1)',
        'CHECK (byte_size >= 0)',
      ];
}

@DataClassName('DataBankSectionRow')
class DataBankSections extends Table {
  TextColumn get id => text()();
  TextColumn get documentVersionId => text().references(
        DataBankDocumentVersions,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get kind => text()();
  TextColumn get title => text().nullable()();
  IntColumn get ordinal => integer()();
  TextColumn get parentSectionId => text().nullable().references(
        DataBankSections,
        #id,
        onDelete: KeyAction.setNull,
        initiallyDeferred: true,
      )();
  TextColumn get locatorJson => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {documentVersionId, ordinal},
      ];
}

@DataClassName('DataBankTextChunkRow')
class DataBankTextChunks extends Table {
  TextColumn get id => text()();
  TextColumn get documentVersionId => text().references(
        DataBankDocumentVersions,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get sectionId => text().nullable().references(
        DataBankSections,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get ordinal => integer()();
  TextColumn get textContent => text()();
  TextColumn get locatorJson => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {documentVersionId, ordinal},
      ];
}

@DataClassName('StoryChapterRow')
class StoryChapters extends Table {
  TextColumn get id => text()();
  TextColumn get chatId =>
      text().references(Chats, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  TextColumn get narrativeJson => text().withDefault(const Constant('{}'))();
  @ReferenceName('storyChapterStartMessage')
  TextColumn get startMessageId =>
      text().references(Messages, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('storyChapterEndMessage')
  TextColumn get endMessageId =>
      text().references(Messages, #id, onDelete: KeyAction.cascade)();
  IntColumn get startOrdinal => integer()();
  IntColumn get endOrdinal => integer()();
  TextColumn get origin => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        'CHECK (start_ordinal >= 0)',
        'CHECK (end_ordinal >= start_ordinal)',
        "CHECK (origin IN ('auto', 'manual'))",
      ];
}

@DataClassName('MomentPostRow')
class MomentPosts extends Table {
  TextColumn get id => text()();
  TextColumn get chatId =>
      text().nullable().references(Chats, #id, onDelete: KeyAction.cascade)();
  TextColumn get authorId => text()();
  TextColumn get authorName => text()();
  TextColumn get publicBody => text()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get factBody => text().nullable()();
  TextColumn get chapterId => text().nullable().references(
        StoryChapters,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get origin => text()();
  TextColumn get status => text()();
  BoolColumn get writeToWorld => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        "CHECK (origin IN ('chapter', 'user', 'character'))",
        "CHECK (status IN ('open', 'waiting', 'ignored'))",
        "CHECK (origin != 'chapter' OR chapter_id IS NOT NULL)",
        'CHECK (length(public_body) > 0 OR image_path IS NOT NULL)',
      ];
}

@DataClassName('MomentCommentRow')
class MomentComments extends Table {
  TextColumn get id => text()();
  TextColumn get postId =>
      text().references(MomentPosts, #id, onDelete: KeyAction.cascade)();
  TextColumn get authorId => text()();
  TextColumn get authorName => text()();
  TextColumn get body => text()();
  TextColumn get kind => text()();
  TextColumn get parentCommentId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
        "CHECK (kind IN ('comment', 'expose', 'character'))",
      ];
}

@DataClassName('MomentPostLikeRow')
class MomentPostLikes extends Table {
  TextColumn get postId =>
      text().references(MomentPosts, #id, onDelete: KeyAction.cascade)();
  TextColumn get authorId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {postId, authorId};
}

@DataClassName('DataBankBindingRow')
class DataBankBindings extends Table {
  TextColumn get id => text()();
  TextColumn get documentId =>
      text().references(DataBankDocuments, #id, onDelete: KeyAction.cascade)();
  TextColumn get scope => text()();
  TextColumn get characterId => text()
      .nullable()
      .references(Characters, #id, onDelete: KeyAction.cascade)();
  TextColumn get chatId =>
      text().nullable().references(Chats, #id, onDelete: KeyAction.cascade)();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {documentId, scope, characterId, chatId},
      ];

  @override
  List<String> get customConstraints => const [
        'CHECK ('
            "(scope = 'global' AND character_id IS NULL AND chat_id IS NULL) OR "
            "(scope = 'character' AND character_id IS NOT NULL AND chat_id IS NULL) OR "
            "(scope = 'chat' AND character_id IS NULL AND chat_id IS NOT NULL)"
            ')',
      ];
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
  GlobalStates,
  LongTermMemories,
  LongTermMemorySourceMessages,
  RpgScenarios,
  RpgStateSnapshots,
  RpgChatStates,
  DataBankDocuments,
  DataBankDocumentVersions,
  DataBankSections,
  DataBankTextChunks,
  DataBankBindings,
  StoryChapters,
  MomentPosts,
  MomentComments,
  MomentPostLikes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 23;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createV15Indexes();
        await _createV15Triggers();
        await _createV16Indexes();
        await _createV17Indexes();
        await _createV18Indexes();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from > to) {
          throw UnsupportedError(
            'Database downgrade is not supported: schema $from -> $to',
          );
        }

        // SQLite supports transactional DDL. Keep the version upgrade atomic
        // so a failed step can be retried from the unchanged legacy schema.
        await transaction(() async {
          // Older app binaries used the same callback for downgrades. They could
          // lower user_version without changing the schema, causing the next
          // current app launch to replay migrations against current tables.
          if (to == schemaVersion && await _hasCompleteCurrentTableLayout()) {
            await _createV15Indexes();
            await _createV15Triggers();
            await _createV16Indexes();
            await _createV17Indexes();
            await _createV18Indexes();
            await _repairMomentCommentsForeignKey();
            await _ensureCharacterFriendshipsTable();
            await _ensureOperationLogsTable();
            return;
          }

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
          if (from < 11) {
            // Add missing SillyTavern-compatible fields to world info entries
            await m.addColumn(
                worldInfoEntries, worldInfoEntries.useGroupScoring);
            await m.addColumn(worldInfoEntries, worldInfoEntries.automationId);
            await m.addColumn(
                worldInfoEntries, worldInfoEntries.delayUntilRecursion);
          }
          if (from < 12) {
            // Add missing SillyTavern-compatible fields to world infos
            await m.addColumn(worldInfos, worldInfos.scanDepth);
            await m.addColumn(worldInfos, worldInfos.caseSensitive);
            await m.addColumn(worldInfos, worldInfos.matchWholeWords);
            await m.addColumn(worldInfos, worldInfos.useGroupScoring);
            await m.addColumn(worldInfos, worldInfos.recursionDepth);
            await m.addColumn(worldInfos, worldInfos.extensionsJson);
          }
          if (from < 13) {
            // Add GlobalStates table for settings persistence
            await m.createTable(globalStates);
          }
          // Versions before v3 did not have a personas table. createTable
          // above uses the current schema, so only add these columns to an
          // existing legacy personas table.
          if (from >= 3 && from < 14) {
            await m.addColumn(personas, personas.connectionsJson);
            await m.addColumn(personas, personas.descriptionSettingsJson);
            await m.addColumn(personas, personas.lorebookId);
            await m.addColumn(personas, personas.systemPromptOverride);
            await m.addColumn(personas, personas.postHistoryInstructions);
            await m.addColumn(personas, personas.tagsJson);
            await m.addColumn(personas, personas.creatorNotes);
            await m.addColumn(personas, personas.isFavorite);
          }
          if (from < 15) {
            await _assertNoPartialV15Schema();
            await m.createTable(longTermMemories);
            await m.createTable(longTermMemorySourceMessages);
            await m.createTable(rpgScenarios);
            await m.createTable(rpgStateSnapshots);
            await m.createTable(rpgChatStates);
            await m.createTable(dataBankDocuments);
            await m.createTable(dataBankDocumentVersions);
            await m.createTable(dataBankSections);
            await m.createTable(dataBankTextChunks);
            await m.createTable(dataBankBindings);
            await _createV15Indexes();
            await _createV15Triggers();
          }
          if (from < 16) {
            await _assertNoPartialV16Schema();
            await m.createTable(storyChapters);
            await _createV16Indexes();
          }
          if (from < 17) {
            await _assertNoPartialV17Schema();
            await m.createTable(momentPosts);
            await m.createTable(momentComments);
            await _createV17Indexes();
          }
          if (from < 18) {
            await _migrateMomentPostsToV18();
            await _createV18Indexes();
          }
          if (from < 19) {
            await _repairMomentCommentsForeignKey();
          }
          if (from < 20) {
            await _ensureCharacterFriendshipsTable();
          }
          if (from < 21) {
            await _ensureOperationLogsTable();
          }
          if (from >= 16 && from < 22) {
            await m.addColumn(storyChapters, storyChapters.narrativeJson);
          }
          if (from < 23) {
            if (!await _hasColumn('characters', 'is_deleted')) {
              await m.addColumn(characters, characters.isDeleted);
            }
            if (!await _hasColumn('moment_comments', 'parent_comment_id')) {
              await m.addColumn(momentComments, momentComments.parentCommentId);
            }
            final likesExist = await customSelect(
              "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'moment_post_likes'",
            ).getSingleOrNull();
            if (likesExist == null) await m.createTable(momentPostLikes);
            await customStatement(
              'CREATE INDEX IF NOT EXISTS moment_comments_parent_idx '
              'ON moment_comments (parent_comment_id)',
            );
          }
        });
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        await _repairMomentCommentsForeignKey();
        await _ensureCharacterFriendshipsTable();
        await _ensureOperationLogsTable();
        final memorySearchIndexCreated =
            await _ensureLongTermMemorySearchIndex();
        if (memorySearchIndexCreated) {
          await _rebuildLongTermMemorySearchIndex();
        }
        final dataBankSearchIndexCreated = await _ensureDataBankSearchIndex();
        if (dataBankSearchIndexCreated) {
          await _rebuildDataBankSearchIndex();
        }
        final storySearchIndexCreated = await _ensureStoryChapterSearchIndex();
        if (storySearchIndexCreated) {
          await _rebuildStoryChapterSearchIndex();
        }
      },
    );
  }

  /// Recreates the derived long-term-memory FTS index from its content table.
  Future<void> rebuildLongTermMemorySearchIndex() async {
    await _ensureLongTermMemorySearchIndex();
    await _rebuildLongTermMemorySearchIndex();
  }

  /// Recreates the derived Data Bank FTS index from canonical text chunks.
  Future<void> rebuildDataBankSearchIndex() async {
    await _ensureDataBankSearchIndex();
    await _rebuildDataBankSearchIndex();
  }

  /// Recreates the derived story-chapter FTS index from chapter records.
  Future<void> rebuildStoryChapterSearchIndex() async {
    await _ensureStoryChapterSearchIndex();
    await _rebuildStoryChapterSearchIndex();
  }

  Future<bool> _ensureDataBankSearchIndex() async {
    final existing = await customSelect(
      'SELECT 1 AS found FROM sqlite_master '
      "WHERE type = 'table' AND name = 'data_bank_text_chunks_fts'",
    ).getSingleOrNull();
    final created = existing == null;

    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS data_bank_text_chunks_fts USING fts5(
        id UNINDEXED,
        text_content,
        content = 'data_bank_text_chunks',
        content_rowid = 'rowid',
        tokenize = 'unicode61 remove_diacritics 2'
      )
    ''');
    await _createDataBankSearchTriggers();
    return created;
  }

  Future<void> _createDataBankSearchTriggers() async {
    const statements = [
      '''
        CREATE TRIGGER IF NOT EXISTS data_bank_chunk_fts_insert
        AFTER INSERT ON data_bank_text_chunks
        BEGIN
          INSERT INTO data_bank_text_chunks_fts(rowid, id, text_content)
          VALUES (NEW.rowid, NEW.id, NEW.text_content);
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS data_bank_chunk_fts_delete
        AFTER DELETE ON data_bank_text_chunks
        BEGIN
          INSERT INTO data_bank_text_chunks_fts(
            data_bank_text_chunks_fts, rowid, id, text_content
          ) VALUES ('delete', OLD.rowid, OLD.id, OLD.text_content);
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS data_bank_chunk_fts_update
        AFTER UPDATE OF id, text_content ON data_bank_text_chunks
        BEGIN
          INSERT INTO data_bank_text_chunks_fts(
            data_bank_text_chunks_fts, rowid, id, text_content
          ) VALUES ('delete', OLD.rowid, OLD.id, OLD.text_content);
          INSERT INTO data_bank_text_chunks_fts(rowid, id, text_content)
          VALUES (NEW.rowid, NEW.id, NEW.text_content);
        END
      ''',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<void> _rebuildDataBankSearchIndex() {
    return customStatement(
      'INSERT INTO data_bank_text_chunks_fts(data_bank_text_chunks_fts) '
      "VALUES ('rebuild')",
    );
  }

  Future<bool> _ensureLongTermMemorySearchIndex() async {
    final existing = await customSelect(
      'SELECT 1 AS found FROM sqlite_master '
      "WHERE type = 'table' AND name = 'long_term_memories_fts'",
    ).getSingleOrNull();
    final created = existing == null;

    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS long_term_memories_fts USING fts5(
        id UNINDEXED,
        content,
        normalized_identity_key,
        content = 'long_term_memories',
        content_rowid = 'rowid',
        tokenize = 'unicode61 remove_diacritics 2'
      )
    ''');
    await _createLongTermMemorySearchTriggers();
    return created;
  }

  Future<void> _createLongTermMemorySearchTriggers() async {
    const statements = [
      '''
        CREATE TRIGGER IF NOT EXISTS long_term_memory_fts_insert
        AFTER INSERT ON long_term_memories
        BEGIN
          INSERT INTO long_term_memories_fts(
            rowid, id, content, normalized_identity_key
          ) VALUES (
            NEW.rowid, NEW.id, NEW.content, NEW.normalized_identity_key
          );
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS long_term_memory_fts_delete
        AFTER DELETE ON long_term_memories
        BEGIN
          INSERT INTO long_term_memories_fts(
            long_term_memories_fts,
            rowid,
            id,
            content,
            normalized_identity_key
          ) VALUES (
            'delete',
            OLD.rowid,
            OLD.id,
            OLD.content,
            OLD.normalized_identity_key
          );
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS long_term_memory_fts_update
        AFTER UPDATE OF content, normalized_identity_key ON long_term_memories
        BEGIN
          INSERT INTO long_term_memories_fts(
            long_term_memories_fts,
            rowid,
            id,
            content,
            normalized_identity_key
          ) VALUES (
            'delete',
            OLD.rowid,
            OLD.id,
            OLD.content,
            OLD.normalized_identity_key
          );
          INSERT INTO long_term_memories_fts(
            rowid, id, content, normalized_identity_key
          ) VALUES (
            NEW.rowid, NEW.id, NEW.content, NEW.normalized_identity_key
          );
        END
      ''',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<void> _rebuildLongTermMemorySearchIndex() {
    return customStatement(
      'INSERT INTO long_term_memories_fts(long_term_memories_fts) '
      "VALUES ('rebuild')",
    );
  }

  Future<bool> _ensureStoryChapterSearchIndex() async {
    final existing = await customSelect(
      'SELECT 1 AS found FROM sqlite_master '
      "WHERE type = 'table' AND name = 'story_chapters_fts'",
    ).getSingleOrNull();
    final created = existing == null;

    await customStatement('''
      CREATE VIRTUAL TABLE IF NOT EXISTS story_chapters_fts USING fts5(
        id UNINDEXED,
        title,
        summary,
        content = 'story_chapters',
        content_rowid = 'rowid',
        tokenize = 'unicode61 remove_diacritics 2'
      )
    ''');
    await _createStoryChapterSearchTriggers();
    return created;
  }

  Future<void> _createStoryChapterSearchTriggers() async {
    const statements = [
      '''
        CREATE TRIGGER IF NOT EXISTS story_chapter_fts_insert
        AFTER INSERT ON story_chapters
        BEGIN
          INSERT INTO story_chapters_fts(rowid, id, title, summary)
          VALUES (NEW.rowid, NEW.id, NEW.title, NEW.summary);
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS story_chapter_fts_delete
        AFTER DELETE ON story_chapters
        BEGIN
          INSERT INTO story_chapters_fts(
            story_chapters_fts, rowid, id, title, summary
          ) VALUES ('delete', OLD.rowid, OLD.id, OLD.title, OLD.summary);
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS story_chapter_fts_update
        AFTER UPDATE OF title, summary ON story_chapters
        BEGIN
          INSERT INTO story_chapters_fts(
            story_chapters_fts, rowid, id, title, summary
          ) VALUES ('delete', OLD.rowid, OLD.id, OLD.title, OLD.summary);
          INSERT INTO story_chapters_fts(rowid, id, title, summary)
          VALUES (NEW.rowid, NEW.id, NEW.title, NEW.summary);
        END
      ''',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<void> _rebuildStoryChapterSearchIndex() {
    return customStatement(
      'INSERT INTO story_chapters_fts(story_chapters_fts) '
      "VALUES ('rebuild')",
    );
  }

  Future<void> _createV15Indexes() async {
    const statements = [
      'CREATE INDEX IF NOT EXISTS long_term_memories_scope_idx '
          'ON long_term_memories '
          '(scope_kind, character_id, persona_id, chat_id, group_id, state)',
      'CREATE INDEX IF NOT EXISTS long_term_memories_source_chat_idx '
          'ON long_term_memories (source_chat_id)',
      'CREATE INDEX IF NOT EXISTS long_term_memory_source_message_idx '
          'ON long_term_memory_source_messages (message_id, memory_id)',
      'CREATE INDEX IF NOT EXISTS rpg_snapshots_branch_idx '
          'ON rpg_state_snapshots (scenario_id, branch_id, turn)',
      'CREATE INDEX IF NOT EXISTS data_bank_versions_document_idx '
          'ON data_bank_document_versions (document_id, version_number)',
      'CREATE INDEX IF NOT EXISTS data_bank_sections_version_idx '
          'ON data_bank_sections (document_version_id, ordinal)',
      'CREATE INDEX IF NOT EXISTS data_bank_chunks_version_idx '
          'ON data_bank_text_chunks (document_version_id, ordinal)',
      'CREATE INDEX IF NOT EXISTS data_bank_bindings_scope_idx '
          'ON data_bank_bindings (scope, character_id, chat_id, enabled)',
      'CREATE UNIQUE INDEX IF NOT EXISTS data_bank_binding_global_unique '
          "ON data_bank_bindings (document_id) WHERE scope = 'global'",
      'CREATE UNIQUE INDEX IF NOT EXISTS data_bank_binding_character_unique '
          'ON data_bank_bindings (document_id, character_id) '
          "WHERE scope = 'character'",
      'CREATE UNIQUE INDEX IF NOT EXISTS data_bank_binding_chat_unique '
          'ON data_bank_bindings (document_id, chat_id) '
          "WHERE scope = 'chat'",
    ];

    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<void> _createV16Indexes() async {
    const statements = [
      'CREATE INDEX IF NOT EXISTS story_chapters_chat_idx '
          'ON story_chapters (chat_id, end_ordinal, created_at)',
      'CREATE INDEX IF NOT EXISTS story_chapters_start_message_idx '
          'ON story_chapters (start_message_id)',
      'CREATE INDEX IF NOT EXISTS story_chapters_end_message_idx '
          'ON story_chapters (end_message_id)',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<void> _createV18Indexes() async {
    const statements = [
      'CREATE INDEX IF NOT EXISTS moment_posts_created_idx '
          'ON moment_posts (created_at, id)',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<void> _migrateMomentPostsToV18() async {
    await customStatement(
        'ALTER TABLE moment_posts RENAME TO moment_posts_v17');
    await customStatement('DROP INDEX IF EXISTS moment_posts_chat_idx');
    await customStatement('DROP INDEX IF EXISTS moment_posts_chapter_unique');
    await customStatement('''
      CREATE TABLE moment_posts (
        id TEXT NOT NULL PRIMARY KEY,
        chat_id TEXT NULL REFERENCES chats(id) ON DELETE CASCADE,
        author_id TEXT NOT NULL,
        author_name TEXT NOT NULL,
        public_body TEXT NOT NULL,
        image_path TEXT NULL,
        fact_body TEXT NULL,
        chapter_id TEXT NULL REFERENCES story_chapters(id) ON DELETE CASCADE,
        origin TEXT NOT NULL,
        status TEXT NOT NULL,
        write_to_world INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        CHECK (origin IN ('chapter', 'user', 'character')),
        CHECK (status IN ('open', 'waiting', 'ignored')),
        CHECK (origin != 'chapter' OR chapter_id IS NOT NULL),
        CHECK (length(public_body) > 0 OR image_path IS NOT NULL)
      )
    ''');
    await customStatement('''
      INSERT INTO moment_posts (
        id, chat_id, author_id, author_name, public_body, image_path,
        fact_body, chapter_id, origin, status, write_to_world,
        created_at, updated_at
      )
      SELECT
        id, chat_id, author_id, author_name, public_body, NULL,
        fact_body, chapter_id, origin, status, write_to_world,
        created_at, updated_at
      FROM moment_posts_v17
    ''');
    await customStatement('DROP TABLE moment_posts_v17');
    await _repairMomentCommentsForeignKey();
  }

  /// v18 renamed moment_posts, which left moment_comments pointing at
  /// moment_posts_v17. Recreate the comments table so inserts work again.
  Future<void> _repairMomentCommentsForeignKey() async {
    final commentsExist = await customSelect(
      'SELECT 1 AS found FROM sqlite_master '
      "WHERE type = 'table' AND name = 'moment_comments'",
    ).getSingleOrNull();
    if (commentsExist == null) return;

    final foreignKeys =
        await customSelect('PRAGMA foreign_key_list(moment_comments)').get();
    var needsRepair = foreignKeys.isEmpty;
    for (final row in foreignKeys) {
      final target = row.read<String>('table');
      if (target != 'moment_posts') {
        needsRepair = true;
        break;
      }
      final targetExists = await customSelect(
        'SELECT 1 AS found FROM sqlite_master '
        "WHERE type = 'table' AND name = ?",
        variables: [Variable<String>(target)],
      ).getSingleOrNull();
      if (targetExists == null) {
        needsRepair = true;
        break;
      }
    }
    if (!needsRepair) return;

    final commentColumns = await customSelect(
      'PRAGMA table_info(moment_comments)',
    ).get();
    final hasParentColumn = commentColumns
        .map((row) => row.read<String>('name'))
        .contains('parent_comment_id');
    await customStatement('PRAGMA foreign_keys = OFF');
    await customStatement('''
      CREATE TABLE moment_comments_new (
        id TEXT NOT NULL PRIMARY KEY,
        post_id TEXT NOT NULL REFERENCES moment_posts(id) ON DELETE CASCADE,
        author_id TEXT NOT NULL,
        author_name TEXT NOT NULL,
        body TEXT NOT NULL,
        kind TEXT NOT NULL,
        ${hasParentColumn ? 'parent_comment_id TEXT NULL,' : ''}
        created_at INTEGER NOT NULL,
        CHECK (kind IN ('comment', 'expose', 'character'))
      )
    ''');
    if (hasParentColumn) {
      await customStatement('''
        INSERT INTO moment_comments_new
          (id, post_id, author_id, author_name, body, kind,
           parent_comment_id, created_at)
        SELECT id, post_id, author_id, author_name, body, kind,
               parent_comment_id, created_at
        FROM moment_comments
      ''');
    } else {
      await customStatement('''
        INSERT INTO moment_comments_new
          (id, post_id, author_id, author_name, body, kind, created_at)
        SELECT id, post_id, author_id, author_name, body, kind, created_at
        FROM moment_comments
      ''');
    }
    await customStatement('DROP TABLE moment_comments');
    await customStatement(
      'ALTER TABLE moment_comments_new RENAME TO moment_comments',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS moment_comments_post_idx '
      'ON moment_comments (post_id, created_at)',
    );
    await customStatement('PRAGMA foreign_keys = ON');
  }

  Future<void> _ensureOperationLogsTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS operation_logs (
        id TEXT NOT NULL PRIMARY KEY,
        kind TEXT NOT NULL,
        subject_id TEXT NOT NULL,
        status TEXT NOT NULL,
        attempts INTEGER NOT NULL,
        payload_json TEXT NOT NULL DEFAULT '{}',
        last_error TEXT NULL,
        due_at INTEGER NOT NULL,
        started_at INTEGER NULL,
        completed_at INTEGER NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        CHECK (status IN ('running', 'completed', 'incomplete'))
      )
    ''');
    await customStatement(
      'CREATE INDEX IF NOT EXISTS operation_logs_retry_idx '
      'ON operation_logs (status, due_at)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS operation_logs_kind_subject_idx '
      'ON operation_logs (kind, subject_id, status)',
    );
  }

  Future<void> _ensureCharacterFriendshipsTable() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS character_friendships (
        id TEXT NOT NULL PRIMARY KEY,
        left_id TEXT NOT NULL,
        right_id TEXT NOT NULL,
        source_group_id TEXT NULL,
        created_at INTEGER NOT NULL,
        UNIQUE (left_id, right_id)
      )
    ''');
    await customStatement(
      'CREATE INDEX IF NOT EXISTS character_friendships_left_idx '
      'ON character_friendships (left_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS character_friendships_right_idx '
      'ON character_friendships (right_id)',
    );
  }

  Future<void> _createV17Indexes() async {
    const statements = [
      'CREATE INDEX IF NOT EXISTS moment_posts_chat_idx '
          'ON moment_posts (chat_id, created_at)',
      'CREATE UNIQUE INDEX IF NOT EXISTS moment_posts_chapter_unique '
          'ON moment_posts (chapter_id) WHERE chapter_id IS NOT NULL',
      'CREATE INDEX IF NOT EXISTS moment_comments_post_idx '
          'ON moment_comments (post_id, created_at)',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }

  Future<bool> _hasCompleteCurrentTableLayout() async {
    for (final table in allTables) {
      final tableName = table.actualTableName.replaceAll('"', '""');
      final rows = await customSelect('PRAGMA table_info("$tableName")').get();
      final actualColumns = rows.map((row) => row.read<String>('name')).toSet();
      final expectedColumns = table.columnsByName.keys.toSet();

      if (actualColumns.length != expectedColumns.length ||
          !actualColumns.containsAll(expectedColumns)) {
        return false;
      }
    }

    return true;
  }

  Future<bool> _hasColumn(String table, String column) async {
    final rows = await customSelect('PRAGMA table_info("$table")').get();
    return rows.map((row) => row.read<String>('name')).contains(column);
  }

  Future<void> _assertNoPartialV15Schema() async {
    const tableNames = [
      'long_term_memories',
      'long_term_memory_source_messages',
      'rpg_scenarios',
      'rpg_state_snapshots',
      'rpg_chat_states',
      'data_bank_documents',
      'data_bank_document_versions',
      'data_bank_sections',
      'data_bank_text_chunks',
      'data_bank_bindings',
    ];
    final placeholders = List.filled(tableNames.length, '?').join(', ');
    final rows = await customSelect(
      'SELECT name FROM sqlite_master '
      "WHERE type = 'table' AND name IN ($placeholders)",
      variables: tableNames.map(Variable<String>.new).toList(),
    ).get();
    if (rows.isNotEmpty) {
      throw StateError(
        'Partial v15 schema detected: '
        '${rows.map((row) => row.read<String>('name')).join(', ')}',
      );
    }
  }

  Future<void> _assertNoPartialV16Schema() async {
    const tableNames = ['story_chapters'];
    final placeholders = List.filled(tableNames.length, '?').join(', ');
    final rows = await customSelect(
      'SELECT name FROM sqlite_master '
      "WHERE type = 'table' AND name IN ($placeholders)",
      variables: tableNames.map(Variable<String>.new).toList(),
    ).get();
    if (rows.isNotEmpty) {
      throw StateError(
        'Partial v16 schema detected: '
        '${rows.map((row) => row.read<String>('name')).join(', ')}',
      );
    }
  }

  Future<void> _assertNoPartialV17Schema() async {
    const tableNames = ['moment_posts', 'moment_comments'];
    final placeholders = List.filled(tableNames.length, '?').join(', ');
    final rows = await customSelect(
      'SELECT name FROM sqlite_master '
      "WHERE type = 'table' AND name IN ($placeholders)",
      variables: tableNames.map(Variable<String>.new).toList(),
    ).get();
    if (rows.isNotEmpty) {
      throw StateError(
        'Partial v17 schema detected: '
        '${rows.map((row) => row.read<String>('name')).join(', ')}',
      );
    }
  }

  Future<void> _createV15Triggers() async {
    const statements = [
      '''
        CREATE TRIGGER IF NOT EXISTS data_bank_document_current_version_insert
        BEFORE INSERT ON data_bank_documents
        WHEN NEW.current_version_id IS NOT NULL AND NOT EXISTS (
          SELECT 1 FROM data_bank_document_versions
          WHERE id = NEW.current_version_id AND document_id = NEW.id
        )
        BEGIN
          SELECT RAISE(ABORT, 'current Data Bank version must belong to document');
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS data_bank_document_current_version_update
        BEFORE UPDATE OF current_version_id ON data_bank_documents
        WHEN NEW.current_version_id IS NOT NULL AND NOT EXISTS (
          SELECT 1 FROM data_bank_document_versions
          WHERE id = NEW.current_version_id AND document_id = NEW.id
        )
        BEGIN
          SELECT RAISE(ABORT, 'current Data Bank version must belong to document');
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS data_bank_current_version_delete
        AFTER DELETE ON data_bank_document_versions
        BEGIN
          UPDATE data_bank_documents
          SET current_version_id = NULL, is_placeholder = 1
          WHERE id = OLD.document_id AND current_version_id = OLD.id;
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS memory_source_chat_removed
        AFTER UPDATE OF source_chat_id ON long_term_memories
        WHEN OLD.source_chat_id IS NOT NULL AND NEW.source_chat_id IS NULL
        BEGIN
          UPDATE long_term_memories
          SET source_origin = 'manual', extracted_at = NULL,
              provider_id = NULL, model_id = NULL
          WHERE id = NEW.id;
        END
      ''',
      '''
        CREATE TRIGGER IF NOT EXISTS memory_last_source_message_removed
        AFTER DELETE ON long_term_memory_source_messages
        WHEN NOT EXISTS (
          SELECT 1 FROM long_term_memory_source_messages
          WHERE memory_id = OLD.memory_id
        )
        BEGIN
          UPDATE long_term_memories
          SET source_origin = 'manual', source_chat_id = NULL,
              extracted_at = NULL, provider_id = NULL, model_id = NULL
          WHERE id = OLD.memory_id;
        END
      ''',
    ];
    for (final statement in statements) {
      await customStatement(statement);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'NativeTavern', 'database.sqlite'));

    // Ensure directory exists
    await file.parent.create(recursive: true);

    // Use foreground database (not background isolate) for reliable writes
    // Background isolate can be killed by OS when app goes to background,
    // causing data loss
    final db = NativeDatabase(
      file,
      setup: (database) {
        // Enable WAL mode for better concurrency
        database.execute('PRAGMA journal_mode=WAL;');
        // Set synchronous mode to FULL to ensure data is written to disk
        database.execute('PRAGMA synchronous=FULL;');
        // Enable foreign keys
        database.execute('PRAGMA foreign_keys=ON;');
      },
    );

    return db;
  });
}
