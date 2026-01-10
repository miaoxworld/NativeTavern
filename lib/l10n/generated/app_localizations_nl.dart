// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Home';

  @override
  String get characters => 'Personages';

  @override
  String get settings => 'Instellingen';

  @override
  String get chats => 'Chats';

  @override
  String get newChat => 'Nieuwe Chat';

  @override
  String get noChatsYet => 'Nog geen chats';

  @override
  String get startNewConversation => 'Start een gesprek met een personage';

  @override
  String get browseCharacters => 'Blader door Personages';

  @override
  String get groupChats => 'Groepschats';

  @override
  String get import => 'Importeren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String get edit => 'Bewerken';

  @override
  String get copy => 'Kopiëren';

  @override
  String get retry => 'Opnieuw';

  @override
  String get close => 'Sluiten';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fout';

  @override
  String errorLoadingChats(String error) {
    return 'Fout bij laden van chats: $error';
  }

  @override
  String get deleteChat => 'Chat Verwijderen';

  @override
  String get deleteChatConfirmation =>
      'Weet je zeker dat je deze chat wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get chatDeleted => 'Chat verwijderd';

  @override
  String get yesterday => 'Gisteren';

  @override
  String daysAgo(int count) {
    return '$count dagen geleden';
  }

  @override
  String get noMessages => 'Geen berichten';

  @override
  String get noMessagesYet => 'Nog geen berichten';

  @override
  String get chat => 'Chat';

  @override
  String get typeMessage => 'Typ een bericht...';

  @override
  String get send => 'Verzenden';

  @override
  String get regenerate => 'Regenereren';

  @override
  String get continueGeneration => 'Doorgaan';

  @override
  String get viewCharacter => 'Bekijk Personage';

  @override
  String get authorsNote => 'Auteursnotitie';

  @override
  String get bookmarks => 'Bladwijzers';

  @override
  String get exportChat => 'Chat Exporteren';

  @override
  String get importChat => 'Chat Importeren';

  @override
  String get clearMessages => 'Berichten Wissen';

  @override
  String get selectModel => 'Selecteer Model';

  @override
  String get loadingModels => 'Modellen laden...';

  @override
  String get noModelsAvailable =>
      'Geen modellen beschikbaar. Controleer je API-instellingen.';

  @override
  String modelChangedTo(String model) {
    return 'Model gewijzigd naar $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Kon modellen niet laden: $error';
  }

  @override
  String get searchModels => 'Zoek modellen...';

  @override
  String get noModelsMatchSearch => 'Geen overeenkomende modellen';

  @override
  String get provider => 'Provider';

  @override
  String get apiNotConfigured => 'API Niet Geconfigureerd';

  @override
  String get apiNotConfiguredMessage =>
      'Om met personages te chatten, moet je eerst een LLM-provider configureren.';

  @override
  String get supportedProviders => 'Ondersteunde providers:';

  @override
  String get configureNow => 'Nu Configureren';

  @override
  String get later => 'Later';

  @override
  String get configure => 'Configureren';

  @override
  String get configureApiProvider =>
      'Configureer LLM-provider om te beginnen met chatten';

  @override
  String get startConversation => 'Start Gesprek';

  @override
  String get deleteMessage => 'Bericht Verwijderen';

  @override
  String get deleteMessageConfirmation =>
      'Weet je zeker dat je dit bericht wilt verwijderen?';

  @override
  String get deleteMessages => 'Berichten Verwijderen';

  @override
  String get deleteMessagesConfirmation =>
      'Weet je zeker dat je dit bericht en alle volgende berichten wilt verwijderen?';

  @override
  String get deleteAll => 'Alles Verwijderen';

  @override
  String get copiedToClipboard => 'Gekopieerd naar klembord';

  @override
  String get generateNewResponse => 'Genereer nieuw antwoord';

  @override
  String get continueFromHere => 'Ga verder vanaf hier';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Verwijder berichten hierna en regenereer';

  @override
  String get deleteMessagesAfterThis => 'Verwijder alle berichten hierna';

  @override
  String get createBookmark => 'Bladwijzer Maken';

  @override
  String get saveAsCheckpoint => 'Sla dit punt op als checkpoint';

  @override
  String get deleteThisMessage => 'Verwijder dit bericht';

  @override
  String get deleteThisAndAllAfter => 'Verwijder dit en alle volgende';

  @override
  String get attachImage => 'Afbeelding Bijvoegen';

  @override
  String get chooseFromGallery => 'Kies uit Galerij';

  @override
  String get takePhoto => 'Foto Maken';

  @override
  String failedToPickImage(String error) {
    return 'Kon afbeelding niet selecteren: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Kon foto niet maken: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Kon bijlage niet toevoegen: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Exporteer chat met $character';
  }

  @override
  String messagesCount(int count) {
    return '$count berichten';
  }

  @override
  String get chooseExportFormat => 'Kies exportformaat:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST-formaat)';

  @override
  String get noChatToExport => 'Geen chat om te exporteren';

  @override
  String exportFailed(String error) {
    return 'Export mislukt: $error';
  }

  @override
  String get importChatHistory => 'Importeer chatgeschiedenis uit bestand';

  @override
  String get supportedFormats => 'Ondersteunde formaten:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern-formaat)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern-formaat)';

  @override
  String get importNote =>
      'Opmerking: Geïmporteerde berichten worden toegevoegd aan de huidige chat.';

  @override
  String get chooseFile => 'Kies Bestand';

  @override
  String get noFileSelected => 'Geen bestand geselecteerd of ongeldig formaat';

  @override
  String get importConfirmation => 'Importbevestiging';

  @override
  String get character => 'Personage';

  @override
  String get user => 'Gebruiker';

  @override
  String get messages => 'Berichten';

  @override
  String get date => 'Datum';

  @override
  String get hasAuthorsNote => 'Heeft auteursnotitie';

  @override
  String get importMessagesToCurrentChat =>
      'Deze berichten importeren naar huidige chat?';

  @override
  String get noActiveChat => 'Geen actieve chat';

  @override
  String importedMessages(int count) {
    return '$count berichten succesvol geïmporteerd';
  }

  @override
  String importFailed(String error) {
    return 'Import mislukt: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Weet je zeker dat je alle berichten wilt wissen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get clear => 'Wissen';

  @override
  String get thinking => 'Denken';

  @override
  String get noSwipesAvailable => 'Geen swipes beschikbaar';

  @override
  String get system => 'Systeem';

  @override
  String get backgroundFeatureComingSoon =>
      'Achtergrondfunctie binnenkort beschikbaar';

  @override
  String get authorsNoteUpdated => 'Auteursnotitie bijgewerkt';

  @override
  String get commandError => 'Commandofout';

  @override
  String get enabled => 'Ingeschakeld';

  @override
  String get disabled => 'Uitgeschakeld';

  @override
  String get personas => 'Persona\'s';

  @override
  String get createPersona => 'Persona Maken';

  @override
  String get editPersona => 'Persona Bewerken';

  @override
  String get deletePersona => 'Persona Verwijderen';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Weet je zeker dat je \"$name\" wilt verwijderen?';
  }

  @override
  String get noPersonasYet => 'Nog geen persona\'s';

  @override
  String get createPersonaDescription =>
      'Maak een persona om jezelf te vertegenwoordigen in chats';

  @override
  String get name => 'Naam';

  @override
  String get enterPersonaName => 'Voer personanaam in';

  @override
  String get description => 'Beschrijving';

  @override
  String get describePersona => 'Beschrijf deze persona (optioneel)';

  @override
  String get personaDescriptionHelp =>
      'De beschrijving wordt opgenomen in de systeemprompt om de AI te helpen begrijpen wie je bent.';

  @override
  String get pleaseEnterName => 'Voer een naam in';

  @override
  String get default_ => 'Standaard';

  @override
  String get active => 'Actief';

  @override
  String get setAsDefault => 'Instellen als Standaard';

  @override
  String get removeAvatar => 'Avatar Verwijderen';

  @override
  String failedToSaveAvatar(String error) {
    return 'Kon avatar niet opslaan: $error';
  }

  @override
  String get selectAvatarImage => 'Selecteer avatarafbeelding';

  @override
  String get aiConfiguration => 'AI-configuratie';

  @override
  String get llmProvider => 'LLM-provider';

  @override
  String get apiUrl => 'API-URL';

  @override
  String get apiKey => 'API-sleutel';

  @override
  String get model => 'Model';

  @override
  String get temperature => 'Temperatuur';

  @override
  String get maxTokens => 'Maximum Tokens';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Frequentiepenalty';

  @override
  String get presencePenalty => 'Aanwezigheidspenalty';

  @override
  String get repetitionPenalty => 'Herhalingspenalty';

  @override
  String get streamingEnabled => 'Streaming Ingeschakeld';

  @override
  String get testConnection => 'Test Verbinding';

  @override
  String get connectionSuccessful => 'Verbinding succesvol!';

  @override
  String connectionFailed(String error) {
    return 'Verbinding mislukt: $error';
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
  String get local => 'Lokaal';

  @override
  String get aiPresets => 'AI-presets';

  @override
  String get createPreset => 'Preset Maken';

  @override
  String get editPreset => 'Preset Bewerken';

  @override
  String get deletePreset => 'Preset Verwijderen';

  @override
  String get presetName => 'Presetnaam';

  @override
  String get promptManager => 'Promptbeheer';

  @override
  String get systemPrompt => 'Systeemprompt';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Wereldinfo';

  @override
  String get createEntry => 'Item Maken';

  @override
  String get editEntry => 'Item Bewerken';

  @override
  String get deleteEntry => 'Item Verwijderen';

  @override
  String get keywords => 'Trefwoorden';

  @override
  String get content => 'Inhoud';

  @override
  String get priority => 'Prioriteit';

  @override
  String get groups => 'Groepen';

  @override
  String get createGroup => 'Groep Maken';

  @override
  String get editGroup => 'Groep Bewerken';

  @override
  String get deleteGroup => 'Groep Verwijderen';

  @override
  String get groupName => 'Groepsnaam';

  @override
  String get members => 'Leden';

  @override
  String get addMember => 'Lid Toevoegen';

  @override
  String get removeMember => 'Lid Verwijderen';

  @override
  String get tags => 'Tags';

  @override
  String get createTag => 'Tag Maken';

  @override
  String get editTag => 'Tag Bewerken';

  @override
  String get deleteTag => 'Tag Verwijderen';

  @override
  String get tagName => 'Tagnaam';

  @override
  String get color => 'Kleur';

  @override
  String get quickReplies => 'Snelle Antwoorden';

  @override
  String get createQuickReply => 'Snel Antwoord Maken';

  @override
  String get editQuickReply => 'Snel Antwoord Bewerken';

  @override
  String get deleteQuickReply => 'Snel Antwoord Verwijderen';

  @override
  String get label => 'Label';

  @override
  String get message => 'Bericht';

  @override
  String get autoSend => 'Automatisch Verzenden';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Regex maken';

  @override
  String get editRegex => 'Regex bewerken';

  @override
  String get deleteRegex => 'Regex verwijderen';

  @override
  String get pattern => 'Patroon';

  @override
  String get replacement => 'Vervanging';

  @override
  String get backup => 'Back-up';

  @override
  String get createBackup => 'Back-up Maken';

  @override
  String get restoreBackup => 'Back-up Herstellen';

  @override
  String get backupCreated => 'Back-up succesvol gemaakt';

  @override
  String get backupRestored => 'Back-up succesvol hersteld';

  @override
  String backupFailed(String error) {
    return 'Back-up mislukt: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Herstel mislukt: $error';
  }

  @override
  String get theme => 'Thema';

  @override
  String get darkMode => 'Donkere Modus';

  @override
  String get lightMode => 'Lichte Modus';

  @override
  String get systemTheme => 'Volg Systeem';

  @override
  String get primaryColor => 'Primaire Kleur';

  @override
  String get accentColor => 'Accentkleur';

  @override
  String get advanced => 'Geavanceerd';

  @override
  String get advancedSettings => 'Geavanceerde Instellingen';

  @override
  String get statistics => 'Statistieken';

  @override
  String get totalChats => 'Totaal Chats';

  @override
  String get totalMessages => 'Totaal Berichten';

  @override
  String get totalCharacters => 'Totaal Personages';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Tekst-naar-Spraak';

  @override
  String get stt => 'Spraak-naar-Tekst';

  @override
  String get translation => 'Vertaling';

  @override
  String get imageGeneration => 'Afbeelding Genereren';

  @override
  String get vectorStorage => 'Vectoropslag';

  @override
  String get sprites => 'Sprites';

  @override
  String get backgrounds => 'Achtergronden';

  @override
  String get cfgScale => 'CFG-schaal';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Variabelen';

  @override
  String get listView => 'Lijstweergave';

  @override
  String get gridView => 'Rasterweergave';

  @override
  String get search => 'Zoeken';

  @override
  String get searchCharacters => 'Zoek personages...';

  @override
  String get noCharactersFound => 'Geen personages gevonden';

  @override
  String get noCharactersYet => 'Nog geen personages';

  @override
  String get importCharacter => 'Importeer een personage om te beginnen';

  @override
  String get createCharacter => 'Personage Maken';

  @override
  String get editCharacter => 'Personage Bewerken';

  @override
  String get deleteCharacter => 'Personage Verwijderen';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Weet je zeker dat je \"$name\" wilt verwijderen? Alle chats met dit personage worden ook verwijderd.';
  }

  @override
  String get characterDeleted => 'Personage verwijderd';

  @override
  String get startChat => 'Start Chat';

  @override
  String get personality => 'Persoonlijkheid';

  @override
  String get scenario => 'Scenario';

  @override
  String get firstMessage => 'Eerste Bericht';

  @override
  String get exampleDialogue => 'Voorbeelddialoog';

  @override
  String get creatorNotes => 'Makernotities';

  @override
  String get alternateGreetings => 'Alternatieve Begroetingen';

  @override
  String get characterBook => 'Personageboek';

  @override
  String get language => 'Taal';

  @override
  String get selectLanguage => 'Selecteer Taal';

  @override
  String get languageChanged => 'Taal gewijzigd';

  @override
  String get about => 'Over';

  @override
  String get version => 'Versie';

  @override
  String get licenses => 'Licenties';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get termsOfService => 'Servicevoorwaarden';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateApp => 'Beoordeel App';

  @override
  String get shareApp => 'Deel App';

  @override
  String get checkForUpdates => 'Controleer op Updates';

  @override
  String get noUpdatesAvailable => 'Geen updates beschikbaar';

  @override
  String get updateAvailable => 'Update beschikbaar';

  @override
  String get downloadUpdate => 'Download Update';

  @override
  String get bookmarkCreated => 'Bladwijzer gemaakt';

  @override
  String get bookmarkName => 'Bladwijzernaam';

  @override
  String get enterBookmarkName => 'Voer bladwijzernaam in';

  @override
  String get noBookmarksYet => 'Nog geen bladwijzers';

  @override
  String get createBookmarkDescription =>
      'Maak bladwijzers om belangrijke punten in het gesprek op te slaan';

  @override
  String get jumpToBookmark => 'Ga naar Bladwijzer';

  @override
  String get deleteBookmark => 'Bladwijzer Verwijderen';

  @override
  String get bookmarkDeleted => 'Bladwijzer verwijderd';

  @override
  String get saveAsJsonl => 'Opslaan als JSONL';

  @override
  String get saveAsJson => 'Opslaan als JSON';

  @override
  String get keyboardShortcuts => 'Sneltoetsen:';

  @override
  String get bold => 'Vet';

  @override
  String get italic => 'Cursief';

  @override
  String get underline => 'Onderstrepen';

  @override
  String get strikethrough => 'Doorhalen';

  @override
  String get inlineCode => 'Inline Code';

  @override
  String get link => 'Link';

  @override
  String get slashCommands => 'Slash-commando\'s';

  @override
  String get availableCommands => 'Beschikbare commando\'s:';

  @override
  String get commandHelp => 'Typ / om beschikbare commando\'s te zien';
}
