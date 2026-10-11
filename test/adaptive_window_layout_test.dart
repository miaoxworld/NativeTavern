import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/widgets/common/app_shell.dart';
import 'package:native_tavern/presentation/widgets/common/app_viewport.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(AppViewport.channelName);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  Future<void> publishGeometry(Map<String, Object> geometry) async {
    await messenger.handlePlatformMessage(
      AppViewport.channelName,
      const StandardMethodCodec().encodeMethodCall(
        MethodCall('geometryChanged', geometry),
      ),
      (_) {},
    );
  }

  Map<String, Object> geometry({
    double width = 1000,
    double height = 800,
    String edge = 'none',
    List<Map<String, Object>> regions = const [],
  }) =>
      {
        'width': width,
        'height': height,
        'supportsVerticalBars': true,
        'verticalBarEdge': edge,
        'regions': regions,
      };

  testWidgets('menus share the status column without covering its indicators',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.padding = const FakeViewPadding(right: 84, bottom: 34);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetPadding);
    Map<String, Object> snapshot(String edge, {bool folded = false}) =>
        geometry(
          edge: edge,
          regions: [
            {
              'x': edge == 'right' ? 916 : 0,
              'y': 0,
              'width': 84,
              'height': 170,
              'kind': 'occlusion',
            },
            if (folded)
              {
                'x': 480,
                'y': 0,
                'width': 40,
                'height': 800,
                'kind': 'division'
              },
          ],
        );
    var currentGeometry = snapshot('right');
    messenger.setMockMethodCallHandler(channel, (_) async => currentGeometry);
    final draft = TextEditingController();
    addTearDown(draft.dispose);
    const pageKey = Key('shared-bar-content');
    final router = GoRouter(routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          for (final path in ['/', '/settings'])
            GoRoute(
              path: path,
              builder: (context, state) => Scaffold(
                key: pageKey,
                body: TextField(controller: draft),
              ),
            ),
        ],
      ),
    ]);
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (_, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: AppViewport(shareVerticalBar: true, child: child!),
      ),
    ));
    await tester.pumpAndSettle();
    final rail = tester.getRect(find.byType(NavigationRail));
    expect(rail.left, 916);
    expect(rail.right, 1000);
    expect(rail.top, greaterThanOrEqualTo(170));
    expect(tester.getRect(find.byKey(pageKey)).right, 916);
    await tester.enterText(find.byType(TextField), 'Keep my draft');
    final editable = tester.state(find.byType(EditableText));

    currentGeometry = snapshot('right', folded: true);
    await publishGeometry(currentGeometry);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(pageKey)).left, 520);
    expect(tester.getRect(find.byType(NavigationRail)).left, 916);
    expect(tester.state(find.byType(EditableText)), same(editable));

    tester.view.padding = const FakeViewPadding(left: 84, bottom: 34);
    currentGeometry = snapshot('left');
    await publishGeometry(currentGeometry);
    await tester.pumpAndSettle();
    final leftRail = tester.getRect(find.byType(NavigationRail));
    expect(leftRail.left, 0);
    expect(leftRail.right, 84);
    expect(leftRail.top, greaterThanOrEqualTo(170));
    expect(tester.getRect(find.byKey(pageKey)).left, 84);
    expect(tester.state(find.byType(EditableText)), same(editable));
    expect(draft.text, 'Keep my draft');
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/settings');
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('native folds and cameras avoid controls without losing a draft',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    messenger.setMockMethodCallHandler(channel, (_) async => geometry());
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    const contentKey = Key('window-content');
    MediaQueryData? contentMedia;

    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => AppViewport(child: child!),
      home: Builder(builder: (context) {
        contentMedia = MediaQuery.of(context);
        return Scaffold(
          key: contentKey,
          body: TextField(controller: controller),
        );
      }),
    ));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Keep my draft');
    final editableState = tester.state(find.byType(EditableText));

    await publishGeometry(geometry(edge: 'right', regions: [
      {'x': 480, 'y': 0, 'width': 40, 'height': 800, 'kind': 'division'},
    ]));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(contentKey)),
        const Rect.fromLTWH(520, 0, 480, 800));
    expect(contentMedia!.size, const Size(480, 800));
    expect(contentMedia!.displayFeatures, isEmpty);
    expect(tester.state(find.byType(EditableText)), same(editableState));
    expect(controller.text, 'Keep my draft');

    await publishGeometry(geometry(regions: [
      {'x': 0, 'y': 400, 'width': 1000, 'height': 0, 'kind': 'division'},
    ]));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(contentKey)),
        const Rect.fromLTWH(0, 400, 1000, 400));

    const camera = Rect.fromLTWH(930, 0, 70, 80);
    await publishGeometry(geometry(regions: [
      {'x': 930, 'y': 0, 'width': 70, 'height': 80, 'kind': 'occlusion'},
    ]));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(contentKey)).overlaps(camera), isFalse);

    await publishGeometry(geometry());
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(contentKey)),
        const Rect.fromLTWH(0, 0, 1000, 800));
    expect(controller.text, 'Keep my draft');
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('stale native sizes and flat folds keep the full viewport',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    messenger.setMockMethodCallHandler(
        channel,
        (_) async => geometry(
              width: 500,
              regions: [
                {
                  'x': 250,
                  'y': 0,
                  'width': 0,
                  'height': 800,
                  'kind': 'division'
                },
              ],
            ));
    const contentKey = Key('window-content');
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(displayFeatures: const [
          DisplayFeature(
            bounds: Rect.fromLTWH(500, 0, 0, 800),
            type: DisplayFeatureType.fold,
            state: DisplayFeatureState.postureFlat,
          ),
        ]),
        child: AppViewport(child: child!),
      ),
      home: const Scaffold(key: contentKey),
    ));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(contentKey)),
        const Rect.fromLTWH(0, 0, 1000, 800));
    await publishGeometry(geometry(regions: [
      {'x': double.nan, 'y': 0, 'width': 10, 'height': 800, 'kind': 'division'},
    ]));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(contentKey)).size, const Size(1000, 800));
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('navigation reflows, preserves state, and follows physical edges',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final draft = TextEditingController();
    final scroll = ScrollController();
    addTearDown(draft.dispose);
    addTearDown(scroll.dispose);
    final nativeLayout = ValueNotifier<(bool, VerticalBarEdge?)>((false, null));
    addTearDown(nativeLayout.dispose);
    final router = GoRouter(routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          for (final path in [
            '/',
            '/characters',
            '/play',
            '/ai-config',
            '/settings'
          ])
            GoRoute(
              path: path,
              builder: (context, state) => Scaffold(
                body: Column(children: [
                  TextField(controller: draft),
                  Expanded(
                      child: ListView.builder(
                    controller: scroll,
                    itemCount: 100,
                    itemBuilder: (_, i) => ListTile(title: Text('Message $i')),
                  )),
                ]),
              ),
            ),
        ],
      ),
    ]);
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: nativeLayout,
        builder: (context, value, _) => WindowLayoutScope(
          supportsVerticalBars: value.$1,
          verticalBarEdge: value.$2,
          child: child!,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Unsent');
    scroll.jumpTo(600);
    await tester.pump();
    final editable = tester.state(find.byType(EditableText));

    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.state(find.byType(EditableText)), same(editable));
    expect(scroll.offset, 600);

    nativeLayout.value = (true, VerticalBarEdge.right);
    tester.view.physicalSize = const Size(500, 350);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(NavigationRail)).right, 500);
    await tester.ensureVisible(find.text('Settings'));
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/settings');
    expect(
        tester
            .widget<NavigationRail>(find.byType(NavigationRail))
            .selectedIndex,
        4);

    nativeLayout.value = (true, null);
    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(draft.text, 'Unsent');
    expect(tester.takeException(), isNull);
  });
}
