import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data
///
/// Uses flutter_secure_storage which:
/// - iOS: Stores data in Keychain
/// - Android: Encrypts data with AES and stores in EncryptedSharedPreferences
/// - Web: Stores data in browser's secure storage
///
/// Use for:
/// - Authentication tokens
/// - API keys
/// - User credentials
/// - Sensitive user data
///
/// Example:
/// ```dart
/// final secureStorage = SecureStorageService();
/// await secureStorage.saveToken('my_token');
/// final token = await secureStorage.getToken();
/// ```
class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  /// Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Storage keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyApiKey = 'api_key';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLastLoginTime = 'last_login_time';

  // ==================== Authentication Tokens ====================

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  /// Get authentication token
  Future<String?> getToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Delete authentication token
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyAuthToken);
  }

  // ==================== Refresh Token ====================

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  // ==================== User Data ====================

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  // ==================== API Key Management ====================

  /// Save API key securely
  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _keyApiKey, value: apiKey);
  }

  /// Get API key
  Future<String?> getApiKey() async {
    return await _storage.read(key: _keyApiKey);
  }

  /// Delete API key
  Future<void> deleteApiKey() async {
    await _storage.delete(key: _keyApiKey);
  }

  // ==================== Biometric Settings ====================

  /// Save biometric authentication preference
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
  }

  /// Get biometric authentication preference
  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  // ==================== Session Management ====================

  /// Save last login timestamp
  Future<void> saveLastLoginTime() async {
    final timestamp = DateTime.now().toIso8601String();
    await _storage.write(key: _keyLastLoginTime, value: timestamp);
  }

  /// Get last login timestamp
  Future<DateTime?> getLastLoginTime() async {
    final value = await _storage.read(key: _keyLastLoginTime);
    if (value == null) return null;

    try {
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }

  /// Check if session is expired (default: 30 days)
  Future<bool> isSessionExpired({
    Duration maxAge = const Duration(days: 30),
  }) async {
    final lastLogin = await getLastLoginTime();
    if (lastLogin == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    return difference > maxAge;
  }

  // ==================== Custom Key-Value Storage ====================

  /// Write custom secure value
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read custom secure value
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete custom secure value
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }

  // ==================== Batch Operations ====================

  /// Get all stored keys
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  /// Clear all stored data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Clear all auth-related data (logout)
  Future<void> clearAuthData() async {
    await Future.wait([
      deleteToken(),
      deleteRefreshToken(),
      delete(_keyUserId),
      delete(_keyUserEmail),
      delete(_keyLastLoginTime),
    ]);
  }

  // ==================== Encryption Utilities ====================

  /// Check if secure storage is available on device
  ///
  /// Returns true if the device supports secure storage.
  /// May return false on some Android emulators or rooted devices.
  static Future<bool> isAvailable() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: '_test', value: 'test');
      await storage.delete(key: '_test');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get storage options for current platform
  static IOSOptions get iOSOptions => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
    synchronizable: false,
  );

  static AndroidOptions get androidOptions => const AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
  );

  static WebOptions get webOptions => const WebOptions();

  /// Create storage instance with custom options
  static FlutterSecureStorage createWithOptions({
    IOSOptions? iosOptions,
    AndroidOptions? androidOptions,
    WebOptions? webOptions,
  }) {
    return FlutterSecureStorage(
      iOptions: iosOptions ?? iOSOptions,
      aOptions: androidOptions ?? SecureStorageService.androidOptions,
      webOptions: webOptions ?? SecureStorageService.webOptions,
    );
  }
}
