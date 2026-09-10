import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/database_backup_service.dart';
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

  group('shouldOfferCloudSyncSetup', () {
    test('offers import when a remote snapshot exists on a new install', () {
      expect(
        shouldOfferCloudSyncSetup(
          setupCompleted: false,
          lastCloudSync: null,
          remoteSnapshotExists: true,
        ),
        isTrue,
      );
    });

    test('skips after this device has already synced', () {
      expect(
        shouldOfferCloudSyncSetup(
          setupCompleted: false,
          lastCloudSync: DateTime.utc(2026, 9, 1),
          remoteSnapshotExists: true,
        ),
        isFalse,
      );
    });
  });

  group('shouldPushCloudSnapshot', () {
    test('does not push before the remote replica is discovered', () {
      expect(
        shouldPushCloudSnapshot(
          queryCompleted: false,
          remoteSnapshotExists: false,
          lastLocalSync: null,
          pulledThisRun: false,
        ),
        isFalse,
      );
    });

    test('does not overwrite an existing replica before this device pulls', () {
      expect(
        shouldPushCloudSnapshot(
          queryCompleted: true,
          remoteSnapshotExists: true,
          lastLocalSync: null,
          pulledThisRun: false,
        ),
        isFalse,
      );
    });

    test('pushes after a successful first pull', () {
      expect(
        shouldPushCloudSnapshot(
          queryCompleted: true,
          remoteSnapshotExists: true,
          lastLocalSync: null,
          pulledThisRun: true,
        ),
        isTrue,
      );
    });

    test('lets the first device create the replica', () {
      expect(
        shouldPushCloudSnapshot(
          queryCompleted: true,
          remoteSnapshotExists: false,
          lastLocalSync: null,
          pulledThisRun: false,
        ),
        isTrue,
      );
    });
  });

  group('mergedChatTitle', () {
    final older = DateTime.utc(2026, 9, 1, 12);
    final newer = DateTime.utc(2026, 9, 1, 13);

    test('keeps a custom name when a later message bumps updatedAt', () {
      expect(
        mergedChatTitle(
          localTitle: 'Harbor talk',
          remoteTitle: 'Chat with Alice',
          localUpdatedAt: older,
          remoteUpdatedAt: newer,
        ),
        'Harbor talk',
      );
    });

    test('takes a custom remote name over a local placeholder', () {
      expect(
        mergedChatTitle(
          localTitle: 'New Chat',
          remoteTitle: 'Evening walk',
          localUpdatedAt: newer,
          remoteUpdatedAt: older,
        ),
        'Evening walk',
      );
    });

    test('uses titleUpdatedAt when both names are custom', () {
      expect(
        mergedChatTitle(
          localTitle: 'Old name',
          remoteTitle: 'New name',
          localUpdatedAt: newer,
          remoteUpdatedAt: older,
          localTitleUpdatedAt: older,
          remoteTitleUpdatedAt: newer,
        ),
        'New name',
      );
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

  test('settings sync defaults on and can be turned off', () {
    expect(const CloudBackupSettings().syncSettingsEnabled, isTrue);
    final restored = CloudBackupSettings.fromJson({
      'autoSyncEnabled': true,
      'syncSettingsEnabled': false,
    });
    expect(restored.syncSettingsEnabled, isFalse);
    expect(restored.toJson()['syncSettingsEnabled'], isFalse);
  });
}
