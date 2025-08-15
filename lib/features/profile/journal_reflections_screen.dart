import 'package:flutter/material.dart';

class JournalReflectionsScreen extends StatefulWidget {
  const JournalReflectionsScreen({super.key});

  @override
  State<JournalReflectionsScreen> createState() => _JournalReflectionsScreenState();
}

class _JournalReflectionsScreenState extends State<JournalReflectionsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> journalEntries = [
    {
      'id': '1',
      'title': 'Morning Gratitude',
      'content': 'Today I\'m grateful for the beautiful sunrise, a warm cup of coffee, and the opportunity to start fresh. Sometimes it\'s the small things that make the biggest difference in our daily happiness.',
      'mood': 'Happy',
      'moodEmoji': '😊',
      'moodColor': Color(0xFF10B981),
      'date': DateTime.now().subtract(Duration(hours: 2)),
      'tags': ['gratitude', 'morning', 'reflection'],
      'wordCount': 87,
    },
    {
      'id': '2', 
      'title': 'Overcoming Challenges',
      'content': 'Had a difficult conversation with a colleague today. It reminded me that conflict resolution is a skill I want to continue developing. I handled it better than I would have six months ago, which shows growth.',
      'mood': 'Thoughtful',
      'moodEmoji': '🤔',
      'moodColor': Color(0xFF6366F1),
      'date': DateTime.now().subtract(Duration(days: 1)),
      'tags': ['work', 'growth', 'communication'],
      'wordCount': 112,
    },
    {
      'id': '3',
      'title': 'Weekend Reflections',
      'content': 'Spent quality time with family this weekend. We went hiking and had meaningful conversations. These moments remind me what truly matters in life. Need to prioritize this more often.',
      'mood': 'Content',
      'moodEmoji': '😌',
      'moodColor': Color(0xFF8B5CF6),
      'date': DateTime.now().subtract(Duration(days: 2)),
      'tags': ['family', 'nature', 'priorities'],
      'wordCount': 95,
    },
    {
      'id': '4',
      'title': 'Learning Journey',
      'content': 'Started reading a new book about mindfulness. The concepts about being present really resonated with me. I want to incorporate more mindful practices into my daily routine.',
      'mood': 'Inspired',
      'moodEmoji': '✨',
      'moodColor': Color(0xFFEC4899),
      'date': DateTime.now().subtract(Duration(days: 4)),
      'tags': ['learning', 'mindfulness', 'books'],
      'wordCount': 78,
    },
  ];

  final List<String> prompts = [
    'What are three things you\'re grateful for today?',
    'Describe a challenge you overcame recently.',
    'What does your ideal day look like?',
    'Write about someone who inspires you.',
    'What lesson did you learn this week?',
    'How have you grown in the past month?',
    'What brings you the most joy?',
    'Describe a moment when you felt truly at peace.',
    'What are your hopes for tomorrow?',
    'Write about a decision you\'re proud of.',
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Journal & Reflections',
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
            onPressed: _showNewEntryDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: const Color(0xFF6B7280),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Recent'),
            Tab(text: 'Prompts'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecentTab(),
          _buildPromptsTab(),
          _buildInsightsTab(),
        ],
      ),
    );
  }

  Widget _buildRecentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Writing Streak Card
          _buildStreakCard(),
          
          const SizedBox(height: 24),
          
          // Recent Entries
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Entries',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3A59),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('View all entries coming soon!')),
                  );
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: Color(0xFF8B5CF6)),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          ...journalEntries.map((entry) => _buildJournalEntryCard(entry)),
        ],
      ),
    );
  }

  Widget _buildPromptsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEBF8FF),
                  Color(0xFFF0F9FF),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFF0EA5E9),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Writing Prompts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get inspired with thoughtful questions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Daily Prompts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...prompts.take(5).map((prompt) => _buildPromptCard(prompt)),
          
          const SizedBox(height: 16),
          
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  // Shuffle prompts for variety
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('More prompts loaded!')),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('More Prompts'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8B5CF6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    final totalEntries = journalEntries.length;
    final averageWordCount = journalEntries.isNotEmpty
        ? journalEntries.map((e) => e['wordCount'] as int).reduce((a, b) => a + b) / totalEntries
        : 0;
    final commonTags = ['gratitude', 'growth', 'reflection', 'mindfulness'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Overview
          _buildCard(
            title: 'Your Journaling Journey',
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatistic('Total Entries', '$totalEntries'),
                    const SizedBox(width: 20),
                    _buildStatistic('Avg Words', '${averageWordCount.round()}'),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    _buildStatistic('This Month', '8'),
                    const SizedBox(width: 20),
                    _buildStatistic('Writing Days', '12'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Mood Patterns
          _buildCard(
            title: 'Mood Patterns',
            child: Column(
              children: [
                _buildMoodPattern('Happy', '😊', 0.4),
                const SizedBox(height: 12),
                _buildMoodPattern('Thoughtful', '🤔', 0.3),
                const SizedBox(height: 12),
                _buildMoodPattern('Content', '😌', 0.2),
                const SizedBox(height: 12),
                _buildMoodPattern('Inspired', '✨', 0.1),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Common Themes
          _buildCard(
            title: 'Common Themes',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: commonTags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#$tag',
                  style: const TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Personal Growth
          _buildCard(
            title: 'Growth Insights',
            child: Column(
              children: [
                _buildInsightItem(
                  Icons.trending_up,
                  'Writing Consistency',
                  'You\'ve been journaling more regularly this month!',
                  const Color(0xFF10B981),
                ),
                const SizedBox(height: 16),
                _buildInsightItem(
                  Icons.psychology,
                  'Emotional Awareness',
                  'Your entries show increasing self-reflection',
                  const Color(0xFF0EA5E9),
                ),
                const SizedBox(height: 16),
                _buildInsightItem(
                  Icons.favorite,
                  'Gratitude Practice',
                  'Gratitude appears in 75% of your recent entries',
                  const Color(0xFFEC4899),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('📝', style: TextStyle(fontSize: 28)),
            ),
          ),
          
          const SizedBox(width: 20),
          
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7 Day Writing Streak',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Keep the momentum going!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '+1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalEntryCard(Map<String, dynamic> entry) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(entry['date'] as DateTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (entry['moodColor'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry['moodEmoji'] as String,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      entry['mood'] as String,
                      style: TextStyle(
                        color: entry['moodColor'] as Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            entry['content'] as String,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF374151),
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Wrap(
                spacing: 6,
                children: (entry['tags'] as List<String>).take(2).map((tag) => 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ).toList(),
              ),
              
              const Spacer(),
              
              Text(
                '${entry['wordCount']} words',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromptCard(String prompt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Text(
              prompt,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
          ),
          
          IconButton(
            onPressed: () => _startWritingWithPrompt(prompt),
            icon: const Icon(
              Icons.edit,
              color: Color(0xFF8B5CF6),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodPattern(String mood, String emoji, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 100, // Increased width to prevent overflow
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mood,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        
        const SizedBox(width: 12),
        
        Text(
          '${(percentage * 100).round()}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistic(String label, String value) {
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showNewEntryDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Journal Entry'),
        content: const Text(
          'Start writing your thoughts, feelings, and reflections. You can add tags, set your mood, and track your personal growth.',
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
                  content: Text('Journal editor coming soon!'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Writing'),
          ),
        ],
      ),
    );
  }

  void _startWritingWithPrompt(String prompt) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Writing Prompt'),
        content: Text('Ready to write about: "$prompt"'),
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
                  content: Text('Opening prompt editor...'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Writing'),
          ),
        ],
      ),
    );
  }
}