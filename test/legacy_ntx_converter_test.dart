import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/domain/services/legacy_ntx_converter.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory documents;

  setUp(() async {
    documents = await Directory.systemTemp.createTemp('ntx_convert_');
  });

  tearDown(() async {
    if (await documents.exists()) await documents.delete(recursive: true);
  });

  test('merges ntb and ntm into ntx', () async {
    final ntb = File(p.join(documents.path, 'legacy.ntb'));
    await ntb.writeAsString(jsonEncode({
      'version': 2,
      'app': 'NativeTavern',
      'data': {
        'characters': {
          'legacy': {'id': 'legacy'}
        },
      },
    }));
    final ntm = File(p.join(documents.path, 'legacy.ntm'));
    await ntm.writeAsBytes([1, 2, 3, 4]);

    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final converted = await LegacyNtxConverter(cloudBackupService: service)
        .convert(dataFile: ntb, mediaFile: ntm);

    expect(converted.path, endsWith('.ntx'));
    final names = ZipDecoder()
        .decodeBytes(await converted.readAsBytes())
        .files
        .where((file) => file.isFile)
        .map((file) => file.name)
        .toSet();
    expect(names, containsAll(['manifest.json', 'data.ntb', 'media.ntm']));
  });

  test('direct ntb import is rejected after conversion-only policy', () async {
    final ntb = File(p.join(documents.path, 'legacy.ntb'));
    await ntb.writeAsString(jsonEncode({
      'version': 2,
      'app': 'NativeTavern',
      'data': {'characters': {}},
    }));
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    expect(
      () => service.importFromFile(ntb),
      throwsA(isA<Exception>()),
    );
  });
}
