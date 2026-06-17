import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/rates_providers.dart';

part 'theme_mode_provider.g.dart';

/// Holds the app's [ThemeMode] (Light / Dark), persisted via SharedPreferences.
/// Defaults to light (docs §3.4 — agreed default).
@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() => ref.watch(prefsStorageProvider).themeMode;

  Future<void> set(ThemeMode mode) async {
    await ref.read(prefsStorageProvider).setThemeMode(mode);
    state = mode;
  }
}
