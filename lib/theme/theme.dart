import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

class MarginTheme {
  // Midnight Bloom — Primary Identity
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: MarginColors.lavender,
      scaffoldBackgroundColor: MarginColors.background,
      colorScheme: const ColorScheme.dark(
        primary: MarginColors.lavender,
        onPrimary: MarginColors.background,
        secondary: MarginColors.peach,
        onSecondary: MarginColors.background,
        tertiary: MarginColors.mint,
        surface: MarginColors.surface,
        onSurface: MarginColors.textPrimary,
        error: MarginColors.error,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: MarginColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: MarginColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: MarginRadii.cardRadius,
          side: const BorderSide(color: MarginColors.border, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MarginColors.elevated,
        hintStyle: MarginTypography.bodyMedium.copyWith(color: MarginColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: MarginRadii.inputRadius,
          borderSide: const BorderSide(color: MarginColors.border, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: MarginRadii.inputRadius,
          borderSide: const BorderSide(color: MarginColors.border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: MarginRadii.inputRadius,
          borderSide: const BorderSide(color: MarginColors.lavender, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MarginColors.lavender,
          foregroundColor: MarginColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: MarginRadii.buttonRadius,
          ),
          textStyle: MarginTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MarginColors.textPrimary,
          side: const BorderSide(color: MarginColors.borderLight, width: 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: MarginRadii.buttonRadius,
          ),
          textStyle: MarginTypography.button,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: MarginColors.border,
        thickness: 1,
        space: 24,
      ),
    );
  }

  // Optional Light Theme for user preference toggle
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF7655E8),
      scaffoldBackgroundColor: const Color(0xFFFAF9F6),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF7655E8),
        onPrimary: Colors.white,
        secondary: Color(0xFFC9B8FF),
        onSecondary: Color(0xFF1E1B2E),
        surface: Colors.white,
        onSurface: Color(0xFF1E1B2E),
      ),
    );
  }
}
