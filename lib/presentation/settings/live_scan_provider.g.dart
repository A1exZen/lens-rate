// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_scan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the camera uses continuous live scanning (vs tap-to-scan).
/// Persisted via SharedPreferences; off by default (docs §6.3).

@ProviderFor(LiveScanEnabled)
final liveScanEnabledProvider = LiveScanEnabledProvider._();

/// Whether the camera uses continuous live scanning (vs tap-to-scan).
/// Persisted via SharedPreferences; off by default (docs §6.3).
final class LiveScanEnabledProvider
    extends $NotifierProvider<LiveScanEnabled, bool> {
  /// Whether the camera uses continuous live scanning (vs tap-to-scan).
  /// Persisted via SharedPreferences; off by default (docs §6.3).
  LiveScanEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveScanEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveScanEnabledHash();

  @$internal
  @override
  LiveScanEnabled create() => LiveScanEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$liveScanEnabledHash() => r'f622e4c4a559d540bb7856c3106e6316a6d5aef8';

/// Whether the camera uses continuous live scanning (vs tap-to-scan).
/// Persisted via SharedPreferences; off by default (docs §6.3).

abstract class _$LiveScanEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
