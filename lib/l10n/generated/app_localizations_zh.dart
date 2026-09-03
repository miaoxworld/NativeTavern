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
  String get saveAs => '另存为';

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
  String get formatting => '格式化';

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
  String get contextLength => '上下文长度';

  @override
  String get contextWindowSize => '上下文窗口大小';

  @override
  String get contextLengthDescription => '模型作为输入上下文可处理的最大 Token 数。';

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
  String get xai => '';

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
  String get worldInfo => '世界书';

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
  String get backupSubtitle => '本地和云端备份与恢复';

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
  String get characterNotFound => '未找到角色';

  @override
  String get characterNotFoundMessage => '找不到角色';

  @override
  String get exportAsPng => '导出为 PNG';

  @override
  String get exportAsCharx => '导出为 CharX';

  @override
  String get duplicate => '复制';

  @override
  String deleteCharacterConfirmationSimple(String name) {
    return '确定删除“$name”吗？此操作无法撤销。';
  }

  @override
  String characterDuplicated(String name) {
    return '已复制$name';
  }

  @override
  String failedToDelete(String error) {
    return '删除失败：$error';
  }

  @override
  String failedToDuplicate(String error) {
    return '复制失败：$error';
  }

  @override
  String get pngExportComingSoon => '即将支持 PNG 导出';

  @override
  String get charxExportComingSoon => '即将支持 CharX 导出';

  @override
  String get failedToCreateChat => '创建聊天失败';

  @override
  String get creating => '正在创建...';

  @override
  String byCreator(String creator) {
    return '作者：$creator';
  }

  @override
  String versionLabel(String version) {
    return 'v$version';
  }

  @override
  String get showLess => '收起';

  @override
  String get showMore => '显示更多';

  @override
  String greetingNumber(int number) {
    return '问候语 $number';
  }

  @override
  String alternateGreetingsCount(int count) {
    return '备选问候语（$count）';
  }

  @override
  String get embeddedLorebook => '内嵌世界书';

  @override
  String entriesEnabled(int enabled, int total) {
    return '已启用 $enabled/$total 个条目';
  }

  @override
  String andMoreEntries(int count) {
    return '...以及另外 $count 个条目';
  }

  @override
  String get exampleMessages => '示例消息';

  @override
  String get postHistoryInstructions => '历史记录后指令';

  @override
  String get selectImages => '选择图片';

  @override
  String get presetsAndTemplates => '预设与模板';

  @override
  String get activePreset => '当前预设';

  @override
  String get change => '更改';

  @override
  String get noPresetSelected => '未选择预设';

  @override
  String get instructTemplate => '指令模板';

  @override
  String get selectInstructTemplate => '选择指令模板';

  @override
  String get instructTemplateDescription =>
      '指令模板会针对不同 LLM 模型设置提示词格式。对于会自动处理格式的 OAI Compatible 或 Claude 等 API 服务，请选择“无”。';

  @override
  String get orderAndTogglePromptSections => '调整提示词部分的顺序和启用状态';

  @override
  String get llmConnection => 'LLM 连接';

  @override
  String get generationSettings => '生成设置';

  @override
  String get advancedSamplerSettings => '高级采样器设置';

  @override
  String get fullControlOverSampling => '完整控制采样参数';

  @override
  String get selectLlmProvider => '选择 LLM 服务';

  @override
  String get notSet => '未设置';

  @override
  String get enterApiKey => '输入 API 密钥';

  @override
  String get apiEndpointUrl => 'API 端点 URL';

  @override
  String get modelName => '模型名称';

  @override
  String get fetchAvailableModels => '获取可用模型';

  @override
  String get fetchModelsDescription => '从 API 获取模型，或手动输入模型名称';

  @override
  String get enterModelName => '输入模型名称';

  @override
  String get fetchingModels => '正在获取模型...';

  @override
  String get failedToFetchModels => '获取模型失败';

  @override
  String get tapToTestConnection => '点击测试 API 连接';

  @override
  String get testing => '正在测试...';

  @override
  String get connected => '已连接';

  @override
  String get connectionFailedSimple => '连接失败';

  @override
  String get maximumTokensToGenerate => '最大生成 Token 数';

  @override
  String get streaming => '流式传输';

  @override
  String get showResponseAsItGenerates => '生成时实时显示回复';

  @override
  String selectModelCount(int count) {
    return '选择模型（$count）';
  }

  @override
  String get refreshModels => '刷新模型';

  @override
  String get enterManually => '手动输入';

  @override
  String get noModelsFound => '未找到模型';

  @override
  String get tryDifferentSearchTerm => '请尝试其他搜索词';

  @override
  String modelsOfTotal(int filtered, int total) {
    return '显示 $filtered/$total 个模型';
  }

  @override
  String get importPreset => '导入预设';

  @override
  String get noGroupChatsYet => '暂无群聊';

  @override
  String get createGroupDescription => '创建群组，与多个角色聊天';

  @override
  String get newGroup => '新建群组';

  @override
  String membersAndMode(int count, String mode) {
    return '$count 位成员 · $mode 模式';
  }

  @override
  String get groupChatWillBeImplemented => '群聊将在聊天集成中实现';

  @override
  String deleteGroupConfirmation(String name) {
    return '确定删除“$name”吗？相关聊天也会一并删除。';
  }

  @override
  String groupDeleted(String name) {
    return '已删除$name';
  }

  @override
  String get groupNameRequired => '群组名称 *';

  @override
  String get enterGroupName => '输入群组名称';

  @override
  String get optionalDescription => '可选描述';

  @override
  String get selectCharacters => '选择角色';

  @override
  String get noCharactersAvailable => '暂无可用角色';

  @override
  String charactersSelected(int count) {
    return '已选择 $count 个角色';
  }

  @override
  String get create => '创建';

  @override
  String get selectAtLeast2Characters => '请至少选择 2 个角色';

  @override
  String get groupCreatedSuccessfully => '群组创建成功';

  @override
  String failedToCreateGroup(String error) {
    return '创建群组失败：$error';
  }

  @override
  String get selectCharacterCard => '选择角色卡';

  @override
  String get supportsPngCharxJson => '支持 PNG、CharX 和 JSON 格式';

  @override
  String get browseFiles => '浏览文件';

  @override
  String failedToPickFile(String error) {
    return '选择文件失败：$error';
  }

  @override
  String failedToLoadCharacter(String error) {
    return '加载角色失败：$error';
  }

  @override
  String unsupportedFileFormat(String format) {
    return '不支持的文件格式：$format';
  }

  @override
  String get pngCharacterCard => 'PNG 角色卡';

  @override
  String get characterDataEmbeddedInImage => '角色数据内嵌在图片元数据中';

  @override
  String get charxArchive => 'CharX 压缩包';

  @override
  String get zipArchiveWithCharacterData => '包含角色数据和资源的 ZIP 压缩包';

  @override
  String get plainCharacterCardJson => '纯角色卡 JSON 文件';

  @override
  String importedWithLorebook(String name) {
    return '已导入带内嵌世界书的“$name”！';
  }

  @override
  String importedSuccessfully(String name) {
    return '已成功导入“$name”！';
  }

  @override
  String failedToImport(String error) {
    return '导入失败：$error';
  }

  @override
  String embeddedLorebookEntries(int count) {
    return '内嵌世界书（$count 个条目）';
  }

  @override
  String get saveCurrentAsPreset => '将当前设置保存为预设';

  @override
  String get exportCurrentSettings => '导出当前设置';

  @override
  String get builtInPresets => '内置预设';

  @override
  String get customPresets => '自定义预设';

  @override
  String get aiPresetsDescription => 'AI 预设包含生成设置、提示词顺序和指令模板。选择一个预设即可一次应用全部设置。';

  @override
  String appliedPreset(String name) {
    return '已应用“$name”预设';
  }

  @override
  String failedToApplyPreset(String error) {
    return '应用预设失败：$error';
  }

  @override
  String get invalidPresetFormat => '预设格式无效，应包含生成设置。';

  @override
  String importedAndApplied(String name) {
    return '已导入并应用“$name”';
  }

  @override
  String get saveAsPreset => '保存为预设';

  @override
  String get descriptionOptional => '描述（可选）';

  @override
  String get pleaseEnterAName => '请输入名称';

  @override
  String savedPreset(String name) {
    return '已保存“$name”';
  }

  @override
  String saveFailed(String error) {
    return '保存失败：$error';
  }

  @override
  String deletePresetConfirmation(String name) {
    return '确定删除“$name”吗？';
  }

  @override
  String deletedPreset(String name) {
    return '已删除“$name”';
  }

  @override
  String get export => '导出';

  @override
  String get resetToDefaults => '恢复默认值';

  @override
  String get basicSampling => '基础采样';

  @override
  String get temperatureDescription => '控制随机性。数值越高越有创意，越低越专注。';

  @override
  String get topPNucleusSampling => 'Top P（核采样）';

  @override
  String get topPDescription => '选择 Token 的累积概率阈值。';

  @override
  String get topKDescription => '纳入考虑的最高概率 Token 数。0 表示停用。';

  @override
  String get advancedSampling => '高级采样';

  @override
  String get minP => 'Min P';

  @override
  String get minPDescription => '相对于最高概率 Token 的最低概率阈值。';

  @override
  String get typicalP => 'Typical P';

  @override
  String get typicalPDescription => '局部典型采样。1.0 表示停用。';

  @override
  String get topA => 'Top A';

  @override
  String get topADescription => 'Top-A 采样阈值。0 表示停用。';

  @override
  String get tailFreeSamplingTfs => '尾部自由采样（TFS）';

  @override
  String get tfsDescription => '移除低概率尾部。1.0 表示停用。';

  @override
  String get repetitionControl => '重复控制';

  @override
  String get repetitionPenaltyDescription => '惩罚重复 Token。1.0 表示不惩罚。';

  @override
  String get repetitionPenaltyRange => '重复惩罚范围';

  @override
  String get repetitionPenaltyRangeDescription => '纳入计算的 Token 数。0 表示全部。';

  @override
  String get frequencyPenaltyDescription => '根据 Token 在文本中的出现频率进行惩罚。';

  @override
  String get presencePenaltyDescription => '对文本中出现过的 Token 进行惩罚。';

  @override
  String get mirostatLocalModels => 'Mirostat（本地模型）';

  @override
  String get mirostatMode => 'Mirostat 模式';

  @override
  String get adaptiveSamplingForLocalModels => '适用于本地模型的自适应采样';

  @override
  String get off => '关闭';

  @override
  String get mirostatTau => 'Mirostat Tau';

  @override
  String get mirostatTauDescription => '目标熵/困惑度。';

  @override
  String get mirostatEta => 'Mirostat Eta';

  @override
  String get mirostatEtaDescription => 'Mirostat 的学习率。';

  @override
  String get generationControl => '生成控制';

  @override
  String get maxTokensDescription => '最多生成的 Token 数。';

  @override
  String get seed => '种子';

  @override
  String get seedDescription => '用于复现结果的随机种子。-1 表示随机。';

  @override
  String get stopSequences => '停止序列';

  @override
  String get noStopSequencesConfigured => '尚未配置停止序列';

  @override
  String get stopSequencesDescription => '每行输入一个序列。生成到其中任一序列时停止。';

  @override
  String get resetConfirmation => '这将把所有采样器设置恢复为默认值。是否继续？';

  @override
  String get reset => '重置';

  @override
  String get settingsResetToDefaults => '设置已恢复默认值';

  @override
  String get characterBackground => '角色背景';

  @override
  String get chatBackground => '聊天背景';

  @override
  String get clearBackground => '清除背景';

  @override
  String get gradientPresets => '渐变预设';

  @override
  String get solidColors => '纯色';

  @override
  String get customImage => '自定义图片';

  @override
  String get adjustments => '调整';

  @override
  String get noBackgroundSelected => '未选择背景';

  @override
  String get chooseImage => '选择图片';

  @override
  String get fromUrl => '来自 URL';

  @override
  String localImage(String filename) {
    return '本地图片：$filename';
  }

  @override
  String urlLabel(String url) {
    return 'URL：$url';
  }

  @override
  String get noImage => '无图片';

  @override
  String get opacity => '不透明度';

  @override
  String get blurEffect => '模糊效果';

  @override
  String get applyBlurToBackground => '对背景应用模糊';

  @override
  String get blurAmount => '模糊程度';

  @override
  String failedToLoadImage(String error) {
    return '加载图片失败：$error';
  }

  @override
  String get imageUrl => '图片 URL';

  @override
  String get enterImageUrl => '输入图片 URL';

  @override
  String get apply => '应用';

  @override
  String get backupAndRestore => '备份与恢复';

  @override
  String get refresh => '刷新';

  @override
  String get storage => '存储';

  @override
  String get totalBackupSize => '备份总大小';

  @override
  String get calculating => '计算中...';

  @override
  String get lastAutoBackup => '上次自动备份';

  @override
  String get autoBackup => '自动备份';

  @override
  String get enableAutoBackup => '启用自动备份';

  @override
  String get automaticallyBackupChats => '自动备份聊天记录';

  @override
  String get backupInterval => '备份间隔';

  @override
  String get backupOnExit => '退出时备份';

  @override
  String get createBackupWhenClosingApp => '关闭应用时创建备份';

  @override
  String get retention => '保留策略';

  @override
  String get maxChatBackups => '最大聊天备份数';

  @override
  String keepUpToChatBackups(int count) {
    return '最多保留 $count 个聊天备份';
  }

  @override
  String get maxFullBackups => '最大完整备份数';

  @override
  String keepUpToFullBackups(int count) {
    return '最多保留 $count 个完整备份';
  }

  @override
  String get cleanupOldBackups => '清理旧备份';

  @override
  String get deleteBackupsExceedingLimits => '删除超过限制的备份';

  @override
  String get cleanup => '清理';

  @override
  String deletedOldBackups(int count) {
    return '已删除 $count 个旧备份';
  }

  @override
  String get chatBackups => '聊天备份';

  @override
  String get noChatBackups => '暂无聊天备份';

  @override
  String viewAllBackups(int count) {
    return '查看全部 $count 个备份';
  }

  @override
  String get fullBackups => '完整备份';

  @override
  String get noFullBackups => '暂无完整备份';

  @override
  String get information => '信息';

  @override
  String get aboutBackups => '关于备份';

  @override
  String get aboutBackupsDescription => '聊天备份保存单个对话。完整备份包含所有角色、聊天、设置和世界书。';

  @override
  String get backupLocation => '备份位置';

  @override
  String errorReadingBackup(String error) {
    return '读取备份错误：$error';
  }

  @override
  String get deleteBackup => '删除备份';

  @override
  String deleteBackupConfirmation(String name) {
    return '删除 \"$name\"？\\n\\n此操作无法撤销。';
  }

  @override
  String get view => '查看';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String hoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String get enableCfgScale => '启用 CFG Scale';

  @override
  String get cfgScaleDescription => '用于文本生成的无分类器引导';

  @override
  String get globalSettings => '全局设置';

  @override
  String get guidanceScale => '引导强度';

  @override
  String get negativePrompt => '负面提示词';

  @override
  String get textToSteerAwayFrom => '希望模型避开的文本';

  @override
  String get positivePromptOptional => '正面提示词（可选）';

  @override
  String get textToEnhanceInOutput => '希望在输出中强化的文本';

  @override
  String get characterSettings => '角色设置';

  @override
  String get useCharacterSpecificSettings => '使用角色专属设置';

  @override
  String get overrideGlobalForCharacter => '为此角色覆盖全局设置';

  @override
  String get characterNegativePrompt => '角色负面提示词';

  @override
  String get overrideGlobalNegativePrompt => '覆盖全局负面提示词';

  @override
  String get chatSettings => '聊天设置';

  @override
  String get chatSettingsDescription => '这些设置仅对当前聊天生效，并覆盖全局和角色设置。';

  @override
  String get chatNegativePrompt => '聊天负面提示词';

  @override
  String get overrideForThisChat => '为当前聊天覆盖设置';

  @override
  String get chatPositivePrompt => '聊天正面提示词';

  @override
  String get enhancementForThisChat => '当前聊天的强化内容';

  @override
  String get promptCombineMode => '提示词组合方式';

  @override
  String get replaceChatPromptOnly => '替换（仅使用聊天提示词）';

  @override
  String get prependChatPlusGlobal => '前置（聊天 + 全局）';

  @override
  String get appendGlobalPlusChat => '后置（全局 + 聊天）';

  @override
  String get aboutCfgScale => '关于 CFG Scale';

  @override
  String get aboutCfgScaleDescription =>
      'CFG（无分类器引导）Scale 控制模型遵循负面提示词、避开特定内容或风格的强度。\n\n• 1.0 = 无效果（默认）\n• 1.5-3.0 = 轻度引导\n• 3.0-7.0 = 中度引导\n• 7.0+ = 强引导（可能影响连贯性）';

  @override
  String get cfgScaleHelp => 'CFG Scale 帮助';

  @override
  String get cfgScaleHelpContent =>
      '无分类器引导（CFG）Scale 可通过指定希望避开的内容来引导 AI 模型输出。\n\n**工作方式：**\n模型会生成两份输出，一份使用提示词，另一份使用负面提示词。最终输出会向远离负面提示词的方向调整。\n\n**设置优先级：**\n1. 聊天专属设置（最高）\n2. 角色专属设置\n3. 全局设置（最低）\n\n**提示：**\n• 从较低数值（1.5-2.0）开始并逐渐增加\n• 使用具体的负面提示词可获得更好效果\n• 数值过高可能导致重复或不连贯\n• 并非所有 AI 后端都支持 CFG Scale';

  @override
  String get help => '帮助';

  @override
  String get processing => '处理中...';

  @override
  String get sampleMessage1 => '你好！有什么可以帮你？';

  @override
  String get sampleMessage2 => '给我讲个故事吧！';

  @override
  String get general => '常规';

  @override
  String get enableImageGeneration => '启用图片生成';

  @override
  String get generateImagesUsingAi => '使用 AI 生成图片';

  @override
  String get imageGenerationProvider => '图片生成服务';

  @override
  String get apiEndpoint => 'API 端点';

  @override
  String get notConfigured => '未配置';

  @override
  String get defaultParameters => '默认参数';

  @override
  String get imageSize => '图片尺寸';

  @override
  String get steps => '步数';

  @override
  String get sampler => '采样器';

  @override
  String get defaultNegativePrompt => '默认负面提示词';

  @override
  String get enterTermsToAvoid => '输入生成图片中需要避免的内容';

  @override
  String get test => '测试';

  @override
  String get aboutImageGeneration => '关于图片生成';

  @override
  String get aboutImageGenerationDescription =>
      '使用 AI 模型生成图片。可在聊天中使用 /imagine 命令，或在角色编辑器中生成角色肖像。';

  @override
  String get imagine => '生图';

  @override
  String get fillImagePromptWithAi => 'AI 填写提示词';

  @override
  String get imagineCommand => '/imagine 命令';

  @override
  String get imagineCommandUsage =>
      '用法：/imagine <提示词> [--width N] [--height N] [--steps N] [--cfg N] [--seed N]';

  @override
  String get stableDiffusion => 'Stable Diffusion';

  @override
  String get stableDiffusionDescription =>
      '连接本地或远程 Stable Diffusion WebUI，需要启用 API。';

  @override
  String get dalle => 'DALL-E';

  @override
  String get dalleDescription =>
      '通过 OAI Compatible 端点使用 DALL-E 生成图片，需要 API 密钥。';

  @override
  String get prompt => '提示词';

  @override
  String get enterPromptToGenerate => '输入图片生成提示词';

  @override
  String get generate => '生成';

  @override
  String get generating => '正在生成...';

  @override
  String get generationComplete => '生成完成';

  @override
  String get imageWouldBeDisplayed => '图片将在此处显示';

  @override
  String get enableLogitBias => '启用 Logit Bias';

  @override
  String get adjustTokenProbabilities => '调整 AI 回复中的 Token 概率';

  @override
  String get presets => '预设';

  @override
  String get activePresetLabel => '当前预设';

  @override
  String get none => '无';

  @override
  String get newPreset => '新建预设';

  @override
  String get importPresetLabel => '导入预设';

  @override
  String get biasEntries => '偏置条目';

  @override
  String get noBiasEntries => '暂无偏置条目';

  @override
  String get addEntriesToAdjust => '添加条目以调整 Token 概率';

  @override
  String get addEntry => '添加条目';

  @override
  String get textOrToken => '文本 / Token';

  @override
  String textTokenHint(Object verbatim) {
    return '单词、$verbatim 或 [1234]';
  }

  @override
  String get bias => '偏置';

  @override
  String get logitBiasHelp => 'Logit Bias 帮助';

  @override
  String get presetCopiedToClipboard => '预设已复制到剪贴板';

  @override
  String exportPresetFailed(String error) {
    return '导出失败：$error';
  }

  @override
  String get pastePresetJson => '在此粘贴预设 JSON';

  @override
  String get presetImportedSuccessfully => '预设导入成功';

  @override
  String importPresetFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get rename => '重命名';

  @override
  String get deletePresetQuestion => '确定删除此预设吗？';

  @override
  String get moreOptions => '更多选项';

  @override
  String get loadPreset => '加载预设';

  @override
  String get saveAsPresetLabel => '保存为预设';

  @override
  String get exportPreset => '导出预设';

  @override
  String get resetToDefault => '恢复默认';

  @override
  String get dragToReorder => '拖动可调整各部分顺序，使用开关启用或停用。';

  @override
  String deleted(String name) {
    return '已删除“$name”';
  }

  @override
  String imported(String name) {
    return '已导入“$name”';
  }

  @override
  String get invalidPresetFormatMessage => '预设格式无效';

  @override
  String get exportPresetTitle => '导出预设';

  @override
  String get presetNameLabel => '预设名称';

  @override
  String get pleaseEnterNameMessage => '请输入名称';

  @override
  String saved(String name) {
    return '已保存“$name”';
  }

  @override
  String saveFailedMessage(String error) {
    return '保存失败：$error';
  }

  @override
  String get resetToDefaultQuestion => '这将恢复所有提示词部分的默认顺序并全部启用。是否继续？';

  @override
  String get resetToDefaultConfig => '恢复默认配置';

  @override
  String get promptManagerHelp => '提示词管理器帮助';

  @override
  String applied(String name) {
    return '已应用“$name”预设';
  }

  @override
  String get showQuickReplies => '显示快捷回复';

  @override
  String get displayQuickReplyButtons => '在聊天中显示快捷回复按钮';

  @override
  String get positionAboveInput => '位于输入框上方';

  @override
  String get quickRepliesAboveInput => '快捷回复显示在输入框上方';

  @override
  String get quickRepliesBelowInput => '快捷回复显示在输入框下方';

  @override
  String get add => '添加';

  @override
  String get noQuickReplies => '暂无快捷回复';

  @override
  String get addYourFirstQuickReply => '添加第一条快捷回复';

  @override
  String deleteQuickReplyQuestion(String label) {
    return '确定删除“$label”吗？';
  }

  @override
  String get resetToDefaultQuestion2 => '这将用默认集合替换你的所有快捷回复。是否继续？';

  @override
  String get continueOrEmpty => '（继续/空消息）';

  @override
  String get autoSendTooltip => '自动发送';

  @override
  String get addQuickReply => '添加快捷回复';

  @override
  String get editQuickReplyLabel => '编辑快捷回复';

  @override
  String get buttonLabel => '按钮文字';

  @override
  String get buttonLabelHint => '例如：是、继续、思考...';

  @override
  String get messageLabel => '消息';

  @override
  String get leaveEmptyForContinue => '留空表示继续生成';

  @override
  String get supportsMacros => '支持提示词宏';

  @override
  String get autoSendLabel => '自动发送';

  @override
  String get messageSentImmediately => '消息将立即发送';

  @override
  String get messageFillsInput => '消息将填入输入框';

  @override
  String get regexScripts => '正则脚本';

  @override
  String get addScript => '添加脚本';

  @override
  String get addPresets => '添加预设';

  @override
  String get clearAll => '全部清除';

  @override
  String get enableRegexScripts => '启用正则脚本';

  @override
  String get applyFindReplacePatterns => '对消息应用查找/替换规则';

  @override
  String get applyTo => '应用到';

  @override
  String get userInput => '用户输入';

  @override
  String get applyBeforeSending => '发送前应用于消息';

  @override
  String get aiOutput => 'AI 输出';

  @override
  String get applyToAiResponses => '应用到 AI 回复';

  @override
  String get slashCommandsLabel => '斜杠命令';

  @override
  String get applyDuringCommandProcessing => '处理命令时应用';

  @override
  String get worldInfoLabel => '世界书';

  @override
  String get applyToWorldInfoEntries => '应用到世界书条目';

  @override
  String scriptsCount(int count) {
    return '脚本（$count）';
  }

  @override
  String get noRegexScripts => '暂无正则脚本';

  @override
  String get tapToAddOrUseMenu => '点击 + 添加脚本，或使用菜单添加预设';

  @override
  String get aboutRegexScripts => '关于正则脚本';

  @override
  String get aboutRegexScriptsDescription =>
      '正则脚本可在消息中查找并替换文本模式。替换内容可使用捕获组（\$1、\$2）。';

  @override
  String get patternFormat => '模式格式';

  @override
  String get patternFormatDescription =>
      '使用 /pattern/flags 格式（如 /hello/gi）或普通模式。标志：i=不区分大小写，m=多行，s=点号匹配换行';

  @override
  String get presetScriptsAdded => '预设脚本已添加';

  @override
  String deleteScriptQuestion(String name) {
    return '删除“$name”？';
  }

  @override
  String get clearAllScripts => '清空所有脚本';

  @override
  String get clearAllScriptsQuestion => '这将删除所有正则脚本，且无法撤销。';

  @override
  String get importScripts => '导入脚本';

  @override
  String get pasteJsonArray => '粘贴脚本 JSON 数组';

  @override
  String importedCount(int count) {
    return '已导入 $count 个脚本';
  }

  @override
  String get exportScripts => '导出脚本';

  @override
  String get newScript => '新建脚本';

  @override
  String get editScript => '编辑脚本';

  @override
  String get scriptName => '脚本名称';

  @override
  String get descriptionOptionalLabel => '描述（可选）';

  @override
  String get findPattern => '查找模式';

  @override
  String get patternOrPlainPattern => '/pattern/flags 或普通模式';

  @override
  String get replaceWith => '替换为';

  @override
  String get useCaptureGroups => '使用 \$1、\$2 表示捕获组';

  @override
  String get applyToLabel => '应用到';

  @override
  String get options => '选项';

  @override
  String get markdownOnly => '仅 Markdown';

  @override
  String get onlyApplyDuringMarkdown => '仅在 Markdown 渲染时应用';

  @override
  String get promptOnly => '仅提示词';

  @override
  String get onlyApplyDuringPrompt => '仅在生成提示词时应用';

  @override
  String get runOnEdit => '编辑时运行';

  @override
  String get applyWhenEditingMessages => '编辑消息时应用';

  @override
  String get macroSubstitution => '宏替换';

  @override
  String get nameAndPatternRequired => '名称和模式不能为空';

  @override
  String get patternLabel => '模式';

  @override
  String get patternHint => '/pattern/flags';

  @override
  String get testString => '测试文本';

  @override
  String get replacementLabel => '替换内容';

  @override
  String get replacementHint => '\$1、\$2 或匹配的文本';

  @override
  String get testButton => '测试';

  @override
  String matchesCount(int count) {
    return '$count 个匹配项';
  }

  @override
  String get errorLabel => '错误';

  @override
  String get resultLabel => '结果：';

  @override
  String get expressionSprites => '表情立绘';

  @override
  String get enableSprites => '启用立绘';

  @override
  String get showCharacterExpressions => '在聊天中显示角色表情图片';

  @override
  String get display => '显示';

  @override
  String get spriteSize => '立绘大小';

  @override
  String get position => '位置';

  @override
  String get whereToDisplaySprites => '立绘显示位置';

  @override
  String get left => '左侧';

  @override
  String get right => '右侧';

  @override
  String get center => '居中';

  @override
  String get floatingLeft => '左侧悬浮';

  @override
  String get floatingRight => '右侧悬浮';

  @override
  String get animation => '动画';

  @override
  String get animateTransitions => '过渡动画';

  @override
  String get smoothFadeWhenSpriteChanges => '立绘切换时平滑淡入淡出';

  @override
  String get transitionDuration => '过渡时长';

  @override
  String get showDuringStreaming => '流式生成时显示';

  @override
  String get displaySpritesWhileGenerating => 'AI 生成时显示立绘';

  @override
  String get emotionDetection => '情绪检测';

  @override
  String get howItWorks => '工作方式';

  @override
  String get spriteEmotionDetectionDescription =>
      '系统会根据消息中检测到的情绪关键词自动选择立绘，并优先识别 *微笑*、*大笑* 等动作文本。';

  @override
  String get supportedEmotions => '支持的情绪';

  @override
  String characterSprites(String name) {
    return '$name的立绘';
  }

  @override
  String get importFromFolder => '从文件夹导入';

  @override
  String get deleteAllSprites => '删除所有立绘';

  @override
  String get addSprite => '添加立绘';

  @override
  String spritesCount(int count) {
    return '$count 张立绘';
  }

  @override
  String defaultEmotion(String emotion) {
    return '默认：$emotion';
  }

  @override
  String get noSpritesYet => '暂无立绘';

  @override
  String get addExpressionImages => '为此角色添加表情图片';

  @override
  String get selectEmotion => '选择表情';

  @override
  String addedSpriteEmotion(String emotion) {
    return '已添加$emotion立绘';
  }

  @override
  String get setAsDefaultEmotion => '设为默认表情';

  @override
  String get changeEmotion => '更改表情';

  @override
  String get deleteSprite => '删除立绘';

  @override
  String deleteSpriteConfirmation(String emotion) {
    return '删除$emotion立绘？';
  }

  @override
  String get deleteAllSpritesConfirmation => '确定删除此角色的所有立绘吗？此操作无法撤销。';

  @override
  String get importSprites => '导入立绘';

  @override
  String get importSpritesDescription => '从文件夹导入立绘。文件名应包含情绪关键词：';

  @override
  String get supportedFormatsSprites => '支持格式：PNG、JPG、GIF、WebP';

  @override
  String get selectFolder => '选择文件夹';

  @override
  String get folderImportRequiresPackage => '从文件夹导入需要 file_picker 软件包';

  @override
  String get appStatistics => '应用统计';

  @override
  String get chatStatistics => '聊天统计';

  @override
  String get resetStatistics => '重置统计';

  @override
  String get resetStatisticsConfirmation => '确定重置所有统计数据吗？此操作无法撤销。';

  @override
  String get statisticsReset => '统计数据已重置';

  @override
  String get overview => '概览';

  @override
  String get firstUsed => '首次使用';

  @override
  String get unknown => '未知';

  @override
  String get totalGroups => '群组总数';

  @override
  String get totalGenerations => '总生成次数';

  @override
  String get tokenUsage => 'Token 用量';

  @override
  String get totalTokensUsed => 'Token 总用量';

  @override
  String get avgTokensPerGeneration => '每次生成平均 Token';

  @override
  String get performance => '性能';

  @override
  String get totalGenerationTime => '总生成时间';

  @override
  String get avgGenerationTime => '平均生成时间';

  @override
  String get userMessages => '用户消息';

  @override
  String get assistantMessages => '助手消息';

  @override
  String get systemMessages => '系统消息';

  @override
  String get timeline => '时间线';

  @override
  String get firstMessage_ => '第一条消息';

  @override
  String get lastMessage => '最后一条消息';

  @override
  String get chatDuration => '聊天时长';

  @override
  String get promptTokens => '提示词 Token';

  @override
  String get completionTokens => '补全 Token';

  @override
  String get avgTokensPerMessage => '每条消息平均 Token';

  @override
  String get generationPerformance => '生成性能';

  @override
  String get generationCount => '总生成次数';

  @override
  String get speechToText => '语音转文字';

  @override
  String get enableStt => '启用语音转文字';

  @override
  String get useVoiceInputForMessages => '使用语音输入消息';

  @override
  String get autoSendStt => '自动发送';

  @override
  String get automaticallySendAfterSpeaking => '说完后自动发送消息';

  @override
  String get continuousListening => '持续聆听';

  @override
  String get keepListeningAfterPhrase => '每句话结束后继续聆听';

  @override
  String get showPartialResults => '显示临时结果';

  @override
  String get displayTextAsYouSpeak => '说话时实时显示文字';

  @override
  String get sttProvider => '语音转文字服务';

  @override
  String get recognitionLanguage => '识别语言';

  @override
  String get testVoiceInput => '测试语音输入';

  @override
  String get stopListening => '停止聆听';

  @override
  String get tapToStop => '点击停止';

  @override
  String get tapToTestSpeechRecognition => '点击测试语音识别';

  @override
  String get final_ => '最终结果';

  @override
  String get listening => '正在聆听...';

  @override
  String get aboutStt => '关于语音转文字';

  @override
  String get aboutSttDescription => '语音转文字可让你通过语音听写消息。点击聊天输入框中的麦克风按钮开始说话。';

  @override
  String get systemStt => '系统语音识别';

  @override
  String get systemSttDescription => '使用设备内置的语音识别。准确度取决于系统设置。';

  @override
  String get whisper => 'Whisper';

  @override
  String get whisperDescription =>
      '通过 OAI Compatible 端点使用 Whisper 转写，需要 API 密钥。';

  @override
  String get voiceInput => '语音输入';

  @override
  String get holdToTalk => '按住说话';

  @override
  String get releaseToTranscribe => '松开并转写';

  @override
  String get cancelVoiceInput => '取消语音输入';

  @override
  String get openSystemSettings => '打开系统设置';

  @override
  String get systemSttOfflineNote => '离线识别能力取决于操作系统和已安装的语言包。';

  @override
  String get sttConfigurationRequired => '请先完成所选语音服务的配置再进行测试。';

  @override
  String get speechRecognitionNotAvailable => '此设备可能不支持语音识别。';

  @override
  String get themes => '主题';

  @override
  String get createCustomTheme => '创建自定义主题';

  @override
  String get builtInThemes => '内置主题';

  @override
  String get preview => '预览';

  @override
  String get chatPreview => '聊天预览';

  @override
  String get helloHowCanIHelp => '你好！有什么可以帮你？';

  @override
  String get tellMeAStory => '给我讲个故事吧！';

  @override
  String get typeAMessage => '输入消息...';

  @override
  String get createTheme => '创建主题';

  @override
  String get editTheme => '编辑主题';

  @override
  String get deleteTheme => '删除主题';

  @override
  String deleteThemeConfirmation(String name) {
    return '确定删除“$name”吗？';
  }

  @override
  String get themeName => '主题名称';

  @override
  String get background => '背景';

  @override
  String get surface => '表面';

  @override
  String get card => '卡片';

  @override
  String selectThemeColor(String label) {
    return '选择$label';
  }

  @override
  String get hexColor => '十六进制颜色';

  @override
  String get tokenizerSettings => '分词器';

  @override
  String get tokenizerHelp => '帮助';

  @override
  String get tokenizerLabel => '分词器';

  @override
  String get showTokenCount => '显示 Token 数';

  @override
  String get displayTokenCountInInput => '在聊天输入框中显示 Token 数';

  @override
  String get showTokenVisualization => '显示 Token 可视化';

  @override
  String get highlightIndividualTokens => '高亮各个 Token';

  @override
  String get cacheResults => '缓存结果';

  @override
  String get cacheTokenizationForPerformance => '缓存分词结果以提升性能';

  @override
  String get tokenVisualization => 'Token 可视化';

  @override
  String get enterTextToTokenize => '输入要分词的文本';

  @override
  String get typePasteTextHere => '在此输入或粘贴文本...';

  @override
  String get quickEstimate => '快速估算';

  @override
  String approximateTokens(int count) {
    return '约 $count 个 Token';
  }

  @override
  String chars(int count) {
    return '$count 个字符';
  }

  @override
  String get statisticsLabel => '统计';

  @override
  String get totalTokens => '总令牌数';

  @override
  String get unique => '唯一';

  @override
  String get charsPerToken => '每个 Token 的字符数';

  @override
  String get avgLength => '平均长度';

  @override
  String get longest => '最长';

  @override
  String get shortest => '最短';

  @override
  String get mostCommonTokens => '最常见 Token';

  @override
  String get tokenBreakdown => 'Token 明细';

  @override
  String tokensCount(int count) {
    return '$count 个 Token';
  }

  @override
  String tokenIdLength(String id, int length) {
    return 'Token ID：$id\n长度：$length 个字符';
  }

  @override
  String get translationSettings => '翻译';

  @override
  String get enableTranslation => '启用翻译';

  @override
  String get translateMessagesAutomatically => '自动翻译消息';

  @override
  String get translationProvider => '翻译服务';

  @override
  String get sourceLanguage => '源语言';

  @override
  String get targetLanguage => '目标语言';

  @override
  String get autoDetect => '自动检测';

  @override
  String get translateUserMessages => '翻译用户消息';

  @override
  String get translateAiResponses => '翻译 AI 回复';

  @override
  String get textToSpeech => '文本转语音';

  @override
  String get enableTts => '启用文本转语音';

  @override
  String get readAiResponsesAloud => '朗读 AI 回复';

  @override
  String get ttsProvider => '文本转语音服务';

  @override
  String get voiceSettings => '语音设置';

  @override
  String get voice => '语音';

  @override
  String get speed => '语速';

  @override
  String get pitch => '音调';

  @override
  String get volume => '音量';

  @override
  String get autoPlay => '自动播放';

  @override
  String get automaticallyPlayResponses => '自动播放 AI 回复';

  @override
  String get testVoice => '测试语音';

  @override
  String get chatVariables => '聊天变量';

  @override
  String get variableSystem => '变量系统';

  @override
  String get globalVariables => '全局变量';

  @override
  String globalVariablesCount(int count) {
    return '$count 个全局变量';
  }

  @override
  String get localVariables => '局部变量';

  @override
  String localVariablesCount(int count) {
    return '$count 个局部变量';
  }

  @override
  String get addVariable => '添加变量';

  @override
  String get variableName => '变量名称';

  @override
  String get variableValue => '变量值';

  @override
  String get scope => '范围';

  @override
  String get global => '全局';

  @override
  String get vectorStorageRag => '向量存储（RAG）';

  @override
  String get enableRag => '启用 RAG';

  @override
  String get useVectorStorageForContext => '使用向量存储检索上下文';

  @override
  String get collections => '集合';

  @override
  String get createCollection => '创建集合';

  @override
  String get collectionName => '集合名称';

  @override
  String get embeddingProvider => '嵌入服务';

  @override
  String get embeddingModel => '嵌入模型';

  @override
  String get chunkSize => '分块大小';

  @override
  String get chunkOverlap => '分块重叠';

  @override
  String get topKResults => 'Top K 结果';

  @override
  String get similarityThreshold => '相似度阈值';

  @override
  String get characterEditor => '角色编辑器';

  @override
  String get basic => '基础';

  @override
  String get prompts => '提示词';

  @override
  String get meta => '元数据';

  @override
  String get nameRequired => '名称 *';

  @override
  String get characterName => '角色名称';

  @override
  String get nameIsRequired => '名称不能为空';

  @override
  String get characterDescription => '角色描述、背景、外观...';

  @override
  String get characterPersonalityTraits => '角色性格特征...';

  @override
  String get currentCircumstancesContext => '当前情境和上下文...';

  @override
  String get customInstructionsSystemMessage => '作为系统消息一部分发送的自定义指令。';

  @override
  String systemPromptHint(Object char) {
    return '你是 $char。你将...';
  }

  @override
  String get instructionsInsertedAfterHistory => '插入在聊天记录之后的指令（也称为“越狱提示词”）。';

  @override
  String postHistoryInstructionsHint(Object char) {
    return '继续扮演 $char...';
  }

  @override
  String get firstMessageGreeting => '第一条消息（问候语）';

  @override
  String get firstMessageSentByCharacter => '开始新聊天时由角色发送的第一条消息。';

  @override
  String firstMessageHint(Object user) {
    return '*走进房间* 你好，$user！';
  }

  @override
  String get alternateGreetingsCanSwipe => '可以通过滑动切换的备选第一条消息。';

  @override
  String greeting(int index) {
    return '问候语 $index';
  }

  @override
  String get alternativeGreetingMessage => '备选问候消息...';

  @override
  String get removeGreeting => '移除问候语';

  @override
  String get moveUp => '上移';

  @override
  String get moveDown => '下移';

  @override
  String get noAlternateGreetings => '暂无备选问候语。点击 + 添加。';

  @override
  String exampleDialogueDemonstrate(Object char, Object user) {
    return '用于展示角色说话方式的示例对话。\n格式：<START>\n$user：你好\n$char：你好！';
  }

  @override
  String exampleMessagesHint(Object char, Object user) {
    return '<START>\n$user：你好吗？\n$char：我很好，谢谢关心！';
  }

  @override
  String get creatorNotesNotSentToAi => '角色作者留下的备注（不会发送给 AI）。';

  @override
  String get creatorNotesHint => '推荐设置、背景备注...';

  @override
  String get tagsCommaSeparated => '以逗号分隔的标签列表';

  @override
  String get tagsHint => '奇幻, 女性, 冒险';

  @override
  String get creator => '作者';

  @override
  String get yourNameOrUsername => '你的姓名或用户名';

  @override
  String get versionNumber => '1.0.0';

  @override
  String get characterInfo => '角色信息';

  @override
  String characterId(String id) {
    return 'ID：$id';
  }

  @override
  String created(String date) {
    return '创建时间：$date';
  }

  @override
  String modified(String date) {
    return '修改时间：$date';
  }

  @override
  String get characterSavedSuccessfully => '角色保存成功';

  @override
  String failedToSaveCharacter(String error) {
    return '保存角色失败：$error';
  }

  @override
  String get addAlternateGreeting => '添加备选问候语';

  @override
  String get groupInfo => '群组信息';

  @override
  String get responseMode => '回复模式';

  @override
  String get howCharactersTakeTurns => '角色轮流回复的方式';

  @override
  String get sequential => '按顺序';

  @override
  String get charactersRespondInOrder => '角色按顺序回复';

  @override
  String get random => '随机';

  @override
  String get randomCharacterResponds => '每轮由随机角色回复';

  @override
  String get allAtOnce => '全部同时回复';

  @override
  String get allNonMutedCharactersRespond => '所有未静音的角色都回复';

  @override
  String get manual => '手动';

  @override
  String get youSelectWhoResponds => '由你选择回复的角色';

  @override
  String get natural => '自然';

  @override
  String get aiDecidesBasedOnContext => 'AI 根据上下文和触发词决定';

  @override
  String membersCount(int count) {
    return '成员（$count）';
  }

  @override
  String get noMembersYet => '暂无成员，请向群组添加角色。';

  @override
  String talkativenessPercent(int percent) {
    return '活跃度：$percent%';
  }

  @override
  String triggers(String words) {
    return '触发词：$words';
  }

  @override
  String get mute => '静音';

  @override
  String get unmute => '取消静音';

  @override
  String get memberSettings => '成员设置';

  @override
  String talkativenessLabel(int percent) {
    return '活跃度：$percent%';
  }

  @override
  String get higherValuesMoreLikely => '数值越高，角色回复的可能性越大。';

  @override
  String get triggerWords => '触发词';

  @override
  String get triggerWordsHint => '词语1, 词语2, 词语3';

  @override
  String get characterWillRespondWhenTriggered => '消息中出现这些词时，角色会回复。';

  @override
  String get addMemberToGroup => '添加群组成员';

  @override
  String get noMoreCharactersAvailable => '没有更多可添加的角色';

  @override
  String get groupSaved => '群组已保存';

  @override
  String deleteGroupAndChats(String name) {
    return '确定删除“$name”吗？';
  }

  @override
  String get startChatAction => '开始聊天';

  @override
  String get noTagsYet => '暂无标签';

  @override
  String get createTagsToOrganize => '创建标签来整理角色';

  @override
  String characterCount(int count, String plural) {
    return '$count 个角色$plural';
  }

  @override
  String deleteTagConfirmation(String name) {
    return '确定删除标签“$name”吗？\n\n所有角色上的此标签都会被移除。';
  }

  @override
  String get enterTagName => '输入标签名称';

  @override
  String get iconEmoji => '图标（表情符号）';

  @override
  String get enterEmojiOptional => '输入表情符号（可选）';

  @override
  String get pleaseEnterTagName => '请输入标签名称';

  @override
  String get worldInfoLorebooks => '世界书';

  @override
  String get createLorebook => '创建世界书';

  @override
  String get noLorebooksYet => '暂无世界书';

  @override
  String get lorebooksInjectContext => '检测到关键词时，世界书会向聊天注入上下文。';

  @override
  String entriesCount(int count) {
    return '$count 个条目';
  }

  @override
  String deleteLorebookConfirmation(String name) {
    return '确定删除“$name”及其所有条目吗？';
  }

  @override
  String get enterLorebookName => '输入世界书名称';

  @override
  String get optionalDescriptionHint => '可选描述';

  @override
  String get globalScope => '全局';

  @override
  String get applyToAllChats => '应用到所有聊天';

  @override
  String get pleaseEnterName2 => '请输入名称';

  @override
  String get noEntriesYet => '暂无条目';

  @override
  String get addEntriesWithKeywords => '添加带关键词的条目，以便向聊天注入上下文';

  @override
  String deleteEntryConfirmation(String keys) {
    return '确定删除此条目吗？\n\n关键词：$keys';
  }

  @override
  String get constant => '常量';

  @override
  String get selective => '选择性匹配';

  @override
  String get keywordsCommaSeparated => '关键词（用逗号分隔）';

  @override
  String get keywordsHint => '龙, 巨龙, 蛇';

  @override
  String get entryActivatesWhenKeywordFound => '聊天中出现任一关键词时激活条目';

  @override
  String get secondaryKeysOptional => '次关键词（可选）';

  @override
  String get secondaryKeysHint => '火, 火焰';

  @override
  String get bothPrimaryAndSecondaryMustMatch => '启用后，主关键词和次关键词必须同时匹配（选择性模式）';

  @override
  String get commentOptional => '备注（可选）';

  @override
  String get noteForThisEntry => '此条目的备注';

  @override
  String get contentLabel => '内容';

  @override
  String get contextToInjectWhenMatches => '关键词匹配时要注入的上下文...';

  @override
  String get pleaseEnterAtLeastOneKeyword => '请至少输入一个关键词';

  @override
  String get pleaseEnterContent => '请输入内容';

  @override
  String get anthropic => 'Anthropic';

  @override
  String get cohere => 'Cohere';

  @override
  String get customProvider => '自定义';

  @override
  String get apiEndpointHint => 'https://api.example.com/v1';

  @override
  String get apiKeyHint => 'sk-...';

  @override
  String get xaiApiKeyHint => 'sk-...';

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
  String get streamResponse => '流式回复';

  @override
  String get streamTokensAsGenerated => '生成 Token 时实时传输';

  @override
  String get useSystemPrompt => '使用系统提示词';

  @override
  String get includeSystemInstructions => '包含系统指令';

  @override
  String get configurationSavedSuccessfully => '配置保存成功';

  @override
  String get errorSavingConfiguration => '保存配置时出错';

  @override
  String get copyAll => '全部复制';

  @override
  String get showFavoritesOnly => '仅显示收藏';

  @override
  String get sortBy => '排序方式';

  @override
  String get filterByTags => '按标签筛选';

  @override
  String get favorites => '收藏';

  @override
  String get manage => '管理';

  @override
  String get noTagsCreatedYet => '尚未创建标签';

  @override
  String get createTags => '创建标签';

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个角色',
      one: '1 个角色',
    );
    return '$_temp0';
  }

  @override
  String get characterTagsLegacy => '角色标签（旧版）';

  @override
  String get done => '完成';

  @override
  String applyFiltersSelected(int count) {
    return '应用（已选 $count 项）';
  }

  @override
  String get enterPresetName => '输入预设名称';

  @override
  String get deleteScript => '删除脚本';

  @override
  String get aiConfig => 'AI 配置';

  @override
  String get authorsNoteDescription => '添加将在指定深度注入对话的上下文或指令。';

  @override
  String get enableAuthorsNote => '启用作者注释';

  @override
  String get injectNoteIntoContext => '将注释注入对话上下文';

  @override
  String get injectionDepth => '注入深度';

  @override
  String get messagesFromEndWhereInserted => '从末尾数起插入注释的消息位置';

  @override
  String get noteContent => '注释内容';

  @override
  String get authorsNoteHint =>
      '在此输入作者注释...\n\n示例：\n• [风格：使用诗意、富有描述性的方式写作]\n• [注重情感深度和角色发展]\n• [角色今天心情忧郁]';

  @override
  String get enterNameForCheckpoint => '输入此检查点的名称';

  @override
  String get addDescription => '添加描述';

  @override
  String createCheckpointAtMessage(int index) {
    return '将在消息 $index 处创建检查点。';
  }

  @override
  String get longPressMessageToBookmark => '长按消息可创建书签';

  @override
  String get contextManagement => '上下文管理';

  @override
  String get autoSummarize => '自动总结';

  @override
  String get autoSummarizeDescription => '当上下文使用率较高时自动总结并压缩聊天历史';

  @override
  String get autoSummarizeThreshold => '自动总结阈值';

  @override
  String get autoSummarizeThresholdDescription => '当上下文达到最大值的此百分比时触发总结';

  @override
  String get branchFromBookmark => '从书签创建分支';

  @override
  String branchFromBookmarkWarning(String name) {
    return '这将删除“$name”之后的所有消息，并从该位置继续。可先创建新书签以保存当前状态。';
  }

  @override
  String get branch => '分支';

  @override
  String branchedFrom(String name) {
    return '分支起点：“$name”';
  }

  @override
  String deleteBookmarkConfirmation(String name) {
    return '确定删除“$name”吗？';
  }

  @override
  String messageIndexAndDate(int index, String date) {
    return '消息 $index · $date';
  }

  @override
  String get branchFromHere => '从此处创建分支';

  @override
  String previewBookmark(String name) {
    return '预览：$name';
  }

  @override
  String get messageNotFoundInChat => '当前聊天中找不到该消息';

  @override
  String get you => '你';

  @override
  String get assistant => '助手';

  @override
  String get reasoningCopiedToClipboard => '推理内容已复制到剪贴板';

  @override
  String charsCount(int count) {
    return '$count 个字符';
  }

  @override
  String get copyReasoning => '复制推理内容';

  @override
  String get commands => '命令';

  @override
  String aliasesLabel(String aliases) {
    return '别名：$aliases';
  }

  @override
  String get noSpritesAddedYet => '尚未添加立绘';

  @override
  String get errorLoadingSprites => '加载立绘时出错';

  @override
  String get insertionPosition => '插入位置';

  @override
  String get beforeCharacterDefinition => '角色定义之前';

  @override
  String get afterCharacterDefinition => '角色定义之后';

  @override
  String get beforeExampleMessages => '示例消息之前';

  @override
  String get afterExampleMessages => '示例消息之后';

  @override
  String get beforeAuthorNote => '作者注释之前';

  @override
  String get afterAuthorNote => '作者注释之后';

  @override
  String get atDepth => '指定深度';

  @override
  String get beforeSystemPrompt => '系统提示词之前';

  @override
  String get afterSystemPrompt => '系统提示词之后';

  @override
  String get insertionOrder => '插入顺序';

  @override
  String get lowerOrderInsertsFirst => '顺序值越小越先插入';

  @override
  String get alwaysIncludeInPrompt => '始终加入提示词（忽略关键词）';

  @override
  String get requiresSecondaryKey => '主关键词和次关键词必须同时匹配';

  @override
  String get debugLog => '调试日志';

  @override
  String get debugLogDescription => '显示悬浮调试按钮以查看日志';

  @override
  String get autoScroll => '自动滚动';

  @override
  String get clearLogs => '清除日志';

  @override
  String get searchLogs => '搜索日志...';

  @override
  String get noLogsYet => '暂无日志';

  @override
  String get allCharactersAvailable => '所有角色';

  @override
  String get availableToAllCharactersNotGlobal => '所有角色可用（上下文匹配）';

  @override
  String get specificCharacter => '特定角色';

  @override
  String get linkToSpecificCharacter => '仅关联到特定角色';

  @override
  String get selectCharacter => '选择角色';

  @override
  String get pleaseSelectCharacter => '请选择一个角色';

  @override
  String get contextUsage => '上下文使用';

  @override
  String get maxContext => '最大上下文';

  @override
  String get remaining => '剩余';

  @override
  String get breakdown => '详细分解';

  @override
  String get cloudBackup => '云备份';

  @override
  String get cloudBackupInfo => '云备份';

  @override
  String get cloudBackupDescription => '跨设备同步数据';

  @override
  String get cloudBackupSubtitle => '备份到 iCloud 或 Google Drive，在任何设备上恢复';

  @override
  String get backupContents => '备份内容';

  @override
  String get allTextData => '全部文本数据';

  @override
  String get allTextDataDescription =>
      '角色、聊天、消息、世界书、群组、Persona、记忆、Data Bank、RPG 数据、故事、动态和应用状态';

  @override
  String get characterCardImages => '全部角色卡图片';

  @override
  String get characterCardImagesDescription => '角色、Persona 和群组头像，以及角色表情立绘';

  @override
  String get worldBookImages => '全部世界书图片';

  @override
  String get worldBookImagesDescription => '世界书引用的本地图片';

  @override
  String get conversationImages => '全部聊天与动态图片';

  @override
  String get conversationImagesDescription => '聊天附件、生成的聊天图片和动态图片';

  @override
  String get backgroundImages => '全部背景图片';

  @override
  String get backgroundImagesDescription => '导入的全局背景和聊天背景';

  @override
  String get live2DBackup => '全部 Live2D 模型';

  @override
  String get live2DModelsBackupDescription => '可选的大体积文件，可能显著增加备份大小';

  @override
  String get independentMediaBackup => '独立媒体备份';

  @override
  String get independentMediaBackupDescription =>
      '图片单独存储；即使媒体失败或缺失，数据备份和恢复仍可正常完成。';

  @override
  String get mediaBackupPartialSuccess => '数据库数据已成功完成，但部分媒体或设置未能备份或恢复。';

  @override
  String mediaRestoreComplete(int count) {
    return '媒体恢复完成：$count 个文件';
  }

  @override
  String get mediaNotIncludedInBackup => '此备份不包含媒体包，本次仅恢复了数据。';

  @override
  String get backupStagePreparingData => '正在整理数据库和设置...';

  @override
  String get backupStageScanningMedia => '正在扫描媒体文件...';

  @override
  String backupStageCompressingMedia(int processed, int total) {
    return '正在压缩媒体：$processed/$total 个文件';
  }

  @override
  String get backupStageUploadingData => '正在上传数据备份...';

  @override
  String get backupStageUploadingMedia => '正在上传媒体包...';

  @override
  String get backupStageDownloadingData => '正在下载数据备份...';

  @override
  String get backupStageDownloadingMedia => '正在下载媒体包...';

  @override
  String get backupStageVerifyingMedia => '正在校验媒体包...';

  @override
  String backupStageRestoringMedia(int processed, int total) {
    return '正在恢复媒体：$processed/$total 个文件';
  }

  @override
  String get backupStageRestoringData => '正在合并或替换数据库...';

  @override
  String get enableICloudBackup => '启用 iCloud 备份';

  @override
  String get enableICloudBackupDescription =>
      '将备份保存到 iCloud 云盘，以便在其他 Apple 设备上使用';

  @override
  String get enableCrossDeviceSync => '自动跨设备同步';

  @override
  String get enableCrossDeviceSyncDescription =>
      '在 Apple 设备上通过 iCloud、在 Android 及其他已登录设备上通过 Google Drive 自动保持数据最新。应用进入后台时上传，下次启动或回到前台时下载。';

  @override
  String get enableGoogleDriveBackup => '启用 Google Drive 备份';

  @override
  String get enableGoogleDriveBackupDescription =>
      '将备份保存到 Google Drive，以便在其他 Android 和已登录设备上使用';

  @override
  String get syncNow => '立即同步';

  @override
  String get crossDeviceSyncComplete => '设备已同步';

  @override
  String get openingBackupFile => '正在打开备份…';

  @override
  String get iCloudNotAvailable => 'iCloud 不可用';

  @override
  String get iCloudNotAvailableDescription => '请在设置中登录 iCloud';

  @override
  String get backupToICloud => '备份到 iCloud';

  @override
  String lastSync(String time) {
    return '上次同步：$time';
  }

  @override
  String get neverSynced => '从未同步';

  @override
  String get iCloudBackups => 'iCloud 备份';

  @override
  String get noCloudBackups => '暂无云备份';

  @override
  String get googleDriveExport => '导出到 Google Drive';

  @override
  String get googleDriveExportDescription => '保存备份文件到 Google Drive 或其他位置';

  @override
  String get googleDriveImport => '从 Google Drive 导入';

  @override
  String get googleDriveImportDescription => '从 Google Drive 或其他位置恢复备份文件';

  @override
  String get import_action => '导入';

  @override
  String get importBackup => '导入备份';

  @override
  String get backupExported => '备份导出成功';

  @override
  String get restoreSettings => '恢复设置';

  @override
  String get defaultRestoreMode => '默认恢复模式';

  @override
  String get selectRestoreMode => '选择数据恢复方式：';

  @override
  String get restoreWarning => '根据所选模式，恢复数据可能会覆盖现有数据。请确保先备份当前数据。';

  @override
  String get restore => '恢复';

  @override
  String restoreComplete(int added, int updated, int skipped) {
    return '恢复完成：新增 $added 项，更新 $updated 项，跳过 $skipped 项';
  }

  @override
  String get selectFileAndImport => '选择文件并导入';

  @override
  String get aboutRestoreModes => '关于恢复模式';

  @override
  String get aboutRestoreModesDescription =>
      '替换：用备份数据覆盖所有本地数据。\n合并：保留两者，冲突时新数据优先。\n仅添加新项：仅从备份添加新项，保留所有现有数据。';

  @override
  String get signInToGoogleDrive => '登录 Google Drive';

  @override
  String get signInToGoogleDriveDescription => '使用 Google 账户登录以备份和恢复数据';

  @override
  String get signIn => '登录';

  @override
  String get signOut => '退出登录';

  @override
  String get signedInSuccessfully => '登录成功';

  @override
  String get backupToGoogleDrive => '备份到 Google Drive';

  @override
  String get googleDriveBackups => 'Google Drive 备份';

  @override
  String get bubbleOpacity => '消息不透明度';

  @override
  String get bubbleOpacityHelp => '控制启用背景时消息气泡的透明度。';

  @override
  String get swipes => '备选回复';

  @override
  String get deleteSwipeQuestion => '删除此备选回复?';

  @override
  String get charsSuffix => '字符';

  @override
  String get swipeDeleted => '已删除备选回复';

  @override
  String get noAlternateSwipes => '没有可删除的备选回复';

  @override
  String get reasoningEffort => '推理强度';

  @override
  String get effortAuto => '自动';

  @override
  String get effortMin => '最低';

  @override
  String get effortLow => '低';

  @override
  String get effortMedium => '中';

  @override
  String get effortHigh => '高';

  @override
  String get effortMax => '最高';

  @override
  String get promptCaching => '提示词缓存';

  @override
  String get promptCachingDescription => '缓存系统提示词与历史以降低费用';

  @override
  String get mergeConsecutiveRoles => '合并连续同角色消息';

  @override
  String get mergeConsecutiveRolesDescription => '用于要求 user/assistant 严格交替的接口';

  @override
  String get connectionProfiles => '连接档案';

  @override
  String get connectionProfilesHint => '保存当前连接以便快速切换';

  @override
  String profilesSavedCount(String count) {
    return '已保存 $count 个';
  }

  @override
  String get saveCurrent => '保存当前';

  @override
  String get noProfilesHint => '还没有档案。保存当前连接,以后即可一键切换。';

  @override
  String appliedProfile(String name) {
    return '已应用档案:$name';
  }

  @override
  String get saveConnectionProfile => '保存连接档案';

  @override
  String get profileName => '档案名称';

  @override
  String get gallery => '图库';

  @override
  String get allLabel => '全部';

  @override
  String get ungrouped => '未分组';

  @override
  String get setAsBackground => '设为背景';

  @override
  String get moveToFolder => '移动到文件夹';

  @override
  String get folderName => '文件夹名称';

  @override
  String get folderNameHint => '留空表示未分组';

  @override
  String get move => '移动';

  @override
  String moveFailed(String error) {
    return '移动失败:$error';
  }

  @override
  String deleteFailed(String error) {
    return '删除失败:$error';
  }

  @override
  String get embedPendingDocuments => '嵌入待处理文档';

  @override
  String embeddedDocuments(String count) {
    return '已嵌入 $count 个文档';
  }

  @override
  String get allDocumentsEmbedded => '所有文档均已嵌入';

  @override
  String embeddingFailed(String error) {
    return '嵌入失败:$error';
  }

  @override
  String get gptImageSettings => 'GPT-Image 设置';

  @override
  String get qualityLabel => '质量';

  @override
  String get qualityAutoDescription => '自动 - 由模型决定';

  @override
  String get qualityHighDescription => '高 - 更高细节与一致性';

  @override
  String get impersonate => 'AI 代打';

  @override
  String get impersonateHint => '让 AI 以你的口吻写一条回复';

  @override
  String get startReplyWith => '回复引导';

  @override
  String get startReplyWithHint => 'AI 的回复将以这段文字开头';

  @override
  String get chatLorebooks => '聊天世界书';

  @override
  String get chatLorebooksHint => '仅在本聊天中生效的世界书';

  @override
  String get messagesCleared => '已清空全部消息';

  @override
  String get selectCharacterCardFiles => '选择角色卡文件';

  @override
  String get supportedCharacterCardFormats => '支持批量导入：PNG、CharX 和 JSON';

  @override
  String get importFromUrl => '从网址导入';

  @override
  String get enterCharacterCardUrl => '输入角色卡链接...';

  @override
  String get pasteAndImport => '粘贴并导入';

  @override
  String get supportedCommunities => '支持的社区（点击访问）：';

  @override
  String get publicCardLinksSupported => '也支持公开的 PNG 和 JSON 链接';

  @override
  String get communityLinks => '社区链接';

  @override
  String importSummaryMixed(Object failed, Object success) {
    return '成功导入 $success 个角色卡，$failed 个失败';
  }

  @override
  String importSummarySuccess(Object count) {
    return '成功导入 $count 个角色卡';
  }

  @override
  String get importSummaryFailed => '所有导入都失败了';

  @override
  String processingProgress(Object processed, Object total) {
    return '处理中：$processed / $total';
  }

  @override
  String get importSuccessLabel => '成功';

  @override
  String get importFailureLabel => '失败';

  @override
  String get totalLabel => '总计';

  @override
  String importAllCharacters(Object count) {
    return '导入全部（$count）';
  }

  @override
  String get switchLayout => '切换布局';

  @override
  String get stopGenerating => '停止生成';

  @override
  String get imageBackgroundSettings => '图片背景设置';

  @override
  String get useCharacterImageAsBackground => '使用角色卡图片作为背景';

  @override
  String get useCharacterImageAsBackgroundHint => '角色卡有头像时自动用作聊天背景';

  @override
  String get backgroundOpacity => '背景透明度';

  @override
  String get backgroundOpacityHint => '应用于自定义图片和角色卡图片背景';

  @override
  String get enableBackgroundBlur => '启用背景模糊效果';

  @override
  String get enableBackgroundBlurHint => '应用模糊效果到所有图片背景';

  @override
  String get backgroundPriorityHint => '优先级：角色专属背景 > 全局背景 > 角色卡图片 > 默认颜色';

  @override
  String get openRouterUpstreamProvider => 'OpenRouter 上游提供商';

  @override
  String get automaticRouting => '自动路由';

  @override
  String get openRouterProviderHint => '选择此模型实际使用的上游提供商';

  @override
  String get useCurrentChatConnection => '使用当前聊天连接';

  @override
  String get chatConnectionAppliedToEmbeddings => '已将聊天接口和 API 密钥用于嵌入';

  @override
  String get localFeatures => '本地功能';

  @override
  String get playHub => '玩法';

  @override
  String get story => '故事';

  @override
  String get storyEnabledSubtitle => '关闭后不会分析聊天，也不会生成或更新故事章节。';

  @override
  String playAiFeatureEnableTitle(String feature) {
    return '开启“$feature”？';
  }

  @override
  String playAiFeatureEnableDescription(String feature) {
    return '“$feature”会主动将角色信息和相关对话发送给你配置的 AI 提供商来生成内容。此功能默认关闭。是否现在开启？';
  }

  @override
  String get playAiFeatureEnableAction => '开启';

  @override
  String get storyEmptyHint => '聊一段时间才会有故事。';

  @override
  String get storyGoToChat => '去聊天';

  @override
  String get storyJotNote => '记一笔';

  @override
  String get storyJotNoteHint => '写一句短记事。这里不是章节编辑器。';

  @override
  String get storyKeyEvents => '发生了什么';

  @override
  String get storyStateChanges => '改变了什么';

  @override
  String get storyOpenThreads => '还没解决';

  @override
  String get storyNextSteps => '可以怎么继续';

  @override
  String get storyContinue => '接着演';

  @override
  String get storyFork => '从这里分叉';

  @override
  String get storyCompare => '对照后果';

  @override
  String get storyViewSource => '查看原文';

  @override
  String get storyOriginalLine => '原始路线';

  @override
  String get storyBranchName => '分支名称';

  @override
  String get storyBranchNameHint => '例如：这次我选择留下';

  @override
  String get storyCreateBranch => '创建分支';

  @override
  String get storyDefaultDirection => '从这一章尚未解决的时刻继续。';

  @override
  String storyContinueDraft(String title, String direction) {
    return '接着「$title」往下演：$direction';
  }

  @override
  String storyForkCreated(String name) {
    return '分支“$name”已经准备好。';
  }

  @override
  String get storyNoOutcome => '这条路线还没有形成新的章节后果。';

  @override
  String get storyChooseTwoLines => '选择两条路线进行对照。';

  @override
  String get storyLeftLine => '第一条路线';

  @override
  String get storyRightLine => '第二条路线';

  @override
  String get storySearch => '搜索故事';

  @override
  String get storyNoSearchResults => '没有匹配的章节。';

  @override
  String get storySelectLine => '故事线';

  @override
  String get storyNoteSaved => '已经记进故事。';

  @override
  String get storyNoChats => '先开始一场聊天，才能记故事。';

  @override
  String get storyConsequencesAfterFork => '分叉之后';

  @override
  String get moments => '动态';

  @override
  String get momentsDisabledEmpty => '动态已关闭。去设置里打开。';

  @override
  String get momentsEnabledSubtitle => '关闭后动态不再更新，角色也不会再发。';

  @override
  String get momentsInChat => '本聊天带入动态';

  @override
  String get momentsInChatHint => '默认关闭。打开后，这个角色才会知道好友和你的动态。';

  @override
  String get momentsEmpty => '还没人发过。';

  @override
  String get momentsRefreshing => '大家正在发动态…';

  @override
  String get momentsCompose => '发表';

  @override
  String get momentsComposeHint => '这一刻的想法…';

  @override
  String get momentsAuthor => '谁在发';

  @override
  String get momentsAuthorMe => '我';

  @override
  String get momentsAddPhoto => '加张图';

  @override
  String get momentsChangePhoto => '换一张';

  @override
  String get momentsNeedSomething => '先写点什么，或者加张图。';

  @override
  String get momentsComment => '评论';

  @override
  String get momentsSavePhoto => '保存图片';

  @override
  String get momentsPhotoSaved => '图片保存成功';

  @override
  String get momentsPhotoSaveFailed => '图片保存失败';

  @override
  String get momentsFriends => '好友';

  @override
  String get momentsNoFriends => '还没有好友。同一群聊里的角色可以互加。';

  @override
  String get momentsTalk => '开聊';

  @override
  String get momentsExpose => '拆穿';

  @override
  String get momentsIgnore => '已读不回';

  @override
  String get momentsWaiting => '等对方回';

  @override
  String get momentsWaitingBadge => '等待中';

  @override
  String get momentsIgnoredBadge => '已读不回';

  @override
  String get momentsWriteToWorld => '写入世界';

  @override
  String momentsFact(String fact) {
    return '实情：$fact';
  }

  @override
  String get playFeatureComingSoon => '这个玩法还没准备好。';

  @override
  String get openDataBank => '打开资料';

  @override
  String get openDataBankSubtitle => '从玩法进入资料库';

  @override
  String get memoryInbox => '记忆收件箱';

  @override
  String get memoryInboxSubtitle => '审核和维护长期记忆';

  @override
  String get dataBank => '资料库';

  @override
  String get dataBankSubtitle => '导入、搜索并绑定本地文档';

  @override
  String get rpgScenarioEditor => 'RPG 剧本编辑器';

  @override
  String get rpgScenarioEditorSubtitle => '创建并验证本地剧本包';

  @override
  String get capabilityCheck => '功能检查';

  @override
  String get capabilityCheckSubtitle => '可用性、权限和配置';

  @override
  String get mcpServers => 'MCP 服务器';

  @override
  String get mcpServersSubtitle => '连接、工具、权限和活动';

  @override
  String get toolCalling => '工具调用';

  @override
  String get toolCallingSubtitle => '内置工具、审批和限制';

  @override
  String get toolCallingAllow => '允许工具调用';

  @override
  String get toolCallingAllowSubtitle => '模型提供商只能请求下方启用的工具';

  @override
  String get toolBuiltInTools => '内置工具';

  @override
  String get toolMcpTools => 'MCP 工具';

  @override
  String get toolMcpPermissionsSubtitle => '已连接的 MCP 服务器使用各自的权限设置';

  @override
  String get toolSafetyLimits => '安全限制';

  @override
  String get toolRounds => '工具轮次';

  @override
  String get toolCallsPerResponse => '每次回复的调用数';

  @override
  String get toolTimeLimit => '时间限制';

  @override
  String get toolTokenBudget => '工具 Token 预算';

  @override
  String get toolSeconds => '秒';

  @override
  String get toolTokens => 'Token';

  @override
  String toolDecrease(String control) {
    return '减少$control';
  }

  @override
  String toolIncrease(String control) {
    return '增加$control';
  }

  @override
  String get toolActivity => '工具活动';

  @override
  String get toolApprovalRequired => '需要批准';

  @override
  String get toolAllowOnce => '仅允许一次';

  @override
  String get toolAlwaysAllow => '始终允许';

  @override
  String get toolDeny => '拒绝';

  @override
  String get toolCancelCall => '取消工具调用';

  @override
  String get toolStatusWaitingApproval => '等待批准';

  @override
  String get toolStatusRunning => '运行中';

  @override
  String get toolStatusSucceeded => '已成功';

  @override
  String get toolStatusFailed => '失败';

  @override
  String get toolStatusDenied => '已拒绝';

  @override
  String get toolStatusCancelled => '已取消';

  @override
  String get storageManagement => '存储管理';

  @override
  String get storageManagementSubtitle => '空间用量、孤立文件扫描和安全清理';

  @override
  String storageUsedOfQuota(String used, String quota) {
    return '已使用 $used，配额 $quota';
  }

  @override
  String get storageQuotaWarning => '存储用量已超过警告阈值';

  @override
  String get storageWithinQuota => '存储用量未超过警告阈值';

  @override
  String storageScanIncomplete(int count) {
    return '有 $count 个路径无法检查';
  }

  @override
  String get storageCategoryLive2d => 'Live2D 模型';

  @override
  String get storageCategoryAttachments => '附件和媒体';

  @override
  String get storageCategoryDataBank => '资料库文档';

  @override
  String get storageCategoryAudio => '音频';

  @override
  String get storageCategoryCache => '缓存';

  @override
  String storageFilesCount(int count) {
    return '$count 个文件';
  }

  @override
  String storageReclaimable(String size) {
    return '可回收 $size';
  }

  @override
  String get storageCleanupCandidates => '安全清理';

  @override
  String get storageNoCleanupCandidates => '未发现无引用或已过期的文件';

  @override
  String get storageSelectAll => '全选';

  @override
  String get storageClearSelection => '清除选择';

  @override
  String get storageUndo => '撤销';

  @override
  String get storageCleanSelected => '清理所选项';

  @override
  String get storageCleanupReviewTitle => '确认清理';

  @override
  String storageCleanupReviewBody(int items, int files, String size) {
    return '将 $items 项（共 $files 个文件，占用 $size）移至可恢复的废纸篓？';
  }

  @override
  String get storageCleanupRecoverableHint => '有引用的文件会受到保护。在暂存文件被永久删除前，可以撤销操作。';

  @override
  String storageCleanupMoved(int count) {
    return '已将 $count 项移至可恢复的废纸篓';
  }

  @override
  String get storageCleanupRestored => '已撤销清理';

  @override
  String get storageCleanupCompleted => '清理完成';

  @override
  String storageCleanupFailed(String error) {
    return '清理失败：$error';
  }

  @override
  String get storageReasonInterruptedTemporary => '中断操作留下的临时数据';

  @override
  String get storageReasonMissingDatabaseReference => '数据库中没有文档引用此数据';

  @override
  String get storageReasonInterruptedDocumentCleanup => '文档清理被中断';

  @override
  String get storageReasonMissingFileReference => '数据库中没有记录引用此文件';

  @override
  String get storageReasonExpiredTransient => '已过期的临时数据';

  @override
  String get storageReasonExpiredAudio => '已过期的合成音频';

  @override
  String get live2dUnavailableModelMessage => '已分配的 Live2D 模型不可用。请选择其他模型或重新导入。';

  @override
  String get live2dSelectionExpiredMessage => '该 Live2D 模型已不可用。请选择其他模型或重新导入。';

  @override
  String live2dModelsImported(int count) {
    return '已导入 $count 个 Live2D 模型';
  }

  @override
  String get live2dModelDeleted => '已删除导入的 Live2D 模型。';

  @override
  String get live2dCleanupPending => ' 文件清理将在下次刷新模型库时重试。';

  @override
  String get live2dDeleteImportedModelQuestion => '删除导入的模型？';

  @override
  String live2dDeletePackageBody(int count) {
    return '此模型包包含 $count 个模型，它们都会被删除。';
  }

  @override
  String live2dDeleteModelBody(String name) {
    return '将从此设备删除“$name”。';
  }

  @override
  String get live2dDisabledFor => '以下角色将停用 Live2D：';

  @override
  String get live2dLicensing => 'Live2D 许可信息';

  @override
  String get live2dLicenseNotice =>
      '渲染器包含 Live2D Cubism SDK 和 Core。模型文件及商业发行可能适用其他条款。\n\n内置的 Hiyori Momose 模型是 Live2D Inc. 拥有版权的官方示例数据，并依据 Live2D 免费素材许可协议和示例数据使用条款使用。本应用由作者自行决定制作。\n\n发布应用前，请确认每个导入模型的使用权。';

  @override
  String get live2dReviewTerms => '查看条款';

  @override
  String live2dUnavailableLabel(String name) {
    return '$name（不可用）';
  }

  @override
  String live2dImportedLabel(String name) {
    return '$name（已导入）';
  }

  @override
  String get live2dImportZip => '导入模型';

  @override
  String get live2dMotion => '动作';

  @override
  String get live2dPlayMotion => '播放动作';

  @override
  String get live2dStageAdjustment => '舞台调整';

  @override
  String get live2dMotionSpeed => '动作速度';

  @override
  String get live2dImportedModels => '已导入模型';

  @override
  String live2dModelsCount(int count) {
    return '$count 个模型';
  }

  @override
  String get live2dDeleteImportedModel => '删除导入的模型';

  @override
  String get rpgScenarioTitle => 'RPG 剧本';

  @override
  String get rpgImportScenario => '导入剧本';

  @override
  String get rpgSaveDraft => '保存草稿';

  @override
  String get rpgRestoreDraft => '恢复草稿';

  @override
  String get rpgExportScenario => '导出剧本';

  @override
  String get rpgIssues => '问题';

  @override
  String rpgIssuesCount(int count) {
    return '问题（$count）';
  }

  @override
  String get rpgScenarioImportFailed => '剧本导入失败';

  @override
  String rpgScenarioImported(String name) {
    return '已导入 $name';
  }

  @override
  String get rpgDraftSaved => '草稿已保存';

  @override
  String get rpgDraftRestored => '草稿已恢复';

  @override
  String get rpgNoSavedDraft => '没有已保存的草稿';

  @override
  String get rpgScenarioExported => '剧本已导出';

  @override
  String get rpgSetValue => '设置值';

  @override
  String rpgAddItem(String label) {
    return '添加$label';
  }

  @override
  String get rpgItemActions => '项目操作';

  @override
  String get rpgMoveUp => '上移';

  @override
  String get rpgMoveDown => '下移';

  @override
  String get rpgAddEntry => '添加条目';

  @override
  String get rpgDeleteEntry => '删除条目';

  @override
  String rpgAddEntryTitle(String label) {
    return '添加$label条目';
  }

  @override
  String get rpgValue => '值';

  @override
  String get rpgEnterInteger => '请输入整数';

  @override
  String get rpgEnterNumber => '请输入数字';

  @override
  String rpgItemNumber(int number) {
    return '项目 $number';
  }

  @override
  String rpgFieldLabel(String field) {
    String _temp0 = intl.Intl.selectLogic(
      field,
      {
        'metadata': '元数据',
        'compatibility': '兼容性',
        'initialState': '初始状态',
        'initialSeed': '初始种子',
        'schemaVersion': '结构版本',
        'protectedFields': '受保护字段',
        'minimumEngineVersion': '最低引擎版本',
        'maximumEngineVersion': '最高引擎版本',
        'requiredCapabilities': '所需功能',
        'actors': '角色',
        'attributes': '属性',
        'author': '作者',
        'availability': '可用性',
        'branchId': '分支 ID',
        'conditions': '条件',
        'cooldowns': '冷却',
        'costs': '消耗',
        'createdAt': '创建时间',
        'data': '数据',
        'day': '天数',
        'description': '描述',
        'difficulty': '难度',
        'effects': '效果',
        'elapsedMinutes': '已过分钟',
        'eventHistory': '事件历史',
        'expression': '表达式',
        'failureEffects': '失败效果',
        'format': '格式',
        'id': 'ID',
        'initialValue': '初始值',
        'inventory': '物品栏',
        'items': '物品',
        'label': '标签',
        'locations': '地点',
        'maximum': '最大值',
        'minimum': '最小值',
        'minuteOfDay': '当日分钟',
        'name': '名称',
        'narrative': '叙事',
        'objectiveIds': '目标 ID',
        'objectiveProgress': '目标进度',
        'operator': '运算符',
        'quantity': '数量',
        'quests': '任务',
        'relationships': '关系',
        'source': '来源',
        'stages': '阶段',
        'status': '状态',
        'successEffects': '成功效果',
        'summary': '摘要',
        'tags': '标签',
        'target': '目标',
        'turn': '回合',
        'type': '类型',
        'updatedAt': '更新时间',
        'value': '值',
        'variables': '变量',
        'version': '版本',
        'other': '$field',
      },
    );
    return '$_temp0';
  }

  @override
  String get dataBankChatRetrievalSettings => '聊天检索设置';

  @override
  String get dataBankRebuildSearchIndex => '重建搜索索引';

  @override
  String get dataBankImportDocument => '导入文档';

  @override
  String get dataBankSearchDocuments => '搜索文档';

  @override
  String get dataBankClearSearch => '清除搜索';

  @override
  String get dataBankNoMatches => '没有匹配结果';

  @override
  String get dataBankNoDocuments => '暂无文档';

  @override
  String get dataBankSearchIndexRebuilt => '搜索索引已重建';

  @override
  String dataBankDeleteDocumentQuestion(String name) {
    return '删除 $name？';
  }

  @override
  String dataBankDeleteDocumentBody(
      int versions, int chunks, int bindings, int files) {
    return '将删除 $versions 个版本、$chunks 个分块、$bindings 个绑定和 $files 个托管文件。';
  }

  @override
  String get dataBankChatRetrieval => '聊天检索';

  @override
  String get dataBankUseInChat => '在聊天中使用资料库';

  @override
  String get dataBankQueryExpansion => '基于对话扩展查询';

  @override
  String get dataBankSemanticReranking => '语义重排';

  @override
  String get dataBankUsesEmbeddingProvider => '使用已配置的嵌入模型提供商';

  @override
  String get dataBankSourcesPerResponse => '每次回复的来源数';

  @override
  String get dataBankTokenBudget => 'Token 预算';

  @override
  String get dataBankChunksPerDocument => '每篇文档的分块数';

  @override
  String get dataBankLastRetrieval => '上次检索';

  @override
  String get dataBankNoRetrievalYet => '尚未执行过聊天检索。';

  @override
  String get dataBankModeLocalFts => '本地全文搜索';

  @override
  String get dataBankModeSemantic => '混合语义重排';

  @override
  String get dataBankModeFallback => '本地回退';

  @override
  String dataBankSourcesCount(int count) {
    return '$count 个来源';
  }

  @override
  String get dataBankInspectAllSources => '查看所有来源';

  @override
  String dataBankChunksCount(int count) {
    return '$count 个分块';
  }

  @override
  String dataBankBindingsCount(int count) {
    return '$count 个绑定';
  }

  @override
  String get dataBankProcessingFailed => '处理失败';

  @override
  String get dataBankManageBindings => '管理绑定';

  @override
  String get dataBankRebuildDocument => '重建文档';

  @override
  String get dataBankBindings => '绑定';

  @override
  String get dataBankRemoveBinding => '移除绑定';

  @override
  String get dataBankAddBinding => '添加绑定';

  @override
  String dataBankStatusSemantics(String status) {
    return '状态：$status';
  }

  @override
  String get dataBankDismiss => '关闭提示';

  @override
  String get dataBankStatePending => '等待处理';

  @override
  String get dataBankStateProcessing => '处理中';

  @override
  String get dataBankStateReady => '就绪';

  @override
  String get dataBankStateFailed => '失败';

  @override
  String get dataBankStateDeleted => '已删除';

  @override
  String get dataBankDuplicateDocument => '该文档已存在于资料库中。';

  @override
  String get memoryChatContext => '聊天上下文';

  @override
  String get memoryAutomaticExtraction => '自动提取';

  @override
  String get memoryAutomaticExtractionSubtitle => '在新对话轮次后使用当前 AI 连接';

  @override
  String get memoryRecentChat => '最近聊天';

  @override
  String get memoryCancelExtraction => '取消提取';

  @override
  String get memoryExtractFromChat => '从聊天中提取';

  @override
  String memoryExtractionResult(int candidates, int duplicates, int rejected) {
    return '$candidates 个候选，$duplicates 个重复，$rejected 个被拒绝';
  }

  @override
  String memoryCandidatesCount(int count) {
    return '候选 $count';
  }

  @override
  String memoryActiveCount(int count) {
    return '生效中 $count';
  }

  @override
  String memoryHistoryCount(int count) {
    return '历史 $count';
  }

  @override
  String get memoryCreate => '创建记忆';

  @override
  String get memoryClearSelection => '清除选择';

  @override
  String get memoryIgnoreSelected => '忽略所选项';

  @override
  String get memoryMergeSelected => '合并所选项';

  @override
  String memorySelectedCount(int count) {
    return '已选择 $count 项';
  }

  @override
  String get memoryUseInChat => '在聊天中使用记忆';

  @override
  String get memorySemanticReranking => '语义重排';

  @override
  String get memoryConfiguredEmbeddingProvider => '已配置的嵌入模型提供商';

  @override
  String get memoryContextBudget => '上下文预算';

  @override
  String memoryTokensCount(int count) {
    return '$count Token';
  }

  @override
  String get memoryEdit => '编辑记忆';

  @override
  String get memoryMerge => '合并记忆';

  @override
  String memoryImportancePercent(int percent) {
    return '重要性 $percent%';
  }

  @override
  String memoryExpires(String date) {
    return '到期时间 $date';
  }

  @override
  String get memoryApprove => '批准';

  @override
  String get memoryUnlock => '解锁';

  @override
  String get memoryLock => '锁定';

  @override
  String get memoryOpenSource => '打开来源';

  @override
  String get memoryIgnore => '忽略';

  @override
  String get memoryChatScope => '聊天范围';

  @override
  String get memoryKind => '类型';

  @override
  String get memoryLabel => '记忆';

  @override
  String get memoryIdentityKey => '标识键';

  @override
  String get memoryImportance => '重要性';

  @override
  String get memoryLocked => '已锁定';

  @override
  String get memoryKindPersonFact => '人物事实';

  @override
  String get memoryKindRelationship => '关系';

  @override
  String get memoryKindEvent => '事件';

  @override
  String get memoryKindCommitment => '承诺';

  @override
  String get memoryKindPreference => '偏好';

  @override
  String get memoryKindLocation => '地点';

  @override
  String get memoryKindOther => '其他';

  @override
  String get memoryScopeCharacterPersona => '角色和用户设定';

  @override
  String get memoryScopeGroup => '群组';

  @override
  String get mcpAddServer => '添加 MCP 服务器';

  @override
  String get mcpServersTab => '服务器';

  @override
  String get mcpActivityTab => '活动';

  @override
  String get mcpProtocolName => '模型上下文协议';

  @override
  String get mcpNoServers => '暂无 MCP 服务器';

  @override
  String mcpErrorCode(String code) {
    return '代码：$code';
  }

  @override
  String mcpProtocolVersion(String version) {
    return '协议 $version';
  }

  @override
  String get mcpDisconnect => '断开连接';

  @override
  String get mcpRefreshTools => '刷新工具';

  @override
  String get mcpReconnect => '重新连接';

  @override
  String get mcpConnect => '连接';

  @override
  String get mcpEditServer => '编辑 MCP 服务器';

  @override
  String get mcpRemoveServer => '移除 MCP 服务器';

  @override
  String get mcpNoToolsDiscovered => '未发现工具';

  @override
  String get mcpRemoveServerQuestion => '移除 MCP 服务器？';

  @override
  String get mcpRemove => '移除';

  @override
  String get mcpToolPermission => '工具权限';

  @override
  String get mcpAskEveryTime => '每次询问';

  @override
  String get mcpAlwaysAllow => '始终允许';

  @override
  String get mcpDenied => '已拒绝';

  @override
  String get mcpNoActivity => '暂无 MCP 活动';

  @override
  String get mcpEndpoint => 'MCP 端点';

  @override
  String get mcpTransport => '传输方式';

  @override
  String get mcpBearerToken => 'Bearer Token';

  @override
  String get mcpShowToken => '显示 Token';

  @override
  String get mcpHideToken => '隐藏 Token';

  @override
  String get mcpRemoveStoredToken => '移除已存储的 Token';

  @override
  String get mcpAllowInsecureHttp => '允许不安全的 HTTP';

  @override
  String get mcpServerEnabled => '启用服务器';

  @override
  String get mcpDisconnected => '已断开';

  @override
  String get mcpConnecting => '连接中';

  @override
  String get mcpConnected => '已连接';

  @override
  String get mcpReconnecting => '重新连接中';

  @override
  String get mcpReadOnlyHint => '只读提示';

  @override
  String get mcpWriteCapable => '可写入';

  @override
  String get mcpExternalSideEffect => '会产生外部影响';

  @override
  String get capabilityCheckFailed => '功能检查失败';

  @override
  String get capabilityRecentExternalActivity => '最近的外部活动';

  @override
  String get capabilityAuditUnavailable => '审计历史不可用';

  @override
  String get capabilityNoExternalCalls => '没有外部调用记录';

  @override
  String capabilityReadyCount(int ready, int total) {
    return '$total 项中有 $ready 项就绪';
  }

  @override
  String get capabilityOpenSettings => '打开设置';

  @override
  String get capabilityRequestPermission => '请求权限';

  @override
  String get capabilityCurrentAi => '当前 AI';

  @override
  String get capabilitySystemSpeech => '系统语音';

  @override
  String get capabilityVoiceInput => '语音输入';

  @override
  String get capabilitySemanticSearch => '语义搜索';

  @override
  String get capabilityMcpTools => 'MCP 工具';

  @override
  String get capabilityChatGenerationConnection => '聊天生成连接';

  @override
  String get capabilityDeviceTts => '设备文字转语音';

  @override
  String get capabilityDeviceSpeechRecognition => '设备语音识别';

  @override
  String get capabilityOptionalEmbeddingConnection => '可选的嵌入模型连接';

  @override
  String get capabilityOptionalImageConnection => '可选的图像连接';

  @override
  String get capabilityExternalToolServers => '外部工具服务器';

  @override
  String get capabilityBundledCharacterRendering => '内置角色渲染';

  @override
  String get capabilityCompleteAiConnection => '请完善当前 AI 连接';

  @override
  String get capabilityCompleteEmbeddingConnection => '请完善嵌入模型连接';

  @override
  String get capabilityCompleteImageConnection => '请完善图像连接';

  @override
  String get capabilityConfigurationRequired => '需要配置';

  @override
  String get capabilityConfigured => '已配置';

  @override
  String get capabilityAvailable => '可用';

  @override
  String get capabilityPermissionRequired => '需要权限';

  @override
  String get capabilityPermissionDenied => '权限被拒绝';

  @override
  String get capabilityDownloadRequired => '需要下载';

  @override
  String get capabilityUnavailableOffline => '离线时不可用';

  @override
  String get capabilityUnavailableBuild => '此版本中不可用';

  @override
  String get capabilityDataMetadata => '元数据';

  @override
  String get capabilityDataPrompt => '提示词';

  @override
  String get capabilityDataChatText => '聊天文本';

  @override
  String get capabilityDataDocumentText => '文档文本';

  @override
  String get capabilityDataImage => '图像';

  @override
  String get capabilityDataAudio => '音频';

  @override
  String get capabilityDataCharacterCard => '角色卡';

  @override
  String get capabilityDataToolArguments => '工具参数';

  @override
  String dataBankCitationSourcesCount(int count) {
    return '$count 个资料库来源';
  }

  @override
  String get dataBankCitationSources => '资料库来源';

  @override
  String dataBankLocalQueriesFused(int count) {
    return '已合并 $count 个本地查询';
  }

  @override
  String get memoryUsed => '已使用的记忆';

  @override
  String memoryTokenUsage(int used, int allocated) {
    return '$used/$allocated Token';
  }

  @override
  String memoryRelevancePercent(int percent) {
    return '相关性 $percent%';
  }

  @override
  String get memoryModeLocalFts => '本地全文搜索';

  @override
  String get memoryModeHybrid => '混合检索';

  @override
  String get memoryModeLocalFallback => '本地全文搜索回退';

  @override
  String get memoryIncluded => '已纳入';

  @override
  String get memoryTrimmed => '已裁剪';

  @override
  String get memoryExcluded => '已排除';

  @override
  String rpgTurnNumber(int turn) {
    return '第 $turn 回合';
  }

  @override
  String get rpgDisableMode => '关闭 RPG 模式';

  @override
  String get rpgStatus => '状态';

  @override
  String get rpgInventory => '物品栏';

  @override
  String get rpgQuests => '任务';

  @override
  String get rpgRelations => '关系';

  @override
  String get rpgActions => '行动';

  @override
  String get rpgLog => '日志';

  @override
  String get rpgLocation => '地点';

  @override
  String get rpgTime => '时间';

  @override
  String rpgDayTime(int day, String time) {
    return '第 $day 天，$time';
  }

  @override
  String get rpgInventoryEmpty => '物品栏为空';

  @override
  String get rpgNoQuests => '暂无任务';

  @override
  String get rpgNoRelationships => '暂无关系';

  @override
  String get rpgNoActions => '未定义行动';

  @override
  String rpgCost(String cost) {
    return '消耗：$cost';
  }

  @override
  String rpgCheck(String dice, String attribute, num difficulty) {
    return '检定：$dice + $attribute 对抗 $difficulty';
  }

  @override
  String rpgCooldown(int turns) {
    return '冷却：$turns 回合';
  }

  @override
  String get rpgRequirementsNotMet => '不满足要求或资源不足';

  @override
  String get rpgNoTurnsRecorded => '暂无回合记录';

  @override
  String get rpgSnapshots => '快照';

  @override
  String get rpgSnapshotActions => '快照操作';

  @override
  String get rpgRestoreSnapshot => '恢复快照';

  @override
  String get rpgForkNewBranch => '创建新分支';

  @override
  String get rpgRuleEngineSource => '来源：规则引擎';

  @override
  String rpgRoll(String total, String expression) {
    return '掷骰：$total（$expression）';
  }

  @override
  String rpgChanges(String changes) {
    return '变更：$changes';
  }

  @override
  String get rpgForkBranch => '创建分支';

  @override
  String get rpgBranchId => '分支 ID';

  @override
  String get rpgFork => '创建';

  @override
  String get rpgQuestInactive => '未激活';

  @override
  String get rpgQuestActive => '进行中';

  @override
  String get rpgQuestCompleted => '已完成';

  @override
  String get rpgQuestFailed => '失败';

  @override
  String get rpgEnableMode => '开启 RPG 模式';

  @override
  String get noImageGenerated => '未生成图片';

  @override
  String failedToSaveImage(String error) {
    return '保存图片失败：$error';
  }

  @override
  String imagesAdded(int count) {
    return '已添加 $count 张图片';
  }

  @override
  String get addConnection => '添加关联';

  @override
  String get group => '群组';

  @override
  String get lockType => '锁定类型';

  @override
  String errorLoadingCharacters(String error) {
    return '加载角色失败：$error';
  }

  @override
  String errorLoadingGroups(String error) {
    return '加载群组失败：$error';
  }

  @override
  String get inSystemPrompt => '系统提示词中';

  @override
  String get connectingGoogleDrive => '正在连接 Google 云端硬盘...';

  @override
  String get checkingICloud => '正在检查 iCloud...';

  @override
  String get whatIsPromptManager => '什么是提示词管理器？';

  @override
  String get promptManagerHelpDescription =>
      '提示词管理器控制消息发送给 AI 前系统提示词的组装方式。你可以调整各部分的顺序，并启用或停用它们。';

  @override
  String get promptSectionTypes => '提示词部分类型';

  @override
  String get promptSectionTypesDescription =>
      '提示词可包含系统指令、用户设定、角色信息、场景、世界书上下文、示例消息、作者注释、聊天记录和历史记录后指令。';

  @override
  String get tips => '提示';

  @override
  String get promptManagerTips =>
      '越靠上的部分优先级越高。停用不需要的部分可以节省 Token，也可以调整顺序来获得不同效果。';

  @override
  String get customImportedPrompt => '从预设导入的自定义提示词';

  @override
  String editPromptSection(String name) {
    return '编辑$name';
  }

  @override
  String get promptName => '提示词名称';

  @override
  String identifierLabel(String identifier) {
    return 'ID：$identifier';
  }

  @override
  String roleLabel(String role) {
    return '角色：$role';
  }

  @override
  String supportedPromptMacros(
      String userMacro, String charMacro, String timeMacro, String dateMacro) {
    return '支持 $userMacro、$charMacro、$timeMacro 和 $dateMacro 等宏。';
  }

  @override
  String get enterPromptContent => '输入提示词内容...';

  @override
  String updated(String name) {
    return '已更新$name';
  }

  @override
  String get customPrompt => '自定义提示词';

  @override
  String get promptSectionSystemPrompt => '系统提示词';

  @override
  String get promptSectionSystemPromptDescription => '基础角色扮演指令';

  @override
  String get promptSectionPersona => '用户设定';

  @override
  String get promptSectionPersonaDescription => '你的用户设定信息';

  @override
  String get promptSectionCharacterDescription => '角色描述';

  @override
  String get promptSectionCharacterDescriptionDescription => 'AI 角色的详细信息';

  @override
  String get promptSectionCharacterPersonality => '角色性格';

  @override
  String get promptSectionCharacterPersonalityDescription => '角色的性格特征';

  @override
  String get promptSectionScenario => '场景';

  @override
  String get promptSectionScenarioDescription => '当前情境与背景设定';

  @override
  String get promptSectionExampleMessages => '示例消息';

  @override
  String get promptSectionExampleMessagesDescription => '用于展示对话风格的示例';

  @override
  String get promptSectionWorldInfoBefore => '前置世界书';

  @override
  String get promptSectionWorldInfoBeforeDescription => '插入在角色信息之前的世界书上下文';

  @override
  String get promptSectionWorldInfoAfter => '后置世界书';

  @override
  String get promptSectionWorldInfoAfterDescription => '插入在角色信息之后的世界书上下文';

  @override
  String get promptSectionAuthorNote => '作者注释';

  @override
  String get promptSectionAuthorNoteDescription => '当前聊天使用的动态指令';

  @override
  String get promptSectionPostHistory => '历史记录后指令';

  @override
  String get promptSectionPostHistoryDescription => '插入在聊天记录之后的指令';

  @override
  String get promptSectionNsfw => 'NSFW 提示词';

  @override
  String get promptSectionNsfwDescription => '可选的成人内容指令';

  @override
  String get promptSectionChatHistory => '聊天记录';

  @override
  String get promptSectionChatHistoryDescription => '会话中的近期消息';

  @override
  String get promptSectionEnhanceDefinitions => '强化定义';

  @override
  String get promptSectionEnhanceDefinitionsDescription => '用于强化角色定义的附加指令';

  @override
  String get promptSectionCustomDescription => '自定义提示词部分';

  @override
  String get reasoning => '推理内容';

  @override
  String get emotionNeutral => '平静';

  @override
  String get emotionHappy => '开心';

  @override
  String get emotionSad => '悲伤';

  @override
  String get emotionAngry => '生气';

  @override
  String get emotionSurprised => '惊讶';

  @override
  String get emotionScared => '害怕';

  @override
  String get emotionDisgusted => '厌恶';

  @override
  String get emotionConfused => '困惑';

  @override
  String get emotionEmbarrassed => '尴尬';

  @override
  String get emotionExcited => '兴奋';

  @override
  String get emotionLoving => '喜爱';

  @override
  String get emotionThinking => '思考';

  @override
  String get emotionSmug => '得意';

  @override
  String get emotionTired => '疲惫';

  @override
  String get emotionBored => '无聊';

  @override
  String get tokenizerHelpContent =>
      '分词器用于估算模型能够处理的文本量。请选择与模型匹配的分词器，或使用“最佳匹配”自动选择。';

  @override
  String get tokenizerNoneEstimate => '无（仅估算）';

  @override
  String get tokenizerBestMatchAuto => '最佳匹配（自动）';

  @override
  String get tokenizerEstimateDescription => '根据字符数快速估算 Token';

  @override
  String get tokenizerGpt2Description => '适用于较旧 GPT 风格模型的 GPT-2 分词器';

  @override
  String get tokenizerOaiDescription =>
      '适用于 GPT 模型的 OAI Compatible tiktoken 分词器';

  @override
  String get tokenizerLlamaDescription => '适用于 Llama 模型的 SentencePiece 分词器';

  @override
  String get tokenizerLlama3Description => '适用于 Llama 3 模型的分词器';

  @override
  String get tokenizerMistralDescription => '适用于 Mistral 模型的分词器';

  @override
  String get tokenizerClaudeDescription => '适用于 Claude 模型的 Token 估算';

  @override
  String get tokenizerGemmaDescription => '适用于 Gemma 模型的分词器';

  @override
  String get tokenizerQwenDescription => '适用于 Qwen 模型的分词器';

  @override
  String get tokenizerDeepSeekDescription => '适用于 DeepSeek 模型的分词器';

  @override
  String get tokenizerCommandRDescription => '适用于 Command R 模型的分词器';

  @override
  String get tokenizerNemoDescription => '适用于 Mistral NeMo 模型的分词器';

  @override
  String get tokenizerBestMatchDescription => '根据当前模型自动选择分词器';

  @override
  String get showOriginal => '显示原文';

  @override
  String get showOriginalDescription => '在译文旁同时显示原文';

  @override
  String get swapLanguages => '交换语言';

  @override
  String get aboutTranslation => '关于翻译';

  @override
  String get aboutTranslationDescription => '可自动或按需翻译消息，帮助你使用不同语言交流。';

  @override
  String get googleTranslate => 'Google 翻译';

  @override
  String get googleTranslateDescription =>
      '使用 Google Cloud Translation API，需要 Google Cloud API 密钥。';

  @override
  String get deepL => 'DeepL';

  @override
  String get deepLDescription => '高质量神经网络机器翻译，需要 deepl.com 的 API 密钥。';

  @override
  String get libreTranslate => 'LibreTranslate';

  @override
  String get libreTranslateDescription => '免费开源的翻译服务，可自行托管或使用公共实例。';

  @override
  String get queueMessages => '消息排队';

  @override
  String get queueMessagesDescription => '将多条消息加入队列，而不是中断当前朗读';

  @override
  String get loadingVoices => '正在加载语音...';

  @override
  String get failedToLoadVoices => '加载语音失败';

  @override
  String get ttsTestPhrase => '你好！这是一段文本转语音系统测试。欢迎使用 NativeTavern。';

  @override
  String get aboutTts => '关于文本转语音';

  @override
  String get aboutTtsDescription => '文本转语音可以朗读消息。你可以在角色设置中为不同角色配置不同语音。';

  @override
  String get systemTts => '系统文本转语音';

  @override
  String get systemTtsDetails => '使用设备内置的文本转语音引擎，可用语音取决于系统设置。';

  @override
  String get elevenLabsDescription => '高质量 AI 语音，需要 elevenlabs.io 的 API 密钥。';

  @override
  String get clearGlobalVariables => '清空全局变量';

  @override
  String get clearLocalVariables => '清空局部变量';

  @override
  String get aboutVariables => '关于变量';

  @override
  String get variableSystemDescription => '变量可在全局或当前聊天中保存可复用的值，并通过宏在提示词中引用。';

  @override
  String get macroUsage => '宏用法';

  @override
  String macroUsageDescription(String localMacro, String globalMacro) {
    return '使用 $localMacro 引用局部变量，使用 $globalMacro 引用全局变量。也可以通过变量宏设置值。';
  }

  @override
  String get noGlobalVariables => '暂无全局变量';

  @override
  String get noLocalVariables => '暂无局部变量';

  @override
  String editVariable(String name) {
    return '编辑变量“$name”';
  }

  @override
  String get deleteVariable => '删除变量';

  @override
  String deleteVariableQuestion(String name) {
    return '确定删除变量“$name”吗？';
  }

  @override
  String clearVariables(String scope) {
    return '清空$scope变量';
  }

  @override
  String clearVariablesConfirmation(String scope) {
    return '确定清空所有$scope变量吗？此操作无法撤销。';
  }

  @override
  String get decrement => '减少';

  @override
  String get increment => '增加';

  @override
  String get testInput => '测试输入';

  @override
  String get variableTestHint => '输入包含变量宏的文本...';

  @override
  String get processMacros => '处理宏';

  @override
  String get result => '结果';

  @override
  String get emptyString => '（空字符串）';

  @override
  String get retrievalAugmentedGeneration => '检索增强生成（RAG）';

  @override
  String get searchSettings => '搜索设置';

  @override
  String topKResultsDescription(int count) {
    return '最多返回 $count 条匹配结果';
  }

  @override
  String minimumPercent(String percent) {
    return '最低相似度：$percent%';
  }

  @override
  String get promptIntegration => '提示词集成';

  @override
  String get includeInPrompt => '加入提示词';

  @override
  String get automaticallyAddContext => '自动将相关上下文加入提示词';

  @override
  String get promptTemplate => '提示词模板';

  @override
  String useContextPlaceholder(String contextMacro) {
    return '使用 $contextMacro 指定检索内容的插入位置';
  }

  @override
  String get vectorStorageHelp => '向量存储帮助';

  @override
  String get vectorStorageHelpContent =>
      '向量存储会将文档转换为嵌入向量，并为每条消息检索相关段落。请配置嵌入服务、创建集合、添加文档并启用提示词集成。';

  @override
  String get enterCollectionName => '输入集合名称';

  @override
  String get deleteCollection => '删除集合';

  @override
  String get deleteCollectionConfirmation => '确定删除此集合及其中的所有文档吗？';

  @override
  String get collectionExported => '集合已导出';

  @override
  String get importCollection => '导入集合';

  @override
  String get pasteCollectionJson => '粘贴集合 JSON...';

  @override
  String get collectionImported => '集合已导入';

  @override
  String get activeCollection => '当前集合';

  @override
  String collectionWithDocumentCount(String name, int count) {
    return '$name（$count 篇文档）';
  }

  @override
  String documentsCount(int count) {
    return '$count 篇文档';
  }

  @override
  String embeddedCount(String percent) {
    return '已嵌入 $percent';
  }

  @override
  String get addDocument => '添加文档';

  @override
  String get viewDocuments => '查看文档';

  @override
  String get enterDocumentContent => '输入文档内容';

  @override
  String get documentAdded => '文档已添加';

  @override
  String get noDocuments => '暂无文档';

  @override
  String documentEmbeddingStatus(int characters, String status) {
    return '$characters 个字符 · $status';
  }

  @override
  String get embedded => '已嵌入';

  @override
  String get notEmbedded => '未嵌入';

  @override
  String get tokenProbabilities => 'Token 概率';

  @override
  String get requestTokenProbabilities => '请求 Token 概率';

  @override
  String get requestTokenProbabilitiesDescription => '请求模型返回生成 Token 的概率数据';

  @override
  String get topCandidatesCount => '候选项数量';

  @override
  String topCandidatesDescription(int count) {
    return '每个 Token 最多显示 $count 个候选项';
  }

  @override
  String get showLogprobsPanel => '显示 Token 概率面板';

  @override
  String get showLogprobsPanelDescription => '在支持的消息下方显示 Token 概率';

  @override
  String get colorIntensity => '颜色强度';

  @override
  String get aboutTokenProbabilities => '关于 Token 概率';

  @override
  String get tokenProbabilitiesDescription =>
      'Token 概率可以显示模型的置信程度及其考虑过的候选项。是否可用取决于当前 API 和模型。';

  @override
  String get moreFormatting => '更多格式';

  @override
  String get readAloud => '朗读';

  @override
  String get openInBrowser => '在浏览器中打开';

  @override
  String get imageLoadFailed => '图片加载失败';

  @override
  String get pauseReading => '暂停朗读';

  @override
  String get resumeReading => '继续朗读';

  @override
  String get stopReading => '停止朗读';

  @override
  String get noTagsAvailable => '暂无可用标签';

  @override
  String rerollAlternativeNotImplemented(String alternative) {
    return '暂不支持使用“$alternative”重新生成';
  }

  @override
  String get enableTokenProbabilitiesHint => '请在设置中启用 Token 概率以查看此数据';

  @override
  String get noTokenProbabilities => '暂无 Token 概率数据';

  @override
  String get noAlternativeTokens => '暂无候选 Token';

  @override
  String get alternativeTokens => '候选 Token';

  @override
  String get otherTokens => '其他 Token';

  @override
  String get chooseRpgScenario => '选择 RPG 剧本';

  @override
  String get importScenario => '导入剧本';

  @override
  String get noSavedScenarios => '暂无已保存的剧本';

  @override
  String get rpgImportScenarioPackage => '导入 RPG 剧本包';

  @override
  String get rpgSelectedScenarioUnreadable => '无法读取所选剧本文件';

  @override
  String get favorite => '收藏';

  @override
  String get connections => '关联';

  @override
  String get systemPromptOverride => '覆盖系统提示词';

  @override
  String get systemPromptOverrideHint => '输入此用户设定专用的系统提示词...';

  @override
  String get systemPromptOverrideDescription => '启用此用户设定时覆盖默认系统提示词';

  @override
  String get instructionsAddedAfterHistory => '添加在聊天记录之后的指令';

  @override
  String get bindPersonaDescription => '绑定用户设定描述';

  @override
  String get noConnections => '暂无关联';

  @override
  String connectionCharacter(String id) {
    return '角色：$id';
  }

  @override
  String connectionGroup(String id) {
    return '群组：$id';
  }

  @override
  String connectionChat(String id) {
    return '聊天：$id';
  }

  @override
  String lockLabel(String type) {
    return '锁定：$type';
  }

  @override
  String get addTag => '添加标签';

  @override
  String errorLoadingLorebooks(String error) {
    return '加载世界书失败：$error';
  }

  @override
  String get personaLorebook => '用户设定世界书';

  @override
  String get selectLorebook => '选择世界书';

  @override
  String get personaLorebookDescription => '与此用户设定关联的世界书';

  @override
  String get descriptionPlacement => '描述插入位置';

  @override
  String get personaDescriptionPositionHelp => '选择用户设定描述在提示词中的插入位置';

  @override
  String get depth => '深度';

  @override
  String get depthInChatHistory => '聊天记录中的深度';

  @override
  String get messageRole => '消息角色';

  @override
  String get roleForDescription => '用户设定描述使用的角色';

  @override
  String get novelAiSettings => 'NovelAI 设置';

  @override
  String get anlasGuard => 'Anlas 保护';

  @override
  String get anlasGuardDescription => '预计 Anlas 消耗过高时阻止生成';

  @override
  String get smea => 'SMEA';

  @override
  String get smeaDescription => '启用 SMEA 采样以提升图片一致性';

  @override
  String get smeaDynamic => '动态 SMEA';

  @override
  String get smeaDynamicDescription => '根据图片尺寸动态调整 SMEA';

  @override
  String get decrisper => '柔化细节';

  @override
  String get decrisperDescription => '减少图片中过度锐利的细节';

  @override
  String get varietyPlus => 'Variety+';

  @override
  String get varietyPlusDescription => '提高生成图片之间的差异性';

  @override
  String get gptImageApiDescription => '通过 OAI Compatible 图片 API 生成图片';

  @override
  String get oaiCompatibleChat => 'OAI Compatible Chat';

  @override
  String get oaiCompatibleChatDescription => '通过 OAI Compatible 聊天补全端点生成图片';

  @override
  String get errorFetchingModels => '获取模型失败';

  @override
  String generatedPrompt(String prompt) {
    return '提示词：$prompt';
  }

  @override
  String generatedSeed(String seed) {
    return '种子：$seed';
  }

  @override
  String imagesGenerated(int count) {
    return '已生成 $count 张图片';
  }

  @override
  String get myTheme => '我的主题';

  @override
  String get translate => '翻译';

  @override
  String get stopSpeaking => '停止朗读';

  @override
  String get insertion => '插入';

  @override
  String get filters => '过滤条件';

  @override
  String get scanDepth => '扫描深度';

  @override
  String get scanDepthDescription => '扫描最近多少条消息来匹配关键词';

  @override
  String get roleForInjectedContent => '注入内容使用的消息角色';

  @override
  String get caseSensitive => '区分大小写';

  @override
  String get matchKeywordsExactCase => '按完全一致的大小写匹配关键词';

  @override
  String get matchWholeWords => '匹配完整单词';

  @override
  String get onlyMatchCompleteWords => '仅匹配完整单词';

  @override
  String get recursionControl => '递归控制';

  @override
  String get preventRecursion => '阻止递归';

  @override
  String get preventRecursionDescription => '不允许此条目触发其他条目';

  @override
  String get excludeRecursion => '从递归中排除';

  @override
  String get excludeRecursionDescription => '递归扫描时不激活此条目';

  @override
  String get delayUntilRecursion => '延迟至递归';

  @override
  String get delayUntilRecursionDescription => '仅在递归扫描时激活此条目';

  @override
  String get characterFilter => '角色过滤';

  @override
  String get groupSettings => '分组设置';

  @override
  String get groupMutuallyExclusive => '组内互斥';

  @override
  String get useGroupScoring => '使用分组评分';

  @override
  String get groupWeight => '分组权重';

  @override
  String get groupWeightDescription => '从组中选择条目时使用的相对权重';

  @override
  String get groupOverride => '覆盖分组';

  @override
  String get groupPriority => '分组优先级';

  @override
  String get probability => '概率';

  @override
  String get useProbability => '使用概率';

  @override
  String get randomActivationProbability => '此条目随机激活的概率';

  @override
  String probabilityPercent(int percent) {
    return '激活概率：$percent%';
  }

  @override
  String get timedEffects => '定时效果';

  @override
  String get filterType => '过滤类型';

  @override
  String get characterIds => '角色 ID';

  @override
  String get stickyDuration => '持续时长';

  @override
  String get stickyDurationDescription => '匹配后此条目保持激活的消息数';

  @override
  String get cooldown => '冷却';

  @override
  String get cooldownDescription => '此条目再次激活前需要经过的消息数';

  @override
  String get delay => '延迟';

  @override
  String get delayDescription => '此条目可激活前需要经过的消息数';

  @override
  String get outlet => '出口';

  @override
  String get include => '包含';

  @override
  String get exclude => '排除';

  @override
  String translatedFromLanguage(String language) {
    return '译自$language';
  }

  @override
  String originalText(String text) {
    return '原文：$text';
  }

  @override
  String get loadingImage => '正在加载图片...';

  @override
  String get backupIntervalNever => '从不';

  @override
  String get backupIntervalHourly => '每小时';

  @override
  String get backupIntervalDaily => '每天';

  @override
  String get backupIntervalWeekly => '每周';

  @override
  String get backupIntervalMonthly => '每月';

  @override
  String get restoreModeReplace => '替换';

  @override
  String get restoreModeReplaceDescription => '使用备份数据替换所有本地数据';

  @override
  String get restoreModeMerge => '合并';

  @override
  String get restoreModeMergeDescription => '合并备份与本地数据，冲突时以较新的数据为准';

  @override
  String get restoreModeAddNewOnly => '仅添加新内容';

  @override
  String get restoreModeAddNewOnlyDescription => '仅添加备份中的新项目，并保留所有现有数据';

  @override
  String get sortNameAscending => '名称（A-Z）';

  @override
  String get sortNameDescending => '名称（Z-A）';

  @override
  String get sortNewestFirst => '最新创建优先';

  @override
  String get sortOldestFirst => '最早创建优先';

  @override
  String get sortRecentlyModified => '最近修改优先';

  @override
  String get sortLeastRecentlyModified => '最早修改优先';

  @override
  String get codeBlock => '代码块';

  @override
  String get quote => '引用';

  @override
  String get heading1 => '一级标题';

  @override
  String get heading2 => '二级标题';

  @override
  String get heading3 => '三级标题';

  @override
  String get bulletList => '项目符号列表';

  @override
  String get numberedList => '编号列表';

  @override
  String get horizontalRule => '分隔线';

  @override
  String get pageNotFound => '页面未找到';

  @override
  String get goHome => '返回首页';

  @override
  String get officialWebsite => '官方网站';

  @override
  String get mcpStreamableHttp => '可流式传输 HTTP';

  @override
  String get mcpLegacyHttpSse => '旧版 HTTP + SSE';

  @override
  String chatWithName(String name) {
    return '与$name聊天';
  }

  @override
  String get noValidCharactersInGroup => '群组中没有有效角色';

  @override
  String get aiDataSharingTitle => '选择远程 AI 如何处理你的数据';

  @override
  String get aiDataSharingIntroduction =>
      'NativeTavern 采用本地优先设计。使用远程 AI 功能时，本设备会将必要数据直接发送给你配置的服务商；NativeTavern 不会中转或存储这些请求。';

  @override
  String get aiDataSharingDataTitle => '可能发送的数据';

  @override
  String get aiDataSharingDataTypes =>
      '- 你的消息及相关聊天记录\n- 角色、人设和系统指令、世界书、记忆及工具输入\n- 用于向量嵌入的文档\n- 用于图片生成的提示词和图片\n- 用于语音功能的音频和文本';

  @override
  String get aiDataSharingRecipientsTitle => '可能接收数据的服务商';

  @override
  String get aiDataSharingRecipients =>
      '根据你的配置，接收方可能是：Anthropic、你配置的 OAI Compatible 兼容端点、OpenRouter、Google Gemini、DeepSeek、阿里云通义千问、SiliconFlow、Moonshot/Kimi、Z.AI、MiniMax、Cohere、ElevenLabs、Azure Speech、火山引擎、NovelAI、Pollinations，或你填写的其他自定义端点。';

  @override
  String get aiDataSharingControlTitle => '由你选择';

  @override
  String get aiDataSharingControlDescription =>
      '远程服务商会依据其各自的隐私政策处理数据。API 凭据保留在本设备上，仅在向所选服务商直接认证时发送。你可以随时在“设置”中更改选择；本地 AI 端点无需同意即可继续使用。';

  @override
  String get allowRemoteAi => '允许使用远程 AI';

  @override
  String get useLocalAiOnly => '仅使用本地 AI';

  @override
  String get aiDataSharingSettingsTitle => '远程 AI 数据共享';

  @override
  String get aiDataSharingAllowedDescription => '已允许向你配置的服务商和端点发送数据';

  @override
  String get aiDataSharingLocalOnlyDescription => '已阻止；本地 AI 端点仍可使用';

  @override
  String get localBackup => '本地与文件备份';

  @override
  String get localBackupDescription =>
      '将 NativeTavern .ntx 合并备份或 .ntb 数据备份导出或导入到设备存储或文件管理器';

  @override
  String get exportNtbBackup => '导出数据备份 (.ntb)';

  @override
  String get exportNtbBackupSubtitle => '仅保存 JSON 数据；媒体单独存储为 .ntm';

  @override
  String get exportNtxBackup => '导出合并备份 (.ntx)';

  @override
  String get exportNtxBackupSubtitle => '将应用数据和媒体一起保存到一个 .ntx 文件';

  @override
  String get importNtbBackup => '导入备份文件 (.ntb)';

  @override
  String get importNtbBackupSubtitle => '从本地 .ntb 文件恢复或合并数据';

  @override
  String get importNtxBackup => '导入备份 (.ntx / .ntb)';

  @override
  String get importNtxBackupSubtitle => '从合并的 .ntx 文件或 .ntb 数据备份恢复或合并数据';

  @override
  String get exportToFiles => '保存到文件';

  @override
  String get shareBackup => '分享备份';

  @override
  String get exportOptions => '导出选项';

  @override
  String get selectNtbFile => '选择 NativeTavern 备份 (.ntb)';

  @override
  String get selectNtbFileDescription => '选择 .ntb 备份文件以及可选的 .ntm 媒体文件';

  @override
  String get selectNtxFile => '选择 NativeTavern 备份';

  @override
  String get selectNtxFileDescription => '选择 .ntx 合并备份，或带可选 .ntm 媒体的 .ntb 文件';

  @override
  String get backupSavedToFilesApp => '备份已保存到文件';

  @override
  String get backupSavedToAppFolder => '无法保存到文件应用。备份已保存到 NativeTavern/Backups。';

  @override
  String get savedToFilesApp => '已保存到文件';

  @override
  String get importBackupExplanation => '从此备份文件中恢复或合并角色、聊天、设置和媒体文件。';

  @override
  String get restoringBackup => '正在恢复备份...';

  @override
  String get exportingBackup => '正在导出备份...';
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
  String get saveAs => '另存新檔';

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
  String get formatting => '格式設定';

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
  String get contextLength => '上下文長度';

  @override
  String get contextWindowSize => '上下文視窗大小';

  @override
  String get contextLengthDescription => '模型作為輸入上下文可處理的最大 Token 數。';

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
  String get xai => '';

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
  String get worldInfo => '世界書';

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
  String get backupSubtitle => '本機與雲端備份及還原';

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

  @override
  String get characterNotFound => '找不到角色';

  @override
  String get characterNotFoundMessage => '找不到角色';

  @override
  String get exportAsPng => '匯出為 PNG';

  @override
  String get exportAsCharx => '匯出為 CharX';

  @override
  String get duplicate => '複製';

  @override
  String deleteCharacterConfirmationSimple(String name) {
    return '確定要刪除「$name」嗎？此操作無法復原。';
  }

  @override
  String characterDuplicated(String name) {
    return '已複製$name';
  }

  @override
  String failedToDelete(String error) {
    return '刪除失敗：$error';
  }

  @override
  String failedToDuplicate(String error) {
    return '複製失敗：$error';
  }

  @override
  String get pngExportComingSoon => '即將支援 PNG 匯出';

  @override
  String get charxExportComingSoon => '即將支援 CharX 匯出';

  @override
  String get failedToCreateChat => '建立聊天失敗';

  @override
  String get creating => '正在建立...';

  @override
  String byCreator(String creator) {
    return '作者：$creator';
  }

  @override
  String versionLabel(String version) {
    return 'v$version';
  }

  @override
  String get showLess => '收合';

  @override
  String get showMore => '顯示更多';

  @override
  String greetingNumber(int number) {
    return '問候語 $number';
  }

  @override
  String alternateGreetingsCount(int count) {
    return '替代問候語（$count）';
  }

  @override
  String get embeddedLorebook => '內嵌世界書';

  @override
  String entriesEnabled(int enabled, int total) {
    return '已啟用 $enabled/$total 個項目';
  }

  @override
  String andMoreEntries(int count) {
    return '...以及另外 $count 個項目';
  }

  @override
  String get exampleMessages => '範例訊息';

  @override
  String get postHistoryInstructions => '歷史記錄後指令';

  @override
  String get selectImages => '選擇圖片';

  @override
  String get presetsAndTemplates => '預設與範本';

  @override
  String get activePreset => '目前預設';

  @override
  String get change => '變更';

  @override
  String get noPresetSelected => '未選擇預設';

  @override
  String get instructTemplate => '指令範本';

  @override
  String get selectInstructTemplate => '選擇指令範本';

  @override
  String get instructTemplateDescription =>
      '指令範本會針對不同 LLM 模型設定提示詞格式。對於會自動處理格式的 OAI Compatible 或 Claude 等 API 服務，請選擇「無」。';

  @override
  String get orderAndTogglePromptSections => '調整提示詞部分的順序與啟用狀態';

  @override
  String get llmConnection => 'LLM 連線';

  @override
  String get generationSettings => '產生設定';

  @override
  String get advancedSamplerSettings => '進階採樣器設定';

  @override
  String get fullControlOverSampling => '完整控制採樣參數';

  @override
  String get selectLlmProvider => '選擇 LLM 服務';

  @override
  String get notSet => '未設定';

  @override
  String get enterApiKey => '輸入 API 金鑰';

  @override
  String get apiEndpointUrl => 'API 端點 URL';

  @override
  String get modelName => '模型名稱';

  @override
  String get fetchAvailableModels => '取得可用模型';

  @override
  String get fetchModelsDescription => '從 API 取得模型，或手動輸入模型名稱';

  @override
  String get enterModelName => '輸入模型名稱';

  @override
  String get fetchingModels => '正在取得模型...';

  @override
  String get failedToFetchModels => '取得模型失敗';

  @override
  String get tapToTestConnection => '點選以測試 API 連線';

  @override
  String get testing => '正在測試...';

  @override
  String get connected => '已連線';

  @override
  String get connectionFailedSimple => '連線失敗';

  @override
  String get maximumTokensToGenerate => '最大產生 Token 數';

  @override
  String get streaming => '串流傳輸';

  @override
  String get showResponseAsItGenerates => '產生時即時顯示回覆';

  @override
  String selectModelCount(int count) {
    return '選擇模型（$count）';
  }

  @override
  String get refreshModels => '重新整理模型';

  @override
  String get enterManually => '手動輸入';

  @override
  String get noModelsFound => '找不到模型';

  @override
  String get tryDifferentSearchTerm => '請嘗試其他搜尋詞';

  @override
  String modelsOfTotal(int filtered, int total) {
    return '顯示 $filtered/$total 個模型';
  }

  @override
  String get importPreset => '匯入預設';

  @override
  String get noGroupChatsYet => '尚無群組聊天';

  @override
  String get createGroupDescription => '建立群組，與多個角色聊天';

  @override
  String get newGroup => '新增群組';

  @override
  String membersAndMode(int count, String mode) {
    return '$count 位成員 · $mode 模式';
  }

  @override
  String get groupChatWillBeImplemented => '群組聊天將在聊天整合中實作';

  @override
  String deleteGroupConfirmation(String name) {
    return '確定要刪除「$name」嗎？相關聊天也會一併刪除。';
  }

  @override
  String groupDeleted(String name) {
    return '已刪除$name';
  }

  @override
  String get groupNameRequired => '群組名稱 *';

  @override
  String get enterGroupName => '輸入群組名稱';

  @override
  String get optionalDescription => '選填描述';

  @override
  String get selectCharacters => '選擇角色';

  @override
  String get noCharactersAvailable => '沒有可用角色';

  @override
  String charactersSelected(int count) {
    return '已選擇 $count 個角色';
  }

  @override
  String get create => '建立';

  @override
  String get selectAtLeast2Characters => '請至少選擇 2 個角色';

  @override
  String get groupCreatedSuccessfully => '群組建立成功';

  @override
  String failedToCreateGroup(String error) {
    return '建立群組失敗：$error';
  }

  @override
  String get selectCharacterCard => '選擇角色卡';

  @override
  String get supportsPngCharxJson => '支援 PNG、CharX 與 JSON 格式';

  @override
  String get browseFiles => '瀏覽檔案';

  @override
  String failedToPickFile(String error) {
    return '選擇檔案失敗：$error';
  }

  @override
  String failedToLoadCharacter(String error) {
    return '載入角色失敗：$error';
  }

  @override
  String unsupportedFileFormat(String format) {
    return '不支援的檔案格式：$format';
  }

  @override
  String get pngCharacterCard => 'PNG 角色卡';

  @override
  String get characterDataEmbeddedInImage => '角色資料內嵌於圖片中繼資料';

  @override
  String get charxArchive => 'CharX 封存檔';

  @override
  String get zipArchiveWithCharacterData => '包含角色資料與資源的 ZIP 封存檔';

  @override
  String get plainCharacterCardJson => '純角色卡 JSON 檔案';

  @override
  String importedWithLorebook(String name) {
    return '已匯入含內嵌世界書的「$name」！';
  }

  @override
  String importedSuccessfully(String name) {
    return '已成功匯入「$name」！';
  }

  @override
  String failedToImport(String error) {
    return '匯入失敗：$error';
  }

  @override
  String embeddedLorebookEntries(int count) {
    return '內嵌世界書（$count 個項目）';
  }

  @override
  String get saveCurrentAsPreset => '將目前設定儲存為預設';

  @override
  String get exportCurrentSettings => '匯出目前設定';

  @override
  String get builtInPresets => '內建預設';

  @override
  String get customPresets => '自訂預設';

  @override
  String get aiPresetsDescription => 'AI 預設包含產生設定、提示詞順序與指令範本。選擇一個預設即可一次套用全部設定。';

  @override
  String appliedPreset(String name) {
    return '已套用「$name」預設';
  }

  @override
  String failedToApplyPreset(String error) {
    return '套用預設失敗：$error';
  }

  @override
  String get invalidPresetFormat => '預設格式無效，應包含產生設定。';

  @override
  String importedAndApplied(String name) {
    return '已匯入並套用「$name」';
  }

  @override
  String get saveAsPreset => '儲存為預設';

  @override
  String get descriptionOptional => '描述（選填）';

  @override
  String get pleaseEnterAName => '請輸入名稱';

  @override
  String savedPreset(String name) {
    return '已儲存「$name」';
  }

  @override
  String saveFailed(String error) {
    return '儲存失敗：$error';
  }

  @override
  String deletePresetConfirmation(String name) {
    return '確定要刪除「$name」嗎？';
  }

  @override
  String deletedPreset(String name) {
    return '已刪除「$name」';
  }

  @override
  String get export => '匯出';

  @override
  String get resetToDefaults => '還原預設值';

  @override
  String get basicSampling => '基本採樣';

  @override
  String get temperatureDescription => '控制隨機性。數值越高越有創意，越低越專注。';

  @override
  String get topPNucleusSampling => 'Top P（核採樣）';

  @override
  String get topPDescription => '選擇 Token 的累積機率門檻。';

  @override
  String get topKDescription => '納入考慮的最高機率 Token 數。0 表示停用。';

  @override
  String get advancedSampling => '進階採樣';

  @override
  String get minP => 'Min P';

  @override
  String get minPDescription => '相對於最高機率 Token 的最低機率門檻。';

  @override
  String get typicalP => 'Typical P';

  @override
  String get typicalPDescription => '區域典型採樣。1.0 表示停用。';

  @override
  String get topA => 'Top A';

  @override
  String get topADescription => 'Top-A 採樣門檻。0 表示停用。';

  @override
  String get tailFreeSamplingTfs => '尾端自由採樣（TFS）';

  @override
  String get tfsDescription => '移除低機率尾端。1.0 表示停用。';

  @override
  String get repetitionControl => '重複控制';

  @override
  String get repetitionPenaltyDescription => '懲罰重複 Token。1.0 表示不懲罰。';

  @override
  String get repetitionPenaltyRange => '重複懲罰範圍';

  @override
  String get repetitionPenaltyRangeDescription => '納入計算的 Token 數。0 表示全部。';

  @override
  String get frequencyPenaltyDescription => '依 Token 在文字中的出現頻率進行懲罰。';

  @override
  String get presencePenaltyDescription => '對文字中出現過的 Token 進行懲罰。';

  @override
  String get mirostatLocalModels => 'Mirostat（本機模型）';

  @override
  String get mirostatMode => 'Mirostat 模式';

  @override
  String get adaptiveSamplingForLocalModels => '適用於本機模型的自適應採樣';

  @override
  String get off => '關閉';

  @override
  String get mirostatTau => 'Mirostat Tau';

  @override
  String get mirostatTauDescription => '目標熵/困惑度。';

  @override
  String get mirostatEta => 'Mirostat Eta';

  @override
  String get mirostatEtaDescription => 'Mirostat 的學習率。';

  @override
  String get generationControl => '產生控制';

  @override
  String get maxTokensDescription => '最多產生的 Token 數。';

  @override
  String get seed => '種子';

  @override
  String get seedDescription => '用於重現結果的隨機種子。-1 表示隨機。';

  @override
  String get stopSequences => '停止序列';

  @override
  String get noStopSequencesConfigured => '尚未設定停止序列';

  @override
  String get stopSequencesDescription => '每行輸入一個序列。產生到其中任一序列時停止。';

  @override
  String get resetConfirmation => '這將把所有採樣器設定還原為預設值。是否繼續？';

  @override
  String get reset => '重設';

  @override
  String get settingsResetToDefaults => '設定已還原預設值';

  @override
  String get characterBackground => '角色背景';

  @override
  String get chatBackground => '聊天背景';

  @override
  String get clearBackground => '清除背景';

  @override
  String get gradientPresets => '漸層預設';

  @override
  String get solidColors => '純色';

  @override
  String get customImage => '自訂圖片';

  @override
  String get adjustments => '調整';

  @override
  String get noBackgroundSelected => '未選擇背景';

  @override
  String get chooseImage => '選擇圖片';

  @override
  String get fromUrl => '來自 URL';

  @override
  String localImage(String filename) {
    return '本機圖片：$filename';
  }

  @override
  String urlLabel(String url) {
    return 'URL：$url';
  }

  @override
  String get noImage => '無圖片';

  @override
  String get opacity => '不透明度';

  @override
  String get blurEffect => '模糊效果';

  @override
  String get applyBlurToBackground => '對背景套用模糊';

  @override
  String get blurAmount => '模糊程度';

  @override
  String failedToLoadImage(String error) {
    return '載入圖片失敗：$error';
  }

  @override
  String get imageUrl => '圖片 URL';

  @override
  String get enterImageUrl => '輸入圖片 URL';

  @override
  String get apply => '套用';

  @override
  String get backupAndRestore => '備份與還原';

  @override
  String get refresh => '重新整理';

  @override
  String get storage => '儲存空間';

  @override
  String get totalBackupSize => '備份總大小';

  @override
  String get calculating => '正在計算...';

  @override
  String get lastAutoBackup => '上次自動備份';

  @override
  String get autoBackup => '自動備份';

  @override
  String get enableAutoBackup => '啟用自動備份';

  @override
  String get automaticallyBackupChats => '自動備份聊天';

  @override
  String get backupInterval => '備份間隔';

  @override
  String get backupOnExit => '結束時備份';

  @override
  String get createBackupWhenClosingApp => '關閉應用程式時建立備份';

  @override
  String get retention => '保留規則';

  @override
  String get maxChatBackups => '聊天備份上限';

  @override
  String keepUpToChatBackups(int count) {
    return '最多保留 $count 個聊天備份';
  }

  @override
  String get maxFullBackups => '完整備份上限';

  @override
  String keepUpToFullBackups(int count) {
    return '最多保留 $count 個完整備份';
  }

  @override
  String get cleanupOldBackups => '清理舊備份';

  @override
  String get deleteBackupsExceedingLimits => '刪除超出限制的備份';

  @override
  String get cleanup => '清理';

  @override
  String deletedOldBackups(int count) {
    return '已刪除 $count 個舊備份';
  }

  @override
  String get chatBackups => '聊天備份';

  @override
  String get noChatBackups => '尚無聊天備份';

  @override
  String viewAllBackups(int count) {
    return '檢視全部 $count 個備份';
  }

  @override
  String get fullBackups => '完整備份';

  @override
  String get noFullBackups => '尚無完整備份';

  @override
  String get information => '資訊';

  @override
  String get aboutBackups => '關於備份';

  @override
  String get aboutBackupsDescription => '聊天備份會儲存個別對話。完整備份包含所有角色、聊天、設定與世界書。';

  @override
  String get backupLocation => '備份位置';

  @override
  String errorReadingBackup(String error) {
    return '讀取備份時發生錯誤：$error';
  }

  @override
  String get deleteBackup => '刪除備份';

  @override
  String deleteBackupConfirmation(String name) {
    return '要刪除「$name」嗎？\n\n此操作無法復原。';
  }

  @override
  String get view => '檢視';

  @override
  String get justNow => '剛剛';

  @override
  String minutesAgo(int count) {
    return '$count 分鐘前';
  }

  @override
  String hoursAgo(int count) {
    return '$count 小時前';
  }

  @override
  String get enableCfgScale => '啟用 CFG Scale';

  @override
  String get cfgScaleDescription => '用於文字產生的無分類器引導';

  @override
  String get globalSettings => '全域設定';

  @override
  String get guidanceScale => '引導強度';

  @override
  String get negativePrompt => '負面提示詞';

  @override
  String get textToSteerAwayFrom => '希望模型避開的文字';

  @override
  String get positivePromptOptional => '正面提示詞（選填）';

  @override
  String get textToEnhanceInOutput => '希望在輸出中強化的文字';

  @override
  String get characterSettings => '角色設定';

  @override
  String get useCharacterSpecificSettings => '使用角色專屬設定';

  @override
  String get overrideGlobalForCharacter => '為此角色覆寫全域設定';

  @override
  String get characterNegativePrompt => '角色負面提示詞';

  @override
  String get overrideGlobalNegativePrompt => '覆寫全域負面提示詞';

  @override
  String get chatSettings => '聊天設定';

  @override
  String get chatSettingsDescription => '這些設定僅對目前聊天生效，並覆寫全域與角色設定。';

  @override
  String get chatNegativePrompt => '聊天負面提示詞';

  @override
  String get overrideForThisChat => '為目前聊天覆寫設定';

  @override
  String get chatPositivePrompt => '聊天正面提示詞';

  @override
  String get enhancementForThisChat => '目前聊天的強化內容';

  @override
  String get promptCombineMode => '提示詞組合方式';

  @override
  String get replaceChatPromptOnly => '取代（僅使用聊天提示詞）';

  @override
  String get prependChatPlusGlobal => '前置（聊天 + 全域）';

  @override
  String get appendGlobalPlusChat => '後置（全域 + 聊天）';

  @override
  String get aboutCfgScale => '關於 CFG Scale';

  @override
  String get aboutCfgScaleDescription =>
      'CFG（無分類器引導）Scale 控制模型遵循負面提示詞、避開特定內容或風格的強度。\n\n• 1.0 = 無效果（預設）\n• 1.5-3.0 = 輕度引導\n• 3.0-7.0 = 中度引導\n• 7.0+ = 強引導（可能影響連貫性）';

  @override
  String get cfgScaleHelp => 'CFG Scale 說明';

  @override
  String get cfgScaleHelpContent =>
      '無分類器引導（CFG）Scale 可透過指定希望避開的內容來引導 AI 模型輸出。\n\n**運作方式：**\n模型會產生兩份輸出，一份使用提示詞，另一份使用負面提示詞。最終輸出會朝遠離負面提示詞的方向調整。\n\n**設定優先級：**\n1. 聊天專屬設定（最高）\n2. 角色專屬設定\n3. 全域設定（最低）\n\n**提示：**\n• 從較低數值（1.5-2.0）開始並逐漸增加\n• 使用具體的負面提示詞可獲得更好效果\n• 數值過高可能導致重複或不連貫\n• 並非所有 AI 後端都支援 CFG Scale';

  @override
  String get help => '說明';

  @override
  String get processing => '處理中...';

  @override
  String get sampleMessage1 => '你好！有什麼可以幫你？';

  @override
  String get sampleMessage2 => '告訴我一個故事吧！';

  @override
  String get general => '一般';

  @override
  String get enableImageGeneration => '啟用圖片產生';

  @override
  String get generateImagesUsingAi => '使用 AI 產生圖片';

  @override
  String get imageGenerationProvider => '圖片產生服務';

  @override
  String get apiEndpoint => 'API 端點';

  @override
  String get notConfigured => '未設定';

  @override
  String get defaultParameters => '預設參數';

  @override
  String get imageSize => '圖片尺寸';

  @override
  String get steps => '步數';

  @override
  String get sampler => '採樣器';

  @override
  String get defaultNegativePrompt => '預設負面提示詞';

  @override
  String get enterTermsToAvoid => '輸入產生圖片中需要避免的內容';

  @override
  String get test => '測試';

  @override
  String get aboutImageGeneration => '關於圖片產生';

  @override
  String get aboutImageGenerationDescription =>
      '使用 AI 模型產生圖片。可在聊天中使用 /imagine 命令，或在角色編輯器中產生角色肖像。';

  @override
  String get imagine => '生圖';

  @override
  String get fillImagePromptWithAi => 'AI 填寫提示詞';

  @override
  String get imagineCommand => '/imagine 命令';

  @override
  String get imagineCommandUsage =>
      '用法：/imagine <提示詞> [--width N] [--height N] [--steps N] [--cfg N] [--seed N]';

  @override
  String get stableDiffusion => 'Stable Diffusion';

  @override
  String get stableDiffusionDescription =>
      '連線至本機或遠端 Stable Diffusion WebUI，需要啟用 API。';

  @override
  String get dalle => 'DALL-E';

  @override
  String get dalleDescription =>
      '透過 OAI Compatible 端點使用 DALL-E 產生圖片，需要 API 金鑰。';

  @override
  String get prompt => '提示詞';

  @override
  String get enterPromptToGenerate => '輸入圖片產生提示詞';

  @override
  String get generate => '產生';

  @override
  String get generating => '正在產生...';

  @override
  String get generationComplete => '產生完成';

  @override
  String get imageWouldBeDisplayed => '圖片將顯示於此處';

  @override
  String get enableLogitBias => '啟用 Logit Bias';

  @override
  String get adjustTokenProbabilities => '調整 AI 回覆中的 Token 機率';

  @override
  String get presets => '預設';

  @override
  String get activePresetLabel => '目前預設';

  @override
  String get none => '無';

  @override
  String get newPreset => '新增預設';

  @override
  String get importPresetLabel => '匯入預設';

  @override
  String get biasEntries => '偏置項目';

  @override
  String get noBiasEntries => '尚無偏置項目';

  @override
  String get addEntriesToAdjust => '加入項目以調整 Token 機率';

  @override
  String get addEntry => '加入項目';

  @override
  String get textOrToken => '文字 / Token';

  @override
  String textTokenHint(Object verbatim) {
    return '單字、$verbatim 或 [1234]';
  }

  @override
  String get bias => '偏置';

  @override
  String get logitBiasHelp => 'Logit Bias 說明';

  @override
  String get presetCopiedToClipboard => '預設已複製到剪貼簿';

  @override
  String exportPresetFailed(String error) {
    return '匯出失敗：$error';
  }

  @override
  String get pastePresetJson => '在此貼上預設 JSON';

  @override
  String get presetImportedSuccessfully => '預設匯入成功';

  @override
  String importPresetFailed(String error) {
    return '匯入失敗：$error';
  }

  @override
  String get rename => '重新命名';

  @override
  String get deletePresetQuestion => '確定要刪除此預設嗎？';

  @override
  String get moreOptions => '更多選項';

  @override
  String get loadPreset => '載入預設';

  @override
  String get saveAsPresetLabel => '儲存為預設';

  @override
  String get exportPreset => '匯出預設';

  @override
  String get resetToDefault => '還原預設';

  @override
  String get dragToReorder => '拖曳可調整各部分順序，使用開關啟用或停用。';

  @override
  String deleted(String name) {
    return '已刪除「$name」';
  }

  @override
  String imported(String name) {
    return '已匯入「$name」';
  }

  @override
  String get invalidPresetFormatMessage => '預設格式無效';

  @override
  String get exportPresetTitle => '匯出預設';

  @override
  String get presetNameLabel => '預設名稱';

  @override
  String get pleaseEnterNameMessage => '請輸入名稱';

  @override
  String saved(String name) {
    return '已儲存「$name」';
  }

  @override
  String saveFailedMessage(String error) {
    return '儲存失敗：$error';
  }

  @override
  String get resetToDefaultQuestion => '這將還原所有提示詞部分的預設順序並全部啟用。是否繼續？';

  @override
  String get resetToDefaultConfig => '還原預設設定';

  @override
  String get promptManagerHelp => '提示詞管理器說明';

  @override
  String applied(String name) {
    return '已套用「$name」預設';
  }

  @override
  String get showQuickReplies => '顯示快速回覆';

  @override
  String get displayQuickReplyButtons => '在聊天中顯示快速回覆按鈕';

  @override
  String get positionAboveInput => '位於輸入框上方';

  @override
  String get quickRepliesAboveInput => '快速回覆顯示在輸入框上方';

  @override
  String get quickRepliesBelowInput => '快速回覆顯示在輸入框下方';

  @override
  String get add => '加入';

  @override
  String get noQuickReplies => '尚無快速回覆';

  @override
  String get addYourFirstQuickReply => '加入第一則快速回覆';

  @override
  String deleteQuickReplyQuestion(String label) {
    return '確定要刪除「$label」嗎？';
  }

  @override
  String get resetToDefaultQuestion2 => '這將以預設集合取代你的所有快速回覆。是否繼續？';

  @override
  String get continueOrEmpty => '（繼續/空白訊息）';

  @override
  String get autoSendTooltip => '自動傳送';

  @override
  String get addQuickReply => '加入快速回覆';

  @override
  String get editQuickReplyLabel => '編輯快速回覆';

  @override
  String get buttonLabel => '按鈕文字';

  @override
  String get buttonLabelHint => '例如：是、繼續、思考...';

  @override
  String get messageLabel => '訊息';

  @override
  String get leaveEmptyForContinue => '留空表示繼續產生';

  @override
  String get supportsMacros => '支援提示詞巨集';

  @override
  String get autoSendLabel => '自動傳送';

  @override
  String get messageSentImmediately => '訊息將立即傳送';

  @override
  String get messageFillsInput => '訊息將填入輸入框';

  @override
  String get regexScripts => '正規表示式指令碼';

  @override
  String get addScript => '加入指令碼';

  @override
  String get addPresets => '加入預設';

  @override
  String get clearAll => '全部清除';

  @override
  String get enableRegexScripts => '啟用正規表示式指令碼';

  @override
  String get applyFindReplacePatterns => '對訊息套用尋找/取代規則';

  @override
  String get applyTo => '套用至';

  @override
  String get userInput => '使用者輸入';

  @override
  String get applyBeforeSending => '傳送前套用至訊息';

  @override
  String get aiOutput => 'AI 輸出';

  @override
  String get applyToAiResponses => '套用至 AI 回覆';

  @override
  String get slashCommandsLabel => '斜線命令';

  @override
  String get applyDuringCommandProcessing => '處理命令時套用';

  @override
  String get worldInfoLabel => '世界書';

  @override
  String get applyToWorldInfoEntries => '套用至世界書項目';

  @override
  String scriptsCount(int count) {
    return '指令碼（$count）';
  }

  @override
  String get noRegexScripts => '尚無正規表示式指令碼';

  @override
  String get tapToAddOrUseMenu => '點選 + 加入指令碼，或使用選單加入預設';

  @override
  String get aboutRegexScripts => '關於正規表示式指令碼';

  @override
  String get aboutRegexScriptsDescription =>
      '正規表示式指令碼可在訊息中尋找並取代文字模式。取代內容可使用擷取群組（\$1、\$2）。';

  @override
  String get patternFormat => '模式格式';

  @override
  String get patternFormatDescription =>
      '使用 /pattern/flags 格式（如 /hello/gi）或一般模式。旗標：i=不區分大小寫，m=多行，s=點號比對換行';

  @override
  String get presetScriptsAdded => '預設指令碼已加入';

  @override
  String deleteScriptQuestion(String name) {
    return '要刪除「$name」嗎？';
  }

  @override
  String get clearAllScripts => '清除所有指令碼';

  @override
  String get clearAllScriptsQuestion => '這將刪除所有正規表示式指令碼，且無法復原。';

  @override
  String get importScripts => '匯入指令碼';

  @override
  String get pasteJsonArray => '貼上指令碼 JSON 陣列';

  @override
  String importedCount(int count) {
    return '已匯入 $count 個指令碼';
  }

  @override
  String get exportScripts => '匯出指令碼';

  @override
  String get newScript => '新增指令碼';

  @override
  String get editScript => '編輯指令碼';

  @override
  String get scriptName => '指令碼名稱';

  @override
  String get descriptionOptionalLabel => '描述（選填）';

  @override
  String get findPattern => '尋找模式';

  @override
  String get patternOrPlainPattern => '/pattern/flags 或一般模式';

  @override
  String get replaceWith => '取代為';

  @override
  String get useCaptureGroups => '使用 \$1、\$2 表示擷取群組';

  @override
  String get applyToLabel => '套用至';

  @override
  String get options => '選項';

  @override
  String get markdownOnly => '僅 Markdown';

  @override
  String get onlyApplyDuringMarkdown => '僅在 Markdown 轉譯時套用';

  @override
  String get promptOnly => '僅提示詞';

  @override
  String get onlyApplyDuringPrompt => '僅在產生提示詞時套用';

  @override
  String get runOnEdit => '編輯時執行';

  @override
  String get applyWhenEditingMessages => '編輯訊息時套用';

  @override
  String get macroSubstitution => '巨集取代';

  @override
  String get nameAndPatternRequired => '名稱與模式不能為空';

  @override
  String get patternLabel => '模式';

  @override
  String get patternHint => '/pattern/flags';

  @override
  String get testString => '測試文字';

  @override
  String get replacementLabel => '取代內容';

  @override
  String get replacementHint => '\$1、\$2 或符合的文字';

  @override
  String get testButton => '測試';

  @override
  String matchesCount(int count) {
    return '$count 個符合項目';
  }

  @override
  String get errorLabel => '錯誤';

  @override
  String get resultLabel => '結果：';

  @override
  String get expressionSprites => '表情立繪';

  @override
  String get enableSprites => '啟用立繪';

  @override
  String get showCharacterExpressions => '在聊天中顯示角色表情圖片';

  @override
  String get display => '顯示';

  @override
  String get spriteSize => '立繪大小';

  @override
  String get position => '位置';

  @override
  String get whereToDisplaySprites => '立繪顯示位置';

  @override
  String get left => '左側';

  @override
  String get right => '右側';

  @override
  String get center => '置中';

  @override
  String get floatingLeft => '左側浮動';

  @override
  String get floatingRight => '右側浮動';

  @override
  String get animation => '動畫';

  @override
  String get animateTransitions => '過場動畫';

  @override
  String get smoothFadeWhenSpriteChanges => '立繪切換時平滑淡入淡出';

  @override
  String get transitionDuration => '過場時間';

  @override
  String get showDuringStreaming => '串流產生時顯示';

  @override
  String get displaySpritesWhileGenerating => 'AI 產生時顯示立繪';

  @override
  String get emotionDetection => '情緒偵測';

  @override
  String get howItWorks => '運作方式';

  @override
  String get spriteEmotionDetectionDescription =>
      '系統會依訊息中偵測到的情緒關鍵字自動選擇立繪，並優先辨識 *微笑*、*大笑* 等動作文字。';

  @override
  String get supportedEmotions => '支援的情緒';

  @override
  String characterSprites(String name) {
    return '$name的立繪';
  }

  @override
  String get importFromFolder => '從資料夾匯入';

  @override
  String get deleteAllSprites => '刪除所有立繪';

  @override
  String get addSprite => '加入立繪';

  @override
  String spritesCount(int count) {
    return '$count 張立繪';
  }

  @override
  String defaultEmotion(String emotion) {
    return '預設：$emotion';
  }

  @override
  String get noSpritesYet => '尚無立繪';

  @override
  String get addExpressionImages => '為此角色加入表情圖片';

  @override
  String get selectEmotion => '選擇表情';

  @override
  String addedSpriteEmotion(String emotion) {
    return '已加入$emotion立繪';
  }

  @override
  String get setAsDefaultEmotion => '設為預設表情';

  @override
  String get changeEmotion => '變更表情';

  @override
  String get deleteSprite => '刪除立繪';

  @override
  String deleteSpriteConfirmation(String emotion) {
    return '要刪除$emotion立繪嗎？';
  }

  @override
  String get deleteAllSpritesConfirmation => '確定要刪除此角色的所有立繪嗎？此操作無法復原。';

  @override
  String get importSprites => '匯入立繪';

  @override
  String get importSpritesDescription => '從資料夾匯入立繪。檔名應包含情緒關鍵字：';

  @override
  String get supportedFormatsSprites => '支援格式：PNG、JPG、GIF、WebP';

  @override
  String get selectFolder => '選擇資料夾';

  @override
  String get folderImportRequiresPackage => '從資料夾匯入需要 file_picker 軟體套件';

  @override
  String get appStatistics => '應用程式統計';

  @override
  String get chatStatistics => '聊天統計';

  @override
  String get resetStatistics => '重設統計';

  @override
  String get resetStatisticsConfirmation => '確定要重設所有統計資料嗎？此操作無法復原。';

  @override
  String get statisticsReset => '統計資料已重設';

  @override
  String get overview => '概覽';

  @override
  String get firstUsed => '首次使用';

  @override
  String get unknown => '未知';

  @override
  String get totalGroups => '群組總數';

  @override
  String get totalGenerations => '總產生次數';

  @override
  String get tokenUsage => 'Token 用量';

  @override
  String get totalTokensUsed => 'Token 總用量';

  @override
  String get avgTokensPerGeneration => '每次產生平均 Token';

  @override
  String get performance => '效能';

  @override
  String get totalGenerationTime => '總產生時間';

  @override
  String get avgGenerationTime => '平均產生時間';

  @override
  String get userMessages => '使用者訊息';

  @override
  String get assistantMessages => '助理訊息';

  @override
  String get systemMessages => '系統訊息';

  @override
  String get timeline => '時間軸';

  @override
  String get firstMessage_ => '第一則訊息';

  @override
  String get lastMessage => '最後一則訊息';

  @override
  String get chatDuration => '聊天時間';

  @override
  String get promptTokens => '提示詞 Token';

  @override
  String get completionTokens => '補全 Token';

  @override
  String get avgTokensPerMessage => '每則訊息平均 Token';

  @override
  String get generationPerformance => '產生效能';

  @override
  String get generationCount => '總產生次數';

  @override
  String get speechToText => '語音轉文字';

  @override
  String get enableStt => '啟用語音轉文字';

  @override
  String get useVoiceInputForMessages => '使用語音輸入訊息';

  @override
  String get autoSendStt => '自動傳送';

  @override
  String get automaticallySendAfterSpeaking => '說完後自動傳送訊息';

  @override
  String get continuousListening => '持續聆聽';

  @override
  String get keepListeningAfterPhrase => '每句話結束後繼續聆聽';

  @override
  String get showPartialResults => '顯示暫時結果';

  @override
  String get displayTextAsYouSpeak => '說話時即時顯示文字';

  @override
  String get sttProvider => '語音轉文字服務';

  @override
  String get recognitionLanguage => '辨識語言';

  @override
  String get testVoiceInput => '測試語音輸入';

  @override
  String get stopListening => '停止聆聽';

  @override
  String get tapToStop => '點選以停止';

  @override
  String get tapToTestSpeechRecognition => '點選以測試語音辨識';

  @override
  String get final_ => '最終結果';

  @override
  String get listening => '正在聆聽...';

  @override
  String get aboutStt => '關於語音轉文字';

  @override
  String get aboutSttDescription => '語音轉文字可讓你透過語音聽寫訊息。點選聊天輸入框中的麥克風按鈕開始說話。';

  @override
  String get systemStt => '系統語音辨識';

  @override
  String get systemSttDescription => '使用裝置內建的語音辨識。準確度取決於系統設定。';

  @override
  String get whisper => 'Whisper';

  @override
  String get whisperDescription =>
      '透過 OAI Compatible 端點使用 Whisper 轉錄，需要 API 金鑰。';

  @override
  String get voiceInput => '語音輸入';

  @override
  String get holdToTalk => '按住說話';

  @override
  String get releaseToTranscribe => '放開以轉錄';

  @override
  String get cancelVoiceInput => '取消語音輸入';

  @override
  String get openSystemSettings => '開啟設定';

  @override
  String get systemSttOfflineNote => '離線辨識取決於作業系統與已安裝的語言套件。';

  @override
  String get sttConfigurationRequired => '測試前請先完成所選服務的設定。';

  @override
  String get speechRecognitionNotAvailable => '此裝置可能不支援語音辨識。';

  @override
  String get themes => '主題';

  @override
  String get createCustomTheme => '建立自訂主題';

  @override
  String get builtInThemes => '內建主題';

  @override
  String get preview => '預覽';

  @override
  String get chatPreview => '聊天預覽';

  @override
  String get helloHowCanIHelp => '你好！有什麼可以幫你？';

  @override
  String get tellMeAStory => '告訴我一個故事吧！';

  @override
  String get typeAMessage => '輸入訊息...';

  @override
  String get createTheme => '建立主題';

  @override
  String get editTheme => '編輯主題';

  @override
  String get deleteTheme => '刪除主題';

  @override
  String deleteThemeConfirmation(String name) {
    return '確定要刪除「$name」嗎？';
  }

  @override
  String get themeName => '主題名稱';

  @override
  String get background => '背景';

  @override
  String get surface => '表面';

  @override
  String get card => '卡片';

  @override
  String selectThemeColor(String label) {
    return '選擇$label';
  }

  @override
  String get hexColor => '十六進位色彩';

  @override
  String get tokenizerSettings => '分詞器';

  @override
  String get tokenizerHelp => '說明';

  @override
  String get tokenizerLabel => '分詞器';

  @override
  String get showTokenCount => '顯示 Token 數';

  @override
  String get displayTokenCountInInput => '在聊天輸入框中顯示 Token 數';

  @override
  String get showTokenVisualization => '顯示 Token 視覺化';

  @override
  String get highlightIndividualTokens => '醒目提示各個 Token';

  @override
  String get cacheResults => '快取結果';

  @override
  String get cacheTokenizationForPerformance => '快取分詞結果以提升效能';

  @override
  String get tokenVisualization => 'Token 視覺化';

  @override
  String get enterTextToTokenize => '輸入要分詞的文字';

  @override
  String get typePasteTextHere => '在此輸入或貼上文字...';

  @override
  String get quickEstimate => '快速估算';

  @override
  String approximateTokens(int count) {
    return '約 $count 個 Token';
  }

  @override
  String chars(int count) {
    return '$count 個字元';
  }

  @override
  String get statisticsLabel => '統計';

  @override
  String get totalTokens => 'Token 總數';

  @override
  String get unique => '唯一';

  @override
  String get charsPerToken => '每個 Token 的字元數';

  @override
  String get avgLength => '平均長度';

  @override
  String get longest => '最長';

  @override
  String get shortest => '最短';

  @override
  String get mostCommonTokens => '最常見 Token';

  @override
  String get tokenBreakdown => 'Token 明細';

  @override
  String tokensCount(int count) {
    return '$count 個 Token';
  }

  @override
  String tokenIdLength(String id, int length) {
    return 'Token ID：$id\n長度：$length 個字元';
  }

  @override
  String get translationSettings => '翻譯';

  @override
  String get enableTranslation => '啟用翻譯';

  @override
  String get translateMessagesAutomatically => '自動翻譯訊息';

  @override
  String get translationProvider => '翻譯服務';

  @override
  String get sourceLanguage => '來源語言';

  @override
  String get targetLanguage => '目標語言';

  @override
  String get autoDetect => '自動偵測';

  @override
  String get translateUserMessages => '翻譯使用者訊息';

  @override
  String get translateAiResponses => '翻譯 AI 回覆';

  @override
  String get textToSpeech => '文字轉語音';

  @override
  String get enableTts => '啟用文字轉語音';

  @override
  String get readAiResponsesAloud => '朗讀 AI 回覆';

  @override
  String get ttsProvider => '文字轉語音服務';

  @override
  String get voiceSettings => '語音設定';

  @override
  String get voice => '語音';

  @override
  String get speed => '語速';

  @override
  String get pitch => '音調';

  @override
  String get volume => '音量';

  @override
  String get autoPlay => '自動播放';

  @override
  String get automaticallyPlayResponses => '自動播放 AI 回覆';

  @override
  String get testVoice => '測試語音';

  @override
  String get chatVariables => '聊天變數';

  @override
  String get variableSystem => '變數系統';

  @override
  String get globalVariables => '全域變數';

  @override
  String globalVariablesCount(int count) {
    return '$count 個全域變數';
  }

  @override
  String get localVariables => '區域變數';

  @override
  String localVariablesCount(int count) {
    return '$count 個區域變數';
  }

  @override
  String get addVariable => '加入變數';

  @override
  String get variableName => '變數名稱';

  @override
  String get variableValue => '變數值';

  @override
  String get scope => '範圍';

  @override
  String get global => '全域';

  @override
  String get vectorStorageRag => '向量儲存（RAG）';

  @override
  String get enableRag => '啟用 RAG';

  @override
  String get useVectorStorageForContext => '使用向量儲存檢索上下文';

  @override
  String get collections => '集合';

  @override
  String get createCollection => '建立集合';

  @override
  String get collectionName => '集合名稱';

  @override
  String get embeddingProvider => '嵌入服務';

  @override
  String get embeddingModel => '嵌入模型';

  @override
  String get chunkSize => '分塊大小';

  @override
  String get chunkOverlap => '分塊重疊';

  @override
  String get topKResults => 'Top K 結果';

  @override
  String get similarityThreshold => '相似度門檻';

  @override
  String get characterEditor => '角色編輯器';

  @override
  String get basic => '基本';

  @override
  String get prompts => '提示詞';

  @override
  String get meta => '中繼資料';

  @override
  String get nameRequired => '名稱 *';

  @override
  String get characterName => '角色名稱';

  @override
  String get nameIsRequired => '名稱不能為空';

  @override
  String get characterDescription => '角色描述、背景、外觀...';

  @override
  String get characterPersonalityTraits => '角色個性特徵...';

  @override
  String get currentCircumstancesContext => '目前情境與上下文...';

  @override
  String get customInstructionsSystemMessage => '作為系統訊息一部分傳送的自訂指令。';

  @override
  String systemPromptHint(Object char) {
    return '你是 $char。你將...';
  }

  @override
  String get instructionsInsertedAfterHistory => '插入在聊天記錄之後的指令（也稱為「越獄提示詞」）。';

  @override
  String postHistoryInstructionsHint(Object char) {
    return '繼續扮演 $char...';
  }

  @override
  String get firstMessageGreeting => '第一則訊息（問候語）';

  @override
  String get firstMessageSentByCharacter => '開始新聊天時由角色傳送的第一則訊息。';

  @override
  String firstMessageHint(Object user) {
    return '*走進房間* 你好，$user！';
  }

  @override
  String get alternateGreetingsCanSwipe => '可透過滑動切換的替代第一則訊息。';

  @override
  String greeting(int index) {
    return '問候語 $index';
  }

  @override
  String get alternativeGreetingMessage => '替代問候訊息...';

  @override
  String get removeGreeting => '移除問候語';

  @override
  String get moveUp => '上移';

  @override
  String get moveDown => '下移';

  @override
  String get noAlternateGreetings => '尚無替代問候語。點選 + 加入。';

  @override
  String exampleDialogueDemonstrate(Object char, Object user) {
    return '用於展示角色說話方式的範例對話。\n格式：<START>\n$user：你好\n$char：你好！';
  }

  @override
  String exampleMessagesHint(Object char, Object user) {
    return '<START>\n$user：你好嗎？\n$char：我很好，謝謝關心！';
  }

  @override
  String get creatorNotesNotSentToAi => '角色作者留下的註記（不會傳送給 AI）。';

  @override
  String get creatorNotesHint => '建議設定、背景註記...';

  @override
  String get tagsCommaSeparated => '以逗號分隔的標籤清單';

  @override
  String get tagsHint => '奇幻, 女性, 冒險';

  @override
  String get creator => '作者';

  @override
  String get yourNameOrUsername => '你的姓名或使用者名稱';

  @override
  String get versionNumber => '1.0.0';

  @override
  String get characterInfo => '角色資訊';

  @override
  String characterId(String id) {
    return 'ID：$id';
  }

  @override
  String created(String date) {
    return '建立時間：$date';
  }

  @override
  String modified(String date) {
    return '修改時間：$date';
  }

  @override
  String get characterSavedSuccessfully => '角色儲存成功';

  @override
  String failedToSaveCharacter(String error) {
    return '儲存角色失敗：$error';
  }

  @override
  String get addAlternateGreeting => '加入替代問候語';

  @override
  String get groupInfo => '群組資訊';

  @override
  String get responseMode => '回覆模式';

  @override
  String get howCharactersTakeTurns => '角色輪流回覆的方式';

  @override
  String get sequential => '依序';

  @override
  String get charactersRespondInOrder => '角色依序回覆';

  @override
  String get random => '隨機';

  @override
  String get randomCharacterResponds => '每輪由隨機角色回覆';

  @override
  String get allAtOnce => '全部同時回覆';

  @override
  String get allNonMutedCharactersRespond => '所有未靜音的角色都回覆';

  @override
  String get manual => '手動';

  @override
  String get youSelectWhoResponds => '由你選擇回覆的角色';

  @override
  String get natural => '自然';

  @override
  String get aiDecidesBasedOnContext => 'AI 依上下文與觸發詞決定';

  @override
  String membersCount(int count) {
    return '成員（$count）';
  }

  @override
  String get noMembersYet => '尚無成員，請向群組加入角色。';

  @override
  String talkativenessPercent(int percent) {
    return '活躍度：$percent%';
  }

  @override
  String triggers(String words) {
    return '觸發詞：$words';
  }

  @override
  String get mute => '靜音';

  @override
  String get unmute => '取消靜音';

  @override
  String get memberSettings => '成員設定';

  @override
  String talkativenessLabel(int percent) {
    return '活躍度：$percent%';
  }

  @override
  String get higherValuesMoreLikely => '數值越高，角色回覆的可能性越大。';

  @override
  String get triggerWords => '觸發詞';

  @override
  String get triggerWordsHint => '詞語1, 詞語2, 詞語3';

  @override
  String get characterWillRespondWhenTriggered => '訊息中出現這些詞時，角色會回覆。';

  @override
  String get addMemberToGroup => '加入群組成員';

  @override
  String get noMoreCharactersAvailable => '沒有更多可加入的角色';

  @override
  String get groupSaved => '群組已儲存';

  @override
  String deleteGroupAndChats(String name) {
    return '確定要刪除「$name」嗎？';
  }

  @override
  String get startChatAction => '開始聊天';

  @override
  String get noTagsYet => '尚無標籤';

  @override
  String get createTagsToOrganize => '建立標籤以整理角色';

  @override
  String characterCount(int count, String plural) {
    return '$count 個角色$plural';
  }

  @override
  String deleteTagConfirmation(String name) {
    return '確定要刪除標籤「$name」嗎？\n\n所有角色上的此標籤都會被移除。';
  }

  @override
  String get enterTagName => '輸入標籤名稱';

  @override
  String get iconEmoji => '圖示（表情符號）';

  @override
  String get enterEmojiOptional => '輸入表情符號（選填）';

  @override
  String get pleaseEnterTagName => '請輸入標籤名稱';

  @override
  String get worldInfoLorebooks => '世界書';

  @override
  String get createLorebook => '建立世界書';

  @override
  String get noLorebooksYet => '尚無世界書';

  @override
  String get lorebooksInjectContext => '偵測到關鍵字時，世界書會向聊天注入上下文。';

  @override
  String entriesCount(int count) {
    return '$count 個項目';
  }

  @override
  String deleteLorebookConfirmation(String name) {
    return '確定要刪除「$name」及其所有項目嗎？';
  }

  @override
  String get enterLorebookName => '輸入世界書名稱';

  @override
  String get optionalDescriptionHint => '選填描述';

  @override
  String get globalScope => '全域';

  @override
  String get applyToAllChats => '套用至所有聊天';

  @override
  String get pleaseEnterName2 => '請輸入名稱';

  @override
  String get noEntriesYet => '尚無項目';

  @override
  String get addEntriesWithKeywords => '加入帶關鍵字的項目，以便向聊天注入上下文';

  @override
  String deleteEntryConfirmation(String keys) {
    return '確定要刪除此項目嗎？\n\n關鍵字：$keys';
  }

  @override
  String get constant => '常數';

  @override
  String get selective => '選擇性比對';

  @override
  String get keywordsCommaSeparated => '關鍵字（以逗號分隔）';

  @override
  String get keywordsHint => '龍, 巨龍, 蛇';

  @override
  String get entryActivatesWhenKeywordFound => '聊天中出現任一關鍵字時啟用項目';

  @override
  String get secondaryKeysOptional => '次要關鍵字（選填）';

  @override
  String get secondaryKeysHint => '火, 火焰';

  @override
  String get bothPrimaryAndSecondaryMustMatch => '啟用後，主要關鍵字與次要關鍵字必須同時符合（選擇性模式）';

  @override
  String get commentOptional => '註解（選填）';

  @override
  String get noteForThisEntry => '此項目的註記';

  @override
  String get contentLabel => '內容';

  @override
  String get contextToInjectWhenMatches => '關鍵字符合時要注入的上下文...';

  @override
  String get pleaseEnterAtLeastOneKeyword => '請至少輸入一個關鍵字';

  @override
  String get pleaseEnterContent => '請輸入內容';

  @override
  String get anthropic => 'Anthropic';

  @override
  String get cohere => 'Cohere';

  @override
  String get customProvider => '自訂';

  @override
  String get apiEndpointHint => 'https://api.example.com/v1';

  @override
  String get apiKeyHint => 'sk-...';

  @override
  String get xaiApiKeyHint => 'sk-...';

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
  String get streamResponse => '串流回覆';

  @override
  String get streamTokensAsGenerated => '產生 Token 時即時傳輸';

  @override
  String get useSystemPrompt => '使用系統提示詞';

  @override
  String get includeSystemInstructions => '包含系統指令';

  @override
  String get configurationSavedSuccessfully => '設定儲存成功';

  @override
  String get errorSavingConfiguration => '儲存設定時發生錯誤';

  @override
  String get copyAll => '全部複製';

  @override
  String get showFavoritesOnly => '僅顯示收藏';

  @override
  String get sortBy => '排序方式';

  @override
  String get filterByTags => '依標籤篩選';

  @override
  String get favorites => '收藏';

  @override
  String get manage => '管理';

  @override
  String get noTagsCreatedYet => '尚未建立標籤';

  @override
  String get createTags => '建立標籤';

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個角色',
      one: '1 個角色',
    );
    return '$_temp0';
  }

  @override
  String get characterTagsLegacy => '角色標籤（舊版）';

  @override
  String get done => '完成';

  @override
  String applyFiltersSelected(int count) {
    return '套用（已選 $count 項）';
  }

  @override
  String get enterPresetName => '輸入預設名稱';

  @override
  String get deleteScript => '刪除指令碼';

  @override
  String get aiConfig => 'AI 設定';

  @override
  String get authorsNoteDescription => '加入將在指定深度注入對話的上下文或指令。';

  @override
  String get enableAuthorsNote => '啟用作者註記';

  @override
  String get injectNoteIntoContext => '將註記注入對話上下文';

  @override
  String get injectionDepth => '注入深度';

  @override
  String get messagesFromEndWhereInserted => '從末尾數起插入註記的訊息位置';

  @override
  String get noteContent => '註記內容';

  @override
  String get authorsNoteHint =>
      '在此輸入作者註記...\n\n範例：\n• [風格：使用詩意、富有描述性的方式寫作]\n• [著重情感深度與角色發展]\n• [角色今天心情憂鬱]';

  @override
  String get enterNameForCheckpoint => '輸入此檢查點的名稱';

  @override
  String get addDescription => '加入描述';

  @override
  String createCheckpointAtMessage(int index) {
    return '將在訊息 $index 處建立檢查點。';
  }

  @override
  String get longPressMessageToBookmark => '長按訊息可建立書籤';

  @override
  String get contextManagement => '上下文管理';

  @override
  String get autoSummarize => '自動摘要';

  @override
  String get autoSummarizeDescription => '上下文用量較高時，自動摘要並壓縮聊天記錄';

  @override
  String get autoSummarizeThreshold => '自動摘要門檻';

  @override
  String get autoSummarizeThresholdDescription => '上下文達到最大值的指定百分比時觸發摘要';

  @override
  String get branchFromBookmark => '從書籤建立分支';

  @override
  String branchFromBookmarkWarning(String name) {
    return '這將刪除「$name」之後的所有訊息，並從該位置繼續。可先建立新書籤以儲存目前狀態。';
  }

  @override
  String get branch => '分支';

  @override
  String branchedFrom(String name) {
    return '分支起點：「$name」';
  }

  @override
  String deleteBookmarkConfirmation(String name) {
    return '確定要刪除「$name」嗎？';
  }

  @override
  String messageIndexAndDate(int index, String date) {
    return '訊息 $index · $date';
  }

  @override
  String get branchFromHere => '從此處建立分支';

  @override
  String previewBookmark(String name) {
    return '預覽：$name';
  }

  @override
  String get messageNotFoundInChat => '目前聊天中找不到該訊息';

  @override
  String get you => '你';

  @override
  String get assistant => '助理';

  @override
  String get reasoningCopiedToClipboard => '推理內容已複製到剪貼簿';

  @override
  String charsCount(int count) {
    return '$count 個字元';
  }

  @override
  String get copyReasoning => '複製推理內容';

  @override
  String get commands => '命令';

  @override
  String aliasesLabel(String aliases) {
    return '別名：$aliases';
  }

  @override
  String get noSpritesAddedYet => '尚未加入立繪';

  @override
  String get errorLoadingSprites => '載入立繪時發生錯誤';

  @override
  String get insertionPosition => '插入位置';

  @override
  String get beforeCharacterDefinition => '角色定義之前';

  @override
  String get afterCharacterDefinition => '角色定義之後';

  @override
  String get beforeExampleMessages => '範例訊息之前';

  @override
  String get afterExampleMessages => '範例訊息之後';

  @override
  String get beforeAuthorNote => '作者註記之前';

  @override
  String get afterAuthorNote => '作者註記之後';

  @override
  String get atDepth => '指定深度';

  @override
  String get beforeSystemPrompt => '系統提示詞之前';

  @override
  String get afterSystemPrompt => '系統提示詞之後';

  @override
  String get insertionOrder => '插入順序';

  @override
  String get lowerOrderInsertsFirst => '順序值越小越先插入';

  @override
  String get alwaysIncludeInPrompt => '一律加入提示詞（忽略關鍵字）';

  @override
  String get requiresSecondaryKey => '主要關鍵字與次要關鍵字必須同時符合';

  @override
  String get debugLog => '偵錯記錄';

  @override
  String get debugLogDescription => '顯示浮動偵錯按鈕以檢視記錄';

  @override
  String get autoScroll => '自動捲動';

  @override
  String get clearLogs => '清除記錄';

  @override
  String get searchLogs => '搜尋記錄...';

  @override
  String get noLogsYet => '尚無記錄';

  @override
  String get allCharactersAvailable => '所有角色';

  @override
  String get availableToAllCharactersNotGlobal => '所有角色皆可使用（依上下文比對）';

  @override
  String get specificCharacter => '特定角色';

  @override
  String get linkToSpecificCharacter => '僅連結至特定角色';

  @override
  String get selectCharacter => '選擇角色';

  @override
  String get pleaseSelectCharacter => '請選擇角色';

  @override
  String get contextUsage => '上下文用量';

  @override
  String get maxContext => '最大上下文';

  @override
  String get remaining => '剩餘';

  @override
  String get breakdown => '明細';

  @override
  String get cloudBackup => '雲端備份';

  @override
  String get cloudBackupInfo => '雲端備份';

  @override
  String get cloudBackupDescription => '跨裝置同步資料';

  @override
  String get cloudBackupSubtitle => '備份至 iCloud 或 Google 雲端硬碟，並可在任何裝置上還原';

  @override
  String get backupContents => '備份內容';

  @override
  String get allTextData => '全部文字資料';

  @override
  String get allTextDataDescription =>
      '角色、聊天、訊息、世界書、群組、Persona、記憶、Data Bank、RPG 資料、故事、動態和應用程式狀態';

  @override
  String get characterCardImages => '全部角色卡圖片';

  @override
  String get characterCardImagesDescription => '角色、Persona 和群組頭像，以及角色表情立繪';

  @override
  String get worldBookImages => '全部世界書圖片';

  @override
  String get worldBookImagesDescription => '世界書引用的本機圖片';

  @override
  String get conversationImages => '全部聊天與動態圖片';

  @override
  String get conversationImagesDescription => '聊天附件、產生的聊天圖片和動態圖片';

  @override
  String get backgroundImages => '全部背景圖片';

  @override
  String get backgroundImagesDescription => '匯入的全域背景和聊天背景';

  @override
  String get live2DBackup => '全部 Live2D 模型';

  @override
  String get live2DModelsBackupDescription => '可選的大型檔案，可能顯著增加備份大小';

  @override
  String get independentMediaBackup => '獨立媒體備份';

  @override
  String get independentMediaBackupDescription =>
      '圖片會分開儲存；即使媒體失敗或缺失，資料備份與還原仍可正常完成。';

  @override
  String get mediaBackupPartialSuccess => '資料庫資料已成功完成，但部分媒體或設定未能備份或還原。';

  @override
  String mediaRestoreComplete(int count) {
    return '媒體還原完成：$count 個檔案';
  }

  @override
  String get mediaNotIncludedInBackup => '此備份不包含媒體包，本次僅還原了資料。';

  @override
  String get backupStagePreparingData => '正在整理資料庫和設定...';

  @override
  String get backupStageScanningMedia => '正在掃描媒體檔案...';

  @override
  String backupStageCompressingMedia(int processed, int total) {
    return '正在壓縮媒體：$processed/$total 個檔案';
  }

  @override
  String get backupStageUploadingData => '正在上傳資料備份...';

  @override
  String get backupStageUploadingMedia => '正在上傳媒體包...';

  @override
  String get backupStageDownloadingData => '正在下載資料備份...';

  @override
  String get backupStageDownloadingMedia => '正在下載媒體包...';

  @override
  String get backupStageVerifyingMedia => '正在校驗媒體包...';

  @override
  String backupStageRestoringMedia(int processed, int total) {
    return '正在還原媒體：$processed/$total 個檔案';
  }

  @override
  String get backupStageRestoringData => '正在合併或替換資料庫...';

  @override
  String get enableICloudBackup => '啟用 iCloud 備份';

  @override
  String get enableICloudBackupDescription =>
      '將備份儲存到 iCloud 雲碟，以便在其他 Apple 裝置上使用';

  @override
  String get enableCrossDeviceSync => '自動跨裝置同步';

  @override
  String get enableCrossDeviceSyncDescription =>
      '在 Apple 裝置上透過 iCloud、在 Android 及其他已登入裝置上透過 Google 雲端硬碟自動保持資料最新。應用程式進入背景時上傳，下次啟動或回到前景時下載。';

  @override
  String get enableGoogleDriveBackup => '啟用 Google 雲端硬碟備份';

  @override
  String get enableGoogleDriveBackupDescription =>
      '將備份儲存到 Google 雲端硬碟，以便在其他 Android 和已登入裝置上使用';

  @override
  String get syncNow => '立即同步';

  @override
  String get crossDeviceSyncComplete => '裝置已同步';

  @override
  String get openingBackupFile => '正在開啟備份…';

  @override
  String get iCloudNotAvailable => 'iCloud 無法使用';

  @override
  String get iCloudNotAvailableDescription => '請先在「設定」中登入 iCloud';

  @override
  String get backupToICloud => '備份至 iCloud';

  @override
  String lastSync(String time) {
    return '上次同步：$time';
  }

  @override
  String get neverSynced => '從未同步';

  @override
  String get iCloudBackups => 'iCloud 備份';

  @override
  String get noCloudBackups => '尚無雲端備份';

  @override
  String get googleDriveExport => '匯出至 Google 雲端硬碟';

  @override
  String get googleDriveExportDescription => '將備份檔案儲存至 Google 雲端硬碟或其他位置';

  @override
  String get googleDriveImport => '從 Google 雲端硬碟匯入';

  @override
  String get googleDriveImportDescription => '從 Google 雲端硬碟或其他位置的備份檔案還原';

  @override
  String get import_action => '匯入';

  @override
  String get importBackup => '匯入備份';

  @override
  String get backupExported => '備份已成功匯出';

  @override
  String get restoreSettings => '還原設定';

  @override
  String get defaultRestoreMode => '預設還原模式';

  @override
  String get selectRestoreMode => '選擇資料還原方式：';

  @override
  String get restoreWarning => '依所選模式不同，還原資料可能會覆寫現有資料。請先備份目前資料。';

  @override
  String get restore => '還原';

  @override
  String restoreComplete(int added, int updated, int skipped) {
    return '還原完成：新增 $added、更新 $updated、略過 $skipped';
  }

  @override
  String get selectFileAndImport => '選擇檔案並匯入';

  @override
  String get aboutRestoreModes => '關於還原模式';

  @override
  String get aboutRestoreModesDescription =>
      '取代：以備份資料覆寫所有本機資料。\n合併：同時保留兩者，發生衝突時以較新資料為準。\n僅新增：只加入新項目，保留所有現有資料。';

  @override
  String get signInToGoogleDrive => '登入 Google 雲端硬碟';

  @override
  String get signInToGoogleDriveDescription => '使用 Google 帳戶登入，以備份與還原資料';

  @override
  String get signIn => '登入';

  @override
  String get signOut => '登出';

  @override
  String get signedInSuccessfully => '登入成功';

  @override
  String get backupToGoogleDrive => '備份至 Google 雲端硬碟';

  @override
  String get googleDriveBackups => 'Google 雲端硬碟備份';

  @override
  String get bubbleOpacity => '訊息不透明度';

  @override
  String get bubbleOpacityHelp => '控制啟用背景時訊息泡泡的透明度。';

  @override
  String get swipes => '備選回覆';

  @override
  String get deleteSwipeQuestion => '刪除此備選回覆?';

  @override
  String get charsSuffix => '字元';

  @override
  String get swipeDeleted => '已刪除備選回覆';

  @override
  String get noAlternateSwipes => '沒有可刪除的備選回覆';

  @override
  String get reasoningEffort => '推理強度';

  @override
  String get effortAuto => '自動';

  @override
  String get effortMin => '最低';

  @override
  String get effortLow => '低';

  @override
  String get effortMedium => '中';

  @override
  String get effortHigh => '高';

  @override
  String get effortMax => '最高';

  @override
  String get promptCaching => '提示詞快取';

  @override
  String get promptCachingDescription => '快取系統提示詞與歷史以降低費用';

  @override
  String get mergeConsecutiveRoles => '合併連續同角色訊息';

  @override
  String get mergeConsecutiveRolesDescription => '用於要求 user/assistant 嚴格交替的介面';

  @override
  String get connectionProfiles => '連線設定檔';

  @override
  String get connectionProfilesHint => '儲存目前連線以便快速切換';

  @override
  String profilesSavedCount(String count) {
    return '已儲存 $count 個';
  }

  @override
  String get saveCurrent => '儲存目前';

  @override
  String get noProfilesHint => '還沒有設定檔。儲存目前連線,以後即可一鍵切換。';

  @override
  String appliedProfile(String name) {
    return '已套用設定檔:$name';
  }

  @override
  String get saveConnectionProfile => '儲存連線設定檔';

  @override
  String get profileName => '設定檔名稱';

  @override
  String get gallery => '圖庫';

  @override
  String get allLabel => '全部';

  @override
  String get ungrouped => '未分組';

  @override
  String get setAsBackground => '設為背景';

  @override
  String get moveToFolder => '移動到資料夾';

  @override
  String get folderName => '資料夾名稱';

  @override
  String get folderNameHint => '留空表示未分組';

  @override
  String get move => '移動';

  @override
  String moveFailed(String error) {
    return '移動失敗:$error';
  }

  @override
  String deleteFailed(String error) {
    return '刪除失敗:$error';
  }

  @override
  String get embedPendingDocuments => '嵌入待處理文件';

  @override
  String embeddedDocuments(String count) {
    return '已嵌入 $count 個文件';
  }

  @override
  String get allDocumentsEmbedded => '所有文件均已嵌入';

  @override
  String embeddingFailed(String error) {
    return '嵌入失敗:$error';
  }

  @override
  String get gptImageSettings => 'GPT-Image 設定';

  @override
  String get qualityLabel => '品質';

  @override
  String get qualityAutoDescription => '自動 - 由模型決定';

  @override
  String get qualityHighDescription => '高 - 更高細節與一致性';

  @override
  String get impersonate => 'AI 代打';

  @override
  String get impersonateHint => '讓 AI 以你的口吻寫一條回覆';

  @override
  String get startReplyWith => '回覆引導';

  @override
  String get startReplyWithHint => 'AI 的回覆將以這段文字開頭';

  @override
  String get chatLorebooks => '聊天世界書';

  @override
  String get chatLorebooksHint => '僅在本聊天中生效的世界書';

  @override
  String get messagesCleared => '所有訊息已清除';

  @override
  String get selectCharacterCardFiles => '選擇角色卡檔案';

  @override
  String get supportedCharacterCardFormats => '支援批次匯入：PNG、CharX 與 JSON';

  @override
  String get importFromUrl => '從 URL 匯入';

  @override
  String get enterCharacterCardUrl => '輸入角色卡 URL...';

  @override
  String get pasteAndImport => '貼上並匯入';

  @override
  String get supportedCommunities => '支援的社群（點選開啟）：';

  @override
  String get publicCardLinksSupported => '亦支援公開的 PNG 與 JSON 連結';

  @override
  String get communityLinks => '社群連結';

  @override
  String importSummaryMixed(Object failed, Object success) {
    return '已匯入 $success 張角色卡；$failed 張失敗';
  }

  @override
  String importSummarySuccess(Object count) {
    return '已匯入 $count 張角色卡';
  }

  @override
  String get importSummaryFailed => '所有匯入皆失敗';

  @override
  String processingProgress(Object processed, Object total) {
    return '處理中：$processed / $total';
  }

  @override
  String get importSuccessLabel => '成功';

  @override
  String get importFailureLabel => '失敗';

  @override
  String get totalLabel => '總計';

  @override
  String importAllCharacters(Object count) {
    return '全部匯入（$count）';
  }

  @override
  String get switchLayout => '切換版面配置';

  @override
  String get stopGenerating => '停止產生';

  @override
  String get imageBackgroundSettings => '圖片背景設定';

  @override
  String get useCharacterImageAsBackground => '使用角色圖片作為背景';

  @override
  String get useCharacterImageAsBackgroundHint => '有角色頭像時自動使用';

  @override
  String get backgroundOpacity => '背景不透明度';

  @override
  String get backgroundOpacityHint => '套用至自訂背景與角色圖片背景';

  @override
  String get enableBackgroundBlur => '啟用背景模糊';

  @override
  String get enableBackgroundBlurHint => '對所有圖片背景套用模糊';

  @override
  String get backgroundPriorityHint => '優先順序：角色背景 > 全域背景 > 角色圖片 > 預設色彩';

  @override
  String get openRouterUpstreamProvider => 'OpenRouter 服務商';

  @override
  String get automaticRouting => '自動路由';

  @override
  String get openRouterProviderHint => '選擇此模型使用的上游服務商';

  @override
  String get useCurrentChatConnection => '使用目前聊天連線';

  @override
  String get chatConnectionAppliedToEmbeddings => '聊天端點與 API 金鑰已套用至嵌入服務';

  @override
  String get localFeatures => '本機功能';

  @override
  String get playHub => '玩法';

  @override
  String get story => '故事';

  @override
  String get storyEnabledSubtitle => '關閉後不會分析聊天，也不會產生或更新故事章節。';

  @override
  String playAiFeatureEnableTitle(String feature) {
    return '開啟「$feature」？';
  }

  @override
  String playAiFeatureEnableDescription(String feature) {
    return '「$feature」會主動將角色資訊和相關對話傳送給你設定的 AI 供應商來產生內容。此功能預設關閉。是否現在開啟？';
  }

  @override
  String get playAiFeatureEnableAction => '開啟';

  @override
  String get storyEmptyHint => '聊一段時間才會有故事。';

  @override
  String get storyGoToChat => '去聊天';

  @override
  String get storyJotNote => '記一筆';

  @override
  String get storyJotNoteHint => '寫一句短記事。這裡不是章節編輯器。';

  @override
  String get storyKeyEvents => '發生了什麼';

  @override
  String get storyStateChanges => '改變了什麼';

  @override
  String get storyOpenThreads => '還沒解決';

  @override
  String get storyNextSteps => '可以怎麼繼續';

  @override
  String get storyContinue => '接著演';

  @override
  String get storyFork => '從這裡分支';

  @override
  String get storyCompare => '對照後果';

  @override
  String get storyViewSource => '查看原文';

  @override
  String get storyOriginalLine => '原始路線';

  @override
  String get storyBranchName => '分支名稱';

  @override
  String get storyBranchNameHint => '例如：這次我選擇留下';

  @override
  String get storyCreateBranch => '建立分支';

  @override
  String get storyDefaultDirection => '從這一章尚未解決的時刻繼續。';

  @override
  String storyContinueDraft(String title, String direction) {
    return '接著「$title」往下演：$direction';
  }

  @override
  String storyForkCreated(String name) {
    return '分支「$name」已經準備好。';
  }

  @override
  String get storyNoOutcome => '這條路線還沒有形成新的章節後果。';

  @override
  String get storyChooseTwoLines => '選擇兩條路線進行對照。';

  @override
  String get storyLeftLine => '第一條路線';

  @override
  String get storyRightLine => '第二條路線';

  @override
  String get storySearch => '搜尋故事';

  @override
  String get storyNoSearchResults => '沒有符合的章節。';

  @override
  String get storySelectLine => '故事線';

  @override
  String get storyNoteSaved => '已經記進故事。';

  @override
  String get storyNoChats => '先開始一場聊天，才能記故事。';

  @override
  String get storyConsequencesAfterFork => '分支之後';

  @override
  String get moments => '動態';

  @override
  String get momentsDisabledEmpty => '動態已關閉。去設定裡打開。';

  @override
  String get momentsEnabledSubtitle => '關閉後動態不再更新，角色也不會再發。';

  @override
  String get momentsInChat => '本聊天帶入動態';

  @override
  String get momentsInChatHint => '預設關閉。打開後，這個角色才會知道好友和你的動態。';

  @override
  String get momentsEmpty => '還沒人發過。';

  @override
  String get momentsRefreshing => '大家正在發動態…';

  @override
  String get momentsCompose => '發表';

  @override
  String get momentsComposeHint => '這一刻的想法…';

  @override
  String get momentsAuthor => '誰在發';

  @override
  String get momentsAuthorMe => '我';

  @override
  String get momentsAddPhoto => '加張圖';

  @override
  String get momentsChangePhoto => '換一張';

  @override
  String get momentsNeedSomething => '先寫點什麼，或加張圖。';

  @override
  String get momentsComment => '留言';

  @override
  String get momentsSavePhoto => '儲存圖片';

  @override
  String get momentsPhotoSaved => '圖片儲存成功';

  @override
  String get momentsPhotoSaveFailed => '圖片儲存失敗';

  @override
  String get momentsFriends => '好友';

  @override
  String get momentsNoFriends => '還沒有好友。同一群聊裡的角色可以互加。';

  @override
  String get momentsTalk => '開聊';

  @override
  String get momentsExpose => '拆穿';

  @override
  String get momentsIgnore => '已讀不回';

  @override
  String get momentsWaiting => '等對方回';

  @override
  String get momentsWaitingBadge => '等待中';

  @override
  String get momentsIgnoredBadge => '已讀不回';

  @override
  String get momentsWriteToWorld => '寫入世界';

  @override
  String momentsFact(String fact) {
    return '實情：$fact';
  }

  @override
  String get playFeatureComingSoon => '這個玩法還沒準備好。';

  @override
  String get openDataBank => '開啟資料';

  @override
  String get openDataBankSubtitle => '從玩法進入資料庫';

  @override
  String get memoryInbox => '記憶收件匣';

  @override
  String get memoryInboxSubtitle => '審核及維護長期記憶';

  @override
  String get dataBank => '資料庫';

  @override
  String get dataBankSubtitle => '匯入、搜尋並綁定本機文件';

  @override
  String get rpgScenarioEditor => 'RPG 劇本編輯器';

  @override
  String get rpgScenarioEditorSubtitle => '建立並驗證本機劇本套件';

  @override
  String get capabilityCheck => '功能檢查';

  @override
  String get capabilityCheckSubtitle => '可用性、權限與設定';

  @override
  String get mcpServers => 'MCP 伺服器';

  @override
  String get mcpServersSubtitle => '連線、工具、權限與活動';

  @override
  String get toolCalling => '工具呼叫';

  @override
  String get toolCallingSubtitle => '內建工具、核准與限制';

  @override
  String get toolCallingAllow => '允許工具呼叫';

  @override
  String get toolCallingAllowSubtitle => '模型供應商只能要求下方啟用的工具';

  @override
  String get toolBuiltInTools => '內建工具';

  @override
  String get toolMcpTools => 'MCP 工具';

  @override
  String get toolMcpPermissionsSubtitle => '已連線的 MCP 伺服器使用各自的權限設定';

  @override
  String get toolSafetyLimits => '安全限制';

  @override
  String get toolRounds => '工具輪次';

  @override
  String get toolCallsPerResponse => '每次回覆的呼叫數';

  @override
  String get toolTimeLimit => '時間限制';

  @override
  String get toolTokenBudget => '工具 Token 預算';

  @override
  String get toolSeconds => '秒';

  @override
  String get toolTokens => 'Token';

  @override
  String toolDecrease(String control) {
    return '減少$control';
  }

  @override
  String toolIncrease(String control) {
    return '增加$control';
  }

  @override
  String get toolActivity => '工具活動';

  @override
  String get toolApprovalRequired => '需要核准';

  @override
  String get toolAllowOnce => '僅允許一次';

  @override
  String get toolAlwaysAllow => '一律允許';

  @override
  String get toolDeny => '拒絕';

  @override
  String get toolCancelCall => '取消工具呼叫';

  @override
  String get toolStatusWaitingApproval => '等待核准';

  @override
  String get toolStatusRunning => '執行中';

  @override
  String get toolStatusSucceeded => '已成功';

  @override
  String get toolStatusFailed => '失敗';

  @override
  String get toolStatusDenied => '已拒絕';

  @override
  String get toolStatusCancelled => '已取消';

  @override
  String get storageManagement => '儲存空間管理';

  @override
  String get storageManagementSubtitle => '空間用量、孤立檔案掃描與安全清理';

  @override
  String storageUsedOfQuota(String used, String quota) {
    return '已使用 $used，配額 $quota';
  }

  @override
  String get storageQuotaWarning => '儲存空間用量已超過警告門檻';

  @override
  String get storageWithinQuota => '儲存空間用量未超過警告門檻';

  @override
  String storageScanIncomplete(int count) {
    return '有 $count 個路徑無法檢查';
  }

  @override
  String get storageCategoryLive2d => 'Live2D 模型';

  @override
  String get storageCategoryAttachments => '附件與媒體';

  @override
  String get storageCategoryDataBank => '資料庫文件';

  @override
  String get storageCategoryAudio => '音訊';

  @override
  String get storageCategoryCache => '快取';

  @override
  String storageFilesCount(int count) {
    return '$count 個檔案';
  }

  @override
  String storageReclaimable(String size) {
    return '可回收 $size';
  }

  @override
  String get storageCleanupCandidates => '安全清理';

  @override
  String get storageNoCleanupCandidates => '未發現無引用或已過期的檔案';

  @override
  String get storageSelectAll => '全選';

  @override
  String get storageClearSelection => '清除選取';

  @override
  String get storageUndo => '復原';

  @override
  String get storageCleanSelected => '清理所選項目';

  @override
  String get storageCleanupReviewTitle => '確認清理';

  @override
  String storageCleanupReviewBody(int items, int files, String size) {
    return '將 $items 項（共 $files 個檔案，佔用 $size）移至可復原的垃圾桶？';
  }

  @override
  String get storageCleanupRecoverableHint => '有引用的檔案會受到保護。在暫存檔案被永久刪除前，可以復原操作。';

  @override
  String storageCleanupMoved(int count) {
    return '已將 $count 項移至可復原的垃圾桶';
  }

  @override
  String get storageCleanupRestored => '已復原清理';

  @override
  String get storageCleanupCompleted => '清理完成';

  @override
  String storageCleanupFailed(String error) {
    return '清理失敗：$error';
  }

  @override
  String get storageReasonInterruptedTemporary => '中斷操作留下的暫存資料';

  @override
  String get storageReasonMissingDatabaseReference => '資料庫中沒有文件引用此資料';

  @override
  String get storageReasonInterruptedDocumentCleanup => '文件清理被中斷';

  @override
  String get storageReasonMissingFileReference => '資料庫中沒有記錄引用此檔案';

  @override
  String get storageReasonExpiredTransient => '已過期的暫存資料';

  @override
  String get storageReasonExpiredAudio => '已過期的合成音訊';

  @override
  String get live2dUnavailableModelMessage =>
      '已指派的 Live2D 模型無法使用。請選擇其他模型或重新匯入。';

  @override
  String get live2dSelectionExpiredMessage => '該 Live2D 模型已無法使用。請選擇其他模型或重新匯入。';

  @override
  String live2dModelsImported(int count) {
    return '已匯入 $count 個 Live2D 模型';
  }

  @override
  String get live2dModelDeleted => '已刪除匯入的 Live2D 模型。';

  @override
  String get live2dCleanupPending => ' 檔案清理將於下次重新整理模型庫時重試。';

  @override
  String get live2dDeleteImportedModelQuestion => '刪除匯入的模型？';

  @override
  String live2dDeletePackageBody(int count) {
    return '此模型套件包含 $count 個模型，它們都會被刪除。';
  }

  @override
  String live2dDeleteModelBody(String name) {
    return '將從此裝置刪除「$name」。';
  }

  @override
  String get live2dDisabledFor => '下列角色將停用 Live2D：';

  @override
  String get live2dLicensing => 'Live2D 授權資訊';

  @override
  String get live2dLicenseNotice =>
      '渲染器包含 Live2D Cubism SDK 與 Core。模型檔案及商業發行可能適用其他條款。\n\n內建的 Hiyori Momose 模型是 Live2D Inc. 擁有著作權的官方範例資料，並依據 Live2D 免費素材授權協議與範例資料使用條款使用。本應用程式由作者自行決定製作。\n\n發行應用程式前，請確認每個匯入模型的使用權。';

  @override
  String get live2dReviewTerms => '查看條款';

  @override
  String live2dUnavailableLabel(String name) {
    return '$name（無法使用）';
  }

  @override
  String live2dImportedLabel(String name) {
    return '$name（已匯入）';
  }

  @override
  String get live2dImportZip => '匯入模型';

  @override
  String get live2dMotion => '動作';

  @override
  String get live2dPlayMotion => '播放動作';

  @override
  String get live2dStageAdjustment => '舞台調整';

  @override
  String get live2dMotionSpeed => '動作速度';

  @override
  String get live2dImportedModels => '已匯入模型';

  @override
  String live2dModelsCount(int count) {
    return '$count 個模型';
  }

  @override
  String get live2dDeleteImportedModel => '刪除匯入的模型';

  @override
  String get rpgScenarioTitle => 'RPG 劇本';

  @override
  String get rpgImportScenario => '匯入劇本';

  @override
  String get rpgSaveDraft => '儲存草稿';

  @override
  String get rpgRestoreDraft => '還原草稿';

  @override
  String get rpgExportScenario => '匯出劇本';

  @override
  String get rpgIssues => '問題';

  @override
  String rpgIssuesCount(int count) {
    return '問題（$count）';
  }

  @override
  String get rpgScenarioImportFailed => '劇本匯入失敗';

  @override
  String rpgScenarioImported(String name) {
    return '已匯入 $name';
  }

  @override
  String get rpgDraftSaved => '草稿已儲存';

  @override
  String get rpgDraftRestored => '草稿已還原';

  @override
  String get rpgNoSavedDraft => '沒有已儲存的草稿';

  @override
  String get rpgScenarioExported => '劇本已匯出';

  @override
  String get rpgSetValue => '設定值';

  @override
  String rpgAddItem(String label) {
    return '新增$label';
  }

  @override
  String get rpgItemActions => '項目操作';

  @override
  String get rpgMoveUp => '上移';

  @override
  String get rpgMoveDown => '下移';

  @override
  String get rpgAddEntry => '新增項目';

  @override
  String get rpgDeleteEntry => '刪除項目';

  @override
  String rpgAddEntryTitle(String label) {
    return '新增$label項目';
  }

  @override
  String get rpgValue => '值';

  @override
  String get rpgEnterInteger => '請輸入整數';

  @override
  String get rpgEnterNumber => '請輸入數字';

  @override
  String rpgItemNumber(int number) {
    return '項目 $number';
  }

  @override
  String rpgFieldLabel(String field) {
    String _temp0 = intl.Intl.selectLogic(
      field,
      {
        'metadata': '中繼資料',
        'compatibility': '相容性',
        'initialState': '初始狀態',
        'initialSeed': '初始種子',
        'schemaVersion': '結構版本',
        'protectedFields': '受保護欄位',
        'minimumEngineVersion': '最低引擎版本',
        'maximumEngineVersion': '最高引擎版本',
        'requiredCapabilities': '所需功能',
        'actors': '角色',
        'attributes': '屬性',
        'author': '作者',
        'availability': '可用性',
        'branchId': '分支 ID',
        'conditions': '條件',
        'cooldowns': '冷卻',
        'costs': '消耗',
        'createdAt': '建立時間',
        'data': '資料',
        'day': '天數',
        'description': '描述',
        'difficulty': '難度',
        'effects': '效果',
        'elapsedMinutes': '經過分鐘',
        'eventHistory': '事件歷程',
        'expression': '運算式',
        'failureEffects': '失敗效果',
        'format': '格式',
        'id': 'ID',
        'initialValue': '初始值',
        'inventory': '物品欄',
        'items': '物品',
        'label': '標籤',
        'locations': '地點',
        'maximum': '最大值',
        'minimum': '最小值',
        'minuteOfDay': '當日分鐘',
        'name': '名稱',
        'narrative': '敘事',
        'objectiveIds': '目標 ID',
        'objectiveProgress': '目標進度',
        'operator': '運算子',
        'quantity': '數量',
        'quests': '任務',
        'relationships': '關係',
        'source': '來源',
        'stages': '階段',
        'status': '狀態',
        'successEffects': '成功效果',
        'summary': '摘要',
        'tags': '標籤',
        'target': '目標',
        'turn': '回合',
        'type': '類型',
        'updatedAt': '更新時間',
        'value': '值',
        'variables': '變數',
        'version': '版本',
        'other': '$field',
      },
    );
    return '$_temp0';
  }

  @override
  String get dataBankChatRetrievalSettings => '聊天檢索設定';

  @override
  String get dataBankRebuildSearchIndex => '重建搜尋索引';

  @override
  String get dataBankImportDocument => '匯入文件';

  @override
  String get dataBankSearchDocuments => '搜尋文件';

  @override
  String get dataBankClearSearch => '清除搜尋';

  @override
  String get dataBankNoMatches => '沒有相符結果';

  @override
  String get dataBankNoDocuments => '尚無文件';

  @override
  String get dataBankSearchIndexRebuilt => '搜尋索引已重建';

  @override
  String dataBankDeleteDocumentQuestion(String name) {
    return '刪除 $name？';
  }

  @override
  String dataBankDeleteDocumentBody(
      int versions, int chunks, int bindings, int files) {
    return '將刪除 $versions 個版本、$chunks 個區塊、$bindings 個綁定與 $files 個受管理檔案。';
  }

  @override
  String get dataBankChatRetrieval => '聊天檢索';

  @override
  String get dataBankUseInChat => '在聊天中使用資料庫';

  @override
  String get dataBankQueryExpansion => '根據對話擴充查詢';

  @override
  String get dataBankSemanticReranking => '語意重新排序';

  @override
  String get dataBankUsesEmbeddingProvider => '使用已設定的嵌入模型供應商';

  @override
  String get dataBankSourcesPerResponse => '每次回覆的來源數';

  @override
  String get dataBankTokenBudget => 'Token 預算';

  @override
  String get dataBankChunksPerDocument => '每份文件的區塊數';

  @override
  String get dataBankLastRetrieval => '上次檢索';

  @override
  String get dataBankNoRetrievalYet => '尚未執行過聊天檢索。';

  @override
  String get dataBankModeLocalFts => '本機全文搜尋';

  @override
  String get dataBankModeSemantic => '混合語意重新排序';

  @override
  String get dataBankModeFallback => '本機備援';

  @override
  String dataBankSourcesCount(int count) {
    return '$count 個來源';
  }

  @override
  String get dataBankInspectAllSources => '查看所有來源';

  @override
  String dataBankChunksCount(int count) {
    return '$count 個區塊';
  }

  @override
  String dataBankBindingsCount(int count) {
    return '$count 個綁定';
  }

  @override
  String get dataBankProcessingFailed => '處理失敗';

  @override
  String get dataBankManageBindings => '管理綁定';

  @override
  String get dataBankRebuildDocument => '重建文件';

  @override
  String get dataBankBindings => '綁定';

  @override
  String get dataBankRemoveBinding => '移除綁定';

  @override
  String get dataBankAddBinding => '新增綁定';

  @override
  String dataBankStatusSemantics(String status) {
    return '狀態：$status';
  }

  @override
  String get dataBankDismiss => '關閉提示';

  @override
  String get dataBankStatePending => '等待處理';

  @override
  String get dataBankStateProcessing => '處理中';

  @override
  String get dataBankStateReady => '就緒';

  @override
  String get dataBankStateFailed => '失敗';

  @override
  String get dataBankStateDeleted => '已刪除';

  @override
  String get dataBankDuplicateDocument => '該文件已存在於資料庫中。';

  @override
  String get memoryChatContext => '聊天內容';

  @override
  String get memoryAutomaticExtraction => '自動擷取';

  @override
  String get memoryAutomaticExtractionSubtitle => '在新對話輪次後使用目前的 AI 連線';

  @override
  String get memoryRecentChat => '最近聊天';

  @override
  String get memoryCancelExtraction => '取消擷取';

  @override
  String get memoryExtractFromChat => '從聊天中擷取';

  @override
  String memoryExtractionResult(int candidates, int duplicates, int rejected) {
    return '$candidates 個候選、$duplicates 個重複、$rejected 個遭拒';
  }

  @override
  String memoryCandidatesCount(int count) {
    return '候選 $count';
  }

  @override
  String memoryActiveCount(int count) {
    return '使用中 $count';
  }

  @override
  String memoryHistoryCount(int count) {
    return '歷程 $count';
  }

  @override
  String get memoryCreate => '建立記憶';

  @override
  String get memoryClearSelection => '清除選取';

  @override
  String get memoryIgnoreSelected => '忽略所選項目';

  @override
  String get memoryMergeSelected => '合併所選項目';

  @override
  String memorySelectedCount(int count) {
    return '已選取 $count 項';
  }

  @override
  String get memoryUseInChat => '在聊天中使用記憶';

  @override
  String get memorySemanticReranking => '語意重新排序';

  @override
  String get memoryConfiguredEmbeddingProvider => '已設定的嵌入模型供應商';

  @override
  String get memoryContextBudget => '內容預算';

  @override
  String memoryTokensCount(int count) {
    return '$count Token';
  }

  @override
  String get memoryEdit => '編輯記憶';

  @override
  String get memoryMerge => '合併記憶';

  @override
  String memoryImportancePercent(int percent) {
    return '重要性 $percent%';
  }

  @override
  String memoryExpires(String date) {
    return '到期時間 $date';
  }

  @override
  String get memoryApprove => '核准';

  @override
  String get memoryUnlock => '解除鎖定';

  @override
  String get memoryLock => '鎖定';

  @override
  String get memoryOpenSource => '開啟來源';

  @override
  String get memoryIgnore => '忽略';

  @override
  String get memoryChatScope => '聊天範圍';

  @override
  String get memoryKind => '類型';

  @override
  String get memoryLabel => '記憶';

  @override
  String get memoryIdentityKey => '識別鍵';

  @override
  String get memoryImportance => '重要性';

  @override
  String get memoryLocked => '已鎖定';

  @override
  String get memoryKindPersonFact => '人物事實';

  @override
  String get memoryKindRelationship => '關係';

  @override
  String get memoryKindEvent => '事件';

  @override
  String get memoryKindCommitment => '承諾';

  @override
  String get memoryKindPreference => '偏好';

  @override
  String get memoryKindLocation => '地點';

  @override
  String get memoryKindOther => '其他';

  @override
  String get memoryScopeCharacterPersona => '角色與使用者設定';

  @override
  String get memoryScopeGroup => '群組';

  @override
  String get mcpAddServer => '新增 MCP 伺服器';

  @override
  String get mcpServersTab => '伺服器';

  @override
  String get mcpActivityTab => '活動';

  @override
  String get mcpProtocolName => '模型內容協定';

  @override
  String get mcpNoServers => '尚無 MCP 伺服器';

  @override
  String mcpErrorCode(String code) {
    return '代碼：$code';
  }

  @override
  String mcpProtocolVersion(String version) {
    return '協定 $version';
  }

  @override
  String get mcpDisconnect => '中斷連線';

  @override
  String get mcpRefreshTools => '重新整理工具';

  @override
  String get mcpReconnect => '重新連線';

  @override
  String get mcpConnect => '連線';

  @override
  String get mcpEditServer => '編輯 MCP 伺服器';

  @override
  String get mcpRemoveServer => '移除 MCP 伺服器';

  @override
  String get mcpNoToolsDiscovered => '未發現工具';

  @override
  String get mcpRemoveServerQuestion => '移除 MCP 伺服器？';

  @override
  String get mcpRemove => '移除';

  @override
  String get mcpToolPermission => '工具權限';

  @override
  String get mcpAskEveryTime => '每次詢問';

  @override
  String get mcpAlwaysAllow => '一律允許';

  @override
  String get mcpDenied => '已拒絕';

  @override
  String get mcpNoActivity => '尚無 MCP 活動';

  @override
  String get mcpEndpoint => 'MCP 端點';

  @override
  String get mcpTransport => '傳輸方式';

  @override
  String get mcpBearerToken => 'Bearer Token';

  @override
  String get mcpShowToken => '顯示 Token';

  @override
  String get mcpHideToken => '隱藏 Token';

  @override
  String get mcpRemoveStoredToken => '移除已儲存的 Token';

  @override
  String get mcpAllowInsecureHttp => '允許不安全的 HTTP';

  @override
  String get mcpServerEnabled => '啟用伺服器';

  @override
  String get mcpDisconnected => '已中斷';

  @override
  String get mcpConnecting => '連線中';

  @override
  String get mcpConnected => '已連線';

  @override
  String get mcpReconnecting => '重新連線中';

  @override
  String get mcpReadOnlyHint => '唯讀提示';

  @override
  String get mcpWriteCapable => '可寫入';

  @override
  String get mcpExternalSideEffect => '會產生外部影響';

  @override
  String get capabilityCheckFailed => '功能檢查失敗';

  @override
  String get capabilityRecentExternalActivity => '最近的外部活動';

  @override
  String get capabilityAuditUnavailable => '稽核歷程無法使用';

  @override
  String get capabilityNoExternalCalls => '沒有外部呼叫記錄';

  @override
  String capabilityReadyCount(int ready, int total) {
    return '$total 項中有 $ready 項就緒';
  }

  @override
  String get capabilityOpenSettings => '開啟設定';

  @override
  String get capabilityRequestPermission => '要求權限';

  @override
  String get capabilityCurrentAi => '目前的 AI';

  @override
  String get capabilitySystemSpeech => '系統語音';

  @override
  String get capabilityVoiceInput => '語音輸入';

  @override
  String get capabilitySemanticSearch => '語意搜尋';

  @override
  String get capabilityMcpTools => 'MCP 工具';

  @override
  String get capabilityChatGenerationConnection => '聊天生成連線';

  @override
  String get capabilityDeviceTts => '裝置文字轉語音';

  @override
  String get capabilityDeviceSpeechRecognition => '裝置語音辨識';

  @override
  String get capabilityOptionalEmbeddingConnection => '選用的嵌入模型連線';

  @override
  String get capabilityOptionalImageConnection => '選用的圖像連線';

  @override
  String get capabilityExternalToolServers => '外部工具伺服器';

  @override
  String get capabilityBundledCharacterRendering => '內建角色渲染';

  @override
  String get capabilityCompleteAiConnection => '請完成目前的 AI 連線設定';

  @override
  String get capabilityCompleteEmbeddingConnection => '請完成嵌入模型連線設定';

  @override
  String get capabilityCompleteImageConnection => '請完成圖像連線設定';

  @override
  String get capabilityConfigurationRequired => '需要設定';

  @override
  String get capabilityConfigured => '已設定';

  @override
  String get capabilityAvailable => '可用';

  @override
  String get capabilityPermissionRequired => '需要權限';

  @override
  String get capabilityPermissionDenied => '權限遭拒';

  @override
  String get capabilityDownloadRequired => '需要下載';

  @override
  String get capabilityUnavailableOffline => '離線時無法使用';

  @override
  String get capabilityUnavailableBuild => '此版本無法使用';

  @override
  String get capabilityDataMetadata => '中繼資料';

  @override
  String get capabilityDataPrompt => '提示詞';

  @override
  String get capabilityDataChatText => '聊天文字';

  @override
  String get capabilityDataDocumentText => '文件文字';

  @override
  String get capabilityDataImage => '圖像';

  @override
  String get capabilityDataAudio => '音訊';

  @override
  String get capabilityDataCharacterCard => '角色卡';

  @override
  String get capabilityDataToolArguments => '工具參數';

  @override
  String dataBankCitationSourcesCount(int count) {
    return '$count 個資料庫來源';
  }

  @override
  String get dataBankCitationSources => '資料庫來源';

  @override
  String dataBankLocalQueriesFused(int count) {
    return '已合併 $count 個本機查詢';
  }

  @override
  String get memoryUsed => '已使用的記憶';

  @override
  String memoryTokenUsage(int used, int allocated) {
    return '$used/$allocated Token';
  }

  @override
  String memoryRelevancePercent(int percent) {
    return '相關性 $percent%';
  }

  @override
  String get memoryModeLocalFts => '本機全文搜尋';

  @override
  String get memoryModeHybrid => '混合檢索';

  @override
  String get memoryModeLocalFallback => '本機全文搜尋備援';

  @override
  String get memoryIncluded => '已納入';

  @override
  String get memoryTrimmed => '已裁剪';

  @override
  String get memoryExcluded => '已排除';

  @override
  String rpgTurnNumber(int turn) {
    return '第 $turn 回合';
  }

  @override
  String get rpgDisableMode => '關閉 RPG 模式';

  @override
  String get rpgStatus => '狀態';

  @override
  String get rpgInventory => '物品欄';

  @override
  String get rpgQuests => '任務';

  @override
  String get rpgRelations => '關係';

  @override
  String get rpgActions => '行動';

  @override
  String get rpgLog => '日誌';

  @override
  String get rpgLocation => '地點';

  @override
  String get rpgTime => '時間';

  @override
  String rpgDayTime(int day, String time) {
    return '第 $day 天，$time';
  }

  @override
  String get rpgInventoryEmpty => '物品欄為空';

  @override
  String get rpgNoQuests => '尚無任務';

  @override
  String get rpgNoRelationships => '尚無關係';

  @override
  String get rpgNoActions => '未定義行動';

  @override
  String rpgCost(String cost) {
    return '消耗：$cost';
  }

  @override
  String rpgCheck(String dice, String attribute, num difficulty) {
    return '檢定：$dice + $attribute 對抗 $difficulty';
  }

  @override
  String rpgCooldown(int turns) {
    return '冷卻：$turns 回合';
  }

  @override
  String get rpgRequirementsNotMet => '不符合要求或資源不足';

  @override
  String get rpgNoTurnsRecorded => '尚無回合記錄';

  @override
  String get rpgSnapshots => '快照';

  @override
  String get rpgSnapshotActions => '快照操作';

  @override
  String get rpgRestoreSnapshot => '還原快照';

  @override
  String get rpgForkNewBranch => '建立新分支';

  @override
  String get rpgRuleEngineSource => '來源：規則引擎';

  @override
  String rpgRoll(String total, String expression) {
    return '擲骰：$total（$expression）';
  }

  @override
  String rpgChanges(String changes) {
    return '變更：$changes';
  }

  @override
  String get rpgForkBranch => '建立分支';

  @override
  String get rpgBranchId => '分支 ID';

  @override
  String get rpgFork => '建立';

  @override
  String get rpgQuestInactive => '未啟用';

  @override
  String get rpgQuestActive => '進行中';

  @override
  String get rpgQuestCompleted => '已完成';

  @override
  String get rpgQuestFailed => '失敗';

  @override
  String get rpgEnableMode => '開啟 RPG 模式';

  @override
  String get noImageGenerated => '未產生圖片';

  @override
  String failedToSaveImage(String error) {
    return '儲存圖片失敗：$error';
  }

  @override
  String imagesAdded(int count) {
    return '已加入 $count 張圖片';
  }

  @override
  String get addConnection => '加入關聯';

  @override
  String get group => '群組';

  @override
  String get lockType => '鎖定類型';

  @override
  String errorLoadingCharacters(String error) {
    return '載入角色失敗：$error';
  }

  @override
  String errorLoadingGroups(String error) {
    return '載入群組失敗：$error';
  }

  @override
  String get inSystemPrompt => '系統提示詞中';

  @override
  String get connectingGoogleDrive => '正在連線至 Google 雲端硬碟...';

  @override
  String get checkingICloud => '正在檢查 iCloud...';

  @override
  String get whatIsPromptManager => '什麼是提示詞管理器？';

  @override
  String get promptManagerHelpDescription =>
      '提示詞管理器控制訊息傳送給 AI 前系統提示詞的組合方式。你可以調整各部分的順序，並啟用或停用它們。';

  @override
  String get promptSectionTypes => '提示詞部分類型';

  @override
  String get promptSectionTypesDescription =>
      '提示詞可包含系統指令、使用者設定、角色資訊、場景、世界書上下文、範例訊息、作者註記、聊天記錄與歷史記錄後指令。';

  @override
  String get tips => '提示';

  @override
  String get promptManagerTips =>
      '越靠上的部分優先級越高。停用不需要的部分可節省 Token，也可調整順序以獲得不同效果。';

  @override
  String get customImportedPrompt => '從預設匯入的自訂提示詞';

  @override
  String editPromptSection(String name) {
    return '編輯$name';
  }

  @override
  String get promptName => '提示詞名稱';

  @override
  String identifierLabel(String identifier) {
    return 'ID：$identifier';
  }

  @override
  String roleLabel(String role) {
    return '角色：$role';
  }

  @override
  String supportedPromptMacros(
      String userMacro, String charMacro, String timeMacro, String dateMacro) {
    return '支援 $userMacro、$charMacro、$timeMacro 與 $dateMacro 等巨集。';
  }

  @override
  String get enterPromptContent => '輸入提示詞內容...';

  @override
  String updated(String name) {
    return '已更新$name';
  }

  @override
  String get customPrompt => '自訂提示詞';

  @override
  String get promptSectionSystemPrompt => '系統提示詞';

  @override
  String get promptSectionSystemPromptDescription => '基礎角色扮演指令';

  @override
  String get promptSectionPersona => '使用者設定';

  @override
  String get promptSectionPersonaDescription => '你的使用者設定資訊';

  @override
  String get promptSectionCharacterDescription => '角色描述';

  @override
  String get promptSectionCharacterDescriptionDescription => 'AI 角色的詳細資訊';

  @override
  String get promptSectionCharacterPersonality => '角色個性';

  @override
  String get promptSectionCharacterPersonalityDescription => '角色的個性特徵';

  @override
  String get promptSectionScenario => '場景';

  @override
  String get promptSectionScenarioDescription => '目前情境與背景設定';

  @override
  String get promptSectionExampleMessages => '範例訊息';

  @override
  String get promptSectionExampleMessagesDescription => '用來展示對話風格的範例';

  @override
  String get promptSectionWorldInfoBefore => '前置世界書';

  @override
  String get promptSectionWorldInfoBeforeDescription => '插入在角色資訊之前的世界書上下文';

  @override
  String get promptSectionWorldInfoAfter => '後置世界書';

  @override
  String get promptSectionWorldInfoAfterDescription => '插入在角色資訊之後的世界書上下文';

  @override
  String get promptSectionAuthorNote => '作者註記';

  @override
  String get promptSectionAuthorNoteDescription => '目前聊天使用的動態指令';

  @override
  String get promptSectionPostHistory => '歷史記錄後指令';

  @override
  String get promptSectionPostHistoryDescription => '插入在聊天記錄之後的指令';

  @override
  String get promptSectionNsfw => 'NSFW 提示詞';

  @override
  String get promptSectionNsfwDescription => '可選的成人內容指令';

  @override
  String get promptSectionChatHistory => '聊天記錄';

  @override
  String get promptSectionChatHistoryDescription => '對話中的近期訊息';

  @override
  String get promptSectionEnhanceDefinitions => '強化定義';

  @override
  String get promptSectionEnhanceDefinitionsDescription => '用於強化角色定義的附加指令';

  @override
  String get promptSectionCustomDescription => '自訂提示詞部分';

  @override
  String get reasoning => '推理內容';

  @override
  String get emotionNeutral => '平靜';

  @override
  String get emotionHappy => '開心';

  @override
  String get emotionSad => '悲傷';

  @override
  String get emotionAngry => '生氣';

  @override
  String get emotionSurprised => '驚訝';

  @override
  String get emotionScared => '害怕';

  @override
  String get emotionDisgusted => '厭惡';

  @override
  String get emotionConfused => '困惑';

  @override
  String get emotionEmbarrassed => '尷尬';

  @override
  String get emotionExcited => '興奮';

  @override
  String get emotionLoving => '喜愛';

  @override
  String get emotionThinking => '思考';

  @override
  String get emotionSmug => '得意';

  @override
  String get emotionTired => '疲憊';

  @override
  String get emotionBored => '無聊';

  @override
  String get tokenizerHelpContent =>
      '分詞器用來估算模型可處理的文字量。請選擇與模型相符的分詞器，或使用「最佳匹配」自動選擇。';

  @override
  String get tokenizerNoneEstimate => '無（僅估算）';

  @override
  String get tokenizerBestMatchAuto => '最佳匹配（自動）';

  @override
  String get tokenizerEstimateDescription => '依字元數快速估算 Token';

  @override
  String get tokenizerGpt2Description => '適用於較舊 GPT 風格模型的 GPT-2 分詞器';

  @override
  String get tokenizerOaiDescription =>
      '適用於 GPT 模型的 OAI Compatible tiktoken 分詞器';

  @override
  String get tokenizerLlamaDescription => '適用於 Llama 模型的 SentencePiece 分詞器';

  @override
  String get tokenizerLlama3Description => '適用於 Llama 3 模型的分詞器';

  @override
  String get tokenizerMistralDescription => '適用於 Mistral 模型的分詞器';

  @override
  String get tokenizerClaudeDescription => '適用於 Claude 模型的 Token 估算';

  @override
  String get tokenizerGemmaDescription => '適用於 Gemma 模型的分詞器';

  @override
  String get tokenizerQwenDescription => '適用於 Qwen 模型的分詞器';

  @override
  String get tokenizerDeepSeekDescription => '適用於 DeepSeek 模型的分詞器';

  @override
  String get tokenizerCommandRDescription => '適用於 Command R 模型的分詞器';

  @override
  String get tokenizerNemoDescription => '適用於 Mistral NeMo 模型的分詞器';

  @override
  String get tokenizerBestMatchDescription => '依目前模型自動選擇分詞器';

  @override
  String get showOriginal => '顯示原文';

  @override
  String get showOriginalDescription => '在譯文旁同時顯示原文';

  @override
  String get swapLanguages => '交換語言';

  @override
  String get aboutTranslation => '關於翻譯';

  @override
  String get aboutTranslationDescription => '可自動或按需翻譯訊息，協助你使用不同語言溝通。';

  @override
  String get googleTranslate => 'Google 翻譯';

  @override
  String get googleTranslateDescription =>
      '使用 Google Cloud Translation API，需要 Google Cloud API 金鑰。';

  @override
  String get deepL => 'DeepL';

  @override
  String get deepLDescription => '高品質神經網路機器翻譯，需要 deepl.com 的 API 金鑰。';

  @override
  String get libreTranslate => 'LibreTranslate';

  @override
  String get libreTranslateDescription => '免費開源的翻譯服務，可自行託管或使用公共執行個體。';

  @override
  String get queueMessages => '訊息排隊';

  @override
  String get queueMessagesDescription => '將多則訊息加入佇列，而不中斷目前朗讀';

  @override
  String get loadingVoices => '正在載入語音...';

  @override
  String get failedToLoadVoices => '載入語音失敗';

  @override
  String get ttsTestPhrase => '你好！這是一段文字轉語音系統測試。歡迎使用 NativeTavern。';

  @override
  String get aboutTts => '關於文字轉語音';

  @override
  String get aboutTtsDescription => '文字轉語音可以朗讀訊息。你可以在角色設定中為不同角色設定不同語音。';

  @override
  String get systemTts => '系統文字轉語音';

  @override
  String get systemTtsDetails => '使用裝置內建的文字轉語音引擎，可用語音取決於系統設定。';

  @override
  String get elevenLabsDescription => '高品質 AI 語音，需要 elevenlabs.io 的 API 金鑰。';

  @override
  String get clearGlobalVariables => '清除全域變數';

  @override
  String get clearLocalVariables => '清除區域變數';

  @override
  String get aboutVariables => '關於變數';

  @override
  String get variableSystemDescription => '變數可在全域或目前聊天中儲存可重複使用的值，並透過巨集在提示詞中引用。';

  @override
  String get macroUsage => '巨集用法';

  @override
  String macroUsageDescription(String localMacro, String globalMacro) {
    return '使用 $localMacro 引用區域變數，使用 $globalMacro 引用全域變數。也可透過變數巨集設定值。';
  }

  @override
  String get noGlobalVariables => '尚無全域變數';

  @override
  String get noLocalVariables => '尚無區域變數';

  @override
  String editVariable(String name) {
    return '編輯變數「$name」';
  }

  @override
  String get deleteVariable => '刪除變數';

  @override
  String deleteVariableQuestion(String name) {
    return '確定要刪除變數「$name」嗎？';
  }

  @override
  String clearVariables(String scope) {
    return '清除$scope變數';
  }

  @override
  String clearVariablesConfirmation(String scope) {
    return '確定要清除所有$scope變數嗎？此操作無法復原。';
  }

  @override
  String get decrement => '減少';

  @override
  String get increment => '增加';

  @override
  String get testInput => '測試輸入';

  @override
  String get variableTestHint => '輸入包含變數巨集的文字...';

  @override
  String get processMacros => '處理巨集';

  @override
  String get result => '結果';

  @override
  String get emptyString => '（空字串）';

  @override
  String get retrievalAugmentedGeneration => '檢索增強生成（RAG）';

  @override
  String get searchSettings => '搜尋設定';

  @override
  String topKResultsDescription(int count) {
    return '最多傳回 $count 筆符合結果';
  }

  @override
  String minimumPercent(String percent) {
    return '最低相似度：$percent%';
  }

  @override
  String get promptIntegration => '提示詞整合';

  @override
  String get includeInPrompt => '加入提示詞';

  @override
  String get automaticallyAddContext => '自動將相關上下文加入提示詞';

  @override
  String get promptTemplate => '提示詞範本';

  @override
  String useContextPlaceholder(String contextMacro) {
    return '使用 $contextMacro 指定檢索內容的插入位置';
  }

  @override
  String get vectorStorageHelp => '向量儲存說明';

  @override
  String get vectorStorageHelpContent =>
      '向量儲存會將文件轉換為嵌入向量，並為每則訊息檢索相關段落。請設定嵌入服務、建立集合、加入文件並啟用提示詞整合。';

  @override
  String get enterCollectionName => '輸入集合名稱';

  @override
  String get deleteCollection => '刪除集合';

  @override
  String get deleteCollectionConfirmation => '確定要刪除此集合及其中的所有文件嗎？';

  @override
  String get collectionExported => '集合已匯出';

  @override
  String get importCollection => '匯入集合';

  @override
  String get pasteCollectionJson => '貼上集合 JSON...';

  @override
  String get collectionImported => '集合已匯入';

  @override
  String get activeCollection => '目前集合';

  @override
  String collectionWithDocumentCount(String name, int count) {
    return '$name（$count 份文件）';
  }

  @override
  String documentsCount(int count) {
    return '$count 份文件';
  }

  @override
  String embeddedCount(String percent) {
    return '已嵌入 $percent';
  }

  @override
  String get addDocument => '加入文件';

  @override
  String get viewDocuments => '檢視文件';

  @override
  String get enterDocumentContent => '輸入文件內容';

  @override
  String get documentAdded => '文件已加入';

  @override
  String get noDocuments => '尚無文件';

  @override
  String documentEmbeddingStatus(int characters, String status) {
    return '$characters 個字元 · $status';
  }

  @override
  String get embedded => '已嵌入';

  @override
  String get notEmbedded => '未嵌入';

  @override
  String get tokenProbabilities => 'Token 機率';

  @override
  String get requestTokenProbabilities => '要求 Token 機率';

  @override
  String get requestTokenProbabilitiesDescription => '要求模型傳回生成 Token 的機率資料';

  @override
  String get topCandidatesCount => '候選項數量';

  @override
  String topCandidatesDescription(int count) {
    return '每個 Token 最多顯示 $count 個候選項';
  }

  @override
  String get showLogprobsPanel => '顯示 Token 機率面板';

  @override
  String get showLogprobsPanelDescription => '在支援的訊息下方顯示 Token 機率';

  @override
  String get colorIntensity => '顏色強度';

  @override
  String get aboutTokenProbabilities => '關於 Token 機率';

  @override
  String get tokenProbabilitiesDescription =>
      'Token 機率可顯示模型的信心程度及其考慮過的候選項。是否可用取決於目前 API 與模型。';

  @override
  String get moreFormatting => '更多格式';

  @override
  String get readAloud => '朗讀';

  @override
  String get openInBrowser => '在瀏覽器中開啟';

  @override
  String get imageLoadFailed => '圖片載入失敗';

  @override
  String get pauseReading => '暫停朗讀';

  @override
  String get resumeReading => '繼續朗讀';

  @override
  String get stopReading => '停止朗讀';

  @override
  String get noTagsAvailable => '尚無可用標籤';

  @override
  String rerollAlternativeNotImplemented(String alternative) {
    return '暫不支援使用「$alternative」重新產生';
  }

  @override
  String get enableTokenProbabilitiesHint => '請在設定中啟用 Token 機率以檢視此資料';

  @override
  String get noTokenProbabilities => '尚無 Token 機率資料';

  @override
  String get noAlternativeTokens => '尚無候選 Token';

  @override
  String get alternativeTokens => '候選 Token';

  @override
  String get otherTokens => '其他 Token';

  @override
  String get chooseRpgScenario => '選擇 RPG 劇本';

  @override
  String get importScenario => '匯入劇本';

  @override
  String get noSavedScenarios => '尚無已儲存的劇本';

  @override
  String get rpgImportScenarioPackage => '匯入 RPG 劇本套件';

  @override
  String get rpgSelectedScenarioUnreadable => '無法讀取所選劇本檔案';

  @override
  String get favorite => '收藏';

  @override
  String get connections => '關聯';

  @override
  String get systemPromptOverride => '覆寫系統提示詞';

  @override
  String get systemPromptOverrideHint => '輸入此使用者設定專用的系統提示詞...';

  @override
  String get systemPromptOverrideDescription => '啟用此使用者設定時覆寫預設系統提示詞';

  @override
  String get instructionsAddedAfterHistory => '加入在聊天記錄之後的指令';

  @override
  String get bindPersonaDescription => '綁定使用者設定描述';

  @override
  String get noConnections => '尚無關聯';

  @override
  String connectionCharacter(String id) {
    return '角色：$id';
  }

  @override
  String connectionGroup(String id) {
    return '群組：$id';
  }

  @override
  String connectionChat(String id) {
    return '聊天：$id';
  }

  @override
  String lockLabel(String type) {
    return '鎖定：$type';
  }

  @override
  String get addTag => '加入標籤';

  @override
  String errorLoadingLorebooks(String error) {
    return '載入世界書失敗：$error';
  }

  @override
  String get personaLorebook => '使用者設定世界書';

  @override
  String get selectLorebook => '選擇世界書';

  @override
  String get personaLorebookDescription => '與此使用者設定關聯的世界書';

  @override
  String get descriptionPlacement => '描述插入位置';

  @override
  String get personaDescriptionPositionHelp => '選擇使用者設定描述在提示詞中的插入位置';

  @override
  String get depth => '深度';

  @override
  String get depthInChatHistory => '聊天記錄中的深度';

  @override
  String get messageRole => '訊息角色';

  @override
  String get roleForDescription => '使用者設定描述使用的角色';

  @override
  String get novelAiSettings => 'NovelAI 設定';

  @override
  String get anlasGuard => 'Anlas 保護';

  @override
  String get anlasGuardDescription => '預估 Anlas 消耗過高時阻止產生';

  @override
  String get smea => 'SMEA';

  @override
  String get smeaDescription => '啟用 SMEA 採樣以提升圖片一致性';

  @override
  String get smeaDynamic => '動態 SMEA';

  @override
  String get smeaDynamicDescription => '依圖片尺寸動態調整 SMEA';

  @override
  String get decrisper => '柔化細節';

  @override
  String get decrisperDescription => '減少圖片中過度銳利的細節';

  @override
  String get varietyPlus => 'Variety+';

  @override
  String get varietyPlusDescription => '提高產生圖片之間的差異性';

  @override
  String get gptImageApiDescription => '透過 OAI Compatible 圖片 API 產生圖片';

  @override
  String get oaiCompatibleChat => 'OAI Compatible Chat';

  @override
  String get oaiCompatibleChatDescription => '透過 OAI Compatible 聊天補全端點產生圖片';

  @override
  String get errorFetchingModels => '取得模型失敗';

  @override
  String generatedPrompt(String prompt) {
    return '提示詞：$prompt';
  }

  @override
  String generatedSeed(String seed) {
    return '種子：$seed';
  }

  @override
  String imagesGenerated(int count) {
    return '已產生 $count 張圖片';
  }

  @override
  String get myTheme => '我的主題';

  @override
  String get translate => '翻譯';

  @override
  String get stopSpeaking => '停止朗讀';

  @override
  String get insertion => '插入';

  @override
  String get filters => '篩選條件';

  @override
  String get scanDepth => '掃描深度';

  @override
  String get scanDepthDescription => '掃描最近多少則訊息以比對關鍵字';

  @override
  String get roleForInjectedContent => '注入內容使用的訊息角色';

  @override
  String get caseSensitive => '區分大小寫';

  @override
  String get matchKeywordsExactCase => '依完全一致的大小寫比對關鍵字';

  @override
  String get matchWholeWords => '比對完整單字';

  @override
  String get onlyMatchCompleteWords => '僅比對完整單字';

  @override
  String get recursionControl => '遞迴控制';

  @override
  String get preventRecursion => '阻止遞迴';

  @override
  String get preventRecursionDescription => '不允許此項目觸發其他項目';

  @override
  String get excludeRecursion => '從遞迴中排除';

  @override
  String get excludeRecursionDescription => '遞迴掃描時不啟用此項目';

  @override
  String get delayUntilRecursion => '延遲至遞迴';

  @override
  String get delayUntilRecursionDescription => '僅在遞迴掃描時啟用此項目';

  @override
  String get characterFilter => '角色篩選';

  @override
  String get groupSettings => '群組設定';

  @override
  String get groupMutuallyExclusive => '群組內互斥';

  @override
  String get useGroupScoring => '使用群組評分';

  @override
  String get groupWeight => '群組權重';

  @override
  String get groupWeightDescription => '從群組中選擇項目時使用的相對權重';

  @override
  String get groupOverride => '覆寫群組';

  @override
  String get groupPriority => '群組優先級';

  @override
  String get probability => '機率';

  @override
  String get useProbability => '使用機率';

  @override
  String get randomActivationProbability => '此項目隨機啟用的機率';

  @override
  String probabilityPercent(int percent) {
    return '啟用機率：$percent%';
  }

  @override
  String get timedEffects => '定時效果';

  @override
  String get filterType => '篩選類型';

  @override
  String get characterIds => '角色 ID';

  @override
  String get stickyDuration => '持續時間';

  @override
  String get stickyDurationDescription => '比對後此項目保持啟用的訊息數';

  @override
  String get cooldown => '冷卻';

  @override
  String get cooldownDescription => '此項目再次啟用前需經過的訊息數';

  @override
  String get delay => '延遲';

  @override
  String get delayDescription => '此項目可啟用前需經過的訊息數';

  @override
  String get outlet => '出口';

  @override
  String get include => '包含';

  @override
  String get exclude => '排除';

  @override
  String translatedFromLanguage(String language) {
    return '譯自$language';
  }

  @override
  String originalText(String text) {
    return '原文：$text';
  }

  @override
  String get loadingImage => '正在載入圖片...';

  @override
  String get backupIntervalNever => '從不';

  @override
  String get backupIntervalHourly => '每小時';

  @override
  String get backupIntervalDaily => '每天';

  @override
  String get backupIntervalWeekly => '每週';

  @override
  String get backupIntervalMonthly => '每月';

  @override
  String get restoreModeReplace => '取代';

  @override
  String get restoreModeReplaceDescription => '使用備份資料取代所有本機資料';

  @override
  String get restoreModeMerge => '合併';

  @override
  String get restoreModeMergeDescription => '合併備份與本機資料，發生衝突時以較新資料為準';

  @override
  String get restoreModeAddNewOnly => '僅加入新內容';

  @override
  String get restoreModeAddNewOnlyDescription => '僅加入備份中的新項目，並保留所有現有資料';

  @override
  String get sortNameAscending => '名稱（A-Z）';

  @override
  String get sortNameDescending => '名稱（Z-A）';

  @override
  String get sortNewestFirst => '最新建立優先';

  @override
  String get sortOldestFirst => '最早建立優先';

  @override
  String get sortRecentlyModified => '最近修改優先';

  @override
  String get sortLeastRecentlyModified => '最早修改優先';

  @override
  String get codeBlock => '程式碼區塊';

  @override
  String get quote => '引用';

  @override
  String get heading1 => '一級標題';

  @override
  String get heading2 => '二級標題';

  @override
  String get heading3 => '三級標題';

  @override
  String get bulletList => '項目符號清單';

  @override
  String get numberedList => '編號清單';

  @override
  String get horizontalRule => '分隔線';

  @override
  String get pageNotFound => '找不到頁面';

  @override
  String get goHome => '返回首頁';

  @override
  String get officialWebsite => '官方網站';

  @override
  String get mcpStreamableHttp => '可串流 HTTP';

  @override
  String get mcpLegacyHttpSse => '舊版 HTTP + SSE';

  @override
  String chatWithName(String name) {
    return '與$name聊天';
  }

  @override
  String get noValidCharactersInGroup => '群組中沒有有效角色';

  @override
  String get aiDataSharingTitle => '選擇遠端 AI 如何處理你的資料';

  @override
  String get aiDataSharingIntroduction =>
      'NativeTavern 採用本機優先設計。使用遠端 AI 功能時，本裝置會將必要資料直接傳送給你設定的服務商；NativeTavern 不會轉送或儲存這些請求。';

  @override
  String get aiDataSharingDataTitle => '可能傳送的資料';

  @override
  String get aiDataSharingDataTypes =>
      '- 你的訊息及相關聊天記錄\n- 角色、人物設定和系統指令、世界書、記憶及工具輸入\n- 用於向量嵌入的文件\n- 用於圖片生成的提示詞和圖片\n- 用於語音功能的音訊和文字';

  @override
  String get aiDataSharingRecipientsTitle => '可能接收資料的服務商';

  @override
  String get aiDataSharingRecipients =>
      '依你的設定，接收方可能是：Anthropic、你設定的 OAI Compatible 相容端點、OpenRouter、Google Gemini、DeepSeek、Alibaba Qwen、SiliconFlow、Moonshot/Kimi、Z.AI、MiniMax、Cohere、ElevenLabs、Azure Speech、Volcengine、NovelAI、Pollinations，或你輸入的其他自訂端點。';

  @override
  String get aiDataSharingControlTitle => '由你選擇';

  @override
  String get aiDataSharingControlDescription =>
      '遠端服務商會依其各自的隱私權政策處理資料。API 憑證保留在本裝置上，僅在向所選服務商直接驗證時傳送。你可以隨時在「設定」中變更選擇；本機 AI 端點無需同意即可繼續使用。';

  @override
  String get allowRemoteAi => '允許使用遠端 AI';

  @override
  String get useLocalAiOnly => '僅使用本機 AI';

  @override
  String get aiDataSharingSettingsTitle => '遠端 AI 資料共享';

  @override
  String get aiDataSharingAllowedDescription => '已允許向你設定的服務商和端點傳送資料';

  @override
  String get aiDataSharingLocalOnlyDescription => '已封鎖；本機 AI 端點仍可使用';

  @override
  String get localBackup => '本地與檔案備份';

  @override
  String get localBackupDescription =>
      '將 NativeTavern .ntx 合併備份或 .ntb 資料備份匯出或匯入至裝置儲存空間或檔案管理器';

  @override
  String get exportNtbBackup => '匯出資料備份 (.ntb)';

  @override
  String get exportNtbBackupSubtitle => '僅儲存 JSON 資料；媒體另外儲存為 .ntm';

  @override
  String get exportNtxBackup => '匯出合併備份 (.ntx)';

  @override
  String get exportNtxBackupSubtitle => '將應用程式資料與媒體一併儲存到單一 .ntx 檔案';

  @override
  String get importNtbBackup => '匯入備份檔案 (.ntb)';

  @override
  String get importNtbBackupSubtitle => '從本機 .ntb 檔案還原或合併資料';

  @override
  String get importNtxBackup => '匯入備份 (.ntx / .ntb)';

  @override
  String get importNtxBackupSubtitle => '從合併的 .ntx 檔案或 .ntb 資料備份還原或合併資料';

  @override
  String get exportToFiles => '儲存到檔案';

  @override
  String get shareBackup => '分享備份';

  @override
  String get exportOptions => '匯出選項';

  @override
  String get selectNtbFile => '選擇 NativeTavern 備份 (.ntb)';

  @override
  String get selectNtbFileDescription => '選擇 .ntb 備份檔案及可選的 .ntm 媒體檔案';

  @override
  String get selectNtxFile => '選擇 NativeTavern 備份';

  @override
  String get selectNtxFileDescription => '選擇 .ntx 合併備份，或含可選 .ntm 媒體的 .ntb 檔案';

  @override
  String get backupSavedToFilesApp => '備份已儲存到檔案';

  @override
  String get backupSavedToAppFolder =>
      '無法儲存到檔案 App。備份已儲存到 NativeTavern/Backups。';

  @override
  String get savedToFilesApp => '已儲存到檔案';

  @override
  String get importBackupExplanation => '從此備份檔案中還原或合併角色、聊天、設定及媒體檔案。';

  @override
  String get restoringBackup => '正在還原備份...';

  @override
  String get exportingBackup => '正在匯出備份...';
}
