import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  static FirebaseService get instance => _instance;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Initialize Firebase with proper error handling
  Future<bool> initialize() async {
    try {
      if (_initialized) {
        debugPrint('Firebase already initialized');
        return true;
      }

      await Firebase.initializeApp();
      _initialized = true;
      debugPrint('Firebase initialized successfully');
      
      // Test Firestore connectivity
      await _testFirestoreConnection();
      
      return true;
      
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      return false;
    }
  }

  /// Test Firestore connectivity
  Future<void> _testFirestoreConnection() async {
    try {
      final firestore = FirebaseFirestore.instance;
      debugPrint('Testing Firestore connectivity...');
      
      // Try to read from a test collection (this will fail gracefully if Firestore isn't set up)
      await firestore.collection('test').limit(1).get();
      debugPrint('Firestore connectivity test passed');
    } catch (e) {
      debugPrint('Firestore connectivity test failed: $e');
      debugPrint('This might mean:');
      debugPrint('1. Firestore database not created in Firebase Console');
      debugPrint('2. Security rules are too restrictive');
      debugPrint('3. Network connectivity issues');
      debugPrint('4. Temporary Firebase service outage');
    }
  }

  /// Check if Firebase is properly configured
  bool isConfigured() {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (e) {
      debugPrint('Firebase configuration check failed: $e');
      return false;
    }
  }

  /// Get current Firebase app instance
  FirebaseApp? getCurrentApp() {
    try {
      return Firebase.app();
    } catch (e) {
      debugPrint('Failed to get Firebase app: $e');
      return null;
    }
  }
}