// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current search query in the selector (docs §14.6).

@ProviderFor(CurrencyQuery)
final currencyQueryProvider = CurrencyQueryProvider._();

/// The current search query in the selector (docs §14.6).
final class CurrencyQueryProvider
    extends $NotifierProvider<CurrencyQuery, String> {
  /// The current search query in the selector (docs §14.6).
  CurrencyQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyQueryHash();

  @$internal
  @override
  CurrencyQuery create() => CurrencyQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currencyQueryHash() => r'1d5c42922d71b202ad5a59d351887e4c59da7a13';

/// The current search query in the selector (docs §14.6).

abstract class _$CurrencyQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Currencies matching the query, by code or name (case-insensitive).

@ProviderFor(filteredCurrencies)
final filteredCurrenciesProvider = FilteredCurrenciesProvider._();

/// Currencies matching the query, by code or name (case-insensitive).

final class FilteredCurrenciesProvider
    extends $FunctionalProvider<List<Currency>, List<Currency>, List<Currency>>
    with $Provider<List<Currency>> {
  /// Currencies matching the query, by code or name (case-insensitive).
  FilteredCurrenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredCurrenciesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredCurrenciesHash();

  @$internal
  @override
  $ProviderElement<List<Currency>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Currency> create(Ref ref) {
    return filteredCurrencies(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Currency> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Currency>>(value),
    );
  }
}

String _$filteredCurrenciesHash() =>
    r'7a946c2f8cd7c9b2bd35286cd594801bc7365441';

/// Last-used currencies, most recent first (docs §3.2, top 5).

@ProviderFor(RecentCurrencies)
final recentCurrenciesProvider = RecentCurrenciesProvider._();

/// Last-used currencies, most recent first (docs §3.2, top 5).
final class RecentCurrenciesProvider
    extends $NotifierProvider<RecentCurrencies, List<Currency>> {
  /// Last-used currencies, most recent first (docs §3.2, top 5).
  RecentCurrenciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentCurrenciesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentCurrenciesHash();

  @$internal
  @override
  RecentCurrencies create() => RecentCurrencies();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Currency> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Currency>>(value),
    );
  }
}

String _$recentCurrenciesHash() => r'4127626ddfded8583723235a01672e4c635dbb95';

/// Last-used currencies, most recent first (docs §3.2, top 5).

abstract class _$RecentCurrencies extends $Notifier<List<Currency>> {
  List<Currency> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Currency>, List<Currency>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Currency>, List<Currency>>,
              List<Currency>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
