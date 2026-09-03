import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/domain/services/chat_export_service.dart';

void main() {
  group('SillyTavern JSONL Chat Parser Tests', () {
    test('Correctly parses line 0 metadata, models, personas, and notes',
        () async {
      const jsonlData = '''
{"user_name":"Alex","character_name":"Seraphina","create_date":1714689000000,"chat_metadata":{"main_model":"grok-4.3","persona":"Hero","note_prompt":"Speak in rhymes","note_depth":5,"note_enabled":true}}
{"name":"Alex","is_user":true,"is_system":false,"send_date":1714689010000,"mes":"Greetings Seraphina!","swipes":["Greetings Seraphina!"],"swipe_id":0}
{"name":"Seraphina","is_user":false,"is_system":false,"send_date":1714689020000,"mes":"Beneath the silver skies we meet,\\nWith quiet words and wandering feet.","swipes":["Beneath the silver skies we meet,\\nWith quiet words and wandering feet.","Alternative rhyme here."],"swipe_id":0,"extra":{"model":"grok-4.3","reasoning":"Generate a poetic greeting rhyme."}}
''';

      final service = ChatExportService();
      final result = await service.importFromJsonl(jsonlData);

      expect(result, isNotNull);
      expect(result!.userName, 'Alex');
      expect(result.characterName, 'Seraphina');
      expect(result.model, 'grok-4.3');
      expect(result.personaName, 'Hero');
      expect(result.authorNote, 'Speak in rhymes');
      expect(result.authorNoteDepth, 5);
      expect(result.authorNoteEnabled, isTrue);
      expect(result.messages.length, 2);

      final userMsg = result.messages[0];
      expect(userMsg.role, MessageRole.user);
      expect(userMsg.content, 'Greetings Seraphina!');

      final assistantMsg = result.messages[1];
      expect(assistantMsg.role, MessageRole.assistant);
      expect(assistantMsg.content,
          'Beneath the silver skies we meet,\nWith quiet words and wandering feet.');
      expect(assistantMsg.swipes.length, 2);
      expect(assistantMsg.reasoning, 'Generate a poetic greeting rhyme.');
      expect(assistantMsg.model, 'grok-4.3');
    });

    test('Robustly handles epoch in seconds, ISO date strings, and fallbacks',
        () async {
      const jsonlData = '''
{"user_name":"Explorer","character_name":"AI Guide","create_date":"2024-05-02T12:00:00Z","chat_metadata":{"model":"claude-3-7-sonnet"}}
{"name":"Explorer","is_user":true,"send_date":1714651200,"mes":"What is the status?"}
{"name":"AI Guide","is_user":false,"send_date":"2024-05-02T12:01:00.000Z","mes":"All systems operational.","extra":{"reasoning_swipes":["First thought","Second thought"]}}
''';

      final service = ChatExportService();
      final result = await service.importFromJsonl(jsonlData);

      expect(result, isNotNull);
      expect(result!.characterName, 'AI Guide');
      expect(result.model, 'claude-3-7-sonnet');
      expect(result.messages.length, 2);
      expect(result.messages[0].timestamp.year, 2024);
      expect(result.messages[1].timestamp.year, 2024);
      expect(result.messages[1].reasoningSwipes?.length, 2);
    });

    test('Converts ImportedMessage to ChatMessage with full fidelity', () {
      final imported = ImportedMessage(
        role: MessageRole.assistant,
        content: 'Response',
        timestamp: DateTime(2024, 5, 2),
        swipes: ['Response 1', 'Response 2'],
        currentSwipeIndex: 1,
        reasoning: 'Chain of thought',
        model: 'grok-4.3',
        characterId: 'char-123',
        characterName: 'Seraphina',
      );

      final chatMsg = imported.toChatMessage('chat-abc', 'msg-xyz');
      expect(chatMsg.chatId, 'chat-abc');
      expect(chatMsg.id, 'msg-xyz');
      expect(chatMsg.role, MessageRole.assistant);
      expect(chatMsg.content, 'Response');
      expect(chatMsg.currentSwipeIndex, 1);
      expect(chatMsg.swipes, ['Response 1', 'Response 2']);
      expect(chatMsg.reasoning, 'Chain of thought');
      expect(chatMsg.metadata['model'], 'grok-4.3');
    });
  });
}
