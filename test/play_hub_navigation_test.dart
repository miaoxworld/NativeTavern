import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/data/models/character.dart' as models;
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/world_info_repository.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/router/app_router.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/screens/chat/chat_screen.dart';
import 'package:native_tavern/presentation/screens/data_bank/data_bank_screen.dart';
import 'package:native_tavern/presentation/screens/play/moments_screen.dart';
import 'package:native_tavern/presentation/screens/play/play_hub_screen.dart';
import 'package:native_tavern/presentation/providers/story_timeline_providers.dart';
import 'package:native_tavern/presentation/screens/play/story_screen.dart';
import 'package:native_tavern/presentation/screens/play/story_timeline_source.dart';
import 'package:native_tavern/presentation/screens/settings/settings_screen.dart';
import 'package:native_tavern/presentation/screens/world_info/world_info_screen.dart';
import 'package:native_tavern/presentation/widgets/common/app_shell.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
  late SharedPreferences preferences;
  late Directory dataDirectory;

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (_) async => 1,
    );
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.customSelect('SELECT 1').get();
    dataDirectory = await Directory.systemTemp.createTemp('play-hub-nav-');
  });

  tearDown(() async {
    await database.close();
    if (dataDirectory.existsSync()) {
      await dataDirectory.delete(recursive: true);
    }
  });

  test('production router registers play hub and reserved play paths', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    addTearDown(router.dispose);
    final registeredPaths = _routePaths(router.configuration.routes).toSet();

    expect(
      registeredPaths,
      containsAll(const {
        AppRoutes.play,
        AppRoutes.playStory,
        AppRoutes.playMoments,
        AppRoutes.worldInfo,
        AppRoutes.dataBank,
      }),
    );
  });

  test('play labels resolve for every locale', () async {
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = await AppLocalizations.delegate.load(locale);
      final values = [
        l10n.playHub,
        l10n.story,
        l10n.moments,
        l10n.worldInfo,
        l10n.dataBank,
        l10n.playFeatureComingSoon,
        l10n.openDataBank,
        l10n.openDataBankSubtitle,
      ];
      expect(
        values,
        everyElement(
          isA<String>()
              .having((value) => value.trim(), 'non-empty value', isNotEmpty)
              .having(
                (value) => value.contains(RegExp(r'\{\w+\}')),
                'resolved placeholders',
                isFalse,
              ),
        ),
        reason: 'Missing play hub localization for $locale',
      );
    }
  });

  testWidgets('AI play destinations require confirmation before opening',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final router = GoRouter(
      initialLocation: AppRoutes.play,
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.play,
              builder: (_, __) => const PlayHubScreen(),
            ),
            GoRoute(
              path: AppRoutes.worldInfo,
              builder: (_, __) => const Scaffold(body: Text('world-info-page')),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.playStory,
          builder: (_, __) => const Scaffold(body: Text('story-page')),
        ),
        GoRoute(
          path: AppRoutes.playMoments,
          builder: (_, __) => const Scaffold(body: Text('moments-page')),
        ),
        GoRoute(
          path: AppRoutes.dataBank,
          builder: (_, __) => const Scaffold(body: Text('data-bank-page')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          sharedPreferencesProvider.overrideWithValue(preferences),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.playHub), findsWidgets);
    expect(find.text(l10n.moments), findsOneWidget);
    expect(find.text(l10n.story), findsOneWidget);
    expect(find.text(l10n.worldInfo), findsOneWidget);
    expect(find.text(l10n.dataBank), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('play-hub-moments'))).height,
      greaterThanOrEqualTo(80),
    );
    expect(find.byType(Switch), findsNothing);
    expect(find.byType(SwitchListTile), findsNothing);

    await tester.tap(find.byKey(const Key('play-hub-moments')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('enable-moments-dialog')), findsNothing);
    expect(find.text('moments-page'), findsOneWidget);
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.play);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('play-hub-story')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('enable-story-dialog')), findsOneWidget);
    await tester.tap(find.byKey(const Key('enable-play-feature-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('story-page'), findsOneWidget);
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.play);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('play-hub-world-info')));
    await tester.pumpAndSettle();
    expect(find.text('world-info-page'), findsOneWidget);

    router.go(AppRoutes.play);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('play-hub-data-bank')));
    await tester.pumpAndSettle();
    expect(find.text('data-bank-page'), findsOneWidget);
  });

  testWidgets('story and moments destinations stay empty without crashing',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storyTimelineSourceProvider.overrideWithValue(
            const EmptyStoryTimelineSource(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StoryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.storyEmptyHint), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('moments destination stays empty without crashing',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final characterRepository = CharacterRepository(
      database,
      dataDirectory.path,
    );
    final chatRepository = ChatRepository(database);
    final worldInfoRepository = WorldInfoRepository(database);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          dataPathProvider.overrideWithValue(dataDirectory.path),
          sharedPreferencesProvider.overrideWithValue(preferences),
          characterRepositoryProvider.overrideWithValue(characterRepository),
          chatRepositoryProvider.overrideWithValue(chatRepository),
          worldInfoRepositoryProvider.overrideWithValue(worldInfoRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MomentsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.momentsDisabledEmpty), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('production play routes open world info and data bank',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final characterRepository = CharacterRepository(
      database,
      dataDirectory.path,
    );
    final chatRepository = ChatRepository(database);
    final worldInfoRepository = WorldInfoRepository(database);
    final router = GoRouter(
      initialLocation: AppRoutes.play,
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.play,
              builder: (_, __) => const PlayHubScreen(),
            ),
            GoRoute(
              path: AppRoutes.worldInfo,
              builder: (_, __) => const WorldInfoScreen(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.playStory,
          builder: (_, __) => const StoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.playMoments,
          builder: (_, __) => const MomentsScreen(),
        ),
        GoRoute(
          path: AppRoutes.dataBank,
          builder: (_, __) => const DataBankScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          dataPathProvider.overrideWithValue(dataDirectory.path),
          sharedPreferencesProvider.overrideWithValue(preferences),
          characterRepositoryProvider.overrideWithValue(characterRepository),
          chatRepositoryProvider.overrideWithValue(chatRepository),
          worldInfoRepositoryProvider.overrideWithValue(worldInfoRepository),
          storyTimelineSourceProvider.overrideWithValue(
            const EmptyStoryTimelineSource(),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.moments), findsOneWidget);
    expect(find.text(l10n.story), findsOneWidget);
    expect(find.text(l10n.worldInfo), findsOneWidget);
    expect(find.text(l10n.dataBank), findsOneWidget);

    await tester.tap(find.byKey(const Key('play-hub-world-info')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text(l10n.worldInfoLorebooks), findsOneWidget);
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.play);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('play-hub-data-bank')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.widgetWithText(AppBar, l10n.dataBank), findsOneWidget);
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.playStory);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, l10n.story), findsOneWidget);
    expect(find.text(l10n.storyEmptyHint), findsOneWidget);
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.playMoments);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('moments-paused-banner')), findsOneWidget);
    expect(find.byKey(const Key('moments-empty')), findsOneWidget);
    expect(find.text(l10n.momentsDisabledEmpty), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings keeps play switches but no duplicate data bank entry',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final router = GoRouter(
      initialLocation: AppRoutes.settings,
      routes: [
        GoRoute(
          path: AppRoutes.settings,
          builder: (_, __) => const SettingsScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          sharedPreferencesProvider.overrideWithValue(preferences),
          activePersonaProvider.overrideWith((ref) => null),
          packageInfoProvider.overrideWith(
            (ref) => PackageInfo(
              appName: 'NativeTavern',
              packageName: 'native_tavern',
              version: '0.1.9',
              buildNumber: '23',
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final momentsSwitch = find.byKey(const Key('moments-enabled-switch'));
    await tester.scrollUntilVisible(momentsSwitch, 240);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('data-bank-settings-tile')), findsNothing);
    expect(momentsSwitch, findsOneWidget);
    expect(find.byKey(const Key('story-enabled-switch')), findsOneWidget);
    expect(find.text(l10n.openDataBank), findsNothing);
  });

  testWidgets('new chat app bar does not expose play destinations',
      (tester) async {
    tester.view.physicalSize = const Size(1024, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final characterRepository = CharacterRepository(
      database,
      dataDirectory.path,
    );
    final chatRepository = ChatRepository(database);
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        dataPathProvider.overrideWithValue(dataDirectory.path),
        characterRepositoryProvider.overrideWithValue(characterRepository),
        chatRepositoryProvider.overrideWithValue(chatRepository),
        sharedPreferencesProvider.overrideWithValue(preferences),
        llmServiceProvider.overrideWithValue(LLMService()),
      ],
    );
    addTearDown(container.dispose);

    final now = DateTime.utc(2026, 8, 23);
    await characterRepository.createCharacter(
      models.Character(
        id: 'play-hub-character',
        name: 'Play Hub Tester',
        createdAt: now,
        modifiedAt: now,
      ),
    );
    final chatId = (await container
        .read(activeChatProvider.notifier)
        .createChat('play-hub-character'))!;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatScreen(chatId: chatId),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text(l10n.playHub), findsNothing);
    expect(find.text(l10n.story), findsNothing);
    expect(find.text(l10n.moments), findsNothing);
    expect(find.text(l10n.dataBank), findsNothing);
    expect(find.text(l10n.worldInfo), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

Iterable<String> _routePaths(List<RouteBase> routes) sync* {
  for (final route in routes) {
    if (route is GoRoute) yield route.path;
    yield* _routePaths(route.routes);
  }
}
