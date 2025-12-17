# 🚀 Quick Start: Menggunakan Arsitektur Baru

## ⚡ Setup Cepat (5 Menit)

### 1. Install Dependencies
```bash
flutter pub get
```

Dependencies baru yang ditambahkan:
- `flutter_riverpod: ^2.4.9` - Modern state management
- `get_it: ^7.6.4` - Dependency injection

---

### 2. Update `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // ✨ Setup Dependency Injection
  await setupDependencies();
  
  // ✨ Wrap app dengan ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}
```

**Penjelasan:**
- `setupDependencies()` - Register semua dependencies (services, repositories, use cases)
- `ProviderScope` - Required untuk Riverpod

---

## 📖 Cara Pakai: 3 Pattern Utama

### Pattern 1: Menggunakan Use Case

**Contoh: Convert Currency**

```dart
import 'package:get_it/get_it.dart';

// Get use case dari DI container
final convertUseCase = GetIt.instance<ConvertCurrencyUseCase>();

// Call use case
final result = await convertUseCase(ConvertCurrencyParams(
  amount: 100,
  fromCurrency: 'USD',
  toCurrency: 'EUR',
));

// Handle result dengan fold
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (data) => print('Result: ${data.result}'),
);
```

---

### Pattern 2: Menggunakan Riverpod Provider

**Option A: StatelessWidget → ConsumerWidget**

```dart
// ❌ BEFORE
class CurrencyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ✅ AFTER
class CurrencyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currencyNotifierProvider);
    return Container();
  }
}
```

**Option B: StatefulWidget → ConsumerStatefulWidget**

```dart
// ❌ BEFORE
class CurrencyScreen extends StatefulWidget {
  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ✅ AFTER
class CurrencyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends ConsumerState<CurrencyScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyNotifierProvider);
    return Container();
  }
}
```

---

### Pattern 3: Pattern Matching dengan Switch

**UI berdasarkan State:**

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(currencyNotifierProvider);
  
  return switch (state) {
    CurrencyInitial() => _buildInitialUI(),
    CurrencyLoading() => Center(child: CircularProgressIndicator()),
    CurrencySuccess(:final result, :final toCurrency) => 
      Text('Result: $result $toCurrency'),
    CurrencyError(:final message) => 
      Text('Error: $message', style: TextStyle(color: Colors.red)),
    CurrencyOffline(:final cachedResult) => 
      Text('Cached: $cachedResult (Offline)'),
  };
}
```

**Keuntungan:**
- ✅ Compiler memaksa handle semua state
- ✅ Tidak ada null checks
- ✅ Lebih mudah dibaca

---

## 🎯 Contoh Lengkap: Currency Conversion Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/riverpod/currency_providers.dart';
import '../state/currency_state.dart';

class CurrencyScreen extends ConsumerStatefulWidget {
  const CurrencyScreen({super.key});

  @override
  ConsumerState<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends ConsumerState<CurrencyScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onConvertPressed() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final currencies = ref.read(selectedCurrenciesProvider);
    
    // ✨ Call notifier method
    ref.read(currencyNotifierProvider.notifier).convert(
      amount: amount,
      from: currencies.from,
      to: currencies.to,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✨ Watch state changes
    final state = ref.watch(currencyNotifierProvider);
    final currencies = ref.watch(selectedCurrenciesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Currency selectors
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: currencies.from,
                    items: ['USD', 'EUR', 'GBP', 'JPY', 'IDR']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(selectedCurrenciesProvider.notifier).state =
                            (from: value, to: currencies.to);
                      }
                    },
                  ),
                ),
                const Icon(Icons.arrow_forward),
                Expanded(
                  child: DropdownButton<String>(
                    value: currencies.to,
                    items: ['USD', 'EUR', 'GBP', 'JPY', 'IDR']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(selectedCurrenciesProvider.notifier).state =
                            (from: currencies.from, to: value);
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Convert button
            ElevatedButton(
              onPressed: _onConvertPressed,
              child: const Text('Convert'),
            ),
            
            const SizedBox(height: 24),
            
            // ✨ Result with pattern matching
            switch (state) {
              CurrencyInitial() => const Text('Enter amount to convert'),
              CurrencyLoading() => const CircularProgressIndicator(),
              CurrencySuccess(:final result, :final toCurrency) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${result.toStringAsFixed(2)} $toCurrency',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
              CurrencyError(:final message) => Text(
                  'Error: $message',
                  style: const TextStyle(color: Colors.red),
                ),
              CurrencyOffline(:final cachedResult) => Text(
                  'Cached: ${cachedResult.toStringAsFixed(2)} (Offline)',
                ),
            },
          ],
        ),
      ),
    );
  }
}
```

---

## 📝 Cheat Sheet

### Watch vs Read

```dart
// ✅ watch() - Di build method, auto rebuild
final state = ref.watch(currencyNotifierProvider);

// ✅ read() - Di callbacks, no rebuild
onPressed: () {
  ref.read(currencyNotifierProvider.notifier).convert(...);
}

// ❌ JANGAN watch() di callbacks!
onPressed: () {
  ref.watch(currencyNotifierProvider); // ❌ Wrong!
}
```

### Call Methods

```dart
// Get notifier
final notifier = ref.read(currencyNotifierProvider.notifier);

// Call method
await notifier.convert(amount: 100, from: 'USD', to: 'EUR');
await notifier.refreshRates();
```

### Access Current State

```dart
// Tanpa rebuild
final currentState = ref.read(currencyNotifierProvider);

// Dengan rebuild
final state = ref.watch(currencyNotifierProvider);
```

---

## 🐛 Troubleshooting

### Error: GetIt not registered

```dart
// ❌ Error
final useCase = getIt<ConvertCurrencyUseCase>();
// Error: Object/factory with type ConvertCurrencyUseCase is not registered

// ✅ Solution
// Pastikan setupDependencies() dipanggil di main()
await setupDependencies();
```

### Error: ProviderNotFoundException

```dart
// ❌ Error
final state = ref.watch(currencyNotifierProvider);
// ProviderNotFoundException

// ✅ Solution
// Wrap app dengan ProviderScope
runApp(const ProviderScope(child: MyApp()));
```

### State Tidak Update

```dart
// ❌ Wrong
final state = ref.read(currencyNotifierProvider); // Di build method

// ✅ Correct
final state = ref.watch(currencyNotifierProvider); // Di build method
```

---

## 📚 Referensi Cepat

### Providers yang Tersedia

**Currency:**
- `currencyNotifierProvider` - Currency state & actions
- `currencyAmountProvider` - Current amount value
- `selectedCurrenciesProvider` - Selected from/to currencies

**Temperature:**
- `temperatureNotifierProvider` - Temperature state & actions
- `temperatureInputProvider` - Current temperature input
- `selectedTemperatureUnitProvider` - Selected unit

**History:**
- `conversionHistoryProvider` - All conversion history
- `historyFilterProvider` - Filter history by type

### Use Cases yang Tersedia

```dart
final convertUseCase = getIt<ConvertCurrencyUseCase>();
final getRatesUseCase = getIt<GetExchangeRatesUseCase>();
final saveConversionUseCase = getIt<SaveConversionUseCase>();
final getHistoryUseCase = getIt<GetConversionHistoryUseCase>();
```

---

## 🎓 Langkah Berikutnya

1. ✅ Run `flutter pub get`
2. ✅ Update `main.dart`
3. ✅ Lihat example: `lib/presentation/screens/examples/currency_screen_riverpod_example.dart`
4. 🔄 Migrate 1 screen sebagai POC
5. 🔄 Baca `MIGRATION_GUIDE.md` untuk detail lengkap

---

## 💡 Tips

### Tip 1: Start Small
Mulai dengan migrate 1 screen dulu, jangan langsung semua.

### Tip 2: Keep Old Code
Jangan hapus Provider lama, jalankan parallel dulu sampai yakin.

### Tip 3: Test Thoroughly
Test setiap screen yang sudah dimigrate sebelum lanjut ke screen berikutnya.

### Tip 4: Use DevTools
Install Flutter DevTools untuk debug Riverpod providers.

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 🆘 Need Help?

1. Check `MIGRATION_GUIDE.md` - Comprehensive guide
2. Check `ARCHITECTURE_IMPROVEMENTS_SUMMARY.md` - Technical details
3. Check example: `currency_screen_riverpod_example.dart`
4. Riverpod docs: https://riverpod.dev/
5. GetIt docs: https://pub.dev/packages/get_it

---

**Happy Coding! 🚀**
