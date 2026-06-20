import 'detected_price.dart';
import 'price_converter.dart';

/// Temporal smoothing for live scan (docs §6.3). Per-frame OCR readings of the
/// same tag jitter (500 → 5.00 → 600), so showing each raw result makes the
/// overlay flip every frame. This locks onto a single price and:
///
/// - shows the first detection immediately (fast acquisition);
/// - only switches to a *different* value once it's been seen [requiredHits]
///   times in a row (resists one-off misreads);
/// - keeps the last value for [linger] after detections stop, so a brief miss
///   doesn't blink the pill away.
///
/// Live shows exactly one pill — the most central detection (ranked first).
class LiveStabilizer {
  LiveStabilizer({
    this.requiredHits = 2,
    this.linger = const Duration(milliseconds: 1500),
  });

  final int requiredHits;
  final Duration linger;

  List<DetectedPrice> _shown = const [];
  List<DetectedPrice> _candidate = const [];
  int _hits = 0;
  DateTime _lastHit = DateTime.fromMillisecondsSinceEpoch(0);

  /// The price currently locked for display (0 or 1 entry).
  List<DetectedPrice> get shown => _shown;

  /// Feeds the latest ranked detections at time [now]. Returns true if [shown]
  /// changed and the caller should repaint.
  bool update(List<DetectedPrice> ranked, DateTime now) {
    final top = ranked.isEmpty ? const <DetectedPrice>[] : [ranked.first];

    if (top.isEmpty) {
      // Nothing this frame — hold the last pill until the linger window passes.
      if (_shown.isNotEmpty && now.difference(_lastHit) > linger) {
        _reset();
        return true;
      }
      return false;
    }

    _lastHit = now;

    // Fast first acquisition: show immediately when nothing is on screen.
    if (_shown.isEmpty) {
      _shown = top;
      _candidate = const [];
      _hits = 0;
      return true;
    }

    // Same value still on the tag → steady, nothing to do.
    if (samePrices(top, _shown)) {
      _candidate = const [];
      _hits = 0;
      return false;
    }

    // A different value: require consecutive agreement before switching.
    if (samePrices(top, _candidate)) {
      _hits++;
    } else {
      _candidate = top;
      _hits = 1;
    }
    if (_hits >= requiredHits) {
      _shown = top;
      _candidate = const [];
      _hits = 0;
      return true;
    }
    return false;
  }

  /// Clears all state (e.g. when the camera restarts).
  void reset() => _reset();

  void _reset() {
    _shown = const [];
    _candidate = const [];
    _hits = 0;
  }
}
