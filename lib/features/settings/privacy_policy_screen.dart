import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
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
        child: Container(
          padding: const EdgeInsets.all(20),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last updated: January 2025',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              const SizedBox(height: 24),
              
              _buildSection(
                'Introduction',
                'PulseBreak+ ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
              ),
              
              _buildSection(
                'Information We Collect',
                '''• Personal Information: Name, email address, profile information you provide
• Health Data: Mood entries, journal entries, wellness tracking data
• Usage Data: How you interact with the app, features used, time spent
• Device Information: Device type, operating system, app version
• Analytics: Anonymous usage statistics to improve our service''',
              ),
              
              _buildSection(
                'How We Use Your Information',
                '''• Provide and maintain our service
• Personalize your experience
• Send important notifications and updates
• Improve our app based on usage patterns
• Provide customer support
• Ensure security and prevent fraud''',
              ),
              
              _buildSection(
                'Data Security',
                'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. Your data is encrypted both in transit and at rest.',
              ),
              
              _buildSection(
                'Data Sharing',
                'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy. We may share anonymized, aggregated data for research purposes.',
              ),
              
              _buildSection(
                'Your Rights',
                '''• Access your personal data
• Correct inaccurate information
• Delete your account and data
• Export your data
• Opt-out of non-essential communications
• Control sharing preferences''',
              ),
              
              _buildSection(
                'Data Retention',
                'We retain your personal information for as long as your account is active or as needed to provide you services. You may delete your account at any time through the app settings.',
              ),
              
              _buildSection(
                'Children\'s Privacy',
                'Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13. If you become aware that a child has provided us with personal information, please contact us.',
              ),
              
              _buildSection(
                'Changes to Privacy Policy',
                'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
              ),
              
              _buildSection(
                'Contact Us',
                'If you have any questions about this Privacy Policy, please contact us at:\n\nEmail: privacy@pulsebreak.com\nAddress: [Company Address]',
              ),
              
              const SizedBox(height: 32),
              
              // Accept/Acknowledgment buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF8B5CF6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Color(0xFF8B5CF6)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Privacy policy acknowledged'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'I Understand',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}