# Design System Documentation

This design system provides a comprehensive set of design tokens, components, and guidelines for building consistent user interfaces in the Currency & Temperature Converter app.

## 📐 Design Tokens

### Spacing (`ds_spacing.dart`)

Consistent spacing values for padding, margins, and gaps.

```dart
import 'package:currency_temperature_converter_mobile_app/core/design_system/ds_spacing.dart';

// Base spacing
DSSpacing.xs    // 4dp
DSSpacing.sm    // 8dp
DSSpacing.md    // 12dp
DSSpacing.lg    // 16dp
DSSpacing.xl    // 20dp
DSSpacing.xxl   // 24dp

// Padding helpers
Padding(
  padding: DSSpacing.paddingLG,  // EdgeInsets.all(16)
  child: child,
)

// Gaps
Column(
  children: [
    widget1,
    SizedBox(height: DSSpacing.gapMD),
    widget2,
  ],
)
```

### Border Radius (`ds_spacing.dart`)

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: DSBorderRadius.borderRadiusMD,  // 12dp
  ),
)
```

### Typography (`ds_typography.dart`)

Material Design 3 typography scale with Poppins font.

```dart
// Using context extension
Text('Title', style: context.headlineLarge);
Text('Body', style: context.bodyMedium);

// Using typography class
Text('Title', style: DSTypography.headlineLarge(context));
Text('Body', style: DSTypography.bodyMedium(context));

// Custom app styles
Text('$100.00', style: DSTypography.currencyAmount(context));
Text('25°C', style: DSTypography.temperatureValue(context));
```

### Elevation

```dart
DSElevation.none   // 0
DSElevation.sm     // 2
DSElevation.md     // 4
DSElevation.lg     // 8
```

### Icon Sizes

```dart
Icon(Icons.star, size: DSIconSize.md);  // 24dp
Icon(Icons.star, size: DSIconSize.lg);  // 32dp
```

### Animations (`ds_spacing.dart`)

```dart
// Durations
AnimatedContainer(
  duration: DSDurations.normal,  // 250ms
  curve: DSCurves.standard,
)

// Curves
DSDurations.fast       // 150ms
DSDurations.normal     // 250ms
DSDurations.slow       // 350ms

DSCurves.standard      // easeInOutCubic
DSCurves.emphasized    // easeInOutQuart
```

### Breakpoints (Responsive Design)

```dart
final screenWidth = MediaQuery.of(context).size.width;

if (DSBreakpoints.isMobile(screenWidth)) {
  // Mobile layout (< 900dp)
} else if (DSBreakpoints.isTablet(screenWidth)) {
  // Tablet layout (900-1200dp)
} else {
  // Desktop layout (> 1200dp)
}

// Helper methods
final padding = DSHelpers.getResponsivePadding(screenWidth);
final columns = DSHelpers.getResponsiveColumns(screenWidth);
```

### Opacity

```dart
opacity: DSOpacity.disabled,  // 0.38
opacity: DSOpacity.inactive,  // 0.60
```

## 🎨 Color System

The app uses Material Design 3 color system with dynamic theming support.

### Color Tokens

```dart
// Theme colors
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.secondary
Theme.of(context).colorScheme.error
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.background

// Surface colors
Theme.of(context).colorScheme.onPrimary
Theme.of(context).colorScheme.onSecondary
Theme.of(context).colorScheme.onError
Theme.of(context).colorScheme.onSurface
```

## 🧩 Components

### Buttons

```dart
// Primary button
PrimaryButton(
  label: 'Convert',
  icon: Icons.swap_horiz,
  onPressed: () {},
  isLoading: false,
)

// Secondary button
SecondaryButton(
  label: 'Cancel',
  onPressed: () {},
)

// Text button
TextButtonCustom(
  label: 'Learn More',
  onPressed: () {},
)

// Icon button
IconButtonCustom(
  icon: Icons.share,
  onPressed: () {},
  tooltip: 'Share',
)
```

### Text Fields

```dart
// Basic text field
CustomTextField(
  label: 'Amount',
  hint: 'Enter amount',
  controller: controller,
)

// Number input
NumberTextField(
  label: 'Amount',
  controller: controller,
  allowDecimal: true,
)

// Currency input
CurrencyTextField(
  label: 'Amount',
  controller: controller,
  currencySymbol: '\$',
)

// Search field
SearchTextField(
  hint: 'Search...',
  onChanged: (query) => search(query),
)
```

### State Views

```dart
// Error view
ErrorView(
  title: 'Connection Failed',
  message: 'Unable to connect',
  onRetry: () => retry(),
)

// Empty view
EmptyView(
  title: 'No History',
  message: 'Your history will appear here',
  actionLabel: 'Convert Now',
  onAction: () => navigate(),
)

// Loading view
LoadingView(message: 'Loading...')

// Network error
NetworkErrorView(onRetry: () => retry())
```

## ♿ Accessibility

### Semantic Labels

```dart
Semantics(
  label: 'Convert button',
  button: true,
  child: ElevatedButton(...),
)
```

### Text Scaling

All text automatically scales with system font size settings.

### Color Contrast

All colors meet WCAG AA standards:
- Normal text: 4.5:1 contrast ratio
- Large text: 3:1 contrast ratio

### Touch Targets

All interactive elements have minimum 48dp touch target.

## 📱 Layout Guidelines

### Screen Padding

```dart
// Mobile: 16dp
// Tablet: 20dp
// Desktop: 24dp
Padding(
  padding: DSSpacing.screenPadding,
  child: content,
)
```

### Card Padding

```dart
Padding(
  padding: DSSpacing.cardPaddingAll,  // 16dp
  child: content,
)
```

### List Items

```dart
ListTile(
  contentPadding: DSSpacing.listItemPaddingHorizontal,  // 16dp horizontal
  title: Text('Title'),
)
```

### Sections

```dart
Column(
  children: [
    Section1(),
    SizedBox(height: DSSpacing.sectionSpacing),  // 24dp
    Section2(),
  ],
)
```

## 🎯 Best Practices

### 1. Always Use Design Tokens

❌ DON'T:
```dart
Padding(padding: EdgeInsets.all(16))
```

✅ DO:
```dart
Padding(padding: DSSpacing.paddingLG)
```

### 2. Use Context Extensions for Typography

❌ DON'T:
```dart
Text('Title', style: TextStyle(fontSize: 24))
```

✅ DO:
```dart
Text('Title', style: context.headlineLarge)
```

### 3. Responsive Design

❌ DON'T:
```dart
Container(width: 400)  // Fixed width
```

✅ DO:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth;
    return Container(
      width: DSBreakpoints.isMobile(width) ? width : 400,
    );
  },
)
```

### 4. Consistent Animations

❌ DON'T:
```dart
AnimatedOpacity(duration: Duration(milliseconds: 300))
```

✅ DO:
```dart
AnimatedOpacity(
  duration: DSDurations.normal,
  curve: DSCurves.standard,
)
```

### 5. Accessibility

✅ DO:
- Add semantic labels to all interactive elements
- Ensure sufficient color contrast
- Use large enough touch targets (48dp minimum)
- Support text scaling
- Provide alternative text for images

## 📚 Additional Resources

- [Material Design 3 Guidelines](https://m3.material.io/)
- [Flutter Accessibility](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Google Fonts](https://fonts.google.com/specimen/Poppins)

## 🔄 Updates

When updating the design system:

1. Update design tokens first
2. Test on all screen sizes
3. Ensure accessibility compliance
4. Update documentation
5. Notify team of changes

## 🎨 Figma Integration

Design tokens are synced with Figma designs. See the design file for visual reference:
[Figma Design File](https://figma.com/...)

## 🧪 Testing

Test design system components:

```bash
flutter test test/design_system/
```

## 📝 Changelog

### Version 1.0 (Current)
- Initial design system implementation
- Material Design 3 typography
- Responsive breakpoints
- Accessibility guidelines
- Animation standards
