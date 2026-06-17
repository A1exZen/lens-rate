import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../core/utils/price_parser.dart';

/// A price found in an image: where it is (image-pixel coords) and what it says.
class RawDetection {
  const RawDetection({
    required this.rect,
    required this.amount,
    this.currencyCode,
    this.hasDecimal = false,
  });

  final Rect rect;
  final double amount;

  /// Currency detected from a symbol/ISO cue, or null → use the selected source.
  final String? currencyCode;

  /// Had a decimal part (e.g. cents) — a strong price signal for ranking.
  final bool hasDecimal;
}

/// Runs on-device OCR (ML Kit) over a captured still and extracts price tags
/// (docs §6.3). Created once and reused; call [dispose] when done.
class PriceScanner {
  final TextRecognizer _recognizer = TextRecognizer();

  Future<List<RawDetection>> scan(String imagePath) async {
    final input = InputImage.fromFilePath(imagePath);
    final recognized = await _recognizer.processImage(input);

    final detections = <RawDetection>[];
    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        final box = line.boundingBox;
        for (final price in PriceParser.parseAll(line.text)) {
          detections.add(RawDetection(
            rect: box,
            amount: price.amount,
            currencyCode: price.code,
            hasDecimal: price.hasDecimal,
          ));
        }
      }
    }
    return detections;
  }

  void dispose() => _recognizer.close();
}
