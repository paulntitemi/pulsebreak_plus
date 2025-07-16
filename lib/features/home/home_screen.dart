import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/tab_toggle.dart';
import 'package:pulsebreak_plus/shared/widgets/wellness_score_card.dart';
import 'package:pulsebreak_plus/shared/widgets/activity_summary_grid.dart';
import 'package:pulsebreak_plus/shared/widgets/todays_focus_section.dart';
import 'package:pulsebreak_plus/shared/widgets/motivation_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Daily Summary', 'Check-ins', 'Nutrition', 'Sleep'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header
                const Text(
                  'Hello, Paul!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
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
                
                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }
}