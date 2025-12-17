import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System Typography
///
/// Provides consistent text styles across the application using Material Design 3
/// typography scale with Google Fonts (Poppins).
///
/// Usage:
/// ```dart
/// Text(
///   'Title',
///   style: DSTypography.headlineLarge(context),
/// )
/// ```
class DSTypography {
  DSTypography._();

  // Display styles (largest text)
  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      height: 1.12,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.16,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.22,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // Headline styles
  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.25,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.29,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.33,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // Title styles
  static TextStyle titleLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // Body styles (default text)
  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // Label styles (buttons, tabs)
  static TextStyle labelLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // Custom application-specific styles

  /// Currency amount style (large numbers)
  static TextStyle currencyAmount(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// Temperature value style
  static TextStyle temperatureValue(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 64,
      fontWeight: FontWeight.w700,
      letterSpacing: -1,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// Currency code style (e.g., USD, EUR)
  static TextStyle currencyCode(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  /// Temperature unit style (e.g., °C, °F)
  static TextStyle temperatureUnit(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  /// Exchange rate style
  static TextStyle exchangeRate(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  /// Error message style
  static TextStyle errorMessage(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.error,
    );
  }

  /// Success message style
  static TextStyle successMessage(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.green,
    );
  }

  /// Helper text style (hints, captions)
  static TextStyle helperText(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  /// Button text style
  static TextStyle button(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  /// Tab text style
  static TextStyle tab(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    );
  }

  /// Monospace style (for numeric inputs, codes)
  static TextStyle monospace(BuildContext context) {
    return const TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    );
  }

  // Text style modifiers

  /// Make text bold
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Make text semi-bold
  static TextStyle semiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  /// Make text medium weight
  static TextStyle medium(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w500);
  }

  /// Make text regular weight
  static TextStyle regular(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w400);
  }

  /// Make text light weight
  static TextStyle light(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w300);
  }

  /// Add italic style
  static TextStyle italic(TextStyle style) {
    return style.copyWith(fontStyle: FontStyle.italic);
  }

  /// Add underline
  static TextStyle underline(TextStyle style) {
    return style.copyWith(decoration: TextDecoration.underline);
  }

  /// Add strikethrough
  static TextStyle strikethrough(TextStyle style) {
    return style.copyWith(decoration: TextDecoration.lineThrough);
  }

  /// Change color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Change size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Change opacity
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withValues(alpha: opacity));
  }
}

/// Extension for easier typography usage
extension TextStyleExtension on BuildContext {
  /// Get display large style
  TextStyle get displayLarge => DSTypography.displayLarge(this);

  /// Get display medium style
  TextStyle get displayMedium => DSTypography.displayMedium(this);

  /// Get display small style
  TextStyle get displaySmall => DSTypography.displaySmall(this);

  /// Get headline large style
  TextStyle get headlineLarge => DSTypography.headlineLarge(this);

  /// Get headline medium style
  TextStyle get headlineMedium => DSTypography.headlineMedium(this);

  /// Get headline small style
  TextStyle get headlineSmall => DSTypography.headlineSmall(this);

  /// Get title large style
  TextStyle get titleLarge => DSTypography.titleLarge(this);

  /// Get title medium style
  TextStyle get titleMedium => DSTypography.titleMedium(this);

  /// Get title small style
  TextStyle get titleSmall => DSTypography.titleSmall(this);

  /// Get body large style
  TextStyle get bodyLarge => DSTypography.bodyLarge(this);

  /// Get body medium style
  TextStyle get bodyMedium => DSTypography.bodyMedium(this);

  /// Get body small style
  TextStyle get bodySmall => DSTypography.bodySmall(this);

  /// Get label large style
  TextStyle get labelLarge => DSTypography.labelLarge(this);

  /// Get label medium style
  TextStyle get labelMedium => DSTypography.labelMedium(this);

  /// Get label small style
  TextStyle get labelSmall => DSTypography.labelSmall(this);
}
