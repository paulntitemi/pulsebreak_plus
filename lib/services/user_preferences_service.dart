import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserPreferencesService {
  static final UserPreferencesService _instance = UserPreferencesService._internal();
  factory UserPreferencesService() => _instance;
  UserPreferencesService._internal();

  static UserPreferencesService get instance => _instance;

  SharedPreferences? _preferences;
  bool _isInitialized = false;

  // Keys for different preference categories
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyReminderHistory = 'reminder_history';
  static const String _keyUserReminders = 'user_reminders';
  static const String _keyAppFirstLaunch = 'app_first_launch';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyWellnessGoals = 'wellness_goals';
  static const String _keyPrivacySettings = 'privacy_settings';
  static const String _keyLanguage = 'language';
  static const String _keyFontSize = 'font_size';
  static const String _keyDataSync = 'data_sync_enabled';
  static const String _keyDarkMode = 'dark_mode_enabled';
  static const String _keyAutoSharing = 'auto_sharing_enabled';

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _preferences = await SharedPreferences.getInstance();
      _isInitialized = true;
      debugPrint('✅ UserPreferencesService initialized successfully');
    } catch (e) {
      debugPrint('❌ UserPreferencesService initialization failed: $e');
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized || _preferences == null) {
      throw StateError('UserPreferencesService not initialized. Call initialize() first.');
    }
  }

  // Theme Preferences
  Future<bool> setThemeMode(String mode) async {
    _ensureInitialized();
    return await _preferences!.setString(_keyThemeMode, mode);
  }

  String getThemeMode() {
    _ensureInitialized();
    return _preferences!.getString(_keyThemeMode) ?? 'system';
  }

  Future<bool> setDarkModeEnabled(bool enabled) async {
    _ensureInitialized();
    return await _preferences!.setBool(_keyDarkMode, enabled);
  }

  bool getDarkModeEnabled() {
    _ensureInitialized();
    return _preferences!.getBool(_keyDarkMode) ?? false;
  }

  // Notification Preferences
  Future<bool> setNotificationsEnabled(bool enabled) async {
    _ensureInitialized();
    return await _preferences!.setBool(_keyNotificationsEnabled, enabled);
  }

  bool getNotificationsEnabled() {
    _ensureInitialized();
    return _preferences!.getBool(_keyNotificationsEnabled) ?? true;
  }

  // Font Size Preferences
  Future<bool> setFontSize(double size) async {
    _ensureInitialized();
    return await _preferences!.setDouble(_keyFontSize, size);
  }

  double getFontSize() {
    _ensureInitialized();
    return _preferences!.getDouble(_keyFontSize) ?? 14.0;
  }

  // Language Preferences
  Future<bool> setLanguage(String languageCode) async {
    _ensureInitialized();
    return await _preferences!.setString(_keyLanguage, languageCode);
  }

  String getLanguage() {
    _ensureInitialized();
    return _preferences!.getString(_keyLanguage) ?? 'en';
  }

  // Reminder Preferences
  Future<bool> saveUserReminders(List<Map<String, dynamic>> reminders) async {
    _ensureInitialized();
    try {
      final String remindersJson = jsonEncode(reminders);
      return await _preferences!.setString(_keyUserReminders, remindersJson);
    } catch (e) {
      debugPrint('❌ Failed to save reminders: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> getUserReminders() {
    _ensureInitialized();
    try {
      final String? remindersJson = _preferences!.getString(_keyUserReminders);
      if (remindersJson != null) {
        final dynamic decoded = jsonDecode(remindersJson);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to load reminders: $e');
    }
    return [];
  }

  // Reminder History
  Future<bool> addReminderHistory(String reminderId, DateTime completedAt) async {
    _ensureInitialized();
    try {
      final List<String> history = _preferences!.getStringList(_keyReminderHistory) ?? [];
      final String entry = jsonEncode({
        'reminderId': reminderId,
        'completedAt': completedAt.toIso8601String(),
      });
      history.add(entry);
      
      // Keep only the last 100 entries
      if (history.length > 100) {
        history.removeAt(0);
      }
      
      return await _preferences!.setStringList(_keyReminderHistory, history);
    } catch (e) {
      debugPrint('❌ Failed to add reminder history: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> getReminderHistory() {
    _ensureInitialized();
    try {
      final List<String>? historyStrings = _preferences!.getStringList(_keyReminderHistory);
      if (historyStrings != null) {
        return historyStrings.map((entry) {
          final dynamic decoded = jsonDecode(entry);
          if (decoded is Map<String, dynamic>) {
            return {
              'reminderId': decoded['reminderId'] as String,
              'completedAt': DateTime.parse(decoded['completedAt'] as String),
            };
          }
          return <String, dynamic>{};
        }).where((entry) => entry.isNotEmpty).toList();
      }
    } catch (e) {
      debugPrint('❌ Failed to load reminder history: $e');
    }
    return [];
  }

  // App State
  Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    _ensureInitialized();
    return await _preferences!.setBool(_keyAppFirstLaunch, isFirstLaunch);
  }

  bool isFirstLaunch() {
    _ensureInitialized();
    return _preferences!.getBool(_keyAppFirstLaunch) ?? true;
  }

  Future<bool> setOnboardingCompleted(bool completed) async {
    _ensureInitialized();
    return await _preferences!.setBool(_keyOnboardingCompleted, completed);
  }

  bool isOnboardingCompleted() {
    _ensureInitialized();
    return _preferences!.getBool(_keyOnboardingCompleted) ?? false;
  }

  // Wellness Goals
  Future<bool> setWellnessGoals(List<String> goals) async {
    _ensureInitialized();
    return await _preferences!.setStringList(_keyWellnessGoals, goals);
  }

  List<String> getWellnessGoals() {
    _ensureInitialized();
    return _preferences!.getStringList(_keyWellnessGoals) ?? [];
  }

  // Privacy Settings
  Future<bool> setPrivacySettings(Map<String, bool> settings) async {
    _ensureInitialized();
    try {
      final String settingsJson = jsonEncode(settings);
      return await _preferences!.setString(_keyPrivacySettings, settingsJson);
    } catch (e) {
      debugPrint('❌ Failed to save privacy settings: $e');
      return false;
    }
  }

  Map<String, bool> getPrivacySettings() {
    _ensureInitialized();
    try {
      final String? settingsJson = _preferences!.getString(_keyPrivacySettings);
      if (settingsJson != null) {
        final dynamic decoded = jsonDecode(settingsJson);
        if (decoded is Map<String, dynamic>) {
          return decoded.cast<String, bool>();
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to load privacy settings: $e');
    }
    // Default privacy settings
    return {
      'shareDataForAnalytics': false,
      'allowPersonalizedAds': false,
      'shareProgressWithFriends': true,
      'allowNotifications': true,
      'shareLocationData': false,
    };
  }

  // Data Sync
  Future<bool> setDataSyncEnabled(bool enabled) async {
    _ensureInitialized();
    return await _preferences!.setBool(_keyDataSync, enabled);
  }

  bool getDataSyncEnabled() {
    _ensureInitialized();
    return _preferences!.getBool(_keyDataSync) ?? true;
  }

  // Auto Sharing
  Future<bool> setAutoSharingEnabled(bool enabled) async {
    _ensureInitialized();
    return await _preferences!.setBool(_keyAutoSharing, enabled);
  }

  bool getAutoSharingEnabled() {
    _ensureInitialized();
    return _preferences!.getBool(_keyAutoSharing) ?? false;
  }

  // Utility Methods
  Future<bool> clearAllPreferences() async {
    _ensureInitialized();
    return await _preferences!.clear();
  }

  Future<bool> clearUserData() async {
    _ensureInitialized();
    // Clear only user-specific data, keep app settings
    final List<String> keysToRemove = [
      _keyReminderHistory,
      _keyUserReminders,
      _keyWellnessGoals,
    ];
    
    bool success = true;
    for (final key in keysToRemove) {
      success = success && await _preferences!.remove(key);
    }
    return success;
  }

  Future<bool> exportUserData() async {
    _ensureInitialized();
    try {
      final Map<String, dynamic> userData = {
        'reminders': getUserReminders(),
        'reminderHistory': getReminderHistory(),
        'wellnessGoals': getWellnessGoals(),
        'preferences': {
          'themeMode': getThemeMode(),
          'notificationsEnabled': getNotificationsEnabled(),
          'language': getLanguage(),
          'fontSize': getFontSize(),
          'darkModeEnabled': getDarkModeEnabled(),
          'dataSyncEnabled': getDataSyncEnabled(),
          'autoSharingEnabled': getAutoSharingEnabled(),
        },
        'privacySettings': getPrivacySettings(),
        'exportedAt': DateTime.now().toIso8601String(),
      };

      debugPrint('📤 User data exported: ${userData.keys}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to export user data: $e');
      return false;
    }
  }

  Future<bool> importUserData(Map<String, dynamic> userData) async {
    _ensureInitialized();
    try {
      // Import reminders
      if (userData['reminders'] != null && userData['reminders'] is List) {
        await saveUserReminders(List<Map<String, dynamic>>.from(userData['reminders'] as List));
      }

      // Import wellness goals
      if (userData['wellnessGoals'] != null && userData['wellnessGoals'] is List) {
        await setWellnessGoals(List<String>.from(userData['wellnessGoals'] as List));
      }

      // Import preferences
      if (userData['preferences'] != null && userData['preferences'] is Map) {
        final prefs = userData['preferences'] as Map<String, dynamic>;
        if (prefs['themeMode'] != null) await setThemeMode(prefs['themeMode'] as String);
        if (prefs['notificationsEnabled'] != null) await setNotificationsEnabled(prefs['notificationsEnabled'] as bool);
        if (prefs['language'] != null) await setLanguage(prefs['language'] as String);
        if (prefs['fontSize'] != null) await setFontSize(prefs['fontSize'] as double);
        if (prefs['darkModeEnabled'] != null) await setDarkModeEnabled(prefs['darkModeEnabled'] as bool);
        if (prefs['dataSyncEnabled'] != null) await setDataSyncEnabled(prefs['dataSyncEnabled'] as bool);
        if (prefs['autoSharingEnabled'] != null) await setAutoSharingEnabled(prefs['autoSharingEnabled'] as bool);
      }

      // Import privacy settings
      if (userData['privacySettings'] != null && userData['privacySettings'] is Map) {
        await setPrivacySettings(Map<String, bool>.from(userData['privacySettings'] as Map));
      }

      debugPrint('📥 User data imported successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to import user data: $e');
      return false;
    }
  }

  // Analytics helpers
  int getReminderCompletionCount() {
    return getReminderHistory().length;
  }

  List<Map<String, dynamic>> getRecentReminderActivity(int days) {
    final DateTime cutoffDate = DateTime.now().subtract(Duration(days: days));
    return getReminderHistory()
        .where((entry) => (entry['completedAt'] as DateTime).isAfter(cutoffDate))
        .toList();
  }

  double calculateReminderCompletionRate(String reminderId, int days) {
    final List<Map<String, dynamic>> activity = getRecentReminderActivity(days);
    final int completions = activity.where((entry) => entry['reminderId'] == reminderId).length;
    
    // Assuming daily reminders for calculation
    return completions / days;
  }
}