import 'dart:ui';

/// A recognised price with its conversion, ready to overlay (docs §14.1).
/// [rect] is in captured-image pixel coordinates; the overlay maps it to screen
/// space using the displayed image's fit transform.
class DetectedPrice {
  const DetectedPrice({
    required this.rect,
    required this.originalAmount,
    required this.sourceCurrency,
    required this.convertedAmount,
    required this.targetCurrency,
  });

  final Rect rect;
  final double originalAmount;
  final String sourceCurrency;
  final double convertedAmount;
  final String targetCurrency;
}
