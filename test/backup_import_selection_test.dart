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
}
