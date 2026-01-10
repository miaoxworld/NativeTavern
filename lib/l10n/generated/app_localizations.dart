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

  /// Import character description
  ///
  /// In en, this message translates to:
  /// **'Import a character to get started'**
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
