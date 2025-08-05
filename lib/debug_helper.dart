import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';

class DebugHelper {
  /// Reset the app to initial state (sign out + clear onboarding)
  /// This is useful for testing the complete flow
  static Future<void> resetAppState() async {
    if (kDebugMode) {
      try {
        // Sign out the user
        await AuthService.instance.signOut();
        debugPrint('User signed out');
        
        // Clear onboarding flag
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_seen_onboarding', false);
        debugPrint('Onboarding flag cleared');
        
        debugPrint('App state reset - app should show onboarding on next restart');
      } catch (e) {
        debugPrint('Error resetting app state: $e');
      }
    }
  }
  
  /// Clear only the onboarding flag (keep user logged in)
  static Future<void> resetOnboardingOnly() async {
    if (kDebugMode) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_seen_onboarding', false);
        debugPrint('Onboarding flag cleared - app should show onboarding on next restart');
      } catch (e) {
        debugPrint('Error clearing onboarding flag: $e');
      }
    }
  }
  
  /// Sign out only (keep onboarding flag)
  static Future<void> signOutOnly() async {
    if (kDebugMode) {
      try {
        await AuthService.instance.signOut();
        debugPrint('User signed out - app should show login on next restart');
      } catch (e) {
        debugPrint('Error signing out: $e');
      }
    }
  }
}