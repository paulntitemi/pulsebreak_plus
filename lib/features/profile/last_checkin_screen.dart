import 'package:flutter/material.dart';
import '../../services/mood_service.dart';

class LastCheckInScreen extends StatefulWidget {
  const LastCheckInScreen({super.key});

  @override
  State<LastCheckInScreen> createState() => _LastCheckInScreenState();
}

class _LastCheckInScreenState extends State<LastCheckInScreen> {
  final MoodService _moodService = MoodService.instance;

  @override
  Widget build(BuildContext context) {
    final moodHistory = _moodService.moodHistory;
    final lastEntry = moodHistory.isNotEmpty ? moodHistory.first : null;
    
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
          'Last Check-In',
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
            if (lastEntry != null) ...[
              // Check-in Summary Card
              _buildSummaryCard(lastEntry),
              
              const SizedBox(height: 24),
              
              // Mood Details
              _buildMoodDetails(lastEntry),
              
              const SizedBox(height: 24),
              
              // Energy & Activity
              _buildEnergyActivity(),
              
              const SizedBox(height: 24),
              
              // Notes Section
              _buildNotesSection(lastEntry),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              _buildQuickActions(),
            ] else ...[
              _buildEmptyState(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(MoodData entry) {
    final timeAgo = _getTimeAgo(entry.timestamp);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            entry.color.withValues(alpha: 0.1),
            entry.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: entry.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    entry.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Feeling ${entry.label}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildStatItem('Mood', entry.label),
                const SizedBox(width: 24),
                _buildStatItem('Categories', '${entry.categories.length}'),
                const SizedBox(width: 24),
                _buildStatItem('Notes', entry.notes.isNotEmpty ? 'Added' : 'None'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
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
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDetails(MoodData entry) {
    return _buildCard(
      title: 'Mood Details',
      child: Column(
        children: [
          _buildCategoryItem('Mood', entry.label, entry.color),
          const SizedBox(height: 16),
          _buildCategoryItem('Categories', entry.categories.join(', '), const Color(0xFF10B981)),
          const SizedBox(height: 16),
          _buildCategoryItem('Timestamp', _formatTime(entry.timestamp), const Color(0xFF6366F1)),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            title == 'Mood' ? Icons.sentiment_satisfied : 
            title == 'Categories' ? Icons.category :
            Icons.access_time,
            color: color,
            size: 20,
          ),
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
                value.isEmpty ? 'Not specified' : value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildEnergyActivity() {
    return _buildCard(
      title: 'Energy & Activity',
      child: Column(
        children: [
          _buildActivityItem(
            icon: Icons.directions_run,
            title: 'Exercise',
            subtitle: '30 min workout',
            color: const Color(0xFF10B981),
          ),
          
          const SizedBox(height: 16),
          
          _buildActivityItem(
            icon: Icons.water_drop,
            title: 'Hydration',
            subtitle: '6/8 glasses',
            color: const Color(0xFF0EA5E9),
          ),
          
          const SizedBox(height: 16),
          
          _buildActivityItem(
            icon: Icons.bedtime,
            title: 'Sleep Quality',
            subtitle: '7.5 hours • Good',
            color: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
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
      ],
    );
  }

  Widget _buildNotesSection(MoodData entry) {
    final notes = entry.notes.isNotEmpty 
        ? entry.notes 
        : 'No notes were added for this check-in.';
    
    return _buildCard(
      title: 'Personal Notes',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          notes,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF374151),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return _buildCard(
      title: 'Quick Actions',
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.add_circle_outline,
            title: 'New Check-In',
            subtitle: 'Record how you\'re feeling now',
            color: const Color(0xFF8B5CF6),
            onTap: () {
              Navigator.pop(context);
              // Navigate to mood check-in
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildActionButton(
            icon: Icons.trending_up,
            title: 'View Trends',
            subtitle: 'See your mood patterns',
            color: const Color(0xFF10B981),
            onTap: () {
              // Navigate to analytics
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildActionButton(
            icon: Icons.edit,
            title: 'Edit Entry',
            subtitle: 'Modify this check-in',
            color: const Color(0xFF6B7280),
            onTap: () {
              _showEditDialog();
            },
          ),
        ],
      ),
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
                color: color.withOpacity(0.1),
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
            color: Colors.black.withOpacity(0.05),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sentiment_satisfied_alt,
              size: 60,
              color: Color(0xFF9CA3AF),
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'No Check-Ins Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Start tracking your mood and energy\nto see your wellness journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 32),
          
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
              'Start Your First Check-In',
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

  void _showEditDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Check-In'),
        content: const Text(
          'This feature allows you to modify your previous check-in entries to keep your wellness data accurate.',
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
                  content: Text('Edit functionality coming soon!'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }
}