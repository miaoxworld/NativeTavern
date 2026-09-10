import 'package:equatable/equatable.dart';

enum HomeWidgetKind { moments, chats, characters, status }

enum ChatSlideOrder { chronological, shuffled }

enum HomeWidgetDeepLinkTarget {
  home,
  moments,
  chat,
  character,
  aiConfig,
  settings,
}

class HomeWidgetSettings extends Equatable {
  static const slideIntervals = [5, 8, 12, 20, 30];
  static const messagesPerChatOptions = [1, 2, 3, 5];
  static const Object _noChange = Object();

  final bool enabled;
  final ChatSlideOrder chatOrder;
  final int messagesPerChat;
  final int slideIntervalSeconds;
  final int recentChatLimit;
  final int characterLimit;
  final int momentLimit;
  final bool favoritesOnlyCharacters;
  final bool favoriteChatsOnly;
  final String? pinnedCharacterId;
  final bool refreshRemoteUsage;

  const HomeWidgetSettings({
    this.enabled = true,
    this.chatOrder = ChatSlideOrder.chronological,
    this.messagesPerChat = 3,
    this.slideIntervalSeconds = 8,
    this.recentChatLimit = 8,
    this.characterLimit = 16,
    this.momentLimit = 10,
    this.favoritesOnlyCharacters = false,
    this.favoriteChatsOnly = false,
    this.pinnedCharacterId,
    this.refreshRemoteUsage = true,
  });

  HomeWidgetSettings copyWith({
    bool? enabled,
    ChatSlideOrder? chatOrder,
    int? messagesPerChat,
    int? slideIntervalSeconds,
    int? recentChatLimit,
    int? characterLimit,
    int? momentLimit,
    bool? favoritesOnlyCharacters,
    bool? favoriteChatsOnly,
    Object? pinnedCharacterId = _noChange,
    bool? refreshRemoteUsage,
  }) {
    return HomeWidgetSettings(
      enabled: enabled ?? this.enabled,
      chatOrder: chatOrder ?? this.chatOrder,
      messagesPerChat: messagesPerChat ?? this.messagesPerChat,
      slideIntervalSeconds: slideIntervalSeconds ?? this.slideIntervalSeconds,
      recentChatLimit: recentChatLimit ?? this.recentChatLimit,
      characterLimit: characterLimit ?? this.characterLimit,
      momentLimit: momentLimit ?? this.momentLimit,
      favoritesOnlyCharacters:
          favoritesOnlyCharacters ?? this.favoritesOnlyCharacters,
      favoriteChatsOnly: favoriteChatsOnly ?? this.favoriteChatsOnly,
      pinnedCharacterId: identical(pinnedCharacterId, _noChange)
          ? this.pinnedCharacterId
          : pinnedCharacterId as String?,
      refreshRemoteUsage: refreshRemoteUsage ?? this.refreshRemoteUsage,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'chatOrder': chatOrder.name,
        'messagesPerChat': messagesPerChat,
        'slideIntervalSeconds': slideIntervalSeconds,
        'recentChatLimit': recentChatLimit,
        'characterLimit': characterLimit,
        'momentLimit': momentLimit,
        'favoritesOnlyCharacters': favoritesOnlyCharacters,
        'favoriteChatsOnly': favoriteChatsOnly,
        if (pinnedCharacterId != null && pinnedCharacterId!.isNotEmpty)
          'pinnedCharacterId': pinnedCharacterId,
        'refreshRemoteUsage': refreshRemoteUsage,
      };

  factory HomeWidgetSettings.fromJson(Map<String, dynamic> json) {
    final pin = json['pinnedCharacterId'] as String?;
    return HomeWidgetSettings(
      enabled: json['enabled'] as bool? ?? true,
      chatOrder: ChatSlideOrder.values.firstWhere(
        (value) => value.name == json['chatOrder'],
        orElse: () => ChatSlideOrder.chronological,
      ),
      messagesPerChat: _clampInt(
        json['messagesPerChat'] as int?,
        messagesPerChatOptions,
        3,
      ),
      slideIntervalSeconds: _clampInt(
        json['slideIntervalSeconds'] as int?,
        slideIntervals,
        8,
      ),
      recentChatLimit: (json['recentChatLimit'] as int?)?.clamp(1, 20) ?? 8,
      characterLimit: (json['characterLimit'] as int?)?.clamp(1, 40) ?? 16,
      momentLimit: (json['momentLimit'] as int?)?.clamp(1, 20) ?? 10,
      favoritesOnlyCharacters:
          json['favoritesOnlyCharacters'] as bool? ?? false,
      favoriteChatsOnly: json['favoriteChatsOnly'] as bool? ?? false,
      pinnedCharacterId: (pin == null || pin.isEmpty) ? null : pin,
      refreshRemoteUsage: json['refreshRemoteUsage'] as bool? ?? true,
    );
  }

  static int _clampInt(int? value, List<int> allowed, int fallback) {
    if (value != null && allowed.contains(value)) return value;
    return fallback;
  }

  @override
  List<Object?> get props => [
        enabled,
        chatOrder,
        messagesPerChat,
        slideIntervalSeconds,
        recentChatLimit,
        characterLimit,
        momentLimit,
        favoritesOnlyCharacters,
        favoriteChatsOnly,
        pinnedCharacterId,
        refreshRemoteUsage,
      ];
}

/// Colors copied from the in-app theme so native widgets can match chrome.
class HomeWidgetTheme extends Equatable {
  final bool isDark;
  final String primary;
  final String accent;
  final String background;
  final String surface;
  final String card;
  final String textPrimary;
  final String textSecondary;

  const HomeWidgetTheme({
    required this.isDark,
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
  });

  static const nativetavernDark = HomeWidgetTheme(
    isDark: true,
    primary: '#6366F1',
    accent: '#8B5CF6',
    background: '#0F0F0F',
    surface: '#1A1A1A',
    card: '#262626',
    textPrimary: '#FFFFFF',
    textSecondary: '#A3A3A3',
  );

  Map<String, dynamic> toJson() => {
        'isDark': isDark,
        'primary': primary,
        'accent': accent,
        'background': background,
        'surface': surface,
        'card': card,
        'textPrimary': textPrimary,
        'textSecondary': textSecondary,
      };

  factory HomeWidgetTheme.fromJson(Map<String, dynamic>? json) {
    if (json == null) return nativetavernDark;
    return HomeWidgetTheme(
      isDark: json['isDark'] as bool? ?? nativetavernDark.isDark,
      primary: json['primary'] as String? ?? nativetavernDark.primary,
      accent: json['accent'] as String? ?? nativetavernDark.accent,
      background: json['background'] as String? ?? nativetavernDark.background,
      surface: json['surface'] as String? ?? nativetavernDark.surface,
      card: json['card'] as String? ?? nativetavernDark.card,
      textPrimary: json['textPrimary'] as String? ?? nativetavernDark.textPrimary,
      textSecondary:
          json['textSecondary'] as String? ?? nativetavernDark.textSecondary,
    );
  }

  @override
  List<Object?> get props => [
        isDark,
        primary,
        accent,
        background,
        surface,
        card,
        textPrimary,
        textSecondary,
      ];
}

/// User-visible strings baked into the snapshot so native widgets never
/// hardcode English.
class HomeWidgetLabels extends Equatable {
  final String moments;
  final String chats;
  final String characters;
  final String status;
  final String emptyMoments;
  final String emptyChats;
  final String emptyCharacters;
  final String openApp;
  final String providerReady;
  final String providerNeedsKey;
  final String providerLocal;
  final String providerUnreachable;
  final String tokensToday;
  final String tokensTotal;
  final String currentModel;
  final String remoteCredits;
  final String remoteUnsupported;
  final String updated;
  final String previous;
  final String next;

  const HomeWidgetLabels({
    required this.moments,
    required this.chats,
    required this.characters,
    required this.status,
    required this.emptyMoments,
    required this.emptyChats,
    required this.emptyCharacters,
    required this.openApp,
    required this.providerReady,
    required this.providerNeedsKey,
    required this.providerLocal,
    required this.providerUnreachable,
    required this.tokensToday,
    required this.tokensTotal,
    required this.currentModel,
    required this.remoteCredits,
    required this.remoteUnsupported,
    required this.updated,
    required this.previous,
    required this.next,
  });

  static const english = HomeWidgetLabels(
    moments: 'Moments',
    chats: 'Chats',
    characters: 'Characters',
    status: 'Status',
    emptyMoments: 'Nobody has posted yet.',
    emptyChats: 'No chats yet.',
    emptyCharacters: 'No characters yet.',
    openApp: 'Open NativeTavern',
    providerReady: 'Ready',
    providerNeedsKey: 'API key needed',
    providerLocal: 'Local',
    providerUnreachable: 'Unreachable',
    tokensToday: 'Today',
    tokensTotal: 'Total',
    currentModel: 'Model',
    remoteCredits: 'Credits',
    remoteUnsupported: 'Tracked locally',
    updated: 'Updated',
    previous: 'Previous',
    next: 'Next',
  );

  Map<String, dynamic> toJson() => {
        'moments': moments,
        'chats': chats,
        'characters': characters,
        'status': status,
        'emptyMoments': emptyMoments,
        'emptyChats': emptyChats,
        'emptyCharacters': emptyCharacters,
        'openApp': openApp,
        'providerReady': providerReady,
        'providerNeedsKey': providerNeedsKey,
        'providerLocal': providerLocal,
        'providerUnreachable': providerUnreachable,
        'tokensToday': tokensToday,
        'tokensTotal': tokensTotal,
        'currentModel': currentModel,
        'remoteCredits': remoteCredits,
        'remoteUnsupported': remoteUnsupported,
        'updated': updated,
        'previous': previous,
        'next': next,
      };

  factory HomeWidgetLabels.fromJson(Map<String, dynamic> json) {
    return HomeWidgetLabels(
      moments: json['moments'] as String? ?? english.moments,
      chats: json['chats'] as String? ?? english.chats,
      characters: json['characters'] as String? ?? english.characters,
      status: json['status'] as String? ?? english.status,
      emptyMoments: json['emptyMoments'] as String? ?? english.emptyMoments,
      emptyChats: json['emptyChats'] as String? ?? english.emptyChats,
      emptyCharacters:
          json['emptyCharacters'] as String? ?? english.emptyCharacters,
      openApp: json['openApp'] as String? ?? english.openApp,
      providerReady: json['providerReady'] as String? ?? english.providerReady,
      providerNeedsKey:
          json['providerNeedsKey'] as String? ?? english.providerNeedsKey,
      providerLocal: json['providerLocal'] as String? ?? english.providerLocal,
      providerUnreachable: json['providerUnreachable'] as String? ??
          english.providerUnreachable,
      tokensToday: json['tokensToday'] as String? ?? english.tokensToday,
      tokensTotal: json['tokensTotal'] as String? ?? english.tokensTotal,
      currentModel: json['currentModel'] as String? ?? english.currentModel,
      remoteCredits: json['remoteCredits'] as String? ?? english.remoteCredits,
      remoteUnsupported:
          json['remoteUnsupported'] as String? ?? english.remoteUnsupported,
      updated: json['updated'] as String? ?? english.updated,
      previous: json['previous'] as String? ?? english.previous,
      next: json['next'] as String? ?? english.next,
    );
  }

  @override
  List<Object?> get props => toJson().values.toList();
}

class HomeWidgetImageRef extends Equatable {
  final String? path;
  final String? fileName;

  const HomeWidgetImageRef({this.path, this.fileName});

  Map<String, dynamic> toJson() => {
        if (path != null) 'path': path,
        if (fileName != null) 'fileName': fileName,
      };

  factory HomeWidgetImageRef.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const HomeWidgetImageRef();
    return HomeWidgetImageRef(
      path: json['path'] as String?,
      fileName: json['fileName'] as String?,
    );
  }

  @override
  List<Object?> get props => [path, fileName];
}

class MomentWidgetItem extends Equatable {
  final String id;
  final String authorName;
  final String body;
  final DateTime createdAt;
  final HomeWidgetImageRef image;
  final String deepLink;

  const MomentWidgetItem({
    required this.id,
    required this.authorName,
    required this.body,
    required this.createdAt,
    this.image = const HomeWidgetImageRef(),
    required this.deepLink,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorName': authorName,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'image': image.toJson(),
        'deepLink': deepLink,
      };

  factory MomentWidgetItem.fromJson(Map<String, dynamic> json) {
    return MomentWidgetItem(
      id: json['id'] as String,
      authorName: json['authorName'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      image: HomeWidgetImageRef.fromJson(json['image'] as Map<String, dynamic>?),
      deepLink: json['deepLink'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, authorName, body, createdAt, image, deepLink];
}

class ChatWidgetSlide extends Equatable {
  final String chatId;
  final String characterId;
  final String characterName;
  final String title;
  final String role;
  final String body;
  final DateTime timestamp;
  final int messageIndex;
  final int messageCount;
  final HomeWidgetImageRef avatar;
  final String deepLink;

  const ChatWidgetSlide({
    required this.chatId,
    required this.characterId,
    required this.characterName,
    required this.title,
    required this.role,
    required this.body,
    required this.timestamp,
    required this.messageIndex,
    required this.messageCount,
    this.avatar = const HomeWidgetImageRef(),
    required this.deepLink,
  });

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'characterId': characterId,
        'characterName': characterName,
        'title': title,
        'role': role,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'messageIndex': messageIndex,
        'messageCount': messageCount,
        'avatar': avatar.toJson(),
        'deepLink': deepLink,
      };

  factory ChatWidgetSlide.fromJson(Map<String, dynamic> json) {
    return ChatWidgetSlide(
      chatId: json['chatId'] as String,
      characterId: json['characterId'] as String? ?? '',
      characterName: json['characterName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      role: json['role'] as String? ?? 'assistant',
      body: json['body'] as String? ?? '',
      timestamp: DateTime.parse(json['timestamp'] as String),
      messageIndex: json['messageIndex'] as int? ?? 0,
      messageCount: json['messageCount'] as int? ?? 1,
      avatar:
          HomeWidgetImageRef.fromJson(json['avatar'] as Map<String, dynamic>?),
      deepLink: json['deepLink'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        chatId,
        characterId,
        characterName,
        title,
        role,
        body,
        timestamp,
        messageIndex,
        messageCount,
        avatar,
        deepLink,
      ];
}

class CharacterWidgetItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool isFavorite;
  final HomeWidgetImageRef avatar;
  final String deepLink;

  const CharacterWidgetItem({
    required this.id,
    required this.name,
    required this.description,
    this.isFavorite = false,
    this.avatar = const HomeWidgetImageRef(),
    required this.deepLink,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'isFavorite': isFavorite,
        'avatar': avatar.toJson(),
        'deepLink': deepLink,
      };

  factory CharacterWidgetItem.fromJson(Map<String, dynamic> json) {
    return CharacterWidgetItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      avatar:
          HomeWidgetImageRef.fromJson(json['avatar'] as Map<String, dynamic>?),
      deepLink: json['deepLink'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, isFavorite, avatar, deepLink];
}

enum HomeWidgetProviderHealth { ready, needsKey, local, unreachable }

class StatusWidgetPayload extends Equatable {
  final String provider;
  final String providerLabel;
  final String model;
  final HomeWidgetProviderHealth health;
  final int tokensToday;
  final int tokensTotal;
  final int generationsToday;
  final double? costUsdToday;
  final double? remoteRemaining;
  final String? remoteUnit;
  final String? remoteDetail;
  final bool remoteSupported;
  final String deepLink;

  const StatusWidgetPayload({
    required this.provider,
    required this.providerLabel,
    required this.model,
    required this.health,
    this.tokensToday = 0,
    this.tokensTotal = 0,
    this.generationsToday = 0,
    this.costUsdToday,
    this.remoteRemaining,
    this.remoteUnit,
    this.remoteDetail,
    this.remoteSupported = false,
    required this.deepLink,
  });

  Map<String, dynamic> toJson() => {
        'provider': provider,
        'providerLabel': providerLabel,
        'model': model,
        'health': health.name,
        'tokensToday': tokensToday,
        'tokensTotal': tokensTotal,
        'generationsToday': generationsToday,
        if (costUsdToday != null) 'costUsdToday': costUsdToday,
        if (remoteRemaining != null) 'remoteRemaining': remoteRemaining,
        if (remoteUnit != null) 'remoteUnit': remoteUnit,
        if (remoteDetail != null) 'remoteDetail': remoteDetail,
        'remoteSupported': remoteSupported,
        'deepLink': deepLink,
      };

  factory StatusWidgetPayload.fromJson(Map<String, dynamic> json) {
    return StatusWidgetPayload(
      provider: json['provider'] as String? ?? '',
      providerLabel: json['providerLabel'] as String? ?? '',
      model: json['model'] as String? ?? '',
      health: HomeWidgetProviderHealth.values.firstWhere(
        (value) => value.name == json['health'],
        orElse: () => HomeWidgetProviderHealth.needsKey,
      ),
      tokensToday: json['tokensToday'] as int? ?? 0,
      tokensTotal: json['tokensTotal'] as int? ?? 0,
      generationsToday: json['generationsToday'] as int? ?? 0,
      costUsdToday: (json['costUsdToday'] as num?)?.toDouble(),
      remoteRemaining: (json['remoteRemaining'] as num?)?.toDouble(),
      remoteUnit: json['remoteUnit'] as String?,
      remoteDetail: json['remoteDetail'] as String?,
      remoteSupported: json['remoteSupported'] as bool? ?? false,
      deepLink: json['deepLink'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        provider,
        providerLabel,
        model,
        health,
        tokensToday,
        tokensTotal,
        generationsToday,
        costUsdToday,
        remoteRemaining,
        remoteUnit,
        remoteDetail,
        remoteSupported,
        deepLink,
      ];
}

class HomeWidgetSnapshot extends Equatable {
  static const schemaVersion = 2;

  final int version;
  final DateTime updatedAt;
  final String locale;
  final HomeWidgetSettings settings;
  final HomeWidgetLabels labels;
  final HomeWidgetTheme theme;
  final List<MomentWidgetItem> moments;
  final List<ChatWidgetSlide> chats;
  final List<CharacterWidgetItem> characters;
  final StatusWidgetPayload status;

  const HomeWidgetSnapshot({
    this.version = schemaVersion,
    required this.updatedAt,
    required this.locale,
    required this.settings,
    required this.labels,
    this.theme = HomeWidgetTheme.nativetavernDark,
    this.moments = const [],
    this.chats = const [],
    this.characters = const [],
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'updatedAt': updatedAt.toIso8601String(),
        'locale': locale,
        'settings': settings.toJson(),
        'labels': labels.toJson(),
        'theme': theme.toJson(),
        'moments': moments.map((item) => item.toJson()).toList(),
        'chats': chats.map((item) => item.toJson()).toList(),
        'characters': characters.map((item) => item.toJson()).toList(),
        'status': status.toJson(),
      };

  factory HomeWidgetSnapshot.fromJson(Map<String, dynamic> json) {
    return HomeWidgetSnapshot(
      version: json['version'] as int? ?? schemaVersion,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      locale: json['locale'] as String? ?? 'en',
      settings: HomeWidgetSettings.fromJson(
        json['settings'] as Map<String, dynamic>? ?? const {},
      ),
      labels: HomeWidgetLabels.fromJson(
        json['labels'] as Map<String, dynamic>? ?? const {},
      ),
      theme: HomeWidgetTheme.fromJson(
        json['theme'] as Map<String, dynamic>?,
      ),
      moments: (json['moments'] as List<dynamic>? ?? const [])
          .map((item) => MomentWidgetItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      chats: (json['chats'] as List<dynamic>? ?? const [])
          .map((item) => ChatWidgetSlide.fromJson(item as Map<String, dynamic>))
          .toList(),
      characters: (json['characters'] as List<dynamic>? ?? const [])
          .map((item) =>
              CharacterWidgetItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: StatusWidgetPayload.fromJson(
        json['status'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  @override
  List<Object?> get props => [
        version,
        updatedAt,
        locale,
        settings,
        labels,
        theme,
        moments,
        chats,
        characters,
        status,
      ];
}

class HomeWidgetDeepLink extends Equatable {
  static const scheme = 'nativetavern';
  static const host = 'widget';

  final HomeWidgetDeepLinkTarget target;
  final String? id;
  final HomeWidgetKind? kind;

  const HomeWidgetDeepLink({
    required this.target,
    this.id,
    this.kind,
  });

  Uri toUri() {
    return Uri(
      scheme: scheme,
      host: host,
      path: '/${target.name}',
      queryParameters: {
        if (id != null && id!.isNotEmpty) 'id': id,
        if (kind != null) 'kind': kind!.name,
      },
    );
  }

  static HomeWidgetDeepLink? tryParse(Uri uri) {
    if (uri.scheme != scheme) return null;
    if (uri.host.isNotEmpty && uri.host != host) return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) {
      return const HomeWidgetDeepLink(target: HomeWidgetDeepLinkTarget.home);
    }
    final target = HomeWidgetDeepLinkTarget.values.where(
      (value) => value.name == segments.first,
    );
    if (target.isEmpty) {
      return const HomeWidgetDeepLink(target: HomeWidgetDeepLinkTarget.home);
    }
    final kindName = uri.queryParameters['kind'];
    return HomeWidgetDeepLink(
      target: target.first,
      id: uri.queryParameters['id'],
      kind: HomeWidgetKind.values
          .where((value) => value.name == kindName)
          .firstOrNull,
    );
  }

  String get location {
    return switch (target) {
      HomeWidgetDeepLinkTarget.home => '/',
      HomeWidgetDeepLinkTarget.moments => '/play/moments',
      HomeWidgetDeepLinkTarget.chat =>
        id == null || id!.isEmpty ? '/' : '/chat/$id',
      HomeWidgetDeepLinkTarget.character =>
        id == null || id!.isEmpty ? '/characters' : '/characters/$id',
      HomeWidgetDeepLinkTarget.aiConfig => '/ai-config',
      HomeWidgetDeepLinkTarget.settings => '/settings/home-widgets',
    };
  }

  @override
  List<Object?> get props => [target, id, kind];
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
