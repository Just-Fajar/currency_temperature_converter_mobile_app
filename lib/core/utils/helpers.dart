import 'package:intl/intl.dart';

/// Helper utilities for the application
class Helpers {
  /// Format number with decimal places
  static String formatNumber(double number, int decimalPlaces) {
    return number.toStringAsFixed(decimalPlaces);
  }

  /// Format currency with proper symbols and decimals
  static String formatCurrency(
    double amount,
    String currencyCode,
    int decimalPlaces,
  ) {
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalPlaces,
    );
    return formatter.format(amount).trim();
  }

  /// Format large numbers with K, M, B suffixes
  static String formatCompactNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    }
    return number.toStringAsFixed(2);
  }

  /// Format date time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  /// Format date only
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  /// Format time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Convert Celsius to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Convert Celsius to Kelvin
  static double celsiusToKelvin(double celsius) {
    return celsius + 273.15;
  }

  /// Convert Fahrenheit to Celsius
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }

  /// Convert Fahrenheit to Kelvin
  static double fahrenheitToKelvin(double fahrenheit) {
    return celsiusToKelvin(fahrenheitToCelsius(fahrenheit));
  }

  /// Convert Kelvin to Celsius
  static double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  /// Convert Kelvin to Fahrenheit
  static double kelvinToFahrenheit(double kelvin) {
    return celsiusToFahrenheit(kelvinToCelsius(kelvin));
  }

  /// Convert temperature between units
  static double convertTemperature(
    double value,
    String fromUnit,
    String toUnit,
  ) {
    if (fromUnit == toUnit) return value;

    // Convert to Celsius first
    double celsius;
    switch (fromUnit) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = fahrenheitToCelsius(value);
        break;
      case 'Kelvin':
        celsius = kelvinToCelsius(value);
        break;
      default:
        celsius = value;
    }

    // Convert from Celsius to target unit
    switch (toUnit) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return celsiusToFahrenheit(celsius);
      case 'Kelvin':
        return celsiusToKelvin(celsius);
      default:
        return celsius;
    }
  }

  /// Truncate string with ellipsis
  static String truncateString(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
