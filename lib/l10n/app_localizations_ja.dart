// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'ホーム';

  @override
  String get characters => 'キャラクター';

  @override
  String get settings => '設定';

  @override
  String get chats => 'チャット';

  @override
  String get newChat => '新規チャット';

  @override
  String get noChatsYet => 'チャットはまだありません';

  @override
  String get startNewConversation => 'キャラクターとの会話を始めましょう';

  @override
  String get browseCharacters => 'キャラクターを閲覧';

  @override
  String get groupChats => 'グループチャット';

  @override
  String get import => 'インポート';

  @override
  String get delete => '削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get copy => 'コピー';

  @override
  String get retry => '再試行';

  @override
  String get close => '閉じる';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String errorLoadingChats(String error) {
    return 'チャットの読み込みに失敗しました：$error';
  }

  @override
  String get deleteChat => 'チャットを削除';

  @override
  String get deleteChatConfirmation => 'このチャットを削除してもよろしいですか？この操作は取り消せません。';

  @override
  String get chatDeleted => 'チャットを削除しました';

  @override
  String get yesterday => '昨日';

  @override
  String daysAgo(int count) {
    return '$count日前';
  }

  @override
  String get noMessages => 'メッセージはありません';

  @override
  String get noMessagesYet => 'メッセージはまだありません';

  @override
  String get chat => 'チャット';

  @override
  String get typeMessage => 'メッセージを入力...';

  @override
  String get send => '送信';

  @override
  String get regenerate => '再生成';

  @override
  String get continueGeneration => '続ける';

  @override
  String get viewCharacter => 'キャラクターを表示';

  @override
  String get authorsNote => '作者メモ';

  @override
  String get bookmarks => 'ブックマーク';

  @override
  String get exportChat => 'チャットをエクスポート';

  @override
  String get importChat => 'チャットをインポート';

  @override
  String get clearMessages => 'メッセージをクリア';

  @override
  String get selectModel => 'モデルを選択';

  @override
  String get loadingModels => 'モデルを読み込み中...';

  @override
  String get noModelsAvailable => '利用可能なモデルがありません。API設定を確認してください。';

  @override
  String modelChangedTo(String model) {
    return 'モデルを $model に変更しました';
  }

  @override
  String failedToLoadModels(String error) {
    return 'モデルの読み込みに失敗しました：$error';
  }

  @override
  String get searchModels => 'モデルを検索...';

  @override
  String get noModelsMatchSearch => '一致するモデルがありません';

  @override
  String get provider => 'プロバイダー';

  @override
  String get apiNotConfigured => 'APIが設定されていません';

  @override
  String get apiNotConfiguredMessage =>
      'キャラクターとチャットするには、まずLLMプロバイダーを設定する必要があります。';

  @override
  String get supportedProviders => '対応プロバイダー：';

  @override
  String get configureNow => '今すぐ設定';

  @override
  String get later => '後で';

  @override
  String get configure => '設定';

  @override
  String get configureApiProvider => 'LLMプロバイダーを設定してチャットを開始';

  @override
  String get startConversation => '会話を始める';

  @override
  String get deleteMessage => 'メッセージを削除';

  @override
  String get deleteMessageConfirmation => 'このメッセージを削除してもよろしいですか？';

  @override
  String get deleteMessages => 'メッセージを削除';

  @override
  String get deleteMessagesConfirmation =>
      'このメッセージとそれ以降のすべてのメッセージを削除してもよろしいですか？';

  @override
  String get deleteAll => 'すべて削除';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get generateNewResponse => '新しい応答を生成';

  @override
  String get continueFromHere => 'ここから続ける';

  @override
  String get deleteMessagesAfterAndRegenerate => '以降のメッセージを削除して応答を再生成';

  @override
  String get deleteMessagesAfterThis => 'このメッセージ以降をすべて削除';

  @override
  String get createBookmark => 'ブックマークを作成';

  @override
  String get saveAsCheckpoint => 'この地点をチェックポイントとして保存';

  @override
  String get deleteThisMessage => 'このメッセージを削除';

  @override
  String get deleteThisAndAllAfter => 'これ以降をすべて削除';

  @override
  String get attachImage => '画像を添付';

  @override
  String get chooseFromGallery => 'ギャラリーから選択';

  @override
  String get takePhoto => '写真を撮る';

  @override
  String failedToPickImage(String error) {
    return '画像の選択に失敗しました：$error';
  }

  @override
  String failedToTakePhoto(String error) {
    return '写真の撮影に失敗しました：$error';
  }

  @override
  String failedToAddAttachment(String error) {
    return '添付ファイルの追加に失敗しました：$error';
  }

  @override
  String exportChatWith(String character) {
    return '$character とのチャットをエクスポート';
  }

  @override
  String messagesCount(int count) {
    return '$count 件のメッセージ';
  }

  @override
  String get chooseExportFormat => 'エクスポート形式を選択：';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST形式)';

  @override
  String get noChatToExport => 'エクスポートするチャットがありません';

  @override
  String exportFailed(String error) {
    return 'エクスポートに失敗しました：$error';
  }

  @override
  String get importChatHistory => 'ファイルからチャット履歴をインポートします。';

  @override
  String get supportedFormats => '対応形式：';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern形式)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern形式)';

  @override
  String get importNote => '注意：インポートされたメッセージは現在のチャットに追加されます。';

  @override
  String get chooseFile => 'ファイルを選択';

  @override
  String get noFileSelected => 'ファイルが選択されていないか、形式が無効です';

  @override
  String get importConfirmation => 'インポートの確認';

  @override
  String get character => 'キャラクター';

  @override
  String get user => 'ユーザー';

  @override
  String get messages => 'メッセージ';

  @override
  String get date => '日付';

  @override
  String get hasAuthorsNote => '作者メモあり';

  @override
  String get importMessagesToCurrentChat => 'これらのメッセージを現在のチャットにインポートしますか？';

  @override
  String get noActiveChat => 'アクティブなチャットがありません';

  @override
  String importedMessages(int count) {
    return '$count 件のメッセージをインポートしました';
  }

  @override
  String importFailed(String error) {
    return 'インポートに失敗しました：$error';
  }

  @override
  String get clearMessagesConfirmation =>
      'すべてのメッセージをクリアしてもよろしいですか？この操作は取り消せません。';

  @override
  String get clear => 'クリア';

  @override
  String get thinking => '思考中';

  @override
  String get noSwipesAvailable => 'スワイプがありません';

  @override
  String get system => 'システム';

  @override
  String get backgroundFeatureComingSoon => '背景機能は近日公開予定';

  @override
  String get authorsNoteUpdated => '作者メモを更新しました';

  @override
  String get commandError => 'コマンドエラー';

  @override
  String get enabled => '有効';

  @override
  String get disabled => '無効';

  @override
  String get personas => 'ペルソナ';

  @override
  String get createPersona => 'ペルソナを作成';

  @override
  String get editPersona => 'ペルソナを編集';

  @override
  String get deletePersona => 'ペルソナを削除';

  @override
  String deletePersonaConfirmation(String name) {
    return '\"$name\"を削除してもよろしいですか？';
  }

  @override
  String get noPersonasYet => 'ペルソナはまだありません';

  @override
  String get createPersonaDescription => 'チャットで自分を表すペルソナを作成';

  @override
  String get name => '名前';

  @override
  String get enterPersonaName => 'ペルソナ名を入力';

  @override
  String get description => '説明';

  @override
  String get describePersona => 'このペルソナを説明（任意）';

  @override
  String get personaDescriptionHelp => '説明はシステムプロンプトに含まれ、AIがあなたを理解するのに役立ちます。';

  @override
  String get pleaseEnterName => '名前を入力してください';

  @override
  String get default_ => 'デフォルト';

  @override
  String get active => 'アクティブ';

  @override
  String get setAsDefault => 'デフォルトに設定';

  @override
  String get removeAvatar => 'アバターを削除';

  @override
  String failedToSaveAvatar(String error) {
    return 'アバターの保存に失敗しました：$error';
  }

  @override
  String get selectAvatarImage => 'アバター画像を選択';

  @override
  String get aiConfiguration => 'AI設定';

  @override
  String get llmProvider => 'LLMプロバイダー';

  @override
  String get apiUrl => 'API URL';

  @override
  String get apiKey => 'APIキー';

  @override
  String get model => 'モデル';

  @override
  String get temperature => '温度';

  @override
  String get maxTokens => '最大トークン数';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => '頻度ペナルティ';

  @override
  String get presencePenalty => '存在ペナルティ';

  @override
  String get repetitionPenalty => '繰り返しペナルティ';

  @override
  String get streamingEnabled => 'ストリーミングを有効化';

  @override
  String get testConnection => '接続テスト';

  @override
  String get connectionSuccessful => '接続成功！';

  @override
  String connectionFailed(String error) {
    return '接続に失敗しました：$error';
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
  String get local => 'ローカル';

  @override
  String get aiPresets => 'AIプリセット';

  @override
  String get createPreset => 'プリセットを作成';

  @override
  String get editPreset => 'プリセットを編集';

  @override
  String get deletePreset => 'プリセットを削除';

  @override
  String get presetName => 'プリセット名';

  @override
  String get promptManager => 'プロンプト管理';

  @override
  String get systemPrompt => 'システムプロンプト';

  @override
  String get jailbreak => 'ジェイルブレイク';

  @override
  String get worldInfo => 'ワールド情報';

  @override
  String get createEntry => 'エントリを作成';

  @override
  String get editEntry => 'エントリを編集';

  @override
  String get deleteEntry => 'エントリを削除';

  @override
  String get keywords => 'キーワード';

  @override
  String get content => 'コンテンツ';

  @override
  String get priority => '優先度';

  @override
  String get groups => 'グループ';

  @override
  String get createGroup => 'グループを作成';

  @override
  String get editGroup => 'グループを編集';

  @override
  String get deleteGroup => 'グループを削除';

  @override
  String get groupName => 'グループ名';

  @override
  String get members => 'メンバー';

  @override
  String get addMember => 'メンバーを追加';

  @override
  String get removeMember => 'メンバーを削除';

  @override
  String get tags => 'タグ';

  @override
  String get createTag => 'タグを作成';

  @override
  String get editTag => 'タグを編集';

  @override
  String get deleteTag => 'タグを削除';

  @override
  String get tagName => 'タグ名';

  @override
  String get color => '色';

  @override
  String get quickReplies => 'クイック返信';

  @override
  String get createQuickReply => 'クイック返信を作成';

  @override
  String get editQuickReply => 'クイック返信を編集';

  @override
  String get deleteQuickReply => 'クイック返信を削除';

  @override
  String get label => 'ラベル';

  @override
  String get message => 'メッセージ';

  @override
  String get autoSend => '自動送信';

  @override
  String get regex => '正規表現';

  @override
  String get createRegex => '正規表現を作成';

  @override
  String get editRegex => '正規表現を編集';

  @override
  String get deleteRegex => '正規表現を削除';

  @override
  String get pattern => 'パターン';

  @override
  String get replacement => '置換';

  @override
  String get backup => 'バックアップ';

  @override
  String get createBackup => 'バックアップを作成';

  @override
  String get restoreBackup => 'バックアップを復元';

  @override
  String get backupCreated => 'バックアップを作成しました';

  @override
  String get backupRestored => 'バックアップを復元しました';

  @override
  String backupFailed(String error) {
    return 'バックアップに失敗しました：$error';
  }

  @override
  String restoreFailed(String error) {
    return '復元に失敗しました：$error';
  }

  @override
  String get theme => 'テーマ';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get lightMode => 'ライトモード';

  @override
  String get systemTheme => 'システムに従う';

  @override
  String get primaryColor => 'プライマリカラー';

  @override
  String get accentColor => 'アクセントカラー';

  @override
  String get advanced => '詳細';

  @override
  String get advancedSettings => '詳細設定';

  @override
  String get statistics => '統計';

  @override
  String get totalChats => '総チャット数';

  @override
  String get totalMessages => '総メッセージ数';

  @override
  String get totalCharacters => '総キャラクター数';

  @override
  String get tokenizer => 'トークナイザー';

  @override
  String get tts => 'テキスト読み上げ';

  @override
  String get stt => '音声認識';

  @override
  String get translation => '翻訳';

  @override
  String get imageGeneration => '画像生成';

  @override
  String get vectorStorage => 'ベクトルストレージ';

  @override
  String get sprites => 'スプライト';

  @override
  String get backgrounds => '背景';

  @override
  String get cfgScale => 'CFGスケール';

  @override
  String get logitBias => 'Logitバイアス';

  @override
  String get variables => '変数';

  @override
  String get listView => 'リスト表示';

  @override
  String get gridView => 'グリッド表示';

  @override
  String get search => '検索';

  @override
  String get searchCharacters => 'キャラクターを検索...';

  @override
  String get noCharactersFound => 'キャラクターが見つかりません';

  @override
  String get noCharactersYet => 'キャラクターはまだありません';

  @override
  String get importCharacter => 'キャラクターをインポートして始めましょう';

  @override
  String get createCharacter => 'キャラクターを作成';

  @override
  String get editCharacter => 'キャラクターを編集';

  @override
  String get deleteCharacter => 'キャラクターを削除';

  @override
  String deleteCharacterConfirmation(String name) {
    return '\"$name\"を削除してもよろしいですか？このキャラクターとのすべてのチャットも削除されます。';
  }

  @override
  String get characterDeleted => 'キャラクターを削除しました';

  @override
  String get startChat => 'チャットを開始';

  @override
  String get personality => '性格';

  @override
  String get scenario => 'シナリオ';

  @override
  String get firstMessage => '最初のメッセージ';

  @override
  String get exampleDialogue => '例文';

  @override
  String get creatorNotes => '作成者メモ';

  @override
  String get alternateGreetings => '代替挨拶';

  @override
  String get characterBook => 'キャラクターブック';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get languageChanged => '言語を変更しました';

  @override
  String get about => 'アプリについて';

  @override
  String get version => 'バージョン';

  @override
  String get licenses => 'ライセンス';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get feedback => 'フィードバック';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get shareApp => 'アプリを共有';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String get noUpdatesAvailable => 'アップデートはありません';

  @override
  String get updateAvailable => 'アップデートがあります';

  @override
  String get downloadUpdate => 'アップデートをダウンロード';

  @override
  String get bookmarkCreated => 'ブックマークを作成しました';

  @override
  String get bookmarkName => 'ブックマーク名';

  @override
  String get enterBookmarkName => 'ブックマーク名を入力';

  @override
  String get noBookmarksYet => 'ブックマークはまだありません';

  @override
  String get createBookmarkDescription => '会話の重要なポイントを保存するブックマークを作成';

  @override
  String get jumpToBookmark => 'ブックマークに移動';

  @override
  String get deleteBookmark => 'ブックマークを削除';

  @override
  String get bookmarkDeleted => 'ブックマークを削除しました';

  @override
  String get saveAsJsonl => 'JSONLとして保存';

  @override
  String get saveAsJson => 'JSONとして保存';

  @override
  String get keyboardShortcuts => 'キーボードショートカット：';

  @override
  String get bold => '太字';

  @override
  String get italic => '斜体';

  @override
  String get underline => '下線';

  @override
  String get strikethrough => '取り消し線';

  @override
  String get inlineCode => 'インラインコード';

  @override
  String get link => 'リンク';

  @override
  String get slashCommands => 'スラッシュコマンド';

  @override
  String get availableCommands => '利用可能なコマンド：';

  @override
  String get commandHelp => '/ を入力して利用可能なコマンドを表示';
}
