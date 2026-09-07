import 'dart:math';

import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/story/story_chapter.dart';
import 'package:native_tavern/data/repositories/chat_repository.dart';
import 'package:native_tavern/domain/repositories/story_repository.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/story_service.dart';
import 'package:uuid/uuid.dart';

const storyRootChatIdKey = 'storyRootChatId';
const storyParentChatIdKey = 'storyParentChatId';
const storyForkChapterIdKey = 'storyForkChapterId';
const storyForkOrdinalKey = 'storyForkOrdinal';
const storyBranchTitleKey = 'storyBranchTitle';

final class StoryLine {
  const StoryLine({
    required this.chat,
    required this.rootChatId,
    required this.branchTitle,
    required this.chapters,
    this.parentChatId,
    this.forkChapterId,
    this.forkOrdinal,
  });

  final Chat chat;
  final String rootChatId;
  final String? parentChatId;
  final String? forkChapterId;
  final int? forkOrdinal;
  final String branchTitle;
  final List<StoryChapter> chapters;

  bool get isRoot => chat.id == rootChatId;
}

final class StoryForkResult {
  const StoryForkResult({required this.chat, required this.copiedChapters});

  final Chat chat;
  final List<StoryChapter> copiedChapters;
}

final class StoryBranchOutcome {
  const StoryBranchOutcome({
    required this.line,
    required this.chapters,
    required this.stateChanges,
    required this.openThreads,
  });

  final StoryLine line;
  final List<StoryChapter> chapters;
  final List<String> stateChanges;
  final List<String> openThreads;
}

final class StoryBranchComparison {
  const StoryBranchComparison({
    required this.divergenceOrdinal,
    required this.left,
    required this.right,
  });

  final int divergenceOrdinal;
  final StoryBranchOutcome left;
  final StoryBranchOutcome right;
}

/// Turns chapter records into continuable, persistent story lines.
final class StoryPlayService {
  StoryPlayService({
    required ChatRepository chatRepository,
    required StoryRepository storyRepository,
    StoryLlmTransport? transport,
    String Function()? createId,
  })  : _chats = chatRepository,
        _stories = storyRepository,
        _transport = transport,
        _createId = createId ?? const Uuid().v4;

  final ChatRepository _chats;
  final StoryRepository _stories;
  final StoryLlmTransport? _transport;
  final String Function() _createId;

  Future<Chat> renameStory({
    required String rootChatId,
    required String newTitle,
  }) async {
    final cleanTitle = newTitle.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError.value(newTitle, 'newTitle', 'Title must not be empty');
    }
    final chat = await _chats.getChat(rootChatId);
    if (chat == null) {
      throw StateError('Story root chat not found: $rootChatId');
    }
    final updated = chat.copyWith(title: cleanTitle);
    await _chats.updateChat(updated);
    return updated;
  }

  Future<String> generateStoryTitle({
    required String rootChatId,
    required LLMConfig config,
  }) async {
    final transport = _transport;
    if (transport == null) {
      throw StateError('LLM transport is not configured for story title generation.');
    }
    final chapters = await _stories.listByChatId(rootChatId);
    final chat = await _chats.getChat(rootChatId);
    final contextBuffer = StringBuffer();
    if (chat != null && chat.title.trim().isNotEmpty) {
      contextBuffer.writeln('Current Story Title: ${chat.title.trim()}');
    }
    if (chapters.isNotEmpty) {
      contextBuffer.writeln('Story Chapters:');
      for (final ch in chapters.take(6)) {
        contextBuffer.writeln('- ${ch.title}: ${ch.summary}');
      }
    } else {
      final messages = await _chats.getMessages(rootChatId);
      final recent = messages.reversed.take(8).toList().reversed;
      contextBuffer.writeln('Recent Conversation:');
      for (final msg in recent) {
        final content = msg.content.length > 120
            ? '${msg.content.substring(0, 120)}...'
            : msg.content;
        contextBuffer.writeln('${msg.role.name}: $content');
      }
    }

    final prompt = [
      {
        'role': 'system',
        'content':
            'You are a creative author. Generate a short, compelling story title (2 to 6 words) based on the story overview provided. Return ONLY the title in plain text, without quotes, punctuation at the end, or explanations.',
      },
      {
        'role': 'user',
        'content': 'Here is the story overview:\n$contextBuffer\n\nGenerate title:',
      },
    ];

    final response = await transport(
      prompt,
      config.copyWith(
        streamEnabled: false,
        temperature: 0.7,
        maxTokens: 32,
      ),
    );

    var title = response.trim();
    title = title.replaceAll(RegExp(r'^["`*_#]+|["`*_#.,:;!?]+$'), '').trim();
    if (title.isEmpty) {
      title = chat?.title ?? 'Untitled Story';
    }
    return title;
  }

  Future<List<StoryLine>> listLines() async {
    final chats = await _chats.getAllChats();
    final lines = <StoryLine>[];
    for (final chat in chats) {
      final chapters = await _stories.listByChatId(chat.id);
      if (chapters.isEmpty) continue;
      lines.add(_line(chat, chapters));
    }
    lines.sort((left, right) {
      final leftAt = left.chapters.first.createdAt;
      final rightAt = right.chapters.first.createdAt;
      return rightAt.compareTo(leftAt);
    });
    return lines;
  }

  Future<StoryForkResult> forkFromChapter({
    required String chapterId,
    required String branchTitle,
  }) async {
    final chapter = await _stories.getById(chapterId);
    if (chapter == null) throw StateError('Story chapter no longer exists.');
    final source = await _chats.getChat(chapter.chatId);
    if (source == null) throw StateError('Source chat no longer exists.');
    final sourceMessages = await _chats.getMessages(source.id);
    if (chapter.endOrdinal >= sourceMessages.length) {
      throw StateError('The chapter source messages are incomplete.');
    }

    final cleanTitle = branchTitle.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError.value(branchTitle, 'branchTitle');
    }
    final rootId = _stringSetting(source, storyRootChatIdKey) ?? source.id;
    if (_stringSetting(source, storyRootChatIdKey) == null) {
      await _chats.updateChat(
        source
            .withSetting(storyRootChatIdKey, rootId)
            .withSetting(storyBranchTitleKey, source.title),
      );
    }

    var branchSettings = Map<String, dynamic>.from(source.settings);
    branchSettings = {
      ...branchSettings,
      storyRootChatIdKey: rootId,
      storyParentChatIdKey: source.id,
      storyForkChapterIdKey: chapter.id,
      storyForkOrdinalKey: chapter.endOrdinal,
      storyBranchTitleKey: cleanTitle,
    };
    final now = DateTime.now();
    final branch = await _chats.createChat(
      Chat(
        id: _createId(),
        characterId: source.characterId,
        groupId: source.groupId,
        title: '${source.title} - $cleanTitle',
        authorNote: source.authorNote,
        authorNoteDepth: source.authorNoteDepth,
        authorNoteEnabled: source.authorNoteEnabled,
        summaries: source.summaries
            .where((summary) => summary.endMessageIndex <= chapter.endOrdinal)
            .toList(growable: false),
        settings: branchSettings,
        createdAt: now,
        updatedAt: now,
      ),
    );

    try {
      final messageIds = <String, String>{};
      for (final message in sourceMessages.take(chapter.endOrdinal + 1)) {
        final copied = await _chats.addMessage(
          message.copyWith(id: _createId(), chatId: branch.id),
        );
        messageIds[message.id] = copied.id;
      }

      final copiedChapters = <StoryChapter>[];
      final sourceChapters = await _stories.listByChatId(source.id);
      final ordered = sourceChapters
          .where((candidate) => candidate.endOrdinal <= chapter.endOrdinal)
          .toList()
        ..sort((a, b) => a.endOrdinal.compareTo(b.endOrdinal));
      for (final sourceChapter in ordered) {
        final startId = messageIds[sourceChapter.startMessageId];
        final endId = messageIds[sourceChapter.endMessageId];
        if (startId == null || endId == null) continue;
        copiedChapters.add(
          await _stories.create(
            sourceChapter.copyWith(
              id: _createId(),
              chatId: branch.id,
              startMessageId: startId,
              endMessageId: endId,
            ),
          ),
        );
      }
      return StoryForkResult(chat: branch, copiedChapters: copiedChapters);
    } catch (_) {
      await _chats.deleteChat(branch.id);
      rethrow;
    }
  }

  Future<StoryChapter> jotNote({
    required String chatId,
    required String note,
  }) async {
    final cleanNote = note.trim();
    if (cleanNote.isEmpty) throw ArgumentError.value(note, 'note');
    final chat = await _chats.getChat(chatId);
    if (chat == null) throw StateError('Chat no longer exists.');
    final messages = await _chats.getMessages(chatId);
    if (messages.isEmpty) {
      throw StateError('A story note needs at least one source message.');
    }
    final latest = await _stories.latestByChatId(chatId);
    final candidateStart = (latest?.endOrdinal ?? -1) + 1;
    final startOrdinal =
        candidateStart < messages.length ? candidateStart : messages.length - 1;
    final endOrdinal = messages.length - 1;
    final now = DateTime.now().toUtc();
    final title = cleanNote.length <= 60
        ? cleanNote
        : '${cleanNote.substring(0, 57).trim()}...';
    return _stories.create(
      StoryChapter(
        id: _createId(),
        chatId: chatId,
        title: title,
        summary: cleanNote,
        narrative: StoryChapterNarrative(keyEvents: [cleanNote]),
        startMessageId: messages[startOrdinal].id,
        endMessageId: messages[endOrdinal].id,
        startOrdinal: startOrdinal,
        endOrdinal: endOrdinal,
        origin: StoryChapterOrigin.manual,
        createdAt: now,
      ),
    );
  }

  Future<StoryBranchComparison> compare({
    required String leftChatId,
    required String rightChatId,
  }) async {
    if (leftChatId == rightChatId) {
      throw ArgumentError('Choose two different story lines.');
    }
    final lines = await listLines();
    final left = lines.where((line) => line.chat.id == leftChatId).firstOrNull;
    final right =
        lines.where((line) => line.chat.id == rightChatId).firstOrNull;
    if (left == null || right == null) {
      throw StateError('One of the story lines no longer exists.');
    }
    if (left.rootChatId != right.rootChatId) {
      throw ArgumentError('Story lines must share the same root.');
    }
    final linesById = {for (final line in lines) line.chat.id: line};
    final divergence = _divergenceOrdinal(left, right, linesById);
    return StoryBranchComparison(
      divergenceOrdinal: divergence,
      left: _outcome(left, divergence),
      right: _outcome(right, divergence),
    );
  }

  StoryLine _line(Chat chat, List<StoryChapter> chapters) {
    return StoryLine(
      chat: chat,
      rootChatId: _stringSetting(chat, storyRootChatIdKey) ?? chat.id,
      parentChatId: _stringSetting(chat, storyParentChatIdKey),
      forkChapterId: _stringSetting(chat, storyForkChapterIdKey),
      forkOrdinal: _intSetting(chat, storyForkOrdinalKey),
      branchTitle: _stringSetting(chat, storyBranchTitleKey) ?? chat.title,
      chapters: List.unmodifiable(chapters),
    );
  }

  StoryBranchOutcome _outcome(StoryLine line, int divergence) {
    final chapters = line.chapters
        .where((chapter) => chapter.endOrdinal > divergence)
        .toList(growable: false);
    return StoryBranchOutcome(
      line: line,
      chapters: chapters,
      stateChanges: _unique(
        chapters.expand((chapter) => chapter.narrative.stateChanges),
      ),
      openThreads: _unique(
        chapters.expand((chapter) => chapter.narrative.openThreads),
      ),
    );
  }

  int _divergenceOrdinal(
    StoryLine left,
    StoryLine right,
    Map<String, StoryLine> linesById,
  ) {
    final leftPath = _pathFromRoot(left, linesById);
    final rightPath = _pathFromRoot(right, linesById);
    var commonLength = 0;
    while (commonLength < leftPath.length &&
        commonLength < rightPath.length &&
        leftPath[commonLength].chat.id == rightPath[commonLength].chat.id) {
      commonLength++;
    }
    if (commonLength == 0) {
      throw StateError('The story branch graph is incomplete.');
    }
    if (commonLength == leftPath.length) {
      return _requiredForkOrdinal(rightPath[commonLength]);
    }
    if (commonLength == rightPath.length) {
      return _requiredForkOrdinal(leftPath[commonLength]);
    }
    return min(
      _requiredForkOrdinal(leftPath[commonLength]),
      _requiredForkOrdinal(rightPath[commonLength]),
    );
  }

  List<StoryLine> _pathFromRoot(
    StoryLine line,
    Map<String, StoryLine> linesById,
  ) {
    final reversed = <StoryLine>[line];
    final visited = <String>{line.chat.id};
    var current = line;
    while (!current.isRoot) {
      final parentId = current.parentChatId;
      final parent = parentId == null ? null : linesById[parentId];
      if (parent == null || parent.rootChatId != line.rootChatId) {
        throw StateError('The story branch graph is incomplete.');
      }
      if (!visited.add(parent.chat.id)) {
        throw StateError('The story branch graph contains a cycle.');
      }
      reversed.add(parent);
      current = parent;
    }
    return reversed.reversed.toList(growable: false);
  }

  int _requiredForkOrdinal(StoryLine line) {
    final ordinal = line.forkOrdinal;
    if (ordinal == null) {
      throw StateError('The story branch is missing its fork position.');
    }
    return ordinal;
  }
}

String? _stringSetting(Chat chat, String key) {
  final value = chat.settings[key];
  return value is String && value.trim().isNotEmpty ? value.trim() : null;
}

int? _intSetting(Chat chat, String key) {
  final value = chat.settings[key];
  return value is num ? value.toInt() : null;
}

List<String> _unique(Iterable<String> values) =>
    values.toSet().toList(growable: false);

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
