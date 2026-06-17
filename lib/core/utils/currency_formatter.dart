import 'package:intl/intl.dart';

import '../constants/currencies.dart';

/// Locale-aware money formatting (docs §12.2).
///
/// Uses the catalogue's per-currency decimals (0 for JPY/KRW/VND). Conversions
/// are mid-market estimates, so [formatConverted] prefixes the `≈` symbol.
abstract final class CurrencyFormatter {
  static int _decimalsFor(String code) =>
      Currencies.find(code)?.decimals ?? 2;

  /// e.g. `158.74` / `1,234` — number only, no code.
  static String formatAmount(double amount, String code) {
    final decimals = _decimalsFor(code);
    final pattern = NumberFormat.decimalPatternDigits(decimalDigits: decimals);
    return pattern.format(amount);
  }

  /// e.g. `158.74 BYN` — number + uppercase ISO code (docs §12.2).
  static String formatWithCode(double amount, String code) =>
      '${formatAmount(amount, code)} ${code.toUpperCase()}';

  /// e.g. `≈ 158.74 BYN` — converted result with the approximate prefix.
  static String formatConverted(double amount, String code) =>
      '≈ ${formatWithCode(amount, code)}';
}
