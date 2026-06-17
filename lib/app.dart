import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/settings/locale_provider.dart';
import 'presentation/settings/theme_mode_provider.dart';

/// Root widget: wires the router, themes, and the user's theme & language.
class LensRateApp extends ConsumerWidget {
  const LensRateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);

    // Drive locale-aware number formatting (docs §12.2): RU → "1 234,56",
    // EN → "1,234.56". CurrencyFormatter's NumberFormat reads this default.
    Intl.defaultLocale = locale.languageCode;

    return MaterialApp.router(
      title: 'LensRate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: AppL10n.localizationsDelegates,
      routerConfig: AppRouter.router,
    );
  }
}
