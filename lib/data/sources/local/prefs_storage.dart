import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin typed wrapper over SharedPreferences for user settings (docs §3.4):
/// default currencies, theme, and recent currency codes.
class PrefsStorage {
  const PrefsStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _kFrom = 'default_from';
  static const _kTo = 'default_to';
  static const _kThemeMode = 'theme_mode';
  static const _kRecent = 'recent_currencies';
  static const _kLanguage = 'language_code';

  String get defaultFrom => _prefs.getString(_kFrom) ?? 'USD';
  Future<void> setDefaultFrom(String code) => _prefs.setString(_kFrom, code);

  String get defaultTo => _prefs.getString(_kTo) ?? 'EUR';
  Future<void> setDefaultTo(String code) => _prefs.setString(_kTo, code);

  // Default is light (docs agreed deviation: light by default, not system).
  ThemeMode get themeMode =>
      ThemeMode.values[_prefs.getInt(_kThemeMode) ?? ThemeMode.light.index];
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setInt(_kThemeMode, mode.index);

  List<String> get recentCurrencies => _prefs.getStringList(_kRecent) ?? const [];
  Future<void> setRecentCurrencies(List<String> codes) =>
      _prefs.setStringList(_kRecent, codes);

  /// UI language code ('en' / 'ru'). Defaults to Russian.
  String get languageCode => _prefs.getString(_kLanguage) ?? 'ru';
  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_kLanguage, code);
}
