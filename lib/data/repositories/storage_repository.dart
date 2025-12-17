import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/conversion_history.dart';
import '../models/paginated_history.dart';

/// Repository for managing local storage operations.
///
/// This repository handles:
/// - Conversion history storage (using Hive)
/// - User preferences storage (using SharedPreferences)
/// - Last used currencies and settings
///
/// Uses Hive for structured data (conversion history) and
/// SharedPreferences for simple key-value pairs (settings).
///
/// Example:
/// ```dart
/// final storage = StorageRepository();
/// await storage.init();
/// await storage.saveConversion(history);
/// final lastCurrency = await storage.getLastCurrencyFrom();
/// ```
class StorageRepository {
  static const String _historyBoxName = 'conversion_history';
  Box<ConversionHistory>? _historyBox;
  SharedPreferences? _prefs;

  /// Initialize storage
  Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ConversionHistoryAdapter());
    }

    // Open boxes
    _historyBox = await Hive.openBox<ConversionHistory>(_historyBoxName);

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ensure storage is initialized
  Future<void> _ensureInitialized() async {
    if (_historyBox == null || _prefs == null) {
      await init();
    }
  }

  // ==================== Conversion History ====================

  /// Save conversion to history
  Future<void> saveConversion(ConversionHistory conversion) async {
    await _ensureInitialized();
    await _historyBox!.add(conversion);

    // Keep only last N items
    if (_historyBox!.length > AppConstants.maxHistoryItems) {
      final keysToDelete = _historyBox!.keys
          .take(_historyBox!.length - AppConstants.maxHistoryItems)
          .toList();

      await _historyBox!.deleteAll(keysToDelete);
    }
  }

  /// Get all conversion history
  Future<List<ConversionHistory>> getHistory() async {
    await _ensureInitialized();
    return _historyBox!.values.toList().reversed.toList();
  }

  /// Get paginated history with lazy loading support
  ///
  /// Parameters:
  /// - [page]: Page number (0-indexed)
  /// - [pageSize]: Number of items per page (default: 20)
  /// - [type]: Optional filter by type (currency/temperature)
  ///
  /// Returns [PaginatedHistory] with items and pagination info
  Future<PaginatedHistory> getPaginatedHistory({
    int page = 0,
    int pageSize = 20,
    String? type,
  }) async {
    await _ensureInitialized();

    // Get all items or filtered by type
    List<ConversionHistory> allItems;
    if (type != null) {
      allItems = _historyBox!.values
          .where((h) => h.type == type)
          .toList()
          .reversed
          .toList();
    } else {
      allItems = _historyBox!.values.toList().reversed.toList();
    }

    final totalCount = allItems.length;
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalCount);

    // Get items for current page
    final items = startIndex < totalCount
        ? allItems.sublist(startIndex, endIndex)
        : <ConversionHistory>[];

    return PaginatedHistory(
      items: items,
      totalCount: totalCount,
      currentPage: page,
      pageSize: pageSize,
      hasNextPage: endIndex < totalCount,
      hasPreviousPage: page > 0,
    );
  }

  /// Get history by type (currency or temperature)
  Future<List<ConversionHistory>> getHistoryByType(String type) async {
    await _ensureInitialized();
    return _historyBox!.values
        .where((h) => h.type == type)
        .toList()
        .reversed
        .toList();
  }

  /// Delete a conversion from history
  Future<void> deleteConversion(int index) async {
    await _ensureInitialized();
    final key = _historyBox!.keys.elementAt(index);
    await _historyBox!.delete(key);
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await _ensureInitialized();
    await _historyBox!.clear();
  }

  // ==================== Preferences ====================

  /// Get theme mode
  Future<String> getThemeMode() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyThemeMode) ?? 'system';
  }

  /// Set theme mode
  Future<void> setThemeMode(String mode) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyThemeMode, mode);
  }

  /// Get default currency
  Future<String> getDefaultCurrency() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyDefaultCurrency) ??
        AppConstants.defaultCurrency;
  }

  /// Set default currency
  Future<void> setDefaultCurrency(String currency) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyDefaultCurrency, currency);
  }

  /// Get decimal places
  Future<int> getDecimalPlaces() async {
    await _ensureInitialized();
    return _prefs!.getInt(AppConstants.keyDecimalPlaces) ??
        AppConstants.defaultDecimalPlaces;
  }

  /// Set decimal places
  Future<void> setDecimalPlaces(int places) async {
    await _ensureInitialized();
    await _prefs!.setInt(AppConstants.keyDecimalPlaces, places);
  }

  /// Get haptic feedback enabled
  Future<bool> getHapticEnabled() async {
    await _ensureInitialized();
    return _prefs!.getBool(AppConstants.keyHapticEnabled) ?? true;
  }

  /// Set haptic feedback enabled
  Future<void> setHapticEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(AppConstants.keyHapticEnabled, enabled);
  }

  /// Get GPS enabled
  Future<bool> getGpsEnabled() async {
    await _ensureInitialized();
    return _prefs!.getBool(AppConstants.keyGpsEnabled) ?? true;
  }

  /// Set GPS enabled
  Future<void> setGpsEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(AppConstants.keyGpsEnabled, enabled);
  }

  /// Get auto update rates
  Future<bool> getAutoUpdateRates() async {
    await _ensureInitialized();
    return _prefs!.getBool(AppConstants.keyAutoUpdateRates) ?? true;
  }

  /// Set auto update rates
  Future<void> setAutoUpdateRates(bool enabled) async {
    await _ensureInitialized();
    await _prefs!.setBool(AppConstants.keyAutoUpdateRates, enabled);
  }

  /// Get last currency from
  Future<String> getLastCurrencyFrom() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyLastCurrencyFrom) ?? 'USD';
  }

  /// Set last currency from
  Future<void> setLastCurrencyFrom(String currency) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyLastCurrencyFrom, currency);
  }

  /// Get last currency to
  Future<String> getLastCurrencyTo() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.keyLastCurrencyTo) ?? 'EUR';
  }

  /// Set last currency to
  Future<void> setLastCurrencyTo(String currency) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.keyLastCurrencyTo, currency);
  }

  /// Clear all preferences
  Future<void> clearPreferences() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  /// Close storage
  Future<void> close() async {
    await _historyBox?.close();
  }
}
