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

    group('noise filtering (no currency cue)', () {
      test('drops weight/volume/quantity units', () {
        expect(PriceParser.parseAll('500 г'), isEmpty);
        expect(PriceParser.parseAll('1,5 л'), isEmpty);
        expect(PriceParser.parseAll('250 ml'), isEmpty);
        expect(PriceParser.parseAll('2 шт'), isEmpty);
        expect(PriceParser.parseAll('-20%'), isEmpty);
      });

      test('does not mistake грн for grams (kept as a price)', () {
        // "грн" is a Cyrillic word cue we don't map (the Latin OCR rarely reads
        // it anyway), so the source falls back to the selected From — but the
        // key point is the number is NOT dropped as "100 г" (grams).
        final r = PriceParser.parseAll('100 грн');
        expect(r, hasLength(1));
        expect(r.first.amount, 100);
        expect(r.first.code, isNull);
      });

      test('keeps a price-per-unit when a currency cue is present', () {
        final r = PriceParser.parseAll('199₽/кг');
        expect(r, hasLength(1));
        expect(r.first.amount, 199);
        expect(r.first.code, 'RUB');
      });

      test('drops long barcode-like digit runs', () {
        expect(PriceParser.parseAll('4607034170012'), isEmpty);
      });

      test('keeps normal integer prices', () {
        expect(PriceParser.parseAll('1500'), hasLength(1));
        expect(PriceParser.parseAll('2024'), hasLength(1));
      });
    });
  });
}
