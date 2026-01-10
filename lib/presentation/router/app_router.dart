import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_tavern/presentation/screens/home/home_screen.dart';
import 'package:native_tavern/presentation/screens/chat/chat_screen.dart';
import 'package:native_tavern/presentation/screens/character/character_list_screen.dart';
import 'package:native_tavern/presentation/screens/character/character_detail_screen.dart';
import 'package:native_tavern/presentation/screens/character_editor/character_editor_screen.dart';
import 'package:native_tavern/presentation/screens/settings/settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/prompt_manager_screen.dart';
import 'package:native_tavern/presentation/screens/settings/advanced_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/quick_reply_screen.dart';
import 'package:native_tavern/presentation/screens/settings/background_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/theme_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/statistics_screen.dart';
import 'package:native_tavern/presentation/screens/settings/ai_presets_screen.dart';
import 'package:native_tavern/presentation/screens/settings/sprite_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/tts_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/stt_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/translation_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/image_gen_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/regex_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/variables_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/backup_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/logit_bias_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/cfg_scale_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/tokenizer_settings_screen.dart';
import 'package:native_tavern/presentation/screens/settings/vector_storage_settings_screen.dart';
import 'package:native_tavern/presentation/widgets/chat/logprobs_panel.dart';
import 'package:native_tavern/presentation/screens/ai_config/ai_config_screen.dart';
import 'package:native_tavern/presentation/screens/import/import_screen.dart';
import 'package:native_tavern/presentation/screens/personas/personas_screen.dart';
import 'package:native_tavern/presentation/screens/world_info/world_info_screen.dart';
import 'package:native_tavern/presentation/screens/groups/groups_screen.dart';
import 'package:native_tavern/presentation/screens/groups/group_detail_screen.dart';
import 'package:native_tavern/presentation/screens/tags/tags_screen.dart';
import 'package:native_tavern/presentation/widgets/common/app_shell.dart';

/// Route paths
abstract class AppRoutes {
  static const home = '/';
  static const characters = '/characters';
  static const characterDetail = '/characters/:id';
  static const characterCreate = '/characters/new';
  static const characterEdit = '/characters/:id/edit';
  static const chat = '/chat/:id';
  static const settings = '/settings';
  static const aiConfig = '/ai-config';
  static const promptManager = '/prompt-manager';
  static const advancedSettings = '/advanced-settings';
  static const quickReplies = '/quick-replies';
  static const backgroundSettings = '/background-settings';
  static const themeSettings = '/theme-settings';
  static const statistics = '/statistics';
  static const chatStatistics = '/chat/:id/statistics';
  static const aiPresets = '/ai-presets';
  static const import_ = '/import';
  static const personas = '/personas';
  static const worldInfo = '/world-info';
  static const groups = '/groups';
  static const groupDetail = '/groups/:id';
  static const tags = '/tags';
  static const spriteSettings = '/sprite-settings';
  static const characterSprites = '/characters/:id/sprites';
  static const ttsSettings = '/tts-settings';
  static const sttSettings = '/stt-settings';
  static const translationSettings = '/translation-settings';
  static const imageGenSettings = '/image-gen-settings';
  static const regexSettings = '/regex-settings';
  static const variablesSettings = '/variables-settings';
  static const backupSettings = '/backup-settings';
  static const logitBiasSettings = '/logit-bias-settings';
  static const cfgScaleSettings = '/cfg-scale-settings';
  static const logprobsSettings = '/logprobs-settings';
  static const tokenizerSettings = '/tokenizer-settings';
  static const vectorStorageSettings = '/vector-storage-settings';
}

/// Navigation keys for nested navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// App router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Main shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.characters,
            name: 'characters',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CharacterListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.worldInfo,
            name: 'worldInfo',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WorldInfoScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.aiConfig,
            name: 'aiConfig',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AIConfigScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      // Full-screen routes (outside shell)
      // NOTE: More specific routes must come BEFORE wildcard routes
      // /characters/new must come before /characters/:id
      GoRoute(
        path: AppRoutes.characterCreate,
        name: 'characterCreate',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CharacterEditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.characterEdit,
        name: 'characterEdit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CharacterEditorScreen(characterId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.characterDetail,
        name: 'characterDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CharacterDetailScreen(characterId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ChatScreen(chatId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.import_,
        name: 'import',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ImportScreen(),
      ),
      GoRoute(
        path: AppRoutes.personas,
        name: 'personas',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PersonasScreen(),
      ),
      GoRoute(
        path: AppRoutes.promptManager,
        name: 'promptManager',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PromptManagerScreen(),
      ),
      GoRoute(
        path: AppRoutes.advancedSettings,
        name: 'advancedSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AdvancedSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.quickReplies,
        name: 'quickReplies',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const QuickReplyScreen(),
      ),
      GoRoute(
        path: AppRoutes.backgroundSettings,
        name: 'backgroundSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BackgroundSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.themeSettings,
        name: 'themeSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ThemeSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.statistics,
        name: 'statistics',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiPresets,
        name: 'aiPresets',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AIPresetsScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatStatistics,
        name: 'chatStatistics',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StatisticsScreen(chatId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.groups,
        name: 'groups',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GroupsScreen(),
      ),
      GoRoute(
        path: AppRoutes.groupDetail,
        name: 'groupDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GroupDetailScreen(groupId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.tags,
        name: 'tags',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TagsScreen(),
      ),
      GoRoute(
        path: AppRoutes.spriteSettings,
        name: 'spriteSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SpriteSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.characterSprites,
        name: 'characterSprites',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = state.uri.queryParameters['name'] ?? 'Character';
          return CharacterSpritesScreen(characterId: id, characterName: name);
        },
      ),
      GoRoute(
        path: AppRoutes.ttsSettings,
        name: 'ttsSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TTSSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.sttSettings,
        name: 'sttSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const STTSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.translationSettings,
        name: 'translationSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TranslationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.imageGenSettings,
        name: 'imageGenSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ImageGenSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.regexSettings,
        name: 'regexSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegexSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.variablesSettings,
        name: 'variablesSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final chatId = state.uri.queryParameters['chatId'];
          return VariablesSettingsScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: AppRoutes.backupSettings,
        name: 'backupSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BackupSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.logitBiasSettings,
        name: 'logitBiasSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LogitBiasSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.cfgScaleSettings,
        name: 'cfgScaleSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final characterId = state.uri.queryParameters['characterId'];
          final chatId = state.uri.queryParameters['chatId'];
          return CFGScaleSettingsScreen(
            characterId: characterId,
            chatId: chatId,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.logprobsSettings,
        name: 'logprobsSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LogprobsSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tokenizerSettings,
        name: 'tokenizerSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TokenizerSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.vectorStorageSettings,
        name: 'vectorStorageSettings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VectorStorageSettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});