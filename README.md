# 💱🌡️ Currency & Temperature Converter Mobile App

A comprehensive Flutter multi-platform application for currency and temperature conversions with advanced features including GPS-based currency detection, conversion history, and customizable settings.

## ✨ Features

### Core Functionality
- **Currency Converter**: Support for 15 major currencies with real-time exchange rates (ExchangeRate-API)
- **Temperature Converter**: Convert between Celsius, Fahrenheit, Kelvin, and Reamur
- **Real-time Conversion**: Instant results as you type with input validation
- **Conversion History**: Save and manage your conversion history with search, filter, and sort capabilities

### Advanced Features
- **GPS Auto-Detection**: Automatically detect your currency based on GPS location (40+ countries mapped)
- **Haptic Feedback**: Tactile responses for button interactions
- **Share Functionality**: Share conversion results via native share sheet
- **Clipboard Support**: Copy results to clipboard with one tap
- **Theme Support**: Light and dark themes with Material Design 3
- **Responsive Design**: Optimized layouts for mobile, tablet, and desktop

### UI/UX Enhancements
- Hero animations for smooth screen transitions
- Fade animations for conversion results
- Bounce animations for interactive buttons
- Shimmer loading effects during API calls
- Custom typography with Google Fonts
- Clean and intuitive Material Design 3 interface

## 🧪 Testing

The app includes comprehensive test coverage:

### Unit Tests (92 tests - ALL PASSING ✅)
- **Currency Converter**: 13 tests covering conversion logic, exchange rates, and formatting
- **Temperature Converter**: 25 tests for all temperature unit conversions
- **Validators**: 35 tests for input validation and sanitization
- **Data Models**: 19 tests for ConversionHistory model

```bash
# Run all unit tests
flutter test test/unit/

# Run with coverage
flutter test --coverage
```

### Integration Tests
- End-to-end user flow tests covering complete app functionality
- Located in `integration_test/app_test.dart`

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.10.4
- Dart SDK (included with Flutter)
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd currency_temperature_converter_mobile_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📦 Dependencies

All packages used are **100% FREE** and open-source:

- `provider ^6.1.1` - State management
- `http ^1.1.2` - API calls for currency rates
- `shared_preferences ^2.2.2` - Settings persistence
- `hive ^2.2.3` + `hive_flutter ^1.1.0` - Local database for history
- `geolocator ^11.0.0` + `geocoding ^4.0.0` - GPS functionality
- `vibration ^2.0.0` - Haptic feedback
- `share_plus ^12.0.1` - Native share functionality
- `google_fonts ^6.1.0` - Custom typography
- `shimmer ^3.0.0` - Loading animations
- `intl ^0.19.0` - Number and date formatting

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (11.0+)
- ✅ Web (Modern browsers)
- ✅ Windows (10+)
- ✅ macOS (10.14+)
- ✅ Linux (64-bit)

## 🏗️ Architecture

The app follows Clean Architecture principles:

```
lib/
├── core/           # Constants, themes, utilities
├── data/           # Models, repositories, services
├── presentation/   # Providers, screens, widgets
└── routes/         # App routing configuration
```

## 📖 Documentation

For detailed development documentation, see [dokumentasi-pembuatan.md](dokumentasi-pembuatan.md).

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Development

### Running Tests
```bash
# Unit tests only
flutter test test/unit/

# All tests
flutter test

# With coverage
flutter test --coverage
```

### Code Quality
- Zero analyzer warnings
- Follows Flutter best practices
- Clean Architecture implementation
- Comprehensive test coverage

---

Made with ❤️ using Flutter
