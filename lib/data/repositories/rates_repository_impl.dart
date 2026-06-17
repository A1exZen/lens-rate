import '../../core/errors/failure.dart';
import '../../domain/entities/exchange_rates.dart';
import '../../domain/repositories/rates_repository.dart';
import '../sources/local/rates_cache.dart';
import '../sources/remote/rates_api.dart';

/// Implements the offline-first strategy from docs §6.4.
class RatesRepositoryImpl implements RatesRepository {
  const RatesRepositoryImpl(this._api, this._cache);

  final RatesApi _api;
  final RatesCache _cache;

  /// Cache is considered fresh for an hour (docs §3.3, §6.4).
  static const _staleAfter = Duration(hours: 1);

  @override
  ExchangeRates? cachedRates() => _cache.read();

  @override
  Future<ExchangeRates> getRates({bool forceRefresh = false}) async {
    final cached = _cache.read();

    final isFresh = cached != null && cached.age < _staleAfter;
    if (isFresh && !forceRefresh) return cached;

    try {
      final fresh = await _api.getRates();
      await _cache.save(fresh);
      return fresh;
    } on RatesFailure {
      // Offline / provider error: fall back to any cache, even if stale.
      if (cached != null) return cached;
      rethrow;
    }
  }
}
