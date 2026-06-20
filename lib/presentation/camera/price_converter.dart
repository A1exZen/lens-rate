import 'dart:ui';

import '../../domain/entities/exchange_rates.dart';
import 'detected_price.dart';
import 'price_scanner.dart';

/// Ranks raw OCR detections and converts them to the target currency
/// (docs §6.3). Nearness to the frame centre dominates the score; an explicit
/// currency cue and a decimal part (cents) are boosts. The caller shows the top
/// few. Shared by tap-to-scan and live scanning.
List<DetectedPrice> convertDetections({
  required List<RawDetection> detections,
  required Size imageSize,
  required ExchangeRates rates,
  required String from,
  required String to,
}) {
  final center = Offset(imageSize.width / 2, imageSize.height / 2);
  final diag = imageSize.bottomRight(Offset.zero).distance;
  double scoreOf(RawDetection d) {
    final dist = (d.rect.center - center).distance / (diag == 0 ? 1 : diag);
    return (1 - dist) * 4 +
        (d.currencyCode != null ? 3 : 0) +
        (d.hasDecimal ? 2 : 0);
  }

  final ranked = [...detections]
    ..sort((a, b) => scoreOf(b).compareTo(scoreOf(a)));

  final prices = <DetectedPrice>[];
  for (final d in ranked) {
    final source = d.currencyCode ?? from;
    if (source == to) continue; // nothing to convert
    final rate = rates.getRate(from: source, to: to);
    if (rate == 0) continue; // unknown currency — skip rather than show 0
    prices.add(DetectedPrice(
      rect: d.rect,
      originalAmount: d.amount,
      sourceCurrency: source,
      convertedAmount: d.amount * rate,
      targetCurrency: to,
    ));
  }
  return prices;
}

/// True when two price lists carry the same amounts/currencies (ignoring small
/// box movement). Lets live scan keep steady pills instead of re-animating them
/// every frame while the user holds the device on one tag (docs §6.3).
bool samePrices(List<DetectedPrice> a, List<DetectedPrice> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].sourceCurrency != b[i].sourceCurrency ||
        a[i].targetCurrency != b[i].targetCurrency ||
        (a[i].originalAmount - b[i].originalAmount).abs() > 0.001) {
      return false;
    }
  }
  return true;
}
