# Converter Pro - Currency and Temperature Converter Mobile App

Converter Pro adalah aplikasi mobile multi-platform berbasis Flutter yang dirancang untuk kebutuhan konversi mata uang secara real-time dan konversi suhu multi-satuan dengan presisi tinggi. Aplikasi ini mengintegrasikan arsitektur perangkat lunak Clean Architecture, manajemen state reaktif, penyimpanan lokal berbasis NoSQL, dan fitur deteksi lokasi perangkat berbasis GPS untuk menentukan mata uang asal secara otomatis.

---

## Daftar Isi

1. [Ringkasan Proyek](#ringkasan-proyek)
2. [Spesifikasi Teknis](#spesifikasi-teknis)
3. [Fitur Utama](#fitur-utama)
   - [Konverter Mata Uang](#konverter-mata-uang)
   - [Konverter Suhu](#konverter-suhu)
   - [Deteksi Lokasi GPS Otomatis](#deteksi-lokasi-gps-otomatis)
   - [Manajemen Riwayat Konversi](#manajemen-riwayat-konversi)
   - [Pengaturan dan Preferensi](#pengaturan-dan-preferensi)
4. [Arsitektur Perangkat Lunak](#arsitektur-perangkat-lunak)
   - [Prinsip Clean Architecture](#prinsip-clean-architecture)
   - [Pola Desain](#pola-desain)
   - [Alur Data dan State Management](#alur-data-dan-state-management)
5. [Struktur Direktori Proyek](#struktur-direktori-proyek)
6. [Daftar Dependensi](#daftar-dependensi)
7. [Dukungan Platform](#dukungan-platform)
8. [Prasyarat Sistem](#prasyarat-sistem)
9. [Panduan Instalasi dan Menjalankan Aplikasi](#panduan-instalasi-dan-menjalankan-aplikasi)
   - [Instalasi Dependensi](#instalasi-dependensi)
   - [Menjalankan di Web](#menjalankan-di-web)
   - [Menjalankan di Android](#menjalankan-di-android)
   - [Menjalankan di Desktop](#menjalankan-di-desktop)
10. [Panduan Pengujian](#panduan-pengujian)
    - [Unit Testing](#unit-testing)
    - [Integration Testing](#integration-testing)
    - [Analisis Statis Kode](#analisis-statis-kode)
11. [Panduan Build dan Rilis](#panduan-build-dan-rilis)
    - [Android (APK dan App Bundle)](#android-apk-dan-app-bundle)
    - [Web Production](#web-production)
    - [Desktop Executable](#desktop-executable)
12. [Optimasi Performa dan Keamanan](#optimasi-performa-dan-keamanan)
13. [Batasan Platform dan Solusi](#batasan-platform-dan-solusi)
14. [Panduan Kontribusi](#panduan-kontribusi)
15. [Lisensi dan Pengakuan](#lisensi-dan-pengakuan)

---

## Ringkasan Proyek

Converter Pro dikembangkan untuk memberikan pengalaman konversi nilai yang cepat, akurat, dan dapat diandalkan baik dalam kondisi daring maupun luring. Aplikasi ini mengombinasikan desain antarmuka modern berstandar Material Design 3 dengan logika bisnis yang modular dan mudah diuji.

Informasi Metadata:
- Nama Aplikasi: Converter Pro
- Versi: 1.0.0+1
- Flutter SDK: ^3.10.4
- Dart SDK: ^3.0.0
- Target Platform: Android, iOS, Web, Windows, macOS, Linux

---

## Spesifikasi Teknis

- Bahasa Pemrograman: Dart 3
- Framework: Flutter 3
- Design System: Material Design 3 dengan dukungan tema Terang (Light) dan Gelap (Dark)
- State Management: Provider Pattern didukung Riverpod untuk modern state evaluation
- Local Database: Hive (NoSQL database berkecepatan tinggi)
- Key-Value Storage: SharedPreferences dan FlutterSecureStorage
- Networking: HTTP client dengan caching layer lokal
- Hardware Services: Geolocator, Geocoding, Vibration API

---

## Fitur Utama

### Konverter Mata Uang
- Mendukung 15 mata uang utama dunia:
  - USD (US Dollar)
  - EUR (Euro)
  - GBP (British Pound)
  - JPY (Japanese Yen)
  - CNY (Chinese Yuan)
  - IDR (Indonesian Rupiah)
  - SGD (Singapore Dollar)
  - AUD (Australian Dollar)
  - CAD (Canadian Dollar)
  - CHF (Swiss Franc)
  - INR (Indian Rupee)
  - MYR (Malaysian Ringgit)
  - THB (Thai Baht)
  - KRW (South Korean Won)
  - HKD (Hong Kong Dollar)
- Integrasi ExchangeRate-API dengan pembaruan kurs terkini.
- Mekanisme Debounce 500ms pada pengetikan input untuk mencegah pemanggilan API berulang secara berlebihan.
- Caching layer otomatis dengan masa berlaku 1 jam untuk efisiensi jaringan.
- Mode Offline cerdas: konversi tetap beroperasi memanfaatkan nilai tukar tersimpan di cache lokal atau nilai rujukan bawaan jika koneksi internet terputus.
- Tombol Swap instan untuk menukar mata uang asal dan mata uang tujuan dalam satu ketukan.
- Fitur Salin ke Clipboard dan Berbagi (Native Share Sheet) untuk mendistribusikan hasil konversi ke aplikasi lain.

### Konverter Suhu
- Mendukung konversi empat skala temperatur utama:
  - Celsius (C)
  - Fahrenheit (F)
  - Kelvin (K)
  - Reamur (R)
- Kalkulasi multirarah secara langsung (real-time) saat angka dimasukkan.
- Indikator status visual kontekstual berbasis rentang derajat suhu (dingin, sedang, panas).
- Validasi numerik otomatis termasuk perlindungan terhadap batas nol mutlak (Absolute Zero).

### Deteksi Lokasi GPS Otomatis
- Deteksi koordinat perangkat melalui sensor GPS bawaan.
- Reverse geocoding terintegrasi untuk memetakan negara pengguna (mencakup lebih dari 40 negara).
- Pemilihan mata uang asal otomatis yang relevan dengan lokasi geografis pengguna.
- Penanganan izin lokasi (permission handling) yang komprehensif untuk status izin ditolak, ditolak permanen, maupun saat sensor lokasi dimatikan.

### Manajemen Riwayat Konversi
- Penyimpanan persisten setiap transaksi konversi (mata uang dan suhu) menggunakan Hive NoSQL.
- Pencarian data instan berdasarkan simbol mata uang, satuan suhu, atau nilai angka.
- Filter kategori riwayat: Semua, Mata Uang, dan Suhu.
- Tap to Reuse: Memuat kembali data riwayat masa lalu langsung ke kalkulator konversi yang aktif.
- Batas penyimpanan hingga 100 entri teratas dengan fitur penghapusan massal disertai dialog konfirmasi keamanan.

### Pengaturan dan Preferensi
- Pilihan Mode Tema: Sistem, Terang (Light Mode), dan Gelap (Dark Mode).
- Konfigurasi Mata Uang Default saat aplikasi pertama kali dibuka.
- Pengaturan Presisi Desimal: Fleksibilitas jumlah angka di belakang koma (0 hingga 4 digit desimal).
- Toggle Pembaruan Kurs Otomatis.
- Toggle Haptic Feedback untuk umpan balik getaran taktil saat berinteraksi.
- Toggle Deteksi Lokasi Otomatis saat aplikasi dijalankan.
- Seluruh konfigurasi tersimpan secara persisten melalui SharedPreferences.

---

## Arsitektur Perangkat Lunak

Aplikasi ini menerapkan standar Clean Architecture yang memisahkan tanggung jawab kode ke dalam tiga lapisan utama: Lapisan Presentasi (Presentation), Lapisan Domain (Domain), dan Lapisan Data (Data).

```
+-------------------------------------------------------------+
|                     PRESENTATION LAYER                      |
|   Screens (UI), Reusable Widgets, Providers (State Mgmt)    |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                        DOMAIN LAYER                         |
|   Entities, Use Cases, Repository Contracts, Failures       |
+-------------------------------------------------------------+
                              ^
                              |
+-------------------------------------------------------------+
|                         DATA LAYER                          |
|   Models (DTOs, Hive Adapters), Repository Implementations, |
|   Remote Services (HTTP API), Local Services (Hive, Prefs)  |
+-------------------------------------------------------------+
                              |
+-------------------------------------------------------------+
|                         CORE LAYER                          |
|   Constants, Theme Tokens, Network Config, Helpers, Errors  |
+-------------------------------------------------------------+
```

### Prinsip Clean Architecture
1. Core Layer: Menyimpan konfigurasi global, tema aplikasi, token tipografi, pemetaan rute, penanganan galat dasar, dan kelas pembantu (utilities).
2. Data Layer: Bertanggung jawab atas pengambilan data mentah dari API eksternal dan database lokal Hive. Melakukan parsing JSON ke model data dan implementasi konkret dari antarmuka repositori.
3. Domain Layer: Berisi entitas bisnis murni dan kontrak repositori yang bersifat independen terhadap pustaka eksternal atau kerangka kerja UI.
4. Presentation Layer: Komponen antarmuka pengguna (UI) yang memanfaatkan ChangeNotifier dan Consumer dari paket Provider untuk merender perubahan status secara reaktif.

### Pola Desain
- Repository Pattern: Mengisolasi lapisan data dari logika bisnis sehingga sumber data dapat diganti tanpa merombak lapisan domain atau presentasi.
- Provider Pattern: Mengelola siklus hidup status aplikasi secara reaktif dan hemat alokasi memori.
- Dependency Injection: Memfasilitasi penggantian komponen saat pengujian unit menggunakan get_it atau konstruktor injeksi.
- Result / Failure Pattern: Pendekatan pemodelan kegagalan bertipe ketat untuk menghindari unhandled runtime exceptions.

### Alur Data dan State Management
1. Pengguna memasukkan data pada field input di Presentation Layer.
2. Provider menerima input dan memicu timer debounce 500 milidetik.
3. Setelah debounce selesai, Provider memanggil metode pada Repository.
4. Repository memeriksa validitas cache lokal. Jika cache masih berlaku (kurang dari 1 jam), data lokal langsung dikembalikan. Jika telah kedaluwarsa, permintaan HTTP dikirimkan ke remote API.
5. Hasil konversi dikembalikan ke Provider.
6. Provider memperbarui nilai status (state) dan memanggil notifyListeners().
7. Widgets yang berlangganan melakukan pembaruan tampilan antarmuka secara instan.
8. Data konversi disimpan secara asinkron ke dalam box Hive untuk keperluan riwayat.

---

## Struktur Direktori Proyek

```
currency_temperature_converter_mobile_app/
|-- android/                         # Konfigurasi platform Android native
|-- ios/                             # Konfigurasi platform iOS native
|-- web/                             # Konfigurasi platform Web hosting & PWA
|-- windows/                         # Konfigurasi platform desktop Windows
|-- macos/                           # Konfigurasi platform desktop macOS
|-- linux/                           # Konfigurasi platform desktop Linux
|-- assets/                          # Aset visual aplikasi dan konfigurasi ikon
|   `-- icon/                        # File ikon master aplikasi
|-- integration_test/                # Pengujian integrasi end-to-end
|   `-- app_test.dart                # Pengujian skenario alur pengguna lengkap
|-- lib/                             # Kode sumber utama aplikasi
|   |-- core/                        # Modul inti aplikasi
|   |   |-- accessibility/           # Utilitas aksesibilitas
|   |   |-- animations/              # Utilitas animasi transisi kustom
|   |   |-- config/                  # Konfigurasi runtime
|   |   |-- constants/               # Konstanta API, rute, dan batasan aplikasi
|   |   |-- design_system/           # Token warna, spasi, dan tipografi
|   |   |-- di/                      # Pendaftaran injeksi ketergantungan
|   |   |-- errors/                  # Definisi kelas kesalahan dan kegagalan
|   |   |-- logging/                 # Utilitas pencatatan log
|   |   |-- services/                # Layanan internal dasar
|   |   |-- themes/                  # Konfigurasi tema Light dan Dark
|   |   `-- utils/                   # Fungsi pembantu dan validator
|   |-- data/                        # Lapisan data
|   |   |-- models/                  # Data Transfer Objects dan adapter Hive
|   |   |-- repositories/            # Implementasi konkret repositori
|   |   `-- services/                # Layanan eksternal (API HTTP, GPS, Storage)
|   |-- domain/                      # Lapisan domain
|   |   |-- core/                    # Abstraksi inti domain
|   |   |-- entities/                # Entitas bisnis aplikasi
|   |   |-- failures/                # Objek kegagalan domain
|   |   |-- repositories/            # Kontrak antarmuka repositori
|   |   `-- usecases/                # Kasus penggunaan bisnis
|   |-- presentation/                # Lapisan antarmuka pengguna
|   |   |-- providers/               # Pengelola state aplikasi
|   |   |-- screens/                 # Halaman utama aplikasi
|   |   |   |-- currency_screen.dart     # Halaman konverter mata uang
|   |   |   |-- history_screen.dart      # Halaman riwayat konversi
|   |   |   |-- home_screen.dart         # Halaman kontainer navigasi utama
|   |   |   |-- settings_screen.dart     # Halaman pengaturan preferensi
|   |   |   `-- temperature_screen.dart  # Halaman konverter suhu
|   |   `-- widgets/                 # Komponen antarmuka yang dapat digunakan ulang
|   |-- routes/                      # Manajemen rute navigasi aplikasi
|   |   `-- app_router.dart          # Router terpusat
|   |-- app.dart                     # Konfigurasi root widget MaterialApp
|   `-- main.dart                    # Titik masuk eksekusi (entry point) aplikasi
|-- test/                            # Rangkaian pengujian perangkat lunak
|   |-- unit/                        # Pengujian logika unit bisnis
|   |   |-- currency_converter_test.dart
|   |   |-- models_test.dart
|   |   |-- temperature_converter_test.dart
|   |   `-- validators_test.dart
|   `-- widget/                      # Pengujian komponen widget UI
|-- .env.example                     # Contoh template variabel lingkungan
|-- analysis_options.yaml            # Konfigurasi linter statis analyzer
|-- pubspec.yaml                     # Manifest dependensi dan metadata proyek
`-- README.md                        # Dokumentasi teknis proyek
```

---

## Daftar Dependensi

Seluruh paket dependensi yang digunakan berlisensi sumber terbuka (open-source) dan dapat digunakan secara bebas:

| Kategori | Paket | Versi | Fungsi Utama |
|---|---|---|---|
| State Management | provider | ^6.1.1 | Pengelolaan status reaktif pada antarmuka |
| State Management | flutter_riverpod | ^3.0.3 | Framework manajemen state alternatif |
| Dependency Injection | get_it | ^7.6.4 | Service locator untuk pemisahan ketergantungan |
| Dependency Injection | injectable | ^2.7.1 | Generator kode injeksi dependensi otomatis |
| Networking | http | ^1.1.2 | Eksekusi permintaan protokol HTTP ke API |
| Local Database | hive | ^2.2.3 | Database NoSQL lokal berkecepatan tinggi |
| Local Database | hive_flutter | ^1.1.0 | Integrasi siklus hidup Hive untuk Flutter |
| Persistence | shared_preferences | ^2.2.2 | Penyimpanan preferensi pengguna berbasis key-value |
| Persistence | flutter_secure_storage | ^9.2.4 | Enkripsi data lokal sensitif pada penyimpanan aman |
| Geolocation | geolocator | ^11.0.0 | Pengambilan koordinat posisi perangkat (GPS) |
| Geolocation | geocoding | ^4.0.0 | Pemetaan koordinat lintang/bujur ke nama negara |
| Device Hardware | vibration | ^3.1.5 | Akses motor haptic untuk getaran taktil responsif |
| Device Hardware | device_info_plus | ^12.3.0 | Ekstraksi informasi perangkat keras dan OS |
| UI & Formatting | google_fonts | ^6.1.0 | Tipografi dinamis dan rendering font modern |
| UI & Formatting | shimmer | ^3.0.0 | Animasi shimmering selama pemuatan data asinkron |
| UI & Formatting | share_plus | ^12.0.1 | Pemanggilan native sharing sheet sistem operasi |
| UI & Formatting | intl | ^0.19.0 | Format desimal, mata uang, dan tanggal lokal |
| Code Generation | build_runner | ^2.4.13 | Orkestrasi otomatis generator kode Dart |
| Code Generation | hive_generator | ^2.0.1 | Pembuatan TypeAdapter persisten untuk Hive |
| Linter & Quality | flutter_lints | ^3.0.1 | Rangkaian aturan analisis statis resmi Flutter |

---

## Dukungan Platform

| Platform | Status Dukungan | Versi Minimum | Catatan Khusus |
|---|---|---|---|
| Android | Didukung Penuh | Android 5.0 (API 21+) | Seluruh fitur GPS, Haptic, dan API berjalan optimal |
| iOS | Didukung Penuh | iOS 11.0+ | Memerlukan izin Info.plist untuk akses lokasi |
| Web | Didukung dengan Catatan | Browser modern (Chrome, Safari, Firefox, Edge) | GPS memerlukan HTTPS. Panggilan API langsung di localhost menggunakan fallback demo rates jika terhalang CORS |
| Windows | Didukung Penuh | Windows 10 x64 atau lebih baru | Native desktop build |
| macOS | Didukung Penuh | macOS 10.14 Mojave atau lebih baru | Native desktop build |
| Linux | Didukung Penuh | Ubuntu 20.04 LTS atau distribusi setara | Native desktop build (GTK+ 3.0) |

---

## Prasyarat Sistem

Sebelum melakukan instalasi dan kompilasi aplikasi, pastikan perangkat kerja Anda telah memenuhi prasyarat berikut:

1. Flutter SDK versi 3.10.4 atau yang lebih baru.
2. Dart SDK versi 3.0.0 atau yang lebih baru (terpasang otomatis bersama Flutter).
3. Git command-line tools.
4. Editor kode yang disarankan:
   - Visual Studio Code dengan ekstensi resmi Flutter dan Dart.
   - Android Studio dengan Android SDK Command-line Tools dan Android Emulator.
5. Kompiler platform lokal (opsional untuk build desktop):
   - Windows: Visual Studio 2022 dengan komponen Desktop development with C++.
   - macOS: Xcode 14 atau lebih baru beserta CocoaPods.
   - Linux: Clang, CMake, Ninja build, dan pustaka GTK development.

Jalankan perintah verifikasi kesiapan sistem:
```bash
flutter doctor
```
Pastikan seluruh status bertanda checklist tanpa isu kritis yang belum terselesaikan.

---

## Panduan Instalasi dan Menjalankan Aplikasi

### 1. Klon Repositori
Buka terminal dan unduh kode sumber proyek:
```bash
git clone https://github.com/Just-Fajar/currency_temperature_converter_mobile_app.git
cd currency_temperature_converter_mobile_app
```

### 2. Instalasi Dependensi
Jalankan pengunduhan pustaka dependensi pihak ketiga:
```bash
flutter pub get
```

Jika terjadi perubahan pada skema model Hive atau dependensi code-generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Menjalankan di Web
Untuk menjalankan pada browser Google Chrome:
```bash
flutter run -d chrome --web-port=8090
```
Setelah proses kompilasi selesai, buka browser pada alamat:
```
http://localhost:8090
```

### 4. Menjalankan di Android
Pastikan perangkat Android fisik terhubung dengan mode USB Debugging aktif, atau Android Emulator sedang berjalan:
```bash
# Menampilkan daftar perangkat yang terdeteksi
flutter devices

# Menjalankan aplikasi ke perangkat yang aktif
flutter run
```

### 5. Menjalankan di Desktop
Jalankan target desktop sesuai sistem operasi Anda:

Untuk Windows:
```bash
flutter run -d windows
```

Untuk macOS:
```bash
flutter run -d macos
```

Untuk Linux:
```bash
flutter run -d linux
```

---

## Panduan Pengujian

Converter Pro menerapkan pengujian otomatis berlapis untuk menjamin keandalan fungsional, integritas kalkulasi matematis, dan kestabilan antarmuka pengguna.

### Unit Testing
Rangkaian unit test mencakup pengujian menyeluruh terhadap 92 skenario logika bisnis yang terbagi ke dalam empat berkas utama:
- `test/unit/currency_converter_test.dart` (13 pengujian): Menguji logika pertukaran valuta, penanganan desimal, validasi rasio kurs, dan mekanisme pembulatan.
- `test/unit/temperature_converter_test.dart` (25 pengujian): Menguji seluruh kombinasi konversi timbal-balik antara Celsius, Fahrenheit, Kelvin, dan Reamur, termasuk titik didih, titik beku, dan batas Absolute Zero (-273.15 C).
- `test/unit/validators_test.dart` (35 pengujian): Menguji sanitasi masukan pengguna, pembatasan karakter ilegal, angka negatif, titik desimal berulang, dan penanganan nilai kosong.
- `test/unit/models_test.dart` (19 pengujian): Menguji serialisasi dan deserialisasi model data, adapter Hive, serta keutuhan entitas ConversionHistory.

Perintah menjalankan unit test:
```bash
# Menjalankan seluruh pengujian unit
flutter test test/unit/

# Menjalankan pengujian dengan metrik cakupan kode (coverage)
flutter test --coverage

# Menjalankan salah satu berkas pengujian secara terisolasi
flutter test test/unit/validators_test.dart
```

### Integration Testing
Pengujian integrasi end-to-end terletak pada `integration_test/app_test.dart` untuk memverifikasi alur interaksi nyata pengguna dari halaman konversi hingga penyimpanan riwayat:
```bash
flutter test integration_test/app_test.dart
```

### Analisis Statis Kode
Proyek ini mematuhi standar penulisan kode resmi Flutter dengan konfigurasi linter ketat pada `analysis_options.yaml`:
```bash
flutter analyze
```
Hasil analisis kode harus menunjukkan:
```
No issues found!
```

---

## Panduan Build dan Rilis

### Android (APK dan App Bundle)

1. Menghasilkan berkas APK Release:
```bash
flutter build apk --release
```
Lokasi keluaran berkas:
`build/app/outputs/flutter-apk/app-release.apk`

2. Menghasilkan berkas Android App Bundle (AAB) untuk Google Play Store:
```bash
flutter build appbundle --release
```
Lokasi keluaran berkas:
`build/app/outputs/bundle/release/app-release.aab`

3. Menghasilkan APK per-arsitektur CPU (opsional untuk meminimalkan ukuran file instalasi):
```bash
flutter build apk --release --split-per-abi
```

### Web Production
Kompilasi build statis untuk produksi web dengan optimasi renderer:
```bash
flutter build web --release --web-renderer canvaskit
```
Keluaran berkas statis siap diunggah ke server hosting atau layanan CDN seperti Cloudflare Pages, Firebase Hosting, atau Vercel melalui direktori `build/web/`.

### Desktop Executable
Kompilasi paket biner desktop untuk distribusi lokal:

- Windows:
```bash
flutter build windows --release
```
Hasil keluaran biner: `build/windows/x64/runner/Release/`

- macOS:
```bash
flutter build macos --release
```
Hasil keluaran aplikasi: `build/macos/Build/Products/Release/`

- Linux:
```bash
flutter build linux --release
```
Hasil keluaran biner: `build/linux/x64/release/bundle/`

---

## Optimasi Performa dan Keamanan

### Optimasi Performa
- Input Debouncing: Input pengguna dijeda dengan durasi 500 milidetik sebelum memanggil fungsi kalkulasi atau permintaan jaringan, mencegah pemborosan beban pemrosesan dan penggunaan kuota API.
- Local Storage Fast I/O: Penggunaan Hive berbasis binary storage NoSQL memastikan operasi baca-tulis riwayat konversi berjalan tanpa mengganggu kelancaran framerate antarmuka (60/120 FPS).
- Const Constructor Enforcement: Komponen widget stateless menggunakan deklarasi konstan (`const`) secara konsisten guna meminimalkan siklus rebuild yang tidak dibutuhkan pada widget tree.
- Lazy Initialization: Inisialisasi adapter database dan preferensi dilakukan secara asinkron di awal pemanggilan aplikasi dengan mekanisme FutureBuilder fallback.

### Keamanan Data
- Local Data Isolation: Riwayat konversi disimpan secara lokal pada perangkat pengguna tanpa pengiriman data pribadi ke server pihak ketiga.
- Input Sanitization: Setiap masukan teks melalui proses sanitasi dan regex validator ketat untuk mencegah anomali tipe data angka dan pembagian dengan nol.
- Secure Preferences Ready: Mendukung penyimpanan berbasis FlutterSecureStorage untuk token atau kunci rahasia masa depan dengan enkripsi Keychain (iOS) dan Keystore (Android).

---

## Batasan Platform dan Solusi

### 1. Geolocation pada Lingkungan Web
- Masalah: Browser modern membatasi akses Geolocation API jika aplikasi diakses melalui protokol HTTP biasa.
- Solusi: Pada mode pengetesan lokal tanpa HTTPS, aplikasi menyediakan dialog informatif dan mengarahkan pengguna untuk memilih mata uang secara manual dari daftar dropdown. Pada rilis produksi web, implementasikan sertifikat SSL/TLS (HTTPS).

### 2. Kebijakan CORS pada Web Browser
- Masalah: Permintaan langsung ke API valuta asing dari peramban web dapat diblokir oleh Cross-Origin Resource Sharing (CORS) policy.
- Solusi: Aplikasi dilengkapi mekanisme fallback cerdas yang secara otomatis menggunakan nilai kurs rujukan (cached demo rates) jika permintaan jaringan gagal akibat hambatan CORS. Pada platform native (Android, iOS, Windows, macOS, Linux), pembatasan CORS tidak berlaku sehingga pembaruan kurs berjalan langsung secara normal.

### 3. Ketersediaan Fitur Haptic Feedback
- Masalah: Motor penggetar fisik hanya tersedia pada ponsel pintar atau tablet tertentu.
- Solusi: Modul haptic membungkus pemanggilan Vibration API dalam pengecekan kompatibilitas hardware (`Vibration.hasVibrator()`). Jika perangkat tidak memiliki motor getar (misalnya PC desktop standar), aplikasi tetap beroperasi secara normal tanpa menimbulkan galat.

---

## Panduan Kontribusi

Kontribusi pada pengembangan proyek Converter Pro sangat diapresiasi. Silakan ikuti alur kerja berikut:

1. Lakukan Fork pada repositori ini.
2. Buat branch fitur baru dari branch utama (`main`):
   ```bash
   git checkout -b feature/nama-fitur-baru
   ```
3. Lakukan perubahan kode sesuai panduan arsitektur dan konvensi Clean Architecture.
4. Pastikan kode memenuhi standar analisis statis dan seluruh pengujian lolos:
   ```bash
   flutter analyze
   flutter test test/unit/
   ```
5. Buat commit terstruktur dengan pesan yang jelas:
   ```bash
   git commit -m "feat: tambahkan validasi presisi desimal kustom"
   ```
6. Dorong branch Anda ke repositori remote:
   ```bash
   git push origin feature/nama-fitur-baru
   ```
7. Buat Pull Request (PR) ke branch `main` dengan menyertakan deskripsi perubahan yang komprehensif.

---

## Lisensi dan Pengakuan

### Lisensi
Proyek ini dibuat dan dikembangkan untuk keperluan akademik, portofolio rekayasa perangkat lunak, dan edukasi. Setiap pustaka pihak ketiga yang digunakan dalam proyek ini tetap tunduk pada ketentuan lisensi masing-masing (MIT, BSD-3-Clause, Apache 2.0).

### Pengakuan Sumber Daya
- ExchangeRate-API: Penyedia data kurs mata uang global (https://www.exchangerate-api.com).
- Google Fonts: Penyedia tipografi digital berstandar terbuka.
- Flutter & Dart Team: Kerangka kerja aplikasi multi-platform oleh Google.
- Kontributor Komunitas Open Source: Pengembang dan pemelihara paket di pub.dev.

---

Converter Pro - Dikembangkan dengan standar arsitektur perangkat lunak yang bersih, teruji, dan siap pakai.
