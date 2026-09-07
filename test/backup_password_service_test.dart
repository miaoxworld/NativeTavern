import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/backup_password_service.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final service = BackupPasswordService(
    iterations: 1000,
    random: Random(42),
  );

  Uint8List sampleZip() {
    final archive = Archive()
      ..addFile(
        ArchiveFile('hello.txt', 5, utf8.encode('hello')),
      );
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  test('protectZip ciphertext does not contain the inner payload', () async {
    final inner = sampleZip();
    final protected = await service.protectZip(
      zipBytes: inner,
      password: 'correct-horse',
    );
    expect(utf8.decode(protected, allowMalformed: true), isNot(contains('hello')));
    final archive = ZipDecoder().decodeBytes(protected, verify: true);
    expect(BackupPasswordService.isProtectedArchive(archive), isTrue);
  });

  test('unlockZip restores the original zip with the right password', () async {
    final inner = sampleZip();
    final protected = await service.protectZip(
      zipBytes: inner,
      password: 'correct-horse',
    );
    final unlocked = await service.unlockZip(
      zipBytes: protected,
      password: 'correct-horse',
    );
    expect(unlocked, inner);
  });

  test('wrong password cannot unlock the backup', () async {
    final protected = await service.protectZip(
      zipBytes: sampleZip(),
      password: 'correct-horse',
    );
    expect(
      () => service.unlockZip(zipBytes: protected, password: 'wrong-horse'),
      throwsA(isA<BackupPasswordInvalidException>()),
    );
  });

  test('passwords shorter than 8 characters are rejected', () {
    expect(
      () => service.validatePassword('short'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('CloudBackupService encrypts and restores a password-protected ntx',
      () async {
    final documents =
        await Directory.systemTemp.createTemp('ntx_password_');
    addTearDown(() async {
      if (await documents.exists()) await documents.delete(recursive: true);
    });
    final cloud = CloudBackupService.forTesting(
      documentsDirectory: documents,
      backupPasswordService: service,
    );
    final dataFile = File('${documents.path}/data.ntb');
    await dataFile.writeAsString(jsonEncode({
      'version': 2,
      'app': 'NativeTavern',
      'data': {
        'characters': {
          'hero': {'id': 'hero', 'name': 'Hero'},
        },
      },
    }));
    final ntx = await cloud.packageCombinedBackup(
      dataFile: dataFile,
      password: 'correct-horse',
    );
    expect(await cloud.isPasswordProtectedBackup(ntx), isTrue);
    expect(
      () => cloud.importFromFile(ntx),
      throwsA(isA<BackupPasswordRequiredException>()),
    );
    expect(
      () => cloud.importFromFile(ntx, password: 'wrong-horse'),
      throwsA(isA<BackupPasswordInvalidException>()),
    );
    final imported = await cloud.importFromFile(
      ntx,
      password: 'correct-horse',
    );
    expect(
      ((imported['data'] as Map)['characters'] as Map)['hero']['name'],
      'Hero',
    );
  });
}
