import 'package:flutter/material.dart';

class SummaryMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color backgroundColor;
  final Color accentColor;
  final bool showProgress;
  final double progressValue;
  final VoidCallback onTap;

  const SummaryMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.backgroundColor,
    required this.accentColor,
    required this.onTap,
    this.showProgress = false,
    this.progressValue = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 20,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: value.contains('😊') ? 24 : 20,
                fontWeight: FontWeight.w800,
                color: accentColor,
                height: 1.2,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Title and subtitle
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                  TextSpan(
                    text: ' $subtitle',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: accentColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // Progress bar (only for hydration)
            if (showProgress) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}