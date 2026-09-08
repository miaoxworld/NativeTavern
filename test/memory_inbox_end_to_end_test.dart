import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/database/database.dart';
import 'package:native_tavern/data/models/long_term_memory.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/data/repositories/drift_long_term_memory_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/long_term_memory_governance_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/screens/settings/memory_inbox_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime.utc(2026, 8, 8, 12);
  late AppDatabase database;
  late ChatRepository chatRepository;
  late DriftLongTermMemoryRepository memoryRepository;
  late SharedPreferences preferences;
  late _MemoryLlmService llmService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.customSelect('SELECT 1').get();
    await _seedChat(database);
    chatRepository = ChatRepository(database);
    memoryRepository = DriftLongTermMemoryRepository(database, now: () => now);
    llmService = _MemoryLlmService();
    await database.customStatement(
      'INSERT INTO global_states (key, value, updated_at) VALUES (?, ?, ?)',
      [
        'llm_config',
        jsonEncode(_config.toJson()),
        now.millisecondsSinceEpoch ~/ 1000,
      ],
    );
  });

  tearDown(() => database.close());

  testWidgets('offline manual creation and editing work at mobile width',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpInbox(tester, database, chatRepository, preferences, llmService);

    await tester.tap(find.byKey(const Key('memory-context-settings')));
    await tester.pumpAndSettle();
    final contextSwitch = tester.widget<SwitchListTile>(
      find.byKey(const Key('memory-context-switch')),
    );
    final semanticSwitch = tester.widget<SwitchListTile>(
      find.byKey(const Key('memory-semantic-search-switch')),
    );
    expect(contextSwitch.value, isTrue);
    expect(semanticSwitch.value, isFalse);
    expect(
      tester
          .widget<DropdownButton<int>>(
            find.byKey(const Key('memory-context-budget-menu')),
          )
          .value,
      512,
    );
    expect(tester.takeException(), isNull);
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    final autoSwitch = tester.widget<SwitchListTile>(
      find.byKey(const Key('memory-auto-extraction-switch')),
    );
    expect(autoSwitch.value, isFalse);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('memory-create-manual')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('memory-editor-content')),
      'Created without an AI connection.',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('memory-editor-save')));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('memory-editor-save')))
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.byKey(const Key('memory-editor-save')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    expect(
      await memoryRepository.findByStates({MemoryState.active}),
      hasLength(1),
    );
    await tester.ensureVisible(find.text('Active 1'));
    await tester.tap(find.text('Active 1'));
    await tester.pumpAndSettle();
    expect(find.text('Created without an AI connection.'), findsOneWidget);
    final active =
        (await memoryRepository.findByStates({MemoryState.active})).single;
    expect(active.source.origin, MemoryOrigin.manual);

    await tester.tap(find.byKey(Key('memory-edit-${active.id}')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('memory-editor-content')),
      'Edited while offline.',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('memory-editor-save')));
    await tester.tap(find.byKey(const Key('memory-editor-save')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Edited while offline.'), findsOneWidget);
    expect((await memoryRepository.getById(active.id))?.content,
        'Edited while offline.');
    expect(tester.takeException(), isNull);
  });

  testWidgets('candidate review, merge, lock, and batch ignore persist',
      (tester) async {
    await memoryRepository.createAll([
      _candidate('approve', 'Likes tea.', 'drink'),
      _candidate('merge-a', 'Lives near the bay.', 'home:a'),
      _candidate('merge-b', 'Lives in Singapore.', 'home:b'),
      _candidate('ignore', 'Temporary detail.', 'temporary'),
    ]);
    await _pumpInbox(tester, database, chatRepository, preferences, llmService);

    await tester.ensureVisible(
      find.byKey(const Key('memory-approve-approve')),
    );
    await tester.pumpAndSettle();
    tester
        .widget<IconButton>(
          find.byKey(const Key('memory-approve-approve')),
        )
        .onPressed!();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(
        (await memoryRepository.getById('approve'))?.state, MemoryState.active);

    await tester.ensureVisible(find.byKey(const Key('memory-select-merge-a')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('memory-select-merge-a')));
    await tester.ensureVisible(find.byKey(const Key('memory-select-merge-b')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('memory-select-merge-b')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('memory-merge-selected')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('memory-editor-content')),
      'Lives near Singapore bay.',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('memory-editor-save')));
    await tester.tap(find.byKey(const Key('memory-editor-save')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect((await memoryRepository.getById('merge-a'))?.state,
        MemoryState.superseded);
    expect((await memoryRepository.getById('merge-b'))?.state,
        MemoryState.superseded);

    await tester.ensureVisible(find.byKey(const Key('memory-select-ignore')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('memory-select-ignore')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('memory-batch-ignore')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect((await memoryRepository.getById('ignore'))?.state,
        MemoryState.forgotten);

    await tester.ensureVisible(find.textContaining('Active '));
    await tester.tap(find.textContaining('Active '));
    await tester.pumpAndSettle();
    final active = await memoryRepository.findByStates({MemoryState.active});
    final merged = active.singleWhere((memory) => memory.id != 'approve');
    await tester.ensureVisible(find.byKey(Key('memory-lock-${merged.id}')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('memory-lock-${merged.id}')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect((await memoryRepository.getById(merged.id))?.locked, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('deleting memory individual and batch works', (tester) async {
    final memoryRepository = DriftLongTermMemoryRepository(database);
    await memoryRepository.createAll([
      _candidate('del-1', 'Delete single', 'del:1'),
      _candidate('del-2', 'Delete batch', 'del:2'),
    ]);

    await _pumpInbox(tester, database, chatRepository, preferences, llmService);
    await tester.pumpAndSettle();

    expect(find.text('Delete single'), findsOneWidget);
    expect(find.text('Delete batch'), findsOneWidget);

    // Delete single memory
    await tester.ensureVisible(find.byKey(const Key('memory-delete-del-1')));
    await tester.tap(find.byKey(const Key('memory-delete-del-1')));
    await tester.pumpAndSettle();
    expect(find.text('Delete memory'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(await memoryRepository.getById('del-1'), isNull);
    expect(find.text('Delete single'), findsNothing);

    // Batch delete del-2
    await tester.ensureVisible(find.byKey(const Key('memory-select-del-2')));
    await tester.tap(find.byKey(const Key('memory-select-del-2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('memory-batch-delete')), findsOneWidget);

    await tester.tap(find.byKey(const Key('memory-batch-delete')));
    await tester.pumpAndSettle();
    expect(find.text('Delete selected'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(await memoryRepository.getById('del-2'), isNull);
    expect(find.text('Delete batch'), findsNothing);
  });

  testWidgets('invalid extraction retries and an in-flight request cancels',
      (tester) async {
    await _pumpInbox(tester, database, chatRepository, preferences, llmService);
    await tester.pumpAndSettle();

    llmService.mode = _LlmMode.invalid;
    await tester.tap(find.byKey(const Key('memory-extract-chat')));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);

    llmService.mode = _LlmMode.valid;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Prefers jasmine tea.'), findsOneWidget);

    llmService.mode = _LlmMode.pending;
    await tester.tap(find.byKey(const Key('memory-extract-chat')));
    await tester.pump();
    expect(find.byKey(const Key('memory-cancel-extraction')), findsOneWidget);
    await tester.tap(find.byKey(const Key('memory-cancel-extraction')));
    await tester.pumpAndSettle();
    expect(find.text('Memory extraction was cancelled.'), findsOneWidget);
  });

  testWidgets('deleted source degrades to manual and remains reviewable',
      (tester) async {
    await memoryRepository.create(
      _candidate(
        'source-deleted',
        'Source can disappear.',
        'source',
        source: MemorySource.generated(
          sourceChatId: 'chat-1',
          sourceMessageIds: const ['message-1'],
          extractedAt: now.subtract(const Duration(days: 1, minutes: 1)),
          providerId: 'openai',
          modelId: 'memory-model',
        ),
      ),
    );
    await (database.delete(database.messages)
          ..where((table) => table.id.equals('message-1')))
        .go();

    await _pumpInbox(tester, database, chatRepository, preferences, llmService);

    expect(find.text('Manual'), findsOneWidget);
    expect(find.byKey(const Key('memory-source-source-deleted')), findsNothing);
    await tester.ensureVisible(
      find.byKey(const Key('memory-approve-source-deleted')),
    );
    await tester.pumpAndSettle();
    tester
        .widget<IconButton>(
          find.byKey(const Key('memory-approve-source-deleted')),
        )
        .onPressed!();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect((await memoryRepository.getById('source-deleted'))?.state,
        MemoryState.active);
    expect(tester.takeException(), isNull);
  });

  testWidgets('source action routes to the exact chat message', (tester) async {
    await memoryRepository.create(
      _candidate(
        'with-source',
        'Traceable fact.',
        'traceable',
        source: MemorySource.generated(
          sourceChatId: 'chat-1',
          sourceMessageIds: const ['message-1'],
          extractedAt: now.subtract(const Duration(days: 1, minutes: 1)),
          providerId: 'openai',
          modelId: 'memory-model',
        ),
      ),
    );
    final router = GoRouter(
      initialLocation: '/memory',
      routes: [
        GoRoute(
          path: '/memory',
          builder: (_, __) => const MemoryInboxScreen(),
        ),
        GoRoute(
          path: '/chat/:id',
          builder: (_, state) => Scaffold(
            body: Text(
              '${state.pathParameters['id']}/'
              '${state.uri.queryParameters['message']}',
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          chatRepositoryProvider.overrideWithValue(chatRepository),
          sharedPreferencesProvider.overrideWithValue(preferences),
          llmServiceProvider.overrideWithValue(llmService),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('memory-source-with-source')),
    );
    await tester.pumpAndSettle();
    tester
        .widget<IconButton>(
          find.byKey(const Key('memory-source-with-source')),
        )
        .onPressed!();
    await tester.pumpAndSettle();

    expect(find.text('chat-1/message-1'), findsOneWidget);
  });
}

Future<void> _pumpInbox(
  WidgetTester tester,
  AppDatabase database,
  ChatRepository chatRepository,
  SharedPreferences preferences,
  LLMService llmService,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        chatRepositoryProvider.overrideWithValue(chatRepository),
        sharedPreferencesProvider.overrideWithValue(preferences),
        llmServiceProvider.overrideWithValue(llmService),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MemoryInboxScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

const _config = LLMConfig(
  provider: LLMProvider.openai,
  model: 'memory-model',
  apiKey: 'secret',
  apiUrl: 'https://example.com/v1',
);

enum _LlmMode { invalid, valid, pending }

class _MemoryLlmService extends LLMService {
  _LlmMode mode = _LlmMode.valid;
  Completer<String>? _pending;

  @override
  Future<String> generate(
    List<Map<String, dynamic>> messages,
    LLMConfig config,
  ) {
    switch (mode) {
      case _LlmMode.invalid:
        return Future.value('invalid response');
      case _LlmMode.valid:
        return Future.value(
          jsonEncode({
            'memories': [
              {
                'kind': 'preference',
                'content': 'Prefers jasmine tea.',
                'identityKey': 'person:drink',
                'sourceMessageIds': ['message-1'],
              },
            ],
          }),
        );
      case _LlmMode.pending:
        _pending = Completer<String>();
        return _pending!.future;
    }
  }

  @override
  void cancelActiveRequest() {
    final pending = _pending;
    if (pending == null || pending.isCompleted) return;
    pending.completeError(
      DioException(
        requestOptions: RequestOptions(path: '/memory'),
        type: DioExceptionType.cancel,
      ),
    );
  }
}

LongTermMemory _candidate(
  String id,
  String content,
  String identityKey, {
  MemorySource? source,
}) {
  return LongTermMemory(
    id: id,
    kind: MemoryKind.other,
    scope: MemoryScope.character('character-1'),
    content: content,
    source: source,
    createdAt: DateTime.utc(2026, 8, 7, 12),
    normalizedIdentityKey: normalizeMemoryIdentity(identityKey),
  );
}

Future<void> _seedChat(AppDatabase database) async {
  const statements = [
    'INSERT INTO characters (id, name, created_at, modified_at) '
        "VALUES ('character-1', 'Character', 1, 1)",
    'INSERT INTO chats (id, character_id, title, created_at, updated_at) '
        "VALUES ('chat-1', 'character-1', 'Recent chat', 1, 1)",
    'INSERT INTO messages (id, chat_id, role, content, timestamp) '
        "VALUES ('message-1', 'chat-1', 'user', 'I prefer jasmine tea.', 1)",
    'INSERT INTO messages (id, chat_id, role, content, timestamp) '
        "VALUES ('message-2', 'chat-1', 'assistant', 'Understood.', 2)",
  ];
  for (final statement in statements) {
    await database.customStatement(statement);
  }
}
