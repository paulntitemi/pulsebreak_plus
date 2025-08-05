import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/main_navigation.dart';
import '../features/onboarding/splash_screen.dart';
import '../features/auth/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _hasSeenOnboarding = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Check if user has seen onboarding
      final prefs = await SharedPreferences.getInstance();
      _hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
      
      // Get current user
      _user = AuthService.instance.currentUser;
      
      debugPrint('AuthWrapper: hasSeenOnboarding = $_hasSeenOnboarding');
      debugPrint('AuthWrapper: currentUser = ${_user?.email ?? 'null'}');
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Auth wrapper initialization error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AuthWrapper build: isLoading=$_isLoading, hasSeenOnboarding=$_hasSeenOnboarding, user=${_user?.email ?? 'null'}');
    
    if (_isLoading) {
      return const SplashScreen();
    }

    // If user hasn't seen onboarding, show onboarding
    if (!_hasSeenOnboarding) {
      debugPrint('AuthWrapper: Showing onboarding screen');
      return const OnboardingScreen();
    }

    // If user is logged in, show main app
    if (_user != null) {
      debugPrint('AuthWrapper: User logged in, showing main navigation');
      return const MainNavigation();
    }

    // User has seen onboarding but not logged in, show login directly
    debugPrint('AuthWrapper: User not logged in, showing login screen');
    return const LoginScreen();
  }
}