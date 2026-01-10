import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:native_tavern/data/models/regex_script.dart';
import 'package:native_tavern/domain/services/regex_service.dart';

const _uuid = Uuid();

/// Provider for the regex service singleton
final regexServiceProvider = Provider<RegexService>((ref) {
  return RegexService.instance;
});

/// Provider for global regex scripts
final globalRegexScriptsProvider = StateNotifierProvider<GlobalRegexScriptsNotifier, List<RegexScript>>((ref) {
  return GlobalRegexScriptsNotifier();
});

/// Notifier for managing global regex scripts
class GlobalRegexScriptsNotifier extends StateNotifier<List<RegexScript>> {
  static const _storageKey = 'global_regex_scripts';
  
  GlobalRegexScriptsNotifier() : super([]) {
    _loadScripts();
  }

  Future<void> _loadScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is List) {
          state = decoded.map((e) => RegexScript.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (e) {
      print('Error loading regex scripts: $e');
    }
  }

  Future<void> _saveScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(state.map((s) => s.toJson()).toList());
      await prefs.setString(_storageKey, json);
    } catch (e) {
      print('Error saving regex scripts: $e');
    }
  }

  /// Add a new script
  Future<void> addScript(RegexScript script) async {
    state = [...state, script];
    await _saveScripts();
  }

  /// Update an existing script
  Future<void> updateScript(RegexScript script) async {
    state = state.map((s) => s.id == script.id ? script : s).toList();
    await _saveScripts();
  }

  /// Remove a script
  Future<void> removeScript(String id) async {
    state = state.where((s) => s.id != id).toList();
    await _saveScripts();
  }

  /// Toggle script enabled/disabled
  Future<void> toggleScript(String id) async {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(
          disabled: !s.disabled,
          updatedAt: DateTime.now(),
        );
      }
      return s;
    }).toList();
    await _saveScripts();
  }

  /// Reorder scripts
  Future<void> reorderScripts(int oldIndex, int newIndex) async {
    final scripts = List<RegexScript>.from(state);
    final script = scripts.removeAt(oldIndex);
    scripts.insert(newIndex, script);
    
    // Update order values
    state = scripts.asMap().entries.map((entry) {
      return entry.value.copyWith(order: entry.key);
    }).toList();
    
    await _saveScripts();
  }

  /// Import scripts from JSON
  Future<int> importScripts(String json) async {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) {
        throw Exception('Invalid JSON format');
      }
      final scripts = decoded.map((e) {
        final script = RegexScript.fromJson(e as Map<String, dynamic>);
        // Generate new ID to avoid conflicts
        return script.copyWith(
          id: _uuid.v4(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();
      
      state = [...state, ...scripts];
      await _saveScripts();
      return scripts.length;
    } catch (e) {
      print('Error importing regex scripts: $e');
      return 0;
    }
  }

  /// Export scripts to JSON
  String exportScripts() {
    return jsonEncode(state.map((s) => s.toJson()).toList());
  }

  /// Add preset scripts
  Future<void> addPresets() async {
    final presets = RegexPresets.all();
    final existingIds = state.map((s) => s.id).toSet();
    
    final newPresets = presets.where((p) => !existingIds.contains(p.id)).toList();
    if (newPresets.isNotEmpty) {
      state = [...state, ...newPresets];
      await _saveScripts();
    }
  }

  /// Clear all scripts
  Future<void> clearAll() async {
    state = [];
    await _saveScripts();
  }
}

/// Provider for character-specific regex scripts
final characterRegexScriptsProvider = StateNotifierProvider.family<CharacterRegexScriptsNotifier, List<RegexScript>, String>((ref, characterId) {
  return CharacterRegexScriptsNotifier(characterId);
});

/// Notifier for managing character-specific regex scripts
class CharacterRegexScriptsNotifier extends StateNotifier<List<RegexScript>> {
  final String characterId;
  
  CharacterRegexScriptsNotifier(this.characterId) : super([]) {
    _loadScripts();
  }

  String get _storageKey => 'character_regex_scripts_$characterId';

  Future<void> _loadScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is List) {
          state = decoded.map((e) => RegexScript.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (e) {
      print('Error loading character regex scripts: $e');
    }
  }

  Future<void> _saveScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(state.map((s) => s.toJson()).toList());
      await prefs.setString(_storageKey, json);
    } catch (e) {
      print('Error saving character regex scripts: $e');
    }
  }

  Future<void> addScript(RegexScript script) async {
    final newScript = script.copyWith(
      characterId: characterId,
      scriptType: RegexScriptType.character,
    );
    state = [...state, newScript];
    await _saveScripts();
  }

  Future<void> updateScript(RegexScript script) async {
    state = state.map((s) => s.id == script.id ? script : s).toList();
    await _saveScripts();
  }

  Future<void> removeScript(String id) async {
    state = state.where((s) => s.id != id).toList();
    await _saveScripts();
  }

  Future<void> toggleScript(String id) async {
    state = state.map((s) {
      if (s.id == id) {
        return s.copyWith(
          disabled: !s.disabled,
          updatedAt: DateTime.now(),
        );
      }
      return s;
    }).toList();
    await _saveScripts();
  }
}

/// Provider for combined regex scripts (global + character)
final combinedRegexScriptsProvider = Provider.family<List<RegexScript>, String?>((ref, characterId) {
  final globalScripts = ref.watch(globalRegexScriptsProvider);
  
  if (characterId == null) {
    return globalScripts.where((s) => !s.disabled).toList();
  }
  
  final characterScripts = ref.watch(characterRegexScriptsProvider(characterId));
  
  // Combine and sort by order
  final combined = [...globalScripts, ...characterScripts]
    .where((s) => !s.disabled)
    .toList()
    ..sort((a, b) => a.order.compareTo(b.order));
  
  return combined;
});

/// Provider for regex settings
final regexSettingsProvider = StateNotifierProvider<RegexSettingsNotifier, RegexSettings>((ref) {
  return RegexSettingsNotifier();
});

/// Regex feature settings
class RegexSettings {
  final bool enabled;
  final bool applyToUserInput;
  final bool applyToAiOutput;
  final bool applyToSlashCommands;
  final bool applyToWorldInfo;
  final bool applyToReasoning;

  const RegexSettings({
    this.enabled = true,
    this.applyToUserInput = true,
    this.applyToAiOutput = true,
    this.applyToSlashCommands = false,
    this.applyToWorldInfo = false,
    this.applyToReasoning = false,
  });

  RegexSettings copyWith({
    bool? enabled,
    bool? applyToUserInput,
    bool? applyToAiOutput,
    bool? applyToSlashCommands,
    bool? applyToWorldInfo,
    bool? applyToReasoning,
  }) {
    return RegexSettings(
      enabled: enabled ?? this.enabled,
      applyToUserInput: applyToUserInput ?? this.applyToUserInput,
      applyToAiOutput: applyToAiOutput ?? this.applyToAiOutput,
      applyToSlashCommands: applyToSlashCommands ?? this.applyToSlashCommands,
      applyToWorldInfo: applyToWorldInfo ?? this.applyToWorldInfo,
      applyToReasoning: applyToReasoning ?? this.applyToReasoning,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'applyToUserInput': applyToUserInput,
    'applyToAiOutput': applyToAiOutput,
    'applyToSlashCommands': applyToSlashCommands,
    'applyToWorldInfo': applyToWorldInfo,
    'applyToReasoning': applyToReasoning,
  };

  factory RegexSettings.fromJson(Map<String, dynamic> json) {
    return RegexSettings(
      enabled: json['enabled'] as bool? ?? true,
      applyToUserInput: json['applyToUserInput'] as bool? ?? true,
      applyToAiOutput: json['applyToAiOutput'] as bool? ?? true,
      applyToSlashCommands: json['applyToSlashCommands'] as bool? ?? false,
      applyToWorldInfo: json['applyToWorldInfo'] as bool? ?? false,
      applyToReasoning: json['applyToReasoning'] as bool? ?? false,
    );
  }
}

/// Notifier for regex settings
class RegexSettingsNotifier extends StateNotifier<RegexSettings> {
  static const _storageKey = 'regex_settings';
  
  RegexSettingsNotifier() : super(const RegexSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) {
          state = RegexSettings.fromJson(decoded);
        }
      }
    } catch (e) {
      print('Error loading regex settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(state.toJson()));
    } catch (e) {
      print('Error saving regex settings: $e');
    }
  }

  void setEnabled(bool value) {
    state = state.copyWith(enabled: value);
    _saveSettings();
  }

  void setApplyToUserInput(bool value) {
    state = state.copyWith(applyToUserInput: value);
    _saveSettings();
  }

  void setApplyToAiOutput(bool value) {
    state = state.copyWith(applyToAiOutput: value);
    _saveSettings();
  }

  void setApplyToSlashCommands(bool value) {
    state = state.copyWith(applyToSlashCommands: value);
    _saveSettings();
  }

  void setApplyToWorldInfo(bool value) {
    state = state.copyWith(applyToWorldInfo: value);
    _saveSettings();
  }

  void setApplyToReasoning(bool value) {
    state = state.copyWith(applyToReasoning: value);
    _saveSettings();
  }

  void reset() {
    state = const RegexSettings();
    _saveSettings();
  }
}

/// Helper function to create a new regex script
RegexScript createRegexScript({
  required String scriptName,
  String? description,
  required String findRegex,
  required String replaceString,
  List<RegexPlacement> placement = const [RegexPlacement.aiOutput],
  RegexScriptType scriptType = RegexScriptType.global,
  bool markdownOnly = false,
  bool promptOnly = false,
  bool runOnEdit = false,
  SubstituteRegex substituteRegex = SubstituteRegex.none,
  int? minDepth,
  int? maxDepth,
  String? characterId,
  String? chatId,
}) {
  return RegexScript(
    id: _uuid.v4(),
    scriptName: scriptName,
    description: description,
    findRegex: findRegex,
    replaceString: replaceString,
    placement: placement,
    scriptType: scriptType,
    markdownOnly: markdownOnly,
    promptOnly: promptOnly,
    runOnEdit: runOnEdit,
    substituteRegex: substituteRegex,
    minDepth: minDepth,
    maxDepth: maxDepth,
    characterId: characterId,
    chatId: chatId,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}