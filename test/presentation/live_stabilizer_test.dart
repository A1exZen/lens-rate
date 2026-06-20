import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_app/presentation/camera/detected_price.dart';
import 'package:test_flutter_app/presentation/camera/live_stabilizer.dart';

DetectedPrice _price(double amount) => DetectedPrice(
      rect: Rect.zero,
      originalAmount: amount,
      sourceCurrency: 'USD',
      convertedAmount: amount * 2,
      targetCurrency: 'BYN',
    );

void main() {
  group('LiveStabilizer', () {
    final t0 = DateTime(2026);

    test('shows the first detection immediately', () {
      final s = LiveStabilizer();
      expect(s.update([_price(500)], t0), isTrue);
      expect(s.shown.single.originalAmount, 500);
    });

    test('does not flip on a single different reading', () {
      final s = LiveStabilizer(requiredHits: 2);
      s.update([_price(500)], t0); // locked on 500
      // One stray misread should NOT change the display.
      expect(s.update([_price(600)], t0), isFalse);
      expect(s.shown.single.originalAmount, 500);
    });

    test('switches only after the new value repeats enough', () {
      final s = LiveStabilizer(requiredHits: 2);
      s.update([_price(500)], t0);
      s.update([_price(600)], t0); // 1st sighting of 600
      expect(s.update([_price(600)], t0), isTrue); // 2nd → switch
      expect(s.shown.single.originalAmount, 600);
    });

    test('staying on the same value keeps it steady (no repaint)', () {
      final s = LiveStabilizer();
      s.update([_price(500)], t0);
      expect(s.update([_price(500)], t0), isFalse);
      expect(s.shown.single.originalAmount, 500);
    });

    test('lingers after detections stop, then clears', () {
      final s = LiveStabilizer(linger: const Duration(milliseconds: 1500));
      s.update([_price(500)], t0);
      // Within the linger window: keep showing.
      expect(s.update([], t0.add(const Duration(milliseconds: 800))), isFalse);
      expect(s.shown, isNotEmpty);
      // Past the window: clear.
      expect(s.update([], t0.add(const Duration(milliseconds: 1600))), isTrue);
      expect(s.shown, isEmpty);
    });

    test('a flicker resets the candidate streak', () {
      final s = LiveStabilizer(requiredHits: 2);
      s.update([_price(500)], t0);
      s.update([_price(600)], t0); // candidate 600, hits=1
      s.update([_price(700)], t0); // candidate switches to 700, hits=1
      expect(s.shown.single.originalAmount, 500); // still locked
    });
  });
}
