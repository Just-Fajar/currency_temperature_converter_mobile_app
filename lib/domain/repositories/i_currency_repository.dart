import '../core/result.dart';
import '../entities/exchange_rates.dart';

/// Repository interface for currency operations.
///
/// This is a contract that defines what operations are available
/// for currency data. Implementations in the data layer will
/// provide the actual logic.
abstract class ICurrencyRepository {
  /// Get exchange rates for a specific currency pair
  ///
  /// [from] Source currency code
  /// [to] Target currency code
  ///
  /// Returns [Result] with exchange rate or failure
  Future<Result<ExchangeRates>> getExchangeRates({
    required String from,
    required String to,
  });

  /// Convert an amount between currencies
  ///
  /// [amount] Amount to convert
  /// [from] Source currency code
  /// [to] Target currency code
  ///
  /// Returns [Result] with converted amount or failure
  Future<Result<double>> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });

  /// Check if exchange rates are cached
  ///
  /// [from] Source currency code
  /// [to] Target currency code
  ///
  /// Returns true if valid cached rates exist
  Future<bool> hasCachedRates({required String from, required String to});

  /// Clear all cached exchange rates
  Future<void> clearCache();
}
