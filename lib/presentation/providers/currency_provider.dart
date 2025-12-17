import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/conversion_history.dart';
import '../../data/models/currency_model.dart';
import '../../data/repositories/currency_repository.dart';
import '../../data/repositories/storage_repository.dart';

/// Provider for managing currency conversion state and operations.
///
/// This provider handles:
/// - Currency selection (from/to)
/// - Real-time conversion with debouncing
/// - Offline mode with cached rates
/// - Conversion history management
/// - Haptic feedback on successful conversions
///
/// Example:
/// ```dart
/// final provider = Provider.of<CurrencyProvider>(context);
/// provider.setAmount(100.0);
/// await provider.convert();
/// print('Result: ${provider.result}');
/// ```
class CurrencyProvider with ChangeNotifier {
  /// Repository for fetching exchange rates from API
  final CurrencyRepository _currencyRepo = CurrencyRepository();

  /// Repository for local storage operations
  final StorageRepository _storage = StorageRepository();

  // State variables
  String _fromCurrency = AppConstants.defaultCurrency;
  String _toCurrency = 'EUR';
  double _amount = 0.0;
  double _result = 0.0;
  double? _exchangeRate;
  bool _isLoading = false;
  String? _error;
  ExchangeRatesModel? _cachedRates;
  DateTime? _lastUpdate;
  Timer? _debounceTimer;
  bool _isOfflineMode = false;

  // Getters

  /// Current source currency code (e.g., 'USD')
  String get fromCurrency => _fromCurrency;

  /// Current target currency code (e.g., 'EUR')
  String get toCurrency => _toCurrency;

  /// Amount to convert
  double get amount => _amount;

  /// Conversion result
  double get result => _result;

  /// Exchange rate used for conversion
  double? get exchangeRate => _exchangeRate;

  /// Whether conversion is in progress
  bool get isLoading => _isLoading;

  /// Error message if conversion failed
  String? get error => _error;

  /// Timestamp of last successful rate update
  DateTime? get lastUpdate => _lastUpdate;

  /// Whether currently using offline/cached rates
  bool get isOfflineMode => _isOfflineMode;

  /// List of available currency codes
  List<String> get availableCurrencies => AppConstants.currencyCodes;

  CurrencyProvider() {
    // Initialize storage first, then load preferences
    _initProvider();
  }

  Future<void> _initProvider() async {
    try {
      await _storage.init();
      await _loadLastUsedCurrencies();
    } catch (e) {
      debugPrint('Provider init failed: $e');
    }
  }

  /// Load last used currencies from storage without blocking initialization.
  ///
  /// This method runs asynchronously to avoid blocking the provider creation.
  /// If loading fails, it falls back to default currencies (USD/EUR).
  Future<void> _loadLastUsedCurrencies() async {
    try {
      _fromCurrency = await _storage.getLastCurrencyFrom();
      _toCurrency = await _storage.getLastCurrencyTo();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load currencies from storage: $e');
      _fromCurrency = AppConstants.defaultCurrency;
      _toCurrency = 'EUR';
    }
  }

  /// Set the source currency and trigger conversion if amount > 0.
  ///
  /// [currency] The currency code to set (e.g., 'USD')
  ///
  /// This method:
  /// 1. Updates the UI immediately
  /// 2. Saves the selection to storage in background
  /// 3. Triggers conversion if amount is set
  Future<void> setFromCurrency(String currency) async {
    _fromCurrency = currency;
    notifyListeners();

    _storage.setLastCurrencyFrom(currency).catchError((e) {
      debugPrint('Failed to save currency: $e');
    });

    if (_amount > 0) {
      await convert();
    }
  }

  /// Set the target currency and trigger conversion if amount > 0.
  ///
  /// [currency] The currency code to set (e.g., 'EUR')
  ///
  /// This method:
  /// 1. Updates the UI immediately
  /// 2. Saves the selection to storage in background
  /// 3. Triggers conversion if amount is set
  Future<void> setToCurrency(String currency) async {
    _toCurrency = currency;
    notifyListeners();

    _storage.setLastCurrencyTo(currency).catchError((e) {
      debugPrint('Failed to save currency: $e');
    });

    if (_amount > 0) {
      await convert();
    }
  }

  /// Set amount with debouncing to reduce API calls.
  ///
  /// [value] The amount to convert
  ///
  /// Debouncing delays the API call by [AppConstants.debounceDelay]
  /// to avoid excessive API requests while user is typing.
  void setAmount(double value) {
    _amount = value;
    _debounceTimer?.cancel();

    if (value > 0) {
      _debounceTimer = Timer(AppConstants.debounceDelay, convert);
    } else {
      _result = 0.0;
      _exchangeRate = null;
      notifyListeners();
    }
  }

  /// Swap source and target currencies.
  ///
  /// This method:
  /// 1. Swaps the currency codes
  /// 2. Saves the new selection
  /// 3. Triggers conversion if amount is set
  /// 4. Provides haptic feedback
  Future<void> swapCurrencies() async {
    final temp = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = temp;

    await _storage.setLastCurrencyFrom(_fromCurrency);
    await _storage.setLastCurrencyTo(_toCurrency);

    if (_amount > 0) {
      await convert();
    }

    await _triggerHaptic();
    notifyListeners();
  }

  /// Convert currency with offline support and caching.
  ///
  /// This method:
  /// 1. Checks for valid cached rates (within [AppConstants.cacheValidityDuration])
  /// 2. Fetches new rates if cache is stale or unavailable
  /// 3. Falls back to offline mode if network fails but cache exists
  /// 4. Saves successful conversions to history
  /// 5. Provides haptic feedback on success
  ///
  /// Throws user-friendly error messages on failure.
  Future<void> convert() async {
    if (_amount <= 0) {
      _result = 0.0;
      _exchangeRate = null;
      notifyListeners();
      return;
    }

    // Same currency = no conversion needed
    if (_fromCurrency == _toCurrency) {
      _result = _amount;
      _exchangeRate = 1.0;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check cache validity to avoid unnecessary API calls
      if (_shouldUseCachedRates()) {
        _applyConversion();
        _isOfflineMode = false;
      } else {
        await _fetchAndConvert();
      }

      if (_exchangeRate != null) {
        await _saveToHistory();
        await _triggerHaptic();
      }
    } catch (e) {
      _handleConversionError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if cached rates are valid and can be used.
  bool _shouldUseCachedRates() {
    return _cachedRates != null &&
        _cachedRates!.base == _fromCurrency &&
        _lastUpdate != null &&
        DateTime.now().difference(_lastUpdate!) <
            AppConstants.cacheValidityDuration;
  }

  /// Apply conversion using cached rates.
  void _applyConversion() {
    _result = _cachedRates!.convert(_amount, _fromCurrency, _toCurrency);
    _exchangeRate = _cachedRates!.rates[_toCurrency];
  }

  /// Fetch new rates from API and perform conversion.
  Future<void> _fetchAndConvert() async {
    try {
      _cachedRates = await _currencyRepo.getExchangeRates(_fromCurrency);
      _lastUpdate = DateTime.now();
      _applyConversion();
      _isOfflineMode = false;
    } catch (networkError) {
      _handleNetworkError();
    }
  }

  /// Handle network errors by falling back to offline mode if possible.
  void _handleNetworkError() {
    if (_cachedRates != null && _cachedRates!.base == _fromCurrency) {
      _applyConversion();
      _isOfflineMode = true;
      _error = 'Using offline rates (last updated: ${_formatLastUpdate()})';
    } else {
      // Create fallback mock rates for demo purposes (CORS issue on web)
      _createFallbackRates();
      if (_cachedRates != null) {
        _applyConversion();
        _isOfflineMode = true;
        _error = '📡 Demo mode - Using sample exchange rates';
      } else {
        _error = 'Network error and no cached rates available';
      }
    }
    notifyListeners();
  }

  /// Create fallback exchange rates for demo when API is blocked
  void _createFallbackRates() {
    // Mock exchange rates data for common currencies
    final Map<String, double> mockRates = {
      'USD': 1.0,
      'EUR': 0.85,
      'GBP': 0.73,
      'JPY': 110.0,
      'CHF': 0.92,
      'CAD': 1.25,
      'AUD': 1.35,
      'NZD': 1.45,
      'CNY': 6.45,
      'INR': 74.5,
      'IDR': 14200.0,
      'KRW': 1180.0,
      'SGD': 1.35,
      'HKD': 7.75,
      'MYR': 4.15,
      'THB': 33.0,
      'PHP': 50.0,
      'VND': 23000.0,
    };

    // Convert to base currency if needed
    if (_fromCurrency != 'USD') {
      final baseRate = mockRates[_fromCurrency] ?? 1.0;
      final Map<String, double> convertedRates = {};
      mockRates.forEach((currency, rate) {
        convertedRates[currency] = rate / baseRate;
      });

      _cachedRates = ExchangeRatesModel(
        base: _fromCurrency,
        date: DateTime.now(),
        rates: convertedRates,
      );
    } else {
      _cachedRates = ExchangeRatesModel(
        base: 'USD',
        date: DateTime.now(),
        rates: mockRates,
      );
    }
    _lastUpdate = DateTime.now();
  }

  /// Handle conversion errors with user-friendly messages.
  void _handleConversionError(dynamic e) {
    _error = _getFriendlyErrorMessage(e);
    _result = 0.0;
    _exchangeRate = null;
    _isOfflineMode = false;
  }

  /// Convert error to user-friendly message.
  ///
  /// Maps technical error messages to human-readable format.
  String _getFriendlyErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('socket') || errorStr.contains('network')) {
      return 'No internet connection. Please check your network.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (errorStr.contains('404') || errorStr.contains('not found')) {
      return 'Currency not found. Please try different currencies.';
    } else if (errorStr.contains('429') || errorStr.contains('rate limit')) {
      return 'Too many requests. Please wait a moment.';
    } else {
      return 'Failed to convert. Please try again later.';
    }
  }

  /// Format last update time to human-readable string.
  ///
  /// Returns relative time like '2h ago', '15m ago', or 'just now'.
  String _formatLastUpdate() {
    if (_lastUpdate == null) return 'unknown';

    final diff = DateTime.now().difference(_lastUpdate!);
    if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  /// Force refresh exchange rates by clearing cache.
  ///
  /// This will fetch fresh rates from the API on next conversion.
  Future<void> refreshRates() async {
    _cachedRates = null;
    _lastUpdate = null;
    if (_amount > 0) {
      await convert();
    }
  }

  /// Save successful conversion to history.
  ///
  /// Only saves if exchange rate is available.
  Future<void> _saveToHistory() async {
    if (_exchangeRate == null) return;

    final history = ConversionHistory.currency(
      inputValue: _amount,
      fromCurrency: _fromCurrency,
      toCurrency: _toCurrency,
      result: _result,
      exchangeRate: _exchangeRate!,
    );

    await _storage.saveConversion(history);
  }

  /// Trigger haptic feedback if enabled in settings.
  ///
  /// Vibrates device briefly (50ms) to provide tactile feedback.
  Future<void> _triggerHaptic() async {
    final hapticEnabled = await _storage.getHapticEnabled();
    if (hapticEnabled) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50);
      }
    }
  }

  /// Clear current error message.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset all conversion state to initial values.
  void reset() {
    _amount = 0.0;
    _result = 0.0;
    _exchangeRate = null;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _currencyRepo.dispose();
    super.dispose();
  }
}
