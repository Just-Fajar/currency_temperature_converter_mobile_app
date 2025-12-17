/// Sealed class representing all possible states of temperature conversion.
///
/// Provides type-safe state management for temperature operations.
///
/// Example:
/// ```dart
/// switch (state) {
///   case TemperatureInitial():
///     return Text('Enter temperature');
///   case TemperatureConverted():
///     return Text('${state.celsius}°C = ${state.fahrenheit}°F');
/// }
/// ```
sealed class TemperatureState {
  const TemperatureState();
}

/// Initial state - no conversion performed
class TemperatureInitial extends TemperatureState {
  const TemperatureInitial();
}

/// Converted state - conversion completed
class TemperatureConverted extends TemperatureState {
  final double inputValue;
  final String inputUnit;
  final double celsius;
  final double fahrenheit;
  final double kelvin;
  final DateTime timestamp;

  const TemperatureConverted({
    required this.inputValue,
    required this.inputUnit,
    required this.celsius,
    required this.fahrenheit,
    required this.kelvin,
    required this.timestamp,
  });

  /// Get value for specific unit
  double getValueFor(String unit) {
    switch (unit) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return fahrenheit;
      case 'Kelvin':
        return kelvin;
      default:
        return celsius;
    }
  }

  @override
  String toString() =>
      'TemperatureConverted(input: $inputValue $inputUnit, C: $celsius, F: $fahrenheit, K: $kelvin)';
}

/// Error state - conversion failed (e.g., invalid temperature)
class TemperatureError extends TemperatureState {
  final String message;

  const TemperatureError({required this.message});

  @override
  String toString() => 'TemperatureError(message: $message)';
}
