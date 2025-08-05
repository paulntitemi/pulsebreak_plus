import 'package:flutter/material.dart';

class WellnessChallengesScreen extends StatefulWidget {
  const WellnessChallengesScreen({super.key});

  @override
  State<WellnessChallengesScreen> createState() => _WellnessChallengesScreenState();
}

class _WellnessChallengesScreenState extends State<WellnessChallengesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _activeChallenges = [
    {
      'id': 1,
      'title': '7-Day Hydration Challenge',
      'description': 'Drink 8 glasses of water daily for 7 days',
      'category': 'Hydration',
      'progress': 0.71,
      'daysCompleted': 5,
      'totalDays': 7,
      'icon': Icons.water_drop,
      'color': const Color(0xFF0EA5E9),
      'backgroundColor': const Color(0xFFEBF8FF),
      'reward': '50 wellness points',
      'deadline': '2 days left',
      'participants': 2847,
    },
    {
      'id': 2,
      'title': 'Morning Mood Check-in',
      'description': 'Check in with your mood every morning for 14 days',
      'category': 'Mindfulness',
      'progress': 0.43,
      'daysCompleted': 6,
      'totalDays': 14,
      'icon': Icons.sentiment_satisfied,
      'color': const Color(0xFF8B5CF6),
      'backgroundColor': const Color(0xFFF3E8FF),
      'reward': '100 wellness points',
      'deadline': '8 days left',
      'participants': 1205,
    },
  ];

  final List<Map<String, dynamic>> _featuredChallenges = [
    {
      'id': 3,
      'title': 'Sleep Optimization',
      'description': 'Get 7+ hours of sleep for 21 days',
      'category': 'Sleep',
      'duration': '21 days',
      'difficulty': 'Medium',
      'icon': Icons.bedtime,
      'color': const Color(0xFF8B5CF6),
      'backgroundColor': const Color(0xFFF3E8FF),
      'reward': '200 wellness points',
      'participants': 5624,
      'featured': true,
    },
    {
      'id': 4,
      'title': 'Stress-Free Week',
      'description': 'Practice stress management techniques daily',
      'category': 'Mental Health',
      'duration': '7 days',
      'difficulty': 'Easy',
      'icon': Icons.psychology,
      'color': const Color(0xFF10B981),
      'backgroundColor': const Color(0xFFECFDF5),
      'reward': '75 wellness points',
      'participants': 3891,
      'featured': true,
    },
    {
      'id': 5,
      'title': 'Nutrition Tracking',
      'description': 'Log all your meals and snacks for 10 days',
      'category': 'Nutrition',
      'duration': '10 days',
      'difficulty': 'Hard',
      'icon': Icons.restaurant,
      'color': const Color(0xFFEAB308),
      'backgroundColor': const Color(0xFFFEF3C7),
      'reward': '150 wellness points',
      'participants': 2156,
      'featured': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wellness Challenges',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF2E3A59)),
            onPressed: () {
              _showChallengeInfo(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Featured'),
            Tab(text: 'My Stats'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(),
          _buildFeaturedTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_activeChallenges.isNotEmpty) ...[
            const Text(
              'Your Active Challenges',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E3A59),
              ),
            ),
            const SizedBox(height: 16),
            ..._activeChallenges.map((challenge) => _buildActiveChallengeCard(challenge)),
          ] else ...[
            _buildEmptyState(),
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Challenges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          const SizedBox(height: 16),
          ..._featuredChallenges.map((challenge) => _buildFeaturedChallengeCard(challenge)),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFF3B82F6),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.emoji_events, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Challenge Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildStatItem('Completed', '12', 'challenges')),
                    Expanded(child: _buildStatItem('Current', '2', 'active')),
                    Expanded(child: _buildStatItem('Points', '1,250', 'earned')),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recent achievements
          const Text(
            'Recent Achievements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildAchievementCard('Hydration Master', 'Completed 5 hydration challenges', Icons.water_drop, const Color(0xFF0EA5E9)),
          _buildAchievementCard('Mood Tracker', 'Tracked mood for 30 days straight', Icons.sentiment_satisfied, const Color(0xFF8B5CF6)),
          _buildAchievementCard('Sleep Champion', 'Achieved 7+ hours sleep for 21 days', Icons.bedtime, const Color(0xFF10B981)),
          
          const SizedBox(height: 24),
          
          // Challenge history
          const Text(
            'Challenge History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildHistoryCard('Mindful Moments', 'Completed • 14 days', '150 points', true),
          _buildHistoryCard('Step Challenge', 'Completed • 7 days', '75 points', true),
          _buildHistoryCard('Nutrition Focus', 'Failed • 3/10 days', '25 points', false),
        ],
      ),
    );
  }

  Widget _buildActiveChallengeCard(Map<String, dynamic> challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: challenge['backgroundColor'] as Color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (challenge['color'] as Color).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (challenge['color'] as Color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(challenge['icon'] as IconData, color: challenge['color'] as Color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    Text(
                      challenge['category'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: challenge['color'] as Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                challenge['deadline'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            challenge['description'] as String,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progress
          Row(
            children: [
              Text(
                '${challenge['daysCompleted']}/${challenge['totalDays']} days',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: challenge['color'] as Color,
                ),
              ),
              const Spacer(),
              Text(
                '${((challenge['progress'] as double) * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: challenge['color'] as Color,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          LinearProgressIndicator(
            value: challenge['progress'] as double,
            backgroundColor: (challenge['color'] as Color).withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(challenge['color'] as Color),
            minHeight: 6,
          ),
          
          const SizedBox(height: 16),
          
          // Footer
          Row(
            children: [
              Icon(Icons.group, color: challenge['color'] as Color, size: 16),
              const SizedBox(width: 4),
              Text(
                '${challenge['participants']} participants',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (challenge['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  challenge['reward'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: challenge['color'] as Color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedChallengeCard(Map<String, dynamic> challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: challenge['backgroundColor'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(challenge['icon'] as IconData, color: challenge['color'] as Color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          challenge['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        if (challenge['featured'] as bool) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAB308).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'FEATURED',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEAB308),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      challenge['category'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: challenge['color'] as Color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            challenge['description'] as String,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Challenge details
          Row(
            children: [
              _buildDetailChip('Duration', challenge['duration'] as String),
              const SizedBox(width: 12),
              _buildDetailChip('Difficulty', challenge['difficulty'] as String),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Footer
          Row(
            children: [
              Icon(Icons.group, color: challenge['color'] as Color, size: 16),
              const SizedBox(width: 4),
              Text(
                '${challenge['participants']} participants',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (challenge['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  challenge['reward'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: challenge['color'] as Color,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Join button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _joinChallenge(challenge);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: challenge['color'] as Color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Join Challenge',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.emoji_events, color: Color(0xFFEAB308), size: 20),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String title, String status, String points, bool completed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: completed ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Text(
            points,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Active Challenges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Join a challenge to start your wellness journey!',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              _tabController.animateTo(1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text(
              'Browse Challenges',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _joinChallenge(Map<String, dynamic> challenge) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Join ${challenge['title'] as String}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge['description'] as String),
            const SizedBox(height: 16),
            Text('Duration: ${challenge['duration'] as String}'),
            Text('Difficulty: ${challenge['difficulty'] as String}'),
            Text('Reward: ${challenge['reward'] as String}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activeChallenges.add({
                  ...challenge,
                  'progress': 0.0,
                  'daysCompleted': 0,
                  'totalDays': int.parse((challenge['duration'] as String).split(' ')[0]),
                  'deadline': '${(challenge['duration'] as String).split(' ')[0]} days left',
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Joined ${challenge['title'] as String}!'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: challenge['color'] as Color,
            ),
            child: const Text('Join Challenge', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showChallengeInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Wellness Challenges'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wellness challenges help you build healthy habits through fun, achievable goals.'),
            SizedBox(height: 16),
            Text('• Join multiple challenges at once'),
            Text('• Track your progress daily'),
            Text('• Earn wellness points for completion'),
            Text('• Compete with friends and community'),
            Text('• Build lasting healthy habits'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}