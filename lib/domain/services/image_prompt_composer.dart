/// Builds a short image-generation prompt from a chat scene.
class ImagePromptComposer {
  static const _maxFallbackLength = 400;

  const ImagePromptComposer();

  String fallbackPrompt({
    required String sceneText,
    String? characterName,
  }) {
    final cleaned = _cleanScene(sceneText);
    final subject = characterName?.trim();
    if (cleaned.isEmpty) {
      return subject == null || subject.isEmpty
          ? ''
          : 'portrait of $subject, detailed, cinematic lighting';
    }
    if (subject == null || subject.isEmpty) return cleaned;
    return '$subject, $cleaned';
  }

  List<Map<String, dynamic>> composeMessages({
    required String sceneText,
    String? characterName,
  }) {
    final scene = _cleanScene(sceneText);
    final subject = characterName?.trim();
    final subjectLine = subject == null || subject.isEmpty
        ? 'No named subject.'
        : 'Subject: $subject';
    return [
      {
        'role': 'system',
        'content':
            'Write one concise image-generation prompt. Output only the prompt. '
                'No quotes, no explanation, no markdown.',
      },
      {
        'role': 'user',
        'content': '$subjectLine\nScene:\n${scene.isEmpty ? '(empty)' : scene}',
      },
    ];
  }

  String normalizeModelOutput(String raw) {
    var text = raw.trim();
    if (text.startsWith('```')) {
      text = text.replaceFirst(RegExp(r'^```[a-zA-Z]*\n?'), '');
      text = text.replaceFirst(RegExp(r'\n?```$'), '');
    }
    return text.replaceAll('"', '').trim();
  }

  String _cleanScene(String sceneText) {
    var text = sceneText.trim();
    text = text.replaceAll(RegExp(r'<[^>]+>'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.length <= _maxFallbackLength) return text;
    return text.substring(0, _maxFallbackLength).trim();
  }
}
