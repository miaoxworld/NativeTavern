import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_models.dart';
import 'package:path/path.dart' as p;

/// Writes widget snapshots into the OS shared container and asks the
/// native widgets to reload.
class HomeWidgetPlatform {
  static const appleAppGroupId = 'group.com.miaomiaoxworld.nativetavern';
  static const appleAppGroupPlistKey = 'NTAppGroupId';
}

class HomeWidgetBridge {
  HomeWidgetBridge({
    MethodChannel? channel,
    bool Function()? supportedOverride,
  })  : _channel = channel ??
            const MethodChannel('com.nativetavern/home_widgets'),
        _supportedOverride = supportedOverride;

  static const androidProviders = <HomeWidgetKind, String>{
    HomeWidgetKind.moments: 'MomentsWidgetProvider',
    HomeWidgetKind.chats: 'ChatsWidgetProvider',
    HomeWidgetKind.characters: 'CharactersWidgetProvider',
    HomeWidgetKind.status: 'StatusWidgetProvider',
  };

  static const appleKindIds = <HomeWidgetKind, String>{
    HomeWidgetKind.moments: 'NativeTavernMomentsWidget',
    HomeWidgetKind.chats: 'NativeTavernChatsWidget',
    HomeWidgetKind.characters: 'NativeTavernCharactersWidget',
    HomeWidgetKind.status: 'NativeTavernStatusWidget',
  };

  final MethodChannel _channel;
  final bool Function()? _supportedOverride;

  bool get isSupported {
    final override = _supportedOverride;
    if (override != null) return override();
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isAndroid || Platform.isMacOS;
  }

  Future<String?> containerPath() async {
    if (!isSupported) return null;
    try {
      final path = await _channel.invokeMethod<String>('getContainerPath');
      return path;
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> publish(HomeWidgetSnapshot snapshot) async {
    if (!isSupported) return;
    final payload = jsonEncode(snapshot.toJson());
    try {
      await _channel.invokeMethod<void>('saveSnapshot', {
        'json': payload,
        'kinds': HomeWidgetKind.values.map((kind) => kind.name).toList(),
        'appleKindIds': {
          for (final entry in appleKindIds.entries) entry.key.name: entry.value,
        },
        'androidProviders': {
          for (final entry in androidProviders.entries)
            entry.key.name: entry.value,
        },
      });
      await _copyImages(snapshot);
      await _channel.invokeMethod<void>('reloadWidgets', {
        'appleKindIds': appleKindIds.values.toList(),
        'androidProviders': androidProviders.values.toList(),
      });
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<Uri?> takeLaunchUri() async {
    if (!isSupported) return null;
    try {
      final raw = await _channel.invokeMethod<String>('takeLaunchUri');
      if (raw == null || raw.isEmpty) return null;
      return Uri.tryParse(raw);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> _copyImages(HomeWidgetSnapshot snapshot) async {
    final container = await containerPath();
    if (container == null || container.isEmpty) return;
    final images = Directory(p.join(container, 'images'));
    if (!images.existsSync()) {
      images.createSync(recursive: true);
    }

    Future<void> copy(String? path, String name) async {
      if (path == null || path.isEmpty) return;
      final source = File(path);
      if (!source.existsSync()) return;
      final destination = File(p.join(images.path, name));
      await source.copy(destination.path);
    }

    for (final moment in snapshot.moments) {
      await copy(moment.image.path, 'moment_${moment.id}.img');
    }
    for (final character in snapshot.characters) {
      await copy(character.avatar.path, 'character_${character.id}.img');
    }
    for (final chat in snapshot.chats) {
      await copy(chat.avatar.path, 'chat_${chat.characterId}.img');
    }
  }
}
