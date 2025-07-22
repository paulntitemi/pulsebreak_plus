import 'package:flutter/material.dart';
import 'lib/services/mood_service.dart';

void main() {
  // Test MoodService functionality
  print('=== Testing MoodService ===');
  
  final moodService = MoodService.instance;
  print('MoodService instance created: ${moodService != null}');
  
  // Test saving a mood
  try {
    moodService.saveMoodEntry(
      moodLabel: 'Happy',
      categories: ['Work', 'Family'],
      notes: 'Test notes',
    );
    print('Mood saved successfully');
    print('Current mood: ${moodService.currentMood?.label}');
    print('Current mood emoji: ${moodService.currentMood?.emoji}');
    print('Background color: ${moodService.currentBackgroundColor}');
  } catch (e) {
    print('Error saving mood: $e');
  }
}