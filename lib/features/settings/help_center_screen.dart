import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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
          'Help Center',
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
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for help...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF8B5CF6)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // FAQ Section
            _buildSectionHeader('Frequently Asked Questions'),
            _buildHelpCard([
              _buildHelpTile(
                icon: Icons.mood,
                title: 'How do I track my mood?',
                subtitle: 'Learn about mood tracking features',
                onTap: () => _showHelpDetails(context, 'Mood Tracking', 
                  'To track your mood:\n\n1. Navigate to the home screen\n2. Tap the mood check-in button\n3. Select your current mood\n4. Add any notes if desired\n5. Save your entry\n\nYour mood data will be saved and you can view trends over time.'),
              ),
              _buildHelpTile(
                icon: Icons.book,
                title: 'How does journaling work?',
                subtitle: 'Understanding the journal feature',
                onTap: () => _showHelpDetails(context, 'Journaling', 
                  'The journal feature allows you to:\n\n• Write daily entries about your thoughts and experiences\n• Add tags to categorize your entries\n• Search through your past entries\n• Export your journal data\n\nTo create an entry, go to the Journal tab and tap the "+" button.'),
              ),
              _buildHelpTile(
                icon: Icons.notifications,
                title: 'Managing notifications',
                subtitle: 'Control your notification preferences',
                onTap: () => _showHelpDetails(context, 'Notifications', 
                  'You can customize notifications in Settings:\n\n• Turn push notifications on/off\n• Set reminder times for mood check-ins\n• Choose which types of reminders you want\n• Set quiet hours\n\nGo to Settings > Notifications to customize your preferences.'),
              ),
            ]),

            const SizedBox(height: 24),

            // Getting Started Section
            _buildSectionHeader('Getting Started'),
            _buildHelpCard([
              _buildHelpTile(
                icon: Icons.play_circle_outline,
                title: 'Quick Start Guide',
                subtitle: 'Learn the basics of PulseBreak+',
                onTap: () => _showHelpDetails(context, 'Quick Start', 
                  'Welcome to PulseBreak+! Here\'s how to get started:\n\n1. Complete your profile setup\n2. Set your notification preferences\n3. Record your first mood entry\n4. Write your first journal entry\n5. Explore the community features\n\nTake your time to explore each feature and make the app your own!'),
              ),
              _buildHelpTile(
                icon: Icons.security,
                title: 'Privacy & Security',
                subtitle: 'How we protect your data',
                onTap: () => _showHelpDetails(context, 'Privacy & Security', 
                  'Your privacy is our priority:\n\n• All data is encrypted in transit and at rest\n• We never share your personal information\n• You control what data to share\n• You can export or delete your data anytime\n• Optional anonymous analytics help us improve\n\nRead our full Privacy Policy in Settings for more details.'),
              ),
            ]),

            const SizedBox(height: 24),

            // Troubleshooting Section
            _buildSectionHeader('Troubleshooting'),
            _buildHelpCard([
              _buildHelpTile(
                icon: Icons.sync_problem,
                title: 'Sync Issues',
                subtitle: 'Problems with data synchronization',
                onTap: () => _showHelpDetails(context, 'Sync Issues', 
                  'If you\'re experiencing sync problems:\n\n1. Check your internet connection\n2. Try logging out and back in\n3. Ensure the app is updated\n4. Restart the app\n5. Clear app cache in Settings\n\nIf issues persist, contact our support team.'),
              ),
              _buildHelpTile(
                icon: Icons.bug_report,
                title: 'Report a Bug',
                subtitle: 'Found something that isn\'t working?',
                onTap: () => _showHelpDetails(context, 'Report a Bug', 
                  'To report a bug:\n\n1. Go to Settings > Send Feedback\n2. Describe what happened\n3. Include steps to reproduce the issue\n4. Mention your device and app version\n\nOur team will investigate and get back to you. You can also enable crash reporting in Settings to help us fix issues faster.'),
              ),
            ]),

            const SizedBox(height: 32),

            // Contact Support
            Center(
              child: Column(
                children: [
                  const Text(
                    'Still need help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Support feature coming soon!'),
                          backgroundColor: Color(0xFF8B5CF6),
                        ),
                      );
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Contact Support'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildHelpCard(List<Widget> children) {
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

  Widget _buildHelpTile({
    required IconData icon,
    required String title,
    required String subtitle,
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
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF9CA3AF),
      ),
      onTap: onTap,
    );
  }

  void _showHelpDetails(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}