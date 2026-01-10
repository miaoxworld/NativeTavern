// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Laman Utama';

  @override
  String get characters => 'Watak';

  @override
  String get settings => 'Tetapan';

  @override
  String get chats => 'Sembang';

  @override
  String get newChat => 'Sembang Baharu';

  @override
  String get noChatsYet => 'Tiada sembang lagi';

  @override
  String get startNewConversation => 'Mulakan perbualan dengan watak';

  @override
  String get browseCharacters => 'Layari Watak';

  @override
  String get groupChats => 'Sembang Kumpulan';

  @override
  String get import => 'Import';

  @override
  String get delete => 'Padam';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get edit => 'Edit';

  @override
  String get copy => 'Salin';

  @override
  String get retry => 'Cuba Lagi';

  @override
  String get close => 'Tutup';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get loading => 'Memuatkan...';

  @override
  String get error => 'Ralat';

  @override
  String errorLoadingChats(String error) {
    return 'Ralat memuatkan sembang: $error';
  }

  @override
  String get deleteChat => 'Padam Sembang';

  @override
  String get deleteChatConfirmation =>
      'Adakah anda pasti mahu memadamkan sembang ini? Tindakan ini tidak boleh dibatalkan.';

  @override
  String get chatDeleted => 'Sembang dipadamkan';

  @override
  String get yesterday => 'Semalam';

  @override
  String daysAgo(int count) {
    return '$count hari lepas';
  }

  @override
  String get noMessages => 'Tiada mesej';

  @override
  String get noMessagesYet => 'Tiada mesej lagi';

  @override
  String get chat => 'Sembang';

  @override
  String get typeMessage => 'Taip mesej...';

  @override
  String get send => 'Hantar';

  @override
  String get regenerate => 'Jana Semula';

  @override
  String get continueGeneration => 'Teruskan';

  @override
  String get viewCharacter => 'Lihat Watak';

  @override
  String get authorsNote => 'Nota Penulis';

  @override
  String get bookmarks => 'Penanda Buku';

  @override
  String get exportChat => 'Eksport Sembang';

  @override
  String get importChat => 'Import Sembang';

  @override
  String get clearMessages => 'Kosongkan Mesej';

  @override
  String get selectModel => 'Pilih Model';

  @override
  String get loadingModels => 'Memuatkan model...';

  @override
  String get noModelsAvailable =>
      'Tiada model tersedia. Semak tetapan API anda.';

  @override
  String modelChangedTo(String model) {
    return 'Model ditukar kepada $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Gagal memuatkan model: $error';
  }

  @override
  String get searchModels => 'Cari model...';

  @override
  String get noModelsMatchSearch => 'Tiada model yang sepadan';

  @override
  String get provider => 'Pembekal';

  @override
  String get apiNotConfigured => 'API Belum Dikonfigurasi';

  @override
  String get apiNotConfiguredMessage =>
      'Untuk bersembang dengan watak, anda perlu mengkonfigurasi pembekal LLM terlebih dahulu.';

  @override
  String get supportedProviders => 'Pembekal yang disokong:';

  @override
  String get configureNow => 'Konfigurasi Sekarang';

  @override
  String get later => 'Kemudian';

  @override
  String get configure => 'Konfigurasi';

  @override
  String get configureApiProvider =>
      'Konfigurasi pembekal LLM untuk mula bersembang';

  @override
  String get startConversation => 'Mulakan Perbualan';

  @override
  String get deleteMessage => 'Padam Mesej';

  @override
  String get deleteMessageConfirmation =>
      'Adakah anda pasti mahu memadamkan mesej ini?';

  @override
  String get deleteMessages => 'Padam Mesej';

  @override
  String get deleteMessagesConfirmation =>
      'Adakah anda pasti mahu memadamkan mesej ini dan semua mesej selepasnya?';

  @override
  String get deleteAll => 'Padam Semua';

  @override
  String get copiedToClipboard => 'Disalin ke papan keratan';

  @override
  String get generateNewResponse => 'Jana respons baharu';

  @override
  String get continueFromHere => 'Teruskan dari sini';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Padam mesej selepas ini dan jana semula';

  @override
  String get deleteMessagesAfterThis => 'Padam semua mesej selepas ini';

  @override
  String get createBookmark => 'Cipta Penanda Buku';

  @override
  String get saveAsCheckpoint => 'Simpan titik ini sebagai checkpoint';

  @override
  String get deleteThisMessage => 'Padam mesej ini';

  @override
  String get deleteThisAndAllAfter => 'Padam ini dan semua selepasnya';

  @override
  String get attachImage => 'Lampirkan Imej';

  @override
  String get chooseFromGallery => 'Pilih dari Galeri';

  @override
  String get takePhoto => 'Ambil Foto';

  @override
  String failedToPickImage(String error) {
    return 'Gagal memilih imej: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Gagal mengambil foto: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Gagal menambah lampiran: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Eksport sembang dengan $character';
  }

  @override
  String messagesCount(int count) {
    return '$count mesej';
  }

  @override
  String get chooseExportFormat => 'Pilih format eksport:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (format ST)';

  @override
  String get noChatToExport => 'Tiada sembang untuk dieksport';

  @override
  String exportFailed(String error) {
    return 'Eksport gagal: $error';
  }

  @override
  String get importChatHistory => 'Import sejarah sembang dari fail';

  @override
  String get supportedFormats => 'Format yang disokong:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (format SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (format NativeTavern)';

  @override
  String get importNote =>
      'Nota: Mesej yang diimport akan ditambah ke sembang semasa.';

  @override
  String get chooseFile => 'Pilih Fail';

  @override
  String get noFileSelected => 'Tiada fail dipilih atau format tidak sah';

  @override
  String get importConfirmation => 'Pengesahan Import';

  @override
  String get character => 'Watak';

  @override
  String get user => 'Pengguna';

  @override
  String get messages => 'Mesej';

  @override
  String get date => 'Tarikh';

  @override
  String get hasAuthorsNote => 'Mempunyai nota penulis';

  @override
  String get importMessagesToCurrentChat =>
      'Import mesej-mesej ini ke sembang semasa?';

  @override
  String get noActiveChat => 'Tiada sembang aktif';

  @override
  String importedMessages(int count) {
    return 'Berjaya mengimport $count mesej';
  }

  @override
  String importFailed(String error) {
    return 'Import gagal: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Adakah anda pasti mahu mengosongkan semua mesej? Tindakan ini tidak boleh dibatalkan.';

  @override
  String get clear => 'Kosongkan';

  @override
  String get thinking => 'Berfikir';

  @override
  String get noSwipesAvailable => 'Tiada swipe tersedia';

  @override
  String get system => 'Sistem';

  @override
  String get backgroundFeatureComingSoon => 'Ciri latar belakang akan datang';

  @override
  String get authorsNoteUpdated => 'Nota penulis dikemas kini';

  @override
  String get commandError => 'Ralat arahan';

  @override
  String get enabled => 'Diaktifkan';

  @override
  String get disabled => 'Dinyahaktifkan';

  @override
  String get personas => 'Persona';

  @override
  String get createPersona => 'Cipta Persona';

  @override
  String get editPersona => 'Edit Persona';

  @override
  String get deletePersona => 'Padam Persona';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Adakah anda pasti mahu memadamkan \"$name\"?';
  }

  @override
  String get noPersonasYet => 'Tiada persona lagi';

  @override
  String get createPersonaDescription =>
      'Cipta persona untuk mewakili diri anda dalam sembang';

  @override
  String get name => 'Nama';

  @override
  String get enterPersonaName => 'Masukkan nama persona';

  @override
  String get description => 'Penerangan';

  @override
  String get describePersona => 'Terangkan persona ini (pilihan)';

  @override
  String get personaDescriptionHelp =>
      'Penerangan akan disertakan dalam prompt sistem untuk membantu AI memahami siapa anda.';

  @override
  String get pleaseEnterName => 'Sila masukkan nama';

  @override
  String get default_ => 'Lalai';

  @override
  String get active => 'Aktif';

  @override
  String get setAsDefault => 'Tetapkan sebagai Lalai';

  @override
  String get removeAvatar => 'Buang Avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Gagal menyimpan avatar: $error';
  }

  @override
  String get selectAvatarImage => 'Pilih imej avatar';

  @override
  String get aiConfiguration => 'Konfigurasi AI';

  @override
  String get llmProvider => 'Pembekal LLM';

  @override
  String get apiUrl => 'URL API';

  @override
  String get apiKey => 'Kunci API';

  @override
  String get model => 'Model';

  @override
  String get temperature => 'Suhu';

  @override
  String get maxTokens => 'Token Maksimum';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Penalti Kekerapan';

  @override
  String get presencePenalty => 'Penalti Kehadiran';

  @override
  String get repetitionPenalty => 'Penalti Pengulangan';

  @override
  String get streamingEnabled => 'Penstriman Diaktifkan';

  @override
  String get testConnection => 'Uji Sambungan';

  @override
  String get connectionSuccessful => 'Sambungan berjaya!';

  @override
  String connectionFailed(String error) {
    return 'Sambungan gagal: $error';
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
  String get local => 'Tempatan';

  @override
  String get aiPresets => 'Pratetap AI';

  @override
  String get createPreset => 'Cipta Pratetap';

  @override
  String get editPreset => 'Edit Pratetap';

  @override
  String get deletePreset => 'Padam Pratetap';

  @override
  String get presetName => 'Nama Pratetap';

  @override
  String get promptManager => 'Pengurus Prompt';

  @override
  String get systemPrompt => 'Prompt Sistem';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Info Dunia';

  @override
  String get createEntry => 'Cipta Entri';

  @override
  String get editEntry => 'Edit Entri';

  @override
  String get deleteEntry => 'Padam Entri';

  @override
  String get keywords => 'Kata Kunci';

  @override
  String get content => 'Kandungan';

  @override
  String get priority => 'Keutamaan';

  @override
  String get groups => 'Kumpulan';

  @override
  String get createGroup => 'Cipta Kumpulan';

  @override
  String get editGroup => 'Edit Kumpulan';

  @override
  String get deleteGroup => 'Padam Kumpulan';

  @override
  String get groupName => 'Nama Kumpulan';

  @override
  String get members => 'Ahli';

  @override
  String get addMember => 'Tambah Ahli';

  @override
  String get removeMember => 'Buang Ahli';

  @override
  String get tags => 'Tag';

  @override
  String get createTag => 'Cipta Tag';

  @override
  String get editTag => 'Edit Tag';

  @override
  String get deleteTag => 'Padam Tag';

  @override
  String get tagName => 'Nama Tag';

  @override
  String get color => 'Warna';

  @override
  String get quickReplies => 'Balasan Pantas';

  @override
  String get createQuickReply => 'Cipta Balasan Pantas';

  @override
  String get editQuickReply => 'Edit Balasan Pantas';

  @override
  String get deleteQuickReply => 'Padam Balasan Pantas';

  @override
  String get label => 'Label';

  @override
  String get message => 'Mesej';

  @override
  String get autoSend => 'Hantar Auto';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Cipta regex';

  @override
  String get editRegex => 'Edit regex';

  @override
  String get deleteRegex => 'Padam regex';

  @override
  String get pattern => 'Corak';

  @override
  String get replacement => 'Penggantian';

  @override
  String get backup => 'Sandaran';

  @override
  String get createBackup => 'Cipta Sandaran';

  @override
  String get restoreBackup => 'Pulihkan Sandaran';

  @override
  String get backupCreated => 'Sandaran berjaya dicipta';

  @override
  String get backupRestored => 'Sandaran berjaya dipulihkan';

  @override
  String backupFailed(String error) {
    return 'Sandaran gagal: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Pemulihan gagal: $error';
  }

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Mod Gelap';

  @override
  String get lightMode => 'Mod Cerah';

  @override
  String get systemTheme => 'Ikut Sistem';

  @override
  String get primaryColor => 'Warna Utama';

  @override
  String get accentColor => 'Warna Aksen';

  @override
  String get advanced => 'Lanjutan';

  @override
  String get advancedSettings => 'Tetapan Lanjutan';

  @override
  String get statistics => 'Statistik';

  @override
  String get totalChats => 'Jumlah Sembang';

  @override
  String get totalMessages => 'Jumlah Mesej';

  @override
  String get totalCharacters => 'Jumlah Watak';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Teks-ke-Pertuturan';

  @override
  String get stt => 'Pertuturan-ke-Teks';

  @override
  String get translation => 'Terjemahan';

  @override
  String get imageGeneration => 'Penjanaan Imej';

  @override
  String get vectorStorage => 'Storan Vektor';

  @override
  String get sprites => 'Sprite';

  @override
  String get backgrounds => 'Latar Belakang';

  @override
  String get cfgScale => 'Skala CFG';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Pembolehubah';

  @override
  String get listView => 'Paparan Senarai';

  @override
  String get gridView => 'Paparan Grid';

  @override
  String get search => 'Cari';

  @override
  String get searchCharacters => 'Cari watak...';

  @override
  String get noCharactersFound => 'Tiada watak dijumpai';

  @override
  String get noCharactersYet => 'Tiada watak lagi';

  @override
  String get importCharacter => 'Import watak untuk bermula';

  @override
  String get createCharacter => 'Cipta Watak';

  @override
  String get editCharacter => 'Edit Watak';

  @override
  String get deleteCharacter => 'Padam Watak';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Adakah anda pasti mahu memadamkan \"$name\"? Semua sembang dengan watak ini juga akan dipadamkan.';
  }

  @override
  String get characterDeleted => 'Watak dipadamkan';

  @override
  String get startChat => 'Mulakan Sembang';

  @override
  String get personality => 'Personaliti';

  @override
  String get scenario => 'Senario';

  @override
  String get firstMessage => 'Mesej Pertama';

  @override
  String get exampleDialogue => 'Dialog Contoh';

  @override
  String get creatorNotes => 'Nota Pencipta';

  @override
  String get alternateGreetings => 'Salam Alternatif';

  @override
  String get characterBook => 'Buku Watak';

  @override
  String get language => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get languageChanged => 'Bahasa ditukar';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi';

  @override
  String get licenses => 'Lesen';

  @override
  String get privacyPolicy => 'Dasar Privasi';

  @override
  String get termsOfService => 'Terma Perkhidmatan';

  @override
  String get feedback => 'Maklum Balas';

  @override
  String get rateApp => 'Nilai Aplikasi';

  @override
  String get shareApp => 'Kongsi Aplikasi';

  @override
  String get checkForUpdates => 'Semak Kemas Kini';

  @override
  String get noUpdatesAvailable => 'Tiada kemas kini tersedia';

  @override
  String get updateAvailable => 'Kemas kini tersedia';

  @override
  String get downloadUpdate => 'Muat Turun Kemas Kini';

  @override
  String get bookmarkCreated => 'Penanda buku dicipta';

  @override
  String get bookmarkName => 'Nama Penanda Buku';

  @override
  String get enterBookmarkName => 'Masukkan nama penanda buku';

  @override
  String get noBookmarksYet => 'Tiada penanda buku lagi';

  @override
  String get createBookmarkDescription =>
      'Cipta penanda buku untuk menyimpan titik penting dalam perbualan';

  @override
  String get jumpToBookmark => 'Lompat ke Penanda Buku';

  @override
  String get deleteBookmark => 'Padam Penanda Buku';

  @override
  String get bookmarkDeleted => 'Penanda buku dipadamkan';

  @override
  String get saveAsJsonl => 'Simpan sebagai JSONL';

  @override
  String get saveAsJson => 'Simpan sebagai JSON';

  @override
  String get keyboardShortcuts => 'Pintasan papan kekunci:';

  @override
  String get bold => 'Tebal';

  @override
  String get italic => 'Italik';

  @override
  String get underline => 'Garis Bawah';

  @override
  String get strikethrough => 'Garis Potong';

  @override
  String get inlineCode => 'Kod Sebaris';

  @override
  String get link => 'Pautan';

  @override
  String get slashCommands => 'Arahan Slash';

  @override
  String get availableCommands => 'Arahan yang tersedia:';

  @override
  String get commandHelp => 'Taip / untuk melihat arahan yang tersedia';
}
