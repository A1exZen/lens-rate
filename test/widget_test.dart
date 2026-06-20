// Smoke test: the app boots into the Converter home screen.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter_app/app.dart';
import 'package:test_flutter_app/data/rates_providers.dart';

void main() {
  testWidgets('App boots into the Converter home with a Scan button',
      (tester) async {
    SharedPreferences.setMockInitialValues({'language_code': 'en'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const LensRateApp(),
      ),
    );
    // Advance past the animated splash screen onto the Converter home.
    await tester.pump(); // build splash
    await tester.pump(const Duration(milliseconds: 1800)); // splash delay → go
    await tester.pump(); // begin route transition
    await tester.pump(const Duration(milliseconds: 500)); // finish fade

    expect(find.text('LensRate'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget); // FAB → camera
  });
}
