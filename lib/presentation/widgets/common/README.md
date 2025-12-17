# 🎨 Reusable Components

## Overview

Library komponen reusable untuk konsistensi UI dan efisiensi development.

---

## 📦 Available Components

### 1. Buttons (buttons.dart)

#### PrimaryButton
```dart
PrimaryButton(
  label: 'Convert',
  icon: Icons.swap_horiz,
  onPressed: () => convert(),
  isLoading: state.isLoading,
  isFullWidth: true,
  size: ButtonSize.medium,
)
```

**Features:**
- Loading state dengan spinner
- Optional icon
- 3 size variants (small, medium, large)
- Full width option
- Consistent Material Design 3 styling

#### SecondaryButton
```dart
SecondaryButton(
  label: 'Cancel',
  icon: Icons.close,
  onPressed: () => Navigator.pop(context),
)
```

**Features:**
- Outlined style
- Same options sebagai PrimaryButton

#### TextButtonCustom
```dart
TextButtonCustom(
  label: 'Learn More',
  icon: Icons.arrow_forward,
  onPressed: () => showInfo(),
)
```

#### IconButtonCustom
```dart
IconButtonCustom(
  icon: Icons.share,
  onPressed: () => share(),
  tooltip: 'Share',
  backgroundColor: Colors.blue,
)
```

---

### 2. Text Fields (text_fields.dart)

#### CustomTextField
```dart
CustomTextField(
  label: 'Amount',
  hint: 'Enter amount',
  controller: controller,
  prefixIcon: Icons.attach_money,
  validator: (value) => Validators.validateAmount(value),
  onChanged: (value) => updateAmount(value),
)
```

**Features:**
- Consistent Material Design 3 styling
- Built-in validation
- Prefix/suffix icons
- Helper text & error text
- Character counter

#### NumberTextField
```dart
NumberTextField(
  label: 'Amount',
  controller: controller,
  allowDecimal: true,
  allowNegative: false,
  maxLength: 10,
)
```

**Features:**
- Number-only input
- Decimal support
- Negative number support
- Auto-formatting

#### CurrencyTextField
```dart
CurrencyTextField(
  label: 'Amount',
  controller: controller,
  currencySymbol: '\$',
  validator: Validators.validateAmount,
)
```

#### SearchTextField
```dart
SearchTextField(
  hint: 'Search...',
  controller: searchController,
  onChanged: (query) => search(query),
  onClear: () => clearSearch(),
)
```

#### PasswordTextField
```dart
PasswordTextField(
  label: 'Password',
  controller: passwordController,
  validator: Validators.validatePassword,
)
```

**Features:**
- Show/hide password toggle
- Eye icon indicator

#### EmailTextField
```dart
EmailTextField(
  controller: emailController,
  validator: Validators.validateEmail,
)
```

#### MultiLineTextField
```dart
MultiLineTextField(
  label: 'Notes',
  hint: 'Enter your notes',
  maxLines: 5,
  maxLength: 500,
)
```

---

### 3. State Views (state_views.dart)

#### ErrorView
```dart
ErrorView(
  title: 'Connection Failed',
  message: 'Unable to connect to server',
  icon: Icons.wifi_off,
  onRetry: () => fetchData(),
)
```

**Features:**
- Error icon dengan container
- Title dan message
- Retry button
- Additional action support

#### EmptyView
```dart
EmptyView(
  title: 'No History',
  message: 'Your history will appear here',
  icon: Icons.history,
  actionLabel: 'Convert Now',
  onAction: () => navigateToConverter(),
)
```

#### NetworkErrorView
```dart
NetworkErrorView(
  onRetry: () => fetchData(),
)
```

Preset untuk offline/network errors.

#### ServerErrorView
```dart
ServerErrorView(
  onRetry: () => fetchData(),
)
```

Preset untuk 500 server errors.

#### NotFoundView
```dart
NotFoundView(
  onGoBack: () => Navigator.pop(context),
)
```

Preset untuk 404 not found.

#### EmptySearchView
```dart
EmptySearchView(
  searchQuery: query,
  onClearSearch: () => clearSearch(),
)
```

#### EmptyHistoryView
```dart
EmptyHistoryView(
  onStartConverting: () => navigateToConverter(),
)
```

#### LoadingView
```dart
LoadingView(
  message: 'Loading data...',
)
```

#### ErrorMessageCard
```dart
ErrorMessageCard(
  message: 'Failed to load data',
  onRetry: () => retry(),
  onDismiss: () => dismiss(),
)
```

Compact inline error card.

#### SuccessMessageCard
```dart
SuccessMessageCard(
  message: 'Saved successfully',
  onDismiss: () => dismiss(),
)
```

Compact inline success card.

---

## 🎯 Usage Examples

### Complete Form Example
```dart
class ConversionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrencyTextField(
          label: 'Amount',
          controller: amountController,
          validator: Validators.validateAmount,
        ),
        const SizedBox(height: 16),
        
        PrimaryButton(
          label: 'Convert',
          icon: Icons.swap_horiz,
          onPressed: () => convert(),
          isLoading: isLoading,
          isFullWidth: true,
        ),
        
        const SizedBox(height: 8),
        
        SecondaryButton(
          label: 'Clear',
          icon: Icons.clear,
          onPressed: () => clear(),
          isFullWidth: true,
        ),
      ],
    );
  }
}
```

### Error Handling Example
```dart
Widget build(BuildContext context) {
  return switch (state) {
    Loading() => LoadingView(message: 'Loading...'),
    Error(:final message) => ErrorView(
      message: message,
      onRetry: () => retry(),
    ),
    Empty() => EmptyHistoryView(
      onStartConverting: () => navigate(),
    ),
    Success(:final data) => ListView(data),
  };
}
```

---

## 📐 Design System

### Button Sizes
- **Small**: 14px text, 18px icon
- **Medium**: 16px text, 20px icon (default)
- **Large**: 18px text, 24px icon

### Spacing
Menggunakan `AppConstants.defaultPadding` (16px) untuk consistency.

### Border Radius
Menggunakan `AppConstants.defaultBorderRadius` (12px).

### Colors
Menggunakan Material Design 3 `ColorScheme` dari theme.

---

## ✅ Benefits

1. **Consistency**: Semua buttons & fields tampil sama
2. **Productivity**: Tidak perlu menulis styling berulang
3. **Maintainability**: Update styling di satu tempat
4. **Type Safety**: Clear parameters dengan documentation
5. **Accessibility**: Built-in semantics & contrast

---

## 🔄 Migration Guide

### Before (Old Code)
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: () {},
  child: Text('Convert'),
)
```

### After (Reusable Component)
```dart
PrimaryButton(
  label: 'Convert',
  onPressed: () {},
)
```

**Savings**: 7 lines → 3 lines (57% reduction!)

---

## 📚 Next Steps

1. Replace existing buttons dengan PrimaryButton/SecondaryButton
2. Replace existing TextFields dengan CustomTextField variants
3. Add error handling dengan ErrorView/EmptyView
4. Update screens untuk consistency

---

**Created:** 16 Desember 2025  
**Version:** 1.0
