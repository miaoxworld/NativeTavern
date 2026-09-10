import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/backup_import_selection.dart';

void main() {
  test('filterData drops collections the user chose to keep locally', () {
    const selection = BackupImportSelection(
      chats: false,
      lorebooks: true,
      moments: false,
      story: true,
      characters: true,
      settings: false,
      secrets: true,
    );
    final filtered = selection.filterData({
      'characters': {'a': 1},
      'chats': {'c': 1},
      'messages': {'m': 1},
      'worldInfos': {'w': 1},
      'momentPosts': {'p': 1},
      'storyChapters': {'s': 1},
      'llmConfigs': {'l': 1},
    });

    expect(filtered.containsKey('characters'), isTrue);
    expect(filtered.containsKey('chats'), isFalse);
    expect(filtered.containsKey('messages'), isFalse);
    expect(filtered.containsKey('worldInfos'), isTrue);
    expect(filtered.containsKey('momentPosts'), isFalse);
    expect(filtered.containsKey('storyChapters'), isTrue);
    expect(filtered.containsKey('llmConfigs'), isFalse);
  });

  test('CloudDeviceSettings overlays remote settings onto local library data',
      () {
    final merged = CloudDeviceSettings.overlayRemoteSettings(
      localData: {
        'chats': {'c': 1},
        'llmConfigs': {'local': 1},
        'globalStates': {'app_settings': 'local'},
      },
      remoteData: {
        'llmConfigs': {'remote': 1},
        'globalStates': {'app_settings': 'remote'},
      },
    );
    expect(merged['chats'], {'c': 1});
    expect(merged['llmConfigs'], {'remote': 1});
    expect(merged['globalStates'], {'app_settings': 'remote'});
  });

  test('CloudDeviceSettings strips settings from a payload', () {
    final stripped = CloudDeviceSettings.stripFromData({
      'chats': {'c': 1},
      'llmConfigs': {'local': 1},
      'globalStates': {'app_settings': 'local'},
    });
    expect(stripped.containsKey('chats'), isTrue);
    expect(stripped.containsKey('llmConfigs'), isFalse);
    expect(stripped.containsKey('globalStates'), isFalse);
  });
}
