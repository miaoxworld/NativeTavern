import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/stt_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for STT service
final sttServiceProvider = Provider<STTService>((ref) {
  final service = STTService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for STT settings
final sttSettingsProvider = StateNotifierProvider<STTSettingsNotifier, STTSettings>((ref) {
  return STTSettingsNotifier(ref.watch(sttServiceProvider));
});

/// Notifier for STT settings
class STTSettingsNotifier extends StateNotifier<STTSettings> {
  static const _prefsKey = 'stt_settings';
  final STTService _service;

  STTSettingsNotifier(this._service) : super(const STTSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKey);
      if (jsonStr != null) {
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        state = STTSettings.fromJson(json);
        _service.updateSettings(state);
      }
    } catch (e) {
      // Use default settings on error
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(state.toJson());
      await prefs.setString(_prefsKey, jsonStr);
      _service.updateSettings(state);
    } catch (e) {
      // Ignore save errors
    }
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    _saveSettings();
  }

  void setProvider(STTProvider provider) {
    state = state.copyWith(provider: provider);
    _saveSettings();
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
    _saveSettings();
  }

  void setContinuousListening(bool continuous) {
    state = state.copyWith(continuousListening: continuous);
    _saveSettings();
  }

  void setAutoSend(bool autoSend) {
    state = state.copyWith(autoSend: autoSend);
    _saveSettings();
  }

  void setShowPartialResults(bool show) {
    state = state.copyWith(showPartialResults: show);
    _saveSettings();
  }

  void setApiKey(String? apiKey) {
    state = state.copyWith(apiKey: apiKey);
    _saveSettings();
  }

  void setApiEndpoint(String? endpoint) {
    state = state.copyWith(apiEndpoint: endpoint);
    _saveSettings();
  }

  void reset() {
    state = const STTSettings();
    _saveSettings();
  }
}

/// Provider for STT listening state
final sttListeningProvider = StateProvider<bool>((ref) => false);

/// Provider for current STT result (partial or final)
final sttResultProvider = StateProvider<STTResult?>((ref) => null);

/// Provider for STT availability
final sttAvailableProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(sttServiceProvider);
  return service.isAvailable();
});

/// STT action provider for starting listening
final sttStartListeningProvider = Provider<Future<void> Function()>((ref) {
  final service = ref.watch(sttServiceProvider);
  final settings = ref.watch(sttSettingsProvider);
  
  return () async {
    if (!settings.enabled) return;
    
    await service.initialize();
    
    service.onListeningStarted = () {
      ref.read(sttListeningProvider.notifier).state = true;
    };
    service.onListeningStopped = () {
      ref.read(sttListeningProvider.notifier).state = false;
    };
    service.onResult = (result) {
      ref.read(sttResultProvider.notifier).state = result;
    };
    service.onError = (error) {
      ref.read(sttListeningProvider.notifier).state = false;
    };
    
    await service.startListening();
  };
});

/// STT action provider for stopping listening
final sttStopListeningProvider = Provider<Future<void> Function()>((ref) {
  final service = ref.watch(sttServiceProvider);
  
  return () async {
    await service.stopListening();
    ref.read(sttListeningProvider.notifier).state = false;
  };
});

/// STT action provider for toggling listening
final sttToggleListeningProvider = Provider<Future<void> Function()>((ref) {
  final service = ref.watch(sttServiceProvider);
  final settings = ref.watch(sttSettingsProvider);
  
  return () async {
    if (!settings.enabled) return;
    
    await service.initialize();
    
    service.onListeningStarted = () {
      ref.read(sttListeningProvider.notifier).state = true;
    };
    service.onListeningStopped = () {
      ref.read(sttListeningProvider.notifier).state = false;
    };
    service.onResult = (result) {
      ref.read(sttResultProvider.notifier).state = result;
    };
    service.onError = (error) {
      ref.read(sttListeningProvider.notifier).state = false;
    };
    
    await service.toggleListening();
  };
});

/// STT action provider for cancelling listening
final sttCancelListeningProvider = Provider<Future<void> Function()>((ref) {
  final service = ref.watch(sttServiceProvider);
  
  return () async {
    await service.cancelListening();
    ref.read(sttListeningProvider.notifier).state = false;
    ref.read(sttResultProvider.notifier).state = null;
  };
});

/// Clear STT result
final sttClearResultProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(sttResultProvider.notifier).state = null;
  };
});