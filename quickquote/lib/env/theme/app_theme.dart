import 'package:flutter/material.dart';

class AppTheme {
  // Define your theme properties here
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryMedium = Color(0xFF3B82F6);
  static const Color primaryDarkest = Color(0xFF1E3A8A);
  static const Color gray = Color(0xFF6B7280);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  ThemeData theme() {
    return ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: AppTheme.primary,
          cursorColor: AppTheme.primary),
      filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppTheme.primaryMedium))),
      useMaterial3: true,
    );
  }
}