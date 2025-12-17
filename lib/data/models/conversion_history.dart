import 'package:hive/hive.dart';

part 'conversion_history.g.dart';

@HiveType(typeId: 0)
class ConversionHistory extends HiveObject {
  @HiveField(0)
  final String type; // 'currency' or 'temperature'

  @HiveField(1)
  final double inputValue;

  @HiveField(2)
  final String fromUnit;

  @HiveField(3)
  final String toUnit;

  @HiveField(4)
  final double result;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final double? exchangeRate; // Only for currency conversions

  ConversionHistory({
    required this.type,
    required this.inputValue,
    required this.fromUnit,
    required this.toUnit,
    required this.result,
    required this.timestamp,
    this.exchangeRate,
  });

  // From JSON
  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      type: json['type'] as String,
      inputValue: (json['inputValue'] as num).toDouble(),
      fromUnit: json['fromUnit'] as String,
      toUnit: json['toUnit'] as String,
      result: (json['result'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      exchangeRate: json['exchangeRate'] != null
          ? (json['exchangeRate'] as num).toDouble()
          : null,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'inputValue': inputValue,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'exchangeRate': exchangeRate,
    };
  }

  /// Create currency conversion history
  factory ConversionHistory.currency({
    required double inputValue,
    required String fromCurrency,
    required String toCurrency,
    required double result,
    required double exchangeRate,
  }) {
    return ConversionHistory(
      type: 'currency',
      inputValue: inputValue,
      fromUnit: fromCurrency,
      toUnit: toCurrency,
      result: result,
      timestamp: DateTime.now(),
      exchangeRate: exchangeRate,
    );
  }

  /// Create temperature conversion history
  factory ConversionHistory.temperature({
    required double inputValue,
    required String fromUnit,
    required String toUnit,
    required double result,
  }) {
    return ConversionHistory(
      type: 'temperature',
      inputValue: inputValue,
      fromUnit: fromUnit,
      toUnit: toUnit,
      result: result,
      timestamp: DateTime.now(),
    );
  }

  /// Get formatted display string
  String get displayString {
    if (type == 'currency') {
      return '$inputValue $fromUnit = $result $toUnit';
    } else {
      return '$inputValue°$fromUnit = $result°$toUnit';
    }
  }

  @override
  String toString() {
    return 'ConversionHistory(type: $type, $inputValue $fromUnit -> $result $toUnit)';
  }
}
