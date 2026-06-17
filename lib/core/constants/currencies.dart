import '../../domain/entities/currency.dart';

/// Static catalogue of supported currencies (docs §3.3 — minimum 30 fiat).
///
/// Decimals follow docs §12.2: 0 for JPY/KRW/VND, 2 otherwise. This is the
/// single source for the currency selector and for formatting.
abstract final class Currencies {
  static const List<Currency> all = [
    Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
    Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
    Currency(code: 'GBP', name: 'British Pound', flag: '🇬🇧'),
    Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵', decimals: 0),
    Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳'),
    Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭'),
    Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦'),
    Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺'),
    Currency(code: 'NZD', name: 'New Zealand Dollar', flag: '🇳🇿'),
    Currency(code: 'SEK', name: 'Swedish Krona', flag: '🇸🇪'),
    Currency(code: 'NOK', name: 'Norwegian Krone', flag: '🇳🇴'),
    Currency(code: 'DKK', name: 'Danish Krone', flag: '🇩🇰'),
    Currency(code: 'PLN', name: 'Polish Zloty', flag: '🇵🇱'),
    Currency(code: 'CZK', name: 'Czech Koruna', flag: '🇨🇿'),
    Currency(code: 'HUF', name: 'Hungarian Forint', flag: '🇭🇺'),
    Currency(code: 'RON', name: 'Romanian Leu', flag: '🇷🇴'),
    Currency(code: 'RUB', name: 'Russian Ruble', flag: '🇷🇺'),
    Currency(code: 'BYN', name: 'Belarusian Ruble', flag: '🇧🇾'),
    Currency(code: 'UAH', name: 'Ukrainian Hryvnia', flag: '🇺🇦'),
    Currency(code: 'TRY', name: 'Turkish Lira', flag: '🇹🇷'),
    Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳'),
    Currency(code: 'IDR', name: 'Indonesian Rupiah', flag: '🇮🇩'),
    Currency(code: 'KRW', name: 'South Korean Won', flag: '🇰🇷', decimals: 0),
    Currency(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬'),
    Currency(code: 'HKD', name: 'Hong Kong Dollar', flag: '🇭🇰'),
    Currency(code: 'THB', name: 'Thai Baht', flag: '🇹🇭'),
    Currency(code: 'MYR', name: 'Malaysian Ringgit', flag: '🇲🇾'),
    Currency(code: 'PHP', name: 'Philippine Peso', flag: '🇵🇭'),
    Currency(code: 'VND', name: 'Vietnamese Dong', flag: '🇻🇳', decimals: 0),
    Currency(code: 'AED', name: 'UAE Dirham', flag: '🇦🇪'),
    Currency(code: 'SAR', name: 'Saudi Riyal', flag: '🇸🇦'),
    Currency(code: 'ILS', name: 'Israeli Shekel', flag: '🇮🇱'),
    Currency(code: 'ZAR', name: 'South African Rand', flag: '🇿🇦'),
    Currency(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷'),
    Currency(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽'),
    Currency(code: 'ARS', name: 'Argentine Peso', flag: '🇦🇷'),
  ];

  /// Most-used currencies, pinned to the top of every list for quick access.
  static const popularCodes = ['USD', 'EUR', 'PLN', 'CNY', 'BYN', 'RUB'];

  /// Fast lookup by ISO code; null when unsupported.
  static final Map<String, Currency> byCode = {
    for (final c in all) c.code: c,
  };

  /// [all] reordered so the popular currencies come first (in [popularCodes]
  /// order), then the rest. Used by the selector so they're always on top.
  static final List<Currency> sorted = [
    for (final code in popularCodes) byCode[code]!,
    for (final c in all)
      if (!popularCodes.contains(c.code)) c,
  ];

  static Currency? find(String code) => byCode[code.toUpperCase()];
}
