import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/features/home/home_screen.dart';
import 'package:pulsebreak_plus/features/dashboard/stats_screen.dart';
import 'package:pulsebreak_plus/features/dashboard/journal_screen.dart';
import 'package:pulsebreak_plus/features/dashboard/settings_screen.dart';
import 'package:pulsebreak_plus/features/profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const StatsScreen(),
    const JournalScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 25,
              offset: const Offset(0, -2),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 0),
              _buildNavItem(Icons.bar_chart_rounded, 1),
              _buildNavItem(Icons.book_rounded, 2),
              _buildNavItem(Icons.person_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF4F8A8B).withValues(alpha: 0.15)
              : Colors.transparent,
          shape: BoxShape.circle, // Force perfect circle
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected 
                ? const Color(0xFF4F8A8B)
                : const Color(0xFF9CA3AF),
            size: 24,
          ),
        ),
      ),
    );
  }
}