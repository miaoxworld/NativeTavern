// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'होम';

  @override
  String get characters => 'पात्र';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get chats => 'चैट';

  @override
  String get newChat => 'नई चैट';

  @override
  String get noChatsYet => 'अभी तक कोई चैट नहीं';

  @override
  String get startNewConversation => 'किसी पात्र के साथ बातचीत शुरू करें';

  @override
  String get browseCharacters => 'पात्र ब्राउज़ करें';

  @override
  String get groupChats => 'ग्रुप चैट';

  @override
  String get import => 'आयात करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get saveAs => 'Save As';

  @override
  String get edit => 'संपादित करें';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get close => 'बंद करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get yes => 'हां';

  @override
  String get no => 'नहीं';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String errorLoadingChats(String error) {
    return 'चैट लोड करने में त्रुटि: $error';
  }

  @override
  String get deleteChat => 'चैट हटाएं';

  @override
  String get deleteChatConfirmation =>
      'क्या आप वाकई इस चैट को हटाना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get chatDeleted => 'चैट हटा दी गई';

  @override
  String get yesterday => 'कल';

  @override
  String daysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String get noMessages => 'कोई संदेश नहीं';

  @override
  String get noMessagesYet => 'अभी तक कोई संदेश नहीं';

  @override
  String get chat => 'चैट';

  @override
  String get typeMessage => 'संदेश टाइप करें...';

  @override
  String get send => 'भेजें';

  @override
  String get regenerate => 'पुनः उत्पन्न करें';

  @override
  String get continueGeneration => 'जारी रखें';

  @override
  String get viewCharacter => 'पात्र देखें';

  @override
  String get authorsNote => 'लेखक का नोट';

  @override
  String get bookmarks => 'बुकमार्क';

  @override
  String get exportChat => 'चैट निर्यात करें';

  @override
  String get importChat => 'चैट आयात करें';

  @override
  String get clearMessages => 'संदेश साफ़ करें';

  @override
  String get selectModel => 'मॉडल चुनें';

  @override
  String get loadingModels => 'मॉडल लोड हो रहे हैं...';

  @override
  String get noModelsAvailable =>
      'कोई मॉडल उपलब्ध नहीं। API कॉन्फ़िगरेशन जांचें।';

  @override
  String modelChangedTo(String model) {
    return 'मॉडल $model में बदल गया';
  }

  @override
  String failedToLoadModels(String error) {
    return 'मॉडल लोड करने में विफल: $error';
  }

  @override
  String get searchModels => 'मॉडल खोजें...';

  @override
  String get noModelsMatchSearch => 'कोई मिलान मॉडल नहीं';

  @override
  String get provider => 'प्रदाता';

  @override
  String get apiNotConfigured => 'API कॉन्फ़िगर नहीं है';

  @override
  String get apiNotConfiguredMessage =>
      'पात्रों के साथ चैट करने के लिए, पहले LLM प्रदाता कॉन्फ़िगर करें।';

  @override
  String get supportedProviders => 'समर्थित प्रदाता:';

  @override
  String get configureNow => 'अभी कॉन्फ़िगर करें';

  @override
  String get later => 'बाद में';

  @override
  String get configure => 'कॉन्फ़िगर करें';

  @override
  String get configureApiProvider =>
      'चैट शुरू करने के लिए LLM प्रदाता कॉन्फ़िगर करें';

  @override
  String get startConversation => 'बातचीत शुरू करें';

  @override
  String get deleteMessage => 'संदेश हटाएं';

  @override
  String get deleteMessageConfirmation =>
      'क्या आप वाकई इस संदेश को हटाना चाहते हैं?';

  @override
  String get deleteMessages => 'संदेश हटाएं';

  @override
  String get deleteMessagesConfirmation =>
      'क्या आप वाकई इस संदेश और इसके बाद के सभी संदेशों को हटाना चाहते हैं?';

  @override
  String get deleteAll => 'सभी हटाएं';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get generateNewResponse => 'नया उत्तर उत्पन्न करें';

  @override
  String get continueFromHere => 'यहां से जारी रखें';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'बाद के संदेश हटाएं और उत्तर पुनः उत्पन्न करें';

  @override
  String get deleteMessagesAfterThis => 'इसके बाद के सभी संदेश हटाएं';

  @override
  String get createBookmark => 'बुकमार्क बनाएं';

  @override
  String get saveAsCheckpoint => 'इस बिंदु को चेकपॉइंट के रूप में सहेजें';

  @override
  String get deleteThisMessage => 'यह संदेश हटाएं';

  @override
  String get deleteThisAndAllAfter => 'यह और इसके बाद के सभी हटाएं';

  @override
  String get attachImage => 'छवि संलग्न करें';

  @override
  String get formatting => 'Formatting';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String failedToPickImage(String error) {
    return 'छवि चुनने में विफल: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'फोटो लेने में विफल: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'अटैचमेंट जोड़ने में विफल: $error';
  }

  @override
  String exportChatWith(String character) {
    return '$character के साथ चैट निर्यात करें';
  }

  @override
  String messagesCount(int count) {
    return '$count संदेश';
  }

  @override
  String get chooseExportFormat => 'निर्यात प्रारूप चुनें:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST प्रारूप)';

  @override
  String get noChatToExport => 'निर्यात करने के लिए कोई चैट नहीं';

  @override
  String exportFailed(String error) {
    return 'निर्यात विफल: $error';
  }

  @override
  String get importChatHistory => 'फ़ाइल से चैट इतिहास आयात करें।';

  @override
  String get supportedFormats => 'समर्थित प्रारूप:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern प्रारूप)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern प्रारूप)';

  @override
  String get importNote => 'नोट: आयातित संदेश वर्तमान चैट में जोड़े जाएंगे।';

  @override
  String get chooseFile => 'फ़ाइल चुनें';

  @override
  String get noFileSelected => 'कोई फ़ाइल नहीं चुनी गई या अमान्य प्रारूप';

  @override
  String get importConfirmation => 'आयात पुष्टि';

  @override
  String get character => 'पात्र';

  @override
  String get user => 'उपयोगकर्ता';

  @override
  String get messages => 'संदेश';

  @override
  String get date => 'तारीख';

  @override
  String get hasAuthorsNote => 'लेखक का नोट है';

  @override
  String get importMessagesToCurrentChat =>
      'इन संदेशों को वर्तमान चैट में आयात करें?';

  @override
  String get noActiveChat => 'कोई सक्रिय चैट नहीं';

  @override
  String importedMessages(int count) {
    return '$count संदेश आयातित';
  }

  @override
  String importFailed(String error) {
    return 'आयात विफल: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'क्या आप वाकई सभी संदेश साफ़ करना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get thinking => 'सोच रहा है';

  @override
  String get noSwipesAvailable => 'कोई स्वाइप उपलब्ध नहीं';

  @override
  String get system => 'सिस्टम';

  @override
  String get backgroundFeatureComingSoon => 'पृष्ठभूमि सुविधा जल्द आ रही है';

  @override
  String get authorsNoteUpdated => 'लेखक का नोट अपडेट किया गया';

  @override
  String get commandError => 'कमांड त्रुटि';

  @override
  String get enabled => 'सक्षम';

  @override
  String get disabled => 'अक्षम';

  @override
  String get personas => 'व्यक्तित्व';

  @override
  String get createPersona => 'व्यक्तित्व बनाएं';

  @override
  String get editPersona => 'व्यक्तित्व संपादित करें';

  @override
  String get deletePersona => 'व्यक्तित्व हटाएं';

  @override
  String deletePersonaConfirmation(String name) {
    return 'क्या आप वाकई \"$name\" को हटाना चाहते हैं?';
  }

  @override
  String get noPersonasYet => 'अभी तक कोई व्यक्तित्व नहीं';

  @override
  String get createPersonaDescription =>
      'चैट में खुद का प्रतिनिधित्व करने के लिए व्यक्तित्व बनाएं';

  @override
  String get name => 'नाम';

  @override
  String get enterPersonaName => 'व्यक्तित्व का नाम दर्ज करें';

  @override
  String get description => 'विवरण';

  @override
  String get describePersona => 'इस व्यक्तित्व का वर्णन करें (वैकल्पिक)';

  @override
  String get personaDescriptionHelp =>
      'विवरण सिस्टम प्रॉम्प्ट में शामिल किया जाएगा ताकि AI समझ सके कि आप कौन हैं।';

  @override
  String get pleaseEnterName => 'कृपया नाम दर्ज करें';

  @override
  String get default_ => 'डिफ़ॉल्ट';

  @override
  String get active => 'सक्रिय';

  @override
  String get setAsDefault => 'डिफ़ॉल्ट के रूप में सेट करें';

  @override
  String get removeAvatar => 'अवतार हटाएं';

  @override
  String failedToSaveAvatar(String error) {
    return 'अवतार सहेजने में विफल: $error';
  }

  @override
  String get selectAvatarImage => 'अवतार छवि चुनें';

  @override
  String get aiConfiguration => 'AI कॉन्फ़िगरेशन';

  @override
  String get llmProvider => 'LLM प्रदाता';

  @override
  String get apiUrl => 'API URL';

  @override
  String get apiKey => 'API कुंजी';

  @override
  String get model => 'मॉडल';

  @override
  String get temperature => 'तापमान';

  @override
  String get maxTokens => 'अधिकतम टोकन';

  @override
  String get contextLength => 'Context Length';

  @override
  String get contextWindowSize => 'Context Window Size';

  @override
  String get contextLengthDescription =>
      'Maximum number of tokens the model can process as input context.';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'आवृत्ति दंड';

  @override
  String get presencePenalty => 'उपस्थिति दंड';

  @override
  String get repetitionPenalty => 'पुनरावृत्ति दंड';

  @override
  String get streamingEnabled => 'स्ट्रीमिंग सक्षम';

  @override
  String get testConnection => 'कनेक्शन परीक्षण';

  @override
  String get connectionSuccessful => 'कनेक्शन सफल!';

  @override
  String connectionFailed(String error) {
    return 'कनेक्शन विफल: $error';
  }

  @override
  String get openai => 'OAI Compatible';

  @override
  String get claude => 'Claude';

  @override
  String get openRouter => 'OpenRouter';

  @override
  String get gemini => 'Gemini';

  @override
  String get ollama => 'Ollama';

  @override
  String get lmStudio => 'LM Studio';

  @override
  String get koboldCpp => 'KoboldCpp';

  @override
  String get xai => 'xAI (Grok)';

  @override
  String get local => 'स्थानीय';

  @override
  String get aiPresets => 'AI प्रीसेट';

  @override
  String get createPreset => 'प्रीसेट बनाएं';

  @override
  String get editPreset => 'प्रीसेट संपादित करें';

  @override
  String get deletePreset => 'प्रीसेट हटाएं';

  @override
  String get presetName => 'प्रीसेट नाम';

  @override
  String get promptManager => 'प्रॉम्प्ट प्रबंधक';

  @override
  String get systemPrompt => 'सिस्टम प्रॉम्प्ट';

  @override
  String get jailbreak => 'जेलब्रेक';

  @override
  String get worldInfo => 'विश्व जानकारी';

  @override
  String get createEntry => 'प्रविष्टि बनाएं';

  @override
  String get editEntry => 'प्रविष्टि संपादित करें';

  @override
  String get deleteEntry => 'प्रविष्टि हटाएं';

  @override
  String get keywords => 'कीवर्ड';

  @override
  String get content => 'सामग्री';

  @override
  String get priority => 'प्राथमिकता';

  @override
  String get groups => 'समूह';

  @override
  String get createGroup => 'समूह बनाएं';

  @override
  String get editGroup => 'समूह संपादित करें';

  @override
  String get deleteGroup => 'समूह हटाएं';

  @override
  String get groupName => 'समूह का नाम';

  @override
  String get members => 'सदस्य';

  @override
  String get addMember => 'सदस्य जोड़ें';

  @override
  String get removeMember => 'सदस्य हटाएं';

  @override
  String get tags => 'टैग';

  @override
  String get createTag => 'टैग बनाएं';

  @override
  String get editTag => 'टैग संपादित करें';

  @override
  String get deleteTag => 'टैग हटाएं';

  @override
  String get tagName => 'टैग नाम';

  @override
  String get color => 'रंग';

  @override
  String get quickReplies => 'त्वरित उत्तर';

  @override
  String get createQuickReply => 'त्वरित उत्तर बनाएं';

  @override
  String get editQuickReply => 'त्वरित उत्तर संपादित करें';

  @override
  String get deleteQuickReply => 'त्वरित उत्तर हटाएं';

  @override
  String get label => 'लेबल';

  @override
  String get message => 'संदेश';

  @override
  String get autoSend => 'स्वतः भेजें';

  @override
  String get regex => 'रेगेक्स';

  @override
  String get createRegex => 'रेगेक्स बनाएं';

  @override
  String get editRegex => 'रेगेक्स संपादित करें';

  @override
  String get deleteRegex => 'रेगेक्स हटाएं';

  @override
  String get pattern => 'पैटर्न';

  @override
  String get replacement => 'प्रतिस्थापन';

  @override
  String get backup => 'बैकअप';

  @override
  String get backupSubtitle => 'Local and cloud backup & restore';

  @override
  String get createBackup => 'बैकअप बनाएं';

  @override
  String get restoreBackup => 'बैकअप पुनर्स्थापित करें';

  @override
  String get backupCreated => 'बैकअप सफलतापूर्वक बनाया गया';

  @override
  String get backupRestored => 'बैकअप सफलतापूर्वक पुनर्स्थापित किया गया';

  @override
  String backupFailed(String error) {
    return 'बैकअप विफल: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'पुनर्स्थापना विफल: $error';
  }

  @override
  String get theme => 'थीम';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get lightMode => 'लाइट मोड';

  @override
  String get systemTheme => 'सिस्टम थीम';

  @override
  String get primaryColor => 'प्राथमिक रंग';

  @override
  String get accentColor => 'एक्सेंट रंग';

  @override
  String get advanced => 'उन्नत';

  @override
  String get advancedSettings => 'उन्नत सेटिंग्स';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get totalChats => 'कुल चैट';

  @override
  String get totalMessages => 'कुल संदेश';

  @override
  String get totalCharacters => 'कुल पात्र';

  @override
  String get tokenizer => 'टोकनाइज़र';

  @override
  String get tts => 'टेक्स्ट टू स्पीच';

  @override
  String get stt => 'स्पीच टू टेक्स्ट';

  @override
  String get translation => 'अनुवाद';

  @override
  String get imageGeneration => 'छवि निर्माण';

  @override
  String get vectorStorage => 'वेक्टर स्टोरेज';

  @override
  String get sprites => 'स्प्राइट्स';

  @override
  String get backgrounds => 'पृष्ठभूमि';

  @override
  String get cfgScale => 'CFG स्केल';

  @override
  String get logitBias => 'Logit बायस';

  @override
  String get variables => 'चर';

  @override
  String get listView => 'सूची दृश्य';

  @override
  String get gridView => 'ग्रिड दृश्य';

  @override
  String get search => 'खोजें';

  @override
  String get searchCharacters => 'पात्र खोजें...';

  @override
  String get noCharactersFound => 'कोई पात्र नहीं मिला';

  @override
  String get noCharactersYet => 'अभी तक कोई पात्र नहीं';

  @override
  String get importCharacter => 'शुरू करने के लिए पात्र आयात करें';

  @override
  String get createCharacter => 'पात्र बनाएं';

  @override
  String get editCharacter => 'पात्र संपादित करें';

  @override
  String get deleteCharacter => 'पात्र हटाएं';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'क्या आप वाकई \"$name\" को हटाना चाहते हैं? इस पात्र के साथ सभी चैट भी हटा दी जाएंगी।';
  }

  @override
  String get characterDeleted => 'पात्र हटा दिया गया';

  @override
  String get startChat => 'चैट शुरू करें';

  @override
  String get personality => 'व्यक्तित्व';

  @override
  String get scenario => 'परिदृश्य';

  @override
  String get firstMessage => 'पहला संदेश';

  @override
  String get exampleDialogue => 'उदाहरण संवाद';

  @override
  String get creatorNotes => 'निर्माता नोट्स';

  @override
  String get alternateGreetings => 'वैकल्पिक अभिवादन';

  @override
  String get characterBook => 'पात्र पुस्तक';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageChanged => 'भाषा बदल गई';

  @override
  String get about => 'के बारे में';

  @override
  String get version => 'संस्करण';

  @override
  String get licenses => 'लाइसेंस';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get feedback => 'प्रतिक्रिया';

  @override
  String get rateApp => 'ऐप रेट करें';

  @override
  String get shareApp => 'ऐप साझा करें';

  @override
  String get checkForUpdates => 'अपडेट जांचें';

  @override
  String get noUpdatesAvailable => 'कोई अपडेट उपलब्ध नहीं';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध';

  @override
  String get downloadUpdate => 'अपडेट डाउनलोड करें';

  @override
  String get bookmarkCreated => 'बुकमार्क बनाया गया';

  @override
  String get bookmarkName => 'बुकमार्क नाम';

  @override
  String get enterBookmarkName => 'बुकमार्क नाम दर्ज करें';

  @override
  String get noBookmarksYet => 'अभी तक कोई बुकमार्क नहीं';

  @override
  String get createBookmarkDescription =>
      'अपनी बातचीत में महत्वपूर्ण बिंदुओं को सहेजने के लिए बुकमार्क बनाएं';

  @override
  String get jumpToBookmark => 'बुकमार्क पर जाएं';

  @override
  String get deleteBookmark => 'बुकमार्क हटाएं';

  @override
  String get bookmarkDeleted => 'बुकमार्क हटा दिया गया';

  @override
  String get saveAsJsonl => 'JSONL के रूप में सहेजें';

  @override
  String get saveAsJson => 'JSON के रूप में सहेजें';

  @override
  String get keyboardShortcuts => 'कीबोर्ड शॉर्टकट:';

  @override
  String get bold => 'बोल्ड';

  @override
  String get italic => 'इटैलिक';

  @override
  String get underline => 'अंडरलाइन';

  @override
  String get strikethrough => 'स्ट्राइकथ्रू';

  @override
  String get inlineCode => 'इनलाइन कोड';

  @override
  String get link => 'लिंक';

  @override
  String get slashCommands => 'स्लैश कमांड';

  @override
  String get availableCommands => 'उपलब्ध कमांड:';

  @override
  String get commandHelp => 'उपलब्ध कमांड देखने के लिए / टाइप करें';

  @override
  String get characterNotFound => 'Character Not Found';

  @override
  String get characterNotFoundMessage => 'Character not found';

  @override
  String get exportAsPng => 'Export as PNG';

  @override
  String get exportAsCharx => 'Export as CharX';

  @override
  String get duplicate => 'Duplicate';

  @override
  String deleteCharacterConfirmationSimple(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String characterDuplicated(String name) {
    return '$name duplicated';
  }

  @override
  String failedToDelete(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String failedToDuplicate(String error) {
    return 'Failed to duplicate: $error';
  }

  @override
  String get pngExportComingSoon => 'PNG export coming soon';

  @override
  String get charxExportComingSoon => 'CharX export coming soon';

  @override
  String get failedToCreateChat => 'Failed to create chat';

  @override
  String get creating => 'Creating...';

  @override
  String byCreator(String creator) {
    return 'by $creator';
  }

  @override
  String versionLabel(String version) {
    return 'v$version';
  }

  @override
  String get showLess => 'Show less';

  @override
  String get showMore => 'Show more';

  @override
  String greetingNumber(int number) {
    return 'Greeting $number';
  }

  @override
  String alternateGreetingsCount(int count) {
    return 'Alternate Greetings ($count)';
  }

  @override
  String get embeddedLorebook => 'Embedded Lorebook';

  @override
  String entriesEnabled(int enabled, int total) {
    return '$enabled of $total entries enabled';
  }

  @override
  String andMoreEntries(int count) {
    return '... and $count more entries';
  }

  @override
  String get exampleMessages => 'Example Messages';

  @override
  String get postHistoryInstructions => 'Post-History Instructions';

  @override
  String get selectImages => 'Select Images';

  @override
  String get presetsAndTemplates => 'Presets & Templates';

  @override
  String get activePreset => 'Active Preset';

  @override
  String get change => 'Change';

  @override
  String get noPresetSelected => 'No preset selected';

  @override
  String get instructTemplate => 'Instruct Template';

  @override
  String get selectInstructTemplate => 'Select Instruct Template';

  @override
  String get instructTemplateDescription =>
      'Instruct templates format prompts for different LLM models. Use \"None\" for API providers such as OAI Compatible or Claude that handle formatting automatically.';

  @override
  String get orderAndTogglePromptSections => 'Order and toggle prompt sections';

  @override
  String get llmConnection => 'LLM Connection';

  @override
  String get generationSettings => 'Generation Settings';

  @override
  String get advancedSamplerSettings => 'Advanced Sampler Settings';

  @override
  String get fullControlOverSampling => 'Full control over sampling parameters';

  @override
  String get selectLlmProvider => 'Select LLM Provider';

  @override
  String get notSet => 'Not set';

  @override
  String get enterApiKey => 'Enter your API key';

  @override
  String get apiEndpointUrl => 'API endpoint URL';

  @override
  String get modelName => 'Model name';

  @override
  String get fetchAvailableModels => 'Fetch Available Models';

  @override
  String get fetchModelsDescription =>
      'Fetch models from the API or enter a model name manually';

  @override
  String get enterModelName => 'Enter Model Name';

  @override
  String get fetchingModels => 'Fetching models...';

  @override
  String get failedToFetchModels => 'Failed to fetch models';

  @override
  String get tapToTestConnection => 'Tap to test API connection';

  @override
  String get testing => 'Testing...';

  @override
  String get connected => 'Connected';

  @override
  String get connectionFailedSimple => 'Connection failed';

  @override
  String get maximumTokensToGenerate => 'Maximum tokens to generate';

  @override
  String get streaming => 'Streaming';

  @override
  String get showResponseAsItGenerates => 'Show response as it generates';

  @override
  String selectModelCount(int count) {
    return 'Select Model ($count)';
  }

  @override
  String get refreshModels => 'Refresh models';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get noModelsFound => 'No models found';

  @override
  String get tryDifferentSearchTerm => 'Try a different search term';

  @override
  String modelsOfTotal(int filtered, int total) {
    return '$filtered of $total models';
  }

  @override
  String get importPreset => 'Import Preset';

  @override
  String get noGroupChatsYet => 'No group chats yet';

  @override
  String get createGroupDescription =>
      'Create a group to chat with multiple characters';

  @override
  String get newGroup => 'New Group';

  @override
  String membersAndMode(int count, String mode) {
    return '$count members • $mode mode';
  }

  @override
  String get groupChatWillBeImplemented =>
      'Group chat will be implemented with chat integration';

  @override
  String deleteGroupConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"? This will also delete all associated chats.';
  }

  @override
  String groupDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get groupNameRequired => 'Group Name *';

  @override
  String get enterGroupName => 'Enter group name';

  @override
  String get optionalDescription => 'Optional description';

  @override
  String get selectCharacters => 'Select Characters';

  @override
  String get noCharactersAvailable => 'No characters available';

  @override
  String charactersSelected(int count) {
    return '$count character(s) selected';
  }

  @override
  String get create => 'Create';

  @override
  String get selectAtLeast2Characters => 'Select at least 2 characters';

  @override
  String get groupCreatedSuccessfully => 'Group created successfully';

  @override
  String failedToCreateGroup(String error) {
    return 'Failed to create group: $error';
  }

  @override
  String get selectCharacterCard => 'Select a character card';

  @override
  String get supportsPngCharxJson => 'Supports PNG, CharX, and JSON formats';

  @override
  String get browseFiles => 'Browse Files';

  @override
  String failedToPickFile(String error) {
    return 'Failed to pick file: $error';
  }

  @override
  String failedToLoadCharacter(String error) {
    return 'Failed to load character: $error';
  }

  @override
  String unsupportedFileFormat(String format) {
    return 'Unsupported file format: $format';
  }

  @override
  String get pngCharacterCard => 'PNG Character Card';

  @override
  String get characterDataEmbeddedInImage =>
      'Character data embedded in image metadata';

  @override
  String get charxArchive => 'CharX Archive';

  @override
  String get zipArchiveWithCharacterData =>
      'ZIP archive with character data and assets';

  @override
  String get plainCharacterCardJson => 'Plain character card JSON file';

  @override
  String importedWithLorebook(String name) {
    return 'Imported \"$name\" with embedded lorebook!';
  }

  @override
  String importedSuccessfully(String name) {
    return 'Imported \"$name\" successfully!';
  }

  @override
  String failedToImport(String error) {
    return 'Failed to import: $error';
  }

  @override
  String embeddedLorebookEntries(int count) {
    return 'Embedded Lorebook ($count entries)';
  }

  @override
  String get saveCurrentAsPreset => 'Save Current as Preset';

  @override
  String get exportCurrentSettings => 'Export Current Settings';

  @override
  String get builtInPresets => 'Built-in Presets';

  @override
  String get customPresets => 'Custom Presets';

  @override
  String get aiPresetsDescription =>
      'AI Presets combine generation settings, prompt ordering, and instruct templates. Select a preset to apply all settings at once.';

  @override
  String appliedPreset(String name) {
    return 'Applied \"$name\" preset';
  }

  @override
  String failedToApplyPreset(String error) {
    return 'Failed to apply preset: $error';
  }

  @override
  String get invalidPresetFormat =>
      'Invalid preset format. Expected preset with generation settings.';

  @override
  String importedAndApplied(String name) {
    return 'Imported and applied \"$name\"';
  }

  @override
  String get saveAsPreset => 'Save as Preset';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get pleaseEnterAName => 'Please enter a name';

  @override
  String savedPreset(String name) {
    return 'Saved \"$name\"';
  }

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String deletePresetConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String deletedPreset(String name) {
    return 'Deleted \"$name\"';
  }

  @override
  String get export => 'Export';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get basicSampling => 'Basic Sampling';

  @override
  String get temperatureDescription =>
      'Controls randomness. Higher = more creative, lower = more focused.';

  @override
  String get topPNucleusSampling => 'Top P (Nucleus Sampling)';

  @override
  String get topPDescription =>
      'Cumulative probability threshold for token selection.';

  @override
  String get topKDescription =>
      'Number of top tokens to consider. 0 = disabled.';

  @override
  String get advancedSampling => 'Advanced Sampling';

  @override
  String get minP => 'Min P';

  @override
  String get minPDescription =>
      'Minimum probability threshold relative to top token.';

  @override
  String get typicalP => 'Typical P';

  @override
  String get typicalPDescription => 'Locally typical sampling. 1.0 = disabled.';

  @override
  String get topA => 'Top A';

  @override
  String get topADescription => 'Top-A sampling threshold. 0 = disabled.';

  @override
  String get tailFreeSamplingTfs => 'Tail Free Sampling (TFS)';

  @override
  String get tfsDescription => 'Removes low-probability tail. 1.0 = disabled.';

  @override
  String get repetitionControl => 'Repetition Control';

  @override
  String get repetitionPenaltyDescription =>
      'Penalizes repeated tokens. 1.0 = no penalty.';

  @override
  String get repetitionPenaltyRange => 'Repetition Penalty Range';

  @override
  String get repetitionPenaltyRangeDescription =>
      'How many tokens to consider. 0 = all.';

  @override
  String get frequencyPenaltyDescription =>
      'Penalizes tokens based on frequency in text.';

  @override
  String get presencePenaltyDescription =>
      'Penalizes tokens that appear at all in text.';

  @override
  String get mirostatLocalModels => 'Mirostat (Local Models)';

  @override
  String get mirostatMode => 'Mirostat Mode';

  @override
  String get adaptiveSamplingForLocalModels =>
      'Adaptive sampling for local models';

  @override
  String get off => 'Off';

  @override
  String get mirostatTau => 'Mirostat Tau';

  @override
  String get mirostatTauDescription => 'Target entropy/perplexity.';

  @override
  String get mirostatEta => 'Mirostat Eta';

  @override
  String get mirostatEtaDescription => 'Learning rate for Mirostat.';

  @override
  String get generationControl => 'Generation Control';

  @override
  String get maxTokensDescription => 'Maximum tokens to generate.';

  @override
  String get seed => 'Seed';

  @override
  String get seedDescription => 'Random seed for reproducibility. -1 = random.';

  @override
  String get stopSequences => 'Stop Sequences';

  @override
  String get noStopSequencesConfigured => 'No stop sequences configured';

  @override
  String get stopSequencesDescription =>
      'Enter one sequence per line. Generation stops when any of these are produced.';

  @override
  String get resetConfirmation =>
      'This will reset all sampler settings to their default values. Continue?';

  @override
  String get reset => 'Reset';

  @override
  String get settingsResetToDefaults => 'Settings reset to defaults';

  @override
  String get characterBackground => 'Character Background';

  @override
  String get chatBackground => 'Chat Background';

  @override
  String get clearBackground => 'Clear background';

  @override
  String get gradientPresets => 'Gradient Presets';

  @override
  String get solidColors => 'Solid Colors';

  @override
  String get customImage => 'Custom Image';

  @override
  String get adjustments => 'Adjustments';

  @override
  String get noBackgroundSelected => 'No background selected';

  @override
  String get chooseImage => 'Choose Image';

  @override
  String get fromUrl => 'From URL';

  @override
  String localImage(String filename) {
    return 'Local image: $filename';
  }

  @override
  String urlLabel(String url) {
    return 'URL: $url';
  }

  @override
  String get noImage => 'No image';

  @override
  String get opacity => 'Opacity';

  @override
  String get blurEffect => 'Blur Effect';

  @override
  String get applyBlurToBackground => 'Apply blur to the background';

  @override
  String get blurAmount => 'Blur Amount';

  @override
  String failedToLoadImage(String error) {
    return 'Failed to load image: $error';
  }

  @override
  String get imageUrl => 'Image URL';

  @override
  String get enterImageUrl => 'Enter image URL';

  @override
  String get apply => 'Apply';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get refresh => 'Refresh';

  @override
  String get storage => 'Storage';

  @override
  String get totalBackupSize => 'Total Backup Size';

  @override
  String get calculating => 'Calculating...';

  @override
  String get lastAutoBackup => 'Last Auto-Backup';

  @override
  String get autoBackup => 'Auto-Backup';

  @override
  String get enableAutoBackup => 'Enable Auto-Backup';

  @override
  String get automaticallyBackupChats => 'Automatically backup chats';

  @override
  String get backupInterval => 'Backup Interval';

  @override
  String get backupOnExit => 'Backup on Exit';

  @override
  String get createBackupWhenClosingApp => 'Create backup when closing app';

  @override
  String get retention => 'Retention';

  @override
  String get maxChatBackups => 'Max Chat Backups';

  @override
  String keepUpToChatBackups(int count) {
    return 'Keep up to $count chat backups';
  }

  @override
  String get maxFullBackups => 'Max Full Backups';

  @override
  String keepUpToFullBackups(int count) {
    return 'Keep up to $count full backups';
  }

  @override
  String get cleanupOldBackups => 'Cleanup Old Backups';

  @override
  String get deleteBackupsExceedingLimits => 'Delete backups exceeding limits';

  @override
  String get cleanup => 'Cleanup';

  @override
  String deletedOldBackups(int count) {
    return 'Deleted $count old backups';
  }

  @override
  String get chatBackups => 'Chat Backups';

  @override
  String get noChatBackups => 'No chat backups';

  @override
  String viewAllBackups(int count) {
    return 'View all $count backups';
  }

  @override
  String get fullBackups => 'Full Backups';

  @override
  String get noFullBackups => 'No full backups';

  @override
  String get information => 'Information';

  @override
  String get aboutBackups => 'About Backups';

  @override
  String get aboutBackupsDescription =>
      'Chat backups save individual conversations. Full backups include all characters, chats, settings, and lorebooks.';

  @override
  String get backupLocation => 'Backup Location';

  @override
  String errorReadingBackup(String error) {
    return 'Error reading backup: $error';
  }

  @override
  String get deleteBackup => 'Delete Backup';

  @override
  String deleteBackupConfirmation(String name) {
    return 'Delete \"$name\"?\n\nThis cannot be undone.';
  }

  @override
  String get view => 'View';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get enableCfgScale => 'Enable CFG Scale';

  @override
  String get cfgScaleDescription =>
      'Classifier-Free Guidance for text generation';

  @override
  String get globalSettings => 'Global Settings';

  @override
  String get guidanceScale => 'Guidance Scale';

  @override
  String get negativePrompt => 'Negative Prompt';

  @override
  String get textToSteerAwayFrom => 'Text to steer the model away from';

  @override
  String get positivePromptOptional => 'Positive Prompt (Optional)';

  @override
  String get textToEnhanceInOutput => 'Text to enhance in the output';

  @override
  String get characterSettings => 'Character Settings';

  @override
  String get useCharacterSpecificSettings => 'Use Character-Specific Settings';

  @override
  String get overrideGlobalForCharacter =>
      'Override global settings for this character';

  @override
  String get characterNegativePrompt => 'Character Negative Prompt';

  @override
  String get overrideGlobalNegativePrompt => 'Override global negative prompt';

  @override
  String get chatSettings => 'Chat Settings';

  @override
  String get chatSettingsDescription =>
      'These settings override global and character settings for this chat only.';

  @override
  String get chatNegativePrompt => 'Chat Negative Prompt';

  @override
  String get overrideForThisChat => 'Override for this chat';

  @override
  String get chatPositivePrompt => 'Chat Positive Prompt';

  @override
  String get enhancementForThisChat => 'Enhancement for this chat';

  @override
  String get promptCombineMode => 'Prompt Combine Mode';

  @override
  String get replaceChatPromptOnly => 'Replace (use chat prompt only)';

  @override
  String get prependChatPlusGlobal => 'Prepend (chat + global)';

  @override
  String get appendGlobalPlusChat => 'Append (global + chat)';

  @override
  String get aboutCfgScale => 'About CFG Scale';

  @override
  String get aboutCfgScaleDescription =>
      'CFG (Classifier-Free Guidance) Scale controls how strongly the model follows the negative prompt to avoid certain content or styles.\n\n• Scale 1.0 = No effect (default)\n• Scale 1.5-3.0 = Subtle guidance\n• Scale 3.0-7.0 = Moderate guidance\n• Scale 7.0+ = Strong guidance (may affect coherence)';

  @override
  String get cfgScaleHelp => 'CFG Scale Help';

  @override
  String get cfgScaleHelpContent =>
      'Classifier-Free Guidance (CFG) Scale is a technique that allows you to guide the AI model\'s output by specifying what you want to avoid.\n\n**How it works:**\nThe model generates two outputs - one with your prompt and one with the negative prompt. The final output is adjusted to move away from the negative prompt direction.\n\n**Settings Priority:**\n1. Chat-specific settings (highest)\n2. Character-specific settings\n3. Global settings (lowest)\n\n**Tips:**\n• Start with low values (1.5-2.0) and increase gradually\n• Use specific negative prompts for better results\n• High values may cause repetition or incoherence\n• Not all AI backends support CFG Scale';

  @override
  String get help => 'Help';

  @override
  String get processing => 'Processing...';

  @override
  String get sampleMessage1 => 'Hello! How are you?';

  @override
  String get sampleMessage2 => 'I\'m doing great!';

  @override
  String get general => 'General';

  @override
  String get enableImageGeneration => 'Enable Image Generation';

  @override
  String get generateImagesUsingAi => 'Generate images using AI';

  @override
  String get imageGenerationProvider => 'Image Generation Provider';

  @override
  String get apiEndpoint => 'API Endpoint';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get defaultParameters => 'Default Parameters';

  @override
  String get imageSize => 'Image Size';

  @override
  String get steps => 'Steps';

  @override
  String get sampler => 'Sampler';

  @override
  String get defaultNegativePrompt => 'Default Negative Prompt';

  @override
  String get enterTermsToAvoid => 'Enter terms to avoid in generated images';

  @override
  String get test => 'Test';

  @override
  String get aboutImageGeneration => 'About Image Generation';

  @override
  String get aboutImageGenerationDescription =>
      'Generate images using AI models. Use the /imagine command in chat or generate character portraits from the character editor.';

  @override
  String get imagine => 'Imagine';

  @override
  String get fillImagePromptWithAi => 'Fill with AI';

  @override
  String get imagineCommand => '/imagine Command';

  @override
  String get imagineCommandUsage =>
      'Usage: /imagine <prompt> [--width N] [--height N] [--steps N] [--cfg N] [--seed N]';

  @override
  String get stableDiffusion => 'Stable Diffusion';

  @override
  String get stableDiffusionDescription =>
      'Connect to a local or remote Stable Diffusion WebUI instance. Requires the API to be enabled.';

  @override
  String get dalle => 'DALL-E';

  @override
  String get dalleDescription =>
      'DALL-E image generation through an OAI Compatible endpoint. Requires an API key.';

  @override
  String get prompt => 'Prompt';

  @override
  String get enterPromptToGenerate => 'Enter a prompt to generate an image';

  @override
  String get generate => 'Generate';

  @override
  String get generating => 'Generating...';

  @override
  String get generationComplete => 'Generation Complete';

  @override
  String get imageWouldBeDisplayed => 'Image would be displayed here';

  @override
  String get enableLogitBias => 'Enable Logit Bias';

  @override
  String get adjustTokenProbabilities =>
      'Adjust token probabilities in AI responses';

  @override
  String get presets => 'Presets';

  @override
  String get activePresetLabel => 'Active Preset';

  @override
  String get none => 'None';

  @override
  String get newPreset => 'New Preset';

  @override
  String get importPresetLabel => 'Import Preset';

  @override
  String get biasEntries => 'Bias Entries';

  @override
  String get noBiasEntries => 'No bias entries';

  @override
  String get addEntriesToAdjust => 'Add entries to adjust token probabilities';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get textOrToken => 'Text / Token';

  @override
  String textTokenHint(Object verbatim) {
    return 'word, $verbatim, or [1234]';
  }

  @override
  String get bias => 'Bias';

  @override
  String get logitBiasHelp => 'Logit Bias Help';

  @override
  String get presetCopiedToClipboard => 'Preset copied to clipboard';

  @override
  String exportPresetFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get pastePresetJson => 'Paste preset JSON here';

  @override
  String get presetImportedSuccessfully => 'Preset imported successfully';

  @override
  String importPresetFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get rename => 'Rename';

  @override
  String get deletePresetQuestion =>
      'Are you sure you want to delete this preset?';

  @override
  String get moreOptions => 'More options';

  @override
  String get loadPreset => 'Load Preset';

  @override
  String get saveAsPresetLabel => 'Save as Preset';

  @override
  String get exportPreset => 'Export Preset';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get dragToReorder =>
      'Drag to reorder sections. Toggle switches to enable/disable.';

  @override
  String deleted(String name) {
    return 'Deleted \"$name\"';
  }

  @override
  String imported(String name) {
    return 'Imported \"$name\"';
  }

  @override
  String get invalidPresetFormatMessage => 'Invalid preset format';

  @override
  String get exportPresetTitle => 'Export Preset';

  @override
  String get presetNameLabel => 'Preset Name';

  @override
  String get pleaseEnterNameMessage => 'Please enter a name';

  @override
  String saved(String name) {
    return 'Saved \"$name\"';
  }

  @override
  String saveFailedMessage(String error) {
    return 'Save failed: $error';
  }

  @override
  String get resetToDefaultQuestion =>
      'This will reset all prompt sections to their default order and enable all sections. Continue?';

  @override
  String get resetToDefaultConfig => 'Reset to default configuration';

  @override
  String get promptManagerHelp => 'Prompt Manager Help';

  @override
  String applied(String name) {
    return 'Applied \"$name\" preset';
  }

  @override
  String get showQuickReplies => 'Show Quick Replies';

  @override
  String get displayQuickReplyButtons => 'Display quick reply buttons in chat';

  @override
  String get positionAboveInput => 'Position Above Input';

  @override
  String get quickRepliesAboveInput =>
      'Quick replies appear above the input field';

  @override
  String get quickRepliesBelowInput =>
      'Quick replies appear below the input field';

  @override
  String get add => 'Add';

  @override
  String get noQuickReplies => 'No quick replies';

  @override
  String get addYourFirstQuickReply => 'Add your first quick reply';

  @override
  String deleteQuickReplyQuestion(String label) {
    return 'Are you sure you want to delete \"$label\"?';
  }

  @override
  String get resetToDefaultQuestion2 =>
      'This will replace all your quick replies with the default set. Continue?';

  @override
  String get continueOrEmpty => '(Continue/Empty message)';

  @override
  String get autoSendTooltip => 'Auto-send';

  @override
  String get addQuickReply => 'Add Quick Reply';

  @override
  String get editQuickReplyLabel => 'Edit Quick Reply';

  @override
  String get buttonLabel => 'Button Label';

  @override
  String get buttonLabelHint => 'e.g., Yes, Continue, Think...';

  @override
  String get messageLabel => 'Message';

  @override
  String get leaveEmptyForContinue => 'Leave empty for continue action';

  @override
  String get supportsMacros => 'Supports prompt macros';

  @override
  String get autoSendLabel => 'Auto-send';

  @override
  String get messageSentImmediately => 'Message will be sent immediately';

  @override
  String get messageFillsInput => 'Message will fill the input field';

  @override
  String get regexScripts => 'Regex Scripts';

  @override
  String get addScript => 'Add Script';

  @override
  String get addPresets => 'Add Presets';

  @override
  String get clearAll => 'Clear All';

  @override
  String get enableRegexScripts => 'Enable Regex Scripts';

  @override
  String get applyFindReplacePatterns =>
      'Apply find/replace patterns to messages';

  @override
  String get applyTo => 'Apply To';

  @override
  String get userInput => 'User Input';

  @override
  String get applyBeforeSending => 'Apply to messages before sending';

  @override
  String get aiOutput => 'AI Output';

  @override
  String get applyToAiResponses => 'Apply to AI responses';

  @override
  String get slashCommandsLabel => 'Slash Commands';

  @override
  String get applyDuringCommandProcessing => 'Apply during command processing';

  @override
  String get worldInfoLabel => 'Lorebook';

  @override
  String get applyToWorldInfoEntries => 'Apply to lorebook entries';

  @override
  String scriptsCount(int count) {
    return 'Scripts ($count)';
  }

  @override
  String get noRegexScripts => 'No regex scripts';

  @override
  String get tapToAddOrUseMenu =>
      'Tap + to add a script or use the menu to add presets';

  @override
  String get aboutRegexScripts => 'About Regex Scripts';

  @override
  String get aboutRegexScriptsDescription =>
      'Regex scripts allow you to find and replace text patterns in messages. Use capture groups (\\\$1, \\\$2) in replacements.';

  @override
  String get patternFormat => 'Pattern Format';

  @override
  String get patternFormatDescription =>
      'Use /pattern/flags format (e.g., /hello/gi) or plain patterns. Flags: i=case-insensitive, m=multiline, s=dotall';

  @override
  String get presetScriptsAdded => 'Preset scripts added';

  @override
  String deleteScriptQuestion(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get clearAllScripts => 'Clear All Scripts';

  @override
  String get clearAllScriptsQuestion =>
      'This will delete all regex scripts. This cannot be undone.';

  @override
  String get importScripts => 'Import Scripts';

  @override
  String get pasteJsonArray => 'Paste JSON array of scripts';

  @override
  String importedCount(int count) {
    return 'Imported $count scripts';
  }

  @override
  String get exportScripts => 'Export Scripts';

  @override
  String get newScript => 'New Script';

  @override
  String get editScript => 'Edit Script';

  @override
  String get scriptName => 'Script Name';

  @override
  String get descriptionOptionalLabel => 'Description (optional)';

  @override
  String get findPattern => 'Find Pattern';

  @override
  String get patternOrPlainPattern => '/pattern/flags or plain pattern';

  @override
  String get replaceWith => 'Replace With';

  @override
  String get useCaptureGroups => 'Use \\\$1, \\\$2 for capture groups';

  @override
  String get applyToLabel => 'Apply To';

  @override
  String get options => 'Options';

  @override
  String get markdownOnly => 'Markdown Only';

  @override
  String get onlyApplyDuringMarkdown => 'Only apply during markdown rendering';

  @override
  String get promptOnly => 'Prompt Only';

  @override
  String get onlyApplyDuringPrompt => 'Only apply during prompt generation';

  @override
  String get runOnEdit => 'Run on Edit';

  @override
  String get applyWhenEditingMessages => 'Apply when editing messages';

  @override
  String get macroSubstitution => 'Macro Substitution';

  @override
  String get nameAndPatternRequired => 'Name and pattern are required';

  @override
  String get patternLabel => 'Pattern';

  @override
  String get patternHint => '/pattern/flags';

  @override
  String get testString => 'Test String';

  @override
  String get replacementLabel => 'Replacement';

  @override
  String get replacementHint => '\$1, \$2, or the matched text';

  @override
  String get testButton => 'Test';

  @override
  String matchesCount(int count) {
    return '$count match(es)';
  }

  @override
  String get errorLabel => 'Error';

  @override
  String get resultLabel => 'Result:';

  @override
  String get expressionSprites => 'Expression Sprites';

  @override
  String get enableSprites => 'Enable Sprites';

  @override
  String get showCharacterExpressions =>
      'Show character expression images in chat';

  @override
  String get display => 'Display';

  @override
  String get spriteSize => 'Sprite Size';

  @override
  String get position => 'Position';

  @override
  String get whereToDisplaySprites => 'Where to display sprites';

  @override
  String get left => 'Left';

  @override
  String get right => 'Right';

  @override
  String get center => 'Center';

  @override
  String get floatingLeft => 'Floating Left';

  @override
  String get floatingRight => 'Floating Right';

  @override
  String get animation => 'Animation';

  @override
  String get animateTransitions => 'Animate Transitions';

  @override
  String get smoothFadeWhenSpriteChanges => 'Smooth fade when sprite changes';

  @override
  String get transitionDuration => 'Transition Duration';

  @override
  String get showDuringStreaming => 'Show During Streaming';

  @override
  String get displaySpritesWhileGenerating =>
      'Display sprites while AI is generating';

  @override
  String get emotionDetection => 'Emotion Detection';

  @override
  String get howItWorks => 'How it works';

  @override
  String get spriteEmotionDetectionDescription =>
      'Sprites are automatically selected based on emotion keywords detected in messages. Action text like *smiles* or *laughs* is prioritized.';

  @override
  String get supportedEmotions => 'Supported Emotions';

  @override
  String characterSprites(String name) {
    return '$name Sprites';
  }

  @override
  String get importFromFolder => 'Import from folder';

  @override
  String get deleteAllSprites => 'Delete All Sprites';

  @override
  String get addSprite => 'Add Sprite';

  @override
  String spritesCount(int count) {
    return '$count sprites';
  }

  @override
  String defaultEmotion(String emotion) {
    return 'Default: $emotion';
  }

  @override
  String get noSpritesYet => 'No sprites yet';

  @override
  String get addExpressionImages => 'Add expression images for this character';

  @override
  String get selectEmotion => 'Select Emotion';

  @override
  String addedSpriteEmotion(String emotion) {
    return 'Added $emotion sprite';
  }

  @override
  String get setAsDefaultEmotion => 'Set as Default';

  @override
  String get changeEmotion => 'Change Emotion';

  @override
  String get deleteSprite => 'Delete Sprite';

  @override
  String deleteSpriteConfirmation(String emotion) {
    return 'Delete the $emotion sprite?';
  }

  @override
  String get deleteAllSpritesConfirmation =>
      'Are you sure you want to delete all sprites for this character? This cannot be undone.';

  @override
  String get importSprites => 'Import Sprites';

  @override
  String get importSpritesDescription =>
      'Import sprites from a folder. Files should be named with emotion keywords:';

  @override
  String get supportedFormatsSprites =>
      'Supported formats: PNG, JPG, GIF, WebP';

  @override
  String get selectFolder => 'Select Folder';

  @override
  String get folderImportRequiresPackage =>
      'Folder import requires file_picker package';

  @override
  String get appStatistics => 'App Statistics';

  @override
  String get chatStatistics => 'Chat Statistics';

  @override
  String get resetStatistics => 'Reset statistics';

  @override
  String get resetStatisticsConfirmation =>
      'Are you sure you want to reset all statistics? This cannot be undone.';

  @override
  String get statisticsReset => 'Statistics reset';

  @override
  String get overview => 'Overview';

  @override
  String get firstUsed => 'First Used';

  @override
  String get unknown => 'Unknown';

  @override
  String get totalGroups => 'Total Groups';

  @override
  String get totalGenerations => 'Total Generations';

  @override
  String get tokenUsage => 'Token Usage';

  @override
  String get totalTokensUsed => 'Total Tokens Used';

  @override
  String get avgTokensPerGeneration => 'Avg Tokens/Generation';

  @override
  String get performance => 'Performance';

  @override
  String get totalGenerationTime => 'Total Generation Time';

  @override
  String get avgGenerationTime => 'Avg Generation Time';

  @override
  String get userMessages => 'User Messages';

  @override
  String get assistantMessages => 'Assistant Messages';

  @override
  String get systemMessages => 'System Messages';

  @override
  String get timeline => 'Timeline';

  @override
  String get firstMessage_ => 'First Message';

  @override
  String get lastMessage => 'Last Message';

  @override
  String get chatDuration => 'Chat Duration';

  @override
  String get promptTokens => 'Prompt Tokens';

  @override
  String get completionTokens => 'Completion Tokens';

  @override
  String get avgTokensPerMessage => 'Avg Tokens/Message';

  @override
  String get generationPerformance => 'Generation Performance';

  @override
  String get generationCount => 'Total Generations';

  @override
  String get speechToText => 'Speech-to-Text';

  @override
  String get enableStt => 'Enable STT';

  @override
  String get useVoiceInputForMessages => 'Use voice input for messages';

  @override
  String get autoSendStt => 'Auto-send';

  @override
  String get automaticallySendAfterSpeaking =>
      'Automatically send message after speaking';

  @override
  String get continuousListening => 'Continuous Listening';

  @override
  String get keepListeningAfterPhrase => 'Keep listening after each phrase';

  @override
  String get showPartialResults => 'Show Partial Results';

  @override
  String get displayTextAsYouSpeak => 'Display text as you speak';

  @override
  String get sttProvider => 'STT Provider';

  @override
  String get recognitionLanguage => 'Recognition Language';

  @override
  String get testVoiceInput => 'Test Voice Input';

  @override
  String get stopListening => 'Stop Listening';

  @override
  String get tapToStop => 'Tap to stop';

  @override
  String get tapToTestSpeechRecognition => 'Tap to test speech recognition';

  @override
  String get final_ => 'Final';

  @override
  String get listening => 'Listening...';

  @override
  String get aboutStt => 'About STT';

  @override
  String get aboutSttDescription =>
      'Speech-to-Text allows you to dictate messages using your voice. Tap the microphone button in the chat input to start speaking.';

  @override
  String get systemStt => 'System STT';

  @override
  String get systemSttDescription =>
      'Using your device\'s built-in speech recognition. Accuracy depends on your system settings.';

  @override
  String get whisper => 'Whisper';

  @override
  String get whisperDescription =>
      'Whisper transcription through an OAI Compatible endpoint. Requires an API key.';

  @override
  String get voiceInput => 'Voice input';

  @override
  String get holdToTalk => 'Hold to talk';

  @override
  String get releaseToTranscribe => 'Release to transcribe';

  @override
  String get cancelVoiceInput => 'Cancel voice input';

  @override
  String get openSystemSettings => 'Open settings';

  @override
  String get systemSttOfflineNote =>
      'Offline recognition depends on your operating system and installed language packs.';

  @override
  String get sttConfigurationRequired =>
      'Complete the selected provider configuration before testing.';

  @override
  String get speechRecognitionNotAvailable =>
      'Speech recognition may not be available on this device.';

  @override
  String get themes => 'Themes';

  @override
  String get createCustomTheme => 'Create custom theme';

  @override
  String get builtInThemes => 'Built-in Themes';

  @override
  String get preview => 'Preview';

  @override
  String get chatPreview => 'Chat Preview';

  @override
  String get helloHowCanIHelp => 'Hello! How can I help you today?';

  @override
  String get tellMeAStory => 'Tell me a story!';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String get createTheme => 'Create Theme';

  @override
  String get editTheme => 'Edit Theme';

  @override
  String get deleteTheme => 'Delete Theme';

  @override
  String deleteThemeConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get themeName => 'Theme Name';

  @override
  String get background => 'Background';

  @override
  String get surface => 'Surface';

  @override
  String get card => 'Card';

  @override
  String selectThemeColor(String label) {
    return 'Select $label';
  }

  @override
  String get hexColor => 'Hex Color';

  @override
  String get tokenizerSettings => 'Tokenizer';

  @override
  String get tokenizerHelp => 'Help';

  @override
  String get tokenizerLabel => 'Tokenizer';

  @override
  String get showTokenCount => 'Show Token Count';

  @override
  String get displayTokenCountInInput => 'Display token count in chat input';

  @override
  String get showTokenVisualization => 'Show Token Visualization';

  @override
  String get highlightIndividualTokens => 'Highlight individual tokens';

  @override
  String get cacheResults => 'Cache Results';

  @override
  String get cacheTokenizationForPerformance =>
      'Cache tokenization for performance';

  @override
  String get tokenVisualization => 'Token Visualization';

  @override
  String get enterTextToTokenize => 'Enter text to tokenize';

  @override
  String get typePasteTextHere => 'Type or paste text here...';

  @override
  String get quickEstimate => 'Quick Estimate';

  @override
  String approximateTokens(int count) {
    return '~$count tokens';
  }

  @override
  String chars(int count) {
    return '$count chars';
  }

  @override
  String get statisticsLabel => 'Statistics';

  @override
  String get totalTokens => 'Total Tokens';

  @override
  String get unique => 'Unique';

  @override
  String get charsPerToken => 'Chars/Token';

  @override
  String get avgLength => 'Avg Length';

  @override
  String get longest => 'Longest';

  @override
  String get shortest => 'Shortest';

  @override
  String get mostCommonTokens => 'Most Common Tokens';

  @override
  String get tokenBreakdown => 'Token Breakdown';

  @override
  String tokensCount(int count) {
    return '$count tokens';
  }

  @override
  String tokenIdLength(String id, int length) {
    return 'Token ID: $id\nLength: $length chars';
  }

  @override
  String get translationSettings => 'Translation';

  @override
  String get enableTranslation => 'Enable Translation';

  @override
  String get translateMessagesAutomatically =>
      'Translate messages automatically';

  @override
  String get translationProvider => 'Translation Provider';

  @override
  String get sourceLanguage => 'Source Language';

  @override
  String get targetLanguage => 'Target Language';

  @override
  String get autoDetect => 'Auto-detect';

  @override
  String get translateUserMessages => 'Translate User Messages';

  @override
  String get translateAiResponses => 'Translate AI Responses';

  @override
  String get textToSpeech => 'Text-to-Speech';

  @override
  String get enableTts => 'Enable TTS';

  @override
  String get readAiResponsesAloud => 'Read AI responses aloud';

  @override
  String get ttsProvider => 'TTS Provider';

  @override
  String get voiceSettings => 'Voice Settings';

  @override
  String get voice => 'Voice';

  @override
  String get speed => 'Speed';

  @override
  String get pitch => 'Pitch';

  @override
  String get volume => 'Volume';

  @override
  String get autoPlay => 'Auto-play';

  @override
  String get automaticallyPlayResponses => 'Automatically play AI responses';

  @override
  String get testVoice => 'Test Voice';

  @override
  String get chatVariables => 'Chat Variables';

  @override
  String get variableSystem => 'Variable System';

  @override
  String get globalVariables => 'Global Variables';

  @override
  String globalVariablesCount(int count) {
    return '$count global variables';
  }

  @override
  String get localVariables => 'Local Variables';

  @override
  String localVariablesCount(int count) {
    return '$count local variables';
  }

  @override
  String get addVariable => 'Add Variable';

  @override
  String get variableName => 'Variable Name';

  @override
  String get variableValue => 'Variable Value';

  @override
  String get scope => 'Scope';

  @override
  String get global => 'Global';

  @override
  String get vectorStorageRag => 'Vector Storage (RAG)';

  @override
  String get enableRag => 'Enable RAG';

  @override
  String get useVectorStorageForContext =>
      'Use vector storage for context retrieval';

  @override
  String get collections => 'Collections';

  @override
  String get createCollection => 'Create Collection';

  @override
  String get collectionName => 'Collection Name';

  @override
  String get embeddingProvider => 'Embedding Provider';

  @override
  String get embeddingModel => 'Embedding Model';

  @override
  String get chunkSize => 'Chunk Size';

  @override
  String get chunkOverlap => 'Chunk Overlap';

  @override
  String get topKResults => 'Top K Results';

  @override
  String get similarityThreshold => 'Similarity Threshold';

  @override
  String get characterEditor => 'Character Editor';

  @override
  String get basic => 'Basic';

  @override
  String get prompts => 'Prompts';

  @override
  String get meta => 'Meta';

  @override
  String get nameRequired => 'Name *';

  @override
  String get characterName => 'Character name';

  @override
  String get nameIsRequired => 'Name is required';

  @override
  String get characterDescription =>
      'Character description, background, appearance...';

  @override
  String get characterPersonalityTraits => 'Character personality traits...';

  @override
  String get currentCircumstancesContext =>
      'The current circumstances and context...';

  @override
  String get customInstructionsSystemMessage =>
      'Custom instructions sent as part of the system message.';

  @override
  String systemPromptHint(Object char) {
    return 'You are $char. You will...';
  }

  @override
  String get instructionsInsertedAfterHistory =>
      'Instructions inserted after the chat history (also known as \"jailbreak\").';

  @override
  String postHistoryInstructionsHint(Object char) {
    return 'Continue the roleplay as $char...';
  }

  @override
  String get firstMessageGreeting => 'First Message (Greeting)';

  @override
  String get firstMessageSentByCharacter =>
      'The first message sent by the character when starting a new chat.';

  @override
  String firstMessageHint(Object user) {
    return '*walks into the room* Hello, $user!';
  }

  @override
  String get alternateGreetingsCanSwipe =>
      'Alternative first messages that can be swiped through.';

  @override
  String greeting(int index) {
    return 'Greeting $index';
  }

  @override
  String get alternativeGreetingMessage => 'Alternative greeting message...';

  @override
  String get removeGreeting => 'Remove greeting';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get noAlternateGreetings =>
      'No alternate greetings. Tap + to add one.';

  @override
  String exampleDialogueDemonstrate(Object char, Object user) {
    return 'Example dialogue to demonstrate how the character speaks.\\nFormat: <START>\\n$user: Hello\\n$char: Hi there!';
  }

  @override
  String exampleMessagesHint(Object char, Object user) {
    return '<START>\\n$user: How are you?\\n$char: I\'m doing well, thanks for asking!';
  }

  @override
  String get creatorNotesNotSentToAi =>
      'Notes from the character creator (not sent to the AI).';

  @override
  String get creatorNotesHint => 'Recommended settings, backstory notes...';

  @override
  String get tagsCommaSeparated => 'Comma-separated list of tags';

  @override
  String get tagsHint => 'fantasy, female, adventure';

  @override
  String get creator => 'Creator';

  @override
  String get yourNameOrUsername => 'Your name or username';

  @override
  String get versionNumber => '1.0.0';

  @override
  String get characterInfo => 'Character Info';

  @override
  String characterId(String id) {
    return 'ID: $id';
  }

  @override
  String created(String date) {
    return 'Created: $date';
  }

  @override
  String modified(String date) {
    return 'Modified: $date';
  }

  @override
  String get characterSavedSuccessfully => 'Character saved successfully';

  @override
  String failedToSaveCharacter(String error) {
    return 'Failed to save character: $error';
  }

  @override
  String get addAlternateGreeting => 'Add alternate greeting';

  @override
  String get groupInfo => 'Group Info';

  @override
  String get responseMode => 'Response Mode';

  @override
  String get howCharactersTakeTurns => 'How characters take turns responding';

  @override
  String get sequential => 'Sequential';

  @override
  String get charactersRespondInOrder => 'Characters respond in order';

  @override
  String get random => 'Random';

  @override
  String get randomCharacterResponds => 'Random character responds each turn';

  @override
  String get allAtOnce => 'All at Once';

  @override
  String get allNonMutedCharactersRespond => 'All non-muted characters respond';

  @override
  String get manual => 'Manual';

  @override
  String get youSelectWhoResponds => 'You select which character responds';

  @override
  String get natural => 'Natural';

  @override
  String get aiDecidesBasedOnContext =>
      'AI decides based on context and trigger words';

  @override
  String membersCount(int count) {
    return 'Members ($count)';
  }

  @override
  String get noMembersYet => 'No members yet. Add characters to this group.';

  @override
  String talkativenessPercent(int percent) {
    return 'Talkativeness: $percent%';
  }

  @override
  String triggers(String words) {
    return 'Triggers: $words';
  }

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get memberSettings => 'Member Settings';

  @override
  String talkativenessLabel(int percent) {
    return 'Talkativeness: $percent%';
  }

  @override
  String get higherValuesMoreLikely =>
      'Higher values make the character more likely to respond.';

  @override
  String get triggerWords => 'Trigger Words';

  @override
  String get triggerWordsHint => 'word1, word2, word3';

  @override
  String get characterWillRespondWhenTriggered =>
      'Character will respond when these words appear in messages.';

  @override
  String get addMemberToGroup => 'Add Member';

  @override
  String get noMoreCharactersAvailable => 'No more characters available to add';

  @override
  String get groupSaved => 'Group saved';

  @override
  String deleteGroupAndChats(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get startChatAction => 'Start Chat';

  @override
  String get noTagsYet => 'No tags yet';

  @override
  String get createTagsToOrganize => 'Create tags to organize your characters';

  @override
  String characterCount(int count, String plural) {
    return '$count character$plural';
  }

  @override
  String deleteTagConfirmation(String name) {
    return 'Are you sure you want to delete the tag \"$name\"?\\n\\nThis will remove the tag from all characters.';
  }

  @override
  String get enterTagName => 'Enter tag name';

  @override
  String get iconEmoji => 'Icon (emoji)';

  @override
  String get enterEmojiOptional => 'Enter an emoji (optional)';

  @override
  String get pleaseEnterTagName => 'Please enter a tag name';

  @override
  String get worldInfoLorebooks => 'Lorebooks';

  @override
  String get createLorebook => 'Create Lorebook';

  @override
  String get noLorebooksYet => 'No Lorebooks yet';

  @override
  String get lorebooksInjectContext =>
      'Lorebooks inject context into your chats when keywords are detected.';

  @override
  String entriesCount(int count) {
    return '$count entries';
  }

  @override
  String deleteLorebookConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\" and all its entries?';
  }

  @override
  String get enterLorebookName => 'Enter lorebook name';

  @override
  String get optionalDescriptionHint => 'Optional description';

  @override
  String get globalScope => 'Global';

  @override
  String get applyToAllChats => 'Apply to all chats';

  @override
  String get pleaseEnterName2 => 'Please enter a name';

  @override
  String get noEntriesYet => 'No entries yet';

  @override
  String get addEntriesWithKeywords =>
      'Add entries with keywords to inject context into chats';

  @override
  String deleteEntryConfirmation(String keys) {
    return 'Are you sure you want to delete this entry?\\n\\nKeys: $keys';
  }

  @override
  String get constant => 'Constant';

  @override
  String get selective => 'Selective';

  @override
  String get keywordsCommaSeparated => 'Keywords (comma-separated)';

  @override
  String get keywordsHint => 'dragon, wyrm, serpent';

  @override
  String get entryActivatesWhenKeywordFound =>
      'Entry activates when any keyword is found in chat';

  @override
  String get secondaryKeysOptional => 'Secondary Keys (optional)';

  @override
  String get secondaryKeysHint => 'fire, flame';

  @override
  String get bothPrimaryAndSecondaryMustMatch =>
      'If set, both primary AND secondary must match (selective mode)';

  @override
  String get commentOptional => 'Comment (optional)';

  @override
  String get noteForThisEntry => 'Note for this entry';

  @override
  String get contentLabel => 'Content';

  @override
  String get contextToInjectWhenMatches =>
      'The context to inject when keywords match...';

  @override
  String get pleaseEnterAtLeastOneKeyword =>
      'Please enter at least one keyword';

  @override
  String get pleaseEnterContent => 'Please enter content';

  @override
  String get anthropic => 'Anthropic';

  @override
  String get cohere => 'Cohere';

  @override
  String get customProvider => 'Custom';

  @override
  String get apiEndpointHint => 'https://api.example.com/v1';

  @override
  String get apiKeyHint => 'sk-...';

  @override
  String get xaiApiKeyHint => 'xai-...';

  @override
  String temperatureValue(String value) {
    return '$value';
  }

  @override
  String maxTokensValue(String value) {
    return '$value';
  }

  @override
  String topPValue(String value) {
    return '$value';
  }

  @override
  String frequencyPenaltyValue(String value) {
    return '$value';
  }

  @override
  String presencePenaltyValue(String value) {
    return '$value';
  }

  @override
  String get streamResponse => 'Stream Response';

  @override
  String get streamTokensAsGenerated => 'Stream tokens as they are generated';

  @override
  String get useSystemPrompt => 'Use System Prompt';

  @override
  String get includeSystemInstructions => 'Include system instructions';

  @override
  String get configurationSavedSuccessfully =>
      'Configuration saved successfully';

  @override
  String get errorSavingConfiguration => 'Error saving configuration';

  @override
  String get copyAll => 'Copy All';

  @override
  String get showFavoritesOnly => 'Show favorites only';

  @override
  String get sortBy => 'Sort by';

  @override
  String get filterByTags => 'Filter by tags';

  @override
  String get favorites => 'Favorites';

  @override
  String get manage => 'Manage';

  @override
  String get noTagsCreatedYet => 'No tags created yet';

  @override
  String get createTags => 'Create Tags';

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count characters',
      one: '1 character',
    );
    return '$_temp0';
  }

  @override
  String get characterTagsLegacy => 'Character Tags (Legacy)';

  @override
  String get done => 'Done';

  @override
  String applyFiltersSelected(int count) {
    return 'Apply ($count selected)';
  }

  @override
  String get enterPresetName => 'Enter preset name';

  @override
  String get deleteScript => 'Delete Script';

  @override
  String get aiConfig => 'AI Config';

  @override
  String get authorsNoteDescription =>
      'Add context or instructions that will be injected into the conversation at a specific depth.';

  @override
  String get enableAuthorsNote => 'Enable Author\'s Note';

  @override
  String get injectNoteIntoContext => 'Inject note into conversation context';

  @override
  String get injectionDepth => 'Injection Depth';

  @override
  String get messagesFromEndWhereInserted =>
      'Messages from the end where note is inserted';

  @override
  String get noteContent => 'Note Content';

  @override
  String get authorsNoteHint =>
      'Enter your author\'s note here...\\n\\nExamples:\\n• [Style: Write in a poetic, descriptive manner]\\n• [Focus on emotional depth and character development]\\n• [The character is feeling melancholic today]';

  @override
  String get enterNameForCheckpoint => 'Enter a name for this checkpoint';

  @override
  String get addDescription => 'Add a description';

  @override
  String createCheckpointAtMessage(int index) {
    return 'This will create a checkpoint at message $index.';
  }

  @override
  String get longPressMessageToBookmark =>
      'Long-press a message to create a bookmark';

  @override
  String get contextManagement => 'Context Management';

  @override
  String get autoSummarize => 'Auto-Summarize';

  @override
  String get autoSummarizeDescription =>
      'Automatically summarize and compress chat history when context usage is high';

  @override
  String get autoSummarizeThreshold => 'Auto-Summarize Threshold';

  @override
  String get autoSummarizeThresholdDescription =>
      'Trigger summarization when context reaches this percentage of maximum';

  @override
  String get branchFromBookmark => 'Branch from Bookmark';

  @override
  String branchFromBookmarkWarning(String name) {
    return 'This will delete all messages after \"$name\" and continue from that point. You can create a new bookmark before doing this to save the current state.';
  }

  @override
  String get branch => 'Branch';

  @override
  String branchedFrom(String name) {
    return 'Branched from \"$name\"';
  }

  @override
  String deleteBookmarkConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String messageIndexAndDate(int index, String date) {
    return 'Message $index • $date';
  }

  @override
  String get branchFromHere => 'Branch from here';

  @override
  String previewBookmark(String name) {
    return 'Preview: $name';
  }

  @override
  String get messageNotFoundInChat => 'Message not found in current chat';

  @override
  String get you => 'You';

  @override
  String get assistant => 'Assistant';

  @override
  String get reasoningCopiedToClipboard => 'Reasoning copied to clipboard';

  @override
  String charsCount(int count) {
    return '$count chars';
  }

  @override
  String get copyReasoning => 'Copy reasoning';

  @override
  String get commands => 'Commands';

  @override
  String aliasesLabel(String aliases) {
    return 'Aliases: $aliases';
  }

  @override
  String get noSpritesAddedYet => 'No sprites added yet';

  @override
  String get errorLoadingSprites => 'Error loading sprites';

  @override
  String get insertionPosition => 'Insertion Position';

  @override
  String get beforeCharacterDefinition => 'Before Character Definition';

  @override
  String get afterCharacterDefinition => 'After Character Definition';

  @override
  String get beforeExampleMessages => 'Before Example Messages';

  @override
  String get afterExampleMessages => 'After Example Messages';

  @override
  String get beforeAuthorNote => 'Before Author\'s Note';

  @override
  String get afterAuthorNote => 'After Author\'s Note';

  @override
  String get atDepth => 'At Depth';

  @override
  String get beforeSystemPrompt => 'Before System Prompt';

  @override
  String get afterSystemPrompt => 'After System Prompt';

  @override
  String get insertionOrder => 'Insertion Order';

  @override
  String get lowerOrderInsertsFirst => 'Lower order values are inserted first';

  @override
  String get alwaysIncludeInPrompt =>
      'Always include in prompt (ignore keywords)';

  @override
  String get requiresSecondaryKey =>
      'Requires both primary AND secondary key to match';

  @override
  String get debugLog => 'Debug Log';

  @override
  String get debugLogDescription => 'Show floating debug button to view logs';

  @override
  String get autoScroll => 'Auto Scroll';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get searchLogs => 'Search logs...';

  @override
  String get noLogsYet => 'No logs yet';

  @override
  String get allCharactersAvailable => 'All Characters';

  @override
  String get availableToAllCharactersNotGlobal =>
      'Available to all characters (contextual matching)';

  @override
  String get specificCharacter => 'Specific Character';

  @override
  String get linkToSpecificCharacter => 'Link to a specific character only';

  @override
  String get selectCharacter => 'Select character';

  @override
  String get pleaseSelectCharacter => 'Please select a character';

  @override
  String get contextUsage => 'Context Usage';

  @override
  String get maxContext => 'Max Context';

  @override
  String get remaining => 'Remaining';

  @override
  String get breakdown => 'Breakdown';

  @override
  String get cloudBackup => 'Cloud Backup';

  @override
  String get cloudBackupInfo => 'Cloud Backup';

  @override
  String get cloudBackupDescription => 'Sync your data across devices';

  @override
  String get cloudBackupSubtitle =>
      'Backup to iCloud or Google Drive and restore on any device';

  @override
  String get backupContents => 'Backup contents';

  @override
  String get allTextData => 'All text data';

  @override
  String get allTextDataDescription =>
      'Characters, chats, messages, world books, groups, personas, memories, Data Bank, RPG data, stories, moments, and app state';

  @override
  String get characterCardImages => 'All character card images';

  @override
  String get characterCardImagesDescription =>
      'Character, persona, and group avatars plus character sprites';

  @override
  String get worldBookImages => 'All world book images';

  @override
  String get worldBookImagesDescription =>
      'Local images referenced by world books';

  @override
  String get conversationImages => 'All chat and moment images';

  @override
  String get conversationImagesDescription =>
      'Chat attachments, generated chat images, and moment images';

  @override
  String get backgroundImages => 'All background images';

  @override
  String get backgroundImagesDescription =>
      'Imported global and chat backgrounds';

  @override
  String get live2DBackup => 'All Live2D models';

  @override
  String get live2DModelsBackupDescription =>
      'Optional large files; may significantly increase backup size';

  @override
  String get independentMediaBackup => 'Independent media backup';

  @override
  String get independentMediaBackupDescription =>
      'Images are stored separately. Data backup and restore still work when media fails or is unavailable.';

  @override
  String get mediaBackupPartialSuccess =>
      'Database data completed successfully, but some media or settings could not be backed up or restored.';

  @override
  String mediaRestoreComplete(int count) {
    return 'Media restored: $count files';
  }

  @override
  String get mediaNotIncludedInBackup =>
      'This backup does not include a media package; only data was restored.';

  @override
  String get backupStagePreparingData => 'Preparing database and settings...';

  @override
  String get backupStageScanningMedia => 'Scanning media files...';

  @override
  String backupStageCompressingMedia(int processed, int total) {
    return 'Compressing media: $processed/$total files';
  }

  @override
  String get backupStageUploadingData => 'Uploading data backup...';

  @override
  String get backupStageUploadingMedia => 'Uploading media package...';

  @override
  String get backupStageDownloadingData => 'Downloading data backup...';

  @override
  String get backupStageDownloadingMedia => 'Downloading media package...';

  @override
  String get backupStageVerifyingMedia => 'Verifying media package...';

  @override
  String backupStageRestoringMedia(int processed, int total) {
    return 'Restoring media: $processed/$total files';
  }

  @override
  String get backupStageRestoringData => 'Merging or replacing database...';

  @override
  String get enableICloudBackup => 'Enable iCloud Backup';

  @override
  String get enableICloudBackupDescription =>
      'Save backups to iCloud Drive so they appear on your other Apple devices';

  @override
  String get enableCrossDeviceSync => 'Automatic cross-device sync';

  @override
  String get enableCrossDeviceSyncDescription =>
      'Keep this device updated with iCloud on Apple devices and Google Drive on Android and other signed-in devices. Changes upload when the app is backgrounded and download on the next launch or resume.';

  @override
  String get enableGoogleDriveBackup => 'Enable Google Drive Backup';

  @override
  String get enableGoogleDriveBackupDescription =>
      'Save backups to Google Drive so they appear on your other Android and signed-in devices';

  @override
  String get syncNow => 'Sync now';

  @override
  String get crossDeviceSyncComplete => 'Devices are in sync';

  @override
  String get openingBackupFile => 'Opening backup…';

  @override
  String get iCloudNotAvailable => 'iCloud Not Available';

  @override
  String get iCloudNotAvailableDescription =>
      'Please sign in to iCloud in Settings';

  @override
  String get backupToICloud => 'Backup to iCloud';

  @override
  String lastSync(String time) {
    return 'Last sync: $time';
  }

  @override
  String get neverSynced => 'Never synced';

  @override
  String get iCloudBackups => 'iCloud Backups';

  @override
  String get noCloudBackups => 'No cloud backups';

  @override
  String get googleDriveExport => 'Export to Google Drive';

  @override
  String get googleDriveExportDescription =>
      'Save backup file to Google Drive or other location';

  @override
  String get googleDriveImport => 'Import from Google Drive';

  @override
  String get googleDriveImportDescription =>
      'Restore from a backup file in Google Drive or other location';

  @override
  String get import_action => 'Import';

  @override
  String get importBackup => 'Import Backup';

  @override
  String get backupExported => 'Backup exported successfully';

  @override
  String get restoreSettings => 'Restore Settings';

  @override
  String get defaultRestoreMode => 'Default Restore Mode';

  @override
  String get selectRestoreMode => 'Select how to restore data:';

  @override
  String get restoreWarning =>
      'Restoring data may overwrite existing data depending on the selected mode. Make sure to backup your current data first.';

  @override
  String get restore => 'Restore';

  @override
  String restoreComplete(int added, int updated, int skipped) {
    return 'Restore complete: $added added, $updated updated, $skipped skipped';
  }

  @override
  String get selectFileAndImport => 'Select File & Import';

  @override
  String get aboutRestoreModes => 'About Restore Modes';

  @override
  String get aboutRestoreModesDescription =>
      'Replace: Overwrites all local data with backup data.\nMerge: Keeps both, newer data wins for conflicts.\nAdd New Only: Only adds new items, keeps all existing data.';

  @override
  String get signInToGoogleDrive => 'Sign in to Google Drive';

  @override
  String get signInToGoogleDriveDescription =>
      'Sign in with your Google account to backup and restore data';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signedInSuccessfully => 'Signed in successfully';

  @override
  String get backupToGoogleDrive => 'Backup to Google Drive';

  @override
  String get googleDriveBackups => 'Google Drive Backups';

  @override
  String get bubbleOpacity => 'Message Opacity';

  @override
  String get bubbleOpacityHelp =>
      'Controls the transparency of message bubbles when a background is active.';

  @override
  String get swipes => 'Swipes';

  @override
  String get deleteSwipeQuestion => 'Delete swipe?';

  @override
  String get charsSuffix => 'chars';

  @override
  String get swipeDeleted => 'Swipe deleted';

  @override
  String get noAlternateSwipes => 'No alternate swipes to delete';

  @override
  String get reasoningEffort => 'Reasoning Effort';

  @override
  String get effortAuto => 'Auto';

  @override
  String get effortMin => 'Minimum';

  @override
  String get effortLow => 'Low';

  @override
  String get effortMedium => 'Medium';

  @override
  String get effortHigh => 'High';

  @override
  String get effortMax => 'Maximum';

  @override
  String get promptCaching => 'Prompt Caching';

  @override
  String get promptCachingDescription =>
      'Cache system prompt & history to reduce cost';

  @override
  String get mergeConsecutiveRoles => 'Merge Consecutive Roles';

  @override
  String get mergeConsecutiveRolesDescription =>
      'For APIs requiring strict user/assistant alternation';

  @override
  String get connectionProfiles => 'Connection Profiles';

  @override
  String get connectionProfilesHint =>
      'Save current connection for quick switching';

  @override
  String profilesSavedCount(String count) {
    return '$count saved';
  }

  @override
  String get saveCurrent => 'Save current';

  @override
  String get noProfilesHint =>
      'No profiles yet. Save the current connection to switch quickly later.';

  @override
  String appliedProfile(String name) {
    return 'Applied profile: $name';
  }

  @override
  String get saveConnectionProfile => 'Save Connection Profile';

  @override
  String get profileName => 'Profile name';

  @override
  String get gallery => 'Gallery';

  @override
  String get allLabel => 'All';

  @override
  String get ungrouped => 'Ungrouped';

  @override
  String get setAsBackground => 'Set as background';

  @override
  String get moveToFolder => 'Move to folder';

  @override
  String get folderName => 'Folder name';

  @override
  String get folderNameHint => 'Leave empty for ungrouped';

  @override
  String get move => 'Move';

  @override
  String moveFailed(String error) {
    return 'Move failed: $error';
  }

  @override
  String deleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String get embedPendingDocuments => 'Embed pending documents';

  @override
  String embeddedDocuments(String count) {
    return 'Embedded $count documents';
  }

  @override
  String get allDocumentsEmbedded => 'All documents already embedded';

  @override
  String embeddingFailed(String error) {
    return 'Embedding failed: $error';
  }

  @override
  String get gptImageSettings => 'GPT-Image Settings';

  @override
  String get qualityLabel => 'Quality';

  @override
  String get qualityAutoDescription => 'Auto - Let the model decide';

  @override
  String get qualityHighDescription => 'High - Higher detail and consistency';

  @override
  String get impersonate => 'Impersonate';

  @override
  String get impersonateHint => 'Let the AI write your next reply';

  @override
  String get startReplyWith => 'Start Reply With';

  @override
  String get startReplyWithHint => 'The AI\'s reply will start with this text';

  @override
  String get chatLorebooks => 'Chat Lorebooks';

  @override
  String get chatLorebooksHint => 'World info books active only in this chat';

  @override
  String get messagesCleared => 'All messages cleared';

  @override
  String get selectCharacterCardFiles => 'Select character card files';

  @override
  String get supportedCharacterCardFormats =>
      'Batch import supported: PNG, CharX, and JSON';

  @override
  String get importFromUrl => 'Import from URL';

  @override
  String get enterCharacterCardUrl => 'Enter a character card URL...';

  @override
  String get pasteAndImport => 'Paste and import';

  @override
  String get supportedCommunities => 'Supported communities (tap to open):';

  @override
  String get publicCardLinksSupported =>
      'Public PNG and JSON links are also supported';

  @override
  String get communityLinks => 'Community links';

  @override
  String importSummaryMixed(Object failed, Object success) {
    return 'Imported $success character cards; $failed failed';
  }

  @override
  String importSummarySuccess(Object count) {
    return 'Imported $count character cards';
  }

  @override
  String get importSummaryFailed => 'All imports failed';

  @override
  String processingProgress(Object processed, Object total) {
    return 'Processing: $processed / $total';
  }

  @override
  String get importSuccessLabel => 'Succeeded';

  @override
  String get importFailureLabel => 'Failed';

  @override
  String get totalLabel => 'Total';

  @override
  String importAllCharacters(Object count) {
    return 'Import all ($count)';
  }

  @override
  String get switchLayout => 'Switch layout';

  @override
  String get stopGenerating => 'Stop generating';

  @override
  String get imageBackgroundSettings => 'Image background settings';

  @override
  String get useCharacterImageAsBackground =>
      'Use character image as background';

  @override
  String get useCharacterImageAsBackgroundHint =>
      'Automatically use the character avatar when available';

  @override
  String get backgroundOpacity => 'Background opacity';

  @override
  String get backgroundOpacityHint =>
      'Applies to custom and character image backgrounds';

  @override
  String get enableBackgroundBlur => 'Enable background blur';

  @override
  String get enableBackgroundBlurHint =>
      'Applies blur to all image backgrounds';

  @override
  String get backgroundPriorityHint =>
      'Priority: character background > global background > character image > default color';

  @override
  String get openRouterUpstreamProvider => 'OpenRouter provider';

  @override
  String get automaticRouting => 'Automatic routing';

  @override
  String get openRouterProviderHint =>
      'Choose the upstream provider used for this model';

  @override
  String get useCurrentChatConnection => 'Use current chat connection';

  @override
  String get chatConnectionAppliedToEmbeddings =>
      'Chat endpoint and API key applied to embeddings';

  @override
  String get localFeatures => 'Local features';

  @override
  String get playHub => 'Play';

  @override
  String get story => 'Story';

  @override
  String get storyEnabledSubtitle =>
      'When this is off, chats are not analyzed and story chapters are not generated.';

  @override
  String playAiFeatureEnableTitle(String feature) {
    return 'Enable $feature?';
  }

  @override
  String playAiFeatureEnableDescription(String feature) {
    return '$feature actively sends character information and relevant conversations to your configured AI provider to generate content. It is off by default. Enable it now?';
  }

  @override
  String get playAiFeatureEnableAction => 'Enable';

  @override
  String get storyEmptyHint => 'A story appears after you chat for a while.';

  @override
  String get storyGoToChat => 'Go to chat';

  @override
  String get storyJotNote => 'Jot a note';

  @override
  String get storyJotNoteHint =>
      'Write a short note. This is not a chapter editor.';

  @override
  String get storyKeyEvents => 'What happened';

  @override
  String get storyStateChanges => 'What changed';

  @override
  String get storyOpenThreads => 'Still unresolved';

  @override
  String get storyNextSteps => 'Where this could go';

  @override
  String get storyContinue => 'Continue';

  @override
  String get storyFork => 'Fork from here';

  @override
  String get storyCompare => 'Compare outcomes';

  @override
  String get storyViewSource => 'View source';

  @override
  String get storyOriginalLine => 'Original line';

  @override
  String get storyBranchName => 'Branch name';

  @override
  String get storyBranchNameHint => 'For example: I stayed instead';

  @override
  String get storyCreateBranch => 'Create branch';

  @override
  String get storyDefaultDirection =>
      'Continue from the unresolved moment in this chapter.';

  @override
  String storyContinueDraft(String title, String direction) {
    return 'Continue \"$title\" from here: $direction';
  }

  @override
  String storyForkCreated(String name) {
    return 'Branch \"$name\" is ready.';
  }

  @override
  String get storyNoOutcome => 'No new chapter has formed on this line yet.';

  @override
  String get storyChooseTwoLines => 'Choose two lines to compare.';

  @override
  String get storyLeftLine => 'First line';

  @override
  String get storyRightLine => 'Second line';

  @override
  String get storySearch => 'Search stories';

  @override
  String get storyNoSearchResults => 'No matching chapters.';

  @override
  String get storySelectLine => 'Story line';

  @override
  String get storyNoteSaved => 'The note was added to the story.';

  @override
  String get storyNoChats => 'Start a chat before writing a story note.';

  @override
  String get storyConsequencesAfterFork => 'After the fork';

  @override
  String get moments => 'Moments';

  @override
  String get momentsDisabledEmpty =>
      'Moments is off. Turn it back on in Settings.';

  @override
  String get momentsEnabledSubtitle =>
      'When this is off, the feed stays still and characters do not post.';

  @override
  String get momentsInChat => 'Use Moments in this chat';

  @override
  String get momentsInChatHint =>
      'Off by default. When on, this character can talk about friends\' and your moments.';

  @override
  String get momentsEmpty => 'Nobody has posted yet.';

  @override
  String get momentsRefreshing => 'People are posting…';

  @override
  String get momentsCompose => 'Post';

  @override
  String get momentsComposeHint => 'What\'s on your mind…';

  @override
  String get momentsAuthor => 'Who is posting';

  @override
  String get momentsAuthorMe => 'Me';

  @override
  String get momentsAddPhoto => 'Add a photo';

  @override
  String get momentsChangePhoto => 'Change photo';

  @override
  String get momentsNeedSomething => 'Write something or add a photo first.';

  @override
  String get momentsComment => 'Comment';

  @override
  String get momentsSavePhoto => 'Save photo';

  @override
  String get momentsPhotoSaved => 'Photo saved';

  @override
  String get momentsPhotoSaveFailed => 'Unable to save photo';

  @override
  String get momentsFriends => 'Friends';

  @override
  String get momentsNoFriends =>
      'No friends yet. Characters who share a group chat can add each other.';

  @override
  String get momentsTalk => 'Talk';

  @override
  String get momentsExpose => 'Expose';

  @override
  String get momentsIgnore => 'Leave it';

  @override
  String get momentsWaiting => 'Waiting for a reply';

  @override
  String get momentsWaitingBadge => 'Waiting';

  @override
  String get momentsIgnoredBadge => 'Left unread';

  @override
  String get momentsWriteToWorld => 'Write this into the world';

  @override
  String momentsFact(String fact) {
    return 'What actually happened: $fact';
  }

  @override
  String get playFeatureComingSoon => 'This play feature is not ready yet.';

  @override
  String get openDataBank => 'Open Data Bank';

  @override
  String get openDataBankSubtitle => 'Opens the library from Play';

  @override
  String get memoryInbox => 'Memory inbox';

  @override
  String get memoryInboxSubtitle => 'Review and maintain long-term memories';

  @override
  String get dataBank => 'Data Bank';

  @override
  String get dataBankSubtitle => 'Import, search, and bind local documents';

  @override
  String get rpgScenarioEditor => 'RPG scenario editor';

  @override
  String get rpgScenarioEditorSubtitle =>
      'Create and validate local scenario packages';

  @override
  String get capabilityCheck => 'Capability check';

  @override
  String get capabilityCheckSubtitle =>
      'Availability, permissions, and configuration';

  @override
  String get mcpServers => 'MCP servers';

  @override
  String get mcpServersSubtitle =>
      'Connections, tools, permissions, and activity';

  @override
  String get toolCalling => 'Tool calling';

  @override
  String get toolCallingSubtitle => 'Built-in tools, approvals, and limits';

  @override
  String get toolCallingAllow => 'Allow tool calling';

  @override
  String get toolCallingAllowSubtitle =>
      'Providers may request only the tools enabled below';

  @override
  String get toolBuiltInTools => 'Built-in tools';

  @override
  String get toolMcpTools => 'MCP tools';

  @override
  String get toolMcpPermissionsSubtitle =>
      'Connected MCP servers use their individual permissions';

  @override
  String get toolSafetyLimits => 'Safety limits';

  @override
  String get toolRounds => 'Tool rounds';

  @override
  String get toolCallsPerResponse => 'Calls per response';

  @override
  String get toolTimeLimit => 'Time limit';

  @override
  String get toolTokenBudget => 'Tool token budget';

  @override
  String get toolSeconds => 'seconds';

  @override
  String get toolTokens => 'tokens';

  @override
  String toolDecrease(String control) {
    return 'Decrease $control';
  }

  @override
  String toolIncrease(String control) {
    return 'Increase $control';
  }

  @override
  String get toolActivity => 'Tool activity';

  @override
  String get toolApprovalRequired => 'Approval required';

  @override
  String get toolAllowOnce => 'Allow once';

  @override
  String get toolAlwaysAllow => 'Always allow';

  @override
  String get toolDeny => 'Deny';

  @override
  String get toolCancelCall => 'Cancel tool call';

  @override
  String get toolStatusWaitingApproval => 'Waiting for approval';

  @override
  String get toolStatusRunning => 'Running';

  @override
  String get toolStatusSucceeded => 'Succeeded';

  @override
  String get toolStatusFailed => 'Failed';

  @override
  String get toolStatusDenied => 'Denied';

  @override
  String get toolStatusCancelled => 'Cancelled';

  @override
  String get storageManagement => 'Storage management';

  @override
  String get storageManagementSubtitle =>
      'Usage, orphan scanning, and safe cleanup';

  @override
  String storageUsedOfQuota(String used, String quota) {
    return '$used used of $quota';
  }

  @override
  String get storageQuotaWarning =>
      'Storage usage is above the warning threshold';

  @override
  String get storageWithinQuota =>
      'Storage usage is within the warning threshold';

  @override
  String storageScanIncomplete(int count) {
    return '$count path(s) could not be inspected';
  }

  @override
  String get storageCategoryLive2d => 'Live2D models';

  @override
  String get storageCategoryAttachments => 'Attachments and media';

  @override
  String get storageCategoryDataBank => 'Data Bank documents';

  @override
  String get storageCategoryAudio => 'Audio';

  @override
  String get storageCategoryCache => 'Cache';

  @override
  String storageFilesCount(int count) {
    return '$count file(s)';
  }

  @override
  String storageReclaimable(String size) {
    return '$size reclaimable';
  }

  @override
  String get storageCleanupCandidates => 'Safe cleanup';

  @override
  String get storageNoCleanupCandidates =>
      'No unreferenced or expired files found';

  @override
  String get storageSelectAll => 'Select all';

  @override
  String get storageClearSelection => 'Clear selection';

  @override
  String get storageUndo => 'Undo';

  @override
  String get storageCleanSelected => 'Clean selected';

  @override
  String get storageCleanupReviewTitle => 'Review cleanup';

  @override
  String storageCleanupReviewBody(int items, int files, String size) {
    return 'Move $items item(s), containing $files file(s) and using $size, to recoverable trash?';
  }

  @override
  String get storageCleanupRecoverableHint =>
      'Referenced files are protected. You can undo until staged files are permanently removed.';

  @override
  String storageCleanupMoved(int count) {
    return '$count item(s) moved to recoverable trash';
  }

  @override
  String get storageCleanupRestored => 'Cleanup undone';

  @override
  String get storageCleanupCompleted => 'Cleanup completed';

  @override
  String storageCleanupFailed(String error) {
    return 'Cleanup failed: $error';
  }

  @override
  String get storageReasonInterruptedTemporary => 'Interrupted temporary data';

  @override
  String get storageReasonMissingDatabaseReference =>
      'No database document references this data';

  @override
  String get storageReasonInterruptedDocumentCleanup =>
      'Interrupted document cleanup';

  @override
  String get storageReasonMissingFileReference =>
      'No database record references this file';

  @override
  String get storageReasonExpiredTransient => 'Expired transient data';

  @override
  String get storageReasonExpiredAudio => 'Expired synthesized audio';

  @override
  String get live2dUnavailableModelMessage =>
      'The assigned Live2D model is unavailable. Choose another model or import it again.';

  @override
  String get live2dSelectionExpiredMessage =>
      'That Live2D model is no longer available. Choose another model or import it again.';

  @override
  String live2dModelsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Live2D models imported',
      one: 'Live2D model imported',
    );
    return '$_temp0';
  }

  @override
  String get live2dModelDeleted => 'Imported Live2D model deleted.';

  @override
  String get live2dCleanupPending =>
      ' File cleanup will be retried on the next library refresh.';

  @override
  String get live2dDeleteImportedModelQuestion => 'Delete imported model?';

  @override
  String live2dDeletePackageBody(int count) {
    return 'This package contains $count models. All of them will be deleted.';
  }

  @override
  String live2dDeleteModelBody(String name) {
    return '\"$name\" will be deleted from this device.';
  }

  @override
  String get live2dDisabledFor => 'Live2D will be disabled for:';

  @override
  String get live2dLicensing => 'Live2D licensing';

  @override
  String get live2dLicenseNotice =>
      'The renderer includes the Live2D Cubism SDK and Core. Model files and commercial distribution may have separate terms.\n\nThe bundled Hiyori Momose model is official sample data owned and copyrighted by Live2D Inc. It is used under the Live2D Free Material License Agreement and Sample Data Terms of Use. This app itself is created at the author\'s sole discretion.\n\nVerify the rights for every imported model before publishing the app.';

  @override
  String get live2dReviewTerms => 'Review terms';

  @override
  String live2dUnavailableLabel(String name) {
    return '$name (Unavailable)';
  }

  @override
  String live2dImportedLabel(String name) {
    return '$name (Imported)';
  }

  @override
  String get live2dImportZip => 'Import model';

  @override
  String get live2dMotion => 'Motion';

  @override
  String get live2dPlayMotion => 'Play motion';

  @override
  String get live2dStageAdjustment => 'Stage adjustment';

  @override
  String get live2dMotionSpeed => 'Motion speed';

  @override
  String get live2dImportedModels => 'Imported models';

  @override
  String live2dModelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count models',
      one: '1 model',
    );
    return '$_temp0';
  }

  @override
  String get live2dDeleteImportedModel => 'Delete imported model';

  @override
  String get rpgScenarioTitle => 'RPG Scenario';

  @override
  String get rpgImportScenario => 'Import scenario';

  @override
  String get rpgSaveDraft => 'Save draft';

  @override
  String get rpgRestoreDraft => 'Restore draft';

  @override
  String get rpgExportScenario => 'Export scenario';

  @override
  String get rpgIssues => 'Issues';

  @override
  String rpgIssuesCount(int count) {
    return 'Issues ($count)';
  }

  @override
  String get rpgScenarioImportFailed => 'Scenario import failed';

  @override
  String rpgScenarioImported(String name) {
    return 'Imported $name';
  }

  @override
  String get rpgDraftSaved => 'Draft saved';

  @override
  String get rpgDraftRestored => 'Draft restored';

  @override
  String get rpgNoSavedDraft => 'No saved draft';

  @override
  String get rpgScenarioExported => 'Scenario exported';

  @override
  String get rpgSetValue => 'Set value';

  @override
  String rpgAddItem(String label) {
    return 'Add $label';
  }

  @override
  String get rpgItemActions => 'Item actions';

  @override
  String get rpgMoveUp => 'Move up';

  @override
  String get rpgMoveDown => 'Move down';

  @override
  String get rpgAddEntry => 'Add entry';

  @override
  String get rpgDeleteEntry => 'Delete entry';

  @override
  String rpgAddEntryTitle(String label) {
    return 'Add $label entry';
  }

  @override
  String get rpgValue => 'Value';

  @override
  String get rpgEnterInteger => 'Enter an integer';

  @override
  String get rpgEnterNumber => 'Enter a number';

  @override
  String rpgItemNumber(int number) {
    return 'Item $number';
  }

  @override
  String rpgFieldLabel(String field) {
    String _temp0 = intl.Intl.selectLogic(
      field,
      {
        'metadata': 'Metadata',
        'compatibility': 'Compatibility',
        'initialState': 'Initial State',
        'initialSeed': 'Initial Seed',
        'schemaVersion': 'Schema Version',
        'protectedFields': 'Protected Fields',
        'minimumEngineVersion': 'Minimum Engine Version',
        'maximumEngineVersion': 'Maximum Engine Version',
        'requiredCapabilities': 'Required Capabilities',
        'actors': 'Actors',
        'attributes': 'Attributes',
        'author': 'Author',
        'availability': 'Availability',
        'branchId': 'Branch ID',
        'conditions': 'Conditions',
        'cooldowns': 'Cooldowns',
        'costs': 'Costs',
        'createdAt': 'Created At',
        'data': 'Data',
        'day': 'Day',
        'description': 'Description',
        'difficulty': 'Difficulty',
        'effects': 'Effects',
        'elapsedMinutes': 'Elapsed Minutes',
        'eventHistory': 'Event History',
        'expression': 'Expression',
        'failureEffects': 'Failure Effects',
        'format': 'Format',
        'id': 'ID',
        'initialValue': 'Initial Value',
        'inventory': 'Inventory',
        'items': 'Items',
        'label': 'Label',
        'locations': 'Locations',
        'maximum': 'Maximum',
        'minimum': 'Minimum',
        'minuteOfDay': 'Minute of Day',
        'name': 'Name',
        'narrative': 'Narrative',
        'objectiveIds': 'Objective IDs',
        'objectiveProgress': 'Objective Progress',
        'operator': 'Operator',
        'quantity': 'Quantity',
        'quests': 'Quests',
        'relationships': 'Relationships',
        'source': 'Source',
        'stages': 'Stages',
        'status': 'Status',
        'successEffects': 'Success Effects',
        'summary': 'Summary',
        'tags': 'Tags',
        'target': 'Target',
        'turn': 'Turn',
        'type': 'Type',
        'updatedAt': 'Updated At',
        'value': 'Value',
        'variables': 'Variables',
        'version': 'Version',
        'other': '$field',
      },
    );
    return '$_temp0';
  }

  @override
  String get dataBankChatRetrievalSettings => 'Chat retrieval settings';

  @override
  String get dataBankRebuildSearchIndex => 'Rebuild search index';

  @override
  String get dataBankImportDocument => 'Import document';

  @override
  String get dataBankSearchDocuments => 'Search documents';

  @override
  String get dataBankClearSearch => 'Clear search';

  @override
  String get dataBankNoMatches => 'No matches';

  @override
  String get dataBankNoDocuments => 'No documents';

  @override
  String get dataBankSearchIndexRebuilt => 'Search index rebuilt';

  @override
  String dataBankDeleteDocumentQuestion(String name) {
    return 'Delete $name?';
  }

  @override
  String dataBankDeleteDocumentBody(
      int versions, int chunks, int bindings, int files) {
    return '$versions version(s), $chunks chunk(s), $bindings binding(s), and $files managed file(s) will be removed.';
  }

  @override
  String get dataBankChatRetrieval => 'Chat retrieval';

  @override
  String get dataBankUseInChat => 'Use Data Bank in chat';

  @override
  String get dataBankQueryExpansion => 'Conversation-aware query expansion';

  @override
  String get dataBankSemanticReranking => 'Semantic reranking';

  @override
  String get dataBankUsesEmbeddingProvider =>
      'Uses the configured Embedding provider';

  @override
  String get dataBankSourcesPerResponse => 'Sources per response';

  @override
  String get dataBankTokenBudget => 'Token budget';

  @override
  String get dataBankChunksPerDocument => 'Chunks per document';

  @override
  String get dataBankLastRetrieval => 'Last retrieval';

  @override
  String get dataBankNoRetrievalYet => 'No chat retrieval has run yet.';

  @override
  String get dataBankModeLocalFts => 'Local full-text search';

  @override
  String get dataBankModeSemantic => 'Hybrid semantic reranking';

  @override
  String get dataBankModeFallback => 'Local fallback';

  @override
  String dataBankSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return '$_temp0';
  }

  @override
  String get dataBankInspectAllSources => 'Inspect all sources';

  @override
  String dataBankChunksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chunks',
      one: '1 chunk',
    );
    return '$_temp0';
  }

  @override
  String dataBankBindingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bindings',
      one: '1 binding',
    );
    return '$_temp0';
  }

  @override
  String get dataBankProcessingFailed => 'Processing failed';

  @override
  String get dataBankManageBindings => 'Manage bindings';

  @override
  String get dataBankRebuildDocument => 'Rebuild document';

  @override
  String get dataBankBindings => 'Bindings';

  @override
  String get dataBankRemoveBinding => 'Remove binding';

  @override
  String get dataBankAddBinding => 'Add binding';

  @override
  String dataBankStatusSemantics(String status) {
    return 'Status: $status';
  }

  @override
  String get dataBankDismiss => 'Dismiss';

  @override
  String get dataBankStatePending => 'Pending';

  @override
  String get dataBankStateProcessing => 'Processing';

  @override
  String get dataBankStateReady => 'Ready';

  @override
  String get dataBankStateFailed => 'Failed';

  @override
  String get dataBankStateDeleted => 'Deleted';

  @override
  String get dataBankDuplicateDocument =>
      'This document is already in the Data Bank.';

  @override
  String get memoryChatContext => 'Chat context';

  @override
  String get memoryAutomaticExtraction => 'Automatic extraction';

  @override
  String get memoryAutomaticExtractionSubtitle =>
      'Uses the current AI connection after new turns';

  @override
  String get memoryRecentChat => 'Recent chat';

  @override
  String get memoryCancelExtraction => 'Cancel extraction';

  @override
  String get memoryExtractFromChat => 'Extract from chat';

  @override
  String memoryExtractionResult(int candidates, int duplicates, int rejected) {
    return '$candidates candidates, $duplicates duplicates, $rejected rejected';
  }

  @override
  String memoryCandidatesCount(int count) {
    return 'Candidates $count';
  }

  @override
  String memoryActiveCount(int count) {
    return 'Active $count';
  }

  @override
  String memoryHistoryCount(int count) {
    return 'History $count';
  }

  @override
  String get memoryCreate => 'Create memory';

  @override
  String get memoryClearSelection => 'Clear selection';

  @override
  String get memoryIgnoreSelected => 'Ignore selected';

  @override
  String get memoryMergeSelected => 'Merge selected';

  @override
  String memorySelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get memoryUseInChat => 'Use memories in chat';

  @override
  String get memorySemanticReranking => 'Semantic reranking';

  @override
  String get memoryConfiguredEmbeddingProvider =>
      'Configured embedding provider';

  @override
  String get memoryContextBudget => 'Context budget';

  @override
  String memoryTokensCount(int count) {
    return '$count tokens';
  }

  @override
  String get memoryEdit => 'Edit memory';

  @override
  String get memoryMerge => 'Merge memories';

  @override
  String memoryImportancePercent(int percent) {
    return '$percent% importance';
  }

  @override
  String memoryExpires(String date) {
    return 'Expires $date';
  }

  @override
  String get memoryApprove => 'Approve';

  @override
  String get memoryUnlock => 'Unlock';

  @override
  String get memoryLock => 'Lock';

  @override
  String get memoryOpenSource => 'Open source';

  @override
  String get memoryIgnore => 'Ignore';

  @override
  String get memoryChatScope => 'Chat scope';

  @override
  String get memoryKind => 'Kind';

  @override
  String get memoryLabel => 'Memory';

  @override
  String get memoryIdentityKey => 'Identity key';

  @override
  String get memoryImportance => 'Importance';

  @override
  String get memoryLocked => 'Locked';

  @override
  String get memoryKindPersonFact => 'Person fact';

  @override
  String get memoryKindRelationship => 'Relationship';

  @override
  String get memoryKindEvent => 'Event';

  @override
  String get memoryKindCommitment => 'Commitment';

  @override
  String get memoryKindPreference => 'Preference';

  @override
  String get memoryKindLocation => 'Location';

  @override
  String get memoryKindOther => 'Other';

  @override
  String get memoryScopeCharacterPersona => 'Character and persona';

  @override
  String get memoryScopeGroup => 'Group';

  @override
  String get mcpAddServer => 'Add MCP server';

  @override
  String get mcpServersTab => 'Servers';

  @override
  String get mcpActivityTab => 'Activity';

  @override
  String get mcpProtocolName => 'Model Context Protocol';

  @override
  String get mcpNoServers => 'No MCP servers';

  @override
  String mcpErrorCode(String code) {
    return 'Code: $code';
  }

  @override
  String mcpProtocolVersion(String version) {
    return 'Protocol $version';
  }

  @override
  String get mcpDisconnect => 'Disconnect';

  @override
  String get mcpRefreshTools => 'Refresh tools';

  @override
  String get mcpReconnect => 'Reconnect';

  @override
  String get mcpConnect => 'Connect';

  @override
  String get mcpEditServer => 'Edit MCP server';

  @override
  String get mcpRemoveServer => 'Remove MCP server';

  @override
  String get mcpNoToolsDiscovered => 'No tools discovered';

  @override
  String get mcpRemoveServerQuestion => 'Remove MCP server?';

  @override
  String get mcpRemove => 'Remove';

  @override
  String get mcpToolPermission => 'Tool permission';

  @override
  String get mcpAskEveryTime => 'Ask every time';

  @override
  String get mcpAlwaysAllow => 'Always allow';

  @override
  String get mcpDenied => 'Denied';

  @override
  String get mcpNoActivity => 'No MCP activity';

  @override
  String get mcpEndpoint => 'MCP endpoint';

  @override
  String get mcpTransport => 'Transport';

  @override
  String get mcpBearerToken => 'Bearer token';

  @override
  String get mcpShowToken => 'Show token';

  @override
  String get mcpHideToken => 'Hide token';

  @override
  String get mcpRemoveStoredToken => 'Remove stored token';

  @override
  String get mcpAllowInsecureHttp => 'Allow insecure HTTP';

  @override
  String get mcpServerEnabled => 'Server enabled';

  @override
  String get mcpDisconnected => 'Disconnected';

  @override
  String get mcpConnecting => 'Connecting';

  @override
  String get mcpConnected => 'Connected';

  @override
  String get mcpReconnecting => 'Reconnecting';

  @override
  String get mcpReadOnlyHint => 'Read-only hint';

  @override
  String get mcpWriteCapable => 'Write-capable';

  @override
  String get mcpExternalSideEffect => 'External side effect';

  @override
  String get capabilityCheckFailed => 'Capability check failed';

  @override
  String get capabilityRecentExternalActivity => 'Recent external activity';

  @override
  String get capabilityAuditUnavailable => 'Audit history unavailable';

  @override
  String get capabilityNoExternalCalls => 'No external calls recorded';

  @override
  String capabilityReadyCount(int ready, int total) {
    return '$ready of $total ready';
  }

  @override
  String get capabilityOpenSettings => 'Open settings';

  @override
  String get capabilityRequestPermission => 'Request permission';

  @override
  String get capabilityCurrentAi => 'Current AI';

  @override
  String get capabilitySystemSpeech => 'System speech';

  @override
  String get capabilityVoiceInput => 'Voice input';

  @override
  String get capabilitySemanticSearch => 'Semantic search';

  @override
  String get capabilityMcpTools => 'MCP tools';

  @override
  String get capabilityChatGenerationConnection => 'Chat generation connection';

  @override
  String get capabilityDeviceTts => 'Device text-to-speech';

  @override
  String get capabilityDeviceSpeechRecognition => 'Device speech recognition';

  @override
  String get capabilityOptionalEmbeddingConnection =>
      'Optional embedding connection';

  @override
  String get capabilityOptionalImageConnection => 'Optional image connection';

  @override
  String get capabilityExternalToolServers => 'External tool servers';

  @override
  String get capabilityBundledCharacterRendering =>
      'Bundled character rendering';

  @override
  String get capabilityCompleteAiConnection =>
      'Complete the current AI connection';

  @override
  String get capabilityCompleteEmbeddingConnection =>
      'Complete the embedding connection';

  @override
  String get capabilityCompleteImageConnection =>
      'Complete the image connection';

  @override
  String get capabilityConfigurationRequired => 'Configuration required';

  @override
  String get capabilityConfigured => 'Configured';

  @override
  String get capabilityAvailable => 'Available';

  @override
  String get capabilityPermissionRequired => 'Permission required';

  @override
  String get capabilityPermissionDenied => 'Permission denied';

  @override
  String get capabilityDownloadRequired => 'Download required';

  @override
  String get capabilityUnavailableOffline => 'Unavailable while offline';

  @override
  String get capabilityUnavailableBuild => 'Not available in this build';

  @override
  String get capabilityDataMetadata => 'metadata';

  @override
  String get capabilityDataPrompt => 'prompt';

  @override
  String get capabilityDataChatText => 'chat text';

  @override
  String get capabilityDataDocumentText => 'document text';

  @override
  String get capabilityDataImage => 'image';

  @override
  String get capabilityDataAudio => 'audio';

  @override
  String get capabilityDataCharacterCard => 'character card';

  @override
  String get capabilityDataToolArguments => 'tool arguments';

  @override
  String dataBankCitationSourcesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Data Bank sources',
      one: '1 Data Bank source',
    );
    return '$_temp0';
  }

  @override
  String get dataBankCitationSources => 'Data Bank sources';

  @override
  String dataBankLocalQueriesFused(int count) {
    return '$count local queries fused';
  }

  @override
  String get memoryUsed => 'Memories used';

  @override
  String memoryTokenUsage(int used, int allocated) {
    return '$used/$allocated tokens';
  }

  @override
  String memoryRelevancePercent(int percent) {
    return '$percent% relevance';
  }

  @override
  String get memoryModeLocalFts => 'Local FTS';

  @override
  String get memoryModeHybrid => 'Hybrid';

  @override
  String get memoryModeLocalFallback => 'Local FTS fallback';

  @override
  String get memoryIncluded => 'Included';

  @override
  String get memoryTrimmed => 'Trimmed';

  @override
  String get memoryExcluded => 'Excluded';

  @override
  String rpgTurnNumber(int turn) {
    return 'Turn $turn';
  }

  @override
  String get rpgDisableMode => 'Disable RPG mode';

  @override
  String get rpgStatus => 'Status';

  @override
  String get rpgInventory => 'Inventory';

  @override
  String get rpgQuests => 'Quests';

  @override
  String get rpgRelations => 'Relations';

  @override
  String get rpgActions => 'Actions';

  @override
  String get rpgLog => 'Log';

  @override
  String get rpgLocation => 'Location';

  @override
  String get rpgTime => 'Time';

  @override
  String rpgDayTime(int day, String time) {
    return 'Day $day, $time';
  }

  @override
  String get rpgInventoryEmpty => 'Inventory is empty';

  @override
  String get rpgNoQuests => 'No quests';

  @override
  String get rpgNoRelationships => 'No relationships';

  @override
  String get rpgNoActions => 'No actions defined';

  @override
  String rpgCost(String cost) {
    return 'Cost: $cost';
  }

  @override
  String rpgCheck(String dice, String attribute, num difficulty) {
    return 'Check: $dice + $attribute vs $difficulty';
  }

  @override
  String rpgCooldown(int turns) {
    return 'Cooldown: $turns turn(s)';
  }

  @override
  String get rpgRequirementsNotMet => 'Requirements or resources not met';

  @override
  String get rpgNoTurnsRecorded => 'No turns recorded';

  @override
  String get rpgSnapshots => 'Snapshots';

  @override
  String get rpgSnapshotActions => 'Snapshot actions';

  @override
  String get rpgRestoreSnapshot => 'Restore snapshot';

  @override
  String get rpgForkNewBranch => 'Fork new branch';

  @override
  String get rpgRuleEngineSource => 'Source: Rule engine';

  @override
  String rpgRoll(String total, String expression) {
    return 'Roll: $total ($expression)';
  }

  @override
  String rpgChanges(String changes) {
    return 'Changes: $changes';
  }

  @override
  String get rpgForkBranch => 'Fork branch';

  @override
  String get rpgBranchId => 'Branch ID';

  @override
  String get rpgFork => 'Fork';

  @override
  String get rpgQuestInactive => 'Inactive';

  @override
  String get rpgQuestActive => 'Active';

  @override
  String get rpgQuestCompleted => 'Completed';

  @override
  String get rpgQuestFailed => 'Failed';

  @override
  String get rpgEnableMode => 'Enable RPG mode';

  @override
  String get noImageGenerated => 'No image was generated';

  @override
  String failedToSaveImage(String error) {
    return 'Failed to save image: $error';
  }

  @override
  String imagesAdded(int count) {
    return 'Added $count image(s)';
  }

  @override
  String get addConnection => 'Add connection';

  @override
  String get group => 'Group';

  @override
  String get lockType => 'Lock type';

  @override
  String errorLoadingCharacters(String error) {
    return 'Failed to load characters: $error';
  }

  @override
  String errorLoadingGroups(String error) {
    return 'Failed to load groups: $error';
  }

  @override
  String get inSystemPrompt => 'In system prompt';

  @override
  String get connectingGoogleDrive => 'Connecting to Google Drive...';

  @override
  String get checkingICloud => 'Checking iCloud...';

  @override
  String get whatIsPromptManager => 'What is the Prompt Manager?';

  @override
  String get promptManagerHelpDescription =>
      'The Prompt Manager controls how the system prompt is assembled before messages are sent to the AI. You can reorder sections and enable or disable them.';

  @override
  String get promptSectionTypes => 'Section types';

  @override
  String get promptSectionTypesDescription =>
      'Sections can include system instructions, persona and character details, scenario, lorebook context, example messages, author\'s notes, chat history, and post-history instructions.';

  @override
  String get tips => 'Tips';

  @override
  String get promptManagerTips =>
      'Sections near the top have higher priority. Disable sections you do not need to save tokens, and adjust their order for different results.';

  @override
  String get customImportedPrompt => 'Custom prompt from an imported preset';

  @override
  String editPromptSection(String name) {
    return 'Edit $name';
  }

  @override
  String get promptName => 'Prompt name';

  @override
  String identifierLabel(String identifier) {
    return 'ID: $identifier';
  }

  @override
  String roleLabel(String role) {
    return 'Role: $role';
  }

  @override
  String supportedPromptMacros(
      String userMacro, String charMacro, String timeMacro, String dateMacro) {
    return 'Supports macros such as $userMacro, $charMacro, $timeMacro, and $dateMacro.';
  }

  @override
  String get enterPromptContent => 'Enter prompt content...';

  @override
  String updated(String name) {
    return 'Updated $name';
  }

  @override
  String get customPrompt => 'Custom prompt';

  @override
  String get promptSectionSystemPrompt => 'System prompt';

  @override
  String get promptSectionSystemPromptDescription =>
      'Base roleplay instructions';

  @override
  String get promptSectionPersona => 'User persona';

  @override
  String get promptSectionPersonaDescription => 'Your persona information';

  @override
  String get promptSectionCharacterDescription => 'Character description';

  @override
  String get promptSectionCharacterDescriptionDescription =>
      'The AI character\'s details';

  @override
  String get promptSectionCharacterPersonality => 'Character personality';

  @override
  String get promptSectionCharacterPersonalityDescription =>
      'The character\'s personality traits';

  @override
  String get promptSectionScenario => 'Scenario';

  @override
  String get promptSectionScenarioDescription =>
      'Current situation and setting';

  @override
  String get promptSectionExampleMessages => 'Example messages';

  @override
  String get promptSectionExampleMessagesDescription =>
      'Sample dialogue that demonstrates style';

  @override
  String get promptSectionWorldInfoBefore => 'Lorebook before';

  @override
  String get promptSectionWorldInfoBeforeDescription =>
      'Lorebook context inserted before character details';

  @override
  String get promptSectionWorldInfoAfter => 'Lorebook after';

  @override
  String get promptSectionWorldInfoAfterDescription =>
      'Lorebook context inserted after character details';

  @override
  String get promptSectionAuthorNote => 'Author\'s note';

  @override
  String get promptSectionAuthorNoteDescription =>
      'Dynamic instructions for the current chat';

  @override
  String get promptSectionPostHistory => 'Post-history instructions';

  @override
  String get promptSectionPostHistoryDescription =>
      'Instructions inserted after chat history';

  @override
  String get promptSectionNsfw => 'NSFW prompt';

  @override
  String get promptSectionNsfwDescription =>
      'Optional mature-content instructions';

  @override
  String get promptSectionChatHistory => 'Chat history';

  @override
  String get promptSectionChatHistoryDescription =>
      'Recent messages from the conversation';

  @override
  String get promptSectionEnhanceDefinitions => 'Enhance definitions';

  @override
  String get promptSectionEnhanceDefinitionsDescription =>
      'Additional instructions that reinforce character definitions';

  @override
  String get promptSectionCustomDescription => 'A custom prompt section';

  @override
  String get reasoning => 'Reasoning';

  @override
  String get emotionNeutral => 'Neutral';

  @override
  String get emotionHappy => 'Happy';

  @override
  String get emotionSad => 'Sad';

  @override
  String get emotionAngry => 'Angry';

  @override
  String get emotionSurprised => 'Surprised';

  @override
  String get emotionScared => 'Scared';

  @override
  String get emotionDisgusted => 'Disgusted';

  @override
  String get emotionConfused => 'Confused';

  @override
  String get emotionEmbarrassed => 'Embarrassed';

  @override
  String get emotionExcited => 'Excited';

  @override
  String get emotionLoving => 'Loving';

  @override
  String get emotionThinking => 'Thinking';

  @override
  String get emotionSmug => 'Smug';

  @override
  String get emotionTired => 'Tired';

  @override
  String get emotionBored => 'Bored';

  @override
  String get tokenizerHelpContent =>
      'The tokenizer estimates how much text a model can process. Choose the tokenizer that matches your model, or use Best Match to select one automatically.';

  @override
  String get tokenizerNoneEstimate => 'None (estimate only)';

  @override
  String get tokenizerBestMatchAuto => 'Best match (automatic)';

  @override
  String get tokenizerEstimateDescription =>
      'Quick character-based token estimate';

  @override
  String get tokenizerGpt2Description =>
      'GPT-2 tokenizer for older GPT-style models';

  @override
  String get tokenizerOaiDescription =>
      'OAI Compatible tiktoken tokenizer for GPT models';

  @override
  String get tokenizerLlamaDescription =>
      'SentencePiece tokenizer for Llama models';

  @override
  String get tokenizerLlama3Description => 'Tokenizer for Llama 3 models';

  @override
  String get tokenizerMistralDescription => 'Tokenizer for Mistral models';

  @override
  String get tokenizerClaudeDescription =>
      'Tokenizer estimate for Claude models';

  @override
  String get tokenizerGemmaDescription => 'Tokenizer for Gemma models';

  @override
  String get tokenizerQwenDescription => 'Tokenizer for Qwen models';

  @override
  String get tokenizerDeepSeekDescription => 'Tokenizer for DeepSeek models';

  @override
  String get tokenizerCommandRDescription => 'Tokenizer for Command R models';

  @override
  String get tokenizerNemoDescription => 'Tokenizer for Mistral NeMo models';

  @override
  String get tokenizerBestMatchDescription =>
      'Automatically choose a tokenizer based on the active model';

  @override
  String get showOriginal => 'Show original';

  @override
  String get showOriginalDescription =>
      'Display original text alongside the translation';

  @override
  String get swapLanguages => 'Swap languages';

  @override
  String get aboutTranslation => 'About translation';

  @override
  String get aboutTranslationDescription =>
      'Translate messages automatically or on demand so you can communicate in different languages.';

  @override
  String get googleTranslate => 'Google Translate';

  @override
  String get googleTranslateDescription =>
      'Uses Google Cloud Translation API and requires a Google Cloud API key.';

  @override
  String get deepL => 'DeepL';

  @override
  String get deepLDescription =>
      'High-quality neural machine translation. Requires an API key from deepl.com.';

  @override
  String get libreTranslate => 'LibreTranslate';

  @override
  String get libreTranslateDescription =>
      'Free and open-source translation that can be self-hosted or use a public instance.';

  @override
  String get queueMessages => 'Queue messages';

  @override
  String get queueMessagesDescription =>
      'Queue multiple messages instead of interrupting the current speech';

  @override
  String get loadingVoices => 'Loading voices...';

  @override
  String get failedToLoadVoices => 'Failed to load voices';

  @override
  String get ttsTestPhrase =>
      'Hello! This is a test of the text-to-speech system. The quick brown fox jumps over the lazy dog.';

  @override
  String get aboutTts => 'About text-to-speech';

  @override
  String get aboutTtsDescription =>
      'Text-to-speech reads messages aloud. You can configure different voices for individual characters in character settings.';

  @override
  String get systemTts => 'System text-to-speech';

  @override
  String get systemTtsDetails =>
      'Uses your device\'s built-in text-to-speech engine. Available voices depend on system settings.';

  @override
  String get elevenLabsDescription =>
      'High-quality AI voices. Requires an API key from elevenlabs.io.';

  @override
  String get clearGlobalVariables => 'Clear global variables';

  @override
  String get clearLocalVariables => 'Clear local variables';

  @override
  String get aboutVariables => 'About variables';

  @override
  String get variableSystemDescription =>
      'Variables store reusable values globally or for the current chat. Reference them in prompts with macros.';

  @override
  String get macroUsage => 'Macro usage';

  @override
  String macroUsageDescription(String localMacro, String globalMacro) {
    return 'Use $localMacro for local variables and $globalMacro for global variables. You can also set values with variable macros.';
  }

  @override
  String get noGlobalVariables => 'No global variables';

  @override
  String get noLocalVariables => 'No local variables';

  @override
  String editVariable(String name) {
    return 'Edit $name';
  }

  @override
  String get deleteVariable => 'Delete variable';

  @override
  String deleteVariableQuestion(String name) {
    return 'Delete variable \"$name\"?';
  }

  @override
  String clearVariables(String scope) {
    return 'Clear $scope variables';
  }

  @override
  String clearVariablesConfirmation(String scope) {
    return 'Clear all $scope variables? This cannot be undone.';
  }

  @override
  String get decrement => 'Decrease';

  @override
  String get increment => 'Increase';

  @override
  String get testInput => 'Test input';

  @override
  String get variableTestHint => 'Enter text containing variable macros...';

  @override
  String get processMacros => 'Process macros';

  @override
  String get result => 'Result';

  @override
  String get emptyString => '(empty string)';

  @override
  String get retrievalAugmentedGeneration =>
      'Retrieval-augmented generation (RAG)';

  @override
  String get searchSettings => 'Search settings';

  @override
  String topKResultsDescription(int count) {
    return 'Return up to $count matching results';
  }

  @override
  String minimumPercent(String percent) {
    return 'Minimum similarity: $percent%';
  }

  @override
  String get promptIntegration => 'Prompt integration';

  @override
  String get includeInPrompt => 'Include in prompt';

  @override
  String get automaticallyAddContext =>
      'Automatically add relevant context to the prompt';

  @override
  String get promptTemplate => 'Prompt template';

  @override
  String useContextPlaceholder(String contextMacro) {
    return 'Use $contextMacro where retrieved content should appear';
  }

  @override
  String get vectorStorageHelp => 'Vector storage help';

  @override
  String get vectorStorageHelpContent =>
      'Vector storage converts documents into embeddings and retrieves relevant passages for each message. Configure an embedding provider, create a collection, add documents, and enable prompt integration.';

  @override
  String get enterCollectionName => 'Enter collection name';

  @override
  String get deleteCollection => 'Delete collection';

  @override
  String get deleteCollectionConfirmation =>
      'Delete this collection and all of its documents?';

  @override
  String get collectionExported => 'Collection exported';

  @override
  String get importCollection => 'Import collection';

  @override
  String get pasteCollectionJson => 'Paste collection JSON...';

  @override
  String get collectionImported => 'Collection imported';

  @override
  String get activeCollection => 'Active collection';

  @override
  String collectionWithDocumentCount(String name, int count) {
    return '$name ($count documents)';
  }

  @override
  String documentsCount(int count) {
    return '$count documents';
  }

  @override
  String embeddedCount(String percent) {
    return '$percent embedded';
  }

  @override
  String get addDocument => 'Add document';

  @override
  String get viewDocuments => 'View documents';

  @override
  String get enterDocumentContent => 'Enter document content';

  @override
  String get documentAdded => 'Document added';

  @override
  String get noDocuments => 'No documents';

  @override
  String documentEmbeddingStatus(int characters, String status) {
    return '$characters characters - $status';
  }

  @override
  String get embedded => 'Embedded';

  @override
  String get notEmbedded => 'Not embedded';

  @override
  String get tokenProbabilities => 'Token probabilities';

  @override
  String get requestTokenProbabilities => 'Request token probabilities';

  @override
  String get requestTokenProbabilitiesDescription =>
      'Ask the model to return probability data for generated tokens';

  @override
  String get topCandidatesCount => 'Top candidates';

  @override
  String topCandidatesDescription(int count) {
    return 'Show up to $count alternatives per token';
  }

  @override
  String get showLogprobsPanel => 'Show token probability panel';

  @override
  String get showLogprobsPanelDescription =>
      'Display token probabilities below supported messages';

  @override
  String get colorIntensity => 'Color intensity';

  @override
  String get aboutTokenProbabilities => 'About token probabilities';

  @override
  String get tokenProbabilitiesDescription =>
      'Token probabilities show how confident the model was and which alternatives it considered. Availability depends on the active API and model.';

  @override
  String get moreFormatting => 'More formatting';

  @override
  String get readAloud => 'Read aloud';

  @override
  String get openInBrowser => 'Open in browser';

  @override
  String get imageLoadFailed => 'Failed to load image';

  @override
  String get pauseReading => 'Pause reading';

  @override
  String get resumeReading => 'Resume reading';

  @override
  String get stopReading => 'Stop reading';

  @override
  String get noTagsAvailable => 'No tags available';

  @override
  String rerollAlternativeNotImplemented(String alternative) {
    return 'Rerolling with \"$alternative\" is not implemented yet';
  }

  @override
  String get enableTokenProbabilitiesHint =>
      'Enable token probabilities in settings to view this data';

  @override
  String get noTokenProbabilities => 'No token probability data available';

  @override
  String get noAlternativeTokens => 'No alternative tokens';

  @override
  String get alternativeTokens => 'Alternative tokens';

  @override
  String get otherTokens => 'Other tokens';

  @override
  String get chooseRpgScenario => 'Choose an RPG scenario';

  @override
  String get importScenario => 'Import scenario';

  @override
  String get noSavedScenarios => 'No saved scenarios';

  @override
  String get rpgImportScenarioPackage => 'Import RPG scenario package';

  @override
  String get rpgSelectedScenarioUnreadable =>
      'The selected scenario file could not be read';

  @override
  String get favorite => 'Favorite';

  @override
  String get connections => 'Connections';

  @override
  String get systemPromptOverride => 'System prompt override';

  @override
  String get systemPromptOverrideHint =>
      'Enter a system prompt for this persona...';

  @override
  String get systemPromptOverrideDescription =>
      'Overrides the default system prompt while this persona is active';

  @override
  String get instructionsAddedAfterHistory =>
      'Instructions added after chat history';

  @override
  String get bindPersonaDescription => 'Bind persona description';

  @override
  String get noConnections => 'No connections';

  @override
  String connectionCharacter(String id) {
    return 'Character: $id';
  }

  @override
  String connectionGroup(String id) {
    return 'Group: $id';
  }

  @override
  String connectionChat(String id) {
    return 'Chat: $id';
  }

  @override
  String lockLabel(String type) {
    return 'Lock: $type';
  }

  @override
  String get addTag => 'Add tag';

  @override
  String errorLoadingLorebooks(String error) {
    return 'Failed to load lorebooks: $error';
  }

  @override
  String get personaLorebook => 'Persona lorebook';

  @override
  String get selectLorebook => 'Select a lorebook';

  @override
  String get personaLorebookDescription => 'Lorebook linked to this persona';

  @override
  String get descriptionPlacement => 'Description placement';

  @override
  String get personaDescriptionPositionHelp =>
      'Choose where the persona description is inserted in the prompt';

  @override
  String get depth => 'Depth';

  @override
  String get depthInChatHistory => 'Depth in chat history';

  @override
  String get messageRole => 'Message role';

  @override
  String get roleForDescription => 'Role used for the persona description';

  @override
  String get novelAiSettings => 'NovelAI settings';

  @override
  String get anlasGuard => 'Anlas guard';

  @override
  String get anlasGuardDescription =>
      'Prevent generation when the estimated Anlas cost is too high';

  @override
  String get smea => 'SMEA';

  @override
  String get smeaDescription =>
      'Enable SMEA sampling for improved image coherence';

  @override
  String get smeaDynamic => 'Dynamic SMEA';

  @override
  String get smeaDynamicDescription =>
      'Dynamically adjust SMEA based on image dimensions';

  @override
  String get decrisper => 'Decrisper';

  @override
  String get decrisperDescription =>
      'Reduce overly sharp or crispy image details';

  @override
  String get varietyPlus => 'Variety+';

  @override
  String get varietyPlusDescription =>
      'Increase variation between generated images';

  @override
  String get gptImageApiDescription =>
      'Generate images through an OAI Compatible image API';

  @override
  String get oaiCompatibleChat => 'OAI Compatible Chat';

  @override
  String get oaiCompatibleChatDescription =>
      'Generate images through an OAI Compatible chat completion endpoint';

  @override
  String get errorFetchingModels => 'Failed to fetch models';

  @override
  String generatedPrompt(String prompt) {
    return 'Prompt: $prompt';
  }

  @override
  String generatedSeed(String seed) {
    return 'Seed: $seed';
  }

  @override
  String imagesGenerated(int count) {
    return 'Generated $count image(s)';
  }

  @override
  String get myTheme => 'My theme';

  @override
  String get translate => 'Translate';

  @override
  String get stopSpeaking => 'Stop speaking';

  @override
  String get insertion => 'Insertion';

  @override
  String get filters => 'Filters';

  @override
  String get scanDepth => 'Scan depth';

  @override
  String get scanDepthDescription =>
      'Number of recent messages scanned for keywords';

  @override
  String get roleForInjectedContent => 'Role used for injected content';

  @override
  String get caseSensitive => 'Case sensitive';

  @override
  String get matchKeywordsExactCase => 'Match keywords using exact letter case';

  @override
  String get matchWholeWords => 'Match whole words';

  @override
  String get onlyMatchCompleteWords => 'Only match complete words';

  @override
  String get recursionControl => 'Recursion control';

  @override
  String get preventRecursion => 'Prevent recursion';

  @override
  String get preventRecursionDescription =>
      'Do not let this entry trigger additional entries';

  @override
  String get excludeRecursion => 'Exclude from recursion';

  @override
  String get excludeRecursionDescription =>
      'Do not activate this entry during recursive scans';

  @override
  String get delayUntilRecursion => 'Delay until recursion';

  @override
  String get delayUntilRecursionDescription =>
      'Only activate this entry during recursive scans';

  @override
  String get characterFilter => 'Character filter';

  @override
  String get groupSettings => 'Group settings';

  @override
  String get groupMutuallyExclusive => 'Mutually exclusive group';

  @override
  String get useGroupScoring => 'Use group scoring';

  @override
  String get groupWeight => 'Group weight';

  @override
  String get groupWeightDescription =>
      'Relative weight when choosing an entry from the group';

  @override
  String get groupOverride => 'Group override';

  @override
  String get groupPriority => 'Group priority';

  @override
  String get probability => 'Probability';

  @override
  String get useProbability => 'Use probability';

  @override
  String get randomActivationProbability =>
      'Random chance for this entry to activate';

  @override
  String probabilityPercent(int percent) {
    return 'Activation probability: $percent%';
  }

  @override
  String get timedEffects => 'Timed effects';

  @override
  String get filterType => 'Filter type';

  @override
  String get characterIds => 'Character IDs';

  @override
  String get stickyDuration => 'Sticky duration';

  @override
  String get stickyDurationDescription =>
      'Number of messages this entry remains active after matching';

  @override
  String get cooldown => 'Cooldown';

  @override
  String get cooldownDescription =>
      'Number of messages before this entry can activate again';

  @override
  String get delay => 'Delay';

  @override
  String get delayDescription =>
      'Number of messages before this entry becomes eligible';

  @override
  String get outlet => 'Outlet';

  @override
  String get include => 'Include';

  @override
  String get exclude => 'Exclude';

  @override
  String translatedFromLanguage(String language) {
    return 'Translated from $language';
  }

  @override
  String originalText(String text) {
    return 'Original: $text';
  }

  @override
  String get loadingImage => 'Loading image...';

  @override
  String get backupIntervalNever => 'Never';

  @override
  String get backupIntervalHourly => 'Hourly';

  @override
  String get backupIntervalDaily => 'Daily';

  @override
  String get backupIntervalWeekly => 'Weekly';

  @override
  String get backupIntervalMonthly => 'Monthly';

  @override
  String get restoreModeReplace => 'Replace';

  @override
  String get restoreModeReplaceDescription =>
      'Replace all local data with backup data';

  @override
  String get restoreModeMerge => 'Merge';

  @override
  String get restoreModeMergeDescription =>
      'Merge backup with local data; newer data wins conflicts';

  @override
  String get restoreModeAddNewOnly => 'Add new only';

  @override
  String get restoreModeAddNewOnlyDescription =>
      'Only add new backup items and keep all existing data';

  @override
  String get sortNameAscending => 'Name (A-Z)';

  @override
  String get sortNameDescending => 'Name (Z-A)';

  @override
  String get sortNewestFirst => 'Newest first';

  @override
  String get sortOldestFirst => 'Oldest first';

  @override
  String get sortRecentlyModified => 'Recently modified';

  @override
  String get sortLeastRecentlyModified => 'Least recently modified';

  @override
  String get codeBlock => 'Code block';

  @override
  String get quote => 'Quote';

  @override
  String get heading1 => 'Heading 1';

  @override
  String get heading2 => 'Heading 2';

  @override
  String get heading3 => 'Heading 3';

  @override
  String get bulletList => 'Bullet list';

  @override
  String get numberedList => 'Numbered list';

  @override
  String get horizontalRule => 'Horizontal rule';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get goHome => 'Go home';

  @override
  String get officialWebsite => 'Official website';

  @override
  String get mcpStreamableHttp => 'Streamable HTTP';

  @override
  String get mcpLegacyHttpSse => 'Legacy HTTP + SSE';

  @override
  String chatWithName(String name) {
    return 'Chat with $name';
  }

  @override
  String get noValidCharactersInGroup => 'No valid characters in group';

  @override
  String get aiDataSharingTitle => 'चुनें कि रिमोट AI आपका डेटा कैसे संभाले';

  @override
  String get aiDataSharingIntroduction =>
      'NativeTavern स्थानीय उपयोग को प्राथमिकता देता है। रिमोट AI सुविधा इस्तेमाल करने पर यह डिवाइस आवश्यक डेटा सीधे आपके कॉन्फ़िगर किए गए प्रदाता को भेजता है। NativeTavern इन अनुरोधों को प्रॉक्सी या संग्रहीत नहीं करता।';

  @override
  String get aiDataSharingDataTitle => 'भेजा जा सकने वाला डेटा';

  @override
  String get aiDataSharingDataTypes =>
      '- आपके संदेश और संबंधित चैट इतिहास\n- चरित्र, पर्सोना और सिस्टम निर्देश, लोरबुक, मेमोरी और टूल इनपुट\n- एम्बेडिंग के लिए दस्तावेज़\n- चित्र निर्माण के लिए प्रॉम्प्ट और चित्र\n- वॉइस सुविधाओं के लिए ऑडियो और टेक्स्ट';

  @override
  String get aiDataSharingRecipientsTitle => 'कौन इसे प्राप्त कर सकता है';

  @override
  String get aiDataSharingRecipients =>
      'आपकी कॉन्फ़िगरेशन के अनुसार: Anthropic, आपके द्वारा कॉन्फ़िगर किया OAI-संगत एंडपॉइंट, OpenRouter, Google Gemini, DeepSeek, Alibaba Qwen, SiliconFlow, Moonshot/Kimi, Z.AI, MiniMax, Cohere, ElevenLabs, Azure Speech, Volcengine, NovelAI, Pollinations या आपका दर्ज किया अन्य कस्टम एंडपॉइंट।';

  @override
  String get aiDataSharingControlTitle => 'आपकी पसंद';

  @override
  String get aiDataSharingControlDescription =>
      'रिमोट प्रदाता अपनी गोपनीयता नीतियों के अनुसार डेटा संसाधित करते हैं। API क्रेडेंशियल चुने गए प्रदाता से सीधे प्रमाणीकरण के अलावा इसी डिवाइस पर रहते हैं। इसे सेटिंग्स में कभी भी बदला जा सकता है। स्थानीय AI बिना सहमति उपलब्ध रहता है।';

  @override
  String get allowRemoteAi => 'रिमोट AI की अनुमति दें';

  @override
  String get useLocalAiOnly => 'केवल स्थानीय AI इस्तेमाल करें';

  @override
  String get aiDataSharingSettingsTitle => 'रिमोट AI डेटा साझाकरण';

  @override
  String get aiDataSharingAllowedDescription =>
      'कॉन्फ़िगर किए गए प्रदाताओं और एंडपॉइंट के लिए अनुमत';

  @override
  String get aiDataSharingLocalOnlyDescription =>
      'अवरुद्ध; स्थानीय AI उपलब्ध रहता है';

  @override
  String get localBackup => 'Local & File Backup';

  @override
  String get localBackupDescription =>
      'Export and import NativeTavern .ntx combined backups or .ntb data backups to your device storage or files app';

  @override
  String get exportNtbBackup => 'Export Data Backup (.ntb)';

  @override
  String get exportNtbBackupSubtitle =>
      'Save JSON data only; media is stored separately as .ntm';

  @override
  String get exportNtxBackup => 'Export Combined Backup (.ntx)';

  @override
  String get exportNtxBackupSubtitle =>
      'Save app data and media together in one .ntx file';

  @override
  String get importNtbBackup => 'Import Backup File (.ntb)';

  @override
  String get importNtbBackupSubtitle =>
      'Restore or merge data from a local .ntb file';

  @override
  String get importNtxBackup => 'Import Backup (.ntx / .ntb)';

  @override
  String get importNtxBackupSubtitle =>
      'Restore or merge data from a combined .ntx file or a .ntb data backup';

  @override
  String get exportToFiles => 'Save to Files';

  @override
  String get shareBackup => 'Share Backup';

  @override
  String get exportOptions => 'Export Options';

  @override
  String get selectNtbFile => 'Select NativeTavern Backup (.ntb)';

  @override
  String get selectNtbFileDescription =>
      'Pick the .ntb backup file and optional .ntm media file';

  @override
  String get selectNtxFile => 'Select NativeTavern Backup';

  @override
  String get selectNtxFileDescription =>
      'Pick a .ntx combined backup, or a .ntb file with optional .ntm media';

  @override
  String get backupSavedToFilesApp => 'Backup saved to Files';

  @override
  String get backupSavedToAppFolder =>
      'Could not save to Files. Backup saved to NativeTavern/Backups.';

  @override
  String get savedToFilesApp => 'Saved to Files';

  @override
  String get importBackupExplanation =>
      'Restore or merge characters, chats, settings, and media from this backup file.';

  @override
  String get restoringBackup => 'Restoring backup...';

  @override
  String get exportingBackup => 'Exporting backup...';
}
