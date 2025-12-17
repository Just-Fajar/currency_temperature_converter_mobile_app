import 'entity.dart';

/// Domain entity representing a conversion operation.
///
/// This represents the core business concept of converting
/// one value to another (currency or temperature).
class Conversion extends Entity {
  /// Type of conversion ('currency' or 'temperature')
  final String type;

  /// Input value
  final double inputValue;

  /// Input unit/currency
  final String fromUnit;

  /// Output unit/currency
  final String toUnit;

  /// Result value
  final double result;

  /// Exchange rate (for currency conversions)
  final double? exchangeRate;

  /// Timestamp of conversion
  final DateTime timestamp;

  const Conversion({
    required String id,
    required this.type,
    required this.inputValue,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
    this.exchangeRate,
    required this.timestamp,
  }) : super(id);

  /// Create a currency conversion
  factory Conversion.currency({
    required String id,
    required double inputValue,
    required String fromCurrency,
    required String toCurrency,
    required double result,
    required double exchangeRate,
  }) {
    return Conversion(
      id: id,
      type: 'currency',
      inputValue: inputValue,
      fromUnit: fromCurrency,
      toUnit: toCurrency,
      result: result,
      exchangeRate: exchangeRate,
      timestamp: DateTime.now(),
    );
  }

  /// Create a temperature conversion
  factory Conversion.temperature({
    required String id,
    required double inputValue,
    required String fromUnit,
    required String toUnit,
    required double result,
  }) {
    return Conversion(
      id: id,
      type: 'temperature',
      inputValue: inputValue,
      fromUnit: fromUnit,
      toUnit: toUnit,
      result: result,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Conversion($inputValue $fromUnit = $result $toUnit)';
  }
}
