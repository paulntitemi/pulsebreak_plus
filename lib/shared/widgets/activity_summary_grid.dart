import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/summary_metric_card.dart';
import 'package:pulsebreak_plus/features/hydration/hydration_screen.dart';
import 'package:pulsebreak_plus/features/mood/mood_checkin_screen.dart';
import 'package:pulsebreak_plus/services/mood_service.dart';

class ActivitySummaryGrid extends StatefulWidget {
  const ActivitySummaryGrid({super.key});

  @override
  State<ActivitySummaryGrid> createState() => _ActivitySummaryGridState();
}

class _ActivitySummaryGridState extends State<ActivitySummaryGrid> {

  @override
  void initState() {
    super.initState();
    MoodService.instance.addListener(_onMoodChanged);
  }

  @override
  void dispose() {
    MoodService.instance.removeListener(_onMoodChanged);
    super.dispose();
  }

  void _onMoodChanged() {
    setState(() {});
  }

  void _showCheckInStats(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check-ins This Week',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      Text(
                        '12 total check-ins',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Daily breakdown
              Expanded(
                child: ListView(
                  children: [
                    _buildDailyCheckIn('Today', '3 check-ins', 'Mood, Hydration, Energy', const Color(0xFF10B981), true),
                    _buildDailyCheckIn('Yesterday', '2 check-ins', 'Mood, Sleep Quality', const Color(0xFF10B981), false),
                    _buildDailyCheckIn('Tuesday', '3 check-ins', 'Mood, Hydration, Stress', const Color(0xFF10B981), false),
                    _buildDailyCheckIn('Monday', '2 check-ins', 'Mood, Energy', const Color(0xFF10B981), false),
                    _buildDailyCheckIn('Sunday', '1 check-in', 'Mood', const Color(0xFFEAB308), false),
                    _buildDailyCheckIn('Saturday', '1 check-in', 'Mood', const Color(0xFFEAB308), false),
                    _buildDailyCheckIn('Friday', '0 check-ins', 'No check-ins', const Color(0xFFEF4444), false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStreakDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_fire_department, color: Color(0xFFEAB308), size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Streak',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      Text(
                        '7 days in a row',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Streak stats
              Row(
                children: [
                  Expanded(
                    child: _buildStreakStat('Current', '7', 'days', const Color(0xFFEAB308)),
                  ),
                  Expanded(
                    child: _buildStreakStat('Longest', '14', 'days', const Color(0xFF10B981)),
                  ),
                  Expanded(
                    child: _buildStreakStat('This Month', '23', 'days', const Color(0xFF8B5CF6)),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Streak history
              const Text(
                'Streak History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3A59),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildStreakHistory('Current streak', '7 days', 'Started Jan 10, 2024', const Color(0xFFEAB308), true),
                    _buildStreakHistory('Previous streak', '14 days', 'Dec 20 - Jan 2, 2024', const Color(0xFF10B981), false),
                    _buildStreakHistory('November streak', '9 days', 'Nov 15 - Nov 23, 2023', const Color(0xFF8B5CF6), false),
                    _buildStreakHistory('October streak', '5 days', 'Oct 8 - Oct 12, 2023', const Color(0xFF0EA5E9), false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyCheckIn(String day, String count, String types, Color color, bool isToday) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isToday ? color.withValues(alpha: 0.1) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: isToday ? Border.all(color: color.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isToday ? color : const Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  types,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakStat(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakHistory(String title, String duration, String dates, Color color, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? color.withValues(alpha: 0.1) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: color.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isCurrent ? Icons.local_fire_department : Icons.history,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCurrent ? color : const Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dates,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Text(
            duration,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

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
                  _showCheckInStats(context);
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
                  _showStreakDetails(context);
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
                value: MoodService.instance.currentMood?.emoji ?? '😐',
                subtitle: MoodService.instance.getMoodSubtitle(),
                backgroundColor: MoodService.instance.currentMood?.color.withValues(alpha: 0.1) ?? const Color(0xFFF3E8FF),
                accentColor: MoodService.instance.currentMood?.color ?? const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (context) => const MoodCheckinScreen()),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (context) => const HydrationScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}