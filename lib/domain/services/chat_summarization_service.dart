import 'package:flutter/foundation.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/llm_config.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/tokenizer_service.dart';
import 'package:uuid/uuid.dart';

/// Service for automatic chat history summarization
class ChatSummarizationService {
  final LLMService _llmService;
  final TokenizerService _tokenizerService;
  
  ChatSummarizationService(this._llmService, this._tokenizerService);

  /// Check if summarization should be triggered based on current context usage
  Future<bool> shouldSummarize({
    required List<ChatMessage> messages,
    required List<ChatSummary> existingSummaries,
    required GenerationSettings settings,
  }) async {
    if (!settings.autoSummarizeEnabled) {
      return false;
    }

    // Calculate current token usage
    final contextTokens = await _estimateTokenCount(messages, existingSummaries);
    final maxContext = settings.contextLength;
    final threshold = settings.autoSummarizeThreshold;
    
    final currentUsage = contextTokens / maxContext;
    
    debugPrint('📊 Context usage: $contextTokens / $maxContext tokens (${(currentUsage * 100).toStringAsFixed(1)}%)');
    debugPrint('📊 Threshold: ${(threshold * 100).toStringAsFixed(1)}%');
    
    return currentUsage >= threshold;
  }

  /// Estimate total token count for messages and summaries
  Future<int> _estimateTokenCount(
    List<ChatMessage> messages,
    List<ChatSummary> summaries,
  ) async {
    int totalTokens = 0;
    
    // Count summary tokens
    for (final summary in summaries) {
      totalTokens += await _tokenizerService.countTokens(summary.content);
    }
    
    // Count message tokens
    for (final message in messages) {
      totalTokens += await _tokenizerService.countTokens(message.content);
      // Also count reasoning if present
      if (message.reasoning != null) {
        totalTokens += await _tokenizerService.countTokens(message.reasoning!);
      }
    }
    
    return totalTokens;
  }

  /// Generate a summary of chat history
  Future<ChatSummary> generateSummary({
    required List<ChatMessage> messages,
    required List<ChatSummary> existingSummaries,
    required LLMConfig config,
    required GenerationSettings settings,
    String? characterName,
    String? userName,
  }) async {
    debugPrint('📝 Generating summary for ${messages.length} messages...');
    
    // Build the prompt for summarization
    final prompt = _buildSummarizationPrompt(
      messages: messages,
      existingSummaries: existingSummaries,
      characterName: characterName ?? 'Assistant',
      userName: userName ?? 'User',
    );
    
    debugPrint('📝 Summary prompt length: ${prompt.length} chars');
    
    // Generate summary using LLM
    final summaryText = await _generateSummaryText(
      prompt: prompt,
      config: config,
      settings: settings,
    );
    
    debugPrint('📝 Generated summary: ${summaryText.substring(0, summaryText.length > 100 ? 100 : summaryText.length)}...');
    
    // Create summary record
    final summary = ChatSummary(
      id: const Uuid().v4(),
      content: summaryText,
      endMessageIndex: messages.length - 1,
      createdAt: DateTime.now(),
    );
    
    return summary;
  }

  /// Build the prompt for summarization
  String _buildSummarizationPrompt({
    required List<ChatMessage> messages,
    required List<ChatSummary> existingSummaries,
    required String characterName,
    required String userName,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('You are tasked with summarizing a conversation history.');
    buffer.writeln('Create a concise but comprehensive summary that captures:');
    buffer.writeln('- Key events and plot developments');
    buffer.writeln('- Important character interactions and relationships');
    buffer.writeln('- Significant facts, decisions, and outcomes');
    buffer.writeln('- Current situation and context');
    buffer.writeln();
    buffer.writeln('Write the summary in third person, past tense.');
    buffer.writeln('Keep the summary focused and factual.');
    buffer.writeln();
    
    // Include existing summaries if any
    if (existingSummaries.isNotEmpty) {
      buffer.writeln('=== PREVIOUS SUMMARY ===');
      // Use the most recent summary
      buffer.writeln(existingSummaries.last.content);
      buffer.writeln();
      buffer.writeln('=== NEW CONVERSATION TO SUMMARIZE ===');
    } else {
      buffer.writeln('=== CONVERSATION TO SUMMARIZE ===');
    }
    
    // Add messages
    for (final message in messages) {
      final speaker = message.role == MessageRole.user ? userName : characterName;
      buffer.writeln('$speaker: ${message.content}');
    }
    
    buffer.writeln();
    if (existingSummaries.isNotEmpty) {
      buffer.writeln('Please update the previous summary with the new conversation.');
      buffer.writeln('Combine them into a single coherent summary.');
    } else {
      buffer.writeln('Please provide a summary of this conversation:');
    }
    buffer.writeln();
    buffer.writeln('SUMMARY:');
    
    return buffer.toString();
  }

  /// Generate summary text using LLM
  Future<String> _generateSummaryText({
    required String prompt,
    required LLMConfig config,
    required GenerationSettings settings,
  }) async {
    final buffer = StringBuffer();
    
    // Create a modified settings for summarization
    final summarySettings = settings.copyWith(
      temperature: 0.3, // Lower temperature for more focused summaries
      maxTokens: 1024, // Limit summary length
      stream: false, // No streaming for summaries
    );
    
    // Generate using LLM service
    await for (final chunk in _llmService.generateStream(
      messages: [
        {'role': 'system', 'content': 'You are a helpful assistant that creates concise conversation summaries.'},
        {'role': 'user', 'content': prompt},
      ],
      config: config,
      settings: summarySettings,
    )) {
      if (chunk['type'] == 'content') {
        buffer.write(chunk['content']);
      }
    }
    
    return buffer.toString().trim();
  }

  /// Get messages to include in context after summarization
  List<ChatMessage> getRecentMessages({
    required List<ChatMessage> allMessages,
    required ChatSummary latestSummary,
  }) {
    // Return messages after the last summarized message
    final startIndex = latestSummary.endMessageIndex + 1;
    if (startIndex >= allMessages.length) {
      return [];
    }
    return allMessages.sublist(startIndex);
  }

  /// Create a pseudo-message from summary for context building
  ChatMessage createSummaryMessage({
    required ChatSummary summary,
    required String chatId,
  }) {
    return ChatMessage(
      id: 'summary_${summary.id}',
      chatId: chatId,
      role: MessageRole.assistant,
      content: '[Context Summary]' + '

' + summary.content,
      timestamp: summary.createdAt,
    );
  }
}
