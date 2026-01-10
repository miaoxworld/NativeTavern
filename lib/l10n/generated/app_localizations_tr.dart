// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get characters => 'Karakterler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get chats => 'Sohbetler';

  @override
  String get newChat => 'Yeni Sohbet';

  @override
  String get noChatsYet => 'Henüz sohbet yok';

  @override
  String get startNewConversation => 'Bir karakterle sohbet başlat';

  @override
  String get browseCharacters => 'Karakterlere Göz At';

  @override
  String get groupChats => 'Grup Sohbetleri';

  @override
  String get import => 'İçe Aktar';

  @override
  String get delete => 'Sil';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get edit => 'Düzenle';

  @override
  String get copy => 'Kopyala';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get close => 'Kapat';

  @override
  String get ok => 'Tamam';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String errorLoadingChats(String error) {
    return 'Sohbetler yüklenirken hata: $error';
  }

  @override
  String get deleteChat => 'Sohbeti Sil';

  @override
  String get deleteChatConfirmation =>
      'Bu sohbeti silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get chatDeleted => 'Sohbet silindi';

  @override
  String get yesterday => 'Dün';

  @override
  String daysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String get noMessages => 'Mesaj yok';

  @override
  String get noMessagesYet => 'Henüz mesaj yok';

  @override
  String get chat => 'Sohbet';

  @override
  String get typeMessage => 'Mesaj yazın...';

  @override
  String get send => 'Gönder';

  @override
  String get regenerate => 'Yeniden Oluştur';

  @override
  String get continueGeneration => 'Devam Et';

  @override
  String get viewCharacter => 'Karakteri Görüntüle';

  @override
  String get authorsNote => 'Yazar Notu';

  @override
  String get bookmarks => 'Yer İmleri';

  @override
  String get exportChat => 'Sohbeti Dışa Aktar';

  @override
  String get importChat => 'Sohbeti İçe Aktar';

  @override
  String get clearMessages => 'Mesajları Temizle';

  @override
  String get selectModel => 'Model Seç';

  @override
  String get loadingModels => 'Modeller yükleniyor...';

  @override
  String get noModelsAvailable =>
      'Kullanılabilir model yok. API ayarlarınızı kontrol edin.';

  @override
  String modelChangedTo(String model) {
    return 'Model $model olarak değiştirildi';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Modeller yüklenemedi: $error';
  }

  @override
  String get searchModels => 'Model ara...';

  @override
  String get noModelsMatchSearch => 'Eşleşen model yok';

  @override
  String get provider => 'Sağlayıcı';

  @override
  String get apiNotConfigured => 'API Yapılandırılmadı';

  @override
  String get apiNotConfiguredMessage =>
      'Karakterlerle sohbet etmek için önce bir LLM sağlayıcısı yapılandırmanız gerekiyor.';

  @override
  String get supportedProviders => 'Desteklenen sağlayıcılar:';

  @override
  String get configureNow => 'Şimdi Yapılandır';

  @override
  String get later => 'Sonra';

  @override
  String get configure => 'Yapılandır';

  @override
  String get configureApiProvider =>
      'Sohbete başlamak için LLM sağlayıcısını yapılandırın';

  @override
  String get startConversation => 'Sohbet Başlat';

  @override
  String get deleteMessage => 'Mesajı Sil';

  @override
  String get deleteMessageConfirmation =>
      'Bu mesajı silmek istediğinizden emin misiniz?';

  @override
  String get deleteMessages => 'Mesajları Sil';

  @override
  String get deleteMessagesConfirmation =>
      'Bu mesajı ve sonrasındaki tüm mesajları silmek istediğinizden emin misiniz?';

  @override
  String get deleteAll => 'Tümünü Sil';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get generateNewResponse => 'Yeni yanıt oluştur';

  @override
  String get continueFromHere => 'Buradan devam et';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Sonraki mesajları sil ve yeniden oluştur';

  @override
  String get deleteMessagesAfterThis => 'Bundan sonraki tüm mesajları sil';

  @override
  String get createBookmark => 'Yer İmi Oluştur';

  @override
  String get saveAsCheckpoint => 'Bu noktayı kontrol noktası olarak kaydet';

  @override
  String get deleteThisMessage => 'Bu mesajı sil';

  @override
  String get deleteThisAndAllAfter => 'Bunu ve sonrasını sil';

  @override
  String get attachImage => 'Resim Ekle';

  @override
  String get chooseFromGallery => 'Galeriden Seç';

  @override
  String get takePhoto => 'Fotoğraf Çek';

  @override
  String failedToPickImage(String error) {
    return 'Resim seçilemedi: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Fotoğraf çekilemedi: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Ek eklenemedi: $error';
  }

  @override
  String exportChatWith(String character) {
    return '$character ile sohbeti dışa aktar';
  }

  @override
  String messagesCount(int count) {
    return '$count mesaj';
  }

  @override
  String get chooseExportFormat => 'Dışa aktarma formatını seçin:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST formatı)';

  @override
  String get noChatToExport => 'Dışa aktarılacak sohbet yok';

  @override
  String exportFailed(String error) {
    return 'Dışa aktarma başarısız: $error';
  }

  @override
  String get importChatHistory => 'Dosyadan sohbet geçmişini içe aktar';

  @override
  String get supportedFormats => 'Desteklenen formatlar:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern formatı)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern formatı)';

  @override
  String get importNote =>
      'Not: İçe aktarılan mesajlar mevcut sohbete eklenecektir.';

  @override
  String get chooseFile => 'Dosya Seç';

  @override
  String get noFileSelected => 'Dosya seçilmedi veya geçersiz format';

  @override
  String get importConfirmation => 'İçe Aktarma Onayı';

  @override
  String get character => 'Karakter';

  @override
  String get user => 'Kullanıcı';

  @override
  String get messages => 'Mesajlar';

  @override
  String get date => 'Tarih';

  @override
  String get hasAuthorsNote => 'Yazar notu var';

  @override
  String get importMessagesToCurrentChat =>
      'Bu mesajları mevcut sohbete içe aktar?';

  @override
  String get noActiveChat => 'Aktif sohbet yok';

  @override
  String importedMessages(int count) {
    return '$count mesaj başarıyla içe aktarıldı';
  }

  @override
  String importFailed(String error) {
    return 'İçe aktarma başarısız: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Tüm mesajları temizlemek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get clear => 'Temizle';

  @override
  String get thinking => 'Düşünüyor';

  @override
  String get noSwipesAvailable => 'Kaydırma mevcut değil';

  @override
  String get system => 'Sistem';

  @override
  String get backgroundFeatureComingSoon => 'Arka plan özelliği yakında';

  @override
  String get authorsNoteUpdated => 'Yazar notu güncellendi';

  @override
  String get commandError => 'Komut hatası';

  @override
  String get enabled => 'Etkin';

  @override
  String get disabled => 'Devre Dışı';

  @override
  String get personas => 'Personalar';

  @override
  String get createPersona => 'Persona Oluştur';

  @override
  String get editPersona => 'Personayı Düzenle';

  @override
  String get deletePersona => 'Personayı Sil';

  @override
  String deletePersonaConfirmation(String name) {
    return '\"$name\" personasını silmek istediğinizden emin misiniz?';
  }

  @override
  String get noPersonasYet => 'Henüz persona yok';

  @override
  String get createPersonaDescription =>
      'Sohbetlerde kendinizi temsil etmek için bir persona oluşturun';

  @override
  String get name => 'Ad';

  @override
  String get enterPersonaName => 'Persona adını girin';

  @override
  String get description => 'Açıklama';

  @override
  String get describePersona => 'Bu personayı tanımlayın (isteğe bağlı)';

  @override
  String get personaDescriptionHelp =>
      'Açıklama, AI\'ın sizi anlamasına yardımcı olmak için sistem istemine dahil edilecektir.';

  @override
  String get pleaseEnterName => 'Lütfen bir ad girin';

  @override
  String get default_ => 'Varsayılan';

  @override
  String get active => 'Aktif';

  @override
  String get setAsDefault => 'Varsayılan Olarak Ayarla';

  @override
  String get removeAvatar => 'Avatarı Kaldır';

  @override
  String failedToSaveAvatar(String error) {
    return 'Avatar kaydedilemedi: $error';
  }

  @override
  String get selectAvatarImage => 'Avatar resmi seçin';

  @override
  String get aiConfiguration => 'AI Yapılandırması';

  @override
  String get llmProvider => 'LLM Sağlayıcısı';

  @override
  String get apiUrl => 'API URL';

  @override
  String get apiKey => 'API Anahtarı';

  @override
  String get model => 'Model';

  @override
  String get temperature => 'Sıcaklık';

  @override
  String get maxTokens => 'Maksimum Token';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Frekans Cezası';

  @override
  String get presencePenalty => 'Varlık Cezası';

  @override
  String get repetitionPenalty => 'Tekrar Cezası';

  @override
  String get streamingEnabled => 'Akış Etkin';

  @override
  String get testConnection => 'Bağlantıyı Test Et';

  @override
  String get connectionSuccessful => 'Bağlantı başarılı!';

  @override
  String connectionFailed(String error) {
    return 'Bağlantı başarısız: $error';
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
  String get local => 'Yerel';

  @override
  String get aiPresets => 'AI Ön Ayarları';

  @override
  String get createPreset => 'Ön Ayar Oluştur';

  @override
  String get editPreset => 'Ön Ayarı Düzenle';

  @override
  String get deletePreset => 'Ön Ayarı Sil';

  @override
  String get presetName => 'Ön Ayar Adı';

  @override
  String get promptManager => 'İstem Yöneticisi';

  @override
  String get systemPrompt => 'Sistem İstemi';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Dünya Bilgisi';

  @override
  String get createEntry => 'Giriş Oluştur';

  @override
  String get editEntry => 'Girişi Düzenle';

  @override
  String get deleteEntry => 'Girişi Sil';

  @override
  String get keywords => 'Anahtar Kelimeler';

  @override
  String get content => 'İçerik';

  @override
  String get priority => 'Öncelik';

  @override
  String get groups => 'Gruplar';

  @override
  String get createGroup => 'Grup Oluştur';

  @override
  String get editGroup => 'Grubu Düzenle';

  @override
  String get deleteGroup => 'Grubu Sil';

  @override
  String get groupName => 'Grup Adı';

  @override
  String get members => 'Üyeler';

  @override
  String get addMember => 'Üye Ekle';

  @override
  String get removeMember => 'Üyeyi Kaldır';

  @override
  String get tags => 'Etiketler';

  @override
  String get createTag => 'Etiket Oluştur';

  @override
  String get editTag => 'Etiketi Düzenle';

  @override
  String get deleteTag => 'Etiketi Sil';

  @override
  String get tagName => 'Etiket Adı';

  @override
  String get color => 'Renk';

  @override
  String get quickReplies => 'Hızlı Yanıtlar';

  @override
  String get createQuickReply => 'Hızlı Yanıt Oluştur';

  @override
  String get editQuickReply => 'Hızlı Yanıtı Düzenle';

  @override
  String get deleteQuickReply => 'Hızlı Yanıtı Sil';

  @override
  String get label => 'Etiket';

  @override
  String get message => 'Mesaj';

  @override
  String get autoSend => 'Otomatik Gönder';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Regex oluştur';

  @override
  String get editRegex => 'Regex düzenle';

  @override
  String get deleteRegex => 'Regex sil';

  @override
  String get pattern => 'Desen';

  @override
  String get replacement => 'Değiştirme';

  @override
  String get backup => 'Yedekleme';

  @override
  String get createBackup => 'Yedek Oluştur';

  @override
  String get restoreBackup => 'Yedeği Geri Yükle';

  @override
  String get backupCreated => 'Yedek başarıyla oluşturuldu';

  @override
  String get backupRestored => 'Yedek başarıyla geri yüklendi';

  @override
  String backupFailed(String error) {
    return 'Yedekleme başarısız: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Geri yükleme başarısız: $error';
  }

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get lightMode => 'Aydınlık Mod';

  @override
  String get systemTheme => 'Sistemi Takip Et';

  @override
  String get primaryColor => 'Ana Renk';

  @override
  String get accentColor => 'Vurgu Rengi';

  @override
  String get advanced => 'Gelişmiş';

  @override
  String get advancedSettings => 'Gelişmiş Ayarlar';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get totalChats => 'Toplam Sohbet';

  @override
  String get totalMessages => 'Toplam Mesaj';

  @override
  String get totalCharacters => 'Toplam Karakter';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Metinden Sese';

  @override
  String get stt => 'Sesten Metne';

  @override
  String get translation => 'Çeviri';

  @override
  String get imageGeneration => 'Görüntü Oluşturma';

  @override
  String get vectorStorage => 'Vektör Depolama';

  @override
  String get sprites => 'Sprite\'lar';

  @override
  String get backgrounds => 'Arka Planlar';

  @override
  String get cfgScale => 'CFG Ölçeği';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Değişkenler';

  @override
  String get listView => 'Liste Görünümü';

  @override
  String get gridView => 'Izgara Görünümü';

  @override
  String get search => 'Ara';

  @override
  String get searchCharacters => 'Karakter ara...';

  @override
  String get noCharactersFound => 'Karakter bulunamadı';

  @override
  String get noCharactersYet => 'Henüz karakter yok';

  @override
  String get importCharacter => 'Başlamak için karakter içe aktarın';

  @override
  String get createCharacter => 'Karakter Oluştur';

  @override
  String get editCharacter => 'Karakteri Düzenle';

  @override
  String get deleteCharacter => 'Karakteri Sil';

  @override
  String deleteCharacterConfirmation(String name) {
    return '\"$name\" karakterini silmek istediğinizden emin misiniz? Bu karakterle yapılan tüm sohbetler de silinecektir.';
  }

  @override
  String get characterDeleted => 'Karakter silindi';

  @override
  String get startChat => 'Sohbet Başlat';

  @override
  String get personality => 'Kişilik';

  @override
  String get scenario => 'Senaryo';

  @override
  String get firstMessage => 'İlk Mesaj';

  @override
  String get exampleDialogue => 'Örnek Diyalog';

  @override
  String get creatorNotes => 'Oluşturucu Notları';

  @override
  String get alternateGreetings => 'Alternatif Selamlamalar';

  @override
  String get characterBook => 'Karakter Kitabı';

  @override
  String get language => 'Dil';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get languageChanged => 'Dil değiştirildi';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get licenses => 'Lisanslar';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get feedback => 'Geri Bildirim';

  @override
  String get rateApp => 'Uygulamayı Değerlendir';

  @override
  String get shareApp => 'Uygulamayı Paylaş';

  @override
  String get checkForUpdates => 'Güncellemeleri Kontrol Et';

  @override
  String get noUpdatesAvailable => 'Güncelleme mevcut değil';

  @override
  String get updateAvailable => 'Güncelleme mevcut';

  @override
  String get downloadUpdate => 'Güncellemeyi İndir';

  @override
  String get bookmarkCreated => 'Yer imi oluşturuldu';

  @override
  String get bookmarkName => 'Yer İmi Adı';

  @override
  String get enterBookmarkName => 'Yer imi adını girin';

  @override
  String get noBookmarksYet => 'Henüz yer imi yok';

  @override
  String get createBookmarkDescription =>
      'Konuşmadaki önemli noktaları kaydetmek için yer imi oluşturun';

  @override
  String get jumpToBookmark => 'Yer İmine Git';

  @override
  String get deleteBookmark => 'Yer İmini Sil';

  @override
  String get bookmarkDeleted => 'Yer imi silindi';

  @override
  String get saveAsJsonl => 'JSONL olarak kaydet';

  @override
  String get saveAsJson => 'JSON olarak kaydet';

  @override
  String get keyboardShortcuts => 'Klavye kısayolları:';

  @override
  String get bold => 'Kalın';

  @override
  String get italic => 'İtalik';

  @override
  String get underline => 'Altı Çizili';

  @override
  String get strikethrough => 'Üstü Çizili';

  @override
  String get inlineCode => 'Satır İçi Kod';

  @override
  String get link => 'Bağlantı';

  @override
  String get slashCommands => 'Eğik Çizgi Komutları';

  @override
  String get availableCommands => 'Kullanılabilir komutlar:';

  @override
  String get commandHelp => 'Kullanılabilir komutları görmek için / yazın';
}
