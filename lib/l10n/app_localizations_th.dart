// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'หน้าแรก';

  @override
  String get characters => 'ตัวละคร';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get chats => 'แชท';

  @override
  String get newChat => 'แชทใหม่';

  @override
  String get noChatsYet => 'ยังไม่มีแชท';

  @override
  String get startNewConversation => 'เริ่มการสนทนากับตัวละคร';

  @override
  String get browseCharacters => 'เรียกดูตัวละคร';

  @override
  String get groupChats => 'แชทกลุ่ม';

  @override
  String get import => 'นำเข้า';

  @override
  String get delete => 'ลบ';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get edit => 'แก้ไข';

  @override
  String get copy => 'คัดลอก';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get close => 'ปิด';

  @override
  String get ok => 'ตกลง';

  @override
  String get yes => 'ใช่';

  @override
  String get no => 'ไม่';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String errorLoadingChats(String error) {
    return 'เกิดข้อผิดพลาดในการโหลดแชท: $error';
  }

  @override
  String get deleteChat => 'ลบแชท';

  @override
  String get deleteChatConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบแชทนี้? การดำเนินการนี้ไม่สามารถยกเลิกได้';

  @override
  String get chatDeleted => 'ลบแชทแล้ว';

  @override
  String get yesterday => 'เมื่อวาน';

  @override
  String daysAgo(int count) {
    return '$count วันที่แล้ว';
  }

  @override
  String get noMessages => 'ไม่มีข้อความ';

  @override
  String get noMessagesYet => 'ยังไม่มีข้อความ';

  @override
  String get chat => 'แชท';

  @override
  String get typeMessage => 'พิมพ์ข้อความ...';

  @override
  String get send => 'ส่ง';

  @override
  String get regenerate => 'สร้างใหม่';

  @override
  String get continueGeneration => 'ดำเนินการต่อ';

  @override
  String get viewCharacter => 'ดูตัวละคร';

  @override
  String get authorsNote => 'บันทึกของผู้เขียน';

  @override
  String get bookmarks => 'บุ๊กมาร์ก';

  @override
  String get exportChat => 'ส่งออกแชท';

  @override
  String get importChat => 'นำเข้าแชท';

  @override
  String get clearMessages => 'ล้างข้อความ';

  @override
  String get selectModel => 'เลือกโมเดล';

  @override
  String get loadingModels => 'กำลังโหลดโมเดล...';

  @override
  String get noModelsAvailable => 'ไม่มีโมเดลที่ใช้ได้ ตรวจสอบการตั้งค่า API';

  @override
  String modelChangedTo(String model) {
    return 'เปลี่ยนโมเดลเป็น $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'ไม่สามารถโหลดโมเดล: $error';
  }

  @override
  String get searchModels => 'ค้นหาโมเดล...';

  @override
  String get noModelsMatchSearch => 'ไม่พบโมเดลที่ตรงกัน';

  @override
  String get provider => 'ผู้ให้บริการ';

  @override
  String get apiNotConfigured => 'ยังไม่ได้ตั้งค่า API';

  @override
  String get apiNotConfiguredMessage =>
      'หากต้องการแชทกับตัวละคร คุณต้องตั้งค่าผู้ให้บริการ LLM ก่อน';

  @override
  String get supportedProviders => 'ผู้ให้บริการที่รองรับ:';

  @override
  String get configureNow => 'ตั้งค่าตอนนี้';

  @override
  String get later => 'ภายหลัง';

  @override
  String get configure => 'ตั้งค่า';

  @override
  String get configureApiProvider => 'ตั้งค่าผู้ให้บริการ LLM เพื่อเริ่มแชท';

  @override
  String get startConversation => 'เริ่มการสนทนา';

  @override
  String get deleteMessage => 'ลบข้อความ';

  @override
  String get deleteMessageConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบข้อความนี้?';

  @override
  String get deleteMessages => 'ลบข้อความ';

  @override
  String get deleteMessagesConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการลบข้อความนี้และข้อความทั้งหมดหลังจากนี้?';

  @override
  String get deleteAll => 'ลบทั้งหมด';

  @override
  String get copiedToClipboard => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get generateNewResponse => 'สร้างคำตอบใหม่';

  @override
  String get continueFromHere => 'ดำเนินการต่อจากที่นี่';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'ลบข้อความหลังจากนี้และสร้างคำตอบใหม่';

  @override
  String get deleteMessagesAfterThis => 'ลบข้อความทั้งหมดหลังจากนี้';

  @override
  String get createBookmark => 'สร้างบุ๊กมาร์ก';

  @override
  String get saveAsCheckpoint => 'บันทึกจุดนี้เป็นเช็คพอยต์';

  @override
  String get deleteThisMessage => 'ลบข้อความนี้';

  @override
  String get deleteThisAndAllAfter => 'ลบข้อความนี้และทั้งหมดหลังจากนี้';

  @override
  String get attachImage => 'แนบรูปภาพ';

  @override
  String get chooseFromGallery => 'เลือกจากแกลเลอรี';

  @override
  String get takePhoto => 'ถ่ายรูป';

  @override
  String failedToPickImage(String error) {
    return 'ไม่สามารถเลือกรูปภาพ: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'ไม่สามารถถ่ายรูป: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'ไม่สามารถเพิ่มไฟล์แนบ: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'ส่งออกแชทกับ $character';
  }

  @override
  String messagesCount(int count) {
    return '$count ข้อความ';
  }

  @override
  String get chooseExportFormat => 'เลือกรูปแบบการส่งออก:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (รูปแบบ ST)';

  @override
  String get noChatToExport => 'ไม่มีแชทที่จะส่งออก';

  @override
  String exportFailed(String error) {
    return 'การส่งออกล้มเหลว: $error';
  }

  @override
  String get importChatHistory => 'นำเข้าประวัติแชทจากไฟล์';

  @override
  String get supportedFormats => 'รูปแบบที่รองรับ:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (รูปแบบ SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (รูปแบบ NativeTavern)';

  @override
  String get importNote => 'หมายเหตุ: ข้อความที่นำเข้าจะถูกเพิ่มในแชทปัจจุบัน';

  @override
  String get chooseFile => 'เลือกไฟล์';

  @override
  String get noFileSelected => 'ไม่ได้เลือกไฟล์หรือรูปแบบไม่ถูกต้อง';

  @override
  String get importConfirmation => 'ยืนยันการนำเข้า';

  @override
  String get character => 'ตัวละคร';

  @override
  String get user => 'ผู้ใช้';

  @override
  String get messages => 'ข้อความ';

  @override
  String get date => 'วันที่';

  @override
  String get hasAuthorsNote => 'มีบันทึกของผู้เขียน';

  @override
  String get importMessagesToCurrentChat =>
      'นำเข้าข้อความเหล่านี้ไปยังแชทปัจจุบัน?';

  @override
  String get noActiveChat => 'ไม่มีแชทที่ใช้งานอยู่';

  @override
  String importedMessages(int count) {
    return 'นำเข้า $count ข้อความแล้ว';
  }

  @override
  String importFailed(String error) {
    return 'การนำเข้าล้มเหลว: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการล้างข้อความทั้งหมด? การดำเนินการนี้ไม่สามารถยกเลิกได้';

  @override
  String get clear => 'ล้าง';

  @override
  String get thinking => 'กำลังคิด';

  @override
  String get noSwipesAvailable => 'ไม่มีการปัดที่ใช้ได้';

  @override
  String get system => 'ระบบ';

  @override
  String get backgroundFeatureComingSoon => 'ฟีเจอร์พื้นหลังเร็วๆ นี้';

  @override
  String get authorsNoteUpdated => 'อัปเดตบันทึกของผู้เขียนแล้ว';

  @override
  String get commandError => 'ข้อผิดพลาดคำสั่ง';

  @override
  String get enabled => 'เปิดใช้งาน';

  @override
  String get disabled => 'ปิดใช้งาน';

  @override
  String get personas => 'บุคลิก';

  @override
  String get createPersona => 'สร้างบุคลิก';

  @override
  String get editPersona => 'แก้ไขบุคลิก';

  @override
  String get deletePersona => 'ลบบุคลิก';

  @override
  String deletePersonaConfirmation(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ \"$name\"?';
  }

  @override
  String get noPersonasYet => 'ยังไม่มีบุคลิก';

  @override
  String get createPersonaDescription =>
      'สร้างบุคลิกเพื่อเป็นตัวแทนของคุณในแชท';

  @override
  String get name => 'ชื่อ';

  @override
  String get enterPersonaName => 'ป้อนชื่อบุคลิก';

  @override
  String get description => 'คำอธิบาย';

  @override
  String get describePersona => 'อธิบายบุคลิกนี้ (ไม่บังคับ)';

  @override
  String get personaDescriptionHelp =>
      'คำอธิบายจะถูกรวมในพรอมต์ระบบเพื่อช่วยให้ AI เข้าใจว่าคุณเป็นใคร';

  @override
  String get pleaseEnterName => 'กรุณาป้อนชื่อ';

  @override
  String get default_ => 'ค่าเริ่มต้น';

  @override
  String get active => 'ใช้งานอยู่';

  @override
  String get setAsDefault => 'ตั้งเป็นค่าเริ่มต้น';

  @override
  String get removeAvatar => 'ลบอวาตาร์';

  @override
  String failedToSaveAvatar(String error) {
    return 'ไม่สามารถบันทึกอวาตาร์: $error';
  }

  @override
  String get selectAvatarImage => 'เลือกรูปอวาตาร์';

  @override
  String get aiConfiguration => 'การตั้งค่า AI';

  @override
  String get llmProvider => 'ผู้ให้บริการ LLM';

  @override
  String get apiUrl => 'URL API';

  @override
  String get apiKey => 'คีย์ API';

  @override
  String get model => 'โมเดล';

  @override
  String get temperature => 'อุณหภูมิ';

  @override
  String get maxTokens => 'โทเค็นสูงสุด';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'การลงโทษความถี่';

  @override
  String get presencePenalty => 'การลงโทษการปรากฏ';

  @override
  String get repetitionPenalty => 'การลงโทษการซ้ำ';

  @override
  String get streamingEnabled => 'เปิดใช้งานสตรีมมิ่ง';

  @override
  String get testConnection => 'ทดสอบการเชื่อมต่อ';

  @override
  String get connectionSuccessful => 'เชื่อมต่อสำเร็จ!';

  @override
  String connectionFailed(String error) {
    return 'การเชื่อมต่อล้มเหลว: $error';
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
  String get local => 'ในเครื่อง';

  @override
  String get aiPresets => 'พรีเซ็ต AI';

  @override
  String get createPreset => 'สร้างพรีเซ็ต';

  @override
  String get editPreset => 'แก้ไขพรีเซ็ต';

  @override
  String get deletePreset => 'ลบพรีเซ็ต';

  @override
  String get presetName => 'ชื่อพรีเซ็ต';

  @override
  String get promptManager => 'ตัวจัดการพรอมต์';

  @override
  String get systemPrompt => 'พรอมต์ระบบ';

  @override
  String get jailbreak => 'เจลเบรก';

  @override
  String get worldInfo => 'ข้อมูลโลก';

  @override
  String get createEntry => 'สร้างรายการ';

  @override
  String get editEntry => 'แก้ไขรายการ';

  @override
  String get deleteEntry => 'ลบรายการ';

  @override
  String get keywords => 'คำสำคัญ';

  @override
  String get content => 'เนื้อหา';

  @override
  String get priority => 'ลำดับความสำคัญ';

  @override
  String get groups => 'กลุ่ม';

  @override
  String get createGroup => 'สร้างกลุ่ม';

  @override
  String get editGroup => 'แก้ไขกลุ่ม';

  @override
  String get deleteGroup => 'ลบกลุ่ม';

  @override
  String get groupName => 'ชื่อกลุ่ม';

  @override
  String get members => 'สมาชิก';

  @override
  String get addMember => 'เพิ่มสมาชิก';

  @override
  String get removeMember => 'ลบสมาชิก';

  @override
  String get tags => 'แท็ก';

  @override
  String get createTag => 'สร้างแท็ก';

  @override
  String get editTag => 'แก้ไขแท็ก';

  @override
  String get deleteTag => 'ลบแท็ก';

  @override
  String get tagName => 'ชื่อแท็ก';

  @override
  String get color => 'สี';

  @override
  String get quickReplies => 'ตอบกลับด่วน';

  @override
  String get createQuickReply => 'สร้างการตอบกลับด่วน';

  @override
  String get editQuickReply => 'แก้ไขการตอบกลับด่วน';

  @override
  String get deleteQuickReply => 'ลบการตอบกลับด่วน';

  @override
  String get label => 'ป้ายกำกับ';

  @override
  String get message => 'ข้อความ';

  @override
  String get autoSend => 'ส่งอัตโนมัติ';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'สร้าง regex';

  @override
  String get editRegex => 'แก้ไข regex';

  @override
  String get deleteRegex => 'ลบ regex';

  @override
  String get pattern => 'รูปแบบ';

  @override
  String get replacement => 'การแทนที่';

  @override
  String get backup => 'สำรองข้อมูล';

  @override
  String get createBackup => 'สร้างข้อมูลสำรอง';

  @override
  String get restoreBackup => 'กู้คืนข้อมูลสำรอง';

  @override
  String get backupCreated => 'สร้างข้อมูลสำรองสำเร็จ';

  @override
  String get backupRestored => 'กู้คืนข้อมูลสำรองสำเร็จ';

  @override
  String backupFailed(String error) {
    return 'การสำรองข้อมูลล้มเหลว: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'การกู้คืนล้มเหลว: $error';
  }

  @override
  String get theme => 'ธีม';

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get lightMode => 'โหมดสว่าง';

  @override
  String get systemTheme => 'ตามระบบ';

  @override
  String get primaryColor => 'สีหลัก';

  @override
  String get accentColor => 'สีเน้น';

  @override
  String get advanced => 'ขั้นสูง';

  @override
  String get advancedSettings => 'การตั้งค่าขั้นสูง';

  @override
  String get statistics => 'สถิติ';

  @override
  String get totalChats => 'แชททั้งหมด';

  @override
  String get totalMessages => 'ข้อความทั้งหมด';

  @override
  String get totalCharacters => 'ตัวละครทั้งหมด';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'แปลงข้อความเป็นเสียง';

  @override
  String get stt => 'แปลงเสียงเป็นข้อความ';

  @override
  String get translation => 'การแปล';

  @override
  String get imageGeneration => 'สร้างรูปภาพ';

  @override
  String get vectorStorage => 'ที่เก็บเวกเตอร์';

  @override
  String get sprites => 'สไปรต์';

  @override
  String get backgrounds => 'พื้นหลัง';

  @override
  String get cfgScale => 'สเกล CFG';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'ตัวแปร';

  @override
  String get listView => 'มุมมองรายการ';

  @override
  String get gridView => 'มุมมองตาราง';

  @override
  String get search => 'ค้นหา';

  @override
  String get searchCharacters => 'ค้นหาตัวละคร...';

  @override
  String get noCharactersFound => 'ไม่พบตัวละคร';

  @override
  String get noCharactersYet => 'ยังไม่มีตัวละคร';

  @override
  String get importCharacter => 'นำเข้าตัวละครเพื่อเริ่มต้น';

  @override
  String get createCharacter => 'สร้างตัวละคร';

  @override
  String get editCharacter => 'แก้ไขตัวละคร';

  @override
  String get deleteCharacter => 'ลบตัวละคร';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ \"$name\"? แชททั้งหมดกับตัวละครนี้จะถูกลบด้วย';
  }

  @override
  String get characterDeleted => 'ลบตัวละครแล้ว';

  @override
  String get startChat => 'เริ่มแชท';

  @override
  String get personality => 'บุคลิกภาพ';

  @override
  String get scenario => 'สถานการณ์';

  @override
  String get firstMessage => 'ข้อความแรก';

  @override
  String get exampleDialogue => 'บทสนทนาตัวอย่าง';

  @override
  String get creatorNotes => 'บันทึกของผู้สร้าง';

  @override
  String get alternateGreetings => 'คำทักทายทางเลือก';

  @override
  String get characterBook => 'หนังสือตัวละคร';

  @override
  String get language => 'ภาษา';

  @override
  String get selectLanguage => 'เลือกภาษา';

  @override
  String get languageChanged => 'เปลี่ยนภาษาแล้ว';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get licenses => 'ใบอนุญาต';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get termsOfService => 'ข้อกำหนดการให้บริการ';

  @override
  String get feedback => 'ความคิดเห็น';

  @override
  String get rateApp => 'ให้คะแนนแอป';

  @override
  String get shareApp => 'แชร์แอป';

  @override
  String get checkForUpdates => 'ตรวจสอบการอัปเดต';

  @override
  String get noUpdatesAvailable => 'ไม่มีการอัปเดต';

  @override
  String get updateAvailable => 'มีการอัปเดต';

  @override
  String get downloadUpdate => 'ดาวน์โหลดการอัปเดต';

  @override
  String get bookmarkCreated => 'สร้างบุ๊กมาร์กแล้ว';

  @override
  String get bookmarkName => 'ชื่อบุ๊กมาร์ก';

  @override
  String get enterBookmarkName => 'ป้อนชื่อบุ๊กมาร์ก';

  @override
  String get noBookmarksYet => 'ยังไม่มีบุ๊กมาร์ก';

  @override
  String get createBookmarkDescription =>
      'สร้างบุ๊กมาร์กเพื่อบันทึกจุดสำคัญในการสนทนา';

  @override
  String get jumpToBookmark => 'ไปที่บุ๊กมาร์ก';

  @override
  String get deleteBookmark => 'ลบบุ๊กมาร์ก';

  @override
  String get bookmarkDeleted => 'ลบบุ๊กมาร์กแล้ว';

  @override
  String get saveAsJsonl => 'บันทึกเป็น JSONL';

  @override
  String get saveAsJson => 'บันทึกเป็น JSON';

  @override
  String get keyboardShortcuts => 'ปุ่มลัด:';

  @override
  String get bold => 'ตัวหนา';

  @override
  String get italic => 'ตัวเอียง';

  @override
  String get underline => 'ขีดเส้นใต้';

  @override
  String get strikethrough => 'ขีดฆ่า';

  @override
  String get inlineCode => 'โค้ดในบรรทัด';

  @override
  String get link => 'ลิงก์';

  @override
  String get slashCommands => 'คำสั่งสแลช';

  @override
  String get availableCommands => 'คำสั่งที่ใช้ได้:';

  @override
  String get commandHelp => 'พิมพ์ / เพื่อดูคำสั่งที่ใช้ได้';
}
