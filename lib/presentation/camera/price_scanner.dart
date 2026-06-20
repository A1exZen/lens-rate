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
  static final _hasDigit = RegExp(r'\d');

  /// Scans a captured still file (tap-to-scan).
  Future<List<RawDetection>> scan(String imagePath) =>
      _process(InputImage.fromFilePath(imagePath));

  /// Scans a streamed frame already built into an [InputImage] (live scan).
  Future<List<RawDetection>> scanInput(InputImage input) => _process(input);

  Future<List<RawDetection>> _process(InputImage input) async {
    final recognized = await _recognizer.processImage(input);

    final detections = <RawDetection>[];
    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        // Anchor to the numeric part of the line, not the whole line: union the
        // boxes of word elements that contain a digit. This keeps the pill on
        // the price, not the product name beside it. Falls back to the line box.
        Rect? numericBox;
        for (final el in line.elements) {
          if (_hasDigit.hasMatch(el.text)) {
            numericBox = numericBox == null
                ? el.boundingBox
                : numericBox.expandToInclude(el.boundingBox);
          }
        }
        final box = numericBox ?? line.boundingBox;
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
