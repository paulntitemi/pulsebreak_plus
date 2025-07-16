import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeText;
  final String buttonText;
  final Color backgroundColor;
  final Color accentColor;
  final String icon;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.buttonText,
    required this.backgroundColor,
    required this.accentColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: accentColor,
                  size: 16,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: accentColor.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Time Text
            Text(
              timeText,
              style: TextStyle(
                fontSize: 11,
                color: accentColor.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}