// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'NativeTavern';

  @override
  String get home => '홈';

  @override
  String get characters => '캐릭터';

  @override
  String get settings => '설정';

  @override
  String get chats => '채팅';

  @override
  String get newChat => '새 채팅';

  @override
  String get noChatsYet => '채팅이 없습니다';

  @override
  String get startNewConversation => '캐릭터와 대화를 시작하세요';

  @override
  String get browseCharacters => '캐릭터 둘러보기';

  @override
  String get groupChats => '그룹 채팅';

  @override
  String get import => '가져오기';

  @override
  String get delete => '삭제';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get edit => '편집';

  @override
  String get copy => '복사';

  @override
  String get retry => '재시도';

  @override
  String get close => '닫기';

  @override
  String get ok => '확인';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String errorLoadingChats(String error) {
    return '채팅 로딩 실패: $error';
  }

  @override
  String get deleteChat => '채팅 삭제';

  @override
  String get deleteChatConfirmation => '이 채팅을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get chatDeleted => '채팅이 삭제되었습니다';

  @override
  String get yesterday => '어제';

  @override
  String daysAgo(int count) {
    return '$count일 전';
  }

  @override
  String get noMessages => '메시지 없음';

  @override
  String get noMessagesYet => '아직 메시지가 없습니다';

  @override
  String get chat => '채팅';

  @override
  String get typeMessage => '메시지 입력...';

  @override
  String get send => '보내기';

  @override
  String get regenerate => '재생성';

  @override
  String get continueGeneration => '계속';

  @override
  String get viewCharacter => '캐릭터 보기';

  @override
  String get authorsNote => '작성자 메모';

  @override
  String get bookmarks => '북마크';

  @override
  String get exportChat => '채팅 내보내기';

  @override
  String get importChat => '채팅 가져오기';

  @override
  String get clearMessages => '메시지 지우기';

  @override
  String get selectModel => '모델 선택';

  @override
  String get loadingModels => '모델 로딩 중...';

  @override
  String get noModelsAvailable => '사용 가능한 모델이 없습니다. API 설정을 확인하세요.';

  @override
  String modelChangedTo(String model) {
    return '모델이 $model(으)로 변경되었습니다';
  }

  @override
  String failedToLoadModels(String error) {
    return '모델 로딩 실패: $error';
  }

  @override
  String get searchModels => '모델 검색...';

  @override
  String get noModelsMatchSearch => '일치하는 모델이 없습니다';

  @override
  String get provider => '제공자';

  @override
  String get apiNotConfigured => 'API가 설정되지 않음';

  @override
  String get apiNotConfiguredMessage => '캐릭터와 채팅하려면 먼저 LLM 제공자를 설정해야 합니다.';

  @override
  String get supportedProviders => '지원되는 제공자:';

  @override
  String get configureNow => '지금 설정';

  @override
  String get later => '나중에';

  @override
  String get configure => '설정';

  @override
  String get configureApiProvider => '채팅을 시작하려면 LLM 제공자를 설정하세요';

  @override
  String get startConversation => '대화 시작';

  @override
  String get deleteMessage => '메시지 삭제';

  @override
  String get deleteMessageConfirmation => '이 메시지를 삭제하시겠습니까?';

  @override
  String get deleteMessages => '메시지 삭제';

  @override
  String get deleteMessagesConfirmation => '이 메시지와 이후의 모든 메시지를 삭제하시겠습니까?';

  @override
  String get deleteAll => '모두 삭제';

  @override
  String get copiedToClipboard => '클립보드에 복사됨';

  @override
  String get generateNewResponse => '새 응답 생성';

  @override
  String get continueFromHere => '여기서 계속';

  @override
  String get deleteMessagesAfterAndRegenerate => '이후 메시지를 삭제하고 응답 재생성';

  @override
  String get deleteMessagesAfterThis => '이 메시지 이후 모두 삭제';

  @override
  String get createBookmark => '북마크 만들기';

  @override
  String get saveAsCheckpoint => '이 지점을 체크포인트로 저장';

  @override
  String get deleteThisMessage => '이 메시지 삭제';

  @override
  String get deleteThisAndAllAfter => '이것과 이후 모두 삭제';

  @override
  String get attachImage => '이미지 첨부';

  @override
  String get chooseFromGallery => '갤러리에서 선택';

  @override
  String get takePhoto => '사진 촬영';

  @override
  String failedToPickImage(String error) {
    return '이미지 선택 실패: $error';
  }

  @override
  String failedToTakePhoto(String error) {
    return '사진 촬영 실패: $error';
  }

  @override
  String failedToAddAttachment(String error) {
    return '첨부 파일 추가 실패: $error';
  }

  @override
  String exportChatWith(String character) {
    return '$character와의 채팅 내보내기';
  }

  @override
  String messagesCount(int count) {
    return '$count개의 메시지';
  }

  @override
  String get chooseExportFormat => '내보내기 형식 선택:';

  @override
  String get json => 'JSON';

  @override
  String get jsonlStFormat => 'JSONL (ST 형식)';

  @override
  String get noChatToExport => '내보낼 채팅이 없습니다';

  @override
  String exportFailed(String error) {
    return '내보내기 실패: $error';
  }

  @override
  String get importChatHistory => '파일에서 채팅 기록을 가져옵니다.';

  @override
  String get supportedFormats => '지원 형식:';

  @override
  String get jsonlSillyTavernFormat => 'JSONL (SillyTavern 형식)';

  @override
  String get jsonNativeTavernFormat => 'JSON (NativeTavern 형식)';

  @override
  String get importNote => '참고: 가져온 메시지는 현재 채팅에 추가됩니다.';

  @override
  String get chooseFile => '파일 선택';

  @override
  String get noFileSelected => '파일이 선택되지 않았거나 형식이 잘못되었습니다';

  @override
  String get importConfirmation => '가져오기 확인';

  @override
  String get character => '캐릭터';

  @override
  String get user => '사용자';

  @override
  String get messages => '메시지';

  @override
  String get date => '날짜';

  @override
  String get hasAuthorsNote => '작성자 메모 있음';

  @override
  String get importMessagesToCurrentChat => '이 메시지들을 현재 채팅으로 가져오시겠습니까?';

  @override
  String get noActiveChat => '활성 채팅 없음';

  @override
  String importedMessages(int count) {
    return '$count개의 메시지를 가져왔습니다';
  }

  @override
  String importFailed(String error) {
    return '가져오기 실패: $error';
  }

  @override
  String get clearMessagesConfirmation => '모든 메시지를 지우시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get clear => '지우기';

  @override
  String get thinking => '생각 중';

  @override
  String get noSwipesAvailable => '스와이프 없음';

  @override
  String get system => '시스템';

  @override
  String get backgroundFeatureComingSoon => '배경 기능 곧 출시 예정';

  @override
  String get authorsNoteUpdated => '작성자 메모가 업데이트되었습니다';

  @override
  String get commandError => '명령 오류';

  @override
  String get enabled => '활성화됨';

  @override
  String get disabled => '비활성화됨';

  @override
  String get personas => '페르소나';

  @override
  String get createPersona => '페르소나 만들기';

  @override
  String get editPersona => '페르소나 편집';

  @override
  String get deletePersona => '페르소나 삭제';

  @override
  String deletePersonaConfirmation(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get noPersonasYet => '페르소나가 없습니다';

  @override
  String get createPersonaDescription => '채팅에서 자신을 나타낼 페르소나를 만드세요';

  @override
  String get name => '이름';

  @override
  String get enterPersonaName => '페르소나 이름 입력';

  @override
  String get description => '설명';

  @override
  String get describePersona => '이 페르소나 설명 (선택사항)';

  @override
  String get personaDescriptionHelp =>
      '설명은 시스템 프롬프트에 포함되어 AI가 당신을 이해하는 데 도움이 됩니다.';

  @override
  String get pleaseEnterName => '이름을 입력하세요';

  @override
  String get default_ => '기본';

  @override
  String get active => '활성';

  @override
  String get setAsDefault => '기본으로 설정';

  @override
  String get removeAvatar => '아바타 제거';

  @override
  String failedToSaveAvatar(String error) {
    return '아바타 저장 실패: $error';
  }

  @override
  String get selectAvatarImage => '아바타 이미지 선택';

  @override
  String get aiConfiguration => 'AI 설정';

  @override
  String get llmProvider => 'LLM 제공자';

  @override
  String get apiUrl => 'API URL';

  @override
  String get apiKey => 'API 키';

  @override
  String get model => '모델';

  @override
  String get temperature => '온도';

  @override
  String get maxTokens => '최대 토큰';

  @override
  String get topP => 'Top P';

  @override
  String get topK => 'Top K';

  @override
  String get frequencyPenalty => '빈도 페널티';

  @override
  String get presencePenalty => '존재 페널티';

  @override
  String get repetitionPenalty => '반복 페널티';

  @override
  String get streamingEnabled => '스트리밍 활성화';

  @override
  String get testConnection => '연결 테스트';

  @override
  String get connectionSuccessful => '연결 성공!';

  @override
  String connectionFailed(String error) {
    return '연결 실패: $error';
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
  String get local => '로컬';

  @override
  String get aiPresets => 'AI 프리셋';

  @override
  String get createPreset => '프리셋 만들기';

  @override
  String get editPreset => '프리셋 편집';

  @override
  String get deletePreset => '프리셋 삭제';

  @override
  String get presetName => '프리셋 이름';

  @override
  String get promptManager => '프롬프트 관리';

  @override
  String get systemPrompt => '시스템 프롬프트';

  @override
  String get jailbreak => '탈옥';

  @override
  String get worldInfo => '월드 정보';

  @override
  String get createEntry => '항목 만들기';

  @override
  String get editEntry => '항목 편집';

  @override
  String get deleteEntry => '항목 삭제';

  @override
  String get keywords => '키워드';

  @override
  String get content => '내용';

  @override
  String get priority => '우선순위';

  @override
  String get groups => '그룹';

  @override
  String get createGroup => '그룹 만들기';

  @override
  String get editGroup => '그룹 편집';

  @override
  String get deleteGroup => '그룹 삭제';

  @override
  String get groupName => '그룹 이름';

  @override
  String get members => '멤버';

  @override
  String get addMember => '멤버 추가';

  @override
  String get removeMember => '멤버 제거';

  @override
  String get tags => '태그';

  @override
  String get createTag => '태그 만들기';

  @override
  String get editTag => '태그 편집';

  @override
  String get deleteTag => '태그 삭제';

  @override
  String get tagName => '태그 이름';

  @override
  String get color => '색상';

  @override
  String get quickReplies => '빠른 답장';

  @override
  String get createQuickReply => '빠른 답장 만들기';

  @override
  String get editQuickReply => '빠른 답장 편집';

  @override
  String get deleteQuickReply => '빠른 답장 삭제';

  @override
  String get label => '라벨';

  @override
  String get message => '메시지';

  @override
  String get autoSend => '자동 전송';

  @override
  String get regex => '정규식';

  @override
  String get createRegex => '정규식 만들기';

  @override
  String get editRegex => '정규식 편집';

  @override
  String get deleteRegex => '정규식 삭제';

  @override
  String get pattern => '패턴';

  @override
  String get replacement => '대체';

  @override
  String get backup => '백업';

  @override
  String get createBackup => '백업 만들기';

  @override
  String get restoreBackup => '백업 복원';

  @override
  String get backupCreated => '백업이 생성되었습니다';

  @override
  String get backupRestored => '백업이 복원되었습니다';

  @override
  String backupFailed(String error) {
    return '백업 실패: $error';
  }

  @override
  String restoreFailed(String error) {
    return '복원 실패: $error';
  }

  @override
  String get theme => '테마';

  @override
  String get darkMode => '다크 모드';

  @override
  String get lightMode => '라이트 모드';

  @override
  String get systemTheme => '시스템 설정 따르기';

  @override
  String get primaryColor => '기본 색상';

  @override
  String get accentColor => '강조 색상';

  @override
  String get advanced => '고급';

  @override
  String get advancedSettings => '고급 설정';

  @override
  String get statistics => '통계';

  @override
  String get totalChats => '총 채팅 수';

  @override
  String get totalMessages => '총 메시지 수';

  @override
  String get totalCharacters => '총 캐릭터 수';

  @override
  String get tokenizer => '토크나이저';

  @override
  String get tts => '텍스트 음성 변환';

  @override
  String get stt => '음성 텍스트 변환';

  @override
  String get translation => '번역';

  @override
  String get imageGeneration => '이미지 생성';

  @override
  String get vectorStorage => '벡터 저장소';

  @override
  String get sprites => '스프라이트';

  @override
  String get backgrounds => '배경';

  @override
  String get cfgScale => 'CFG 스케일';

  @override
  String get logitBias => 'Logit 바이어스';

  @override
  String get variables => '변수';

  @override
  String get listView => '목록 보기';

  @override
  String get gridView => '그리드 보기';

  @override
  String get search => '검색';

  @override
  String get searchCharacters => '캐릭터 검색...';

  @override
  String get noCharactersFound => '캐릭터를 찾을 수 없습니다';

  @override
  String get noCharactersYet => '캐릭터가 없습니다';

  @override
  String get importCharacter => '캐릭터를 가져와서 시작하세요';

  @override
  String get createCharacter => '캐릭터 만들기';

  @override
  String get editCharacter => '캐릭터 편집';

  @override
  String get deleteCharacter => '캐릭터 삭제';

  @override
  String deleteCharacterConfirmation(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 이 캐릭터와의 모든 채팅도 삭제됩니다.';
  }

  @override
  String get characterDeleted => '캐릭터가 삭제되었습니다';

  @override
  String get startChat => '채팅 시작';

  @override
  String get personality => '성격';

  @override
  String get scenario => '시나리오';

  @override
  String get firstMessage => '첫 메시지';

  @override
  String get exampleDialogue => '예시 대화';

  @override
  String get creatorNotes => '제작자 메모';

  @override
  String get alternateGreetings => '대체 인사말';

  @override
  String get characterBook => '캐릭터 북';

  @override
  String get language => '언어';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get languageChanged => '언어가 변경되었습니다';

  @override
  String get about => '정보';

  @override
  String get version => '버전';

  @override
  String get licenses => '라이선스';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get feedback => '피드백';

  @override
  String get rateApp => '앱 평가';

  @override
  String get shareApp => '앱 공유';

  @override
  String get checkForUpdates => '업데이트 확인';

  @override
  String get noUpdatesAvailable => '사용 가능한 업데이트 없음';

  @override
  String get updateAvailable => '업데이트 가능';

  @override
  String get downloadUpdate => '업데이트 다운로드';

  @override
  String get bookmarkCreated => '북마크가 생성되었습니다';

  @override
  String get bookmarkName => '북마크 이름';

  @override
  String get enterBookmarkName => '북마크 이름 입력';

  @override
  String get noBookmarksYet => '북마크가 없습니다';

  @override
  String get createBookmarkDescription => '대화의 중요한 지점을 저장할 북마크를 만드세요';

  @override
  String get jumpToBookmark => '북마크로 이동';

  @override
  String get deleteBookmark => '북마크 삭제';

  @override
  String get bookmarkDeleted => '북마크가 삭제되었습니다';

  @override
  String get saveAsJsonl => 'JSONL로 저장';

  @override
  String get saveAsJson => 'JSON으로 저장';

  @override
  String get keyboardShortcuts => '키보드 단축키:';

  @override
  String get bold => '굵게';

  @override
  String get italic => '기울임';

  @override
  String get underline => '밑줄';

  @override
  String get strikethrough => '취소선';

  @override
  String get inlineCode => '인라인 코드';

  @override
  String get link => '링크';

  @override
  String get slashCommands => '슬래시 명령';

  @override
  String get availableCommands => '사용 가능한 명령:';

  @override
  String get commandHelp => '/ 를 입력하여 사용 가능한 명령 보기';
}
