import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularMoodPicker extends StatelessWidget {
  final List<Map<String, dynamic>> moods;
  final String? selectedMood;
  final Function(String) onMoodSelected;

  const CircularMoodPicker({
    super.key,
    required this.moods,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 320,
        width: 320,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle with mood-based color
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedMood != null 
                    ? _getMoodBackgroundColor(selectedMood!)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: selectedMood != null 
                        ? _getMoodColor(selectedMood!).withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
            
            // Center content - larger selected mood
            if (selectedMood != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getMoodEmoji(selectedMood!),
                    style: const TextStyle(fontSize: 80), // Increased from 48
                  ),
                  const SizedBox(height: 12),
                  Text(
                    selectedMood!,
                    style: TextStyle(
                      fontSize: 22, // Increased from 18
                      fontWeight: FontWeight.w700,
                      color: _getMoodColor(selectedMood!),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF3F4F6),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.sentiment_neutral,
                  size: 50,
                  color: Color(0xFF9CA3AF),
                ),
              ),
          
          // Mood options positioned in a circle
          ...moods.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> mood = entry.value;
            
            double angle = (index * 2 * math.pi) / moods.length;
            double radius = 130;
            
            double x = radius * math.cos(angle - math.pi / 2);
            double y = radius * math.sin(angle - math.pi / 2);
            
            bool isSelected = selectedMood == mood['label'];
            
            return Transform.translate(
              offset: Offset(x, y),
              child: GestureDetector(
                onTap: () {
                  print('=== MOOD PICKER TAPPED ===');
                  print('Mood tapped: ${mood['label']}');
                  onMoodSelected(mood['label']);
                  print('=== MOOD PICKER CALLBACK CALLED ===');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 70 : 60,
                  height: isSelected ? 70 : 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected 
                        ? mood['color'].withValues(alpha: 0.1)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected 
                          ? mood['color']
                          : const Color(0xFFE5E7EB),
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                            ? mood['color'].withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.1),
                        blurRadius: isSelected ? 12 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      mood['emoji'],
                      style: TextStyle(
                        fontSize: isSelected ? 32 : 28,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),),
    );
  }

  String _getMoodEmoji(String moodLabel) {
    final mood = moods.firstWhere((m) => m['label'] == moodLabel);
    return mood['emoji'];
  }

  Color _getMoodColor(String moodLabel) {
    final mood = moods.firstWhere((m) => m['label'] == moodLabel);
    return mood['color'];
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
        return Colors.white;
    }
  }
}