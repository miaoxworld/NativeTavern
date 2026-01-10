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
