import 'package:flutter/material.dart';

class HydrationNutritionScreen extends StatefulWidget {
  const HydrationNutritionScreen({super.key});

  @override
  State<HydrationNutritionScreen> createState() => _HydrationNutritionScreenState();
}

class _HydrationNutritionScreenState extends State<HydrationNutritionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Hydration tracking
  int _waterGlasses = 4;
  final int _waterGoal = 8;
  
  // Nutrition tracking
  final List<Map<String, dynamic>> _todaysMeals = [
    {
      'meal': 'Breakfast',
      'items': ['Oatmeal with berries', 'Greek yogurt'],
      'calories': 320,
      'time': '8:00 AM',
      'icon': Icons.free_breakfast,
      'color': Color(0xFFEAB308),
    },
    {
      'meal': 'Lunch',
      'items': ['Grilled chicken salad', 'Water'],
      'calories': 480,
      'time': '12:30 PM',
      'icon': Icons.lunch_dining,
      'color': Color(0xFF10B981),
    },
    {
      'meal': 'Snack',
      'items': ['Apple', 'Almonds'],
      'calories': 150,
      'time': '3:15 PM',
      'icon': Icons.cookie,
      'color': Color(0xFF8B5CF6),
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
          'Hydration & Nutrition',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0EA5E9),
          labelColor: const Color(0xFF0EA5E9),
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Hydration'),
            Tab(text: 'Nutrition'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHydrationTab(),
          _buildNutritionTab(),
        ],
      ),
    );
  }

  Widget _buildHydrationTab() {
    final progress = _waterGlasses / _waterGoal;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Water Progress Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEBF8FF),
                  Color(0xFFF0F9FF),
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
                          'Today\'s Hydration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_waterGlasses of $_waterGoal glasses',
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
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Color(0xFF0EA5E9),
                        size: 30,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Progress Bar
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress * 100).round()}% Complete',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        Text(
                          '${(_waterGoal - _waterGlasses)} left',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Water glasses visualization
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_waterGoal, (index) {
                    final isFilled = index < _waterGlasses;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (index < _waterGlasses) {
                            _waterGlasses = index;
                          } else {
                            _waterGlasses = index + 1;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isFilled 
                              ? const Color(0xFF0EA5E9)
                              : Colors.transparent,
                          border: Border.all(
                            color: isFilled 
                                ? const Color(0xFF0EA5E9)
                                : const Color(0xFFE5E7EB),
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: isFilled
                            ? const Icon(
                                Icons.water_drop,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions
          _buildCard(
            title: 'Quick Actions',
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.add,
                  title: 'Add Water',
                  subtitle: 'Log a glass of water',
                  color: const Color(0xFF0EA5E9),
                  onTap: () {
                    setState(() {
                      if (_waterGlasses < _waterGoal) _waterGlasses++;
                    });
                    _showSuccessMessage('Water logged! 💧');
                  },
                ),
                
                const SizedBox(height: 12),
                
                _buildActionButton(
                  icon: Icons.remove,
                  title: 'Remove Water',
                  subtitle: 'Undo last glass',
                  color: const Color(0xFFEF4444),
                  onTap: () {
                    setState(() {
                      if (_waterGlasses > 0) _waterGlasses--;
                    });
                    _showInfoMessage('Last glass removed');
                  },
                ),
                
                const SizedBox(height: 12),
                
                _buildActionButton(
                  icon: Icons.history,
                  title: 'View History',
                  subtitle: 'See past hydration trends',
                  color: const Color(0xFF6B7280),
                  onTap: () {
                    _showComingSoonDialog('Hydration History');
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Hydration Tips
          _buildCard(
            title: 'Hydration Tips',
            child: Column(
              children: [
                _buildTipItem(
                  '💡',
                  'Start your day with a glass of water',
                  'Kickstart your metabolism and hydration',
                ),
                const SizedBox(height: 16),
                _buildTipItem(
                  '⏰',
                  'Set regular water reminders',
                  'Stay consistent throughout the day',
                ),
                const SizedBox(height: 16),
                _buildTipItem(
                  '🍋',
                  'Add flavor with fruits',
                  'Make water more enjoyable naturally',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTab() {
    final totalCalories = _todaysMeals.fold<int>(
      0, 
      (sum, meal) => sum + (meal['calories'] as int),
    );
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calories Summary Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFEF3C7),
                  Color(0xFFFFFBEB),
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
                          'Today\'s Nutrition',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalCalories calories consumed',
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
                        color: const Color(0xFFEAB308).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Color(0xFFEAB308),
                        size: 30,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    _buildNutritionStat('Meals', '${_todaysMeals.length}'),
                    const SizedBox(width: 32),
                    _buildNutritionStat('Avg/Meal', '${(totalCalories / _todaysMeals.length).round()}'),
                    const SizedBox(width: 32),
                    _buildNutritionStat('Goal', '2000'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Today's Meals
          _buildCard(
            title: 'Today\'s Meals',
            child: Column(
              children: [
                ..._todaysMeals.map((meal) => _buildMealItem(meal)),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.add_circle_outline,
                  title: 'Add Meal',
                  subtitle: 'Log your food intake',
                  color: const Color(0xFF10B981),
                  onTap: () => _showAddMealDialog(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Nutrition Insights
          _buildCard(
            title: 'Nutrition Insights',
            child: Column(
              children: [
                _buildInsightItem(
                  Icons.trending_up,
                  'Calorie Trend',
                  'You\'re eating 15% more vegetables this week',
                  const Color(0xFF10B981),
                ),
                const SizedBox(height: 16),
                _buildInsightItem(
                  Icons.water_drop,
                  'Hydration Balance',
                  'Great job staying hydrated today!',
                  const Color(0xFF0EA5E9),
                ),
                const SizedBox(height: 16),
                _buildInsightItem(
                  Icons.schedule,
                  'Meal Timing',
                  'Consider having dinner earlier for better sleep',
                  const Color(0xFFEAB308),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
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
          ),
        ],
      ),
    );
  }

  Widget _buildMealItem(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (meal['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              meal['icon'] as IconData,
              color: meal['color'] as Color,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meal['meal'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    Text(
                      meal['time'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  (meal['items'] as List<String>).join(', '),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 6),
                
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (meal['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${meal['calories']} cal',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: meal['color'] as Color,
                        ),
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

  Widget _buildInsightItem(IconData icon, String title, String description, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3A59),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E3A59),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
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

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF6B7280),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature functionality will be available in a future update!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Meal'),
        content: const Text('Meal logging functionality will allow you to track your food intake, calories, and nutritional information.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showInfoMessage('Meal logging coming soon!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}