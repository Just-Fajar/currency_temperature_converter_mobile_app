/// API configuration constants for the application
///
/// This file centralizes all API-related configuration including:
/// - Base URLs for different environments
/// - API endpoints
/// - Timeout durations
/// - Retry configurations
///
/// Example:
/// ```dart
/// final apiService = ApiService(
///   baseUrl: ApiConfig.baseUrl,
///   timeout: ApiConfig.defaultTimeout,
/// );
/// ```
class ApiConfig {
  // Private constructor to prevent instantiation
  ApiConfig._();

  // ============================================================================
  // Base URLs
  // ============================================================================

  /// Base URL for Exchange Rate API
  ///
  /// Uses v6 of the ExchangeRate-API with app_id authentication
  static const String exchangeRateBaseUrl =
      'https://v6.exchangerate-api.com/v6';

  /// App ID for Exchange Rate API
  ///
  /// Note: In production, this should be moved to environment variables
  /// using flutter_dotenv for security
  static const String exchangeRateAppId = 'YOUR_APP_ID_HERE';

  /// Complete base URL with app ID
  static String get exchangeRateApiUrl =>
      '$exchangeRateBaseUrl/$exchangeRateAppId';

  // ============================================================================
  // API Endpoints
  // ============================================================================

  /// Endpoint untuk mendapatkan latest exchange rates
  ///
  /// Format: /latest/{base_currency}
  /// Example: /latest/USD
  static String latestRatesEndpoint(String baseCurrency) =>
      '/latest/$baseCurrency';

  /// Endpoint untuk pair conversion
  ///
  /// Format: /pair/{from}/{to}
  /// Example: /pair/USD/EUR
  static String pairConversionEndpoint(String from, String to) =>
      '/pair/$from/$to';

  /// Endpoint untuk historical rates (if available)
  ///
  /// Format: /history/{base_currency}/{year}/{month}/{day}
  static String historicalRatesEndpoint(String baseCurrency, DateTime date) {
    return '/history/$baseCurrency/${date.year}/${date.month}/${date.day}';
  }

  // ============================================================================
  // Timeout Configurations
  // ============================================================================

  /// Default connection timeout
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Timeout for receive data
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Timeout for send data
  static const Duration sendTimeout = Duration(seconds: 30);

  // ============================================================================
  // Retry Configurations
  // ============================================================================

  /// Maximum number of retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Delay between retry attempts
  static const Duration retryDelay = Duration(seconds: 2);

  /// Exponential backoff multiplier for retry delays
  static const double retryBackoffMultiplier = 2.0;

  // ============================================================================
  // Cache Configurations
  // ============================================================================

  /// Default cache validity duration for exchange rates
  static const Duration cacheValidityDuration = Duration(hours: 1);

  /// Maximum age of cache before forcing refresh
  static const Duration maxCacheAge = Duration(hours: 24);

  // ============================================================================
  // HTTP Headers
  // ============================================================================

  /// Common HTTP headers for API requests
  static Map<String, String> get commonHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers with authorization (if needed)
  static Map<String, String> authorizedHeaders(String token) => {
    ...commonHeaders,
    'Authorization': 'Bearer $token',
  };

  // ============================================================================
  // Currency Codes
  // ============================================================================

  /// List of supported currency codes
  ///
  /// This whitelist ensures only valid currencies are used
  static const List<String> supportedCurrencies = [
    'USD', // US Dollar
    'EUR', // Euro
    'GBP', // British Pound
    'JPY', // Japanese Yen
    'IDR', // Indonesian Rupiah
    'AUD', // Australian Dollar
    'CAD', // Canadian Dollar
    'CHF', // Swiss Franc
    'CNY', // Chinese Yuan
    'INR', // Indian Rupee
    'SGD', // Singapore Dollar
    'MYR', // Malaysian Ringgit
    'THB', // Thai Baht
    'KRW', // South Korean Won
    'HKD', // Hong Kong Dollar
  ];

  /// Default base currency
  static const String defaultBaseCurrency = 'USD';

  // ============================================================================
  // Error Messages
  // ============================================================================

  /// Generic network error message
  static const String networkErrorMessage =
      'Unable to connect to server. Please check your internet connection.';

  /// Timeout error message
  static const String timeoutErrorMessage =
      'Request timeout. Please try again.';

  /// Server error message
  static const String serverErrorMessage =
      'Server error occurred. Please try again later.';

  /// Invalid currency error message
  static const String invalidCurrencyMessage =
      'Invalid currency code. Please select a valid currency.';

  // ============================================================================
  // Validation
  // ============================================================================

  /// Validate if currency code is supported
  static bool isSupportedCurrency(String code) {
    return supportedCurrencies.contains(code.toUpperCase());
  }

  /// Validate currency pair
  static bool isValidCurrencyPair(String from, String to) {
    return isSupportedCurrency(from) && isSupportedCurrency(to);
  }

  // ============================================================================
  // Environment-specific configurations
  // ============================================================================

  /// Check if running in development mode
  static bool get isDevelopment {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// API base URL based on environment
  ///
  /// In production, this could be configured via environment variables
  static String get baseUrl {
    if (isDevelopment) {
      return exchangeRateApiUrl; // Development
    } else {
      return exchangeRateApiUrl; // Production
    }
  }
}
