# Firebase Crashlytics Setup Guide

This guide provides step-by-step instructions for integrating Firebase Crashlytics into the Currency & Temperature Converter app.

## Prerequisites

1. Flutter project
2. Firebase account
3. Android Studio / Xcode (for platform-specific setup)

## Step 1: Add Firebase to Your Project

### 1.1 Install Firebase CLI

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### 1.2 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "Currency Temperature Converter"
4. Enable Google Analytics (optional)
5. Create project

### 1.3 Configure FlutterFire

```bash
# Run from project root
flutterfire configure

# Select the Firebase project you just created
# Select platforms: Android, iOS, Web
# This will create firebase_options.dart file
```

## Step 2: Add Dependencies

Add these dependencies to `pubspec.yaml`:

```yaml
dependencies:
  # Firebase Core (required)
  firebase_core: ^2.24.0
  
  # Firebase Crashlytics
  firebase_crashlytics: ^3.4.0
  
  # Optional: Analytics
  firebase_analytics: ^10.7.0

dev_dependencies:
  # For symbol upload
  firebase_app_check: ^0.2.1+0
```

Run:
```bash
flutter pub get
```

## Step 3: Initialize Firebase in main.dart

Update your `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'core/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Pass all uncaught Flutter errors to Crashlytics
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    AppLogger.critical(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  
  // Pass all uncaught async errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    AppLogger.critical(
      'Async Error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };
  
  // Enable crash collection (can be toggled by user)
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  
  runApp(const MyApp());
}
```

## Step 4: Platform-Specific Configuration

### Android Configuration

#### 4.1 Update android/build.gradle

```gradle
buildscript {
    dependencies {
        // Add Firebase Crashlytics Gradle plugin
        classpath 'com.google.firebase:firebase-crashlytics-gradle:2.9.9'
    }
}
```

#### 4.2 Update android/app/build.gradle

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    
    // Add these plugins
    id "com.google.gms.google-services"
    id "com.google.firebase.crashlytics"
}

android {
    // ... existing config

    buildTypes {
        release {
            // Enable crash reporting for release builds
            firebaseCrashlytics {
                mappingFileUploadEnabled true
            }
            
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

#### 4.3 Add google-services.json

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/` directory
3. Add to `.gitignore`:
```
# Firebase
google-services.json
GoogleService-Info.plist
```

### iOS Configuration

#### 4.4 Add GoogleService-Info.plist

1. Download `GoogleService-Info.plist` from Firebase Console
2. Open `ios/Runner.xcworkspace` in Xcode
3. Drag the file into the project (under Runner folder)
4. Ensure "Copy items if needed" is checked

#### 4.5 Update ios/Podfile

```ruby
platform :ios, '12.0'

# Add Firebase
pod 'Firebase/Crashlytics'
pod 'Firebase/Analytics'
```

Run:
```bash
cd ios
pod install
cd ..
```

## Step 5: Create Crashlytics Service

Create `lib/core/services/crashlytics_service.dart`:

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../errors/failures.dart';
import '../logging/app_logger.dart';

/// Service for handling crash reporting and error tracking
class CrashlyticsService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initialize Crashlytics
  static Future<void> initialize() async {
    // Set user identifiers (call after login)
    // await setUser(userId: 'user123', email: 'user@example.com');
    
    AppLogger.info('Crashlytics initialized');
  }

  /// Record a non-fatal error
  static Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? information,
    bool fatal = false,
  }) async {
    try {
      // Log locally first
      AppLogger.error(
        reason ?? 'Error occurred',
        error: error,
        stackTrace: stackTrace,
        context: information,
      );

      // Record to Crashlytics
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        information: information?.entries.map((e) => '${e.key}: ${e.value}').toList(),
        fatal: fatal,
      );
    } catch (e) {
      AppLogger.error('Failed to record error to Crashlytics', error: e);
    }
  }

  /// Record a Failure object
  static Future<void> recordFailure(
    Failure failure, {
    String? additionalInfo,
    bool fatal = false,
  }) async {
    await recordError(
      failure,
      failure.stackTrace,
      reason: failure.code ?? failure.runtimeType.toString(),
      information: {
        'message': failure.message,
        'code': failure.code ?? 'N/A',
        'type': failure.runtimeType.toString(),
        if (additionalInfo != null) 'additional': additionalInfo,
      },
      fatal: fatal,
    );
  }

  /// Log a message to Crashlytics
  static Future<void> log(String message) async {
    await _crashlytics.log(message);
    AppLogger.debug('Crashlytics log: $message', tag: 'Crashlytics');
  }

  /// Set user identifier (call after login)
  static Future<void> setUser({
    required String userId,
    String? email,
    String? name,
  }) async {
    await _crashlytics.setUserIdentifier(userId);
    
    if (email != null) {
      await _crashlytics.setCustomKey('email', email);
    }
    
    if (name != null) {
      await _crashlytics.setCustomKey('name', name);
    }
    
    AppLogger.info('Crashlytics user set', context: {'userId': userId});
  }

  /// Set custom key-value pairs
  static Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Set multiple custom keys at once
  static Future<void> setCustomKeys(Map<String, dynamic> keys) async {
    for (final entry in keys.entries) {
      await setCustomKey(entry.key, entry.value);
    }
  }

  /// Force a crash (for testing)
  static void forceCrash() {
    _crashlytics.crash();
  }

  /// Check if crash reporting is enabled
  static Future<bool> isCrashlyticsCollectionEnabled() async {
    return _crashlytics.isCrashlyticsCollectionEnabled();
  }

  /// Enable/disable crash reporting
  static Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
    AppLogger.info(
      'Crashlytics collection ${enabled ? 'enabled' : 'disabled'}',
    );
  }

  /// Record breadcrumb for debugging
  static Future<void> breadcrumb(String message) async {
    await log('Breadcrumb: $message');
  }
}
```

## Step 6: Usage Examples

### Basic Error Recording

```dart
try {
  await riskyOperation();
} catch (e, stackTrace) {
  // Record to both logger and Crashlytics
  AppLogger.error('Operation failed', error: e, stackTrace: stackTrace);
  await CrashlyticsService.recordError(
    e,
    stackTrace,
    reason: 'Risky operation failed',
    information: {'operationType': 'conversion'},
  );
}
```

### Recording Failures

```dart
final result = await repository.getData();
result.fold(
  (failure) async {
    // Record failure to Crashlytics
    await CrashlyticsService.recordFailure(
      failure,
      additionalInfo: 'Failed to load user data',
    );
  },
  (data) => _showData(data),
);
```

### Setting User Context

```dart
// After user login
await CrashlyticsService.setUser(
  userId: user.id,
  email: user.email,
  name: user.name,
);

// Set additional context
await CrashlyticsService.setCustomKeys({
  'userRole': 'premium',
  'appVersion': '1.0.0',
  'environment': 'production',
});
```

### Breadcrumbs for Debugging

```dart
// Track user flow
await CrashlyticsService.breadcrumb('User opened currency converter');
await CrashlyticsService.breadcrumb('User selected USD to EUR');
await CrashlyticsService.breadcrumb('Conversion started');
// If crash happens, you'll see the breadcrumbs
```

## Step 7: Testing Crashlytics

### Test Crash

Add a test button (only in debug mode):

```dart
if (kDebugMode) {
  ElevatedButton(
    onPressed: () {
      // This will crash the app and report to Crashlytics
      CrashlyticsService.forceCrash();
    },
    child: const Text('Test Crash'),
  );
}
```

### Test Non-Fatal Error

```dart
ElevatedButton(
  onPressed: () async {
    await CrashlyticsService.recordError(
      Exception('Test error'),
      StackTrace.current,
      reason: 'Testing Crashlytics',
      information: {'testId': '123'},
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test error recorded')),
    );
  },
  child: const Text('Test Error'),
);
```

### Verify in Firebase Console

1. Run the app and trigger test errors
2. Wait 5-10 minutes for data to appear
3. Go to Firebase Console → Crashlytics
4. Check for errors and crashes

## Step 8: Build Release with Symbols

### Android

```bash
# Build release APK with symbols
flutter build apk --release

# Build App Bundle with symbols
flutter build appbundle --release

# Symbols are automatically uploaded during build
```

### iOS

```bash
# Build release
flutter build ios --release

# Archive in Xcode
# Upload to App Store Connect
# Symbols are automatically uploaded
```

## Step 9: Privacy & User Consent

Add crash reporting toggle in settings:

```dart
class SettingsScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Crash Reporting'),
      subtitle: const Text('Help us improve by sending crash reports'),
      value: _crashReportingEnabled,
      onChanged: (enabled) async {
        await CrashlyticsService.setCrashlyticsCollectionEnabled(enabled);
        setState(() => _crashReportingEnabled = enabled);
      },
    );
  }
}
```

## Troubleshooting

### Crashes not appearing

1. Wait 5-10 minutes after first crash
2. Ensure `firebase_options.dart` is generated
3. Check `google-services.json` / `GoogleService-Info.plist` are in correct location
4. Verify Firebase project is active

### Build errors

```bash
# Clean and rebuild
flutter clean
flutter pub get

# Android
cd android && ./gradlew clean && cd ..

# iOS
cd ios && pod deintegrate && pod install && cd ..
```

### Symbol upload issues

Android: Ensure ProGuard mapping files are uploaded
iOS: Ensure dSYMs are uploaded to Firebase

## Best Practices

1. **Always log before reporting**: Use AppLogger + CrashlyticsService
2. **Set user context early**: After login/initialization
3. **Use breadcrumbs**: Track user flow before crashes
4. **Don't report expected errors**: Only unexpected errors
5. **Respect user privacy**: Allow opt-out in settings
6. **Test thoroughly**: Use test buttons in debug mode
7. **Monitor regularly**: Check Firebase Console weekly

## Additional Resources

- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [FlutterFire Documentation](https://firebase.flutter.dev/docs/crashlytics/overview)
- [Crashlytics Best Practices](https://firebase.google.com/docs/crashlytics/best-practices)
