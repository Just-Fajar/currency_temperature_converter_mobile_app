// NOTE: Firebase Crashlytics is currently disabled for demo purposes
// To enable: Add firebase_core and firebase_crashlytics to pubspec.yaml
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logging/app_logger.dart';
import '../../core/services/crashlytics_service.dart';
import '../../core/services/secure_storage_service.dart';
import '../../data/repositories/currency_repository.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/services/api_service.dart';
import '../../data/services/location_service.dart';
import '../../domain/repositories/i_currency_repository.dart';
import '../../domain/repositories/i_storage_repository.dart';
import '../../domain/usecases/convert_currency_usecase.dart';
import '../../domain/usecases/get_conversion_history_usecase.dart';
import '../../domain/usecases/get_exchange_rates_usecase.dart';
import '../../domain/usecases/save_conversion_usecase.dart';
import '../../presentation/providers/currency_provider.dart';
import '../../presentation/providers/settings_provider.dart';
import '../../presentation/providers/temperature_provider.dart';
import '../../presentation/providers/theme_provider.dart';

/// Service locator for dependency injection.
///
/// Provides centralized access to all dependencies throughout the app.
/// Uses get_it package for service location pattern.
///
/// Features:
/// - Lazy singletons for shared resources
/// - Factory registration for providers
/// - Async initialization support
/// - Environment-based configuration
/// - Type-safe dependency resolution
///
/// Usage:
/// ```dart
/// // Register dependencies
/// await setupDependencies();
///
/// // Resolve dependencies
/// final repository = getIt<ICurrencyRepository>();
/// final useCase = getIt<ConvertCurrencyUseCase>();
///
/// // Check if registered
/// if (getIt.isRegistered<ApiService>()) { ... }
///
/// // Unregister (testing)
/// await getIt.unregister<ApiService>();
///
/// // Reset all (testing)
/// await resetDependencies();
/// ```
final getIt = GetIt.instance;

/// Initialize all dependencies.
///
/// This should be called once at app startup before runApp().
///
/// Registers dependencies in the following order:
/// 1. Core services (logging, crashlytics)
/// 2. External dependencies (HTTP client, storage)
/// 3. Data services (API, location)
/// 4. Repositories
/// 5. Use cases
/// 6. Providers/State management
///
/// Example:
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize Firebase
///   await Firebase.initializeApp();
///
///   // Setup dependencies
///   await setupDependencies();
///
///   // Configure logger
///   AppLogger.configure(LoggerConfig.production);
///
///   runApp(MyApp());
/// }
/// ```
Future<void> setupDependencies({bool isProduction = true}) async {
  // ============================================================================
  // CORE SERVICES
  // ============================================================================

  // Logger (configure first for early logging)
  if (!getIt.isRegistered<AppLogger>()) {
    getIt.registerLazySingleton<AppLogger>(() => AppLogger());
  }

  // Crashlytics Service
  if (!getIt.isRegistered<CrashlyticsService>()) {
    getIt.registerLazySingleton<CrashlyticsService>(() => CrashlyticsService());
    await CrashlyticsService.initialize();
  }

  // ============================================================================
  // EXTERNAL DEPENDENCIES
  // ============================================================================

  // HTTP Client
  if (!getIt.isRegistered<http.Client>()) {
    getIt.registerLazySingleton<http.Client>(() => http.Client());
  }

  // Shared Preferences
  if (!getIt.isRegistered<SharedPreferences>()) {
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);
  }

  // Secure Storage
  if (!getIt.isRegistered<FlutterSecureStorage>()) {
    getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    );
  }

  // Secure Storage Service
  if (!getIt.isRegistered<SecureStorageService>()) {
    getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(),
    );
  }

  // ============================================================================
  // DATA SERVICES
  // ============================================================================

  // API Service
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(
      () => ApiService(
        baseUrl: 'https://api.exchangerate-api.com',
        client: getIt(),
      ),
    );
  }

  // Location Service
  if (!getIt.isRegistered<LocationService>()) {
    getIt.registerLazySingleton<LocationService>(() => LocationService());
  }

  // ============================================================================
  // REPOSITORIES
  // ============================================================================

  // Currency Repository
  if (!getIt.isRegistered<ICurrencyRepository>()) {
    getIt.registerLazySingleton<ICurrencyRepository>(
      () => CurrencyRepository(client: getIt()) as ICurrencyRepository,
    );
  }

  // Storage Repository
  if (!getIt.isRegistered<IStorageRepository>()) {
    final storageRepo = StorageRepository();
    await storageRepo.init(); // Initialize storage
    getIt.registerSingleton<IStorageRepository>(
      storageRepo as IStorageRepository,
    );
  }

  // ============================================================================
  // USE CASES
  // ============================================================================

  // Convert Currency Use Case
  if (!getIt.isRegistered<ConvertCurrencyUseCase>()) {
    getIt.registerLazySingleton<ConvertCurrencyUseCase>(
      () => ConvertCurrencyUseCase(getIt()),
    );
  }

  // Get Exchange Rates Use Case
  if (!getIt.isRegistered<GetExchangeRatesUseCase>()) {
    getIt.registerLazySingleton<GetExchangeRatesUseCase>(
      () => GetExchangeRatesUseCase(getIt()),
    );
  }

  // Save Conversion Use Case
  if (!getIt.isRegistered<SaveConversionUseCase>()) {
    getIt.registerLazySingleton<SaveConversionUseCase>(
      () => SaveConversionUseCase(getIt()),
    );
  }

  // Get Conversion History Use Case
  if (!getIt.isRegistered<GetConversionHistoryUseCase>()) {
    getIt.registerLazySingleton<GetConversionHistoryUseCase>(
      () => GetConversionHistoryUseCase(getIt()),
    );
  }

  // ============================================================================
  // PROVIDERS (for compatibility with existing Provider-based code)
  // ============================================================================

  // Currency Provider - instantiates its own repositories
  if (!getIt.isRegistered<CurrencyProvider>()) {
    getIt.registerFactory<CurrencyProvider>(() => CurrencyProvider());
  }

  // Temperature Provider - instantiates its own repositories
  if (!getIt.isRegistered<TemperatureProvider>()) {
    getIt.registerFactory<TemperatureProvider>(() => TemperatureProvider());
  }

  // Theme Provider
  if (!getIt.isRegistered<ThemeProvider>()) {
    getIt.registerFactory<ThemeProvider>(() => ThemeProvider());
  }

  // Settings Provider (singleton with initialization)
  if (!getIt.isRegistered<SettingsProvider>()) {
    final settingsProvider = SettingsProvider();
    await settingsProvider.init();
    getIt.registerSingleton<SettingsProvider>(settingsProvider);
  }

  // Log successful initialization
  AppLogger.info(
    'Dependency injection setup completed',
    context: {
      'isProduction': isProduction,
      'registeredCount': 'setup complete',
    },
  );
}

/// Reset all dependencies (useful for testing).
///
/// Clears all registered dependencies from the service locator.
/// Should typically only be used in test environments.
///
/// Example:
/// ```dart
/// // In tests
/// tearDown(() async {
///   await resetDependencies();
/// });
/// ```
Future<void> resetDependencies() async {
  await getIt.reset();
}

/// Check if a dependency is registered.
///
/// Useful for conditional registration or testing.
///
/// Example:
/// ```dart
/// if (!isDependencyRegistered<ApiService>()) {
///   getIt.registerLazySingleton<ApiService>(() => ApiService());
/// }
/// ```
bool isDependencyRegistered<T extends Object>() {
  return getIt.isRegistered<T>();
}

/// Get a dependency if registered, otherwise return null.
///
/// Safe way to retrieve optional dependencies.
///
/// Example:
/// ```dart
/// final crashlytics = tryGetDependency<CrashlyticsService>();
/// if (crashlytics != null) {
///   await crashlytics.recordError(error, stackTrace);
/// }
/// ```
T? tryGetDependency<T extends Object>() {
  try {
    return getIt.isRegistered<T>() ? getIt<T>() : null;
  } catch (e) {
    return null;
  }
}

/// Unregister a specific dependency.
///
/// Useful for testing or hot reload scenarios.
///
/// Example:
/// ```dart
/// await unregisterDependency<ApiService>();
/// ```
Future<void> unregisterDependency<T extends Object>() async {
  if (getIt.isRegistered<T>()) {
    await getIt.unregister<T>();
  }
}

/// Register a test dependency (replaces existing if registered).
///
/// Useful for mocking dependencies in tests.
///
/// Example:
/// ```dart
/// // In tests
/// final mockRepo = MockCurrencyRepository();
/// await registerTestDependency<ICurrencyRepository>(mockRepo);
/// ```
Future<void> registerTestDependency<T extends Object>(
  T instance, {
  bool disposable = true,
}) async {
  // Unregister if already exists
  if (getIt.isRegistered<T>()) {
    await getIt.unregister<T>();
  }

  // Register new instance
  getIt.registerSingleton<T>(instance);
}

/// Get all registered dependency types.
///
/// Useful for debugging and diagnostics.
///
/// Example:
/// ```dart
/// final dependencies = getAllRegisteredDependencies();
/// print('Registered: ${dependencies.length} dependencies');
/// ```
List<Type> getAllRegisteredDependencies() {
  // GetIt doesn't expose registered types list, return empty for now
  return [];
}

/// Setup dependencies for testing environment.
///
/// Registers minimal dependencies needed for testing.
///
/// Example:
/// ```dart
/// setUp(() async {
///   await setupTestDependencies();
/// });
/// ```
Future<void> setupTestDependencies() async {
  await setupDependencies(isProduction: false);
}
