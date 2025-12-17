# 📦 Required Dependencies for Performance & Security Features

Add these dependencies to `pubspec.yaml`:

```yaml
dependencies:
  # Environment variables & API key management
  flutter_dotenv: ^5.1.0
  
  # Secure storage
  flutter_secure_storage: ^9.0.0
  
  # HTTP client for certificate pinning
  http: ^1.2.0

dev_dependencies:
  # For testing secure storage
  mockito: ^5.4.4
```

## Installation Steps

1. **Add dependencies to pubspec.yaml**
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     
     # Existing dependencies...
     provider: ^6.1.2
     hive: ^2.2.3
     # ... other dependencies
     
     # NEW: Security & Performance
     flutter_dotenv: ^5.1.0
     flutter_secure_storage: ^9.0.0
     http: ^1.2.0
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create .env file** (root directory)
   ```env
   EXCHANGE_RATE_API_KEY=your_api_key_here
   EXCHANGE_RATE_BASE_URL=https://v6.exchangerate-api.com/v6
   ENVIRONMENT=development
   ```

4. **Update pubspec.yaml to include .env**
   ```yaml
   flutter:
     assets:
       - .env
       - assets/
   ```

5. **Update main.dart**
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';
   import 'core/config/env_config.dart';
   
   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // Load environment variables
     await dotenv.load(fileName: ".env");
     
     // Validate required environment variables
     EnvConfig.validate();
     
     runApp(const MyApp());
   }
   ```

6. **Usage Examples**

   **Environment Config:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/core/config/env_config.dart';
   
   // Get API key
   final apiKey = EnvConfig.exchangeRateApiKey;
   
   // Check environment
   if (EnvConfig.isDevelopment) {
     print('Running in development mode');
   }
   ```

   **Secure Storage:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/core/services/secure_storage_service.dart';
   
   final secureStorage = SecureStorageService();
   
   // Save token
   await secureStorage.saveToken('user_token_here');
   
   // Get token
   final token = await secureStorage.getToken();
   
   // Check if logged in
   final hasToken = await secureStorage.hasToken();
   ```

   **Certificate Pinning:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/core/services/certificate_pinning_service.dart';
   
   // Create secure client
   final client = CertificatePinningService.createSecureClient();
   
   try {
     final response = await client.get(Uri.parse(url));
     // Handle response
   } finally {
     client.close();
   }
   ```

   **Lazy Loading:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/data/repositories/storage_repository.dart';
   
   final storage = StorageRepository();
   
   // Get paginated history
   final page1 = await storage.getPaginatedHistory(
     page: 0,
     pageSize: 20,
   );
   
   print('Loaded ${page1.items.length} of ${page1.totalCount} items');
   print('Has next page: ${page1.hasNextPage}');
   ```

   **Build Optimization:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/core/utils/build_optimization.dart';
   
   // Selective rebuild
   BuildOptimization.selective<double>(
     selector: (context, value) => provider.amount,
     shouldRebuild: (prev, curr) => prev != curr,
     builder: (context, value, child) => Text('Amount: $value'),
   );
   ```

   **List Performance:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/core/utils/list_performance.dart';
   
   // Optimized list
   ListPerformance.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
     keyBuilder: (index) => items[index].id,
   );
   ```

   **Heavy Computation:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/core/utils/heavy_computation.dart';
   
   // Process in background
   final stats = await HeavyComputation.calculateStatistics(history);
   print('Total conversions: ${stats.totalConversions}');
   print('Average amount: ${stats.averageAmount}');
   ```

   **Input Sanitization:**
   ```dart
   import 'package:currency_temperature_converter_mobile_app/core/utils/input_sanitizer.dart';
   
   // Sanitize user input
   final safeCurrency = InputSanitizer.sanitizeCurrencyCode(userInput);
   final safeAmount = InputSanitizer.sanitizeCurrencyAmount(amountInput);
   
   // Validate
   if (SecurityValidator.isValidCurrencyCode(safeCurrency)) {
     // Process
   }
   ```

## Testing

After installation, test each feature:

```dart
// Test environment config
void testEnvConfig() {
  print('Environment: ${EnvConfig.environment}');
  print('Has API Key: ${EnvConfig.hasApiKey}');
  EnvConfig.validate(); // Should not throw
}

// Test secure storage
Future<void> testSecureStorage() async {
  final storage = SecureStorageService();
  await storage.write('test_key', 'test_value');
  final value = await storage.read('test_key');
  print('Stored and retrieved: $value');
  await storage.delete('test_key');
}

// Test certificate pinning
Future<void> testCertificatePinning() async {
  final isValid = await CertificatePinningService.validateCertificate(
    'api.exchangerate-api.com',
  );
  print('Certificate valid: $isValid');
}
```

## Platform-Specific Setup

### Android

No additional setup required for these dependencies.

### iOS

For `flutter_secure_storage`, update `ios/Podfile`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # Add this for secure storage
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_KEYCHAIN=1'
      ]
    end
  end
end
```

### Web

`flutter_secure_storage` uses browser's `localStorage` on web (not as secure as mobile).

For production web apps, consider additional security measures.

## Troubleshooting

### Issue: "dotenv not loaded"
**Solution:** Ensure `.env` file exists and is listed in `pubspec.yaml` assets

### Issue: "Secure storage not working on Android emulator"
**Solution:** Some emulators don't support secure storage. Test on real devices.

### Issue: "Certificate pinning failing"
**Solution:** Add actual certificate fingerprints to `trustedCertificates` map

## Next Steps

1. ✅ Install dependencies
2. ✅ Create .env file
3. ✅ Update main.dart
4. ✅ Test each feature
5. 🔄 Migrate existing API calls to use certificate pinning
6. 🔄 Replace sensitive data storage with secure storage
7. 🔄 Add input sanitization to all user inputs
8. 🔄 Implement lazy loading in history screen
9. 🔄 Apply build optimizations to heavy screens

---

**Generated:** December 16, 2025
**Flutter Version:** 3.10.4+
