import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';

/// A fiat currency the app can convert (docs §3.3).
///
/// [decimals] is how many fraction digits to display — 0 for JPY/KRW/VND,
/// 2 for most others (docs §12.2).
@freezed
abstract class Currency with _$Currency {
  const factory Currency({
    required String code, // ISO 4217, e.g. 'USD'
    required String name, // 'US Dollar'
    required String flag, // emoji, e.g. '🇺🇸'
    @Default(2) int decimals,
  }) = _Currency;
}
