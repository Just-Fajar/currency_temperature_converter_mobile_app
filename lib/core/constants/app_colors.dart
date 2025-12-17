import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  // Primary Colors
  static const Color primaryTeal = Color(0xFF009688);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryDeep = Color(0xFF00796B);

  // Accent Colors
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentYellow = Color(0xFFFFC107);

  // Temperature Colors
  static const Color coldBlue = Color(0xFF2196F3);
  static const Color coolCyan = Color(0xFF00BCD4);
  static const Color normalGreen = Color(0xFF4CAF50);
  static const Color warmOrange = Color(0xFFFF9800);
  static const Color hotRed = Color(0xFFF44336);

  // Neutral Colors
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF424242);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  // Currency Category Colors
  static const Color currencyGreen = Color(0xFF4CAF50);
  static const Color currencyBlue = Color(0xFF2196F3);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient temperatureGradient = LinearGradient(
    colors: [coldBlue, hotRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Get temperature color based on celsius value
  static Color getTemperatureColor(double celsius) {
    if (celsius < 0) return coldBlue;
    if (celsius < 15) return coolCyan;
    if (celsius < 25) return normalGreen;
    if (celsius < 35) return warmOrange;
    return hotRed;
  }
}
