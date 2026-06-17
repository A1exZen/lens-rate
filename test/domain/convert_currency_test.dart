import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_app/domain/entities/exchange_rates.dart';
import 'package:test_flutter_app/domain/usecases/convert_currency.dart';

void main() {
  // Rates are per 1 USD (base): 1 EUR costs 1/0.92 USD, etc.
  final rates = ExchangeRates(
    base: 'USD',
    rates: const {'USD': 1, 'EUR': 0.92, 'JPY': 150, 'GBP': 0.8},
    fetchedAt: DateTime(2026, 6, 14),
  );

  group('ExchangeRates.getRate', () {
    test('cross rate is to/from', () {
      expect(rates.getRate(from: 'USD', to: 'EUR'), closeTo(0.92, 1e-9));
      expect(rates.getRate(from: 'EUR', to: 'USD'), closeTo(1 / 0.92, 1e-9));
      expect(rates.getRate(from: 'GBP', to: 'EUR'), closeTo(0.92 / 0.8, 1e-9));
    });

    test('same currency is 1', () {
      expect(rates.getRate(from: 'EUR', to: 'EUR'), 1);
    });

    test('unknown currency returns 0 (no crash)', () {
      expect(rates.getRate(from: 'USD', to: 'XXX'), 0);
      expect(rates.getRate(from: 'XXX', to: 'USD'), 0);
    });
  });

  group('ConvertCurrency', () {
    const convert = ConvertCurrency();

    test('multiplies amount by the cross rate', () {
      final result = convert(amount: 100, from: 'USD', to: 'EUR', rates: rates);
      expect(result, closeTo(92, 1e-9));
    });

    test('zero amount converts to zero', () {
      final result = convert(amount: 0, from: 'USD', to: 'JPY', rates: rates);
      expect(result, 0);
    });
  });
}
