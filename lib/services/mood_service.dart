import 'package:flutter/material.dart';

class MoodData {
  final String emoji;
  final String label;
  final Color color;
  final List<String> categories;
  final String notes;
  final DateTime timestamp;

  MoodData({
    required this.emoji,
    required this.label,
    required this.color,
    required this.categories,
    required this.notes,
    required this.timestamp,
  });
}

class MoodService extends ChangeNotifier {
  static final MoodService _instance = MoodService._internal();
  factory MoodService() => _instance;
  MoodService._internal();

  static MoodService get instance => _instance;

  MoodData? _currentMood;
  Color _currentBackgroundColor = const Color(0xFFF8F9FA);

  MoodData? get currentMood => _currentMood;
  Color get currentBackgroundColor => _currentBackgroundColor;

  // Mood definitions
  static const List<Map<String, dynamic>> moodDefinitions = [
    {'emoji': '😊', 'label': 'Happy', 'color': Color(0xFF10B981)},
    {'emoji': '😌', 'label': 'Calm', 'color': Color(0xFF6366F1)},
    {'emoji': '😔', 'label': 'Sad', 'color': Color(0xFF3B82F6)},
    {'emoji': '😤', 'label': 'Angry', 'color': Color(0xFFEF4444)},
    {'emoji': '😟', 'label': 'Anxious', 'color': Color(0xFFF59E0B)},
    {'emoji': '😴', 'label': 'Tired', 'color': Color(0xFF8B5CF6)},
    {'emoji': '🤔', 'label': 'Confused', 'color': Color(0xFF6B7280)},
    {'emoji': '😍', 'label': 'Excited', 'color': Color(0xFFEC4899)},
  ];

  void saveMoodEntry({
    required String moodLabel,
    required List<String> categories,
    required String notes,
  }) {
    // Find the mood data
    final moodData = moodDefinitions.firstWhere(
      (mood) => mood['label'] == moodLabel,
    );

    _currentMood = MoodData(
      emoji: moodData['emoji'],
      label: moodData['label'],
      color: moodData['color'],
      categories: categories,
      notes: notes,
      timestamp: DateTime.now(),
    );

    // Update background color based on mood
    _currentBackgroundColor = _getMoodBackgroundColor(moodLabel);
    
    notifyListeners();
  }

  Color _getMoodBackgroundColor(String moodLabel) {
    switch (moodLabel) {
      case 'Happy':
        return const Color(0xFFECFDF5); // Light green
      case 'Calm':
        return const Color(0xFFEBF8FF); // Light blue
      case 'Sad':
        return const Color(0xFFEFF6FF); // Light blue variant
      case 'Angry':
        return const Color(0xFFFEF2F2); // Light red
      case 'Anxious':
        return const Color(0xFFFEF3C7); // Light yellow
      case 'Tired':
        return const Color(0xFFF3E8FF); // Light purple
      case 'Confused':
        return const Color(0xFFF9FAFB); // Light gray
      case 'Excited':
        return const Color(0xFFFDF2F8); // Light pink
      default:
        return const Color(0xFFF8F9FA);
    }
  }

  String getMoodSubtitle() {
    if (_currentMood == null) return 'No mood yet';
    
    switch (_currentMood!.label) {
      case 'Happy':
        return 'Feeling great';
      case 'Calm':
        return 'Peaceful';
      case 'Sad':
        return 'Need support';
      case 'Angry':
        return 'Frustrated';
      case 'Anxious':
        return 'Worried';
      case 'Tired':
        return 'Need rest';
      case 'Confused':
        return 'Uncertain';
      case 'Excited':
        return 'Energetic';
      default:
        return 'Current mood';
    }
  }

  void clearMood() {
    _currentMood = null;
    _currentBackgroundColor = const Color(0xFFF8F9FA);
    notifyListeners();
  }
}