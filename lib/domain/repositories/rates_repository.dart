import '../entities/exchange_rates.dart';

/// Abstraction over rate retrieval (docs §24.2). Domain depends only on this;
/// the data layer provides the concrete implementation.
abstract interface class RatesRepository {
  /// Returns usable rates following the offline strategy (docs §6.4):
  /// fresh cache → cache; stale + online → network (and re-cache);
  /// stale + offline → cache; nothing cached + offline → throws.
  Future<ExchangeRates> getRates({bool forceRefresh = false});

  /// Last cached snapshot without any network call, or null if none.
  ExchangeRates? cachedRates();
}
