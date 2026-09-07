// Storage scans intentionally inspect real filesystem metadata.
// ignore_for_file: avoid_slow_async_io

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

enum StorageCategory { live2d, attachments, dataBank, audio, cache }

enum StorageEntityKind { file, directory }

enum StorageCleanupReason {
  interruptedTemporaryData,
  missingDatabaseReference,
  interruptedDocumentCleanup,
  missingFileReference,
  expiredTransientData,
  expiredSynthesizedAudio,
}

final class StorageReferenceSet {
  final Set<String> filePaths;
  final Set<String> dataBankDocumentIds;

  const StorageReferenceSet({
    this.filePaths = const <String>{},
    this.dataBankDocumentIds = const <String>{},
  });
}

abstract interface class StorageReferenceSource {
  Future<StorageReferenceSet> loadReferences();
}

abstract interface class StorageCleanupTransaction {
  int get movedCount;

  Future<void> restore();

  Future<void> commit();
}

abstract interface class StorageGovernanceOperations {
  Directory get dataRoot;

  Future<StorageSnapshot> scan();

  StorageCleanupPlan createCleanupPlan(
    StorageSnapshot snapshot, {
    Set<String>? selectedPaths,
  });

  StorageCleanupConfirmation confirmCleanup(StorageCleanupPlan reviewedPlan);

  Future<StorageCleanupTransaction> clean(
    StorageCleanupConfirmation confirmation,
  );
}

final class StorageCategoryUsage {
  final StorageCategory category;
  final int bytes;
  final int fileCount;
  final int reclaimableBytes;
  final int reclaimableCount;

  const StorageCategoryUsage({
    required this.category,
    required this.bytes,
    required this.fileCount,
    required this.reclaimableBytes,
    required this.reclaimableCount,
  });
}

final class StorageCleanupCandidate {
  final String path;
  final StorageCategory category;
  final StorageEntityKind kind;
  final int bytes;
  final int fileCount;
  final DateTime modifiedAt;
  final StorageCleanupReason reason;

  const StorageCleanupCandidate({
    required this.path,
    required this.category,
    required this.kind,
    required this.bytes,
    required this.fileCount,
    required this.modifiedAt,
    required this.reason,
  });

  String get fingerprint => [
        path,
        category.name,
        kind.name,
        bytes,
        fileCount,
        modifiedAt.toUtc().microsecondsSinceEpoch,
      ].join('\u0000');
}

final class StorageSnapshot {
  final DateTime scannedAt;
  final int quotaBytes;
  final Map<StorageCategory, StorageCategoryUsage> categories;
  final List<StorageCleanupCandidate> cleanupCandidates;
  final List<String> unreadablePaths;

  const StorageSnapshot({
    required this.scannedAt,
    required this.quotaBytes,
    required this.categories,
    required this.cleanupCandidates,
    required this.unreadablePaths,
  });

  int get totalBytes =>
      categories.values.fold(0, (sum, item) => sum + item.bytes);

  int get totalFileCount =>
      categories.values.fold(0, (sum, item) => sum + item.fileCount);

  int get reclaimableBytes =>
      cleanupCandidates.fold(0, (sum, item) => sum + item.bytes);

  bool get exceedsQuota => totalBytes > quotaBytes;

  double get quotaFraction {
    if (quotaBytes <= 0) return 1;
    return (totalBytes / quotaBytes).clamp(0, 1).toDouble();
  }
}

final class StorageCleanupPlan {
  final DateTime createdAt;
  final List<StorageCleanupCandidate> entries;

  const StorageCleanupPlan._({required this.createdAt, required this.entries});

  int get bytes => entries.fold(0, (sum, item) => sum + item.bytes);

  int get fileCount => entries.fold(0, (sum, item) => sum + item.fileCount);
}

final class StorageCleanupConfirmation {
  final StorageCleanupPlan plan;
  final Object _issuer;
  final Object _nonce;

  const StorageCleanupConfirmation._({
    required this.plan,
    required Object issuer,
    required Object nonce,
  })  : _issuer = issuer,
        _nonce = nonce;
}

final class StorageCleanupException implements Exception {
  final String message;

  const StorageCleanupException(this.message);

  @override
  String toString() => message;
}

final class StorageStagedEntry {
  final String originalPath;
  final String stagedPath;
  final StorageEntityKind kind;

  const StorageStagedEntry({
    required this.originalPath,
    required this.stagedPath,
    required this.kind,
  });
}

final class StorageCleanupReceipt implements StorageCleanupTransaction {
  final List<StorageStagedEntry> entries;
  bool _finalized = false;

  StorageCleanupReceipt._(this.entries);

  bool get finalized => _finalized;

  @override
  int get movedCount => entries.length;

  @override
  Future<void> restore() async {
    if (_finalized) {
      throw const StorageCleanupException(
        'This cleanup can no longer be restored.',
      );
    }
    for (final entry in entries.reversed) {
      final stagedType = await FileSystemEntity.type(
        entry.stagedPath,
        followLinks: false,
      );
      if (stagedType == FileSystemEntityType.notFound) continue;
      final originalType = await FileSystemEntity.type(
        entry.originalPath,
        followLinks: false,
      );
      if (originalType != FileSystemEntityType.notFound) {
        throw StorageCleanupException(
          'Cannot restore because the original path is in use: '
          '${entry.originalPath}',
        );
      }
      await Directory(path.dirname(entry.originalPath)).create(recursive: true);
      await _rename(entry.stagedPath, entry.originalPath, entry.kind);
    }
    await _removeEmptyStagingParents(entries);
    _finalized = true;
  }

  @override
  Future<void> commit() async {
    if (_finalized) return;
    Object? firstError;
    for (final entry in entries) {
      try {
        await _delete(entry.stagedPath, entry.kind);
      } catch (error) {
        firstError ??= error;
      }
    }
    await _removeEmptyStagingParents(entries);
    if (firstError != null) {
      throw StorageCleanupException(
        'Some staged files could not be removed: $firstError',
      );
    }
    _finalized = true;
  }
}

final class StorageGovernanceService implements StorageGovernanceOperations {
  static const defaultQuotaBytes = 2 * 1024 * 1024 * 1024;
  static const defaultOrphanGracePeriod = Duration(hours: 24);
  static const defaultTransientGracePeriod = Duration(hours: 1);

  @override
  final Directory dataRoot;
  final List<Directory> cacheRoots;
  final List<Directory> temporaryRoots;
  final StorageReferenceSource referenceSource;
  final int quotaBytes;
  final Duration orphanGracePeriod;
  final Duration transientGracePeriod;
  final DateTime Function() _clock;
  final String Function() _idFactory;
  final Object _confirmationIssuer = Object();
  final Set<Object> _pendingConfirmations = <Object>{};

  StorageGovernanceService({
    required this.dataRoot,
    required this.referenceSource,
    this.cacheRoots = const <Directory>[],
    this.temporaryRoots = const <Directory>[],
    this.quotaBytes = defaultQuotaBytes,
    this.orphanGracePeriod = defaultOrphanGracePeriod,
    this.transientGracePeriod = defaultTransientGracePeriod,
    DateTime Function()? clock,
    String Function()? idFactory,
  })  : _clock = clock ?? (() => DateTime.now().toUtc()),
        _idFactory = idFactory ?? const Uuid().v4;

  @override
  Future<StorageSnapshot> scan() async {
    final now = _clock().toUtc();
    final references = await referenceSource.loadReferences();
    final normalizedReferences = _normalizeReferences(references.filePaths);
    final referencedBasenames = references.filePaths
        .where((value) => value.trim().isNotEmpty)
        .map(path.basename)
        .toSet();
    final usage = {
      for (final category in StorageCategory.values)
        category: _MutableUsage(category),
    };
    final candidates = <StorageCleanupCandidate>[];
    final candidatePaths = <String>{};
    final visitedFiles = <String>{};
    final unreadablePaths = <String>[];

    final live2dRoot = Directory(path.join(dataRoot.path, 'live2d_models'));
    await _measureTree(
      live2dRoot,
      usage[StorageCategory.live2d]!,
      visitedFiles,
      unreadablePaths,
    );
    await _collectNamedTransientDirectories(
      live2dRoot,
      StorageCategory.live2d,
      now,
      candidates,
      candidatePaths,
      unreadablePaths,
      const ['.import-', '.deleting-', '.native_tavern_trash_'],
    );

    final dataBankRoot = Directory(path.join(dataRoot.path, 'data_bank'));
    await _measureTree(
      dataBankRoot,
      usage[StorageCategory.dataBank]!,
      visitedFiles,
      unreadablePaths,
    );
    await _collectDataBankOrphans(
      dataBankRoot,
      references.dataBankDocumentIds,
      now,
      candidates,
      candidatePaths,
      unreadablePaths,
    );

    final attachmentRoots = <({Directory directory, bool cleanup})>[
      (
        directory: Directory(path.join(dataRoot.path, 'attachments')),
        cleanup: true,
      ),
      (
        directory: Directory(path.join(dataRoot.path, 'avatars')),
        cleanup: true,
      ),
      (
        directory: Directory(path.join(dataRoot.path, 'backgrounds')),
        cleanup: false,
      ),
      (
        directory: Directory(path.join(dataRoot.path, 'sprites')),
        cleanup: false,
      ),
      (
        directory: Directory(
          path.join(path.dirname(dataRoot.path), 'chat_images'),
        ),
        cleanup: true,
      ),
    ];
    for (final root in attachmentRoots) {
      await _measureTree(
        root.directory,
        usage[StorageCategory.attachments]!,
        visitedFiles,
        unreadablePaths,
      );
      if (root.cleanup) {
        await _collectStagingDirectories(
          root.directory,
          StorageCategory.attachments,
          now,
          candidates,
          candidatePaths,
          unreadablePaths,
        );
        await _collectUnreferencedFiles(
          root.directory,
          StorageCategory.attachments,
          now,
          normalizedReferences,
          referencedBasenames,
          candidates,
          candidatePaths,
          unreadablePaths,
        );
      }
    }

    final managedAudioRoot = Directory(path.join(dataRoot.path, 'audio'));
    await _measureTree(
      managedAudioRoot,
      usage[StorageCategory.audio]!,
      visitedFiles,
      unreadablePaths,
    );
    await _collectStagingDirectories(
      managedAudioRoot,
      StorageCategory.audio,
      now,
      candidates,
      candidatePaths,
      unreadablePaths,
    );
    await _collectStaleFiles(
      managedAudioRoot,
      StorageCategory.audio,
      now,
      orphanGracePeriod,
      candidates,
      candidatePaths,
      unreadablePaths,
    );
    for (final temporaryRoot in _uniqueRoots(temporaryRoots)) {
      await _collectStagingDirectories(
        temporaryRoot,
        StorageCategory.audio,
        now,
        candidates,
        candidatePaths,
        unreadablePaths,
      );
      await _collectTemporaryAudio(
        temporaryRoot,
        now,
        usage[StorageCategory.audio]!,
        visitedFiles,
        candidates,
        candidatePaths,
        unreadablePaths,
      );
    }

    final managedCacheRoots = _uniqueRoots([
      Directory(path.join(dataRoot.path, 'thumbnails')),
      Directory(path.join(dataRoot.path, 'cloud_cache')),
      ...cacheRoots,
    ]);
    for (final cacheRoot in managedCacheRoots) {
      await _measureTree(
        cacheRoot,
        usage[StorageCategory.cache]!,
        visitedFiles,
        unreadablePaths,
      );
      await _collectStagingDirectories(
        cacheRoot,
        StorageCategory.cache,
        now,
        candidates,
        candidatePaths,
        unreadablePaths,
      );
      await _collectStaleCacheEntries(
        cacheRoot,
        now,
        candidates,
        candidatePaths,
        unreadablePaths,
      );
    }

    candidates.sort((left, right) {
      final category = left.category.index.compareTo(right.category.index);
      if (category != 0) return category;
      return left.path.compareTo(right.path);
    });
    for (final candidate in candidates) {
      final mutable = usage[candidate.category]!;
      mutable.reclaimableBytes += candidate.bytes;
      mutable.reclaimableCount += 1;
    }
    unreadablePaths.sort();

    return StorageSnapshot(
      scannedAt: now,
      quotaBytes: quotaBytes,
      categories: {
        for (final entry in usage.entries) entry.key: entry.value.freeze(),
      },
      cleanupCandidates: List.unmodifiable(candidates),
      unreadablePaths: List.unmodifiable(unreadablePaths),
    );
  }

  @override
  StorageCleanupPlan createCleanupPlan(
    StorageSnapshot snapshot, {
    Set<String>? selectedPaths,
  }) {
    final selected = selectedPaths == null
        ? snapshot.cleanupCandidates
        : snapshot.cleanupCandidates
            .where((candidate) => selectedPaths.contains(candidate.path))
            .toList(growable: false);
    if (selectedPaths != null && selected.length != selectedPaths.length) {
      throw const StorageCleanupException(
        'The cleanup selection is not part of this scan.',
      );
    }
    if (selected.isEmpty) {
      throw const StorageCleanupException('Select at least one item to clean.');
    }
    return StorageCleanupPlan._(
      createdAt: snapshot.scannedAt,
      entries: List.unmodifiable(selected),
    );
  }

  @override
  StorageCleanupConfirmation confirmCleanup(StorageCleanupPlan reviewedPlan) {
    final nonce = Object();
    _pendingConfirmations.add(nonce);
    return StorageCleanupConfirmation._(
      plan: reviewedPlan,
      issuer: _confirmationIssuer,
      nonce: nonce,
    );
  }

  @override
  Future<StorageCleanupReceipt> clean(
    StorageCleanupConfirmation confirmation,
  ) async {
    if (!identical(confirmation._issuer, _confirmationIssuer) ||
        !_pendingConfirmations.remove(confirmation._nonce)) {
      throw const StorageCleanupException(
        'A fresh cleanup confirmation is required.',
      );
    }
    final current = await scan();
    final currentByPath = {
      for (final candidate in current.cleanupCandidates)
        candidate.path: candidate,
    };
    for (final reviewed in confirmation.plan.entries) {
      final fresh = currentByPath[reviewed.path];
      if (fresh == null || fresh.fingerprint != reviewed.fingerprint) {
        throw StorageCleanupException(
          'Storage changed after review. Scan again before cleaning: '
          '${reviewed.path}',
        );
      }
    }

    final staged = <StorageStagedEntry>[];
    final batch = _idFactory();
    try {
      for (var index = 0; index < confirmation.plan.entries.length; index++) {
        final candidate = confirmation.plan.entries[index];
        final stagingRoot = Directory(
          path.join(
            path.dirname(candidate.path),
            '.native_tavern_trash_$batch',
          ),
        );
        await stagingRoot.create(recursive: true);
        final stagedPath = path.join(
          stagingRoot.path,
          '${index}_${path.basename(candidate.path)}',
        );
        await _rename(candidate.path, stagedPath, candidate.kind);
        staged.add(
          StorageStagedEntry(
            originalPath: candidate.path,
            stagedPath: stagedPath,
            kind: candidate.kind,
          ),
        );
      }
    } catch (error) {
      final receipt = StorageCleanupReceipt._(List.unmodifiable(staged));
      try {
        await receipt.restore();
      } catch (_) {
        // The staged paths remain recoverable and visible to a later scan.
      }
      throw StorageCleanupException('Cleanup could not be staged: $error');
    }
    return StorageCleanupReceipt._(List.unmodifiable(staged));
  }

  Set<String> _normalizeReferences(Set<String> references) {
    final normalized = <String>{};
    for (final reference in references) {
      if (reference.trim().isEmpty) continue;
      final value = path.normalize(reference);
      normalized.add(value);
      if (path.isAbsolute(value)) {
        final parts = path.split(value);
        final marker = parts.lastIndexOf(path.basename(dataRoot.path));
        if (marker >= 0 && marker < parts.length - 1) {
          normalized.add(
            path.normalize(
              path.join(dataRoot.path, path.joinAll(parts.sublist(marker + 1))),
            ),
          );
        }
      } else {
        normalized.add(path.normalize(path.join(dataRoot.path, value)));
      }
    }
    return normalized;
  }

  Future<void> _measureTree(
    Directory root,
    _MutableUsage usage,
    Set<String> visitedFiles,
    List<String> unreadablePaths,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(
        recursive: true,
        followLinks: false,
      )) {
        final type = await FileSystemEntity.type(
          entity.path,
          followLinks: false,
        );
        if (type != FileSystemEntityType.file) continue;
        final normalized = path.normalize(entity.path);
        if (!visitedFiles.add(normalized)) continue;
        try {
          usage.bytes += await File(entity.path).length();
          usage.fileCount += 1;
        } on FileSystemException {
          unreadablePaths.add(normalized);
        }
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  Future<void> _collectNamedTransientDirectories(
    Directory root,
    StorageCategory category,
    DateTime now,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
    List<String> prefixes,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(followLinks: false)) {
        if (entity is! Directory ||
            !prefixes.any(
              (prefix) => path.basename(entity.path).startsWith(prefix),
            )) {
          continue;
        }
        await _addDirectoryCandidate(
          entity,
          category,
          now,
          transientGracePeriod,
          StorageCleanupReason.interruptedTemporaryData,
          candidates,
          candidatePaths,
          unreadablePaths,
        );
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  Future<void> _collectDataBankOrphans(
    Directory root,
    Set<String> referencedDocumentIds,
    DateTime now,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(followLinks: false)) {
        if (entity is! Directory) continue;
        final name = path.basename(entity.path);
        final isTrash =
            name == '.trash' || name.startsWith('.native_tavern_trash_');
        if (!isTrash && referencedDocumentIds.contains(name)) continue;
        await _addDirectoryCandidate(
          entity,
          StorageCategory.dataBank,
          now,
          isTrash ? transientGracePeriod : orphanGracePeriod,
          isTrash
              ? StorageCleanupReason.interruptedDocumentCleanup
              : StorageCleanupReason.missingDatabaseReference,
          candidates,
          candidatePaths,
          unreadablePaths,
        );
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  Future<void> _collectStagingDirectories(
    Directory root,
    StorageCategory category,
    DateTime now,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is! Directory || !_isStagingDirectory(entity.path)) {
          continue;
        }
        await _addDirectoryCandidate(
          entity,
          category,
          now,
          transientGracePeriod,
          StorageCleanupReason.interruptedTemporaryData,
          candidates,
          candidatePaths,
          unreadablePaths,
        );
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  Future<void> _collectUnreferencedFiles(
    Directory root,
    StorageCategory category,
    DateTime now,
    Set<String> normalizedReferences,
    Set<String> referencedBasenames,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(
        recursive: true,
        followLinks: false,
      )) {
        final type = await FileSystemEntity.type(
          entity.path,
          followLinks: false,
        );
        if (type != FileSystemEntityType.file) continue;
        final normalized = path.normalize(entity.path);
        if (_isInsideStagingDirectory(root.path, normalized)) continue;
        if (normalizedReferences.contains(normalized) ||
            referencedBasenames.contains(path.basename(normalized))) {
          continue;
        }
        await _addFileCandidate(
          File(entity.path),
          category,
          now,
          orphanGracePeriod,
          StorageCleanupReason.missingFileReference,
          candidates,
          candidatePaths,
          unreadablePaths,
        );
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  Future<void> _collectStaleFiles(
    Directory root,
    StorageCategory category,
    DateTime now,
    Duration gracePeriod,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(
        recursive: true,
        followLinks: false,
      )) {
        final type = await FileSystemEntity.type(
          entity.path,
          followLinks: false,
        );
        if (type != FileSystemEntityType.file) continue;
        if (_isInsideStagingDirectory(root.path, entity.path)) continue;
        await _addFileCandidate(
          File(entity.path),
          category,
          now,
          gracePeriod,
          StorageCleanupReason.expiredTransientData,
          candidates,
          candidatePaths,
          unreadablePaths,
        );
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  /// Cache trees (plugin image caches, backup temps) can contain thousands of
  /// files. List only immediate children so Storage management stays usable.
  Future<void> _collectStaleCacheEntries(
    Directory root,
    DateTime now,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(followLinks: false)) {
        if (_isStagingDirectory(entity.path) ||
            _isInsideStagingDirectory(root.path, entity.path)) {
          continue;
        }
        final type = await FileSystemEntity.type(
          entity.path,
          followLinks: false,
        );
        if (type == FileSystemEntityType.directory) {
          await _addDirectoryCandidate(
            Directory(entity.path),
            StorageCategory.cache,
            now,
            orphanGracePeriod,
            StorageCleanupReason.expiredTransientData,
            candidates,
            candidatePaths,
            unreadablePaths,
          );
        } else if (type == FileSystemEntityType.file) {
          await _addFileCandidate(
            File(entity.path),
            StorageCategory.cache,
            now,
            orphanGracePeriod,
            StorageCleanupReason.expiredTransientData,
            candidates,
            candidatePaths,
            unreadablePaths,
          );
        }
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  Future<void> _collectTemporaryAudio(
    Directory root,
    DateTime now,
    _MutableUsage usage,
    Set<String> visitedFiles,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    if (!await root.exists()) return;
    try {
      await for (final entity in root.list(followLinks: false)) {
        if (entity is! File || !path.basename(entity.path).startsWith('tts_')) {
          continue;
        }
        final normalized = path.normalize(entity.path);
        try {
          if (visitedFiles.add(normalized)) {
            usage.bytes += await entity.length();
            usage.fileCount += 1;
          }
          await _addFileCandidate(
            entity,
            StorageCategory.audio,
            now,
            transientGracePeriod,
            StorageCleanupReason.expiredSynthesizedAudio,
            candidates,
            candidatePaths,
            unreadablePaths,
          );
        } on FileSystemException {
          unreadablePaths.add(normalized);
        }
      }
    } on FileSystemException {
      unreadablePaths.add(path.normalize(root.path));
    }
  }

  Future<void> _addFileCandidate(
    File file,
    StorageCategory category,
    DateTime now,
    Duration gracePeriod,
    StorageCleanupReason reason,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    final normalized = path.normalize(file.path);
    if (!candidatePaths.add(normalized)) return;
    try {
      final stat = await file.stat();
      if (!_oldEnough(now, stat.modified, gracePeriod)) {
        candidatePaths.remove(normalized);
        return;
      }
      candidates.add(
        StorageCleanupCandidate(
          path: normalized,
          category: category,
          kind: StorageEntityKind.file,
          bytes: stat.size,
          fileCount: 1,
          modifiedAt: stat.modified.toUtc(),
          reason: reason,
        ),
      );
    } on FileSystemException {
      candidatePaths.remove(normalized);
      unreadablePaths.add(normalized);
    }
  }

  Future<void> _addDirectoryCandidate(
    Directory directory,
    StorageCategory category,
    DateTime now,
    Duration gracePeriod,
    StorageCleanupReason reason,
    List<StorageCleanupCandidate> candidates,
    Set<String> candidatePaths,
    List<String> unreadablePaths,
  ) async {
    final normalized = path.normalize(directory.path);
    if (!candidatePaths.add(normalized)) return;
    try {
      final measurement = await _measureEntity(directory);
      if (!_oldEnough(now, measurement.modifiedAt, gracePeriod)) {
        candidatePaths.remove(normalized);
        return;
      }
      candidates.add(
        StorageCleanupCandidate(
          path: normalized,
          category: category,
          kind: StorageEntityKind.directory,
          bytes: measurement.bytes,
          fileCount: measurement.fileCount,
          modifiedAt: measurement.modifiedAt,
          reason: reason,
        ),
      );
    } on FileSystemException {
      candidatePaths.remove(normalized);
      unreadablePaths.add(normalized);
    }
  }

  Future<_EntityMeasurement> _measureEntity(Directory directory) async {
    final directoryStat = await directory.stat();
    var newestModifiedAt = directoryStat.modified.toUtc();
    var bytes = 0;
    var fileCount = 0;
    await for (final entity in directory.list(
      recursive: true,
      followLinks: false,
    )) {
      final type = await FileSystemEntity.type(entity.path, followLinks: false);
      if (type != FileSystemEntityType.file) continue;
      final stat = await File(entity.path).stat();
      bytes += stat.size;
      fileCount += 1;
      final modified = stat.modified.toUtc();
      if (modified.isAfter(newestModifiedAt)) {
        newestModifiedAt = modified;
      }
    }
    return _EntityMeasurement(
      bytes: bytes,
      fileCount: fileCount,
      modifiedAt: newestModifiedAt,
    );
  }

  bool _oldEnough(DateTime now, DateTime modifiedAt, Duration gracePeriod) {
    return !modifiedAt.toUtc().isAfter(now.subtract(gracePeriod));
  }
}

final class _MutableUsage {
  final StorageCategory category;
  int bytes = 0;
  int fileCount = 0;
  int reclaimableBytes = 0;
  int reclaimableCount = 0;

  _MutableUsage(this.category);

  StorageCategoryUsage freeze() => StorageCategoryUsage(
        category: category,
        bytes: bytes,
        fileCount: fileCount,
        reclaimableBytes: reclaimableBytes,
        reclaimableCount: reclaimableCount,
      );
}

final class _EntityMeasurement {
  final int bytes;
  final int fileCount;
  final DateTime modifiedAt;

  const _EntityMeasurement({
    required this.bytes,
    required this.fileCount,
    required this.modifiedAt,
  });
}

List<Directory> _uniqueRoots(Iterable<Directory> roots) {
  final seen = <String>{};
  return roots
      .where((root) => seen.add(path.normalize(path.absolute(root.path))))
      .toList(growable: false);
}

bool _isStagingDirectory(String value) =>
    path.basename(value).startsWith('.native_tavern_trash_');

bool _isInsideStagingDirectory(String root, String value) {
  final relative = path.relative(value, from: root);
  return path.split(relative).any(_isStagingDirectory);
}

Future<void> _rename(String from, String to, StorageEntityKind kind) async {
  switch (kind) {
    case StorageEntityKind.file:
      await File(from).rename(to);
    case StorageEntityKind.directory:
      await Directory(from).rename(to);
  }
}

Future<void> _delete(String target, StorageEntityKind kind) async {
  final type = await FileSystemEntity.type(target, followLinks: false);
  if (type == FileSystemEntityType.notFound) return;
  switch (kind) {
    case StorageEntityKind.file:
      await File(target).delete();
    case StorageEntityKind.directory:
      await Directory(target).delete(recursive: true);
  }
}

Future<void> _removeEmptyStagingParents(
  List<StorageStagedEntry> entries,
) async {
  final parents =
      entries.map((entry) => path.dirname(entry.stagedPath)).toSet();
  for (final parentPath in parents) {
    final parent = Directory(parentPath);
    if (!await parent.exists()) continue;
    try {
      if (await parent.list(followLinks: false).isEmpty) {
        await parent.delete();
      }
    } on FileSystemException {
      // A non-empty or concurrently used staging directory remains recoverable.
    }
  }
}
