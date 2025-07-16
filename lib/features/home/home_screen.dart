import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/activity_card.dart';
import 'package:pulsebreak_plus/shared/widgets/challenge_banner.dart';
import 'package:pulsebreak_plus/shared/widgets/date_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    return 'Today is ${weekdays[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}';
  }

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
                // Top Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Image
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F8A8B), Color(0xFF188038)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F8A8B).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    
                    // Header Text
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Paul 👋🏽',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E3A59),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFormattedDate(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Right Icons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: Color(0xFF6B7280),
                            size: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.settings,
                            color: Color(0xFF6B7280),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Daily Challenge Banner
                const ChallengeBanner(),
                
                const SizedBox(height: 24),
                
                // Friends checking in avatars
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final colors = [
                        const Color(0xFF4F8A8B),
                        const Color(0xFF188038),
                        const Color(0xFF6366F1),
                        const Color(0xFFEF4444),
                        const Color(0xFF8B5CF6),
                      ];
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors[index % colors.length],
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D, E
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Date Selector Strip
                const DateSelector(),
                
                const SizedBox(height: 24),
                
                // Activity Cards Section
                const Text(
                  'Your Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Activity Cards Row
                Row(
                  children: [
                    Expanded(
                      child: ActivityCard(
                        title: 'Morning Check-In',
                        subtitle: 'Reflect on your mood, energy, focus',
                        timeText: 'Available till 12:00 PM',
                        buttonText: 'Check-In',
                        backgroundColor: const Color(0xFFFFF4E6),
                        accentColor: const Color(0xFFEA580C),
                        icon: '☀️',
                        onTap: () {
                          // Navigate to morning check-in
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ActivityCard(
                        title: 'Today\'s Habit Boost',
                        subtitle: 'Hydrate 3x, stretch, take a deep breath',
                        timeText: 'You\'ve done 1 of 3 today',
                        buttonText: 'View Tips',
                        backgroundColor: const Color(0xFFEBF8FF),
                        accentColor: const Color(0xFF0369A1),
                        icon: '💧',
                        onTap: () {
                          // Navigate to habit boost
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 100), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
    );
  }
}