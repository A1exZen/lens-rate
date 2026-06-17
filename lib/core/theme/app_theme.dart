import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Builds the light and dark [ThemeData] from the design tokens (docs §11–§12).
///
/// Platform fonts are intentionally left to the system default: SF Pro on iOS,
/// Roboto on Android (docs §12) — Flutter picks the right one per platform.
abstract final class AppTheme {
  static ThemeData get light => _base(AppColorSchemes.light);
  static ThemeData get dark => _base(AppColorSchemes.dark);

  static ThemeData _base(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: false,
        backgroundColor: null,
      ),
      dividerColor: scheme.outline,
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          // Selected segment: solid primary fill with white label/icon.
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return scheme.primary;
            return scheme.surfaceContainerHighest;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return scheme.onPrimary;
            return scheme.onSurface;
          }),
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return scheme.onPrimary;
            return scheme.onSurface;
          }),
          // Less rounded than the default stadium-shape.
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: scheme.outline),
            ),
          ),
        ),
      ),
    );
  }
}
