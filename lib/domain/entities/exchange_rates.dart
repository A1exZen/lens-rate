import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rates.freezed.dart';
part 'exchange_rates.g.dart';

/// A snapshot of exchange rates, all expressed against [base] (docs §3.3).
///
/// [fetchedAt] is when *we* retrieved them — used to decide cache freshness
/// (docs §6.4). JSON (de)serialisation lets the cache store this directly.
@freezed
abstract class ExchangeRates with _$ExchangeRates {
  const ExchangeRates._();

  const factory ExchangeRates({
    required String base, // base currency code, e.g. 'USD'
    required Map<String, double> rates, // units of <code> per 1 base
    required DateTime fetchedAt,
  }) = _ExchangeRates;

  factory ExchangeRates.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRatesFromJson(json);

  /// Rate to multiply a [from] amount by to get the [to] amount.
  ///
  /// Rates are relative to [base], so cross-rate = to/from. Returns 0 when a
  /// code is missing so the UI shows a clear zero rather than crashing.
  double getRate({required String from, required String to}) {
    final fromRate = rates[from];
    final toRate = rates[to];
    if (fromRate == null || toRate == null || fromRate == 0) return 0;
    return toRate / fromRate;
  }

  /// How stale this snapshot is right now.
  Duration get age => DateTime.now().difference(fetchedAt);
}
