import 'package:native_tavern/domain/services/cloud_backup_service.dart';

/// A concurrent edit between this device and another cloud replica.
class ICloudSyncConflict {
  final CloudProvider provider;
  final CloudBackupInfo remote;
  final Map<String, dynamic> remotePackage;
  final DateTime remoteUpdatedAt;
  final bool localHasEdits;
  final bool hasFileVersions;
  final String? localSnapshotPath;

  const ICloudSyncConflict({
    this.provider = CloudProvider.iCloud,
    required this.remote,
    required this.remotePackage,
    required this.remoteUpdatedAt,
    required this.localHasEdits,
    this.hasFileVersions = false,
    this.localSnapshotPath,
  });
}

enum ICloudConflictResolution {
  keepLocal,
  keepRemote,
  merge,
  chooseCollections,
}
