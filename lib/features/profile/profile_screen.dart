import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/stat_card.dart';
import 'package:pulsebreak_plus/shared/widgets/profile_tile.dart';
import 'package:pulsebreak_plus/features/reminders/smart_reminders_screen.dart';
import 'package:pulsebreak_plus/features/analytics/wellness_analytics_screen.dart';
import 'package:pulsebreak_plus/services/mood_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    MoodService.instance.addListener(_onMoodChanged);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    MoodService.instance.removeListener(_onMoodChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onMoodChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoodService.instance.currentBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Header Section
                    _buildHeader(),
                    
                    const SizedBox(height: 32),
                    
                    // Stats Cards Row
                    _buildStatsCards(),
                    
                    const SizedBox(height: 32),
                    
                    // Main Section - Profile Tiles
                    _buildProfileTiles(),
                    
                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Profile Photo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4F8A8B),
                Color(0xFF188038),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F8A8B).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 50,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Name
        const Text(
          'Paul Nti',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Location
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: const Color(0xFF6B7280),
            ),
            const SizedBox(width: 4),
            const Text(
              'Accra, Ghana',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Column(
      children: [
        // First row - Check-ins and Streak
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Check-ins',
                subtitle: 'this week',
                value: '12',
                backgroundColor: const Color(0xFFECFDF5),
                accentColor: const Color(0xFF10B981),
                icon: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Streak',
                subtitle: 'days',
                value: '7',
                backgroundColor: const Color(0xFFEBF8FF),
                accentColor: const Color(0xFF0EA5E9),
                icon: Icons.local_fire_department,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Second row - Average Mood (full width)
        StatCard(
          title: 'Avg Mood',
          subtitle: 'this week',
          value: '😊',
          backgroundColor: const Color(0xFFFEF3C7),
          accentColor: const Color(0xFFEAB308),
          icon: Icons.sentiment_satisfied,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildProfileTiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Wellness',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Profile Tiles
        ProfileTile(
          title: 'Last Check-in',
          subtitle: '2 hours ago',
          icon: Icons.access_time,
          accentColor: const Color(0xFF4F8A8B),
          onTap: () {
            // Navigate to last check-in details
          },
        ),
        
        const SizedBox(height: 12),
        
        ProfileTile(
          title: 'Mood & Energy Trends',
          subtitle: 'Track your mental health journey',
          icon: Icons.trending_up,
          accentColor: const Color(0xFF6366F1),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WellnessAnalyticsScreen()),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        ProfileTile(
          title: 'Hydration & Nutrition',
          subtitle: 'Today\'s water: 4/8 glasses',
          icon: Icons.water_drop,
          accentColor: const Color(0xFF0EA5E9),
          onTap: () {
            // Navigate to hydration logs
          },
        ),
        
        const SizedBox(height: 12),
        
        ProfileTile(
          title: 'Check-In Streak',
          subtitle: 'Current: 7 days • Best: 21 days',
          icon: Icons.local_fire_department,
          accentColor: const Color(0xFFEF4444),
          onTap: () {
            // Navigate to streak details
          },
        ),
        
        const SizedBox(height: 12),
        
        ProfileTile(
          title: 'Micro-Habit Tracker',
          subtitle: '85% completion rate this week',
          icon: Icons.track_changes,
          accentColor: const Color(0xFF10B981),
          onTap: () {
            // Navigate to habit tracker
          },
        ),
        
        const SizedBox(height: 12),
        
        ProfileTile(
          title: 'Journal & Reflections',
          subtitle: '23 entries this month',
          icon: Icons.book,
          accentColor: const Color(0xFF8B5CF6),
          onTap: () {
            // Navigate to journal
          },
        ),
        
        const SizedBox(height: 12),
        
        ProfileTile(
          title: 'Smart Reminders',
          subtitle: 'Manage your wellness notifications',
          icon: Icons.notifications_active,
          accentColor: const Color(0xFF8B5CF6),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SmartRemindersScreen()),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        ProfileTile(
          title: 'Settings',
          subtitle: 'Customize your experience',
          icon: Icons.settings,
          accentColor: const Color(0xFF6B7280),
          onTap: () {
            // Navigate to settings
          },
        ),
      ],
    );
  }
}