# Code Obfuscation & Production Build Guide

## Overview

Code obfuscation makes your Flutter app harder to reverse-engineer by:
- Renaming classes, methods, and variables to meaningless names
- Removing debug information
- Optimizing and minifying code

## 🚀 Quick Start

### Android APK (Obfuscated)
```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info/android
```

### Android App Bundle (Recommended for Play Store)
```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info/android
```

### iOS (Obfuscated)
```bash
flutter build ios --release --obfuscate --split-debug-info=build/debug-info/ios
```

### Web (Obfuscated)
```bash
flutter build web --release --source-maps
```

## 📋 Build Flags Explained

### --obfuscate
Enables code obfuscation:
- Renames classes, methods, variables
- Makes reverse-engineering difficult
- Reduces app size

### --split-debug-info=<directory>
Separates debug symbols from app:
- Required for obfuscation
- Stores symbols for crash reporting
- Helps debug production crashes

### --release
Builds optimized release version:
- Removes debug code
- Enables optimizations
- Smaller app size
- Better performance

## 🔧 ProGuard Configuration (Android)

### android/app/build.gradle

Add ProGuard rules for additional obfuscation:

```gradle
android {
    buildTypes {
        release {
            // Enable obfuscation
            minifyEnabled true
            
            // Enable resource shrinking
            shrinkResources true
            
            // ProGuard rules
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            
            // Signing config
            signingConfig signingConfigs.release
        }
    }
}
```

### android/app/proguard-rules.pro

```proguard
# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep model classes (if using reflection)
-keep class com.yourapp.data.models.** { *; }

# Gson/JSON serialization
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Hive (if using)
-keep class * extends hive.HiveObject { *; }

# Your app's models
-keep class com.example.currency_temperature_converter_mobile_app.data.models.** { *; }
```

## 🍎 iOS Configuration

### ios/Runner/Info.plist

No special configuration needed for obfuscation.
iOS apps are automatically obfuscated during archive build.

## 📦 Build Artifacts

After obfuscated build, you'll have:

```
build/
├── debug-info/
│   ├── android/
│   │   └── app.android-arm64.symbols  # Debug symbols for Android
│   └── ios/
│       └── app.ios-arm64.symbols      # Debug symbols for iOS
├── app/
│   └── outputs/
│       └── apk/release/
│           └── app-release.apk        # Obfuscated APK
└── ios/
    └── Release-iphoneos/
        └── Runner.app                 # Obfuscated iOS app
```

## 🔍 Debugging Production Crashes

### Store Debug Symbols

**IMPORTANT:** Keep debug symbols for crash analysis!

```bash
# Backup debug symbols
cp -r build/debug-info ~/backups/app-v1.0.0-debug-info
```

### Firebase Crashlytics Integration

Upload debug symbols to Firebase for automatic crash deobfuscation:

```bash
# Android
firebase crashlytics:symbols:upload \
  --app=YOUR_APP_ID \
  build/debug-info/android

# iOS (done automatically by Xcode with dSYM files)
```

### Manual Deobfuscation

To deobfuscate stack traces:

```bash
flutter symbolize \
  --input=crash_log.txt \
  --debug-info=build/debug-info/android/app.android-arm64.symbols
```

## 🧪 Testing Obfuscated Builds

### 1. Build and Install
```bash
# Android
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
flutter install --release

# iOS
flutter build ios --release --obfuscate --split-debug-info=build/debug-info
# Then open in Xcode and archive
```

### 2. Test Critical Flows
- [ ] App launches correctly
- [ ] All features work
- [ ] No crashes
- [ ] API calls succeed
- [ ] Storage works correctly

### 3. Verify Obfuscation

Use APK analyzer to verify code is obfuscated:

```bash
# Android Studio > Build > Analyze APK
# Look for classes named 'a', 'b', 'c' instead of actual names
```

## 📝 Build Scripts

Create convenience scripts for common builds:

### scripts/build_android_release.sh
```bash
#!/bin/bash
echo "Building obfuscated Android release..."

flutter clean
flutter pub get

# Build APK
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/debug-info/android \
  --target-platform android-arm64

echo "✅ Build complete!"
echo "📦 APK: build/app/outputs/apk/release/app-release.apk"
echo "🔍 Debug info: build/debug-info/android/"
```

### scripts/build_ios_release.sh
```bash
#!/bin/bash
echo "Building obfuscated iOS release..."

flutter clean
flutter pub get

# Build iOS
flutter build ios --release \
  --obfuscate \
  --split-debug-info=build/debug-info/ios

echo "✅ Build complete!"
echo "📦 Open ios/Runner.xcworkspace in Xcode to archive"
```

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

## ⚙️ Additional Security

### 1. Enable R8 (Android)

In `android/gradle.properties`:
```properties
android.enableR8=true
android.enableR8.fullMode=true
```

### 2. Remove Console Logs

Use flutter_dotenv to disable debug prints in production:

```dart
// lib/main.dart
void main() {
  if (const String.fromEnvironment('ENVIRONMENT') == 'production') {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  
  runApp(MyApp());
}
```

Build with:
```bash
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/debug-info \
  --dart-define=ENVIRONMENT=production
```

### 3. Asset Obfuscation

Obfuscate asset paths in build:

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
  
  # Use asset bundles instead of direct paths
```

## 📊 Size Comparison

Typical size reduction with obfuscation:

| Build Type | Size | Notes |
|------------|------|-------|
| Debug | ~50MB | Full symbols, no optimization |
| Release | ~25MB | Optimized, no obfuscation |
| Release + Obfuscate | ~20MB | Optimized + obfuscated |
| Release + Obfuscate + R8 | ~15MB | Maximum optimization |

## ✅ Pre-Release Checklist

Before releasing obfuscated build:

- [ ] Test on multiple devices (Android 5+, iOS 12+)
- [ ] Verify all features work
- [ ] Check crashlytics integration
- [ ] Backup debug symbols
- [ ] Document build version and symbols location
- [ ] Test app updates work correctly
- [ ] Verify in-app purchases (if any)
- [ ] Test push notifications
- [ ] Verify analytics tracking

## 🚨 Common Issues

### Issue: App crashes on startup
**Solution:** Check ProGuard rules, ensure models are kept

### Issue: Reflection not working
**Solution:** Add `-keep` rules for classes using reflection

### Issue: Can't deobfuscate crashes
**Solution:** Ensure debug symbols are uploaded to Firebase

### Issue: App size still large
**Solution:** Enable R8 full mode, check for unused dependencies

## 📚 Resources

- [Flutter Obfuscation Docs](https://docs.flutter.dev/deployment/obfuscate)
- [ProGuard Manual](https://www.guardsquare.com/manual/home)
- [R8 Documentation](https://developer.android.com/studio/build/shrink-code)

## 🔐 Security Checklist

Obfuscation is just ONE layer of security. Also implement:

- [ ] API key management (.env)
- [ ] Certificate pinning
- [ ] Secure storage for sensitive data
- [ ] Input validation & sanitization
- [ ] HTTPS only
- [ ] No hardcoded secrets
- [ ] Regular security audits

---

**Last Updated:** December 16, 2025
**Flutter Version:** 3.10.4+
**Target SDK:** Android 13+, iOS 12+
