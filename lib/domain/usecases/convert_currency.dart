import '../entities/exchange_rates.dart';

/// Converts an amount between two currencies (docs §24.3).
///
/// Pure and synchronous: it operates on an already-loaded [ExchangeRates]
/// snapshot, so the live converter and the camera overlay share one tested
/// implementation and neither blocks on I/O.
class ConvertCurrency {
  const ConvertCurrency();

  double call({
    required double amount,
    required String from,
    required String to,
    required ExchangeRates rates,
  }) {
    return amount * rates.getRate(from: from, to: to);
  }
}
