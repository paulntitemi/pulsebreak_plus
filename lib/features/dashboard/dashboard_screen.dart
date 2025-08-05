import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/features/ai_coach/ai_chat_screen.dart';
import 'package:pulsebreak_plus/services/auth_service.dart';
import 'package:pulsebreak_plus/services/user_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  
  // Check-in state
  bool _morningCheckedIn = false;
  bool _middayCheckedIn = false;
  bool _eveningCheckedIn = false;
  
  // Mood selection state
  String? _selectedMood;
  
  // Habit reminder state
  bool _habitReminderVisible = true;
  
  // User data
  String _firstName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = AuthService.instance.currentUser;
    if (user != null) {
      final userModel = await UserService.instance.getUserProfile(user.uid);
      if (userModel != null && mounted) {
        setState(() {
          _firstName = userModel.firstName;
        });
      } else if (mounted) {
        // Fallback to Firebase Auth display name if Firestore fails
        final displayName = user.displayName ?? '';
        setState(() {
          _firstName = displayName.split(' ').first;
        });
      }
    }
  }
  
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
  
  void _handleCheckIn(String timeOfDay) {
    setState(() {
      switch (timeOfDay) {
        case 'morning':
          _morningCheckedIn = !_morningCheckedIn;
          break;
        case 'midday':
          _middayCheckedIn = !_middayCheckedIn;
          break;
        case 'evening':
          _eveningCheckedIn = !_eveningCheckedIn;
          break;
      }
    });
    
    // Show feedback
    final message = _getCheckInMessage(timeOfDay);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4F8A8B),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  String _getCheckInMessage(String timeOfDay) {
    bool isCheckedIn;
    switch (timeOfDay) {
      case 'morning':
        isCheckedIn = _morningCheckedIn;
        break;
      case 'midday':
        isCheckedIn = _middayCheckedIn;
        break;
      case 'evening':
        isCheckedIn = _eveningCheckedIn;
        break;
      default:
        return '';
    }
    
    if (isCheckedIn) {
      return '${timeOfDay.substring(0, 1).toUpperCase() + timeOfDay.substring(1)} check-in complete! 🎉';
    } else {
      return '${timeOfDay.substring(0, 1).toUpperCase() + timeOfDay.substring(1)} check-in removed.';
    }
  }
  
  void _handleMoodSelection(String mood) {
    setState(() {
      _selectedMood = _selectedMood == mood ? null : mood;
    });
    
    if (_selectedMood != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood updated to ${_selectedMood!} 😊'),
          backgroundColor: const Color(0xFF4F8A8B),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF5F7FA),
                  Color(0xFFE8F4F8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with greeting and avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _firstName.isNotEmpty 
                                ? '${_getGreeting()}, $_firstName 👋🏽' 
                                : '${_getGreeting()}! 👋🏽',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'How are you feeling today?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4F8A8B), Color(0xFF188038)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F8A8B).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Affirmation Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE8F4F8),
                          Color(0xFFF0F9FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F8A8B).withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.spa,
                          size: 32,
                          color: Color(0xFF4F8A8B),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '"Presence is power. Stay grounded."',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Check-in Buttons
                  const Text(
                    'Daily Check-ins',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildCheckInButton(
                          'Morning',
                          '☀️',
                          const Color(0xFFFFF7ED),
                          const Color(0xFFEA580C),
                          _morningCheckedIn,
                          () => _handleCheckIn('morning'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckInButton(
                          'Midday',
                          '⏱',
                          const Color(0xFFEBF8FF),
                          const Color(0xFF0369A1),
                          _middayCheckedIn,
                          () => _handleCheckIn('midday'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckInButton(
                          'Evening',
                          '🌙',
                          const Color(0xFFF3E8FF),
                          const Color(0xFF7C3AED),
                          _eveningCheckedIn,
                          () => _handleCheckIn('evening'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Habit Reminder Card
                  if (_habitReminderVisible)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEAB308).withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBBF24),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.self_improvement,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Stretch for 2 mins after waking up.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF92400E),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _habitReminderVisible = false;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF92400E),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Mood Ring Tracker
                  const Text(
                    'How are you feeling?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMoodOption('😊', 'Happy', const Color(0xFF10B981), 'happy'),
                        _buildMoodOption('😌', 'Calm', const Color(0xFF6366F1), 'calm'),
                        _buildMoodOption('😟', 'Anxious', const Color(0xFFEF4444), 'anxious'),
                        _buildMoodOption('😴', 'Tired', const Color(0xFF8B5CF6), 'tired'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Progress Ring & Weekly Calendar
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Progress Ring
                        const Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: 0.75,
                                strokeWidth: 8,
                                backgroundColor: Color(0xFFE5E7EB),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4F8A8B),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '75%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2E3A59),
                                  ),
                                ),
                                Text(
                                  'Complete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Weekly Calendar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDayIndicator('S', '✅', 'Sunday'),
                            _buildDayIndicator('M', '✅', 'Monday'),
                            _buildDayIndicator('T', '✅', 'Tuesday'),
                            _buildDayIndicator('W', '⏰', 'Wednesday'),
                            _buildDayIndicator('T', '⭕', 'Thursday'),
                            _buildDayIndicator('F', '⭕', 'Friday'),
                            _buildDayIndicator('S', '⭕', 'Saturday'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // AI Wellness Coach Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF8B5CF6),
                          Color(0xFF7C3AED),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (context) => const AIChatScreen()),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.psychology,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AI Wellness Coach',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Get personalized support and guidance for your mental health journey',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Footer Tip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Color(0xFF0EA5E9),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Take 3 deep breaths before your next task.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0369A1),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInButton(String title, String emoji, Color bgColor, Color textColor, bool isCheckedIn, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isCheckedIn ? textColor.withValues(alpha: 0.1) : bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isCheckedIn ? Border.all(color: textColor, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: textColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                if (isCheckedIn) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.check_circle,
                    color: textColor,
                    size: 16,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOption(String emoji, String label, Color color, String moodValue) {
    final isSelected = _selectedMood == moodValue;
    return GestureDetector(
      onTap: () => _handleMoodSelection(moodValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : color.withValues(alpha: 0.3),
                  width: isSelected ? 3 : 2,
                ),
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    if (isSelected)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayIndicator(String day, String indicator, String fullDayName) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$fullDayName progress: ${_getDayStatus(indicator)}'),
            backgroundColor: const Color(0xFF4F8A8B),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              indicator,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getDayStatus(String indicator) {
    switch (indicator) {
      case '✅':
        return 'Completed all check-ins';
      case '⏰':
        return 'In progress';
      case '⭕':
        return 'No check-ins yet';
      default:
        return 'Unknown status';
    }
  }
}