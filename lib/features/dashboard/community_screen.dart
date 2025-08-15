import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/messaging_service.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../models/message_model.dart';
import '../../models/chat_model.dart';
import '../messaging/chat_screen.dart';
import '../messaging/chat_list_screen.dart';

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

class PotentialFriend {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final int mutualFriends;
  final List<String> commonInterests;
  final bool isRequested;

  PotentialFriend({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.mutualFriends,
    required this.commonInterests,
    required this.isRequested,
  });
}

class FriendRequest {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String message;
  final DateTime timestamp;
  final bool isIncoming;

  FriendRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.message,
    required this.timestamp,
    required this.isIncoming,
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

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Track which posts are liked by current user
  final Set<String> _likedPosts = <String>{};

  // Track double-tap like animations
  final Map<String, bool> _showLikeAnimation = <String, bool>{};
  
  // Cache for chat IDs to avoid repeated Firebase lookups
  final Map<String, String> _chatIdCache = {};

  // Track custom emoji for mood selection (replaces the 8th emoji)
  String _customMoodEmoji = '🤔';

  // Track friend requests
  final Set<String> _sentRequests = <String>{};

  final List<PotentialFriend> _potentialFriends = [
    PotentialFriend(
      id: 'pf1',
      name: 'Emma Wilson',
      avatar: '👩‍🎓',
      bio:
          'Mindfulness advocate and yoga instructor. Spreading positive vibes!',
      mutualFriends: 3,
      commonInterests: ['Meditation', 'Yoga', 'Journaling'],
      isRequested: false,
    ),
    PotentialFriend(
      id: 'pf2',
      name: 'David Chen',
      avatar: '👨‍💼',
      bio:
          'Software engineer finding balance in tech life. Love hiking and reading.',
      mutualFriends: 1,
      commonInterests: ['Reading', 'Technology', 'Hiking'],
      isRequested: false,
    ),
    PotentialFriend(
      id: 'pf3',
      name: 'Sofia Martinez',
      avatar: '👩‍🎨',
      bio: 'Artist and mental health advocate. Creating art that heals.',
      mutualFriends: 2,
      commonInterests: ['Art Therapy', 'Creative Writing', 'Mindfulness'],
      isRequested: false,
    ),
    PotentialFriend(
      id: 'pf4',
      name: 'James Johnson',
      avatar: '👨‍⚕️',
      bio: 'Wellness coach helping others achieve their mental health goals.',
      mutualFriends: 4,
      commonInterests: ['Fitness', 'Nutrition', 'Coaching'],
      isRequested: false,
    ),
    PotentialFriend(
      id: 'pf5',
      name: 'Luna Rodriguez',
      avatar: '👩‍🏫',
      bio: 'Psychologist and meditation teacher. Here to support your journey.',
      mutualFriends: 2,
      commonInterests: ['Psychology', 'Meditation', 'Self-care'],
      isRequested: false,
    ),
    PotentialFriend(
      id: 'pf6',
      name: 'Alex Thompson',
      avatar: '👨‍🎓',
      bio: 'Student exploring mindfulness and building healthy habits.',
      mutualFriends: 1,
      commonInterests: ['Study Techniques', 'Habit Building', 'Music'],
      isRequested: false,
    ),
  ];

  final List<FriendRequest> _friendRequests = [
    FriendRequest(
      id: 'fr1',
      userId: 'user1',
      userName: 'Oliver Smith',
      userAvatar: '👨‍💻',
      message:
          'Hi! I saw your wellness journey posts and would love to connect!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isIncoming: true,
    ),
    FriendRequest(
      id: 'fr2',
      userId: 'user2',
      userName: 'Zoe Adams',
      userAvatar: '👩‍🔬',
      message:
          'Your mindfulness tips have been so helpful. Let\'s be wellness buddies!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isIncoming: true,
    ),
  ];

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
      content:
          'Just completed my morning meditation! Feeling so centered and ready for the day ahead. 🧘‍♀️',
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
      content:
          'Hit my 20-day wellness streak today! Small daily habits really do add up. Keep going everyone! 💪',
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
      content:
          'Grateful for this beautiful sunrise and my morning coffee. Sometimes it\'s the simple moments that matter most ☕',
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

    final List<String> moodOptions = [
      '😊',
      '😌',
      '💪',
      '🧘',
      '🎉',
      '😔',
      '😰',
      _customMoodEmoji,
    ];
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

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
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
                                  _addNewPost(
                                    postController.text.trim(),
                                    selectedMood,
                                    selectedAchievement,
                                  );
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
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: TextField(
                                  controller: postController,
                                  maxLines: 4,
                                  maxLength: 280,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'How are you feeling today? Share your wellness journey...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                    ),
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
                                children: [
                                  // Regular mood options
                                  ...moodOptions
                                      .map(
                                        (mood) => GestureDetector(
                                          onTap:
                                              () => setModalState(
                                                () => selectedMood = mood,
                                              ),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  selectedMood == mood
                                                      ? const Color(
                                                        0xFF8B5CF6,
                                                      ).withValues(alpha: 0.1)
                                                      : const Color(0xFFF3F4F6),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    selectedMood == mood
                                                        ? const Color(
                                                          0xFF8B5CF6,
                                                        )
                                                        : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                mood,
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  // Plus button for custom emoji
                                  GestureDetector(
                                    onTap:
                                        () => _showEmojiPicker(
                                          context,
                                          setModalState,
                                        ),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(
                                            0xFF8B5CF6,
                                          ).withValues(alpha: 0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Color(0xFF8B5CF6),
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
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
                                      items:
                                          achievementOptions
                                              .map(
                                                (achievement) =>
                                                    DropdownMenuItem(
                                                      value: achievement,
                                                      child: Text(
                                                        achievement.isEmpty
                                                            ? 'No achievement'
                                                            : achievement,
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF2E3A59,
                                                          ),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                              )
                                              .toList(),
                                      onChanged:
                                          (value) => setModalState(
                                            () =>
                                                selectedAchievement =
                                                    value ?? '',
                                          ),
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

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
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
                            GestureDetector(
                              onTap:
                                  () => _showMainProfileExpansion(
                                    post.userAvatar,
                                    post.userName,
                                  ),
                              child: Hero(
                                tag: 'post_profile_${post.id}',
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF8B5CF6,
                                    ).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      post.userAvatar,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
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
                        child:
                            post.comments.isEmpty
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  itemCount: post.comments.length,
                                  itemBuilder:
                                      (context, index) => _buildCommentItem(
                                        post.comments[index],
                                        index,
                                      ),
                                ),
                      ),

                      // Add Comment Input
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E7EB)),
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
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
                                  _addComment(
                                    post.id,
                                    commentController.text.trim(),
                                  );
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
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 16,
                                ),
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
    final List<String> avatars = [
      '👤',
      '👨‍💼',
      '👩‍💻',
      '👨‍🎓',
      '👩‍🎨',
      '👨‍⚕️',
      '👩‍🏫',
    ];
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
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Community Member',
                    style: TextStyle(
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
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showLikeAnimation[postId] = false;
        });
      }
    });
  }

  void _showEmojiPicker(BuildContext context, StateSetter setModalState) {
    final List<String> popularEmojis = [
      '😀',
      '😃',
      '😄',
      '😁',
      '😆',
      '😅',
      '😂',
      '🤣',
      '😊',
      '😇',
      '🙂',
      '🙃',
      '😉',
      '😌',
      '😍',
      '🥰',
      '😘',
      '😗',
      '😙',
      '😚',
      '😋',
      '😛',
      '😝',
      '😜',
      '🤪',
      '🤨',
      '🧐',
      '🤓',
      '😎',
      '🤩',
      '🥳',
      '😏',
      '😒',
      '😞',
      '😔',
      '😟',
      '😕',
      '🙁',
      '☹️',
      '😣',
      '😖',
      '😫',
      '😩',
      '🥺',
      '😢',
      '😭',
      '😤',
      '😠',
      '😡',
      '🤬',
      '🤯',
      '😳',
      '🥵',
      '🥶',
      '😱',
      '😨',
      '😰',
      '😥',
      '😓',
      '🤗',
      '🤔',
      '🤭',
      '🤫',
      '🤥',
      '😶',
      '😐',
      '😑',
      '😬',
      '🙄',
      '😯',
      '😦',
      '😧',
      '😮',
      '😲',
      '🥱',
      '😴',
      '🤤',
      '😪',
      '😵',
      '🤐',
      '🥴',
      '🤢',
      '🤮',
      '🤧',
      '😷',
      '🤒',
      '🤕',
      '🤑',
      '🤠',
      '😈',
      '👿',
      '👹',
      '👺',
      '🤡',
      '💩',
      '👻',
      '💀',
      '☠️',
      '👽',
      '👾',
      '🤖',
      '🎃',
      '😺',
      '😸',
      '😹',
      '😻',
      '😼',
      '😽',
      '🙀',
      '😿',
      '😾',
      '💪',
      '🦾',
      '🦿',
      '🦵',
      '🦶',
      '👂',
      '🦻',
      '👃',
      '🧠',
      '🫀',
      '🫁',
      '🦷',
      '🦴',
      '👀',
      '👁️',
      '👅',
      '👄',
    ];

    showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Choose Custom Emoji',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E3A59),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: popularEmojis.length,
                itemBuilder: (context, index) {
                  final emoji = popularEmojis[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _customMoodEmoji = emoji;
                      });
                      Navigator.pop(context);
                      setModalState(() {}); // Refresh the post creation modal
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Custom emoji $emoji saved!'),
                          backgroundColor: const Color(0xFF10B981),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddFriendsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder:
            (context) => _AddFriendsScreen(
              potentialFriends: _potentialFriends,
              friendRequests: _friendRequests,
              sentRequests: _sentRequests,
              onSendRequest: _sendFriendRequest,
              onAcceptRequest: _acceptFriendRequest,
              onDeclineRequest: _declineFriendRequest,
            ),
      ),
    );
  }

  void _openChatList() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const ChatListScreen(),
      ),
    );
  }

  Future<void> _messageUser(CommunityUser user) async {
    // Check cache first
    String? chatId = _chatIdCache[user.id];
    
    if (chatId != null) {
      // Use cached chat ID - much faster!
      final chat = Chat(
        id: chatId,
        name: user.name,
        participantIds: [user.id],
        participantNames: {user.id: user.name},
        createdAt: DateTime.now(),
        type: ChatType.direct,
        unreadCounts: <String, int>{},
        avatarUrl: user.avatar,
      );
      
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ChatScreen(chat: chat),
        ),
      );
      return;
    }
    
    // Show loading state for first-time chats
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                SizedBox(height: 16),
                Text('Opening chat...'),
              ],
            ),
          ),
        ),
      ),
    );

    final messagingService = MessagingService.instance;
    
    try {
      // Add timeout to prevent hanging
      chatId = await messagingService.createOrGetDirectChat(
        user.id,
        user.name,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Chat creation timed out');
        },
      );
      
      if (chatId != null && mounted) {
        // Cache the chat ID for future use
        _chatIdCache[user.id] = chatId;
        
        // Dismiss loading dialog
        Navigator.pop(context);
        
        // Create chat object
        final chat = Chat(
          id: chatId,
          name: user.name,
          participantIds: [user.id],
          participantNames: {user.id: user.name},
          createdAt: DateTime.now(),
          type: ChatType.direct,
          unreadCounts: <String, int>{},
          avatarUrl: user.avatar,
        );
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => ChatScreen(chat: chat),
            ),
          );
        }
      } else {
        if (mounted) Navigator.pop(context);
        throw Exception('Failed to create chat');
      }
    } catch (e) {
      debugPrint('Error starting chat with user: $e');
      if (mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().contains('timed out') 
                ? 'Chat is taking longer than expected. Please try again.'
                : 'Unable to start chat. Please try again.'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _sendFriendRequest(String friendId) {
    setState(() {
      _sentRequests.add(friendId);
      final friendIndex = _potentialFriends.indexWhere((f) => f.id == friendId);
      if (friendIndex != -1) {
        final friend = _potentialFriends[friendIndex];
        _potentialFriends[friendIndex] = PotentialFriend(
          id: friend.id,
          name: friend.name,
          avatar: friend.avatar,
          bio: friend.bio,
          mutualFriends: friend.mutualFriends,
          commonInterests: friend.commonInterests,
          isRequested: true,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Friend request sent!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _acceptFriendRequest(String requestId) {
    setState(() {
      final requestIndex = _friendRequests.indexWhere((r) => r.id == requestId);
      if (requestIndex != -1) {
        final request = _friendRequests[requestIndex];

        // Add to friends list
        _friends.add(
          CommunityUser(
            id: request.userId,
            name: request.userName,
            avatar: request.userAvatar,
            currentMood: '😊',
            streakDays: 1,
            lastActivity: 'Just now',
            isOnline: true,
            achievements: ['New friend'],
          ),
        );

        // Remove from requests
        _friendRequests.removeAt(requestIndex);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Friend request accepted!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _declineFriendRequest(String requestId) {
    setState(() {
      _friendRequests.removeWhere((r) => r.id == requestId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Friend request declined'),
        backgroundColor: Color(0xFF6B7280),
      ),
    );
  }

  void _showMainProfileExpansion(String avatar, String name) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder:
          (context) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: GestureDetector(
                  onTap:
                      () {}, // Prevent dialog from closing when tapping the content
                  child: Hero(
                    tag: 'profile_expanded',
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          avatar,
                          style: const TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
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
            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF6B7280)),
            onPressed: _openChatList,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF6B7280)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => _SearchFriendsListScreen(
                    friends: _friends,
                    onMessageUser: _messageUser,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person_add_rounded,
              color: Color(0xFF6B7280),
            ),
            onPressed: _showAddFriendsScreen,
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
        children: [_buildFeedTab(), _buildFriendsTab(), _buildChallengesTab()],
      ),
      floatingActionButton:
          _tabController.index == 0
              ? FloatingActionButton(
                onPressed: _showCreatePostDialog,
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
                colors: [Color(0xFFE8F4F8), Color(0xFFF0F9FF)],
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
                        child: Text('😊', style: TextStyle(fontSize: 24)),
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
                  onTap: _showCreatePostDialog,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      ),
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
                    GestureDetector(
                      onTap:
                          () => _showMainProfileExpansion(
                            post.userAvatar,
                            post.userName,
                          ),
                      child: Hero(
                        tag: 'activity_profile_${post.id}',
                        child: Container(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFEAB308,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '🏆',
                                        style: TextStyle(fontSize: 10),
                                      ),
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
                            scale:
                                _showLikeAnimation[post.id] == true ? 1.5 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _likedPosts.contains(post.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color:
                                  _likedPosts.contains(post.id)
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${post.likes}',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  _likedPosts.contains(post.id)
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
                      onTap: () => _showShareDialog(context, post),
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
                colors: [Color(0xFFE8F4F8), Color(0xFFF0F9FF)],
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
          GestureDetector(
            onTap: () => _showMainProfileExpansion(friend.avatar, friend.name),
            child: Stack(
              children: [
                Hero(
                  tag: 'main_profile_${friend.id}',
                  child: Container(
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
                    children:
                        friend.achievements
                            .take(2)
                            .map(
                              (achievement) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFEAB308,
                                  ).withValues(alpha: 0.1),
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
                              ),
                            )
                            .toList(),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _messageUser(friend),
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
                colors: [Color(0xFFE8F4F8), Color(0xFFF0F9FF)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wellness Challenges',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
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

  Widget _buildChallengeCard(
    String title,
    String description,
    String participants,
    String progress,
    double progressValue,
    Color color,
  ) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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

  Widget _buildUpcomingChallengeCard(
    String title,
    String description,
    String startDate,
    String friendsJoined,
  ) {
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

  void _shareToSocialPlatforms(BuildContext context, CommunityPost post) async {
    // Close the share dialog immediately for better UX
    Navigator.pop(context);
    
    // Show loading indicator while preparing share
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Preparing to share...'),
            ],
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF8B5CF6),
        ),
      );
    }

    try {
      // Pre-format the text to avoid computation delay
      final String shareText = _buildShareText(post);

      // Share using the native sharing dialog with timeout
      await Future.any([
        Share.share(
          shareText,
          subject: 'Wellness Update from ${post.userName}',
        ),
        Future<void>.delayed(const Duration(seconds: 5)), // 5 second timeout
      ]);
      
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share post'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _createStoryImage(BuildContext context, CommunityPost post) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Story Image'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library,
              size: 64,
              color: Color(0xFF8B5CF6),
            ),
            SizedBox(height: 16),
            Text(
              'Story image creation will generate a beautiful visual card with your wellness update, perfect for sharing on social media stories.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Coming soon in a future update!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
            ),
            child: const Text('Notify me', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveAsScreenshot(BuildContext context, CommunityPost post) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save as Screenshot'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.save_alt,
              size: 64,
              color: Color(0xFF10B981),
            ),
            SizedBox(height: 16),
            Text(
              'This feature will capture your wellness post as a beautiful image and save it to your device gallery.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Screenshot functionality coming soon!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFF6B7280),
              ),
            ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Screenshot saved to gallery! (Demo)'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: const Text('Save Demo', style: TextStyle(color: Colors.white)),
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

  // Cache for pre-built share texts to avoid repeated computation
  final Map<String, String> _shareTextCache = {};
  
  String _buildShareText(CommunityPost post) {
    // Use post ID as cache key
    final cacheKey = '${post.userName}_${post.timestamp.millisecondsSinceEpoch}';
    
    if (_shareTextCache.containsKey(cacheKey)) {
      return _shareTextCache[cacheKey]!;
    }
    
    final String shareText = '''
🌟 ${post.userName} shared from PulseBreak+

${post.content}

${post.achievement.isNotEmpty ? '🏆 ${post.achievement}' : ''}

❤️ ${post.likes} likes • 💬 ${post.comments.length} comments
⏰ ${_formatTimestamp(post.timestamp)}

#WellnessJourney #MentalHealth #SelfCare
''';
    
    // Cache the result for 5 minutes
    _shareTextCache[cacheKey] = shareText;
    Timer(const Duration(minutes: 5), () => _shareTextCache.remove(cacheKey));
    
    return shareText;
  }

  void _showShareDialog(BuildContext context, CommunityPost post) {
    debugPrint('🔄 Opening share dialog for post by ${post.userName}');
    
    // Pre-cache share text to avoid delays
    _buildShareText(post);
    
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Share Post',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
                ),
              ),

              // Share options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildShareOption(
                      icon: Icons.share,
                      title: 'Share via Apps',
                      subtitle: 'Share to messaging apps, social media, etc.',
                      onTap: () => _shareViaApps(context, post),
                    ),
                    const SizedBox(height: 12),
                    _buildShareOption(
                      icon: Icons.copy,
                      title: 'Copy Text',
                      subtitle: 'Copy post content to clipboard',
                      onTap: () => _copyToClipboard(context, post),
                    ),
                    const SizedBox(height: 12),
                    _buildShareOption(
                      icon: Icons.link,
                      title: 'Copy Link',
                      subtitle: 'Copy a shareable link to this post',
                      onTap: () => _copyLink(context, post),
                    ),
                    const SizedBox(height: 12),
                    _buildShareOption(
                      icon: Icons.message,
                      title: 'Share with Friends',
                      subtitle: 'Send directly to your wellness circle',
                      onTap: () => _shareWithFriends(context, post),
                    ),
                    const SizedBox(height: 12),
                    _buildShareOption(
                      icon: Icons.share,
                      title: 'Share via Apps',
                      subtitle: 'Share through installed social apps',
                      onTap: () => _shareToSocialPlatforms(context, post),
                    ),
                    const SizedBox(height: 12),
                    _buildShareOption(
                      icon: Icons.photo_library,
                      title: 'Create Story Image',
                      subtitle: 'Generate image for social media stories',
                      onTap: () => _createStoryImage(context, post),
                    ),
                    const SizedBox(height: 12),
                    _buildShareOption(
                      icon: Icons.save_alt,
                      title: 'Save as Screenshot',
                      subtitle: 'Save post as image to gallery',
                      onTap: () => _saveAsScreenshot(context, post),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF8B5CF6),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E3A59),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        onTap: onTap,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  void _shareViaApps(BuildContext context, CommunityPost post) {
    Navigator.pop(context);
    
    String shareText = '${post.userName} shared: "${post.content}"';
    
    if (post.achievement.isNotEmpty) {
      shareText += '\n🏆 Achievement: ${post.achievement}';
    }
    
    shareText += '\n\nShared from PulseBreak+ Wellness Community 💚';
    
    Share.share(
      shareText,
      subject: 'Wellness Update from ${post.userName}',
    );
  }

  void _copyToClipboard(BuildContext context, CommunityPost post) {
    Navigator.pop(context);
    
    String copyText = '${post.userName}: "${post.content}"';
    
    if (post.achievement.isNotEmpty) {
      copyText += '\n🏆 ${post.achievement}';
    }
    
    Clipboard.setData(ClipboardData(text: copyText));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post copied to clipboard!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyLink(BuildContext context, CommunityPost post) {
    Navigator.pop(context);
    
    // Generate a mock shareable link (in a real app, this would be a deep link)
    final link = 'https://pulsebreakplus.com/post/${post.id}';
    
    Clipboard.setData(ClipboardData(text: link));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post link copied to clipboard!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareWithFriends(BuildContext context, CommunityPost post) {
    debugPrint('👥 Opening share with friends for post by ${post.userName}');
    Navigator.pop(context);
    
    // Show loading indicator briefly
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loading friends list...'),
        duration: Duration(milliseconds: 500),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
    
    // Show friends list to share with
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
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
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Share with Friends',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
                ),
              ),

              // Friends list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _friends.length,
                  itemBuilder: (context, index) {
                    final friend = _friends[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              friend.avatar,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        title: Text(
                          friend.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        subtitle: Text(
                          friend.isOnline ? 'Online' : friend.lastActivity,
                          style: TextStyle(
                            fontSize: 14,
                            color: friend.isOnline 
                                ? const Color(0xFF10B981) 
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onTap: () => _showMessageInputDialog(context, post, friend),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageInputDialog(BuildContext context, CommunityPost post, CommunityUser friend) {
    Navigator.pop(context); // Close the friends list
    
    final TextEditingController messageController = TextEditingController();
    
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share with ${friend.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a personal message (optional):',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'Hey ${friend.name.split(' ').first}, check this out!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF8B5CF6), width: 2),
                ),
                contentPadding: EdgeInsets.all(12),
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post Preview:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '👤 ${post.userName}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '💬 "${post.content}"',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (post.achievement.isNotEmpty)
                    Text(
                      '🏆 ${post.achievement}',
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
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
              _sendPostToFriend(context, post, friend, messageController.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _sendPostToFriend(BuildContext context, CommunityPost post, CommunityUser friend, [String? personalMessage]) async {
    debugPrint('🚀 Starting to share post with ${friend.name} (ID: ${friend.id})');
    
    try {
      // Check if this is a mock friend (ID is just a number like "1", "2", etc.)
      // For demo purposes, we'll simulate the chat functionality
      if (friend.id.length <= 2 && int.tryParse(friend.id) != null) {
        debugPrint('🎭 Detected mock friend, simulating share functionality...');
        
        // Simulate a delay for realistic feel
        await Future<void>.delayed(const Duration(milliseconds: 500));
        
        // Show success message for demo
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post shared with ${friend.name}! (Demo Mode)'),
              backgroundColor: const Color(0xFF10B981),
              action: SnackBarAction(
                label: 'View Demo',
                textColor: Colors.white,
                onPressed: () {
                  // Show a demo message
                  _showDemoSharedMessage(context, post, friend, personalMessage);
                },
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // For real Firebase users, use the actual messaging service
      debugPrint('📞 Creating/getting chat with real Firebase user...');
      final chatId = await MessagingService.instance.createOrGetDirectChat(
        friend.id,
        friend.name,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('⏰ Chat creation timed out');
          return null;
        },
      );
      
      debugPrint('💬 Chat ID: $chatId');
      
      if (chatId == null) {
        throw Exception('Could not create chat - possibly a connection issue');
      }

      // Format the post content as a message
      String sharedPostMessage = '';
      
      // Add personal message if provided
      if (personalMessage != null && personalMessage.isNotEmpty) {
        sharedPostMessage += '💭 $personalMessage\n\n';
      }
      
      sharedPostMessage += '📢 Shared from Community Feed:\n\n';
      sharedPostMessage += '👤 ${post.userName}\n';
      sharedPostMessage += '💬 "${post.content}"\n';
      
      if (post.achievement.isNotEmpty) {
        sharedPostMessage += '🏆 ${post.achievement}\n';
      }
      
      sharedPostMessage += '\n❤️ ${post.likes} likes • 💬 ${post.comments} comments';
      sharedPostMessage += '\n⏰ ${_formatTimestamp(post.timestamp)}';

      debugPrint('📝 Formatted message: $sharedPostMessage');

      // Send the formatted post as a message
      debugPrint('📨 Sending message to chat...');
      final success = await MessagingService.instance.sendMessage(
        chatId: chatId,
        content: sharedPostMessage,
        type: MessageType.text,
      );

      debugPrint('✅ Message sent successfully: $success');

      if (success) {
        // Show success message and navigate to chat
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post shared with ${friend.name}!'),
              backgroundColor: const Color(0xFF10B981),
              action: SnackBarAction(
                label: 'View Chat',
                textColor: Colors.white,
                onPressed: () => _messageUser(friend),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      debugPrint('Error sharing post with friend: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share post with ${friend.name}'),
            backgroundColor: const Color(0xFFEF4444),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showDemoSharedMessage(BuildContext context, CommunityPost post, CommunityUser friend, [String? personalMessage]) {
    // Format the post as it would appear in chat
    String sharedPostMessage = '';
    
    // Add personal message if provided
    if (personalMessage != null && personalMessage.isNotEmpty) {
      sharedPostMessage += '💭 $personalMessage\n\n';
    }
    
    sharedPostMessage += '📢 Shared from Community Feed:\n\n';
    sharedPostMessage += '👤 ${post.userName}\n';
    sharedPostMessage += '💬 "${post.content}"\n';
    
    if (post.achievement.isNotEmpty) {
      sharedPostMessage += '🏆 ${post.achievement}\n';
    }
    
    sharedPostMessage += '\n❤️ ${post.likes} likes • 💬 ${post.comments} comments';
    sharedPostMessage += '\n⏰ ${_formatTimestamp(post.timestamp)}';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Demo: Chat with ${friend.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is how the post would appear in your chat:',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                sharedPostMessage,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '💡 This is a demo since we\'re using mock friends. With real Firebase users, this would appear in the actual chat.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8B5CF6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}

class _SearchFriendsListScreen extends StatefulWidget {
  final List<CommunityUser> friends;
  final Function(CommunityUser) onMessageUser;

  const _SearchFriendsListScreen({
    required this.friends,
    required this.onMessageUser,
  });

  @override
  State<_SearchFriendsListScreen> createState() => _SearchFriendsListScreenState();
}

class _SearchFriendsListScreenState extends State<_SearchFriendsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CommunityUser> _filteredFriends = [];

  @override
  void initState() {
    super.initState();
    _filteredFriends = widget.friends;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFriends(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFriends = widget.friends;
      } else {
        _filteredFriends = widget.friends
            .where(
              (friend) =>
                  friend.name.toLowerCase().contains(query.toLowerCase()) ||
                  friend.achievements.any(
                    (achievement) => achievement.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
                  ),
            )
            .toList();
      }
    });
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
          'Search Friends',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Friends summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8F4F8), Color(0xFFF0F9FF)],
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
                          '${widget.friends.length} friends • ${widget.friends.where((f) => f.isOnline).length} online',
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

            const SizedBox(height: 20),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterFriends,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search your friends by name or achievements...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF8B5CF6)),
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                ),
                style: const TextStyle(color: Color(0xFF2E3A59), fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Friends List
            Expanded(
              child: _filteredFriends.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _filteredFriends.length,
                      itemBuilder: (context, index) => _buildFriendCard(_filteredFriends[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchController.text.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 60,
              color: Color(0xFFE5E7EB),
            ),
            SizedBox(height: 16),
            Text(
              'No Friends Yet',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add some friends to start building your wellness circle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 60,
              color: Color(0xFFE5E7EB),
            ),
            SizedBox(height: 16),
            Text(
              'No friends found',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try different search terms',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    }
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
          GestureDetector(
            onTap: () => _showProfileExpansion(friend.avatar, friend.name),
            child: Stack(
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
                    children: friend.achievements
                        .take(2)
                        .map(
                          (achievement) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
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
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => widget.onMessageUser(friend),
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

  void _showProfileExpansion(String avatar, String name) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent dialog from closing when tapping the content
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    avatar,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddFriendsScreen extends StatefulWidget {
  final List<PotentialFriend> potentialFriends;
  final List<FriendRequest> friendRequests;
  final Set<String> sentRequests;
  final void Function(String) onSendRequest;
  final void Function(String) onAcceptRequest;
  final void Function(String) onDeclineRequest;

  const _AddFriendsScreen({
    required this.potentialFriends,
    required this.friendRequests,
    required this.sentRequests,
    required this.onSendRequest,
    required this.onAcceptRequest,
    required this.onDeclineRequest,
  });

  @override
  State<_AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<_AddFriendsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<PotentialFriend> _filteredFriends = [];
  List<FriendRequest> _currentFriendRequests = [];
  List<UserModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredFriends = widget.potentialFriends;
    _currentFriendRequests = List.from(widget.friendRequests);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterFriends(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredFriends = widget.potentialFriends;
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // First filter local potential friends
      final localResults = widget.potentialFriends
          .where(
            (friend) =>
                friend.name.toLowerCase().contains(query.toLowerCase()) ||
                friend.bio.toLowerCase().contains(query.toLowerCase()) ||
                friend.commonInterests.any(
                  (interest) => interest.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                ),
          )
          .toList();

      // Then search real users from Firestore
      final currentUser = AuthService.instance.currentUser;
      final realUsers = await UserService.instance.searchUsers(
        query, 
        excludeUserId: currentUser?.uid,
      );

      setState(() {
        _filteredFriends = localResults;
        _searchResults = realUsers;
        _isSearching = false;
      });
    } catch (e) {
      debugPrint('Error searching users: $e');
      setState(() {
        _filteredFriends = widget.potentialFriends
            .where(
              (friend) =>
                  friend.name.toLowerCase().contains(query.toLowerCase()) ||
                  friend.bio.toLowerCase().contains(query.toLowerCase()) ||
                  friend.commonInterests.any(
                    (interest) => interest.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
                  ),
            )
            .toList();
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _handleAcceptRequest(String requestId) {
    setState(() {
      _currentFriendRequests.removeWhere((request) => request.id == requestId);
    });
    widget.onAcceptRequest(requestId);
  }

  void _handleDeclineRequest(String requestId) {
    setState(() {
      _currentFriendRequests.removeWhere((request) => request.id == requestId);
    });
    widget.onDeclineRequest(requestId);
  }

  void _showProfileExpansion(String avatar, String name) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder:
          (context) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: GestureDetector(
                  onTap:
                      () {}, // Prevent dialog from closing when tapping the content
                  child: Hero(
                    tag: 'profile_expanded',
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          avatar,
                          style: const TextStyle(fontSize: 80),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
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
          'Add Friends',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: const Color(0xFF6B7280),
          tabs: [
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 18),
                  SizedBox(width: 8),
                  Text('Discover'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add, size: 18),
                  const SizedBox(width: 8),
                  Text('Requests (${widget.friendRequests.length})'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people, size: 18),
                  SizedBox(width: 8),
                  Text('Suggested'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverTab(),
          _buildRequestsTab(),
          _buildSuggestedTab(),
        ],
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFriends,
              decoration: const InputDecoration(
                hintText: 'Search by name, interests, or bio...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF8B5CF6)),
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
              ),
              style: const TextStyle(color: Color(0xFF2E3A59), fontSize: 16),
            ),
          ),

          const SizedBox(height: 20),

          // Results
          Expanded(
            child: _isSearching
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF8B5CF6),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Searching for users...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  )
                : (_filteredFriends.isEmpty && _searchResults.isEmpty)
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60,
                              color: Color(0xFFE5E7EB),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No users found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try different search terms',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredFriends.length + _searchResults.length,
                        itemBuilder: (context, index) {
                          if (index < _searchResults.length) {
                            return _buildRealUserCard(_searchResults[index]);
                          } else {
                            final friendIndex = index - _searchResults.length;
                            return _buildPotentialFriendCard(
                              _filteredFriends[friendIndex],
                            );
                          }
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child:
          _currentFriendRequests.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 60, color: Color(0xFFE5E7EB)),
                    SizedBox(height: 16),
                    Text(
                      'No friend requests',
                      style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'When someone sends you a friend request, it will appear here',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _currentFriendRequests.length,
                itemBuilder: (context, index) {
                  // Safety check to prevent RangeError
                  if (index >= _currentFriendRequests.length) {
                    return const SizedBox.shrink();
                  }
                  return _buildFriendRequestCard(_currentFriendRequests[index]);
                },
              ),
    );
  }

  Widget _buildSuggestedTab() {
    final suggestedFriends =
        widget.potentialFriends
            .where((friend) => friend.mutualFriends > 0)
            .toList()
          ..sort((a, b) => b.mutualFriends.compareTo(a.mutualFriends));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'People you may know',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E3A59),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Based on mutual friends and shared interests',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: suggestedFriends.length,
              itemBuilder:
                  (context, index) =>
                      _buildPotentialFriendCard(suggestedFriends[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealUserCard(UserModel user) {
    final isRequested = widget.sentRequests.contains(user.uid);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
          width: 1,
        ),
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
          // Real user badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user,
                  size: 14,
                  color: const Color(0xFF8B5CF6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Real User',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // User Header
          Row(
            children: [
              GestureDetector(
                onTap: () => _showProfileExpansion('👤', user.displayName),
                child: Hero(
                  tag: 'real_user_${user.uid}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: user.photoURL != null && user.photoURL!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                user.photoURL!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Text('👤', style: TextStyle(fontSize: 28)),
                              ),
                            )
                          : const Text('👤', style: TextStyle(fontSize: 28)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.isOnline ? 'Online now' : 'Last seen ${_formatLastSeen(user.lastSeen)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: user.isOnline ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              // Add Friend Button
              ElevatedButton(
                onPressed: isRequested 
                    ? null 
                    : () async {
                        try {
                          final currentUser = AuthService.instance.currentUser;
                          if (currentUser != null) {
                            await UserService.instance.sendFriendRequest(
                              fromUserId: currentUser.uid,
                              toUserId: user.uid,
                              message: 'Hi! I\'d like to connect and share our wellness journey together.',
                            );
                            widget.onSendRequest(user.uid);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Friend request sent!'),
                                backgroundColor: Color(0xFF10B981),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to send request: ${e.toString()}'),
                              backgroundColor: Color(0xFFEF4444),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRequested
                      ? const Color(0xFFE5E7EB)
                      : const Color(0xFF8B5CF6),
                  foregroundColor: isRequested 
                      ? const Color(0xFF6B7280) 
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  isRequested ? 'Requested' : 'Add Friend',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // User Stats
          Row(
            children: [
              _buildUserStat('Wellness Score', '${user.wellnessScore}', Icons.trending_up),
              const SizedBox(width: 24),
              _buildUserStat(
                'Interests',
                '${user.interests.length}',
                Icons.favorite,
              ),
            ],
          ),

          if (user.interests.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Interests',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: user.interests
                  .take(3)
                  .map(
                    (interest) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        interest,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8B5CF6)),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
    }
  }

  Widget _buildPotentialFriendCard(PotentialFriend friend) {
    final isRequested =
        friend.isRequested || widget.sentRequests.contains(friend.id);

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
          // User Header
          Row(
            children: [
              GestureDetector(
                onTap: () => _showProfileExpansion(friend.avatar, friend.name),
                child: Hero(
                  tag: 'profile_${friend.id}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        friend.avatar,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (friend.mutualFriends > 0)
                      Text(
                        '${friend.mutualFriends} mutual friend${friend.mutualFriends == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                  ],
                ),
              ),
              // Add Friend Button
              ElevatedButton(
                onPressed:
                    isRequested ? null : () => widget.onSendRequest(friend.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isRequested
                          ? const Color(0xFFE5E7EB)
                          : const Color(0xFF8B5CF6),
                  foregroundColor:
                      isRequested ? const Color(0xFF6B7280) : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  isRequested ? 'Requested' : 'Add Friend',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bio
          Text(
            friend.bio,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // Common Interests
          if (friend.commonInterests.isNotEmpty) ...[
            const Text(
              'Common Interests',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  friend.commonInterests
                      .map(
                        (interest) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF8B5CF6,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8B5CF6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFriendRequestCard(FriendRequest request) {
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
          // User Header
          Row(
            children: [
              GestureDetector(
                onTap:
                    () => _showProfileExpansion(
                      request.userAvatar,
                      request.userName,
                    ),
                child: Hero(
                  tag: 'profile_${request.id}',
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        request.userAvatar,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(request.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              request.message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleDeclineRequest(request.id),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleAcceptRequest(request.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
