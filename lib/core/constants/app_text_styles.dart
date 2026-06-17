import 'package:flutter/material.dart';

/// Type scale (docs §12.1). Colour is intentionally omitted — it comes from the
/// theme / context so the same style works in light and dark mode.
///
/// Numbers in results use tabular figures for stable width as digits change
/// (docs §12). Apply [tabular] to any style showing changing numbers.
abstract final class AppTextStyles {
  static const _tnum = [FontFeature.tabularFigures()];

  static const displayXl = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.1,
    fontFeatures: _tnum,
  ); // converted amount — manual hero result

  static const displayLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.15,
    fontFeatures: _tnum,
  ); // AR overlay price

  static const displayMd = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.2,
  ); // screen titles

  static const titleLg = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  ); // section headers, modal titles

  static const titleMd = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.35,
  ); // list labels, tab labels

  static const bodyLg = TextStyle(fontSize: 16, height: 1.5); // body copy
  static const bodyMd = TextStyle(fontSize: 15, height: 1.5); // secondary body

  static const labelMd = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
  ); // chip labels, badges, hints

  static const caption = TextStyle(fontSize: 12, height: 1.4); // timestamps
  static const micro = TextStyle(fontSize: 11, height: 1.3); // legal, version
}
