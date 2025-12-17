import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for app settings and preferences
class SettingsProvider with ChangeNotifier {
  // Keys for SharedPreferences
  static const String _defaultCurrencyKey = 'default_currency';
  static const String _decimalPlacesKey = 'decimal_places';
  static const String _autoUpdateRatesKey = 'auto_update_rates';
  static const String _hapticFeedbackKey = 'haptic_feedback';
  static const String _gpsDetectionKey = 'gps_detection';
  static const String _themeModeKey = 'theme_mode';

  SharedPreferences? _prefs;

  // Settings values
  String _defaultCurrency = 'USD';
  int _decimalPlaces = 2;
  bool _autoUpdateRates = true;
  bool _hapticFeedback = true;
  bool _gpsDetection = true;
  ThemeMode _themeMode = ThemeMode.system;

  // Getters
  String get defaultCurrency => _defaultCurrency;
  int get decimalPlaces => _decimalPlaces;
  bool get autoUpdateRates => _autoUpdateRates;
  bool get hapticFeedback => _hapticFeedback;
  bool get gpsDetection => _gpsDetection;
  ThemeMode get themeMode => _themeMode;

  /// Initialize settings from SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _defaultCurrency = _prefs?.getString(_defaultCurrencyKey) ?? 'USD';
    _decimalPlaces = _prefs?.getInt(_decimalPlacesKey) ?? 2;
    _autoUpdateRates = _prefs?.getBool(_autoUpdateRatesKey) ?? true;
    _hapticFeedback = _prefs?.getBool(_hapticFeedbackKey) ?? true;
    _gpsDetection = _prefs?.getBool(_gpsDetectionKey) ?? true;

    // Load theme mode - handle both int and String values for backward compatibility
    try {
      final themeModeIndex = _prefs?.getInt(_themeModeKey) ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
    } catch (e) {
      // If int fails, try reading as String (legacy format)
      final themeModeString = _prefs?.getString(_themeModeKey);
      if (themeModeString == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (themeModeString == 'light') {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }
      // Save as int for future compatibility
      await _prefs?.setInt(_themeModeKey, _themeMode.index);
    }

    notifyListeners();
  }

  /// Set default currency
  Future<void> setDefaultCurrency(String currency) async {
    _defaultCurrency = currency;
    await _prefs?.setString(_defaultCurrencyKey, currency);
    notifyListeners();
  }

  /// Set decimal places
  Future<void> setDecimalPlaces(int places) async {
    if (places < 2 || places > 6) return;
    _decimalPlaces = places;
    await _prefs?.setInt(_decimalPlacesKey, places);
    notifyListeners();
  }

  /// Toggle auto-update rates
  Future<void> toggleAutoUpdateRates() async {
    _autoUpdateRates = !_autoUpdateRates;
    await _prefs?.setBool(_autoUpdateRatesKey, _autoUpdateRates);
    notifyListeners();
  }

  /// Toggle haptic feedback
  Future<void> toggleHapticFeedback() async {
    _hapticFeedback = !_hapticFeedback;
    await _prefs?.setBool(_hapticFeedbackKey, _hapticFeedback);
    notifyListeners();
  }

  /// Toggle GPS detection
  Future<void> toggleGpsDetection() async {
    _gpsDetection = !_gpsDetection;
    await _prefs?.setBool(_gpsDetectionKey, _gpsDetection);
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs?.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  /// Reset all settings to default
  Future<void> resetToDefaults() async {
    _defaultCurrency = 'USD';
    _decimalPlaces = 2;
    _autoUpdateRates = true;
    _hapticFeedback = true;
    _gpsDetection = true;
    _themeMode = ThemeMode.system;

    await _prefs?.setString(_defaultCurrencyKey, _defaultCurrency);
    await _prefs?.setInt(_decimalPlacesKey, _decimalPlaces);
    await _prefs?.setBool(_autoUpdateRatesKey, _autoUpdateRates);
    await _prefs?.setBool(_hapticFeedbackKey, _hapticFeedback);
    await _prefs?.setBool(_gpsDetectionKey, _gpsDetection);
    await _prefs?.setInt(_themeModeKey, _themeMode.index);

    notifyListeners();
  }
}
