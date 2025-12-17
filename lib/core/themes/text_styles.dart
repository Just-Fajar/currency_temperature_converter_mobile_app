import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography styles for the application
class TextStyles {
  // Headings
  static TextStyle get heading1 =>
      GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold);

  static TextStyle get heading2 =>
      GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get heading3 =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600);

  // Body Text
  static TextStyle get bodyLarge =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get bodyMedium =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal);

  static TextStyle get bodySmall =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal);

  // Conversion Display
  static TextStyle get conversionResult => GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle get conversionLabel => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Currency
  static TextStyle get currencySymbol =>
      GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w600);

  static TextStyle get currencyCode => GoogleFonts.robotoMono(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
  );

  // Temperature
  static TextStyle get temperatureValue =>
      GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.bold);

  static TextStyle get temperatureUnit =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500);

  // Button Text
  static TextStyle get button =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

  // Caption
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  // Error Text
  static TextStyle get error => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );
}
