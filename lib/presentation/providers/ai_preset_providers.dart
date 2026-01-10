import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/ai_preset.dart';
import '../../data/models/prompt_manager.dart';
import 'settings_providers.dart';
import 'prompt_manager_providers.dart';
import 'instruct_providers.dart';

const _customPresetsKey = 'ai_custom_presets';
const _activePresetIdKey = 'ai_active_preset_id';

/// Provider for custom AI presets
final aiCustomPresetsProvider =
    StateNotifierProvider<AICustomPresetsNotifier, List<AIPreset>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AICustomPresetsNotifier(prefs);
});

class AICustomPresetsNotifier extends StateNotifier<List<AIPreset>> {
  final SharedPreferences _prefs;

  AICustomPresetsNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final json = _prefs.getString(_customPresetsKey);
    if (json != null) {
      try {
        final list = jsonDecode(json) as List<dynamic>;
        state = list
            .map((e) => AIPreset.fromJson(e as Map<String, dynamic>))
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
  Future<void> addPreset(AIPreset preset) async {
    state = [...state, preset];
    await _save();
  }

  /// Update an existing preset
  Future<void> updatePreset(AIPreset preset) async {
    state = state.map((p) => p.id == preset.id ? preset : p).toList();
    await _save();
  }

  /// Delete a preset
  Future<void> deletePreset(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _save();
  }

  /// Import a preset from JSON (supports both SillyTavern and NativeTavern formats)
  Future<AIPreset> importPreset(Map<String, dynamic> json) async {
    final id = const Uuid().v4();
    final preset = AIPreset.fromExportJson(json, id);
    await addPreset(preset);
    return preset;
  }
}

/// Provider for all AI presets (built-in + custom)
final allAIPresetsProvider = Provider<List<AIPreset>>((ref) {
  final customPresets = ref.watch(aiCustomPresetsProvider);
  return [...BuiltInAIPresets.all, ...customPresets];
});

/// Active AI preset ID provider
final activeAIPresetIdProvider =
    StateNotifierProvider<ActiveAIPresetIdNotifier, String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ActiveAIPresetIdNotifier(prefs);
});

class ActiveAIPresetIdNotifier extends StateNotifier<String?> {
  final SharedPreferences _prefs;

  ActiveAIPresetIdNotifier(this._prefs) : super(null) {
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

/// Provider for the currently active AI preset
final activeAIPresetProvider = Provider<AIPreset?>((ref) {
  final activeId = ref.watch(activeAIPresetIdProvider);
  if (activeId == null) return null;

  final allPresets = ref.watch(allAIPresetsProvider);
  try {
    return allPresets.firstWhere((p) => p.id == activeId);
  } catch (_) {
    return null;
  }
});

/// AI Preset Manager - handles applying presets and creating from current settings
class AIPresetManager {
  final Ref _ref;

  AIPresetManager(this._ref);

  /// Apply an AI preset to current settings
  Future<void> applyPreset(AIPreset preset) async {
    // Apply generation settings to LLM config
    final llmNotifier = _ref.read(llmConfigProvider.notifier);
    final gen = preset.generationSettings;

    llmNotifier.updateTemperature(gen.temperature);
    llmNotifier.updateTopP(gen.topP);
    llmNotifier.updateTopK(gen.topK);
    llmNotifier.updateMinP(gen.minP);
    llmNotifier.updateTypicalP(gen.typicalP);
    llmNotifier.updateRepetitionPenalty(gen.repetitionPenalty);
    llmNotifier.updateRepetitionPenaltyRange(gen.repetitionPenaltyRange);
    llmNotifier.updateFrequencyPenalty(gen.frequencyPenalty);
    llmNotifier.updatePresencePenalty(gen.presencePenalty);
    llmNotifier.updateTailFreeSampling(gen.tailFreeSampling);
    llmNotifier.updateTopA(gen.topA);
    llmNotifier.updateMirostatMode(gen.mirostatMode);
    llmNotifier.updateMirostatTau(gen.mirostatTau);
    llmNotifier.updateMirostatEta(gen.mirostatEta);
    llmNotifier.updateMaxTokens(gen.maxTokens);
    llmNotifier.updateStopSequences(gen.stopSequences);
    llmNotifier.updateSeed(gen.seed);
    llmNotifier.updateStreamEnabled(gen.streamEnabled);

    // Apply prompt manager config (reset to default if not present)
    final promptNotifier = _ref.read(promptManagerProvider.notifier);
    if (preset.promptManagerConfig != null) {
      await promptNotifier.applyPreset(PromptManagerPreset(
        id: preset.id,
        name: preset.name,
        config: preset.promptManagerConfig!,
        createdAt: preset.createdAt,
        updatedAt: preset.updatedAt,
      ));
    } else {
      // Reset to default prompt manager config when preset doesn't have one
      await promptNotifier.resetToDefault();
    }

    // Apply instruct template if present
    if (preset.instructTemplateId != null) {
      _ref.read(activeInstructTemplateIdProvider.notifier).state =
          preset.instructTemplateId!;
    }

    // Set as active preset
    await _ref.read(activeAIPresetIdProvider.notifier).setActivePreset(preset.id);
  }

  /// Create a preset from current settings
  AIPreset createFromCurrentSettings({
    required String name,
    String? description,
  }) {
    final llmConfig = _ref.read(llmConfigProvider);
    final promptConfig = _ref.read(promptManagerProvider);
    final instructTemplateId = _ref.read(activeInstructTemplateIdProvider);

    return AIPreset(
      id: const Uuid().v4(),
      name: name,
      description: description,
      isBuiltIn: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      generationSettings: GenerationPreset(
        temperature: llmConfig.temperature,
        topP: llmConfig.topP,
        topK: llmConfig.topK,
        minP: llmConfig.minP,
        typicalP: llmConfig.typicalP,
        repetitionPenalty: llmConfig.repetitionPenalty,
        repetitionPenaltyRange: llmConfig.repetitionPenaltyRange,
        frequencyPenalty: llmConfig.frequencyPenalty,
        presencePenalty: llmConfig.presencePenalty,
        tailFreeSampling: llmConfig.tailFreeSampling,
        topA: llmConfig.topA,
        mirostatMode: llmConfig.mirostatMode,
        mirostatTau: llmConfig.mirostatTau,
        mirostatEta: llmConfig.mirostatEta,
        maxTokens: llmConfig.maxTokens,
        stopSequences: llmConfig.stopSequences,
        seed: llmConfig.seed,
        streamEnabled: llmConfig.streamEnabled,
      ),
      promptManagerConfig: promptConfig,
      instructTemplateId: instructTemplateId,
    );
  }

  /// Export current settings as JSON
  Map<String, dynamic> exportCurrentSettings(String name) {
    final preset = createFromCurrentSettings(name: name);
    return preset.toExportJson();
  }
}

/// Provider for AI Preset Manager
final aiPresetManagerProvider = Provider<AIPresetManager>((ref) {
  return AIPresetManager(ref);
});