/// Builds a short image-generation prompt from a chat scene and associated tags.
class ImagePromptComposer {
  static const _maxFallbackLength = 400;

  const ImagePromptComposer();

  /// Fallback prompt builder when LLM generation is unavailable or fails.
  String fallbackPrompt({
    required String sceneText,
    String? characterName,
    List<String> characterTags = const [],
    List<String> chatTags = const [],
    List<String> lorebookTags = const [],
    String? positiveExtension,
  }) {
    final cleaned = _cleanScene(sceneText);
    final subject = characterName?.trim();
    final parts = <String>[];

    if (subject != null && subject.isNotEmpty) {
      parts.add(subject);
    }

    // Add unique non-empty tags
    final combinedTags = <String>{
      ...characterTags.map((t) => t.trim()).where((t) => t.isNotEmpty),
      ...chatTags.map((t) => t.trim()).where((t) => t.isNotEmpty),
      ...lorebookTags.map((t) => t.trim()).where((t) => t.isNotEmpty),
    };

    if (combinedTags.isNotEmpty) {
      parts.add(combinedTags.join(', '));
    }

    if (cleaned.isNotEmpty) {
      parts.add(cleaned);
    }

    if (positiveExtension != null && positiveExtension.trim().isNotEmpty) {
      parts.add(positiveExtension.trim());
    } else if (parts.isEmpty) {
      parts.add('detailed, cinematic lighting, masterpiece');
    }

    return parts.join(', ');
  }

  /// Compose LLM prompt messages enriched with tags and context.
  List<Map<String, dynamic>> composeMessages({
    required String sceneText,
    String? characterName,
    List<String> characterTags = const [],
    List<String> chatTags = const [],
    List<String> lorebookTags = const [],
    String? positiveExtension,
  }) {
    final scene = _cleanScene(sceneText);
    final subject = characterName?.trim();

    final userContent = StringBuffer();
    if (subject != null && subject.isNotEmpty) {
      userContent.writeln('Subject: $subject');
    } else {
      userContent.writeln('Subject: None');
    }

    final validCharTags =
        characterTags.map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    if (validCharTags.isNotEmpty) {
      userContent.writeln('Character Tags: ${validCharTags.join(', ')}');
    }

    final validChatTags =
        chatTags.map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    if (validChatTags.isNotEmpty) {
      userContent.writeln('Chat / Scene Tags: ${validChatTags.join(', ')}');
    }

    final validLoreTags =
        lorebookTags.map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    if (validLoreTags.isNotEmpty) {
      userContent.writeln('World / Lore Tags: ${validLoreTags.join(', ')}');
    }

    if (positiveExtension != null && positiveExtension.trim().isNotEmpty) {
      userContent
          .writeln('Style / Positive Modifiers: ${positiveExtension.trim()}');
    }

    userContent.writeln('Scene:\n${scene.isEmpty ? '(empty)' : scene}');

    return [
      {
        'role': 'system',
        'content':
            'You are an expert AI image prompt engineer. Write one concise, high-quality image generation prompt '
                '(positive prompt) describing the visual scene, subject appearance, clothing, environment, lighting, and mood. '
                'Use the provided character, chat, and lore tags to make the prompt accurate and distinctive. '
                'Output only the prompt. Do not output quotes, explanations, markdown, or commentary.',
      },
      {
        'role': 'user',
        'content': userContent.toString().trim(),
      },
    ];
  }

  /// Combine a base prompt with a positive or negative prompt extension.
  static String combinePrompt(String basePrompt, String? extension) {
    final trimmedBase = basePrompt.trim();
    final trimmedExt = extension?.trim();
    if (trimmedExt == null || trimmedExt.isEmpty) return trimmedBase;
    if (trimmedBase.isEmpty) return trimmedExt;
    if (trimmedBase.endsWith(',')) return '$trimmedBase $trimmedExt';
    return '$trimmedBase, $trimmedExt';
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
