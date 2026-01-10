// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'الرئيسية';

  @override
  String get characters => 'الشخصيات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get chats => 'المحادثات';

  @override
  String get newChat => 'محادثة جديدة';

  @override
  String get noChatsYet => 'لا توجد محادثات بعد';

  @override
  String get startNewConversation => 'ابدأ محادثة مع شخصية';

  @override
  String get browseCharacters => 'تصفح الشخصيات';

  @override
  String get groupChats => 'المحادثات الجماعية';

  @override
  String get import => 'استيراد';

  @override
  String get delete => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get copy => 'نسخ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get ok => 'موافق';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String errorLoadingChats(String error) {
    return 'فشل تحميل المحادثات: $error';
  }

  @override
  String get deleteChat => 'حذف المحادثة';

  @override
  String get deleteChatConfirmation =>
      'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get chatDeleted => 'تم حذف المحادثة';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int count) {
    return 'منذ $count أيام';
  }

  @override
  String get noMessages => 'لا توجد رسائل';

  @override
  String get noMessagesYet => 'لا توجد رسائل بعد';

  @override
  String get chat => 'محادثة';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get send => 'إرسال';

  @override
  String get regenerate => 'إعادة التوليد';

  @override
  String get continueGeneration => 'متابعة';

  @override
  String get viewCharacter => 'عرض الشخصية';

  @override
  String get authorsNote => 'ملاحظة المؤلف';

  @override
  String get bookmarks => 'الإشارات المرجعية';

  @override
  String get exportChat => 'تصدير المحادثة';

  @override
  String get importChat => 'استيراد المحادثة';

  @override
  String get clearMessages => 'مسح الرسائل';

  @override
  String get selectModel => 'اختر النموذج';

  @override
  String get loadingModels => 'جاري تحميل النماذج...';

  @override
  String get noModelsAvailable => 'لا توجد نماذج متاحة. تحقق من إعدادات API.';

  @override
  String modelChangedTo(String model) {
    return 'تم تغيير النموذج إلى $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'فشل تحميل النماذج: $error';
  }

  @override
  String get searchModels => 'البحث عن نماذج...';

  @override
  String get noModelsMatchSearch => 'لا توجد نماذج مطابقة';

  @override
  String get provider => 'المزود';

  @override
  String get apiNotConfigured => 'لم يتم تكوين API';

  @override
  String get apiNotConfiguredMessage =>
      'للدردشة مع الشخصيات، تحتاج إلى تكوين مزود LLM أولاً.';

  @override
  String get supportedProviders => 'المزودون المدعومون:';

  @override
  String get configureNow => 'تكوين الآن';

  @override
  String get later => 'لاحقاً';

  @override
  String get configure => 'تكوين';

  @override
  String get configureApiProvider => 'قم بتكوين مزود LLM لبدء الدردشة';

  @override
  String get startConversation => 'ابدأ محادثة';

  @override
  String get deleteMessage => 'حذف الرسالة';

  @override
  String get deleteMessageConfirmation => 'هل أنت متأكد من حذف هذه الرسالة؟';

  @override
  String get deleteMessages => 'حذف الرسائل';

  @override
  String get deleteMessagesConfirmation =>
      'هل أنت متأكد من حذف هذه الرسالة وجميع الرسائل التالية؟';

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get generateNewResponse => 'توليد رد جديد';

  @override
  String get continueFromHere => 'المتابعة من هنا';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'حذف الرسائل التالية وإعادة توليد الرد';

  @override
  String get deleteMessagesAfterThis => 'حذف جميع الرسائل بعد هذه';

  @override
  String get createBookmark => 'إنشاء إشارة مرجعية';

  @override
  String get saveAsCheckpoint => 'حفظ هذه النقطة كنقطة تفتيش';

  @override
  String get deleteThisMessage => 'حذف هذه الرسالة';

  @override
  String get deleteThisAndAllAfter => 'حذف هذه وجميع ما بعدها';

  @override
  String get attachImage => 'إرفاق صورة';

  @override
  String get chooseFromGallery => 'اختر من المعرض';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String failedToPickImage(String error) {
    return 'فشل اختيار الصورة: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'فشل التقاط الصورة: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'فشل إضافة المرفق: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'تصدير المحادثة مع $character';
  }

  @override
  String messagesCount(int count) {
    return '$count رسائل';
  }

  @override
  String get chooseExportFormat => 'اختر صيغة التصدير:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (صيغة ST)';

  @override
  String get noChatToExport => 'لا توجد محادثة للتصدير';

  @override
  String exportFailed(String error) {
    return 'فشل التصدير: $error';
  }

  @override
  String get importChatHistory => 'استيراد سجل المحادثة من ملف.';

  @override
  String get supportedFormats => 'الصيغ المدعومة:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (صيغة SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (صيغة NativeTavern)';

  @override
  String get importNote =>
      'ملاحظة: سيتم إضافة الرسائل المستوردة إلى المحادثة الحالية.';

  @override
  String get chooseFile => 'اختر ملف';

  @override
  String get noFileSelected => 'لم يتم اختيار ملف أو الصيغة غير صالحة';

  @override
  String get importConfirmation => 'تأكيد الاستيراد';

  @override
  String get character => 'شخصية';

  @override
  String get user => 'مستخدم';

  @override
  String get messages => 'رسائل';

  @override
  String get date => 'تاريخ';

  @override
  String get hasAuthorsNote => 'يحتوي على ملاحظة المؤلف';

  @override
  String get importMessagesToCurrentChat =>
      'استيراد هذه الرسائل إلى المحادثة الحالية؟';

  @override
  String get noActiveChat => 'لا توجد محادثة نشطة';

  @override
  String importedMessages(int count) {
    return 'تم استيراد $count رسائل';
  }

  @override
  String importFailed(String error) {
    return 'فشل الاستيراد: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'هل أنت متأكد من مسح جميع الرسائل؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get clear => 'مسح';

  @override
  String get thinking => 'جاري التفكير';

  @override
  String get noSwipesAvailable => 'لا توجد تمريرات متاحة';

  @override
  String get system => 'النظام';

  @override
  String get backgroundFeatureComingSoon => 'ميزة الخلفية قادمة قريباً';

  @override
  String get authorsNoteUpdated => 'تم تحديث ملاحظة المؤلف';

  @override
  String get commandError => 'خطأ في الأمر';

  @override
  String get enabled => 'مفعل';

  @override
  String get disabled => 'معطل';

  @override
  String get personas => 'الشخصيات';

  @override
  String get createPersona => 'إنشاء شخصية';

  @override
  String get editPersona => 'تعديل الشخصية';

  @override
  String get deletePersona => 'حذف الشخصية';

  @override
  String deletePersonaConfirmation(String name) {
    return 'هل أنت متأكد من حذف \"$name\"؟';
  }

  @override
  String get noPersonasYet => 'لا توجد شخصيات بعد';

  @override
  String get createPersonaDescription => 'أنشئ شخصية لتمثيل نفسك في المحادثات';

  @override
  String get name => 'الاسم';

  @override
  String get enterPersonaName => 'أدخل اسم الشخصية';

  @override
  String get description => 'الوصف';

  @override
  String get describePersona => 'صف هذه الشخصية (اختياري)';

  @override
  String get personaDescriptionHelp =>
      'سيتم تضمين الوصف في موجه النظام لمساعدة الذكاء الاصطناعي على فهم من أنت.';

  @override
  String get pleaseEnterName => 'الرجاء إدخال اسم';

  @override
  String get default_ => 'افتراضي';

  @override
  String get active => 'نشط';

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get removeAvatar => 'إزالة الصورة الرمزية';

  @override
  String failedToSaveAvatar(String error) {
    return 'فشل حفظ الصورة الرمزية: $error';
  }

  @override
  String get selectAvatarImage => 'اختر صورة رمزية';

  @override
  String get aiConfiguration => 'تكوين الذكاء الاصطناعي';

  @override
  String get llmProvider => 'مزود LLM';

  @override
  String get apiUrl => 'رابط API';

  @override
  String get apiKey => 'مفتاح API';

  @override
  String get model => 'النموذج';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get maxTokens => 'الحد الأقصى للرموز';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'عقوبة التكرار';

  @override
  String get presencePenalty => 'عقوبة الوجود';

  @override
  String get repetitionPenalty => 'عقوبة التكرار';

  @override
  String get streamingEnabled => 'تفعيل البث';

  @override
  String get testConnection => 'اختبار الاتصال';

  @override
  String get connectionSuccessful => 'نجح الاتصال!';

  @override
  String connectionFailed(String error) {
    return 'فشل الاتصال: $error';
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
  String get local => 'محلي';

  @override
  String get aiPresets => 'إعدادات AI المسبقة';

  @override
  String get createPreset => 'إنشاء إعداد مسبق';

  @override
  String get editPreset => 'تعديل الإعداد المسبق';

  @override
  String get deletePreset => 'حذف الإعداد المسبق';

  @override
  String get presetName => 'اسم الإعداد المسبق';

  @override
  String get promptManager => 'مدير الموجهات';

  @override
  String get systemPrompt => 'موجه النظام';

  @override
  String get jailbreak => 'كسر القيود';

  @override
  String get worldInfo => 'معلومات العالم';

  @override
  String get createEntry => 'إنشاء إدخال';

  @override
  String get editEntry => 'تعديل الإدخال';

  @override
  String get deleteEntry => 'حذف الإدخال';

  @override
  String get keywords => 'الكلمات المفتاحية';

  @override
  String get content => 'المحتوى';

  @override
  String get priority => 'الأولوية';

  @override
  String get groups => 'المجموعات';

  @override
  String get createGroup => 'إنشاء مجموعة';

  @override
  String get editGroup => 'تعديل المجموعة';

  @override
  String get deleteGroup => 'حذف المجموعة';

  @override
  String get groupName => 'اسم المجموعة';

  @override
  String get members => 'الأعضاء';

  @override
  String get addMember => 'إضافة عضو';

  @override
  String get removeMember => 'إزالة عضو';

  @override
  String get tags => 'الوسوم';

  @override
  String get createTag => 'إنشاء وسم';

  @override
  String get editTag => 'تعديل الوسم';

  @override
  String get deleteTag => 'حذف الوسم';

  @override
  String get tagName => 'اسم الوسم';

  @override
  String get color => 'اللون';

  @override
  String get quickReplies => 'الردود السريعة';

  @override
  String get createQuickReply => 'إنشاء رد سريع';

  @override
  String get editQuickReply => 'تعديل الرد السريع';

  @override
  String get deleteQuickReply => 'حذف الرد السريع';

  @override
  String get label => 'التسمية';

  @override
  String get message => 'الرسالة';

  @override
  String get autoSend => 'إرسال تلقائي';

  @override
  String get regex => 'التعبيرات النمطية';

  @override
  String get createRegex => 'إنشاء تعبير نمطي';

  @override
  String get editRegex => 'تعديل التعبير النمطي';

  @override
  String get deleteRegex => 'حذف التعبير النمطي';

  @override
  String get pattern => 'النمط';

  @override
  String get replacement => 'الاستبدال';

  @override
  String get backup => 'النسخ الاحتياطي';

  @override
  String get createBackup => 'إنشاء نسخة احتياطية';

  @override
  String get restoreBackup => 'استعادة النسخة الاحتياطية';

  @override
  String get backupCreated => 'تم إنشاء النسخة الاحتياطية بنجاح';

  @override
  String get backupRestored => 'تم استعادة النسخة الاحتياطية بنجاح';

  @override
  String backupFailed(String error) {
    return 'فشل النسخ الاحتياطي: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'فشل الاستعادة: $error';
  }

  @override
  String get theme => 'المظهر';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get systemTheme => 'اتباع النظام';

  @override
  String get primaryColor => 'اللون الأساسي';

  @override
  String get accentColor => 'لون التمييز';

  @override
  String get advanced => 'متقدم';

  @override
  String get advancedSettings => 'الإعدادات المتقدمة';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get totalChats => 'إجمالي المحادثات';

  @override
  String get totalMessages => 'إجمالي الرسائل';

  @override
  String get totalCharacters => 'إجمالي الشخصيات';

  @override
  String get tokenizer => 'المحلل اللغوي';

  @override
  String get tts => 'تحويل النص إلى كلام';

  @override
  String get stt => 'تحويل الكلام إلى نص';

  @override
  String get translation => 'الترجمة';

  @override
  String get imageGeneration => 'توليد الصور';

  @override
  String get vectorStorage => 'تخزين المتجهات';

  @override
  String get sprites => 'الرسوم المتحركة';

  @override
  String get backgrounds => 'الخلفيات';

  @override
  String get cfgScale => 'مقياس CFG';

  @override
  String get logitBias => 'انحياز Logit';

  @override
  String get variables => 'المتغيرات';

  @override
  String get listView => 'عرض القائمة';

  @override
  String get gridView => 'عرض الشبكة';

  @override
  String get search => 'بحث';

  @override
  String get searchCharacters => 'البحث عن شخصيات...';

  @override
  String get noCharactersFound => 'لم يتم العثور على شخصيات';

  @override
  String get noCharactersYet => 'لا توجد شخصيات بعد';

  @override
  String get importCharacter => 'استورد شخصية للبدء';

  @override
  String get createCharacter => 'إنشاء شخصية';

  @override
  String get editCharacter => 'تعديل الشخصية';

  @override
  String get deleteCharacter => 'حذف الشخصية';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'هل أنت متأكد من حذف \"$name\"؟ سيتم أيضاً حذف جميع المحادثات مع هذه الشخصية.';
  }

  @override
  String get characterDeleted => 'تم حذف الشخصية';

  @override
  String get startChat => 'بدء المحادثة';

  @override
  String get personality => 'الشخصية';

  @override
  String get scenario => 'السيناريو';

  @override
  String get firstMessage => 'الرسالة الأولى';

  @override
  String get exampleDialogue => 'حوار مثال';

  @override
  String get creatorNotes => 'ملاحظات المنشئ';

  @override
  String get alternateGreetings => 'تحيات بديلة';

  @override
  String get characterBook => 'كتاب الشخصية';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get languageChanged => 'تم تغيير اللغة';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get licenses => 'التراخيص';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get feedback => 'التعليقات';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get shareApp => 'مشاركة التطبيق';

  @override
  String get checkForUpdates => 'التحقق من التحديثات';

  @override
  String get noUpdatesAvailable => 'لا توجد تحديثات متاحة';

  @override
  String get updateAvailable => 'يتوفر تحديث';

  @override
  String get downloadUpdate => 'تنزيل التحديث';

  @override
  String get bookmarkCreated => 'تم إنشاء الإشارة المرجعية';

  @override
  String get bookmarkName => 'اسم الإشارة المرجعية';

  @override
  String get enterBookmarkName => 'أدخل اسم الإشارة المرجعية';

  @override
  String get noBookmarksYet => 'لا توجد إشارات مرجعية بعد';

  @override
  String get createBookmarkDescription =>
      'أنشئ إشارات مرجعية لحفظ النقاط المهمة في محادثتك';

  @override
  String get jumpToBookmark => 'الانتقال إلى الإشارة المرجعية';

  @override
  String get deleteBookmark => 'حذف الإشارة المرجعية';

  @override
  String get bookmarkDeleted => 'تم حذف الإشارة المرجعية';

  @override
  String get saveAsJsonl => 'حفظ كـ JSONL';

  @override
  String get saveAsJson => 'حفظ كـ JSON';

  @override
  String get keyboardShortcuts => 'اختصارات لوحة المفاتيح:';

  @override
  String get bold => 'عريض';

  @override
  String get italic => 'مائل';

  @override
  String get underline => 'تسطير';

  @override
  String get strikethrough => 'يتوسطه خط';

  @override
  String get inlineCode => 'كود مضمن';

  @override
  String get link => 'رابط';

  @override
  String get slashCommands => 'أوامر الشرطة المائلة';

  @override
  String get availableCommands => 'الأوامر المتاحة:';

  @override
  String get commandHelp => 'اكتب / لعرض الأوامر المتاحة';
}
