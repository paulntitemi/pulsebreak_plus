import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/services/ai_wellness_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIWellnessService _aiService = AIWellnessService.instance;
  
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _conversationId;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          text: "Hi! I'm your AI wellness coach. I'm here to support your mental health journey. How are you feeling today?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Get current context for AI
      final context = ChatContext(
        currentMood: _getCurrentMoodHint(),
        timeOfDay: _getTimeOfDay(),
      );

      // Send to AI service
      final response = await _aiService.sendChatMessage(
        message: message,
        conversationId: _conversationId,
        context: context,
      );

      _conversationId = response.conversationId;

      // Add AI response
      setState(() {
        _messages.add(
          ChatMessage(
            text: response.response,
            isUser: false,
            timestamp: DateTime.now(),
            suggestions: response.suggestions,
            followUpQuestions: response.followUpQuestions,
          ),
        );
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "I'm having trouble right now. Please try again in a moment.",
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          ),
        );
        _isLoading = false;
      });
    }
  }

  String? _getCurrentMoodHint() {
    // This could integrate with your mood tracking system
    return null;
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSuggestionTap(AISuggestion suggestion) {
    // Handle different suggestion types
    switch (suggestion.type) {
      case 'breathing_exercise':
        _showBreathingExercise(suggestion);
        break;
      case 'mindfulness_exercise':
        _showMindfulnessExercise(suggestion);
        break;
      case 'journal_prompt':
        _showJournalPrompt(suggestion);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${suggestion.title}...')),
        );
    }
  }

  void _showBreathingExercise(AISuggestion suggestion) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(suggestion.title),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.air, size: 60, color: Color(0xFF8B5CF6)),
            SizedBox(height: 16),
            Text('Let\'s do a simple breathing exercise together:\n\n'
                '1. Breathe in slowly for 4 counts\n'
                '2. Hold for 4 counts\n'
                '3. Breathe out for 6 counts\n'
                '4. Repeat 5-10 times'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Could integrate with a breathing exercise timer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Breathing exercise completed!')),
              );
            },
            child: const Text('Start Exercise'),
          ),
        ],
      ),
    );
  }

  void _showMindfulnessExercise(AISuggestion suggestion) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(suggestion.title),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.self_improvement, size: 60, color: Color(0xFF10B981)),
            SizedBox(height: 16),
            Text('Take a moment to practice mindfulness:\n\n'
                '• Notice 5 things you can see\n'
                '• Notice 4 things you can touch\n'
                '• Notice 3 things you can hear\n'
                '• Notice 2 things you can smell\n'
                '• Notice 1 thing you can taste'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Great job practicing mindfulness!')),
              );
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showJournalPrompt(AISuggestion suggestion) {
    Navigator.pop(context); // Close chat
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening journal with prompt: ${suggestion.title}')),
    );
    // Could navigate to journal screen with pre-filled prompt
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
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF4F8A8B)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Wellness Coach',
                  style: TextStyle(
                    color: Color(0xFF2E3A59),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF2E3A59)),
            onPressed: () => _showChatOptions(),
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
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF4F8A8B)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: message.isUser ? const Color(0xFF8B5CF6) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : const Color(0xFF2E3A59),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
                
                // Suggestions
                if (message.suggestions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: message.suggestions.map((suggestion) => 
                      GestureDetector(
                        onTap: () => _handleSuggestionTap(suggestion),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            suggestion.title,
                            style: const TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ],

                // Follow-up questions
                if (message.followUpQuestions.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: message.followUpQuestions.map((question) => 
                      GestureDetector(
                        onTap: () {
                          _messageController.text = question;
                          _sendMessage();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.help_outline, size: 14, color: Color(0xFF6B7280)),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  question,
                                  style: const TextStyle(
                                    color: Color(0xFF4B5563),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ],

                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF4F8A8B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF4F8A8B)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'AI is thinking...',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showChatOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Chat Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3A59),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Color(0xFF8B5CF6)),
              title: const Text('New Conversation'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                  _conversationId = null;
                });
                _addWelcomeMessage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Color(0xFF8B5CF6)),
              title: const Text('Export Chat'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat export coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF8B5CF6)),
              title: const Text('AI Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('AI settings coming soon!')),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<AISuggestion> suggestions;
  final List<String> followUpQuestions;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestions = const [],
    this.followUpQuestions = const [],
    this.isError = false,
  });
}