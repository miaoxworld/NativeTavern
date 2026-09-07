// Test fixtures intentionally exercise real filesystem behavior.
// ignore_for_file: avoid_slow_async_io

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/storage_governance_service.dart';
import 'package:path/path.dart' as path;

void main() {
  late Directory temporary;
  late Directory dataRoot;
  late Directory cacheRoot;
  late Directory audioRoot;
  late DateTime now;
  late StorageGovernanceService service;

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('storage_governance_');
    dataRoot = Directory(path.join(temporary.path, 'NativeTavern'))
      ..createSync(recursive: true);
    cacheRoot = Directory(path.join(temporary.path, 'app_cache'))
      ..createSync(recursive: true);
    audioRoot = Directory(path.join(temporary.path, 'temporary'))
      ..createSync(recursive: true);
    // Keep freshly-created fixture directories older than the logical clock.
    now = DateTime.utc(2100, 8, 8, 12);
    service = StorageGovernanceService(
      dataRoot: dataRoot,
      cacheRoots: [cacheRoot],
      temporaryRoots: [audioRoot],
      referenceSource: _References(
        filePaths: {
          path.join(dataRoot.path, 'avatars', 'kept.png'),
          path.join(dataRoot.path, 'attachments', 'kept.jpg'),
          path.join(temporary.path, 'chat_images', 'kept.webp'),
        },
        dataBankDocumentIds: const {'document-kept'},
      ),
      quotaBytes: 16,
      clock: () => now,
      idFactory: () => 'batch-1',
    );
  });

  tearDown(() {
    if (temporary.existsSync()) temporary.deleteSync(recursive: true);
  });

  test('scan accounts for categories and protects referenced or recent data',
      () async {
    final old = now.subtract(const Duration(days: 2));
    final recent = now.subtract(const Duration(minutes: 5));

    await _oldDirectory(
      path.join(dataRoot.path, 'live2d_models', 'valid-package'),
      {'model.json': 'valid'},
      old,
    );
    final live2dStaging = await _oldDirectory(
      path.join(dataRoot.path, 'live2d_models', '.import-stale'),
      {'partial.bin': 'stale'},
      old,
    );
    await _oldFile(
      path.join(dataRoot.path, 'avatars', 'kept.png'),
      'kept-avatar',
      old,
    );
    final orphanAvatar = await _oldFile(
      path.join(dataRoot.path, 'avatars', 'orphan.png'),
      'orphan-avatar',
      old,
    );
    await _oldFile(
      path.join(dataRoot.path, 'avatars', 'recent.png'),
      'recent-avatar',
      recent,
    );
    await _oldFile(
      path.join(dataRoot.path, 'backgrounds', 'gallery.png'),
      'unused-but-user-managed',
      old,
    );
    await _oldFile(
      path.join(dataRoot.path, 'attachments', 'kept.jpg'),
      'kept-attachment',
      old,
    );
    final orphanAttachment = await _oldFile(
      path.join(dataRoot.path, 'attachments', 'orphan.jpg'),
      'orphan-attachment',
      old,
    );
    await _oldFile(
      path.join(temporary.path, 'chat_images', 'kept.webp'),
      'kept-image',
      old,
    );
    final orphanGeneratedImage = await _oldFile(
      path.join(temporary.path, 'chat_images', 'orphan.webp'),
      'orphan-image',
      old,
    );
    await _oldDirectory(
      path.join(dataRoot.path, 'data_bank', 'document-kept'),
      {'version/source.txt': 'kept-document'},
      old,
    );
    final orphanDocument = await _oldDirectory(
      path.join(dataRoot.path, 'data_bank', 'document-orphan'),
      {'version/source.txt': 'orphan-document'},
      old,
    );
    final interruptedDeletion = await _oldDirectory(
      path.join(dataRoot.path, 'data_bank', '.trash'),
      {'deleted/source.txt': 'deleted-document'},
      old,
    );
    final managedAudio = await _oldFile(
      path.join(dataRoot.path, 'audio', 'old.wav'),
      'managed-audio',
      old,
    );
    final temporaryAudio = await _oldFile(
      path.join(audioRoot.path, 'tts_old.audio'),
      'temporary-audio',
      old,
    );
    await _oldFile(
      path.join(audioRoot.path, 'unrelated.tmp'),
      'unrelated',
      old,
    );
    final expiredCacheDir = Directory(path.join(cacheRoot.path, 'nested'));
    await _oldFile(
      path.join(expiredCacheDir.path, 'expired.cache'),
      'expired-cache',
      old,
    );
    await _oldFile(
      path.join(expiredCacheDir.path, 'another.cache'),
      'another-cache',
      old,
    );
    await _oldFile(
      path.join(cacheRoot.path, 'recent.cache'),
      'recent-cache',
      recent,
    );

    final snapshot = await service.scan();
    final candidatePaths =
        snapshot.cleanupCandidates.map((candidate) => candidate.path).toSet();

    expect(snapshot.totalBytes, greaterThan(16));
    expect(snapshot.exceedsQuota, isTrue);
    expect(snapshot.quotaFraction, 1);
    expect(snapshot.unreadablePaths, isEmpty);
    expect(
      snapshot.categories[StorageCategory.live2d]?.fileCount,
      2,
    );
    expect(
      snapshot.categories[StorageCategory.attachments]?.fileCount,
      8,
    );
    expect(candidatePaths, contains(live2dStaging.path));
    expect(candidatePaths, contains(orphanAvatar.path));
    expect(candidatePaths, contains(orphanAttachment.path));
    expect(candidatePaths, contains(orphanGeneratedImage.path));
    expect(candidatePaths, contains(orphanDocument.path));
    expect(candidatePaths, contains(interruptedDeletion.path));
    expect(candidatePaths, contains(managedAudio.path));
    expect(candidatePaths, contains(temporaryAudio.path));
    expect(candidatePaths, contains(path.normalize(expiredCacheDir.path)));
    expect(
      candidatePaths.where((value) => value.endsWith('.cache')),
      isEmpty,
    );
    expect(
      candidatePaths,
      isNot(contains(path.join(dataRoot.path, 'avatars', 'kept.png'))),
    );
    expect(
      candidatePaths,
      isNot(contains(path.join(dataRoot.path, 'avatars', 'recent.png'))),
    );
    expect(
      candidatePaths,
      isNot(contains(path.join(dataRoot.path, 'backgrounds', 'gallery.png'))),
    );
    expect(
      candidatePaths,
      isNot(contains(path.join(
        dataRoot.path,
        'live2d_models',
        'valid-package',
      ))),
    );
  });

  test('cleanup stages reviewed items and supports restore or commit',
      () async {
    final old = now.subtract(const Duration(days: 2));
    final orphanAttachment = await _oldFile(
      path.join(dataRoot.path, 'attachments', 'orphan.jpg'),
      'orphan-attachment',
      old,
    );
    final orphanDocument = await _oldDirectory(
      path.join(dataRoot.path, 'data_bank', 'document-orphan'),
      {'version/source.txt': 'orphan-document'},
      old,
    );

    var snapshot = await service.scan();
    var plan = service.createCleanupPlan(
      snapshot,
      selectedPaths: {orphanAttachment.path, orphanDocument.path},
    );
    var receipt = await service.clean(service.confirmCleanup(plan));

    expect(receipt.movedCount, 2);
    expect(orphanAttachment.existsSync(), isFalse);
    expect(orphanDocument.existsSync(), isFalse);
    expect(
        receipt.entries.every((entry) =>
            FileSystemEntity.typeSync(entry.stagedPath, followLinks: false) !=
            FileSystemEntityType.notFound),
        isTrue);

    await receipt.restore();
    expect(receipt.finalized, isTrue);
    expect(orphanAttachment.existsSync(), isTrue);
    expect(orphanDocument.existsSync(), isTrue);

    snapshot = await service.scan();
    plan = service.createCleanupPlan(
      snapshot,
      selectedPaths: {orphanAttachment.path, orphanDocument.path},
    );
    receipt = await service.clean(service.confirmCleanup(plan));
    final stagedPaths =
        receipt.entries.map((entry) => entry.stagedPath).toList();
    await receipt.commit();

    expect(receipt.finalized, isTrue);
    expect(orphanAttachment.existsSync(), isFalse);
    expect(orphanDocument.existsSync(), isFalse);
    expect(
      stagedPaths.any(
        (stagedPath) =>
            FileSystemEntity.typeSync(stagedPath, followLinks: false) !=
            FileSystemEntityType.notFound,
      ),
      isFalse,
    );
  });

  test(
      'changed storage invalidates a confirmation and confirmations are one use',
      () async {
    final old = now.subtract(const Duration(days: 2));
    final expiredCache = await _oldFile(
      path.join(cacheRoot.path, 'expired.cache'),
      'before',
      old,
    );
    final snapshot = await service.scan();
    final plan = service.createCleanupPlan(
      snapshot,
      selectedPaths: {expiredCache.path},
    );
    final confirmation = service.confirmCleanup(plan);
    await expiredCache.writeAsString('changed after review');

    await expectLater(
      service.clean(confirmation),
      throwsA(
        isA<StorageCleanupException>().having(
          (error) => error.message,
          'message',
          contains('Storage changed after review'),
        ),
      ),
    );
    await expectLater(
      service.clean(confirmation),
      throwsA(
        isA<StorageCleanupException>().having(
          (error) => error.message,
          'message',
          contains('fresh cleanup confirmation'),
        ),
      ),
    );
    expect(expiredCache.existsSync(), isTrue);
  });

  test('nested plugin caches collapse to one expired transient candidate',
      () async {
    final old = now.subtract(const Duration(days: 2));
    final pluginCache = Directory(
      path.join(cacheRoot.path, 'libCachedImageData'),
    );
    for (var index = 0; index < 40; index++) {
      await _oldFile(
        path.join(pluginCache.path, 'shard', '$index.img'),
        'cache-$index',
        old,
      );
    }

    final snapshot = await service.scan();
    final cacheCandidates = snapshot.cleanupCandidates
        .where((candidate) => candidate.category == StorageCategory.cache)
        .toList();

    expect(cacheCandidates, hasLength(1));
    expect(cacheCandidates.single.path, path.normalize(pluginCache.path));
    expect(cacheCandidates.single.fileCount, 40);
    expect(
      cacheCandidates.single.reason,
      StorageCleanupReason.expiredTransientData,
    );
  });

  test('overlapping temporary and cache roots count each file once', () async {
    final sharedRoot = Directory(path.join(temporary.path, 'shared'))
      ..createSync(recursive: true);
    final old = now.subtract(const Duration(days: 2));
    final temporaryAudio = await _oldFile(
      path.join(sharedRoot.path, 'tts_reply.audio'),
      'voice',
      old,
    );
    final cachedFile = await _oldFile(
      path.join(sharedRoot.path, 'response.cache'),
      'cache',
      old,
    );
    final overlappingService = StorageGovernanceService(
      dataRoot: dataRoot,
      cacheRoots: [sharedRoot],
      temporaryRoots: [sharedRoot],
      referenceSource: const _References(),
      clock: () => now,
    );

    final snapshot = await overlappingService.scan();
    final audio = snapshot.categories[StorageCategory.audio]!;
    final cache = snapshot.categories[StorageCategory.cache]!;

    expect(snapshot.totalFileCount, 2);
    expect(audio.fileCount, 1);
    expect(audio.bytes, await temporaryAudio.length());
    expect(cache.fileCount, 1);
    expect(cache.bytes, await cachedFile.length());
    expect(
      snapshot.cleanupCandidates.map((candidate) => candidate.path),
      containsAll([temporaryAudio.path, cachedFile.path]),
    );
  });

  test('a crash-left staging directory is scanned as one recoverable unit',
      () async {
    now = DateTime.now().toUtc();
    final old = now.subtract(const Duration(days: 2));
    final orphan = await _oldFile(
      path.join(dataRoot.path, 'attachments', 'nested', 'orphan.jpg'),
      'orphan',
      old,
    );
    final snapshot = await service.scan();
    final plan = service.createCleanupPlan(
      snapshot,
      selectedPaths: {orphan.path},
    );
    final receipt = await service.clean(service.confirmCleanup(plan));
    final staged = receipt.entries.single;
    final stagingDirectory = Directory(path.dirname(staged.stagedPath));
    await File(staged.stagedPath).setLastModified(old);

    final immediateSnapshot = await service.scan();
    expect(
      immediateSnapshot.cleanupCandidates.map((candidate) => candidate.path),
      isNot(contains(stagingDirectory.path)),
    );

    now = now.add(const Duration(hours: 2));
    final recoverySnapshot = await service.scan();
    final recoveryCandidates = recoverySnapshot.cleanupCandidates
        .where((candidate) => candidate.category == StorageCategory.attachments)
        .toList();

    expect(recoveryCandidates, hasLength(1));
    expect(recoveryCandidates.single.path, stagingDirectory.path);
    expect(recoveryCandidates.single.kind, StorageEntityKind.directory);
    expect(
      recoveryCandidates.single.reason,
      StorageCleanupReason.interruptedTemporaryData,
    );
    await receipt.restore();
    expect(orphan.existsSync(), isTrue);
  });
}

final class _References implements StorageReferenceSource {
  final Set<String> filePaths;
  final Set<String> dataBankDocumentIds;

  const _References({
    this.filePaths = const {},
    this.dataBankDocumentIds = const {},
  });

  @override
  Future<StorageReferenceSet> loadReferences() async => StorageReferenceSet(
        filePaths: filePaths,
        dataBankDocumentIds: dataBankDocumentIds,
      );
}

Future<File> _oldFile(
    String filePath, String content, DateTime modified) async {
  final file = File(filePath);
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
  await file.setLastModified(modified);
  return file;
}

Future<Directory> _oldDirectory(
  String directoryPath,
  Map<String, String> files,
  DateTime modified,
) async {
  final directory = Directory(directoryPath);
  await directory.create(recursive: true);
  for (final entry in files.entries) {
    await _oldFile(path.join(directory.path, entry.key), entry.value, modified);
  }
  return directory;
}
