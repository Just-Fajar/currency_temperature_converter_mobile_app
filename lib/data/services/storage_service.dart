import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for local storage operations using SharedPreferences and Hive
class StorageService {
  static SharedPreferences? _prefs;
  static final Map<String, Box> _boxes = {};

  /// Initialize storage services
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();
  }

  /// Ensure storage is initialized
  static Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== SharedPreferences ====================

  /// Get string value
  static Future<String?> getString(String key) async {
    await _ensureInitialized();
    return _prefs!.getString(key);
  }

  /// Set string value
  static Future<bool> setString(String key, String value) async {
    await _ensureInitialized();
    return await _prefs!.setString(key, value);
  }

  /// Get int value
  static Future<int?> getInt(String key) async {
    await _ensureInitialized();
    return _prefs!.getInt(key);
  }

  /// Set int value
  static Future<bool> setInt(String key, int value) async {
    await _ensureInitialized();
    return await _prefs!.setInt(key, value);
  }

  /// Get double value
  static Future<double?> getDouble(String key) async {
    await _ensureInitialized();
    return _prefs!.getDouble(key);
  }

  /// Set double value
  static Future<bool> setDouble(String key, double value) async {
    await _ensureInitialized();
    return await _prefs!.setDouble(key, value);
  }

  /// Get bool value
  static Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    return _prefs!.getBool(key);
  }

  /// Set bool value
  static Future<bool> setBool(String key, bool value) async {
    await _ensureInitialized();
    return await _prefs!.setBool(key, value);
  }

  /// Get string list
  static Future<List<String>?> getStringList(String key) async {
    await _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  /// Set string list
  static Future<bool> setStringList(String key, List<String> value) async {
    await _ensureInitialized();
    return await _prefs!.setStringList(key, value);
  }

  /// Remove value
  static Future<bool> remove(String key) async {
    await _ensureInitialized();
    return await _prefs!.remove(key);
  }

  /// Clear all values
  static Future<bool> clear() async {
    await _ensureInitialized();
    return await _prefs!.clear();
  }

  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  // ==================== Hive ====================

  /// Open Hive box
  static Future<Box<T>> openBox<T>(String name) async {
    if (_boxes.containsKey(name)) {
      return _boxes[name] as Box<T>;
    }

    final box = await Hive.openBox<T>(name);
    _boxes[name] = box;
    return box;
  }

  /// Get Hive box
  static Box<T>? getBox<T>(String name) {
    return _boxes[name] as Box<T>?;
  }

  /// Close Hive box
  static Future<void> closeBox(String name) async {
    if (_boxes.containsKey(name)) {
      await _boxes[name]!.close();
      _boxes.remove(name);
    }
  }

  /// Close all boxes
  static Future<void> closeAllBoxes() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }

  /// Delete Hive box
  static Future<void> deleteBox(String name) async {
    await closeBox(name);
    await Hive.deleteBoxFromDisk(name);
  }
}
