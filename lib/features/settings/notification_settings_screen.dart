import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pulsebreak_plus/services/settings_service.dart';
import '../../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final SettingsService _settings = SettingsService.instance;
  final NotificationService _notificationService = NotificationService.instance;

  // Detailed notification settings
  bool _moodReminders = true;
  bool _journalReminders = true;
  bool _hydrationReminders = true;
  bool _exerciseReminders = false;
  bool _sleepReminders = true;
  bool _achievementNotifications = true;
  bool _friendActivity = true;
  bool _challengeUpdates = true;
  bool _weeklyReports = true;
  bool _motivationalQuotes = false;

  TimeOfDay _morningReminderTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _eveningReminderTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            _buildSectionHeader('General'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Master toggle for all notifications',
                value: _settings.pushNotifications,
                onChanged: (value) => _settings.setPushNotifications(value),
              ),
              _buildSwitchTile(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _settings.emailNotifications,
                onChanged: (value) => _settings.setEmailNotifications(value),
              ),
            ]),

            const SizedBox(height: 24),

            // Reminder Settings
            _buildSectionHeader('Reminders'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.sentiment_satisfied,
                title: 'Mood Check-ins',
                subtitle: 'Daily mood tracking reminders',
                value: _moodReminders,
                onChanged: (value) => setState(() => _moodReminders = value),
              ),
              _buildSwitchTile(
                icon: Icons.book_outlined,
                title: 'Journal Entries',
                subtitle: 'Remind me to write in my journal',
                value: _journalReminders,
                onChanged: (value) => setState(() => _journalReminders = value),
              ),
              _buildSwitchTile(
                icon: Icons.water_drop_outlined,
                title: 'Hydration',
                subtitle: 'Water intake reminders',
                value: _hydrationReminders,
                onChanged: (value) => setState(() => _hydrationReminders = value),
              ),
              _buildSwitchTile(
                icon: Icons.fitness_center_outlined,
                title: 'Exercise',
                subtitle: 'Physical activity reminders',
                value: _exerciseReminders,
                onChanged: (value) => setState(() => _exerciseReminders = value),
              ),
              _buildSwitchTile(
                icon: Icons.bedtime_outlined,
                title: 'Sleep',
                subtitle: 'Bedtime and wake-up reminders',
                value: _sleepReminders,
                onChanged: (value) => setState(() => _sleepReminders = value),
              ),
            ]),

            const SizedBox(height: 24),

            // Timing Settings
            _buildSectionHeader('Reminder Times'),
            _buildSettingsCard([
              _buildTimeTile(
                icon: Icons.wb_sunny_outlined,
                title: 'Morning Reminder',
                subtitle: 'Time for morning check-in',
                time: _morningReminderTime,
                onTap: () => _showTimePicker(true),
              ),
              _buildTimeTile(
                icon: Icons.nights_stay_outlined,
                title: 'Evening Reminder',
                subtitle: 'Time for evening reflection',
                time: _eveningReminderTime,
                onTap: () => _showTimePicker(false),
              ),
            ]),

            const SizedBox(height: 24),

            // Social & Achievements
            _buildSectionHeader('Social & Achievements'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.emoji_events_outlined,
                title: 'Achievements',
                subtitle: 'Celebrate your wellness milestones',
                value: _achievementNotifications,
                onChanged: (value) => setState(() => _achievementNotifications = value),
              ),
              _buildSwitchTile(
                icon: Icons.people_outlined,
                title: 'Friend Activity',
                subtitle: 'Updates from your wellness circle',
                value: _friendActivity,
                onChanged: (value) => setState(() => _friendActivity = value),
              ),
              _buildSwitchTile(
                icon: Icons.flag_outlined,
                title: 'Challenge Updates',
                subtitle: 'Progress on wellness challenges',
                value: _challengeUpdates,
                onChanged: (value) => setState(() => _challengeUpdates = value),
              ),
            ]),

            const SizedBox(height: 24),

            // Reports & Insights
            _buildSectionHeader('Reports & Insights'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.analytics_outlined,
                title: 'Weekly Reports',
                subtitle: 'Summary of your wellness progress',
                value: _weeklyReports,
                onChanged: (value) => setState(() => _weeklyReports = value),
              ),
              _buildSwitchTile(
                icon: Icons.format_quote_outlined,
                title: 'Motivational Quotes',
                subtitle: 'Daily inspiration and motivation',
                value: _motivationalQuotes,
                onChanged: (value) => setState(() => _motivationalQuotes = value),
              ),
            ]),

            const SizedBox(height: 24),

            // Test Notification Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _sendTestNotification,
                icon: const Icon(Icons.notifications_outlined),
                label: const Text('Send Test Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2E3A59),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF8B5CF6),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E3A59),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF8B5CF6),
      ),
    );
  }

  Widget _buildTimeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF8B5CF6),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E3A59),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time.format(context),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Future<void> _showTimePicker(bool isMorning) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? _morningReminderTime : _eveningReminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        if (isMorning) {
          _morningReminderTime = picked;
        } else {
          _eveningReminderTime = picked;
        }
      });

      final timeString = picked.format(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${isMorning ? 'Morning' : 'Evening'} reminder time updated to $timeString',
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  void _sendTestNotification() async {
    try {
      // Send actual local notification
      await _notificationService.scheduleWellnessReminder(
        id: 999,
        title: '🌟 PulseBreak+ Test Notification',
        body: 'This is how your wellness reminders will appear!',
        scheduledTime: DateTime.now().add(const Duration(seconds: 1)),
      );

      // Show enhanced notification banner overlay
      _showNotificationBanner();
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Test notification sent! Check your notification panel.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Fallback to visual banner if notification service fails
      _showNotificationBanner();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Showing demo notification (enable notifications in system settings)',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF0EA5E9),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showNotificationBanner() {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: AnimationController(
              duration: const Duration(milliseconds: 300),
              vsync: Navigator.of(context),
            )..forward(),
            curve: Curves.easeOut,
          )),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E), // iOS dark background
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // App Icon - iOS style rounded square
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF8B5CF6),
                            Color(0xFF6366F1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8), // iOS app icon radius
                      ),
                      child: const Center(
                        child: Text(
                          '💜', // Heart emoji as app icon
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Notification content
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // App name and time - iOS style
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PulseBreak+',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'now',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF8E8E93), // iOS secondary text color
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 2),
                          
                          // Notification title
                          Text(
                            'Wellness Reminder 🌟',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          
                          SizedBox(height: 1),
                          
                          // Notification body
                          Text(
                            'This is how your wellness reminders will appear!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8E8E93), // iOS secondary text color
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // iOS-style close button
                    GestureDetector(
                      onTap: () => overlayEntry.remove(),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF48484A), // iOS tertiary fill
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          size: 12,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    // Auto-remove after 4 seconds (like iOS notifications)
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}