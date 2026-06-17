import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/exchange_rates.dart';
import '../domain/repositories/rates_repository.dart';
import 'repositories/rates_repository_impl.dart';
import 'sources/local/prefs_storage.dart';
import 'sources/local/rates_cache.dart';
import 'sources/remote/rates_api.dart';

part 'rates_providers.g.dart';

/// Overridden in main() once SharedPreferences has been loaded.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider must be overridden');

@Riverpod(keepAlive: true)
PrefsStorage prefsStorage(Ref ref) =>
    PrefsStorage(ref.watch(sharedPreferencesProvider));

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
RatesCache ratesCache(Ref ref) =>
    RatesCache(Hive.box<String>('rates_cache'));

@Riverpod(keepAlive: true)
RatesApi ratesApi(Ref ref) => RatesApi(ref.watch(httpClientProvider));

@Riverpod(keepAlive: true)
RatesRepository ratesRepository(Ref ref) =>
    RatesRepositoryImpl(ref.watch(ratesApiProvider), ref.watch(ratesCacheProvider));

/// Loads rates via the offline-first repository and exposes a refresh action
/// (docs §6.4, §22.1 AsyncNotifier).
@riverpod
class Rates extends _$Rates {
  @override
  Future<ExchangeRates> build() =>
      ref.watch(ratesRepositoryProvider).getRates();

  /// Force a network refresh (e.g. settings "force refresh", docs §4.4).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(ratesRepositoryProvider).getRates(forceRefresh: true),
    );
  }
}
