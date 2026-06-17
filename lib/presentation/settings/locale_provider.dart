import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/rates_providers.dart';

part 'locale_provider.g.dart';

/// The app's UI language, persisted via SharedPreferences (defaults to Russian).
@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale build() => Locale(ref.watch(prefsStorageProvider).languageCode);

  Future<void> set(String languageCode) async {
    await ref.read(prefsStorageProvider).setLanguageCode(languageCode);
    state = Locale(languageCode);
  }
}
