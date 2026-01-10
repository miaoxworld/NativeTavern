// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Beranda';

  @override
  String get characters => 'Karakter';

  @override
  String get settings => 'Pengaturan';

  @override
  String get chats => 'Obrolan';

  @override
  String get newChat => 'Obrolan Baru';

  @override
  String get noChatsYet => 'Belum ada obrolan';

  @override
  String get startNewConversation => 'Mulai percakapan dengan karakter';

  @override
  String get browseCharacters => 'Jelajahi Karakter';

  @override
  String get groupChats => 'Obrolan Grup';

  @override
  String get import => 'Impor';

  @override
  String get delete => 'Hapus';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get edit => 'Edit';

  @override
  String get copy => 'Salin';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get close => 'Tutup';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get loading => 'Memuat...';

  @override
  String get error => 'Kesalahan';

  @override
  String errorLoadingChats(String error) {
    return 'Kesalahan memuat obrolan: $error';
  }

  @override
  String get deleteChat => 'Hapus Obrolan';

  @override
  String get deleteChatConfirmation =>
      'Apakah Anda yakin ingin menghapus obrolan ini? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get chatDeleted => 'Obrolan dihapus';

  @override
  String get yesterday => 'Kemarin';

  @override
  String daysAgo(int count) {
    return '$count hari yang lalu';
  }

  @override
  String get noMessages => 'Tidak ada pesan';

  @override
  String get noMessagesYet => 'Belum ada pesan';

  @override
  String get chat => 'Obrolan';

  @override
  String get typeMessage => 'Ketik pesan...';

  @override
  String get send => 'Kirim';

  @override
  String get regenerate => 'Regenerasi';

  @override
  String get continueGeneration => 'Lanjutkan';

  @override
  String get viewCharacter => 'Lihat Karakter';

  @override
  String get authorsNote => 'Catatan Penulis';

  @override
  String get bookmarks => 'Penanda';

  @override
  String get exportChat => 'Ekspor Obrolan';

  @override
  String get importChat => 'Impor Obrolan';

  @override
  String get clearMessages => 'Hapus Pesan';

  @override
  String get selectModel => 'Pilih Model';

  @override
  String get loadingModels => 'Memuat model...';

  @override
  String get noModelsAvailable =>
      'Tidak ada model tersedia. Periksa pengaturan API Anda.';

  @override
  String modelChangedTo(String model) {
    return 'Model diubah ke $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Gagal memuat model: $error';
  }

  @override
  String get searchModels => 'Cari model...';

  @override
  String get noModelsMatchSearch => 'Tidak ada model yang cocok';

  @override
  String get provider => 'Penyedia';

  @override
  String get apiNotConfigured => 'API Belum Dikonfigurasi';

  @override
  String get apiNotConfiguredMessage =>
      'Untuk mengobrol dengan karakter, Anda perlu mengonfigurasi penyedia LLM terlebih dahulu.';

  @override
  String get supportedProviders => 'Penyedia yang didukung:';

  @override
  String get configureNow => 'Konfigurasi Sekarang';

  @override
  String get later => 'Nanti';

  @override
  String get configure => 'Konfigurasi';

  @override
  String get configureApiProvider =>
      'Konfigurasi penyedia LLM untuk mulai mengobrol';

  @override
  String get startConversation => 'Mulai Percakapan';

  @override
  String get deleteMessage => 'Hapus Pesan';

  @override
  String get deleteMessageConfirmation =>
      'Apakah Anda yakin ingin menghapus pesan ini?';

  @override
  String get deleteMessages => 'Hapus Pesan';

  @override
  String get deleteMessagesConfirmation =>
      'Apakah Anda yakin ingin menghapus pesan ini dan semua pesan setelahnya?';

  @override
  String get deleteAll => 'Hapus Semua';

  @override
  String get copiedToClipboard => 'Disalin ke clipboard';

  @override
  String get generateNewResponse => 'Buat respons baru';

  @override
  String get continueFromHere => 'Lanjutkan dari sini';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Hapus pesan setelah ini dan regenerasi';

  @override
  String get deleteMessagesAfterThis => 'Hapus semua pesan setelah ini';

  @override
  String get createBookmark => 'Buat Penanda';

  @override
  String get saveAsCheckpoint => 'Simpan titik ini sebagai checkpoint';

  @override
  String get deleteThisMessage => 'Hapus pesan ini';

  @override
  String get deleteThisAndAllAfter => 'Hapus ini dan semua setelahnya';

  @override
  String get attachImage => 'Lampirkan Gambar';

  @override
  String get chooseFromGallery => 'Pilih dari Galeri';

  @override
  String get takePhoto => 'Ambil Foto';

  @override
  String failedToPickImage(String error) {
    return 'Gagal memilih gambar: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Gagal mengambil foto: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Gagal menambahkan lampiran: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Ekspor obrolan dengan $character';
  }

  @override
  String messagesCount(int count) {
    return '$count pesan';
  }

  @override
  String get chooseExportFormat => 'Pilih format ekspor:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (format ST)';

  @override
  String get noChatToExport => 'Tidak ada obrolan untuk diekspor';

  @override
  String exportFailed(String error) {
    return 'Ekspor gagal: $error';
  }

  @override
  String get importChatHistory => 'Impor riwayat obrolan dari file';

  @override
  String get supportedFormats => 'Format yang didukung:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (format SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (format NativeTavern)';

  @override
  String get importNote =>
      'Catatan: Pesan yang diimpor akan ditambahkan ke obrolan saat ini.';

  @override
  String get chooseFile => 'Pilih File';

  @override
  String get noFileSelected =>
      'Tidak ada file yang dipilih atau format tidak valid';

  @override
  String get importConfirmation => 'Konfirmasi Impor';

  @override
  String get character => 'Karakter';

  @override
  String get user => 'Pengguna';

  @override
  String get messages => 'Pesan';

  @override
  String get date => 'Tanggal';

  @override
  String get hasAuthorsNote => 'Memiliki catatan penulis';

  @override
  String get importMessagesToCurrentChat =>
      'Impor pesan-pesan ini ke obrolan saat ini?';

  @override
  String get noActiveChat => 'Tidak ada obrolan aktif';

  @override
  String importedMessages(int count) {
    return 'Berhasil mengimpor $count pesan';
  }

  @override
  String importFailed(String error) {
    return 'Impor gagal: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Apakah Anda yakin ingin menghapus semua pesan? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get clear => 'Hapus';

  @override
  String get thinking => 'Berpikir';

  @override
  String get noSwipesAvailable => 'Tidak ada swipe tersedia';

  @override
  String get system => 'Sistem';

  @override
  String get backgroundFeatureComingSoon => 'Fitur latar belakang segera hadir';

  @override
  String get authorsNoteUpdated => 'Catatan penulis diperbarui';

  @override
  String get commandError => 'Kesalahan perintah';

  @override
  String get enabled => 'Diaktifkan';

  @override
  String get disabled => 'Dinonaktifkan';

  @override
  String get personas => 'Persona';

  @override
  String get createPersona => 'Buat Persona';

  @override
  String get editPersona => 'Edit Persona';

  @override
  String get deletePersona => 'Hapus Persona';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Apakah Anda yakin ingin menghapus \"$name\"?';
  }

  @override
  String get noPersonasYet => 'Belum ada persona';

  @override
  String get createPersonaDescription =>
      'Buat persona untuk mewakili diri Anda dalam obrolan';

  @override
  String get name => 'Nama';

  @override
  String get enterPersonaName => 'Masukkan nama persona';

  @override
  String get description => 'Deskripsi';

  @override
  String get describePersona => 'Deskripsikan persona ini (opsional)';

  @override
  String get personaDescriptionHelp =>
      'Deskripsi akan disertakan dalam prompt sistem untuk membantu AI memahami siapa Anda.';

  @override
  String get pleaseEnterName => 'Silakan masukkan nama';

  @override
  String get default_ => 'Default';

  @override
  String get active => 'Aktif';

  @override
  String get setAsDefault => 'Atur sebagai Default';

  @override
  String get removeAvatar => 'Hapus Avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Gagal menyimpan avatar: $error';
  }

  @override
  String get selectAvatarImage => 'Pilih gambar avatar';

  @override
  String get aiConfiguration => 'Konfigurasi AI';

  @override
  String get llmProvider => 'Penyedia LLM';

  @override
  String get apiUrl => 'URL API';

  @override
  String get apiKey => 'Kunci API';

  @override
  String get model => 'Model';

  @override
  String get temperature => 'Temperatur';

  @override
  String get maxTokens => 'Token Maksimum';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Penalti Frekuensi';

  @override
  String get presencePenalty => 'Penalti Kehadiran';

  @override
  String get repetitionPenalty => 'Penalti Pengulangan';

  @override
  String get streamingEnabled => 'Streaming Diaktifkan';

  @override
  String get testConnection => 'Tes Koneksi';

  @override
  String get connectionSuccessful => 'Koneksi berhasil!';

  @override
  String connectionFailed(String error) {
    return 'Koneksi gagal: $error';
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
  String get aiPresets => 'Preset AI';

  @override
  String get createPreset => 'Buat Preset';

  @override
  String get editPreset => 'Edit Preset';

  @override
  String get deletePreset => 'Hapus Preset';

  @override
  String get presetName => 'Nama Preset';

  @override
  String get promptManager => 'Manajer Prompt';

  @override
  String get systemPrompt => 'Prompt Sistem';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Info Dunia';

  @override
  String get createEntry => 'Buat Entri';

  @override
  String get editEntry => 'Edit Entri';

  @override
  String get deleteEntry => 'Hapus Entri';

  @override
  String get keywords => 'Kata Kunci';

  @override
  String get content => 'Konten';

  @override
  String get priority => 'Prioritas';

  @override
  String get groups => 'Grup';

  @override
  String get createGroup => 'Buat Grup';

  @override
  String get editGroup => 'Edit Grup';

  @override
  String get deleteGroup => 'Hapus Grup';

  @override
  String get groupName => 'Nama Grup';

  @override
  String get members => 'Anggota';

  @override
  String get addMember => 'Tambah Anggota';

  @override
  String get removeMember => 'Hapus Anggota';

  @override
  String get tags => 'Tag';

  @override
  String get createTag => 'Buat Tag';

  @override
  String get editTag => 'Edit Tag';

  @override
  String get deleteTag => 'Hapus Tag';

  @override
  String get tagName => 'Nama Tag';

  @override
  String get color => 'Warna';

  @override
  String get quickReplies => 'Balasan Cepat';

  @override
  String get createQuickReply => 'Buat Balasan Cepat';

  @override
  String get editQuickReply => 'Edit Balasan Cepat';

  @override
  String get deleteQuickReply => 'Hapus Balasan Cepat';

  @override
  String get label => 'Label';

  @override
  String get message => 'Pesan';

  @override
  String get autoSend => 'Kirim Otomatis';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Buat regex';

  @override
  String get editRegex => 'Edit regex';

  @override
  String get deleteRegex => 'Hapus regex';

  @override
  String get pattern => 'Pola';

  @override
  String get replacement => 'Pengganti';

  @override
  String get backup => 'Cadangan';

  @override
  String get createBackup => 'Buat Cadangan';

  @override
  String get restoreBackup => 'Pulihkan Cadangan';

  @override
  String get backupCreated => 'Cadangan berhasil dibuat';

  @override
  String get backupRestored => 'Cadangan berhasil dipulihkan';

  @override
  String backupFailed(String error) {
    return 'Pencadangan gagal: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Pemulihan gagal: $error';
  }

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get lightMode => 'Mode Terang';

  @override
  String get systemTheme => 'Ikuti Sistem';

  @override
  String get primaryColor => 'Warna Utama';

  @override
  String get accentColor => 'Warna Aksen';

  @override
  String get advanced => 'Lanjutan';

  @override
  String get advancedSettings => 'Pengaturan Lanjutan';

  @override
  String get statistics => 'Statistik';

  @override
  String get totalChats => 'Total Obrolan';

  @override
  String get totalMessages => 'Total Pesan';

  @override
  String get totalCharacters => 'Total Karakter';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get stt => 'Speech-to-Text';

  @override
  String get translation => 'Terjemahan';

  @override
  String get imageGeneration => 'Pembuatan Gambar';

  @override
  String get vectorStorage => 'Penyimpanan Vektor';

  @override
  String get sprites => 'Sprite';

  @override
  String get backgrounds => 'Latar Belakang';

  @override
  String get cfgScale => 'Skala CFG';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Variabel';

  @override
  String get listView => 'Tampilan Daftar';

  @override
  String get gridView => 'Tampilan Grid';

  @override
  String get search => 'Cari';

  @override
  String get searchCharacters => 'Cari karakter...';

  @override
  String get noCharactersFound => 'Tidak ada karakter ditemukan';

  @override
  String get noCharactersYet => 'Belum ada karakter';

  @override
  String get importCharacter => 'Impor karakter untuk memulai';

  @override
  String get createCharacter => 'Buat Karakter';

  @override
  String get editCharacter => 'Edit Karakter';

  @override
  String get deleteCharacter => 'Hapus Karakter';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Apakah Anda yakin ingin menghapus \"$name\"? Semua obrolan dengan karakter ini juga akan dihapus.';
  }

  @override
  String get characterDeleted => 'Karakter dihapus';

  @override
  String get startChat => 'Mulai Obrolan';

  @override
  String get personality => 'Kepribadian';

  @override
  String get scenario => 'Skenario';

  @override
  String get firstMessage => 'Pesan Pertama';

  @override
  String get exampleDialogue => 'Dialog Contoh';

  @override
  String get creatorNotes => 'Catatan Pembuat';

  @override
  String get alternateGreetings => 'Salam Alternatif';

  @override
  String get characterBook => 'Buku Karakter';

  @override
  String get language => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get languageChanged => 'Bahasa diubah';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi';

  @override
  String get licenses => 'Lisensi';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get termsOfService => 'Ketentuan Layanan';

  @override
  String get feedback => 'Umpan Balik';

  @override
  String get rateApp => 'Beri Rating Aplikasi';

  @override
  String get shareApp => 'Bagikan Aplikasi';

  @override
  String get checkForUpdates => 'Periksa Pembaruan';

  @override
  String get noUpdatesAvailable => 'Tidak ada pembaruan tersedia';

  @override
  String get updateAvailable => 'Pembaruan tersedia';

  @override
  String get downloadUpdate => 'Unduh Pembaruan';

  @override
  String get bookmarkCreated => 'Penanda dibuat';

  @override
  String get bookmarkName => 'Nama Penanda';

  @override
  String get enterBookmarkName => 'Masukkan nama penanda';

  @override
  String get noBookmarksYet => 'Belum ada penanda';

  @override
  String get createBookmarkDescription =>
      'Buat penanda untuk menyimpan titik penting dalam percakapan';

  @override
  String get jumpToBookmark => 'Lompat ke Penanda';

  @override
  String get deleteBookmark => 'Hapus Penanda';

  @override
  String get bookmarkDeleted => 'Penanda dihapus';

  @override
  String get saveAsJsonl => 'Simpan sebagai JSONL';

  @override
  String get saveAsJson => 'Simpan sebagai JSON';

  @override
  String get keyboardShortcuts => 'Pintasan keyboard:';

  @override
  String get bold => 'Tebal';

  @override
  String get italic => 'Miring';

  @override
  String get underline => 'Garis Bawah';

  @override
  String get strikethrough => 'Coret';

  @override
  String get inlineCode => 'Kode Inline';

  @override
  String get link => 'Tautan';

  @override
  String get slashCommands => 'Perintah Slash';

  @override
  String get availableCommands => 'Perintah yang tersedia:';

  @override
  String get commandHelp => 'Ketik / untuk melihat perintah yang tersedia';
}
