import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_tavern/data/models/logit_bias.dart';
import 'package:native_tavern/domain/services/logit_bias_service.dart';

/// Provider for LogitBiasService
final logitBiasServiceProvider = Provider<LogitBiasService>((ref) {
  return LogitBiasService();
});

/// Provider for logit bias settings
final logitBiasSettingsProvider =
    StateNotifierProvider<LogitBiasSettingsNotifier, LogitBiasSettings>((ref) {
  return LogitBiasSettingsNotifier();
});

/// Notifier for managing logit bias settings
class LogitBiasSettingsNotifier extends StateNotifier<LogitBiasSettings> {
  static const _storageKey = 'logit_bias_settings';

  LogitBiasSettingsNotifier() : super(const LogitBiasSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey);
      if (json != null) {
        state = LogitBiasSettings.deserialize(json);
      }
    } catch (e) {
      // Keep default settings on error
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, LogitBiasSettings.serialize(state));
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Toggle logit bias enabled state
  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _saveSettings();
  }

  /// Set the active preset
  void setActivePreset(String? presetId) {
    if (presetId == null) {
      state = state.copyWith(clearActivePreset: true);
    } else {
      state = state.copyWith(activePresetId: presetId);
    }
    _saveSettings();
  }

  /// Add a new preset
  void addPreset(LogitBiasPreset preset) {
    state = state.copyWith(
      presets: [...state.presets, preset],
    );
    _saveSettings();
  }

  /// Update an existing preset
  void updatePreset(LogitBiasPreset preset) {
    final index = state.presets.indexWhere((p) => p.id == preset.id);
    if (index >= 0) {
      final newPresets = List<LogitBiasPreset>.from(state.presets);
      newPresets[index] = preset;
      state = state.copyWith(presets: newPresets);
      _saveSettings();
    }
  }

  /// Delete a preset
  void deletePreset(String presetId) {
    final newPresets = state.presets.where((p) => p.id != presetId).toList();
    final newActiveId = state.activePresetId == presetId ? null : state.activePresetId;
    
    if (newActiveId == null) {
      state = state.copyWith(presets: newPresets, clearActivePreset: true);
    } else {
      state = state.copyWith(presets: newPresets, activePresetId: newActiveId);
    }
    _saveSettings();
  }

  /// Duplicate a preset
  void duplicatePreset(String presetId) {
    final preset = state.presets.firstWhere(
      (p) => p.id == presetId,
      orElse: () => throw Exception('Preset not found'),
    );
    
    final newPreset = LogitBiasPreset.create(
      name: '${preset.name} (Copy)',
      entries: preset.entries.map((e) => LogitBiasEntry.create(
        text: e.text,
        value: e.value,
      )).toList(),
    );
    
    addPreset(newPreset);
  }

  /// Add entry to active preset
  void addEntry(LogitBiasEntry entry) {
    final activePreset = state.activePreset;
    if (activePreset == null) return;

    final updatedPreset = activePreset.copyWith(
      entries: [...activePreset.entries, entry],
    );
    updatePreset(updatedPreset);
  }

  /// Update entry in active preset
  void updateEntry(LogitBiasEntry entry) {
    final activePreset = state.activePreset;
    if (activePreset == null) return;

    final index = activePreset.entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      final newEntries = List<LogitBiasEntry>.from(activePreset.entries);
      newEntries[index] = entry;
      final updatedPreset = activePreset.copyWith(entries: newEntries);
      updatePreset(updatedPreset);
    }
  }

  /// Delete entry from active preset
  void deleteEntry(String entryId) {
    final activePreset = state.activePreset;
    if (activePreset == null) return;

    final newEntries = activePreset.entries.where((e) => e.id != entryId).toList();
    final updatedPreset = activePreset.copyWith(entries: newEntries);
    updatePreset(updatedPreset);
  }

  /// Reorder entries in active preset
  void reorderEntries(int oldIndex, int newIndex) {
    final activePreset = state.activePreset;
    if (activePreset == null) return;

    final newEntries = List<LogitBiasEntry>.from(activePreset.entries);
    if (newIndex > oldIndex) newIndex--;
    final entry = newEntries.removeAt(oldIndex);
    newEntries.insert(newIndex, entry);
    
    final updatedPreset = activePreset.copyWith(entries: newEntries);
    updatePreset(updatedPreset);
  }

  /// Toggle entry enabled state
  void toggleEntry(String entryId) {
    final activePreset = state.activePreset;
    if (activePreset == null) return;

    final index = activePreset.entries.indexWhere((e) => e.id == entryId);
    if (index >= 0) {
      final entry = activePreset.entries[index];
      final newEntries = List<LogitBiasEntry>.from(activePreset.entries);
      newEntries[index] = entry.copyWith(enabled: !entry.enabled);
      final updatedPreset = activePreset.copyWith(entries: newEntries);
      updatePreset(updatedPreset);
    }
  }

  /// Import preset from JSON
  void importPreset(Map<String, dynamic> json) {
    try {
      final preset = LogitBiasPreset.fromJson(json);
      // Generate new ID to avoid conflicts
      final newPreset = LogitBiasPreset.create(
        name: preset.name,
        entries: preset.entries,
      );
      addPreset(newPreset);
    } catch (e) {
      throw Exception('Invalid preset format: $e');
    }
  }

  /// Export preset to JSON
  Map<String, dynamic> exportPreset(String presetId) {
    final preset = state.presets.firstWhere(
      (p) => p.id == presetId,
      orElse: () => throw Exception('Preset not found'),
    );
    return preset.toJson();
  }

  /// Create default preset if none exist
  void createDefaultPresetIfNeeded() {
    if (state.presets.isEmpty) {
      final defaultPreset = LogitBiasPreset.create(
        name: 'Default',
        entries: [],
      );
      state = state.copyWith(
        presets: [defaultPreset],
        activePresetId: defaultPreset.id,
      );
      _saveSettings();
    }
  }
}

/// Provider for active logit bias entries (convenience)
final activeLogitBiasEntriesProvider = Provider<List<LogitBiasEntry>>((ref) {
  final settings = ref.watch(logitBiasSettingsProvider);
  return settings.activeEntries;
});

/// Provider for checking if logit bias is active
final isLogitBiasActiveProvider = Provider<bool>((ref) {
  final settings = ref.watch(logitBiasSettingsProvider);
  return settings.enabled && settings.activePreset != null;
});

/// Provider for validating an entry
final logitBiasValidationProvider = Provider.family<LogitBiasValidationResult, LogitBiasEntry>((ref, entry) {
  final service = ref.watch(logitBiasServiceProvider);
  return service.validateEntry(entry);
});