import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/models/vector_storage.dart';
import 'package:native_tavern/domain/services/image_generation_service.dart';
import 'package:native_tavern/domain/services/stt_service.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/l10n/generated/app_localizations_en.dart';
import 'package:native_tavern/l10n/generated/app_localizations_zh.dart';

void main() {
  test('uses OAI Compatible for user-facing provider names', () {
    final l10n = AppLocalizationsEn();

    expect(l10n.openai, 'OAI Compatible');
    expect(l10n.lmStudio, 'LM Studio');
    expect(l10n.xaiApiKeyHint, 'xai-...');
    expect(l10n.aboutRestoreModesDescription, isNot(contains(r'\n')));
    expect(l10n.aboutRestoreModesDescription.split('\n'), hasLength(3));
    expect(l10n.instructTemplateDescription, isNot(contains('OpenAI')));
    expect(l10n.dalleDescription, isNot(contains('OpenAI')));
    expect(l10n.whisperDescription, isNot(contains('OpenAI')));
    expect(STTProvider.openAICompatible.displayName, 'OAI Compatible');
    expect(TTSProvider.openaiCompatible.displayName, 'OAI Compatible');
    expect(ImageGenProvider.openai.displayName, 'OAI Compatible');
    expect(ImageGenProvider.openaiChat.displayName, 'OAI Compatible Chat');
    expect(EmbeddingProvider.openai.displayName, 'OAI Compatible');
    expect(
      EmbeddingProvider.custom.displayName,
      'Custom API (OAI Compatible)',
    );
  });

  test('provides Chinese translations for recently added features', () {
    final l10n = AppLocalizationsZh();

    expect(l10n.memoryInbox, '记忆收件箱');
    expect(l10n.playHub, '玩法');
    expect(l10n.story, '故事');
    expect(l10n.storyEmptyHint, '聊一段时间才会有故事。');
    expect(l10n.storyGoToChat, '去聊天');
    expect(l10n.storyJotNote, '记一笔');
    expect(l10n.imagine, '生图');
    expect(l10n.fillImagePromptWithAi, 'AI 填写提示词');
    expect(l10n.moments, '动态');
    expect(l10n.momentsEmpty, '还没人发过。');
    expect(l10n.momentsEnabledSubtitle, '关闭后动态不再更新，角色也不会再发。');
    expect(l10n.momentsInChat, '本聊天带入动态');
    expect(l10n.momentsInChatHint, '默认关闭。打开后，这个角色才会知道好友和你的动态。');
    expect(l10n.momentsCompose, '发表');
    expect(l10n.momentsRefreshing, '大家正在发动态…');
    expect(l10n.momentsComment, '评论');
    expect(l10n.momentsAuthorMe, '我');
    expect(l10n.openDataBank, '打开资料');
    expect(l10n.worldInfo, '世界书');
    expect(l10n.worldInfoLorebooks, '世界书');
    expect(l10n.dataBank, '资料库');
    expect(l10n.rpgScenarioEditor, 'RPG 剧本编辑器');
    expect(l10n.capabilityCheck, '功能检查');
    expect(l10n.mcpServers, 'MCP 服务器');
    expect(l10n.storageManagement, '存储管理');
    expect(l10n.live2dModelsCount(2), '2 个模型');
  });

  test('localizes audited child surfaces in simplified Chinese', () {
    final l10n = AppLocalizationsZh();

    expect(l10n.appStatistics, '应用统计');
    expect(l10n.tokenizerHelpContent, contains('分词器'));
    expect(l10n.expressionSprites, '表情立绘');
    expect(l10n.vectorStorageRag, '向量存储（RAG）');
    expect(l10n.variableSystem, '变量系统');
    expect(l10n.promptManagerHelp, '提示词管理器帮助');
    expect(l10n.regexScripts, '正则脚本');
    expect(l10n.aboutTts, '关于文本转语音');
    expect(l10n.aboutTranslation, '关于翻译');
    expect(l10n.novelAiSettings, 'NovelAI 设置');
    expect(l10n.insertion, '插入');
    expect(l10n.connections, '关联');
    expect(l10n.tokenProbabilities, 'Token 概率');
    expect(l10n.chatPreview, '聊天预览');
    expect(l10n.translatedFromLanguage('日语'), '译自日语');
    expect(l10n.loadingImage, '正在加载图片...');
    expect(l10n.aboutRestoreModesDescription, isNot(contains(r'\n')));
    expect(l10n.aboutRestoreModesDescription, contains('\n'));
    expect(l10n.lmStudio, 'LM Studio');
    expect(l10n.restoreModeMerge, '合并');
    expect(l10n.backupStageScanningMedia, '正在扫描媒体文件...');
    expect(l10n.backupStageRestoringMedia(2, 5), '正在恢复媒体：2/5 个文件');
    expect(l10n.sortRecentlyModified, '最近修改优先');
    expect(l10n.pageNotFound, '页面未找到');
    expect(l10n.officialWebsite, '官方网站');
    expect(l10n.mcpStreamableHttp, '可流式传输 HTTP');
    expect(l10n.chatWithName('小酒馆'), '与小酒馆聊天');
    expect(
      l10n.supportedPromptMacros(
        '{{user}}',
        '{{char}}',
        '{{time}}',
        '{{date}}',
      ),
      contains('{{user}}'),
    );
  });

  test('localizes audited child surfaces in traditional Chinese', () {
    final l10n = AppLocalizationsZhTw();

    expect(l10n.appStatistics, '應用程式統計');
    expect(l10n.tokenizerHelpContent, contains('分詞器'));
    expect(l10n.expressionSprites, '表情立繪');
    expect(l10n.vectorStorageRag, '向量儲存（RAG）');
    expect(l10n.variableSystem, '變數系統');
    expect(l10n.promptManagerHelp, '提示詞管理器說明');
    expect(l10n.regexScripts, '正規表示式指令碼');
    expect(l10n.aboutTts, '關於文字轉語音');
    expect(l10n.aboutTranslation, '關於翻譯');
    expect(l10n.novelAiSettings, 'NovelAI 設定');
    expect(l10n.insertion, '插入');
    expect(l10n.connections, '關聯');
    expect(l10n.tokenProbabilities, 'Token 機率');
    expect(l10n.chatPreview, '聊天預覽');
    expect(l10n.translatedFromLanguage('日文'), '譯自日文');
    expect(l10n.loadingImage, '正在載入圖片...');
    expect(l10n.aboutRestoreModesDescription, isNot(contains(r'\n')));
    expect(l10n.aboutRestoreModesDescription, contains('\n'));
    expect(l10n.lmStudio, 'LM Studio');
    expect(l10n.restoreModeMerge, '合併');
    expect(l10n.backupStageScanningMedia, '正在掃描媒體檔案...');
    expect(l10n.backupStageRestoringMedia(2, 5), '正在還原媒體：2/5 個檔案');
    expect(l10n.sortRecentlyModified, '最近修改優先');
    expect(l10n.pageNotFound, '找不到頁面');
    expect(l10n.officialWebsite, '官方網站');
    expect(l10n.mcpStreamableHttp, '可串流 HTTP');
    expect(l10n.chatWithName('小酒館'), '與小酒館聊天');
  });

  test('Chinese localizations do not mention xAI', () {
    final locales = <AppLocalizations>[
      AppLocalizationsZh(),
      AppLocalizationsZhTw(),
    ];
    for (final l10n in locales) {
      expect(l10n.xai.toLowerCase(), isNot(contains('xai')));
      expect(l10n.xai.toLowerCase(), isNot(contains('grok')));
      expect(l10n.xaiApiKeyHint.toLowerCase(), isNot(contains('xai')));
      expect(l10n.xaiApiKeyHint.toLowerCase(), isNot(contains('grok')));
      expect(
          l10n.aiDataSharingRecipients.toLowerCase(), isNot(contains('xai')));
      expect(
        l10n.aiDataSharingRecipients.toLowerCase(),
        isNot(contains('grok')),
      );
    }
  });
}
