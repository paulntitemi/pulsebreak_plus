import 'package:flutter/material.dart';

class AIWellnessCoachScreen extends StatefulWidget {
  const AIWellnessCoachScreen({super.key});

  @override
  State<AIWellnessCoachScreen> createState() => _AIWellnessCoachScreenState();
}

class _AIWellnessCoachScreenState extends State<AIWellnessCoachScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'message': 'Hello! I\'m your AI Wellness Coach. I\'m here to help you maintain healthy habits and reach your wellness goals. How can I assist you today?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'suggestions': ['How can I improve my sleep?', 'I feel stressed today', 'Help me stay hydrated', 'Create a morning routine']
    }
  ];

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'isUser': true,
        'message': message,
        'timestamp': DateTime.now(),
      });
    });
    
    _messageController.clear();
    
    // Simulate AI response
    Future<void>.delayed(const Duration(seconds: 1), () {
      _simulateAIResponse(message);
    });
    
    // Scroll to bottom
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _simulateAIResponse(String userMessage) {
    String response = '';
    List<String> suggestions = [];
    
    if (userMessage.toLowerCase().contains('sleep')) {
      response = 'Great question about sleep! Based on your recent data, I see you\'ve been getting 7.5 hours on average. Here are some personalized recommendations:\n\n• Try going to bed 30 minutes earlier\n• Limit screen time 1 hour before bed\n• Keep your bedroom cool (65-68°F)\n• Consider a bedtime routine with reading or meditation\n\nWould you like me to create a personalized sleep plan for you?';
      suggestions = ['Create sleep plan', 'Track my bedtime', 'Sleep meditation tips', 'Set sleep reminders'];
    } else if (userMessage.toLowerCase().contains('stress')) {
      response = 'I understand you\'re feeling stressed. Let\'s work on some immediate relief strategies:\n\n• Take 5 deep breaths right now\n• Try the 4-7-8 breathing technique\n• Step outside for fresh air if possible\n• Listen to calming music\n\nBased on your mood check-ins, stress tends to peak around 3 PM for you. Would you like me to set up preventive reminders?';
      suggestions = ['Breathing exercises', 'Stress management plan', 'Mindfulness tips', 'Set stress reminders'];
    } else if (userMessage.toLowerCase().contains('hydration') || userMessage.toLowerCase().contains('water')) {
      response = 'Excellent focus on hydration! You\'ve been doing well with 1.7L daily. Here\'s how to optimize further:\n\n• Drink a glass when you wake up\n• Set hourly reminders during work hours\n• Add lemon or cucumber for variety\n• Track with your existing system\n\nI notice you drink more water on days you exercise. Should we create an activity-based hydration plan?';
      suggestions = ['Hydration reminders', 'Water tracking tips', 'Healthy drink ideas', 'Exercise hydration plan'];
    } else if (userMessage.toLowerCase().contains('routine') || userMessage.toLowerCase().contains('morning')) {
      response = 'A solid morning routine can set the tone for your entire day! Based on your habits, here\'s a personalized routine:\n\n**6:30 AM - Wake Up**\n• Drink a glass of water\n• 5 minutes of stretching\n\n**6:45 AM - Mindfulness**\n• Quick mood check-in\n• 3 minutes of breathing\n\n**7:00 AM - Fuel Up**\n• Healthy breakfast\n• Morning vitamins\n\nWould you like me to create reminders for this routine?';
      suggestions = ['Set morning reminders', 'Customize routine', 'Evening routine too', 'Track routine progress'];
    } else {
      response = 'I\'m here to help with your wellness journey! I can assist you with:\n\n• Sleep optimization\n• Stress management\n• Hydration tracking\n• Mood improvement\n• Habit building\n• Nutrition guidance\n• Exercise motivation\n\nWhat specific area would you like to focus on today?';
      suggestions = ['Improve my mood', 'Build better habits', 'Manage stress', 'Sleep better tonight'];
    }
    
    setState(() {
      _messages.add({
        'isUser': false,
        'message': response,
        'timestamp': DateTime.now(),
        'suggestions': suggestions,
      });
    });
    
    // Scroll to bottom
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Wellness Coach',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E3A59),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF2E3A59)),
            onPressed: () {
              // Show coach settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ask me anything about wellness...',
                        hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['message'] as String;
    final timestamp = message['timestamp'] as DateTime;
    final suggestions = message['suggestions'] as List<String>?;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.psychology, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
              ],
              
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF3B82F6) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : const Color(0xFF2E3A59),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              
              if (isUser) ...[
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 16),
                ),
              ],
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Timestamp
          Text(
            _formatTimestamp(timestamp),
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9CA3AF),
            ),
          ),
          
          // Suggestions
          if (suggestions != null && suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((suggestion) {
                return GestureDetector(
                  onTap: () => _sendMessage(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}