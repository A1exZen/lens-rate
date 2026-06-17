import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_app/core/utils/price_parser.dart';

void main() {
  group('PriceParser.parseAll', () {
    test('detects symbol-prefixed prices', () {
      final r = PriceParser.parseAll(r'$19.99');
      expect(r, hasLength(1));
      expect(r.first.amount, 19.99);
      expect(r.first.code, 'USD');
    });

    test('detects euro and pound symbols', () {
      expect(PriceParser.parseAll('€5').first.code, 'EUR');
      expect(PriceParser.parseAll('£12.50').first.code, 'GBP');
    });

    test('detects ISO code suffix', () {
      final r = PriceParser.parseAll('100 PLN');
      expect(r.first.amount, 100);
      expect(r.first.code, 'PLN');
    });

    test('detects decimal price without any currency symbol', () {
      // Now lenient: a number with cents is a price; source comes from the
      // user-selected "From" currency at conversion time.
      final r = PriceParser.parseAll('19.99');
      expect(r, hasLength(1));
      expect(r.first.amount, 19.99);
      expect(r.first.code, isNull);
    });

    test('parses european decimal comma', () {
      final r = PriceParser.parseAll('€1.234,56');
      expect(r.first.amount, closeTo(1234.56, 1e-9));
    });

    test('parses thousands with comma + dot decimal', () {
      final r = PriceParser.parseAll(r'$1,234.56');
      expect(r.first.amount, closeTo(1234.56, 1e-9));
    });

    test('counts any standalone number (currency resolved later)', () {
      final r = PriceParser.parseAll('1500');
      expect(r, hasLength(1));
      expect(r.first.amount, 1500);
      expect(r.first.code, isNull);
      expect(r.first.hasDecimal, isFalse);
    });

    test('ignores zero', () {
      expect(PriceParser.parseAll('0'), isEmpty);
    });
  });
}
