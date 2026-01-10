// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => '首页';

  @override
  String get characters => '角色';

  @override
  String get settings => '设置';

  @override
  String get chats => '聊天';

  @override
  String get newChat => '新建聊天';

  @override
  String get noChatsYet => '暂无聊天';

  @override
  String get startNewConversation => '开始与角色对话';

  @override
  String get browseCharacters => '浏览角色';

  @override
  String get groupChats => '群聊';

  @override
  String get import => '导入';

  @override
  String get delete => '删除';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get edit => '编辑';

  @override
  String get copy => '复制';

  @override
  String get retry => '重试';

  @override
  String get close => '关闭';

  @override
  String get ok => '确定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String errorLoadingChats(String error) {
    return '加载聊天失败：$error';
  }

  @override
  String get deleteChat => '删除聊天';

  @override
  String get deleteChatConfirmation => '确定要删除此聊天吗？此操作无法撤销。';

  @override
  String get chatDeleted => '聊天已删除';

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String get noMessages => '暂无消息';

  @override
  String get noMessagesYet => '暂无消息';

  @override
  String get chat => '聊天';

  @override
  String get typeMessage => '输入消息...';

  @override
  String get send => '发送';

  @override
  String get regenerate => '重新生成';

  @override
  String get continueGeneration => '继续';

  @override
  String get viewCharacter => '查看角色';

  @override
  String get authorsNote => '作者注释';

  @override
  String get bookmarks => '书签';

  @override
  String get exportChat => '导出聊天';

  @override
  String get importChat => '导入聊天';

  @override
  String get clearMessages => '清空消息';

  @override
  String get selectModel => '选择模型';

  @override
  String get loadingModels => '加载模型中...';

  @override
  String get noModelsAvailable => '没有可用的模型。请检查API配置。';

  @override
  String modelChangedTo(String model) {
    return '模型已切换为 $model';
  }

  @override
  String failedToLoadModels(String error) {
    return '加载模型失败：$error';
  }

  @override
  String get searchModels => '搜索模型...';

  @override
  String get noModelsMatchSearch => '没有匹配的模型';

  @override
  String get provider => '提供商';

  @override
  String get apiNotConfigured => 'API未配置';

  @override
  String get apiNotConfiguredMessage => '要与角色聊天，您需要先配置LLM提供商。';

  @override
  String get supportedProviders => '支持的提供商：';

  @override
  String get configureNow => '立即配置';

  @override
  String get later => '稍后';

  @override
  String get configure => '配置';

  @override
  String get configureApiProvider => '配置LLM提供商以开始聊天';

  @override
  String get startConversation => '开始对话';

  @override
  String get deleteMessage => '删除消息';

  @override
  String get deleteMessageConfirmation => '确定要删除此消息吗？';

  @override
  String get deleteMessages => '删除消息';

  @override
  String get deleteMessagesConfirmation => '确定要删除此消息及之后的所有消息吗？';

  @override
  String get deleteAll => '全部删除';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get generateNewResponse => '生成新的回复';

  @override
  String get continueFromHere => '从此处继续';

  @override
  String get deleteMessagesAfterAndRegenerate => '删除之后的消息并重新生成回复';

  @override
  String get deleteMessagesAfterThis => '删除此消息之后的所有消息';

  @override
  String get createBookmark => '创建书签';

  @override
  String get saveAsCheckpoint => '将此处保存为检查点';

  @override
  String get deleteThisMessage => '删除此消息';

  @override
  String get deleteThisAndAllAfter => '删除此消息及之后的所有消息';

  @override
  String get attachImage => '附加图片';

  @override
  String get chooseFromGallery => '从相册选择';

  @override
  String get takePhoto => '拍照';

  @override
  String failedToPickImage(String error) {
    return '选择图片失败：$error';
  }

  @override
  String failedToTakePhoto(String error) {
    return '拍照失败：$error';
  }

  @override
  String failedToAddAttachment(String error) {
    return '添加附件失败：$error';
  }

  @override
  String exportChatWith(String character) {
    return '导出与 $character 的聊天';
  }

  @override
  String messagesCount(int count) {
    return '$count 条消息';
  }

  @override
  String get chooseExportFormat => '选择导出格式：';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST格式)';

  @override
  String get noChatToExport => '没有可导出的聊天';

  @override
  String exportFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String get importChatHistory => '从文件导入聊天记录。';

  @override
  String get supportedFormats => '支持的格式：';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern格式)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern格式)';

  @override
  String get importNote => '注意：导入的消息将添加到当前聊天中。';

  @override
  String get chooseFile => '选择文件';

  @override
  String get noFileSelected => '未选择文件或格式无效';

  @override
  String get importConfirmation => '导入确认';

  @override
  String get character => '角色';

  @override
  String get user => '用户';

  @override
  String get messages => '消息';

  @override
  String get date => '日期';

  @override
  String get hasAuthorsNote => '包含作者注释';

  @override
  String get importMessagesToCurrentChat => '将这些消息导入到当前聊天？';

  @override
  String get noActiveChat => '没有活动的聊天';

  @override
  String importedMessages(int count) {
    return '已导入 $count 条消息';
  }

  @override
  String importFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get clearMessagesConfirmation => '确定要清空所有消息吗？此操作无法撤销。';

  @override
  String get clear => '清空';

  @override
  String get thinking => '思考中';

  @override
  String get noSwipesAvailable => '没有可用的滑动';

  @override
  String get system => '系统';

  @override
  String get backgroundFeatureComingSoon => '背景功能即将推出';

  @override
  String get authorsNoteUpdated => '作者注释已更新';

  @override
  String get commandError => '命令错误';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get personas => '人设';

  @override
  String get createPersona => '创建人设';

  @override
  String get editPersona => '编辑人设';

  @override
  String get deletePersona => '删除人设';

  @override
  String deletePersonaConfirmation(String name) {
    return '确定要删除\"$name\"吗？';
  }

  @override
  String get noPersonasYet => '暂无人设';

  @override
  String get createPersonaDescription => '创建人设以在聊天中代表自己';

  @override
  String get name => '名称';

  @override
  String get enterPersonaName => '输入人设名称';

  @override
  String get description => '描述';

  @override
  String get describePersona => '描述此人设（可选）';

  @override
  String get personaDescriptionHelp => '描述将包含在系统提示中，帮助AI了解您是谁。';

  @override
  String get pleaseEnterName => '请输入名称';

  @override
  String get default_ => '默认';

  @override
  String get active => '活动';

  @override
  String get setAsDefault => '设为默认';

  @override
  String get removeAvatar => '移除头像';

  @override
  String failedToSaveAvatar(String error) {
    return '保存头像失败：$error';
  }

  @override
  String get selectAvatarImage => '选择头像图片';

  @override
  String get aiConfiguration => 'AI配置';

  @override
  String get llmProvider => 'LLM提供商';

  @override
  String get apiUrl => 'API地址';

  @override
  String get apiKey => 'API密钥';

  @override
  String get model => '模型';

  @override
  String get temperature => '温度';

  @override
  String get maxTokens => '最大令牌数';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => '频率惩罚';

  @override
  String get presencePenalty => '存在惩罚';

  @override
  String get repetitionPenalty => '重复惩罚';

  @override
  String get streamingEnabled => '启用流式传输';

  @override
  String get testConnection => '测试连接';

  @override
  String get connectionSuccessful => '连接成功！';

  @override
  String connectionFailed(String error) {
    return '连接失败：$error';
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
  String get local => '本地';

  @override
  String get aiPresets => 'AI预设';

  @override
  String get createPreset => '创建预设';

  @override
  String get editPreset => '编辑预设';

  @override
  String get deletePreset => '删除预设';

  @override
  String get presetName => '预设名称';

  @override
  String get promptManager => '提示词管理';

  @override
  String get systemPrompt => '系统提示';

  @override
  String get jailbreak => '越狱提示';

  @override
  String get worldInfo => '世界信息';

  @override
  String get createEntry => '创建条目';

  @override
  String get editEntry => '编辑条目';

  @override
  String get deleteEntry => '删除条目';

  @override
  String get keywords => '关键词';

  @override
  String get content => '内容';

  @override
  String get priority => '优先级';

  @override
  String get groups => '群组';

  @override
  String get createGroup => '创建群组';

  @override
  String get editGroup => '编辑群组';

  @override
  String get deleteGroup => '删除群组';

  @override
  String get groupName => '群组名称';

  @override
  String get members => '成员';

  @override
  String get addMember => '添加成员';

  @override
  String get removeMember => '移除成员';

  @override
  String get tags => '标签';

  @override
  String get createTag => '创建标签';

  @override
  String get editTag => '编辑标签';

  @override
  String get deleteTag => '删除标签';

  @override
  String get tagName => '标签名称';

  @override
  String get color => '颜色';

  @override
  String get quickReplies => '快捷回复';

  @override
  String get createQuickReply => '创建快捷回复';

  @override
  String get editQuickReply => '编辑快捷回复';

  @override
  String get deleteQuickReply => '删除快捷回复';

  @override
  String get label => '标签';

  @override
  String get message => '消息';

  @override
  String get autoSend => '自动发送';

  @override
  String get regex => '正则表达式';

  @override
  String get createRegex => '创建正则';

  @override
  String get editRegex => '编辑正则';

  @override
  String get deleteRegex => '删除正则';

  @override
  String get pattern => '模式';

  @override
  String get replacement => '替换';

  @override
  String get backup => '备份';

  @override
  String get createBackup => '创建备份';

  @override
  String get restoreBackup => '恢复备份';

  @override
  String get backupCreated => '备份创建成功';

  @override
  String get backupRestored => '备份恢复成功';

  @override
  String backupFailed(String error) {
    return '备份失败：$error';
  }

  @override
  String restoreFailed(String error) {
    return '恢复失败：$error';
  }

  @override
  String get theme => '主题';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '浅色模式';

  @override
  String get systemTheme => '跟随系统';

  @override
  String get primaryColor => '主色调';

  @override
  String get accentColor => '强调色';

  @override
  String get advanced => '高级';

  @override
  String get advancedSettings => '高级设置';

  @override
  String get statistics => '统计';

  @override
  String get totalChats => '总聊天数';

  @override
  String get totalMessages => '总消息数';

  @override
  String get totalCharacters => '总角色数';

  @override
  String get tokenizer => '分词器';

  @override
  String get tts => '文字转语音';

  @override
  String get stt => '语音转文字';

  @override
  String get translation => '翻译';

  @override
  String get imageGeneration => '图像生成';

  @override
  String get vectorStorage => '向量存储';

  @override
  String get sprites => '精灵图';

  @override
  String get backgrounds => '背景';

  @override
  String get cfgScale => 'CFG比例';

  @override
  String get logitBias => 'Logit偏置';

  @override
  String get variables => '变量';

  @override
  String get listView => '列表视图';

  @override
  String get gridView => '网格视图';

  @override
  String get search => '搜索';

  @override
  String get searchCharacters => '搜索角色...';

  @override
  String get noCharactersFound => '未找到角色';

  @override
  String get noCharactersYet => '暂无角色';

  @override
  String get importCharacter => '导入角色以开始';

  @override
  String get createCharacter => '创建角色';

  @override
  String get editCharacter => '编辑角色';

  @override
  String get deleteCharacter => '删除角色';

  @override
  String deleteCharacterConfirmation(String name) {
    return '确定要删除\"$name\"吗？这也将删除与此角色的所有聊天。';
  }

  @override
  String get characterDeleted => '角色已删除';

  @override
  String get startChat => '开始聊天';

  @override
  String get personality => '性格';

  @override
  String get scenario => '场景';

  @override
  String get firstMessage => '开场白';

  @override
  String get exampleDialogue => '示例对话';

  @override
  String get creatorNotes => '创作者注释';

  @override
  String get alternateGreetings => '备选问候语';

  @override
  String get characterBook => '角色书';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get languageChanged => '语言已更改';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get licenses => '许可证';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get feedback => '反馈';

  @override
  String get rateApp => '评价应用';

  @override
  String get shareApp => '分享应用';

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get noUpdatesAvailable => '没有可用更新';

  @override
  String get updateAvailable => '有可用更新';

  @override
  String get downloadUpdate => '下载更新';

  @override
  String get bookmarkCreated => '书签已创建';

  @override
  String get bookmarkName => '书签名称';

  @override
  String get enterBookmarkName => '输入书签名称';

  @override
  String get noBookmarksYet => '暂无书签';

  @override
  String get createBookmarkDescription => '创建书签以保存对话中的重要节点';

  @override
  String get jumpToBookmark => '跳转到书签';

  @override
  String get deleteBookmark => '删除书签';

  @override
  String get bookmarkDeleted => '书签已删除';

  @override
  String get saveAsJsonl => '保存为JSONL';

  @override
  String get saveAsJson => '保存为JSON';

  @override
  String get keyboardShortcuts => '键盘快捷键：';

  @override
  String get bold => '粗体';

  @override
  String get italic => '斜体';

  @override
  String get underline => '下划线';

  @override
  String get strikethrough => '删除线';

  @override
  String get inlineCode => '行内代码';

  @override
  String get link => '链接';

  @override
  String get slashCommands => '斜杠命令';

  @override
  String get availableCommands => '可用命令：';

  @override
  String get commandHelp => '输入 / 查看可用命令';

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
      'Instruct templates format prompts for different LLM models. Use \"None\" for API providers like OpenAI or Claude that handle formatting automatically.';

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
  String get noCharactersAvailable =>
      'No characters available. Import some first.';

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
      'Chat backups save individual conversations. Full backups include all characters, chats, settings, and world info.';

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
      'OpenAI\'s DALL-E image generation. Requires an API key from OpenAI.';

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
  String supportsMacros(Object char, Object user) {
    return 'Supports macros like \'$user\', \'$char\'';
  }

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
  String get worldInfoLabel => 'World Info';

  @override
  String get applyToWorldInfoEntries => 'Apply to world info entries';

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
  String replacementHint(Object match) {
    return '\$1, \$2, \'$match\'';
  }

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
      'OpenAI\'s Whisper model for high-accuracy transcription. Requires an API key.';

  @override
  String get voiceInput => 'Voice input';

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
  String get worldInfoLorebooks => 'World Info / Lorebooks';

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
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => '首頁';

  @override
  String get characters => '角色';

  @override
  String get settings => '設定';

  @override
  String get chats => '聊天';

  @override
  String get newChat => '新建聊天';

  @override
  String get noChatsYet => '尚無聊天';

  @override
  String get startNewConversation => '開始與角色對話';

  @override
  String get browseCharacters => '瀏覽角色';

  @override
  String get groupChats => '群組聊天';

  @override
  String get import => '匯入';

  @override
  String get delete => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String get edit => '編輯';

  @override
  String get copy => '複製';

  @override
  String get retry => '重試';

  @override
  String get close => '關閉';

  @override
  String get ok => '確定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get loading => '載入中...';

  @override
  String get error => '錯誤';

  @override
  String errorLoadingChats(String error) {
    return '載入聊天失敗：$error';
  }

  @override
  String get deleteChat => '刪除聊天';

  @override
  String get deleteChatConfirmation => '確定要刪除此聊天嗎？此操作無法復原。';

  @override
  String get chatDeleted => '聊天已刪除';

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String get noMessages => '尚無訊息';

  @override
  String get noMessagesYet => '尚無訊息';

  @override
  String get chat => '聊天';

  @override
  String get typeMessage => '輸入訊息...';

  @override
  String get send => '傳送';

  @override
  String get regenerate => '重新生成';

  @override
  String get continueGeneration => '繼續';

  @override
  String get viewCharacter => '檢視角色';

  @override
  String get authorsNote => '作者註記';

  @override
  String get bookmarks => '書籤';

  @override
  String get exportChat => '匯出聊天';

  @override
  String get importChat => '匯入聊天';

  @override
  String get clearMessages => '清除訊息';

  @override
  String get selectModel => '選擇模型';

  @override
  String get loadingModels => '載入模型中...';

  @override
  String get noModelsAvailable => '沒有可用的模型。請檢查API設定。';

  @override
  String modelChangedTo(String model) {
    return '模型已切換為 $model';
  }

  @override
  String failedToLoadModels(String error) {
    return '載入模型失敗：$error';
  }

  @override
  String get searchModels => '搜尋模型...';

  @override
  String get noModelsMatchSearch => '沒有符合的模型';

  @override
  String get provider => '提供者';

  @override
  String get apiNotConfigured => 'API未設定';

  @override
  String get apiNotConfiguredMessage => '要與角色聊天，您需要先設定LLM提供者。';

  @override
  String get supportedProviders => '支援的提供者：';

  @override
  String get configureNow => '立即設定';

  @override
  String get later => '稍後';

  @override
  String get configure => '設定';

  @override
  String get configureApiProvider => '設定LLM提供者以開始聊天';

  @override
  String get startConversation => '開始對話';

  @override
  String get deleteMessage => '刪除訊息';

  @override
  String get deleteMessageConfirmation => '確定要刪除此訊息嗎？';

  @override
  String get deleteMessages => '刪除訊息';

  @override
  String get deleteMessagesConfirmation => '確定要刪除此訊息及之後的所有訊息嗎？';

  @override
  String get deleteAll => '全部刪除';

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get generateNewResponse => '生成新的回覆';

  @override
  String get continueFromHere => '從此處繼續';

  @override
  String get deleteMessagesAfterAndRegenerate => '刪除之後的訊息並重新生成回覆';

  @override
  String get deleteMessagesAfterThis => '刪除此訊息之後的所有訊息';

  @override
  String get createBookmark => '建立書籤';

  @override
  String get saveAsCheckpoint => '將此處儲存為檢查點';

  @override
  String get deleteThisMessage => '刪除此訊息';

  @override
  String get deleteThisAndAllAfter => '刪除此訊息及之後的所有訊息';

  @override
  String get attachImage => '附加圖片';

  @override
  String get chooseFromGallery => '從相簿選擇';

  @override
  String get takePhoto => '拍照';

  @override
  String failedToPickImage(String error) {
    return '選擇圖片失敗：$error';
  }

  @override
  String failedToTakePhoto(String error) {
    return '拍照失敗：$error';
  }

  @override
  String failedToAddAttachment(String error) {
    return '新增附件失敗：$error';
  }

  @override
  String exportChatWith(String character) {
    return '匯出與 $character 的聊天';
  }

  @override
  String messagesCount(int count) {
    return '$count 則訊息';
  }

  @override
  String get chooseExportFormat => '選擇匯出格式：';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST格式)';

  @override
  String get noChatToExport => '沒有可匯出的聊天';

  @override
  String exportFailed(String error) {
    return '匯出失敗：$error';
  }

  @override
  String get importChatHistory => '從檔案匯入聊天記錄。';

  @override
  String get supportedFormats => '支援的格式：';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern格式)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern格式)';

  @override
  String get importNote => '注意：匯入的訊息將新增到目前的聊天中。';

  @override
  String get chooseFile => '選擇檔案';

  @override
  String get noFileSelected => '未選擇檔案或格式無效';

  @override
  String get importConfirmation => '匯入確認';

  @override
  String get character => '角色';

  @override
  String get user => '使用者';

  @override
  String get messages => '訊息';

  @override
  String get date => '日期';

  @override
  String get hasAuthorsNote => '包含作者註記';

  @override
  String get importMessagesToCurrentChat => '將這些訊息匯入到目前的聊天？';

  @override
  String get noActiveChat => '沒有進行中的聊天';

  @override
  String importedMessages(int count) {
    return '已匯入 $count 則訊息';
  }

  @override
  String importFailed(String error) {
    return '匯入失敗：$error';
  }

  @override
  String get clearMessagesConfirmation => '確定要清除所有訊息嗎？此操作無法復原。';

  @override
  String get clear => '清除';

  @override
  String get thinking => '思考中';

  @override
  String get noSwipesAvailable => '沒有可用的滑動';

  @override
  String get system => '系統';

  @override
  String get backgroundFeatureComingSoon => '背景功能即將推出';

  @override
  String get authorsNoteUpdated => '作者註記已更新';

  @override
  String get commandError => '指令錯誤';

  @override
  String get enabled => '已啟用';

  @override
  String get disabled => '已停用';

  @override
  String get personas => '人設';

  @override
  String get createPersona => '建立人設';

  @override
  String get editPersona => '編輯人設';

  @override
  String get deletePersona => '刪除人設';

  @override
  String deletePersonaConfirmation(String name) {
    return '確定要刪除\"$name\"嗎？';
  }

  @override
  String get noPersonasYet => '尚無人設';

  @override
  String get createPersonaDescription => '建立人設以在聊天中代表自己';

  @override
  String get name => '名稱';

  @override
  String get enterPersonaName => '輸入人設名稱';

  @override
  String get description => '描述';

  @override
  String get describePersona => '描述此人設（選填）';

  @override
  String get personaDescriptionHelp => '描述將包含在系統提示中，幫助AI了解您是誰。';

  @override
  String get pleaseEnterName => '請輸入名稱';

  @override
  String get default_ => '預設';

  @override
  String get active => '使用中';

  @override
  String get setAsDefault => '設為預設';

  @override
  String get removeAvatar => '移除頭像';

  @override
  String failedToSaveAvatar(String error) {
    return '儲存頭像失敗：$error';
  }

  @override
  String get selectAvatarImage => '選擇頭像圖片';

  @override
  String get aiConfiguration => 'AI設定';

  @override
  String get llmProvider => 'LLM提供者';

  @override
  String get apiUrl => 'API網址';

  @override
  String get apiKey => 'API金鑰';

  @override
  String get model => '模型';

  @override
  String get temperature => '溫度';

  @override
  String get maxTokens => '最大令牌數';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => '頻率懲罰';

  @override
  String get presencePenalty => '存在懲罰';

  @override
  String get repetitionPenalty => '重複懲罰';

  @override
  String get streamingEnabled => '啟用串流傳輸';

  @override
  String get testConnection => '測試連線';

  @override
  String get connectionSuccessful => '連線成功！';

  @override
  String connectionFailed(String error) {
    return '連線失敗：$error';
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
  String get local => '本機';

  @override
  String get aiPresets => 'AI預設';

  @override
  String get createPreset => '建立預設';

  @override
  String get editPreset => '編輯預設';

  @override
  String get deletePreset => '刪除預設';

  @override
  String get presetName => '預設名稱';

  @override
  String get promptManager => '提示詞管理';

  @override
  String get systemPrompt => '系統提示';

  @override
  String get jailbreak => '越獄提示';

  @override
  String get worldInfo => '世界資訊';

  @override
  String get createEntry => '建立條目';

  @override
  String get editEntry => '編輯條目';

  @override
  String get deleteEntry => '刪除條目';

  @override
  String get keywords => '關鍵字';

  @override
  String get content => '內容';

  @override
  String get priority => '優先順序';

  @override
  String get groups => '群組';

  @override
  String get createGroup => '建立群組';

  @override
  String get editGroup => '編輯群組';

  @override
  String get deleteGroup => '刪除群組';

  @override
  String get groupName => '群組名稱';

  @override
  String get members => '成員';

  @override
  String get addMember => '新增成員';

  @override
  String get removeMember => '移除成員';

  @override
  String get tags => '標籤';

  @override
  String get createTag => '建立標籤';

  @override
  String get editTag => '編輯標籤';

  @override
  String get deleteTag => '刪除標籤';

  @override
  String get tagName => '標籤名稱';

  @override
  String get color => '顏色';

  @override
  String get quickReplies => '快速回覆';

  @override
  String get createQuickReply => '建立快速回覆';

  @override
  String get editQuickReply => '編輯快速回覆';

  @override
  String get deleteQuickReply => '刪除快速回覆';

  @override
  String get label => '標籤';

  @override
  String get message => '訊息';

  @override
  String get autoSend => '自動傳送';

  @override
  String get regex => '正規表示式';

  @override
  String get createRegex => '建立正規式';

  @override
  String get editRegex => '編輯正規式';

  @override
  String get deleteRegex => '刪除正規式';

  @override
  String get pattern => '模式';

  @override
  String get replacement => '替換';

  @override
  String get backup => '備份';

  @override
  String get createBackup => '建立備份';

  @override
  String get restoreBackup => '還原備份';

  @override
  String get backupCreated => '備份建立成功';

  @override
  String get backupRestored => '備份還原成功';

  @override
  String backupFailed(String error) {
    return '備份失敗：$error';
  }

  @override
  String restoreFailed(String error) {
    return '還原失敗：$error';
  }

  @override
  String get theme => '主題';

  @override
  String get darkMode => '深色模式';

  @override
  String get lightMode => '淺色模式';

  @override
  String get systemTheme => '跟隨系統';

  @override
  String get primaryColor => '主色調';

  @override
  String get accentColor => '強調色';

  @override
  String get advanced => '進階';

  @override
  String get advancedSettings => '進階設定';

  @override
  String get statistics => '統計';

  @override
  String get totalChats => '總聊天數';

  @override
  String get totalMessages => '總訊息數';

  @override
  String get totalCharacters => '總角色數';

  @override
  String get tokenizer => '分詞器';

  @override
  String get tts => '文字轉語音';

  @override
  String get stt => '語音轉文字';

  @override
  String get translation => '翻譯';

  @override
  String get imageGeneration => '圖像生成';

  @override
  String get vectorStorage => '向量儲存';

  @override
  String get sprites => '精靈圖';

  @override
  String get backgrounds => '背景';

  @override
  String get cfgScale => 'CFG比例';

  @override
  String get logitBias => 'Logit偏置';

  @override
  String get variables => '變數';

  @override
  String get listView => '清單檢視';

  @override
  String get gridView => '格狀檢視';

  @override
  String get search => '搜尋';

  @override
  String get searchCharacters => '搜尋角色...';

  @override
  String get noCharactersFound => '找不到角色';

  @override
  String get noCharactersYet => '尚無角色';

  @override
  String get importCharacter => '匯入角色以開始';

  @override
  String get createCharacter => '建立角色';

  @override
  String get editCharacter => '編輯角色';

  @override
  String get deleteCharacter => '刪除角色';

  @override
  String deleteCharacterConfirmation(String name) {
    return '確定要刪除\"$name\"嗎？這也將刪除與此角色的所有聊天。';
  }

  @override
  String get characterDeleted => '角色已刪除';

  @override
  String get startChat => '開始聊天';

  @override
  String get personality => '性格';

  @override
  String get scenario => '場景';

  @override
  String get firstMessage => '開場白';

  @override
  String get exampleDialogue => '範例對話';

  @override
  String get creatorNotes => '創作者註記';

  @override
  String get alternateGreetings => '備選問候語';

  @override
  String get characterBook => '角色書';

  @override
  String get language => '語言';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get languageChanged => '語言已變更';

  @override
  String get about => '關於';

  @override
  String get version => '版本';

  @override
  String get licenses => '授權條款';

  @override
  String get privacyPolicy => '隱私權政策';

  @override
  String get termsOfService => '服務條款';

  @override
  String get feedback => '意見回饋';

  @override
  String get rateApp => '評價應用程式';

  @override
  String get shareApp => '分享應用程式';

  @override
  String get checkForUpdates => '檢查更新';

  @override
  String get noUpdatesAvailable => '沒有可用更新';

  @override
  String get updateAvailable => '有可用更新';

  @override
  String get downloadUpdate => '下載更新';

  @override
  String get bookmarkCreated => '書籤已建立';

  @override
  String get bookmarkName => '書籤名稱';

  @override
  String get enterBookmarkName => '輸入書籤名稱';

  @override
  String get noBookmarksYet => '尚無書籤';

  @override
  String get createBookmarkDescription => '建立書籤以儲存對話中的重要節點';

  @override
  String get jumpToBookmark => '跳至書籤';

  @override
  String get deleteBookmark => '刪除書籤';

  @override
  String get bookmarkDeleted => '書籤已刪除';

  @override
  String get saveAsJsonl => '儲存為JSONL';

  @override
  String get saveAsJson => '儲存為JSON';

  @override
  String get keyboardShortcuts => '鍵盤快速鍵：';

  @override
  String get bold => '粗體';

  @override
  String get italic => '斜體';

  @override
  String get underline => '底線';

  @override
  String get strikethrough => '刪除線';

  @override
  String get inlineCode => '行內程式碼';

  @override
  String get link => '連結';

  @override
  String get slashCommands => '斜線指令';

  @override
  String get availableCommands => '可用指令：';

  @override
  String get commandHelp => '輸入 / 檢視可用指令';
}
