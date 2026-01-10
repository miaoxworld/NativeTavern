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
}
