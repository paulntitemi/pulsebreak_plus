import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/features/coach/ai_wellness_coach_screen.dart';

class TodaysFocusSection extends StatefulWidget {
  const TodaysFocusSection({super.key});

  @override
  State<TodaysFocusSection> createState() => _TodaysFocusSectionState();
}

class _TodaysFocusSectionState extends State<TodaysFocusSection> {
  bool _isAffirmationDone = false;
  bool _isMicrohabitDone = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const Text(
            'Today\'s Focus',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Affirmation
          _buildFocusItem(
            icon: Icons.auto_awesome,
            title: 'Daily Affirmation',
            content: 'I am calm, focused, and present.',
            isDone: _isAffirmationDone,
            onToggle: () {
              setState(() {
                _isAffirmationDone = !_isAffirmationDone;
              });
            },
            accentColor: const Color(0xFF8B5CF6),
          ),
          
          const SizedBox(height: 20),
          
          // AI Wellness Coach
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIWellnessCoachScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFF3B82F6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Wellness Coach',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Get personalized wellness guidance',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Microhabit
          _buildFocusItem(
            icon: Icons.spa,
            title: 'Microhabit',
            content: 'Take 1 deep breath before your next task.',
            isDone: _isMicrohabitDone,
            onToggle: () {
              setState(() {
                _isMicrohabitDone = !_isMicrohabitDone;
              });
            },
            accentColor: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusItem({
    required IconData icon,
    required String title,
    required String content,
    required bool isDone,
    required VoidCallback onToggle,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: isDone 
            ? Border.all(color: accentColor, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Icon(
                icon,
                color: accentColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              const Spacer(),
              if (isDone)
                Icon(
                  Icons.check_circle,
                  color: accentColor,
                  size: 20,
                ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Content
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDone 
                  ? accentColor
                  : const Color(0xFF2E3A59),
              fontStyle: title == 'Daily Affirmation' ? FontStyle.italic : FontStyle.normal,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Mark as done button
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDone ? accentColor : accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isDone ? 'Completed ✓' : 'Mark as Done',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDone ? Colors.white : accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}