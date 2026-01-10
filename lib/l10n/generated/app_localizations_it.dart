// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Home';

  @override
  String get characters => 'Personaggi';

  @override
  String get settings => 'Impostazioni';

  @override
  String get chats => 'Chat';

  @override
  String get newChat => 'Nuova Chat';

  @override
  String get noChatsYet => 'Nessuna chat ancora';

  @override
  String get startNewConversation =>
      'Inizia una conversazione con un personaggio';

  @override
  String get browseCharacters => 'Sfoglia Personaggi';

  @override
  String get groupChats => 'Chat di Gruppo';

  @override
  String get import => 'Importa';

  @override
  String get delete => 'Elimina';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get edit => 'Modifica';

  @override
  String get copy => 'Copia';

  @override
  String get retry => 'Riprova';

  @override
  String get close => 'Chiudi';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String errorLoadingChats(String error) {
    return 'Errore nel caricamento delle chat: $error';
  }

  @override
  String get deleteChat => 'Elimina Chat';

  @override
  String get deleteChatConfirmation =>
      'Sei sicuro di voler eliminare questa chat? Questa azione non può essere annullata.';

  @override
  String get chatDeleted => 'Chat eliminata';

  @override
  String get yesterday => 'Ieri';

  @override
  String daysAgo(int count) {
    return '$count giorni fa';
  }

  @override
  String get noMessages => 'Nessun messaggio';

  @override
  String get noMessagesYet => 'Nessun messaggio ancora';

  @override
  String get chat => 'Chat';

  @override
  String get typeMessage => 'Scrivi un messaggio...';

  @override
  String get send => 'Invia';

  @override
  String get regenerate => 'Rigenera';

  @override
  String get continueGeneration => 'Continua';

  @override
  String get viewCharacter => 'Visualizza Personaggio';

  @override
  String get authorsNote => 'Nota dell\'Autore';

  @override
  String get bookmarks => 'Segnalibri';

  @override
  String get exportChat => 'Esporta Chat';

  @override
  String get importChat => 'Importa Chat';

  @override
  String get clearMessages => 'Cancella Messaggi';

  @override
  String get selectModel => 'Seleziona Modello';

  @override
  String get loadingModels => 'Caricamento modelli...';

  @override
  String get noModelsAvailable =>
      'Nessun modello disponibile. Controlla le impostazioni API.';

  @override
  String modelChangedTo(String model) {
    return 'Modello cambiato in $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Impossibile caricare i modelli: $error';
  }

  @override
  String get searchModels => 'Cerca modelli...';

  @override
  String get noModelsMatchSearch => 'Nessun modello corrispondente';

  @override
  String get provider => 'Provider';

  @override
  String get apiNotConfigured => 'API Non Configurata';

  @override
  String get apiNotConfiguredMessage =>
      'Per chattare con i personaggi, devi prima configurare un provider LLM.';

  @override
  String get supportedProviders => 'Provider supportati:';

  @override
  String get configureNow => 'Configura Ora';

  @override
  String get later => 'Più Tardi';

  @override
  String get configure => 'Configura';

  @override
  String get configureApiProvider =>
      'Configura il provider LLM per iniziare a chattare';

  @override
  String get startConversation => 'Inizia Conversazione';

  @override
  String get deleteMessage => 'Elimina Messaggio';

  @override
  String get deleteMessageConfirmation =>
      'Sei sicuro di voler eliminare questo messaggio?';

  @override
  String get deleteMessages => 'Elimina Messaggi';

  @override
  String get deleteMessagesConfirmation =>
      'Sei sicuro di voler eliminare questo messaggio e tutti quelli successivi?';

  @override
  String get deleteAll => 'Elimina Tutto';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get generateNewResponse => 'Genera nuova risposta';

  @override
  String get continueFromHere => 'Continua da qui';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Elimina messaggi successivi e rigenera';

  @override
  String get deleteMessagesAfterThis => 'Elimina tutti i messaggi successivi';

  @override
  String get createBookmark => 'Crea Segnalibro';

  @override
  String get saveAsCheckpoint => 'Salva questo punto come checkpoint';

  @override
  String get deleteThisMessage => 'Elimina questo messaggio';

  @override
  String get deleteThisAndAllAfter => 'Elimina questo e tutti i successivi';

  @override
  String get attachImage => 'Allega Immagine';

  @override
  String get chooseFromGallery => 'Scegli dalla Galleria';

  @override
  String get takePhoto => 'Scatta Foto';

  @override
  String failedToPickImage(String error) {
    return 'Impossibile selezionare l\'immagine: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Impossibile scattare la foto: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Impossibile aggiungere l\'allegato: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Esporta chat con $character';
  }

  @override
  String messagesCount(int count) {
    return '$count messaggi';
  }

  @override
  String get chooseExportFormat => 'Scegli il formato di esportazione:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (formato ST)';

  @override
  String get noChatToExport => 'Nessuna chat da esportare';

  @override
  String exportFailed(String error) {
    return 'Esportazione fallita: $error';
  }

  @override
  String get importChatHistory => 'Importa cronologia chat da file';

  @override
  String get supportedFormats => 'Formati supportati:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (formato SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (formato NativeTavern)';

  @override
  String get importNote =>
      'Nota: I messaggi importati verranno aggiunti alla chat corrente.';

  @override
  String get chooseFile => 'Scegli File';

  @override
  String get noFileSelected => 'Nessun file selezionato o formato non valido';

  @override
  String get importConfirmation => 'Conferma Importazione';

  @override
  String get character => 'Personaggio';

  @override
  String get user => 'Utente';

  @override
  String get messages => 'Messaggi';

  @override
  String get date => 'Data';

  @override
  String get hasAuthorsNote => 'Ha nota dell\'autore';

  @override
  String get importMessagesToCurrentChat =>
      'Importare questi messaggi nella chat corrente?';

  @override
  String get noActiveChat => 'Nessuna chat attiva';

  @override
  String importedMessages(int count) {
    return 'Importati $count messaggi con successo';
  }

  @override
  String importFailed(String error) {
    return 'Importazione fallita: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Sei sicuro di voler cancellare tutti i messaggi? Questa azione non può essere annullata.';

  @override
  String get clear => 'Cancella';

  @override
  String get thinking => 'Pensando';

  @override
  String get noSwipesAvailable => 'Nessuno swipe disponibile';

  @override
  String get system => 'Sistema';

  @override
  String get backgroundFeatureComingSoon => 'Funzione sfondo in arrivo';

  @override
  String get authorsNoteUpdated => 'Nota dell\'autore aggiornata';

  @override
  String get commandError => 'Errore comando';

  @override
  String get enabled => 'Abilitato';

  @override
  String get disabled => 'Disabilitato';

  @override
  String get personas => 'Personae';

  @override
  String get createPersona => 'Crea Persona';

  @override
  String get editPersona => 'Modifica Persona';

  @override
  String get deletePersona => 'Elimina Persona';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"?';
  }

  @override
  String get noPersonasYet => 'Nessuna persona ancora';

  @override
  String get createPersonaDescription =>
      'Crea una persona per rappresentarti nelle chat';

  @override
  String get name => 'Nome';

  @override
  String get enterPersonaName => 'Inserisci nome persona';

  @override
  String get description => 'Descrizione';

  @override
  String get describePersona => 'Descrivi questa persona (opzionale)';

  @override
  String get personaDescriptionHelp =>
      'La descrizione sarà inclusa nel prompt di sistema per aiutare l\'AI a capire chi sei.';

  @override
  String get pleaseEnterName => 'Per favore inserisci un nome';

  @override
  String get default_ => 'Predefinito';

  @override
  String get active => 'Attivo';

  @override
  String get setAsDefault => 'Imposta come Predefinito';

  @override
  String get removeAvatar => 'Rimuovi Avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Impossibile salvare l\'avatar: $error';
  }

  @override
  String get selectAvatarImage => 'Seleziona immagine avatar';

  @override
  String get aiConfiguration => 'Configurazione AI';

  @override
  String get llmProvider => 'Provider LLM';

  @override
  String get apiUrl => 'URL API';

  @override
  String get apiKey => 'Chiave API';

  @override
  String get model => 'Modello';

  @override
  String get temperature => 'Temperatura';

  @override
  String get maxTokens => 'Token Massimi';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Penalità Frequenza';

  @override
  String get presencePenalty => 'Penalità Presenza';

  @override
  String get repetitionPenalty => 'Penalità Ripetizione';

  @override
  String get streamingEnabled => 'Streaming Abilitato';

  @override
  String get testConnection => 'Testa Connessione';

  @override
  String get connectionSuccessful => 'Connessione riuscita!';

  @override
  String connectionFailed(String error) {
    return 'Connessione fallita: $error';
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
  String get local => 'Locale';

  @override
  String get aiPresets => 'Preset AI';

  @override
  String get createPreset => 'Crea Preset';

  @override
  String get editPreset => 'Modifica Preset';

  @override
  String get deletePreset => 'Elimina Preset';

  @override
  String get presetName => 'Nome Preset';

  @override
  String get promptManager => 'Gestore Prompt';

  @override
  String get systemPrompt => 'Prompt di Sistema';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Info Mondo';

  @override
  String get createEntry => 'Crea Voce';

  @override
  String get editEntry => 'Modifica Voce';

  @override
  String get deleteEntry => 'Elimina Voce';

  @override
  String get keywords => 'Parole Chiave';

  @override
  String get content => 'Contenuto';

  @override
  String get priority => 'Priorità';

  @override
  String get groups => 'Gruppi';

  @override
  String get createGroup => 'Crea Gruppo';

  @override
  String get editGroup => 'Modifica Gruppo';

  @override
  String get deleteGroup => 'Elimina Gruppo';

  @override
  String get groupName => 'Nome Gruppo';

  @override
  String get members => 'Membri';

  @override
  String get addMember => 'Aggiungi Membro';

  @override
  String get removeMember => 'Rimuovi Membro';

  @override
  String get tags => 'Tag';

  @override
  String get createTag => 'Crea Tag';

  @override
  String get editTag => 'Modifica Tag';

  @override
  String get deleteTag => 'Elimina Tag';

  @override
  String get tagName => 'Nome Tag';

  @override
  String get color => 'Colore';

  @override
  String get quickReplies => 'Risposte Rapide';

  @override
  String get createQuickReply => 'Crea Risposta Rapida';

  @override
  String get editQuickReply => 'Modifica Risposta Rapida';

  @override
  String get deleteQuickReply => 'Elimina Risposta Rapida';

  @override
  String get label => 'Etichetta';

  @override
  String get message => 'Messaggio';

  @override
  String get autoSend => 'Invio Automatico';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Crea regex';

  @override
  String get editRegex => 'Modifica regex';

  @override
  String get deleteRegex => 'Elimina regex';

  @override
  String get pattern => 'Pattern';

  @override
  String get replacement => 'Sostituzione';

  @override
  String get backup => 'Backup';

  @override
  String get createBackup => 'Crea Backup';

  @override
  String get restoreBackup => 'Ripristina Backup';

  @override
  String get backupCreated => 'Backup creato con successo';

  @override
  String get backupRestored => 'Backup ripristinato con successo';

  @override
  String backupFailed(String error) {
    return 'Backup fallito: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Ripristino fallito: $error';
  }

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modalità Scura';

  @override
  String get lightMode => 'Modalità Chiara';

  @override
  String get systemTheme => 'Segui Sistema';

  @override
  String get primaryColor => 'Colore Primario';

  @override
  String get accentColor => 'Colore Accento';

  @override
  String get advanced => 'Avanzate';

  @override
  String get advancedSettings => 'Impostazioni Avanzate';

  @override
  String get statistics => 'Statistiche';

  @override
  String get totalChats => 'Chat Totali';

  @override
  String get totalMessages => 'Messaggi Totali';

  @override
  String get totalCharacters => 'Personaggi Totali';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get stt => 'Speech-to-Text';

  @override
  String get translation => 'Traduzione';

  @override
  String get imageGeneration => 'Generazione Immagini';

  @override
  String get vectorStorage => 'Archiviazione Vettoriale';

  @override
  String get sprites => 'Sprite';

  @override
  String get backgrounds => 'Sfondi';

  @override
  String get cfgScale => 'Scala CFG';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Variabili';

  @override
  String get listView => 'Vista Lista';

  @override
  String get gridView => 'Vista Griglia';

  @override
  String get search => 'Cerca';

  @override
  String get searchCharacters => 'Cerca personaggi...';

  @override
  String get noCharactersFound => 'Nessun personaggio trovato';

  @override
  String get noCharactersYet => 'Nessun personaggio ancora';

  @override
  String get importCharacter => 'Importa un personaggio per iniziare';

  @override
  String get createCharacter => 'Crea Personaggio';

  @override
  String get editCharacter => 'Modifica Personaggio';

  @override
  String get deleteCharacter => 'Elimina Personaggio';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"? Tutte le chat con questo personaggio verranno eliminate.';
  }

  @override
  String get characterDeleted => 'Personaggio eliminato';

  @override
  String get startChat => 'Inizia Chat';

  @override
  String get personality => 'Personalità';

  @override
  String get scenario => 'Scenario';

  @override
  String get firstMessage => 'Primo Messaggio';

  @override
  String get exampleDialogue => 'Dialogo di Esempio';

  @override
  String get creatorNotes => 'Note del Creatore';

  @override
  String get alternateGreetings => 'Saluti Alternativi';

  @override
  String get characterBook => 'Libro del Personaggio';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona Lingua';

  @override
  String get languageChanged => 'Lingua cambiata';

  @override
  String get about => 'Informazioni';

  @override
  String get version => 'Versione';

  @override
  String get licenses => 'Licenze';

  @override
  String get privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get termsOfService => 'Termini di Servizio';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateApp => 'Valuta l\'App';

  @override
  String get shareApp => 'Condividi l\'App';

  @override
  String get checkForUpdates => 'Controlla Aggiornamenti';

  @override
  String get noUpdatesAvailable => 'Nessun aggiornamento disponibile';

  @override
  String get updateAvailable => 'Aggiornamento disponibile';

  @override
  String get downloadUpdate => 'Scarica Aggiornamento';

  @override
  String get bookmarkCreated => 'Segnalibro creato';

  @override
  String get bookmarkName => 'Nome Segnalibro';

  @override
  String get enterBookmarkName => 'Inserisci nome segnalibro';

  @override
  String get noBookmarksYet => 'Nessun segnalibro ancora';

  @override
  String get createBookmarkDescription =>
      'Crea segnalibri per salvare punti importanti nella conversazione';

  @override
  String get jumpToBookmark => 'Vai al Segnalibro';

  @override
  String get deleteBookmark => 'Elimina Segnalibro';

  @override
  String get bookmarkDeleted => 'Segnalibro eliminato';

  @override
  String get saveAsJsonl => 'Salva come JSONL';

  @override
  String get saveAsJson => 'Salva come JSON';

  @override
  String get keyboardShortcuts => 'Scorciatoie da tastiera:';

  @override
  String get bold => 'Grassetto';

  @override
  String get italic => 'Corsivo';

  @override
  String get underline => 'Sottolineato';

  @override
  String get strikethrough => 'Barrato';

  @override
  String get inlineCode => 'Codice Inline';

  @override
  String get link => 'Link';

  @override
  String get slashCommands => 'Comandi Slash';

  @override
  String get availableCommands => 'Comandi disponibili:';

  @override
  String get commandHelp => 'Digita / per vedere i comandi disponibili';
}
