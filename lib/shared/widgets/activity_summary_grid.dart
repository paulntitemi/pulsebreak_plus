import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/summary_metric_card.dart';

class ActivitySummaryGrid extends StatelessWidget {
  const ActivitySummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row
        Row(
          children: [
            Expanded(
              child: SummaryMetricCard(
                icon: Icons.check_circle,
                title: 'Check-ins',
                value: '12',
                subtitle: 'this week',
                backgroundColor: const Color(0xFFECFDF5),
                accentColor: const Color(0xFF10B981),
                onTap: () {
                  // Navigate to check-in stats
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryMetricCard(
                icon: Icons.local_fire_department,
                title: 'Streak',
                value: '7',
                subtitle: 'days',
                backgroundColor: const Color(0xFFFEF3C7),
                accentColor: const Color(0xFFEAB308),
                onTap: () {
                  // Navigate to streak details
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Second row
        Row(
          children: [
            Expanded(
              child: SummaryMetricCard(
                icon: Icons.sentiment_satisfied,
                title: 'Mood',
                value: '😊',
                subtitle: 'Energetic',
                backgroundColor: const Color(0xFFF3E8FF),
                accentColor: const Color(0xFF8B5CF6),
                onTap: () {
                  // Navigate to mood tracking
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryMetricCard(
                icon: Icons.water_drop,
                title: 'Hydration',
                value: '1700ml',
                subtitle: '/ 2000ml',
                backgroundColor: const Color(0xFFEBF8FF),
                accentColor: const Color(0xFF0EA5E9),
                showProgress: true,
                progressValue: 0.85, // 1700/2000
                onTap: () {
                  // Navigate to hydration page
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}