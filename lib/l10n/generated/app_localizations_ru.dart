// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Главная';

  @override
  String get characters => 'Персонажи';

  @override
  String get settings => 'Настройки';

  @override
  String get chats => 'Чаты';

  @override
  String get newChat => 'Новый чат';

  @override
  String get noChatsYet => 'Пока нет чатов';

  @override
  String get startNewConversation => 'Начните разговор с персонажем';

  @override
  String get browseCharacters => 'Просмотр персонажей';

  @override
  String get groupChats => 'Групповые чаты';

  @override
  String get import => 'Импорт';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get edit => 'Редактировать';

  @override
  String get copy => 'Копировать';

  @override
  String get retry => 'Повторить';

  @override
  String get close => 'Закрыть';

  @override
  String get ok => 'ОК';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String errorLoadingChats(String error) {
    return 'Ошибка загрузки чатов: $error';
  }

  @override
  String get deleteChat => 'Удалить чат';

  @override
  String get deleteChatConfirmation =>
      'Вы уверены, что хотите удалить этот чат? Это действие нельзя отменить.';

  @override
  String get chatDeleted => 'Чат удалён';

  @override
  String get yesterday => 'Вчера';

  @override
  String daysAgo(int count) {
    return '$count дней назад';
  }

  @override
  String get noMessages => 'Нет сообщений';

  @override
  String get noMessagesYet => 'Пока нет сообщений';

  @override
  String get chat => 'Чат';

  @override
  String get typeMessage => 'Введите сообщение...';

  @override
  String get send => 'Отправить';

  @override
  String get regenerate => 'Перегенерировать';

  @override
  String get continueGeneration => 'Продолжить';

  @override
  String get viewCharacter => 'Просмотр персонажа';

  @override
  String get authorsNote => 'Заметка автора';

  @override
  String get bookmarks => 'Закладки';

  @override
  String get exportChat => 'Экспорт чата';

  @override
  String get importChat => 'Импорт чата';

  @override
  String get clearMessages => 'Очистить сообщения';

  @override
  String get selectModel => 'Выбрать модель';

  @override
  String get loadingModels => 'Загрузка моделей...';

  @override
  String get noModelsAvailable =>
      'Нет доступных моделей. Проверьте настройки API.';

  @override
  String modelChangedTo(String model) {
    return 'Модель изменена на $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Не удалось загрузить модели: $error';
  }

  @override
  String get searchModels => 'Поиск моделей...';

  @override
  String get noModelsMatchSearch => 'Модели не найдены';

  @override
  String get provider => 'Провайдер';

  @override
  String get apiNotConfigured => 'API не настроен';

  @override
  String get apiNotConfiguredMessage =>
      'Для общения с персонажами сначала настройте провайдера LLM.';

  @override
  String get supportedProviders => 'Поддерживаемые провайдеры:';

  @override
  String get configureNow => 'Настроить сейчас';

  @override
  String get later => 'Позже';

  @override
  String get configure => 'Настроить';

  @override
  String get configureApiProvider =>
      'Настройте провайдера LLM для начала общения';

  @override
  String get startConversation => 'Начать разговор';

  @override
  String get deleteMessage => 'Удалить сообщение';

  @override
  String get deleteMessageConfirmation =>
      'Вы уверены, что хотите удалить это сообщение?';

  @override
  String get deleteMessages => 'Удалить сообщения';

  @override
  String get deleteMessagesConfirmation =>
      'Вы уверены, что хотите удалить это сообщение и все последующие?';

  @override
  String get deleteAll => 'Удалить всё';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get generateNewResponse => 'Сгенерировать новый ответ';

  @override
  String get continueFromHere => 'Продолжить отсюда';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Удалить последующие сообщения и перегенерировать ответ';

  @override
  String get deleteMessagesAfterThis => 'Удалить все сообщения после этого';

  @override
  String get createBookmark => 'Создать закладку';

  @override
  String get saveAsCheckpoint => 'Сохранить эту точку как контрольную';

  @override
  String get deleteThisMessage => 'Удалить это сообщение';

  @override
  String get deleteThisAndAllAfter => 'Удалить это и все последующие';

  @override
  String get attachImage => 'Прикрепить изображение';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String failedToPickImage(String error) {
    return 'Не удалось выбрать изображение: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Не удалось сделать фото: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Не удалось добавить вложение: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Экспорт чата с $character';
  }

  @override
  String messagesCount(int count) {
    return '$count сообщений';
  }

  @override
  String get chooseExportFormat => 'Выберите формат экспорта:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (формат ST)';

  @override
  String get noChatToExport => 'Нет чата для экспорта';

  @override
  String exportFailed(String error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String get importChatHistory => 'Импорт истории чата из файла.';

  @override
  String get supportedFormats => 'Поддерживаемые форматы:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (формат SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (формат NativeTavern)';

  @override
  String get importNote =>
      'Примечание: Импортированные сообщения будут добавлены в текущий чат.';

  @override
  String get chooseFile => 'Выбрать файл';

  @override
  String get noFileSelected => 'Файл не выбран или неверный формат';

  @override
  String get importConfirmation => 'Подтверждение импорта';

  @override
  String get character => 'Персонаж';

  @override
  String get user => 'Пользователь';

  @override
  String get messages => 'Сообщения';

  @override
  String get date => 'Дата';

  @override
  String get hasAuthorsNote => 'Есть заметка автора';

  @override
  String get importMessagesToCurrentChat =>
      'Импортировать эти сообщения в текущий чат?';

  @override
  String get noActiveChat => 'Нет активного чата';

  @override
  String importedMessages(int count) {
    return 'Импортировано $count сообщений';
  }

  @override
  String importFailed(String error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Вы уверены, что хотите очистить все сообщения? Это действие нельзя отменить.';

  @override
  String get clear => 'Очистить';

  @override
  String get thinking => 'Думает';

  @override
  String get noSwipesAvailable => 'Нет доступных свайпов';

  @override
  String get system => 'Система';

  @override
  String get backgroundFeatureComingSoon => 'Функция фона скоро появится';

  @override
  String get authorsNoteUpdated => 'Заметка автора обновлена';

  @override
  String get commandError => 'Ошибка команды';

  @override
  String get enabled => 'Включено';

  @override
  String get disabled => 'Отключено';

  @override
  String get personas => 'Персоны';

  @override
  String get createPersona => 'Создать персону';

  @override
  String get editPersona => 'Редактировать персону';

  @override
  String get deletePersona => 'Удалить персону';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Вы уверены, что хотите удалить «$name»?';
  }

  @override
  String get noPersonasYet => 'Пока нет персон';

  @override
  String get createPersonaDescription =>
      'Создайте персону, чтобы представлять себя в чатах';

  @override
  String get name => 'Имя';

  @override
  String get enterPersonaName => 'Введите имя персоны';

  @override
  String get description => 'Описание';

  @override
  String get describePersona => 'Опишите эту персону (необязательно)';

  @override
  String get personaDescriptionHelp =>
      'Описание будет включено в системный промпт, чтобы помочь ИИ понять, кто вы.';

  @override
  String get pleaseEnterName => 'Пожалуйста, введите имя';

  @override
  String get default_ => 'По умолчанию';

  @override
  String get active => 'Активный';

  @override
  String get setAsDefault => 'Установить по умолчанию';

  @override
  String get removeAvatar => 'Удалить аватар';

  @override
  String failedToSaveAvatar(String error) {
    return 'Не удалось сохранить аватар: $error';
  }

  @override
  String get selectAvatarImage => 'Выбрать изображение аватара';

  @override
  String get aiConfiguration => 'Настройка ИИ';

  @override
  String get llmProvider => 'Провайдер LLM';

  @override
  String get apiUrl => 'URL API';

  @override
  String get apiKey => 'Ключ API';

  @override
  String get model => 'Модель';

  @override
  String get temperature => 'Температура';

  @override
  String get maxTokens => 'Макс. токенов';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Штраф за частоту';

  @override
  String get presencePenalty => 'Штраф за присутствие';

  @override
  String get repetitionPenalty => 'Штраф за повторение';

  @override
  String get streamingEnabled => 'Потоковая передача включена';

  @override
  String get testConnection => 'Проверить соединение';

  @override
  String get connectionSuccessful => 'Соединение успешно!';

  @override
  String connectionFailed(String error) {
    return 'Ошибка соединения: $error';
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
  String get local => 'Локальный';

  @override
  String get aiPresets => 'Пресеты ИИ';

  @override
  String get createPreset => 'Создать пресет';

  @override
  String get editPreset => 'Редактировать пресет';

  @override
  String get deletePreset => 'Удалить пресет';

  @override
  String get presetName => 'Название пресета';

  @override
  String get promptManager => 'Менеджер промптов';

  @override
  String get systemPrompt => 'Системный промпт';

  @override
  String get jailbreak => 'Джейлбрейк';

  @override
  String get worldInfo => 'Информация о мире';

  @override
  String get createEntry => 'Создать запись';

  @override
  String get editEntry => 'Редактировать запись';

  @override
  String get deleteEntry => 'Удалить запись';

  @override
  String get keywords => 'Ключевые слова';

  @override
  String get content => 'Содержимое';

  @override
  String get priority => 'Приоритет';

  @override
  String get groups => 'Группы';

  @override
  String get createGroup => 'Создать группу';

  @override
  String get editGroup => 'Редактировать группу';

  @override
  String get deleteGroup => 'Удалить группу';

  @override
  String get groupName => 'Название группы';

  @override
  String get members => 'Участники';

  @override
  String get addMember => 'Добавить участника';

  @override
  String get removeMember => 'Удалить участника';

  @override
  String get tags => 'Теги';

  @override
  String get createTag => 'Создать тег';

  @override
  String get editTag => 'Редактировать тег';

  @override
  String get deleteTag => 'Удалить тег';

  @override
  String get tagName => 'Название тега';

  @override
  String get color => 'Цвет';

  @override
  String get quickReplies => 'Быстрые ответы';

  @override
  String get createQuickReply => 'Создать быстрый ответ';

  @override
  String get editQuickReply => 'Редактировать быстрый ответ';

  @override
  String get deleteQuickReply => 'Удалить быстрый ответ';

  @override
  String get label => 'Метка';

  @override
  String get message => 'Сообщение';

  @override
  String get autoSend => 'Автоотправка';

  @override
  String get regex => 'Регулярные выражения';

  @override
  String get createRegex => 'Создать regex';

  @override
  String get editRegex => 'Редактировать regex';

  @override
  String get deleteRegex => 'Удалить regex';

  @override
  String get pattern => 'Шаблон';

  @override
  String get replacement => 'Замена';

  @override
  String get backup => 'Резервное копирование';

  @override
  String get createBackup => 'Создать резервную копию';

  @override
  String get restoreBackup => 'Восстановить резервную копию';

  @override
  String get backupCreated => 'Резервная копия создана';

  @override
  String get backupRestored => 'Резервная копия восстановлена';

  @override
  String backupFailed(String error) {
    return 'Ошибка резервного копирования: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Ошибка восстановления: $error';
  }

  @override
  String get theme => 'Тема';

  @override
  String get darkMode => 'Тёмный режим';

  @override
  String get lightMode => 'Светлый режим';

  @override
  String get systemTheme => 'Системная тема';

  @override
  String get primaryColor => 'Основной цвет';

  @override
  String get accentColor => 'Акцентный цвет';

  @override
  String get advanced => 'Дополнительно';

  @override
  String get advancedSettings => 'Дополнительные настройки';

  @override
  String get statistics => 'Статистика';

  @override
  String get totalChats => 'Всего чатов';

  @override
  String get totalMessages => 'Всего сообщений';

  @override
  String get totalCharacters => 'Всего персонажей';

  @override
  String get tokenizer => 'Токенизатор';

  @override
  String get tts => 'Текст в речь';

  @override
  String get stt => 'Речь в текст';

  @override
  String get translation => 'Перевод';

  @override
  String get imageGeneration => 'Генерация изображений';

  @override
  String get vectorStorage => 'Векторное хранилище';

  @override
  String get sprites => 'Спрайты';

  @override
  String get backgrounds => 'Фоны';

  @override
  String get cfgScale => 'Масштаб CFG';

  @override
  String get logitBias => 'Смещение Logit';

  @override
  String get variables => 'Переменные';

  @override
  String get listView => 'Список';

  @override
  String get gridView => 'Сетка';

  @override
  String get search => 'Поиск';

  @override
  String get searchCharacters => 'Поиск персонажей...';

  @override
  String get noCharactersFound => 'Персонажи не найдены';

  @override
  String get noCharactersYet => 'Пока нет персонажей';

  @override
  String get importCharacter => 'Импортируйте персонажа, чтобы начать';

  @override
  String get createCharacter => 'Создать персонажа';

  @override
  String get editCharacter => 'Редактировать персонажа';

  @override
  String get deleteCharacter => 'Удалить персонажа';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Вы уверены, что хотите удалить «$name»? Все чаты с этим персонажем также будут удалены.';
  }

  @override
  String get characterDeleted => 'Персонаж удалён';

  @override
  String get startChat => 'Начать чат';

  @override
  String get personality => 'Личность';

  @override
  String get scenario => 'Сценарий';

  @override
  String get firstMessage => 'Первое сообщение';

  @override
  String get exampleDialogue => 'Пример диалога';

  @override
  String get creatorNotes => 'Заметки создателя';

  @override
  String get alternateGreetings => 'Альтернативные приветствия';

  @override
  String get characterBook => 'Книга персонажа';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get languageChanged => 'Язык изменён';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get licenses => 'Лицензии';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get feedback => 'Обратная связь';

  @override
  String get rateApp => 'Оценить приложение';

  @override
  String get shareApp => 'Поделиться приложением';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get noUpdatesAvailable => 'Нет доступных обновлений';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get downloadUpdate => 'Скачать обновление';

  @override
  String get bookmarkCreated => 'Закладка создана';

  @override
  String get bookmarkName => 'Название закладки';

  @override
  String get enterBookmarkName => 'Введите название закладки';

  @override
  String get noBookmarksYet => 'Пока нет закладок';

  @override
  String get createBookmarkDescription =>
      'Создавайте закладки для сохранения важных моментов в разговоре';

  @override
  String get jumpToBookmark => 'Перейти к закладке';

  @override
  String get deleteBookmark => 'Удалить закладку';

  @override
  String get bookmarkDeleted => 'Закладка удалена';

  @override
  String get saveAsJsonl => 'Сохранить как JSONL';

  @override
  String get saveAsJson => 'Сохранить как JSON';

  @override
  String get keyboardShortcuts => 'Горячие клавиши:';

  @override
  String get bold => 'Жирный';

  @override
  String get italic => 'Курсив';

  @override
  String get underline => 'Подчёркнутый';

  @override
  String get strikethrough => 'Зачёркнутый';

  @override
  String get inlineCode => 'Код';

  @override
  String get link => 'Ссылка';

  @override
  String get slashCommands => 'Слэш-команды';

  @override
  String get availableCommands => 'Доступные команды:';

  @override
  String get commandHelp => 'Введите / для просмотра доступных команд';
}
