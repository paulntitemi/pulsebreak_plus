import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/tab_toggle.dart';
import 'package:pulsebreak_plus/shared/widgets/wellness_score_card.dart';
import 'package:pulsebreak_plus/shared/widgets/activity_summary_grid.dart';
import 'package:pulsebreak_plus/shared/widgets/todays_focus_section.dart';
import 'package:pulsebreak_plus/shared/widgets/motivation_banner.dart';
import 'package:pulsebreak_plus/services/mood_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Daily Summary', 'Check-ins', 'Nutrition', 'Sleep'];

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

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0: // Daily Summary
        return Column(
          children: [
            // Wellness Score Card
            const WellnessScoreCard(),
            const SizedBox(height: 24),
            
            // Activity Summary Grid
            const ActivitySummaryGrid(),
            const SizedBox(height: 24),
            
            // Today's Focus Section
            const TodaysFocusSection(),
            const SizedBox(height: 24),
            
            // Motivation Banner
            const MotivationBanner(),
          ],
        );
        
      case 1: // Check-ins
        return Column(
          children: [
            // Recent Check-ins Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F4F8), Color(0xFFF0F9FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.assignment_turned_in, color: Color(0xFF10B981), size: 28),
                      const SizedBox(width: 12),
                      const Text('Recent Check-ins', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2E3A59))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCheckInItem('Mood Check-in', '2 hours ago', '😊 Happy', Color(0xFF10B981)),
                  _buildCheckInItem('Energy Level', '4 hours ago', '⚡ High Energy', Color(0xFFEAB308)),
                  _buildCheckInItem('Stress Level', '6 hours ago', '😌 Low Stress', Color(0xFF8B5CF6)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Quick Check-in Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Check-in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildQuickCheckInButton('Mood', Icons.sentiment_satisfied, Color(0xFF8B5CF6))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildQuickCheckInButton('Energy', Icons.bolt, Color(0xFFEAB308))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildQuickCheckInButton('Stress', Icons.psychology, Color(0xFF0EA5E9))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
        
      case 2: // Nutrition
        return Column(
          children: [
            // Nutrition Overview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant, color: Color(0xFF10B981), size: 28),
                      const SizedBox(width: 12),
                      const Text('Today\'s Nutrition', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2E3A59))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildNutritionStat('Calories', '1,540', '/ 2,000', Color(0xFF10B981))),
                      Expanded(child: _buildNutritionStat('Protein', '89g', '/ 120g', Color(0xFF0EA5E9))),
                      Expanded(child: _buildNutritionStat('Water', '1.7L', '/ 2.0L', Color(0xFF8B5CF6))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Recent Meals
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Meals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 16),
                  _buildMealItem('Breakfast', 'Oatmeal with berries', '320 cal', '8:30 AM'),
                  _buildMealItem('Lunch', 'Grilled chicken salad', '450 cal', '1:15 PM'),
                  _buildMealItem('Snack', 'Greek yogurt', '120 cal', '3:45 PM'),
                ],
              ),
            ),
          ],
        );
        
      case 3: // Sleep
        return Column(
          children: [
            // Sleep Overview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF3E8FF), Color(0xFFFAF5FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bedtime, color: Color(0xFF8B5CF6), size: 28),
                      const SizedBox(width: 12),
                      const Text('Last Night\'s Sleep', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2E3A59))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildSleepStat('Duration', '7h 23m', 'Good', Color(0xFF10B981))),
                      Expanded(child: _buildSleepStat('Quality', '85%', 'Excellent', Color(0xFF8B5CF6))),
                      Expanded(child: _buildSleepStat('Deep Sleep', '2h 15m', 'Normal', Color(0xFF0EA5E9))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Sleep Insights
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sleep Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2E3A59))),
                  const SizedBox(height: 16),
                  _buildSleepInsight('🌙', 'Bedtime Consistency', 'You\'ve been going to bed consistently around 10:30 PM'),
                  _buildSleepInsight('📱', 'Screen Time', 'Consider reducing screen time 1 hour before bed'),
                  _buildSleepInsight('☕', 'Caffeine Intake', 'Last coffee at 2 PM - perfect timing for better sleep'),
                ],
              ),
            ),
          ],
        );
        
      default:
        return Container();
    }
  }
  
  Widget _buildCheckInItem(String title, String time, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
        ],
      ),
    );
  }
  
  Widget _buildQuickCheckInButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
  
  Widget _buildNutritionStat(String label, String value, String target, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        Text(target, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      ],
    );
  }
  
  Widget _buildMealItem(String meal, String description, String calories, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.restaurant, color: Color(0xFF6B7280), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(calories, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
              Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSleepStat(String label, String value, String status, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        Text(status, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
      ],
    );
  }
  
  Widget _buildSleepInsight(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF2E3A59))),
                Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoodService.instance.currentBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Hello, Paul!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                    ),
                    // Debug: Clear mood button
                    if (MoodService.instance.currentMood != null)
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Color(0xFF6B7280)),
                        onPressed: () {
                          MoodService.instance.clearMood();
                        },
                        tooltip: 'Clear mood',
                      ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Tab Toggle
                TabToggle(
                  tabs: _tabs,
                  selectedIndex: _selectedTabIndex,
                  onTabSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Tab Content
                _buildTabContent(),
                
                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }
}