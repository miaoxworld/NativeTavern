import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/chat_statistics.dart';
import '../../data/models/chat.dart';
import '../../data/models/character.dart';
import '../../data/repositories/chat_repository.dart';
import 'settings_providers.dart';
import 'character_providers.dart';

/// Key for storing app statistics
const _appStatsKey = 'app_statistics';

/// Key prefix for chat statistics
const _chatStatsPrefix = 'chat_stats_';

/// Provider for app-wide statistics
final appStatisticsProvider = StateNotifierProvider<AppStatisticsNotifier, AppStatistics>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppStatisticsNotifier(prefs);
});

/// Notifier for app statistics
class AppStatisticsNotifier extends StateNotifier<AppStatistics> {
  final SharedPreferences _prefs;

  AppStatisticsNotifier(this._prefs) : super(const AppStatistics()) {
    _load();
  }

  void _load() {
    final json = _prefs.getString(_appStatsKey);
    if (json != null) {
      try {
        state = AppStatistics.fromJson(jsonDecode(json) as Map<String, dynamic>);
      } catch (e) {
        // Ignore parse errors, use default
      }
    }
    
    // Set first used date if not set
    if (state.appFirstUsed == null) {
      state = state.copyWith(appFirstUsed: DateTime.now());
      _save();
    }
  }

  Future<void> _save() async {
    await _prefs.setString(_appStatsKey, jsonEncode(state.toJson()));
  }

  /// Record a new generation
  void recordGeneration({
    required int promptTokens,
    required int completionTokens,
    required Duration generationTime,
  }) {
    state = state.copyWith(
      totalTokensUsed: state.totalTokensUsed + promptTokens + completionTokens,
      totalGenerationTime: state.totalGenerationTime + generationTime,
      totalGenerations: state.totalGenerations + 1,
    );
    _save();
  }

  /// Record a new message
  void recordMessage() {
    state = state.copyWith(
      totalMessages: state.totalMessages + 1,
    );
    _save();
  }

  /// Update character count
  void updateCharacterCount(int count) {
    state = state.copyWith(totalCharacters: count);
    _save();
  }

  /// Update chat count
  void updateChatCount(int count) {
    state = state.copyWith(totalChats: count);
    _save();
  }

  /// Update group count
  void updateGroupCount(int count) {
    state = state.copyWith(totalGroups: count);
    _save();
  }

  /// Reset all statistics
  void reset() {
    state = AppStatistics(appFirstUsed: DateTime.now());
    _save();
  }
}

/// Provider for chat-specific statistics
final chatStatisticsProvider = StateNotifierProviderFamily<ChatStatisticsNotifier, ChatStatistics, String>((ref, chatId) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ChatStatisticsNotifier(prefs, chatId);
});

/// Notifier for chat statistics
class ChatStatisticsNotifier extends StateNotifier<ChatStatistics> {
  final SharedPreferences _prefs;
  final String _chatId;

  ChatStatisticsNotifier(this._prefs, this._chatId) 
      : super(ChatStatistics(chatId: _chatId)) {
    _load();
  }

  void _load() {
    final json = _prefs.getString('$_chatStatsPrefix$_chatId');
    if (json != null) {
      try {
        state = ChatStatistics.fromJson(jsonDecode(json) as Map<String, dynamic>);
      } catch (e) {
        // Ignore parse errors, use default
      }
    }
  }

  Future<void> _save() async {
    await _prefs.setString('$_chatStatsPrefix$_chatId', jsonEncode(state.toJson()));
  }

  /// Record a new message
  void recordMessage(MessageRole role) {
    final now = DateTime.now();
    state = state.copyWith(
      totalMessages: state.totalMessages + 1,
      userMessages: role == MessageRole.user 
          ? state.userMessages + 1 
          : state.userMessages,
      assistantMessages: role == MessageRole.assistant 
          ? state.assistantMessages + 1 
          : state.assistantMessages,
      systemMessages: role == MessageRole.system 
          ? state.systemMessages + 1 
          : state.systemMessages,
      firstMessageAt: state.firstMessageAt ?? now,
      lastMessageAt: now,
    );
    _save();
  }

  /// Record a generation
  void recordGeneration({
    required int promptTokens,
    required int completionTokens,
    required Duration generationTime,
  }) {
    state = state.copyWith(
      totalTokensUsed: state.totalTokensUsed + promptTokens + completionTokens,
      promptTokens: state.promptTokens + promptTokens,
      completionTokens: state.completionTokens + completionTokens,
      totalGenerationTime: state.totalGenerationTime + generationTime,
      generationCount: state.generationCount + 1,
    );
    _save();
  }

  /// Reset statistics for this chat
  void reset() {
    state = ChatStatistics(chatId: _chatId);
    _save();
  }
}

/// Provider to compute statistics from messages
final computedChatStatisticsProvider = FutureProvider.family<ChatStatistics, String>((ref, chatId) async {
  final chatRepo = ref.watch(chatRepositoryProvider);
  final messages = await chatRepo.getMessages(chatId);
  
  int userCount = 0;
  int assistantCount = 0;
  int systemCount = 0;
  DateTime? firstMessage;
  DateTime? lastMessage;
  
  for (final message in messages) {
    switch (message.role) {
      case MessageRole.user:
        userCount++;
        break;
      case MessageRole.assistant:
        assistantCount++;
        break;
      case MessageRole.system:
        systemCount++;
        break;
    }
    
    if (firstMessage == null || message.timestamp.isBefore(firstMessage)) {
      firstMessage = message.timestamp;
    }
    if (lastMessage == null || message.timestamp.isAfter(lastMessage)) {
      lastMessage = message.timestamp;
    }
  }
  
  // Get stored stats for token/generation info
  final storedStats = ref.read(chatStatisticsProvider(chatId));
  
  return ChatStatistics(
    chatId: chatId,
    totalMessages: messages.length,
    userMessages: userCount,
    assistantMessages: assistantCount,
    systemMessages: systemCount,
    totalTokensUsed: storedStats.totalTokensUsed,
    promptTokens: storedStats.promptTokens,
    completionTokens: storedStats.completionTokens,
    totalGenerationTime: storedStats.totalGenerationTime,
    generationCount: storedStats.generationCount,
    firstMessageAt: firstMessage,
    lastMessageAt: lastMessage,
  );
});

/// Provider for overall statistics summary
final statisticsSummaryProvider = Provider<StatisticsSummary>((ref) {
  final appStats = ref.watch(appStatisticsProvider);
  final charactersAsync = ref.watch(characterListProvider);
  
  final characterCount = charactersAsync.when(
    data: (List<Character> chars) => chars.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
  
  return StatisticsSummary(
    appStats: appStats,
    characterCount: characterCount,
  );
});

/// Summary of all statistics
class StatisticsSummary {
  final AppStatistics appStats;
  final int characterCount;

  const StatisticsSummary({
    required this.appStats,
    required this.characterCount,
  });
}