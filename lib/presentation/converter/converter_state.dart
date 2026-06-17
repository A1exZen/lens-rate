import 'package:freezed_annotation/freezed_annotation.dart';

part 'converter_state.freezed.dart';

/// User inputs for the manual converter (docs §4.2). The result is derived
/// reactively from these plus the current rates (see conversionProvider), so it
/// is intentionally *not* stored here — it can never go stale.
@freezed
abstract class ConverterState with _$ConverterState {
  const factory ConverterState({
    required String from,
    required String to,
    @Default(0) double amount,
  }) = _ConverterState;
}
