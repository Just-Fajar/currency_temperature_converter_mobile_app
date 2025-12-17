import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

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
/// Usage:
/// ```dart
/// final repository = getIt<ICurrencyRepository>();
/// final useCase = getIt<ConvertCurrencyUseCase>();
/// ```
final getIt = GetIt.instance;

/// Initialize all dependencies.
///
/// This should be called once at app startup before runApp().
///
/// Registers dependencies in the following order:
/// 1. External dependencies (HTTP client, etc.)
/// 2. Services
/// 3. Repositories
/// 4. Use cases
/// 5. Providers/State management
///
/// Example:
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await setupDependencies();
///   runApp(MyApp());
/// }
/// ```
Future<void> setupDependencies() async {
  // External dependencies
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(
      baseUrl: 'https://api.exchangerate-api.com',
      client: getIt(),
    ),
  );

  getIt.registerLazySingleton<LocationService>(() => LocationService());

  // Repositories (as interfaces)
  getIt.registerLazySingleton<ICurrencyRepository>(
    () => CurrencyRepository(client: getIt()) as ICurrencyRepository,
  );

  final storageRepo = StorageRepository();
  await storageRepo.init(); // Initialize storage
  getIt.registerLazySingleton<IStorageRepository>(
    () => storageRepo as IStorageRepository,
  );

  // Use Cases
  getIt.registerLazySingleton<ConvertCurrencyUseCase>(
    () => ConvertCurrencyUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetExchangeRatesUseCase>(
    () => GetExchangeRatesUseCase(getIt()),
  );

  getIt.registerLazySingleton<SaveConversionUseCase>(
    () => SaveConversionUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetConversionHistoryUseCase>(
    () => GetConversionHistoryUseCase(getIt()),
  );

  // Providers (for compatibility with existing Provider-based code)
  // Note: Providers instantiate their own repositories, so no parameters needed
  getIt.registerFactory<CurrencyProvider>(() => CurrencyProvider());

  getIt.registerFactory<TemperatureProvider>(() => TemperatureProvider());

  getIt.registerFactory<ThemeProvider>(() => ThemeProvider());

  final settingsProvider = SettingsProvider();
  await settingsProvider.init();
  getIt.registerSingleton<SettingsProvider>(settingsProvider);
}

/// Reset all dependencies (useful for testing).
///
/// Clears all registered dependencies from the service locator.
Future<void> resetDependencies() async {
  await getIt.reset();
}
