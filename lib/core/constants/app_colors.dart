import 'package:flutter/material.dart';

/// Single source of truth for all colours (docs §11). Never hardcode a colour
/// elsewhere — reference these tokens so light/dark and brand stay consistent.
abstract final class AppColors {
  // ── Brand (docs §11.1) ──────────────────────────────────────────────
  static const primary = Color(0xFF16A34A);
  static const primaryDark = Color(0xFF15803D);
  static const primaryLight = Color(0xFFDCFCE7);
  static const primaryBg = Color(0xFFF0FDF4);

  /// Lighter primary for sufficient contrast on dark surfaces (docs §11.4).
  static const primaryOnDark = Color(0xFF22C55E);

  // ── Accent ──────────────────────────────────────────────────────────
  static const skyAccent = Color(0xFF0EA5E9);
  static const accentLight = Color(0xFFE0F2FE);

  // ── Neutrals (docs §11.2) ───────────────────────────────────────────
  static const slate900 = Color(0xFF0F172A);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const slate600 = Color(0xFF475569);
  static const slate400 = Color(0xFF94A3B8);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);
  static const white = Color(0xFFFFFFFF);

  // ── Semantic (docs §11.3) ───────────────────────────────────────────
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);

  // ── AR overlay backgrounds (docs §11.4 / §14.1) ─────────────────────
  static const overlayBgLight = Color(0xA6000000); // rgba(0,0,0,0.65)
  static const overlayBgDark = Color(0xB8000000); // rgba(0,0,0,0.72)
}

/// Maps the raw tokens above onto Material [ColorScheme]s (docs §11.4).
abstract final class AppColorSchemes {
  static const light = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.skyAccent,
    surface: AppColors.white,
    onSurface: AppColors.slate900,
    surfaceContainerHighest: AppColors.slate50,
    outline: AppColors.slate200,
    error: AppColors.error,
  );

  static const dark = ColorScheme.dark(
    primary: AppColors.primaryOnDark,
    onPrimary: AppColors.slate900,
    secondary: AppColors.skyAccent,
    surface: AppColors.slate900,
    onSurface: AppColors.slate100,
    surfaceContainerHighest: AppColors.slate800,
    outline: AppColors.slate700,
    error: AppColors.error,
  );
}
