import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'label': label,
      'color': color.toARGB32(),
      'categories': categories,
      'notes': notes,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory MoodData.fromJson(Map<String, dynamic> json) {
    return MoodData(
      emoji: json['emoji'] as String? ?? '😐',
      label: json['label'] as String? ?? 'Neutral',
      color: Color((json['color'] as int?) ?? 0xFF6B7280),
      categories: List<String>.from((json['categories'] as List?) ?? []),
      notes: json['notes'] as String? ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch((json['timestamp'] as int?) ?? 0),
    );
  }
}

class MoodService extends ChangeNotifier {
  static final MoodService _instance = MoodService._internal();
  factory MoodService() => _instance;
  MoodService._internal();

  static MoodService get instance => _instance;

  // Keys for SharedPreferences
  static const String _currentMoodKey = 'current_mood';
  static const String _moodHistoryKey = 'mood_history';

  MoodData? _currentMood;
  Color _currentBackgroundColor = const Color(0xFFF8F9FA);
  List<MoodData> _moodHistory = [];

  MoodData? get currentMood => _currentMood;
  Color get currentBackgroundColor => _currentBackgroundColor;
  List<MoodData> get moodHistory => List.unmodifiable(_moodHistory);

  // Initialize mood service
  Future<void> initialize() async {
    await _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load current mood
      final currentMoodJson = prefs.getString(_currentMoodKey);
      if (currentMoodJson != null) {
        final moodMap = jsonDecode(currentMoodJson) as Map<String, dynamic>;
        _currentMood = MoodData.fromJson(moodMap);
        _currentBackgroundColor = _getMoodBackgroundColor(_currentMood!.label);
      }
      
      // Load mood history
      final historyJson = prefs.getString(_moodHistoryKey);
      if (historyJson != null) {
        final historyList = jsonDecode(historyJson) as List;
        _moodHistory = historyList.map((item) => MoodData.fromJson(item as Map<String, dynamic>)).toList();
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading mood data: $e');
    }
  }

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

  Future<void> saveMoodEntry({
    required String moodLabel,
    required List<String> categories,
    required String notes,
  }) async {
    try {
      // Find the mood data
      final moodData = moodDefinitions.firstWhere(
        (mood) => mood['label'] == moodLabel,
        orElse: () => moodDefinitions.first,
      );

      final newMood = MoodData(
        emoji: moodData['emoji'] as String,
        label: moodData['label'] as String,
        color: moodData['color'] as Color,
        categories: categories,
        notes: notes,
        timestamp: DateTime.now(),
      );

      _currentMood = newMood;
      _currentBackgroundColor = _getMoodBackgroundColor(moodLabel);
      
      // Add to history
      _moodHistory.insert(0, newMood); // Add to beginning of list
      
      // Keep only last 100 entries
      if (_moodHistory.length > 100) {
        _moodHistory = _moodHistory.take(100).toList();
      }
      
      // Save to preferences
      await _saveMoodData();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving mood entry: $e');
    }
  }

  Future<void> _saveMoodData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save current mood
      if (_currentMood != null) {
        await prefs.setString(_currentMoodKey, jsonEncode(_currentMood!.toJson()));
      }
      
      // Save mood history
      final historyJson = _moodHistory.map((mood) => mood.toJson()).toList();
      await prefs.setString(_moodHistoryKey, jsonEncode(historyJson));
      
    } catch (e) {
      debugPrint('Error saving mood data: $e');
    }
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

  Future<void> clearMood() async {
    try {
      _currentMood = null;
      _currentBackgroundColor = const Color(0xFFF8F9FA);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentMoodKey);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing mood: $e');
    }
  }

  // Get moods for a specific date range
  List<MoodData> getMoodsForDateRange(DateTime start, DateTime end) {
    return _moodHistory.where((mood) {
      return mood.timestamp.isAfter(start) && mood.timestamp.isBefore(end);
    }).toList();
  }

  // Get mood statistics
  Map<String, int> getMoodStatistics({int? lastDays}) {
    List<MoodData> moods = _moodHistory;
    
    if (lastDays != null) {
      final cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
      moods = _moodHistory.where((mood) => mood.timestamp.isAfter(cutoffDate)).toList();
    }
    
    final Map<String, int> stats = {};
    for (final mood in moods) {
      stats[mood.label] = (stats[mood.label] ?? 0) + 1;
    }
    
    return stats;
  }

  // Get average mood score (simplified)
  double getAverageMoodScore({int? lastDays}) {
    List<MoodData> moods = _moodHistory;
    
    if (lastDays != null) {
      final cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
      moods = _moodHistory.where((mood) => mood.timestamp.isAfter(cutoffDate)).toList();
    }
    
    if (moods.isEmpty) return 0.0;
    
    // Simple scoring system (could be improved)
    double totalScore = 0.0;
    for (final mood in moods) {
      switch (mood.label) {
        case 'Happy':
        case 'Excited':
          totalScore += 5.0;
          break;
        case 'Calm':
          totalScore += 4.0;
          break;
        case 'Confused':
        case 'Tired':
          totalScore += 3.0;
          break;
        case 'Anxious':
          totalScore += 2.0;
          break;
        case 'Sad':
        case 'Angry':
          totalScore += 1.0;
          break;
      }
    }
    
    return totalScore / moods.length;
  }
}