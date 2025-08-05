import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark, system }

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static ThemeService get instance => _instance;
  
  static const String _themeKey = 'app_theme';

  ThemeMode _themeMode = ThemeMode.system;
  AppTheme _selectedTheme = AppTheme.system;

  ThemeMode get themeMode => _themeMode;
  AppTheme get selectedTheme => _selectedTheme;
  String get selectedThemeString => _selectedTheme.name;

  Future<void> initialize() async {
    await _loadThemeFromPreferences();
  }

  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey) ?? 'system';
      final theme = AppTheme.values.firstWhere(
        (e) => e.name == themeString,
        orElse: () => AppTheme.system,
      );
      await setTheme(theme);
    } catch (e) {
      debugPrint('Error loading theme from preferences: $e');
      // Fallback to system theme
      _selectedTheme = AppTheme.system;
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    _selectedTheme = theme;
    _themeMode = _getThemeModeFromAppTheme(theme);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme.name);
    } catch (e) {
      debugPrint('Error saving theme to preferences: $e');
    }
    
    notifyListeners();
  }

  // Legacy method for backward compatibility
  Future<void> setThemeByString(String theme) async {
    final appTheme = _getAppThemeFromString(theme);
    await setTheme(appTheme);
  }

  ThemeMode _getThemeModeFromAppTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }

  AppTheme _getAppThemeFromString(String theme) {
    switch (theme.toLowerCase()) {
      case 'light':
        return AppTheme.light;
      case 'dark':
        return AppTheme.dark;
      case 'system':
      default:
        return AppTheme.system;
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: const MaterialColor(0xFF8B5CF6, {
        50: Color(0xFFF3E8FF),
        100: Color(0xFFE9D5FF),
        200: Color(0xFFD8B4FE),
        300: Color(0xFFC084FC),
        400: Color(0xFFA855F7),
        500: Color(0xFF8B5CF6),
        600: Color(0xFF7C3AED),
        700: Color(0xFF6D28D9),
        800: Color(0xFF5B21B6),
        900: Color(0xFF4C1D95),
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
      primarySwatch: const MaterialColor(0xFF8B5CF6, {
        50: Color(0xFF4C1D95),
        100: Color(0xFF5B21B6),
        200: Color(0xFF6D28D9),
        300: Color(0xFF7C3AED),
        400: Color(0xFF8B5CF6),
        500: Color(0xFFA855F7),
        600: Color(0xFFC084FC),
        700: Color(0xFFD8B4FE),
        800: Color(0xFFE9D5FF),
        900: Color(0xFFF3E8FF),
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