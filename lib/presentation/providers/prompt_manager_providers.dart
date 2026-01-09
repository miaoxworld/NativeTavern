import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/prompt_manager.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _promptManagerKey = 'prompt_manager_config';
const _customPresetsKey = 'prompt_manager_custom_presets';
const _activePresetIdKey = 'prompt_manager_active_preset_id';

/// Prompt Manager configuration notifier
class PromptManagerNotifier extends StateNotifier<PromptManagerConfig> {
  final SharedPreferences _prefs;

  PromptManagerNotifier(this._prefs)
      : super(_loadConfig(_prefs));

  static PromptManagerConfig _loadConfig(SharedPreferences prefs) {
    final json = prefs.getString(_promptManagerKey);
    if (json == null) {
      return PromptManagerConfig.defaultConfig();
    }
    try {
      return PromptManagerConfig.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return PromptManagerConfig.defaultConfig();
    }
  }

  Future<void> _saveConfig() async {
    await _prefs.setString(_promptManagerKey, jsonEncode(state.toJson()));
  }

  /// Toggle a section's enabled state
  Future<void> toggleSection(PromptSectionType type) async {
    state = state.toggleSection(type);
    await _saveConfig();
  }

  /// Toggle a section's enabled state by index (for custom prompts)
  Future<void> toggleSectionByIndex(int index) async {
    state = state.toggleSectionByIndex(index);
    await _saveConfig();
  }

  /// Update a section
  Future<void> updateSection(PromptSection section) async {
    state = state.updateSection(section);
    await _saveConfig();
  }

  /// Update the content of an editable section
  Future<void> updateSectionContent(PromptSectionType type, String content) async {
    final section = state.getSection(type);
    if (section != null && section.isEditable) {
      state = state.updateSection(section.copyWith(content: content));
      await _saveConfig();
    }
  }

  /// Update a section by index (for custom prompts)
  Future<void> updateSectionByIndex(int index, PromptSection section) async {
    state = state.updateSectionByIndex(index, section);
    await _saveConfig();
  }

  /// Update the content of a section by index
  Future<void> updateSectionContentByIndex(int index, String content) async {
    final sorted = state.sortedSections;
    if (index >= 0 && index < sorted.length) {
      final section = sorted[index];
      state = state.updateSectionByIndex(index, section.copyWith(content: content));
      await _saveConfig();
    }
  }

  /// Reorder sections
  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    state = state.reorder(oldIndex, newIndex);
    await _saveConfig();
  }

  /// Reset to default configuration
  Future<void> resetToDefault() async {
    state = PromptManagerConfig.defaultConfig();
    await _saveConfig();
  }

  /// Apply a preset configuration
  Future<void> applyPreset(PromptManagerPreset preset) async {
    state = preset.config;
    await _saveConfig();
  }

  /// Load configuration from JSON (for import)
  Future<void> loadFromJson(Map<String, dynamic> json) async {
    try {
      // Try to parse as export format first
      if (json['format'] == 'native_tavern_prompt_preset' && json['sections'] != null) {
        final sectionsJson = json['sections'] as List<dynamic>;
        state = PromptManagerConfig(
          sections: sectionsJson
              .map((s) => PromptSection.fromJson(s as Map<String, dynamic>))
              .toList(),
        );
      } else {
        // Try standard format
        state = PromptManagerConfig.fromJson(json);
      }
      await _saveConfig();
    } catch (e) {
      // If parsing fails, keep current state
      rethrow;
    }
  }

  /// Export current configuration as JSON
  Map<String, dynamic> exportToJson(String name) {
    return {
      'name': name,
      'description': 'Exported from NativeTavern',
      'version': 1,
      'format': 'native_tavern_prompt_preset',
      'sections': state.sections.map((s) => s.toJson()).toList(),
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}

/// Provider for Prompt Manager configuration
final promptManagerProvider =
    StateNotifierProvider<PromptManagerNotifier, PromptManagerConfig>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PromptManagerNotifier(prefs);
});

/// Provider for sorted enabled sections
final enabledPromptSectionsProvider = Provider<List<PromptSection>>((ref) {
  final config = ref.watch(promptManagerProvider);
  return config.enabledSections;
});

/// Provider to check if a specific section is enabled
final isSectionEnabledProvider =
    Provider.family<bool, PromptSectionType>((ref, type) {
  final config = ref.watch(promptManagerProvider);
  return config.isSectionEnabled(type);
});

/// Custom presets notifier
class CustomPresetsNotifier extends StateNotifier<List<PromptManagerPreset>> {
  final SharedPreferences _prefs;

  CustomPresetsNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final json = _prefs.getString(_customPresetsKey);
    if (json != null) {
      try {
        final list = jsonDecode(json) as List<dynamic>;
        state = list
            .map((e) => PromptManagerPreset.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        state = [];
      }
    }
  }

  Future<void> _save() async {
    await _prefs.setString(
      _customPresetsKey,
      jsonEncode(state.map((p) => p.toJson()).toList()),
    );
  }

  /// Add a new custom preset
  Future<void> addPreset(PromptManagerPreset preset) async {
    state = [...state, preset];
    await _save();
  }

  /// Update an existing preset
  Future<void> updatePreset(PromptManagerPreset preset) async {
    state = state.map((p) => p.id == preset.id ? preset : p).toList();
    await _save();
  }

  /// Delete a preset
  Future<void> deletePreset(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _save();
  }

  /// Import a preset from JSON
  Future<PromptManagerPreset> importPreset(Map<String, dynamic> json) async {
    final id = const Uuid().v4();
    final preset = PromptManagerPreset.fromExportJson(json, id);
    await addPreset(preset);
    return preset;
  }

  /// Save current config as a new preset
  Future<PromptManagerPreset> saveCurrentAsPreset(
    PromptManagerConfig config,
    String name,
    String? description,
  ) async {
    final preset = PromptManagerPreset(
      id: const Uuid().v4(),
      name: name,
      description: description,
      config: config,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isBuiltIn: false,
    );
    await addPreset(preset);
    return preset;
  }
}

/// Provider for custom presets
final customPresetsProvider =
    StateNotifierProvider<CustomPresetsNotifier, List<PromptManagerPreset>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CustomPresetsNotifier(prefs);
});

/// Provider for all presets (built-in + custom)
final allPresetsProvider = Provider<List<PromptManagerPreset>>((ref) {
  final customPresets = ref.watch(customPresetsProvider);
  return [...BuiltInPromptPresets.all, ...customPresets];
});

/// Active preset ID provider
final activePresetIdProvider = StateNotifierProvider<ActivePresetIdNotifier, String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ActivePresetIdNotifier(prefs);
});

class ActivePresetIdNotifier extends StateNotifier<String?> {
  final SharedPreferences _prefs;

  ActivePresetIdNotifier(this._prefs) : super(null) {
    state = _prefs.getString(_activePresetIdKey);
  }

  Future<void> setActivePreset(String? id) async {
    state = id;
    if (id != null) {
      await _prefs.setString(_activePresetIdKey, id);
    } else {
      await _prefs.remove(_activePresetIdKey);
    }
  }
}

/// Provider for the currently active preset
final activePresetProvider = Provider<PromptManagerPreset?>((ref) {
  final activeId = ref.watch(activePresetIdProvider);
  if (activeId == null) return null;
  
  final allPresets = ref.watch(allPresetsProvider);
  try {
    return allPresets.firstWhere((p) => p.id == activeId);
  } catch (_) {
    return null;
  }
});