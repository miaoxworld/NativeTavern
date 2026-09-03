import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'NativeTavern'**
  String get appTitle;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Characters navigation label
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// Settings navigation label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Chats navigation label
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// New chat button label
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// Empty state message when no chats exist
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get noChatsYet;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Start a new conversation with a character'**
  String get startNewConversation;

  /// Button to browse characters
  ///
  /// In en, this message translates to:
  /// **'Browse Characters'**
  String get browseCharacters;

  /// Group chats tooltip
  ///
  /// In en, this message translates to:
  /// **'Group Chats'**
  String get groupChats;

  /// Import button tooltip
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Save as action
  ///
  /// In en, this message translates to:
  /// **'Save As'**
  String get saveAs;

  /// Edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Copy action
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Close action
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// OK action
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Yes action
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No action
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error message when loading chats fails
  ///
  /// In en, this message translates to:
  /// **'Error loading chats: {error}'**
  String errorLoadingChats(String error);

  /// Delete chat dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// Delete chat confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat? This action cannot be undone.'**
  String get deleteChatConfirmation;

  /// Chat deleted snackbar message
  ///
  /// In en, this message translates to:
  /// **'Chat deleted'**
  String get chatDeleted;

  /// Yesterday time label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Days ago time label
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No messages placeholder
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No messages yet placeholder
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// Chat label
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Message input placeholder
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Send button label
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Regenerate response button
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// Continue generation button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGeneration;

  /// View character menu item
  ///
  /// In en, this message translates to:
  /// **'View Character'**
  String get viewCharacter;

  /// Author's note label
  ///
  /// In en, this message translates to:
  /// **'Author\'s Note'**
  String get authorsNote;

  /// Bookmarks label
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// Export chat menu item
  ///
  /// In en, this message translates to:
  /// **'Export Chat'**
  String get exportChat;

  /// Import chat menu item
  ///
  /// In en, this message translates to:
  /// **'Import Chat'**
  String get importChat;

  /// Clear messages menu item
  ///
  /// In en, this message translates to:
  /// **'Clear Messages'**
  String get clearMessages;

  /// Select model dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get selectModel;

  /// Loading models indicator
  ///
  /// In en, this message translates to:
  /// **'Loading models...'**
  String get loadingModels;

  /// No models available message
  ///
  /// In en, this message translates to:
  /// **'No models available. Check your API configuration.'**
  String get noModelsAvailable;

  /// Model changed snackbar message
  ///
  /// In en, this message translates to:
  /// **'Model changed to {model}'**
  String modelChangedTo(String model);

  /// Failed to load models error message
  ///
  /// In en, this message translates to:
  /// **'Failed to load models: {error}'**
  String failedToLoadModels(String error);

  /// Search models placeholder
  ///
  /// In en, this message translates to:
  /// **'Search models...'**
  String get searchModels;

  /// No models match search message
  ///
  /// In en, this message translates to:
  /// **'No models match your search'**
  String get noModelsMatchSearch;

  /// Provider label
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// API not configured title
  ///
  /// In en, this message translates to:
  /// **'API Not Configured'**
  String get apiNotConfigured;

  /// API not configured message
  ///
  /// In en, this message translates to:
  /// **'To chat with characters, you need to configure an LLM provider first.'**
  String get apiNotConfiguredMessage;

  /// Supported providers label
  ///
  /// In en, this message translates to:
  /// **'Supported providers:'**
  String get supportedProviders;

  /// Configure now button
  ///
  /// In en, this message translates to:
  /// **'Configure Now'**
  String get configureNow;

  /// Later button
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Configure button
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get configure;

  /// Configure API provider message
  ///
  /// In en, this message translates to:
  /// **'Configure an LLM provider to start chatting'**
  String get configureApiProvider;

  /// Start conversation message
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get startConversation;

  /// Delete message dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get deleteMessage;

  /// Delete message confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get deleteMessageConfirmation;

  /// Delete messages dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Messages'**
  String get deleteMessages;

  /// Delete messages confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message and all messages after it?'**
  String get deleteMessagesConfirmation;

  /// Delete all button
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// Copied to clipboard snackbar
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Regenerate tooltip
  ///
  /// In en, this message translates to:
  /// **'Generate a new response alternative'**
  String get generateNewResponse;

  /// Continue from here menu item
  ///
  /// In en, this message translates to:
  /// **'Continue from here'**
  String get continueFromHere;

  /// Continue from here description for user messages
  ///
  /// In en, this message translates to:
  /// **'Delete messages after and regenerate response'**
  String get deleteMessagesAfterAndRegenerate;

  /// Continue from here description for assistant messages
  ///
  /// In en, this message translates to:
  /// **'Delete messages after this one'**
  String get deleteMessagesAfterThis;

  /// Create bookmark menu item
  ///
  /// In en, this message translates to:
  /// **'Create Bookmark'**
  String get createBookmark;

  /// Create bookmark description
  ///
  /// In en, this message translates to:
  /// **'Save this point as a checkpoint'**
  String get saveAsCheckpoint;

  /// Delete this message menu item
  ///
  /// In en, this message translates to:
  /// **'Delete this message'**
  String get deleteThisMessage;

  /// Delete this and all after menu item
  ///
  /// In en, this message translates to:
  /// **'Delete this and all after'**
  String get deleteThisAndAllAfter;

  /// Attach image tooltip
  ///
  /// In en, this message translates to:
  /// **'Attach image'**
  String get attachImage;

  /// Formatting button label in chat input menu
  ///
  /// In en, this message translates to:
  /// **'Formatting'**
  String get formatting;

  /// Choose from gallery option
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Take photo option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Failed to pick image error
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// Failed to take photo error
  ///
  /// In en, this message translates to:
  /// **'Failed to take photo: {error}'**
  String failedToTakePhoto(String error);

  /// Failed to add attachment error
  ///
  /// In en, this message translates to:
  /// **'Failed to add attachment: {error}'**
  String failedToAddAttachment(String error);

  /// Export chat dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'Export chat with {character}'**
  String exportChatWith(String character);

  /// Messages count
  ///
  /// In en, this message translates to:
  /// **'{count} messages'**
  String messagesCount(int count);

  /// Choose export format label
  ///
  /// In en, this message translates to:
  /// **'Choose export format:'**
  String get chooseExportFormat;

  /// JSON format
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get json;

  /// JSONL SillyTavern format
  ///
  /// In en, this message translates to:
  /// **'JSONL (ST Format)'**
  String get jsonlStFormat;

  /// No chat to export message
  ///
  /// In en, this message translates to:
  /// **'No chat to export'**
  String get noChatToExport;

  /// Export failed error
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// Import chat description
  ///
  /// In en, this message translates to:
  /// **'Import chat history from a file.'**
  String get importChatHistory;

  /// Supported formats label
  ///
  /// In en, this message translates to:
  /// **'Supported formats:'**
  String get supportedFormats;

  /// JSONL SillyTavern format description
  ///
  /// In en, this message translates to:
  /// **'JSONL (SillyTavern format)'**
  String get jsonlSillyTavernFormat;

  /// JSON NativeTavern format description
  ///
  /// In en, this message translates to:
  /// **'JSON (NativeTavern format)'**
  String get jsonNativeTavernFormat;

  /// Import note
  ///
  /// In en, this message translates to:
  /// **'Note: Imported messages will be added to the current chat.'**
  String get importNote;

  /// Choose file button
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No file selected message
  ///
  /// In en, this message translates to:
  /// **'No file selected or invalid format'**
  String get noFileSelected;

  /// Import confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Import Confirmation'**
  String get importConfirmation;

  /// Character label
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get character;

  /// User label
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Messages label
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Has author's note label
  ///
  /// In en, this message translates to:
  /// **'Has Author\'s Note'**
  String get hasAuthorsNote;

  /// Import confirmation question
  ///
  /// In en, this message translates to:
  /// **'Import these messages to the current chat?'**
  String get importMessagesToCurrentChat;

  /// No active chat message
  ///
  /// In en, this message translates to:
  /// **'No active chat'**
  String get noActiveChat;

  /// Imported messages snackbar
  ///
  /// In en, this message translates to:
  /// **'Imported {count} messages'**
  String importedMessages(int count);

  /// Import failed error
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(String error);

  /// Clear messages confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all messages? This cannot be undone.'**
  String get clearMessagesConfirmation;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Thinking/reasoning label
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get thinking;

  /// No swipes available message
  ///
  /// In en, this message translates to:
  /// **'No swipes available'**
  String get noSwipesAvailable;

  /// System label
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Background feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Background feature coming soon'**
  String get backgroundFeatureComingSoon;

  /// Author's note updated snackbar
  ///
  /// In en, this message translates to:
  /// **'Author\'s note updated'**
  String get authorsNoteUpdated;

  /// Command error dialog title
  ///
  /// In en, this message translates to:
  /// **'Command Error'**
  String get commandError;

  /// Enabled label
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Disabled label
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Personas screen title
  ///
  /// In en, this message translates to:
  /// **'Personas'**
  String get personas;

  /// Create persona button
  ///
  /// In en, this message translates to:
  /// **'Create Persona'**
  String get createPersona;

  /// Edit persona dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Persona'**
  String get editPersona;

  /// Delete persona dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Persona'**
  String get deletePersona;

  /// Delete persona confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deletePersonaConfirmation(String name);

  /// No personas empty state
  ///
  /// In en, this message translates to:
  /// **'No personas yet'**
  String get noPersonasYet;

  /// Create persona description
  ///
  /// In en, this message translates to:
  /// **'Create a persona to represent yourself in chats'**
  String get createPersonaDescription;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Enter persona name hint
  ///
  /// In en, this message translates to:
  /// **'Enter persona name'**
  String get enterPersonaName;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Describe persona hint
  ///
  /// In en, this message translates to:
  /// **'Describe this persona (optional)'**
  String get describePersona;

  /// Persona description help text
  ///
  /// In en, this message translates to:
  /// **'The description will be included in the system prompt to help the AI understand who you are.'**
  String get personaDescriptionHelp;

  /// Please enter name validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// Default label
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_;

  /// Active label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Set as default menu item
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefault;

  /// Remove avatar option
  ///
  /// In en, this message translates to:
  /// **'Remove Avatar'**
  String get removeAvatar;

  /// Failed to save avatar error
  ///
  /// In en, this message translates to:
  /// **'Failed to save avatar: {error}'**
  String failedToSaveAvatar(String error);

  /// Select avatar image dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Avatar Image'**
  String get selectAvatarImage;

  /// AI configuration screen title
  ///
  /// In en, this message translates to:
  /// **'AI Configuration'**
  String get aiConfiguration;

  /// LLM provider label
  ///
  /// In en, this message translates to:
  /// **'LLM Provider'**
  String get llmProvider;

  /// API URL label
  ///
  /// In en, this message translates to:
  /// **'API URL'**
  String get apiUrl;

  /// API key label
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// Model label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Temperature label
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Max tokens label
  ///
  /// In en, this message translates to:
  /// **'Max Tokens'**
  String get maxTokens;

  /// Context length label
  ///
  /// In en, this message translates to:
  /// **'Context Length'**
  String get contextLength;

  /// Context window size label
  ///
  /// In en, this message translates to:
  /// **'Context Window Size'**
  String get contextWindowSize;

  /// Context length description
  ///
  /// In en, this message translates to:
  /// **'Maximum number of tokens the model can process as input context.'**
  String get contextLengthDescription;

  /// Top P label
  ///
  /// In en, this message translates to:
  /// **'Top P'**
  String get topP;

  /// Top K label
  ///
  /// In en, this message translates to:
  /// **'Top K'**
  String get topK;

  /// Frequency penalty label
  ///
  /// In en, this message translates to:
  /// **'Frequency Penalty'**
  String get frequencyPenalty;

  /// Presence penalty label
  ///
  /// In en, this message translates to:
  /// **'Presence Penalty'**
  String get presencePenalty;

  /// Repetition penalty label
  ///
  /// In en, this message translates to:
  /// **'Repetition Penalty'**
  String get repetitionPenalty;

  /// Streaming enabled label
  ///
  /// In en, this message translates to:
  /// **'Streaming Enabled'**
  String get streamingEnabled;

  /// Test connection button
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// Connection successful message
  ///
  /// In en, this message translates to:
  /// **'Connection successful!'**
  String get connectionSuccessful;

  /// Connection failed message
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailed(String error);

  /// OAI Compatible provider name
  ///
  /// In en, this message translates to:
  /// **'OAI Compatible'**
  String get openai;

  /// Claude provider name
  ///
  /// In en, this message translates to:
  /// **'Claude'**
  String get claude;

  /// OpenRouter provider name
  ///
  /// In en, this message translates to:
  /// **'OpenRouter'**
  String get openRouter;

  /// Gemini provider name
  ///
  /// In en, this message translates to:
  /// **'Gemini'**
  String get gemini;

  /// Ollama provider name
  ///
  /// In en, this message translates to:
  /// **'Ollama'**
  String get ollama;

  /// LM Studio local provider name
  ///
  /// In en, this message translates to:
  /// **'LM Studio'**
  String get lmStudio;

  /// KoboldCpp provider name
  ///
  /// In en, this message translates to:
  /// **'KoboldCpp'**
  String get koboldCpp;

  /// xAI (Grok) provider name
  ///
  /// In en, this message translates to:
  /// **'xAI (Grok)'**
  String get xai;

  /// Local provider indicator
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// AI presets screen title
  ///
  /// In en, this message translates to:
  /// **'AI Presets'**
  String get aiPresets;

  /// Create preset button
  ///
  /// In en, this message translates to:
  /// **'Create Preset'**
  String get createPreset;

  /// Edit preset dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Preset'**
  String get editPreset;

  /// Delete preset dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Preset'**
  String get deletePreset;

  /// Preset name label
  ///
  /// In en, this message translates to:
  /// **'Preset Name'**
  String get presetName;

  /// Prompt manager screen title
  ///
  /// In en, this message translates to:
  /// **'Prompt Manager'**
  String get promptManager;

  /// System prompt label
  ///
  /// In en, this message translates to:
  /// **'System Prompt'**
  String get systemPrompt;

  /// Jailbreak prompt label
  ///
  /// In en, this message translates to:
  /// **'Jailbreak'**
  String get jailbreak;

  /// Lorebook screen title
  ///
  /// In en, this message translates to:
  /// **'Lorebook'**
  String get worldInfo;

  /// Create entry button
  ///
  /// In en, this message translates to:
  /// **'Create Entry'**
  String get createEntry;

  /// Edit entry dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntry;

  /// Delete entry dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteEntry;

  /// Keywords label
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get keywords;

  /// Content label
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// Priority label
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// Groups screen title
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// Create group button
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// Edit group dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get editGroup;

  /// Delete group dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroup;

  /// Group name label
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// Members label
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// Add member button
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// Remove member button
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get removeMember;

  /// Tags screen title
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Create tag button
  ///
  /// In en, this message translates to:
  /// **'Create Tag'**
  String get createTag;

  /// Edit tag dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Tag'**
  String get editTag;

  /// Delete tag dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Tag'**
  String get deleteTag;

  /// Tag name label
  ///
  /// In en, this message translates to:
  /// **'Tag Name'**
  String get tagName;

  /// Color label
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// Quick replies screen title
  ///
  /// In en, this message translates to:
  /// **'Quick Replies'**
  String get quickReplies;

  /// Create quick reply button
  ///
  /// In en, this message translates to:
  /// **'Create Quick Reply'**
  String get createQuickReply;

  /// Edit quick reply dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Quick Reply'**
  String get editQuickReply;

  /// Delete quick reply dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Quick Reply'**
  String get deleteQuickReply;

  /// Label field
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// Message field
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// Auto send toggle
  ///
  /// In en, this message translates to:
  /// **'Auto Send'**
  String get autoSend;

  /// Regex screen title
  ///
  /// In en, this message translates to:
  /// **'Regex'**
  String get regex;

  /// Create regex button
  ///
  /// In en, this message translates to:
  /// **'Create Regex'**
  String get createRegex;

  /// Edit regex dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Regex'**
  String get editRegex;

  /// Delete regex dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Regex'**
  String get deleteRegex;

  /// Pattern label
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// Replacement label
  ///
  /// In en, this message translates to:
  /// **'Replacement'**
  String get replacement;

  /// Backup screen title
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Backup subtitle in settings
  ///
  /// In en, this message translates to:
  /// **'Local and cloud backup & restore'**
  String get backupSubtitle;

  /// Create backup button
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// Restore backup button
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// Backup created message
  ///
  /// In en, this message translates to:
  /// **'Backup created successfully'**
  String get backupCreated;

  /// Backup restored message
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully'**
  String get backupRestored;

  /// Backup failed message
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// Restore failed message
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailed(String error);

  /// Theme screen title
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode toggle
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// Primary color label
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// Accent color label
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// Advanced settings label
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// Advanced settings screen title
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// Statistics screen title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Total chats statistic
  ///
  /// In en, this message translates to:
  /// **'Total Chats'**
  String get totalChats;

  /// Total messages statistic
  ///
  /// In en, this message translates to:
  /// **'Total Messages'**
  String get totalMessages;

  /// Total characters statistic
  ///
  /// In en, this message translates to:
  /// **'Total Characters'**
  String get totalCharacters;

  /// Tokenizer screen title
  ///
  /// In en, this message translates to:
  /// **'Tokenizer'**
  String get tokenizer;

  /// TTS screen title
  ///
  /// In en, this message translates to:
  /// **'Text-to-Speech'**
  String get tts;

  /// STT screen title
  ///
  /// In en, this message translates to:
  /// **'Speech-to-Text'**
  String get stt;

  /// Translation screen title
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// Image generation screen title
  ///
  /// In en, this message translates to:
  /// **'Image Generation'**
  String get imageGeneration;

  /// Vector storage screen title
  ///
  /// In en, this message translates to:
  /// **'Vector Storage'**
  String get vectorStorage;

  /// Sprites screen title
  ///
  /// In en, this message translates to:
  /// **'Sprites'**
  String get sprites;

  /// Backgrounds screen title
  ///
  /// In en, this message translates to:
  /// **'Backgrounds'**
  String get backgrounds;

  /// CFG scale screen title
  ///
  /// In en, this message translates to:
  /// **'CFG Scale'**
  String get cfgScale;

  /// Logit bias screen title
  ///
  /// In en, this message translates to:
  /// **'Logit Bias'**
  String get logitBias;

  /// Variables screen title
  ///
  /// In en, this message translates to:
  /// **'Variables'**
  String get variables;

  /// List view toggle
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get listView;

  /// Grid view toggle
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get gridView;

  /// Search label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search characters placeholder
  ///
  /// In en, this message translates to:
  /// **'Search characters...'**
  String get searchCharacters;

  /// No characters found message
  ///
  /// In en, this message translates to:
  /// **'No characters found'**
  String get noCharactersFound;

  /// No characters empty state
  ///
  /// In en, this message translates to:
  /// **'No characters yet'**
  String get noCharactersYet;

  /// Import character screen title
  ///
  /// In en, this message translates to:
  /// **'Import Character'**
  String get importCharacter;

  /// Create character button
  ///
  /// In en, this message translates to:
  /// **'Create Character'**
  String get createCharacter;

  /// Edit character button
  ///
  /// In en, this message translates to:
  /// **'Edit Character'**
  String get editCharacter;

  /// Delete character button
  ///
  /// In en, this message translates to:
  /// **'Delete Character'**
  String get deleteCharacter;

  /// Delete character confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This will also delete all chats with this character.'**
  String deleteCharacterConfirmation(String name);

  /// Character deleted snackbar
  ///
  /// In en, this message translates to:
  /// **'Character deleted'**
  String get characterDeleted;

  /// Start chat button
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// Personality label
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get personality;

  /// Scenario label
  ///
  /// In en, this message translates to:
  /// **'Scenario'**
  String get scenario;

  /// First message label
  ///
  /// In en, this message translates to:
  /// **'First Message'**
  String get firstMessage;

  /// Example dialogue label
  ///
  /// In en, this message translates to:
  /// **'Example Dialogue'**
  String get exampleDialogue;

  /// Creator notes label
  ///
  /// In en, this message translates to:
  /// **'Creator Notes'**
  String get creatorNotes;

  /// Alternate greetings label
  ///
  /// In en, this message translates to:
  /// **'Alternate Greetings'**
  String get alternateGreetings;

  /// Character book label
  ///
  /// In en, this message translates to:
  /// **'Character Book'**
  String get characterBook;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language changed snackbar
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// About screen title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Licenses button
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// Privacy policy button
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service button
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Feedback button
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// Rate app button
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// Share app button
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// Check for updates button
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No updates available message
  ///
  /// In en, this message translates to:
  /// **'No updates available'**
  String get noUpdatesAvailable;

  /// Update available message
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// Download update button
  ///
  /// In en, this message translates to:
  /// **'Download Update'**
  String get downloadUpdate;

  /// Bookmark created snackbar
  ///
  /// In en, this message translates to:
  /// **'Bookmark created'**
  String get bookmarkCreated;

  /// Bookmark name label
  ///
  /// In en, this message translates to:
  /// **'Bookmark Name'**
  String get bookmarkName;

  /// Enter bookmark name hint
  ///
  /// In en, this message translates to:
  /// **'Enter bookmark name'**
  String get enterBookmarkName;

  /// No bookmarks empty state
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get noBookmarksYet;

  /// Create bookmark description
  ///
  /// In en, this message translates to:
  /// **'Create bookmarks to save important points in your conversation'**
  String get createBookmarkDescription;

  /// Jump to bookmark button
  ///
  /// In en, this message translates to:
  /// **'Jump to Bookmark'**
  String get jumpToBookmark;

  /// Delete bookmark button
  ///
  /// In en, this message translates to:
  /// **'Delete Bookmark'**
  String get deleteBookmark;

  /// Bookmark deleted snackbar
  ///
  /// In en, this message translates to:
  /// **'Bookmark deleted'**
  String get bookmarkDeleted;

  /// Save as JSONL option
  ///
  /// In en, this message translates to:
  /// **'Save as JSONL'**
  String get saveAsJsonl;

  /// Save as JSON option
  ///
  /// In en, this message translates to:
  /// **'Save as JSON'**
  String get saveAsJson;

  /// Keyboard shortcuts tooltip title
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts:'**
  String get keyboardShortcuts;

  /// Bold formatting
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// Italic formatting
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// Underline formatting
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get underline;

  /// Strikethrough formatting
  ///
  /// In en, this message translates to:
  /// **'Strikethrough'**
  String get strikethrough;

  /// Inline code formatting
  ///
  /// In en, this message translates to:
  /// **'Inline code'**
  String get inlineCode;

  /// Link formatting
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// Slash commands help title
  ///
  /// In en, this message translates to:
  /// **'Slash Commands'**
  String get slashCommands;

  /// Available commands label
  ///
  /// In en, this message translates to:
  /// **'Available commands:'**
  String get availableCommands;

  /// Command help hint
  ///
  /// In en, this message translates to:
  /// **'Type / to see available commands'**
  String get commandHelp;

  /// Character not found title
  ///
  /// In en, this message translates to:
  /// **'Character Not Found'**
  String get characterNotFound;

  /// Character not found message
  ///
  /// In en, this message translates to:
  /// **'Character not found'**
  String get characterNotFoundMessage;

  /// Export as PNG menu item
  ///
  /// In en, this message translates to:
  /// **'Export as PNG'**
  String get exportAsPng;

  /// Export as CharX menu item
  ///
  /// In en, this message translates to:
  /// **'Export as CharX'**
  String get exportAsCharx;

  /// Duplicate menu item
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// Delete character confirmation simple
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteCharacterConfirmationSimple(String name);

  /// Character duplicated message
  ///
  /// In en, this message translates to:
  /// **'{name} duplicated'**
  String characterDuplicated(String name);

  /// Failed to delete error
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String failedToDelete(String error);

  /// Failed to duplicate error
  ///
  /// In en, this message translates to:
  /// **'Failed to duplicate: {error}'**
  String failedToDuplicate(String error);

  /// PNG export coming soon message
  ///
  /// In en, this message translates to:
  /// **'PNG export coming soon'**
  String get pngExportComingSoon;

  /// CharX export coming soon message
  ///
  /// In en, this message translates to:
  /// **'CharX export coming soon'**
  String get charxExportComingSoon;

  /// Failed to create chat message
  ///
  /// In en, this message translates to:
  /// **'Failed to create chat'**
  String get failedToCreateChat;

  /// Creating indicator
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// By creator label
  ///
  /// In en, this message translates to:
  /// **'by {creator}'**
  String byCreator(String creator);

  /// Version label with number
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String versionLabel(String version);

  /// Show less button
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// Show more button
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// Greeting number label
  ///
  /// In en, this message translates to:
  /// **'Greeting {number}'**
  String greetingNumber(int number);

  /// Alternate greetings with count
  ///
  /// In en, this message translates to:
  /// **'Alternate Greetings ({count})'**
  String alternateGreetingsCount(int count);

  /// Embedded lorebook label
  ///
  /// In en, this message translates to:
  /// **'Embedded Lorebook'**
  String get embeddedLorebook;

  /// Entries enabled count
  ///
  /// In en, this message translates to:
  /// **'{enabled} of {total} entries enabled'**
  String entriesEnabled(int enabled, int total);

  /// And more entries label
  ///
  /// In en, this message translates to:
  /// **'... and {count} more entries'**
  String andMoreEntries(int count);

  /// Example messages label
  ///
  /// In en, this message translates to:
  /// **'Example Messages'**
  String get exampleMessages;

  /// Post-history instructions label
  ///
  /// In en, this message translates to:
  /// **'Post-History Instructions'**
  String get postHistoryInstructions;

  /// Select images dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Images'**
  String get selectImages;

  /// Presets and templates section header
  ///
  /// In en, this message translates to:
  /// **'Presets & Templates'**
  String get presetsAndTemplates;

  /// Active preset label
  ///
  /// In en, this message translates to:
  /// **'Active Preset'**
  String get activePreset;

  /// Change button
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No preset selected message
  ///
  /// In en, this message translates to:
  /// **'No preset selected'**
  String get noPresetSelected;

  /// Instruct template label
  ///
  /// In en, this message translates to:
  /// **'Instruct Template'**
  String get instructTemplate;

  /// Select instruct template dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Instruct Template'**
  String get selectInstructTemplate;

  /// Instruct template description
  ///
  /// In en, this message translates to:
  /// **'Instruct templates format prompts for different LLM models. Use \"None\" for API providers such as OAI Compatible or Claude that handle formatting automatically.'**
  String get instructTemplateDescription;

  /// Prompt manager subtitle
  ///
  /// In en, this message translates to:
  /// **'Order and toggle prompt sections'**
  String get orderAndTogglePromptSections;

  /// LLM connection section header
  ///
  /// In en, this message translates to:
  /// **'LLM Connection'**
  String get llmConnection;

  /// Generation settings section header
  ///
  /// In en, this message translates to:
  /// **'Generation Settings'**
  String get generationSettings;

  /// Advanced sampler settings label
  ///
  /// In en, this message translates to:
  /// **'Advanced Sampler Settings'**
  String get advancedSamplerSettings;

  /// Advanced sampler settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Full control over sampling parameters'**
  String get fullControlOverSampling;

  /// Select LLM provider dialog title
  ///
  /// In en, this message translates to:
  /// **'Select LLM Provider'**
  String get selectLlmProvider;

  /// Not set placeholder
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// Enter API key hint
  ///
  /// In en, this message translates to:
  /// **'Enter your API key'**
  String get enterApiKey;

  /// API endpoint URL label
  ///
  /// In en, this message translates to:
  /// **'API endpoint URL'**
  String get apiEndpointUrl;

  /// Model name label
  ///
  /// In en, this message translates to:
  /// **'Model name'**
  String get modelName;

  /// Fetch available models button
  ///
  /// In en, this message translates to:
  /// **'Fetch Available Models'**
  String get fetchAvailableModels;

  /// Fetch models description
  ///
  /// In en, this message translates to:
  /// **'Fetch models from the API or enter a model name manually'**
  String get fetchModelsDescription;

  /// Enter model name dialog title
  ///
  /// In en, this message translates to:
  /// **'Enter Model Name'**
  String get enterModelName;

  /// Fetching models indicator
  ///
  /// In en, this message translates to:
  /// **'Fetching models...'**
  String get fetchingModels;

  /// Failed to fetch models message
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch models'**
  String get failedToFetchModels;

  /// Tap to test connection hint
  ///
  /// In en, this message translates to:
  /// **'Tap to test API connection'**
  String get tapToTestConnection;

  /// Testing indicator
  ///
  /// In en, this message translates to:
  /// **'Testing...'**
  String get testing;

  /// Connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Connection failed status
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailedSimple;

  /// Maximum tokens to generate hint
  ///
  /// In en, this message translates to:
  /// **'Maximum tokens to generate'**
  String get maximumTokensToGenerate;

  /// Streaming label
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streaming;

  /// Streaming description
  ///
  /// In en, this message translates to:
  /// **'Show response as it generates'**
  String get showResponseAsItGenerates;

  /// Select model with count
  ///
  /// In en, this message translates to:
  /// **'Select Model ({count})'**
  String selectModelCount(int count);

  /// Refresh models tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh models'**
  String get refreshModels;

  /// Enter manually tooltip
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManually;

  /// No models found message
  ///
  /// In en, this message translates to:
  /// **'No models found'**
  String get noModelsFound;

  /// Try different search term hint
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearchTerm;

  /// Filtered models count
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total} models'**
  String modelsOfTotal(int filtered, int total);

  /// Import preset tooltip
  ///
  /// In en, this message translates to:
  /// **'Import Preset'**
  String get importPreset;

  /// No group chats empty state
  ///
  /// In en, this message translates to:
  /// **'No group chats yet'**
  String get noGroupChatsYet;

  /// Create group description
  ///
  /// In en, this message translates to:
  /// **'Create a group to chat with multiple characters'**
  String get createGroupDescription;

  /// New group button
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroup;

  /// Members and mode label
  ///
  /// In en, this message translates to:
  /// **'{count} members • {mode} mode'**
  String membersAndMode(int count, String mode);

  /// Group chat coming soon message
  ///
  /// In en, this message translates to:
  /// **'Group chat will be implemented with chat integration'**
  String get groupChatWillBeImplemented;

  /// Delete group confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This will also delete all associated chats.'**
  String deleteGroupConfirmation(String name);

  /// Group deleted message
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String groupDeleted(String name);

  /// Group name required label
  ///
  /// In en, this message translates to:
  /// **'Group Name *'**
  String get groupNameRequired;

  /// Enter group name hint
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// Optional description hint
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get optionalDescription;

  /// Select characters label
  ///
  /// In en, this message translates to:
  /// **'Select Characters'**
  String get selectCharacters;

  /// No characters available message
  ///
  /// In en, this message translates to:
  /// **'No characters available'**
  String get noCharactersAvailable;

  /// Characters selected count
  ///
  /// In en, this message translates to:
  /// **'{count} character(s) selected'**
  String charactersSelected(int count);

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Select at least 2 characters validation
  ///
  /// In en, this message translates to:
  /// **'Select at least 2 characters'**
  String get selectAtLeast2Characters;

  /// Group created success message
  ///
  /// In en, this message translates to:
  /// **'Group created successfully'**
  String get groupCreatedSuccessfully;

  /// Failed to create group error
  ///
  /// In en, this message translates to:
  /// **'Failed to create group: {error}'**
  String failedToCreateGroup(String error);

  /// Select character card message
  ///
  /// In en, this message translates to:
  /// **'Select a character card'**
  String get selectCharacterCard;

  /// Supported formats description
  ///
  /// In en, this message translates to:
  /// **'Supports PNG, CharX, and JSON formats'**
  String get supportsPngCharxJson;

  /// Browse files button
  ///
  /// In en, this message translates to:
  /// **'Browse Files'**
  String get browseFiles;

  /// Failed to pick file error
  ///
  /// In en, this message translates to:
  /// **'Failed to pick file: {error}'**
  String failedToPickFile(String error);

  /// Failed to load character error
  ///
  /// In en, this message translates to:
  /// **'Failed to load character: {error}'**
  String failedToLoadCharacter(String error);

  /// Unsupported file format error
  ///
  /// In en, this message translates to:
  /// **'Unsupported file format: {format}'**
  String unsupportedFileFormat(String format);

  /// PNG character card format
  ///
  /// In en, this message translates to:
  /// **'PNG Character Card'**
  String get pngCharacterCard;

  /// PNG format description
  ///
  /// In en, this message translates to:
  /// **'Character data embedded in image metadata'**
  String get characterDataEmbeddedInImage;

  /// CharX archive format
  ///
  /// In en, this message translates to:
  /// **'CharX Archive'**
  String get charxArchive;

  /// CharX format description
  ///
  /// In en, this message translates to:
  /// **'ZIP archive with character data and assets'**
  String get zipArchiveWithCharacterData;

  /// JSON format description
  ///
  /// In en, this message translates to:
  /// **'Plain character card JSON file'**
  String get plainCharacterCardJson;

  /// Imported with lorebook message
  ///
  /// In en, this message translates to:
  /// **'Imported \"{name}\" with embedded lorebook!'**
  String importedWithLorebook(String name);

  /// Imported successfully message
  ///
  /// In en, this message translates to:
  /// **'Imported \"{name}\" successfully!'**
  String importedSuccessfully(String name);

  /// Failed to import error
  ///
  /// In en, this message translates to:
  /// **'Failed to import: {error}'**
  String failedToImport(String error);

  /// Embedded lorebook with entry count
  ///
  /// In en, this message translates to:
  /// **'Embedded Lorebook ({count} entries)'**
  String embeddedLorebookEntries(int count);

  /// Save current as preset menu item
  ///
  /// In en, this message translates to:
  /// **'Save Current as Preset'**
  String get saveCurrentAsPreset;

  /// Export current settings menu item
  ///
  /// In en, this message translates to:
  /// **'Export Current Settings'**
  String get exportCurrentSettings;

  /// Built-in presets section header
  ///
  /// In en, this message translates to:
  /// **'Built-in Presets'**
  String get builtInPresets;

  /// Custom presets section header
  ///
  /// In en, this message translates to:
  /// **'Custom Presets'**
  String get customPresets;

  /// AI presets info description
  ///
  /// In en, this message translates to:
  /// **'AI Presets combine generation settings, prompt ordering, and instruct templates. Select a preset to apply all settings at once.'**
  String get aiPresetsDescription;

  /// Applied preset message
  ///
  /// In en, this message translates to:
  /// **'Applied \"{name}\" preset'**
  String appliedPreset(String name);

  /// Failed to apply preset error
  ///
  /// In en, this message translates to:
  /// **'Failed to apply preset: {error}'**
  String failedToApplyPreset(String error);

  /// Invalid preset format error
  ///
  /// In en, this message translates to:
  /// **'Invalid preset format. Expected preset with generation settings.'**
  String get invalidPresetFormat;

  /// Imported and applied preset message
  ///
  /// In en, this message translates to:
  /// **'Imported and applied \"{name}\"'**
  String importedAndApplied(String name);

  /// Save as preset dialog title
  ///
  /// In en, this message translates to:
  /// **'Save as Preset'**
  String get saveAsPreset;

  /// Description optional label
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// Please enter a name validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterAName;

  /// Saved preset message
  ///
  /// In en, this message translates to:
  /// **'Saved \"{name}\"'**
  String savedPreset(String name);

  /// Save failed error
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(String error);

  /// Delete preset confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deletePresetConfirmation(String name);

  /// Deleted preset message
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{name}\"'**
  String deletedPreset(String name);

  /// Export button
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Reset to defaults button
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// Basic sampling section header
  ///
  /// In en, this message translates to:
  /// **'Basic Sampling'**
  String get basicSampling;

  /// Temperature description
  ///
  /// In en, this message translates to:
  /// **'Controls randomness. Higher = more creative, lower = more focused.'**
  String get temperatureDescription;

  /// Top P label with description
  ///
  /// In en, this message translates to:
  /// **'Top P (Nucleus Sampling)'**
  String get topPNucleusSampling;

  /// Top P description
  ///
  /// In en, this message translates to:
  /// **'Cumulative probability threshold for token selection.'**
  String get topPDescription;

  /// Top K description
  ///
  /// In en, this message translates to:
  /// **'Number of top tokens to consider. 0 = disabled.'**
  String get topKDescription;

  /// Advanced sampling section header
  ///
  /// In en, this message translates to:
  /// **'Advanced Sampling'**
  String get advancedSampling;

  /// Min P label
  ///
  /// In en, this message translates to:
  /// **'Min P'**
  String get minP;

  /// Min P description
  ///
  /// In en, this message translates to:
  /// **'Minimum probability threshold relative to top token.'**
  String get minPDescription;

  /// Typical P label
  ///
  /// In en, this message translates to:
  /// **'Typical P'**
  String get typicalP;

  /// Typical P description
  ///
  /// In en, this message translates to:
  /// **'Locally typical sampling. 1.0 = disabled.'**
  String get typicalPDescription;

  /// Top A label
  ///
  /// In en, this message translates to:
  /// **'Top A'**
  String get topA;

  /// Top A description
  ///
  /// In en, this message translates to:
  /// **'Top-A sampling threshold. 0 = disabled.'**
  String get topADescription;

  /// Tail Free Sampling label
  ///
  /// In en, this message translates to:
  /// **'Tail Free Sampling (TFS)'**
  String get tailFreeSamplingTfs;

  /// TFS description
  ///
  /// In en, this message translates to:
  /// **'Removes low-probability tail. 1.0 = disabled.'**
  String get tfsDescription;

  /// Repetition control section header
  ///
  /// In en, this message translates to:
  /// **'Repetition Control'**
  String get repetitionControl;

  /// Repetition penalty description
  ///
  /// In en, this message translates to:
  /// **'Penalizes repeated tokens. 1.0 = no penalty.'**
  String get repetitionPenaltyDescription;

  /// Repetition penalty range label
  ///
  /// In en, this message translates to:
  /// **'Repetition Penalty Range'**
  String get repetitionPenaltyRange;

  /// Repetition penalty range description
  ///
  /// In en, this message translates to:
  /// **'How many tokens to consider. 0 = all.'**
  String get repetitionPenaltyRangeDescription;

  /// Frequency penalty description
  ///
  /// In en, this message translates to:
  /// **'Penalizes tokens based on frequency in text.'**
  String get frequencyPenaltyDescription;

  /// Presence penalty description
  ///
  /// In en, this message translates to:
  /// **'Penalizes tokens that appear at all in text.'**
  String get presencePenaltyDescription;

  /// Mirostat section header
  ///
  /// In en, this message translates to:
  /// **'Mirostat (Local Models)'**
  String get mirostatLocalModels;

  /// Mirostat mode label
  ///
  /// In en, this message translates to:
  /// **'Mirostat Mode'**
  String get mirostatMode;

  /// Mirostat mode description
  ///
  /// In en, this message translates to:
  /// **'Adaptive sampling for local models'**
  String get adaptiveSamplingForLocalModels;

  /// Off label
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// Mirostat Tau label
  ///
  /// In en, this message translates to:
  /// **'Mirostat Tau'**
  String get mirostatTau;

  /// Mirostat Tau description
  ///
  /// In en, this message translates to:
  /// **'Target entropy/perplexity.'**
  String get mirostatTauDescription;

  /// Mirostat Eta label
  ///
  /// In en, this message translates to:
  /// **'Mirostat Eta'**
  String get mirostatEta;

  /// Mirostat Eta description
  ///
  /// In en, this message translates to:
  /// **'Learning rate for Mirostat.'**
  String get mirostatEtaDescription;

  /// Generation control section header
  ///
  /// In en, this message translates to:
  /// **'Generation Control'**
  String get generationControl;

  /// Max tokens description
  ///
  /// In en, this message translates to:
  /// **'Maximum tokens to generate.'**
  String get maxTokensDescription;

  /// Seed label
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get seed;

  /// Seed description
  ///
  /// In en, this message translates to:
  /// **'Random seed for reproducibility. -1 = random.'**
  String get seedDescription;

  /// Stop sequences label
  ///
  /// In en, this message translates to:
  /// **'Stop Sequences'**
  String get stopSequences;

  /// No stop sequences configured message
  ///
  /// In en, this message translates to:
  /// **'No stop sequences configured'**
  String get noStopSequencesConfigured;

  /// Stop sequences description
  ///
  /// In en, this message translates to:
  /// **'Enter one sequence per line. Generation stops when any of these are produced.'**
  String get stopSequencesDescription;

  /// Reset confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will reset all sampler settings to their default values. Continue?'**
  String get resetConfirmation;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Settings reset to defaults message
  ///
  /// In en, this message translates to:
  /// **'Settings reset to defaults'**
  String get settingsResetToDefaults;

  /// Character background screen title
  ///
  /// In en, this message translates to:
  /// **'Character Background'**
  String get characterBackground;

  /// Chat background screen title
  ///
  /// In en, this message translates to:
  /// **'Chat Background'**
  String get chatBackground;

  /// Clear background tooltip
  ///
  /// In en, this message translates to:
  /// **'Clear background'**
  String get clearBackground;

  /// Gradient presets section header
  ///
  /// In en, this message translates to:
  /// **'Gradient Presets'**
  String get gradientPresets;

  /// Solid colors section header
  ///
  /// In en, this message translates to:
  /// **'Solid Colors'**
  String get solidColors;

  /// Custom image section header
  ///
  /// In en, this message translates to:
  /// **'Custom Image'**
  String get customImage;

  /// Adjustments section header
  ///
  /// In en, this message translates to:
  /// **'Adjustments'**
  String get adjustments;

  /// No background selected message
  ///
  /// In en, this message translates to:
  /// **'No background selected'**
  String get noBackgroundSelected;

  /// Choose image button
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get chooseImage;

  /// From URL button
  ///
  /// In en, this message translates to:
  /// **'From URL'**
  String get fromUrl;

  /// Local image label
  ///
  /// In en, this message translates to:
  /// **'Local image: {filename}'**
  String localImage(String filename);

  /// URL label
  ///
  /// In en, this message translates to:
  /// **'URL: {url}'**
  String urlLabel(String url);

  /// No image message
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get noImage;

  /// Opacity label
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get opacity;

  /// Blur effect label
  ///
  /// In en, this message translates to:
  /// **'Blur Effect'**
  String get blurEffect;

  /// Blur effect description
  ///
  /// In en, this message translates to:
  /// **'Apply blur to the background'**
  String get applyBlurToBackground;

  /// Blur amount label
  ///
  /// In en, this message translates to:
  /// **'Blur Amount'**
  String get blurAmount;

  /// Failed to load image error
  ///
  /// In en, this message translates to:
  /// **'Failed to load image: {error}'**
  String failedToLoadImage(String error);

  /// Image URL dialog title
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// Enter image URL hint
  ///
  /// In en, this message translates to:
  /// **'Enter image URL'**
  String get enterImageUrl;

  /// Apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Backup and restore screen title
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Storage section header
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// Total backup size label
  ///
  /// In en, this message translates to:
  /// **'Total Backup Size'**
  String get totalBackupSize;

  /// Calculating indicator
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// Last auto-backup label
  ///
  /// In en, this message translates to:
  /// **'Last Auto-Backup'**
  String get lastAutoBackup;

  /// Auto-backup section header
  ///
  /// In en, this message translates to:
  /// **'Auto-Backup'**
  String get autoBackup;

  /// Enable auto-backup toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Auto-Backup'**
  String get enableAutoBackup;

  /// Auto-backup description
  ///
  /// In en, this message translates to:
  /// **'Automatically backup chats'**
  String get automaticallyBackupChats;

  /// Backup interval label
  ///
  /// In en, this message translates to:
  /// **'Backup Interval'**
  String get backupInterval;

  /// Backup on exit toggle
  ///
  /// In en, this message translates to:
  /// **'Backup on Exit'**
  String get backupOnExit;

  /// Backup on exit description
  ///
  /// In en, this message translates to:
  /// **'Create backup when closing app'**
  String get createBackupWhenClosingApp;

  /// Retention section header
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get retention;

  /// Max chat backups label
  ///
  /// In en, this message translates to:
  /// **'Max Chat Backups'**
  String get maxChatBackups;

  /// Keep up to chat backups description
  ///
  /// In en, this message translates to:
  /// **'Keep up to {count} chat backups'**
  String keepUpToChatBackups(int count);

  /// Max full backups label
  ///
  /// In en, this message translates to:
  /// **'Max Full Backups'**
  String get maxFullBackups;

  /// Keep up to full backups description
  ///
  /// In en, this message translates to:
  /// **'Keep up to {count} full backups'**
  String keepUpToFullBackups(int count);

  /// Cleanup old backups button
  ///
  /// In en, this message translates to:
  /// **'Cleanup Old Backups'**
  String get cleanupOldBackups;

  /// Cleanup description
  ///
  /// In en, this message translates to:
  /// **'Delete backups exceeding limits'**
  String get deleteBackupsExceedingLimits;

  /// Cleanup button
  ///
  /// In en, this message translates to:
  /// **'Cleanup'**
  String get cleanup;

  /// Deleted old backups message
  ///
  /// In en, this message translates to:
  /// **'Deleted {count} old backups'**
  String deletedOldBackups(int count);

  /// Chat backups section header
  ///
  /// In en, this message translates to:
  /// **'Chat Backups'**
  String get chatBackups;

  /// No chat backups message
  ///
  /// In en, this message translates to:
  /// **'No chat backups'**
  String get noChatBackups;

  /// View all backups button
  ///
  /// In en, this message translates to:
  /// **'View all {count} backups'**
  String viewAllBackups(int count);

  /// Full backups section header
  ///
  /// In en, this message translates to:
  /// **'Full Backups'**
  String get fullBackups;

  /// No full backups message
  ///
  /// In en, this message translates to:
  /// **'No full backups'**
  String get noFullBackups;

  /// Information section header
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// About backups label
  ///
  /// In en, this message translates to:
  /// **'About Backups'**
  String get aboutBackups;

  /// About backups description
  ///
  /// In en, this message translates to:
  /// **'Chat backups save individual conversations. Full backups include all characters, chats, settings, and lorebooks.'**
  String get aboutBackupsDescription;

  /// Backup location label
  ///
  /// In en, this message translates to:
  /// **'Backup Location'**
  String get backupLocation;

  /// Error reading backup message
  ///
  /// In en, this message translates to:
  /// **'Error reading backup: {error}'**
  String errorReadingBackup(String error);

  /// Delete backup dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Backup'**
  String get deleteBackup;

  /// Delete backup confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?\n\nThis cannot be undone.'**
  String deleteBackupConfirmation(String name);

  /// View button
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Just now time label
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Minutes ago time label
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// Hours ago time label
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// Enable CFG scale toggle
  ///
  /// In en, this message translates to:
  /// **'Enable CFG Scale'**
  String get enableCfgScale;

  /// CFG scale description
  ///
  /// In en, this message translates to:
  /// **'Classifier-Free Guidance for text generation'**
  String get cfgScaleDescription;

  /// Global settings section header
  ///
  /// In en, this message translates to:
  /// **'Global Settings'**
  String get globalSettings;

  /// Guidance scale label
  ///
  /// In en, this message translates to:
  /// **'Guidance Scale'**
  String get guidanceScale;

  /// Negative prompt label
  ///
  /// In en, this message translates to:
  /// **'Negative Prompt'**
  String get negativePrompt;

  /// Negative prompt hint
  ///
  /// In en, this message translates to:
  /// **'Text to steer the model away from'**
  String get textToSteerAwayFrom;

  /// Positive prompt optional label
  ///
  /// In en, this message translates to:
  /// **'Positive Prompt (Optional)'**
  String get positivePromptOptional;

  /// Positive prompt hint
  ///
  /// In en, this message translates to:
  /// **'Text to enhance in the output'**
  String get textToEnhanceInOutput;

  /// Character settings section header
  ///
  /// In en, this message translates to:
  /// **'Character Settings'**
  String get characterSettings;

  /// Use character-specific settings toggle
  ///
  /// In en, this message translates to:
  /// **'Use Character-Specific Settings'**
  String get useCharacterSpecificSettings;

  /// Override global for character description
  ///
  /// In en, this message translates to:
  /// **'Override global settings for this character'**
  String get overrideGlobalForCharacter;

  /// Character negative prompt label
  ///
  /// In en, this message translates to:
  /// **'Character Negative Prompt'**
  String get characterNegativePrompt;

  /// Override global negative prompt hint
  ///
  /// In en, this message translates to:
  /// **'Override global negative prompt'**
  String get overrideGlobalNegativePrompt;

  /// Chat settings section header
  ///
  /// In en, this message translates to:
  /// **'Chat Settings'**
  String get chatSettings;

  /// Chat settings description
  ///
  /// In en, this message translates to:
  /// **'These settings override global and character settings for this chat only.'**
  String get chatSettingsDescription;

  /// Chat negative prompt label
  ///
  /// In en, this message translates to:
  /// **'Chat Negative Prompt'**
  String get chatNegativePrompt;

  /// Override for this chat hint
  ///
  /// In en, this message translates to:
  /// **'Override for this chat'**
  String get overrideForThisChat;

  /// Chat positive prompt label
  ///
  /// In en, this message translates to:
  /// **'Chat Positive Prompt'**
  String get chatPositivePrompt;

  /// Enhancement for this chat hint
  ///
  /// In en, this message translates to:
  /// **'Enhancement for this chat'**
  String get enhancementForThisChat;

  /// Prompt combine mode label
  ///
  /// In en, this message translates to:
  /// **'Prompt Combine Mode'**
  String get promptCombineMode;

  /// Replace combine mode
  ///
  /// In en, this message translates to:
  /// **'Replace (use chat prompt only)'**
  String get replaceChatPromptOnly;

  /// Prepend combine mode
  ///
  /// In en, this message translates to:
  /// **'Prepend (chat + global)'**
  String get prependChatPlusGlobal;

  /// Append combine mode
  ///
  /// In en, this message translates to:
  /// **'Append (global + chat)'**
  String get appendGlobalPlusChat;

  /// About CFG scale label
  ///
  /// In en, this message translates to:
  /// **'About CFG Scale'**
  String get aboutCfgScale;

  /// About CFG scale description
  ///
  /// In en, this message translates to:
  /// **'CFG (Classifier-Free Guidance) Scale controls how strongly the model follows the negative prompt to avoid certain content or styles.\n\n• Scale 1.0 = No effect (default)\n• Scale 1.5-3.0 = Subtle guidance\n• Scale 3.0-7.0 = Moderate guidance\n• Scale 7.0+ = Strong guidance (may affect coherence)'**
  String get aboutCfgScaleDescription;

  /// CFG scale help dialog title
  ///
  /// In en, this message translates to:
  /// **'CFG Scale Help'**
  String get cfgScaleHelp;

  /// CFG scale help content
  ///
  /// In en, this message translates to:
  /// **'Classifier-Free Guidance (CFG) Scale is a technique that allows you to guide the AI model\'s output by specifying what you want to avoid.\n\n**How it works:**\nThe model generates two outputs - one with your prompt and one with the negative prompt. The final output is adjusted to move away from the negative prompt direction.\n\n**Settings Priority:**\n1. Chat-specific settings (highest)\n2. Character-specific settings\n3. Global settings (lowest)\n\n**Tips:**\n• Start with low values (1.5-2.0) and increase gradually\n• Use specific negative prompts for better results\n• High values may cause repetition or incoherence\n• Not all AI backends support CFG Scale'**
  String get cfgScaleHelpContent;

  /// Help button
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Processing indicator
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// Sample chat message for background preview
  ///
  /// In en, this message translates to:
  /// **'Hello! How are you?'**
  String get sampleMessage1;

  /// Sample chat message for background preview
  ///
  /// In en, this message translates to:
  /// **'I\'m doing great!'**
  String get sampleMessage2;

  /// General section header
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Enable image generation toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Image Generation'**
  String get enableImageGeneration;

  /// Image generation description
  ///
  /// In en, this message translates to:
  /// **'Generate images using AI'**
  String get generateImagesUsingAi;

  /// Image generation provider label
  ///
  /// In en, this message translates to:
  /// **'Image Generation Provider'**
  String get imageGenerationProvider;

  /// API endpoint label
  ///
  /// In en, this message translates to:
  /// **'API Endpoint'**
  String get apiEndpoint;

  /// Not configured message
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// Default parameters section header
  ///
  /// In en, this message translates to:
  /// **'Default Parameters'**
  String get defaultParameters;

  /// Image size label
  ///
  /// In en, this message translates to:
  /// **'Image Size'**
  String get imageSize;

  /// Steps label for image generation
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// Sampler label
  ///
  /// In en, this message translates to:
  /// **'Sampler'**
  String get sampler;

  /// Default negative prompt label
  ///
  /// In en, this message translates to:
  /// **'Default Negative Prompt'**
  String get defaultNegativePrompt;

  /// Negative prompt hint for image generation
  ///
  /// In en, this message translates to:
  /// **'Enter terms to avoid in generated images'**
  String get enterTermsToAvoid;

  /// Test section header
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// About image generation label
  ///
  /// In en, this message translates to:
  /// **'About Image Generation'**
  String get aboutImageGeneration;

  /// About image generation description
  ///
  /// In en, this message translates to:
  /// **'Generate images using AI models. Use the /imagine command in chat or generate character portraits from the character editor.'**
  String get aboutImageGenerationDescription;

  /// Chat input action that opens image generation
  ///
  /// In en, this message translates to:
  /// **'Imagine'**
  String get imagine;

  /// Ask the chat model to write an image prompt
  ///
  /// In en, this message translates to:
  /// **'Fill with AI'**
  String get fillImagePromptWithAi;

  /// Imagine command label
  ///
  /// In en, this message translates to:
  /// **'/imagine Command'**
  String get imagineCommand;

  /// Imagine command usage
  ///
  /// In en, this message translates to:
  /// **'Usage: /imagine <prompt> [--width N] [--height N] [--steps N] [--cfg N] [--seed N]'**
  String get imagineCommandUsage;

  /// Stable Diffusion label
  ///
  /// In en, this message translates to:
  /// **'Stable Diffusion'**
  String get stableDiffusion;

  /// Stable Diffusion description
  ///
  /// In en, this message translates to:
  /// **'Connect to a local or remote Stable Diffusion WebUI instance. Requires the API to be enabled.'**
  String get stableDiffusionDescription;

  /// DALL-E label
  ///
  /// In en, this message translates to:
  /// **'DALL-E'**
  String get dalle;

  /// DALL-E description
  ///
  /// In en, this message translates to:
  /// **'DALL-E image generation through an OAI Compatible endpoint. Requires an API key.'**
  String get dalleDescription;

  /// Prompt label
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get prompt;

  /// Prompt hint for image generation
  ///
  /// In en, this message translates to:
  /// **'Enter a prompt to generate an image'**
  String get enterPromptToGenerate;

  /// Generate button
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// Generating indicator
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// Generation complete message
  ///
  /// In en, this message translates to:
  /// **'Generation Complete'**
  String get generationComplete;

  /// Image placeholder text
  ///
  /// In en, this message translates to:
  /// **'Image would be displayed here'**
  String get imageWouldBeDisplayed;

  /// Enable logit bias toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Logit Bias'**
  String get enableLogitBias;

  /// Logit bias description
  ///
  /// In en, this message translates to:
  /// **'Adjust token probabilities in AI responses'**
  String get adjustTokenProbabilities;

  /// Presets section header
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get presets;

  /// Active preset label
  ///
  /// In en, this message translates to:
  /// **'Active Preset'**
  String get activePresetLabel;

  /// None option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// New preset tooltip
  ///
  /// In en, this message translates to:
  /// **'New Preset'**
  String get newPreset;

  /// Import preset menu item
  ///
  /// In en, this message translates to:
  /// **'Import Preset'**
  String get importPresetLabel;

  /// Bias entries section header
  ///
  /// In en, this message translates to:
  /// **'Bias Entries'**
  String get biasEntries;

  /// No bias entries message
  ///
  /// In en, this message translates to:
  /// **'No bias entries'**
  String get noBiasEntries;

  /// Add entries description
  ///
  /// In en, this message translates to:
  /// **'Add entries to adjust token probabilities'**
  String get addEntriesToAdjust;

  /// Add entry button
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addEntry;

  /// Text or token label
  ///
  /// In en, this message translates to:
  /// **'Text / Token'**
  String get textOrToken;

  /// Text token hint for logit bias
  ///
  /// In en, this message translates to:
  /// **'word, {verbatim}, or [1234]'**
  String textTokenHint(Object verbatim);

  /// Bias label
  ///
  /// In en, this message translates to:
  /// **'Bias'**
  String get bias;

  /// Logit bias help dialog title
  ///
  /// In en, this message translates to:
  /// **'Logit Bias Help'**
  String get logitBiasHelp;

  /// Preset copied message
  ///
  /// In en, this message translates to:
  /// **'Preset copied to clipboard'**
  String get presetCopiedToClipboard;

  /// Export preset failed error
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportPresetFailed(String error);

  /// Paste preset JSON hint
  ///
  /// In en, this message translates to:
  /// **'Paste preset JSON here'**
  String get pastePresetJson;

  /// Preset imported message
  ///
  /// In en, this message translates to:
  /// **'Preset imported successfully'**
  String get presetImportedSuccessfully;

  /// Import preset failed error
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importPresetFailed(String error);

  /// Rename button
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// Delete preset confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this preset?'**
  String get deletePresetQuestion;

  /// More options tooltip
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// Load preset label
  ///
  /// In en, this message translates to:
  /// **'Load Preset'**
  String get loadPreset;

  /// Save as preset label
  ///
  /// In en, this message translates to:
  /// **'Save as Preset'**
  String get saveAsPresetLabel;

  /// Export preset label
  ///
  /// In en, this message translates to:
  /// **'Export Preset'**
  String get exportPreset;

  /// Reset to default label
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// Prompt manager help text
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder sections. Toggle switches to enable/disable.'**
  String get dragToReorder;

  /// Deleted message
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{name}\"'**
  String deleted(String name);

  /// Imported message
  ///
  /// In en, this message translates to:
  /// **'Imported \"{name}\"'**
  String imported(String name);

  /// Invalid preset format error
  ///
  /// In en, this message translates to:
  /// **'Invalid preset format'**
  String get invalidPresetFormatMessage;

  /// Export preset dialog title
  ///
  /// In en, this message translates to:
  /// **'Export Preset'**
  String get exportPresetTitle;

  /// Preset name label
  ///
  /// In en, this message translates to:
  /// **'Preset Name'**
  String get presetNameLabel;

  /// Please enter name message
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterNameMessage;

  /// Saved message
  ///
  /// In en, this message translates to:
  /// **'Saved \"{name}\"'**
  String saved(String name);

  /// Save failed error
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailedMessage(String error);

  /// Reset to default confirmation
  ///
  /// In en, this message translates to:
  /// **'This will reset all prompt sections to their default order and enable all sections. Continue?'**
  String get resetToDefaultQuestion;

  /// Reset to default config message
  ///
  /// In en, this message translates to:
  /// **'Reset to default configuration'**
  String get resetToDefaultConfig;

  /// Prompt manager help title
  ///
  /// In en, this message translates to:
  /// **'Prompt Manager Help'**
  String get promptManagerHelp;

  /// Applied preset message
  ///
  /// In en, this message translates to:
  /// **'Applied \"{name}\" preset'**
  String applied(String name);

  /// Show quick replies toggle
  ///
  /// In en, this message translates to:
  /// **'Show Quick Replies'**
  String get showQuickReplies;

  /// Show quick replies description
  ///
  /// In en, this message translates to:
  /// **'Display quick reply buttons in chat'**
  String get displayQuickReplyButtons;

  /// Position above input toggle
  ///
  /// In en, this message translates to:
  /// **'Position Above Input'**
  String get positionAboveInput;

  /// Above input description
  ///
  /// In en, this message translates to:
  /// **'Quick replies appear above the input field'**
  String get quickRepliesAboveInput;

  /// Below input description
  ///
  /// In en, this message translates to:
  /// **'Quick replies appear below the input field'**
  String get quickRepliesBelowInput;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No quick replies message
  ///
  /// In en, this message translates to:
  /// **'No quick replies'**
  String get noQuickReplies;

  /// Add first quick reply button
  ///
  /// In en, this message translates to:
  /// **'Add your first quick reply'**
  String get addYourFirstQuickReply;

  /// Delete quick reply confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{label}\"?'**
  String deleteQuickReplyQuestion(String label);

  /// Reset quick replies confirmation
  ///
  /// In en, this message translates to:
  /// **'This will replace all your quick replies with the default set. Continue?'**
  String get resetToDefaultQuestion2;

  /// Continue or empty message placeholder
  ///
  /// In en, this message translates to:
  /// **'(Continue/Empty message)'**
  String get continueOrEmpty;

  /// Auto-send tooltip
  ///
  /// In en, this message translates to:
  /// **'Auto-send'**
  String get autoSendTooltip;

  /// Add quick reply dialog title
  ///
  /// In en, this message translates to:
  /// **'Add Quick Reply'**
  String get addQuickReply;

  /// Edit quick reply dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Quick Reply'**
  String get editQuickReplyLabel;

  /// Button label field
  ///
  /// In en, this message translates to:
  /// **'Button Label'**
  String get buttonLabel;

  /// Button label hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Yes, Continue, Think...'**
  String get buttonLabelHint;

  /// Message label
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// Leave empty hint
  ///
  /// In en, this message translates to:
  /// **'Leave empty for continue action'**
  String get leaveEmptyForContinue;

  /// Supports macros help
  ///
  /// In en, this message translates to:
  /// **'Supports prompt macros'**
  String get supportsMacros;

  /// Auto-send label
  ///
  /// In en, this message translates to:
  /// **'Auto-send'**
  String get autoSendLabel;

  /// Auto-send enabled description
  ///
  /// In en, this message translates to:
  /// **'Message will be sent immediately'**
  String get messageSentImmediately;

  /// Auto-send disabled description
  ///
  /// In en, this message translates to:
  /// **'Message will fill the input field'**
  String get messageFillsInput;

  /// Regex scripts screen title
  ///
  /// In en, this message translates to:
  /// **'Regex Scripts'**
  String get regexScripts;

  /// Add script tooltip
  ///
  /// In en, this message translates to:
  /// **'Add Script'**
  String get addScript;

  /// Add presets menu item
  ///
  /// In en, this message translates to:
  /// **'Add Presets'**
  String get addPresets;

  /// Clear all menu item
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Enable regex scripts toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Regex Scripts'**
  String get enableRegexScripts;

  /// Regex scripts description
  ///
  /// In en, this message translates to:
  /// **'Apply find/replace patterns to messages'**
  String get applyFindReplacePatterns;

  /// Apply to section header
  ///
  /// In en, this message translates to:
  /// **'Apply To'**
  String get applyTo;

  /// User input label
  ///
  /// In en, this message translates to:
  /// **'User Input'**
  String get userInput;

  /// User input description
  ///
  /// In en, this message translates to:
  /// **'Apply to messages before sending'**
  String get applyBeforeSending;

  /// AI output label
  ///
  /// In en, this message translates to:
  /// **'AI Output'**
  String get aiOutput;

  /// AI output description
  ///
  /// In en, this message translates to:
  /// **'Apply to AI responses'**
  String get applyToAiResponses;

  /// Slash commands label
  ///
  /// In en, this message translates to:
  /// **'Slash Commands'**
  String get slashCommandsLabel;

  /// Slash commands description
  ///
  /// In en, this message translates to:
  /// **'Apply during command processing'**
  String get applyDuringCommandProcessing;

  /// Lorebook label
  ///
  /// In en, this message translates to:
  /// **'Lorebook'**
  String get worldInfoLabel;

  /// Lorebook description
  ///
  /// In en, this message translates to:
  /// **'Apply to lorebook entries'**
  String get applyToWorldInfoEntries;

  /// Scripts count
  ///
  /// In en, this message translates to:
  /// **'Scripts ({count})'**
  String scriptsCount(int count);

  /// No regex scripts message
  ///
  /// In en, this message translates to:
  /// **'No regex scripts'**
  String get noRegexScripts;

  /// No regex scripts hint
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a script or use the menu to add presets'**
  String get tapToAddOrUseMenu;

  /// About regex scripts label
  ///
  /// In en, this message translates to:
  /// **'About Regex Scripts'**
  String get aboutRegexScripts;

  /// About regex scripts description
  ///
  /// In en, this message translates to:
  /// **'Regex scripts allow you to find and replace text patterns in messages. Use capture groups (\\\$1, \\\$2) in replacements.'**
  String get aboutRegexScriptsDescription;

  /// Pattern format label
  ///
  /// In en, this message translates to:
  /// **'Pattern Format'**
  String get patternFormat;

  /// Pattern format description
  ///
  /// In en, this message translates to:
  /// **'Use /pattern/flags format (e.g., /hello/gi) or plain patterns. Flags: i=case-insensitive, m=multiline, s=dotall'**
  String get patternFormatDescription;

  /// Preset scripts added message
  ///
  /// In en, this message translates to:
  /// **'Preset scripts added'**
  String get presetScriptsAdded;

  /// Delete script confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteScriptQuestion(String name);

  /// Clear all scripts dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear All Scripts'**
  String get clearAllScripts;

  /// Clear all scripts confirmation
  ///
  /// In en, this message translates to:
  /// **'This will delete all regex scripts. This cannot be undone.'**
  String get clearAllScriptsQuestion;

  /// Import scripts dialog title
  ///
  /// In en, this message translates to:
  /// **'Import Scripts'**
  String get importScripts;

  /// Paste JSON hint
  ///
  /// In en, this message translates to:
  /// **'Paste JSON array of scripts'**
  String get pasteJsonArray;

  /// Imported count message
  ///
  /// In en, this message translates to:
  /// **'Imported {count} scripts'**
  String importedCount(int count);

  /// Export scripts dialog title
  ///
  /// In en, this message translates to:
  /// **'Export Scripts'**
  String get exportScripts;

  /// New script title
  ///
  /// In en, this message translates to:
  /// **'New Script'**
  String get newScript;

  /// Edit script title
  ///
  /// In en, this message translates to:
  /// **'Edit Script'**
  String get editScript;

  /// Script name label
  ///
  /// In en, this message translates to:
  /// **'Script Name'**
  String get scriptName;

  /// Description optional field
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptionalLabel;

  /// Find pattern label
  ///
  /// In en, this message translates to:
  /// **'Find Pattern'**
  String get findPattern;

  /// Find pattern hint
  ///
  /// In en, this message translates to:
  /// **'/pattern/flags or plain pattern'**
  String get patternOrPlainPattern;

  /// Replace with label
  ///
  /// In en, this message translates to:
  /// **'Replace With'**
  String get replaceWith;

  /// Replace with hint
  ///
  /// In en, this message translates to:
  /// **'Use \\\$1, \\\$2 for capture groups'**
  String get useCaptureGroups;

  /// Apply to label
  ///
  /// In en, this message translates to:
  /// **'Apply To'**
  String get applyToLabel;

  /// Options section header
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// Markdown only label
  ///
  /// In en, this message translates to:
  /// **'Markdown Only'**
  String get markdownOnly;

  /// Markdown only description
  ///
  /// In en, this message translates to:
  /// **'Only apply during markdown rendering'**
  String get onlyApplyDuringMarkdown;

  /// Prompt only label
  ///
  /// In en, this message translates to:
  /// **'Prompt Only'**
  String get promptOnly;

  /// Prompt only description
  ///
  /// In en, this message translates to:
  /// **'Only apply during prompt generation'**
  String get onlyApplyDuringPrompt;

  /// Run on edit label
  ///
  /// In en, this message translates to:
  /// **'Run on Edit'**
  String get runOnEdit;

  /// Run on edit description
  ///
  /// In en, this message translates to:
  /// **'Apply when editing messages'**
  String get applyWhenEditingMessages;

  /// Macro substitution label
  ///
  /// In en, this message translates to:
  /// **'Macro Substitution'**
  String get macroSubstitution;

  /// Name and pattern required message
  ///
  /// In en, this message translates to:
  /// **'Name and pattern are required'**
  String get nameAndPatternRequired;

  /// Pattern label for testing
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get patternLabel;

  /// Pattern hint for testing
  ///
  /// In en, this message translates to:
  /// **'/pattern/flags'**
  String get patternHint;

  /// Test string label
  ///
  /// In en, this message translates to:
  /// **'Test String'**
  String get testString;

  /// Replacement label for testing
  ///
  /// In en, this message translates to:
  /// **'Replacement'**
  String get replacementLabel;

  /// Replacement hint for testing
  ///
  /// In en, this message translates to:
  /// **'\$1, \$2, or the matched text'**
  String get replacementHint;

  /// Test button
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testButton;

  /// Matches count
  ///
  /// In en, this message translates to:
  /// **'{count} match(es)'**
  String matchesCount(int count);

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLabel;

  /// Result label
  ///
  /// In en, this message translates to:
  /// **'Result:'**
  String get resultLabel;

  /// Expression sprites screen title
  ///
  /// In en, this message translates to:
  /// **'Expression Sprites'**
  String get expressionSprites;

  /// Enable sprites toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Sprites'**
  String get enableSprites;

  /// Enable sprites description
  ///
  /// In en, this message translates to:
  /// **'Show character expression images in chat'**
  String get showCharacterExpressions;

  /// Display section header
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// Sprite size label
  ///
  /// In en, this message translates to:
  /// **'Sprite Size'**
  String get spriteSize;

  /// Position label
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// Position description
  ///
  /// In en, this message translates to:
  /// **'Where to display sprites'**
  String get whereToDisplaySprites;

  /// Left position
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// Right position
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get right;

  /// Center position
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get center;

  /// Floating left position
  ///
  /// In en, this message translates to:
  /// **'Floating Left'**
  String get floatingLeft;

  /// Floating right position
  ///
  /// In en, this message translates to:
  /// **'Floating Right'**
  String get floatingRight;

  /// Animation section header
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get animation;

  /// Animate transitions toggle
  ///
  /// In en, this message translates to:
  /// **'Animate Transitions'**
  String get animateTransitions;

  /// Animate transitions description
  ///
  /// In en, this message translates to:
  /// **'Smooth fade when sprite changes'**
  String get smoothFadeWhenSpriteChanges;

  /// Transition duration label
  ///
  /// In en, this message translates to:
  /// **'Transition Duration'**
  String get transitionDuration;

  /// Show during streaming toggle
  ///
  /// In en, this message translates to:
  /// **'Show During Streaming'**
  String get showDuringStreaming;

  /// Show during streaming description
  ///
  /// In en, this message translates to:
  /// **'Display sprites while AI is generating'**
  String get displaySpritesWhileGenerating;

  /// Emotion detection section header
  ///
  /// In en, this message translates to:
  /// **'Emotion Detection'**
  String get emotionDetection;

  /// How it works label
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// Sprite emotion detection description
  ///
  /// In en, this message translates to:
  /// **'Sprites are automatically selected based on emotion keywords detected in messages. Action text like *smiles* or *laughs* is prioritized.'**
  String get spriteEmotionDetectionDescription;

  /// Supported emotions label
  ///
  /// In en, this message translates to:
  /// **'Supported Emotions'**
  String get supportedEmotions;

  /// Character sprites title
  ///
  /// In en, this message translates to:
  /// **'{name} Sprites'**
  String characterSprites(String name);

  /// Import from folder tooltip
  ///
  /// In en, this message translates to:
  /// **'Import from folder'**
  String get importFromFolder;

  /// Delete all sprites menu item
  ///
  /// In en, this message translates to:
  /// **'Delete All Sprites'**
  String get deleteAllSprites;

  /// Add sprite button
  ///
  /// In en, this message translates to:
  /// **'Add Sprite'**
  String get addSprite;

  /// Sprites count
  ///
  /// In en, this message translates to:
  /// **'{count} sprites'**
  String spritesCount(int count);

  /// Default emotion label
  ///
  /// In en, this message translates to:
  /// **'Default: {emotion}'**
  String defaultEmotion(String emotion);

  /// No sprites message
  ///
  /// In en, this message translates to:
  /// **'No sprites yet'**
  String get noSpritesYet;

  /// Add expression images hint
  ///
  /// In en, this message translates to:
  /// **'Add expression images for this character'**
  String get addExpressionImages;

  /// Select emotion dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Emotion'**
  String get selectEmotion;

  /// Added sprite message
  ///
  /// In en, this message translates to:
  /// **'Added {emotion} sprite'**
  String addedSpriteEmotion(String emotion);

  /// Set as default emotion menu item
  ///
  /// In en, this message translates to:
  /// **'Set as Default'**
  String get setAsDefaultEmotion;

  /// Change emotion menu item
  ///
  /// In en, this message translates to:
  /// **'Change Emotion'**
  String get changeEmotion;

  /// Delete sprite dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Sprite'**
  String get deleteSprite;

  /// Delete sprite confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete the {emotion} sprite?'**
  String deleteSpriteConfirmation(String emotion);

  /// Delete all sprites confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all sprites for this character? This cannot be undone.'**
  String get deleteAllSpritesConfirmation;

  /// Import sprites dialog title
  ///
  /// In en, this message translates to:
  /// **'Import Sprites'**
  String get importSprites;

  /// Import sprites description
  ///
  /// In en, this message translates to:
  /// **'Import sprites from a folder. Files should be named with emotion keywords:'**
  String get importSpritesDescription;

  /// Supported formats for sprites
  ///
  /// In en, this message translates to:
  /// **'Supported formats: PNG, JPG, GIF, WebP'**
  String get supportedFormatsSprites;

  /// Select folder button
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get selectFolder;

  /// Folder import requirement message
  ///
  /// In en, this message translates to:
  /// **'Folder import requires file_picker package'**
  String get folderImportRequiresPackage;

  /// App statistics title
  ///
  /// In en, this message translates to:
  /// **'App Statistics'**
  String get appStatistics;

  /// Chat statistics title
  ///
  /// In en, this message translates to:
  /// **'Chat Statistics'**
  String get chatStatistics;

  /// Reset statistics tooltip
  ///
  /// In en, this message translates to:
  /// **'Reset statistics'**
  String get resetStatistics;

  /// Reset statistics confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all statistics? This cannot be undone.'**
  String get resetStatisticsConfirmation;

  /// Statistics reset message
  ///
  /// In en, this message translates to:
  /// **'Statistics reset'**
  String get statisticsReset;

  /// Overview section header
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// First used label
  ///
  /// In en, this message translates to:
  /// **'First Used'**
  String get firstUsed;

  /// Unknown label
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Total groups statistic
  ///
  /// In en, this message translates to:
  /// **'Total Groups'**
  String get totalGroups;

  /// Total generations statistic
  ///
  /// In en, this message translates to:
  /// **'Total Generations'**
  String get totalGenerations;

  /// Token usage section header
  ///
  /// In en, this message translates to:
  /// **'Token Usage'**
  String get tokenUsage;

  /// Total tokens used label
  ///
  /// In en, this message translates to:
  /// **'Total Tokens Used'**
  String get totalTokensUsed;

  /// Average tokens per generation label
  ///
  /// In en, this message translates to:
  /// **'Avg Tokens/Generation'**
  String get avgTokensPerGeneration;

  /// Performance section header
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// Total generation time label
  ///
  /// In en, this message translates to:
  /// **'Total Generation Time'**
  String get totalGenerationTime;

  /// Average generation time label
  ///
  /// In en, this message translates to:
  /// **'Avg Generation Time'**
  String get avgGenerationTime;

  /// User messages count
  ///
  /// In en, this message translates to:
  /// **'User Messages'**
  String get userMessages;

  /// Assistant messages count
  ///
  /// In en, this message translates to:
  /// **'Assistant Messages'**
  String get assistantMessages;

  /// System messages count
  ///
  /// In en, this message translates to:
  /// **'System Messages'**
  String get systemMessages;

  /// Timeline section header
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// First message timestamp label
  ///
  /// In en, this message translates to:
  /// **'First Message'**
  String get firstMessage_;

  /// Last message timestamp label
  ///
  /// In en, this message translates to:
  /// **'Last Message'**
  String get lastMessage;

  /// Chat duration label
  ///
  /// In en, this message translates to:
  /// **'Chat Duration'**
  String get chatDuration;

  /// Prompt tokens count
  ///
  /// In en, this message translates to:
  /// **'Prompt Tokens'**
  String get promptTokens;

  /// Completion tokens count
  ///
  /// In en, this message translates to:
  /// **'Completion Tokens'**
  String get completionTokens;

  /// Average tokens per message label
  ///
  /// In en, this message translates to:
  /// **'Avg Tokens/Message'**
  String get avgTokensPerMessage;

  /// Generation performance section header
  ///
  /// In en, this message translates to:
  /// **'Generation Performance'**
  String get generationPerformance;

  /// Generation count label
  ///
  /// In en, this message translates to:
  /// **'Total Generations'**
  String get generationCount;

  /// Speech-to-text screen title
  ///
  /// In en, this message translates to:
  /// **'Speech-to-Text'**
  String get speechToText;

  /// Enable STT toggle
  ///
  /// In en, this message translates to:
  /// **'Enable STT'**
  String get enableStt;

  /// Enable STT description
  ///
  /// In en, this message translates to:
  /// **'Use voice input for messages'**
  String get useVoiceInputForMessages;

  /// Auto-send toggle for STT
  ///
  /// In en, this message translates to:
  /// **'Auto-send'**
  String get autoSendStt;

  /// Auto-send STT description
  ///
  /// In en, this message translates to:
  /// **'Automatically send message after speaking'**
  String get automaticallySendAfterSpeaking;

  /// Continuous listening toggle
  ///
  /// In en, this message translates to:
  /// **'Continuous Listening'**
  String get continuousListening;

  /// Continuous listening description
  ///
  /// In en, this message translates to:
  /// **'Keep listening after each phrase'**
  String get keepListeningAfterPhrase;

  /// Show partial results toggle
  ///
  /// In en, this message translates to:
  /// **'Show Partial Results'**
  String get showPartialResults;

  /// Show partial results description
  ///
  /// In en, this message translates to:
  /// **'Display text as you speak'**
  String get displayTextAsYouSpeak;

  /// STT provider label
  ///
  /// In en, this message translates to:
  /// **'STT Provider'**
  String get sttProvider;

  /// Recognition language label
  ///
  /// In en, this message translates to:
  /// **'Recognition Language'**
  String get recognitionLanguage;

  /// Test voice input label
  ///
  /// In en, this message translates to:
  /// **'Test Voice Input'**
  String get testVoiceInput;

  /// Stop listening label
  ///
  /// In en, this message translates to:
  /// **'Stop Listening'**
  String get stopListening;

  /// Tap to stop hint
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get tapToStop;

  /// Test speech recognition hint
  ///
  /// In en, this message translates to:
  /// **'Tap to test speech recognition'**
  String get tapToTestSpeechRecognition;

  /// Final status label
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get final_;

  /// Listening status
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// About STT label
  ///
  /// In en, this message translates to:
  /// **'About STT'**
  String get aboutStt;

  /// About STT description
  ///
  /// In en, this message translates to:
  /// **'Speech-to-Text allows you to dictate messages using your voice. Tap the microphone button in the chat input to start speaking.'**
  String get aboutSttDescription;

  /// System STT label
  ///
  /// In en, this message translates to:
  /// **'System STT'**
  String get systemStt;

  /// System STT description
  ///
  /// In en, this message translates to:
  /// **'Using your device\'s built-in speech recognition. Accuracy depends on your system settings.'**
  String get systemSttDescription;

  /// Whisper label
  ///
  /// In en, this message translates to:
  /// **'Whisper'**
  String get whisper;

  /// Whisper description
  ///
  /// In en, this message translates to:
  /// **'Whisper transcription through an OAI Compatible endpoint. Requires an API key.'**
  String get whisperDescription;

  /// Voice input tooltip
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get voiceInput;

  /// Hold-to-talk microphone tooltip
  ///
  /// In en, this message translates to:
  /// **'Hold to talk'**
  String get holdToTalk;

  /// Active hold-to-talk microphone tooltip
  ///
  /// In en, this message translates to:
  /// **'Release to transcribe'**
  String get releaseToTranscribe;

  /// Cancel active voice input tooltip
  ///
  /// In en, this message translates to:
  /// **'Cancel voice input'**
  String get cancelVoiceInput;

  /// Open the operating system settings
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSystemSettings;

  /// System speech recognition offline capability note
  ///
  /// In en, this message translates to:
  /// **'Offline recognition depends on your operating system and installed language packs.'**
  String get systemSttOfflineNote;

  /// External STT configuration warning
  ///
  /// In en, this message translates to:
  /// **'Complete the selected provider configuration before testing.'**
  String get sttConfigurationRequired;

  /// Speech recognition not available warning
  ///
  /// In en, this message translates to:
  /// **'Speech recognition may not be available on this device.'**
  String get speechRecognitionNotAvailable;

  /// Themes screen title
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// Create custom theme tooltip
  ///
  /// In en, this message translates to:
  /// **'Create custom theme'**
  String get createCustomTheme;

  /// Built-in themes section
  ///
  /// In en, this message translates to:
  /// **'Built-in Themes'**
  String get builtInThemes;

  /// Preview section header
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Chat preview label
  ///
  /// In en, this message translates to:
  /// **'Chat Preview'**
  String get chatPreview;

  /// Sample AI message
  ///
  /// In en, this message translates to:
  /// **'Hello! How can I help you today?'**
  String get helloHowCanIHelp;

  /// Sample user message
  ///
  /// In en, this message translates to:
  /// **'Tell me a story!'**
  String get tellMeAStory;

  /// Message input placeholder
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// Create theme dialog title
  ///
  /// In en, this message translates to:
  /// **'Create Theme'**
  String get createTheme;

  /// Edit theme dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Theme'**
  String get editTheme;

  /// Delete theme dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Theme'**
  String get deleteTheme;

  /// Delete theme confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteThemeConfirmation(String name);

  /// Theme name label
  ///
  /// In en, this message translates to:
  /// **'Theme Name'**
  String get themeName;

  /// Background color label
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// Surface color label
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get surface;

  /// Card color label
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// Select color dialog title
  ///
  /// In en, this message translates to:
  /// **'Select {label}'**
  String selectThemeColor(String label);

  /// Hex color label
  ///
  /// In en, this message translates to:
  /// **'Hex Color'**
  String get hexColor;

  /// Tokenizer screen title
  ///
  /// In en, this message translates to:
  /// **'Tokenizer'**
  String get tokenizerSettings;

  /// Tokenizer help tooltip
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get tokenizerHelp;

  /// Tokenizer selection label
  ///
  /// In en, this message translates to:
  /// **'Tokenizer'**
  String get tokenizerLabel;

  /// Show token count toggle
  ///
  /// In en, this message translates to:
  /// **'Show Token Count'**
  String get showTokenCount;

  /// Show token count description
  ///
  /// In en, this message translates to:
  /// **'Display token count in chat input'**
  String get displayTokenCountInInput;

  /// Show token visualization toggle
  ///
  /// In en, this message translates to:
  /// **'Show Token Visualization'**
  String get showTokenVisualization;

  /// Show token visualization description
  ///
  /// In en, this message translates to:
  /// **'Highlight individual tokens'**
  String get highlightIndividualTokens;

  /// Cache results toggle
  ///
  /// In en, this message translates to:
  /// **'Cache Results'**
  String get cacheResults;

  /// Cache results description
  ///
  /// In en, this message translates to:
  /// **'Cache tokenization for performance'**
  String get cacheTokenizationForPerformance;

  /// Token visualization section header
  ///
  /// In en, this message translates to:
  /// **'Token Visualization'**
  String get tokenVisualization;

  /// Text to tokenize label
  ///
  /// In en, this message translates to:
  /// **'Enter text to tokenize'**
  String get enterTextToTokenize;

  /// Type or paste text hint
  ///
  /// In en, this message translates to:
  /// **'Type or paste text here...'**
  String get typePasteTextHere;

  /// Quick estimate label
  ///
  /// In en, this message translates to:
  /// **'Quick Estimate'**
  String get quickEstimate;

  /// Approximate tokens count
  ///
  /// In en, this message translates to:
  /// **'~{count} tokens'**
  String approximateTokens(int count);

  /// Characters count
  ///
  /// In en, this message translates to:
  /// **'{count} chars'**
  String chars(int count);

  /// Statistics section label
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsLabel;

  /// Total tokens label
  ///
  /// In en, this message translates to:
  /// **'Total Tokens'**
  String get totalTokens;

  /// Unique tokens label
  ///
  /// In en, this message translates to:
  /// **'Unique'**
  String get unique;

  /// Characters per token label
  ///
  /// In en, this message translates to:
  /// **'Chars/Token'**
  String get charsPerToken;

  /// Average length label
  ///
  /// In en, this message translates to:
  /// **'Avg Length'**
  String get avgLength;

  /// Longest token label
  ///
  /// In en, this message translates to:
  /// **'Longest'**
  String get longest;

  /// Shortest token label
  ///
  /// In en, this message translates to:
  /// **'Shortest'**
  String get shortest;

  /// Most common tokens label
  ///
  /// In en, this message translates to:
  /// **'Most Common Tokens'**
  String get mostCommonTokens;

  /// Token breakdown label
  ///
  /// In en, this message translates to:
  /// **'Token Breakdown'**
  String get tokenBreakdown;

  /// Tokens count
  ///
  /// In en, this message translates to:
  /// **'{count} tokens'**
  String tokensCount(int count);

  /// Token tooltip info
  ///
  /// In en, this message translates to:
  /// **'Token ID: {id}\nLength: {length} chars'**
  String tokenIdLength(String id, int length);

  /// Translation settings screen title
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translationSettings;

  /// Enable translation toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Translation'**
  String get enableTranslation;

  /// Enable translation description
  ///
  /// In en, this message translates to:
  /// **'Translate messages automatically'**
  String get translateMessagesAutomatically;

  /// Translation provider label
  ///
  /// In en, this message translates to:
  /// **'Translation Provider'**
  String get translationProvider;

  /// Source language label
  ///
  /// In en, this message translates to:
  /// **'Source Language'**
  String get sourceLanguage;

  /// Target language label
  ///
  /// In en, this message translates to:
  /// **'Target Language'**
  String get targetLanguage;

  /// Auto-detect option
  ///
  /// In en, this message translates to:
  /// **'Auto-detect'**
  String get autoDetect;

  /// Translate user messages toggle
  ///
  /// In en, this message translates to:
  /// **'Translate User Messages'**
  String get translateUserMessages;

  /// Translate AI responses toggle
  ///
  /// In en, this message translates to:
  /// **'Translate AI Responses'**
  String get translateAiResponses;

  /// Text-to-speech screen title
  ///
  /// In en, this message translates to:
  /// **'Text-to-Speech'**
  String get textToSpeech;

  /// Enable TTS toggle
  ///
  /// In en, this message translates to:
  /// **'Enable TTS'**
  String get enableTts;

  /// Enable TTS description
  ///
  /// In en, this message translates to:
  /// **'Read AI responses aloud'**
  String get readAiResponsesAloud;

  /// TTS provider label
  ///
  /// In en, this message translates to:
  /// **'TTS Provider'**
  String get ttsProvider;

  /// Voice settings section header
  ///
  /// In en, this message translates to:
  /// **'Voice Settings'**
  String get voiceSettings;

  /// Voice label
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// Speed label
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// Pitch label
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get pitch;

  /// Volume label
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Auto-play toggle
  ///
  /// In en, this message translates to:
  /// **'Auto-play'**
  String get autoPlay;

  /// Auto-play description
  ///
  /// In en, this message translates to:
  /// **'Automatically play AI responses'**
  String get automaticallyPlayResponses;

  /// Test voice button
  ///
  /// In en, this message translates to:
  /// **'Test Voice'**
  String get testVoice;

  /// Chat variables screen title
  ///
  /// In en, this message translates to:
  /// **'Chat Variables'**
  String get chatVariables;

  /// Variable system section header
  ///
  /// In en, this message translates to:
  /// **'Variable System'**
  String get variableSystem;

  /// Global variables label
  ///
  /// In en, this message translates to:
  /// **'Global Variables'**
  String get globalVariables;

  /// Global variables count
  ///
  /// In en, this message translates to:
  /// **'{count} global variables'**
  String globalVariablesCount(int count);

  /// Local variables label
  ///
  /// In en, this message translates to:
  /// **'Local Variables'**
  String get localVariables;

  /// Local variables count
  ///
  /// In en, this message translates to:
  /// **'{count} local variables'**
  String localVariablesCount(int count);

  /// Add variable button
  ///
  /// In en, this message translates to:
  /// **'Add Variable'**
  String get addVariable;

  /// Variable name label
  ///
  /// In en, this message translates to:
  /// **'Variable Name'**
  String get variableName;

  /// Variable value label
  ///
  /// In en, this message translates to:
  /// **'Variable Value'**
  String get variableValue;

  /// Scope label
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get scope;

  /// Global scope
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get global;

  /// Vector storage screen title
  ///
  /// In en, this message translates to:
  /// **'Vector Storage (RAG)'**
  String get vectorStorageRag;

  /// Enable RAG toggle
  ///
  /// In en, this message translates to:
  /// **'Enable RAG'**
  String get enableRag;

  /// Enable RAG description
  ///
  /// In en, this message translates to:
  /// **'Use vector storage for context retrieval'**
  String get useVectorStorageForContext;

  /// Collections section header
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// Create collection button
  ///
  /// In en, this message translates to:
  /// **'Create Collection'**
  String get createCollection;

  /// Collection name label
  ///
  /// In en, this message translates to:
  /// **'Collection Name'**
  String get collectionName;

  /// Embedding provider label
  ///
  /// In en, this message translates to:
  /// **'Embedding Provider'**
  String get embeddingProvider;

  /// Embedding model label
  ///
  /// In en, this message translates to:
  /// **'Embedding Model'**
  String get embeddingModel;

  /// Chunk size label
  ///
  /// In en, this message translates to:
  /// **'Chunk Size'**
  String get chunkSize;

  /// Chunk overlap label
  ///
  /// In en, this message translates to:
  /// **'Chunk Overlap'**
  String get chunkOverlap;

  /// Top K results label
  ///
  /// In en, this message translates to:
  /// **'Top K Results'**
  String get topKResults;

  /// Similarity threshold label
  ///
  /// In en, this message translates to:
  /// **'Similarity Threshold'**
  String get similarityThreshold;

  /// Character editor screen title
  ///
  /// In en, this message translates to:
  /// **'Character Editor'**
  String get characterEditor;

  /// Basic tab label
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// Prompts tab label
  ///
  /// In en, this message translates to:
  /// **'Prompts'**
  String get prompts;

  /// Meta tab label
  ///
  /// In en, this message translates to:
  /// **'Meta'**
  String get meta;

  /// Name required field
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get nameRequired;

  /// Character name hint
  ///
  /// In en, this message translates to:
  /// **'Character name'**
  String get characterName;

  /// Name is required validation
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// Description hint
  ///
  /// In en, this message translates to:
  /// **'Character description, background, appearance...'**
  String get characterDescription;

  /// Personality hint
  ///
  /// In en, this message translates to:
  /// **'Character personality traits...'**
  String get characterPersonalityTraits;

  /// Scenario hint
  ///
  /// In en, this message translates to:
  /// **'The current circumstances and context...'**
  String get currentCircumstancesContext;

  /// System prompt description
  ///
  /// In en, this message translates to:
  /// **'Custom instructions sent as part of the system message.'**
  String get customInstructionsSystemMessage;

  /// System prompt hint
  ///
  /// In en, this message translates to:
  /// **'You are {char}. You will...'**
  String systemPromptHint(Object char);

  /// Post-history instructions description
  ///
  /// In en, this message translates to:
  /// **'Instructions inserted after the chat history (also known as \"jailbreak\").'**
  String get instructionsInsertedAfterHistory;

  /// Post-history instructions hint
  ///
  /// In en, this message translates to:
  /// **'Continue the roleplay as {char}...'**
  String postHistoryInstructionsHint(Object char);

  /// First message section title
  ///
  /// In en, this message translates to:
  /// **'First Message (Greeting)'**
  String get firstMessageGreeting;

  /// First message description
  ///
  /// In en, this message translates to:
  /// **'The first message sent by the character when starting a new chat.'**
  String get firstMessageSentByCharacter;

  /// First message hint
  ///
  /// In en, this message translates to:
  /// **'*walks into the room* Hello, {user}!'**
  String firstMessageHint(Object user);

  /// Alternate greetings description
  ///
  /// In en, this message translates to:
  /// **'Alternative first messages that can be swiped through.'**
  String get alternateGreetingsCanSwipe;

  /// Greeting index label
  ///
  /// In en, this message translates to:
  /// **'Greeting {index}'**
  String greeting(int index);

  /// Alternative greeting hint
  ///
  /// In en, this message translates to:
  /// **'Alternative greeting message...'**
  String get alternativeGreetingMessage;

  /// Remove greeting tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove greeting'**
  String get removeGreeting;

  /// Move up tooltip
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// Move down tooltip
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

  /// No alternate greetings message
  ///
  /// In en, this message translates to:
  /// **'No alternate greetings. Tap + to add one.'**
  String get noAlternateGreetings;

  /// Example messages description
  ///
  /// In en, this message translates to:
  /// **'Example dialogue to demonstrate how the character speaks.\\nFormat: <START>\\n{user}: Hello\\n{char}: Hi there!'**
  String exampleDialogueDemonstrate(Object char, Object user);

  /// Example messages hint
  ///
  /// In en, this message translates to:
  /// **'<START>\\n{user}: How are you?\\n{char}: I\'m doing well, thanks for asking!'**
  String exampleMessagesHint(Object char, Object user);

  /// Creator notes description
  ///
  /// In en, this message translates to:
  /// **'Notes from the character creator (not sent to the AI).'**
  String get creatorNotesNotSentToAi;

  /// Creator notes hint
  ///
  /// In en, this message translates to:
  /// **'Recommended settings, backstory notes...'**
  String get creatorNotesHint;

  /// Tags helper text
  ///
  /// In en, this message translates to:
  /// **'Comma-separated list of tags'**
  String get tagsCommaSeparated;

  /// Tags hint
  ///
  /// In en, this message translates to:
  /// **'fantasy, female, adventure'**
  String get tagsHint;

  /// Creator label
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// Creator hint
  ///
  /// In en, this message translates to:
  /// **'Your name or username'**
  String get yourNameOrUsername;

  /// Version number hint
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get versionNumber;

  /// Character info section title
  ///
  /// In en, this message translates to:
  /// **'Character Info'**
  String get characterInfo;

  /// Character ID label
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String characterId(String id);

  /// Created date label
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String created(String date);

  /// Modified date label
  ///
  /// In en, this message translates to:
  /// **'Modified: {date}'**
  String modified(String date);

  /// Character saved message
  ///
  /// In en, this message translates to:
  /// **'Character saved successfully'**
  String get characterSavedSuccessfully;

  /// Failed to save character error
  ///
  /// In en, this message translates to:
  /// **'Failed to save character: {error}'**
  String failedToSaveCharacter(String error);

  /// Add alternate greeting tooltip
  ///
  /// In en, this message translates to:
  /// **'Add alternate greeting'**
  String get addAlternateGreeting;

  /// Group info section title
  ///
  /// In en, this message translates to:
  /// **'Group Info'**
  String get groupInfo;

  /// Response mode section title
  ///
  /// In en, this message translates to:
  /// **'Response Mode'**
  String get responseMode;

  /// Response mode description
  ///
  /// In en, this message translates to:
  /// **'How characters take turns responding'**
  String get howCharactersTakeTurns;

  /// Sequential response mode
  ///
  /// In en, this message translates to:
  /// **'Sequential'**
  String get sequential;

  /// Sequential mode description
  ///
  /// In en, this message translates to:
  /// **'Characters respond in order'**
  String get charactersRespondInOrder;

  /// Random response mode
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// Random mode description
  ///
  /// In en, this message translates to:
  /// **'Random character responds each turn'**
  String get randomCharacterResponds;

  /// All at once response mode
  ///
  /// In en, this message translates to:
  /// **'All at Once'**
  String get allAtOnce;

  /// All at once mode description
  ///
  /// In en, this message translates to:
  /// **'All non-muted characters respond'**
  String get allNonMutedCharactersRespond;

  /// Manual response mode
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// Manual mode description
  ///
  /// In en, this message translates to:
  /// **'You select which character responds'**
  String get youSelectWhoResponds;

  /// Natural response mode
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get natural;

  /// Natural mode description
  ///
  /// In en, this message translates to:
  /// **'AI decides based on context and trigger words'**
  String get aiDecidesBasedOnContext;

  /// Members count label
  ///
  /// In en, this message translates to:
  /// **'Members ({count})'**
  String membersCount(int count);

  /// No members message
  ///
  /// In en, this message translates to:
  /// **'No members yet. Add characters to this group.'**
  String get noMembersYet;

  /// Talkativeness label
  ///
  /// In en, this message translates to:
  /// **'Talkativeness: {percent}%'**
  String talkativenessPercent(int percent);

  /// Triggers label
  ///
  /// In en, this message translates to:
  /// **'Triggers: {words}'**
  String triggers(String words);

  /// Mute tooltip
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// Unmute tooltip
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute;

  /// Member settings dialog title
  ///
  /// In en, this message translates to:
  /// **'Member Settings'**
  String get memberSettings;

  /// Talkativeness slider label
  ///
  /// In en, this message translates to:
  /// **'Talkativeness: {percent}%'**
  String talkativenessLabel(int percent);

  /// Talkativeness help text
  ///
  /// In en, this message translates to:
  /// **'Higher values make the character more likely to respond.'**
  String get higherValuesMoreLikely;

  /// Trigger words label
  ///
  /// In en, this message translates to:
  /// **'Trigger Words'**
  String get triggerWords;

  /// Trigger words hint
  ///
  /// In en, this message translates to:
  /// **'word1, word2, word3'**
  String get triggerWordsHint;

  /// Trigger words help text
  ///
  /// In en, this message translates to:
  /// **'Character will respond when these words appear in messages.'**
  String get characterWillRespondWhenTriggered;

  /// Add member dialog title
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMemberToGroup;

  /// No more characters message
  ///
  /// In en, this message translates to:
  /// **'No more characters available to add'**
  String get noMoreCharactersAvailable;

  /// Group saved message
  ///
  /// In en, this message translates to:
  /// **'Group saved'**
  String get groupSaved;

  /// Delete group confirmation short
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteGroupAndChats(String name);

  /// Start chat tooltip
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChatAction;

  /// No tags empty state
  ///
  /// In en, this message translates to:
  /// **'No tags yet'**
  String get noTagsYet;

  /// Create tags description
  ///
  /// In en, this message translates to:
  /// **'Create tags to organize your characters'**
  String get createTagsToOrganize;

  /// Character count label
  ///
  /// In en, this message translates to:
  /// **'{count} character{plural}'**
  String characterCount(int count, String plural);

  /// Delete tag confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the tag \"{name}\"?\\n\\nThis will remove the tag from all characters.'**
  String deleteTagConfirmation(String name);

  /// Tag name hint
  ///
  /// In en, this message translates to:
  /// **'Enter tag name'**
  String get enterTagName;

  /// Icon emoji label
  ///
  /// In en, this message translates to:
  /// **'Icon (emoji)'**
  String get iconEmoji;

  /// Icon emoji hint
  ///
  /// In en, this message translates to:
  /// **'Enter an emoji (optional)'**
  String get enterEmojiOptional;

  /// Please enter tag name validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a tag name'**
  String get pleaseEnterTagName;

  /// Lorebook screen title
  ///
  /// In en, this message translates to:
  /// **'Lorebooks'**
  String get worldInfoLorebooks;

  /// Create lorebook tooltip
  ///
  /// In en, this message translates to:
  /// **'Create Lorebook'**
  String get createLorebook;

  /// No lorebooks empty state
  ///
  /// In en, this message translates to:
  /// **'No Lorebooks yet'**
  String get noLorebooksYet;

  /// Lorebooks description
  ///
  /// In en, this message translates to:
  /// **'Lorebooks inject context into your chats when keywords are detected.'**
  String get lorebooksInjectContext;

  /// Entries count label
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String entriesCount(int count);

  /// Delete lorebook confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\" and all its entries?'**
  String deleteLorebookConfirmation(String name);

  /// Lorebook name hint
  ///
  /// In en, this message translates to:
  /// **'Enter lorebook name'**
  String get enterLorebookName;

  /// Optional description hint
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get optionalDescriptionHint;

  /// Global scope label
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get globalScope;

  /// Global toggle description
  ///
  /// In en, this message translates to:
  /// **'Apply to all chats'**
  String get applyToAllChats;

  /// Please enter name validation alternate
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName2;

  /// No entries empty state
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntriesYet;

  /// Add entries description
  ///
  /// In en, this message translates to:
  /// **'Add entries with keywords to inject context into chats'**
  String get addEntriesWithKeywords;

  /// Delete entry confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this entry?\\n\\nKeys: {keys}'**
  String deleteEntryConfirmation(String keys);

  /// Constant badge
  ///
  /// In en, this message translates to:
  /// **'Constant'**
  String get constant;

  /// Selective badge
  ///
  /// In en, this message translates to:
  /// **'Selective'**
  String get selective;

  /// Keywords label
  ///
  /// In en, this message translates to:
  /// **'Keywords (comma-separated)'**
  String get keywordsCommaSeparated;

  /// Keywords hint
  ///
  /// In en, this message translates to:
  /// **'dragon, wyrm, serpent'**
  String get keywordsHint;

  /// Keywords helper text
  ///
  /// In en, this message translates to:
  /// **'Entry activates when any keyword is found in chat'**
  String get entryActivatesWhenKeywordFound;

  /// Secondary keys label
  ///
  /// In en, this message translates to:
  /// **'Secondary Keys (optional)'**
  String get secondaryKeysOptional;

  /// Secondary keys hint
  ///
  /// In en, this message translates to:
  /// **'fire, flame'**
  String get secondaryKeysHint;

  /// Secondary keys helper text
  ///
  /// In en, this message translates to:
  /// **'If set, both primary AND secondary must match (selective mode)'**
  String get bothPrimaryAndSecondaryMustMatch;

  /// Comment label
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get commentOptional;

  /// Comment hint
  ///
  /// In en, this message translates to:
  /// **'Note for this entry'**
  String get noteForThisEntry;

  /// Content field label
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentLabel;

  /// Content hint
  ///
  /// In en, this message translates to:
  /// **'The context to inject when keywords match...'**
  String get contextToInjectWhenMatches;

  /// Keywords validation
  ///
  /// In en, this message translates to:
  /// **'Please enter at least one keyword'**
  String get pleaseEnterAtLeastOneKeyword;

  /// Content validation
  ///
  /// In en, this message translates to:
  /// **'Please enter content'**
  String get pleaseEnterContent;

  /// Anthropic provider name
  ///
  /// In en, this message translates to:
  /// **'Anthropic'**
  String get anthropic;

  /// Cohere provider name
  ///
  /// In en, this message translates to:
  /// **'Cohere'**
  String get cohere;

  /// Custom provider name
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customProvider;

  /// API endpoint hint
  ///
  /// In en, this message translates to:
  /// **'https://api.example.com/v1'**
  String get apiEndpointHint;

  /// API key hint for OpenAI-compatible providers
  ///
  /// In en, this message translates to:
  /// **'sk-...'**
  String get apiKeyHint;

  /// API key hint for the xAI/Grok provider
  ///
  /// In en, this message translates to:
  /// **'xai-...'**
  String get xaiApiKeyHint;

  /// Temperature value display
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String temperatureValue(String value);

  /// Max tokens value display
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String maxTokensValue(String value);

  /// Top P value display
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String topPValue(String value);

  /// Frequency penalty value display
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String frequencyPenaltyValue(String value);

  /// Presence penalty value display
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String presencePenaltyValue(String value);

  /// Stream response label
  ///
  /// In en, this message translates to:
  /// **'Stream Response'**
  String get streamResponse;

  /// Stream response description
  ///
  /// In en, this message translates to:
  /// **'Stream tokens as they are generated'**
  String get streamTokensAsGenerated;

  /// Use system prompt label
  ///
  /// In en, this message translates to:
  /// **'Use System Prompt'**
  String get useSystemPrompt;

  /// Use system prompt description
  ///
  /// In en, this message translates to:
  /// **'Include system instructions'**
  String get includeSystemInstructions;

  /// Configuration saved message
  ///
  /// In en, this message translates to:
  /// **'Configuration saved successfully'**
  String get configurationSavedSuccessfully;

  /// Error saving configuration message
  ///
  /// In en, this message translates to:
  /// **'Error saving configuration'**
  String get errorSavingConfiguration;

  /// Copy all action
  ///
  /// In en, this message translates to:
  /// **'Copy All'**
  String get copyAll;

  /// Show favorites only tooltip
  ///
  /// In en, this message translates to:
  /// **'Show favorites only'**
  String get showFavoritesOnly;

  /// Sort by tooltip
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// Filter by tags tooltip
  ///
  /// In en, this message translates to:
  /// **'Filter by tags'**
  String get filterByTags;

  /// Favorites filter label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Manage button
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No tags created message
  ///
  /// In en, this message translates to:
  /// **'No tags created yet'**
  String get noTagsCreatedYet;

  /// Create tags button
  ///
  /// In en, this message translates to:
  /// **'Create Tags'**
  String get createTags;

  /// Characters count with plural
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 character} other{{count} characters}}'**
  String charactersCount(int count);

  /// Legacy character tags section
  ///
  /// In en, this message translates to:
  /// **'Character Tags (Legacy)'**
  String get characterTagsLegacy;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Apply filters with count
  ///
  /// In en, this message translates to:
  /// **'Apply ({count} selected)'**
  String applyFiltersSelected(int count);

  /// Enter preset name hint
  ///
  /// In en, this message translates to:
  /// **'Enter preset name'**
  String get enterPresetName;

  /// Delete script title
  ///
  /// In en, this message translates to:
  /// **'Delete Script'**
  String get deleteScript;

  /// AI config navigation label
  ///
  /// In en, this message translates to:
  /// **'AI Config'**
  String get aiConfig;

  /// Author's note description
  ///
  /// In en, this message translates to:
  /// **'Add context or instructions that will be injected into the conversation at a specific depth.'**
  String get authorsNoteDescription;

  /// Enable author's note toggle
  ///
  /// In en, this message translates to:
  /// **'Enable Author\'s Note'**
  String get enableAuthorsNote;

  /// Inject note description
  ///
  /// In en, this message translates to:
  /// **'Inject note into conversation context'**
  String get injectNoteIntoContext;

  /// Injection depth label
  ///
  /// In en, this message translates to:
  /// **'Injection Depth'**
  String get injectionDepth;

  /// Injection depth description
  ///
  /// In en, this message translates to:
  /// **'Messages from the end where note is inserted'**
  String get messagesFromEndWhereInserted;

  /// Note content label
  ///
  /// In en, this message translates to:
  /// **'Note Content'**
  String get noteContent;

  /// Author's note hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your author\'s note here...\\n\\nExamples:\\n• [Style: Write in a poetic, descriptive manner]\\n• [Focus on emotional depth and character development]\\n• [The character is feeling melancholic today]'**
  String get authorsNoteHint;

  /// Bookmark name hint
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this checkpoint'**
  String get enterNameForCheckpoint;

  /// Add description hint
  ///
  /// In en, this message translates to:
  /// **'Add a description'**
  String get addDescription;

  /// Create checkpoint confirmation
  ///
  /// In en, this message translates to:
  /// **'This will create a checkpoint at message {index}.'**
  String createCheckpointAtMessage(int index);

  /// Long press to bookmark hint
  ///
  /// In en, this message translates to:
  /// **'Long-press a message to create a bookmark'**
  String get longPressMessageToBookmark;

  /// Context management section header
  ///
  /// In en, this message translates to:
  /// **'Context Management'**
  String get contextManagement;

  /// Auto-summarize toggle label
  ///
  /// In en, this message translates to:
  /// **'Auto-Summarize'**
  String get autoSummarize;

  /// Auto-summarize toggle description
  ///
  /// In en, this message translates to:
  /// **'Automatically summarize and compress chat history when context usage is high'**
  String get autoSummarizeDescription;

  /// Auto-summarize threshold label
  ///
  /// In en, this message translates to:
  /// **'Auto-Summarize Threshold'**
  String get autoSummarizeThreshold;

  /// Auto-summarize threshold description
  ///
  /// In en, this message translates to:
  /// **'Trigger summarization when context reaches this percentage of maximum'**
  String get autoSummarizeThresholdDescription;

  /// Branch from bookmark title
  ///
  /// In en, this message translates to:
  /// **'Branch from Bookmark'**
  String get branchFromBookmark;

  /// Branch from bookmark warning
  ///
  /// In en, this message translates to:
  /// **'This will delete all messages after \"{name}\" and continue from that point. You can create a new bookmark before doing this to save the current state.'**
  String branchFromBookmarkWarning(String name);

  /// Branch button
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// Branched from message
  ///
  /// In en, this message translates to:
  /// **'Branched from \"{name}\"'**
  String branchedFrom(String name);

  /// Delete bookmark confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteBookmarkConfirmation(String name);

  /// Message index and date label
  ///
  /// In en, this message translates to:
  /// **'Message {index} • {date}'**
  String messageIndexAndDate(int index, String date);

  /// Branch from here tooltip
  ///
  /// In en, this message translates to:
  /// **'Branch from here'**
  String get branchFromHere;

  /// Preview bookmark title
  ///
  /// In en, this message translates to:
  /// **'Preview: {name}'**
  String previewBookmark(String name);

  /// Message not found message
  ///
  /// In en, this message translates to:
  /// **'Message not found in current chat'**
  String get messageNotFoundInChat;

  /// You label for user messages
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Assistant label
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistant;

  /// Reasoning copied message
  ///
  /// In en, this message translates to:
  /// **'Reasoning copied to clipboard'**
  String get reasoningCopiedToClipboard;

  /// Characters count for reasoning
  ///
  /// In en, this message translates to:
  /// **'{count} chars'**
  String charsCount(int count);

  /// Copy reasoning tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy reasoning'**
  String get copyReasoning;

  /// Commands label
  ///
  /// In en, this message translates to:
  /// **'Commands'**
  String get commands;

  /// Aliases label with list
  ///
  /// In en, this message translates to:
  /// **'Aliases: {aliases}'**
  String aliasesLabel(String aliases);

  /// No sprites message
  ///
  /// In en, this message translates to:
  /// **'No sprites added yet'**
  String get noSpritesAddedYet;

  /// Error loading sprites message
  ///
  /// In en, this message translates to:
  /// **'Error loading sprites'**
  String get errorLoadingSprites;

  /// Insertion position label for world info entry
  ///
  /// In en, this message translates to:
  /// **'Insertion Position'**
  String get insertionPosition;

  /// World info position: before character definition
  ///
  /// In en, this message translates to:
  /// **'Before Character Definition'**
  String get beforeCharacterDefinition;

  /// World info position: after character definition
  ///
  /// In en, this message translates to:
  /// **'After Character Definition'**
  String get afterCharacterDefinition;

  /// World info position: before example messages
  ///
  /// In en, this message translates to:
  /// **'Before Example Messages'**
  String get beforeExampleMessages;

  /// World info position: after example messages
  ///
  /// In en, this message translates to:
  /// **'After Example Messages'**
  String get afterExampleMessages;

  /// World info position: before author's note
  ///
  /// In en, this message translates to:
  /// **'Before Author\'s Note'**
  String get beforeAuthorNote;

  /// World info position: after author's note
  ///
  /// In en, this message translates to:
  /// **'After Author\'s Note'**
  String get afterAuthorNote;

  /// World info position: at specific depth
  ///
  /// In en, this message translates to:
  /// **'At Depth'**
  String get atDepth;

  /// World info position: before system prompt
  ///
  /// In en, this message translates to:
  /// **'Before System Prompt'**
  String get beforeSystemPrompt;

  /// World info position: after system prompt
  ///
  /// In en, this message translates to:
  /// **'After System Prompt'**
  String get afterSystemPrompt;

  /// Insertion order label for world info entry
  ///
  /// In en, this message translates to:
  /// **'Insertion Order'**
  String get insertionOrder;

  /// Helper text for insertion order
  ///
  /// In en, this message translates to:
  /// **'Lower order values are inserted first'**
  String get lowerOrderInsertsFirst;

  /// Helper text for constant toggle
  ///
  /// In en, this message translates to:
  /// **'Always include in prompt (ignore keywords)'**
  String get alwaysIncludeInPrompt;

  /// Helper text for selective toggle
  ///
  /// In en, this message translates to:
  /// **'Requires both primary AND secondary key to match'**
  String get requiresSecondaryKey;

  /// Debug log setting title
  ///
  /// In en, this message translates to:
  /// **'Debug Log'**
  String get debugLog;

  /// Debug log setting description
  ///
  /// In en, this message translates to:
  /// **'Show floating debug button to view logs'**
  String get debugLogDescription;

  /// Auto scroll toggle tooltip
  ///
  /// In en, this message translates to:
  /// **'Auto Scroll'**
  String get autoScroll;

  /// Clear logs button tooltip
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// Search logs placeholder
  ///
  /// In en, this message translates to:
  /// **'Search logs...'**
  String get searchLogs;

  /// Empty state when no logs
  ///
  /// In en, this message translates to:
  /// **'No logs yet'**
  String get noLogsYet;

  /// World info scope: available to all characters
  ///
  /// In en, this message translates to:
  /// **'All Characters'**
  String get allCharactersAvailable;

  /// Description for all characters scope
  ///
  /// In en, this message translates to:
  /// **'Available to all characters (contextual matching)'**
  String get availableToAllCharactersNotGlobal;

  /// World info scope: bound to specific character
  ///
  /// In en, this message translates to:
  /// **'Specific Character'**
  String get specificCharacter;

  /// Description for specific character scope
  ///
  /// In en, this message translates to:
  /// **'Link to a specific character only'**
  String get linkToSpecificCharacter;

  /// Character selection dropdown label
  ///
  /// In en, this message translates to:
  /// **'Select character'**
  String get selectCharacter;

  /// Character selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a character'**
  String get pleaseSelectCharacter;

  /// Context usage dialog title
  ///
  /// In en, this message translates to:
  /// **'Context Usage'**
  String get contextUsage;

  /// Max context label
  ///
  /// In en, this message translates to:
  /// **'Max Context'**
  String get maxContext;

  /// Remaining tokens label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Token breakdown section title
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdown;

  /// Cloud backup screen title
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// Cloud backup info section title
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackupInfo;

  /// Cloud backup description
  ///
  /// In en, this message translates to:
  /// **'Sync your data across devices'**
  String get cloudBackupDescription;

  /// Cloud backup subtitle
  ///
  /// In en, this message translates to:
  /// **'Backup to iCloud or Google Drive and restore on any device'**
  String get cloudBackupSubtitle;

  /// No description provided for @backupContents.
  ///
  /// In en, this message translates to:
  /// **'Backup contents'**
  String get backupContents;

  /// No description provided for @allTextData.
  ///
  /// In en, this message translates to:
  /// **'All text data'**
  String get allTextData;

  /// No description provided for @allTextDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Characters, chats, messages, world books, groups, personas, memories, Data Bank, RPG data, stories, moments, and app state'**
  String get allTextDataDescription;

  /// No description provided for @characterCardImages.
  ///
  /// In en, this message translates to:
  /// **'All character card images'**
  String get characterCardImages;

  /// No description provided for @characterCardImagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Character, persona, and group avatars plus character sprites'**
  String get characterCardImagesDescription;

  /// No description provided for @worldBookImages.
  ///
  /// In en, this message translates to:
  /// **'All world book images'**
  String get worldBookImages;

  /// No description provided for @worldBookImagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Local images referenced by world books'**
  String get worldBookImagesDescription;

  /// No description provided for @conversationImages.
  ///
  /// In en, this message translates to:
  /// **'All chat and moment images'**
  String get conversationImages;

  /// No description provided for @conversationImagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Chat attachments, generated chat images, and moment images'**
  String get conversationImagesDescription;

  /// No description provided for @backgroundImages.
  ///
  /// In en, this message translates to:
  /// **'All background images'**
  String get backgroundImages;

  /// No description provided for @backgroundImagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Imported global and chat backgrounds'**
  String get backgroundImagesDescription;

  /// No description provided for @live2DBackup.
  ///
  /// In en, this message translates to:
  /// **'All Live2D models'**
  String get live2DBackup;

  /// No description provided for @live2DModelsBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional large files; may significantly increase backup size'**
  String get live2DModelsBackupDescription;

  /// No description provided for @independentMediaBackup.
  ///
  /// In en, this message translates to:
  /// **'Independent media backup'**
  String get independentMediaBackup;

  /// No description provided for @independentMediaBackupDescription.
  ///
  /// In en, this message translates to:
  /// **'Images are stored separately. Data backup and restore still work when media fails or is unavailable.'**
  String get independentMediaBackupDescription;

  /// No description provided for @mediaBackupPartialSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database data completed successfully, but some media or settings could not be backed up or restored.'**
  String get mediaBackupPartialSuccess;

  /// Media file restore count shown after a backup restore
  ///
  /// In en, this message translates to:
  /// **'Media restored: {count} files'**
  String mediaRestoreComplete(int count);

  /// Shown when a restored backup has no media sidecar
  ///
  /// In en, this message translates to:
  /// **'This backup does not include a media package; only data was restored.'**
  String get mediaNotIncludedInBackup;

  /// No description provided for @backupStagePreparingData.
  ///
  /// In en, this message translates to:
  /// **'Preparing database and settings...'**
  String get backupStagePreparingData;

  /// No description provided for @backupStageScanningMedia.
  ///
  /// In en, this message translates to:
  /// **'Scanning media files...'**
  String get backupStageScanningMedia;

  /// No description provided for @backupStageCompressingMedia.
  ///
  /// In en, this message translates to:
  /// **'Compressing media: {processed}/{total} files'**
  String backupStageCompressingMedia(int processed, int total);

  /// No description provided for @backupStageUploadingData.
  ///
  /// In en, this message translates to:
  /// **'Uploading data backup...'**
  String get backupStageUploadingData;

  /// No description provided for @backupStageUploadingMedia.
  ///
  /// In en, this message translates to:
  /// **'Uploading media package...'**
  String get backupStageUploadingMedia;

  /// No description provided for @backupStageDownloadingData.
  ///
  /// In en, this message translates to:
  /// **'Downloading data backup...'**
  String get backupStageDownloadingData;

  /// No description provided for @backupStageDownloadingMedia.
  ///
  /// In en, this message translates to:
  /// **'Downloading media package...'**
  String get backupStageDownloadingMedia;

  /// No description provided for @backupStageVerifyingMedia.
  ///
  /// In en, this message translates to:
  /// **'Verifying media package...'**
  String get backupStageVerifyingMedia;

  /// No description provided for @backupStageRestoringMedia.
  ///
  /// In en, this message translates to:
  /// **'Restoring media: {processed}/{total} files'**
  String backupStageRestoringMedia(int processed, int total);

  /// No description provided for @backupStageRestoringData.
  ///
  /// In en, this message translates to:
  /// **'Merging or replacing database...'**
  String get backupStageRestoringData;

  /// Enable iCloud backup toggle
  ///
  /// In en, this message translates to:
  /// **'Enable iCloud Backup'**
  String get enableICloudBackup;

  /// Enable iCloud backup description
  ///
  /// In en, this message translates to:
  /// **'Save backups to iCloud Drive so they appear on your other Apple devices'**
  String get enableICloudBackupDescription;

  /// Toggle for automatic iCloud/Google Drive sync
  ///
  /// In en, this message translates to:
  /// **'Automatic cross-device sync'**
  String get enableCrossDeviceSync;

  /// Description of automatic cross-device backup sync
  ///
  /// In en, this message translates to:
  /// **'Keep this device updated with iCloud on Apple devices and Google Drive on Android and other signed-in devices. Changes upload when the app is backgrounded and download on the next launch or resume.'**
  String get enableCrossDeviceSyncDescription;

  /// Enable Google Drive backup toggle, the Android counterpart to iCloud backup
  ///
  /// In en, this message translates to:
  /// **'Enable Google Drive Backup'**
  String get enableGoogleDriveBackup;

  /// Enable Google Drive backup description
  ///
  /// In en, this message translates to:
  /// **'Save backups to Google Drive so they appear on your other Android and signed-in devices'**
  String get enableGoogleDriveBackupDescription;

  /// Button that runs an immediate cloud sync
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// Shown after a successful automatic cloud sync
  ///
  /// In en, this message translates to:
  /// **'Devices are in sync'**
  String get crossDeviceSyncComplete;

  /// Shown while a backup file opened from the Files app is being prepared
  ///
  /// In en, this message translates to:
  /// **'Opening backup…'**
  String get openingBackupFile;

  /// iCloud not available message
  ///
  /// In en, this message translates to:
  /// **'iCloud Not Available'**
  String get iCloudNotAvailable;

  /// iCloud not available description
  ///
  /// In en, this message translates to:
  /// **'Please sign in to iCloud in Settings'**
  String get iCloudNotAvailableDescription;

  /// Backup to iCloud button
  ///
  /// In en, this message translates to:
  /// **'Backup to iCloud'**
  String get backupToICloud;

  /// Last sync time
  ///
  /// In en, this message translates to:
  /// **'Last sync: {time}'**
  String lastSync(String time);

  /// Never synced message
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get neverSynced;

  /// iCloud backups section title
  ///
  /// In en, this message translates to:
  /// **'iCloud Backups'**
  String get iCloudBackups;

  /// No cloud backups message
  ///
  /// In en, this message translates to:
  /// **'No cloud backups'**
  String get noCloudBackups;

  /// Google Drive export button
  ///
  /// In en, this message translates to:
  /// **'Export to Google Drive'**
  String get googleDriveExport;

  /// Google Drive export description
  ///
  /// In en, this message translates to:
  /// **'Save backup file to Google Drive or other location'**
  String get googleDriveExportDescription;

  /// Google Drive import button
  ///
  /// In en, this message translates to:
  /// **'Import from Google Drive'**
  String get googleDriveImport;

  /// Google Drive import description
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup file in Google Drive or other location'**
  String get googleDriveImportDescription;

  /// Import button
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import_action;

  /// Import backup dialog title
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get importBackup;

  /// Backup exported message
  ///
  /// In en, this message translates to:
  /// **'Backup exported successfully'**
  String get backupExported;

  /// Restore settings section title
  ///
  /// In en, this message translates to:
  /// **'Restore Settings'**
  String get restoreSettings;

  /// Default restore mode label
  ///
  /// In en, this message translates to:
  /// **'Default Restore Mode'**
  String get defaultRestoreMode;

  /// Select restore mode prompt
  ///
  /// In en, this message translates to:
  /// **'Select how to restore data:'**
  String get selectRestoreMode;

  /// Restore warning message
  ///
  /// In en, this message translates to:
  /// **'Restoring data may overwrite existing data depending on the selected mode. Make sure to backup your current data first.'**
  String get restoreWarning;

  /// Restore button
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// Restore complete message
  ///
  /// In en, this message translates to:
  /// **'Restore complete: {added} added, {updated} updated, {skipped} skipped'**
  String restoreComplete(int added, int updated, int skipped);

  /// Select file and import button
  ///
  /// In en, this message translates to:
  /// **'Select File & Import'**
  String get selectFileAndImport;

  /// About restore modes label
  ///
  /// In en, this message translates to:
  /// **'About Restore Modes'**
  String get aboutRestoreModes;

  /// About restore modes description
  ///
  /// In en, this message translates to:
  /// **'Replace: Overwrites all local data with backup data.\nMerge: Keeps both, newer data wins for conflicts.\nAdd New Only: Only adds new items, keeps all existing data.'**
  String get aboutRestoreModesDescription;

  /// Sign in to Google Drive title
  ///
  /// In en, this message translates to:
  /// **'Sign in to Google Drive'**
  String get signInToGoogleDrive;

  /// Sign in to Google Drive description
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account to backup and restore data'**
  String get signInToGoogleDriveDescription;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Signed in successfully message
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get signedInSuccessfully;

  /// Backup to Google Drive button
  ///
  /// In en, this message translates to:
  /// **'Backup to Google Drive'**
  String get backupToGoogleDrive;

  /// Google Drive backups section title
  ///
  /// In en, this message translates to:
  /// **'Google Drive Backups'**
  String get googleDriveBackups;

  /// Label for message bubble opacity slider
  ///
  /// In en, this message translates to:
  /// **'Message Opacity'**
  String get bubbleOpacity;

  /// Helper text for message bubble opacity slider
  ///
  /// In en, this message translates to:
  /// **'Controls the transparency of message bubbles when a background is active.'**
  String get bubbleOpacityHelp;

  /// UI label: Swipes
  ///
  /// In en, this message translates to:
  /// **'Swipes'**
  String get swipes;

  /// UI label: Delete swipe?
  ///
  /// In en, this message translates to:
  /// **'Delete swipe?'**
  String get deleteSwipeQuestion;

  /// UI label: chars
  ///
  /// In en, this message translates to:
  /// **'chars'**
  String get charsSuffix;

  /// UI label: Swipe deleted
  ///
  /// In en, this message translates to:
  /// **'Swipe deleted'**
  String get swipeDeleted;

  /// UI label: No alternate swipes to delete
  ///
  /// In en, this message translates to:
  /// **'No alternate swipes to delete'**
  String get noAlternateSwipes;

  /// UI label: Reasoning Effort
  ///
  /// In en, this message translates to:
  /// **'Reasoning Effort'**
  String get reasoningEffort;

  /// UI label: Auto
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get effortAuto;

  /// UI label: Minimum
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get effortMin;

  /// UI label: Low
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get effortLow;

  /// UI label: Medium
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get effortMedium;

  /// UI label: High
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get effortHigh;

  /// UI label: Maximum
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get effortMax;

  /// UI label: Prompt Caching
  ///
  /// In en, this message translates to:
  /// **'Prompt Caching'**
  String get promptCaching;

  /// UI label: Cache system prompt & history to reduce cost
  ///
  /// In en, this message translates to:
  /// **'Cache system prompt & history to reduce cost'**
  String get promptCachingDescription;

  /// UI label: Merge Consecutive Roles
  ///
  /// In en, this message translates to:
  /// **'Merge Consecutive Roles'**
  String get mergeConsecutiveRoles;

  /// UI label: For APIs requiring strict user/assistant alternation
  ///
  /// In en, this message translates to:
  /// **'For APIs requiring strict user/assistant alternation'**
  String get mergeConsecutiveRolesDescription;

  /// UI label: Connection Profiles
  ///
  /// In en, this message translates to:
  /// **'Connection Profiles'**
  String get connectionProfiles;

  /// UI label: Save current connection for quick switching
  ///
  /// In en, this message translates to:
  /// **'Save current connection for quick switching'**
  String get connectionProfilesHint;

  /// UI label: {count} saved
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String profilesSavedCount(String count);

  /// UI label: Save current
  ///
  /// In en, this message translates to:
  /// **'Save current'**
  String get saveCurrent;

  /// UI label: No profiles yet. Save the current connection to switch quickly later.
  ///
  /// In en, this message translates to:
  /// **'No profiles yet. Save the current connection to switch quickly later.'**
  String get noProfilesHint;

  /// UI label: Applied profile: {name}
  ///
  /// In en, this message translates to:
  /// **'Applied profile: {name}'**
  String appliedProfile(String name);

  /// UI label: Save Connection Profile
  ///
  /// In en, this message translates to:
  /// **'Save Connection Profile'**
  String get saveConnectionProfile;

  /// UI label: Profile name
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get profileName;

  /// UI label: Gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// UI label: All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLabel;

  /// UI label: Ungrouped
  ///
  /// In en, this message translates to:
  /// **'Ungrouped'**
  String get ungrouped;

  /// UI label: Set as background
  ///
  /// In en, this message translates to:
  /// **'Set as background'**
  String get setAsBackground;

  /// UI label: Move to folder
  ///
  /// In en, this message translates to:
  /// **'Move to folder'**
  String get moveToFolder;

  /// UI label: Folder name
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderName;

  /// UI label: Leave empty for ungrouped
  ///
  /// In en, this message translates to:
  /// **'Leave empty for ungrouped'**
  String get folderNameHint;

  /// UI label: Move
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// UI label: Move failed: {error}
  ///
  /// In en, this message translates to:
  /// **'Move failed: {error}'**
  String moveFailed(String error);

  /// UI label: Delete failed: {error}
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String deleteFailed(String error);

  /// UI label: Embed pending documents
  ///
  /// In en, this message translates to:
  /// **'Embed pending documents'**
  String get embedPendingDocuments;

  /// UI label: Embedded {count} documents
  ///
  /// In en, this message translates to:
  /// **'Embedded {count} documents'**
  String embeddedDocuments(String count);

  /// UI label: All documents already embedded
  ///
  /// In en, this message translates to:
  /// **'All documents already embedded'**
  String get allDocumentsEmbedded;

  /// UI label: Embedding failed: {error}
  ///
  /// In en, this message translates to:
  /// **'Embedding failed: {error}'**
  String embeddingFailed(String error);

  /// UI label: GPT-Image Settings
  ///
  /// In en, this message translates to:
  /// **'GPT-Image Settings'**
  String get gptImageSettings;

  /// UI label: Quality
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get qualityLabel;

  /// UI label: Auto - Let the model decide
  ///
  /// In en, this message translates to:
  /// **'Auto - Let the model decide'**
  String get qualityAutoDescription;

  /// UI label: High - Higher detail and consistency
  ///
  /// In en, this message translates to:
  /// **'High - Higher detail and consistency'**
  String get qualityHighDescription;

  /// UI label: Impersonate
  ///
  /// In en, this message translates to:
  /// **'Impersonate'**
  String get impersonate;

  /// UI label: Let the AI write your next reply
  ///
  /// In en, this message translates to:
  /// **'Let the AI write your next reply'**
  String get impersonateHint;

  /// UI label: Start Reply With
  ///
  /// In en, this message translates to:
  /// **'Start Reply With'**
  String get startReplyWith;

  /// UI label: The AI's reply will start with this text
  ///
  /// In en, this message translates to:
  /// **'The AI\'s reply will start with this text'**
  String get startReplyWithHint;

  /// UI label: Chat Lorebooks
  ///
  /// In en, this message translates to:
  /// **'Chat Lorebooks'**
  String get chatLorebooks;

  /// UI label: World info books active only in this chat
  ///
  /// In en, this message translates to:
  /// **'World info books active only in this chat'**
  String get chatLorebooksHint;

  /// No description provided for @messagesCleared.
  ///
  /// In en, this message translates to:
  /// **'All messages cleared'**
  String get messagesCleared;

  /// No description provided for @selectCharacterCardFiles.
  ///
  /// In en, this message translates to:
  /// **'Select character card files'**
  String get selectCharacterCardFiles;

  /// No description provided for @supportedCharacterCardFormats.
  ///
  /// In en, this message translates to:
  /// **'Batch import supported: PNG, CharX, and JSON'**
  String get supportedCharacterCardFormats;

  /// No description provided for @importFromUrl.
  ///
  /// In en, this message translates to:
  /// **'Import from URL'**
  String get importFromUrl;

  /// No description provided for @enterCharacterCardUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a character card URL...'**
  String get enterCharacterCardUrl;

  /// No description provided for @pasteAndImport.
  ///
  /// In en, this message translates to:
  /// **'Paste and import'**
  String get pasteAndImport;

  /// No description provided for @supportedCommunities.
  ///
  /// In en, this message translates to:
  /// **'Supported communities (tap to open):'**
  String get supportedCommunities;

  /// No description provided for @publicCardLinksSupported.
  ///
  /// In en, this message translates to:
  /// **'Public PNG and JSON links are also supported'**
  String get publicCardLinksSupported;

  /// No description provided for @communityLinks.
  ///
  /// In en, this message translates to:
  /// **'Community links'**
  String get communityLinks;

  /// No description provided for @importSummaryMixed.
  ///
  /// In en, this message translates to:
  /// **'Imported {success} character cards; {failed} failed'**
  String importSummaryMixed(Object failed, Object success);

  /// No description provided for @importSummarySuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} character cards'**
  String importSummarySuccess(Object count);

  /// No description provided for @importSummaryFailed.
  ///
  /// In en, this message translates to:
  /// **'All imports failed'**
  String get importSummaryFailed;

  /// No description provided for @processingProgress.
  ///
  /// In en, this message translates to:
  /// **'Processing: {processed} / {total}'**
  String processingProgress(Object processed, Object total);

  /// No description provided for @importSuccessLabel.
  ///
  /// In en, this message translates to:
  /// **'Succeeded'**
  String get importSuccessLabel;

  /// No description provided for @importFailureLabel.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get importFailureLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @importAllCharacters.
  ///
  /// In en, this message translates to:
  /// **'Import all ({count})'**
  String importAllCharacters(Object count);

  /// No description provided for @switchLayout.
  ///
  /// In en, this message translates to:
  /// **'Switch layout'**
  String get switchLayout;

  /// No description provided for @stopGenerating.
  ///
  /// In en, this message translates to:
  /// **'Stop generating'**
  String get stopGenerating;

  /// No description provided for @imageBackgroundSettings.
  ///
  /// In en, this message translates to:
  /// **'Image background settings'**
  String get imageBackgroundSettings;

  /// No description provided for @useCharacterImageAsBackground.
  ///
  /// In en, this message translates to:
  /// **'Use character image as background'**
  String get useCharacterImageAsBackground;

  /// No description provided for @useCharacterImageAsBackgroundHint.
  ///
  /// In en, this message translates to:
  /// **'Automatically use the character avatar when available'**
  String get useCharacterImageAsBackgroundHint;

  /// No description provided for @backgroundOpacity.
  ///
  /// In en, this message translates to:
  /// **'Background opacity'**
  String get backgroundOpacity;

  /// No description provided for @backgroundOpacityHint.
  ///
  /// In en, this message translates to:
  /// **'Applies to custom and character image backgrounds'**
  String get backgroundOpacityHint;

  /// No description provided for @enableBackgroundBlur.
  ///
  /// In en, this message translates to:
  /// **'Enable background blur'**
  String get enableBackgroundBlur;

  /// No description provided for @enableBackgroundBlurHint.
  ///
  /// In en, this message translates to:
  /// **'Applies blur to all image backgrounds'**
  String get enableBackgroundBlurHint;

  /// No description provided for @backgroundPriorityHint.
  ///
  /// In en, this message translates to:
  /// **'Priority: character background > global background > character image > default color'**
  String get backgroundPriorityHint;

  /// No description provided for @openRouterUpstreamProvider.
  ///
  /// In en, this message translates to:
  /// **'OpenRouter provider'**
  String get openRouterUpstreamProvider;

  /// No description provided for @automaticRouting.
  ///
  /// In en, this message translates to:
  /// **'Automatic routing'**
  String get automaticRouting;

  /// No description provided for @openRouterProviderHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the upstream provider used for this model'**
  String get openRouterProviderHint;

  /// No description provided for @useCurrentChatConnection.
  ///
  /// In en, this message translates to:
  /// **'Use current chat connection'**
  String get useCurrentChatConnection;

  /// No description provided for @chatConnectionAppliedToEmbeddings.
  ///
  /// In en, this message translates to:
  /// **'Chat endpoint and API key applied to embeddings'**
  String get chatConnectionAppliedToEmbeddings;

  /// No description provided for @localFeatures.
  ///
  /// In en, this message translates to:
  /// **'Local features'**
  String get localFeatures;

  /// Bottom tab and play hub title
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playHub;

  /// Play hub row for the story timeline
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get story;

  /// Settings switch subtitle for AI-generated story processing
  ///
  /// In en, this message translates to:
  /// **'When this is off, chats are not analyzed and story chapters are not generated.'**
  String get storyEnabledSubtitle;

  /// Title of the confirmation shown before enabling an AI-powered play feature
  ///
  /// In en, this message translates to:
  /// **'Enable {feature}?'**
  String playAiFeatureEnableTitle(String feature);

  /// Disclosure shown before enabling an AI-powered play feature
  ///
  /// In en, this message translates to:
  /// **'{feature} actively sends character information and relevant conversations to your configured AI provider to generate content. It is off by default. Enable it now?'**
  String playAiFeatureEnableDescription(String feature);

  /// Confirms enabling an AI-powered play feature
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get playAiFeatureEnableAction;

  /// Empty state on the story chapter timeline
  ///
  /// In en, this message translates to:
  /// **'A story appears after you chat for a while.'**
  String get storyEmptyHint;

  /// Empty-state button that leaves the story page for chat
  ///
  /// In en, this message translates to:
  /// **'Go to chat'**
  String get storyGoToChat;

  /// Story-page action to write a short note
  ///
  /// In en, this message translates to:
  /// **'Jot a note'**
  String get storyJotNote;

  /// Hint inside the story jot-a-note sheet
  ///
  /// In en, this message translates to:
  /// **'Write a short note. This is not a chapter editor.'**
  String get storyJotNoteHint;

  /// No description provided for @storyKeyEvents.
  ///
  /// In en, this message translates to:
  /// **'What happened'**
  String get storyKeyEvents;

  /// No description provided for @storyStateChanges.
  ///
  /// In en, this message translates to:
  /// **'What changed'**
  String get storyStateChanges;

  /// No description provided for @storyOpenThreads.
  ///
  /// In en, this message translates to:
  /// **'Still unresolved'**
  String get storyOpenThreads;

  /// No description provided for @storyNextSteps.
  ///
  /// In en, this message translates to:
  /// **'Where this could go'**
  String get storyNextSteps;

  /// No description provided for @storyContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get storyContinue;

  /// No description provided for @storyFork.
  ///
  /// In en, this message translates to:
  /// **'Fork from here'**
  String get storyFork;

  /// No description provided for @storyCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare outcomes'**
  String get storyCompare;

  /// No description provided for @storyViewSource.
  ///
  /// In en, this message translates to:
  /// **'View source'**
  String get storyViewSource;

  /// No description provided for @storyOriginalLine.
  ///
  /// In en, this message translates to:
  /// **'Original line'**
  String get storyOriginalLine;

  /// No description provided for @storyBranchName.
  ///
  /// In en, this message translates to:
  /// **'Branch name'**
  String get storyBranchName;

  /// No description provided for @storyBranchNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example: I stayed instead'**
  String get storyBranchNameHint;

  /// No description provided for @storyCreateBranch.
  ///
  /// In en, this message translates to:
  /// **'Create branch'**
  String get storyCreateBranch;

  /// No description provided for @storyDefaultDirection.
  ///
  /// In en, this message translates to:
  /// **'Continue from the unresolved moment in this chapter.'**
  String get storyDefaultDirection;

  /// No description provided for @storyContinueDraft.
  ///
  /// In en, this message translates to:
  /// **'Continue \"{title}\" from here: {direction}'**
  String storyContinueDraft(String title, String direction);

  /// No description provided for @storyForkCreated.
  ///
  /// In en, this message translates to:
  /// **'Branch \"{name}\" is ready.'**
  String storyForkCreated(String name);

  /// No description provided for @storyNoOutcome.
  ///
  /// In en, this message translates to:
  /// **'No new chapter has formed on this line yet.'**
  String get storyNoOutcome;

  /// No description provided for @storyChooseTwoLines.
  ///
  /// In en, this message translates to:
  /// **'Choose two lines to compare.'**
  String get storyChooseTwoLines;

  /// No description provided for @storyLeftLine.
  ///
  /// In en, this message translates to:
  /// **'First line'**
  String get storyLeftLine;

  /// No description provided for @storyRightLine.
  ///
  /// In en, this message translates to:
  /// **'Second line'**
  String get storyRightLine;

  /// No description provided for @storySearch.
  ///
  /// In en, this message translates to:
  /// **'Search stories'**
  String get storySearch;

  /// No description provided for @storyNoSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No matching chapters.'**
  String get storyNoSearchResults;

  /// No description provided for @storySelectLine.
  ///
  /// In en, this message translates to:
  /// **'Story line'**
  String get storySelectLine;

  /// No description provided for @storyNoteSaved.
  ///
  /// In en, this message translates to:
  /// **'The note was added to the story.'**
  String get storyNoteSaved;

  /// No description provided for @storyNoChats.
  ///
  /// In en, this message translates to:
  /// **'Start a chat before writing a story note.'**
  String get storyNoChats;

  /// No description provided for @storyConsequencesAfterFork.
  ///
  /// In en, this message translates to:
  /// **'After the fork'**
  String get storyConsequencesAfterFork;

  /// Play hub row for the public moments feed
  ///
  /// In en, this message translates to:
  /// **'Moments'**
  String get moments;

  /// Empty state when the user has turned moments off
  ///
  /// In en, this message translates to:
  /// **'Moments is off. Turn it back on in Settings.'**
  String get momentsDisabledEmpty;

  /// Settings switch subtitle for the moments world loop
  ///
  /// In en, this message translates to:
  /// **'When this is off, the feed stays still and characters do not post.'**
  String get momentsEnabledSubtitle;

  /// Chat-page toggle to inject visible moments into this conversation
  ///
  /// In en, this message translates to:
  /// **'Use Moments in this chat'**
  String get momentsInChat;

  /// Explains that moments knowledge stays out of chat unless enabled
  ///
  /// In en, this message translates to:
  /// **'Off by default. When on, this character can talk about friends\' and your moments.'**
  String get momentsInChatHint;

  /// Empty state when moments is on but there are no posts
  ///
  /// In en, this message translates to:
  /// **'Nobody has posted yet.'**
  String get momentsEmpty;

  /// Shown while characters decide whether to post
  ///
  /// In en, this message translates to:
  /// **'People are posting…'**
  String get momentsRefreshing;

  /// No description provided for @momentsCompose.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get momentsCompose;

  /// No description provided for @momentsComposeHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind…'**
  String get momentsComposeHint;

  /// No description provided for @momentsAuthor.
  ///
  /// In en, this message translates to:
  /// **'Who is posting'**
  String get momentsAuthor;

  /// No description provided for @momentsAuthorMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get momentsAuthorMe;

  /// No description provided for @momentsAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get momentsAddPhoto;

  /// No description provided for @momentsChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get momentsChangePhoto;

  /// No description provided for @momentsNeedSomething.
  ///
  /// In en, this message translates to:
  /// **'Write something or add a photo first.'**
  String get momentsNeedSomething;

  /// No description provided for @momentsComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get momentsComment;

  /// No description provided for @momentsSavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Save photo'**
  String get momentsSavePhoto;

  /// No description provided for @momentsPhotoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved'**
  String get momentsPhotoSaved;

  /// No description provided for @momentsPhotoSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to save photo'**
  String get momentsPhotoSaveFailed;

  /// No description provided for @momentsFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get momentsFriends;

  /// No description provided for @momentsNoFriends.
  ///
  /// In en, this message translates to:
  /// **'No friends yet. Characters who share a group chat can add each other.'**
  String get momentsNoFriends;

  /// No description provided for @momentsTalk.
  ///
  /// In en, this message translates to:
  /// **'Talk'**
  String get momentsTalk;

  /// No description provided for @momentsExpose.
  ///
  /// In en, this message translates to:
  /// **'Expose'**
  String get momentsExpose;

  /// No description provided for @momentsIgnore.
  ///
  /// In en, this message translates to:
  /// **'Leave it'**
  String get momentsIgnore;

  /// No description provided for @momentsWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a reply'**
  String get momentsWaiting;

  /// No description provided for @momentsWaitingBadge.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get momentsWaitingBadge;

  /// No description provided for @momentsIgnoredBadge.
  ///
  /// In en, this message translates to:
  /// **'Left unread'**
  String get momentsIgnoredBadge;

  /// No description provided for @momentsWriteToWorld.
  ///
  /// In en, this message translates to:
  /// **'Write this into the world'**
  String get momentsWriteToWorld;

  /// No description provided for @momentsFact.
  ///
  /// In en, this message translates to:
  /// **'What actually happened: {fact}'**
  String momentsFact(String fact);

  /// Placeholder body for unfinished play destinations
  ///
  /// In en, this message translates to:
  /// **'This play feature is not ready yet.'**
  String get playFeatureComingSoon;

  /// Settings jump to the existing data bank, not as a homepage
  ///
  /// In en, this message translates to:
  /// **'Open Data Bank'**
  String get openDataBank;

  /// No description provided for @openDataBankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Opens the library from Play'**
  String get openDataBankSubtitle;

  /// No description provided for @memoryInbox.
  ///
  /// In en, this message translates to:
  /// **'Memory inbox'**
  String get memoryInbox;

  /// No description provided for @memoryInboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review and maintain long-term memories'**
  String get memoryInboxSubtitle;

  /// No description provided for @dataBank.
  ///
  /// In en, this message translates to:
  /// **'Data Bank'**
  String get dataBank;

  /// No description provided for @dataBankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import, search, and bind local documents'**
  String get dataBankSubtitle;

  /// No description provided for @rpgScenarioEditor.
  ///
  /// In en, this message translates to:
  /// **'RPG scenario editor'**
  String get rpgScenarioEditor;

  /// No description provided for @rpgScenarioEditorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and validate local scenario packages'**
  String get rpgScenarioEditorSubtitle;

  /// No description provided for @capabilityCheck.
  ///
  /// In en, this message translates to:
  /// **'Capability check'**
  String get capabilityCheck;

  /// No description provided for @capabilityCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Availability, permissions, and configuration'**
  String get capabilityCheckSubtitle;

  /// No description provided for @mcpServers.
  ///
  /// In en, this message translates to:
  /// **'MCP servers'**
  String get mcpServers;

  /// No description provided for @mcpServersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connections, tools, permissions, and activity'**
  String get mcpServersSubtitle;

  /// No description provided for @toolCalling.
  ///
  /// In en, this message translates to:
  /// **'Tool calling'**
  String get toolCalling;

  /// No description provided for @toolCallingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Built-in tools, approvals, and limits'**
  String get toolCallingSubtitle;

  /// No description provided for @toolCallingAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow tool calling'**
  String get toolCallingAllow;

  /// No description provided for @toolCallingAllowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Providers may request only the tools enabled below'**
  String get toolCallingAllowSubtitle;

  /// No description provided for @toolBuiltInTools.
  ///
  /// In en, this message translates to:
  /// **'Built-in tools'**
  String get toolBuiltInTools;

  /// No description provided for @toolMcpTools.
  ///
  /// In en, this message translates to:
  /// **'MCP tools'**
  String get toolMcpTools;

  /// No description provided for @toolMcpPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connected MCP servers use their individual permissions'**
  String get toolMcpPermissionsSubtitle;

  /// No description provided for @toolSafetyLimits.
  ///
  /// In en, this message translates to:
  /// **'Safety limits'**
  String get toolSafetyLimits;

  /// No description provided for @toolRounds.
  ///
  /// In en, this message translates to:
  /// **'Tool rounds'**
  String get toolRounds;

  /// No description provided for @toolCallsPerResponse.
  ///
  /// In en, this message translates to:
  /// **'Calls per response'**
  String get toolCallsPerResponse;

  /// No description provided for @toolTimeLimit.
  ///
  /// In en, this message translates to:
  /// **'Time limit'**
  String get toolTimeLimit;

  /// No description provided for @toolTokenBudget.
  ///
  /// In en, this message translates to:
  /// **'Tool token budget'**
  String get toolTokenBudget;

  /// No description provided for @toolSeconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get toolSeconds;

  /// No description provided for @toolTokens.
  ///
  /// In en, this message translates to:
  /// **'tokens'**
  String get toolTokens;

  /// No description provided for @toolDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease {control}'**
  String toolDecrease(String control);

  /// No description provided for @toolIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase {control}'**
  String toolIncrease(String control);

  /// No description provided for @toolActivity.
  ///
  /// In en, this message translates to:
  /// **'Tool activity'**
  String get toolActivity;

  /// No description provided for @toolApprovalRequired.
  ///
  /// In en, this message translates to:
  /// **'Approval required'**
  String get toolApprovalRequired;

  /// No description provided for @toolAllowOnce.
  ///
  /// In en, this message translates to:
  /// **'Allow once'**
  String get toolAllowOnce;

  /// No description provided for @toolAlwaysAllow.
  ///
  /// In en, this message translates to:
  /// **'Always allow'**
  String get toolAlwaysAllow;

  /// No description provided for @toolDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get toolDeny;

  /// No description provided for @toolCancelCall.
  ///
  /// In en, this message translates to:
  /// **'Cancel tool call'**
  String get toolCancelCall;

  /// No description provided for @toolStatusWaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval'**
  String get toolStatusWaitingApproval;

  /// No description provided for @toolStatusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get toolStatusRunning;

  /// No description provided for @toolStatusSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Succeeded'**
  String get toolStatusSucceeded;

  /// No description provided for @toolStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get toolStatusFailed;

  /// No description provided for @toolStatusDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get toolStatusDenied;

  /// No description provided for @toolStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get toolStatusCancelled;

  /// No description provided for @storageManagement.
  ///
  /// In en, this message translates to:
  /// **'Storage management'**
  String get storageManagement;

  /// No description provided for @storageManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Usage, orphan scanning, and safe cleanup'**
  String get storageManagementSubtitle;

  /// No description provided for @storageUsedOfQuota.
  ///
  /// In en, this message translates to:
  /// **'{used} used of {quota}'**
  String storageUsedOfQuota(String used, String quota);

  /// No description provided for @storageQuotaWarning.
  ///
  /// In en, this message translates to:
  /// **'Storage usage is above the warning threshold'**
  String get storageQuotaWarning;

  /// No description provided for @storageWithinQuota.
  ///
  /// In en, this message translates to:
  /// **'Storage usage is within the warning threshold'**
  String get storageWithinQuota;

  /// No description provided for @storageScanIncomplete.
  ///
  /// In en, this message translates to:
  /// **'{count} path(s) could not be inspected'**
  String storageScanIncomplete(int count);

  /// No description provided for @storageCategoryLive2d.
  ///
  /// In en, this message translates to:
  /// **'Live2D models'**
  String get storageCategoryLive2d;

  /// No description provided for @storageCategoryAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments and media'**
  String get storageCategoryAttachments;

  /// No description provided for @storageCategoryDataBank.
  ///
  /// In en, this message translates to:
  /// **'Data Bank documents'**
  String get storageCategoryDataBank;

  /// No description provided for @storageCategoryAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get storageCategoryAudio;

  /// No description provided for @storageCategoryCache.
  ///
  /// In en, this message translates to:
  /// **'Cache'**
  String get storageCategoryCache;

  /// No description provided for @storageFilesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s)'**
  String storageFilesCount(int count);

  /// No description provided for @storageReclaimable.
  ///
  /// In en, this message translates to:
  /// **'{size} reclaimable'**
  String storageReclaimable(String size);

  /// No description provided for @storageCleanupCandidates.
  ///
  /// In en, this message translates to:
  /// **'Safe cleanup'**
  String get storageCleanupCandidates;

  /// No description provided for @storageNoCleanupCandidates.
  ///
  /// In en, this message translates to:
  /// **'No unreferenced or expired files found'**
  String get storageNoCleanupCandidates;

  /// No description provided for @storageSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get storageSelectAll;

  /// No description provided for @storageClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get storageClearSelection;

  /// No description provided for @storageUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get storageUndo;

  /// No description provided for @storageCleanSelected.
  ///
  /// In en, this message translates to:
  /// **'Clean selected'**
  String get storageCleanSelected;

  /// No description provided for @storageCleanupReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review cleanup'**
  String get storageCleanupReviewTitle;

  /// No description provided for @storageCleanupReviewBody.
  ///
  /// In en, this message translates to:
  /// **'Move {items} item(s), containing {files} file(s) and using {size}, to recoverable trash?'**
  String storageCleanupReviewBody(int items, int files, String size);

  /// No description provided for @storageCleanupRecoverableHint.
  ///
  /// In en, this message translates to:
  /// **'Referenced files are protected. You can undo until staged files are permanently removed.'**
  String get storageCleanupRecoverableHint;

  /// No description provided for @storageCleanupMoved.
  ///
  /// In en, this message translates to:
  /// **'{count} item(s) moved to recoverable trash'**
  String storageCleanupMoved(int count);

  /// No description provided for @storageCleanupRestored.
  ///
  /// In en, this message translates to:
  /// **'Cleanup undone'**
  String get storageCleanupRestored;

  /// No description provided for @storageCleanupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Cleanup completed'**
  String get storageCleanupCompleted;

  /// No description provided for @storageCleanupFailed.
  ///
  /// In en, this message translates to:
  /// **'Cleanup failed: {error}'**
  String storageCleanupFailed(String error);

  /// No description provided for @storageReasonInterruptedTemporary.
  ///
  /// In en, this message translates to:
  /// **'Interrupted temporary data'**
  String get storageReasonInterruptedTemporary;

  /// No description provided for @storageReasonMissingDatabaseReference.
  ///
  /// In en, this message translates to:
  /// **'No database document references this data'**
  String get storageReasonMissingDatabaseReference;

  /// No description provided for @storageReasonInterruptedDocumentCleanup.
  ///
  /// In en, this message translates to:
  /// **'Interrupted document cleanup'**
  String get storageReasonInterruptedDocumentCleanup;

  /// No description provided for @storageReasonMissingFileReference.
  ///
  /// In en, this message translates to:
  /// **'No database record references this file'**
  String get storageReasonMissingFileReference;

  /// No description provided for @storageReasonExpiredTransient.
  ///
  /// In en, this message translates to:
  /// **'Expired transient data'**
  String get storageReasonExpiredTransient;

  /// No description provided for @storageReasonExpiredAudio.
  ///
  /// In en, this message translates to:
  /// **'Expired synthesized audio'**
  String get storageReasonExpiredAudio;

  /// No description provided for @live2dUnavailableModelMessage.
  ///
  /// In en, this message translates to:
  /// **'The assigned Live2D model is unavailable. Choose another model or import it again.'**
  String get live2dUnavailableModelMessage;

  /// No description provided for @live2dSelectionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'That Live2D model is no longer available. Choose another model or import it again.'**
  String get live2dSelectionExpiredMessage;

  /// No description provided for @live2dModelsImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Live2D model imported} other{{count} Live2D models imported}}'**
  String live2dModelsImported(int count);

  /// No description provided for @live2dModelDeleted.
  ///
  /// In en, this message translates to:
  /// **'Imported Live2D model deleted.'**
  String get live2dModelDeleted;

  /// No description provided for @live2dCleanupPending.
  ///
  /// In en, this message translates to:
  /// **' File cleanup will be retried on the next library refresh.'**
  String get live2dCleanupPending;

  /// No description provided for @live2dDeleteImportedModelQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete imported model?'**
  String get live2dDeleteImportedModelQuestion;

  /// No description provided for @live2dDeletePackageBody.
  ///
  /// In en, this message translates to:
  /// **'This package contains {count} models. All of them will be deleted.'**
  String live2dDeletePackageBody(int count);

  /// No description provided for @live2dDeleteModelBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be deleted from this device.'**
  String live2dDeleteModelBody(String name);

  /// No description provided for @live2dDisabledFor.
  ///
  /// In en, this message translates to:
  /// **'Live2D will be disabled for:'**
  String get live2dDisabledFor;

  /// No description provided for @live2dLicensing.
  ///
  /// In en, this message translates to:
  /// **'Live2D licensing'**
  String get live2dLicensing;

  /// No description provided for @live2dLicenseNotice.
  ///
  /// In en, this message translates to:
  /// **'The renderer includes the Live2D Cubism SDK and Core. Model files and commercial distribution may have separate terms.\n\nThe bundled Hiyori Momose model is official sample data owned and copyrighted by Live2D Inc. It is used under the Live2D Free Material License Agreement and Sample Data Terms of Use. This app itself is created at the author\'s sole discretion.\n\nVerify the rights for every imported model before publishing the app.'**
  String get live2dLicenseNotice;

  /// No description provided for @live2dReviewTerms.
  ///
  /// In en, this message translates to:
  /// **'Review terms'**
  String get live2dReviewTerms;

  /// No description provided for @live2dUnavailableLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} (Unavailable)'**
  String live2dUnavailableLabel(String name);

  /// No description provided for @live2dImportedLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} (Imported)'**
  String live2dImportedLabel(String name);

  /// No description provided for @live2dImportZip.
  ///
  /// In en, this message translates to:
  /// **'Import model'**
  String get live2dImportZip;

  /// No description provided for @live2dMotion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get live2dMotion;

  /// No description provided for @live2dPlayMotion.
  ///
  /// In en, this message translates to:
  /// **'Play motion'**
  String get live2dPlayMotion;

  /// No description provided for @live2dStageAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Stage adjustment'**
  String get live2dStageAdjustment;

  /// No description provided for @live2dMotionSpeed.
  ///
  /// In en, this message translates to:
  /// **'Motion speed'**
  String get live2dMotionSpeed;

  /// No description provided for @live2dImportedModels.
  ///
  /// In en, this message translates to:
  /// **'Imported models'**
  String get live2dImportedModels;

  /// No description provided for @live2dModelsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 model} other{{count} models}}'**
  String live2dModelsCount(int count);

  /// No description provided for @live2dDeleteImportedModel.
  ///
  /// In en, this message translates to:
  /// **'Delete imported model'**
  String get live2dDeleteImportedModel;

  /// No description provided for @rpgScenarioTitle.
  ///
  /// In en, this message translates to:
  /// **'RPG Scenario'**
  String get rpgScenarioTitle;

  /// No description provided for @rpgImportScenario.
  ///
  /// In en, this message translates to:
  /// **'Import scenario'**
  String get rpgImportScenario;

  /// No description provided for @rpgSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get rpgSaveDraft;

  /// No description provided for @rpgRestoreDraft.
  ///
  /// In en, this message translates to:
  /// **'Restore draft'**
  String get rpgRestoreDraft;

  /// No description provided for @rpgExportScenario.
  ///
  /// In en, this message translates to:
  /// **'Export scenario'**
  String get rpgExportScenario;

  /// No description provided for @rpgIssues.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get rpgIssues;

  /// No description provided for @rpgIssuesCount.
  ///
  /// In en, this message translates to:
  /// **'Issues ({count})'**
  String rpgIssuesCount(int count);

  /// No description provided for @rpgScenarioImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Scenario import failed'**
  String get rpgScenarioImportFailed;

  /// No description provided for @rpgScenarioImported.
  ///
  /// In en, this message translates to:
  /// **'Imported {name}'**
  String rpgScenarioImported(String name);

  /// No description provided for @rpgDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get rpgDraftSaved;

  /// No description provided for @rpgDraftRestored.
  ///
  /// In en, this message translates to:
  /// **'Draft restored'**
  String get rpgDraftRestored;

  /// No description provided for @rpgNoSavedDraft.
  ///
  /// In en, this message translates to:
  /// **'No saved draft'**
  String get rpgNoSavedDraft;

  /// No description provided for @rpgScenarioExported.
  ///
  /// In en, this message translates to:
  /// **'Scenario exported'**
  String get rpgScenarioExported;

  /// No description provided for @rpgSetValue.
  ///
  /// In en, this message translates to:
  /// **'Set value'**
  String get rpgSetValue;

  /// No description provided for @rpgAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add {label}'**
  String rpgAddItem(String label);

  /// No description provided for @rpgItemActions.
  ///
  /// In en, this message translates to:
  /// **'Item actions'**
  String get rpgItemActions;

  /// No description provided for @rpgMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get rpgMoveUp;

  /// No description provided for @rpgMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get rpgMoveDown;

  /// No description provided for @rpgAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get rpgAddEntry;

  /// No description provided for @rpgDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get rpgDeleteEntry;

  /// No description provided for @rpgAddEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {label} entry'**
  String rpgAddEntryTitle(String label);

  /// No description provided for @rpgValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get rpgValue;

  /// No description provided for @rpgEnterInteger.
  ///
  /// In en, this message translates to:
  /// **'Enter an integer'**
  String get rpgEnterInteger;

  /// No description provided for @rpgEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get rpgEnterNumber;

  /// No description provided for @rpgItemNumber.
  ///
  /// In en, this message translates to:
  /// **'Item {number}'**
  String rpgItemNumber(int number);

  /// No description provided for @rpgFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'{field, select, metadata{Metadata} compatibility{Compatibility} initialState{Initial State} initialSeed{Initial Seed} schemaVersion{Schema Version} protectedFields{Protected Fields} minimumEngineVersion{Minimum Engine Version} maximumEngineVersion{Maximum Engine Version} requiredCapabilities{Required Capabilities} actors{Actors} attributes{Attributes} author{Author} availability{Availability} branchId{Branch ID} conditions{Conditions} cooldowns{Cooldowns} costs{Costs} createdAt{Created At} data{Data} day{Day} description{Description} difficulty{Difficulty} effects{Effects} elapsedMinutes{Elapsed Minutes} eventHistory{Event History} expression{Expression} failureEffects{Failure Effects} format{Format} id{ID} initialValue{Initial Value} inventory{Inventory} items{Items} label{Label} locations{Locations} maximum{Maximum} minimum{Minimum} minuteOfDay{Minute of Day} name{Name} narrative{Narrative} objectiveIds{Objective IDs} objectiveProgress{Objective Progress} operator{Operator} quantity{Quantity} quests{Quests} relationships{Relationships} source{Source} stages{Stages} status{Status} successEffects{Success Effects} summary{Summary} tags{Tags} target{Target} turn{Turn} type{Type} updatedAt{Updated At} value{Value} variables{Variables} version{Version} other{{field}}}'**
  String rpgFieldLabel(String field);

  /// No description provided for @dataBankChatRetrievalSettings.
  ///
  /// In en, this message translates to:
  /// **'Chat retrieval settings'**
  String get dataBankChatRetrievalSettings;

  /// No description provided for @dataBankRebuildSearchIndex.
  ///
  /// In en, this message translates to:
  /// **'Rebuild search index'**
  String get dataBankRebuildSearchIndex;

  /// No description provided for @dataBankImportDocument.
  ///
  /// In en, this message translates to:
  /// **'Import document'**
  String get dataBankImportDocument;

  /// No description provided for @dataBankSearchDocuments.
  ///
  /// In en, this message translates to:
  /// **'Search documents'**
  String get dataBankSearchDocuments;

  /// No description provided for @dataBankClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get dataBankClearSearch;

  /// No description provided for @dataBankNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get dataBankNoMatches;

  /// No description provided for @dataBankNoDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get dataBankNoDocuments;

  /// No description provided for @dataBankSearchIndexRebuilt.
  ///
  /// In en, this message translates to:
  /// **'Search index rebuilt'**
  String get dataBankSearchIndexRebuilt;

  /// No description provided for @dataBankDeleteDocumentQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String dataBankDeleteDocumentQuestion(String name);

  /// No description provided for @dataBankDeleteDocumentBody.
  ///
  /// In en, this message translates to:
  /// **'{versions} version(s), {chunks} chunk(s), {bindings} binding(s), and {files} managed file(s) will be removed.'**
  String dataBankDeleteDocumentBody(
      int versions, int chunks, int bindings, int files);

  /// No description provided for @dataBankChatRetrieval.
  ///
  /// In en, this message translates to:
  /// **'Chat retrieval'**
  String get dataBankChatRetrieval;

  /// No description provided for @dataBankUseInChat.
  ///
  /// In en, this message translates to:
  /// **'Use Data Bank in chat'**
  String get dataBankUseInChat;

  /// No description provided for @dataBankQueryExpansion.
  ///
  /// In en, this message translates to:
  /// **'Conversation-aware query expansion'**
  String get dataBankQueryExpansion;

  /// No description provided for @dataBankSemanticReranking.
  ///
  /// In en, this message translates to:
  /// **'Semantic reranking'**
  String get dataBankSemanticReranking;

  /// No description provided for @dataBankUsesEmbeddingProvider.
  ///
  /// In en, this message translates to:
  /// **'Uses the configured Embedding provider'**
  String get dataBankUsesEmbeddingProvider;

  /// No description provided for @dataBankSourcesPerResponse.
  ///
  /// In en, this message translates to:
  /// **'Sources per response'**
  String get dataBankSourcesPerResponse;

  /// No description provided for @dataBankTokenBudget.
  ///
  /// In en, this message translates to:
  /// **'Token budget'**
  String get dataBankTokenBudget;

  /// No description provided for @dataBankChunksPerDocument.
  ///
  /// In en, this message translates to:
  /// **'Chunks per document'**
  String get dataBankChunksPerDocument;

  /// No description provided for @dataBankLastRetrieval.
  ///
  /// In en, this message translates to:
  /// **'Last retrieval'**
  String get dataBankLastRetrieval;

  /// No description provided for @dataBankNoRetrievalYet.
  ///
  /// In en, this message translates to:
  /// **'No chat retrieval has run yet.'**
  String get dataBankNoRetrievalYet;

  /// No description provided for @dataBankModeLocalFts.
  ///
  /// In en, this message translates to:
  /// **'Local full-text search'**
  String get dataBankModeLocalFts;

  /// No description provided for @dataBankModeSemantic.
  ///
  /// In en, this message translates to:
  /// **'Hybrid semantic reranking'**
  String get dataBankModeSemantic;

  /// No description provided for @dataBankModeFallback.
  ///
  /// In en, this message translates to:
  /// **'Local fallback'**
  String get dataBankModeFallback;

  /// No description provided for @dataBankSourcesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 source} other{{count} sources}}'**
  String dataBankSourcesCount(int count);

  /// No description provided for @dataBankInspectAllSources.
  ///
  /// In en, this message translates to:
  /// **'Inspect all sources'**
  String get dataBankInspectAllSources;

  /// No description provided for @dataBankChunksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chunk} other{{count} chunks}}'**
  String dataBankChunksCount(int count);

  /// No description provided for @dataBankBindingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 binding} other{{count} bindings}}'**
  String dataBankBindingsCount(int count);

  /// No description provided for @dataBankProcessingFailed.
  ///
  /// In en, this message translates to:
  /// **'Processing failed'**
  String get dataBankProcessingFailed;

  /// No description provided for @dataBankManageBindings.
  ///
  /// In en, this message translates to:
  /// **'Manage bindings'**
  String get dataBankManageBindings;

  /// No description provided for @dataBankRebuildDocument.
  ///
  /// In en, this message translates to:
  /// **'Rebuild document'**
  String get dataBankRebuildDocument;

  /// No description provided for @dataBankBindings.
  ///
  /// In en, this message translates to:
  /// **'Bindings'**
  String get dataBankBindings;

  /// No description provided for @dataBankRemoveBinding.
  ///
  /// In en, this message translates to:
  /// **'Remove binding'**
  String get dataBankRemoveBinding;

  /// No description provided for @dataBankAddBinding.
  ///
  /// In en, this message translates to:
  /// **'Add binding'**
  String get dataBankAddBinding;

  /// No description provided for @dataBankStatusSemantics.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String dataBankStatusSemantics(String status);

  /// No description provided for @dataBankDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dataBankDismiss;

  /// No description provided for @dataBankStatePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dataBankStatePending;

  /// No description provided for @dataBankStateProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get dataBankStateProcessing;

  /// No description provided for @dataBankStateReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get dataBankStateReady;

  /// No description provided for @dataBankStateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get dataBankStateFailed;

  /// No description provided for @dataBankStateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get dataBankStateDeleted;

  /// No description provided for @dataBankDuplicateDocument.
  ///
  /// In en, this message translates to:
  /// **'This document is already in the Data Bank.'**
  String get dataBankDuplicateDocument;

  /// No description provided for @memoryChatContext.
  ///
  /// In en, this message translates to:
  /// **'Chat context'**
  String get memoryChatContext;

  /// No description provided for @memoryAutomaticExtraction.
  ///
  /// In en, this message translates to:
  /// **'Automatic extraction'**
  String get memoryAutomaticExtraction;

  /// No description provided for @memoryAutomaticExtractionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Uses the current AI connection after new turns'**
  String get memoryAutomaticExtractionSubtitle;

  /// No description provided for @memoryRecentChat.
  ///
  /// In en, this message translates to:
  /// **'Recent chat'**
  String get memoryRecentChat;

  /// No description provided for @memoryCancelExtraction.
  ///
  /// In en, this message translates to:
  /// **'Cancel extraction'**
  String get memoryCancelExtraction;

  /// No description provided for @memoryExtractFromChat.
  ///
  /// In en, this message translates to:
  /// **'Extract from chat'**
  String get memoryExtractFromChat;

  /// No description provided for @memoryExtractionResult.
  ///
  /// In en, this message translates to:
  /// **'{candidates} candidates, {duplicates} duplicates, {rejected} rejected'**
  String memoryExtractionResult(int candidates, int duplicates, int rejected);

  /// No description provided for @memoryCandidatesCount.
  ///
  /// In en, this message translates to:
  /// **'Candidates {count}'**
  String memoryCandidatesCount(int count);

  /// No description provided for @memoryActiveCount.
  ///
  /// In en, this message translates to:
  /// **'Active {count}'**
  String memoryActiveCount(int count);

  /// No description provided for @memoryHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'History {count}'**
  String memoryHistoryCount(int count);

  /// No description provided for @memoryCreate.
  ///
  /// In en, this message translates to:
  /// **'Create memory'**
  String get memoryCreate;

  /// No description provided for @memoryClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get memoryClearSelection;

  /// No description provided for @memoryIgnoreSelected.
  ///
  /// In en, this message translates to:
  /// **'Ignore selected'**
  String get memoryIgnoreSelected;

  /// No description provided for @memoryMergeSelected.
  ///
  /// In en, this message translates to:
  /// **'Merge selected'**
  String get memoryMergeSelected;

  /// No description provided for @memorySelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String memorySelectedCount(int count);

  /// No description provided for @memoryUseInChat.
  ///
  /// In en, this message translates to:
  /// **'Use memories in chat'**
  String get memoryUseInChat;

  /// No description provided for @memorySemanticReranking.
  ///
  /// In en, this message translates to:
  /// **'Semantic reranking'**
  String get memorySemanticReranking;

  /// No description provided for @memoryConfiguredEmbeddingProvider.
  ///
  /// In en, this message translates to:
  /// **'Configured embedding provider'**
  String get memoryConfiguredEmbeddingProvider;

  /// No description provided for @memoryContextBudget.
  ///
  /// In en, this message translates to:
  /// **'Context budget'**
  String get memoryContextBudget;

  /// No description provided for @memoryTokensCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tokens'**
  String memoryTokensCount(int count);

  /// No description provided for @memoryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit memory'**
  String get memoryEdit;

  /// No description provided for @memoryMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge memories'**
  String get memoryMerge;

  /// No description provided for @memoryImportancePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% importance'**
  String memoryImportancePercent(int percent);

  /// No description provided for @memoryExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String memoryExpires(String date);

  /// No description provided for @memoryApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get memoryApprove;

  /// No description provided for @memoryUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get memoryUnlock;

  /// No description provided for @memoryLock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get memoryLock;

  /// No description provided for @memoryOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get memoryOpenSource;

  /// No description provided for @memoryIgnore.
  ///
  /// In en, this message translates to:
  /// **'Ignore'**
  String get memoryIgnore;

  /// No description provided for @memoryChatScope.
  ///
  /// In en, this message translates to:
  /// **'Chat scope'**
  String get memoryChatScope;

  /// No description provided for @memoryKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get memoryKind;

  /// No description provided for @memoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memoryLabel;

  /// No description provided for @memoryIdentityKey.
  ///
  /// In en, this message translates to:
  /// **'Identity key'**
  String get memoryIdentityKey;

  /// No description provided for @memoryImportance.
  ///
  /// In en, this message translates to:
  /// **'Importance'**
  String get memoryImportance;

  /// No description provided for @memoryLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get memoryLocked;

  /// No description provided for @memoryKindPersonFact.
  ///
  /// In en, this message translates to:
  /// **'Person fact'**
  String get memoryKindPersonFact;

  /// No description provided for @memoryKindRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get memoryKindRelationship;

  /// No description provided for @memoryKindEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get memoryKindEvent;

  /// No description provided for @memoryKindCommitment.
  ///
  /// In en, this message translates to:
  /// **'Commitment'**
  String get memoryKindCommitment;

  /// No description provided for @memoryKindPreference.
  ///
  /// In en, this message translates to:
  /// **'Preference'**
  String get memoryKindPreference;

  /// No description provided for @memoryKindLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get memoryKindLocation;

  /// No description provided for @memoryKindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get memoryKindOther;

  /// No description provided for @memoryScopeCharacterPersona.
  ///
  /// In en, this message translates to:
  /// **'Character and persona'**
  String get memoryScopeCharacterPersona;

  /// No description provided for @memoryScopeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get memoryScopeGroup;

  /// No description provided for @mcpAddServer.
  ///
  /// In en, this message translates to:
  /// **'Add MCP server'**
  String get mcpAddServer;

  /// No description provided for @mcpServersTab.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get mcpServersTab;

  /// No description provided for @mcpActivityTab.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get mcpActivityTab;

  /// No description provided for @mcpProtocolName.
  ///
  /// In en, this message translates to:
  /// **'Model Context Protocol'**
  String get mcpProtocolName;

  /// No description provided for @mcpNoServers.
  ///
  /// In en, this message translates to:
  /// **'No MCP servers'**
  String get mcpNoServers;

  /// No description provided for @mcpErrorCode.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String mcpErrorCode(String code);

  /// No description provided for @mcpProtocolVersion.
  ///
  /// In en, this message translates to:
  /// **'Protocol {version}'**
  String mcpProtocolVersion(String version);

  /// No description provided for @mcpDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get mcpDisconnect;

  /// No description provided for @mcpRefreshTools.
  ///
  /// In en, this message translates to:
  /// **'Refresh tools'**
  String get mcpRefreshTools;

  /// No description provided for @mcpReconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get mcpReconnect;

  /// No description provided for @mcpConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get mcpConnect;

  /// No description provided for @mcpEditServer.
  ///
  /// In en, this message translates to:
  /// **'Edit MCP server'**
  String get mcpEditServer;

  /// No description provided for @mcpRemoveServer.
  ///
  /// In en, this message translates to:
  /// **'Remove MCP server'**
  String get mcpRemoveServer;

  /// No description provided for @mcpNoToolsDiscovered.
  ///
  /// In en, this message translates to:
  /// **'No tools discovered'**
  String get mcpNoToolsDiscovered;

  /// No description provided for @mcpRemoveServerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove MCP server?'**
  String get mcpRemoveServerQuestion;

  /// No description provided for @mcpRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get mcpRemove;

  /// No description provided for @mcpToolPermission.
  ///
  /// In en, this message translates to:
  /// **'Tool permission'**
  String get mcpToolPermission;

  /// No description provided for @mcpAskEveryTime.
  ///
  /// In en, this message translates to:
  /// **'Ask every time'**
  String get mcpAskEveryTime;

  /// No description provided for @mcpAlwaysAllow.
  ///
  /// In en, this message translates to:
  /// **'Always allow'**
  String get mcpAlwaysAllow;

  /// No description provided for @mcpDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied'**
  String get mcpDenied;

  /// No description provided for @mcpNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No MCP activity'**
  String get mcpNoActivity;

  /// No description provided for @mcpEndpoint.
  ///
  /// In en, this message translates to:
  /// **'MCP endpoint'**
  String get mcpEndpoint;

  /// No description provided for @mcpTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get mcpTransport;

  /// No description provided for @mcpBearerToken.
  ///
  /// In en, this message translates to:
  /// **'Bearer token'**
  String get mcpBearerToken;

  /// No description provided for @mcpShowToken.
  ///
  /// In en, this message translates to:
  /// **'Show token'**
  String get mcpShowToken;

  /// No description provided for @mcpHideToken.
  ///
  /// In en, this message translates to:
  /// **'Hide token'**
  String get mcpHideToken;

  /// No description provided for @mcpRemoveStoredToken.
  ///
  /// In en, this message translates to:
  /// **'Remove stored token'**
  String get mcpRemoveStoredToken;

  /// No description provided for @mcpAllowInsecureHttp.
  ///
  /// In en, this message translates to:
  /// **'Allow insecure HTTP'**
  String get mcpAllowInsecureHttp;

  /// No description provided for @mcpServerEnabled.
  ///
  /// In en, this message translates to:
  /// **'Server enabled'**
  String get mcpServerEnabled;

  /// No description provided for @mcpDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get mcpDisconnected;

  /// No description provided for @mcpConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get mcpConnecting;

  /// No description provided for @mcpConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get mcpConnected;

  /// No description provided for @mcpReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting'**
  String get mcpReconnecting;

  /// No description provided for @mcpReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Read-only hint'**
  String get mcpReadOnlyHint;

  /// No description provided for @mcpWriteCapable.
  ///
  /// In en, this message translates to:
  /// **'Write-capable'**
  String get mcpWriteCapable;

  /// No description provided for @mcpExternalSideEffect.
  ///
  /// In en, this message translates to:
  /// **'External side effect'**
  String get mcpExternalSideEffect;

  /// No description provided for @capabilityCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Capability check failed'**
  String get capabilityCheckFailed;

  /// No description provided for @capabilityRecentExternalActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent external activity'**
  String get capabilityRecentExternalActivity;

  /// No description provided for @capabilityAuditUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Audit history unavailable'**
  String get capabilityAuditUnavailable;

  /// No description provided for @capabilityNoExternalCalls.
  ///
  /// In en, this message translates to:
  /// **'No external calls recorded'**
  String get capabilityNoExternalCalls;

  /// No description provided for @capabilityReadyCount.
  ///
  /// In en, this message translates to:
  /// **'{ready} of {total} ready'**
  String capabilityReadyCount(int ready, int total);

  /// No description provided for @capabilityOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get capabilityOpenSettings;

  /// No description provided for @capabilityRequestPermission.
  ///
  /// In en, this message translates to:
  /// **'Request permission'**
  String get capabilityRequestPermission;

  /// No description provided for @capabilityCurrentAi.
  ///
  /// In en, this message translates to:
  /// **'Current AI'**
  String get capabilityCurrentAi;

  /// No description provided for @capabilitySystemSpeech.
  ///
  /// In en, this message translates to:
  /// **'System speech'**
  String get capabilitySystemSpeech;

  /// No description provided for @capabilityVoiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get capabilityVoiceInput;

  /// No description provided for @capabilitySemanticSearch.
  ///
  /// In en, this message translates to:
  /// **'Semantic search'**
  String get capabilitySemanticSearch;

  /// No description provided for @capabilityMcpTools.
  ///
  /// In en, this message translates to:
  /// **'MCP tools'**
  String get capabilityMcpTools;

  /// No description provided for @capabilityChatGenerationConnection.
  ///
  /// In en, this message translates to:
  /// **'Chat generation connection'**
  String get capabilityChatGenerationConnection;

  /// No description provided for @capabilityDeviceTts.
  ///
  /// In en, this message translates to:
  /// **'Device text-to-speech'**
  String get capabilityDeviceTts;

  /// No description provided for @capabilityDeviceSpeechRecognition.
  ///
  /// In en, this message translates to:
  /// **'Device speech recognition'**
  String get capabilityDeviceSpeechRecognition;

  /// No description provided for @capabilityOptionalEmbeddingConnection.
  ///
  /// In en, this message translates to:
  /// **'Optional embedding connection'**
  String get capabilityOptionalEmbeddingConnection;

  /// No description provided for @capabilityOptionalImageConnection.
  ///
  /// In en, this message translates to:
  /// **'Optional image connection'**
  String get capabilityOptionalImageConnection;

  /// No description provided for @capabilityExternalToolServers.
  ///
  /// In en, this message translates to:
  /// **'External tool servers'**
  String get capabilityExternalToolServers;

  /// No description provided for @capabilityBundledCharacterRendering.
  ///
  /// In en, this message translates to:
  /// **'Bundled character rendering'**
  String get capabilityBundledCharacterRendering;

  /// No description provided for @capabilityCompleteAiConnection.
  ///
  /// In en, this message translates to:
  /// **'Complete the current AI connection'**
  String get capabilityCompleteAiConnection;

  /// No description provided for @capabilityCompleteEmbeddingConnection.
  ///
  /// In en, this message translates to:
  /// **'Complete the embedding connection'**
  String get capabilityCompleteEmbeddingConnection;

  /// No description provided for @capabilityCompleteImageConnection.
  ///
  /// In en, this message translates to:
  /// **'Complete the image connection'**
  String get capabilityCompleteImageConnection;

  /// No description provided for @capabilityConfigurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Configuration required'**
  String get capabilityConfigurationRequired;

  /// No description provided for @capabilityConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get capabilityConfigured;

  /// No description provided for @capabilityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get capabilityAvailable;

  /// No description provided for @capabilityPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get capabilityPermissionRequired;

  /// No description provided for @capabilityPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get capabilityPermissionDenied;

  /// No description provided for @capabilityDownloadRequired.
  ///
  /// In en, this message translates to:
  /// **'Download required'**
  String get capabilityDownloadRequired;

  /// No description provided for @capabilityUnavailableOffline.
  ///
  /// In en, this message translates to:
  /// **'Unavailable while offline'**
  String get capabilityUnavailableOffline;

  /// No description provided for @capabilityUnavailableBuild.
  ///
  /// In en, this message translates to:
  /// **'Not available in this build'**
  String get capabilityUnavailableBuild;

  /// No description provided for @capabilityDataMetadata.
  ///
  /// In en, this message translates to:
  /// **'metadata'**
  String get capabilityDataMetadata;

  /// No description provided for @capabilityDataPrompt.
  ///
  /// In en, this message translates to:
  /// **'prompt'**
  String get capabilityDataPrompt;

  /// No description provided for @capabilityDataChatText.
  ///
  /// In en, this message translates to:
  /// **'chat text'**
  String get capabilityDataChatText;

  /// No description provided for @capabilityDataDocumentText.
  ///
  /// In en, this message translates to:
  /// **'document text'**
  String get capabilityDataDocumentText;

  /// No description provided for @capabilityDataImage.
  ///
  /// In en, this message translates to:
  /// **'image'**
  String get capabilityDataImage;

  /// No description provided for @capabilityDataAudio.
  ///
  /// In en, this message translates to:
  /// **'audio'**
  String get capabilityDataAudio;

  /// No description provided for @capabilityDataCharacterCard.
  ///
  /// In en, this message translates to:
  /// **'character card'**
  String get capabilityDataCharacterCard;

  /// No description provided for @capabilityDataToolArguments.
  ///
  /// In en, this message translates to:
  /// **'tool arguments'**
  String get capabilityDataToolArguments;

  /// No description provided for @dataBankCitationSourcesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Data Bank source} other{{count} Data Bank sources}}'**
  String dataBankCitationSourcesCount(int count);

  /// No description provided for @dataBankCitationSources.
  ///
  /// In en, this message translates to:
  /// **'Data Bank sources'**
  String get dataBankCitationSources;

  /// No description provided for @dataBankLocalQueriesFused.
  ///
  /// In en, this message translates to:
  /// **'{count} local queries fused'**
  String dataBankLocalQueriesFused(int count);

  /// No description provided for @memoryUsed.
  ///
  /// In en, this message translates to:
  /// **'Memories used'**
  String get memoryUsed;

  /// No description provided for @memoryTokenUsage.
  ///
  /// In en, this message translates to:
  /// **'{used}/{allocated} tokens'**
  String memoryTokenUsage(int used, int allocated);

  /// No description provided for @memoryRelevancePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% relevance'**
  String memoryRelevancePercent(int percent);

  /// No description provided for @memoryModeLocalFts.
  ///
  /// In en, this message translates to:
  /// **'Local FTS'**
  String get memoryModeLocalFts;

  /// No description provided for @memoryModeHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get memoryModeHybrid;

  /// No description provided for @memoryModeLocalFallback.
  ///
  /// In en, this message translates to:
  /// **'Local FTS fallback'**
  String get memoryModeLocalFallback;

  /// No description provided for @memoryIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get memoryIncluded;

  /// No description provided for @memoryTrimmed.
  ///
  /// In en, this message translates to:
  /// **'Trimmed'**
  String get memoryTrimmed;

  /// No description provided for @memoryExcluded.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get memoryExcluded;

  /// No description provided for @rpgTurnNumber.
  ///
  /// In en, this message translates to:
  /// **'Turn {turn}'**
  String rpgTurnNumber(int turn);

  /// No description provided for @rpgDisableMode.
  ///
  /// In en, this message translates to:
  /// **'Disable RPG mode'**
  String get rpgDisableMode;

  /// No description provided for @rpgStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get rpgStatus;

  /// No description provided for @rpgInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get rpgInventory;

  /// No description provided for @rpgQuests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get rpgQuests;

  /// No description provided for @rpgRelations.
  ///
  /// In en, this message translates to:
  /// **'Relations'**
  String get rpgRelations;

  /// No description provided for @rpgActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get rpgActions;

  /// No description provided for @rpgLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get rpgLog;

  /// No description provided for @rpgLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get rpgLocation;

  /// No description provided for @rpgTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get rpgTime;

  /// No description provided for @rpgDayTime.
  ///
  /// In en, this message translates to:
  /// **'Day {day}, {time}'**
  String rpgDayTime(int day, String time);

  /// No description provided for @rpgInventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Inventory is empty'**
  String get rpgInventoryEmpty;

  /// No description provided for @rpgNoQuests.
  ///
  /// In en, this message translates to:
  /// **'No quests'**
  String get rpgNoQuests;

  /// No description provided for @rpgNoRelationships.
  ///
  /// In en, this message translates to:
  /// **'No relationships'**
  String get rpgNoRelationships;

  /// No description provided for @rpgNoActions.
  ///
  /// In en, this message translates to:
  /// **'No actions defined'**
  String get rpgNoActions;

  /// No description provided for @rpgCost.
  ///
  /// In en, this message translates to:
  /// **'Cost: {cost}'**
  String rpgCost(String cost);

  /// No description provided for @rpgCheck.
  ///
  /// In en, this message translates to:
  /// **'Check: {dice} + {attribute} vs {difficulty}'**
  String rpgCheck(String dice, String attribute, num difficulty);

  /// No description provided for @rpgCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown: {turns} turn(s)'**
  String rpgCooldown(int turns);

  /// No description provided for @rpgRequirementsNotMet.
  ///
  /// In en, this message translates to:
  /// **'Requirements or resources not met'**
  String get rpgRequirementsNotMet;

  /// No description provided for @rpgNoTurnsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No turns recorded'**
  String get rpgNoTurnsRecorded;

  /// No description provided for @rpgSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Snapshots'**
  String get rpgSnapshots;

  /// No description provided for @rpgSnapshotActions.
  ///
  /// In en, this message translates to:
  /// **'Snapshot actions'**
  String get rpgSnapshotActions;

  /// No description provided for @rpgRestoreSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Restore snapshot'**
  String get rpgRestoreSnapshot;

  /// No description provided for @rpgForkNewBranch.
  ///
  /// In en, this message translates to:
  /// **'Fork new branch'**
  String get rpgForkNewBranch;

  /// No description provided for @rpgRuleEngineSource.
  ///
  /// In en, this message translates to:
  /// **'Source: Rule engine'**
  String get rpgRuleEngineSource;

  /// No description provided for @rpgRoll.
  ///
  /// In en, this message translates to:
  /// **'Roll: {total} ({expression})'**
  String rpgRoll(String total, String expression);

  /// No description provided for @rpgChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes: {changes}'**
  String rpgChanges(String changes);

  /// No description provided for @rpgForkBranch.
  ///
  /// In en, this message translates to:
  /// **'Fork branch'**
  String get rpgForkBranch;

  /// No description provided for @rpgBranchId.
  ///
  /// In en, this message translates to:
  /// **'Branch ID'**
  String get rpgBranchId;

  /// No description provided for @rpgFork.
  ///
  /// In en, this message translates to:
  /// **'Fork'**
  String get rpgFork;

  /// No description provided for @rpgQuestInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get rpgQuestInactive;

  /// No description provided for @rpgQuestActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get rpgQuestActive;

  /// No description provided for @rpgQuestCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get rpgQuestCompleted;

  /// No description provided for @rpgQuestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get rpgQuestFailed;

  /// No description provided for @rpgEnableMode.
  ///
  /// In en, this message translates to:
  /// **'Enable RPG mode'**
  String get rpgEnableMode;

  /// No description provided for @noImageGenerated.
  ///
  /// In en, this message translates to:
  /// **'No image was generated'**
  String get noImageGenerated;

  /// No description provided for @failedToSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image: {error}'**
  String failedToSaveImage(String error);

  /// No description provided for @imagesAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {count} image(s)'**
  String imagesAdded(int count);

  /// No description provided for @addConnection.
  ///
  /// In en, this message translates to:
  /// **'Add connection'**
  String get addConnection;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @lockType.
  ///
  /// In en, this message translates to:
  /// **'Lock type'**
  String get lockType;

  /// No description provided for @errorLoadingCharacters.
  ///
  /// In en, this message translates to:
  /// **'Failed to load characters: {error}'**
  String errorLoadingCharacters(String error);

  /// No description provided for @errorLoadingGroups.
  ///
  /// In en, this message translates to:
  /// **'Failed to load groups: {error}'**
  String errorLoadingGroups(String error);

  /// No description provided for @inSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'In system prompt'**
  String get inSystemPrompt;

  /// No description provided for @connectingGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Connecting to Google Drive...'**
  String get connectingGoogleDrive;

  /// No description provided for @checkingICloud.
  ///
  /// In en, this message translates to:
  /// **'Checking iCloud...'**
  String get checkingICloud;

  /// No description provided for @whatIsPromptManager.
  ///
  /// In en, this message translates to:
  /// **'What is the Prompt Manager?'**
  String get whatIsPromptManager;

  /// No description provided for @promptManagerHelpDescription.
  ///
  /// In en, this message translates to:
  /// **'The Prompt Manager controls how the system prompt is assembled before messages are sent to the AI. You can reorder sections and enable or disable them.'**
  String get promptManagerHelpDescription;

  /// No description provided for @promptSectionTypes.
  ///
  /// In en, this message translates to:
  /// **'Section types'**
  String get promptSectionTypes;

  /// No description provided for @promptSectionTypesDescription.
  ///
  /// In en, this message translates to:
  /// **'Sections can include system instructions, persona and character details, scenario, lorebook context, example messages, author\'s notes, chat history, and post-history instructions.'**
  String get promptSectionTypesDescription;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @promptManagerTips.
  ///
  /// In en, this message translates to:
  /// **'Sections near the top have higher priority. Disable sections you do not need to save tokens, and adjust their order for different results.'**
  String get promptManagerTips;

  /// No description provided for @customImportedPrompt.
  ///
  /// In en, this message translates to:
  /// **'Custom prompt from an imported preset'**
  String get customImportedPrompt;

  /// No description provided for @editPromptSection.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editPromptSection(String name);

  /// No description provided for @promptName.
  ///
  /// In en, this message translates to:
  /// **'Prompt name'**
  String get promptName;

  /// No description provided for @identifierLabel.
  ///
  /// In en, this message translates to:
  /// **'ID: {identifier}'**
  String identifierLabel(String identifier);

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String roleLabel(String role);

  /// No description provided for @supportedPromptMacros.
  ///
  /// In en, this message translates to:
  /// **'Supports macros such as {userMacro}, {charMacro}, {timeMacro}, and {dateMacro}.'**
  String supportedPromptMacros(
      String userMacro, String charMacro, String timeMacro, String dateMacro);

  /// No description provided for @enterPromptContent.
  ///
  /// In en, this message translates to:
  /// **'Enter prompt content...'**
  String get enterPromptContent;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated {name}'**
  String updated(String name);

  /// No description provided for @customPrompt.
  ///
  /// In en, this message translates to:
  /// **'Custom prompt'**
  String get customPrompt;

  /// No description provided for @promptSectionSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'System prompt'**
  String get promptSectionSystemPrompt;

  /// No description provided for @promptSectionSystemPromptDescription.
  ///
  /// In en, this message translates to:
  /// **'Base roleplay instructions'**
  String get promptSectionSystemPromptDescription;

  /// No description provided for @promptSectionPersona.
  ///
  /// In en, this message translates to:
  /// **'User persona'**
  String get promptSectionPersona;

  /// No description provided for @promptSectionPersonaDescription.
  ///
  /// In en, this message translates to:
  /// **'Your persona information'**
  String get promptSectionPersonaDescription;

  /// No description provided for @promptSectionCharacterDescription.
  ///
  /// In en, this message translates to:
  /// **'Character description'**
  String get promptSectionCharacterDescription;

  /// No description provided for @promptSectionCharacterDescriptionDescription.
  ///
  /// In en, this message translates to:
  /// **'The AI character\'s details'**
  String get promptSectionCharacterDescriptionDescription;

  /// No description provided for @promptSectionCharacterPersonality.
  ///
  /// In en, this message translates to:
  /// **'Character personality'**
  String get promptSectionCharacterPersonality;

  /// No description provided for @promptSectionCharacterPersonalityDescription.
  ///
  /// In en, this message translates to:
  /// **'The character\'s personality traits'**
  String get promptSectionCharacterPersonalityDescription;

  /// No description provided for @promptSectionScenario.
  ///
  /// In en, this message translates to:
  /// **'Scenario'**
  String get promptSectionScenario;

  /// No description provided for @promptSectionScenarioDescription.
  ///
  /// In en, this message translates to:
  /// **'Current situation and setting'**
  String get promptSectionScenarioDescription;

  /// No description provided for @promptSectionExampleMessages.
  ///
  /// In en, this message translates to:
  /// **'Example messages'**
  String get promptSectionExampleMessages;

  /// No description provided for @promptSectionExampleMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Sample dialogue that demonstrates style'**
  String get promptSectionExampleMessagesDescription;

  /// No description provided for @promptSectionWorldInfoBefore.
  ///
  /// In en, this message translates to:
  /// **'Lorebook before'**
  String get promptSectionWorldInfoBefore;

  /// No description provided for @promptSectionWorldInfoBeforeDescription.
  ///
  /// In en, this message translates to:
  /// **'Lorebook context inserted before character details'**
  String get promptSectionWorldInfoBeforeDescription;

  /// No description provided for @promptSectionWorldInfoAfter.
  ///
  /// In en, this message translates to:
  /// **'Lorebook after'**
  String get promptSectionWorldInfoAfter;

  /// No description provided for @promptSectionWorldInfoAfterDescription.
  ///
  /// In en, this message translates to:
  /// **'Lorebook context inserted after character details'**
  String get promptSectionWorldInfoAfterDescription;

  /// No description provided for @promptSectionAuthorNote.
  ///
  /// In en, this message translates to:
  /// **'Author\'s note'**
  String get promptSectionAuthorNote;

  /// No description provided for @promptSectionAuthorNoteDescription.
  ///
  /// In en, this message translates to:
  /// **'Dynamic instructions for the current chat'**
  String get promptSectionAuthorNoteDescription;

  /// No description provided for @promptSectionPostHistory.
  ///
  /// In en, this message translates to:
  /// **'Post-history instructions'**
  String get promptSectionPostHistory;

  /// No description provided for @promptSectionPostHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Instructions inserted after chat history'**
  String get promptSectionPostHistoryDescription;

  /// No description provided for @promptSectionNsfw.
  ///
  /// In en, this message translates to:
  /// **'NSFW prompt'**
  String get promptSectionNsfw;

  /// No description provided for @promptSectionNsfwDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional mature-content instructions'**
  String get promptSectionNsfwDescription;

  /// No description provided for @promptSectionChatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get promptSectionChatHistory;

  /// No description provided for @promptSectionChatHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Recent messages from the conversation'**
  String get promptSectionChatHistoryDescription;

  /// No description provided for @promptSectionEnhanceDefinitions.
  ///
  /// In en, this message translates to:
  /// **'Enhance definitions'**
  String get promptSectionEnhanceDefinitions;

  /// No description provided for @promptSectionEnhanceDefinitionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Additional instructions that reinforce character definitions'**
  String get promptSectionEnhanceDefinitionsDescription;

  /// No description provided for @promptSectionCustomDescription.
  ///
  /// In en, this message translates to:
  /// **'A custom prompt section'**
  String get promptSectionCustomDescription;

  /// No description provided for @reasoning.
  ///
  /// In en, this message translates to:
  /// **'Reasoning'**
  String get reasoning;

  /// No description provided for @emotionNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get emotionNeutral;

  /// No description provided for @emotionHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get emotionHappy;

  /// No description provided for @emotionSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get emotionSad;

  /// No description provided for @emotionAngry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get emotionAngry;

  /// No description provided for @emotionSurprised.
  ///
  /// In en, this message translates to:
  /// **'Surprised'**
  String get emotionSurprised;

  /// No description provided for @emotionScared.
  ///
  /// In en, this message translates to:
  /// **'Scared'**
  String get emotionScared;

  /// No description provided for @emotionDisgusted.
  ///
  /// In en, this message translates to:
  /// **'Disgusted'**
  String get emotionDisgusted;

  /// No description provided for @emotionConfused.
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get emotionConfused;

  /// No description provided for @emotionEmbarrassed.
  ///
  /// In en, this message translates to:
  /// **'Embarrassed'**
  String get emotionEmbarrassed;

  /// No description provided for @emotionExcited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get emotionExcited;

  /// No description provided for @emotionLoving.
  ///
  /// In en, this message translates to:
  /// **'Loving'**
  String get emotionLoving;

  /// No description provided for @emotionThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get emotionThinking;

  /// No description provided for @emotionSmug.
  ///
  /// In en, this message translates to:
  /// **'Smug'**
  String get emotionSmug;

  /// No description provided for @emotionTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get emotionTired;

  /// No description provided for @emotionBored.
  ///
  /// In en, this message translates to:
  /// **'Bored'**
  String get emotionBored;

  /// No description provided for @tokenizerHelpContent.
  ///
  /// In en, this message translates to:
  /// **'The tokenizer estimates how much text a model can process. Choose the tokenizer that matches your model, or use Best Match to select one automatically.'**
  String get tokenizerHelpContent;

  /// No description provided for @tokenizerNoneEstimate.
  ///
  /// In en, this message translates to:
  /// **'None (estimate only)'**
  String get tokenizerNoneEstimate;

  /// No description provided for @tokenizerBestMatchAuto.
  ///
  /// In en, this message translates to:
  /// **'Best match (automatic)'**
  String get tokenizerBestMatchAuto;

  /// No description provided for @tokenizerEstimateDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick character-based token estimate'**
  String get tokenizerEstimateDescription;

  /// No description provided for @tokenizerGpt2Description.
  ///
  /// In en, this message translates to:
  /// **'GPT-2 tokenizer for older GPT-style models'**
  String get tokenizerGpt2Description;

  /// No description provided for @tokenizerOaiDescription.
  ///
  /// In en, this message translates to:
  /// **'OAI Compatible tiktoken tokenizer for GPT models'**
  String get tokenizerOaiDescription;

  /// No description provided for @tokenizerLlamaDescription.
  ///
  /// In en, this message translates to:
  /// **'SentencePiece tokenizer for Llama models'**
  String get tokenizerLlamaDescription;

  /// No description provided for @tokenizerLlama3Description.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer for Llama 3 models'**
  String get tokenizerLlama3Description;

  /// No description provided for @tokenizerMistralDescription.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer for Mistral models'**
  String get tokenizerMistralDescription;

  /// No description provided for @tokenizerClaudeDescription.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer estimate for Claude models'**
  String get tokenizerClaudeDescription;

  /// No description provided for @tokenizerGemmaDescription.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer for Gemma models'**
  String get tokenizerGemmaDescription;

  /// No description provided for @tokenizerQwenDescription.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer for Qwen models'**
  String get tokenizerQwenDescription;

  /// No description provided for @tokenizerDeepSeekDescription.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer for DeepSeek models'**
  String get tokenizerDeepSeekDescription;

  /// No description provided for @tokenizerCommandRDescription.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer for Command R models'**
  String get tokenizerCommandRDescription;

  /// No description provided for @tokenizerNemoDescription.
  ///
  /// In en, this message translates to:
  /// **'Tokenizer for Mistral NeMo models'**
  String get tokenizerNemoDescription;

  /// No description provided for @tokenizerBestMatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically choose a tokenizer based on the active model'**
  String get tokenizerBestMatchDescription;

  /// No description provided for @showOriginal.
  ///
  /// In en, this message translates to:
  /// **'Show original'**
  String get showOriginal;

  /// No description provided for @showOriginalDescription.
  ///
  /// In en, this message translates to:
  /// **'Display original text alongside the translation'**
  String get showOriginalDescription;

  /// No description provided for @swapLanguages.
  ///
  /// In en, this message translates to:
  /// **'Swap languages'**
  String get swapLanguages;

  /// No description provided for @aboutTranslation.
  ///
  /// In en, this message translates to:
  /// **'About translation'**
  String get aboutTranslation;

  /// No description provided for @aboutTranslationDescription.
  ///
  /// In en, this message translates to:
  /// **'Translate messages automatically or on demand so you can communicate in different languages.'**
  String get aboutTranslationDescription;

  /// No description provided for @googleTranslate.
  ///
  /// In en, this message translates to:
  /// **'Google Translate'**
  String get googleTranslate;

  /// No description provided for @googleTranslateDescription.
  ///
  /// In en, this message translates to:
  /// **'Uses Google Cloud Translation API and requires a Google Cloud API key.'**
  String get googleTranslateDescription;

  /// No description provided for @deepL.
  ///
  /// In en, this message translates to:
  /// **'DeepL'**
  String get deepL;

  /// No description provided for @deepLDescription.
  ///
  /// In en, this message translates to:
  /// **'High-quality neural machine translation. Requires an API key from deepl.com.'**
  String get deepLDescription;

  /// No description provided for @libreTranslate.
  ///
  /// In en, this message translates to:
  /// **'LibreTranslate'**
  String get libreTranslate;

  /// No description provided for @libreTranslateDescription.
  ///
  /// In en, this message translates to:
  /// **'Free and open-source translation that can be self-hosted or use a public instance.'**
  String get libreTranslateDescription;

  /// No description provided for @queueMessages.
  ///
  /// In en, this message translates to:
  /// **'Queue messages'**
  String get queueMessages;

  /// No description provided for @queueMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Queue multiple messages instead of interrupting the current speech'**
  String get queueMessagesDescription;

  /// No description provided for @loadingVoices.
  ///
  /// In en, this message translates to:
  /// **'Loading voices...'**
  String get loadingVoices;

  /// No description provided for @failedToLoadVoices.
  ///
  /// In en, this message translates to:
  /// **'Failed to load voices'**
  String get failedToLoadVoices;

  /// No description provided for @ttsTestPhrase.
  ///
  /// In en, this message translates to:
  /// **'Hello! This is a test of the text-to-speech system. The quick brown fox jumps over the lazy dog.'**
  String get ttsTestPhrase;

  /// No description provided for @aboutTts.
  ///
  /// In en, this message translates to:
  /// **'About text-to-speech'**
  String get aboutTts;

  /// No description provided for @aboutTtsDescription.
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech reads messages aloud. You can configure different voices for individual characters in character settings.'**
  String get aboutTtsDescription;

  /// No description provided for @systemTts.
  ///
  /// In en, this message translates to:
  /// **'System text-to-speech'**
  String get systemTts;

  /// No description provided for @systemTtsDetails.
  ///
  /// In en, this message translates to:
  /// **'Uses your device\'s built-in text-to-speech engine. Available voices depend on system settings.'**
  String get systemTtsDetails;

  /// No description provided for @elevenLabsDescription.
  ///
  /// In en, this message translates to:
  /// **'High-quality AI voices. Requires an API key from elevenlabs.io.'**
  String get elevenLabsDescription;

  /// No description provided for @clearGlobalVariables.
  ///
  /// In en, this message translates to:
  /// **'Clear global variables'**
  String get clearGlobalVariables;

  /// No description provided for @clearLocalVariables.
  ///
  /// In en, this message translates to:
  /// **'Clear local variables'**
  String get clearLocalVariables;

  /// No description provided for @aboutVariables.
  ///
  /// In en, this message translates to:
  /// **'About variables'**
  String get aboutVariables;

  /// No description provided for @variableSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Variables store reusable values globally or for the current chat. Reference them in prompts with macros.'**
  String get variableSystemDescription;

  /// No description provided for @macroUsage.
  ///
  /// In en, this message translates to:
  /// **'Macro usage'**
  String get macroUsage;

  /// No description provided for @macroUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'Use {localMacro} for local variables and {globalMacro} for global variables. You can also set values with variable macros.'**
  String macroUsageDescription(String localMacro, String globalMacro);

  /// No description provided for @noGlobalVariables.
  ///
  /// In en, this message translates to:
  /// **'No global variables'**
  String get noGlobalVariables;

  /// No description provided for @noLocalVariables.
  ///
  /// In en, this message translates to:
  /// **'No local variables'**
  String get noLocalVariables;

  /// No description provided for @editVariable.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editVariable(String name);

  /// No description provided for @deleteVariable.
  ///
  /// In en, this message translates to:
  /// **'Delete variable'**
  String get deleteVariable;

  /// No description provided for @deleteVariableQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete variable \"{name}\"?'**
  String deleteVariableQuestion(String name);

  /// No description provided for @clearVariables.
  ///
  /// In en, this message translates to:
  /// **'Clear {scope} variables'**
  String clearVariables(String scope);

  /// No description provided for @clearVariablesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Clear all {scope} variables? This cannot be undone.'**
  String clearVariablesConfirmation(String scope);

  /// No description provided for @decrement.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get decrement;

  /// No description provided for @increment.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get increment;

  /// No description provided for @testInput.
  ///
  /// In en, this message translates to:
  /// **'Test input'**
  String get testInput;

  /// No description provided for @variableTestHint.
  ///
  /// In en, this message translates to:
  /// **'Enter text containing variable macros...'**
  String get variableTestHint;

  /// No description provided for @processMacros.
  ///
  /// In en, this message translates to:
  /// **'Process macros'**
  String get processMacros;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @emptyString.
  ///
  /// In en, this message translates to:
  /// **'(empty string)'**
  String get emptyString;

  /// No description provided for @retrievalAugmentedGeneration.
  ///
  /// In en, this message translates to:
  /// **'Retrieval-augmented generation (RAG)'**
  String get retrievalAugmentedGeneration;

  /// No description provided for @searchSettings.
  ///
  /// In en, this message translates to:
  /// **'Search settings'**
  String get searchSettings;

  /// No description provided for @topKResultsDescription.
  ///
  /// In en, this message translates to:
  /// **'Return up to {count} matching results'**
  String topKResultsDescription(int count);

  /// No description provided for @minimumPercent.
  ///
  /// In en, this message translates to:
  /// **'Minimum similarity: {percent}%'**
  String minimumPercent(String percent);

  /// No description provided for @promptIntegration.
  ///
  /// In en, this message translates to:
  /// **'Prompt integration'**
  String get promptIntegration;

  /// No description provided for @includeInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Include in prompt'**
  String get includeInPrompt;

  /// No description provided for @automaticallyAddContext.
  ///
  /// In en, this message translates to:
  /// **'Automatically add relevant context to the prompt'**
  String get automaticallyAddContext;

  /// No description provided for @promptTemplate.
  ///
  /// In en, this message translates to:
  /// **'Prompt template'**
  String get promptTemplate;

  /// No description provided for @useContextPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Use {contextMacro} where retrieved content should appear'**
  String useContextPlaceholder(String contextMacro);

  /// No description provided for @vectorStorageHelp.
  ///
  /// In en, this message translates to:
  /// **'Vector storage help'**
  String get vectorStorageHelp;

  /// No description provided for @vectorStorageHelpContent.
  ///
  /// In en, this message translates to:
  /// **'Vector storage converts documents into embeddings and retrieves relevant passages for each message. Configure an embedding provider, create a collection, add documents, and enable prompt integration.'**
  String get vectorStorageHelpContent;

  /// No description provided for @enterCollectionName.
  ///
  /// In en, this message translates to:
  /// **'Enter collection name'**
  String get enterCollectionName;

  /// No description provided for @deleteCollection.
  ///
  /// In en, this message translates to:
  /// **'Delete collection'**
  String get deleteCollection;

  /// No description provided for @deleteCollectionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete this collection and all of its documents?'**
  String get deleteCollectionConfirmation;

  /// No description provided for @collectionExported.
  ///
  /// In en, this message translates to:
  /// **'Collection exported'**
  String get collectionExported;

  /// No description provided for @importCollection.
  ///
  /// In en, this message translates to:
  /// **'Import collection'**
  String get importCollection;

  /// No description provided for @pasteCollectionJson.
  ///
  /// In en, this message translates to:
  /// **'Paste collection JSON...'**
  String get pasteCollectionJson;

  /// No description provided for @collectionImported.
  ///
  /// In en, this message translates to:
  /// **'Collection imported'**
  String get collectionImported;

  /// No description provided for @activeCollection.
  ///
  /// In en, this message translates to:
  /// **'Active collection'**
  String get activeCollection;

  /// No description provided for @collectionWithDocumentCount.
  ///
  /// In en, this message translates to:
  /// **'{name} ({count} documents)'**
  String collectionWithDocumentCount(String name, int count);

  /// No description provided for @documentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} documents'**
  String documentsCount(int count);

  /// No description provided for @embeddedCount.
  ///
  /// In en, this message translates to:
  /// **'{percent} embedded'**
  String embeddedCount(String percent);

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addDocument;

  /// No description provided for @viewDocuments.
  ///
  /// In en, this message translates to:
  /// **'View documents'**
  String get viewDocuments;

  /// No description provided for @enterDocumentContent.
  ///
  /// In en, this message translates to:
  /// **'Enter document content'**
  String get enterDocumentContent;

  /// No description provided for @documentAdded.
  ///
  /// In en, this message translates to:
  /// **'Document added'**
  String get documentAdded;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get noDocuments;

  /// No description provided for @documentEmbeddingStatus.
  ///
  /// In en, this message translates to:
  /// **'{characters} characters - {status}'**
  String documentEmbeddingStatus(int characters, String status);

  /// No description provided for @embedded.
  ///
  /// In en, this message translates to:
  /// **'Embedded'**
  String get embedded;

  /// No description provided for @notEmbedded.
  ///
  /// In en, this message translates to:
  /// **'Not embedded'**
  String get notEmbedded;

  /// No description provided for @tokenProbabilities.
  ///
  /// In en, this message translates to:
  /// **'Token probabilities'**
  String get tokenProbabilities;

  /// No description provided for @requestTokenProbabilities.
  ///
  /// In en, this message translates to:
  /// **'Request token probabilities'**
  String get requestTokenProbabilities;

  /// No description provided for @requestTokenProbabilitiesDescription.
  ///
  /// In en, this message translates to:
  /// **'Ask the model to return probability data for generated tokens'**
  String get requestTokenProbabilitiesDescription;

  /// No description provided for @topCandidatesCount.
  ///
  /// In en, this message translates to:
  /// **'Top candidates'**
  String get topCandidatesCount;

  /// No description provided for @topCandidatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Show up to {count} alternatives per token'**
  String topCandidatesDescription(int count);

  /// No description provided for @showLogprobsPanel.
  ///
  /// In en, this message translates to:
  /// **'Show token probability panel'**
  String get showLogprobsPanel;

  /// No description provided for @showLogprobsPanelDescription.
  ///
  /// In en, this message translates to:
  /// **'Display token probabilities below supported messages'**
  String get showLogprobsPanelDescription;

  /// No description provided for @colorIntensity.
  ///
  /// In en, this message translates to:
  /// **'Color intensity'**
  String get colorIntensity;

  /// No description provided for @aboutTokenProbabilities.
  ///
  /// In en, this message translates to:
  /// **'About token probabilities'**
  String get aboutTokenProbabilities;

  /// No description provided for @tokenProbabilitiesDescription.
  ///
  /// In en, this message translates to:
  /// **'Token probabilities show how confident the model was and which alternatives it considered. Availability depends on the active API and model.'**
  String get tokenProbabilitiesDescription;

  /// No description provided for @moreFormatting.
  ///
  /// In en, this message translates to:
  /// **'More formatting'**
  String get moreFormatting;

  /// No description provided for @readAloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get readAloud;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get openInBrowser;

  /// No description provided for @imageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get imageLoadFailed;

  /// No description provided for @pauseReading.
  ///
  /// In en, this message translates to:
  /// **'Pause reading'**
  String get pauseReading;

  /// No description provided for @resumeReading.
  ///
  /// In en, this message translates to:
  /// **'Resume reading'**
  String get resumeReading;

  /// No description provided for @stopReading.
  ///
  /// In en, this message translates to:
  /// **'Stop reading'**
  String get stopReading;

  /// No description provided for @noTagsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tags available'**
  String get noTagsAvailable;

  /// No description provided for @rerollAlternativeNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Rerolling with \"{alternative}\" is not implemented yet'**
  String rerollAlternativeNotImplemented(String alternative);

  /// No description provided for @enableTokenProbabilitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Enable token probabilities in settings to view this data'**
  String get enableTokenProbabilitiesHint;

  /// No description provided for @noTokenProbabilities.
  ///
  /// In en, this message translates to:
  /// **'No token probability data available'**
  String get noTokenProbabilities;

  /// No description provided for @noAlternativeTokens.
  ///
  /// In en, this message translates to:
  /// **'No alternative tokens'**
  String get noAlternativeTokens;

  /// No description provided for @alternativeTokens.
  ///
  /// In en, this message translates to:
  /// **'Alternative tokens'**
  String get alternativeTokens;

  /// No description provided for @otherTokens.
  ///
  /// In en, this message translates to:
  /// **'Other tokens'**
  String get otherTokens;

  /// No description provided for @chooseRpgScenario.
  ///
  /// In en, this message translates to:
  /// **'Choose an RPG scenario'**
  String get chooseRpgScenario;

  /// No description provided for @importScenario.
  ///
  /// In en, this message translates to:
  /// **'Import scenario'**
  String get importScenario;

  /// No description provided for @noSavedScenarios.
  ///
  /// In en, this message translates to:
  /// **'No saved scenarios'**
  String get noSavedScenarios;

  /// No description provided for @rpgImportScenarioPackage.
  ///
  /// In en, this message translates to:
  /// **'Import RPG scenario package'**
  String get rpgImportScenarioPackage;

  /// No description provided for @rpgSelectedScenarioUnreadable.
  ///
  /// In en, this message translates to:
  /// **'The selected scenario file could not be read'**
  String get rpgSelectedScenarioUnreadable;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @connections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get connections;

  /// No description provided for @systemPromptOverride.
  ///
  /// In en, this message translates to:
  /// **'System prompt override'**
  String get systemPromptOverride;

  /// No description provided for @systemPromptOverrideHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a system prompt for this persona...'**
  String get systemPromptOverrideHint;

  /// No description provided for @systemPromptOverrideDescription.
  ///
  /// In en, this message translates to:
  /// **'Overrides the default system prompt while this persona is active'**
  String get systemPromptOverrideDescription;

  /// No description provided for @instructionsAddedAfterHistory.
  ///
  /// In en, this message translates to:
  /// **'Instructions added after chat history'**
  String get instructionsAddedAfterHistory;

  /// No description provided for @bindPersonaDescription.
  ///
  /// In en, this message translates to:
  /// **'Bind persona description'**
  String get bindPersonaDescription;

  /// No description provided for @noConnections.
  ///
  /// In en, this message translates to:
  /// **'No connections'**
  String get noConnections;

  /// No description provided for @connectionCharacter.
  ///
  /// In en, this message translates to:
  /// **'Character: {id}'**
  String connectionCharacter(String id);

  /// No description provided for @connectionGroup.
  ///
  /// In en, this message translates to:
  /// **'Group: {id}'**
  String connectionGroup(String id);

  /// No description provided for @connectionChat.
  ///
  /// In en, this message translates to:
  /// **'Chat: {id}'**
  String connectionChat(String id);

  /// No description provided for @lockLabel.
  ///
  /// In en, this message translates to:
  /// **'Lock: {type}'**
  String lockLabel(String type);

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTag;

  /// No description provided for @errorLoadingLorebooks.
  ///
  /// In en, this message translates to:
  /// **'Failed to load lorebooks: {error}'**
  String errorLoadingLorebooks(String error);

  /// No description provided for @personaLorebook.
  ///
  /// In en, this message translates to:
  /// **'Persona lorebook'**
  String get personaLorebook;

  /// No description provided for @selectLorebook.
  ///
  /// In en, this message translates to:
  /// **'Select a lorebook'**
  String get selectLorebook;

  /// No description provided for @personaLorebookDescription.
  ///
  /// In en, this message translates to:
  /// **'Lorebook linked to this persona'**
  String get personaLorebookDescription;

  /// No description provided for @descriptionPlacement.
  ///
  /// In en, this message translates to:
  /// **'Description placement'**
  String get descriptionPlacement;

  /// No description provided for @personaDescriptionPositionHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose where the persona description is inserted in the prompt'**
  String get personaDescriptionPositionHelp;

  /// No description provided for @depth.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get depth;

  /// No description provided for @depthInChatHistory.
  ///
  /// In en, this message translates to:
  /// **'Depth in chat history'**
  String get depthInChatHistory;

  /// No description provided for @messageRole.
  ///
  /// In en, this message translates to:
  /// **'Message role'**
  String get messageRole;

  /// No description provided for @roleForDescription.
  ///
  /// In en, this message translates to:
  /// **'Role used for the persona description'**
  String get roleForDescription;

  /// No description provided for @novelAiSettings.
  ///
  /// In en, this message translates to:
  /// **'NovelAI settings'**
  String get novelAiSettings;

  /// No description provided for @anlasGuard.
  ///
  /// In en, this message translates to:
  /// **'Anlas guard'**
  String get anlasGuard;

  /// No description provided for @anlasGuardDescription.
  ///
  /// In en, this message translates to:
  /// **'Prevent generation when the estimated Anlas cost is too high'**
  String get anlasGuardDescription;

  /// No description provided for @smea.
  ///
  /// In en, this message translates to:
  /// **'SMEA'**
  String get smea;

  /// No description provided for @smeaDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable SMEA sampling for improved image coherence'**
  String get smeaDescription;

  /// No description provided for @smeaDynamic.
  ///
  /// In en, this message translates to:
  /// **'Dynamic SMEA'**
  String get smeaDynamic;

  /// No description provided for @smeaDynamicDescription.
  ///
  /// In en, this message translates to:
  /// **'Dynamically adjust SMEA based on image dimensions'**
  String get smeaDynamicDescription;

  /// No description provided for @decrisper.
  ///
  /// In en, this message translates to:
  /// **'Decrisper'**
  String get decrisper;

  /// No description provided for @decrisperDescription.
  ///
  /// In en, this message translates to:
  /// **'Reduce overly sharp or crispy image details'**
  String get decrisperDescription;

  /// No description provided for @varietyPlus.
  ///
  /// In en, this message translates to:
  /// **'Variety+'**
  String get varietyPlus;

  /// No description provided for @varietyPlusDescription.
  ///
  /// In en, this message translates to:
  /// **'Increase variation between generated images'**
  String get varietyPlusDescription;

  /// No description provided for @gptImageApiDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate images through an OAI Compatible image API'**
  String get gptImageApiDescription;

  /// No description provided for @oaiCompatibleChat.
  ///
  /// In en, this message translates to:
  /// **'OAI Compatible Chat'**
  String get oaiCompatibleChat;

  /// No description provided for @oaiCompatibleChatDescription.
  ///
  /// In en, this message translates to:
  /// **'Generate images through an OAI Compatible chat completion endpoint'**
  String get oaiCompatibleChatDescription;

  /// No description provided for @errorFetchingModels.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch models'**
  String get errorFetchingModels;

  /// No description provided for @generatedPrompt.
  ///
  /// In en, this message translates to:
  /// **'Prompt: {prompt}'**
  String generatedPrompt(String prompt);

  /// No description provided for @generatedSeed.
  ///
  /// In en, this message translates to:
  /// **'Seed: {seed}'**
  String generatedSeed(String seed);

  /// No description provided for @imagesGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated {count} image(s)'**
  String imagesGenerated(int count);

  /// No description provided for @myTheme.
  ///
  /// In en, this message translates to:
  /// **'My theme'**
  String get myTheme;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @stopSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Stop speaking'**
  String get stopSpeaking;

  /// No description provided for @insertion.
  ///
  /// In en, this message translates to:
  /// **'Insertion'**
  String get insertion;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @scanDepth.
  ///
  /// In en, this message translates to:
  /// **'Scan depth'**
  String get scanDepth;

  /// No description provided for @scanDepthDescription.
  ///
  /// In en, this message translates to:
  /// **'Number of recent messages scanned for keywords'**
  String get scanDepthDescription;

  /// No description provided for @roleForInjectedContent.
  ///
  /// In en, this message translates to:
  /// **'Role used for injected content'**
  String get roleForInjectedContent;

  /// No description provided for @caseSensitive.
  ///
  /// In en, this message translates to:
  /// **'Case sensitive'**
  String get caseSensitive;

  /// No description provided for @matchKeywordsExactCase.
  ///
  /// In en, this message translates to:
  /// **'Match keywords using exact letter case'**
  String get matchKeywordsExactCase;

  /// No description provided for @matchWholeWords.
  ///
  /// In en, this message translates to:
  /// **'Match whole words'**
  String get matchWholeWords;

  /// No description provided for @onlyMatchCompleteWords.
  ///
  /// In en, this message translates to:
  /// **'Only match complete words'**
  String get onlyMatchCompleteWords;

  /// No description provided for @recursionControl.
  ///
  /// In en, this message translates to:
  /// **'Recursion control'**
  String get recursionControl;

  /// No description provided for @preventRecursion.
  ///
  /// In en, this message translates to:
  /// **'Prevent recursion'**
  String get preventRecursion;

  /// No description provided for @preventRecursionDescription.
  ///
  /// In en, this message translates to:
  /// **'Do not let this entry trigger additional entries'**
  String get preventRecursionDescription;

  /// No description provided for @excludeRecursion.
  ///
  /// In en, this message translates to:
  /// **'Exclude from recursion'**
  String get excludeRecursion;

  /// No description provided for @excludeRecursionDescription.
  ///
  /// In en, this message translates to:
  /// **'Do not activate this entry during recursive scans'**
  String get excludeRecursionDescription;

  /// No description provided for @delayUntilRecursion.
  ///
  /// In en, this message translates to:
  /// **'Delay until recursion'**
  String get delayUntilRecursion;

  /// No description provided for @delayUntilRecursionDescription.
  ///
  /// In en, this message translates to:
  /// **'Only activate this entry during recursive scans'**
  String get delayUntilRecursionDescription;

  /// No description provided for @characterFilter.
  ///
  /// In en, this message translates to:
  /// **'Character filter'**
  String get characterFilter;

  /// No description provided for @groupSettings.
  ///
  /// In en, this message translates to:
  /// **'Group settings'**
  String get groupSettings;

  /// No description provided for @groupMutuallyExclusive.
  ///
  /// In en, this message translates to:
  /// **'Mutually exclusive group'**
  String get groupMutuallyExclusive;

  /// No description provided for @useGroupScoring.
  ///
  /// In en, this message translates to:
  /// **'Use group scoring'**
  String get useGroupScoring;

  /// No description provided for @groupWeight.
  ///
  /// In en, this message translates to:
  /// **'Group weight'**
  String get groupWeight;

  /// No description provided for @groupWeightDescription.
  ///
  /// In en, this message translates to:
  /// **'Relative weight when choosing an entry from the group'**
  String get groupWeightDescription;

  /// No description provided for @groupOverride.
  ///
  /// In en, this message translates to:
  /// **'Group override'**
  String get groupOverride;

  /// No description provided for @groupPriority.
  ///
  /// In en, this message translates to:
  /// **'Group priority'**
  String get groupPriority;

  /// No description provided for @probability.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get probability;

  /// No description provided for @useProbability.
  ///
  /// In en, this message translates to:
  /// **'Use probability'**
  String get useProbability;

  /// No description provided for @randomActivationProbability.
  ///
  /// In en, this message translates to:
  /// **'Random chance for this entry to activate'**
  String get randomActivationProbability;

  /// No description provided for @probabilityPercent.
  ///
  /// In en, this message translates to:
  /// **'Activation probability: {percent}%'**
  String probabilityPercent(int percent);

  /// No description provided for @timedEffects.
  ///
  /// In en, this message translates to:
  /// **'Timed effects'**
  String get timedEffects;

  /// No description provided for @filterType.
  ///
  /// In en, this message translates to:
  /// **'Filter type'**
  String get filterType;

  /// No description provided for @characterIds.
  ///
  /// In en, this message translates to:
  /// **'Character IDs'**
  String get characterIds;

  /// No description provided for @stickyDuration.
  ///
  /// In en, this message translates to:
  /// **'Sticky duration'**
  String get stickyDuration;

  /// No description provided for @stickyDurationDescription.
  ///
  /// In en, this message translates to:
  /// **'Number of messages this entry remains active after matching'**
  String get stickyDurationDescription;

  /// No description provided for @cooldown.
  ///
  /// In en, this message translates to:
  /// **'Cooldown'**
  String get cooldown;

  /// No description provided for @cooldownDescription.
  ///
  /// In en, this message translates to:
  /// **'Number of messages before this entry can activate again'**
  String get cooldownDescription;

  /// No description provided for @delay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// No description provided for @delayDescription.
  ///
  /// In en, this message translates to:
  /// **'Number of messages before this entry becomes eligible'**
  String get delayDescription;

  /// No description provided for @outlet.
  ///
  /// In en, this message translates to:
  /// **'Outlet'**
  String get outlet;

  /// No description provided for @include.
  ///
  /// In en, this message translates to:
  /// **'Include'**
  String get include;

  /// No description provided for @exclude.
  ///
  /// In en, this message translates to:
  /// **'Exclude'**
  String get exclude;

  /// No description provided for @translatedFromLanguage.
  ///
  /// In en, this message translates to:
  /// **'Translated from {language}'**
  String translatedFromLanguage(String language);

  /// No description provided for @originalText.
  ///
  /// In en, this message translates to:
  /// **'Original: {text}'**
  String originalText(String text);

  /// No description provided for @loadingImage.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get loadingImage;

  /// No description provided for @backupIntervalNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get backupIntervalNever;

  /// No description provided for @backupIntervalHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get backupIntervalHourly;

  /// No description provided for @backupIntervalDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get backupIntervalDaily;

  /// No description provided for @backupIntervalWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get backupIntervalWeekly;

  /// No description provided for @backupIntervalMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get backupIntervalMonthly;

  /// No description provided for @restoreModeReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get restoreModeReplace;

  /// No description provided for @restoreModeReplaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Replace all local data with backup data'**
  String get restoreModeReplaceDescription;

  /// No description provided for @restoreModeMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get restoreModeMerge;

  /// No description provided for @restoreModeMergeDescription.
  ///
  /// In en, this message translates to:
  /// **'Merge backup with local data; newer data wins conflicts'**
  String get restoreModeMergeDescription;

  /// No description provided for @restoreModeAddNewOnly.
  ///
  /// In en, this message translates to:
  /// **'Add new only'**
  String get restoreModeAddNewOnly;

  /// No description provided for @restoreModeAddNewOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Only add new backup items and keep all existing data'**
  String get restoreModeAddNewOnlyDescription;

  /// No description provided for @sortNameAscending.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get sortNameAscending;

  /// No description provided for @sortNameDescending.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get sortNameDescending;

  /// No description provided for @sortNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewestFirst;

  /// No description provided for @sortOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldestFirst;

  /// No description provided for @sortRecentlyModified.
  ///
  /// In en, this message translates to:
  /// **'Recently modified'**
  String get sortRecentlyModified;

  /// No description provided for @sortLeastRecentlyModified.
  ///
  /// In en, this message translates to:
  /// **'Least recently modified'**
  String get sortLeastRecentlyModified;

  /// No description provided for @codeBlock.
  ///
  /// In en, this message translates to:
  /// **'Code block'**
  String get codeBlock;

  /// No description provided for @quote.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quote;

  /// No description provided for @heading1.
  ///
  /// In en, this message translates to:
  /// **'Heading 1'**
  String get heading1;

  /// No description provided for @heading2.
  ///
  /// In en, this message translates to:
  /// **'Heading 2'**
  String get heading2;

  /// No description provided for @heading3.
  ///
  /// In en, this message translates to:
  /// **'Heading 3'**
  String get heading3;

  /// No description provided for @bulletList.
  ///
  /// In en, this message translates to:
  /// **'Bullet list'**
  String get bulletList;

  /// No description provided for @numberedList.
  ///
  /// In en, this message translates to:
  /// **'Numbered list'**
  String get numberedList;

  /// No description provided for @horizontalRule.
  ///
  /// In en, this message translates to:
  /// **'Horizontal rule'**
  String get horizontalRule;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go home'**
  String get goHome;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get officialWebsite;

  /// No description provided for @mcpStreamableHttp.
  ///
  /// In en, this message translates to:
  /// **'Streamable HTTP'**
  String get mcpStreamableHttp;

  /// No description provided for @mcpLegacyHttpSse.
  ///
  /// In en, this message translates to:
  /// **'Legacy HTTP + SSE'**
  String get mcpLegacyHttpSse;

  /// No description provided for @chatWithName.
  ///
  /// In en, this message translates to:
  /// **'Chat with {name}'**
  String chatWithName(String name);

  /// No description provided for @noValidCharactersInGroup.
  ///
  /// In en, this message translates to:
  /// **'No valid characters in group'**
  String get noValidCharactersInGroup;

  /// No description provided for @aiDataSharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how remote AI handles your data'**
  String get aiDataSharingTitle;

  /// No description provided for @aiDataSharingIntroduction.
  ///
  /// In en, this message translates to:
  /// **'NativeTavern is local-first. When you use a remote AI feature, this device sends the required data directly to the provider you configured. NativeTavern does not proxy or store those requests.'**
  String get aiDataSharingIntroduction;

  /// No description provided for @aiDataSharingDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data that may be sent'**
  String get aiDataSharingDataTitle;

  /// No description provided for @aiDataSharingDataTypes.
  ///
  /// In en, this message translates to:
  /// **'- Your messages and relevant chat history\n- Character, persona and system instructions, lorebook, memory and tool inputs\n- Documents used for embeddings\n- Prompts and images used for image generation\n- Audio and text used for speech features'**
  String get aiDataSharingDataTypes;

  /// No description provided for @aiDataSharingRecipientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Who may receive it'**
  String get aiDataSharingRecipientsTitle;

  /// No description provided for @aiDataSharingRecipients.
  ///
  /// In en, this message translates to:
  /// **'Depending on your configuration: Anthropic, an OAI Compatible endpoint you configure, OpenRouter, Google Gemini, xAI (Grok), DeepSeek, Alibaba Qwen, SiliconFlow, Moonshot/Kimi, Z.AI, MiniMax, Cohere, ElevenLabs, Azure Speech, Volcengine, NovelAI, Pollinations, or another custom endpoint you enter.'**
  String get aiDataSharingRecipients;

  /// No description provided for @aiDataSharingControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Your choice'**
  String get aiDataSharingControlTitle;

  /// No description provided for @aiDataSharingControlDescription.
  ///
  /// In en, this message translates to:
  /// **'Remote providers process data under their own privacy policies. Your API credentials stay on this device except when used to authenticate directly with the selected provider. You can change this choice in Settings at any time. Local AI endpoints remain available without consent.'**
  String get aiDataSharingControlDescription;

  /// No description provided for @allowRemoteAi.
  ///
  /// In en, this message translates to:
  /// **'Allow remote AI'**
  String get allowRemoteAi;

  /// No description provided for @useLocalAiOnly.
  ///
  /// In en, this message translates to:
  /// **'Use local AI only'**
  String get useLocalAiOnly;

  /// No description provided for @aiDataSharingSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Remote AI data sharing'**
  String get aiDataSharingSettingsTitle;

  /// No description provided for @aiDataSharingAllowedDescription.
  ///
  /// In en, this message translates to:
  /// **'Allowed for providers and endpoints you configure'**
  String get aiDataSharingAllowedDescription;

  /// No description provided for @aiDataSharingLocalOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Blocked; local AI endpoints remain available'**
  String get aiDataSharingLocalOnlyDescription;

  /// Local and file backup section header
  ///
  /// In en, this message translates to:
  /// **'Local & File Backup'**
  String get localBackup;

  /// Local backup description
  ///
  /// In en, this message translates to:
  /// **'Export and import NativeTavern .ntx combined backups or .ntb data backups to your device storage or files app'**
  String get localBackupDescription;

  /// Export NTB backup button
  ///
  /// In en, this message translates to:
  /// **'Export Data Backup (.ntb)'**
  String get exportNtbBackup;

  /// Export NTB backup subtitle
  ///
  /// In en, this message translates to:
  /// **'Save JSON data only; media is stored separately as .ntm'**
  String get exportNtbBackupSubtitle;

  /// Export NTX combined backup button
  ///
  /// In en, this message translates to:
  /// **'Export Combined Backup (.ntx)'**
  String get exportNtxBackup;

  /// Export NTX backup subtitle
  ///
  /// In en, this message translates to:
  /// **'Save app data and media together in one .ntx file'**
  String get exportNtxBackupSubtitle;

  /// Import NTB backup button
  ///
  /// In en, this message translates to:
  /// **'Import Backup File (.ntb)'**
  String get importNtbBackup;

  /// Import NTB backup subtitle
  ///
  /// In en, this message translates to:
  /// **'Restore or merge data from a local .ntb file'**
  String get importNtbBackupSubtitle;

  /// Import NTX or NTB backup button
  ///
  /// In en, this message translates to:
  /// **'Import Backup (.ntx / .ntb)'**
  String get importNtxBackup;

  /// Import NTX backup subtitle
  ///
  /// In en, this message translates to:
  /// **'Restore or merge data from a combined .ntx file or a .ntb data backup'**
  String get importNtxBackupSubtitle;

  /// Save to files action button
  ///
  /// In en, this message translates to:
  /// **'Save to Files'**
  String get exportToFiles;

  /// Share backup action button
  ///
  /// In en, this message translates to:
  /// **'Share Backup'**
  String get shareBackup;

  /// Export options modal title
  ///
  /// In en, this message translates to:
  /// **'Export Options'**
  String get exportOptions;

  /// Select NTB file title
  ///
  /// In en, this message translates to:
  /// **'Select NativeTavern Backup (.ntb)'**
  String get selectNtbFile;

  /// Select NTB file description
  ///
  /// In en, this message translates to:
  /// **'Pick the .ntb backup file and optional .ntm media file'**
  String get selectNtbFileDescription;

  /// Select NTX or NTB backup file title
  ///
  /// In en, this message translates to:
  /// **'Select NativeTavern Backup'**
  String get selectNtxFile;

  /// Select NTX file description
  ///
  /// In en, this message translates to:
  /// **'Pick a .ntx combined backup, or a .ntb file with optional .ntm media'**
  String get selectNtxFileDescription;

  /// Snackbar after saving a backup through the system Files app
  ///
  /// In en, this message translates to:
  /// **'Backup saved to Files'**
  String get backupSavedToFilesApp;

  /// Snackbar when a backup is stored in the app Backups folder
  ///
  /// In en, this message translates to:
  /// **'Could not save to Files. Backup saved to NativeTavern/Backups.'**
  String get backupSavedToAppFolder;

  /// Snackbar after saving an export through the system Files app
  ///
  /// In en, this message translates to:
  /// **'Saved to Files'**
  String get savedToFilesApp;

  /// Explanation shown before importing a backup
  ///
  /// In en, this message translates to:
  /// **'Restore or merge characters, chats, settings, and media from this backup file.'**
  String get importBackupExplanation;

  /// Status text while restoring backup
  ///
  /// In en, this message translates to:
  /// **'Restoring backup...'**
  String get restoringBackup;

  /// Status text while exporting backup
  ///
  /// In en, this message translates to:
  /// **'Exporting backup...'**
  String get exportingBackup;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'it',
        'ja',
        'ko',
        'ms',
        'nl',
        'pl',
        'pt',
        'ru',
        'th',
        'tr',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
