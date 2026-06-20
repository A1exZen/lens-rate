import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter_app/app.dart';
import 'package:test_flutter_app/data/rates_providers.dart';
import 'package:test_flutter_app/domain/entities/exchange_rates.dart';
import 'package:test_flutter_app/domain/repositories/rates_repository.dart';

/// Fake repo so tests never hit the network (docs §6.4 boundary).
class _FakeRatesRepository implements RatesRepository {
  final _rates = ExchangeRates(
    base: 'USD',
    rates: const {'USD': 1, 'EUR': 0.92},
    fetchedAt: DateTime.now(),
  );

  @override
  ExchangeRates? cachedRates() => _rates;

  @override
  Future<ExchangeRates> getRates({bool forceRefresh = false}) async => _rates;
}

Future<void> _pumpApp(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({
    'default_from': 'USD',
    'default_to': 'EUR',
    'language_code': 'en',
  });
  final prefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        ratesRepositoryProvider.overrideWithValue(_FakeRatesRepository()),
      ],
      child: const LensRateApp(),
    ),
  );
  await _skipSplash(tester);
}

/// Advances past the animated splash screen onto the Converter home.
Future<void> _skipSplash(WidgetTester tester) async {
  await tester.pump(); // build splash
  await tester.pump(const Duration(milliseconds: 1800)); // splash delay → go
  await tester.pump(); // begin route transition
  await tester.pump(const Duration(milliseconds: 500)); // finish fade
}

void main() {
  testWidgets('converts live as the user types', (tester) async {
    await _pumpApp(tester);

    await tester.enterText(find.byType(TextField), '100');
    await tester.pump();

    // 100 USD * 0.92 = 92 EUR, shown with the ≈ prefix (docs §12.2).
    expect(find.text('≈ 92.00 EUR'), findsOneWidget);
  });

  testWidgets('swap reverses the currencies', (tester) async {
    await _pumpApp(tester);

    await tester.enterText(find.byType(TextField), '100');
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Swap currencies'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // swap animation

    // Now EUR → USD: 100 * (1 / 0.92) ≈ 108.70.
    expect(find.textContaining('USD'), findsWidgets);
    expect(find.text('≈ 108.70 USD'), findsOneWidget);
  });
}
