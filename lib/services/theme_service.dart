import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static ThemeService get instance => _instance;

  ThemeMode _themeMode = ThemeMode.system;
  String _selectedTheme = 'System';

  ThemeMode get themeMode => _themeMode;
  String get selectedTheme => _selectedTheme;

  void setTheme(String theme) {
    _selectedTheme = theme;
    switch (theme) {
      case 'Light':
        _themeMode = ThemeMode.light;
        break;
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: MaterialColor(0xFF8B5CF6, {
        50: const Color(0xFFF3E8FF),
        100: const Color(0xFFE9D5FF),
        200: const Color(0xFFD8B4FE),
        300: const Color(0xFFC084FC),
        400: const Color(0xFFA855F7),
        500: const Color(0xFF8B5CF6),
        600: const Color(0xFF7C3AED),
        700: const Color(0xFF6D28D9),
        800: const Color(0xFF5B21B6),
        900: const Color(0xFF4C1D95),
      }),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8B5CF6),
        secondary: Color(0xFF4F8A8B),
        surface: Color(0xFFF5F7FA),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF2E3A59)),
        titleTextStyle: TextStyle(
          color: Color(0xFF2E3A59),
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(0xFF8B5CF6, {
        50: const Color(0xFF4C1D95),
        100: const Color(0xFF5B21B6),
        200: const Color(0xFF6D28D9),
        300: const Color(0xFF7C3AED),
        400: const Color(0xFF8B5CF6),
        500: const Color(0xFFA855F7),
        600: const Color(0xFFC084FC),
        700: const Color(0xFFD8B4FE),
        800: const Color(0xFFE9D5FF),
        900: const Color(0xFFF3E8FF),
      }),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8B5CF6),
        secondary: Color(0xFF4F8A8B),
        surface: Color(0xFF1F2937),
      ),
      scaffoldBackgroundColor: const Color(0xFF111827),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}