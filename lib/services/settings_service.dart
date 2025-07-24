import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static SettingsService get instance => _instance;

  // Settings state
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _soundEffects = true;
  bool _hapticFeedback = true;
  bool _autoBackup = true;
  bool _dataCollection = false;
  bool _crashReporting = true;
  String _selectedLanguage = 'English';
  String _reminderFrequency = 'Daily';
  String _dataExportFormat = 'JSON';

  // User profile data
  String _userName = 'Paul Nti';
  String _userEmail = 'paul.nti@example.com';
  String _userLocation = 'Accra, Ghana';

  // Getters
  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get soundEffects => _soundEffects;
  bool get hapticFeedback => _hapticFeedback;
  bool get autoBackup => _autoBackup;
  bool get dataCollection => _dataCollection;
  bool get crashReporting => _crashReporting;
  String get selectedLanguage => _selectedLanguage;
  String get reminderFrequency => _reminderFrequency;
  String get dataExportFormat => _dataExportFormat;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userLocation => _userLocation;

  // Setters
  void setPushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void setEmailNotifications(bool value) {
    _emailNotifications = value;
    notifyListeners();
  }

  void setSoundEffects(bool value) {
    _soundEffects = value;
    notifyListeners();
  }

  void setHapticFeedback(bool value) {
    _hapticFeedback = value;
    notifyListeners();
  }

  void setAutoBackup(bool value) {
    _autoBackup = value;
    notifyListeners();
  }

  void setDataCollection(bool value) {
    _dataCollection = value;
    notifyListeners();
  }

  void setCrashReporting(bool value) {
    _crashReporting = value;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void setReminderFrequency(String frequency) {
    _reminderFrequency = frequency;
    notifyListeners();
  }

  void setDataExportFormat(String format) {
    _dataExportFormat = format;
    notifyListeners();
  }

  void updateUserProfile({String? name, String? email, String? location}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (location != null) _userLocation = location;
    notifyListeners();
  }

  // Storage calculation
  Map<String, double> getStorageBreakdown() {
    return {
      'Journal entries': 156.0,
      'Mood data': 45.0,
      'App cache': 32.0,
      'Images': 12.0,
    };
  }

  double get totalStorageUsed {
    return getStorageBreakdown().values.reduce((a, b) => a + b);
  }

  void clearCache() {
    // Simulate cache clearing
    notifyListeners();
  }
}