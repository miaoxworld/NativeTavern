import 'dart:math';
import 'package:intl/intl.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/chat.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/domain/services/variables_service.dart';

/// Service for expanding macros in text
/// Supports SillyTavern-compatible macros: {{user}}, {{char}}, {{time}}, etc.
/// Includes Macros 2.0 features: scoped {{if}}...{{else}}...{{/if}} blocks with
/// lazy evaluation, and variable shorthands ({{.local}}, {{$global}}) with operators.
class MacroService {
  final Random _random = Random();

  /// Context for macro expansion
  final MacroContext context;

  /// Guard against runaway recursion in condition resolution
  int _recursionDepth = 0;
  static const int _maxRecursionDepth = 10;

  MacroService(this.context);

  /// Process all macros in the given text
  String process(String text) {
    if (text.isEmpty) return text;

    String result = text;

    // Process macros in order of complexity (more specific first)
    result = _processScopedIfMacros(result);
    result = _processVariableShorthands(result);
    result = _processRandomMacros(result);
    result = _processConditionalMacros(result);
    result = _processTimeDateMacros(result);
    result = _processCharacterMacros(result);
    result = _processUserMacros(result);
    result = _processChatMacros(result);
    result = _processSpecialMacros(result);

    return result;
  }

  /// Process {{user}} and related user macros
  String _processUserMacros(String text) {
    String result = text;

    // {{user}} - User's display name
    result = result.replaceAll(
      RegExp(r'\{\{user\}\}', caseSensitive: false),
      context.userName,
    );

    // {{persona}} - Same as {{user}} for compatibility
    result = result.replaceAll(
      RegExp(r'\{\{persona\}\}', caseSensitive: false),
      context.userName,
    );

    // {{user_description}} or {{persona_description}} - User's description/personality
    result = result.replaceAll(
      RegExp(r'\{\{user_description\}\}', caseSensitive: false),
      context.userDescription,
    );
    result = result.replaceAll(
      RegExp(r'\{\{persona_description\}\}', caseSensitive: false),
      context.userDescription,
    );

    return result;
  }

  /// Process {{char}} and related character macros
  String _processCharacterMacros(String text) {
    String result = text;

    // {{char}} - Character's name
    result = result.replaceAll(
      RegExp(r'\{\{char\}\}', caseSensitive: false),
      context.characterName,
    );

    // {{charname}} - Same as {{char}}
    result = result.replaceAll(
      RegExp(r'\{\{charname\}\}', caseSensitive: false),
      context.characterName,
    );

    // {{charVersion}}, {{char_version}} or {{version}} - version field
    result = result.replaceAll(
      RegExp(r'\{\{charVersion\}\}', caseSensitive: false),
      context.characterVersion,
    );
    result = result.replaceAll(
      RegExp(r'\{\{char_version\}\}', caseSensitive: false),
      context.characterVersion,
    );
    result = result.replaceAll(
      RegExp(r'\{\{version\}\}', caseSensitive: false),
      context.characterVersion,
    );

    // {{description}} - Character's description
    result = result.replaceAll(
      RegExp(r'\{\{description\}\}', caseSensitive: false),
      context.characterDescription,
    );

    // {{personality}} - Character's personality
    result = result.replaceAll(
      RegExp(r'\{\{personality\}\}', caseSensitive: false),
      context.characterPersonality,
    );

    // {{scenario}} - Character's scenario
    result = result.replaceAll(
      RegExp(r'\{\{scenario\}\}', caseSensitive: false),
      context.characterScenario,
    );

    // {{greeting::N}} or {{charFirstMessage::N}} - indexed greeting
    // (0 = main greeting, 1+ = alternate greetings)
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{(?:greeting|charFirstMessage)::(\d+)\}\}',
          caseSensitive: false),
      (match) {
        final index = int.parse(match.group(1)!);
        if (index == 0) return context.characterFirstMessage;
        final alternates = context.alternateGreetings;
        if (index - 1 < alternates.length) return alternates[index - 1];
        return '';
      },
    );

    // {{first_mes}}, {{greeting}} or {{charFirstMessage}} - first message
    result = result.replaceAll(
      RegExp(r'\{\{first_mes\}\}', caseSensitive: false),
      context.characterFirstMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{greeting\}\}', caseSensitive: false),
      context.characterFirstMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{charFirstMessage\}\}', caseSensitive: false),
      context.characterFirstMessage,
    );

    // {{mes_example}}, {{mesExamples}} or {{examples}} - example dialogues
    result = result.replaceAll(
      RegExp(r'\{\{mes_example\}\}', caseSensitive: false),
      context.characterExamples,
    );
    result = result.replaceAll(
      RegExp(r'\{\{mesExamples\}\}', caseSensitive: false),
      context.characterExamples,
    );
    result = result.replaceAll(
      RegExp(r'\{\{examples\}\}', caseSensitive: false),
      context.characterExamples,
    );

    // {{system_prompt}}, {{char_system_prompt}} or {{charPrompt}}
    result = result.replaceAll(
      RegExp(r'\{\{system_prompt\}\}', caseSensitive: false),
      context.characterSystemPrompt,
    );
    result = result.replaceAll(
      RegExp(r'\{\{char_system_prompt\}\}', caseSensitive: false),
      context.characterSystemPrompt,
    );
    result = result.replaceAll(
      RegExp(r'\{\{charPrompt\}\}', caseSensitive: false),
      context.characterSystemPrompt,
    );

    // {{post_history_instructions}} - Character's post-history instructions
    result = result.replaceAll(
      RegExp(r'\{\{post_history_instructions\}\}', caseSensitive: false),
      context.postHistoryInstructions,
    );

    // {{jailbreak}} or {{charJailbreak}} - Alias for post_history_instructions
    result = result.replaceAll(
      RegExp(r'\{\{jailbreak\}\}', caseSensitive: false),
      context.postHistoryInstructions,
    );
    result = result.replaceAll(
      RegExp(r'\{\{charJailbreak\}\}', caseSensitive: false),
      context.postHistoryInstructions,
    );

    // {{group}} - Comma-separated group member names
    // (or character name outside of groups)
    result = result.replaceAll(
      RegExp(r'\{\{group\}\}', caseSensitive: false),
      context.groupCharacterNames.isNotEmpty
          ? context.groupCharacterNames.join(', ')
          : context.characterName,
    );

    return result;
  }

  /// Process time and date macros
  String _processTimeDateMacros(String text) {
    String result = text;
    final now = DateTime.now();

    // {{time}} - Current time (HH:mm)
    result = result.replaceAll(
      RegExp(r'\{\{time\}\}', caseSensitive: false),
      DateFormat('HH:mm').format(now),
    );

    // {{time_12h}} - Current time in 12-hour format
    result = result.replaceAll(
      RegExp(r'\{\{time_12h\}\}', caseSensitive: false),
      DateFormat('hh:mm a').format(now),
    );

    // {{date}} - Current date (YYYY-MM-DD)
    result = result.replaceAll(
      RegExp(r'\{\{date\}\}', caseSensitive: false),
      DateFormat('yyyy-MM-dd').format(now),
    );

    // {{date_local}} - Current date in local format
    result = result.replaceAll(
      RegExp(r'\{\{date_local\}\}', caseSensitive: false),
      DateFormat.yMMMd().format(now),
    );

    // {{weekday}} - Current day of week
    result = result.replaceAll(
      RegExp(r'\{\{weekday\}\}', caseSensitive: false),
      DateFormat('EEEE').format(now),
    );

    // {{day}} - Day of month
    result = result.replaceAll(
      RegExp(r'\{\{day\}\}', caseSensitive: false),
      now.day.toString(),
    );

    // {{month}} - Month name
    result = result.replaceAll(
      RegExp(r'\{\{month\}\}', caseSensitive: false),
      DateFormat('MMMM').format(now),
    );

    // {{year}} - Year
    result = result.replaceAll(
      RegExp(r'\{\{year\}\}', caseSensitive: false),
      now.year.toString(),
    );

    // {{datetime}} - Full datetime
    result = result.replaceAll(
      RegExp(r'\{\{datetime\}\}', caseSensitive: false),
      DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
    );

    // {{iso_date}} - ISO 8601 datetime
    result = result.replaceAll(
      RegExp(r'\{\{iso_date\}\}', caseSensitive: false),
      now.toIso8601String(),
    );

    return result;
  }

  /// Process chat-related macros
  String _processChatMacros(String text) {
    String result = text;

    // {{lastMessage}} or {{last_message}} - Last message content
    result = result.replaceAll(
      RegExp(r'\{\{lastMessage\}\}', caseSensitive: false),
      context.lastMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{last_message\}\}', caseSensitive: false),
      context.lastMessage,
    );

    // {{lastUserMessage}} or {{last_user_message}} - Last user message
    result = result.replaceAll(
      RegExp(r'\{\{lastUserMessage\}\}', caseSensitive: false),
      context.lastUserMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{last_user_message\}\}', caseSensitive: false),
      context.lastUserMessage,
    );

    // {{lastCharMessage}} or {{last_char_message}} - Last character message
    result = result.replaceAll(
      RegExp(r'\{\{lastCharMessage\}\}', caseSensitive: false),
      context.lastCharacterMessage,
    );
    result = result.replaceAll(
      RegExp(r'\{\{last_char_message\}\}', caseSensitive: false),
      context.lastCharacterMessage,
    );

    // {{messageCount}} or {{message_count}} - Total message count
    result = result.replaceAll(
      RegExp(r'\{\{messageCount\}\}', caseSensitive: false),
      context.messageCount.toString(),
    );
    result = result.replaceAll(
      RegExp(r'\{\{message_count\}\}', caseSensitive: false),
      context.messageCount.toString(),
    );

    // {{chatId}} or {{chat_id}} - Chat ID
    result = result.replaceAll(
      RegExp(r'\{\{chatId\}\}', caseSensitive: false),
      context.chatId,
    );
    result = result.replaceAll(
      RegExp(r'\{\{chat_id\}\}', caseSensitive: false),
      context.chatId,
    );

    return result;
  }

  /// Process random macros
  String _processRandomMacros(String text) {
    String result = text;

    // {{random}} - Random number 0-100
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{random\}\}', caseSensitive: false),
      (match) => _random.nextInt(101).toString(),
    );

    // {{random::min::max}} - Random number between min and max
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{random::(\d+)::(\d+)\}\}', caseSensitive: false),
      (match) {
        final min = int.parse(match.group(1)!);
        final max = int.parse(match.group(2)!);
        if (min >= max) return min.toString();
        return (min + _random.nextInt(max - min + 1)).toString();
      },
    );

    // {{roll::dice}} - Roll dice (e.g., {{roll::d20}}, {{roll::2d6}})
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{roll::(\d*)d(\d+)\}\}', caseSensitive: false),
      (match) {
        final count = match.group(1)!.isEmpty ? 1 : int.parse(match.group(1)!);
        final sides = int.parse(match.group(2)!);
        if (sides <= 0) return '0';

        int total = 0;
        for (int i = 0; i < count; i++) {
          total += _random.nextInt(sides) + 1;
        }
        return total.toString();
      },
    );

    // {{pick::option1::option2::option3}} - Pick a random option.
    // Unlike {{random}}, the pick is stable within a chat: the same macro
    // at the same position always resolves to the same option (ST behavior)
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{pick::([^}]+)\}\}', caseSensitive: false),
      (match) {
        final options = match.group(1)!.split('::');
        if (options.isEmpty) return '';
        final seed =
            _stableSeed('${context.chatId}|${match.group(0)}|${match.start}');
        return options[seed % options.length];
      },
    );

    // {{uuid}} - Generate UUID
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{uuid\}\}', caseSensitive: false),
      (match) => _generateUuid(),
    );

    return result;
  }

  // ==================== Macros 2.0: Scoped {{if}} ====================

  /// Process scoped conditional blocks (Macros 2.0):
  /// `{{if condition}}then{{/if}}`
  /// `{{if condition}}then{{else}}other{{/if}}`
  /// `{{if !condition}}...{{/if}}` (inverted)
  ///
  /// Lazy evaluation: macros in the dropped branch are never expanded.
  /// Supports nesting.
  String _processScopedIfMacros(String text) {
    // Opening tag: {{if <condition>}} with a space (the inline form uses {{if::)
    final openRe = RegExp(r'\{\{if\s+([^}]+)\}\}', caseSensitive: false);
    // Tokens that affect block structure
    final tokenRe =
        RegExp(r'\{\{(if\s+[^}]+|else|/if)\}\}', caseSensitive: false);

    var iterations = 0;
    while (iterations++ < 100) {
      // The inline form {{if cond::content}} contains '::' and is not
      // a scoped block opener - skip those
      RegExpMatch? open;
      for (final m in openRe.allMatches(text)) {
        if (!m.group(1)!.contains('::')) {
          open = m;
          break;
        }
      }
      if (open == null) break;

      // Find the matching {{/if}}, tracking nesting depth,
      // and the top-level {{else}} if present
      var depth = 1;
      int? elseStart, elseEnd, closeStart, closeEnd;
      for (final t in tokenRe.allMatches(text, open.end)) {
        final token = t.group(1)!.toLowerCase();
        if (token.startsWith('if')) {
          if (token.contains('::')) continue; // inline form, not a block
          depth++;
        } else if (token == '/if') {
          depth--;
          if (depth == 0) {
            closeStart = t.start;
            closeEnd = t.end;
            break;
          }
        } else if (token == 'else' && depth == 1 && elseStart == null) {
          elseStart = t.start;
          elseEnd = t.end;
        }
      }

      if (closeStart == null || closeEnd == null) {
        // Unbalanced block: drop the opening tag and continue
        text = text.replaceRange(open.start, open.end, '');
        continue;
      }

      final String thenBranch;
      final String elseBranch;
      if (elseStart != null && elseEnd != null) {
        thenBranch = text.substring(open.end, elseStart);
        elseBranch = text.substring(elseEnd, closeStart);
      } else {
        thenBranch = text.substring(open.end, closeStart);
        elseBranch = '';
      }

      final chosen =
          _evaluateCondition(open.group(1)!.trim()) ? thenBranch : elseBranch;
      // The chosen branch stays in the text and is processed by the
      // remaining loop iterations (nested ifs) and pipeline stages
      text = text.replaceRange(open.start, closeEnd, chosen);
    }

    return text;
  }

  // ==================== Macros 2.0: Variable shorthands ====================

  /// Variable name pattern: starts with a letter, may contain
  /// word chars and inner hyphens, must not end with a hyphen
  static const String _varNamePattern = r'[a-zA-Z](?:[\w\-]*[\w])?';

  /// Process variable shorthand macros (Macros 2.0):
  /// `{{.name}}` / `{{$name}}` - get local / global variable
  /// `{{.name=value}}` - assign, `{{.name+=n}}` / `{{.name-=n}}` - add/subtract
  /// `{{.name++}}` / `{{.name--}}` - increment/decrement
  /// `{{.name==v}}` `!=` `>` `>=` `<` `<=` - comparisons (return true/false)
  /// `{{.name??default}}` / `{{.name||default}}` - fallbacks
  /// `{{.name??=v}}` / `{{.name||=v}}` - conditional assignment
  String _processVariableShorthands(String text) {
    // Operator form (longest operators first so e.g. `>=` wins over `>`)
    final opRe = RegExp(
      r'\{\{([.$])(' +
          _varNamePattern +
          r')\s*(\+\+|--|\?\?=|\|\|=|\?\?|\|\||\+=|-=|==|!=|>=|<=|>|<|=)\s*([^}]*)\}\}',
    );
    var result = text.replaceAllMapped(opRe, (m) {
      final global = m.group(1) == r'$';
      final name = m.group(2)!;
      final op = m.group(3)!;
      final value = m.group(4)!.trim();
      return _applyVariableOperator(name, op, value, global: global);
    });

    // Plain get form
    final getRe = RegExp(r'\{\{([.$])(' + _varNamePattern + r')\}\}');
    result = result.replaceAllMapped(getRe, (m) {
      final global = m.group(1) == r'$';
      return _readVariable(m.group(2)!, global: global) ?? '';
    });

    return result;
  }

  String? _readVariable(String name, {required bool global}) {
    final vars = VariablesService.instance;
    if (global) {
      if (!vars.existsGlobalVariable(name)) return null;
      return vars.getGlobalVariable(name)?.toString() ?? '';
    }
    if (context.chatId.isEmpty ||
        !vars.existsLocalVariable(context.chatId, name)) {
      return null;
    }
    return vars.getLocalVariable(context.chatId, name)?.toString() ?? '';
  }

  void _writeVariable(String name, String value, {required bool global}) {
    final vars = VariablesService.instance;
    if (global) {
      // Fire-and-forget persistence
      vars.setGlobalVariable(name, value);
    } else if (context.chatId.isNotEmpty) {
      vars.setLocalVariable(context.chatId, name, value);
    }
  }

  String _applyVariableOperator(
    String name,
    String op,
    String value, {
    required bool global,
  }) {
    final current = _readVariable(name, global: global);

    switch (op) {
      case '=':
        _writeVariable(name, value, global: global);
        return '';
      case '+=':
        _writeVariable(name, _addValues(current ?? '', value), global: global);
        return '';
      case '-=':
        _writeVariable(name, _subtractValues(current ?? '0', value),
            global: global);
        return '';
      case '++':
        _writeVariable(name, _addValues(current ?? '0', '1'), global: global);
        return '';
      case '--':
        _writeVariable(name, _subtractValues(current ?? '0', '1'),
            global: global);
        return '';
      case '??':
        return current ?? value;
      case '||':
        return (current == null || _isFalsyValue(current)) ? value : current;
      case '??=':
        if (current == null) _writeVariable(name, value, global: global);
        return '';
      case '||=':
        if (current == null || _isFalsyValue(current)) {
          _writeVariable(name, value, global: global);
        }
        return '';
      case '==':
        return (_compareValues(current ?? '', value) == 0).toString();
      case '!=':
        return (_compareValues(current ?? '', value) != 0).toString();
      case '>':
        return (_compareValues(current ?? '', value) > 0).toString();
      case '>=':
        return (_compareValues(current ?? '', value) >= 0).toString();
      case '<':
        return (_compareValues(current ?? '', value) < 0).toString();
      case '<=':
        return (_compareValues(current ?? '', value) <= 0).toString();
    }
    return '';
  }

  /// Add two values: numeric addition when both are numbers, else concatenation
  String _addValues(String a, String b) {
    final na = num.tryParse(a);
    final nb = num.tryParse(b);
    if (na != null && nb != null) return _formatNum(na + nb);
    return a + b;
  }

  String _subtractValues(String a, String b) {
    final na = num.tryParse(a) ?? 0;
    final nb = num.tryParse(b) ?? 0;
    return _formatNum(na - nb);
  }

  /// Compare two values numerically when possible, else as strings
  int _compareValues(String a, String b) {
    final na = num.tryParse(a);
    final nb = num.tryParse(b);
    if (na != null && nb != null) return na.compareTo(nb);
    return a.compareTo(b);
  }

  String _formatNum(num n) {
    if (n is int || n == n.roundToDouble()) return n.toInt().toString();
    return n.toString();
  }

  bool _isFalsyValue(String v) {
    final s = v.trim().toLowerCase();
    return s.isEmpty || s == 'false' || s == 'off' || s == '0';
  }

  /// Process conditional macros (inline forms)
  String _processConditionalMacros(String text) {
    String result = text;

    // {{if condition::content}} - ST Macros 2.0 inline form
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{if\s+([^:}]+)::([^}]*?)\}\}', caseSensitive: false),
      (match) {
        final condition = match.group(1)!.trim();
        final thenValue = match.group(2)!;

        if (_evaluateCondition(condition)) {
          return thenValue;
        }
        return '';
      },
    );

    // {{if::condition::then}} - Simple if
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{if::([^:]*?)::([^}]*?)\}\}', caseSensitive: false),
      (match) {
        final condition = match.group(1)!.trim();
        final thenValue = match.group(2)!;

        if (_evaluateCondition(condition)) {
          return thenValue;
        }
        return '';
      },
    );

    // {{if::condition::then::else}} - If-else
    result = _replaceAllWithCallback(
      result,
      RegExp(r'\{\{if::([^:]*?)::([^:]*?)::([^}]*?)\}\}', caseSensitive: false),
      (match) {
        final condition = match.group(1)!.trim();
        final thenValue = match.group(2)!;
        final elseValue = match.group(3)!;

        if (_evaluateCondition(condition)) {
          return thenValue;
        }
        return elseValue;
      },
    );

    return result;
  }

  /// Process special/utility macros
  String _processSpecialMacros(String text) {
    String result = text;

    // {{newline}} or {{nl}} - Newline character
    result = result.replaceAll(
      RegExp(r'\{\{newline\}\}', caseSensitive: false),
      '\n',
    );
    result = result.replaceAll(
      RegExp(r'\{\{nl\}\}', caseSensitive: false),
      '\n',
    );

    // {{trim}} - Remove surrounding whitespace (marker only)
    result = result.replaceAll(
      RegExp(r'\{\{trim\}\}', caseSensitive: false),
      '',
    );

    // {{noop}} - No operation (useful for testing)
    result = result.replaceAll(
      RegExp(r'\{\{noop\}\}', caseSensitive: false),
      '',
    );

    // {{original}} - For use in prompt overrides
    result = result.replaceAll(
      RegExp(r'\{\{original\}\}', caseSensitive: false),
      context.originalPrompt,
    );

    // {{input}} - Current user input
    result = result.replaceAll(
      RegExp(r'\{\{input\}\}', caseSensitive: false),
      context.currentInput,
    );

    // {{model}} - Current model name
    result = result.replaceAll(
      RegExp(r'\{\{model\}\}', caseSensitive: false),
      context.modelName,
    );

    // {{provider}} - Current provider name
    result = result.replaceAll(
      RegExp(r'\{\{provider\}\}', caseSensitive: false),
      context.providerName,
    );

    // {{idle_duration}} - Time since last message (in minutes)
    result = result.replaceAll(
      RegExp(r'\{\{idle_duration\}\}', caseSensitive: false),
      context.idleDuration.toString(),
    );

    // {{maxContext}} / {{maxContextTokens}} / {{maxPromptTokens}}
    result = result.replaceAll(
      RegExp(r'\{\{(?:maxContext|maxContextTokens|maxPromptTokens)\}\}',
          caseSensitive: false),
      context.maxContextTokens.toString(),
    );

    // {{maxResponse}} / {{maxResponseTokens}}
    result = result.replaceAll(
      RegExp(r'\{\{(?:maxResponse|maxResponseTokens)\}\}',
          caseSensitive: false),
      context.maxResponseTokens.toString(),
    );

    return result;
  }

  /// Evaluate a condition following ST Macros 2.0 semantics:
  /// - `!` prefix inverts the result
  /// - nested macros in the condition are resolved first
  /// - `.name` / `$name` shorthands read local/global variables
  /// - a bare macro name (e.g. `description`) resolves that macro
  /// - falsy values: empty string, 'false', 'off', '0'
  bool _evaluateCondition(String condition) {
    condition = condition.trim();
    if (condition.isEmpty) return false;

    // Check for negation
    if (condition.startsWith('!')) {
      return !_evaluateCondition(condition.substring(1).trim());
    }

    // Check for explicit comparison operators
    for (final op in const ['==', '!=']) {
      if (condition.contains(op)) {
        final parts = condition.split(op);
        if (parts.length == 2) {
          final left = _resolveConditionValue(parts[0].trim());
          final right = _resolveConditionValue(parts[1].trim());
          final equal = _compareValues(left, right) == 0;
          return op == '==' ? equal : !equal;
        }
      }
    }

    return !_isFalsyValue(_resolveConditionValue(condition));
  }

  /// Resolve a condition operand: nested macros, variable shorthands,
  /// or bare macro names
  String _resolveConditionValue(String value) {
    if (_recursionDepth >= _maxRecursionDepth) return value;

    // Nested macros like {{getvar::x}} or {{description}}
    if (value.contains('{{')) {
      _recursionDepth++;
      final resolved = process(value);
      _recursionDepth--;
      return resolved;
    }

    // Variable shorthand: .name (local) or $name (global)
    final varMatch =
        RegExp(r'^([.$])(' + _varNamePattern + r')$').firstMatch(value);
    if (varMatch != null) {
      return _readVariable(varMatch.group(2)!,
              global: varMatch.group(1) == r'$') ??
          '';
    }

    // Bare macro name: resolve {{name}} if it changes anything
    if (RegExp(r'^[a-zA-Z_][\w]*$').hasMatch(value)) {
      _recursionDepth++;
      final resolved = process('{{$value}}');
      _recursionDepth--;
      if (resolved != '{{$value}}') return resolved;
    }

    return value;
  }

  /// Deterministic seed from a string (FNV-1a hash)
  int _stableSeed(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }

  /// Helper to replace all matches with callback function
  String _replaceAllWithCallback(
    String text,
    RegExp regex,
    String Function(Match) callback,
  ) {
    return text.replaceAllMapped(regex, callback);
  }

  /// Generate a simple UUID v4
  String _generateUuid() {
    final random = Random();
    const hexDigits = '0123456789abcdef';

    final uuid = List<String>.generate(36, (i) {
      if (i == 8 || i == 13 || i == 18 || i == 23) {
        return '-';
      }
      if (i == 14) {
        return '4'; // Version 4
      }
      if (i == 19) {
        return hexDigits[(random.nextInt(4) + 8)]; // Variant bits
      }
      return hexDigits[random.nextInt(16)];
    });

    return uuid.join();
  }
}

/// Context data for macro expansion
class MacroContext {
  // User/Persona data
  final String userName;
  final String userDescription;

  // Character data
  final String characterName;
  final String characterDescription;
  final String characterPersonality;
  final String characterScenario;
  final String characterFirstMessage;
  final String characterExamples;
  final String characterSystemPrompt;
  final String characterVersion;
  final String postHistoryInstructions;

  // Chat data
  final String chatId;
  final int messageCount;
  final String lastMessage;
  final String lastUserMessage;
  final String lastCharacterMessage;

  // Current state
  final String currentInput;
  final String originalPrompt;
  final String modelName;
  final String providerName;
  final int idleDuration;

  // Group chat data (optional)
  final List<String> groupCharacterNames;

  // Alternate greetings for {{greeting::N}}
  final List<String> alternateGreetings;

  // Token limits for {{maxContextTokens}} / {{maxResponseTokens}}
  final int maxContextTokens;
  final int maxResponseTokens;

  const MacroContext({
    this.userName = 'User',
    this.userDescription = '',
    this.characterName = 'Assistant',
    this.characterDescription = '',
    this.characterPersonality = '',
    this.characterScenario = '',
    this.characterFirstMessage = '',
    this.characterExamples = '',
    this.characterSystemPrompt = '',
    this.characterVersion = '',
    this.postHistoryInstructions = '',
    this.chatId = '',
    this.messageCount = 0,
    this.lastMessage = '',
    this.lastUserMessage = '',
    this.lastCharacterMessage = '',
    this.currentInput = '',
    this.originalPrompt = '',
    this.modelName = '',
    this.providerName = '',
    this.idleDuration = 0,
    this.groupCharacterNames = const [],
    this.alternateGreetings = const [],
    this.maxContextTokens = 0,
    this.maxResponseTokens = 0,
  });

  /// Create MacroContext from character, persona, and chat data
  factory MacroContext.fromData({
    Character? character,
    Persona? persona,
    Chat? chat,
    List<ChatMessage>? messages,
    String? currentInput,
    String? modelName,
    String? providerName,
    String? originalPrompt,
    List<Character>? groupCharacters,
    int? maxContextTokens,
    int? maxResponseTokens,
  }) {
    // Get last messages
    String lastMessage = '';
    String lastUserMessage = '';
    String lastCharMessage = '';

    if (messages != null && messages.isNotEmpty) {
      lastMessage = messages.last.content;

      for (final msg in messages.reversed) {
        if (msg.role == MessageRole.user && lastUserMessage.isEmpty) {
          lastUserMessage = msg.content;
        } else if (msg.role == MessageRole.assistant &&
            lastCharMessage.isEmpty) {
          lastCharMessage = msg.content;
        }

        if (lastUserMessage.isNotEmpty && lastCharMessage.isNotEmpty) {
          break;
        }
      }
    }

    // Calculate idle duration
    int idleDuration = 0;
    if (messages != null && messages.isNotEmpty) {
      final lastMsgTime = messages.last.timestamp;
      idleDuration = DateTime.now().difference(lastMsgTime).inMinutes;
    }

    return MacroContext(
      userName: persona?.name ?? 'User',
      userDescription: persona?.description ?? '',
      characterName: character?.name ?? 'Assistant',
      characterDescription: character?.description ?? '',
      characterPersonality: character?.personality ?? '',
      characterScenario: character?.scenario ?? '',
      characterFirstMessage: character?.firstMessage ?? '',
      characterExamples: character?.exampleMessages ?? '',
      characterSystemPrompt: character?.systemPrompt ?? '',
      characterVersion: character?.version ?? '',
      postHistoryInstructions: character?.postHistoryInstructions ?? '',
      chatId: chat?.id ?? '',
      messageCount: messages?.length ?? 0,
      lastMessage: lastMessage,
      lastUserMessage: lastUserMessage,
      lastCharacterMessage: lastCharMessage,
      currentInput: currentInput ?? '',
      originalPrompt: originalPrompt ?? '',
      modelName: modelName ?? '',
      providerName: providerName ?? '',
      idleDuration: idleDuration,
      groupCharacterNames: groupCharacters?.map((c) => c.name).toList() ?? [],
      alternateGreetings: character?.alternateGreetings ?? const [],
      maxContextTokens: maxContextTokens ?? 0,
      maxResponseTokens: maxResponseTokens ?? 0,
    );
  }

  MacroContext copyWith({
    String? userName,
    String? userDescription,
    String? characterName,
    String? characterDescription,
    String? characterPersonality,
    String? characterScenario,
    String? characterFirstMessage,
    String? characterExamples,
    String? characterSystemPrompt,
    String? characterVersion,
    String? postHistoryInstructions,
    String? chatId,
    int? messageCount,
    String? lastMessage,
    String? lastUserMessage,
    String? lastCharacterMessage,
    String? currentInput,
    String? originalPrompt,
    String? modelName,
    String? providerName,
    int? idleDuration,
    List<String>? groupCharacterNames,
    List<String>? alternateGreetings,
    int? maxContextTokens,
    int? maxResponseTokens,
  }) {
    return MacroContext(
      userName: userName ?? this.userName,
      userDescription: userDescription ?? this.userDescription,
      characterName: characterName ?? this.characterName,
      characterDescription: characterDescription ?? this.characterDescription,
      characterPersonality: characterPersonality ?? this.characterPersonality,
      characterScenario: characterScenario ?? this.characterScenario,
      characterFirstMessage:
          characterFirstMessage ?? this.characterFirstMessage,
      characterExamples: characterExamples ?? this.characterExamples,
      characterSystemPrompt:
          characterSystemPrompt ?? this.characterSystemPrompt,
      characterVersion: characterVersion ?? this.characterVersion,
      postHistoryInstructions:
          postHistoryInstructions ?? this.postHistoryInstructions,
      chatId: chatId ?? this.chatId,
      messageCount: messageCount ?? this.messageCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastUserMessage: lastUserMessage ?? this.lastUserMessage,
      lastCharacterMessage: lastCharacterMessage ?? this.lastCharacterMessage,
      currentInput: currentInput ?? this.currentInput,
      originalPrompt: originalPrompt ?? this.originalPrompt,
      modelName: modelName ?? this.modelName,
      providerName: providerName ?? this.providerName,
      idleDuration: idleDuration ?? this.idleDuration,
      groupCharacterNames: groupCharacterNames ?? this.groupCharacterNames,
      alternateGreetings: alternateGreetings ?? this.alternateGreetings,
      maxContextTokens: maxContextTokens ?? this.maxContextTokens,
      maxResponseTokens: maxResponseTokens ?? this.maxResponseTokens,
    );
  }
}

/// Extension to easily process macros on strings
extension MacroStringExtension on String {
  /// Process all macros in this string using the given context
  String processMacros(MacroContext context) {
    return MacroService(context).process(this);
  }
}
