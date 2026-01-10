// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Home';

  @override
  String get characters => 'Characters';

  @override
  String get settings => 'Settings';

  @override
  String get chats => 'Chats';

  @override
  String get newChat => 'New Chat';

  @override
  String get noChatsYet => 'No chats yet';

  @override
  String get startNewConversation =>
      'Start a new conversation with a character';

  @override
  String get browseCharacters => 'Browse Characters';

  @override
  String get groupChats => 'Group Chats';

  @override
  String get import => 'Import';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get copy => 'Copy';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String errorLoadingChats(String error) {
    return 'Error loading chats: $error';
  }

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String get deleteChatConfirmation =>
      'Are you sure you want to delete this chat? This action cannot be undone.';

  @override
  String get chatDeleted => 'Chat deleted';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get noMessages => 'No messages';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get chat => 'Chat';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get send => 'Send';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get continueGeneration => 'Continue';

  @override
  String get viewCharacter => 'View Character';

  @override
  String get authorsNote => 'Author\'s Note';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get exportChat => 'Export Chat';

  @override
  String get importChat => 'Import Chat';

  @override
  String get clearMessages => 'Clear Messages';

  @override
  String get selectModel => 'Select Model';

  @override
  String get loadingModels => 'Loading models...';

  @override
  String get noModelsAvailable =>
      'No models available. Check your API configuration.';

  @override
  String modelChangedTo(String model) {
    return 'Model changed to $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Failed to load models: $error';
  }

  @override
  String get searchModels => 'Search models...';

  @override
  String get noModelsMatchSearch => 'No models match your search';

  @override
  String get provider => 'Provider';

  @override
  String get apiNotConfigured => 'API Not Configured';

  @override
  String get apiNotConfiguredMessage =>
      'To chat with characters, you need to configure an LLM provider first.';

  @override
  String get supportedProviders => 'Supported providers:';

  @override
  String get configureNow => 'Configure Now';

  @override
  String get later => 'Later';

  @override
  String get configure => 'Configure';

  @override
  String get configureApiProvider =>
      'Configure an LLM provider to start chatting';

  @override
  String get startConversation => 'Start a conversation';

  @override
  String get deleteMessage => 'Delete Message';

  @override
  String get deleteMessageConfirmation =>
      'Are you sure you want to delete this message?';

  @override
  String get deleteMessages => 'Delete Messages';

  @override
  String get deleteMessagesConfirmation =>
      'Are you sure you want to delete this message and all messages after it?';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get generateNewResponse => 'Generate a new response alternative';

  @override
  String get continueFromHere => 'Continue from here';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Delete messages after and regenerate response';

  @override
  String get deleteMessagesAfterThis => 'Delete messages after this one';

  @override
  String get createBookmark => 'Create Bookmark';

  @override
  String get saveAsCheckpoint => 'Save this point as a checkpoint';

  @override
  String get deleteThisMessage => 'Delete this message';

  @override
  String get deleteThisAndAllAfter => 'Delete this and all after';

  @override
  String get attachImage => 'Attach image';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String failedToPickImage(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Failed to take photo: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Failed to add attachment: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Export chat with $character';
  }

  @override
  String messagesCount(int count) {
    return '$count messages';
  }

  @override
  String get chooseExportFormat => 'Choose export format:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST Format)';

  @override
  String get noChatToExport => 'No chat to export';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get importChatHistory => 'Import chat history from a file.';

  @override
  String get supportedFormats => 'Supported formats:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern format)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern format)';

  @override
  String get importNote =>
      'Note: Imported messages will be added to the current chat.';

  @override
  String get chooseFile => 'Choose File';

  @override
  String get noFileSelected => 'No file selected or invalid format';

  @override
  String get importConfirmation => 'Import Confirmation';

  @override
  String get character => 'Character';

  @override
  String get user => 'User';

  @override
  String get messages => 'Messages';

  @override
  String get date => 'Date';

  @override
  String get hasAuthorsNote => 'Has Author\'s Note';

  @override
  String get importMessagesToCurrentChat =>
      'Import these messages to the current chat?';

  @override
  String get noActiveChat => 'No active chat';

  @override
  String importedMessages(int count) {
    return 'Imported $count messages';
  }

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Are you sure you want to clear all messages? This cannot be undone.';

  @override
  String get clear => 'Clear';

  @override
  String get thinking => 'Thinking';

  @override
  String get noSwipesAvailable => 'No swipes available';

  @override
  String get system => 'System';

  @override
  String get backgroundFeatureComingSoon => 'Background feature coming soon';

  @override
  String get authorsNoteUpdated => 'Author\'s note updated';

  @override
  String get commandError => 'Command Error';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get personas => 'Personas';

  @override
  String get createPersona => 'Create Persona';

  @override
  String get editPersona => 'Edit Persona';

  @override
  String get deletePersona => 'Delete Persona';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get noPersonasYet => 'No personas yet';

  @override
  String get createPersonaDescription =>
      'Create a persona to represent yourself in chats';

  @override
  String get name => 'Name';

  @override
  String get enterPersonaName => 'Enter persona name';

  @override
  String get description => 'Description';

  @override
  String get describePersona => 'Describe this persona (optional)';

  @override
  String get personaDescriptionHelp =>
      'The description will be included in the system prompt to help the AI understand who you are.';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get default_ => 'Default';

  @override
  String get active => 'Active';

  @override
  String get setAsDefault => 'Set as Default';

  @override
  String get removeAvatar => 'Remove Avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Failed to save avatar: $error';
  }

  @override
  String get selectAvatarImage => 'Select Avatar Image';

  @override
  String get aiConfiguration => 'AI Configuration';

  @override
  String get llmProvider => 'LLM Provider';

  @override
  String get apiUrl => 'API URL';

  @override
  String get apiKey => 'API Key';

  @override
  String get model => 'Model';

  @override
  String get temperature => 'Temperature';

  @override
  String get maxTokens => 'Max Tokens';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Frequency Penalty';

  @override
  String get presencePenalty => 'Presence Penalty';

  @override
  String get repetitionPenalty => 'Repetition Penalty';

  @override
  String get streamingEnabled => 'Streaming Enabled';

  @override
  String get testConnection => 'Test Connection';

  @override
  String get connectionSuccessful => 'Connection successful!';

  @override
  String connectionFailed(String error) {
    return 'Connection failed: $error';
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
  String get local => 'Local';

  @override
  String get aiPresets => 'AI Presets';

  @override
  String get createPreset => 'Create Preset';

  @override
  String get editPreset => 'Edit Preset';

  @override
  String get deletePreset => 'Delete Preset';

  @override
  String get presetName => 'Preset Name';

  @override
  String get promptManager => 'Prompt Manager';

  @override
  String get systemPrompt => 'System Prompt';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'World Info';

  @override
  String get createEntry => 'Create Entry';

  @override
  String get editEntry => 'Edit Entry';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String get keywords => 'Keywords';

  @override
  String get content => 'Content';

  @override
  String get priority => 'Priority';

  @override
  String get groups => 'Groups';

  @override
  String get createGroup => 'Create Group';

  @override
  String get editGroup => 'Edit Group';

  @override
  String get deleteGroup => 'Delete Group';

  @override
  String get groupName => 'Group Name';

  @override
  String get members => 'Members';

  @override
  String get addMember => 'Add Member';

  @override
  String get removeMember => 'Remove Member';

  @override
  String get tags => 'Tags';

  @override
  String get createTag => 'Create Tag';

  @override
  String get editTag => 'Edit Tag';

  @override
  String get deleteTag => 'Delete Tag';

  @override
  String get tagName => 'Tag Name';

  @override
  String get color => 'Color';

  @override
  String get quickReplies => 'Quick Replies';

  @override
  String get createQuickReply => 'Create Quick Reply';

  @override
  String get editQuickReply => 'Edit Quick Reply';

  @override
  String get deleteQuickReply => 'Delete Quick Reply';

  @override
  String get label => 'Label';

  @override
  String get message => 'Message';

  @override
  String get autoSend => 'Auto Send';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Create Regex';

  @override
  String get editRegex => 'Edit Regex';

  @override
  String get deleteRegex => 'Delete Regex';

  @override
  String get pattern => 'Pattern';

  @override
  String get replacement => 'Replacement';

  @override
  String get backup => 'Backup';

  @override
  String get createBackup => 'Create Backup';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String get backupCreated => 'Backup created successfully';

  @override
  String get backupRestored => 'Backup restored successfully';

  @override
  String backupFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get advanced => 'Advanced';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalChats => 'Total Chats';

  @override
  String get totalMessages => 'Total Messages';

  @override
  String get totalCharacters => 'Total Characters';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get stt => 'Speech-to-Text';

  @override
  String get translation => 'Translation';

  @override
  String get imageGeneration => 'Image Generation';

  @override
  String get vectorStorage => 'Vector Storage';

  @override
  String get sprites => 'Sprites';

  @override
  String get backgrounds => 'Backgrounds';

  @override
  String get cfgScale => 'CFG Scale';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Variables';

  @override
  String get listView => 'List view';

  @override
  String get gridView => 'Grid view';

  @override
  String get search => 'Search';

  @override
  String get searchCharacters => 'Search characters...';

  @override
  String get noCharactersFound => 'No characters found';

  @override
  String get noCharactersYet => 'No characters yet';

  @override
  String get importCharacter => 'Import a character to get started';

  @override
  String get createCharacter => 'Create Character';

  @override
  String get editCharacter => 'Edit Character';

  @override
  String get deleteCharacter => 'Delete Character';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"? This will also delete all chats with this character.';
  }

  @override
  String get characterDeleted => 'Character deleted';

  @override
  String get startChat => 'Start Chat';

  @override
  String get personality => 'Personality';

  @override
  String get scenario => 'Scenario';

  @override
  String get firstMessage => 'First Message';

  @override
  String get exampleDialogue => 'Example Dialogue';

  @override
  String get creatorNotes => 'Creator Notes';

  @override
  String get alternateGreetings => 'Alternate Greetings';

  @override
  String get characterBook => 'Character Book';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get licenses => 'Licenses';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get noUpdatesAvailable => 'No updates available';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get downloadUpdate => 'Download Update';

  @override
  String get bookmarkCreated => 'Bookmark created';

  @override
  String get bookmarkName => 'Bookmark Name';

  @override
  String get enterBookmarkName => 'Enter bookmark name';

  @override
  String get noBookmarksYet => 'No bookmarks yet';

  @override
  String get createBookmarkDescription =>
      'Create bookmarks to save important points in your conversation';

  @override
  String get jumpToBookmark => 'Jump to Bookmark';

  @override
  String get deleteBookmark => 'Delete Bookmark';

  @override
  String get bookmarkDeleted => 'Bookmark deleted';

  @override
  String get saveAsJsonl => 'Save as JSONL';

  @override
  String get saveAsJson => 'Save as JSON';

  @override
  String get keyboardShortcuts => 'Keyboard shortcuts:';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get underline => 'Underline';

  @override
  String get strikethrough => 'Strikethrough';

  @override
  String get inlineCode => 'Inline code';

  @override
  String get link => 'Link';

  @override
  String get slashCommands => 'Slash Commands';

  @override
  String get availableCommands => 'Available commands:';

  @override
  String get commandHelp => 'Type / to see available commands';
}
