import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/app_theme_config.dart';
import 'settings_providers.dart';

const String _activeThemeIdKey = 'active_theme_id';
const String _customThemesKey = 'custom_themes';

/// Provider for the active theme ID
final activeThemeIdProvider = StateNotifierProvider<ActiveThemeIdNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ActiveThemeIdNotifier(prefs);
});

/// Notifier for active theme ID
class ActiveThemeIdNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;

  ActiveThemeIdNotifier(this._prefs) : super(BuiltInThemes.defaultDark.id) {
    _loadActiveThemeId();
  }

  void _loadActiveThemeId() {
    final id = _prefs.getString(_activeThemeIdKey);
    if (id != null) {
      state = id;
    }
  }

  Future<void> setActiveTheme(String themeId) async {
    state = themeId;
    await _prefs.setString(_activeThemeIdKey, themeId);
  }
}

/// Provider for custom themes
final customThemesProvider = StateNotifierProvider<CustomThemesNotifier, List<AppThemeConfig>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CustomThemesNotifier(prefs);
});

/// Notifier for custom themes
class CustomThemesNotifier extends StateNotifier<List<AppThemeConfig>> {
  final SharedPreferences _prefs;

  CustomThemesNotifier(this._prefs) : super([]) {
    _loadCustomThemes();
  }

  void _loadCustomThemes() {
    final jsonString = _prefs.getString(_customThemesKey);
    if (jsonString != null) {
      try {
        final list = jsonDecode(jsonString) as List<dynamic>;
        state = list
            .map((e) => AppThemeConfig.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        state = [];
      }
    }
  }

  Future<void> _saveCustomThemes() async {
    final jsonString = jsonEncode(state.map((t) => t.toJson()).toList());
    await _prefs.setString(_customThemesKey, jsonString);
  }

  Future<void> addTheme(AppThemeConfig theme) async {
    state = [...state, theme];
    await _saveCustomThemes();
  }

  Future<void> updateTheme(AppThemeConfig theme) async {
    state = state.map((t) => t.id == theme.id ? theme : t).toList();
    await _saveCustomThemes();
  }

  Future<void> deleteTheme(String themeId) async {
    state = state.where((t) => t.id != themeId).toList();
    await _saveCustomThemes();
  }
}

/// Provider for all available themes (built-in + custom)
final allThemesProvider = Provider<List<AppThemeConfig>>((ref) {
  final customThemes = ref.watch(customThemesProvider);
  return [...BuiltInThemes.all, ...customThemes];
});

/// Provider for the active theme config
final activeThemeConfigProvider = Provider<AppThemeConfig>((ref) {
  final activeId = ref.watch(activeThemeIdProvider);
  final allThemes = ref.watch(allThemesProvider);
  
  return allThemes.firstWhere(
    (t) => t.id == activeId,
    orElse: () => BuiltInThemes.defaultDark,
  );
});

/// Provider for the active ThemeData
final activeThemeDataProvider = Provider<ThemeData>((ref) {
  final config = ref.watch(activeThemeConfigProvider);
  return config.toThemeData();
});

/// Provider for whether dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  final config = ref.watch(activeThemeConfigProvider);
  return config.isDark;
});