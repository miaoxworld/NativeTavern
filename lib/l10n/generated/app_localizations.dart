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

  /// OpenAI provider name
  ///
  /// In en, this message translates to:
  /// **'OpenAI'**
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

  /// KoboldCpp provider name
  ///
  /// In en, this message translates to:
  /// **'KoboldCpp'**
  String get koboldCpp;

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

  /// World info screen title
  ///
  /// In en, this message translates to:
  /// **'World Info'**
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
  /// **'Instruct templates format prompts for different LLM models. Use \"None\" for API providers like OpenAI or Claude that handle formatting automatically.'**
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
  /// **'No characters available. Import some first.'**
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
  /// **'Chat backups save individual conversations. Full backups include all characters, chats, settings, and world info.'**
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
  /// **'OpenAI\'s DALL-E image generation. Requires an API key from OpenAI.'**
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
  /// **'Supports macros like \'{user}\', \'{char}\''**
  String supportsMacros(Object char, Object user);

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

  /// World info label
  ///
  /// In en, this message translates to:
  /// **'World Info'**
  String get worldInfoLabel;

  /// World info description
  ///
  /// In en, this message translates to:
  /// **'Apply to world info entries'**
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
  /// **'\$1, \$2, \'{match}\''**
  String replacementHint(Object match);

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
  /// **'OpenAI\'s Whisper model for high-accuracy transcription. Requires an API key.'**
  String get whisperDescription;

  /// Voice input tooltip
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get voiceInput;

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

  /// World info screen title
  ///
  /// In en, this message translates to:
  /// **'World Info / Lorebooks'**
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

  /// API key hint
  ///
  /// In en, this message translates to:
  /// **'sk-...'**
  String get apiKeyHint;

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
