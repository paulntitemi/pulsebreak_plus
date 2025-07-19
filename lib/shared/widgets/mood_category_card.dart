import 'package:flutter/material.dart';

class MoodCategoryCard extends StatelessWidget {
  final String label;
  final bool isSelected;

  const MoodCategoryCard({
    super.key,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFF8B5CF6)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected 
            ? null
            : Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                ? const Color(0xFF8B5CF6).withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: isSelected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected 
              ? Colors.white
              : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}