import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/file_export_service.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory documents;

  setUp(() async {
    documents = await Directory.systemTemp.createTemp('native_tavern_export_');
  });

  tearDown(() async {
    if (await documents.exists()) await documents.delete(recursive: true);
  });

  test('cloud backup names match the iCloud naming scheme', () {
    final name = FileExportService.cloudBackupFileName(
      extension: 'ntx',
      now: DateTime(2026, 9, 1, 12, 30, 5),
    );
    expect(name, 'NativeTavern_cloud_backup_2026-09-01_12-30-05.ntx');
  });

  test('copies backups into NativeTavern/Backups', () async {
    final service = FileExportService.forTesting(
      documentsDirectory: documents,
    );
    final source = File(p.join(documents.path, 'source.ntx'));
    await source.writeAsBytes([1, 2, 3]);

    final copied = await service.copyToAppBackups(
      source,
      fileName: FileExportService.cloudBackupFileName(
        extension: 'ntx',
        now: DateTime(2026, 9, 1, 8, 0, 0),
      ),
    );

    expect(
      copied.path,
      p.join(
        documents.path,
        'NativeTavern',
        'Backups',
        'NativeTavern_cloud_backup_2026-09-01_08-00-00.ntx',
      ),
    );
    expect(await copied.readAsBytes(), [1, 2, 3]);
  });

  test('chosen-folder save does not copy into NativeTavern/Backups', () async {
    final service = FileExportService.forTesting(
      documentsDirectory: documents,
    );
    final source = File(p.join(documents.path, 'source.ntx'));
    await source.writeAsBytes([1, 2, 3]);
    final chosen = File(p.join(documents.path, 'picked', 'export.ntx'));
    await chosen.parent.create(recursive: true);
    await chosen.writeAsBytes([1, 2, 3]);

    final outcome = await service.resolveBackupExport(
      source: source,
      fileName: 'NativeTavern_cloud_backup_2026-09-01_08-00-00.ntx',
      chosenFile: chosen,
    );

    expect(outcome.savedToFilesApp, isTrue);
    expect(outcome.savedToAppBackups, isFalse);
    expect(outcome.cancelled, isFalse);
    expect(
      Directory(p.join(documents.path, 'NativeTavern', 'Backups')).existsSync(),
      isFalse,
    );
  });

  test('user cancel does not copy into NativeTavern/Backups', () async {
    final service = FileExportService.forTesting(
      documentsDirectory: documents,
    );
    final source = File(p.join(documents.path, 'source.ntx'));
    await source.writeAsBytes([1, 2, 3]);

    final outcome = await service.resolveBackupExport(
      source: source,
      fileName: 'NativeTavern_cloud_backup_2026-09-01_08-00-00.ntx',
    );

    expect(outcome.cancelled, isTrue);
    expect(outcome.succeeded, isFalse);
    expect(
      Directory(p.join(documents.path, 'NativeTavern', 'Backups')).existsSync(),
      isFalse,
    );
  });

  test('falls back to NativeTavern/Backups when chosen-folder save fails',
      () async {
    final service = FileExportService.forTesting(
      documentsDirectory: documents,
    );
    final source = File(p.join(documents.path, 'source.ntx'));
    await source.writeAsBytes([1, 2, 3]);
    const fileName = 'NativeTavern_cloud_backup_2026-09-01_08-00-00.ntx';

    final outcome = await service.resolveBackupExport(
      source: source,
      fileName: fileName,
      saveError: StateError('Files picker unavailable'),
    );

    expect(outcome.savedToFilesApp, isFalse);
    expect(outcome.savedToAppBackups, isTrue);
    expect(
      outcome.appBackupFile!.path,
      p.join(documents.path, 'NativeTavern', 'Backups', fileName),
    );
    expect(await outcome.appBackupFile!.readAsBytes(), [1, 2, 3]);
  });
}
