import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/currencies.dart';
import '../../data/rates_providers.dart';
import '../../domain/entities/currency.dart';

part 'currency_search_provider.g.dart';

/// The current search query in the selector (docs §14.6).
@riverpod
class CurrencyQuery extends _$CurrencyQuery {
  @override
  String build() => '';

  void update(String value) => state = value.trim();
}

/// Currencies matching the query, by code or name (case-insensitive).
@riverpod
List<Currency> filteredCurrencies(Ref ref) {
  final query = ref.watch(currencyQueryProvider).toLowerCase();
  if (query.isEmpty) return Currencies.sorted;
  return Currencies.sorted
      .where((c) =>
          c.code.toLowerCase().contains(query) ||
          c.name.toLowerCase().contains(query))
      .toList();
}

/// Last-used currencies, most recent first (docs §3.2, top 5).
@riverpod
class RecentCurrencies extends _$RecentCurrencies {
  static const _max = 5;

  @override
  List<Currency> build() {
    final codes = ref.watch(prefsStorageProvider).recentCurrencies;
    return codes.map(Currencies.find).whereType<Currency>().toList();
  }

  Future<void> add(String code) async {
    final prefs = ref.read(prefsStorageProvider);
    final updated = [code, ...prefs.recentCurrencies.where((c) => c != code)]
        .take(_max)
        .toList();
    await prefs.setRecentCurrencies(updated);
    ref.invalidateSelf();
  }
}
