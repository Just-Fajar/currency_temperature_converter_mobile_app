/// API endpoints and configuration
class ApiConstants {
  // Base URLs
  static const String exchangeRateApiBase =
      'https://api.exchangerate-api.com/v4';
  static const String openExchangeRatesBase =
      'https://openexchangerates.org/api';

  // ExchangeRate-API Endpoints (FREE)
  static const String latestRates = '/latest'; // /latest/{base_currency}

  // Example: https://api.exchangerate-api.com/v4/latest/USD
  static String getLatestRates(String baseCurrency) {
    return '$exchangeRateApiBase$latestRates/$baseCurrency';
  }

  // Alternative APIs (for future implementation)
  // 1. Fixer.io: https://fixer.io/
  // 2. CurrencyAPI: https://currencyapi.com/
  // 3. OpenExchangeRates: https://openexchangerates.org/

  // API Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
