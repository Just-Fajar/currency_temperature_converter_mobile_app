/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Converter Pro';
  static const String appVersion = '1.0.0';

  // Currency Codes
  static const List<String> currencyCodes = [
    'USD', // US Dollar
    'EUR', // Euro
    'GBP', // British Pound
    'JPY', // Japanese Yen
    'CNY', // Chinese Yuan
    'IDR', // Indonesian Rupiah
    'SGD', // Singapore Dollar
    'AUD', // Australian Dollar
    'CAD', // Canadian Dollar
    'CHF', // Swiss Franc
    'INR', // Indian Rupee
    'MYR', // Malaysian Ringgit
    'THB', // Thai Baht
    'KRW', // South Korean Won
    'HKD', // Hong Kong Dollar
  ];

  // Currency Names
  static const Map<String, String> currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'CNY': 'Chinese Yuan',
    'IDR': 'Indonesian Rupiah',
    'SGD': 'Singapore Dollar',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'INR': 'Indian Rupee',
    'MYR': 'Malaysian Ringgit',
    'THB': 'Thai Baht',
    'KRW': 'South Korean Won',
    'HKD': 'Hong Kong Dollar',
  };

  // Currency Symbols
  static const Map<String, String> currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CNY': '¥',
    'IDR': 'Rp',
    'SGD': 'S\$',
    'AUD': 'A\$',
    'CAD': 'C\$',
    'CHF': 'CHF',
    'INR': '₹',
    'MYR': 'RM',
    'THB': '฿',
    'KRW': '₩',
    'HKD': 'HK\$',
  };

  // Temperature Units
  static const List<String> temperatureUnits = [
    'Celsius',
    'Fahrenheit',
    'Kelvin',
  ];

  // Temperature Unit Symbols
  static const Map<String, String> temperatureSymbols = {
    'Celsius': '°C',
    'Fahrenheit': '°F',
    'Kelvin': 'K',
  };

  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyDefaultCurrency = 'default_currency';
  static const String keyDecimalPlaces = 'decimal_places';
  static const String keyHapticEnabled = 'haptic_enabled';
  static const String keyGpsEnabled = 'gps_enabled';
  static const String keyAutoUpdateRates = 'auto_update_rates';
  static const String keyLastCurrencyFrom = 'last_currency_from';
  static const String keyLastCurrencyTo = 'last_currency_to';

  // Default Values
  static const String defaultCurrency = 'USD';
  static const int defaultDecimalPlaces = 2;
  static const int maxHistoryItems = 100;

  // API Settings
  static const int apiTimeout = 30; // seconds
  static const int maxRetries = 3;

  // UI Constants
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration cacheValidityDuration = Duration(hours: 1);
  static const Duration snackBarDuration = Duration(seconds: 2);
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);

  // Widget Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const int minPasswordLength = 6;
  static const int maxCurrencyAmount = 1000000000000; // 1 trillion

  // Temperature Limits
  static const double absoluteZeroCelsius = -273.15;
  static const double absoluteZeroFahrenheit = -459.67;
  static const double absoluteZeroKelvin = 0.0;
}
