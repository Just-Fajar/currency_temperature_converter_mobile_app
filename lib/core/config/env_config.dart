// NOTE: flutter_dotenv is currently disabled for demo purposes
// To enable: Add flutter_dotenv to pubspec.yaml and create .env file
// import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration manager
///
/// Manages environment-specific configurations and sensitive data
/// using flutter_dotenv for secure key management.
///
/// NOTE: Currently using hardcoded values for demo. To enable .env files:
/// 1. Add flutter_dotenv to pubspec.yaml
/// 2. Create .env file in project root
/// 3. Add .env to .gitignore
/// 4. Uncomment flutter_dotenv import
/// 5. Load in main.dart: await dotenv.load(fileName: ".env")
///
/// Example .env file:
/// ```
/// EXCHANGE_RATE_API_KEY=your_key_here
/// ENVIRONMENT=development
/// ```
class EnvConfig {
  // Stub implementation - replace with actual .env values when enabled
  static const _config = {
    'ENVIRONMENT': 'development',
    'EXCHANGE_RATE_API_KEY': '',
    'EXCHANGE_RATE_API_URL': 'https://api.exchangerate-api.com/v4',
    'WEATHER_API_KEY': '',
    'WEATHER_API_URL': 'https://api.openweathermap.org/data/2.5',
    'GOOGLE_MAPS_API_KEY': '',
    'SENTRY_DSN': '',
  };

  /// Check if environment is loaded
  static bool get isLoaded => true; // Stub: Always true with hardcoded config

  /// Get current environment (development, staging, production)
  static String get environment => _config['ENVIRONMENT'] ?? 'development';

  /// Check if running in development
  static bool get isDevelopment => environment == 'development';

  /// Check if running in production
  static bool get isProduction => environment == 'production';

  /// Check if running in staging
  static bool get isStaging => environment == 'staging';

  // ==================== API Configuration ====================

  /// Get Exchange Rate API key
  static String get exchangeRateApiKey {
    if (!isLoaded) {
      throw StateError('Environment not loaded.');
    }
    return _config['EXCHANGE_RATE_API_KEY'] ?? '';
  }

  /// Get Exchange Rate base URL
  static String get exchangeRateBaseUrl {
    return _config['EXCHANGE_RATE_API_URL'] ??
        'https://v6.exchangerate-api.com/v6';
  }

  /// Check if API key is configured
  static bool get hasApiKey => exchangeRateApiKey.isNotEmpty;

  // ==================== Firebase Configuration (Optional) ====================

  /// Get Firebase API key
  static String? get firebaseApiKey {
    return _config['FIREBASE_API_KEY'];
  }

  /// Get Firebase project ID
  static String? get firebaseProjectId {
    return _config['FIREBASE_PROJECT_ID'];
  }

  /// Check if Firebase is configured
  static bool get hasFirebaseConfig {
    return firebaseApiKey != null && firebaseProjectId != null;
  }

  // ==================== Analytics Configuration (Optional) ====================

  /// Get Analytics ID
  static String? get analyticsId {
    return _config['ANALYTICS_ID'];
  }

  /// Check if Analytics is enabled
  static bool get hasAnalytics => analyticsId != null;

  // ==================== Helper Methods ====================

  /// Get environment variable with fallback
  static String getString(String key, {String fallback = ''}) {
    return _config[key] ?? fallback;
  }

  /// Get optional environment variable
  static String? getStringOrNull(String key) {
    return _config[key];
  }

  /// Get boolean environment variable
  static bool getBool(String key, {bool fallback = false}) {
    final value = _config[key];
    if (value == null) return fallback;
    return value.toLowerCase() == 'true' || value == '1';
  }

  /// Get integer environment variable
  static int getInt(String key, {int fallback = 0}) {
    final value = _config[key];
    if (value == null) return fallback;
    return int.tryParse(value) ?? fallback;
  }

  /// Print current configuration (for debugging only)
  /// DO NOT use in production or commit logs
  static void printConfig() {
    if (!isDevelopment) {
      // Removed print for production safety
      return;
    }

    // Removed print statements - use AppLogger instead
    // print('=== Environment Configuration ===');
    // print('Environment: $environment');
    // print('API Key configured: $hasApiKey');
    // print('Firebase configured: $hasFirebaseConfig');
    // print('Analytics enabled: $hasAnalytics');
    // print('================================');
  }

  /// Validate required environment variables
  ///
  /// Throws [StateError] if required variables are missing
  static void validate() {
    final missingVars = <String>[];

    // Check required variables
    if (!hasApiKey && isProduction) {
      missingVars.add('EXCHANGE_RATE_API_KEY');
    }

    if (missingVars.isNotEmpty) {
      throw StateError(
        'Missing required environment variables: ${missingVars.join(", ")}\n'
        'Please check your .env file.',
      );
    }
  }
}
