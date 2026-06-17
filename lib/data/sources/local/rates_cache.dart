import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../domain/entities/exchange_rates.dart';

/// Persists the last fetched rates as a JSON string in Hive (docs §6.4).
///
/// Storing JSON (rather than a typed adapter) keeps the model free of Hive
/// annotations and avoids a codegen dependency on hive_generator.
class RatesCache {
  const RatesCache(this._box);

  final Box<String> _box;

  static const _key = 'latest';

  Future<void> save(ExchangeRates rates) async {
    await _box.put(_key, jsonEncode(rates.toJson()));
  }

  ExchangeRates? read() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    return ExchangeRates.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
