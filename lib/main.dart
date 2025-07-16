import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pulsebreak_plus/features/onboarding/splash_screen.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
