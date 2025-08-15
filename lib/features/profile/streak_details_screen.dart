import 'package:flutter/material.dart';

class StreakDetailsScreen extends StatefulWidget {
  const StreakDetailsScreen({super.key});

  @override
  State<StreakDetailsScreen> createState() => _StreakDetailsScreenState();
}

class _StreakDetailsScreenState extends State<StreakDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // Mock streak data
  final int currentStreak = 7;
  final int bestStreak = 21;
  final int totalCheckIns = 156;
  
  final List<Map<String, dynamic>> weeklyData = [
    {'day': 'Mon', 'completed': true, 'date': '12'},
    {'day': 'Tue', 'completed': true, 'date': '13'},
    {'day': 'Wed', 'completed': true, 'date': '14'},
    {'day': 'Thu', 'completed': true, 'date': '15'},
    {'day': 'Fri', 'completed': true, 'date': '16'},
    {'day': 'Sat', 'completed': true, 'date': '17'},
    {'day': 'Sun', 'completed': true, 'date': '18'},
  ];
  
  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'First Check-In',
      'description': 'Completed your first wellness check-in',
      'icon': Icons.star,
      'color': Color(0xFFEAB308),
      'unlocked': true,
    },
    {
      'title': 'Week Warrior',
      'description': 'Maintained a 7-day check-in streak',
      'icon': Icons.local_fire_department,
      'color': Color(0xFFEF4444),
      'unlocked': true,
    },
    {
      'title': 'Consistency King',
      'description': 'Reached a 21-day streak',
      'icon': Icons.emoji_events,
      'color': Color(0xFF10B981),
      'unlocked': true,
    },
    {
      'title': 'Centurion',
      'description': 'Complete 100 total check-ins',
      'icon': Icons.military_tech,
      'color': Color(0xFF8B5CF6),
      'unlocked': true,
    },
    {
      'title': 'Streak Master',
      'description': 'Achieve a 30-day streak',
      'icon': Icons.workspace_premium,
      'color': Color(0xFFEC4899),
      'unlocked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Check-In Streak',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Overview Card
            ScaleTransition(
              scale: _scaleAnimation,
              child: _buildStreakOverview(),
            ),
            
            const SizedBox(height: 24),
            
            // This Week's Progress
            _buildWeeklyProgress(),
            
            const SizedBox(height: 24),
            
            // Statistics
            _buildStatistics(),
            
            const SizedBox(height: 24),
            
            // Achievements
            _buildAchievements(),
            
            const SizedBox(height: 24),
            
            // Motivation
            _buildMotivationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakOverview() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE4E6),
            Color(0xFFFFF0F1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Fire emoji and current streak
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🔥',
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            '$currentStreak Days',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2E3A59),
              letterSpacing: -1,
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Current Streak',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFEAB308),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Best: $bestStreak days',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3A59),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    return _buildCard(
      title: 'This Week\'s Progress',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weeklyData.map((day) {
              return Column(
                children: [
                  Text(
                    day['day'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: (day['completed'] as bool)
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE5E7EB),
                      shape: BoxShape.circle,
                    ),
                    child: (day['completed'] as bool)
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    day['date'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.celebration,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Perfect week! You\'ve checked in every day.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF065F46),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return _buildCard(
      title: 'Statistics',
      child: Column(
        children: [
          Row(
            children: [
              _buildStatItem('Total Check-ins', '$totalCheckIns', Icons.fact_check),
              const SizedBox(width: 24),
              _buildStatItem('This Month', '28', Icons.calendar_today),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              _buildStatItem('Avg per Week', '6.2', Icons.trending_up),
              const SizedBox(width: 24),
              _buildStatItem('Success Rate', '89%', Icons.psychology),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Progress towards next milestone
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Milestone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  '30-Day Streak Master',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: currentStreak / 30,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${30 - currentStreak} days left',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    return _buildCard(
      title: 'Achievements',
      child: Column(
        children: achievements.map((achievement) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (achievement['unlocked'] as bool) 
                  ? const Color(0xFFF9FAFB)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (achievement['unlocked'] as bool) 
                    ? const Color(0xFFE5E7EB)
                    : const Color(0xFFD1D5DB),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (achievement['unlocked'] as bool) 
                        ? (achievement['color'] as Color).withValues(alpha: 0.1)
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: (achievement['unlocked'] as bool)
                        ? achievement['color'] as Color
                        : const Color(0xFF9CA3AF),
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement['title'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: (achievement['unlocked'] as bool)
                              ? const Color(0xFF2E3A59)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: (achievement['unlocked'] as bool)
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (achievement['unlocked'] as bool)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF10B981),
                    size: 20,
                  )
                else
                  const Icon(
                    Icons.lock,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF3E8FF),
            Color(0xFFFAF5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '💪',
            style: TextStyle(fontSize: 40),
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Keep It Going!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 12),
          
          const Text(
            'You\'re doing amazing! Every check-in brings you closer to better mental health. Stay consistent and watch your wellness journey unfold.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to mood check-in
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Check-In Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}