import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/rates_providers.dart';

part 'live_scan_provider.g.dart';

/// Whether the camera uses continuous live scanning (vs tap-to-scan).
/// Persisted via SharedPreferences; off by default (docs §6.3).
@riverpod
class LiveScanEnabled extends _$LiveScanEnabled {
  @override
  bool build() => ref.watch(prefsStorageProvider).liveScan;

  Future<void> set(bool enabled) async {
    await ref.read(prefsStorageProvider).setLiveScan(enabled);
    state = enabled;
  }
}
