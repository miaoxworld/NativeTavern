import 'package:native_tavern/data/models/regex_script.dart';

/// Service for managing and executing regex scripts
/// Based on SillyTavern's regex extension engine
class RegexService {
  /// Singleton instance
  static final RegexService instance = RegexService._();
  
  RegexService._();

  /// LRU cache for compiled regex patterns
  final Map<String, RegExp> _regexCache = {};
  static const int _maxCacheSize = 1000;

  /// Get or compile a regex from string
  /// Returns null if the regex is invalid
  RegExp? getRegex(String regexString) {
    // Check cache first
    if (_regexCache.containsKey(regexString)) {
      // LRU: Move to end by re-inserting
      final regex = _regexCache.remove(regexString)!;
      _regexCache[regexString] = regex;
      return regex;
    }

    // Try to compile the regex
    try {
      final regex = _parseRegexString(regexString);
      if (regex == null) return null;

      // Evict oldest if at capacity
      if (_regexCache.length >= _maxCacheSize) {
        _regexCache.remove(_regexCache.keys.first);
      }
      
      _regexCache[regexString] = regex;
      return regex;
    } catch (e) {
      print('RegexService: Failed to compile regex "$regexString": $e');
      return null;
    }
  }

  /// Parse a regex string in /pattern/flags format
  RegExp? _parseRegexString(String regexString) {
    // Handle /pattern/flags format
    if (regexString.startsWith('/')) {
      final lastSlash = regexString.lastIndexOf('/');
      if (lastSlash > 0) {
        final pattern = regexString.substring(1, lastSlash);
        final flags = regexString.substring(lastSlash + 1);
        
        bool caseSensitive = !flags.contains('i');
        bool multiLine = flags.contains('m');
        bool dotAll = flags.contains('s');
        bool unicode = flags.contains('u');
        
        return RegExp(
          pattern,
          caseSensitive: caseSensitive,
          multiLine: multiLine,
          dotAll: dotAll,
          unicode: unicode,
        );
      }
    }
    
    // Plain pattern without delimiters
    return RegExp(regexString);
  }

  /// Clear the regex cache
  void clearCache() {
    _regexCache.clear();
  }

  /// Apply a single regex script to a string
  String runRegexScript(
    RegexScript script,
    String input, {
    String? characterName,
    String? userName,
  }) {
    if (script.disabled || script.findRegex.isEmpty || input.isEmpty) {
      return input;
    }

    // Get the find regex, optionally with macro substitution
    String regexString = script.findRegex;
    if (script.substituteRegex == SubstituteRegex.raw) {
      regexString = _substituteMacros(regexString, characterName, userName);
    } else if (script.substituteRegex == SubstituteRegex.escaped) {
      regexString = _substituteMacrosEscaped(regexString, characterName, userName);
    }

    final regex = getRegex(regexString);
    if (regex == null) {
      return input;
    }

    // Perform the replacement
    try {
      return input.replaceAllMapped(regex, (match) {
        String replacement = script.replaceString;
        
        // Replace {{match}} with $0
        replacement = replacement.replaceAll(RegExp(r'\{\{match\}\}', caseSensitive: false), match.group(0) ?? '');
        
        // Replace numbered capture groups ($1, $2, etc.)
        for (int i = 0; i <= match.groupCount; i++) {
          final group = match.group(i) ?? '';
          final filteredGroup = _filterString(group, script.trimStrings);
          replacement = replacement.replaceAll('\$$i', filteredGroup);
        }
        
        // Replace named capture groups ($<name>)
        // Note: Named groups require RegExpMatch, which is available when using RegExp
        final namedGroupPattern = RegExp(r'\$<([^>]+)>');
        replacement = replacement.replaceAllMapped(namedGroupPattern, (m) {
          final groupName = m.group(1);
          if (groupName != null && match is RegExpMatch) {
            try {
              final regExpMatch = match as RegExpMatch;
              final groupValue = regExpMatch.namedGroup(groupName) ?? '';
              return _filterString(groupValue, script.trimStrings);
            } catch (_) {
              return '';
            }
          }
          return '';
        });
        
        // Substitute macros in the replacement
        replacement = _substituteMacros(replacement, characterName, userName);
        
        return replacement;
      });
    } catch (e) {
      print('RegexService: Error running script "${script.scriptName}": $e');
      return input;
    }
  }

  /// Apply all applicable regex scripts to a string
  String getRegexedString(
    String input,
    RegexPlacement placement,
    List<RegexScript> scripts, {
    String? characterName,
    String? userName,
    bool isMarkdown = false,
    bool isPrompt = false,
    bool isEdit = false,
    int? depth,
  }) {
    if (input.isEmpty) return input;

    String result = input;

    // Sort scripts by order
    final sortedScripts = List<RegexScript>.from(scripts)
      ..sort((a, b) => a.order.compareTo(b.order));

    for (final script in sortedScripts) {
      // Skip disabled scripts
      if (script.disabled) continue;

      // Check placement
      if (!script.placement.contains(placement)) continue;

      // Check markdown/prompt only flags
      if (script.markdownOnly && !isMarkdown) continue;
      if (script.promptOnly && !isPrompt) continue;
      if (!script.markdownOnly && !script.promptOnly && (isMarkdown || isPrompt)) continue;

      // Check edit flag
      if (isEdit && !script.runOnEdit) continue;

      // Check depth constraints
      if (depth != null) {
        if (script.minDepth != null && script.minDepth! >= -1 && depth < script.minDepth!) {
          continue;
        }
        if (script.maxDepth != null && script.maxDepth! >= 0 && depth > script.maxDepth!) {
          continue;
        }
      }

      // Run the script
      result = runRegexScript(
        script,
        result,
        characterName: characterName,
        userName: userName,
      );
    }

    return result;
  }

  /// Filter a string by removing trim strings
  String _filterString(String input, List<String> trimStrings) {
    if (trimStrings.isEmpty) return input;
    
    String result = input;
    for (final trim in trimStrings) {
      result = result.replaceAll(trim, '');
    }
    return result;
  }

  /// Substitute macros in a string (raw)
  String _substituteMacros(String input, String? characterName, String? userName) {
    String result = input;
    
    if (characterName != null) {
      result = result.replaceAll(RegExp(r'\{\{char\}\}', caseSensitive: false), characterName);
    }
    if (userName != null) {
      result = result.replaceAll(RegExp(r'\{\{user\}\}', caseSensitive: false), userName);
    }
    
    return result;
  }

  /// Substitute macros in a string with regex escaping
  String _substituteMacrosEscaped(String input, String? characterName, String? userName) {
    String result = input;
    
    if (characterName != null) {
      result = result.replaceAll(
        RegExp(r'\{\{char\}\}', caseSensitive: false),
        _escapeRegex(characterName),
      );
    }
    if (userName != null) {
      result = result.replaceAll(
        RegExp(r'\{\{user\}\}', caseSensitive: false),
        _escapeRegex(userName),
      );
    }
    
    return result;
  }

  /// Escape special regex characters in a string
  String _escapeRegex(String input) {
    return input.replaceAllMapped(
      RegExp(r'[\n\r\t\v\f\0.^$*+?{}\[\]\\/|()]'),
      (match) {
        final char = match.group(0)!;
        switch (char) {
          case '\n': return r'\n';
          case '\r': return r'\r';
          case '\t': return r'\t';
          case '\v': return r'\v';
          case '\f': return r'\f';
          case '\x00': return r'\0';
          default: return '\\$char';
        }
      },
    );
  }

  /// Test a regex pattern against a test string
  RegexTestResult testRegex(String pattern, String testString, String replacement) {
    try {
      final regex = getRegex(pattern);
      if (regex == null) {
        return RegexTestResult(
          success: false,
          error: 'Invalid regex pattern',
          matches: [],
          result: testString,
        );
      }

      final matches = regex.allMatches(testString).toList();
      final result = testString.replaceAllMapped(regex, (match) {
        String rep = replacement;
        rep = rep.replaceAll(RegExp(r'\{\{match\}\}', caseSensitive: false), match.group(0) ?? '');
        for (int i = 0; i <= match.groupCount; i++) {
          rep = rep.replaceAll('\$$i', match.group(i) ?? '');
        }
        return rep;
      });

      return RegexTestResult(
        success: true,
        matches: matches.map((m) => RegexMatch(
          fullMatch: m.group(0) ?? '',
          start: m.start,
          end: m.end,
          groups: List.generate(m.groupCount + 1, (i) => m.group(i)),
        )).toList(),
        result: result,
      );
    } catch (e) {
      return RegexTestResult(
        success: false,
        error: e.toString(),
        matches: [],
        result: testString,
      );
    }
  }
}

/// Result of testing a regex
class RegexTestResult {
  final bool success;
  final String? error;
  final List<RegexMatch> matches;
  final String result;

  const RegexTestResult({
    required this.success,
    this.error,
    required this.matches,
    required this.result,
  });
}

/// A single regex match
class RegexMatch {
  final String fullMatch;
  final int start;
  final int end;
  final List<String?> groups;

  const RegexMatch({
    required this.fullMatch,
    required this.start,
    required this.end,
    required this.groups,
  });
}

/// Common regex script presets
class RegexPresets {
  /// Remove asterisks from roleplay actions
  static RegexScript removeAsterisks() {
    return RegexScript(
      id: 'preset_remove_asterisks',
      scriptName: 'Remove Asterisks',
      description: 'Removes asterisks from roleplay actions',
      findRegex: r'/\*([^*]+)\*/g',
      replaceString: r'$1',
      placement: [RegexPlacement.aiOutput],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Remove quotes from dialogue
  static RegexScript removeQuotes() {
    return RegexScript(
      id: 'preset_remove_quotes',
      scriptName: 'Remove Quotes',
      description: 'Removes quotation marks from dialogue',
      findRegex: r'/"([^"]+)"/g',
      replaceString: r'$1',
      placement: [RegexPlacement.aiOutput],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Convert *action* to italics
  static RegexScript actionToItalics() {
    return RegexScript(
      id: 'preset_action_italics',
      scriptName: 'Action to Italics',
      description: 'Converts *action* to _action_ for italic rendering',
      findRegex: r'/\*([^*]+)\*/g',
      replaceString: r'_$1_',
      placement: [RegexPlacement.aiOutput],
      markdownOnly: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Remove OOC (out of character) text
  static RegexScript removeOOC() {
    return RegexScript(
      id: 'preset_remove_ooc',
      scriptName: 'Remove OOC',
      description: 'Removes out-of-character text in parentheses or brackets',
      findRegex: r'/\(OOC:?[^)]*\)|\[OOC:?[^\]]*\]/gi',
      replaceString: '',
      placement: [RegexPlacement.aiOutput],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Censor profanity (example)
  static RegexScript censorProfanity() {
    return RegexScript(
      id: 'preset_censor',
      scriptName: 'Censor Profanity',
      description: 'Replaces common profanity with asterisks',
      findRegex: r'/\b(fuck|shit|damn)\b/gi',
      replaceString: '****',
      placement: [RegexPlacement.aiOutput, RegexPlacement.userInput],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get all presets
  static List<RegexScript> all() {
    return [
      removeAsterisks(),
      removeQuotes(),
      actionToItalics(),
      removeOOC(),
      censorProfanity(),
    ];
  }
}