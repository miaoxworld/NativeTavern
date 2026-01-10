// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Strona główna';

  @override
  String get characters => 'Postacie';

  @override
  String get settings => 'Ustawienia';

  @override
  String get chats => 'Czaty';

  @override
  String get newChat => 'Nowy czat';

  @override
  String get noChatsYet => 'Brak czatów';

  @override
  String get startNewConversation => 'Rozpocznij rozmowę z postacią';

  @override
  String get browseCharacters => 'Przeglądaj postacie';

  @override
  String get groupChats => 'Czaty grupowe';

  @override
  String get import => 'Importuj';

  @override
  String get delete => 'Usuń';

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get edit => 'Edytuj';

  @override
  String get copy => 'Kopiuj';

  @override
  String get retry => 'Ponów';

  @override
  String get close => 'Zamknij';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get error => 'Błąd';

  @override
  String errorLoadingChats(String error) {
    return 'Błąd ładowania czatów: $error';
  }

  @override
  String get deleteChat => 'Usuń czat';

  @override
  String get deleteChatConfirmation =>
      'Czy na pewno chcesz usunąć ten czat? Tej operacji nie można cofnąć.';

  @override
  String get chatDeleted => 'Czat usunięty';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String daysAgo(int count) {
    return '$count dni temu';
  }

  @override
  String get noMessages => 'Brak wiadomości';

  @override
  String get noMessagesYet => 'Brak wiadomości';

  @override
  String get chat => 'Czat';

  @override
  String get typeMessage => 'Wpisz wiadomość...';

  @override
  String get send => 'Wyślij';

  @override
  String get regenerate => 'Regeneruj';

  @override
  String get continueGeneration => 'Kontynuuj';

  @override
  String get viewCharacter => 'Zobacz postać';

  @override
  String get authorsNote => 'Notatka autora';

  @override
  String get bookmarks => 'Zakładki';

  @override
  String get exportChat => 'Eksportuj czat';

  @override
  String get importChat => 'Importuj czat';

  @override
  String get clearMessages => 'Wyczyść wiadomości';

  @override
  String get selectModel => 'Wybierz model';

  @override
  String get loadingModels => 'Ładowanie modeli...';

  @override
  String get noModelsAvailable =>
      'Brak dostępnych modeli. Sprawdź ustawienia API.';

  @override
  String modelChangedTo(String model) {
    return 'Model zmieniony na $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Nie udało się załadować modeli: $error';
  }

  @override
  String get searchModels => 'Szukaj modeli...';

  @override
  String get noModelsMatchSearch => 'Brak pasujących modeli';

  @override
  String get provider => 'Dostawca';

  @override
  String get apiNotConfigured => 'API nie skonfigurowane';

  @override
  String get apiNotConfiguredMessage =>
      'Aby rozmawiać z postaciami, musisz najpierw skonfigurować dostawcę LLM.';

  @override
  String get supportedProviders => 'Obsługiwani dostawcy:';

  @override
  String get configureNow => 'Skonfiguruj teraz';

  @override
  String get later => 'Później';

  @override
  String get configure => 'Konfiguruj';

  @override
  String get configureApiProvider =>
      'Skonfiguruj dostawcę LLM, aby rozpocząć czat';

  @override
  String get startConversation => 'Rozpocznij rozmowę';

  @override
  String get deleteMessage => 'Usuń wiadomość';

  @override
  String get deleteMessageConfirmation =>
      'Czy na pewno chcesz usunąć tę wiadomość?';

  @override
  String get deleteMessages => 'Usuń wiadomości';

  @override
  String get deleteMessagesConfirmation =>
      'Czy na pewno chcesz usunąć tę wiadomość i wszystkie następne?';

  @override
  String get deleteAll => 'Usuń wszystko';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get generateNewResponse => 'Wygeneruj nową odpowiedź';

  @override
  String get continueFromHere => 'Kontynuuj stąd';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Usuń wiadomości po tej i regeneruj';

  @override
  String get deleteMessagesAfterThis => 'Usuń wszystkie wiadomości po tej';

  @override
  String get createBookmark => 'Utwórz zakładkę';

  @override
  String get saveAsCheckpoint => 'Zapisz ten punkt jako checkpoint';

  @override
  String get deleteThisMessage => 'Usuń tę wiadomość';

  @override
  String get deleteThisAndAllAfter => 'Usuń tę i wszystkie następne';

  @override
  String get attachImage => 'Dołącz obraz';

  @override
  String get chooseFromGallery => 'Wybierz z galerii';

  @override
  String get takePhoto => 'Zrób zdjęcie';

  @override
  String failedToPickImage(String error) {
    return 'Nie udało się wybrać obrazu: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Nie udało się zrobić zdjęcia: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Nie udało się dodać załącznika: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Eksportuj czat z $character';
  }

  @override
  String messagesCount(int count) {
    return '$count wiadomości';
  }

  @override
  String get chooseExportFormat => 'Wybierz format eksportu:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (format ST)';

  @override
  String get noChatToExport => 'Brak czatu do eksportu';

  @override
  String exportFailed(String error) {
    return 'Eksport nie powiódł się: $error';
  }

  @override
  String get importChatHistory => 'Importuj historię czatu z pliku';

  @override
  String get supportedFormats => 'Obsługiwane formaty:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (format SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (format NativeTavern)';

  @override
  String get importNote =>
      'Uwaga: Zaimportowane wiadomości zostaną dodane do bieżącego czatu.';

  @override
  String get chooseFile => 'Wybierz plik';

  @override
  String get noFileSelected => 'Nie wybrano pliku lub nieprawidłowy format';

  @override
  String get importConfirmation => 'Potwierdzenie importu';

  @override
  String get character => 'Postać';

  @override
  String get user => 'Użytkownik';

  @override
  String get messages => 'Wiadomości';

  @override
  String get date => 'Data';

  @override
  String get hasAuthorsNote => 'Ma notatkę autora';

  @override
  String get importMessagesToCurrentChat =>
      'Zaimportować te wiadomości do bieżącego czatu?';

  @override
  String get noActiveChat => 'Brak aktywnego czatu';

  @override
  String importedMessages(int count) {
    return 'Pomyślnie zaimportowano $count wiadomości';
  }

  @override
  String importFailed(String error) {
    return 'Import nie powiódł się: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Czy na pewno chcesz wyczyścić wszystkie wiadomości? Tej operacji nie można cofnąć.';

  @override
  String get clear => 'Wyczyść';

  @override
  String get thinking => 'Myślenie';

  @override
  String get noSwipesAvailable => 'Brak dostępnych przesunięć';

  @override
  String get system => 'System';

  @override
  String get backgroundFeatureComingSoon => 'Funkcja tła wkrótce';

  @override
  String get authorsNoteUpdated => 'Notatka autora zaktualizowana';

  @override
  String get commandError => 'Błąd polecenia';

  @override
  String get enabled => 'Włączone';

  @override
  String get disabled => 'Wyłączone';

  @override
  String get personas => 'Persony';

  @override
  String get createPersona => 'Utwórz personę';

  @override
  String get editPersona => 'Edytuj personę';

  @override
  String get deletePersona => 'Usuń personę';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Czy na pewno chcesz usunąć \"$name\"?';
  }

  @override
  String get noPersonasYet => 'Brak person';

  @override
  String get createPersonaDescription =>
      'Utwórz personę, aby reprezentować siebie w czatach';

  @override
  String get name => 'Nazwa';

  @override
  String get enterPersonaName => 'Wprowadź nazwę persony';

  @override
  String get description => 'Opis';

  @override
  String get describePersona => 'Opisz tę personę (opcjonalnie)';

  @override
  String get personaDescriptionHelp =>
      'Opis zostanie dołączony do promptu systemowego, aby pomóc AI zrozumieć, kim jesteś.';

  @override
  String get pleaseEnterName => 'Proszę wprowadzić nazwę';

  @override
  String get default_ => 'Domyślny';

  @override
  String get active => 'Aktywny';

  @override
  String get setAsDefault => 'Ustaw jako domyślny';

  @override
  String get removeAvatar => 'Usuń awatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Nie udało się zapisać awatara: $error';
  }

  @override
  String get selectAvatarImage => 'Wybierz obraz awatara';

  @override
  String get aiConfiguration => 'Konfiguracja AI';

  @override
  String get llmProvider => 'Dostawca LLM';

  @override
  String get apiUrl => 'URL API';

  @override
  String get apiKey => 'Klucz API';

  @override
  String get model => 'Model';

  @override
  String get temperature => 'Temperatura';

  @override
  String get maxTokens => 'Maksymalna liczba tokenów';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Kara za częstotliwość';

  @override
  String get presencePenalty => 'Kara za obecność';

  @override
  String get repetitionPenalty => 'Kara za powtórzenia';

  @override
  String get streamingEnabled => 'Streaming włączony';

  @override
  String get testConnection => 'Testuj połączenie';

  @override
  String get connectionSuccessful => 'Połączenie udane!';

  @override
  String connectionFailed(String error) {
    return 'Połączenie nie powiodło się: $error';
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
  String get local => 'Lokalny';

  @override
  String get aiPresets => 'Presety AI';

  @override
  String get createPreset => 'Utwórz preset';

  @override
  String get editPreset => 'Edytuj preset';

  @override
  String get deletePreset => 'Usuń preset';

  @override
  String get presetName => 'Nazwa presetu';

  @override
  String get promptManager => 'Menedżer promptów';

  @override
  String get systemPrompt => 'Prompt systemowy';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Informacje o świecie';

  @override
  String get createEntry => 'Utwórz wpis';

  @override
  String get editEntry => 'Edytuj wpis';

  @override
  String get deleteEntry => 'Usuń wpis';

  @override
  String get keywords => 'Słowa kluczowe';

  @override
  String get content => 'Treść';

  @override
  String get priority => 'Priorytet';

  @override
  String get groups => 'Grupy';

  @override
  String get createGroup => 'Utwórz grupę';

  @override
  String get editGroup => 'Edytuj grupę';

  @override
  String get deleteGroup => 'Usuń grupę';

  @override
  String get groupName => 'Nazwa grupy';

  @override
  String get members => 'Członkowie';

  @override
  String get addMember => 'Dodaj członka';

  @override
  String get removeMember => 'Usuń członka';

  @override
  String get tags => 'Tagi';

  @override
  String get createTag => 'Utwórz tag';

  @override
  String get editTag => 'Edytuj tag';

  @override
  String get deleteTag => 'Usuń tag';

  @override
  String get tagName => 'Nazwa tagu';

  @override
  String get color => 'Kolor';

  @override
  String get quickReplies => 'Szybkie odpowiedzi';

  @override
  String get createQuickReply => 'Utwórz szybką odpowiedź';

  @override
  String get editQuickReply => 'Edytuj szybką odpowiedź';

  @override
  String get deleteQuickReply => 'Usuń szybką odpowiedź';

  @override
  String get label => 'Etykieta';

  @override
  String get message => 'Wiadomość';

  @override
  String get autoSend => 'Automatyczne wysyłanie';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Utwórz regex';

  @override
  String get editRegex => 'Edytuj regex';

  @override
  String get deleteRegex => 'Usuń regex';

  @override
  String get pattern => 'Wzorzec';

  @override
  String get replacement => 'Zamiennik';

  @override
  String get backup => 'Kopia zapasowa';

  @override
  String get createBackup => 'Utwórz kopię zapasową';

  @override
  String get restoreBackup => 'Przywróć kopię zapasową';

  @override
  String get backupCreated => 'Kopia zapasowa utworzona pomyślnie';

  @override
  String get backupRestored => 'Kopia zapasowa przywrócona pomyślnie';

  @override
  String backupFailed(String error) {
    return 'Tworzenie kopii zapasowej nie powiodło się: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Przywracanie nie powiodło się: $error';
  }

  @override
  String get theme => 'Motyw';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get lightMode => 'Tryb jasny';

  @override
  String get systemTheme => 'Zgodnie z systemem';

  @override
  String get primaryColor => 'Kolor główny';

  @override
  String get accentColor => 'Kolor akcentu';

  @override
  String get advanced => 'Zaawansowane';

  @override
  String get advancedSettings => 'Ustawienia zaawansowane';

  @override
  String get statistics => 'Statystyki';

  @override
  String get totalChats => 'Łączna liczba czatów';

  @override
  String get totalMessages => 'Łączna liczba wiadomości';

  @override
  String get totalCharacters => 'Łączna liczba postaci';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Tekst na mowę';

  @override
  String get stt => 'Mowa na tekst';

  @override
  String get translation => 'Tłumaczenie';

  @override
  String get imageGeneration => 'Generowanie obrazów';

  @override
  String get vectorStorage => 'Przechowywanie wektorowe';

  @override
  String get sprites => 'Sprite\'y';

  @override
  String get backgrounds => 'Tła';

  @override
  String get cfgScale => 'Skala CFG';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Zmienne';

  @override
  String get listView => 'Widok listy';

  @override
  String get gridView => 'Widok siatki';

  @override
  String get search => 'Szukaj';

  @override
  String get searchCharacters => 'Szukaj postaci...';

  @override
  String get noCharactersFound => 'Nie znaleziono postaci';

  @override
  String get noCharactersYet => 'Brak postaci';

  @override
  String get importCharacter => 'Zaimportuj postać, aby rozpocząć';

  @override
  String get createCharacter => 'Utwórz postać';

  @override
  String get editCharacter => 'Edytuj postać';

  @override
  String get deleteCharacter => 'Usuń postać';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Czy na pewno chcesz usunąć \"$name\"? Wszystkie czaty z tą postacią również zostaną usunięte.';
  }

  @override
  String get characterDeleted => 'Postać usunięta';

  @override
  String get startChat => 'Rozpocznij czat';

  @override
  String get personality => 'Osobowość';

  @override
  String get scenario => 'Scenariusz';

  @override
  String get firstMessage => 'Pierwsza wiadomość';

  @override
  String get exampleDialogue => 'Przykładowy dialog';

  @override
  String get creatorNotes => 'Notatki twórcy';

  @override
  String get alternateGreetings => 'Alternatywne powitania';

  @override
  String get characterBook => 'Książka postaci';

  @override
  String get language => 'Język';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get languageChanged => 'Język zmieniony';

  @override
  String get about => 'O aplikacji';

  @override
  String get version => 'Wersja';

  @override
  String get licenses => 'Licencje';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get termsOfService => 'Warunki usługi';

  @override
  String get feedback => 'Opinia';

  @override
  String get rateApp => 'Oceń aplikację';

  @override
  String get shareApp => 'Udostępnij aplikację';

  @override
  String get checkForUpdates => 'Sprawdź aktualizacje';

  @override
  String get noUpdatesAvailable => 'Brak dostępnych aktualizacji';

  @override
  String get updateAvailable => 'Dostępna aktualizacja';

  @override
  String get downloadUpdate => 'Pobierz aktualizację';

  @override
  String get bookmarkCreated => 'Zakładka utworzona';

  @override
  String get bookmarkName => 'Nazwa zakładki';

  @override
  String get enterBookmarkName => 'Wprowadź nazwę zakładki';

  @override
  String get noBookmarksYet => 'Brak zakładek';

  @override
  String get createBookmarkDescription =>
      'Utwórz zakładki, aby zapisać ważne punkty w rozmowie';

  @override
  String get jumpToBookmark => 'Przejdź do zakładki';

  @override
  String get deleteBookmark => 'Usuń zakładkę';

  @override
  String get bookmarkDeleted => 'Zakładka usunięta';

  @override
  String get saveAsJsonl => 'Zapisz jako JSONL';

  @override
  String get saveAsJson => 'Zapisz jako JSON';

  @override
  String get keyboardShortcuts => 'Skróty klawiaturowe:';

  @override
  String get bold => 'Pogrubienie';

  @override
  String get italic => 'Kursywa';

  @override
  String get underline => 'Podkreślenie';

  @override
  String get strikethrough => 'Przekreślenie';

  @override
  String get inlineCode => 'Kod w linii';

  @override
  String get link => 'Link';

  @override
  String get slashCommands => 'Polecenia slash';

  @override
  String get availableCommands => 'Dostępne polecenia:';

  @override
  String get commandHelp => 'Wpisz / aby zobaczyć dostępne polecenia';
}
