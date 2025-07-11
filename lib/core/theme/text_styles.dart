// lib/core/theme/text_styles.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  static const TextStyle splashTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,  // Navy color
    letterSpacing: -0.5,
    fontFamily: 'TextMeOne',
  );

  static const TextStyle splashSubtitle = TextStyle(
    fontSize: 16,
    color: AppColors.neutral,  // Medium gray
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    fontFamily: 'TextMeOne',
  );
}