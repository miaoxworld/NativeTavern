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
}
