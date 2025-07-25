// lib/theme/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart'; // Import AppColors for consistent text colors

class AppTextStyles {
  // Define a base font family if you have a custom one (e.g., 'Inter').
  // For now, we'll use system default or let Material Design handle it.
  // static const String _fontFamily = 'Inter'; // Example if you add a custom font

  // --- AppBar Titles ---
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground, // Use onBackground for theme consistency
    // fontFamily: _fontFamily, // Uncomment if using a custom font
  );

  // --- Display Text Styles (Very large, for prominent headings) ---
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57.0,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );

  // --- Headline Text Styles (Large, for section titles) ---
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );

  // --- Title Text Styles (Medium, for subtitles or prominent text) ---
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600, // Semi-bold
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );

  // --- Body Text Styles (Standard text content) ---
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );

  // --- Label Text Styles (For buttons, input labels) ---
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.onPrimary, // Often white for buttons
    // fontFamily: _fontFamily,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );

  // --- Specific UI Element Text Styles ---
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary, // White text on primary buttons
    // fontFamily: _fontFamily,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.hintText, // Grey color for hint text
    // fontFamily: _fontFamily,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primary, // Primary color for links
    decoration: TextDecoration.underline,
    // fontFamily: _fontFamily,
  );

  static const TextStyle formLabel = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
    // fontFamily: _fontFamily,
  );
}
