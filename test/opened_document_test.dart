import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/opened_document.dart';

void main() {
  test('detects backup files opened from the Files app', () {
    expect(OpenedDocument.isBackupPath('/tmp/NativeTavern_sync.ntx'), isTrue);
    expect(OpenedDocument.isBackupPath('chat.jsonl'), isFalse);
    expect(
      OpenedDocument.isExternalDocumentUri(
        Uri.parse('file:///private/var/mobile/Containers/Data/backup.ntx'),
      ),
      isTrue,
    );
    expect(
      OpenedDocument.isExternalDocumentUri(
        Uri.parse('/private/var/mobile/Containers/Data/Application/backup.ntb'),
      ),
      isTrue,
    );
    expect(
      OpenedDocument.isExternalDocumentUri(Uri.parse('/cloud-backup-settings')),
      isFalse,
    );
    expect(
      OpenedDocument.isExternalDocumentUri(Uri.parse('/settings')),
      isFalse,
    );
  });
}
