import 'package:flutter/material.dart';

class AppColors {
  static const teal = Color(0xFF1565C0); // Vibrant Primary Blue
  static const primary = Color(0xFF1565C0); // Vibrant Primary Blue
  static const primaryDark = Color(0xFF0D47A1); // Dark Navy Blue
  static const ink = Color(0xFF0F172A); // Dark Slate Body Text
  static const bg = Color(0xFFF6F8FB); // Clean Off-White Background
  static const line = Color(0xFFE2E8F0); // Subtle Line Border
  static const muted = Color(0xFF64748B); // Cool Muted Grey Text
  static const red = Color(0xFFDC2626); // Alert Red
  static const mint = Color(0xFFE3F2FD); // Light Blue Tint Accent
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        primary: AppColors.teal,
        secondary: AppColors.primaryDark,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.bg,
    );
    OutlineInputBorder b(Color color, [double width = 1.0]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: b(AppColors.line),
        enabledBorder: b(AppColors.line),
        focusedBorder: b(AppColors.teal, 1.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.teal,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.teal, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
