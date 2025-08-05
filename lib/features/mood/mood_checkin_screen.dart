import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/shared/widgets/circular_mood_picker.dart';
import 'package:pulsebreak_plus/shared/widgets/mood_category_card.dart';
import 'package:pulsebreak_plus/services/mood_service.dart';
import 'package:pulsebreak_plus/features/dashboard/main_navigation.dart';

class MoodCheckinScreen extends StatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  State<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  String? _selectedMood;
  List<String> _selectedCategories = [];
  String _notes = '';

  final List<Map<String, dynamic>> _moods = MoodService.moodDefinitions;

  final List<String> _categories = [
    'Work', 'Family', 'Health', 'Friends', 'Exercise', 'Sleep', 'Food', 'Weather'
  ];

  void _saveMoodEntry() {
    
    if (_selectedMood != null) {
      try {
        // Save mood to service
        MoodService.instance.saveMoodEntry(
          moodLabel: _selectedMood!,
          categories: _selectedCategories,
          notes: _notes,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood logged: $_selectedMood'),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 1),
          ),
        );

        // Navigate to dashboard and clear all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (context) => const MainNavigation()),
          (Route<dynamic> route) => false,
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving mood: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mood first'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedMood != null 
          ? _getMoodBackgroundColor(_selectedMood!)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E3A59),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Greeting message
              Container(
                width: double.infinity,
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
                child: const Column(
                  children: [
                    Text(
                      '✨',
                      style: TextStyle(fontSize: 32),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Take a moment to check in with yourself',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your feelings matter and tracking them helps with mindfulness',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Circular Mood Picker - Centered
              Center(
                child: CircularMoodPicker(
                  moods: _moods,
                  selectedMood: _selectedMood,
                  onMoodSelected: (mood) {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),

              // What's influencing your mood?
              const Text(
                'What\'s influencing your mood?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3A59),
                ),
              ),

              const SizedBox(height: 16),

              // Category cards
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  bool isSelected = _selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedCategories.remove(category);
                        } else {
                          _selectedCategories.add(category);
                        }
                      });
                    },
                    child: MoodCategoryCard(
                      label: category,
                      isSelected: isSelected,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Notes section
              const Text(
                'Any additional notes? (Optional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3A59),
                ),
              ),

              const SizedBox(height: 16),

              DecoratedBox(
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
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _notes = value;
                    });
                  },
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'What happened today that made you feel this way?',
                    hintStyle: TextStyle(
                      color: Color(0xFFB0B8C1),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _saveMoodEntry,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _selectedMood != null ? const Color(0xFF8B5CF6) : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Save Mood Entry',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _selectedMood != null ? Colors.white : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
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

  Color _getMoodBackgroundColor(String moodLabel) {
    switch (moodLabel) {
      case 'Happy':
        return const Color(0xFFECFDF5); // Light green like dashboard
      case 'Calm':
        return const Color(0xFFEBF8FF); // Light blue like dashboard
      case 'Sad':
        return const Color(0xFFEFF6FF); // Light blue variant
      case 'Angry':
        return const Color(0xFFFEF2F2); // Light red
      case 'Anxious':
        return const Color(0xFFFEF3C7); // Light yellow
      case 'Tired':
        return const Color(0xFFF3E8FF); // Light purple like dashboard
      case 'Confused':
        return const Color(0xFFF9FAFB); // Light gray
      case 'Excited':
        return const Color(0xFFFDF2F8); // Light pink
      default:
        return const Color(0xFFF8F9FA);
    }
  }
}