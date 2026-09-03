import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory documents;

  setUp(() async {
    documents = await Directory.systemTemp.createTemp('native_tavern_cloud_');
    SharedPreferences.setMockInitialValues({
      'quick_reply_config': jsonEncode({
        'items': ['hello'],
        'apiKey': 'nested-secret',
      }),
      'provider_api_key': 'top-level-secret',
      'locale': 'zh',
    });
  });

  tearDown(() async {
    if (await documents.exists()) await documents.delete(recursive: true);
  });

  test('default backup stays a standalone JSON file and removes secrets',
      () async {
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final artifacts = await service.createCloudBackupArtifacts(
      data: {
        'llmConfigs': {
          'config': {
            'id': 'config',
            'apiKey': 'database-secret',
            'name': 'Local config',
          },
        },
      },
      provider: CloudProvider.googleDrive,
    );

    expect(artifacts.mediaFile, isNull);
    final package = jsonDecode(await artifacts.dataFile.readAsString()) as Map;
    expect(package['version'], 2);
    expect(package.containsKey('media'), isFalse);
    expect(jsonEncode(package), isNot(contains('database-secret')));
    expect(jsonEncode(package), isNot(contains('nested-secret')));
    expect(jsonEncode(package), isNot(contains('top-level-secret')));
    expect((package['preferences'] as Map)['locale'], 'zh');
  });

  test('media switches include whole categories without mixing categories',
      () async {
    final nativeData = Directory(p.join(documents.path, 'NativeTavern'));
    final avatar = File(p.join(nativeData.path, 'avatars', 'card.png'));
    final worldImage = File(p.join(nativeData.path, 'worlds', 'map.png'));
    await avatar.parent.create(recursive: true);
    await worldImage.parent.create(recursive: true);
    await avatar.writeAsBytes([1, 2, 3]);
    await worldImage.writeAsBytes([4, 5, 6]);

    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final artifacts = await service.createCloudBackupArtifacts(
      data: {
        'worldInfoEntries': {
          'entry': {
            'extensionsJson': jsonEncode({'image': worldImage.path})
          },
        },
      },
      provider: CloudProvider.iCloud,
      options: const CloudBackupOptions(
        mediaCategories: {CloudMediaCategory.characterImages},
      ),
    );

    final names = _archiveNames(await artifacts.mediaFile!.readAsBytes());
    expect(names, contains('files/nativeData/avatars/card.png'));
    expect(names, isNot(contains('files/nativeData/worlds/map.png')));
  });

  test('backup artifact progress reports scan, compression count, and write',
      () async {
    final avatar = File(
      p.join(documents.path, 'NativeTavern', 'avatars', 'card.png'),
    );
    await avatar.parent.create(recursive: true);
    await avatar.writeAsBytes([1, 2, 3]);
    final updates = <CloudBackupArtifactProgress>[];
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );

    await service.createCloudBackupArtifacts(
      data: const <String, dynamic>{},
      provider: CloudProvider.googleDrive,
      options: const CloudBackupOptions(
        mediaCategories: {CloudMediaCategory.characterImages},
      ),
      onProgress: updates.add,
    );

    expect(updates.first.stage, CloudBackupArtifactStage.scanningMedia);
    final compression = updates
        .where((update) =>
            update.stage == CloudBackupArtifactStage.compressingMedia)
        .toList();
    expect(compression.last.processedFiles, 1);
    expect(compression.last.totalFiles, 1);
    expect(updates.last.stage, CloudBackupArtifactStage.writingData);
  });

  test('world book switch includes all referenced local world book images',
      () async {
    final image = File(
      p.join(documents.path, 'NativeTavern', 'worlds', 'location.webp'),
    );
    await image.parent.create(recursive: true);
    await image.writeAsBytes([7, 8, 9]);
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final artifacts = await service.createCloudBackupArtifacts(
      data: {
        'worldInfos': {
          'world': {
            'extensionsJson': jsonEncode({'imagePath': image.path})
          },
        },
      },
      provider: CloudProvider.googleDrive,
      options: const CloudBackupOptions(
        mediaCategories: {CloudMediaCategory.worldInfoImages},
      ),
    );

    expect(
      _archiveNames(await artifacts.mediaFile!.readAsBytes()),
      contains('files/nativeData/worlds/location.webp'),
    );
  });

  test('media restore recreates paths in a new app sandbox', () async {
    final oldAvatar = File(
      p.join(documents.path, 'NativeTavern', 'avatars', 'card.png'),
    );
    await oldAvatar.parent.create(recursive: true);
    await oldAvatar.writeAsBytes([10, 11, 12]);
    final sourceService = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final artifacts = await sourceService.createCloudBackupArtifacts(
      data: {
        'characters': {
          'card': {'id': 'card', 'avatarPath': oldAvatar.path},
        },
      },
      provider: CloudProvider.iCloud,
      options: const CloudBackupOptions(
        mediaCategories: {CloudMediaCategory.characterImages},
      ),
    );
    final package = jsonDecode(await artifacts.dataFile.readAsString())
        as Map<String, dynamic>;

    final targetDocuments = await Directory.systemTemp.createTemp(
      'native_tavern_cloud_target_',
    );
    addTearDown(() async {
      if (await targetDocuments.exists()) {
        await targetDocuments.delete(recursive: true);
      }
    });
    final targetService = CloudBackupService.forTesting(
      documentsDirectory: targetDocuments,
    );
    final progress = <(int, int)>[];
    final outcome = await targetService.restoreMediaFile(
      backupPackage: package,
      mediaFile: artifacts.mediaFile!,
      onProgress: (processed, total) => progress.add((processed, total)),
    );

    final restored = File(
      p.join(targetDocuments.path, 'NativeTavern', 'avatars', 'card.png'),
    );
    expect(await restored.readAsBytes(), [10, 11, 12]);
    final character = ((outcome.backupPackage['data'] as Map)['characters']
        as Map)['card'] as Map;
    expect(character['avatarPath'], restored.path);
    expect(outcome.skippedFiles, 0);
    expect(progress, [(0, 1), (1, 1)]);
  });

  test('unsafe media paths are skipped without invalidating data', () async {
    final bytes = [1, 3, 3, 7];
    final manifest = utf8.encode(jsonEncode({
      'version': 1,
      'app': 'NativeTavern',
      'sourceRoots': <String, String>{},
      'files': [
        {
          'archivePath': 'files/nativeData/../escaped.png',
          'storageRoot': 'nativeData',
          'relativePath': '../escaped.png',
          'category': 'characterImages',
          'size': bytes.length,
          'sha256': sha256.convert(bytes).toString(),
        },
      ],
    }));
    final archive = Archive()
      ..addFile(ArchiveFile('manifest.json', manifest.length, manifest))
      ..addFile(
        ArchiveFile('files/nativeData/../escaped.png', bytes.length, bytes),
      );
    final encoded = ZipEncoder().encode(archive)!;
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );

    final outcome = await service.restoreMediaBytes(
      backupPackage: {
        'app': 'NativeTavern',
        'data': {'characters': <String, dynamic>{}},
      },
      bytes: encoded,
    );

    expect(outcome.skippedFiles, 1);
    expect(outcome.backupPackage['data'], isNotNull);
    expect(await File(p.join(documents.path, 'escaped.png')).exists(), isFalse);
  });

  test('corrupt media sidecar reports a warning and preserves database data',
      () async {
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final package = {
      'app': 'NativeTavern',
      'data': {
        'characters': {
          'card': {'id': 'card'},
        },
      },
    };

    final outcome = await service.restoreMediaBytesSafely(
      backupPackage: package,
      bytes: const [0, 1, 2, 3],
    );

    expect(outcome.warning, isNotNull);
    expect(
      ((outcome.backupPackage['data'] as Map)['characters'] as Map),
      contains('card'),
    );
  });

  test('legacy v2 JSON backup remains importable', () async {
    final legacy = File(p.join(documents.path, 'legacy.ntb'));
    await legacy.writeAsString(jsonEncode({
      'version': 2,
      'app': 'NativeTavern',
      'data': {
        'characters': {
          'legacy': {'id': 'legacy'}
        },
      },
    }));
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );

    final imported = await service.importFromFile(legacy);

    expect(
        ((imported['data'] as Map)['characters'] as Map), contains('legacy'));
  });

  test('file import restores a selected media sidecar from another directory',
      () async {
    final avatar = File(
      p.join(documents.path, 'NativeTavern', 'avatars', 'card.png'),
    );
    await avatar.parent.create(recursive: true);
    await avatar.writeAsBytes([21, 22, 23]);
    final sourceService = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final artifacts = await sourceService.createCloudBackupArtifacts(
      data: {
        'characters': {
          'card': {'id': 'card', 'avatarPath': avatar.path},
        },
      },
      provider: CloudProvider.googleDrive,
      options: const CloudBackupOptions(
        mediaCategories: {CloudMediaCategory.characterImages},
      ),
    );

    final pickerCache = await Directory.systemTemp.createTemp(
      'native_tavern_picker_cache_',
    );
    final targetDocuments = await Directory.systemTemp.createTemp(
      'native_tavern_import_target_',
    );
    addTearDown(() async {
      if (await pickerCache.exists()) await pickerCache.delete(recursive: true);
      if (await targetDocuments.exists()) {
        await targetDocuments.delete(recursive: true);
      }
    });
    final selectedData = await artifacts.dataFile.copy(
      p.join(pickerCache.path, p.basename(artifacts.dataFile.path)),
    );
    final selectedMedia = await artifacts.mediaFile!.copy(
      p.join(documents.path, 'file-picker-cache-entry'),
    );
    final targetService = CloudBackupService.forTesting(
      documentsDirectory: targetDocuments,
    );

    final imported = await targetService.importFromFile(
      selectedData,
      mediaFile: selectedMedia,
    );

    final restoredAvatar = File(
      p.join(targetDocuments.path, 'NativeTavern', 'avatars', 'card.png'),
    );
    expect(await restoredAvatar.readAsBytes(), [21, 22, 23]);
    expect(imported['_mediaRestoredFiles'], 1);
    expect(imported['_mediaSkippedFiles'], 0);
    expect(imported['_mediaRestoreWarning'], isNull);
  });

  test('media settings are opt-in and persist in JSON', () {
    final defaults = CloudBackupSettings.fromJson(const {});
    expect(defaults.backupOptions.mediaCategories, isEmpty);

    final restored = CloudBackupSettings.fromJson({
      'includeCharacterImages': true,
      'includeWorldInfoImages': true,
    });
    expect(
      restored.backupOptions.mediaCategories,
      containsAll({
        CloudMediaCategory.characterImages,
        CloudMediaCategory.worldInfoImages,
      }),
    );
  });

  test('operation progress updates preserve stage text and item counts', () {
    const initial = CloudBackupOperationState(
      isLoading: true,
      currentOperation: 'Uploading media',
      progress: 0.2,
      stage: CloudBackupOperationStage.compressingMedia,
      processedItems: 2,
      totalItems: 5,
    );

    final updated = initial.copyWith(progress: 0.4);

    expect(updated.currentOperation, 'Uploading media');
    expect(updated.stage, CloudBackupOperationStage.compressingMedia);
    expect(updated.processedItems, 2);
    expect(updated.totalItems, 5);
    expect(updated.progress, 0.4);

    final cleared = updated.copyWith(
      currentOperation: null,
      stage: null,
      processedItems: null,
      totalItems: null,
    );
    expect(cleared.currentOperation, isNull);
    expect(cleared.stage, isNull);
    expect(cleared.processedItems, isNull);
    expect(cleared.totalItems, isNull);
  });

  test('combined .ntx backup includes data and media and restores both',
      () async {
    final avatar = File(
      p.join(documents.path, 'NativeTavern', 'avatars', 'card.png'),
    );
    await avatar.parent.create(recursive: true);
    await avatar.writeAsBytes([9, 8, 7]);

    final source = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    final artifacts = await source.createCloudBackupArtifacts(
      data: {
        'characters': {
          'card': {'id': 'card', 'avatarPath': avatar.path},
        },
      },
      provider: CloudProvider.googleDrive,
      options: const CloudBackupOptions(
        mediaCategories: {CloudMediaCategory.characterImages},
      ),
    );

    expect(artifacts.combinedFile, isNotNull);
    expect(artifacts.combinedFile!.path, endsWith('.ntx'));
    expect(
      p.basename(artifacts.combinedFile!.path),
      matches(RegExp(r'^NativeTavern_cloud_backup_.+\.ntx$')),
    );

    final names = _archiveNames(await artifacts.combinedFile!.readAsBytes());
    expect(names, containsAll(['manifest.json', 'data.ntb', 'media.ntm']));

    final targetDocuments = await Directory.systemTemp.createTemp(
      'native_tavern_ntx_target_',
    );
    addTearDown(() async {
      if (await targetDocuments.exists()) {
        await targetDocuments.delete(recursive: true);
      }
    });
    final target = CloudBackupService.forTesting(
      documentsDirectory: targetDocuments,
    );
    final imported = await target.importFromFile(artifacts.combinedFile!);

    expect(
      ((imported['data'] as Map)['characters'] as Map),
      contains('card'),
    );
    expect(imported['_mediaRestoredFiles'], 1);
    expect(
      await File(
        p.join(targetDocuments.path, 'NativeTavern', 'avatars', 'card.png'),
      ).readAsBytes(),
      [9, 8, 7],
    );
  });

  test('legacy .ntb remains importable alongside .ntx', () async {
    final service = CloudBackupService.forTesting(
      documentsDirectory: documents,
    );
    expect(service.isCombinedBackupPath('/tmp/backup.ntx'), isTrue);
    expect(service.isDataBackupPath('/tmp/backup.ntb'), isTrue);
    expect(
      CloudBackupService.cloudBackupFileName(extension: 'ntx').endsWith('.ntx'),
      isTrue,
    );
    expect(
      CloudBackupService.syncBackupFileName,
      'NativeTavern_sync.ntx',
    );
    expect(
      CloudBackupService.syncMetadataFileName,
      'NativeTavern_sync.meta.json',
    );
  });
}

Set<String> _archiveNames(List<int> bytes) {
  return ZipDecoder()
      .decodeBytes(bytes)
      .files
      .where((entry) => entry.isFile)
      .map((entry) => entry.name)
      .toSet();
}
