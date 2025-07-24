import 'package:flutter/material.dart';

class CommunityUser {
  final String id;
  final String name;
  final String avatar;
  final String currentMood;
  final int streakDays;
  final String lastActivity;
  final bool isOnline;
  final List<String> achievements;

  CommunityUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.currentMood,
    required this.streakDays,
    required this.lastActivity,
    required this.isOnline,
    required this.achievements,
  });
}

class CommunityPost {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String mood;
  final DateTime timestamp;
  final int likes;
  final List<String> comments;
  final String achievement;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.mood,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.achievement,
  });
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Track which posts are liked by current user
  final Set<String> _likedPosts = <String>{};
  
  // Track double-tap like animations
  final Map<String, bool> _showLikeAnimation = <String, bool>{};
  
  final List<CommunityUser> _friends = [
    CommunityUser(
      id: '1',
      name: 'Sarah Chen',
      avatar: '👩‍💼',
      currentMood: '😊',
      streakDays: 12,
      lastActivity: '2 hours ago',
      isOnline: true,
      achievements: ['7-day streak', 'Mindful week'],
    ),
    CommunityUser(
      id: '2',
      name: 'Alex Rivera',
      avatar: '👨‍💻',
      currentMood: '🧘',
      streakDays: 8,
      lastActivity: '5 hours ago',
      isOnline: false,
      achievements: ['Early bird', 'Hydration hero'],
    ),
    CommunityUser(
      id: '3',
      name: 'Maya Patel',
      avatar: '👩‍🎨',
      currentMood: '💪',
      streakDays: 20,
      lastActivity: '1 hour ago',
      isOnline: true,
      achievements: ['3-week warrior', 'Journal master'],
    ),
    CommunityUser(
      id: '4',
      name: 'Chris Johnson',
      avatar: '👨‍🏫',
      currentMood: '😌',
      streakDays: 5,
      lastActivity: '30 min ago',
      isOnline: true,
      achievements: ['Consistent tracker'],
    ),
  ];

  final List<CommunityPost> _recentPosts = [
    CommunityPost(
      id: '1',
      userId: '1',
      userName: 'Sarah Chen',
      userAvatar: '👩‍💼',
      content: 'Just completed my morning meditation! Feeling so centered and ready for the day ahead. 🧘‍♀️',
      mood: '😊',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 8,
      comments: ['Great job!', 'Inspiring!'],
      achievement: '7-day streak',
    ),
    CommunityPost(
      id: '2',
      userId: '3',
      userName: 'Maya Patel',
      userAvatar: '👩‍🎨',
      content: 'Hit my 20-day wellness streak today! Small daily habits really do add up. Keep going everyone! 💪',
      mood: '💪',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 15,
      comments: ['Amazing!', 'You\'re crushing it!', 'Motivation!'],
      achievement: '3-week warrior',
    ),
    CommunityPost(
      id: '3',
      userId: '4',
      userName: 'Chris Johnson',
      userAvatar: '👨‍🏫',
      content: 'Grateful for this beautiful sunrise and my morning coffee. Sometimes it\'s the simple moments that matter most ☕',
      mood: '😌',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 6,
      comments: ['So peaceful'],
      achievement: '',
    ),
  ];

  void _showCreatePostDialog() {
    final TextEditingController postController = TextEditingController();
    String selectedMood = '😊';
    String selectedAchievement = '';
    
    final List<String> moodOptions = ['😊', '😌', '💪', '🧘', '🎉', '😔', '😰', '🤔'];
    final List<String> achievementOptions = [
      '',
      '7-day streak',
      'Morning meditation',
      'Completed workout',
      'Journaled today',
      'Practiced gratitude',
      'Hydration goal met',
      'Good sleep',
      'Mindful moment',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Share with Community',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (postController.text.trim().isNotEmpty) {
                          _addNewPost(postController.text.trim(), selectedMood, selectedAchievement);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post content input
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: postController,
                          maxLines: 4,
                          maxLength: 280,
                          decoration: const InputDecoration(
                            hintText: 'How are you feeling today? Share your wellness journey...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Mood selection
                      const Text(
                        'Current Mood',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: moodOptions.map((mood) => GestureDetector(
                          onTap: () => setModalState(() => selectedMood = mood),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: selectedMood == mood 
                                  ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                                  : const Color(0xFFF3F4F6),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedMood == mood 
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(mood, style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                        )).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Achievement selection
                      const Text(
                        'Share an Achievement (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Colors.white,
                              textTheme: const TextTheme(
                                bodyMedium: TextStyle(
                                  color: Color(0xFF2E3A59),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: selectedAchievement,
                              isExpanded: true,
                              hint: const Text(
                                'Select an achievement',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF2E3A59),
                                fontSize: 14,
                              ),
                              dropdownColor: Colors.white,
                              items: achievementOptions.map((achievement) => DropdownMenuItem(
                                value: achievement,
                                child: Text(
                                  achievement.isEmpty ? 'No achievement' : achievement,
                                  style: const TextStyle(
                                    color: Color(0xFF2E3A59),
                                    fontSize: 14,
                                  ),
                                ),
                              )).toList(),
                              onChanged: (value) => setModalState(() => selectedAchievement = value ?? ''),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewPost(String content, String mood, String achievement) {
    final newPost = CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      userName: 'Paul Nti', // This would come from user service
      userAvatar: '👨‍💻',
      content: content,
      mood: mood,
      timestamp: DateTime.now(),
      likes: 0,
      comments: [],
      achievement: achievement,
    );
    
    setState(() {
      _recentPosts.insert(0, newPost); // Add to beginning of list
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Posted to community feed!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = _recentPosts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = _recentPosts[postIndex];
        
        if (_likedPosts.contains(postId)) {
          // Unlike the post
          _likedPosts.remove(postId);
          _recentPosts[postIndex] = CommunityPost(
            id: post.id,
            userId: post.userId,
            userName: post.userName,
            userAvatar: post.userAvatar,
            content: post.content,
            mood: post.mood,
            timestamp: post.timestamp,
            likes: post.likes - 1,
            comments: post.comments,
            achievement: post.achievement,
          );
        } else {
          // Like the post
          _likedPosts.add(postId);
          _recentPosts[postIndex] = CommunityPost(
            id: post.id,
            userId: post.userId,
            userName: post.userName,
            userAvatar: post.userAvatar,
            content: post.content,
            mood: post.mood,
            timestamp: post.timestamp,
            likes: post.likes + 1,
            comments: post.comments,
            achievement: post.achievement,
          );
        }
      }
    });
  }

  void _showCommentsModal(CommunityPost post) {
    final TextEditingController commentController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          post.userAvatar,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${post.userName}\'s Post',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          Text(
                            '${post.comments.length} comments',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Comments List
              Expanded(
                child: post.comments.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 60,
                              color: Color(0xFFE5E7EB),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No comments yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Be the first to comment!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: post.comments.length,
                        itemBuilder: (context, index) => _buildCommentItem(post.comments[index], index),
                      ),
              ),
              
              // Add Comment Input
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F8A8B),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(
                            color: Color(0xFF2E3A59),
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (comment) {
                            if (comment.trim().isNotEmpty) {
                              _addComment(post.id, comment.trim());
                              commentController.clear();
                              setModalState(() {}); // Refresh the modal
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (commentController.text.trim().isNotEmpty) {
                          _addComment(post.id, commentController.text.trim());
                          commentController.clear();
                          setModalState(() {}); // Refresh the modal
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.send, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(String comment, int index) {
    // Generate different avatars for variety
    final List<String> avatars = ['👤', '👨‍💼', '👩‍💻', '👨‍🎓', '👩‍🎨', '👨‍⚕️', '👩‍🏫'];
    final avatar = avatars[index % avatars.length];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(avatar, style: const TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community Member',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E3A59),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addComment(String postId, String comment) {
    setState(() {
      final postIndex = _recentPosts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = _recentPosts[postIndex];
        final updatedComments = List<String>.from(post.comments)..add(comment);
        
        _recentPosts[postIndex] = CommunityPost(
          id: post.id,
          userId: post.userId,
          userName: post.userName,
          userAvatar: post.userAvatar,
          content: post.content,
          mood: post.mood,
          timestamp: post.timestamp,
          likes: post.likes,
          comments: updatedComments,
          achievement: post.achievement,
        );
      }
    });
  }

  void _handleDoubleTapLike(String postId) {
    // Always like on double tap (don't toggle)
    if (!_likedPosts.contains(postId)) {
      _toggleLike(postId);
    }
    
    // Show heart scale animation
    setState(() {
      _showLikeAnimation[postId] = true;
    });
    
    // Hide animation after 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showLikeAnimation[postId] = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to show/hide FAB based on tab
    });
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
        title: const Text(
          'Community',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color(0xFF6B7280),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search friends coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person_add_rounded,
              color: Color(0xFF6B7280),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add friends coming soon!')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: const Color(0xFF6B7280),
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Friends'),
            Tab(text: 'Challenges'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedTab(),
          _buildFriendsTab(),
          _buildChallengesTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => _showCreatePostDialog(),
              backgroundColor: const Color(0xFF8B5CF6),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildFeedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your wellness summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F4F8),
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '😊',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How are you feeling today?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Share your wellness journey with friends',
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
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _showCreatePostDialog(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'What\'s on your mind?',
                      style: TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent activity header
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),

          const SizedBox(height: 16),

          // Posts
          ..._recentPosts.map((post) => _buildPostCard(post)),
        ],
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return GestureDetector(
      onDoubleTap: () => _handleDoubleTapLike(post.id),
      child: Container(
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
        child: Stack(
          children: [
            Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    post.userAvatar,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.userName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          post.mood,
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (post.achievement.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAB308).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🏆', style: TextStyle(fontSize: 10)),
                                const SizedBox(width: 2),
                                Text(
                                  post.achievement,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFEAB308),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatTimestamp(post.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleLike(post.id),
                child: Row(
                  children: [
                    AnimatedScale(
                      scale: _showLikeAnimation[post.id] == true ? 1.5 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _likedPosts.contains(post.id) 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                        size: 18,
                        color: _likedPosts.contains(post.id) 
                            ? const Color(0xFFEF4444) 
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post.likes}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _likedPosts.contains(post.id) 
                            ? const Color(0xFFEF4444) 
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _showCommentsModal(post),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${post.comments.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share functionality coming soon!'),
                      backgroundColor: Color(0xFF8B5CF6),
                    ),
                  );
                },
                child: Transform.rotate(
                  angle: -0.52, // ~30 degrees to 2 o'clock position
                  child: const Icon(
                    Icons.send,
                    size: 18,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
            ],
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Friends summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F4F8),
                  Color(0xFFF0F9FF),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Wellness Circle',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_friends.length} friends • ${_friends.where((f) => f.isOnline).length} online',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Color(0xFF8B5CF6),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Friends list
          const Text(
            'Friends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),

          const SizedBox(height: 16),

          ..._friends.map((friend) => _buildFriendCard(friend)),
        ],
      ),
    );
  }

  Widget _buildFriendCard(CommunityUser friend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    friend.avatar,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              if (friend.isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      friend.currentMood,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${friend.streakDays} day streak • ${friend.lastActivity}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                if (friend.achievements.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: friend.achievements.take(2).map((achievement) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAB308).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        achievement,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFEAB308),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Message friend
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.message_outlined,
                size: 18,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active challenges header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8F4F8),
                  Color(0xFFF0F9FF),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wellness Challenges',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Join friends in wellness goals',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Color(0xFF8B5CF6),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Challenge cards
          _buildChallengeCard(
            '🏃‍♂️ 7-Day Activity Streak',
            'Complete any wellness activity for 7 days straight',
            '156 participants',
            '5/7 days',
            0.71,
            const Color(0xFF10B981),
          ),

          _buildChallengeCard(
            '🧘 Mindful March',
            'Practice mindfulness daily throughout March',
            '89 participants',
            '12/31 days',
            0.39,
            const Color(0xFF8B5CF6),
          ),

          _buildChallengeCard(
            '💧 Hydration Hero',
            'Track water intake for 2 weeks',
            '203 participants',
            '8/14 days',
            0.57,
            const Color(0xFF06B6D4),
          ),

          const SizedBox(height: 24),

          // Upcoming challenges
          const Text(
            'Upcoming Challenges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),

          const SizedBox(height: 16),

          _buildUpcomingChallengeCard(
            '🌱 Spring Wellness Reset',
            'A 30-day comprehensive wellness journey',
            'Starts April 1st',
            '0 friends joined',
          ),

          _buildUpcomingChallengeCard(
            '👥 Team Gratitude',
            'Share daily gratitude with your wellness circle',
            'Starts next Monday',
            '3 friends interested',
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(String title, String description, String participants, String progress, double progressValue, Color color) {
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
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 8),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    progress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  Text(
                    participants,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progressValue,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingChallengeCard(String title, String description, String startDate, String friendsJoined) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$startDate • $friendsJoined',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Join',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}