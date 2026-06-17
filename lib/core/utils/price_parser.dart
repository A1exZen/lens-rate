/// A price found in OCR text: the [amount], the currency [code] if one was
/// detected from a symbol/ISO cue (else null → caller uses the selected source),
/// and whether it looked price-like (had decimals or a currency cue).
typedef PriceMatch = ({double amount, String? code, bool hasDecimal});

/// Detects prices in OCR text (docs §6.3).
///
/// Lenient by design: a number counts as a price if it has a decimal part
/// (e.g. `19.99`) OR a currency cue (symbol / ISO code). Plain integers like
/// quantities or sizes are ignored to avoid converting noise.
abstract final class PriceParser {
  /// Symbol → ISO code. Ambiguous symbols resolve to the most common currency.
  static const symbolToCode = {
    r'$': 'USD',
    '€': 'EUR',
    '£': 'GBP',
    '¥': 'JPY',
    '₽': 'RUB',
    'zł': 'PLN',
    '₴': 'UAH',
    '₩': 'KRW',
    '₹': 'INR',
    '฿': 'THB',
    '₺': 'TRY',
  };

  // First alt: grouped thousands (needs ≥1 separator). Second alt: a plain
  // run of digits. Order + the `+` ensure e.g. "1500" parses whole, not "150".
  static final _numberRe = RegExp(r'\d{1,3}(?:[ .,]\d{3})+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?');
  static final _symbolRe = RegExp(r'[$€£¥₽₴₩₹฿₺]|zł');
  static final _isoRe = RegExp(r'\b([A-Z]{3})\b');

  /// All price-like numbers in [text]. The currency [code] is taken from a
  /// symbol or ISO code found anywhere in the same line, or null if none.
  static List<PriceMatch> parseAll(String text) {
    final lineCode = _detectCurrency(text);
    final matches = <PriceMatch>[];

    for (final m in _numberRe.allMatches(text)) {
      final raw = m.group(0)!;
      final amount = _parseNumber(raw);
      if (amount == null || amount == 0) continue;

      // Count any number as a possible price. Whether it has a decimal part or a
      // currency cue is kept so the camera can rank the most price-like first.
      final hasDecimal = RegExp(r'[.,]\d{1,2}$').hasMatch(raw);
      matches.add((amount: amount, code: lineCode, hasDecimal: hasDecimal));
    }
    return matches;
  }

  /// First currency cue in [text]: a symbol, else a known ISO code.
  static String? _detectCurrency(String text) {
    final symbol = _symbolRe.firstMatch(text)?.group(0);
    if (symbol != null) return symbolToCode[symbol];

    for (final m in _isoRe.allMatches(text)) {
      final code = m.group(1)!;
      if (symbolToCode.containsValue(code) || _knownIso.contains(code)) {
        return code;
      }
    }
    return null;
  }

  // A few common codes that have no symbol, so the ISO cue still works.
  static const _knownIso = {
    'USD', 'EUR', 'GBP', 'CHF', 'CAD', 'AUD', 'NZD', 'SEK', 'NOK', 'DKK',
    'PLN', 'CZK', 'HUF', 'RON', 'BYN', 'TRY', 'AED', 'SAR', 'ILS', 'ZAR',
    'BRL', 'MXN', 'SGD', 'HKD', 'CNY',
  };

  /// Parses a number string handling `1,234.56`, `1.234,56`, `1 234,56`, etc.
  /// by treating the rightmost separator as the decimal point.
  static double? _parseNumber(String raw) {
    var s = raw.replaceAll(' ', '');
    final lastComma = s.lastIndexOf(',');
    final lastDot = s.lastIndexOf('.');

    if (lastComma >= 0 && lastDot >= 0) {
      final decimalSep = lastComma > lastDot ? ',' : '.';
      final thousandsSep = decimalSep == ',' ? '.' : ',';
      s = s.replaceAll(thousandsSep, '').replaceAll(decimalSep, '.');
    } else if (lastComma >= 0) {
      s = (s.length - lastComma - 1) <= 2
          ? s.replaceAll(',', '.')
          : s.replaceAll(',', '');
    } else if (lastDot >= 0) {
      if ((s.length - lastDot - 1) > 2) s = s.replaceAll('.', '');
    }
    return double.tryParse(s);
  }
}
