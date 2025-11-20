import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Qari2 App Theme Configuration
/// Provides light and dark themes with bilingual typography support
class AppTheme {
  AppTheme._();

  /// Light theme for Latin/English
  static ThemeData lightThemeEnglish() {
    return _buildTheme(
      brightness: Brightness.light,
      textTheme: AppTypography.getLatinTextTheme(AppColors.textPrimary),
      primaryColor: AppColors.primaryInkBlue,
      scaffoldBackground: AppColors.backgroundLight,
      surface: AppColors.surface,
    );
  }

  /// Dark theme for Latin/English
  static ThemeData darkThemeEnglish() {
    return _buildTheme(
      brightness: Brightness.dark,
      textTheme: AppTypography.getLatinTextTheme(AppColors.textOnDark),
      primaryColor: AppColors.primaryInkBlue,
      scaffoldBackground: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
    );
  }

  /// Light theme for Arabic
  static ThemeData lightThemeArabic() {
    return _buildTheme(
      brightness: Brightness.light,
      textTheme: AppTypography.getArabicTextTheme(AppColors.textPrimary),
      primaryColor: AppColors.primaryInkBlue,
      scaffoldBackground: AppColors.backgroundLight,
      surface: AppColors.surface,
    );
  }

  /// Dark theme for Arabic
  static ThemeData darkThemeArabic() {
    return _buildTheme(
      brightness: Brightness.dark,
      textTheme: AppTypography.getArabicTextTheme(AppColors.textOnDark),
      primaryColor: AppColors.primaryInkBlue,
      scaffoldBackground: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required TextTheme textTheme,
    required Color primaryColor,
    required Color scaffoldBackground,
    required Color surface,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final ColorScheme colorScheme = isDark
        ? ColorScheme.dark(
            primary: primaryColor,
            secondary: AppColors.accentEmeraldGreen,
            tertiary: AppColors.secondarySoftSand,
            surface: surface,
            error: AppColors.error,
            onPrimary: AppColors.textOnPrimary,
            onSecondary: AppColors.textOnPrimary,
            onSurface: AppColors.textOnDark,
            onError: AppColors.textOnPrimary,
          )
        : ColorScheme.light(
            primary: primaryColor,
            secondary: AppColors.accentEmeraldGreen,
            tertiary: AppColors.secondarySoftSand,
            surface: surface,
            error: AppColors.error,
            onPrimary: AppColors.textOnPrimary,
            onSecondary: AppColors.textOnPrimary,
            onSurface: AppColors.textPrimary,
            onError: AppColors.textOnPrimary,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: isDark ? AppColors.textOnDark : AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: surface,
        elevation: 1,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: primaryColor, width: 1.5),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.gray800 : AppColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.gray400 : AppColors.gray500,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentEmeraldGreen,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor:
            isDark ? AppColors.gray400 : AppColors.gray500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.gray700 : AppColors.gray100,
        selectedColor: AppColors.accentEmeraldGreen.withOpacity(0.2),
        labelStyle: textTheme.labelMedium!,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.gray700 : AppColors.gray200,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
        size: 24,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: isDark ? AppColors.textOnDark : AppColors.textPrimary,
        textColor: isDark ? AppColors.textOnDark : AppColors.textPrimary,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.accentEmeraldGreen,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.gray800 : AppColors.gray900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
