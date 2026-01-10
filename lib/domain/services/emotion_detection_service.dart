import 'package:native_tavern/data/models/sprite.dart';

/// Service for detecting emotions from message content
class EmotionDetectionService {
  /// Emotion keyword patterns with weights
  static const Map<SpriteEmotion, List<EmotionPattern>> _emotionPatterns = {
    SpriteEmotion.happy: [
      EmotionPattern(r'\b(laugh|laughs|laughing|laughed)\b', 3),
      EmotionPattern(r'\b(smile|smiles|smiling|smiled)\b', 3),
      EmotionPattern(r'\b(grin|grins|grinning|grinned)\b', 3),
      EmotionPattern(r'\b(happy|happily|happiness)\b', 2),
      EmotionPattern(r'\b(joy|joyful|joyfully)\b', 2),
      EmotionPattern(r'\b(cheerful|cheerfully)\b', 2),
      EmotionPattern(r'\b(delighted|pleased)\b', 2),
      EmotionPattern(r'\b(giggle|giggles|giggling)\b', 2),
      EmotionPattern(r'[😀😃😄😁😆😊🙂☺️😂🤣😇]', 3),
      EmotionPattern(r'\bhaha+\b', 2),
      EmotionPattern(r'\bhehe+\b', 2),
      EmotionPattern(r'\blol\b', 1),
    ],
    SpriteEmotion.sad: [
      EmotionPattern(r'\b(cry|cries|crying|cried)\b', 3),
      EmotionPattern(r'\b(tear|tears)\b', 3),
      EmotionPattern(r'\b(sob|sobs|sobbing|sobbed)\b', 3),
      EmotionPattern(r'\b(sad|sadly|sadness)\b', 2),
      EmotionPattern(r'\b(depressed|depression)\b', 2),
      EmotionPattern(r'\b(unhappy|miserable)\b', 2),
      EmotionPattern(r'\b(sorrow|sorrowful)\b', 2),
      EmotionPattern(r'\b(weep|weeps|weeping)\b', 2),
      EmotionPattern(r'[😢😭😿😥😞😔]', 3),
    ],
    SpriteEmotion.angry: [
      EmotionPattern(r'\b(angry|angrily|anger)\b', 3),
      EmotionPattern(r'\b(furious|furiously|fury)\b', 3),
      EmotionPattern(r'\b(rage|raging|enraged)\b', 3),
      EmotionPattern(r'\b(mad|madly)\b', 2),
      EmotionPattern(r'\b(annoyed|irritated)\b', 2),
      EmotionPattern(r'\b(frustrated|frustration)\b', 2),
      EmotionPattern(r'\b(yell|yells|yelling|yelled)\b', 2),
      EmotionPattern(r'\b(shout|shouts|shouting|shouted)\b', 2),
      EmotionPattern(r'\b(scream|screams|screaming|screamed)\b', 2),
      EmotionPattern(r'[😠😡🤬😤💢]', 3),
    ],
    SpriteEmotion.surprised: [
      EmotionPattern(r'\b(surprise|surprised|surprising)\b', 3),
      EmotionPattern(r'\b(shock|shocked|shocking)\b', 3),
      EmotionPattern(r'\b(amazed|amazing|amazement)\b', 2),
      EmotionPattern(r'\b(astonished|astonishment)\b', 2),
      EmotionPattern(r'\b(startled|startling)\b', 2),
      EmotionPattern(r'\b(gasp|gasps|gasping|gasped)\b', 3),
      EmotionPattern(r'\bwow\b', 2),
      EmotionPattern(r'\bwhoa\b', 2),
      EmotionPattern(r'\bwhat\?!\b', 2),
      EmotionPattern(r'[😮😲😯😱🤯]', 3),
      EmotionPattern(r'!{2,}', 1),
    ],
    SpriteEmotion.scared: [
      EmotionPattern(r'\b(scared|scary|scare)\b', 3),
      EmotionPattern(r'\b(fear|fearful|fearing|feared)\b', 3),
      EmotionPattern(r'\b(afraid)\b', 3),
      EmotionPattern(r'\b(terrified|terrifying|terror)\b', 3),
      EmotionPattern(r'\b(frightened|frightening|fright)\b', 3),
      EmotionPattern(r'\b(nervous|nervously)\b', 2),
      EmotionPattern(r'\b(anxious|anxiety)\b', 2),
      EmotionPattern(r'\b(tremble|trembles|trembling|trembled)\b', 2),
      EmotionPattern(r'\b(shiver|shivers|shivering|shivered)\b', 2),
      EmotionPattern(r'[😨😰😱🫣]', 3),
    ],
    SpriteEmotion.disgusted: [
      EmotionPattern(r'\b(disgust|disgusted|disgusting)\b', 3),
      EmotionPattern(r'\b(gross|grossed)\b', 2),
      EmotionPattern(r'\b(revolted|revolting)\b', 2),
      EmotionPattern(r'\b(sick|sickened|sickening)\b', 2),
      EmotionPattern(r'\b(ew+|eww+|ugh+)\b', 2),
      EmotionPattern(r'\b(yuck|yucky)\b', 2),
      EmotionPattern(r'[🤢🤮😖]', 3),
    ],
    SpriteEmotion.confused: [
      EmotionPattern(r'\b(confused|confusing|confusion)\b', 3),
      EmotionPattern(r'\b(puzzled|puzzling)\b', 2),
      EmotionPattern(r'\b(bewildered|bewildering)\b', 2),
      EmotionPattern(r'\b(uncertain|uncertainty)\b', 2),
      EmotionPattern(r'\b(unsure)\b', 2),
      EmotionPattern(r'\b(huh|hmm+)\b', 2),
      EmotionPattern(r'\b(what|wait)\b.*\?', 1),
      EmotionPattern(r'[🤔😕❓]', 3),
      EmotionPattern(r'\?{2,}', 1),
    ],
    SpriteEmotion.embarrassed: [
      EmotionPattern(r'\b(embarrassed|embarrassing|embarrassment)\b', 3),
      EmotionPattern(r'\b(blush|blushes|blushing|blushed)\b', 3),
      EmotionPattern(r'\b(shy|shyly|shyness)\b', 2),
      EmotionPattern(r'\b(flustered)\b', 2),
      EmotionPattern(r'\b(awkward|awkwardly)\b', 2),
      EmotionPattern(r'[😳🫢😅]', 3),
    ],
    SpriteEmotion.excited: [
      EmotionPattern(r'\b(excited|exciting|excitement)\b', 3),
      EmotionPattern(r'\b(thrilled|thrilling)\b', 2),
      EmotionPattern(r'\b(eager|eagerly)\b', 2),
      EmotionPattern(r'\b(enthusiastic|enthusiasm)\b', 2),
      EmotionPattern(r'\b(hyped|hype)\b', 2),
      EmotionPattern(r'\b(yay|woohoo|woo)\b', 2),
      EmotionPattern(r'[🤩🥳🎉✨]', 3),
      EmotionPattern(r'!{3,}', 1),
    ],
    SpriteEmotion.loving: [
      EmotionPattern(r'\b(love|loves|loving|loved)\b', 3),
      EmotionPattern(r'\b(adore|adores|adoring|adored)\b', 3),
      EmotionPattern(r'\b(affection|affectionate)\b', 2),
      EmotionPattern(r'\b(romantic|romantically)\b', 2),
      EmotionPattern(r'\b(heart)\b', 2),
      EmotionPattern(r'\b(darling|dear|sweetheart|honey)\b', 2),
      EmotionPattern(r'[❤️💕💖💗💘🥰😍💓💞]', 3),
    ],
    SpriteEmotion.thinking: [
      EmotionPattern(r'\b(think|thinks|thinking|thought)\b', 2),
      EmotionPattern(r'\b(ponder|ponders|pondering|pondered)\b', 3),
      EmotionPattern(r'\b(consider|considers|considering|considered)\b', 2),
      EmotionPattern(r'\b(contemplate|contemplates|contemplating)\b', 2),
      EmotionPattern(r'\b(wonder|wonders|wondering|wondered)\b', 2),
      EmotionPattern(r'\b(hmm+|hm+)\b', 2),
      EmotionPattern(r"\b(let me see|let's see)\b", 2),
      EmotionPattern(r'[🤔💭]', 3),
    ],
    SpriteEmotion.smug: [
      EmotionPattern(r'\b(smug|smugly)\b', 3),
      EmotionPattern(r'\b(confident|confidently|confidence)\b', 2),
      EmotionPattern(r'\b(proud|proudly|pride)\b', 2),
      EmotionPattern(r'\b(satisfied|satisfaction)\b', 2),
      EmotionPattern(r'\b(cocky)\b', 2),
      EmotionPattern(r'\b(smirk|smirks|smirking|smirked)\b', 3),
      EmotionPattern(r'[😏😎😼]', 3),
    ],
    SpriteEmotion.tired: [
      EmotionPattern(r'\b(tired|tiredly)\b', 3),
      EmotionPattern(r'\b(sleepy|sleep)\b', 2),
      EmotionPattern(r'\b(exhausted|exhaustion)\b', 3),
      EmotionPattern(r'\b(weary|weariness)\b', 2),
      EmotionPattern(r'\b(drowsy|drowsiness)\b', 2),
      EmotionPattern(r'\b(yawn|yawns|yawning|yawned)\b', 3),
      EmotionPattern(r'\b(sigh|sighs|sighing|sighed)\b', 2),
      EmotionPattern(r'[😴😪🥱]', 3),
    ],
    SpriteEmotion.bored: [
      EmotionPattern(r'\b(bored|boring|boredom)\b', 3),
      EmotionPattern(r'\b(uninterested)\b', 2),
      EmotionPattern(r'\b(dull)\b', 2),
      EmotionPattern(r'\b(meh)\b', 2),
      EmotionPattern(r'\b(whatever)\b', 1),
      EmotionPattern(r'[😐😑🙄]', 3),
    ],
  };

  /// Detect the primary emotion from message content
  /// Returns the emotion with the highest score, or neutral if no strong emotion detected
  SpriteEmotion detectEmotion(String content) {
    if (content.isEmpty) return SpriteEmotion.neutral;

    final scores = <SpriteEmotion, int>{};
    final lowerContent = content.toLowerCase();

    for (final entry in _emotionPatterns.entries) {
      final emotion = entry.key;
      final patterns = entry.value;
      int score = 0;

      for (final pattern in patterns) {
        final regex = RegExp(pattern.pattern, caseSensitive: false);
        final matches = regex.allMatches(lowerContent);
        score += matches.length * pattern.weight;
      }

      if (score > 0) {
        scores[emotion] = score;
      }
    }

    if (scores.isEmpty) return SpriteEmotion.neutral;

    // Find the emotion with the highest score
    final sortedEmotions = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEmotions.first.key;
  }

  /// Detect emotion with confidence score (0.0 - 1.0)
  EmotionResult detectEmotionWithConfidence(String content) {
    if (content.isEmpty) {
      return EmotionResult(SpriteEmotion.neutral, 0.0);
    }

    final scores = <SpriteEmotion, int>{};
    final lowerContent = content.toLowerCase();
    int totalScore = 0;

    for (final entry in _emotionPatterns.entries) {
      final emotion = entry.key;
      final patterns = entry.value;
      int score = 0;

      for (final pattern in patterns) {
        final regex = RegExp(pattern.pattern, caseSensitive: false);
        final matches = regex.allMatches(lowerContent);
        score += matches.length * pattern.weight;
      }

      if (score > 0) {
        scores[emotion] = score;
        totalScore += score;
      }
    }

    if (scores.isEmpty) {
      return EmotionResult(SpriteEmotion.neutral, 0.0);
    }

    // Find the emotion with the highest score
    final sortedEmotions = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topEmotion = sortedEmotions.first;
    final confidence = totalScore > 0 ? topEmotion.value / totalScore : 0.0;

    return EmotionResult(topEmotion.key, confidence.clamp(0.0, 1.0));
  }

  /// Detect all emotions present in the content with their scores
  List<EmotionResult> detectAllEmotions(String content) {
    if (content.isEmpty) {
      return [EmotionResult(SpriteEmotion.neutral, 1.0)];
    }

    final scores = <SpriteEmotion, int>{};
    final lowerContent = content.toLowerCase();
    int totalScore = 0;

    for (final entry in _emotionPatterns.entries) {
      final emotion = entry.key;
      final patterns = entry.value;
      int score = 0;

      for (final pattern in patterns) {
        final regex = RegExp(pattern.pattern, caseSensitive: false);
        final matches = regex.allMatches(lowerContent);
        score += matches.length * pattern.weight;
      }

      if (score > 0) {
        scores[emotion] = score;
        totalScore += score;
      }
    }

    if (scores.isEmpty) {
      return [EmotionResult(SpriteEmotion.neutral, 1.0)];
    }

    // Convert to results with confidence
    final results = scores.entries.map((e) {
      final confidence = totalScore > 0 ? e.value / totalScore : 0.0;
      return EmotionResult(e.key, confidence.clamp(0.0, 1.0));
    }).toList();

    // Sort by confidence descending
    results.sort((a, b) => b.confidence.compareTo(a.confidence));

    return results;
  }

  /// Extract emotion from action text (e.g., "*smiles warmly*" -> happy)
  SpriteEmotion? detectEmotionFromAction(String content) {
    // Look for action markers like *action* or (action)
    final actionRegex = RegExp(r'\*([^*]+)\*|\(([^)]+)\)');
    final matches = actionRegex.allMatches(content);

    for (final match in matches) {
      final actionText = match.group(1) ?? match.group(2) ?? '';
      final emotion = detectEmotion(actionText);
      if (emotion != SpriteEmotion.neutral) {
        return emotion;
      }
    }

    return null;
  }
}

/// Pattern for emotion detection with weight
class EmotionPattern {
  final String pattern;
  final int weight;

  const EmotionPattern(this.pattern, this.weight);
}

/// Result of emotion detection
class EmotionResult {
  final SpriteEmotion emotion;
  final double confidence;

  const EmotionResult(this.emotion, this.confidence);

  @override
  String toString() => 'EmotionResult($emotion, ${(confidence * 100).toStringAsFixed(1)}%)';
}