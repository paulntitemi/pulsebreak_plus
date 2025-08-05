import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static SettingsService get instance => _instance;

  // Keys for SharedPreferences
  static const String _pushNotificationsKey = 'push_notifications';
  static const String _emailNotificationsKey = 'email_notifications';
  static const String _soundEffectsKey = 'sound_effects';
  static const String _hapticFeedbackKey = 'haptic_feedback';
  static const String _autoBackupKey = 'auto_backup';
  static const String _dataCollectionKey = 'data_collection';
  static const String _crashReportingKey = 'crash_reporting';
  static const String _selectedLanguageKey = 'selected_language';
  static const String _reminderFrequencyKey = 'reminder_frequency';
  static const String _dataExportFormatKey = 'data_export_format';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userLocationKey = 'user_location';

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

  // Initialize settings from SharedPreferences
  Future<void> initialize() async {
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _pushNotifications = prefs.getBool(_pushNotificationsKey) ?? true;
      _emailNotifications = prefs.getBool(_emailNotificationsKey) ?? false;
      _soundEffects = prefs.getBool(_soundEffectsKey) ?? true;
      _hapticFeedback = prefs.getBool(_hapticFeedbackKey) ?? true;
      _autoBackup = prefs.getBool(_autoBackupKey) ?? true;
      _dataCollection = prefs.getBool(_dataCollectionKey) ?? false;
      _crashReporting = prefs.getBool(_crashReportingKey) ?? true;
      _selectedLanguage = prefs.getString(_selectedLanguageKey) ?? 'English';
      _reminderFrequency = prefs.getString(_reminderFrequencyKey) ?? 'Daily';
      _dataExportFormat = prefs.getString(_dataExportFormatKey) ?? 'JSON';
      _userName = prefs.getString(_userNameKey) ?? 'Paul Nti';
      _userEmail = prefs.getString(_userEmailKey) ?? 'paul.nti@example.com';
      _userLocation = prefs.getString(_userLocationKey) ?? 'Accra, Ghana';
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Setters with persistence
  Future<void> setPushNotifications(bool value) async {
    _pushNotifications = value;
    await _saveBoolSetting(_pushNotificationsKey, value);
    notifyListeners();
  }

  Future<void> setEmailNotifications(bool value) async {
    _emailNotifications = value;
    await _saveBoolSetting(_emailNotificationsKey, value);
    notifyListeners();
  }

  Future<void> setSoundEffects(bool value) async {
    _soundEffects = value;
    await _saveBoolSetting(_soundEffectsKey, value);
    notifyListeners();
  }

  Future<void> setHapticFeedback(bool value) async {
    _hapticFeedback = value;
    await _saveBoolSetting(_hapticFeedbackKey, value);
    notifyListeners();
  }

  Future<void> setAutoBackup(bool value) async {
    _autoBackup = value;
    await _saveBoolSetting(_autoBackupKey, value);
    notifyListeners();
  }

  Future<void> setDataCollection(bool value) async {
    _dataCollection = value;
    await _saveBoolSetting(_dataCollectionKey, value);
    notifyListeners();
  }

  Future<void> setCrashReporting(bool value) async {
    _crashReporting = value;
    await _saveBoolSetting(_crashReportingKey, value);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _selectedLanguage = language;
    await _saveStringSetting(_selectedLanguageKey, language);
    notifyListeners();
  }

  Future<void> setReminderFrequency(String frequency) async {
    _reminderFrequency = frequency;
    await _saveStringSetting(_reminderFrequencyKey, frequency);
    notifyListeners();
  }

  Future<void> setDataExportFormat(String format) async {
    _dataExportFormat = format;
    await _saveStringSetting(_dataExportFormatKey, format);
    notifyListeners();
  }

  Future<void> updateUserProfile({String? name, String? email, String? location}) async {
    if (name != null) {
      _userName = name;
      await _saveStringSetting(_userNameKey, name);
    }
    if (email != null) {
      _userEmail = email;
      await _saveStringSetting(_userEmailKey, email);
    }
    if (location != null) {
      _userLocation = location;
      await _saveStringSetting(_userLocationKey, location);
    }
    notifyListeners();
  }

  // Helper methods for saving settings
  Future<void> _saveBoolSetting(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e) {
      debugPrint('Error saving bool setting $key: $e');
    }
  }

  Future<void> _saveStringSetting(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      debugPrint('Error saving string setting $key: $e');
    }
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