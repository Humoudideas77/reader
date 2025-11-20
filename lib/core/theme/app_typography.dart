import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for Qari2
/// Supports both Latin (Poppins) and Arabic (Cairo) fonts
class AppTypography {
  AppTypography._();

  /// Get text theme for Latin/English
  static TextTheme getLatinTextTheme(Color textColor) {
    return GoogleFonts.poppinsTextTheme().copyWith(
      // Display styles
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.2,
      ),

      // Headline styles
      headlineLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),

      // Title styles
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),

      // Body styles
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.5,
      ),

      // Label styles
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
    );
  }

  /// Get text theme for Arabic
  static TextTheme getArabicTextTheme(Color textColor) {
    return GoogleFonts.cairoTextTheme().copyWith(
      // Display styles
      displayLarge: GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.4,
      ),
      displayMedium: GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.4,
      ),
      displaySmall: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.4,
      ),

      // Headline styles
      headlineLarge: GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.5,
      ),
      headlineMedium: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.5,
      ),
      headlineSmall: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.5,
      ),

      // Title styles
      titleLarge: GoogleFonts.cairo(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.6,
      ),
      titleMedium: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.6,
      ),
      titleSmall: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.6,
      ),

      // Body styles
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.7,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.7,
      ),
      bodySmall: GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.7,
      ),

      // Label styles
      labelLarge: GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.6,
      ),
      labelMedium: GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.6,
      ),
      labelSmall: GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.6,
      ),
    );
  }
}
