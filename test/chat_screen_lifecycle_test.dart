import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/data/models/character.dart' as models;
import 'package:native_tavern/data/repositories/character_repository.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/tts_service.dart';
import 'package:native_tavern/data/models/chat_background.dart';
import 'package:native_tavern/presentation/providers/background_providers.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/chat_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/tts_providers.dart';
import 'package:native_tavern/presentation/screens/chat/chat_screen.dart';
import 'package:native_tavern/presentation/screens/character/character_list_screen.dart';
import 'package:native_tavern/presentation/widgets/common/app_viewport.dart';
import 'package:native_tavern/presentation/widgets/chat/visual_novel_message_view.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'support/fake_system_tts_backend.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late Directory dataDirectory;
  late ProviderContainer container;
  late String chatId;
  String? stoppedOwnerId;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    database = AppDatabase.forTesting(NativeDatabase.memory());
    dataDirectory = await Directory.systemTemp.createTemp(
      'chat-screen-lifecycle-',
    );
    final characterRepository = CharacterRepository(
      database,
      dataDirectory.path,
    );
    final chatRepository = ChatRepository(database);
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        dataPathProvider.overrideWithValue(dataDirectory.path),
        characterRepositoryProvider.overrideWithValue(characterRepository),
        chatRepositoryProvider.overrideWithValue(chatRepository),
        sharedPreferencesProvider.overrideWithValue(preferences),
        llmServiceProvider.overrideWithValue(LLMService()),
        ttsServiceProvider.overrideWithValue(
          TTSService(systemTts: FakeSystemTTSBackend()),
        ),
        effectiveBackgroundProvider.overrideWith(
          (ref, characterId) async =>
              ChatBackground.imagePath('/unused-background.png'),
        ),
        ttsStopProvider.overrideWithValue(({String? ownerId}) async {
          stoppedOwnerId = ownerId;
        }),
      ],
    );

    final now = DateTime.utc(2026, 8, 8);
    await characterRepository.createCharacter(
      models.Character(
        id: 'lifecycle-character',
        name: 'Lifecycle Tester',
        description: 'Exercises chat navigation disposal.',
        createdAt: now,
        modifiedAt: now,
      ),
    );
    chatId = (await container
        .read(activeChatProvider.notifier)
        .createChat('lifecycle-character'))!;
  });

  tearDown(() async {
    container.dispose();
    await database.close();
    await dataDirectory.delete(recursive: true);
  });

  testWidgets('leaving chat stops TTS without using a disposed ref', (
    tester,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatScreen(chatId: chatId),
        ),
      ),
    );
    await tester.pump();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SizedBox.shrink()),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(stoppedOwnerId, chatId);
  });

  testWidgets('chat draft and menus survive resizing and a vertical toolbar',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    final edge = ValueNotifier<VerticalBarEdge?>(null);
    addTearDown(edge.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => ValueListenableBuilder(
          valueListenable: edge,
          builder: (context, value, _) => WindowLayoutScope(
            supportsVerticalBars: true,
            verticalBarEdge: value,
            child: child!,
          ),
        ),
        home: ChatScreen(chatId: chatId),
      ),
    ));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.enterText(find.byType(TextField), 'Draft across displays');
    final editor = tester.state(find.byType(EditableText));
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    edge.value = VerticalBarEdge.right;
    container.read(ttsSettingsProvider.notifier).setEnabled(true);
    final tts = container.read(ttsServiceProvider);
    await tester.runAsync(tts.initialize);
    unawaited(tts.speak('Reading across displays',
        ownerId: chatId, sourceId: 'resize-speech'));
    tester.view.physicalSize = const Size(500, 700);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsOneWidget);
    expect(tester.state(find.byType(EditableText)), same(editor));
    expect(find.text('Draft across displays'), findsOneWidget);
    // The input menu follows the narrowed content, including the side toolbar.
    final menu = find.byKey(const ValueKey('chat-input-menu-panel'));
    expect(menu, findsOneWidget);
    expect(tester.getRect(menu).right, lessThanOrEqualTo(444));
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.text_format));
    await tester.pumpAndSettle();
    expect(find.text('Bold'), findsOneWidget);
    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpAndSettle();
    expect(tester.getRect(find.text('Bold')).right, lessThanOrEqualTo(1000));
    expect(tester.getRect(find.text('Bold')).bottom, lessThanOrEqualTo(800));
    expect(tester.state(find.byType(EditableText)), same(editor));
    expect(tester.takeException(), isNull);

    await tester.runAsync(() async {
      await tts.stop();
      tts.dispose();
    });
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('visual novel panel fits the remaining height above the keyboard',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 500);
    tester.view.viewInsets = const FakeViewPadding(bottom: 180);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    await container.read(chatRepositoryProvider).addMessage(ChatMessage(
          id: 'resize-message',
          chatId: chatId,
          role: MessageRole.assistant,
          content: 'Visible in a small pane',
          timestamp: DateTime.utc(2026, 10, 11),
        ));
    await container.read(activeChatProvider.notifier).loadChat(chatId);
    container
        .read(appSettingsProvider.notifier)
        .updateChatLayoutMode('visualNovel');

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChatScreen(chatId: chatId),
      ),
    ));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.byType(VisualNovelMessageView), findsOneWidget);
    expect(find.text('Visible in a small pane'), findsOneWidget);
    final panel = tester.getRect(find.byType(VisualNovelMessageView));
    expect(panel.bottom, lessThanOrEqualTo(320));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('character cards remain readable as their grid resizes',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CharacterListScreen(),
      ),
    ));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.text('Lifecycle Tester'), findsOneWidget);
    final narrowGrid = tester.widget<GridView>(find.byType(GridView));
    final narrowColumns =
        (narrowGrid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
            .crossAxisCount;
    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpAndSettle();
    final wideGrid = tester.widget<GridView>(find.byType(GridView));
    final wideColumns =
        (wideGrid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
            .crossAxisCount;
    expect(wideColumns, greaterThan(narrowColumns));
    expect(wideColumns.isEven, isTrue);
    expect(find.text('Lifecycle Tester'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
