import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the current locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// Notifier for managing the app locale
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  static const String _localeKey = 'app_locale';

  /// Load the saved locale from preferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      final parts = localeCode.split('_');
      if (parts.length == 2) {
        state = Locale(parts[0], parts[1]);
      } else {
        state = Locale(parts[0]);
      }
    }
  }

  /// Set the app locale
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    final localeCode = locale.countryCode != null 
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await prefs.setString(_localeKey, localeCode);
  }

  /// Reset to system locale
  Future<void> resetToSystem() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
}

/// List of supported locales with their display names
class SupportedLocale {
  final Locale locale;
  final String displayName;
  final String nativeName;

  const SupportedLocale({
    required this.locale,
    required this.displayName,
    required this.nativeName,
  });
}

/// All supported locales
const List<SupportedLocale> supportedLocales = [
  SupportedLocale(
    locale: Locale('en'),
    displayName: 'English',
    nativeName: 'English',
  ),
  SupportedLocale(
    locale: Locale('zh'),
    displayName: 'Chinese (Simplified)',
    nativeName: '简体中文',
  ),
  SupportedLocale(
    locale: Locale('zh', 'TW'),
    displayName: 'Chinese (Traditional)',
    nativeName: '繁體中文',
  ),
  SupportedLocale(
    locale: Locale('ja'),
    displayName: 'Japanese',
    nativeName: '日本語',
  ),
  SupportedLocale(
    locale: Locale('ko'),
    displayName: 'Korean',
    nativeName: '한국어',
  ),
  SupportedLocale(
    locale: Locale('ar'),
    displayName: 'Arabic',
    nativeName: 'العربية',
  ),
  SupportedLocale(
    locale: Locale('es'),
    displayName: 'Spanish',
    nativeName: 'Español',
  ),
  SupportedLocale(
    locale: Locale('pt'),
    displayName: 'Portuguese',
    nativeName: 'Português',
  ),
  SupportedLocale(
    locale: Locale('fr'),
    displayName: 'French',
    nativeName: 'Français',
  ),
  SupportedLocale(
    locale: Locale('de'),
    displayName: 'German',
    nativeName: 'Deutsch',
  ),
  SupportedLocale(
    locale: Locale('ru'),
    displayName: 'Russian',
    nativeName: 'Русский',
  ),
  SupportedLocale(
    locale: Locale('hi'),
    displayName: 'Hindi',
    nativeName: 'हिन्दी',
  ),
  SupportedLocale(
    locale: Locale('vi'),
    displayName: 'Vietnamese',
    nativeName: 'Tiếng Việt',
  ),
  SupportedLocale(
    locale: Locale('th'),
    displayName: 'Thai',
    nativeName: 'ไทย',
  ),
  SupportedLocale(
    locale: Locale('id'),
    displayName: 'Indonesian',
    nativeName: 'Bahasa Indonesia',
  ),
  SupportedLocale(
    locale: Locale('ms'),
    displayName: 'Malay',
    nativeName: 'Bahasa Melayu',
  ),
  SupportedLocale(
    locale: Locale('tr'),
    displayName: 'Turkish',
    nativeName: 'Türkçe',
  ),
  SupportedLocale(
    locale: Locale('it'),
    displayName: 'Italian',
    nativeName: 'Italiano',
  ),
  SupportedLocale(
    locale: Locale('pl'),
    displayName: 'Polish',
    nativeName: 'Polski',
  ),
  SupportedLocale(
    locale: Locale('nl'),
    displayName: 'Dutch',
    nativeName: 'Nederlands',
  ),
];