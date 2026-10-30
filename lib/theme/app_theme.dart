
import 'package:flutter/material.dart';

class AppColors {
  // Primary palette — Premium Floral
  static const pink = Color(0xFFD96C91);
  static const pinkDark = Color(0xFFAD496F);
  static const pinkLight = Color(0xFFF8E3EA);

  // Elegant neutral palette
  static const background = Color(0xFFFFFAF7);
  static const surface = Color(0xFFFFFFFF);
  static const ivory = Color(0xFFF5EEE8);
  static const roseGold = Color(0xFFB88772);

  // Typography colors
  static const text = Color(0xFF35252D);
  static const muted = Color(0xFF97858D);
  static const textLight = Color(0xFFB6A6AD);

  // Supporting colors
  static const green = Color(0xFF648875);
  static const divider = Color(0xFFF0E4E8);
  static const error = Color(0xFFCB4E61);
}

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.pink,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.pinkDark,
      onPrimary: Colors.white,
      secondary: AppColors.roseGold,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Inter',

      // Global visual defaults
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,

      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: AppColors.text,
          size: 23,
        ),
      ),

      // Text hierarchy
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.text,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -1.2,
        ),
        headlineLarge: TextStyle(
          color: AppColors.text,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.8,
        ),
        headlineMedium: TextStyle(
          color: AppColors.text,
          fontSize: 25,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          color: AppColors.text,
          fontSize: 15,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: AppColors.muted,
          fontSize: 14,
          height: 1.55,
        ),
        bodySmall: TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pinkDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 17,
          ),
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.pinkDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.pinkLight,
          disabledForegroundColor: AppColors.muted,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 16,
          ),
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.pinkDark,
          side: const BorderSide(
            color: AppColors.pinkLight,
            width: 1.3,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 14,
        ),
        prefixIconColor: AppColors.muted,
        suffixIconColor: AppColors.muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.divider,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.pink,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.pinkDark.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(
            color: AppColors.divider,
            width: 0.7,
          ),
        ),
      ),

      // Navigation
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.pinkLight,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) {
            final selected = states.contains(WidgetState.selected);

            return TextStyle(
              fontSize: 11,
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
              color:
                  selected ? AppColors.pinkDark : AppColors.muted,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (states) {
            final selected = states.contains(WidgetState.selected);

            return IconThemeData(
              size: selected ? 24 : 22,
              color:
                  selected ? AppColors.pinkDark : AppColors.muted,
            );
          },
        ),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.8,
        space: 1,
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.text,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          height: 1.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        insetPadding: const EdgeInsets.all(16),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.text,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.muted,
          fontSize: 14,
          height: 1.6,
        ),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppColors.pinkLight,
        disabledColor: AppColors.ivory,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        labelStyle: const TextStyle(
          color: AppColors.text,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.pinkDark,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(
            color: AppColors.divider,
          ),
        ),
      ),
    );
  }
}
