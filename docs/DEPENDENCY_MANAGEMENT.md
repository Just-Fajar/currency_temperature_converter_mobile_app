# Dependency Management Guide

## Overview

This project uses a comprehensive dependency management strategy to ensure maintainability, testability, and scalability.

## Table of Contents

- [Dependencies Overview](#dependencies-overview)
- [Dependency Injection](#dependency-injection)
- [Adding New Dependencies](#adding-new-dependencies)
- [Updating Dependencies](#updating-dependencies)
- [Removing Unused Dependencies](#removing-unused-dependencies)
- [Lock File Management](#lock-file-management)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Dependencies Overview

### Production Dependencies

#### State Management
- **provider** (^6.1.1) - Simple state management
- **flutter_riverpod** (^3.0.3) - Modern reactive state management

#### Dependency Injection
- **get_it** (^9.0.0) - Service locator for DI
- **injectable** (^2.5.0) - Code generation for DI (optional)

#### HTTP & API
- **http** (^1.2.0) - Basic HTTP client for API calls
- **dio** (^5.9.0) - Advanced HTTP client with interceptors

#### Local Storage
- **shared_preferences** (^2.5.0) - Simple key-value storage
- **hive** (^2.2.3) - NoSQL local database
- **hive_flutter** (^1.1.0) - Flutter integration for Hive
- **flutter_secure_storage** (^9.2.2) - Encrypted storage for sensitive data

#### Hardware Integration
- **geolocator** (^13.0.1) - GPS location services
- **vibration** (^3.0.0) - Haptic feedback

#### UI/UX Enhancement
- **google_fonts** (^6.3.0) - Custom fonts
- **flutter_animate** (^4.5.0) - Smooth animations
- **shimmer** (^3.0.0) - Loading shimmer effect

#### Utilities
- **intl** (^0.20.0) - Internationalization and formatting
- **share_plus** (^12.0.1) - Share content functionality
- **geocoding** (^4.0.0) - Reverse geocoding

#### Error Handling & Logging
- **firebase_core** (^3.11.0) - Firebase core SDK
- **firebase_crashlytics** (^4.8.3) - Crash reporting

#### Environment Configuration
- **flutter_dotenv** (^5.2.1) - Environment variables

#### Code Quality
- **freezed_annotation** (^2.4.4) - Immutable data classes
- **json_annotation** (^4.9.0) - JSON serialization

### Development Dependencies

#### Code Generation
- **build_runner** (^2.4.13) - Build system
- **hive_generator** (^2.0.1) - Hive code generation
- **injectable_generator** (^2.6.2) - DI code generation
- **freezed** (^2.5.7) - Data class code generation
- **json_serializable** (^6.9.3) - JSON serialization

#### Testing
- **flutter_test** (SDK) - Unit and widget testing
- **integration_test** (SDK) - Integration testing
- **mocktail** (^1.0.5) - Mocking library for tests

#### Development Tools
- **flutter_lints** (^6.0.0) - Flutter linting rules
- **very_good_analysis** (^7.0.0) - Stricter lint rules

---

## Dependency Injection

### Setup

The project uses **GetIt** as a service locator for dependency injection.

#### Initialization

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Setup dependencies
  await setupDependencies();
  
  // Configure logger
  AppLogger.configure(LoggerConfig.production);
  
  runApp(MyApp());
}
```

#### Registration

Dependencies are registered in `lib/core/di/injection_container.dart`:

```dart
// Lazy Singleton (created on first use)
getIt.registerLazySingleton<ApiService>(
  () => ApiService(client: getIt()),
);

// Singleton (created immediately)
getIt.registerSingleton<SharedPreferences>(prefs);

// Factory (new instance every time)
getIt.registerFactory<CurrencyProvider>(
  () => CurrencyProvider(currencyRepo: getIt()),
);
```

#### Resolution

```dart
// Resolve dependency
final apiService = getIt<ApiService>();
final repository = getIt<ICurrencyRepository>();

// Check if registered
if (getIt.isRegistered<ApiService>()) { ... }

// Safe resolution
final service = tryGetDependency<CrashlyticsService>();
if (service != null) { ... }
```

### Testing

```dart
setUp(() async {
  await setupTestDependencies();
  
  // Register mocks
  final mockRepo = MockCurrencyRepository();
  await registerTestDependency<ICurrencyRepository>(mockRepo);
});

tearDown(() async {
  await resetDependencies();
});
```

---

## Adding New Dependencies

### Step 1: Add to pubspec.yaml

```yaml
dependencies:
  new_package: ^1.0.0
```

### Step 2: Install

```bash
flutter pub get
```

### Step 3: Register in DI (if needed)

```dart
// In injection_container.dart
if (!getIt.isRegistered<NewService>()) {
  getIt.registerLazySingleton<NewService>(
    () => NewService(),
  );
}
```

### Step 4: Document

Update this guide with:
- Package purpose
- Configuration notes
- Usage examples

---

## Updating Dependencies

### Check for Updates

```bash
# Check outdated packages
flutter pub outdated

# Check specific package
flutter pub outdated --mode=outdated --show-all
```

### Update Process

#### Minor/Patch Updates (Safe)

```bash
# Update to latest compatible versions
flutter pub upgrade

# Update specific package
flutter pub upgrade package_name
```

#### Major Updates (Breaking Changes)

```bash
# Update with major version changes
flutter pub upgrade --major-versions

# Or manually edit pubspec.yaml
```

### After Updating

1. **Run tests:**
   ```bash
   flutter test
   ```

2. **Check for breaking changes:**
   - Read changelog
   - Review migration guide
   - Update code if needed

3. **Test manually:**
   - Build app
   - Test critical flows
   - Check on multiple devices

4. **Update lock file:**
   ```bash
   flutter pub get
   ```

---

## Removing Unused Dependencies

### Audit Dependencies

```bash
# Check which dependencies are used
flutter pub deps
```

### Manual Audit Process

1. **Search codebase:**
   ```bash
   grep -r "import 'package:package_name" lib/
   ```

2. **Check for transitive usage:**
   - Some packages are used by other packages
   - Don't remove if still needed by dependencies

3. **Remove from pubspec.yaml:**
   ```yaml
   # Remove line
   # unused_package: ^1.0.0
   ```

4. **Clean:**
   ```bash
   flutter pub get
   flutter clean
   flutter pub get
   ```

### Currently Identified Unused

Based on code analysis, consider removing:
- ❓ **dio** - If only using `http` package
- ❓ **flutter_animate** - If not using animations yet

**Note:** Verify usage before removing!

---

## Lock File Management

### Understanding pubspec.lock

The `pubspec.lock` file:
- Records exact versions of all dependencies
- Ensures consistent builds across environments
- Should be committed to version control
- Auto-generated, don't edit manually

### When to Update Lock File

1. **After adding dependencies:**
   ```bash
   flutter pub get
   ```

2. **After updating versions:**
   ```bash
   flutter pub upgrade
   ```

3. **When resolving conflicts:**
   ```bash
   flutter pub get
   rm pubspec.lock
   flutter pub get
   ```

4. **When dependency resolution fails:**
   ```bash
   flutter clean
   rm pubspec.lock
   flutter pub get
   ```

### Lock File in CI/CD

```yaml
# In CI/CD pipeline
- name: Get dependencies
  run: flutter pub get
  
# Use locked versions (faster, more reliable)
- name: Use locked versions
  run: flutter pub get --offline
```

---

## Best Practices

### ✅ Do's

1. **Pin major versions:**
   ```yaml
   package: ^1.0.0  # Good: allows minor updates
   package: 1.0.0   # Too strict
   package: >=1.0.0 # Too loose
   ```

2. **Group related dependencies:**
   ```yaml
   # State Management
   provider: ^6.1.1
   flutter_riverpod: ^3.0.3
   
   # HTTP & API
   http: ^1.2.0
   dio: ^5.9.0
   ```

3. **Document why you added it:**
   ```yaml
   new_package: ^1.0.0  # For feature X, replaces old_package
   ```

4. **Keep dev dependencies separate:**
   ```yaml
   dev_dependencies:
     build_runner: ^2.4.13  # Only for development
   ```

5. **Update regularly:**
   - Weekly: Check for security updates
   - Monthly: Update dependencies
   - Before release: Full dependency audit

6. **Test after updates:**
   ```bash
   flutter test
   flutter build apk --debug
   ```

### ❌ Don'ts

1. **Don't use specific versions unless necessary:**
   ```yaml
   package: 1.0.0  # Avoid unless absolutely needed
   ```

2. **Don't ignore breaking changes:**
   - Always read changelogs
   - Test after major updates

3. **Don't add dependencies unnecessarily:**
   - Can you implement it yourself? (small utility)
   - Is there a lighter alternative?
   - Do you really need it?

4. **Don't commit large dependencies:**
   - Never commit `packages/` folder
   - Use `.gitignore` properly

5. **Don't mix state management solutions:**
   - Choose one: Provider OR Riverpod
   - Keep it consistent

### Version Constraints

```yaml
# Caret (^) - Allows compatible updates
package: ^1.0.0  # Allows 1.0.0 <= version < 2.0.0

# Greater than or equal
package: >=1.0.0 <2.0.0  # Same as above

# Range
package: >=1.0.0 <=1.5.0  # Specific range

# Any version
package: any  # Avoid! Too risky
```

---

## Troubleshooting

### Issue: Dependency Conflict

**Error:**
```
Because package_a requires package_c ^1.0.0 and package_b requires package_c ^2.0.0,
package_a is incompatible with package_b.
```

**Solutions:**

1. **Update conflicting packages:**
   ```bash
   flutter pub upgrade
   ```

2. **Use dependency overrides (last resort):**
   ```yaml
   dependency_overrides:
     package_c: ^2.0.0
   ```

3. **Find alternative packages:**
   - Look for packages with compatible dependencies

### Issue: Package Not Found

**Error:**
```
Package doesn't exist (could not find package package_name at https://pub.dev).
```

**Solutions:**

1. **Check package name spelling**
2. **Check if package exists on pub.dev**
3. **Clear pub cache:**
   ```bash
   flutter pub cache repair
   ```

### Issue: Version Solving Failed

**Error:**
```
version solving failed
```

**Solutions:**

1. **Clean and retry:**
   ```bash
   flutter clean
   rm pubspec.lock
   flutter pub get
   ```

2. **Update Flutter SDK:**
   ```bash
   flutter upgrade
   ```

3. **Check SDK constraints:**
   ```yaml
   environment:
     sdk: ^3.10.4  # Make sure this matches your Flutter version
   ```

### Issue: Build Errors After Update

**Solutions:**

1. **Clean build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

2. **Check breaking changes:**
   - Read package changelog
   - Update deprecated APIs

3. **Regenerate code:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Issue: Slow Dependency Resolution

**Solutions:**

1. **Use pub cache:**
   ```bash
   flutter pub cache repair
   ```

2. **Use offline mode (if packages cached):**
   ```bash
   flutter pub get --offline
   ```

3. **Clear cache and retry:**
   ```bash
   flutter pub cache clean
   flutter pub get
   ```

---

## Dependency Audit Checklist

Use this checklist monthly:

- [ ] Run `flutter pub outdated`
- [ ] Check for security advisories
- [ ] Update dependencies with patches
- [ ] Test critical functionality
- [ ] Update major versions (if needed)
- [ ] Run full test suite
- [ ] Update this documentation
- [ ] Commit updated `pubspec.lock`

---

## Commands Reference

```bash
# Check dependencies
flutter pub deps              # Show dependency tree
flutter pub outdated          # Check for updates
flutter pub get               # Install dependencies
flutter pub upgrade           # Update dependencies
flutter pub cache repair      # Repair pub cache
flutter pub cache clean       # Clear pub cache

# Dependency resolution
flutter pub get --offline     # Use cached packages
flutter pub upgrade --major-versions  # Update with breaking changes

# Code generation
flutter pub run build_runner build            # Generate code
flutter pub run build_runner build --delete-conflicting-outputs  # Force regenerate
flutter pub run build_runner watch            # Watch for changes

# Clean
flutter clean                 # Clean build artifacts
rm pubspec.lock              # Remove lock file
rm -rf .dart_tool            # Remove tool cache
```

---

## Migration Notes

### Upgrading from Old Versions

#### flutter_riverpod (2.x → 3.x)

**Breaking changes:**
- `ref.watch` becomes `ref.watch`
- `ref.read` becomes `ref.read`
- Update imports

**Migration:**
```dart
// Old
import 'package:flutter_riverpod/flutter_riverpod.dart';

// New (no change in import)
import 'package:flutter_riverpod/flutter_riverpod.dart';

// But usage may differ - check docs
```

#### get_it (7.x → 9.x)

**Breaking changes:**
- Minor API changes
- Better null safety support

**Migration:**
```dart
// Most code should work as-is
// Check for deprecated methods
```

---

## Resources

- [pub.dev](https://pub.dev) - Dart package repository
- [Flutter Packages](https://pub.dev/flutter) - Flutter-specific packages
- [Dart Dependencies](https://dart.dev/tools/pub/dependencies) - Official guide
- [Dependency Injection](https://pub.dev/packages/get_it) - GetIt documentation

---

**Last Updated:** December 16, 2025  
**Version:** 1.0  
**Maintainer:** Development Team
