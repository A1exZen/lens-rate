import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/errors/failure.dart';
import '../../../domain/entities/exchange_rates.dart';

/// Fetches live rates from the keyless open.er-api.com endpoint (docs §6.1).
///
/// Response shape: `{ result, base_code, rates: {USD:1, EUR:0.92, ...} }`.
class RatesApi {
  const RatesApi(this._client, {this.baseCurrency = 'USD'});

  final http.Client _client;
  final String baseCurrency;

  static const _host = 'open.er-api.com';

  Future<ExchangeRates> getRates() async {
    final uri = Uri.https(_host, '/v6/latest/$baseCurrency');
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on SocketException catch (e) {
      throw NetworkFailure(e.message);
    } on HttpException catch (e) {
      throw NetworkFailure(e.message);
    }

    if (response.statusCode != 200) {
      throw RateProviderFailure('HTTP ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['result'] != 'success') {
      throw RateProviderFailure('Provider returned ${json['result']}');
    }

    final rawRates = json['rates'] as Map<String, dynamic>;
    return ExchangeRates(
      base: json['base_code'] as String,
      rates: rawRates.map((code, v) => MapEntry(code, (v as num).toDouble())),
      fetchedAt: DateTime.now(),
    );
  }
}
