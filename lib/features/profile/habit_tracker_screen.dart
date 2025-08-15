import 'package:flutter/material.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> habits = [
    {
      'title': 'Drink Water',
      'description': '8 glasses daily',
      'icon': Icons.water_drop,
      'color': Color(0xFF0EA5E9),
      'completedToday': true,
      'streak': 5,
      'targetDays': 7,
      'completedDays': [true, true, false, true, true, true, true],
    },
    {
      'title': 'Morning Exercise',
      'description': '20 minutes workout',
      'icon': Icons.fitness_center,
      'color': Color(0xFF10B981),
      'completedToday': false,
      'streak': 3,
      'targetDays': 7,
      'completedDays': [true, true, true, false, false, false, false],
    },
    {
      'title': 'Meditation',
      'description': '10 minutes daily',
      'icon': Icons.self_improvement,
      'color': Color(0xFF8B5CF6),
      'completedToday': true,
      'streak': 7,
      'targetDays': 7,
      'completedDays': [true, true, true, true, true, true, true],
    },
    {
      'title': 'Read Book',
      'description': '30 minutes reading',
      'icon': Icons.book,
      'color': Color(0xFFEAB308),
      'completedToday': false,
      'streak': 2,
      'targetDays': 7,
      'completedDays': [true, true, false, false, false, false, false],
    },
    {
      'title': 'Gratitude Journal',
      'description': 'Write 3 things',
      'icon': Icons.favorite,
      'color': Color(0xFFEC4899),
      'completedToday': true,
      'streak': 4,
      'targetDays': 7,
      'completedDays': [true, false, true, true, true, false, false],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Habit Tracker',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF8B5CF6)),
            onPressed: _showAddHabitDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          _buildProgressTab(),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    final completedHabits = habits.where((h) => h['completedToday'] as bool).length;
    final completionRate = (completedHabits / habits.length * 100).round();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Overview
          Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today\'s Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completedHabits of ${habits.length} habits completed',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$completionRate%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                LinearProgressIndicator(
                  value: completedHabits / habits.length,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Habits List
          const Text(
            'Today\'s Habits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...habits.map((habit) => _buildHabitCard(habit, isToday: true)),
          
          const SizedBox(height: 24),
          
          // Quick Stats
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekly Overview
          _buildWeeklyOverview(),
          
          const SizedBox(height: 24),
          
          // Individual Habit Progress
          const Text(
            'Habit Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...habits.map((habit) => _buildHabitCard(habit, isToday: false)),
        ],
      ),
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit, {required bool isToday}) {
    final isCompleted = habit['completedToday'] as bool;
    final streak = habit['streak'] as int;
    final completedDays = habit['completedDays'] as List<bool>;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (habit['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  habit['icon'] as IconData,
                  color: habit['color'] as Color,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      habit['description'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (isToday)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      habit['completedToday'] = !(habit['completedToday'] as bool);
                    });
                    _showFeedback(habit['completedToday'] as bool);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? habit['color'] as Color
                          : Colors.transparent,
                      border: Border.all(
                        color: habit['color'] as Color,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
            ],
          ),
          
          if (!isToday) ...[
            const SizedBox(height: 16),
            
            // Weekly progress visualization
            Row(
              children: [
                Text(
                  '${streak} day streak',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: habit['color'] as Color,
                  ),
                ),
                
                const Spacer(),
                
                Row(
                  children: List.generate(7, (index) {
                    final isCompleted = completedDays[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? habit['color'] as Color
                            : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    );
                  }),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalStreaks = habits.fold(0, (sum, habit) => sum + (habit['streak'] as int));
    final perfectHabits = habits.where((h) => (h['streak'] as int) >= 7).length;
    final activeHabits = habits.length;
    
    return _buildCard(
      title: 'Quick Stats',
      child: Row(
        children: [
          _buildStatItem('Total Streaks', '$totalStreaks', Icons.local_fire_department),
          const SizedBox(width: 20),
          _buildStatItem('Perfect Habits', '$perfectHabits', Icons.star),
          const SizedBox(width: 20),
          _buildStatItem('Active Habits', '$activeHabits', Icons.track_changes),
        ],
      ),
    );
  }

  Widget _buildWeeklyOverview() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return _buildCard(
      title: 'This Week\'s Overview',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: days.map((day) {
              final dayIndex = days.indexOf(day);
              final completedCount = habits
                  .where((h) => (h['completedDays'] as List<bool>)[dayIndex])
                  .length;
              final completion = completedCount / habits.length;
              
              return Column(
                children: [
                  Text(
                    day,
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
                      color: completion >= 0.8
                          ? const Color(0xFF10B981)
                          : completion >= 0.5
                              ? const Color(0xFFEAB308)
                              : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$completedCount',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: completion >= 0.5 ? Colors.white : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF0EA5E9), size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Green = 80%+ completed, Yellow = 50%+ completed',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0C4A6E),
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
            Icon(icon, color: const Color(0xFF8B5CF6), size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
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

  void _showFeedback(bool completed) {
    final message = completed ? 'Great job! ✨' : 'Habit unchecked';
    final color = completed ? const Color(0xFF10B981) : const Color(0xFF6B7280);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showAddHabitDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: const Text(
          'Create a custom habit to track daily. You can set goals, choose icons, and monitor your progress over time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Custom habit creation coming soon!'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}