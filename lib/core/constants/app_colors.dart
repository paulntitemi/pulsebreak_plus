// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4F8A8B); // Teal
  static const Color secondary = Color(0xFFFBD46D); // Yellow
  static const Color accent = Color(0xFF2E3A59); // Navy
  static const Color success = Color(0xFF188038); // Green
  static const Color background = Color(0xFFF5F7F8); // Light gray
  static const Color neutral = Color(0xFFB0B8C1); // Medium gray
  static const Color coral = Color(0xFFE27D60); // Coral
  static const Color textPrimary = Color(0xFF000000); // Black

  // Splash screen specific colors
  static const List<Color> splashGradient = [
    Color(0xFFFBD46D), // Light background
    Color(0xFF188038), // Tinted with primary
    Color(0xFF4F8A8B), // White
  ];

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4F8A8B), // Primary teal
      Color(0xFF188038), // Success green
    ],
  );

  static const Color logoShadow = Color(0x404F8A8B);
  static const Color particleColor = Color(0x40FBD46D);
  static const Color waveColor = Color(0x204F8A8B);
  static const Color loadingDot = Color(0xFF4F8A8B);
}
