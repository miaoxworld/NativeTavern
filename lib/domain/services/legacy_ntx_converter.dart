import 'dart:io';

import 'package:native_tavern/domain/services/cloud_backup_service.dart';
import 'package:path/path.dart' as path;

/// Turns a legacy `.ntb` (+ optional `.ntm`) pair into a combined `.ntx`.
///
/// Direct `.ntb` / `.ntm` restore is no longer supported. Convert first, then
/// import the resulting `.ntx`.
class LegacyNtxConverter {
  LegacyNtxConverter({CloudBackupService? cloudBackupService})
      : _cloud = cloudBackupService ?? CloudBackupService.instance;

  final CloudBackupService _cloud;

  static bool isLegacyBackupPath(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return extension == '.ntb' || extension == '.ntm';
  }

  Future<File> convert({
    required File dataFile,
    File? mediaFile,
    Directory? outputDirectory,
  }) async {
    if (!_cloud.isDataBackupPath(dataFile.path)) {
      throw const FormatException(
        'Select a .ntb data backup to convert. .ntm files cannot be converted alone.',
      );
    }
    final parsed = await _cloud.parseBackupFile(
      dataFile,
      mediaFile: mediaFile,
    );
    if (parsed.package['app'] != 'NativeTavern') {
      throw Exception('Invalid backup file: not a NativeTavern backup');
    }

    File? resolvedMedia = mediaFile;
    if (resolvedMedia == null || !await resolvedMedia.exists()) {
      final sibling = File(
        '${path.withoutExtension(dataFile.path)}.ntm',
      );
      if (await sibling.exists()) {
        resolvedMedia = sibling;
      }
    }

    final directory = outputDirectory ?? dataFile.parent;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final output = File(
      path.join(
        directory.path,
        '${path.basenameWithoutExtension(dataFile.path)}.ntx',
      ),
    );

    var mediaCount = 0;
    if (resolvedMedia != null && await resolvedMedia.exists()) {
      mediaCount = 1;
    } else if (parsed.mediaBytes != null) {
      resolvedMedia = File(
        path.join(directory.path, 'media.ntm'),
      );
      await resolvedMedia.writeAsBytes(parsed.mediaBytes!, flush: true);
      mediaCount = 1;
    }

    return _cloud.packageCombinedBackup(
      dataFile: dataFile,
      mediaFile: resolvedMedia != null && await resolvedMedia.exists()
          ? resolvedMedia
          : null,
      mediaFileCount: mediaCount,
      outputFile: output,
    );
  }
}
