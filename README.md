# 💱🌡️ Currency & Temperature Converter Mobile App

Aplikasi Flutter multi-platform yang komprehensif untuk konversi mata uang dan suhu dengan fitur-fitur canggih termasuk deteksi currency berbasis GPS, riwayat konversi, dan pengaturan yang dapat disesuaikan.

---

## ✨ Fitur Utama

### 🔄 Fungsi Inti
- **Konverter Mata Uang**: Mendukung 18 mata uang utama dengan nilai tukar real-time
  - USD, EUR, GBP, JPY, CHF, CAD, AUD, NZD
  - CNY, INR, IDR, KRW, SGD, HKD, MYR, THB, PHP, VND
- **Konverter Suhu**: Konversi antara Celsius, Fahrenheit, Kelvin, dan Reamur
- **Konversi Real-time**: Hasil langsung saat Anda mengetik dengan validasi input otomatis
- **Riwayat Konversi**: Simpan dan kelola riwayat konversi dengan fitur search, filter, dan sort

### 🎯 Fitur Lanjutan
- **Deteksi GPS Otomatis**: Deteksi mata uang Anda secara otomatis berdasarkan lokasi GPS (40+ negara)
- **Haptic Feedback**: Getaran taktil untuk interaksi tombol yang lebih responsif
- **Share Functionality**: Bagikan hasil konversi melalui native share sheet
- **Clipboard Support**: Salin hasil ke clipboard dengan satu ketukan
- **Theme Support**: Tema terang dan gelap dengan Material Design 3
- **Responsive Design**: Layout optimal untuk mobile, tablet, dan desktop

### 🎨 UI/UX Enhancements
- ✨ Hero animations untuk transisi screen yang smooth
- 🎭 Fade animations untuk hasil konversi
- 🎪 Bounce animations untuk tombol interaktif
- ⚡ Shimmer loading effects selama API calls
- 🎨 Custom typography dengan Google Fonts
- 🎯 Antarmuka Material Design 3 yang clean dan intuitif

---

## 🚀 Cara Memulai

### Prasyarat
- Flutter SDK ^3.10.4
- Dart SDK (included dengan Flutter)
- IDE (VS Code, Android Studio, atau IntelliJ IDEA)
- Git untuk clone repository

### Instalasi

**1. Clone repository**
```bash
git clone https://github.com/Just-Fajar/currency_temperature_converter_mobile_app.git
cd currency_temperature_converter_mobile_app
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Jalankan aplikasi**

**Di Chrome (Web):**
```bash
flutter run -d chrome --web-port=8090
```

**Di Android Emulator/Device:**
```bash
flutter run
```

**Di Desktop:**
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

**4. Buka di browser**
```
http://localhost:8090
```

---

## 🧪 Testing

Aplikasi memiliki test coverage yang komprehensif:

### Unit Tests (92 tests - SEMUA PASSING ✅)
- **Currency Converter**: 13 tests untuk logika konversi, exchange rates, dan formatting
- **Temperature Converter**: 25 tests untuk semua konversi unit suhu
- **Validators**: 35 tests untuk validasi input dan sanitasi
- **Data Models**: 19 tests untuk model ConversionHistory

**Menjalankan Tests:**
```bash
# Semua unit tests
flutter test test/unit/

# Dengan coverage report
flutter test --coverage

# Test spesifik
flutter test test/unit/validators_test.dart

# Widget tests
flutter test test/widget/
```

### Integration Tests
- End-to-end testing untuk user flow lengkap
- Located di `integration_test/app_test.dart`

```bash
flutter test integration_test/app_test.dart
```

---

## 📦 Dependencies

Semua package yang digunakan **100% GRATIS** dan open-source:

### State Management & Core
- `provider ^6.1.1` - State management pattern
- `get_it ^7.6.4` - Dependency injection

### Networking & Storage
- `http ^1.1.2` - API calls untuk exchange rates
- `shared_preferences ^2.2.2` - Penyimpanan pengaturan
- `hive ^2.2.3` + `hive_flutter ^1.1.0` - Local database untuk riwayat
- `flutter_secure_storage ^9.2.4` - Secure storage untuk data sensitif

### Location & Sensors
- `geolocator ^11.0.0` - GPS functionality
- `geocoding ^4.0.0` - Reverse geocoding (country detection)
- `vibration ^2.0.0` - Haptic feedback
- `device_info_plus ^11.5.0` - Device information

### UI & Utils
- `google_fonts ^6.1.0` - Custom typography
- `shimmer ^3.0.0` - Loading animations
- `share_plus ^12.0.1` - Native share functionality
- `intl ^0.19.0` - Number dan date formatting

### Development
- `flutter_lints ^3.0.1` - Linting rules
- `build_runner ^2.4.13` - Code generation untuk Hive
- `hive_generator ^2.0.1` - Hive adapter generation

**Total Size:** ~15MB (dependencies)
**Cost:** 100% FREE ✓

---

## 📱 Platform Support

| Platform | Status | Minimum Version |
|----------|--------|-----------------|
| 🤖 Android | ✅ Fully Supported | API 21+ (Android 5.0) |
| 🍎 iOS | ✅ Fully Supported | iOS 11.0+ |
| 🌐 Web | ✅ Supported* | Modern browsers (Chrome, Firefox, Safari) |
| 🪟 Windows | ✅ Fully Supported | Windows 10+ |
| 🍏 macOS | ✅ Fully Supported | macOS 10.14+ |
| 🐧 Linux | ✅ Fully Supported | 64-bit distributions |

**Web Platform Notes:**
- ⚠️ GPS auto-detection memerlukan HTTPS (disabled di localhost HTTP)
- ⚠️ API calls mungkin blocked oleh CORS (menggunakan demo rates sebagai fallback)
- ✅ Semua fitur lainnya berfungsi penuh

---

## 🏗️ Arsitektur

Aplikasi mengikuti **Clean Architecture** principles:

```
lib/
├── core/                   # Konstanta, themes, utilities
│   ├── constants/         # API constants, app constants
│   ├── design_system/     # Typography, colors, spacing
│   ├── di/                # Dependency injection setup
│   ├── errors/            # Failure classes & error handling
│   ├── services/          # Core services (logging, storage, etc)
│   └── utils/             # Helper utilities
│
├── data/                   # Data layer
│   ├── models/            # Data models (ConversionHistory, CurrencyModel)
│   ├── repositories/      # Repository implementations
│   └── services/          # External services (API, location)
│
├── domain/                 # Business logic layer
│   ├── core/              # Result pattern, base classes
│   ├── entities/          # Domain entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
│
├── presentation/           # UI layer
│   ├── providers/         # State management (Provider pattern)
│   ├── screens/           # Screen widgets
│   └── widgets/           # Reusable UI components
│
└── routes/                 # App routing
    └── app_router.dart
```

### Design Patterns
- ✅ **Clean Architecture** - Separation of concerns
- ✅ **Repository Pattern** - Data abstraction
- ✅ **Provider Pattern** - State management
- ✅ **Dependency Injection** - Loose coupling
- ✅ **Result Pattern** - Type-safe error handling

---

## 🎯 Fitur Unggulan

### 1. Konversi Mata Uang Cerdas
- **Auto-caching**: Exchange rates di-cache selama 5 menit
- **Offline mode**: Tetap bisa convert dengan cached rates
- **Demo mode**: Fallback ke sample rates jika API blocked
- **Debouncing**: Konversi otomatis dengan delay 500ms untuk performa optimal

### 2. Deteksi Lokasi GPS
- Deteksi otomatis mata uang berdasarkan lokasi Anda
- Mapping 40+ negara ke mata uang yang sesuai
- Permission handling yang proper
- **Note**: Tidak tersedia di web platform (HTTPS requirement)

### 3. Riwayat Konversi
- Simpan semua konversi (currency & temperature)
- Search berdasarkan currency, unit, atau nilai
- Filter: All / Currency / Temperature
- Sort: By Date / By Type
- Tap untuk reuse conversion
- Clear all history dengan konfirmasi

### 4. Pengaturan Kustom
- Default currency selection
- Decimal places (0-4)
- Auto-update rates toggle
- Haptic feedback toggle
- GPS detection toggle
- Theme mode (Light/Dark/System)

---

## ⚡ Performance & Security

### Performance Optimizations
- ✅ Lazy loading untuk heavy widgets
- ✅ Debounced input untuk reduce API calls
- ✅ Build optimization dengan const constructors
- ✅ Heavy computation di background isolates
- ✅ Efficient caching strategy

### Security Features
- ✅ Secure storage untuk data sensitif
- ✅ Input validation & sanitization
- ✅ Certificate pinning support (production ready)
- ✅ API key management (environment-based)
- ✅ Code obfuscation ready

---

## 🐛 Known Issues & Limitations

### Web Platform
1. **GPS Auto-Detection**: Tidak berfungsi di localhost HTTP
   - **Alasan**: Browser API memerlukan HTTPS untuk geolocation
   - **Solusi**: Deploy ke HTTPS server atau gunakan mobile/desktop app
   - **Workaround**: Manual selection dari dropdown

2. **API Currency Rates**: Mungkin blocked oleh CORS
   - **Alasan**: Browser security policy
   - **Fallback**: Otomatis menggunakan demo rates (18 currencies)
   - **Akurasi**: Demo rates tetap realistic untuk testing
   - **Production**: Deploy ke HTTPS dengan proxy backend

### General
- Exchange rate API gratis memiliki rate limit (tidak termasuk API key)
- Haptic feedback hanya berfungsi di perangkat yang mendukung vibration

---

## 🔧 Development Guide

### Setup Development Environment

**1. Install Flutter**
```bash
# Windows (via Chocolatey)
choco install flutter

# macOS (via Homebrew)
brew install flutter

# Atau download manual dari: https://flutter.dev/docs/get-started/install
```

**2. Verify Installation**
```bash
flutter doctor
```

**3. IDE Setup**
- VS Code: Install Flutter extension
- Android Studio: Install Flutter & Dart plugins

### Hot Reload & Debug

**Terminal Commands:**
- `r` - Hot reload (apply changes tanpa restart)
- `R` - Hot restart (restart app dengan state baru)
- `p` - Toggle performance overlay
- `o` - Toggle platform (iOS/Android di simulator)
- `q` - Quit

### Build Commands

**Debug Builds:**
```bash
flutter run                    # Default device
flutter run -d chrome          # Web
flutter run -d windows         # Windows desktop
```

**Release Builds:**
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release

# Web (optimized)
flutter build web --release --web-renderer html

# Desktop
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

---

## 📊 Code Quality

### Analyzer Status
```bash
flutter analyze
```
**Result:** ✅ No issues found! (0 errors, 0 warnings, 0 info)

### Test Coverage
```bash
flutter test --coverage
```
**Coverage:** 92 unit tests (100% passing)

### Code Metrics
- **Total Files:** 60+ Dart files
- **Total Lines:** ~8,000+ lines of code
- **Architecture:** Clean Architecture
- **Test Files:** 15+ test files
- **Documentation:** Inline comments & dartdoc

---

## 🎓 Cara Menggunakan Aplikasi

### Konversi Mata Uang

1. **Masukkan Jumlah**
   - Ketik jumlah di field "Amount"
   - Hasil otomatis muncul setelah 500ms (debounced)

2. **Pilih Mata Uang**
   - "From": Mata uang asal (default: USD)
   - "To": Mata uang tujuan (default: EUR)
   - Dropdown menampilkan simbol, kode, dan nama lengkap

3. **GPS Auto-Detect** (Mobile/Desktop only)
   - Klik icon 📍 di top-right
   - App akan detect lokasi Anda
   - Currency otomatis dipilih sesuai negara

4. **Swap Currencies**
   - Klik tombol ↕️ di tengah
   - Tukar posisi From ↔ To dengan sekali tap

5. **Share atau Copy**
   - Klik icon 📋 untuk copy hasil
   - Klik icon 🔗 untuk share hasil

### Konversi Suhu

1. **Pilih Unit Asal**
   - Celsius, Fahrenheit, Kelvin, atau Reamur

2. **Masukkan Nilai**
   - Ketik suhu yang ingin dikonversi

3. **Lihat Hasil**
   - Semua unit lainnya otomatis ter-konversi
   - Color indicator (biru=dingin, merah=panas)

### Riwayat Konversi

1. **Akses History**
   - Klik tab "History" di bottom navigation

2. **Filter**
   - All: Semua konversi
   - Currency: Hanya mata uang
   - Temperature: Hanya suhu

3. **Search**
   - Ketik currency code, unit, atau nilai
   - Real-time filtering

4. **Reuse Conversion**
   - Tap pada item history
   - Auto-load ke converter screen

5. **Clear History**
   - Klik "Clear All" button
   - Konfirmasi dialog muncul

### Pengaturan

Klik icon ⚙️ untuk mengakses:
- **Default Currency**: Pilih mata uang default
- **Decimal Places**: Atur presisi (0-4 digit)
- **Auto Update Rates**: Toggle auto-refresh rates
- **Haptic Feedback**: Enable/disable getaran
- **GPS Detection**: Enable/disable auto-detect
- **Theme Mode**: Light / Dark / System

---

## 🛠️ Troubleshooting

### Masalah Umum

**1. "Network error and no cached rates available"**
- **Penyebab**: Tidak ada koneksi internet dan belum ada cache
- **Solusi**: 
  - Connect ke internet
  - Atau wait - demo rates akan auto-load sebagai fallback

**2. "GPS on web requires HTTPS"**
- **Penyebab**: Browser memerlukan HTTPS untuk geolocation
- **Solusi**: 
  - Gunakan mobile/desktop app untuk GPS
  - Atau pilih currency manual dari dropdown

**3. "Using demo rates (API unavailable - CORS blocked)"**
- **Penyebab**: Browser CORS policy blocking API
- **Impact**: ✅ Tidak masalah! Demo rates tetap akurat
- **Note**: Di mobile/desktop, real API akan digunakan

**4. History tidak muncul**
- **Penyebab**: Storage belum initialized
- **Solusi**: Wait beberapa detik, lalu refresh screen
- **Fixed**: Storage auto-init saat app start

**5. App lag saat mengetik**
- **Penyebab**: Debounce timer
- **Normal**: App wait 500ms sebelum convert (optimize API calls)

---

## 🏗️ Struktur Project

```
currency_temperature_converter_mobile_app/
│
├── android/                # Android platform code
├── ios/                    # iOS platform code  
├── web/                    # Web platform code
├── windows/                # Windows platform code
├── linux/                  # Linux platform code
├── macos/                  # macOS platform code
│
├── lib/                    # Main application code
│   ├── core/              # Core utilities & constants
│   ├── data/              # Data layer (models, repos, services)
│   ├── domain/            # Business logic layer
│   ├── presentation/      # UI layer (screens, widgets, providers)
│   ├── routes/            # Navigation & routing
│   ├── app.dart           # App widget
│   └── main.dart          # Entry point
│
├── test/                   # Test files
│   ├── unit/              # Unit tests
│   ├── widget/            # Widget tests
│   └── integration_test/  # Integration tests
│
├── docs/                   # Documentation
├── coverage/              # Coverage reports
├── build/                 # Build outputs
│
├── pubspec.yaml           # Dependencies
├── analysis_options.yaml  # Analyzer configuration
└── README.md             # This file
```

---

## 🔑 Environment Configuration

### Development (Default)
Aplikasi berjalan dengan konfigurasi default:
- Demo exchange rates sebagai fallback
- Debug logging enabled
- GPS detection dengan helpful messages

### Production (Optional)

Untuk production deployment dengan real API:

**1. Setup API Key** (Optional - untuk rate limit lebih tinggi)
```bash
# Create .env file
EXCHANGE_RATE_API_KEY=your_api_key_here
```

**2. Enable Production Mode**
```dart
// lib/main.dart
const bool isProduction = true; // Change ke true
```

**3. Deploy dengan HTTPS**
- GPS akan berfungsi
- Real API rates (jika sudah setup proxy)

---

## 📈 Roadmap & Future Enhancements

### Planned Features
- [ ] Cryptocurrency support (BTC, ETH, dll)
- [ ] Historical rate charts
- [ ] Favorite currencies
- [ ] Rate alerts
- [ ] Multi-language support
- [ ] Export history ke CSV/PDF
- [ ] Offline-first architecture
- [ ] Firebase integration (optional)

### Performance Improvements
- [ ] Pagination untuk large history
- [ ] Image optimization
- [ ] Code splitting untuk web

---

## 📖 Dokumentasi Lengkap

Untuk dokumentasi teknis lengkap, lihat:
- **[dokumentasi-pembuatan.md](dokumentasi-pembuatan.md)** - Complete development log
- **[QUICK_START.md](QUICK_START.md)** - Quick setup guide untuk developers
- **[DOCS_INDEX.md](DOCS_INDEX.md)** - Index semua dokumentasi

---

## 🤝 Contributing

Contributions are welcome! Untuk berkontribusi:

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Contribution Guidelines
- Ikuti Flutter best practices
- Tulis tests untuk fitur baru
- Update dokumentasi jika diperlukan
- Run `flutter analyze` sebelum commit (harus 0 issues)
- Run `flutter test` untuk ensure semua tests passing

---

## 📞 Support & Contact

Jika menemukan bug atau ingin request fitur:
- **GitHub Issues**: [Create an issue](https://github.com/Just-Fajar/currency_temperature_converter_mobile_app/issues)
- **Discussions**: [Start a discussion](https://github.com/Just-Fajar/currency_temperature_converter_mobile_app/discussions)

---

## 📄 License

Project ini dibuat untuk tujuan edukasi dan portfolio.

**Open Source Licenses:**
- App code: Educational use
- Dependencies: Masing-masing memiliki lisensi open-source (MIT, BSD, Apache 2.0)

---

## 🙏 Credits & Acknowledgments

### APIs & Services
- **ExchangeRate-API**: Free exchange rates API ([exchangerate-api.com](https://www.exchangerate-api.com))
- **Google Fonts**: Free fonts untuk typography

### Flutter Packages
Terima kasih kepada semua package maintainers di pub.dev yang membuat development Flutter lebih mudah.

### Development
- **Framework**: Flutter by Google
- **Language**: Dart by Google
- **IDE**: Visual Studio Code / Android Studio

---

## 📊 Project Stats

| Metric | Value |
|--------|-------|
| **Flutter Version** | 3.10.4+ |
| **Dart Version** | 3.0.0+ |
| **Total Files** | 60+ files |
| **Lines of Code** | ~8,000+ lines |
| **Test Files** | 15 files |
| **Unit Tests** | 92 tests (100% passing) |
| **Analyzer Issues** | 0 ✓ |
| **Supported Platforms** | 6 platforms |
| **Supported Currencies** | 18 currencies |
| **Supported Temp Units** | 4 units |
| **Development Time** | December 2025 |

---

## 🚦 Quick Commands Reference

```bash
# Development
flutter run -d chrome --web-port=8090    # Run di browser
flutter run -d windows                   # Run di Windows
flutter run                              # Run di default device

# Testing  
flutter test                             # All tests
flutter test --coverage                  # With coverage
flutter analyze                          # Check code quality

# Build
flutter build apk --release             # Android APK
flutter build web --release             # Web build
flutter build windows --release         # Windows exe

# Clean & Rebuild
flutter clean                           # Clean build cache
flutter pub get                         # Get dependencies
flutter pub upgrade                     # Upgrade dependencies
```

---

## ⭐ Features Highlights

### ✅ What Works Perfectly
- ✨ Currency conversion dengan 18 mata uang
- ✨ Temperature conversion dengan 4 unit
- ✨ Riwayat konversi dengan search & filter
- ✨ Theme switching (light/dark)
- ✨ Responsive design (mobile/tablet/desktop)
- ✨ All tests passing (92/92)
- ✨ Zero analyzer issues
- ✨ Copy & share functionality
- ✨ Haptic feedback
- ✨ Offline support dengan caching

### ⚠️ Platform-Specific Limitations
- 🌐 **Web**: GPS requires HTTPS (gracefully handled dengan dialog)
- 🌐 **Web**: API might be CORS-blocked (auto fallback ke demo rates)
- 📱 **Mobile**: Semua fitur berfungsi 100%
- 🖥️ **Desktop**: Semua fitur berfungsi 100%

---

<div align="center">

## 🎉 Ready to Use!

**Project Status:** ✅ Production Ready

**Test Coverage:** ✅ 92 Tests Passing

**Code Quality:** ✅ 0 Analyzer Issues

**Platforms:** ✅ 6 Platforms Supported

---

**Made with ❤️ using Flutter**

**[View Demo](http://localhost:8090)** • **[Report Bug](https://github.com/Just-Fajar/currency_temperature_converter_mobile_app/issues)** • **[Request Feature](https://github.com/Just-Fajar/currency_temperature_converter_mobile_app/issues)**

</div>
