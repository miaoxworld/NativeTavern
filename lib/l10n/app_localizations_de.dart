// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Startseite';

  @override
  String get characters => 'Charaktere';

  @override
  String get settings => 'Einstellungen';

  @override
  String get chats => 'Chats';

  @override
  String get newChat => 'Neuer Chat';

  @override
  String get noChatsYet => 'Noch keine Chats';

  @override
  String get startNewConversation =>
      'Starte eine Unterhaltung mit einem Charakter';

  @override
  String get browseCharacters => 'Charaktere durchsuchen';

  @override
  String get groupChats => 'Gruppenchats';

  @override
  String get import => 'Importieren';

  @override
  String get delete => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get copy => 'Kopieren';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get close => 'Schließen';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String errorLoadingChats(String error) {
    return 'Fehler beim Laden der Chats: $error';
  }

  @override
  String get deleteChat => 'Chat löschen';

  @override
  String get deleteChatConfirmation =>
      'Möchtest du diesen Chat wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get chatDeleted => 'Chat gelöscht';

  @override
  String get yesterday => 'Gestern';

  @override
  String daysAgo(int count) {
    return 'Vor $count Tagen';
  }

  @override
  String get noMessages => 'Keine Nachrichten';

  @override
  String get noMessagesYet => 'Noch keine Nachrichten';

  @override
  String get chat => 'Chat';

  @override
  String get typeMessage => 'Nachricht eingeben...';

  @override
  String get send => 'Senden';

  @override
  String get regenerate => 'Neu generieren';

  @override
  String get continueGeneration => 'Fortsetzen';

  @override
  String get viewCharacter => 'Charakter anzeigen';

  @override
  String get authorsNote => 'Autorennotiz';

  @override
  String get bookmarks => 'Lesezeichen';

  @override
  String get exportChat => 'Chat exportieren';

  @override
  String get importChat => 'Chat importieren';

  @override
  String get clearMessages => 'Nachrichten löschen';

  @override
  String get selectModel => 'Modell auswählen';

  @override
  String get loadingModels => 'Modelle werden geladen...';

  @override
  String get noModelsAvailable =>
      'Keine Modelle verfügbar. Überprüfe die API-Konfiguration.';

  @override
  String modelChangedTo(String model) {
    return 'Modell geändert zu $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Fehler beim Laden der Modelle: $error';
  }

  @override
  String get searchModels => 'Modelle suchen...';

  @override
  String get noModelsMatchSearch => 'Keine passenden Modelle gefunden';

  @override
  String get provider => 'Anbieter';

  @override
  String get apiNotConfigured => 'API nicht konfiguriert';

  @override
  String get apiNotConfiguredMessage =>
      'Um mit Charakteren zu chatten, musst du zuerst einen LLM-Anbieter konfigurieren.';

  @override
  String get supportedProviders => 'Unterstützte Anbieter:';

  @override
  String get configureNow => 'Jetzt konfigurieren';

  @override
  String get later => 'Später';

  @override
  String get configure => 'Konfigurieren';

  @override
  String get configureApiProvider =>
      'Konfiguriere einen LLM-Anbieter, um zu chatten';

  @override
  String get startConversation => 'Unterhaltung starten';

  @override
  String get deleteMessage => 'Nachricht löschen';

  @override
  String get deleteMessageConfirmation =>
      'Möchtest du diese Nachricht wirklich löschen?';

  @override
  String get deleteMessages => 'Nachrichten löschen';

  @override
  String get deleteMessagesConfirmation =>
      'Möchtest du diese Nachricht und alle folgenden wirklich löschen?';

  @override
  String get deleteAll => 'Alle löschen';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get generateNewResponse => 'Neue Antwort generieren';

  @override
  String get continueFromHere => 'Von hier fortsetzen';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Folgende Nachrichten löschen und Antwort neu generieren';

  @override
  String get deleteMessagesAfterThis => 'Alle Nachrichten nach dieser löschen';

  @override
  String get createBookmark => 'Lesezeichen erstellen';

  @override
  String get saveAsCheckpoint => 'Diesen Punkt als Checkpoint speichern';

  @override
  String get deleteThisMessage => 'Diese Nachricht löschen';

  @override
  String get deleteThisAndAllAfter => 'Diese und alle folgenden löschen';

  @override
  String get attachImage => 'Bild anhängen';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String failedToPickImage(String error) {
    return 'Fehler beim Auswählen des Bildes: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Fehler beim Aufnehmen des Fotos: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Fehler beim Hinzufügen des Anhangs: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Chat mit $character exportieren';
  }

  @override
  String messagesCount(int count) {
    return '$count Nachrichten';
  }

  @override
  String get chooseExportFormat => 'Exportformat wählen:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST-Format)';

  @override
  String get noChatToExport => 'Kein Chat zum Exportieren';

  @override
  String exportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get importChatHistory => 'Chatverlauf aus Datei importieren.';

  @override
  String get supportedFormats => 'Unterstützte Formate:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern-Format)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern-Format)';

  @override
  String get importNote =>
      'Hinweis: Importierte Nachrichten werden zum aktuellen Chat hinzugefügt.';

  @override
  String get chooseFile => 'Datei wählen';

  @override
  String get noFileSelected => 'Keine Datei ausgewählt oder ungültiges Format';

  @override
  String get importConfirmation => 'Import bestätigen';

  @override
  String get character => 'Charakter';

  @override
  String get user => 'Benutzer';

  @override
  String get messages => 'Nachrichten';

  @override
  String get date => 'Datum';

  @override
  String get hasAuthorsNote => 'Hat Autorennotiz';

  @override
  String get importMessagesToCurrentChat =>
      'Diese Nachrichten in den aktuellen Chat importieren?';

  @override
  String get noActiveChat => 'Kein aktiver Chat';

  @override
  String importedMessages(int count) {
    return '$count Nachrichten importiert';
  }

  @override
  String importFailed(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Möchtest du wirklich alle Nachrichten löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get clear => 'Löschen';

  @override
  String get thinking => 'Denkt nach';

  @override
  String get noSwipesAvailable => 'Keine Swipes verfügbar';

  @override
  String get system => 'System';

  @override
  String get backgroundFeatureComingSoon => 'Hintergrund-Funktion kommt bald';

  @override
  String get authorsNoteUpdated => 'Autorennotiz aktualisiert';

  @override
  String get commandError => 'Befehlsfehler';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get personas => 'Personas';

  @override
  String get createPersona => 'Persona erstellen';

  @override
  String get editPersona => 'Persona bearbeiten';

  @override
  String get deletePersona => 'Persona löschen';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Möchtest du \"$name\" wirklich löschen?';
  }

  @override
  String get noPersonasYet => 'Noch keine Personas';

  @override
  String get createPersonaDescription =>
      'Erstelle eine Persona, um dich in Chats zu repräsentieren';

  @override
  String get name => 'Name';

  @override
  String get enterPersonaName => 'Persona-Name eingeben';

  @override
  String get description => 'Beschreibung';

  @override
  String get describePersona => 'Diese Persona beschreiben (optional)';

  @override
  String get personaDescriptionHelp =>
      'Die Beschreibung wird in den System-Prompt aufgenommen, um der KI zu helfen, zu verstehen, wer du bist.';

  @override
  String get pleaseEnterName => 'Bitte gib einen Namen ein';

  @override
  String get default_ => 'Standard';

  @override
  String get active => 'Aktiv';

  @override
  String get setAsDefault => 'Als Standard festlegen';

  @override
  String get removeAvatar => 'Avatar entfernen';

  @override
  String failedToSaveAvatar(String error) {
    return 'Fehler beim Speichern des Avatars: $error';
  }

  @override
  String get selectAvatarImage => 'Avatar-Bild auswählen';

  @override
  String get aiConfiguration => 'KI-Konfiguration';

  @override
  String get llmProvider => 'LLM-Anbieter';

  @override
  String get apiUrl => 'API-URL';

  @override
  String get apiKey => 'API-Schlüssel';

  @override
  String get model => 'Modell';

  @override
  String get temperature => 'Temperatur';

  @override
  String get maxTokens => 'Max. Tokens';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Frequenzstrafe';

  @override
  String get presencePenalty => 'Präsenzstrafe';

  @override
  String get repetitionPenalty => 'Wiederholungsstrafe';

  @override
  String get streamingEnabled => 'Streaming aktiviert';

  @override
  String get testConnection => 'Verbindung testen';

  @override
  String get connectionSuccessful => 'Verbindung erfolgreich!';

  @override
  String connectionFailed(String error) {
    return 'Verbindung fehlgeschlagen: $error';
  }

  @override
  String get openai => 'OpenAI';

  @override
  String get claude => 'Claude';

  @override
  String get openRouter => 'OpenRouter';

  @override
  String get gemini => 'Gemini';

  @override
  String get ollama => 'Ollama';

  @override
  String get koboldCpp => 'KoboldCpp';

  @override
  String get local => 'Lokal';

  @override
  String get aiPresets => 'KI-Voreinstellungen';

  @override
  String get createPreset => 'Voreinstellung erstellen';

  @override
  String get editPreset => 'Voreinstellung bearbeiten';

  @override
  String get deletePreset => 'Voreinstellung löschen';

  @override
  String get presetName => 'Voreinstellungsname';

  @override
  String get promptManager => 'Prompt-Manager';

  @override
  String get systemPrompt => 'System-Prompt';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Welt-Info';

  @override
  String get createEntry => 'Eintrag erstellen';

  @override
  String get editEntry => 'Eintrag bearbeiten';

  @override
  String get deleteEntry => 'Eintrag löschen';

  @override
  String get keywords => 'Schlüsselwörter';

  @override
  String get content => 'Inhalt';

  @override
  String get priority => 'Priorität';

  @override
  String get groups => 'Gruppen';

  @override
  String get createGroup => 'Gruppe erstellen';

  @override
  String get editGroup => 'Gruppe bearbeiten';

  @override
  String get deleteGroup => 'Gruppe löschen';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get members => 'Mitglieder';

  @override
  String get addMember => 'Mitglied hinzufügen';

  @override
  String get removeMember => 'Mitglied entfernen';

  @override
  String get tags => 'Tags';

  @override
  String get createTag => 'Tag erstellen';

  @override
  String get editTag => 'Tag bearbeiten';

  @override
  String get deleteTag => 'Tag löschen';

  @override
  String get tagName => 'Tag-Name';

  @override
  String get color => 'Farbe';

  @override
  String get quickReplies => 'Schnellantworten';

  @override
  String get createQuickReply => 'Schnellantwort erstellen';

  @override
  String get editQuickReply => 'Schnellantwort bearbeiten';

  @override
  String get deleteQuickReply => 'Schnellantwort löschen';

  @override
  String get label => 'Bezeichnung';

  @override
  String get message => 'Nachricht';

  @override
  String get autoSend => 'Automatisch senden';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Regex erstellen';

  @override
  String get editRegex => 'Regex bearbeiten';

  @override
  String get deleteRegex => 'Regex löschen';

  @override
  String get pattern => 'Muster';

  @override
  String get replacement => 'Ersetzung';

  @override
  String get backup => 'Backup';

  @override
  String get createBackup => 'Backup erstellen';

  @override
  String get restoreBackup => 'Backup wiederherstellen';

  @override
  String get backupCreated => 'Backup erfolgreich erstellt';

  @override
  String get backupRestored => 'Backup erfolgreich wiederhergestellt';

  @override
  String backupFailed(String error) {
    return 'Backup fehlgeschlagen: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String get theme => 'Design';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get lightMode => 'Hellmodus';

  @override
  String get systemTheme => 'System folgen';

  @override
  String get primaryColor => 'Primärfarbe';

  @override
  String get accentColor => 'Akzentfarbe';

  @override
  String get advanced => 'Erweitert';

  @override
  String get advancedSettings => 'Erweiterte Einstellungen';

  @override
  String get statistics => 'Statistiken';

  @override
  String get totalChats => 'Chats gesamt';

  @override
  String get totalMessages => 'Nachrichten gesamt';

  @override
  String get totalCharacters => 'Charaktere gesamt';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Text-zu-Sprache';

  @override
  String get stt => 'Sprache-zu-Text';

  @override
  String get translation => 'Übersetzung';

  @override
  String get imageGeneration => 'Bildgenerierung';

  @override
  String get vectorStorage => 'Vektorspeicher';

  @override
  String get sprites => 'Sprites';

  @override
  String get backgrounds => 'Hintergründe';

  @override
  String get cfgScale => 'CFG-Skala';

  @override
  String get logitBias => 'Logit-Bias';

  @override
  String get variables => 'Variablen';

  @override
  String get listView => 'Listenansicht';

  @override
  String get gridView => 'Rasteransicht';

  @override
  String get search => 'Suchen';

  @override
  String get searchCharacters => 'Charaktere suchen...';

  @override
  String get noCharactersFound => 'Keine Charaktere gefunden';

  @override
  String get noCharactersYet => 'Noch keine Charaktere';

  @override
  String get importCharacter => 'Importiere einen Charakter, um zu beginnen';

  @override
  String get createCharacter => 'Charakter erstellen';

  @override
  String get editCharacter => 'Charakter bearbeiten';

  @override
  String get deleteCharacter => 'Charakter löschen';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Möchtest du \"$name\" wirklich löschen? Alle Chats mit diesem Charakter werden ebenfalls gelöscht.';
  }

  @override
  String get characterDeleted => 'Charakter gelöscht';

  @override
  String get startChat => 'Chat starten';

  @override
  String get personality => 'Persönlichkeit';

  @override
  String get scenario => 'Szenario';

  @override
  String get firstMessage => 'Erste Nachricht';

  @override
  String get exampleDialogue => 'Beispieldialog';

  @override
  String get creatorNotes => 'Ersteller-Notizen';

  @override
  String get alternateGreetings => 'Alternative Begrüßungen';

  @override
  String get characterBook => 'Charakterbuch';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get languageChanged => 'Sprache geändert';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get shareApp => 'App teilen';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get noUpdatesAvailable => 'Keine Updates verfügbar';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get downloadUpdate => 'Update herunterladen';

  @override
  String get bookmarkCreated => 'Lesezeichen erstellt';

  @override
  String get bookmarkName => 'Lesezeichen-Name';

  @override
  String get enterBookmarkName => 'Lesezeichen-Name eingeben';

  @override
  String get noBookmarksYet => 'Noch keine Lesezeichen';

  @override
  String get createBookmarkDescription =>
      'Erstelle Lesezeichen, um wichtige Punkte in deiner Unterhaltung zu speichern';

  @override
  String get jumpToBookmark => 'Zum Lesezeichen springen';

  @override
  String get deleteBookmark => 'Lesezeichen löschen';

  @override
  String get bookmarkDeleted => 'Lesezeichen gelöscht';

  @override
  String get saveAsJsonl => 'Als JSONL speichern';

  @override
  String get saveAsJson => 'Als JSON speichern';

  @override
  String get keyboardShortcuts => 'Tastaturkürzel:';

  @override
  String get bold => 'Fett';

  @override
  String get italic => 'Kursiv';

  @override
  String get underline => 'Unterstrichen';

  @override
  String get strikethrough => 'Durchgestrichen';

  @override
  String get inlineCode => 'Inline-Code';

  @override
  String get link => 'Link';

  @override
  String get slashCommands => 'Slash-Befehle';

  @override
  String get availableCommands => 'Verfügbare Befehle:';

  @override
  String get commandHelp => 'Tippe / um verfügbare Befehle zu sehen';
}
