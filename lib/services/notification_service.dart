import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();
      
      // Android settings
      const AndroidInitializationSettings androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS settings
      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      await _requestPermissions();
      _isInitialized = true;
      
      debugPrint('✅ NotificationService initialized successfully');
    } catch (e) {
      debugPrint('❌ NotificationService initialization failed: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      debugPrint('📱 Android notification permission: $status');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: false,
          );
      debugPrint('🍎 iOS notification permissions requested');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    // Handle notification tap here - could navigate to specific screens
  }

  // Schedule a wellness reminder
  Future<void> scheduleWellnessReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) {
      debugPrint('⚠️ NotificationService not initialized');
      return;
    }

    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'wellness_reminders',
        'Wellness Reminders',
        channelDescription: 'Notifications for wellness activities and reminders',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF8B5CF6),
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        categoryIdentifier: 'wellness_reminders',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);
      
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint('⏰ Scheduled notification: $title at $scheduledTime');
    } catch (e) {
      debugPrint('❌ Failed to schedule notification: $e');
    }
  }

  // Schedule recurring reminder
  Future<void> scheduleRecurringReminder({
    required int id,
    required String title,
    required String body,
    required RepeatInterval interval,
    String? payload,
  }) async {
    if (!_isInitialized) return;

    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'wellness_reminders',
        'Wellness Reminders',
        channelDescription: 'Notifications for wellness activities and reminders',
        importance: Importance.high,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        categoryIdentifier: 'wellness_reminders',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.periodicallyShow(
        id,
        title,
        body,
        interval,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('🔄 Scheduled recurring notification: $title (${interval.name})');
    } catch (e) {
      debugPrint('❌ Failed to schedule recurring notification: $e');
    }
  }

  // Show immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) return;

    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'wellness_alerts',
        'Wellness Alerts',
        channelDescription: 'Immediate wellness notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );

      debugPrint('🔔 Showed immediate notification: $title');
    } catch (e) {
      debugPrint('❌ Failed to show notification: $e');
    }
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    debugPrint('🚫 Cancelled notification: $id');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('🚫 Cancelled all notifications');
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Helper method to convert reminder frequency to RepeatInterval
  RepeatInterval? getRepeatInterval(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return RepeatInterval.daily;
      case 'weekly':
        return RepeatInterval.weekly;
      case 'hourly':
        return RepeatInterval.hourly;
      default:
        return null;
    }
  }

  // Schedule wellness reminder based on reminder data
  Future<void> scheduleReminderNotification(Map<String, dynamic> reminder) async {
    final id = reminder['id'] as int;
    final title = reminder['title'] as String;
    final description = reminder['description'] as String;
    final frequency = reminder['frequency'] as String;
    final timeString = reminder['time'] as String;
    
    try {
      // For demo purposes, schedule notifications for supported intervals
      final interval = getRepeatInterval(frequency);
      
      if (interval != null) {
        await scheduleRecurringReminder(
          id: id,
          title: title,
          body: description,
          interval: interval,
          payload: 'reminder_$id',
        );
      } else {
        // For custom times like "8:00 AM", we'll show immediate notification for demo
        await showNotification(
          id: id,
          title: '✅ Reminder Set!',
          body: '$title - $timeString ($frequency)',
          payload: 'reminder_created_$id',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to schedule reminder notification: $e');
    }
  }
}