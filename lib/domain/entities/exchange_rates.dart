import 'entity.dart';

/// Domain entity representing currency exchange rates.
///
/// This is a pure domain object without any dependencies on
/// data layer implementations.
class ExchangeRates extends Entity {
  /// Base currency code
  final String baseCurrency;

  /// Target currency code
  final String targetCurrency;

  /// Exchange rate value
  final double rate;

  /// Timestamp when the rate was fetched
  final DateTime timestamp;

  const ExchangeRates({
    required String id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.timestamp,
  }) : super(id);

  /// Check if the rates are still valid (within cache duration)
  bool isValid(Duration validityDuration) {
    return DateTime.now().difference(timestamp) < validityDuration;
  }

  /// Convert an amount using this exchange rate
  double convert(double amount) {
    return amount * rate;
  }

  @override
  String toString() {
    return 'ExchangeRates(base: $baseCurrency, target: $targetCurrency, rate: $rate)';
  }
}
