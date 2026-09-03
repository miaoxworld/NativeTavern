import 'package:flutter_test/flutter_test.dart';
import 'package:native_tavern/domain/services/llm_service.dart';

/// Helper: run deltas through the parser and collect results
(String, String) run(List<String> deltas) {
  final parser = ThinkTagParser();
  final content = StringBuffer();
  final reasoning = StringBuffer();
  for (final delta in deltas) {
    final (c, r) = parser.feed(delta);
    content.write(c);
    reasoning.write(r);
  }
  final (c, r) = parser.flush();
  content.write(c);
  reasoning.write(r);
  return (content.toString(), reasoning.toString());
}

void main() {
  group('ThinkTagParser streaming', () {
    test('single chunk with think block', () {
      final (content, reasoning) = run(['<think>step 1</think>Hello world']);
      expect(reasoning, 'step 1');
      expect(content, 'Hello world');
    });

    test('tag split across chunks', () {
      final (content, reasoning) =
          run(['<th', 'ink>rea', 'soning</th', 'ink>answer']);
      expect(reasoning, 'reasoning');
      expect(content, 'answer');
    });

    test('no think tag passes through', () {
      final (content, reasoning) = run(['Hello ', 'world']);
      expect(content, 'Hello world');
      expect(reasoning, '');
    });

    test('mid-message tag is regular content', () {
      final (content, reasoning) =
          run(['I will use ', '<think>tags</think> in my answer']);
      expect(content, 'I will use <think>tags</think> in my answer');
      expect(reasoning, '');
    });

    test('leading whitespace before tag', () {
      final (content, reasoning) = run(['\n <think>r</think>c']);
      expect(reasoning, 'r');
      expect(content, 'c');
    });

    test('unclosed think block flushes as reasoning', () {
      final (content, reasoning) = run(['<think>never closed']);
      expect(reasoning, 'never closed');
      expect(content, '');
    });

    test('thinking variant', () {
      final (content, reasoning) = run(['<thinking>a</thinking>b']);
      expect(reasoning, 'a');
      expect(content, 'b');
    });

    test('angle bracket content without tag', () {
      final (content, reasoning) = run(['<b>bold</b> text']);
      expect(content, '<b>bold</b> text');
      expect(reasoning, '');
    });
  });

  group('ThinkTagParser.extract (non-streaming)', () {
    test('extracts leading block', () {
      final (content, reasoning) =
          ThinkTagParser.extract('<think>why</think>\nanswer');
      expect(reasoning, 'why');
      expect(content, 'answer');
    });

    test('no block returns original', () {
      final (content, reasoning) = ThinkTagParser.extract('just text');
      expect(content, 'just text');
      expect(reasoning, isNull);
    });

    test('mid-text block not extracted', () {
      const text = 'prefix <think>x</think> suffix';
      final (content, reasoning) = ThinkTagParser.extract(text);
      expect(content, text);
      expect(reasoning, isNull);
    });
  });
}
