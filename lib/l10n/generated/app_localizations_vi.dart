// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => 'Trang chủ';

  @override
  String get characters => 'Nhân vật';

  @override
  String get settings => 'Cài đặt';

  @override
  String get chats => 'Trò chuyện';

  @override
  String get newChat => 'Cuộc trò chuyện mới';

  @override
  String get noChatsYet => 'Chưa có cuộc trò chuyện nào';

  @override
  String get startNewConversation => 'Bắt đầu cuộc trò chuyện với một nhân vật';

  @override
  String get browseCharacters => 'Duyệt nhân vật';

  @override
  String get groupChats => 'Trò chuyện nhóm';

  @override
  String get import => 'Nhập';

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get copy => 'Sao chép';

  @override
  String get retry => 'Thử lại';

  @override
  String get close => 'Đóng';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get loading => 'Đang tải...';

  @override
  String get error => 'Lỗi';

  @override
  String errorLoadingChats(String error) {
    return 'Lỗi khi tải cuộc trò chuyện: $error';
  }

  @override
  String get deleteChat => 'Xóa cuộc trò chuyện';

  @override
  String get deleteChatConfirmation =>
      'Bạn có chắc muốn xóa cuộc trò chuyện này? Hành động này không thể hoàn tác.';

  @override
  String get chatDeleted => 'Đã xóa cuộc trò chuyện';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String daysAgo(int count) {
    return '$count ngày trước';
  }

  @override
  String get noMessages => 'Không có tin nhắn';

  @override
  String get noMessagesYet => 'Chưa có tin nhắn nào';

  @override
  String get chat => 'Trò chuyện';

  @override
  String get typeMessage => 'Nhập tin nhắn...';

  @override
  String get send => 'Gửi';

  @override
  String get regenerate => 'Tạo lại';

  @override
  String get continueGeneration => 'Tiếp tục';

  @override
  String get viewCharacter => 'Xem nhân vật';

  @override
  String get authorsNote => 'Ghi chú của tác giả';

  @override
  String get bookmarks => 'Dấu trang';

  @override
  String get exportChat => 'Xuất cuộc trò chuyện';

  @override
  String get importChat => 'Nhập cuộc trò chuyện';

  @override
  String get clearMessages => 'Xóa tin nhắn';

  @override
  String get selectModel => 'Chọn mô hình';

  @override
  String get loadingModels => 'Đang tải mô hình...';

  @override
  String get noModelsAvailable =>
      'Không có mô hình nào. Kiểm tra cấu hình API.';

  @override
  String modelChangedTo(String model) {
    return 'Đã đổi mô hình thành $model';
  }

  @override
  String failedToLoadModels(String error) {
    return 'Không thể tải mô hình: $error';
  }

  @override
  String get searchModels => 'Tìm kiếm mô hình...';

  @override
  String get noModelsMatchSearch => 'Không có mô hình phù hợp';

  @override
  String get provider => 'Nhà cung cấp';

  @override
  String get apiNotConfigured => 'API chưa được cấu hình';

  @override
  String get apiNotConfiguredMessage =>
      'Để trò chuyện với nhân vật, bạn cần cấu hình nhà cung cấp LLM trước.';

  @override
  String get supportedProviders => 'Nhà cung cấp được hỗ trợ:';

  @override
  String get configureNow => 'Cấu hình ngay';

  @override
  String get later => 'Để sau';

  @override
  String get configure => 'Cấu hình';

  @override
  String get configureApiProvider =>
      'Cấu hình nhà cung cấp LLM để bắt đầu trò chuyện';

  @override
  String get startConversation => 'Bắt đầu cuộc trò chuyện';

  @override
  String get deleteMessage => 'Xóa tin nhắn';

  @override
  String get deleteMessageConfirmation => 'Bạn có chắc muốn xóa tin nhắn này?';

  @override
  String get deleteMessages => 'Xóa tin nhắn';

  @override
  String get deleteMessagesConfirmation =>
      'Bạn có chắc muốn xóa tin nhắn này và tất cả tin nhắn sau đó?';

  @override
  String get deleteAll => 'Xóa tất cả';

  @override
  String get copiedToClipboard => 'Đã sao chép vào clipboard';

  @override
  String get generateNewResponse => 'Tạo phản hồi mới';

  @override
  String get continueFromHere => 'Tiếp tục từ đây';

  @override
  String get deleteMessagesAfterAndRegenerate =>
      'Xóa tin nhắn sau và tạo lại phản hồi';

  @override
  String get deleteMessagesAfterThis => 'Xóa tất cả tin nhắn sau tin này';

  @override
  String get createBookmark => 'Tạo dấu trang';

  @override
  String get saveAsCheckpoint => 'Lưu điểm này làm checkpoint';

  @override
  String get deleteThisMessage => 'Xóa tin nhắn này';

  @override
  String get deleteThisAndAllAfter => 'Xóa tin này và tất cả sau đó';

  @override
  String get attachImage => 'Đính kèm hình ảnh';

  @override
  String get chooseFromGallery => 'Chọn từ thư viện';

  @override
  String get takePhoto => 'Chụp ảnh';

  @override
  String failedToPickImage(String error) {
    return 'Không thể chọn hình ảnh: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return 'Không thể chụp ảnh: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return 'Không thể thêm tệp đính kèm: $error';
  }

  @override
  String exportChatWith(String character) {
    return 'Xuất cuộc trò chuyện với $character';
  }

  @override
  String messagesCount(int count) {
    return '$count tin nhắn';
  }

  @override
  String get chooseExportFormat => 'Chọn định dạng xuất:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (định dạng ST)';

  @override
  String get noChatToExport => 'Không có cuộc trò chuyện để xuất';

  @override
  String exportFailed(String error) {
    return 'Xuất thất bại: $error';
  }

  @override
  String get importChatHistory => 'Nhập lịch sử trò chuyện từ tệp.';

  @override
  String get supportedFormats => 'Định dạng được hỗ trợ:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (định dạng SillyTavern)';

  @override
  String get jsonNativeTavernFormat => 'JSON (định dạng NativeTavern)';

  @override
  String get importNote =>
      'Lưu ý: Tin nhắn nhập sẽ được thêm vào cuộc trò chuyện hiện tại.';

  @override
  String get chooseFile => 'Chọn tệp';

  @override
  String get noFileSelected => 'Chưa chọn tệp hoặc định dạng không hợp lệ';

  @override
  String get importConfirmation => 'Xác nhận nhập';

  @override
  String get character => 'Nhân vật';

  @override
  String get user => 'Người dùng';

  @override
  String get messages => 'Tin nhắn';

  @override
  String get date => 'Ngày';

  @override
  String get hasAuthorsNote => 'Có ghi chú của tác giả';

  @override
  String get importMessagesToCurrentChat =>
      'Nhập các tin nhắn này vào cuộc trò chuyện hiện tại?';

  @override
  String get noActiveChat => 'Không có cuộc trò chuyện đang hoạt động';

  @override
  String importedMessages(int count) {
    return 'Đã nhập $count tin nhắn';
  }

  @override
  String importFailed(String error) {
    return 'Nhập thất bại: $error';
  }

  @override
  String get clearMessagesConfirmation =>
      'Bạn có chắc muốn xóa tất cả tin nhắn? Hành động này không thể hoàn tác.';

  @override
  String get clear => 'Xóa';

  @override
  String get thinking => 'Đang suy nghĩ';

  @override
  String get noSwipesAvailable => 'Không có swipe nào';

  @override
  String get system => 'Hệ thống';

  @override
  String get backgroundFeatureComingSoon => 'Tính năng nền sắp ra mắt';

  @override
  String get authorsNoteUpdated => 'Đã cập nhật ghi chú của tác giả';

  @override
  String get commandError => 'Lỗi lệnh';

  @override
  String get enabled => 'Đã bật';

  @override
  String get disabled => 'Đã tắt';

  @override
  String get personas => 'Nhân cách';

  @override
  String get createPersona => 'Tạo nhân cách';

  @override
  String get editPersona => 'Chỉnh sửa nhân cách';

  @override
  String get deletePersona => 'Xóa nhân cách';

  @override
  String deletePersonaConfirmation(String name) {
    return 'Bạn có chắc muốn xóa \"$name\"?';
  }

  @override
  String get noPersonasYet => 'Chưa có nhân cách nào';

  @override
  String get createPersonaDescription =>
      'Tạo nhân cách để đại diện cho bạn trong các cuộc trò chuyện';

  @override
  String get name => 'Tên';

  @override
  String get enterPersonaName => 'Nhập tên nhân cách';

  @override
  String get description => 'Mô tả';

  @override
  String get describePersona => 'Mô tả nhân cách này (tùy chọn)';

  @override
  String get personaDescriptionHelp =>
      'Mô tả sẽ được đưa vào prompt hệ thống để giúp AI hiểu bạn là ai.';

  @override
  String get pleaseEnterName => 'Vui lòng nhập tên';

  @override
  String get default_ => 'Mặc định';

  @override
  String get active => 'Đang hoạt động';

  @override
  String get setAsDefault => 'Đặt làm mặc định';

  @override
  String get removeAvatar => 'Xóa avatar';

  @override
  String failedToSaveAvatar(String error) {
    return 'Không thể lưu avatar: $error';
  }

  @override
  String get selectAvatarImage => 'Chọn hình avatar';

  @override
  String get aiConfiguration => 'Cấu hình AI';

  @override
  String get llmProvider => 'Nhà cung cấp LLM';

  @override
  String get apiUrl => 'URL API';

  @override
  String get apiKey => 'Khóa API';

  @override
  String get model => 'Mô hình';

  @override
  String get temperature => 'Nhiệt độ';

  @override
  String get maxTokens => 'Token tối đa';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => 'Phạt tần suất';

  @override
  String get presencePenalty => 'Phạt hiện diện';

  @override
  String get repetitionPenalty => 'Phạt lặp lại';

  @override
  String get streamingEnabled => 'Bật streaming';

  @override
  String get testConnection => 'Kiểm tra kết nối';

  @override
  String get connectionSuccessful => 'Kết nối thành công!';

  @override
  String connectionFailed(String error) {
    return 'Kết nối thất bại: $error';
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
  String get local => 'Cục bộ';

  @override
  String get aiPresets => 'Preset AI';

  @override
  String get createPreset => 'Tạo preset';

  @override
  String get editPreset => 'Chỉnh sửa preset';

  @override
  String get deletePreset => 'Xóa preset';

  @override
  String get presetName => 'Tên preset';

  @override
  String get promptManager => 'Quản lý prompt';

  @override
  String get systemPrompt => 'Prompt hệ thống';

  @override
  String get jailbreak => 'Jailbreak';

  @override
  String get worldInfo => 'Thông tin thế giới';

  @override
  String get createEntry => 'Tạo mục';

  @override
  String get editEntry => 'Chỉnh sửa mục';

  @override
  String get deleteEntry => 'Xóa mục';

  @override
  String get keywords => 'Từ khóa';

  @override
  String get content => 'Nội dung';

  @override
  String get priority => 'Ưu tiên';

  @override
  String get groups => 'Nhóm';

  @override
  String get createGroup => 'Tạo nhóm';

  @override
  String get editGroup => 'Chỉnh sửa nhóm';

  @override
  String get deleteGroup => 'Xóa nhóm';

  @override
  String get groupName => 'Tên nhóm';

  @override
  String get members => 'Thành viên';

  @override
  String get addMember => 'Thêm thành viên';

  @override
  String get removeMember => 'Xóa thành viên';

  @override
  String get tags => 'Thẻ';

  @override
  String get createTag => 'Tạo thẻ';

  @override
  String get editTag => 'Chỉnh sửa thẻ';

  @override
  String get deleteTag => 'Xóa thẻ';

  @override
  String get tagName => 'Tên thẻ';

  @override
  String get color => 'Màu';

  @override
  String get quickReplies => 'Trả lời nhanh';

  @override
  String get createQuickReply => 'Tạo trả lời nhanh';

  @override
  String get editQuickReply => 'Chỉnh sửa trả lời nhanh';

  @override
  String get deleteQuickReply => 'Xóa trả lời nhanh';

  @override
  String get label => 'Nhãn';

  @override
  String get message => 'Tin nhắn';

  @override
  String get autoSend => 'Tự động gửi';

  @override
  String get regex => 'Regex';

  @override
  String get createRegex => 'Tạo regex';

  @override
  String get editRegex => 'Chỉnh sửa regex';

  @override
  String get deleteRegex => 'Xóa regex';

  @override
  String get pattern => 'Mẫu';

  @override
  String get replacement => 'Thay thế';

  @override
  String get backup => 'Sao lưu';

  @override
  String get createBackup => 'Tạo bản sao lưu';

  @override
  String get restoreBackup => 'Khôi phục bản sao lưu';

  @override
  String get backupCreated => 'Đã tạo bản sao lưu thành công';

  @override
  String get backupRestored => 'Đã khôi phục bản sao lưu thành công';

  @override
  String backupFailed(String error) {
    return 'Sao lưu thất bại: $error';
  }

  @override
  String restoreFailed(String error) {
    return 'Khôi phục thất bại: $error';
  }

  @override
  String get theme => 'Giao diện';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get lightMode => 'Chế độ sáng';

  @override
  String get systemTheme => 'Theo hệ thống';

  @override
  String get primaryColor => 'Màu chính';

  @override
  String get accentColor => 'Màu nhấn';

  @override
  String get advanced => 'Nâng cao';

  @override
  String get advancedSettings => 'Cài đặt nâng cao';

  @override
  String get statistics => 'Thống kê';

  @override
  String get totalChats => 'Tổng số cuộc trò chuyện';

  @override
  String get totalMessages => 'Tổng số tin nhắn';

  @override
  String get totalCharacters => 'Tổng số nhân vật';

  @override
  String get tokenizer => 'Tokenizer';

  @override
  String get tts => 'Chuyển văn bản thành giọng nói';

  @override
  String get stt => 'Chuyển giọng nói thành văn bản';

  @override
  String get translation => 'Dịch';

  @override
  String get imageGeneration => 'Tạo hình ảnh';

  @override
  String get vectorStorage => 'Lưu trữ vector';

  @override
  String get sprites => 'Sprites';

  @override
  String get backgrounds => 'Nền';

  @override
  String get cfgScale => 'Tỷ lệ CFG';

  @override
  String get logitBias => 'Logit Bias';

  @override
  String get variables => 'Biến';

  @override
  String get listView => 'Xem danh sách';

  @override
  String get gridView => 'Xem lưới';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchCharacters => 'Tìm kiếm nhân vật...';

  @override
  String get noCharactersFound => 'Không tìm thấy nhân vật';

  @override
  String get noCharactersYet => 'Chưa có nhân vật nào';

  @override
  String get importCharacter => 'Nhập nhân vật để bắt đầu';

  @override
  String get createCharacter => 'Tạo nhân vật';

  @override
  String get editCharacter => 'Chỉnh sửa nhân vật';

  @override
  String get deleteCharacter => 'Xóa nhân vật';

  @override
  String deleteCharacterConfirmation(String name) {
    return 'Bạn có chắc muốn xóa \"$name\"? Tất cả cuộc trò chuyện với nhân vật này cũng sẽ bị xóa.';
  }

  @override
  String get characterDeleted => 'Đã xóa nhân vật';

  @override
  String get startChat => 'Bắt đầu trò chuyện';

  @override
  String get personality => 'Tính cách';

  @override
  String get scenario => 'Kịch bản';

  @override
  String get firstMessage => 'Tin nhắn đầu tiên';

  @override
  String get exampleDialogue => 'Đoạn hội thoại mẫu';

  @override
  String get creatorNotes => 'Ghi chú của người tạo';

  @override
  String get alternateGreetings => 'Lời chào thay thế';

  @override
  String get characterBook => 'Sách nhân vật';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get languageChanged => 'Đã thay đổi ngôn ngữ';

  @override
  String get about => 'Giới thiệu';

  @override
  String get version => 'Phiên bản';

  @override
  String get licenses => 'Giấy phép';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get feedback => 'Phản hồi';

  @override
  String get rateApp => 'Đánh giá ứng dụng';

  @override
  String get shareApp => 'Chia sẻ ứng dụng';

  @override
  String get checkForUpdates => 'Kiểm tra cập nhật';

  @override
  String get noUpdatesAvailable => 'Không có bản cập nhật nào';

  @override
  String get updateAvailable => 'Có bản cập nhật';

  @override
  String get downloadUpdate => 'Tải bản cập nhật';

  @override
  String get bookmarkCreated => 'Đã tạo dấu trang';

  @override
  String get bookmarkName => 'Tên dấu trang';

  @override
  String get enterBookmarkName => 'Nhập tên dấu trang';

  @override
  String get noBookmarksYet => 'Chưa có dấu trang nào';

  @override
  String get createBookmarkDescription =>
      'Tạo dấu trang để lưu các điểm quan trọng trong cuộc trò chuyện';

  @override
  String get jumpToBookmark => 'Đi đến dấu trang';

  @override
  String get deleteBookmark => 'Xóa dấu trang';

  @override
  String get bookmarkDeleted => 'Đã xóa dấu trang';

  @override
  String get saveAsJsonl => 'Lưu dưới dạng JSONL';

  @override
  String get saveAsJson => 'Lưu dưới dạng JSON';

  @override
  String get keyboardShortcuts => 'Phím tắt:';

  @override
  String get bold => 'Đậm';

  @override
  String get italic => 'Nghiêng';

  @override
  String get underline => 'Gạch chân';

  @override
  String get strikethrough => 'Gạch ngang';

  @override
  String get inlineCode => 'Mã inline';

  @override
  String get link => 'Liên kết';

  @override
  String get slashCommands => 'Lệnh slash';

  @override
  String get availableCommands => 'Các lệnh có sẵn:';

  @override
  String get commandHelp => 'Nhập / để xem các lệnh có sẵn';

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
