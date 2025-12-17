/// Temperature model for conversions
class TemperatureModel {
  final double value;
  final String unit; // Celsius, Fahrenheit, Kelvin

  TemperatureModel({required this.value, required this.unit});

  // From JSON
  factory TemperatureModel.fromJson(Map<String, dynamic> json) {
    return TemperatureModel(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {'value': value, 'unit': unit};
  }

  // Copy with
  TemperatureModel copyWith({double? value, String? unit}) {
    return TemperatureModel(
      value: value ?? this.value,
      unit: unit ?? this.unit,
    );
  }

  /// Convert to Celsius
  double toCelsius() {
    switch (unit) {
      case 'Celsius':
        return value;
      case 'Fahrenheit':
        return (value - 32) * 5 / 9;
      case 'Kelvin':
        return value - 273.15;
      default:
        return value;
    }
  }

  /// Convert to Fahrenheit
  double toFahrenheit() {
    switch (unit) {
      case 'Celsius':
        return (value * 9 / 5) + 32;
      case 'Fahrenheit':
        return value;
      case 'Kelvin':
        return ((value - 273.15) * 9 / 5) + 32;
      default:
        return value;
    }
  }

  /// Convert to Kelvin
  double toKelvin() {
    switch (unit) {
      case 'Celsius':
        return value + 273.15;
      case 'Fahrenheit':
        return ((value - 32) * 5 / 9) + 273.15;
      case 'Kelvin':
        return value;
      default:
        return value;
    }
  }

  /// Convert to specific unit
  double convertTo(String targetUnit) {
    switch (targetUnit) {
      case 'Celsius':
        return toCelsius();
      case 'Fahrenheit':
        return toFahrenheit();
      case 'Kelvin':
        return toKelvin();
      default:
        return value;
    }
  }

  @override
  String toString() {
    return 'TemperatureModel(value: $value, unit: $unit)';
  }
}
