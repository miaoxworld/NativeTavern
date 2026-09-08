import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';

void main() {
  group('remoteCloudSnapshotIsNewer', () {
    final now = DateTime.utc(2026, 9, 8, 12);

    test('pulls when this device has never synced', () {
      expect(
        remoteCloudSnapshotIsNewer(
          remoteUpdatedAt: now,
          lastLocalSync: null,
          remoteDeviceId: 'ipad',
          localDeviceId: 'iphone',
        ),
        isTrue,
      );
    });

    test('does not pull a snapshot this device just wrote', () {
      expect(
        remoteCloudSnapshotIsNewer(
          remoteUpdatedAt: now.add(const Duration(minutes: 1)),
          lastLocalSync: now,
          remoteDeviceId: 'iphone',
          localDeviceId: 'iphone',
        ),
        isFalse,
      );
    });

    test('pulls a later snapshot from the other device', () {
      expect(
        remoteCloudSnapshotIsNewer(
          remoteUpdatedAt: now.add(const Duration(minutes: 2)),
          lastLocalSync: now,
          remoteDeviceId: 'ipad',
          localDeviceId: 'iphone',
        ),
        isTrue,
      );
    });

    test('ignores a remote timestamp that is not newer', () {
      expect(
        remoteCloudSnapshotIsNewer(
          remoteUpdatedAt: now.subtract(const Duration(minutes: 1)),
          lastLocalSync: now,
          remoteDeviceId: 'ipad',
          localDeviceId: 'iphone',
        ),
        isFalse,
      );
    });
  });

  group('CloudSyncSchedule', () {
    test('maps names and intervals', () {
      expect(CloudSyncSchedule.fromName(null), CloudSyncSchedule.every30Minutes);
      expect(
        CloudSyncSchedule.fromName('onOpen').interval,
        isNull,
      );
      expect(
        CloudSyncSchedule.every15Minutes.interval,
        const Duration(minutes: 15),
      );
      expect(
        CloudSyncSchedule.every30Minutes.interval,
        const Duration(minutes: 30),
      );
      expect(CloudSyncSchedule.hourly.interval, const Duration(hours: 1));
    });
  });

  test('cloud settings persist the sync schedule', () {
    final restored = CloudBackupSettings.fromJson({
      'autoSyncEnabled': true,
      'syncSchedule': 'hourly',
    });
    expect(restored.autoSyncEnabled, isTrue);
    expect(restored.syncSchedule, CloudSyncSchedule.hourly);
    expect(restored.toJson()['syncSchedule'], 'hourly');
  });
}
