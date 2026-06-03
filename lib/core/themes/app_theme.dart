import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF14B8A6);
  static const Color bg = Color(0xFFF6F8FC);
  static const Color darkBg = Color(0xFF0F172A);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary, secondary: secondary, surface: Colors.white),
      appBarTheme: const AppBarTheme(backgroundColor: bg, foregroundColor: Color(0xFF0F172A), elevation: 0),
      inputDecorationTheme: _inputTheme(false),
      elevatedButtonTheme: _buttonTheme,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primary.withOpacity(.12),
        labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: darkBg,
      colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark, primary: primary, secondary: secondary, surface: const Color(0xFF111827)),
      appBarTheme: const AppBarTheme(backgroundColor: darkBg, foregroundColor: Colors.white, elevation: 0),
      inputDecorationTheme: _inputTheme(true),
      elevatedButtonTheme: _buttonTheme,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF111827),
        indicatorColor: primary.withOpacity(.24),
        labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    );
  }

  static InputDecorationTheme _inputTheme(bool dark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF111827) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: dark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
    );
  }

  static final ElevatedButtonThemeData _buttonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 52),
      backgroundColor: primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
    ),
  );
}
