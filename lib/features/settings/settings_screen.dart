import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/services/settings_service.dart';
import 'package:pulsebreak_plus/services/theme_service.dart';
import 'package:pulsebreak_plus/services/auth_service.dart';
import 'package:pulsebreak_plus/services/user_service.dart';
import 'package:pulsebreak_plus/features/settings/edit_profile_screen.dart';
import 'package:pulsebreak_plus/features/settings/notification_settings_screen.dart';
import 'package:pulsebreak_plus/features/settings/help_center_screen.dart';
import 'package:pulsebreak_plus/features/settings/privacy_policy_screen.dart';
import 'package:pulsebreak_plus/features/settings/change_password_screen.dart';
import 'package:pulsebreak_plus/features/auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService.instance;
  final ThemeService _themeService = ThemeService.instance;
  String _firstName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = AuthService.instance.currentUser;
    if (user != null) {
      final userModel = await UserService.instance.getUserProfile(user.uid);
      if (userModel != null && mounted) {
        setState(() {
          _firstName = userModel.firstName;
          _userEmail = userModel.email;
        });
      }
    }
  }

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
  ];

  final List<String> _themes = ['Light', 'Dark', 'System'];
  final List<String> _reminderOptions = ['Never', 'Daily', 'Weekly', 'Custom'];
  final List<String> _exportFormats = ['JSON', 'CSV', 'PDF'];

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
          'Settings',
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
            // Account Section
            _buildSectionHeader('Account'),
            _buildAccountSection(),
            
            const SizedBox(height: 32),
            
            // Appearance Section
            _buildSectionHeader('Appearance'),
            _buildAppearanceSection(),
            
            const SizedBox(height: 32),
            
            // Notifications Section
            _buildSectionHeader('Notifications'),
            _buildNotificationsSection(),
            
            const SizedBox(height: 32),
            
            // App Behavior Section
            _buildSectionHeader('App Behavior'),
            _buildAppBehaviorSection(),
            
            const SizedBox(height: 32),
            
            // Privacy & Data Section
            _buildSectionHeader('Privacy & Data'),
            _buildPrivacySection(),
            
            const SizedBox(height: 32),
            
            // Support Section
            _buildSectionHeader('Support'),
            _buildSupportSection(),
            
            const SizedBox(height: 32),
            
            // Danger Zone
            _buildSectionHeader('Account Management'),
            _buildDangerZone(),
            
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

  Widget _buildAccountSection() {
    return _buildSettingsCard([
      _buildSettingsTile(
        icon: Icons.person_outline,
        title: 'Edit Profile',
        subtitle: _firstName.isNotEmpty 
            ? 'Signed in as $_firstName' 
            : 'Update your personal information',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => const EditProfileScreen()),
        ),
      ),
      _buildSettingsTile(
        icon: Icons.email_outlined,
        title: 'Change Email',
        subtitle: _userEmail.isNotEmpty ? _userEmail : _settingsService.userEmail,
        onTap: _showComingSoon,
      ),
      _buildSettingsTile(
        icon: Icons.lock_outline,
        title: 'Change Password',
        subtitle: 'Update your account password',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => const ChangePasswordScreen()),
        ),
      ),
      _buildSettingsTile(
        icon: Icons.security,
        title: 'Two-Factor Authentication',
        subtitle: 'Secure your account',
        onTap: _showComingSoon,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Off',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFEF4444),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildAppearanceSection() {
    return _buildSettingsCard([
      _buildDropdownTile(
        icon: Icons.palette_outlined,
        title: 'Theme',
        subtitle: 'Choose your preferred theme',
        value: _themeService.selectedTheme.name,
        options: _themes,
        onChanged: (value) {
          final themeEnum = AppTheme.values.firstWhere(
            (theme) => theme.name == value!,
            orElse: () => AppTheme.system,
          );
          _themeService.setTheme(themeEnum);
          setState(() {});
        },
      ),
      _buildDropdownTile(
        icon: Icons.language,
        title: 'Language',
        subtitle: 'Select your preferred language',
        value: _settingsService.selectedLanguage,
        options: _languages,
        onChanged: (value) {
          _settingsService.setLanguage(value! as String);
          setState(() {});
        },
      ),
      _buildSwitchTile(
        icon: Icons.dark_mode_outlined,
        title: 'Dark Mode',
        subtitle: 'Switch to dark theme',
        value: _themeService.themeMode == ThemeMode.dark,
        onChanged: (value) {
          _themeService.setTheme(value ? AppTheme.dark : AppTheme.light);
          setState(() {});
        },
      ),
    ]);
  }

  Widget _buildNotificationsSection() {
    return _buildSettingsCard([
      _buildSwitchTile(
        icon: Icons.notifications_outlined,
        title: 'Push Notifications',
        subtitle: 'Receive app notifications',
        value: _settingsService.pushNotifications,
        onChanged: (value) => _settingsService.setPushNotifications(value),
      ),
      _buildSwitchTile(
        icon: Icons.email_outlined,
        title: 'Email Notifications',
        subtitle: 'Receive email updates',
        value: _settingsService.emailNotifications,
        onChanged: (value) => _settingsService.setEmailNotifications(value),
      ),
      _buildDropdownTile(
        icon: Icons.schedule,
        title: 'Reminder Frequency',
        subtitle: 'How often to remind you',
        value: _settingsService.reminderFrequency,
        options: _reminderOptions,
        onChanged: (value) {
          _settingsService.setReminderFrequency(value!);
          setState(() {});
        },
      ),
      _buildSettingsTile(
        icon: Icons.tune,
        title: 'Notification Settings',
        subtitle: 'Customize notification preferences',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => const NotificationSettingsScreen()),
        ),
      ),
    ]);
  }

  Widget _buildAppBehaviorSection() {
    return _buildSettingsCard([
      _buildSwitchTile(
        icon: Icons.volume_up_outlined,
        title: 'Sound Effects',
        subtitle: 'Play sounds for app interactions',
        value: _settingsService.soundEffects,
        onChanged: (value) => _settingsService.setSoundEffects(value),
      ),
      _buildSwitchTile(
        icon: Icons.vibration,
        title: 'Haptic Feedback',
        subtitle: 'Enable vibration feedback',
        value: _settingsService.hapticFeedback,
        onChanged: (value) => _settingsService.setHapticFeedback(value),
      ),
      _buildSwitchTile(
        icon: Icons.cloud_upload_outlined,
        title: 'Auto Backup',
        subtitle: 'Automatically backup your data',
        value: _settingsService.autoBackup,
        onChanged: (value) => _settingsService.setAutoBackup(value),
      ),
      _buildSettingsTile(
        icon: Icons.storage,
        title: 'Storage Usage',
        subtitle: '${_settingsService.totalStorageUsed.toInt()} MB used',
        onTap: _showStorageDetails,
      ),
    ]);
  }

  Widget _buildPrivacySection() {
    return _buildSettingsCard([
      _buildSwitchTile(
        icon: Icons.analytics_outlined,
        title: 'Usage Analytics',
        subtitle: 'Help improve the app',
        value: _settingsService.dataCollection,
        onChanged: (value) => _settingsService.setDataCollection(value),
      ),
      _buildSwitchTile(
        icon: Icons.bug_report_outlined,
        title: 'Crash Reporting',
        subtitle: 'Send crash reports to developers',
        value: _settingsService.crashReporting,
        onChanged: (value) => _settingsService.setCrashReporting(value),
      ),
      _buildSettingsTile(
        icon: Icons.privacy_tip_outlined,
        title: 'Privacy Policy',
        subtitle: 'Read our privacy policy',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => const PrivacyPolicyScreen()),
        ),
      ),
      _buildDropdownTile(
        icon: Icons.download_outlined,
        title: 'Data Export Format',
        subtitle: 'Choose export file format',
        value: _settingsService.dataExportFormat,
        options: _exportFormats,
        onChanged: (value) {
          _settingsService.setDataExportFormat(value!);
          setState(() {});
        },
      ),
      _buildSettingsTile(
        icon: Icons.file_download_outlined,
        title: 'Export My Data',
        subtitle: 'Download all your wellness data',
        onTap: _showExportDialog,
      ),
    ]);
  }

  Widget _buildSupportSection() {
    return _buildSettingsCard([
      _buildSettingsTile(
        icon: Icons.help_outline,
        title: 'Help Center',
        subtitle: 'Get help and find answers',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => const HelpCenterScreen()),
        ),
      ),
      _buildSettingsTile(
        icon: Icons.feedback_outlined,
        title: 'Send Feedback',
        subtitle: 'Share your thoughts with us',
        onTap: _showFeedbackDialog,
      ),
      _buildSettingsTile(
        icon: Icons.star_outline,
        title: 'Rate the App',
        subtitle: 'Leave a review on the app store',
        onTap: _showComingSoon,
      ),
      _buildSettingsTile(
        icon: Icons.info_outline,
        title: 'About',
        subtitle: 'Version 1.0.0 (Build 1)',
        onTap: _showAboutDialog,
      ),
    ]);
  }

  Widget _buildDangerZone() {
    return _buildSettingsCard([
      _buildSettingsTile(
        icon: Icons.logout,
        title: 'Sign Out',
        subtitle: 'Sign out of your account',
        onTap: _showSignOutDialog,
        titleColor: const Color(0xFFEF4444),
      ),
      _buildSettingsTile(
        icon: Icons.delete_forever,
        title: 'Delete Account',
        subtitle: 'Permanently delete your account',
        onTap: _showDeleteAccountDialog,
        titleColor: const Color(0xFFEF4444),
      ),
    ]);
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? titleColor,
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
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: titleColor ?? const Color(0xFF2E3A59),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      trailing: trailing ?? const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF9CA3AF),
      ),
      onTap: onTap,
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

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
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
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
      onTap: () => _showDropdownDialog(title, value, options, onChanged),
    );
  }

  void _showDropdownDialog(String title, String currentValue, List<String> options, ValueChanged<String?> onChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) => ListTile(
            title: Text(option),
            trailing: currentValue == option ? const Icon(Icons.check, color: Color(0xFF8B5CF6)) : null,
            onTap: () {
              onChanged(option);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }

  void _showStorageDetails() {
    showDialog(
      context: context,
      builder: (context) {
        final storageBreakdown = _settingsService.getStorageBreakdown();
        return AlertDialog(
          title: const Text('Storage Usage'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total used: ${_settingsService.totalStorageUsed.toInt()} MB\n'),
              ...storageBreakdown.entries.map((entry) => 
                Text('• ${entry.key}: ${entry.value.toInt()} MB')
              ),
            ],
          ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _settingsService.clearCache();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared!')),
              );
            },
            child: const Text('Clear Cache'),
          ),
        ],
      );
      },
    );
  }

  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('We\'d love to hear your thoughts!'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback sent! Thank you.')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Text('Export your data in ${_settingsService.dataExportFormat} format?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data export started...')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'PulseBreak+',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF4F8A8B)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.favorite, color: Colors.white, size: 30),
      ),
      children: [
        const Text('Your personal wellness companion.'),
        const SizedBox(height: 16),
        const Text('Built with ❤️ for your mental health journey.'),
      ],
    );
  }

  void _showSignOutDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              
              debugPrint('Starting sign out process...');
              
              // Try to sign out but don't wait if it hangs
              AuthService.instance.signOut().timeout(
                const Duration(seconds: 2),
                onTimeout: () {
                  debugPrint('AuthService.signOut() timed out, continuing with navigation');
                },
              );
              
              // Navigate immediately to login screen
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
                debugPrint('Navigated to login screen');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion cancelled')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}