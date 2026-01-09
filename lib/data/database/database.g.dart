// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _personalityMeta =
      const VerificationMeta('personality');
  @override
  late final GeneratedColumn<String> personality = GeneratedColumn<String>(
      'personality', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _scenarioMeta =
      const VerificationMeta('scenario');
  @override
  late final GeneratedColumn<String> scenario = GeneratedColumn<String>(
      'scenario', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _firstMessageMeta =
      const VerificationMeta('firstMessage');
  @override
  late final GeneratedColumn<String> firstMessage = GeneratedColumn<String>(
      'first_message', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _alternateGreetingsMeta =
      const VerificationMeta('alternateGreetings');
  @override
  late final GeneratedColumn<String> alternateGreetings =
      GeneratedColumn<String>('alternate_greetings', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _exampleDialogueMeta =
      const VerificationMeta('exampleDialogue');
  @override
  late final GeneratedColumn<String> exampleDialogue = GeneratedColumn<String>(
      'example_dialogue', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _systemPromptMeta =
      const VerificationMeta('systemPrompt');
  @override
  late final GeneratedColumn<String> systemPrompt = GeneratedColumn<String>(
      'system_prompt', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _postHistoryInstructionsMeta =
      const VerificationMeta('postHistoryInstructions');
  @override
  late final GeneratedColumn<String> postHistoryInstructions =
      GeneratedColumn<String>('post_history_instructions', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _creatorNotesMeta =
      const VerificationMeta('creatorNotes');
  @override
  late final GeneratedColumn<String> creatorNotes = GeneratedColumn<String>(
      'creator_notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _creatorMeta =
      const VerificationMeta('creator');
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
      'creator', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _characterVersionMeta =
      const VerificationMeta('characterVersion');
  @override
  late final GeneratedColumn<String> characterVersion = GeneratedColumn<String>(
      'character_version', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assetsJsonMeta =
      const VerificationMeta('assetsJson');
  @override
  late final GeneratedColumn<String> assetsJson = GeneratedColumn<String>(
      'assets_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _characterBookJsonMeta =
      const VerificationMeta('characterBookJson');
  @override
  late final GeneratedColumn<String> characterBookJson =
      GeneratedColumn<String>('character_book_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _extensionsJsonMeta =
      const VerificationMeta('extensionsJson');
  @override
  late final GeneratedColumn<String> extensionsJson = GeneratedColumn<String>(
      'extensions_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        personality,
        scenario,
        firstMessage,
        alternateGreetings,
        exampleDialogue,
        systemPrompt,
        postHistoryInstructions,
        creatorNotes,
        tags,
        creator,
        characterVersion,
        avatarPath,
        assetsJson,
        characterBookJson,
        extensionsJson,
        isFavorite,
        createdAt,
        modifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(Insertable<Character> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('personality')) {
      context.handle(
          _personalityMeta,
          personality.isAcceptableOrUnknown(
              data['personality']!, _personalityMeta));
    }
    if (data.containsKey('scenario')) {
      context.handle(_scenarioMeta,
          scenario.isAcceptableOrUnknown(data['scenario']!, _scenarioMeta));
    }
    if (data.containsKey('first_message')) {
      context.handle(
          _firstMessageMeta,
          firstMessage.isAcceptableOrUnknown(
              data['first_message']!, _firstMessageMeta));
    }
    if (data.containsKey('alternate_greetings')) {
      context.handle(
          _alternateGreetingsMeta,
          alternateGreetings.isAcceptableOrUnknown(
              data['alternate_greetings']!, _alternateGreetingsMeta));
    }
    if (data.containsKey('example_dialogue')) {
      context.handle(
          _exampleDialogueMeta,
          exampleDialogue.isAcceptableOrUnknown(
              data['example_dialogue']!, _exampleDialogueMeta));
    }
    if (data.containsKey('system_prompt')) {
      context.handle(
          _systemPromptMeta,
          systemPrompt.isAcceptableOrUnknown(
              data['system_prompt']!, _systemPromptMeta));
    }
    if (data.containsKey('post_history_instructions')) {
      context.handle(
          _postHistoryInstructionsMeta,
          postHistoryInstructions.isAcceptableOrUnknown(
              data['post_history_instructions']!,
              _postHistoryInstructionsMeta));
    }
    if (data.containsKey('creator_notes')) {
      context.handle(
          _creatorNotesMeta,
          creatorNotes.isAcceptableOrUnknown(
              data['creator_notes']!, _creatorNotesMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('creator')) {
      context.handle(_creatorMeta,
          creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta));
    }
    if (data.containsKey('character_version')) {
      context.handle(
          _characterVersionMeta,
          characterVersion.isAcceptableOrUnknown(
              data['character_version']!, _characterVersionMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('assets_json')) {
      context.handle(
          _assetsJsonMeta,
          assetsJson.isAcceptableOrUnknown(
              data['assets_json']!, _assetsJsonMeta));
    }
    if (data.containsKey('character_book_json')) {
      context.handle(
          _characterBookJsonMeta,
          characterBookJson.isAcceptableOrUnknown(
              data['character_book_json']!, _characterBookJsonMeta));
    }
    if (data.containsKey('extensions_json')) {
      context.handle(
          _extensionsJsonMeta,
          extensionsJson.isAcceptableOrUnknown(
              data['extensions_json']!, _extensionsJsonMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      personality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}personality'])!,
      scenario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenario'])!,
      firstMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_message'])!,
      alternateGreetings: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}alternate_greetings'])!,
      exampleDialogue: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}example_dialogue'])!,
      systemPrompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_prompt'])!,
      postHistoryInstructions: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}post_history_instructions'])!,
      creatorNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator_notes'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      creator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator'])!,
      characterVersion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}character_version'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      assetsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assets_json'])!,
      characterBookJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}character_book_json'])!,
      extensionsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}extensions_json'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at'])!,
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  final String id;
  final String name;
  final String description;
  final String personality;
  final String scenario;
  final String firstMessage;
  final String alternateGreetings;
  final String exampleDialogue;
  final String systemPrompt;
  final String postHistoryInstructions;
  final String creatorNotes;
  final String tags;
  final String creator;
  final String characterVersion;
  final String? avatarPath;
  final String assetsJson;
  final String characterBookJson;
  final String extensionsJson;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime modifiedAt;
  const Character(
      {required this.id,
      required this.name,
      required this.description,
      required this.personality,
      required this.scenario,
      required this.firstMessage,
      required this.alternateGreetings,
      required this.exampleDialogue,
      required this.systemPrompt,
      required this.postHistoryInstructions,
      required this.creatorNotes,
      required this.tags,
      required this.creator,
      required this.characterVersion,
      this.avatarPath,
      required this.assetsJson,
      required this.characterBookJson,
      required this.extensionsJson,
      required this.isFavorite,
      required this.createdAt,
      required this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['personality'] = Variable<String>(personality);
    map['scenario'] = Variable<String>(scenario);
    map['first_message'] = Variable<String>(firstMessage);
    map['alternate_greetings'] = Variable<String>(alternateGreetings);
    map['example_dialogue'] = Variable<String>(exampleDialogue);
    map['system_prompt'] = Variable<String>(systemPrompt);
    map['post_history_instructions'] =
        Variable<String>(postHistoryInstructions);
    map['creator_notes'] = Variable<String>(creatorNotes);
    map['tags'] = Variable<String>(tags);
    map['creator'] = Variable<String>(creator);
    map['character_version'] = Variable<String>(characterVersion);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['assets_json'] = Variable<String>(assetsJson);
    map['character_book_json'] = Variable<String>(characterBookJson);
    map['extensions_json'] = Variable<String>(extensionsJson);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      personality: Value(personality),
      scenario: Value(scenario),
      firstMessage: Value(firstMessage),
      alternateGreetings: Value(alternateGreetings),
      exampleDialogue: Value(exampleDialogue),
      systemPrompt: Value(systemPrompt),
      postHistoryInstructions: Value(postHistoryInstructions),
      creatorNotes: Value(creatorNotes),
      tags: Value(tags),
      creator: Value(creator),
      characterVersion: Value(characterVersion),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      assetsJson: Value(assetsJson),
      characterBookJson: Value(characterBookJson),
      extensionsJson: Value(extensionsJson),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
    );
  }

  factory Character.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      personality: serializer.fromJson<String>(json['personality']),
      scenario: serializer.fromJson<String>(json['scenario']),
      firstMessage: serializer.fromJson<String>(json['firstMessage']),
      alternateGreetings:
          serializer.fromJson<String>(json['alternateGreetings']),
      exampleDialogue: serializer.fromJson<String>(json['exampleDialogue']),
      systemPrompt: serializer.fromJson<String>(json['systemPrompt']),
      postHistoryInstructions:
          serializer.fromJson<String>(json['postHistoryInstructions']),
      creatorNotes: serializer.fromJson<String>(json['creatorNotes']),
      tags: serializer.fromJson<String>(json['tags']),
      creator: serializer.fromJson<String>(json['creator']),
      characterVersion: serializer.fromJson<String>(json['characterVersion']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      assetsJson: serializer.fromJson<String>(json['assetsJson']),
      characterBookJson: serializer.fromJson<String>(json['characterBookJson']),
      extensionsJson: serializer.fromJson<String>(json['extensionsJson']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'personality': serializer.toJson<String>(personality),
      'scenario': serializer.toJson<String>(scenario),
      'firstMessage': serializer.toJson<String>(firstMessage),
      'alternateGreetings': serializer.toJson<String>(alternateGreetings),
      'exampleDialogue': serializer.toJson<String>(exampleDialogue),
      'systemPrompt': serializer.toJson<String>(systemPrompt),
      'postHistoryInstructions':
          serializer.toJson<String>(postHistoryInstructions),
      'creatorNotes': serializer.toJson<String>(creatorNotes),
      'tags': serializer.toJson<String>(tags),
      'creator': serializer.toJson<String>(creator),
      'characterVersion': serializer.toJson<String>(characterVersion),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'assetsJson': serializer.toJson<String>(assetsJson),
      'characterBookJson': serializer.toJson<String>(characterBookJson),
      'extensionsJson': serializer.toJson<String>(extensionsJson),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
    };
  }

  Character copyWith(
          {String? id,
          String? name,
          String? description,
          String? personality,
          String? scenario,
          String? firstMessage,
          String? alternateGreetings,
          String? exampleDialogue,
          String? systemPrompt,
          String? postHistoryInstructions,
          String? creatorNotes,
          String? tags,
          String? creator,
          String? characterVersion,
          Value<String?> avatarPath = const Value.absent(),
          String? assetsJson,
          String? characterBookJson,
          String? extensionsJson,
          bool? isFavorite,
          DateTime? createdAt,
          DateTime? modifiedAt}) =>
      Character(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        personality: personality ?? this.personality,
        scenario: scenario ?? this.scenario,
        firstMessage: firstMessage ?? this.firstMessage,
        alternateGreetings: alternateGreetings ?? this.alternateGreetings,
        exampleDialogue: exampleDialogue ?? this.exampleDialogue,
        systemPrompt: systemPrompt ?? this.systemPrompt,
        postHistoryInstructions:
            postHistoryInstructions ?? this.postHistoryInstructions,
        creatorNotes: creatorNotes ?? this.creatorNotes,
        tags: tags ?? this.tags,
        creator: creator ?? this.creator,
        characterVersion: characterVersion ?? this.characterVersion,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        assetsJson: assetsJson ?? this.assetsJson,
        characterBookJson: characterBookJson ?? this.characterBookJson,
        extensionsJson: extensionsJson ?? this.extensionsJson,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      personality:
          data.personality.present ? data.personality.value : this.personality,
      scenario: data.scenario.present ? data.scenario.value : this.scenario,
      firstMessage: data.firstMessage.present
          ? data.firstMessage.value
          : this.firstMessage,
      alternateGreetings: data.alternateGreetings.present
          ? data.alternateGreetings.value
          : this.alternateGreetings,
      exampleDialogue: data.exampleDialogue.present
          ? data.exampleDialogue.value
          : this.exampleDialogue,
      systemPrompt: data.systemPrompt.present
          ? data.systemPrompt.value
          : this.systemPrompt,
      postHistoryInstructions: data.postHistoryInstructions.present
          ? data.postHistoryInstructions.value
          : this.postHistoryInstructions,
      creatorNotes: data.creatorNotes.present
          ? data.creatorNotes.value
          : this.creatorNotes,
      tags: data.tags.present ? data.tags.value : this.tags,
      creator: data.creator.present ? data.creator.value : this.creator,
      characterVersion: data.characterVersion.present
          ? data.characterVersion.value
          : this.characterVersion,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      assetsJson:
          data.assetsJson.present ? data.assetsJson.value : this.assetsJson,
      characterBookJson: data.characterBookJson.present
          ? data.characterBookJson.value
          : this.characterBookJson,
      extensionsJson: data.extensionsJson.present
          ? data.extensionsJson.value
          : this.extensionsJson,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('personality: $personality, ')
          ..write('scenario: $scenario, ')
          ..write('firstMessage: $firstMessage, ')
          ..write('alternateGreetings: $alternateGreetings, ')
          ..write('exampleDialogue: $exampleDialogue, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('postHistoryInstructions: $postHistoryInstructions, ')
          ..write('creatorNotes: $creatorNotes, ')
          ..write('tags: $tags, ')
          ..write('creator: $creator, ')
          ..write('characterVersion: $characterVersion, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('assetsJson: $assetsJson, ')
          ..write('characterBookJson: $characterBookJson, ')
          ..write('extensionsJson: $extensionsJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        description,
        personality,
        scenario,
        firstMessage,
        alternateGreetings,
        exampleDialogue,
        systemPrompt,
        postHistoryInstructions,
        creatorNotes,
        tags,
        creator,
        characterVersion,
        avatarPath,
        assetsJson,
        characterBookJson,
        extensionsJson,
        isFavorite,
        createdAt,
        modifiedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.personality == this.personality &&
          other.scenario == this.scenario &&
          other.firstMessage == this.firstMessage &&
          other.alternateGreetings == this.alternateGreetings &&
          other.exampleDialogue == this.exampleDialogue &&
          other.systemPrompt == this.systemPrompt &&
          other.postHistoryInstructions == this.postHistoryInstructions &&
          other.creatorNotes == this.creatorNotes &&
          other.tags == this.tags &&
          other.creator == this.creator &&
          other.characterVersion == this.characterVersion &&
          other.avatarPath == this.avatarPath &&
          other.assetsJson == this.assetsJson &&
          other.characterBookJson == this.characterBookJson &&
          other.extensionsJson == this.extensionsJson &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> personality;
  final Value<String> scenario;
  final Value<String> firstMessage;
  final Value<String> alternateGreetings;
  final Value<String> exampleDialogue;
  final Value<String> systemPrompt;
  final Value<String> postHistoryInstructions;
  final Value<String> creatorNotes;
  final Value<String> tags;
  final Value<String> creator;
  final Value<String> characterVersion;
  final Value<String?> avatarPath;
  final Value<String> assetsJson;
  final Value<String> characterBookJson;
  final Value<String> extensionsJson;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<int> rowid;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.personality = const Value.absent(),
    this.scenario = const Value.absent(),
    this.firstMessage = const Value.absent(),
    this.alternateGreetings = const Value.absent(),
    this.exampleDialogue = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.postHistoryInstructions = const Value.absent(),
    this.creatorNotes = const Value.absent(),
    this.tags = const Value.absent(),
    this.creator = const Value.absent(),
    this.characterVersion = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.assetsJson = const Value.absent(),
    this.characterBookJson = const Value.absent(),
    this.extensionsJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.personality = const Value.absent(),
    this.scenario = const Value.absent(),
    this.firstMessage = const Value.absent(),
    this.alternateGreetings = const Value.absent(),
    this.exampleDialogue = const Value.absent(),
    this.systemPrompt = const Value.absent(),
    this.postHistoryInstructions = const Value.absent(),
    this.creatorNotes = const Value.absent(),
    this.tags = const Value.absent(),
    this.creator = const Value.absent(),
    this.characterVersion = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.assetsJson = const Value.absent(),
    this.characterBookJson = const Value.absent(),
    this.extensionsJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        modifiedAt = Value(modifiedAt);
  static Insertable<Character> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? personality,
    Expression<String>? scenario,
    Expression<String>? firstMessage,
    Expression<String>? alternateGreetings,
    Expression<String>? exampleDialogue,
    Expression<String>? systemPrompt,
    Expression<String>? postHistoryInstructions,
    Expression<String>? creatorNotes,
    Expression<String>? tags,
    Expression<String>? creator,
    Expression<String>? characterVersion,
    Expression<String>? avatarPath,
    Expression<String>? assetsJson,
    Expression<String>? characterBookJson,
    Expression<String>? extensionsJson,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (personality != null) 'personality': personality,
      if (scenario != null) 'scenario': scenario,
      if (firstMessage != null) 'first_message': firstMessage,
      if (alternateGreetings != null) 'alternate_greetings': alternateGreetings,
      if (exampleDialogue != null) 'example_dialogue': exampleDialogue,
      if (systemPrompt != null) 'system_prompt': systemPrompt,
      if (postHistoryInstructions != null)
        'post_history_instructions': postHistoryInstructions,
      if (creatorNotes != null) 'creator_notes': creatorNotes,
      if (tags != null) 'tags': tags,
      if (creator != null) 'creator': creator,
      if (characterVersion != null) 'character_version': characterVersion,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (assetsJson != null) 'assets_json': assetsJson,
      if (characterBookJson != null) 'character_book_json': characterBookJson,
      if (extensionsJson != null) 'extensions_json': extensionsJson,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? personality,
      Value<String>? scenario,
      Value<String>? firstMessage,
      Value<String>? alternateGreetings,
      Value<String>? exampleDialogue,
      Value<String>? systemPrompt,
      Value<String>? postHistoryInstructions,
      Value<String>? creatorNotes,
      Value<String>? tags,
      Value<String>? creator,
      Value<String>? characterVersion,
      Value<String?>? avatarPath,
      Value<String>? assetsJson,
      Value<String>? characterBookJson,
      Value<String>? extensionsJson,
      Value<bool>? isFavorite,
      Value<DateTime>? createdAt,
      Value<DateTime>? modifiedAt,
      Value<int>? rowid}) {
    return CharactersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      personality: personality ?? this.personality,
      scenario: scenario ?? this.scenario,
      firstMessage: firstMessage ?? this.firstMessage,
      alternateGreetings: alternateGreetings ?? this.alternateGreetings,
      exampleDialogue: exampleDialogue ?? this.exampleDialogue,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      postHistoryInstructions:
          postHistoryInstructions ?? this.postHistoryInstructions,
      creatorNotes: creatorNotes ?? this.creatorNotes,
      tags: tags ?? this.tags,
      creator: creator ?? this.creator,
      characterVersion: characterVersion ?? this.characterVersion,
      avatarPath: avatarPath ?? this.avatarPath,
      assetsJson: assetsJson ?? this.assetsJson,
      characterBookJson: characterBookJson ?? this.characterBookJson,
      extensionsJson: extensionsJson ?? this.extensionsJson,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (personality.present) {
      map['personality'] = Variable<String>(personality.value);
    }
    if (scenario.present) {
      map['scenario'] = Variable<String>(scenario.value);
    }
    if (firstMessage.present) {
      map['first_message'] = Variable<String>(firstMessage.value);
    }
    if (alternateGreetings.present) {
      map['alternate_greetings'] = Variable<String>(alternateGreetings.value);
    }
    if (exampleDialogue.present) {
      map['example_dialogue'] = Variable<String>(exampleDialogue.value);
    }
    if (systemPrompt.present) {
      map['system_prompt'] = Variable<String>(systemPrompt.value);
    }
    if (postHistoryInstructions.present) {
      map['post_history_instructions'] =
          Variable<String>(postHistoryInstructions.value);
    }
    if (creatorNotes.present) {
      map['creator_notes'] = Variable<String>(creatorNotes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (characterVersion.present) {
      map['character_version'] = Variable<String>(characterVersion.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (assetsJson.present) {
      map['assets_json'] = Variable<String>(assetsJson.value);
    }
    if (characterBookJson.present) {
      map['character_book_json'] = Variable<String>(characterBookJson.value);
    }
    if (extensionsJson.present) {
      map['extensions_json'] = Variable<String>(extensionsJson.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('personality: $personality, ')
          ..write('scenario: $scenario, ')
          ..write('firstMessage: $firstMessage, ')
          ..write('alternateGreetings: $alternateGreetings, ')
          ..write('exampleDialogue: $exampleDialogue, ')
          ..write('systemPrompt: $systemPrompt, ')
          ..write('postHistoryInstructions: $postHistoryInstructions, ')
          ..write('creatorNotes: $creatorNotes, ')
          ..write('tags: $tags, ')
          ..write('creator: $creator, ')
          ..write('characterVersion: $characterVersion, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('assetsJson: $assetsJson, ')
          ..write('characterBookJson: $characterBookJson, ')
          ..write('extensionsJson: $extensionsJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
      'character_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES characters (id)'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('New Chat'));
  static const VerificationMeta _settingsJsonMeta =
      const VerificationMeta('settingsJson');
  @override
  late final GeneratedColumn<String> settingsJson = GeneratedColumn<String>(
      'settings_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _authorNoteMeta =
      const VerificationMeta('authorNote');
  @override
  late final GeneratedColumn<String> authorNote = GeneratedColumn<String>(
      'author_note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _authorNoteDepthMeta =
      const VerificationMeta('authorNoteDepth');
  @override
  late final GeneratedColumn<int> authorNoteDepth = GeneratedColumn<int>(
      'author_note_depth', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _authorNoteEnabledMeta =
      const VerificationMeta('authorNoteEnabled');
  @override
  late final GeneratedColumn<bool> authorNoteEnabled = GeneratedColumn<bool>(
      'author_note_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("author_note_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        characterId,
        groupId,
        title,
        settingsJson,
        authorNote,
        authorNoteDepth,
        authorNoteEnabled,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('settings_json')) {
      context.handle(
          _settingsJsonMeta,
          settingsJson.isAcceptableOrUnknown(
              data['settings_json']!, _settingsJsonMeta));
    }
    if (data.containsKey('author_note')) {
      context.handle(
          _authorNoteMeta,
          authorNote.isAcceptableOrUnknown(
              data['author_note']!, _authorNoteMeta));
    }
    if (data.containsKey('author_note_depth')) {
      context.handle(
          _authorNoteDepthMeta,
          authorNoteDepth.isAcceptableOrUnknown(
              data['author_note_depth']!, _authorNoteDepthMeta));
    }
    if (data.containsKey('author_note_enabled')) {
      context.handle(
          _authorNoteEnabledMeta,
          authorNoteEnabled.isAcceptableOrUnknown(
              data['author_note_enabled']!, _authorNoteEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      settingsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}settings_json'])!,
      authorNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_note'])!,
      authorNoteDepth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}author_note_depth'])!,
      authorNoteEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}author_note_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final String id;
  final String characterId;
  final String? groupId;
  final String title;
  final String settingsJson;
  final String authorNote;
  final int authorNoteDepth;
  final bool authorNoteEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Chat(
      {required this.id,
      required this.characterId,
      this.groupId,
      required this.title,
      required this.settingsJson,
      required this.authorNote,
      required this.authorNoteDepth,
      required this.authorNoteEnabled,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['character_id'] = Variable<String>(characterId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['title'] = Variable<String>(title);
    map['settings_json'] = Variable<String>(settingsJson);
    map['author_note'] = Variable<String>(authorNote);
    map['author_note_depth'] = Variable<int>(authorNoteDepth);
    map['author_note_enabled'] = Variable<bool>(authorNoteEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      characterId: Value(characterId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      title: Value(title),
      settingsJson: Value(settingsJson),
      authorNote: Value(authorNote),
      authorNoteDepth: Value(authorNoteDepth),
      authorNoteEnabled: Value(authorNoteEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      id: serializer.fromJson<String>(json['id']),
      characterId: serializer.fromJson<String>(json['characterId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      title: serializer.fromJson<String>(json['title']),
      settingsJson: serializer.fromJson<String>(json['settingsJson']),
      authorNote: serializer.fromJson<String>(json['authorNote']),
      authorNoteDepth: serializer.fromJson<int>(json['authorNoteDepth']),
      authorNoteEnabled: serializer.fromJson<bool>(json['authorNoteEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'characterId': serializer.toJson<String>(characterId),
      'groupId': serializer.toJson<String?>(groupId),
      'title': serializer.toJson<String>(title),
      'settingsJson': serializer.toJson<String>(settingsJson),
      'authorNote': serializer.toJson<String>(authorNote),
      'authorNoteDepth': serializer.toJson<int>(authorNoteDepth),
      'authorNoteEnabled': serializer.toJson<bool>(authorNoteEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Chat copyWith(
          {String? id,
          String? characterId,
          Value<String?> groupId = const Value.absent(),
          String? title,
          String? settingsJson,
          String? authorNote,
          int? authorNoteDepth,
          bool? authorNoteEnabled,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Chat(
        id: id ?? this.id,
        characterId: characterId ?? this.characterId,
        groupId: groupId.present ? groupId.value : this.groupId,
        title: title ?? this.title,
        settingsJson: settingsJson ?? this.settingsJson,
        authorNote: authorNote ?? this.authorNote,
        authorNoteDepth: authorNoteDepth ?? this.authorNoteDepth,
        authorNoteEnabled: authorNoteEnabled ?? this.authorNoteEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Chat copyWithCompanion(ChatsCompanion data) {
    return Chat(
      id: data.id.present ? data.id.value : this.id,
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      title: data.title.present ? data.title.value : this.title,
      settingsJson: data.settingsJson.present
          ? data.settingsJson.value
          : this.settingsJson,
      authorNote:
          data.authorNote.present ? data.authorNote.value : this.authorNote,
      authorNoteDepth: data.authorNoteDepth.present
          ? data.authorNoteDepth.value
          : this.authorNoteDepth,
      authorNoteEnabled: data.authorNoteEnabled.present
          ? data.authorNoteEnabled.value
          : this.authorNoteEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('authorNote: $authorNote, ')
          ..write('authorNoteDepth: $authorNoteDepth, ')
          ..write('authorNoteEnabled: $authorNoteEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, characterId, groupId, title, settingsJson,
      authorNote, authorNoteDepth, authorNoteEnabled, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.groupId == this.groupId &&
          other.title == this.title &&
          other.settingsJson == this.settingsJson &&
          other.authorNote == this.authorNote &&
          other.authorNoteDepth == this.authorNoteDepth &&
          other.authorNoteEnabled == this.authorNoteEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<String> id;
  final Value<String> characterId;
  final Value<String?> groupId;
  final Value<String> title;
  final Value<String> settingsJson;
  final Value<String> authorNote;
  final Value<int> authorNoteDepth;
  final Value<bool> authorNoteEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.title = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.authorNote = const Value.absent(),
    this.authorNoteDepth = const Value.absent(),
    this.authorNoteEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatsCompanion.insert({
    required String id,
    required String characterId,
    this.groupId = const Value.absent(),
    this.title = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.authorNote = const Value.absent(),
    this.authorNoteDepth = const Value.absent(),
    this.authorNoteEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        characterId = Value(characterId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Chat> custom({
    Expression<String>? id,
    Expression<String>? characterId,
    Expression<String>? groupId,
    Expression<String>? title,
    Expression<String>? settingsJson,
    Expression<String>? authorNote,
    Expression<int>? authorNoteDepth,
    Expression<bool>? authorNoteEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (groupId != null) 'group_id': groupId,
      if (title != null) 'title': title,
      if (settingsJson != null) 'settings_json': settingsJson,
      if (authorNote != null) 'author_note': authorNote,
      if (authorNoteDepth != null) 'author_note_depth': authorNoteDepth,
      if (authorNoteEnabled != null) 'author_note_enabled': authorNoteEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatsCompanion copyWith(
      {Value<String>? id,
      Value<String>? characterId,
      Value<String?>? groupId,
      Value<String>? title,
      Value<String>? settingsJson,
      Value<String>? authorNote,
      Value<int>? authorNoteDepth,
      Value<bool>? authorNoteEnabled,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ChatsCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      settingsJson: settingsJson ?? this.settingsJson,
      authorNote: authorNote ?? this.authorNote,
      authorNoteDepth: authorNoteDepth ?? this.authorNoteDepth,
      authorNoteEnabled: authorNoteEnabled ?? this.authorNoteEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (settingsJson.present) {
      map['settings_json'] = Variable<String>(settingsJson.value);
    }
    if (authorNote.present) {
      map['author_note'] = Variable<String>(authorNote.value);
    }
    if (authorNoteDepth.present) {
      map['author_note_depth'] = Variable<int>(authorNoteDepth.value);
    }
    if (authorNoteEnabled.present) {
      map['author_note_enabled'] = Variable<bool>(authorNoteEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('groupId: $groupId, ')
          ..write('title: $title, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('authorNote: $authorNote, ')
          ..write('authorNoteDepth: $authorNoteDepth, ')
          ..write('authorNoteEnabled: $authorNoteEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chats (id)'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _swipesMeta = const VerificationMeta('swipes');
  @override
  late final GeneratedColumn<String> swipes = GeneratedColumn<String>(
      'swipes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _currentSwipeIndexMeta =
      const VerificationMeta('currentSwipeIndex');
  @override
  late final GeneratedColumn<int> currentSwipeIndex = GeneratedColumn<int>(
      'current_swipe_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isEditedMeta =
      const VerificationMeta('isEdited');
  @override
  late final GeneratedColumn<bool> isEdited = GeneratedColumn<bool>(
      'is_edited', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_edited" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isHiddenMeta =
      const VerificationMeta('isHidden');
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
      'is_hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
      'character_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _characterNameMeta =
      const VerificationMeta('characterName');
  @override
  late final GeneratedColumn<String> characterName = GeneratedColumn<String>(
      'character_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        chatId,
        role,
        content,
        timestamp,
        swipes,
        currentSwipeIndex,
        isEdited,
        isHidden,
        metadataJson,
        characterId,
        characterName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('swipes')) {
      context.handle(_swipesMeta,
          swipes.isAcceptableOrUnknown(data['swipes']!, _swipesMeta));
    }
    if (data.containsKey('current_swipe_index')) {
      context.handle(
          _currentSwipeIndexMeta,
          currentSwipeIndex.isAcceptableOrUnknown(
              data['current_swipe_index']!, _currentSwipeIndexMeta));
    }
    if (data.containsKey('is_edited')) {
      context.handle(_isEditedMeta,
          isEdited.isAcceptableOrUnknown(data['is_edited']!, _isEditedMeta));
    }
    if (data.containsKey('is_hidden')) {
      context.handle(_isHiddenMeta,
          isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    }
    if (data.containsKey('character_name')) {
      context.handle(
          _characterNameMeta,
          characterName.isAcceptableOrUnknown(
              data['character_name']!, _characterNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      swipes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}swipes'])!,
      currentSwipeIndex: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}current_swipe_index'])!,
      isEdited: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_edited'])!,
      isHidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_hidden'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json'])!,
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character_id']),
      characterName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character_name']),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String chatId;
  final String role;
  final String content;
  final DateTime timestamp;
  final String swipes;
  final int currentSwipeIndex;
  final bool isEdited;
  final bool isHidden;
  final String metadataJson;
  final String? characterId;
  final String? characterName;
  const Message(
      {required this.id,
      required this.chatId,
      required this.role,
      required this.content,
      required this.timestamp,
      required this.swipes,
      required this.currentSwipeIndex,
      required this.isEdited,
      required this.isHidden,
      required this.metadataJson,
      this.characterId,
      this.characterName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chat_id'] = Variable<String>(chatId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['swipes'] = Variable<String>(swipes);
    map['current_swipe_index'] = Variable<int>(currentSwipeIndex);
    map['is_edited'] = Variable<bool>(isEdited);
    map['is_hidden'] = Variable<bool>(isHidden);
    map['metadata_json'] = Variable<String>(metadataJson);
    if (!nullToAbsent || characterId != null) {
      map['character_id'] = Variable<String>(characterId);
    }
    if (!nullToAbsent || characterName != null) {
      map['character_name'] = Variable<String>(characterName);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
      swipes: Value(swipes),
      currentSwipeIndex: Value(currentSwipeIndex),
      isEdited: Value(isEdited),
      isHidden: Value(isHidden),
      metadataJson: Value(metadataJson),
      characterId: characterId == null && nullToAbsent
          ? const Value.absent()
          : Value(characterId),
      characterName: characterName == null && nullToAbsent
          ? const Value.absent()
          : Value(characterName),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      chatId: serializer.fromJson<String>(json['chatId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      swipes: serializer.fromJson<String>(json['swipes']),
      currentSwipeIndex: serializer.fromJson<int>(json['currentSwipeIndex']),
      isEdited: serializer.fromJson<bool>(json['isEdited']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      characterId: serializer.fromJson<String?>(json['characterId']),
      characterName: serializer.fromJson<String?>(json['characterName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chatId': serializer.toJson<String>(chatId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'swipes': serializer.toJson<String>(swipes),
      'currentSwipeIndex': serializer.toJson<int>(currentSwipeIndex),
      'isEdited': serializer.toJson<bool>(isEdited),
      'isHidden': serializer.toJson<bool>(isHidden),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'characterId': serializer.toJson<String?>(characterId),
      'characterName': serializer.toJson<String?>(characterName),
    };
  }

  Message copyWith(
          {String? id,
          String? chatId,
          String? role,
          String? content,
          DateTime? timestamp,
          String? swipes,
          int? currentSwipeIndex,
          bool? isEdited,
          bool? isHidden,
          String? metadataJson,
          Value<String?> characterId = const Value.absent(),
          Value<String?> characterName = const Value.absent()}) =>
      Message(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        role: role ?? this.role,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        swipes: swipes ?? this.swipes,
        currentSwipeIndex: currentSwipeIndex ?? this.currentSwipeIndex,
        isEdited: isEdited ?? this.isEdited,
        isHidden: isHidden ?? this.isHidden,
        metadataJson: metadataJson ?? this.metadataJson,
        characterId: characterId.present ? characterId.value : this.characterId,
        characterName:
            characterName.present ? characterName.value : this.characterName,
      );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      swipes: data.swipes.present ? data.swipes.value : this.swipes,
      currentSwipeIndex: data.currentSwipeIndex.present
          ? data.currentSwipeIndex.value
          : this.currentSwipeIndex,
      isEdited: data.isEdited.present ? data.isEdited.value : this.isEdited,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
      characterName: data.characterName.present
          ? data.characterName.value
          : this.characterName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('swipes: $swipes, ')
          ..write('currentSwipeIndex: $currentSwipeIndex, ')
          ..write('isEdited: $isEdited, ')
          ..write('isHidden: $isHidden, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('characterId: $characterId, ')
          ..write('characterName: $characterName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      chatId,
      role,
      content,
      timestamp,
      swipes,
      currentSwipeIndex,
      isEdited,
      isHidden,
      metadataJson,
      characterId,
      characterName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.swipes == this.swipes &&
          other.currentSwipeIndex == this.currentSwipeIndex &&
          other.isEdited == this.isEdited &&
          other.isHidden == this.isHidden &&
          other.metadataJson == this.metadataJson &&
          other.characterId == this.characterId &&
          other.characterName == this.characterName);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> chatId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<String> swipes;
  final Value<int> currentSwipeIndex;
  final Value<bool> isEdited;
  final Value<bool> isHidden;
  final Value<String> metadataJson;
  final Value<String?> characterId;
  final Value<String?> characterName;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.swipes = const Value.absent(),
    this.currentSwipeIndex = const Value.absent(),
    this.isEdited = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.characterId = const Value.absent(),
    this.characterName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String chatId,
    required String role,
    required String content,
    required DateTime timestamp,
    this.swipes = const Value.absent(),
    this.currentSwipeIndex = const Value.absent(),
    this.isEdited = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.characterId = const Value.absent(),
    this.characterName = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chatId = Value(chatId),
        role = Value(role),
        content = Value(content),
        timestamp = Value(timestamp);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? chatId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<String>? swipes,
    Expression<int>? currentSwipeIndex,
    Expression<bool>? isEdited,
    Expression<bool>? isHidden,
    Expression<String>? metadataJson,
    Expression<String>? characterId,
    Expression<String>? characterName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (swipes != null) 'swipes': swipes,
      if (currentSwipeIndex != null) 'current_swipe_index': currentSwipeIndex,
      if (isEdited != null) 'is_edited': isEdited,
      if (isHidden != null) 'is_hidden': isHidden,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (characterId != null) 'character_id': characterId,
      if (characterName != null) 'character_name': characterName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? chatId,
      Value<String>? role,
      Value<String>? content,
      Value<DateTime>? timestamp,
      Value<String>? swipes,
      Value<int>? currentSwipeIndex,
      Value<bool>? isEdited,
      Value<bool>? isHidden,
      Value<String>? metadataJson,
      Value<String?>? characterId,
      Value<String?>? characterName,
      Value<int>? rowid}) {
    return MessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      swipes: swipes ?? this.swipes,
      currentSwipeIndex: currentSwipeIndex ?? this.currentSwipeIndex,
      isEdited: isEdited ?? this.isEdited,
      isHidden: isHidden ?? this.isHidden,
      metadataJson: metadataJson ?? this.metadataJson,
      characterId: characterId ?? this.characterId,
      characterName: characterName ?? this.characterName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (swipes.present) {
      map['swipes'] = Variable<String>(swipes.value);
    }
    if (currentSwipeIndex.present) {
      map['current_swipe_index'] = Variable<int>(currentSwipeIndex.value);
    }
    if (isEdited.present) {
      map['is_edited'] = Variable<bool>(isEdited.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (characterName.present) {
      map['character_name'] = Variable<String>(characterName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('swipes: $swipes, ')
          ..write('currentSwipeIndex: $currentSwipeIndex, ')
          ..write('isEdited: $isEdited, ')
          ..write('isHidden: $isHidden, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('characterId: $characterId, ')
          ..write('characterName: $characterName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldInfosTable extends WorldInfos
    with TableInfo<$WorldInfosTable, WorldInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isGlobalMeta =
      const VerificationMeta('isGlobal');
  @override
  late final GeneratedColumn<bool> isGlobal = GeneratedColumn<bool>(
      'is_global', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_global" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _characterIdMeta =
      const VerificationMeta('characterId');
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
      'character_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES characters (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        enabled,
        isGlobal,
        characterId,
        createdAt,
        modifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'world_infos';
  @override
  VerificationContext validateIntegrity(Insertable<WorldInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('is_global')) {
      context.handle(_isGlobalMeta,
          isGlobal.isAcceptableOrUnknown(data['is_global']!, _isGlobalMeta));
    }
    if (data.containsKey('character_id')) {
      context.handle(
          _characterIdMeta,
          characterId.isAcceptableOrUnknown(
              data['character_id']!, _characterIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorldInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldInfo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      isGlobal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_global'])!,
      characterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}character_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at'])!,
    );
  }

  @override
  $WorldInfosTable createAlias(String alias) {
    return $WorldInfosTable(attachedDatabase, alias);
  }
}

class WorldInfo extends DataClass implements Insertable<WorldInfo> {
  final String id;
  final String name;
  final String? description;
  final bool enabled;
  final bool isGlobal;
  final String? characterId;
  final DateTime createdAt;
  final DateTime modifiedAt;
  const WorldInfo(
      {required this.id,
      required this.name,
      this.description,
      required this.enabled,
      required this.isGlobal,
      this.characterId,
      required this.createdAt,
      required this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['is_global'] = Variable<bool>(isGlobal);
    if (!nullToAbsent || characterId != null) {
      map['character_id'] = Variable<String>(characterId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    return map;
  }

  WorldInfosCompanion toCompanion(bool nullToAbsent) {
    return WorldInfosCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      enabled: Value(enabled),
      isGlobal: Value(isGlobal),
      characterId: characterId == null && nullToAbsent
          ? const Value.absent()
          : Value(characterId),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
    );
  }

  factory WorldInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldInfo(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      isGlobal: serializer.fromJson<bool>(json['isGlobal']),
      characterId: serializer.fromJson<String?>(json['characterId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'enabled': serializer.toJson<bool>(enabled),
      'isGlobal': serializer.toJson<bool>(isGlobal),
      'characterId': serializer.toJson<String?>(characterId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
    };
  }

  WorldInfo copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          bool? enabled,
          bool? isGlobal,
          Value<String?> characterId = const Value.absent(),
          DateTime? createdAt,
          DateTime? modifiedAt}) =>
      WorldInfo(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        enabled: enabled ?? this.enabled,
        isGlobal: isGlobal ?? this.isGlobal,
        characterId: characterId.present ? characterId.value : this.characterId,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );
  WorldInfo copyWithCompanion(WorldInfosCompanion data) {
    return WorldInfo(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      isGlobal: data.isGlobal.present ? data.isGlobal.value : this.isGlobal,
      characterId:
          data.characterId.present ? data.characterId.value : this.characterId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldInfo(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('enabled: $enabled, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('characterId: $characterId, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, enabled, isGlobal,
      characterId, createdAt, modifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldInfo &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.enabled == this.enabled &&
          other.isGlobal == this.isGlobal &&
          other.characterId == this.characterId &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class WorldInfosCompanion extends UpdateCompanion<WorldInfo> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> enabled;
  final Value<bool> isGlobal;
  final Value<String?> characterId;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<int> rowid;
  const WorldInfosCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isGlobal = const Value.absent(),
    this.characterId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldInfosCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isGlobal = const Value.absent(),
    this.characterId = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        modifiedAt = Value(modifiedAt);
  static Insertable<WorldInfo> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? enabled,
    Expression<bool>? isGlobal,
    Expression<String>? characterId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (enabled != null) 'enabled': enabled,
      if (isGlobal != null) 'is_global': isGlobal,
      if (characterId != null) 'character_id': characterId,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldInfosCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<bool>? enabled,
      Value<bool>? isGlobal,
      Value<String?>? characterId,
      Value<DateTime>? createdAt,
      Value<DateTime>? modifiedAt,
      Value<int>? rowid}) {
    return WorldInfosCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      isGlobal: isGlobal ?? this.isGlobal,
      characterId: characterId ?? this.characterId,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (isGlobal.present) {
      map['is_global'] = Variable<bool>(isGlobal.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldInfosCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('enabled: $enabled, ')
          ..write('isGlobal: $isGlobal, ')
          ..write('characterId: $characterId, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldInfoEntriesTable extends WorldInfoEntries
    with TableInfo<$WorldInfoEntriesTable, WorldInfoEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldInfoEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _worldInfoIdMeta =
      const VerificationMeta('worldInfoId');
  @override
  late final GeneratedColumn<String> worldInfoId = GeneratedColumn<String>(
      'world_info_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES world_infos (id)'));
  static const VerificationMeta _keysMeta = const VerificationMeta('keys');
  @override
  late final GeneratedColumn<String> keys = GeneratedColumn<String>(
      'keys', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _secondaryKeysMeta =
      const VerificationMeta('secondaryKeys');
  @override
  late final GeneratedColumn<String> secondaryKeys = GeneratedColumn<String>(
      'secondary_keys', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _constantMeta =
      const VerificationMeta('constant');
  @override
  late final GeneratedColumn<bool> constant = GeneratedColumn<bool>(
      'constant', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("constant" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _selectiveMeta =
      const VerificationMeta('selective');
  @override
  late final GeneratedColumn<bool> selective = GeneratedColumn<bool>(
      'selective', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("selective" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _insertionOrderMeta =
      const VerificationMeta('insertionOrder');
  @override
  late final GeneratedColumn<int> insertionOrder = GeneratedColumn<int>(
      'insertion_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _caseSensitiveMeta =
      const VerificationMeta('caseSensitive');
  @override
  late final GeneratedColumn<bool> caseSensitive = GeneratedColumn<bool>(
      'case_sensitive', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("case_sensitive" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _matchWholeWordsMeta =
      const VerificationMeta('matchWholeWords');
  @override
  late final GeneratedColumn<bool> matchWholeWords = GeneratedColumn<bool>(
      'match_whole_words', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("match_whole_words" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _probabilityMeta =
      const VerificationMeta('probability');
  @override
  late final GeneratedColumn<int> probability = GeneratedColumn<int>(
      'probability', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _depthMeta = const VerificationMeta('depth');
  @override
  late final GeneratedColumn<int> depth = GeneratedColumn<int>(
      'depth', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _groupMeta = const VerificationMeta('group');
  @override
  late final GeneratedColumn<String> group = GeneratedColumn<String>(
      'group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupWeightMeta =
      const VerificationMeta('groupWeight');
  @override
  late final GeneratedColumn<int> groupWeight = GeneratedColumn<int>(
      'group_weight', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _preventRecursionMeta =
      const VerificationMeta('preventRecursion');
  @override
  late final GeneratedColumn<bool> preventRecursion = GeneratedColumn<bool>(
      'prevent_recursion', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("prevent_recursion" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _scanDepthMeta =
      const VerificationMeta('scanDepth');
  @override
  late final GeneratedColumn<int> scanDepth = GeneratedColumn<int>(
      'scan_depth', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1000));
  static const VerificationMeta _extensionsJsonMeta =
      const VerificationMeta('extensionsJson');
  @override
  late final GeneratedColumn<String> extensionsJson = GeneratedColumn<String>(
      'extensions_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        worldInfoId,
        keys,
        secondaryKeys,
        content,
        comment,
        enabled,
        constant,
        selective,
        insertionOrder,
        caseSensitive,
        matchWholeWords,
        probability,
        position,
        depth,
        group,
        groupWeight,
        preventRecursion,
        scanDepth,
        extensionsJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'world_info_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WorldInfoEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('world_info_id')) {
      context.handle(
          _worldInfoIdMeta,
          worldInfoId.isAcceptableOrUnknown(
              data['world_info_id']!, _worldInfoIdMeta));
    } else if (isInserting) {
      context.missing(_worldInfoIdMeta);
    }
    if (data.containsKey('keys')) {
      context.handle(
          _keysMeta, keys.isAcceptableOrUnknown(data['keys']!, _keysMeta));
    }
    if (data.containsKey('secondary_keys')) {
      context.handle(
          _secondaryKeysMeta,
          secondaryKeys.isAcceptableOrUnknown(
              data['secondary_keys']!, _secondaryKeysMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('constant')) {
      context.handle(_constantMeta,
          constant.isAcceptableOrUnknown(data['constant']!, _constantMeta));
    }
    if (data.containsKey('selective')) {
      context.handle(_selectiveMeta,
          selective.isAcceptableOrUnknown(data['selective']!, _selectiveMeta));
    }
    if (data.containsKey('insertion_order')) {
      context.handle(
          _insertionOrderMeta,
          insertionOrder.isAcceptableOrUnknown(
              data['insertion_order']!, _insertionOrderMeta));
    }
    if (data.containsKey('case_sensitive')) {
      context.handle(
          _caseSensitiveMeta,
          caseSensitive.isAcceptableOrUnknown(
              data['case_sensitive']!, _caseSensitiveMeta));
    }
    if (data.containsKey('match_whole_words')) {
      context.handle(
          _matchWholeWordsMeta,
          matchWholeWords.isAcceptableOrUnknown(
              data['match_whole_words']!, _matchWholeWordsMeta));
    }
    if (data.containsKey('probability')) {
      context.handle(
          _probabilityMeta,
          probability.isAcceptableOrUnknown(
              data['probability']!, _probabilityMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('depth')) {
      context.handle(
          _depthMeta, depth.isAcceptableOrUnknown(data['depth']!, _depthMeta));
    }
    if (data.containsKey('group')) {
      context.handle(
          _groupMeta, group.isAcceptableOrUnknown(data['group']!, _groupMeta));
    }
    if (data.containsKey('group_weight')) {
      context.handle(
          _groupWeightMeta,
          groupWeight.isAcceptableOrUnknown(
              data['group_weight']!, _groupWeightMeta));
    }
    if (data.containsKey('prevent_recursion')) {
      context.handle(
          _preventRecursionMeta,
          preventRecursion.isAcceptableOrUnknown(
              data['prevent_recursion']!, _preventRecursionMeta));
    }
    if (data.containsKey('scan_depth')) {
      context.handle(_scanDepthMeta,
          scanDepth.isAcceptableOrUnknown(data['scan_depth']!, _scanDepthMeta));
    }
    if (data.containsKey('extensions_json')) {
      context.handle(
          _extensionsJsonMeta,
          extensionsJson.isAcceptableOrUnknown(
              data['extensions_json']!, _extensionsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorldInfoEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldInfoEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      worldInfoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}world_info_id'])!,
      keys: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keys'])!,
      secondaryKeys: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}secondary_keys'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      constant: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}constant'])!,
      selective: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}selective'])!,
      insertionOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}insertion_order'])!,
      caseSensitive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}case_sensitive'])!,
      matchWholeWords: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}match_whole_words'])!,
      probability: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}probability'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      depth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}depth'])!,
      group: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group']),
      groupWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_weight'])!,
      preventRecursion: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}prevent_recursion'])!,
      scanDepth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scan_depth'])!,
      extensionsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}extensions_json'])!,
    );
  }

  @override
  $WorldInfoEntriesTable createAlias(String alias) {
    return $WorldInfoEntriesTable(attachedDatabase, alias);
  }
}

class WorldInfoEntry extends DataClass implements Insertable<WorldInfoEntry> {
  final String id;
  final String worldInfoId;
  final String keys;
  final String secondaryKeys;
  final String content;
  final String comment;
  final bool enabled;
  final bool constant;
  final bool selective;
  final int insertionOrder;
  final bool caseSensitive;
  final bool matchWholeWords;
  final int probability;
  final int position;
  final int depth;
  final String? group;
  final int groupWeight;
  final bool preventRecursion;
  final int scanDepth;
  final String extensionsJson;
  const WorldInfoEntry(
      {required this.id,
      required this.worldInfoId,
      required this.keys,
      required this.secondaryKeys,
      required this.content,
      required this.comment,
      required this.enabled,
      required this.constant,
      required this.selective,
      required this.insertionOrder,
      required this.caseSensitive,
      required this.matchWholeWords,
      required this.probability,
      required this.position,
      required this.depth,
      this.group,
      required this.groupWeight,
      required this.preventRecursion,
      required this.scanDepth,
      required this.extensionsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['world_info_id'] = Variable<String>(worldInfoId);
    map['keys'] = Variable<String>(keys);
    map['secondary_keys'] = Variable<String>(secondaryKeys);
    map['content'] = Variable<String>(content);
    map['comment'] = Variable<String>(comment);
    map['enabled'] = Variable<bool>(enabled);
    map['constant'] = Variable<bool>(constant);
    map['selective'] = Variable<bool>(selective);
    map['insertion_order'] = Variable<int>(insertionOrder);
    map['case_sensitive'] = Variable<bool>(caseSensitive);
    map['match_whole_words'] = Variable<bool>(matchWholeWords);
    map['probability'] = Variable<int>(probability);
    map['position'] = Variable<int>(position);
    map['depth'] = Variable<int>(depth);
    if (!nullToAbsent || group != null) {
      map['group'] = Variable<String>(group);
    }
    map['group_weight'] = Variable<int>(groupWeight);
    map['prevent_recursion'] = Variable<bool>(preventRecursion);
    map['scan_depth'] = Variable<int>(scanDepth);
    map['extensions_json'] = Variable<String>(extensionsJson);
    return map;
  }

  WorldInfoEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorldInfoEntriesCompanion(
      id: Value(id),
      worldInfoId: Value(worldInfoId),
      keys: Value(keys),
      secondaryKeys: Value(secondaryKeys),
      content: Value(content),
      comment: Value(comment),
      enabled: Value(enabled),
      constant: Value(constant),
      selective: Value(selective),
      insertionOrder: Value(insertionOrder),
      caseSensitive: Value(caseSensitive),
      matchWholeWords: Value(matchWholeWords),
      probability: Value(probability),
      position: Value(position),
      depth: Value(depth),
      group:
          group == null && nullToAbsent ? const Value.absent() : Value(group),
      groupWeight: Value(groupWeight),
      preventRecursion: Value(preventRecursion),
      scanDepth: Value(scanDepth),
      extensionsJson: Value(extensionsJson),
    );
  }

  factory WorldInfoEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldInfoEntry(
      id: serializer.fromJson<String>(json['id']),
      worldInfoId: serializer.fromJson<String>(json['worldInfoId']),
      keys: serializer.fromJson<String>(json['keys']),
      secondaryKeys: serializer.fromJson<String>(json['secondaryKeys']),
      content: serializer.fromJson<String>(json['content']),
      comment: serializer.fromJson<String>(json['comment']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      constant: serializer.fromJson<bool>(json['constant']),
      selective: serializer.fromJson<bool>(json['selective']),
      insertionOrder: serializer.fromJson<int>(json['insertionOrder']),
      caseSensitive: serializer.fromJson<bool>(json['caseSensitive']),
      matchWholeWords: serializer.fromJson<bool>(json['matchWholeWords']),
      probability: serializer.fromJson<int>(json['probability']),
      position: serializer.fromJson<int>(json['position']),
      depth: serializer.fromJson<int>(json['depth']),
      group: serializer.fromJson<String?>(json['group']),
      groupWeight: serializer.fromJson<int>(json['groupWeight']),
      preventRecursion: serializer.fromJson<bool>(json['preventRecursion']),
      scanDepth: serializer.fromJson<int>(json['scanDepth']),
      extensionsJson: serializer.fromJson<String>(json['extensionsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'worldInfoId': serializer.toJson<String>(worldInfoId),
      'keys': serializer.toJson<String>(keys),
      'secondaryKeys': serializer.toJson<String>(secondaryKeys),
      'content': serializer.toJson<String>(content),
      'comment': serializer.toJson<String>(comment),
      'enabled': serializer.toJson<bool>(enabled),
      'constant': serializer.toJson<bool>(constant),
      'selective': serializer.toJson<bool>(selective),
      'insertionOrder': serializer.toJson<int>(insertionOrder),
      'caseSensitive': serializer.toJson<bool>(caseSensitive),
      'matchWholeWords': serializer.toJson<bool>(matchWholeWords),
      'probability': serializer.toJson<int>(probability),
      'position': serializer.toJson<int>(position),
      'depth': serializer.toJson<int>(depth),
      'group': serializer.toJson<String?>(group),
      'groupWeight': serializer.toJson<int>(groupWeight),
      'preventRecursion': serializer.toJson<bool>(preventRecursion),
      'scanDepth': serializer.toJson<int>(scanDepth),
      'extensionsJson': serializer.toJson<String>(extensionsJson),
    };
  }

  WorldInfoEntry copyWith(
          {String? id,
          String? worldInfoId,
          String? keys,
          String? secondaryKeys,
          String? content,
          String? comment,
          bool? enabled,
          bool? constant,
          bool? selective,
          int? insertionOrder,
          bool? caseSensitive,
          bool? matchWholeWords,
          int? probability,
          int? position,
          int? depth,
          Value<String?> group = const Value.absent(),
          int? groupWeight,
          bool? preventRecursion,
          int? scanDepth,
          String? extensionsJson}) =>
      WorldInfoEntry(
        id: id ?? this.id,
        worldInfoId: worldInfoId ?? this.worldInfoId,
        keys: keys ?? this.keys,
        secondaryKeys: secondaryKeys ?? this.secondaryKeys,
        content: content ?? this.content,
        comment: comment ?? this.comment,
        enabled: enabled ?? this.enabled,
        constant: constant ?? this.constant,
        selective: selective ?? this.selective,
        insertionOrder: insertionOrder ?? this.insertionOrder,
        caseSensitive: caseSensitive ?? this.caseSensitive,
        matchWholeWords: matchWholeWords ?? this.matchWholeWords,
        probability: probability ?? this.probability,
        position: position ?? this.position,
        depth: depth ?? this.depth,
        group: group.present ? group.value : this.group,
        groupWeight: groupWeight ?? this.groupWeight,
        preventRecursion: preventRecursion ?? this.preventRecursion,
        scanDepth: scanDepth ?? this.scanDepth,
        extensionsJson: extensionsJson ?? this.extensionsJson,
      );
  WorldInfoEntry copyWithCompanion(WorldInfoEntriesCompanion data) {
    return WorldInfoEntry(
      id: data.id.present ? data.id.value : this.id,
      worldInfoId:
          data.worldInfoId.present ? data.worldInfoId.value : this.worldInfoId,
      keys: data.keys.present ? data.keys.value : this.keys,
      secondaryKeys: data.secondaryKeys.present
          ? data.secondaryKeys.value
          : this.secondaryKeys,
      content: data.content.present ? data.content.value : this.content,
      comment: data.comment.present ? data.comment.value : this.comment,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      constant: data.constant.present ? data.constant.value : this.constant,
      selective: data.selective.present ? data.selective.value : this.selective,
      insertionOrder: data.insertionOrder.present
          ? data.insertionOrder.value
          : this.insertionOrder,
      caseSensitive: data.caseSensitive.present
          ? data.caseSensitive.value
          : this.caseSensitive,
      matchWholeWords: data.matchWholeWords.present
          ? data.matchWholeWords.value
          : this.matchWholeWords,
      probability:
          data.probability.present ? data.probability.value : this.probability,
      position: data.position.present ? data.position.value : this.position,
      depth: data.depth.present ? data.depth.value : this.depth,
      group: data.group.present ? data.group.value : this.group,
      groupWeight:
          data.groupWeight.present ? data.groupWeight.value : this.groupWeight,
      preventRecursion: data.preventRecursion.present
          ? data.preventRecursion.value
          : this.preventRecursion,
      scanDepth: data.scanDepth.present ? data.scanDepth.value : this.scanDepth,
      extensionsJson: data.extensionsJson.present
          ? data.extensionsJson.value
          : this.extensionsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldInfoEntry(')
          ..write('id: $id, ')
          ..write('worldInfoId: $worldInfoId, ')
          ..write('keys: $keys, ')
          ..write('secondaryKeys: $secondaryKeys, ')
          ..write('content: $content, ')
          ..write('comment: $comment, ')
          ..write('enabled: $enabled, ')
          ..write('constant: $constant, ')
          ..write('selective: $selective, ')
          ..write('insertionOrder: $insertionOrder, ')
          ..write('caseSensitive: $caseSensitive, ')
          ..write('matchWholeWords: $matchWholeWords, ')
          ..write('probability: $probability, ')
          ..write('position: $position, ')
          ..write('depth: $depth, ')
          ..write('group: $group, ')
          ..write('groupWeight: $groupWeight, ')
          ..write('preventRecursion: $preventRecursion, ')
          ..write('scanDepth: $scanDepth, ')
          ..write('extensionsJson: $extensionsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      worldInfoId,
      keys,
      secondaryKeys,
      content,
      comment,
      enabled,
      constant,
      selective,
      insertionOrder,
      caseSensitive,
      matchWholeWords,
      probability,
      position,
      depth,
      group,
      groupWeight,
      preventRecursion,
      scanDepth,
      extensionsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldInfoEntry &&
          other.id == this.id &&
          other.worldInfoId == this.worldInfoId &&
          other.keys == this.keys &&
          other.secondaryKeys == this.secondaryKeys &&
          other.content == this.content &&
          other.comment == this.comment &&
          other.enabled == this.enabled &&
          other.constant == this.constant &&
          other.selective == this.selective &&
          other.insertionOrder == this.insertionOrder &&
          other.caseSensitive == this.caseSensitive &&
          other.matchWholeWords == this.matchWholeWords &&
          other.probability == this.probability &&
          other.position == this.position &&
          other.depth == this.depth &&
          other.group == this.group &&
          other.groupWeight == this.groupWeight &&
          other.preventRecursion == this.preventRecursion &&
          other.scanDepth == this.scanDepth &&
          other.extensionsJson == this.extensionsJson);
}

class WorldInfoEntriesCompanion extends UpdateCompanion<WorldInfoEntry> {
  final Value<String> id;
  final Value<String> worldInfoId;
  final Value<String> keys;
  final Value<String> secondaryKeys;
  final Value<String> content;
  final Value<String> comment;
  final Value<bool> enabled;
  final Value<bool> constant;
  final Value<bool> selective;
  final Value<int> insertionOrder;
  final Value<bool> caseSensitive;
  final Value<bool> matchWholeWords;
  final Value<int> probability;
  final Value<int> position;
  final Value<int> depth;
  final Value<String?> group;
  final Value<int> groupWeight;
  final Value<bool> preventRecursion;
  final Value<int> scanDepth;
  final Value<String> extensionsJson;
  final Value<int> rowid;
  const WorldInfoEntriesCompanion({
    this.id = const Value.absent(),
    this.worldInfoId = const Value.absent(),
    this.keys = const Value.absent(),
    this.secondaryKeys = const Value.absent(),
    this.content = const Value.absent(),
    this.comment = const Value.absent(),
    this.enabled = const Value.absent(),
    this.constant = const Value.absent(),
    this.selective = const Value.absent(),
    this.insertionOrder = const Value.absent(),
    this.caseSensitive = const Value.absent(),
    this.matchWholeWords = const Value.absent(),
    this.probability = const Value.absent(),
    this.position = const Value.absent(),
    this.depth = const Value.absent(),
    this.group = const Value.absent(),
    this.groupWeight = const Value.absent(),
    this.preventRecursion = const Value.absent(),
    this.scanDepth = const Value.absent(),
    this.extensionsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldInfoEntriesCompanion.insert({
    required String id,
    required String worldInfoId,
    this.keys = const Value.absent(),
    this.secondaryKeys = const Value.absent(),
    this.content = const Value.absent(),
    this.comment = const Value.absent(),
    this.enabled = const Value.absent(),
    this.constant = const Value.absent(),
    this.selective = const Value.absent(),
    this.insertionOrder = const Value.absent(),
    this.caseSensitive = const Value.absent(),
    this.matchWholeWords = const Value.absent(),
    this.probability = const Value.absent(),
    this.position = const Value.absent(),
    this.depth = const Value.absent(),
    this.group = const Value.absent(),
    this.groupWeight = const Value.absent(),
    this.preventRecursion = const Value.absent(),
    this.scanDepth = const Value.absent(),
    this.extensionsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        worldInfoId = Value(worldInfoId);
  static Insertable<WorldInfoEntry> custom({
    Expression<String>? id,
    Expression<String>? worldInfoId,
    Expression<String>? keys,
    Expression<String>? secondaryKeys,
    Expression<String>? content,
    Expression<String>? comment,
    Expression<bool>? enabled,
    Expression<bool>? constant,
    Expression<bool>? selective,
    Expression<int>? insertionOrder,
    Expression<bool>? caseSensitive,
    Expression<bool>? matchWholeWords,
    Expression<int>? probability,
    Expression<int>? position,
    Expression<int>? depth,
    Expression<String>? group,
    Expression<int>? groupWeight,
    Expression<bool>? preventRecursion,
    Expression<int>? scanDepth,
    Expression<String>? extensionsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (worldInfoId != null) 'world_info_id': worldInfoId,
      if (keys != null) 'keys': keys,
      if (secondaryKeys != null) 'secondary_keys': secondaryKeys,
      if (content != null) 'content': content,
      if (comment != null) 'comment': comment,
      if (enabled != null) 'enabled': enabled,
      if (constant != null) 'constant': constant,
      if (selective != null) 'selective': selective,
      if (insertionOrder != null) 'insertion_order': insertionOrder,
      if (caseSensitive != null) 'case_sensitive': caseSensitive,
      if (matchWholeWords != null) 'match_whole_words': matchWholeWords,
      if (probability != null) 'probability': probability,
      if (position != null) 'position': position,
      if (depth != null) 'depth': depth,
      if (group != null) 'group': group,
      if (groupWeight != null) 'group_weight': groupWeight,
      if (preventRecursion != null) 'prevent_recursion': preventRecursion,
      if (scanDepth != null) 'scan_depth': scanDepth,
      if (extensionsJson != null) 'extensions_json': extensionsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldInfoEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? worldInfoId,
      Value<String>? keys,
      Value<String>? secondaryKeys,
      Value<String>? content,
      Value<String>? comment,
      Value<bool>? enabled,
      Value<bool>? constant,
      Value<bool>? selective,
      Value<int>? insertionOrder,
      Value<bool>? caseSensitive,
      Value<bool>? matchWholeWords,
      Value<int>? probability,
      Value<int>? position,
      Value<int>? depth,
      Value<String?>? group,
      Value<int>? groupWeight,
      Value<bool>? preventRecursion,
      Value<int>? scanDepth,
      Value<String>? extensionsJson,
      Value<int>? rowid}) {
    return WorldInfoEntriesCompanion(
      id: id ?? this.id,
      worldInfoId: worldInfoId ?? this.worldInfoId,
      keys: keys ?? this.keys,
      secondaryKeys: secondaryKeys ?? this.secondaryKeys,
      content: content ?? this.content,
      comment: comment ?? this.comment,
      enabled: enabled ?? this.enabled,
      constant: constant ?? this.constant,
      selective: selective ?? this.selective,
      insertionOrder: insertionOrder ?? this.insertionOrder,
      caseSensitive: caseSensitive ?? this.caseSensitive,
      matchWholeWords: matchWholeWords ?? this.matchWholeWords,
      probability: probability ?? this.probability,
      position: position ?? this.position,
      depth: depth ?? this.depth,
      group: group ?? this.group,
      groupWeight: groupWeight ?? this.groupWeight,
      preventRecursion: preventRecursion ?? this.preventRecursion,
      scanDepth: scanDepth ?? this.scanDepth,
      extensionsJson: extensionsJson ?? this.extensionsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (worldInfoId.present) {
      map['world_info_id'] = Variable<String>(worldInfoId.value);
    }
    if (keys.present) {
      map['keys'] = Variable<String>(keys.value);
    }
    if (secondaryKeys.present) {
      map['secondary_keys'] = Variable<String>(secondaryKeys.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (constant.present) {
      map['constant'] = Variable<bool>(constant.value);
    }
    if (selective.present) {
      map['selective'] = Variable<bool>(selective.value);
    }
    if (insertionOrder.present) {
      map['insertion_order'] = Variable<int>(insertionOrder.value);
    }
    if (caseSensitive.present) {
      map['case_sensitive'] = Variable<bool>(caseSensitive.value);
    }
    if (matchWholeWords.present) {
      map['match_whole_words'] = Variable<bool>(matchWholeWords.value);
    }
    if (probability.present) {
      map['probability'] = Variable<int>(probability.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (depth.present) {
      map['depth'] = Variable<int>(depth.value);
    }
    if (group.present) {
      map['group'] = Variable<String>(group.value);
    }
    if (groupWeight.present) {
      map['group_weight'] = Variable<int>(groupWeight.value);
    }
    if (preventRecursion.present) {
      map['prevent_recursion'] = Variable<bool>(preventRecursion.value);
    }
    if (scanDepth.present) {
      map['scan_depth'] = Variable<int>(scanDepth.value);
    }
    if (extensionsJson.present) {
      map['extensions_json'] = Variable<String>(extensionsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldInfoEntriesCompanion(')
          ..write('id: $id, ')
          ..write('worldInfoId: $worldInfoId, ')
          ..write('keys: $keys, ')
          ..write('secondaryKeys: $secondaryKeys, ')
          ..write('content: $content, ')
          ..write('comment: $comment, ')
          ..write('enabled: $enabled, ')
          ..write('constant: $constant, ')
          ..write('selective: $selective, ')
          ..write('insertionOrder: $insertionOrder, ')
          ..write('caseSensitive: $caseSensitive, ')
          ..write('matchWholeWords: $matchWholeWords, ')
          ..write('probability: $probability, ')
          ..write('position: $position, ')
          ..write('depth: $depth, ')
          ..write('group: $group, ')
          ..write('groupWeight: $groupWeight, ')
          ..write('preventRecursion: $preventRecursion, ')
          ..write('scanDepth: $scanDepth, ')
          ..write('extensionsJson: $extensionsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LlmConfigsTable extends LlmConfigs
    with TableInfo<$LlmConfigsTable, LlmConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LlmConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endpointMeta =
      const VerificationMeta('endpoint');
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
      'endpoint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
      'api_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _defaultSettingsJsonMeta =
      const VerificationMeta('defaultSettingsJson');
  @override
  late final GeneratedColumn<String> defaultSettingsJson =
      GeneratedColumn<String>('default_settings_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        provider,
        endpoint,
        apiKey,
        model,
        enabled,
        isDefault,
        defaultSettingsJson,
        createdAt,
        modifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'llm_configs';
  @override
  VerificationContext validateIntegrity(Insertable<LlmConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('endpoint')) {
      context.handle(_endpointMeta,
          endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta));
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('default_settings_json')) {
      context.handle(
          _defaultSettingsJsonMeta,
          defaultSettingsJson.isAcceptableOrUnknown(
              data['default_settings_json']!, _defaultSettingsJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LlmConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LlmConfig(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      endpoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endpoint'])!,
      apiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key']),
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      defaultSettingsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_settings_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at'])!,
    );
  }

  @override
  $LlmConfigsTable createAlias(String alias) {
    return $LlmConfigsTable(attachedDatabase, alias);
  }
}

class LlmConfig extends DataClass implements Insertable<LlmConfig> {
  final String id;
  final String name;
  final String provider;
  final String endpoint;
  final String? apiKey;
  final String? model;
  final bool enabled;
  final bool isDefault;
  final String defaultSettingsJson;
  final DateTime createdAt;
  final DateTime modifiedAt;
  const LlmConfig(
      {required this.id,
      required this.name,
      required this.provider,
      required this.endpoint,
      this.apiKey,
      this.model,
      required this.enabled,
      required this.isDefault,
      required this.defaultSettingsJson,
      required this.createdAt,
      required this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['provider'] = Variable<String>(provider);
    map['endpoint'] = Variable<String>(endpoint);
    if (!nullToAbsent || apiKey != null) {
      map['api_key'] = Variable<String>(apiKey);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['is_default'] = Variable<bool>(isDefault);
    map['default_settings_json'] = Variable<String>(defaultSettingsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    return map;
  }

  LlmConfigsCompanion toCompanion(bool nullToAbsent) {
    return LlmConfigsCompanion(
      id: Value(id),
      name: Value(name),
      provider: Value(provider),
      endpoint: Value(endpoint),
      apiKey:
          apiKey == null && nullToAbsent ? const Value.absent() : Value(apiKey),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      enabled: Value(enabled),
      isDefault: Value(isDefault),
      defaultSettingsJson: Value(defaultSettingsJson),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
    );
  }

  factory LlmConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LlmConfig(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      provider: serializer.fromJson<String>(json['provider']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      apiKey: serializer.fromJson<String?>(json['apiKey']),
      model: serializer.fromJson<String?>(json['model']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      defaultSettingsJson:
          serializer.fromJson<String>(json['defaultSettingsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'provider': serializer.toJson<String>(provider),
      'endpoint': serializer.toJson<String>(endpoint),
      'apiKey': serializer.toJson<String?>(apiKey),
      'model': serializer.toJson<String?>(model),
      'enabled': serializer.toJson<bool>(enabled),
      'isDefault': serializer.toJson<bool>(isDefault),
      'defaultSettingsJson': serializer.toJson<String>(defaultSettingsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
    };
  }

  LlmConfig copyWith(
          {String? id,
          String? name,
          String? provider,
          String? endpoint,
          Value<String?> apiKey = const Value.absent(),
          Value<String?> model = const Value.absent(),
          bool? enabled,
          bool? isDefault,
          String? defaultSettingsJson,
          DateTime? createdAt,
          DateTime? modifiedAt}) =>
      LlmConfig(
        id: id ?? this.id,
        name: name ?? this.name,
        provider: provider ?? this.provider,
        endpoint: endpoint ?? this.endpoint,
        apiKey: apiKey.present ? apiKey.value : this.apiKey,
        model: model.present ? model.value : this.model,
        enabled: enabled ?? this.enabled,
        isDefault: isDefault ?? this.isDefault,
        defaultSettingsJson: defaultSettingsJson ?? this.defaultSettingsJson,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );
  LlmConfig copyWithCompanion(LlmConfigsCompanion data) {
    return LlmConfig(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      provider: data.provider.present ? data.provider.value : this.provider,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      apiKey: data.apiKey.present ? data.apiKey.value : this.apiKey,
      model: data.model.present ? data.model.value : this.model,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      defaultSettingsJson: data.defaultSettingsJson.present
          ? data.defaultSettingsJson.value
          : this.defaultSettingsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LlmConfig(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('provider: $provider, ')
          ..write('endpoint: $endpoint, ')
          ..write('apiKey: $apiKey, ')
          ..write('model: $model, ')
          ..write('enabled: $enabled, ')
          ..write('isDefault: $isDefault, ')
          ..write('defaultSettingsJson: $defaultSettingsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, provider, endpoint, apiKey, model,
      enabled, isDefault, defaultSettingsJson, createdAt, modifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LlmConfig &&
          other.id == this.id &&
          other.name == this.name &&
          other.provider == this.provider &&
          other.endpoint == this.endpoint &&
          other.apiKey == this.apiKey &&
          other.model == this.model &&
          other.enabled == this.enabled &&
          other.isDefault == this.isDefault &&
          other.defaultSettingsJson == this.defaultSettingsJson &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class LlmConfigsCompanion extends UpdateCompanion<LlmConfig> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> provider;
  final Value<String> endpoint;
  final Value<String?> apiKey;
  final Value<String?> model;
  final Value<bool> enabled;
  final Value<bool> isDefault;
  final Value<String> defaultSettingsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<int> rowid;
  const LlmConfigsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.provider = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.model = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.defaultSettingsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LlmConfigsCompanion.insert({
    required String id,
    required String name,
    required String provider,
    required String endpoint,
    this.apiKey = const Value.absent(),
    this.model = const Value.absent(),
    this.enabled = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.defaultSettingsJson = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        provider = Value(provider),
        endpoint = Value(endpoint),
        createdAt = Value(createdAt),
        modifiedAt = Value(modifiedAt);
  static Insertable<LlmConfig> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? provider,
    Expression<String>? endpoint,
    Expression<String>? apiKey,
    Expression<String>? model,
    Expression<bool>? enabled,
    Expression<bool>? isDefault,
    Expression<String>? defaultSettingsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (provider != null) 'provider': provider,
      if (endpoint != null) 'endpoint': endpoint,
      if (apiKey != null) 'api_key': apiKey,
      if (model != null) 'model': model,
      if (enabled != null) 'enabled': enabled,
      if (isDefault != null) 'is_default': isDefault,
      if (defaultSettingsJson != null)
        'default_settings_json': defaultSettingsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LlmConfigsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? provider,
      Value<String>? endpoint,
      Value<String?>? apiKey,
      Value<String?>? model,
      Value<bool>? enabled,
      Value<bool>? isDefault,
      Value<String>? defaultSettingsJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? modifiedAt,
      Value<int>? rowid}) {
    return LlmConfigsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      endpoint: endpoint ?? this.endpoint,
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      enabled: enabled ?? this.enabled,
      isDefault: isDefault ?? this.isDefault,
      defaultSettingsJson: defaultSettingsJson ?? this.defaultSettingsJson,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (defaultSettingsJson.present) {
      map['default_settings_json'] =
          Variable<String>(defaultSettingsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LlmConfigsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('provider: $provider, ')
          ..write('endpoint: $endpoint, ')
          ..write('apiKey: $apiKey, ')
          ..write('model: $model, ')
          ..write('enabled: $enabled, ')
          ..write('isDefault: $isDefault, ')
          ..write('defaultSettingsJson: $defaultSettingsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonasTable extends Personas with TableInfo<$PersonasTable, Persona> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, avatarPath, isDefault, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personas';
  @override
  VerificationContext validateIntegrity(Insertable<Persona> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Persona map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Persona(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PersonasTable createAlias(String alias) {
    return $PersonasTable(attachedDatabase, alias);
  }
}

class Persona extends DataClass implements Insertable<Persona> {
  final String id;
  final String name;
  final String description;
  final String? avatarPath;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Persona(
      {required this.id,
      required this.name,
      required this.description,
      this.avatarPath,
      required this.isDefault,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonasCompanion toCompanion(bool nullToAbsent) {
    return PersonasCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Persona.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Persona(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Persona copyWith(
          {String? id,
          String? name,
          String? description,
          Value<String?> avatarPath = const Value.absent(),
          bool? isDefault,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Persona(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Persona copyWithCompanion(PersonasCompanion data) {
    return Persona(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Persona(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, description, avatarPath, isDefault, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Persona &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.avatarPath == this.avatarPath &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonasCompanion extends UpdateCompanion<Persona> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> avatarPath;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PersonasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonasCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Persona> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? avatarPath,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonasCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String?>? avatarPath,
      Value<bool>? isDefault,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PersonasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarPath: avatarPath ?? this.avatarPath,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _membersJsonMeta =
      const VerificationMeta('membersJson');
  @override
  late final GeneratedColumn<String> membersJson = GeneratedColumn<String>(
      'members_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _settingsJsonMeta =
      const VerificationMeta('settingsJson');
  @override
  late final GeneratedColumn<String> settingsJson = GeneratedColumn<String>(
      'settings_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        membersJson,
        settingsJson,
        avatarPath,
        createdAt,
        modifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<Group> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('members_json')) {
      context.handle(
          _membersJsonMeta,
          membersJson.isAcceptableOrUnknown(
              data['members_json']!, _membersJsonMeta));
    }
    if (data.containsKey('settings_json')) {
      context.handle(
          _settingsJsonMeta,
          settingsJson.isAcceptableOrUnknown(
              data['settings_json']!, _settingsJsonMeta));
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    } else if (isInserting) {
      context.missing(_modifiedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      membersJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}members_json'])!,
      settingsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}settings_json'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at'])!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final String id;
  final String name;
  final String? description;
  final String membersJson;
  final String settingsJson;
  final String? avatarPath;
  final DateTime createdAt;
  final DateTime modifiedAt;
  const Group(
      {required this.id,
      required this.name,
      this.description,
      required this.membersJson,
      required this.settingsJson,
      this.avatarPath,
      required this.createdAt,
      required this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['members_json'] = Variable<String>(membersJson);
    map['settings_json'] = Variable<String>(settingsJson);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['modified_at'] = Variable<DateTime>(modifiedAt);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      membersJson: Value(membersJson),
      settingsJson: Value(settingsJson),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
    );
  }

  factory Group.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      membersJson: serializer.fromJson<String>(json['membersJson']),
      settingsJson: serializer.fromJson<String>(json['settingsJson']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'membersJson': serializer.toJson<String>(membersJson),
      'settingsJson': serializer.toJson<String>(settingsJson),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime>(modifiedAt),
    };
  }

  Group copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? membersJson,
          String? settingsJson,
          Value<String?> avatarPath = const Value.absent(),
          DateTime? createdAt,
          DateTime? modifiedAt}) =>
      Group(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        membersJson: membersJson ?? this.membersJson,
        settingsJson: settingsJson ?? this.settingsJson,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt ?? this.modifiedAt,
      );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      membersJson:
          data.membersJson.present ? data.membersJson.value : this.membersJson,
      settingsJson: data.settingsJson.present
          ? data.settingsJson.value
          : this.settingsJson,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('membersJson: $membersJson, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, membersJson,
      settingsJson, avatarPath, createdAt, modifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.membersJson == this.membersJson &&
          other.settingsJson == this.settingsJson &&
          other.avatarPath == this.avatarPath &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> membersJson;
  final Value<String> settingsJson;
  final Value<String?> avatarPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> modifiedAt;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.membersJson = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.membersJson = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.avatarPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        modifiedAt = Value(modifiedAt);
  static Insertable<Group> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? membersJson,
    Expression<String>? settingsJson,
    Expression<String>? avatarPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (membersJson != null) 'members_json': membersJson,
      if (settingsJson != null) 'settings_json': settingsJson,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? membersJson,
      Value<String>? settingsJson,
      Value<String?>? avatarPath,
      Value<DateTime>? createdAt,
      Value<DateTime>? modifiedAt,
      Value<int>? rowid}) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      membersJson: membersJson ?? this.membersJson,
      settingsJson: settingsJson ?? this.settingsJson,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (membersJson.present) {
      map['members_json'] = Variable<String>(membersJson.value);
    }
    if (settingsJson.present) {
      map['settings_json'] = Variable<String>(settingsJson.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('membersJson: $membersJson, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chats (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIndexMeta =
      const VerificationMeta('messageIndex');
  @override
  late final GeneratedColumn<int> messageIndex = GeneratedColumn<int>(
      'message_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, chatId, name, description, messageId, messageIndex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<Bookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('message_index')) {
      context.handle(
          _messageIndexMeta,
          messageIndex.isAcceptableOrUnknown(
              data['message_index']!, _messageIndexMeta));
    } else if (isInserting) {
      context.missing(_messageIndexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      messageIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}message_index'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final String id;
  final String chatId;
  final String name;
  final String? description;
  final String messageId;
  final int messageIndex;
  final DateTime createdAt;
  const Bookmark(
      {required this.id,
      required this.chatId,
      required this.name,
      this.description,
      required this.messageId,
      required this.messageIndex,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chat_id'] = Variable<String>(chatId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['message_id'] = Variable<String>(messageId);
    map['message_index'] = Variable<int>(messageIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      chatId: Value(chatId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      messageId: Value(messageId),
      messageIndex: Value(messageIndex),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<String>(json['id']),
      chatId: serializer.fromJson<String>(json['chatId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      messageId: serializer.fromJson<String>(json['messageId']),
      messageIndex: serializer.fromJson<int>(json['messageIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chatId': serializer.toJson<String>(chatId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'messageId': serializer.toJson<String>(messageId),
      'messageIndex': serializer.toJson<int>(messageIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bookmark copyWith(
          {String? id,
          String? chatId,
          String? name,
          Value<String?> description = const Value.absent(),
          String? messageId,
          int? messageIndex,
          DateTime? createdAt}) =>
      Bookmark(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        messageId: messageId ?? this.messageId,
        messageIndex: messageIndex ?? this.messageIndex,
        createdAt: createdAt ?? this.createdAt,
      );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      messageIndex: data.messageIndex.present
          ? data.messageIndex.value
          : this.messageIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('messageId: $messageId, ')
          ..write('messageIndex: $messageIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, chatId, name, description, messageId, messageIndex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.name == this.name &&
          other.description == this.description &&
          other.messageId == this.messageId &&
          other.messageIndex == this.messageIndex &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<String> id;
  final Value<String> chatId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> messageId;
  final Value<int> messageIndex;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.messageId = const Value.absent(),
    this.messageIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookmarksCompanion.insert({
    required String id,
    required String chatId,
    required String name,
    this.description = const Value.absent(),
    required String messageId,
    required int messageIndex,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chatId = Value(chatId),
        name = Value(name),
        messageId = Value(messageId),
        messageIndex = Value(messageIndex),
        createdAt = Value(createdAt);
  static Insertable<Bookmark> custom({
    Expression<String>? id,
    Expression<String>? chatId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? messageId,
    Expression<int>? messageIndex,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (messageId != null) 'message_id': messageId,
      if (messageIndex != null) 'message_index': messageIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookmarksCompanion copyWith(
      {Value<String>? id,
      Value<String>? chatId,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? messageId,
      Value<int>? messageIndex,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BookmarksCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      name: name ?? this.name,
      description: description ?? this.description,
      messageId: messageId ?? this.messageId,
      messageIndex: messageIndex ?? this.messageIndex,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (messageIndex.present) {
      map['message_index'] = Variable<int>(messageIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('messageId: $messageId, ')
          ..write('messageIndex: $messageIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CharactersTable characters = $CharactersTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $WorldInfosTable worldInfos = $WorldInfosTable(this);
  late final $WorldInfoEntriesTable worldInfoEntries =
      $WorldInfoEntriesTable(this);
  late final $LlmConfigsTable llmConfigs = $LlmConfigsTable(this);
  late final $PersonasTable personas = $PersonasTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        characters,
        chats,
        messages,
        worldInfos,
        worldInfoEntries,
        llmConfigs,
        personas,
        groups,
        bookmarks
      ];
}

typedef $$CharactersTableCreateCompanionBuilder = CharactersCompanion Function({
  required String id,
  required String name,
  Value<String> description,
  Value<String> personality,
  Value<String> scenario,
  Value<String> firstMessage,
  Value<String> alternateGreetings,
  Value<String> exampleDialogue,
  Value<String> systemPrompt,
  Value<String> postHistoryInstructions,
  Value<String> creatorNotes,
  Value<String> tags,
  Value<String> creator,
  Value<String> characterVersion,
  Value<String?> avatarPath,
  Value<String> assetsJson,
  Value<String> characterBookJson,
  Value<String> extensionsJson,
  Value<bool> isFavorite,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<int> rowid,
});
typedef $$CharactersTableUpdateCompanionBuilder = CharactersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> personality,
  Value<String> scenario,
  Value<String> firstMessage,
  Value<String> alternateGreetings,
  Value<String> exampleDialogue,
  Value<String> systemPrompt,
  Value<String> postHistoryInstructions,
  Value<String> creatorNotes,
  Value<String> tags,
  Value<String> creator,
  Value<String> characterVersion,
  Value<String?> avatarPath,
  Value<String> assetsJson,
  Value<String> characterBookJson,
  Value<String> extensionsJson,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<int> rowid,
});

final class $$CharactersTableReferences
    extends BaseReferences<_$AppDatabase, $CharactersTable, Character> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChatsTable, List<Chat>> _chatsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.chats,
          aliasName:
              $_aliasNameGenerator(db.characters.id, db.chats.characterId));

  $$ChatsTableProcessedTableManager get chatsRefs {
    final manager = $$ChatsTableTableManager($_db, $_db.chats)
        .filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorldInfosTable, List<WorldInfo>>
      _worldInfosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.worldInfos,
              aliasName: $_aliasNameGenerator(
                  db.characters.id, db.worldInfos.characterId));

  $$WorldInfosTableProcessedTableManager get worldInfosRefs {
    final manager = $$WorldInfosTableTableManager($_db, $_db.worldInfos)
        .filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_worldInfosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenario => $composableBuilder(
      column: $table.scenario, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstMessage => $composableBuilder(
      column: $table.firstMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alternateGreetings => $composableBuilder(
      column: $table.alternateGreetings,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleDialogue => $composableBuilder(
      column: $table.exampleDialogue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postHistoryInstructions => $composableBuilder(
      column: $table.postHistoryInstructions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creatorNotes => $composableBuilder(
      column: $table.creatorNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creator => $composableBuilder(
      column: $table.creator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characterVersion => $composableBuilder(
      column: $table.characterVersion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assetsJson => $composableBuilder(
      column: $table.assetsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characterBookJson => $composableBuilder(
      column: $table.characterBookJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extensionsJson => $composableBuilder(
      column: $table.extensionsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> chatsRefs(
      Expression<bool> Function($$ChatsTableFilterComposer f) f) {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableFilterComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> worldInfosRefs(
      Expression<bool> Function($$WorldInfosTableFilterComposer f) f) {
    final $$WorldInfosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.worldInfos,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldInfosTableFilterComposer(
              $db: $db,
              $table: $db.worldInfos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenario => $composableBuilder(
      column: $table.scenario, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstMessage => $composableBuilder(
      column: $table.firstMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alternateGreetings => $composableBuilder(
      column: $table.alternateGreetings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleDialogue => $composableBuilder(
      column: $table.exampleDialogue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postHistoryInstructions => $composableBuilder(
      column: $table.postHistoryInstructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creatorNotes => $composableBuilder(
      column: $table.creatorNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creator => $composableBuilder(
      column: $table.creator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characterVersion => $composableBuilder(
      column: $table.characterVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assetsJson => $composableBuilder(
      column: $table.assetsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characterBookJson => $composableBuilder(
      column: $table.characterBookJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extensionsJson => $composableBuilder(
      column: $table.extensionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get personality => $composableBuilder(
      column: $table.personality, builder: (column) => column);

  GeneratedColumn<String> get scenario =>
      $composableBuilder(column: $table.scenario, builder: (column) => column);

  GeneratedColumn<String> get firstMessage => $composableBuilder(
      column: $table.firstMessage, builder: (column) => column);

  GeneratedColumn<String> get alternateGreetings => $composableBuilder(
      column: $table.alternateGreetings, builder: (column) => column);

  GeneratedColumn<String> get exampleDialogue => $composableBuilder(
      column: $table.exampleDialogue, builder: (column) => column);

  GeneratedColumn<String> get systemPrompt => $composableBuilder(
      column: $table.systemPrompt, builder: (column) => column);

  GeneratedColumn<String> get postHistoryInstructions => $composableBuilder(
      column: $table.postHistoryInstructions, builder: (column) => column);

  GeneratedColumn<String> get creatorNotes => $composableBuilder(
      column: $table.creatorNotes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<String> get characterVersion => $composableBuilder(
      column: $table.characterVersion, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<String> get assetsJson => $composableBuilder(
      column: $table.assetsJson, builder: (column) => column);

  GeneratedColumn<String> get characterBookJson => $composableBuilder(
      column: $table.characterBookJson, builder: (column) => column);

  GeneratedColumn<String> get extensionsJson => $composableBuilder(
      column: $table.extensionsJson, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  Expression<T> chatsRefs<T extends Object>(
      Expression<T> Function($$ChatsTableAnnotationComposer a) f) {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableAnnotationComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> worldInfosRefs<T extends Object>(
      Expression<T> Function($$WorldInfosTableAnnotationComposer a) f) {
    final $$WorldInfosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.worldInfos,
        getReferencedColumn: (t) => t.characterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldInfosTableAnnotationComposer(
              $db: $db,
              $table: $db.worldInfos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CharactersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CharactersTable,
    Character,
    $$CharactersTableFilterComposer,
    $$CharactersTableOrderingComposer,
    $$CharactersTableAnnotationComposer,
    $$CharactersTableCreateCompanionBuilder,
    $$CharactersTableUpdateCompanionBuilder,
    (Character, $$CharactersTableReferences),
    Character,
    PrefetchHooks Function({bool chatsRefs, bool worldInfosRefs})> {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> personality = const Value.absent(),
            Value<String> scenario = const Value.absent(),
            Value<String> firstMessage = const Value.absent(),
            Value<String> alternateGreetings = const Value.absent(),
            Value<String> exampleDialogue = const Value.absent(),
            Value<String> systemPrompt = const Value.absent(),
            Value<String> postHistoryInstructions = const Value.absent(),
            Value<String> creatorNotes = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> creator = const Value.absent(),
            Value<String> characterVersion = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> assetsJson = const Value.absent(),
            Value<String> characterBookJson = const Value.absent(),
            Value<String> extensionsJson = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> modifiedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CharactersCompanion(
            id: id,
            name: name,
            description: description,
            personality: personality,
            scenario: scenario,
            firstMessage: firstMessage,
            alternateGreetings: alternateGreetings,
            exampleDialogue: exampleDialogue,
            systemPrompt: systemPrompt,
            postHistoryInstructions: postHistoryInstructions,
            creatorNotes: creatorNotes,
            tags: tags,
            creator: creator,
            characterVersion: characterVersion,
            avatarPath: avatarPath,
            assetsJson: assetsJson,
            characterBookJson: characterBookJson,
            extensionsJson: extensionsJson,
            isFavorite: isFavorite,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> description = const Value.absent(),
            Value<String> personality = const Value.absent(),
            Value<String> scenario = const Value.absent(),
            Value<String> firstMessage = const Value.absent(),
            Value<String> alternateGreetings = const Value.absent(),
            Value<String> exampleDialogue = const Value.absent(),
            Value<String> systemPrompt = const Value.absent(),
            Value<String> postHistoryInstructions = const Value.absent(),
            Value<String> creatorNotes = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> creator = const Value.absent(),
            Value<String> characterVersion = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> assetsJson = const Value.absent(),
            Value<String> characterBookJson = const Value.absent(),
            Value<String> extensionsJson = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            required DateTime createdAt,
            required DateTime modifiedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CharactersCompanion.insert(
            id: id,
            name: name,
            description: description,
            personality: personality,
            scenario: scenario,
            firstMessage: firstMessage,
            alternateGreetings: alternateGreetings,
            exampleDialogue: exampleDialogue,
            systemPrompt: systemPrompt,
            postHistoryInstructions: postHistoryInstructions,
            creatorNotes: creatorNotes,
            tags: tags,
            creator: creator,
            characterVersion: characterVersion,
            avatarPath: avatarPath,
            assetsJson: assetsJson,
            characterBookJson: characterBookJson,
            extensionsJson: extensionsJson,
            isFavorite: isFavorite,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CharactersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chatsRefs = false, worldInfosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chatsRefs) db.chats,
                if (worldInfosRefs) db.worldInfos
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatsRefs)
                    await $_getPrefetchedData<Character, $CharactersTable,
                            Chat>(
                        currentTable: table,
                        referencedTable:
                            $$CharactersTableReferences._chatsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CharactersTableReferences(db, table, p0)
                                .chatsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.characterId == item.id),
                        typedResults: items),
                  if (worldInfosRefs)
                    await $_getPrefetchedData<Character, $CharactersTable,
                            WorldInfo>(
                        currentTable: table,
                        referencedTable: $$CharactersTableReferences
                            ._worldInfosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CharactersTableReferences(db, table, p0)
                                .worldInfosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.characterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CharactersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CharactersTable,
    Character,
    $$CharactersTableFilterComposer,
    $$CharactersTableOrderingComposer,
    $$CharactersTableAnnotationComposer,
    $$CharactersTableCreateCompanionBuilder,
    $$CharactersTableUpdateCompanionBuilder,
    (Character, $$CharactersTableReferences),
    Character,
    PrefetchHooks Function({bool chatsRefs, bool worldInfosRefs})>;
typedef $$ChatsTableCreateCompanionBuilder = ChatsCompanion Function({
  required String id,
  required String characterId,
  Value<String?> groupId,
  Value<String> title,
  Value<String> settingsJson,
  Value<String> authorNote,
  Value<int> authorNoteDepth,
  Value<bool> authorNoteEnabled,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<String> id,
  Value<String> characterId,
  Value<String?> groupId,
  Value<String> title,
  Value<String> settingsJson,
  Value<String> authorNote,
  Value<int> authorNoteDepth,
  Value<bool> authorNoteEnabled,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ChatsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatsTable, Chat> {
  $$ChatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
          $_aliasNameGenerator(db.chats.characterId, db.characters.id));

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager($_db, $_db.characters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.messages,
          aliasName: $_aliasNameGenerator(db.chats.id, db.messages.chatId));

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager($_db, $_db.messages)
        .filter((f) => f.chatId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BookmarksTable, List<Bookmark>>
      _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.bookmarks,
          aliasName: $_aliasNameGenerator(db.chats.id, db.bookmarks.chatId));

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager($_db, $_db.bookmarks)
        .filter((f) => f.chatId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChatsTableFilterComposer extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorNote => $composableBuilder(
      column: $table.authorNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get authorNoteDepth => $composableBuilder(
      column: $table.authorNoteDepth,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get authorNoteEnabled => $composableBuilder(
      column: $table.authorNoteEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableFilterComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> messagesRefs(
      Expression<bool> Function($$MessagesTableFilterComposer f) f) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.chatId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableFilterComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> bookmarksRefs(
      Expression<bool> Function($$BookmarksTableFilterComposer f) f) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.chatId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableFilterComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorNote => $composableBuilder(
      column: $table.authorNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get authorNoteDepth => $composableBuilder(
      column: $table.authorNoteDepth,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get authorNoteEnabled => $composableBuilder(
      column: $table.authorNoteEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableOrderingComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => column);

  GeneratedColumn<String> get authorNote => $composableBuilder(
      column: $table.authorNote, builder: (column) => column);

  GeneratedColumn<int> get authorNoteDepth => $composableBuilder(
      column: $table.authorNoteDepth, builder: (column) => column);

  GeneratedColumn<bool> get authorNoteEnabled => $composableBuilder(
      column: $table.authorNoteEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableAnnotationComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> messagesRefs<T extends Object>(
      Expression<T> Function($$MessagesTableAnnotationComposer a) f) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.chatId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> bookmarksRefs<T extends Object>(
      Expression<T> Function($$BookmarksTableAnnotationComposer a) f) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookmarks,
        getReferencedColumn: (t) => t.chatId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookmarksTableAnnotationComposer(
              $db: $db,
              $table: $db.bookmarks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableAnnotationComposer,
    $$ChatsTableCreateCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder,
    (Chat, $$ChatsTableReferences),
    Chat,
    PrefetchHooks Function(
        {bool characterId, bool messagesRefs, bool bookmarksRefs})> {
  $$ChatsTableTableManager(_$AppDatabase db, $ChatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> characterId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> settingsJson = const Value.absent(),
            Value<String> authorNote = const Value.absent(),
            Value<int> authorNoteDepth = const Value.absent(),
            Value<bool> authorNoteEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsCompanion(
            id: id,
            characterId: characterId,
            groupId: groupId,
            title: title,
            settingsJson: settingsJson,
            authorNote: authorNote,
            authorNoteDepth: authorNoteDepth,
            authorNoteEnabled: authorNoteEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String characterId,
            Value<String?> groupId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> settingsJson = const Value.absent(),
            Value<String> authorNote = const Value.absent(),
            Value<int> authorNoteDepth = const Value.absent(),
            Value<bool> authorNoteEnabled = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatsCompanion.insert(
            id: id,
            characterId: characterId,
            groupId: groupId,
            title: title,
            settingsJson: settingsJson,
            authorNote: authorNote,
            authorNoteDepth: authorNoteDepth,
            authorNoteEnabled: authorNoteEnabled,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ChatsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {characterId = false,
              messagesRefs = false,
              bookmarksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (messagesRefs) db.messages,
                if (bookmarksRefs) db.bookmarks
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (characterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.characterId,
                    referencedTable:
                        $$ChatsTableReferences._characterIdTable(db),
                    referencedColumn:
                        $$ChatsTableReferences._characterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData<Chat, $ChatsTable, Message>(
                        currentTable: table,
                        referencedTable:
                            $$ChatsTableReferences._messagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatsTableReferences(db, table, p0).messagesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.chatId == item.id),
                        typedResults: items),
                  if (bookmarksRefs)
                    await $_getPrefetchedData<Chat, $ChatsTable, Bookmark>(
                        currentTable: table,
                        referencedTable:
                            $$ChatsTableReferences._bookmarksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChatsTableReferences(db, table, p0).bookmarksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.chatId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatsTable,
    Chat,
    $$ChatsTableFilterComposer,
    $$ChatsTableOrderingComposer,
    $$ChatsTableAnnotationComposer,
    $$ChatsTableCreateCompanionBuilder,
    $$ChatsTableUpdateCompanionBuilder,
    (Chat, $$ChatsTableReferences),
    Chat,
    PrefetchHooks Function(
        {bool characterId, bool messagesRefs, bool bookmarksRefs})>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  required String chatId,
  required String role,
  required String content,
  required DateTime timestamp,
  Value<String> swipes,
  Value<int> currentSwipeIndex,
  Value<bool> isEdited,
  Value<bool> isHidden,
  Value<String> metadataJson,
  Value<String?> characterId,
  Value<String?> characterName,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> chatId,
  Value<String> role,
  Value<String> content,
  Value<DateTime> timestamp,
  Value<String> swipes,
  Value<int> currentSwipeIndex,
  Value<bool> isEdited,
  Value<bool> isHidden,
  Value<String> metadataJson,
  Value<String?> characterId,
  Value<String?> characterName,
  Value<int> rowid,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) => db.chats
      .createAlias($_aliasNameGenerator(db.messages.chatId, db.chats.id));

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<String>('chat_id')!;

    final manager = $$ChatsTableTableManager($_db, $_db.chats)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get swipes => $composableBuilder(
      column: $table.swipes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentSwipeIndex => $composableBuilder(
      column: $table.currentSwipeIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEdited => $composableBuilder(
      column: $table.isEdited, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get characterName => $composableBuilder(
      column: $table.characterName, builder: (column) => ColumnFilters(column));

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableFilterComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get swipes => $composableBuilder(
      column: $table.swipes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentSwipeIndex => $composableBuilder(
      column: $table.currentSwipeIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEdited => $composableBuilder(
      column: $table.isEdited, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHidden => $composableBuilder(
      column: $table.isHidden, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get characterName => $composableBuilder(
      column: $table.characterName,
      builder: (column) => ColumnOrderings(column));

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableOrderingComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get swipes =>
      $composableBuilder(column: $table.swipes, builder: (column) => column);

  GeneratedColumn<int> get currentSwipeIndex => $composableBuilder(
      column: $table.currentSwipeIndex, builder: (column) => column);

  GeneratedColumn<bool> get isEdited =>
      $composableBuilder(column: $table.isEdited, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  GeneratedColumn<String> get characterId => $composableBuilder(
      column: $table.characterId, builder: (column) => column);

  GeneratedColumn<String> get characterName => $composableBuilder(
      column: $table.characterName, builder: (column) => column);

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableAnnotationComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool chatId})> {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chatId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<String> swipes = const Value.absent(),
            Value<int> currentSwipeIndex = const Value.absent(),
            Value<bool> isEdited = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
            Value<String> metadataJson = const Value.absent(),
            Value<String?> characterId = const Value.absent(),
            Value<String?> characterName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            chatId: chatId,
            role: role,
            content: content,
            timestamp: timestamp,
            swipes: swipes,
            currentSwipeIndex: currentSwipeIndex,
            isEdited: isEdited,
            isHidden: isHidden,
            metadataJson: metadataJson,
            characterId: characterId,
            characterName: characterName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chatId,
            required String role,
            required String content,
            required DateTime timestamp,
            Value<String> swipes = const Value.absent(),
            Value<int> currentSwipeIndex = const Value.absent(),
            Value<bool> isEdited = const Value.absent(),
            Value<bool> isHidden = const Value.absent(),
            Value<String> metadataJson = const Value.absent(),
            Value<String?> characterId = const Value.absent(),
            Value<String?> characterName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            chatId: chatId,
            role: role,
            content: content,
            timestamp: timestamp,
            swipes: swipes,
            currentSwipeIndex: currentSwipeIndex,
            isEdited: isEdited,
            isHidden: isHidden,
            metadataJson: metadataJson,
            characterId: characterId,
            characterName: characterName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MessagesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({chatId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (chatId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.chatId,
                    referencedTable: $$MessagesTableReferences._chatIdTable(db),
                    referencedColumn:
                        $$MessagesTableReferences._chatIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool chatId})>;
typedef $$WorldInfosTableCreateCompanionBuilder = WorldInfosCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<bool> enabled,
  Value<bool> isGlobal,
  Value<String?> characterId,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<int> rowid,
});
typedef $$WorldInfosTableUpdateCompanionBuilder = WorldInfosCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<bool> enabled,
  Value<bool> isGlobal,
  Value<String?> characterId,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<int> rowid,
});

final class $$WorldInfosTableReferences
    extends BaseReferences<_$AppDatabase, $WorldInfosTable, WorldInfo> {
  $$WorldInfosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias(
          $_aliasNameGenerator(db.worldInfos.characterId, db.characters.id));

  $$CharactersTableProcessedTableManager? get characterId {
    final $_column = $_itemColumn<String>('character_id');
    if ($_column == null) return null;
    final manager = $$CharactersTableTableManager($_db, $_db.characters)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WorldInfoEntriesTable, List<WorldInfoEntry>>
      _worldInfoEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.worldInfoEntries,
              aliasName: $_aliasNameGenerator(
                  db.worldInfos.id, db.worldInfoEntries.worldInfoId));

  $$WorldInfoEntriesTableProcessedTableManager get worldInfoEntriesRefs {
    final manager = $$WorldInfoEntriesTableTableManager(
            $_db, $_db.worldInfoEntries)
        .filter((f) => f.worldInfoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_worldInfoEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorldInfosTableFilterComposer
    extends Composer<_$AppDatabase, $WorldInfosTable> {
  $$WorldInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isGlobal => $composableBuilder(
      column: $table.isGlobal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableFilterComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> worldInfoEntriesRefs(
      Expression<bool> Function($$WorldInfoEntriesTableFilterComposer f) f) {
    final $$WorldInfoEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.worldInfoEntries,
        getReferencedColumn: (t) => t.worldInfoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldInfoEntriesTableFilterComposer(
              $db: $db,
              $table: $db.worldInfoEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorldInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldInfosTable> {
  $$WorldInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isGlobal => $composableBuilder(
      column: $table.isGlobal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableOrderingComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorldInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldInfosTable> {
  $$WorldInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get isGlobal =>
      $composableBuilder(column: $table.isGlobal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.characterId,
        referencedTable: $db.characters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CharactersTableAnnotationComposer(
              $db: $db,
              $table: $db.characters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> worldInfoEntriesRefs<T extends Object>(
      Expression<T> Function($$WorldInfoEntriesTableAnnotationComposer a) f) {
    final $$WorldInfoEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.worldInfoEntries,
        getReferencedColumn: (t) => t.worldInfoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldInfoEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.worldInfoEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorldInfosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorldInfosTable,
    WorldInfo,
    $$WorldInfosTableFilterComposer,
    $$WorldInfosTableOrderingComposer,
    $$WorldInfosTableAnnotationComposer,
    $$WorldInfosTableCreateCompanionBuilder,
    $$WorldInfosTableUpdateCompanionBuilder,
    (WorldInfo, $$WorldInfosTableReferences),
    WorldInfo,
    PrefetchHooks Function({bool characterId, bool worldInfoEntriesRefs})> {
  $$WorldInfosTableTableManager(_$AppDatabase db, $WorldInfosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> isGlobal = const Value.absent(),
            Value<String?> characterId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> modifiedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorldInfosCompanion(
            id: id,
            name: name,
            description: description,
            enabled: enabled,
            isGlobal: isGlobal,
            characterId: characterId,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> isGlobal = const Value.absent(),
            Value<String?> characterId = const Value.absent(),
            required DateTime createdAt,
            required DateTime modifiedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorldInfosCompanion.insert(
            id: id,
            name: name,
            description: description,
            enabled: enabled,
            isGlobal: isGlobal,
            characterId: characterId,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorldInfosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {characterId = false, worldInfoEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (worldInfoEntriesRefs) db.worldInfoEntries
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (characterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.characterId,
                    referencedTable:
                        $$WorldInfosTableReferences._characterIdTable(db),
                    referencedColumn:
                        $$WorldInfosTableReferences._characterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (worldInfoEntriesRefs)
                    await $_getPrefetchedData<WorldInfo, $WorldInfosTable,
                            WorldInfoEntry>(
                        currentTable: table,
                        referencedTable: $$WorldInfosTableReferences
                            ._worldInfoEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorldInfosTableReferences(db, table, p0)
                                .worldInfoEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.worldInfoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorldInfosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorldInfosTable,
    WorldInfo,
    $$WorldInfosTableFilterComposer,
    $$WorldInfosTableOrderingComposer,
    $$WorldInfosTableAnnotationComposer,
    $$WorldInfosTableCreateCompanionBuilder,
    $$WorldInfosTableUpdateCompanionBuilder,
    (WorldInfo, $$WorldInfosTableReferences),
    WorldInfo,
    PrefetchHooks Function({bool characterId, bool worldInfoEntriesRefs})>;
typedef $$WorldInfoEntriesTableCreateCompanionBuilder
    = WorldInfoEntriesCompanion Function({
  required String id,
  required String worldInfoId,
  Value<String> keys,
  Value<String> secondaryKeys,
  Value<String> content,
  Value<String> comment,
  Value<bool> enabled,
  Value<bool> constant,
  Value<bool> selective,
  Value<int> insertionOrder,
  Value<bool> caseSensitive,
  Value<bool> matchWholeWords,
  Value<int> probability,
  Value<int> position,
  Value<int> depth,
  Value<String?> group,
  Value<int> groupWeight,
  Value<bool> preventRecursion,
  Value<int> scanDepth,
  Value<String> extensionsJson,
  Value<int> rowid,
});
typedef $$WorldInfoEntriesTableUpdateCompanionBuilder
    = WorldInfoEntriesCompanion Function({
  Value<String> id,
  Value<String> worldInfoId,
  Value<String> keys,
  Value<String> secondaryKeys,
  Value<String> content,
  Value<String> comment,
  Value<bool> enabled,
  Value<bool> constant,
  Value<bool> selective,
  Value<int> insertionOrder,
  Value<bool> caseSensitive,
  Value<bool> matchWholeWords,
  Value<int> probability,
  Value<int> position,
  Value<int> depth,
  Value<String?> group,
  Value<int> groupWeight,
  Value<bool> preventRecursion,
  Value<int> scanDepth,
  Value<String> extensionsJson,
  Value<int> rowid,
});

final class $$WorldInfoEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $WorldInfoEntriesTable, WorldInfoEntry> {
  $$WorldInfoEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorldInfosTable _worldInfoIdTable(_$AppDatabase db) =>
      db.worldInfos.createAlias($_aliasNameGenerator(
          db.worldInfoEntries.worldInfoId, db.worldInfos.id));

  $$WorldInfosTableProcessedTableManager get worldInfoId {
    final $_column = $_itemColumn<String>('world_info_id')!;

    final manager = $$WorldInfosTableTableManager($_db, $_db.worldInfos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldInfoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorldInfoEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WorldInfoEntriesTable> {
  $$WorldInfoEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keys => $composableBuilder(
      column: $table.keys, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secondaryKeys => $composableBuilder(
      column: $table.secondaryKeys, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get constant => $composableBuilder(
      column: $table.constant, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get selective => $composableBuilder(
      column: $table.selective, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get insertionOrder => $composableBuilder(
      column: $table.insertionOrder,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get caseSensitive => $composableBuilder(
      column: $table.caseSensitive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get matchWholeWords => $composableBuilder(
      column: $table.matchWholeWords,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get probability => $composableBuilder(
      column: $table.probability, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get depth => $composableBuilder(
      column: $table.depth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get group => $composableBuilder(
      column: $table.group, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupWeight => $composableBuilder(
      column: $table.groupWeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get preventRecursion => $composableBuilder(
      column: $table.preventRecursion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scanDepth => $composableBuilder(
      column: $table.scanDepth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extensionsJson => $composableBuilder(
      column: $table.extensionsJson,
      builder: (column) => ColumnFilters(column));

  $$WorldInfosTableFilterComposer get worldInfoId {
    final $$WorldInfosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.worldInfoId,
        referencedTable: $db.worldInfos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldInfosTableFilterComposer(
              $db: $db,
              $table: $db.worldInfos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorldInfoEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldInfoEntriesTable> {
  $$WorldInfoEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keys => $composableBuilder(
      column: $table.keys, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondaryKeys => $composableBuilder(
      column: $table.secondaryKeys,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get constant => $composableBuilder(
      column: $table.constant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get selective => $composableBuilder(
      column: $table.selective, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get insertionOrder => $composableBuilder(
      column: $table.insertionOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get caseSensitive => $composableBuilder(
      column: $table.caseSensitive,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get matchWholeWords => $composableBuilder(
      column: $table.matchWholeWords,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get probability => $composableBuilder(
      column: $table.probability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get depth => $composableBuilder(
      column: $table.depth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get group => $composableBuilder(
      column: $table.group, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupWeight => $composableBuilder(
      column: $table.groupWeight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get preventRecursion => $composableBuilder(
      column: $table.preventRecursion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scanDepth => $composableBuilder(
      column: $table.scanDepth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extensionsJson => $composableBuilder(
      column: $table.extensionsJson,
      builder: (column) => ColumnOrderings(column));

  $$WorldInfosTableOrderingComposer get worldInfoId {
    final $$WorldInfosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.worldInfoId,
        referencedTable: $db.worldInfos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldInfosTableOrderingComposer(
              $db: $db,
              $table: $db.worldInfos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorldInfoEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldInfoEntriesTable> {
  $$WorldInfoEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get keys =>
      $composableBuilder(column: $table.keys, builder: (column) => column);

  GeneratedColumn<String> get secondaryKeys => $composableBuilder(
      column: $table.secondaryKeys, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get constant =>
      $composableBuilder(column: $table.constant, builder: (column) => column);

  GeneratedColumn<bool> get selective =>
      $composableBuilder(column: $table.selective, builder: (column) => column);

  GeneratedColumn<int> get insertionOrder => $composableBuilder(
      column: $table.insertionOrder, builder: (column) => column);

  GeneratedColumn<bool> get caseSensitive => $composableBuilder(
      column: $table.caseSensitive, builder: (column) => column);

  GeneratedColumn<bool> get matchWholeWords => $composableBuilder(
      column: $table.matchWholeWords, builder: (column) => column);

  GeneratedColumn<int> get probability => $composableBuilder(
      column: $table.probability, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get depth =>
      $composableBuilder(column: $table.depth, builder: (column) => column);

  GeneratedColumn<String> get group =>
      $composableBuilder(column: $table.group, builder: (column) => column);

  GeneratedColumn<int> get groupWeight => $composableBuilder(
      column: $table.groupWeight, builder: (column) => column);

  GeneratedColumn<bool> get preventRecursion => $composableBuilder(
      column: $table.preventRecursion, builder: (column) => column);

  GeneratedColumn<int> get scanDepth =>
      $composableBuilder(column: $table.scanDepth, builder: (column) => column);

  GeneratedColumn<String> get extensionsJson => $composableBuilder(
      column: $table.extensionsJson, builder: (column) => column);

  $$WorldInfosTableAnnotationComposer get worldInfoId {
    final $$WorldInfosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.worldInfoId,
        referencedTable: $db.worldInfos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldInfosTableAnnotationComposer(
              $db: $db,
              $table: $db.worldInfos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorldInfoEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorldInfoEntriesTable,
    WorldInfoEntry,
    $$WorldInfoEntriesTableFilterComposer,
    $$WorldInfoEntriesTableOrderingComposer,
    $$WorldInfoEntriesTableAnnotationComposer,
    $$WorldInfoEntriesTableCreateCompanionBuilder,
    $$WorldInfoEntriesTableUpdateCompanionBuilder,
    (WorldInfoEntry, $$WorldInfoEntriesTableReferences),
    WorldInfoEntry,
    PrefetchHooks Function({bool worldInfoId})> {
  $$WorldInfoEntriesTableTableManager(
      _$AppDatabase db, $WorldInfoEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldInfoEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldInfoEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldInfoEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> worldInfoId = const Value.absent(),
            Value<String> keys = const Value.absent(),
            Value<String> secondaryKeys = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> constant = const Value.absent(),
            Value<bool> selective = const Value.absent(),
            Value<int> insertionOrder = const Value.absent(),
            Value<bool> caseSensitive = const Value.absent(),
            Value<bool> matchWholeWords = const Value.absent(),
            Value<int> probability = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> depth = const Value.absent(),
            Value<String?> group = const Value.absent(),
            Value<int> groupWeight = const Value.absent(),
            Value<bool> preventRecursion = const Value.absent(),
            Value<int> scanDepth = const Value.absent(),
            Value<String> extensionsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorldInfoEntriesCompanion(
            id: id,
            worldInfoId: worldInfoId,
            keys: keys,
            secondaryKeys: secondaryKeys,
            content: content,
            comment: comment,
            enabled: enabled,
            constant: constant,
            selective: selective,
            insertionOrder: insertionOrder,
            caseSensitive: caseSensitive,
            matchWholeWords: matchWholeWords,
            probability: probability,
            position: position,
            depth: depth,
            group: group,
            groupWeight: groupWeight,
            preventRecursion: preventRecursion,
            scanDepth: scanDepth,
            extensionsJson: extensionsJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String worldInfoId,
            Value<String> keys = const Value.absent(),
            Value<String> secondaryKeys = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> constant = const Value.absent(),
            Value<bool> selective = const Value.absent(),
            Value<int> insertionOrder = const Value.absent(),
            Value<bool> caseSensitive = const Value.absent(),
            Value<bool> matchWholeWords = const Value.absent(),
            Value<int> probability = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<int> depth = const Value.absent(),
            Value<String?> group = const Value.absent(),
            Value<int> groupWeight = const Value.absent(),
            Value<bool> preventRecursion = const Value.absent(),
            Value<int> scanDepth = const Value.absent(),
            Value<String> extensionsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorldInfoEntriesCompanion.insert(
            id: id,
            worldInfoId: worldInfoId,
            keys: keys,
            secondaryKeys: secondaryKeys,
            content: content,
            comment: comment,
            enabled: enabled,
            constant: constant,
            selective: selective,
            insertionOrder: insertionOrder,
            caseSensitive: caseSensitive,
            matchWholeWords: matchWholeWords,
            probability: probability,
            position: position,
            depth: depth,
            group: group,
            groupWeight: groupWeight,
            preventRecursion: preventRecursion,
            scanDepth: scanDepth,
            extensionsJson: extensionsJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorldInfoEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({worldInfoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (worldInfoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.worldInfoId,
                    referencedTable:
                        $$WorldInfoEntriesTableReferences._worldInfoIdTable(db),
                    referencedColumn: $$WorldInfoEntriesTableReferences
                        ._worldInfoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorldInfoEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorldInfoEntriesTable,
    WorldInfoEntry,
    $$WorldInfoEntriesTableFilterComposer,
    $$WorldInfoEntriesTableOrderingComposer,
    $$WorldInfoEntriesTableAnnotationComposer,
    $$WorldInfoEntriesTableCreateCompanionBuilder,
    $$WorldInfoEntriesTableUpdateCompanionBuilder,
    (WorldInfoEntry, $$WorldInfoEntriesTableReferences),
    WorldInfoEntry,
    PrefetchHooks Function({bool worldInfoId})>;
typedef $$LlmConfigsTableCreateCompanionBuilder = LlmConfigsCompanion Function({
  required String id,
  required String name,
  required String provider,
  required String endpoint,
  Value<String?> apiKey,
  Value<String?> model,
  Value<bool> enabled,
  Value<bool> isDefault,
  Value<String> defaultSettingsJson,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<int> rowid,
});
typedef $$LlmConfigsTableUpdateCompanionBuilder = LlmConfigsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> provider,
  Value<String> endpoint,
  Value<String?> apiKey,
  Value<String?> model,
  Value<bool> enabled,
  Value<bool> isDefault,
  Value<String> defaultSettingsJson,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<int> rowid,
});

class $$LlmConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $LlmConfigsTable> {
  $$LlmConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultSettingsJson => $composableBuilder(
      column: $table.defaultSettingsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));
}

class $$LlmConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $LlmConfigsTable> {
  $$LlmConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiKey => $composableBuilder(
      column: $table.apiKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultSettingsJson => $composableBuilder(
      column: $table.defaultSettingsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));
}

class $$LlmConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LlmConfigsTable> {
  $$LlmConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get apiKey =>
      $composableBuilder(column: $table.apiKey, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<String> get defaultSettingsJson => $composableBuilder(
      column: $table.defaultSettingsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);
}

class $$LlmConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LlmConfigsTable,
    LlmConfig,
    $$LlmConfigsTableFilterComposer,
    $$LlmConfigsTableOrderingComposer,
    $$LlmConfigsTableAnnotationComposer,
    $$LlmConfigsTableCreateCompanionBuilder,
    $$LlmConfigsTableUpdateCompanionBuilder,
    (LlmConfig, BaseReferences<_$AppDatabase, $LlmConfigsTable, LlmConfig>),
    LlmConfig,
    PrefetchHooks Function()> {
  $$LlmConfigsTableTableManager(_$AppDatabase db, $LlmConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LlmConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LlmConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LlmConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String> endpoint = const Value.absent(),
            Value<String?> apiKey = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<String> defaultSettingsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> modifiedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LlmConfigsCompanion(
            id: id,
            name: name,
            provider: provider,
            endpoint: endpoint,
            apiKey: apiKey,
            model: model,
            enabled: enabled,
            isDefault: isDefault,
            defaultSettingsJson: defaultSettingsJson,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String provider,
            required String endpoint,
            Value<String?> apiKey = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<String> defaultSettingsJson = const Value.absent(),
            required DateTime createdAt,
            required DateTime modifiedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LlmConfigsCompanion.insert(
            id: id,
            name: name,
            provider: provider,
            endpoint: endpoint,
            apiKey: apiKey,
            model: model,
            enabled: enabled,
            isDefault: isDefault,
            defaultSettingsJson: defaultSettingsJson,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LlmConfigsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LlmConfigsTable,
    LlmConfig,
    $$LlmConfigsTableFilterComposer,
    $$LlmConfigsTableOrderingComposer,
    $$LlmConfigsTableAnnotationComposer,
    $$LlmConfigsTableCreateCompanionBuilder,
    $$LlmConfigsTableUpdateCompanionBuilder,
    (LlmConfig, BaseReferences<_$AppDatabase, $LlmConfigsTable, LlmConfig>),
    LlmConfig,
    PrefetchHooks Function()>;
typedef $$PersonasTableCreateCompanionBuilder = PersonasCompanion Function({
  required String id,
  required String name,
  Value<String> description,
  Value<String?> avatarPath,
  Value<bool> isDefault,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PersonasTableUpdateCompanionBuilder = PersonasCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String?> avatarPath,
  Value<bool> isDefault,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PersonasTableFilterComposer
    extends Composer<_$AppDatabase, $PersonasTable> {
  $$PersonasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PersonasTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonasTable> {
  $$PersonasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonasTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonasTable> {
  $$PersonasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PersonasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonasTable,
    Persona,
    $$PersonasTableFilterComposer,
    $$PersonasTableOrderingComposer,
    $$PersonasTableAnnotationComposer,
    $$PersonasTableCreateCompanionBuilder,
    $$PersonasTableUpdateCompanionBuilder,
    (Persona, BaseReferences<_$AppDatabase, $PersonasTable, Persona>),
    Persona,
    PrefetchHooks Function()> {
  $$PersonasTableTableManager(_$AppDatabase db, $PersonasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonasCompanion(
            id: id,
            name: name,
            description: description,
            avatarPath: avatarPath,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> description = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonasCompanion.insert(
            id: id,
            name: name,
            description: description,
            avatarPath: avatarPath,
            isDefault: isDefault,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PersonasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonasTable,
    Persona,
    $$PersonasTableFilterComposer,
    $$PersonasTableOrderingComposer,
    $$PersonasTableAnnotationComposer,
    $$PersonasTableCreateCompanionBuilder,
    $$PersonasTableUpdateCompanionBuilder,
    (Persona, BaseReferences<_$AppDatabase, $PersonasTable, Persona>),
    Persona,
    PrefetchHooks Function()>;
typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String> membersJson,
  Value<String> settingsJson,
  Value<String?> avatarPath,
  required DateTime createdAt,
  required DateTime modifiedAt,
  Value<int> rowid,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> membersJson,
  Value<String> settingsJson,
  Value<String?> avatarPath,
  Value<DateTime> createdAt,
  Value<DateTime> modifiedAt,
  Value<int> rowid,
});

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get membersJson => $composableBuilder(
      column: $table.membersJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get membersJson => $composableBuilder(
      column: $table.membersJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get membersJson => $composableBuilder(
      column: $table.membersJson, builder: (column) => column);

  GeneratedColumn<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);
}

class $$GroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, BaseReferences<_$AppDatabase, $GroupsTable, Group>),
    Group,
    PrefetchHooks Function()> {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> membersJson = const Value.absent(),
            Value<String> settingsJson = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> modifiedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupsCompanion(
            id: id,
            name: name,
            description: description,
            membersJson: membersJson,
            settingsJson: settingsJson,
            avatarPath: avatarPath,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String> membersJson = const Value.absent(),
            Value<String> settingsJson = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            required DateTime createdAt,
            required DateTime modifiedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupsCompanion.insert(
            id: id,
            name: name,
            description: description,
            membersJson: membersJson,
            settingsJson: settingsJson,
            avatarPath: avatarPath,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GroupsTable,
    Group,
    $$GroupsTableFilterComposer,
    $$GroupsTableOrderingComposer,
    $$GroupsTableAnnotationComposer,
    $$GroupsTableCreateCompanionBuilder,
    $$GroupsTableUpdateCompanionBuilder,
    (Group, BaseReferences<_$AppDatabase, $GroupsTable, Group>),
    Group,
    PrefetchHooks Function()>;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  required String id,
  required String chatId,
  required String name,
  Value<String?> description,
  required String messageId,
  required int messageIndex,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<String> id,
  Value<String> chatId,
  Value<String> name,
  Value<String?> description,
  Value<String> messageId,
  Value<int> messageIndex,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) => db.chats
      .createAlias($_aliasNameGenerator(db.bookmarks.chatId, db.chats.id));

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<String>('chat_id')!;

    final manager = $$ChatsTableTableManager($_db, $_db.chats)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get messageIndex => $composableBuilder(
      column: $table.messageIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableFilterComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get messageIndex => $composableBuilder(
      column: $table.messageIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableOrderingComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<int> get messageIndex => $composableBuilder(
      column: $table.messageIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chatId,
        referencedTable: $db.chats,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChatsTableAnnotationComposer(
              $db: $db,
              $table: $db.chats,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, $$BookmarksTableReferences),
    Bookmark,
    PrefetchHooks Function({bool chatId})> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chatId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<int> messageIndex = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion(
            id: id,
            chatId: chatId,
            name: name,
            description: description,
            messageId: messageId,
            messageIndex: messageIndex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chatId,
            required String name,
            Value<String?> description = const Value.absent(),
            required String messageId,
            required int messageIndex,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            id: id,
            chatId: chatId,
            name: name,
            description: description,
            messageId: messageId,
            messageIndex: messageIndex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BookmarksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chatId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (chatId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.chatId,
                    referencedTable:
                        $$BookmarksTableReferences._chatIdTable(db),
                    referencedColumn:
                        $$BookmarksTableReferences._chatIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableAnnotationComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder,
    (Bookmark, $$BookmarksTableReferences),
    Bookmark,
    PrefetchHooks Function({bool chatId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$WorldInfosTableTableManager get worldInfos =>
      $$WorldInfosTableTableManager(_db, _db.worldInfos);
  $$WorldInfoEntriesTableTableManager get worldInfoEntries =>
      $$WorldInfoEntriesTableTableManager(_db, _db.worldInfoEntries);
  $$LlmConfigsTableTableManager get llmConfigs =>
      $$LlmConfigsTableTableManager(_db, _db.llmConfigs);
  $$PersonasTableTableManager get personas =>
      $$PersonasTableTableManager(_db, _db.personas);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}
