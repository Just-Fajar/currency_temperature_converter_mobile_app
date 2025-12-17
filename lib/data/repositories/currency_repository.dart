import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../models/currency_model.dart';

/// Repository for fetching and managing currency exchange rates.
///
/// This repository handles all currency-related API operations including:
/// - Fetching latest exchange rates from external API
/// - Converting amounts between currencies
/// - Getting exchange rates for specific currency pairs
/// - Checking API health status
///
/// Example:
/// ```dart
/// final repo = CurrencyRepository();
/// final rates = await repo.getExchangeRates('USD');
/// final converted = await repo.convertCurrency(
///   amount: 100,
///   from: 'USD',
///   to: 'EUR',
/// );
/// ```
class CurrencyRepository {
  /// HTTP client for making API requests
  final http.Client _client;

  /// Creates a new [CurrencyRepository] instance.
  ///
  /// [client] Optional HTTP client for testing purposes.
  /// If not provided, a default client will be created.
  CurrencyRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch latest exchange rates for a base currency from API.
  ///
  /// [baseCurrency] The base currency code (e.g., 'USD')
  ///
  /// Returns [ExchangeRatesModel] containing all exchange rates.
  /// Throws [Exception] if the API request fails or times out.
  ///
  /// Example:
  /// ```dart
  /// final rates = await repo.getExchangeRates('USD');
  /// print(rates.rates['EUR']); // 0.85
  /// ```
  Future<ExchangeRatesModel> getExchangeRates(String baseCurrency) async {
    try {
      final url = ApiConstants.getLatestRates(baseCurrency);

      final response = await _client
          .get(Uri.parse(url), headers: ApiConstants.defaultHeaders)
          .timeout(Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return ExchangeRatesModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to load exchange rates: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }

  /// Convert amount from one currency to another.
  ///
  /// [amount] The amount to convert
  /// [from] Source currency code (e.g., 'USD')
  /// [to] Target currency code (e.g., 'EUR')
  ///
  /// Returns the converted amount.
  /// Returns original amount if converting same currencies.
  /// Throws [Exception] if conversion fails.
  ///
  /// Example:
  /// ```dart
  /// final result = await repo.convertCurrency(
  ///   amount: 100,
  ///   from: 'USD',
  ///   to: 'EUR',
  /// );
  /// print(result); // 85.0
  /// ```
  Future<double> convertCurrency({
    required double amount,
    required String from,
    required String to,
  }) async {
    try {
      // If same currency, no conversion needed
      if (from == to) return amount;

      // Fetch rates for the base currency
      final rates = await getExchangeRates(from);

      // Convert
      return rates.convert(amount, from, to);
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }

  /// Get exchange rate between two currencies.
  ///
  /// [from] Source currency code
  /// [to] Target currency code
  ///
  /// Returns the exchange rate as a double.
  /// Returns 1.0 if currencies are the same.
  /// Throws [Exception] if currency is not found.
  Future<double> getExchangeRate(String from, String to) async {
    try {
      if (from == to) return 1.0;

      final rates = await getExchangeRates(from);
      final toRate = rates.rates[to];

      if (toRate == null) {
        throw Exception('Currency $to not found');
      }

      return toRate;
    } catch (e) {
      throw Exception('Error getting exchange rate: $e');
    }
  }

  /// Check if API is available and responsive.
  ///
  /// Returns `true` if API is healthy, `false` otherwise.
  /// Useful for checking network connectivity before making requests.
  Future<bool> checkApiHealth() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConstants.getLatestRates('USD')))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources and close HTTP client.
  ///
  /// Should be called when the repository is no longer needed
  /// to free up system resources.
  void dispose() {
    _client.close();
  }
}
