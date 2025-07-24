import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pulsebreak_plus/features/onboarding/splash_screen.dart';
import 'package:pulsebreak_plus/services/theme_service.dart';
import 'package:pulsebreak_plus/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    // Firebase initialized successfully
  } catch (e) {
    // Firebase initialization failed - continuing in demo mode
    // Continue without Firebase for now
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeService _themeService = ThemeService.instance;
  final SettingsService _settingsService = SettingsService.instance;

  @override
  void initState() {
    super.initState();
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      themeMode: _themeService.themeMode,
      home: const SplashScreen(),
    );
  }
}
