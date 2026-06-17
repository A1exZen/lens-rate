import 'package:flutter/widgets.dart';

/// Spacing tokens — 4dp base unit (docs §13). All values are multiples of 4.
abstract final class AppSpacing {
  static const double s1 = 4; // icon internal padding
  static const double s2 = 8; // icon ↔ label
  static const double s3 = 12; // chip padding
  static const double s4 = 16; // standard content padding [DEFAULT]
  static const double s5 = 20; // between sections within a card
  static const double s6 = 24; // card-to-card gap, bottom sheet top padding
  static const double s8 = 32; // section spacing on screen
  static const double s12 = 48; // large vertical spacing
  static const double s16 = 64; // top/bottom screen margin

  /// Minimum interactive touch target (Apple HIG / Material 3, docs §13.1).
  static const double minTouchTarget = 44;

  /// Standard horizontal screen margin on phones (docs §13.1).
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: s4);
}

/// Corner-radius tokens used across components (docs §14).
abstract final class AppRadius {
  static const double chip = 6;
  static const double overlay = 12;
  static const double input = 12;
  static const double sheet = 16;
}
