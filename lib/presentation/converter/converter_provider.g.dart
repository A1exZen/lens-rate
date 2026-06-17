// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the converter's from/to/amount (docs §22.2). Methods mutate immutably
/// via copyWith; the result is computed separately by [conversion].

@ProviderFor(ConverterNotifier)
final converterProvider = ConverterNotifierProvider._();

/// Holds the converter's from/to/amount (docs §22.2). Methods mutate immutably
/// via copyWith; the result is computed separately by [conversion].
final class ConverterNotifierProvider
    extends $NotifierProvider<ConverterNotifier, ConverterState> {
  /// Holds the converter's from/to/amount (docs §22.2). Methods mutate immutably
  /// via copyWith; the result is computed separately by [conversion].
  ConverterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'converterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$converterNotifierHash();

  @$internal
  @override
  ConverterNotifier create() => ConverterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConverterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConverterState>(value),
    );
  }
}

String _$converterNotifierHash() => r'cb257f3f5b2f262097b03dc9ae8d6cc8cf22399f';

/// Holds the converter's from/to/amount (docs §22.2). Methods mutate immutably
/// via copyWith; the result is computed separately by [conversion].

abstract class _$ConverterNotifier extends $Notifier<ConverterState> {
  ConverterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ConverterState, ConverterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConverterState, ConverterState>,
              ConverterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Derived conversion result + the unit rate, recomputed whenever the inputs or
/// the rates change. Returns zeros until rates have loaded.

@ProviderFor(conversion)
final conversionProvider = ConversionProvider._();

/// Derived conversion result + the unit rate, recomputed whenever the inputs or
/// the rates change. Returns zeros until rates have loaded.

final class ConversionProvider
    extends
        $FunctionalProvider<
          ({double rate, double result}),
          ({double rate, double result}),
          ({double rate, double result})
        >
    with $Provider<({double rate, double result})> {
  /// Derived conversion result + the unit rate, recomputed whenever the inputs or
  /// the rates change. Returns zeros until rates have loaded.
  ConversionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversionHash();

  @$internal
  @override
  $ProviderElement<({double rate, double result})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({double rate, double result}) create(Ref ref) {
    return conversion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({double rate, double result}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({double rate, double result})>(
        value,
      ),
    );
  }
}

String _$conversionHash() => r'21c573a2b9564f31ddf66334847d6b3bf2de916f';
