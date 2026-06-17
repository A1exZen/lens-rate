import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/rates_providers.dart';
import '../../domain/entities/exchange_rates.dart';
import '../../domain/usecases/convert_currency.dart';
import 'converter_state.dart';

part 'converter_provider.g.dart';

/// Holds the converter's from/to/amount (docs §22.2). Methods mutate immutably
/// via copyWith; the result is computed separately by [conversion].
@riverpod
class ConverterNotifier extends _$ConverterNotifier {
  @override
  ConverterState build() {
    final prefs = ref.watch(prefsStorageProvider);
    return ConverterState(from: prefs.defaultFrom, to: prefs.defaultTo);
  }

  void setAmount(String input) {
    // Accept both '.' and ',' as decimal separators for international keyboards.
    final amount = double.tryParse(input.replaceAll(',', '.')) ?? 0;
    state = state.copyWith(amount: amount);
  }

  void setFrom(String code) => state = state.copyWith(from: code);
  void setTo(String code) => state = state.copyWith(to: code);

  void swapCurrencies() =>
      state = state.copyWith(from: state.to, to: state.from);
}

/// Derived conversion result + the unit rate, recomputed whenever the inputs or
/// the rates change. Returns zeros until rates have loaded.
@riverpod
({double result, double rate}) conversion(Ref ref) {
  final input = ref.watch(converterProvider);
  final ExchangeRates? rates = ref.watch(ratesProvider).value;
  if (rates == null) return (result: 0, rate: 0);

  final rate = rates.getRate(from: input.from, to: input.to);
  final result = const ConvertCurrency()(
    amount: input.amount,
    from: input.from,
    to: input.to,
    rates: rates,
  );
  return (result: result, rate: rate);
}
