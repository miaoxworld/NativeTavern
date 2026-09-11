import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/home_widget/home_widget_bridge.dart';

void main() {
  const groupId = HomeWidgetPlatform.appleAppGroupId;
  const plistKey = HomeWidgetPlatform.appleAppGroupPlistKey;

  test('Apple app, widget, and build script share the same App Group', () {
    expect(groupId, 'group.com.miaomiaoxworld.nativetavern');

    final files = [
      'ios/Runner/Runner.entitlements',
      'ios/HomeWidgets/HomeWidgets.entitlements',
      'ios/Runner/Info.plist',
      'ios/HomeWidgets/Info.plist',
      'macos/Runner/DebugProfile.entitlements',
      'macos/Runner/Release.entitlements',
      'macos/HomeWidgets/HomeWidgets.entitlements',
      'macos/Runner/Info.plist',
      'macos/HomeWidgets/Info.plist',
      'native/apple_home_widgets/HomeWidgetShared.swift',
      'ios/Runner/HomeWidgetPlugin.swift',
      'macos/Runner/HomeWidgetPlugin.swift',
      'build_ios_local.sh',
    ];

    for (final path in files) {
      final text = File(path).readAsStringSync();
      expect(
        text.contains(groupId) || text.contains(r'$APP_GROUP_ID'),
        isTrue,
        reason: '$path must reference $groupId or \$APP_GROUP_ID',
      );
    }

    expect(File('ios/Runner/Info.plist').readAsStringSync(), contains(plistKey));
    expect(
      File('ios/HomeWidgets/Info.plist').readAsStringSync(),
      contains(plistKey),
    );
    expect(
      File('build_ios_local.sh').readAsStringSync(),
      contains('com.apple.security.application-groups'),
    );
    expect(
      File('build_ios_local.sh').readAsStringSync(),
      contains('apply_local_bundle_ids'),
    );
    expect(
      File('build_macos_local.sh').readAsStringSync(),
      contains('APP_GROUP_ID'),
    );
    expect(
      File('native/apple_home_widgets/HomeWidgetShared.swift').readAsStringSync(),
      contains('AdvanceHomeWidgetIntent'),
    );
    expect(
      File('native/apple_home_widgets/HomeWidgetShared.swift').readAsStringSync(),
      contains('accessoryCircular'),
    );
    expect(
      File('native/apple_home_widgets/HomeWidgetShared.swift').readAsStringSync(),
      contains('containerBackground'),
    );
    expect(
      File('ios/Runner/Info.plist').readAsStringSync(),
      contains('NSSupportsLiveActivities'),
    );
    expect(
      File('ios/Runner/HomeWidgetPlugin.swift').readAsStringSync(),
      contains('NativeTavernLiveAttributes'),
    );
    expect(
      File('native/apple_home_widgets/HomeWidgetShared.swift').readAsStringSync(),
      contains('NativeTavernLiveActivityWidget'),
    );
    expect(
      File('ios/HomeWidgets/HomeWidgets.swift').readAsStringSync(),
      contains('NativeTavernLiveActivityWidget'),
    );
  });
}
