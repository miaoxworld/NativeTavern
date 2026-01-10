import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing local (per-chat) and global variables
/// Based on SillyTavern's variables.js
class VariablesService {
  /// Singleton instance
  static final VariablesService instance = VariablesService._();
  
  VariablesService._();

  /// Global variables (app-wide, persisted)
  final Map<String, dynamic> _globalVariables = {};
  
  /// Local variables (per-chat, stored in chat metadata)
  /// Key is chatId, value is map of variable name to value
  final Map<String, Map<String, dynamic>> _localVariables = {};

  /// Storage key for global variables
  static const _globalStorageKey = 'global_variables';

  /// Initialize the service and load global variables
  Future<void> initialize() async {
    await _loadGlobalVariables();
  }

  Future<void> _loadGlobalVariables() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_globalStorageKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) {
          _globalVariables.clear();
          _globalVariables.addAll(decoded);
        }
      }
    } catch (e) {
      print('VariablesService: Error loading global variables: $e');
    }
  }

  Future<void> _saveGlobalVariables() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_globalStorageKey, jsonEncode(_globalVariables));
    } catch (e) {
      print('VariablesService: Error saving global variables: $e');
    }
  }

  // ==================== Global Variables ====================

  /// Get a global variable value
  dynamic getGlobalVariable(String name, {String? index}) {
    if (!_globalVariables.containsKey(name)) {
      return '';
    }

    var value = _globalVariables[name];

    // Handle indexed access
    if (index != null) {
      try {
        if (value is String) {
          value = jsonDecode(value);
        }
        
        final numIndex = int.tryParse(index);
        if (numIndex != null && value is List) {
          value = value[numIndex];
        } else if (value is Map) {
          value = value[index];
        }
        
        if (value is Map || value is List) {
          return jsonEncode(value);
        }
      } catch (_) {
        // Return as-is if parsing fails
      }
    }

    // Convert to number if possible
    if (value is String && value.trim().isNotEmpty) {
      final num = double.tryParse(value);
      if (num != null) {
        return num % 1 == 0 ? num.toInt() : num;
      }
    }

    return value ?? '';
  }

  /// Set a global variable value
  Future<void> setGlobalVariable(String name, dynamic value, {String? index, String? asType}) async {
    if (name.isEmpty) {
      throw ArgumentError('Variable name cannot be empty');
    }

    if (index != null) {
      try {
        var current = _globalVariables[name];
        if (current is String) {
          current = jsonDecode(current);
        }
        current ??= {};

        final convertedValue = _convertValueType(value, asType);
        final numIndex = int.tryParse(index);
        
        if (numIndex != null) {
          if (current is! List) {
            current = [];
          }
          // Extend list if needed
          while ((current as List).length <= numIndex) {
            current.add(null);
          }
          current[numIndex] = convertedValue;
        } else {
          if (current is! Map) {
            current = {};
          }
          (current as Map)[index] = convertedValue;
        }
        
        _globalVariables[name] = jsonEncode(current);
      } catch (_) {
        // Ignore errors
      }
    } else {
      _globalVariables[name] = value;
    }

    await _saveGlobalVariables();
  }

  /// Check if a global variable exists
  bool existsGlobalVariable(String name) {
    return _globalVariables.containsKey(name);
  }

  /// Delete a global variable
  Future<void> deleteGlobalVariable(String name) async {
    _globalVariables.remove(name);
    await _saveGlobalVariables();
  }

  /// Get all global variables
  Map<String, dynamic> getAllGlobalVariables() {
    return Map.unmodifiable(_globalVariables);
  }

  /// Clear all global variables
  Future<void> clearGlobalVariables() async {
    _globalVariables.clear();
    await _saveGlobalVariables();
  }

  /// Add to a global variable (increment number or append string/array)
  Future<dynamic> addGlobalVariable(String name, dynamic value) async {
    final currentValue = getGlobalVariable(name);
    
    // Try to handle as array
    try {
      final parsed = currentValue is String ? jsonDecode(currentValue) : currentValue;
      if (parsed is List) {
        parsed.add(value);
        await setGlobalVariable(name, jsonEncode(parsed));
        return parsed;
      }
    } catch (_) {
      // Not an array
    }

    // Try to handle as number
    final increment = value is num ? value : double.tryParse(value.toString());
    final current = currentValue is num ? currentValue : double.tryParse(currentValue.toString());

    if (increment != null && current != null) {
      final newValue = current + increment;
      await setGlobalVariable(name, newValue);
      return newValue;
    }

    // Concatenate as string
    final stringValue = '${currentValue ?? ''}$value';
    await setGlobalVariable(name, stringValue);
    return stringValue;
  }

  /// Increment a global variable by 1
  Future<dynamic> incrementGlobalVariable(String name) async {
    return addGlobalVariable(name, 1);
  }

  /// Decrement a global variable by 1
  Future<dynamic> decrementGlobalVariable(String name) async {
    return addGlobalVariable(name, -1);
  }

  // ==================== Local Variables (Per-Chat) ====================

  /// Get a local variable value for a specific chat
  dynamic getLocalVariable(String chatId, String name, {String? index}) {
    final chatVars = _localVariables[chatId];
    if (chatVars == null || !chatVars.containsKey(name)) {
      return '';
    }

    var value = chatVars[name];

    // Handle indexed access
    if (index != null) {
      try {
        if (value is String) {
          value = jsonDecode(value);
        }
        
        final numIndex = int.tryParse(index);
        if (numIndex != null && value is List) {
          value = value[numIndex];
        } else if (value is Map) {
          value = value[index];
        }
        
        if (value is Map || value is List) {
          return jsonEncode(value);
        }
      } catch (_) {
        // Return as-is if parsing fails
      }
    }

    // Convert to number if possible
    if (value is String && value.trim().isNotEmpty) {
      final num = double.tryParse(value);
      if (num != null) {
        return num % 1 == 0 ? num.toInt() : num;
      }
    }

    return value ?? '';
  }

  /// Set a local variable value for a specific chat
  void setLocalVariable(String chatId, String name, dynamic value, {String? index, String? asType}) {
    if (name.isEmpty) {
      throw ArgumentError('Variable name cannot be empty');
    }

    _localVariables[chatId] ??= {};

    if (index != null) {
      try {
        var current = _localVariables[chatId]![name];
        if (current is String) {
          current = jsonDecode(current);
        }
        current ??= {};

        final convertedValue = _convertValueType(value, asType);
        final numIndex = int.tryParse(index);
        
        if (numIndex != null) {
          if (current is! List) {
            current = [];
          }
          while ((current as List).length <= numIndex) {
            current.add(null);
          }
          current[numIndex] = convertedValue;
        } else {
          if (current is! Map) {
            current = {};
          }
          (current as Map)[index] = convertedValue;
        }
        
        _localVariables[chatId]![name] = jsonEncode(current);
      } catch (_) {
        // Ignore errors
      }
    } else {
      _localVariables[chatId]![name] = value;
    }
  }

  /// Check if a local variable exists
  bool existsLocalVariable(String chatId, String name) {
    return _localVariables[chatId]?.containsKey(name) ?? false;
  }

  /// Delete a local variable
  void deleteLocalVariable(String chatId, String name) {
    _localVariables[chatId]?.remove(name);
  }

  /// Get all local variables for a chat
  Map<String, dynamic> getAllLocalVariables(String chatId) {
    return Map.unmodifiable(_localVariables[chatId] ?? {});
  }

  /// Clear all local variables for a chat
  void clearLocalVariables(String chatId) {
    _localVariables.remove(chatId);
  }

  /// Load local variables from chat metadata
  void loadLocalVariablesFromMetadata(String chatId, Map<String, dynamic>? metadata) {
    if (metadata != null && metadata.containsKey('variables')) {
      final vars = metadata['variables'];
      if (vars is Map<String, dynamic>) {
        _localVariables[chatId] = Map<String, dynamic>.from(vars);
      }
    }
  }

  /// Export local variables to chat metadata
  Map<String, dynamic>? exportLocalVariablesToMetadata(String chatId) {
    final vars = _localVariables[chatId];
    if (vars == null || vars.isEmpty) {
      return null;
    }
    return {'variables': Map<String, dynamic>.from(vars)};
  }

  /// Add to a local variable (increment number or append string/array)
  dynamic addLocalVariable(String chatId, String name, dynamic value) {
    final currentValue = getLocalVariable(chatId, name);
    
    // Try to handle as array
    try {
      final parsed = currentValue is String ? jsonDecode(currentValue) : currentValue;
      if (parsed is List) {
        parsed.add(value);
        setLocalVariable(chatId, name, jsonEncode(parsed));
        return parsed;
      }
    } catch (_) {
      // Not an array
    }

    // Try to handle as number
    final increment = value is num ? value : double.tryParse(value.toString());
    final current = currentValue is num ? currentValue : double.tryParse(currentValue.toString());

    if (increment != null && current != null) {
      final newValue = current + increment;
      setLocalVariable(chatId, name, newValue);
      return newValue;
    }

    // Concatenate as string
    final stringValue = '${currentValue ?? ''}$value';
    setLocalVariable(chatId, name, stringValue);
    return stringValue;
  }

  /// Increment a local variable by 1
  dynamic incrementLocalVariable(String chatId, String name) {
    return addLocalVariable(chatId, name, 1);
  }

  /// Decrement a local variable by 1
  dynamic decrementLocalVariable(String chatId, String name) {
    return addLocalVariable(chatId, name, -1);
  }

  // ==================== Variable Resolution ====================

  /// Resolve a variable name to its value
  /// Checks local variables first, then global
  dynamic resolveVariable(String name, {String? chatId}) {
    if (chatId != null && existsLocalVariable(chatId, name)) {
      return getLocalVariable(chatId, name);
    }

    if (existsGlobalVariable(name)) {
      return getGlobalVariable(name);
    }

    return name; // Return the name as-is if not found
  }

  // ==================== Macro Support ====================

  /// Process variable macros in a string
  /// Supports: {{getvar::name}}, {{setvar::name::value}}, {{addvar::name::value}},
  /// {{incvar::name}}, {{decvar::name}}, {{getglobalvar::name}}, {{setglobalvar::name::value}},
  /// {{addglobalvar::name::value}}, {{incglobalvar::name}}, {{decglobalvar::name}}
  Future<String> processVariableMacros(String input, {String? chatId}) async {
    String result = input;

    // {{setvar::name::value}} - Set local variable
    result = result.replaceAllMapped(
      RegExp(r'\{\{setvar::([^:]+)::([^}]*)\}\}', caseSensitive: false),
      (match) {
        final name = match.group(1)!.trim();
        final value = match.group(2)!;
        if (chatId != null) {
          setLocalVariable(chatId, name, value);
        }
        return '';
      },
    );

    // {{addvar::name::value}} - Add to local variable
    result = result.replaceAllMapped(
      RegExp(r'\{\{addvar::([^:]+)::([^}]+)\}\}', caseSensitive: false),
      (match) {
        final name = match.group(1)!.trim();
        final value = match.group(2)!;
        if (chatId != null) {
          addLocalVariable(chatId, name, value);
        }
        return '';
      },
    );

    // {{incvar::name}} - Increment local variable
    result = result.replaceAllMapped(
      RegExp(r'\{\{incvar::([^}]+)\}\}', caseSensitive: false),
      (match) {
        final name = match.group(1)!.trim();
        if (chatId != null) {
          return incrementLocalVariable(chatId, name).toString();
        }
        return '';
      },
    );

    // {{decvar::name}} - Decrement local variable
    result = result.replaceAllMapped(
      RegExp(r'\{\{decvar::([^}]+)\}\}', caseSensitive: false),
      (match) {
        final name = match.group(1)!.trim();
        if (chatId != null) {
          return decrementLocalVariable(chatId, name).toString();
        }
        return '';
      },
    );

    // {{getvar::name}} - Get local variable
    result = result.replaceAllMapped(
      RegExp(r'\{\{getvar::([^}]+)\}\}', caseSensitive: false),
      (match) {
        final name = match.group(1)!.trim();
        if (chatId != null) {
          return getLocalVariable(chatId, name).toString();
        }
        return '';
      },
    );

    // {{setglobalvar::name::value}} - Set global variable
    result = await _replaceAllMappedAsync(
      result,
      RegExp(r'\{\{setglobalvar::([^:]+)::([^}]*)\}\}', caseSensitive: false),
      (match) async {
        final name = match.group(1)!.trim();
        final value = match.group(2)!;
        await setGlobalVariable(name, value);
        return '';
      },
    );

    // {{addglobalvar::name::value}} - Add to global variable
    result = await _replaceAllMappedAsync(
      result,
      RegExp(r'\{\{addglobalvar::([^:]+)::([^}]+)\}\}', caseSensitive: false),
      (match) async {
        final name = match.group(1)!.trim();
        final value = match.group(2)!;
        await addGlobalVariable(name, value);
        return '';
      },
    );

    // {{incglobalvar::name}} - Increment global variable
    result = await _replaceAllMappedAsync(
      result,
      RegExp(r'\{\{incglobalvar::([^}]+)\}\}', caseSensitive: false),
      (match) async {
        final name = match.group(1)!.trim();
        final value = await incrementGlobalVariable(name);
        return value.toString();
      },
    );

    // {{decglobalvar::name}} - Decrement global variable
    result = await _replaceAllMappedAsync(
      result,
      RegExp(r'\{\{decglobalvar::([^}]+)\}\}', caseSensitive: false),
      (match) async {
        final name = match.group(1)!.trim();
        final value = await decrementGlobalVariable(name);
        return value.toString();
      },
    );

    // {{getglobalvar::name}} - Get global variable
    result = result.replaceAllMapped(
      RegExp(r'\{\{getglobalvar::([^}]+)\}\}', caseSensitive: false),
      (match) {
        final name = match.group(1)!.trim();
        return getGlobalVariable(name).toString();
      },
    );

    return result;
  }

  /// Helper for async replaceAllMapped
  Future<String> _replaceAllMappedAsync(
    String input,
    RegExp regex,
    Future<String> Function(Match) replace,
  ) async {
    final matches = regex.allMatches(input).toList();
    if (matches.isEmpty) return input;

    final buffer = StringBuffer();
    int lastEnd = 0;

    for (final match in matches) {
      buffer.write(input.substring(lastEnd, match.start));
      buffer.write(await replace(match));
      lastEnd = match.end;
    }
    buffer.write(input.substring(lastEnd));

    return buffer.toString();
  }

  /// Convert value to specified type
  dynamic _convertValueType(dynamic value, String? asType) {
    if (asType == null) return value;

    switch (asType.toLowerCase()) {
      case 'number':
      case 'num':
        return double.tryParse(value.toString()) ?? 0;
      case 'int':
      case 'integer':
        return int.tryParse(value.toString()) ?? 0;
      case 'bool':
      case 'boolean':
        return value.toString().toLowerCase() == 'true' || value == 1;
      case 'string':
      case 'str':
        return value.toString();
      default:
        return value;
    }
  }
}

/// Variable info for display
class VariableInfo {
  final String name;
  final dynamic value;
  final bool isGlobal;
  final String? chatId;

  const VariableInfo({
    required this.name,
    required this.value,
    required this.isGlobal,
    this.chatId,
  });

  String get displayValue {
    if (value == null) return 'null';
    if (value is String && (value as String).isEmpty) return '(empty)';
    return value.toString();
  }

  String get valueType {
    if (value == null) return 'null';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is String) {
      try {
        final parsed = jsonDecode(value as String);
        if (parsed is List) return 'array';
        if (parsed is Map) return 'object';
      } catch (_) {}
      return 'string';
    }
    if (value is List) return 'array';
    if (value is Map) return 'object';
    return value.runtimeType.toString();
  }
}