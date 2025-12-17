/// Input validation utilities
class Validators {
  /// Validate if string is a valid number
  static bool isValidNumber(String? value) {
    if (value == null || value.isEmpty) return false;
    final number = double.tryParse(value);
    return number != null;
  }

  /// Validate if string is a valid positive number
  static bool isValidPositiveNumber(String? value) {
    if (!isValidNumber(value)) return false;
    final number = double.parse(value!);
    return number >= 0;
  }

  /// Validate temperature value (Kelvin cannot be negative)
  static bool isValidTemperature(String? value, String unit) {
    if (!isValidNumber(value)) return false;
    final temp = double.parse(value!);

    // Kelvin cannot be negative
    if (unit == 'Kelvin' && temp < 0) {
      return false;
    }

    // Celsius cannot be below absolute zero (-273.15°C)
    if (unit == 'Celsius' && temp < -273.15) {
      return false;
    }

    // Fahrenheit cannot be below absolute zero (-459.67°F)
    if (unit == 'Fahrenheit' && temp < -459.67) {
      return false;
    }

    return true;
  }

  /// Validate currency amount (must be positive and reasonable)
  static bool isValidCurrencyAmount(String? value) {
    if (!isValidPositiveNumber(value)) return false;
    final amount = double.parse(value!);

    // Maximum reasonable amount (1 trillion)
    if (amount > 1000000000000) {
      return false;
    }

    return true;
  }

  /// Get validation error message
  static String? getNumberValidationError(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (!isValidNumber(value)) {
      return 'Please enter a valid number';
    }
    return null;
  }

  /// Get temperature validation error message
  static String? getTemperatureValidationError(String? value, String unit) {
    if (value == null || value.isEmpty) {
      return 'Please enter a temperature';
    }
    if (!isValidNumber(value)) {
      return 'Please enter a valid number';
    }
    if (!isValidTemperature(value, unit)) {
      if (unit == 'Kelvin') {
        return 'Kelvin cannot be negative';
      }
      return 'Temperature is below absolute zero';
    }
    return null;
  }

  /// Get currency validation error message
  static String? getCurrencyValidationError(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    if (!isValidNumber(value)) {
      return 'Please enter a valid number';
    }
    if (!isValidCurrencyAmount(value)) {
      final amount = double.parse(value);
      if (amount < 0) {
        return 'Amount cannot be negative';
      }
      return 'Amount is too large';
    }
    return null;
  }
}
