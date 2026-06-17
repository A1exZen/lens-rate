// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rates_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in main() once SharedPreferences has been loaded.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Overridden in main() once SharedPreferences has been loaded.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// Overridden in main() once SharedPreferences has been loaded.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'70ef90bd70df9f89260fca9b542d9f8d25d8e3cb';

@ProviderFor(prefsStorage)
final prefsStorageProvider = PrefsStorageProvider._();

final class PrefsStorageProvider
    extends $FunctionalProvider<PrefsStorage, PrefsStorage, PrefsStorage>
    with $Provider<PrefsStorage> {
  PrefsStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefsStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefsStorageHash();

  @$internal
  @override
  $ProviderElement<PrefsStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrefsStorage create(Ref ref) {
    return prefsStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrefsStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrefsStorage>(value),
    );
  }
}

String _$prefsStorageHash() => r'638b19d5745b9837aa80c1bac14d471762bd9a66';

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'7ec49beae0f15115de79f9aa98dbd250130e26d8';

@ProviderFor(ratesCache)
final ratesCacheProvider = RatesCacheProvider._();

final class RatesCacheProvider
    extends $FunctionalProvider<RatesCache, RatesCache, RatesCache>
    with $Provider<RatesCache> {
  RatesCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratesCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratesCacheHash();

  @$internal
  @override
  $ProviderElement<RatesCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RatesCache create(Ref ref) {
    return ratesCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RatesCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RatesCache>(value),
    );
  }
}

String _$ratesCacheHash() => r'fe6266617629732bb172b1a12b23c52ce768631b';

@ProviderFor(ratesApi)
final ratesApiProvider = RatesApiProvider._();

final class RatesApiProvider
    extends $FunctionalProvider<RatesApi, RatesApi, RatesApi>
    with $Provider<RatesApi> {
  RatesApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratesApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratesApiHash();

  @$internal
  @override
  $ProviderElement<RatesApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RatesApi create(Ref ref) {
    return ratesApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RatesApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RatesApi>(value),
    );
  }
}

String _$ratesApiHash() => r'9d821884e7457784f88b6c555b980450004f62bd';

@ProviderFor(ratesRepository)
final ratesRepositoryProvider = RatesRepositoryProvider._();

final class RatesRepositoryProvider
    extends
        $FunctionalProvider<RatesRepository, RatesRepository, RatesRepository>
    with $Provider<RatesRepository> {
  RatesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratesRepositoryHash();

  @$internal
  @override
  $ProviderElement<RatesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RatesRepository create(Ref ref) {
    return ratesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RatesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RatesRepository>(value),
    );
  }
}

String _$ratesRepositoryHash() => r'ced0d66a3a597f49ec1a7fda7d78ab0a59a4dc90';

/// Loads rates via the offline-first repository and exposes a refresh action
/// (docs §6.4, §22.1 AsyncNotifier).

@ProviderFor(Rates)
final ratesProvider = RatesProvider._();

/// Loads rates via the offline-first repository and exposes a refresh action
/// (docs §6.4, §22.1 AsyncNotifier).
final class RatesProvider extends $AsyncNotifierProvider<Rates, ExchangeRates> {
  /// Loads rates via the offline-first repository and exposes a refresh action
  /// (docs §6.4, §22.1 AsyncNotifier).
  RatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ratesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ratesHash();

  @$internal
  @override
  Rates create() => Rates();
}

String _$ratesHash() => r'ad87f75676c113abdbab23bfa510c110cd2a3569';

/// Loads rates via the offline-first repository and exposes a refresh action
/// (docs §6.4, §22.1 AsyncNotifier).

abstract class _$Rates extends $AsyncNotifier<ExchangeRates> {
  FutureOr<ExchangeRates> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ExchangeRates>, ExchangeRates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExchangeRates>, ExchangeRates>,
              AsyncValue<ExchangeRates>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
