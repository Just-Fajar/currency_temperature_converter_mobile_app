# Dependency Update Migration Guide

## Overview

This guide helps you migrate from the old dependency versions to the new updated versions.

## Updated Dependencies

### Major Updates (Breaking Changes Possible)

| Package | Old Version | New Version | Breaking Changes |
|---------|-------------|-------------|------------------|
| flutter_riverpod | 2.4.9 → 3.0.3 | ✅ Yes | Minor API changes |
| get_it | 7.6.4 → 9.0.0 | ⚠️ Minor | Mostly compatible |
| geolocator | 11.0.0 → 13.0.1 | ⚠️ Minor | API improvements |
| vibration | 2.0.0 → 3.0.0 | ✅ Yes | Platform updates |

### Minor/Patch Updates (Safe)

| Package | Old Version | New Version | Status |
|---------|-------------|-------------|--------|
| http | 1.1.2 → 1.2.0 | ✅ Safe |
| shared_preferences | 2.2.2 → 2.5.0 | ✅ Safe |
| google_fonts | 6.1.0 → 6.3.0 | ✅ Safe |
| intl | 0.19.0 → 0.20.0 | ✅ Safe |

### New Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| firebase_core | ^3.11.0 | Firebase integration |
| firebase_crashlytics | ^4.8.3 | Crash reporting |
| flutter_secure_storage | ^9.2.2 | Secure data storage |
| flutter_dotenv | ^5.2.1 | Environment variables |
| injectable | ^2.5.0 | DI code generation |
| freezed_annotation | ^2.4.4 | Immutable classes |
| json_annotation | ^4.9.0 | JSON serialization |

---

## Migration Steps

### Step 1: Backup Current State

```bash
# Commit current changes
git add .
git commit -m "Pre-dependency-update backup"

# Create backup branch
git checkout -b backup/pre-dependency-update
git checkout main
```

### Step 2: Update Dependencies

#### Option A: Automatic Update (Recommended)

```bash
# Clean first
flutter clean

# Update pubspec.yaml (already done)
# Then get dependencies
flutter pub get

# If issues occur, try:
rm pubspec.lock
flutter pub get
```

#### Option B: Manual Step-by-Step

```bash
# Update one at a time
flutter pub upgrade flutter_riverpod
flutter pub upgrade get_it
# ... etc

# Test after each update
flutter test
```

### Step 3: Fix Breaking Changes

#### flutter_riverpod (2.x → 3.x)

**No code changes required** for basic usage. If you see deprecation warnings:

```dart
// Old (still works)
final provider = Provider((ref) => Service());

// New (recommended)
final provider = Provider((ref) => Service());

// Riverpod 3.x has better null safety
// Check imports - should still be:
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

#### get_it (7.x → 9.x)

**Mostly backward compatible**. New features available:

```dart
// New: Check if ready
await getIt.allReady();

// New: Better scoping
getIt.pushNewScope();
// ... do work
await getIt.popScope();

// Old methods still work
getIt<Service>();
```

#### geolocator (11.x → 13.x)

**Minor API improvements**, existing code should work:

```dart
// Check if any LocationSettings changed
final position = await Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,
  // New optional parameters available
  timeLimit: Duration(seconds: 10), // NEW
);
```

#### vibration (2.x → 3.x)

**Platform-specific updates**:

```dart
// Old (still works)
Vibration.vibrate(duration: 100);

// New features
Vibration.vibrate(
  duration: 100,
  amplitude: 128, // NEW: Android 8.0+
);
```

### Step 4: Add New Dependencies Configuration

#### Firebase Setup

1. **Install Firebase CLI:**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. **Initialize Firebase:**
   ```bash
   flutterfire configure
   ```

3. **Update main.dart:**
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   import 'firebase_options.dart';

   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     // Initialize Firebase
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     
     // Rest of your setup
     await setupDependencies();
     runApp(MyApp());
   }
   ```

#### Secure Storage Setup

```dart
// Initialize in DI
final secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);
getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
```

#### Environment Variables

1. **Create .env file:**
   ```env
   API_KEY=your_api_key_here
   API_BASE_URL=https://api.example.com
   ```

2. **Add to .gitignore:**
   ```gitignore
   .env
   .env.local
   .env.*.local
   ```

3. **Load in main.dart:**
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   Future<void> main() async {
     await dotenv.load(fileName: ".env");
     runApp(MyApp());
   }
   ```

### Step 5: Update DI Container

**Replace old injection.dart with new injection_container.dart:**

```bash
# Backup old file
mv lib/core/di/injection.dart lib/core/di/injection_old.dart

# Copy new file (already created)
# File: lib/core/di/injection_container.dart

# Update imports in files using it
# From:
import '../../core/di/injection.dart';
# To:
import '../../core/di/injection_container.dart';
```

**Or update imports to use new file:**

```dart
// main.dart
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Setup dependencies with new container
  await setupDependencies();
  
  runApp(MyApp());
}
```

### Step 6: Test Everything

```bash
# Run tests
flutter test

# Build debug app
flutter build apk --debug

# Run on device
flutter run

# Check for deprecation warnings
flutter analyze
```

### Step 7: Update CI/CD

Update your CI/CD pipeline to handle new dependencies:

```yaml
# .github/workflows/flutter.yml
- name: Install dependencies
  run: |
    flutter pub get
    
- name: Run code generation (if using injectable)
  run: flutter pub run build_runner build --delete-conflicting-outputs

- name: Run tests
  run: flutter test --coverage
```

---

## Code Changes Required

### Minimal Changes (Most Apps)

For most apps, only these changes are needed:

#### 1. main.dart

```dart
// Add these imports
import 'package:firebase_core/firebase_core.dart';
import 'core/di/injection_container.dart'; // Updated path

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // NEW: Initialize Firebase
  await Firebase.initializeApp();
  
  // NEW: Use new DI container
  await setupDependencies();
  
  // Configure logger
  AppLogger.configure(LoggerConfig.production);
  
  runApp(MyApp());
}
```

#### 2. Update DI Imports

```bash
# Find and replace
# From: import '../../core/di/injection.dart';
# To:   import '../../core/di/injection_container.dart';

# Or keep using getIt from new file
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;
```

### Optional Enhancements

#### Use Injectable (Optional)

If you want to use code generation for DI:

1. **Annotate services:**
   ```dart
   @injectable
   class ApiService {
     @injectable
     ApiService(http.Client client);
   }
   ```

2. **Generate code:**
   ```bash
   flutter pub run build_runner build
   ```

#### Use Freezed (Optional)

For immutable data classes:

1. **Annotate models:**
   ```dart
   @freezed
   class User with _$User {
     const factory User({
       required String id,
       required String name,
     }) = _User;
     
     factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
   }
   ```

2. **Generate code:**
   ```bash
   flutter pub run build_runner build
   ```

---

## Rollback Plan

If something goes wrong:

### Option 1: Revert pubspec.yaml

```bash
# Restore old pubspec.yaml
git checkout HEAD~1 -- pubspec.yaml
flutter pub get
```

### Option 2: Use Backup Branch

```bash
git checkout backup/pre-dependency-update
```

### Option 3: Manual Revert

Edit `pubspec.yaml` back to old versions:

```yaml
dependencies:
  flutter_riverpod: ^2.4.9  # Revert
  get_it: ^7.6.4            # Revert
  # etc...
```

Then:

```bash
flutter clean
rm pubspec.lock
flutter pub get
```

---

## Verification Checklist

After migration, verify:

- [ ] App builds successfully
  ```bash
  flutter build apk --debug
  ```

- [ ] All tests pass
  ```bash
  flutter test
  ```

- [ ] No deprecation warnings
  ```bash
  flutter analyze
  ```

- [ ] Dependencies resolve correctly
  ```bash
  flutter pub get
  ```

- [ ] App runs on device
  ```bash
  flutter run
  ```

- [ ] Critical features work:
  - [ ] Currency conversion
  - [ ] Temperature conversion
  - [ ] History saving
  - [ ] Settings persistence
  - [ ] Location services (if used)

- [ ] Error handling works:
  - [ ] Test network error
  - [ ] Test validation error
  - [ ] Check crash reporting (if Firebase setup)

- [ ] Performance is acceptable:
  - [ ] App launch time
  - [ ] Screen transitions
  - [ ] API response times

---

## Troubleshooting

### Issue: Flutter Riverpod Errors

**Error:**
```
The method 'watch' isn't defined for the type 'WidgetRef'
```

**Solution:**
```dart
// Make sure imports are correct
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Make sure using ConsumerWidget or ConsumerStatefulWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(myProvider);
    return Text('$value');
  }
}
```

### Issue: GetIt Registration Errors

**Error:**
```
GetIt: Object/factory with type X is not registered inside GetIt
```

**Solution:**
```dart
// Check if setupDependencies() was called
await setupDependencies();

// Check if dependency is registered
if (getIt.isRegistered<MyService>()) {
  final service = getIt<MyService>();
}

// Or use safe method
final service = tryGetDependency<MyService>();
```

### Issue: Firebase Not Initialized

**Error:**
```
Firebase has not been correctly initialized. Call Firebase.initializeApp()
```

**Solution:**
```dart
// Add to main.dart BEFORE setupDependencies
await Firebase.initializeApp();
```

### Issue: Build Runner Conflicts

**Error:**
```
Conflicting outputs were detected and the build was stopped
```

**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Performance Impact

### Expected Improvements

- **Riverpod 3.x**: Better performance, reduced rebuilds
- **GetIt 9.x**: Faster dependency resolution
- **Geolocator 13.x**: More accurate location, better battery
- **HTTP 1.2**: Minor performance improvements

### Benchmarks

Run before and after:

```dart
// Add to main.dart for testing
import 'dart:developer' as developer;

void main() async {
  final stopwatch = Stopwatch()..start();
  
  await Firebase.initializeApp();
  await setupDependencies();
  
  stopwatch.stop();
  developer.log('Setup time: ${stopwatch.elapsedMilliseconds}ms');
  
  runApp(MyApp());
}
```

---

## Support

If you encounter issues:

1. **Check this guide** for solutions
2. **Check package changelogs** on pub.dev
3. **Search GitHub issues** for the package
4. **Rollback if needed** using the Rollback Plan above

---

**Migration Date:** December 16, 2025  
**Version:** 1.0  
**Status:** Ready for Migration
