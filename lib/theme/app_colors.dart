// lib/theme/app_colors.dart (CORRECTED/UPDATED)

import 'package:flutter/material.dart';

class AppColors {
  // Primary and Accent Colors
  static const Color primary = Color(
    0xFF0D47A1,
  ); // A deep blue for primary actions
  static const Color primaryLight = Color(
    0xFF42A5F5,
  ); // Lighter shade of primary
  static const Color primaryDark = Color(0xFF002171); // Darker shade of primary
  static const Color accent = Color(0xFF1DE9B6); // Teal accent for buttons
  static const Color onPrimary = Color(
    0xFFFFFFFF,
  ); // Text/icons on primary color

  // Secondary Colors (Optional, for distinct elements)
  static const Color secondary = Color(0xFF1DE9B6); // A teal/aqua color
  static const Color onSecondary = Color(
    0xFF000000,
  ); // Text/icons on secondary color

  // Backgrounds and Surfaces
  static const Color background = Color(
    0xFFF0F2F5,
  ); // Light grey for general backgrounds
  static const Color surface = Color(
    0xFFFFFFFF,
  ); // White for cards, dialogs, etc.
  static const Color onSurface = Color(
    0xFF212121,
  ); // Dark grey for text on surfaces
  static const Color scaffoldBackground = Color(
    0xFFF0F2F5,
  ); // Consistent light grey

  // Text Colors
  static const Color bodyText = Color(0xFF424242); // Standard body text
  static const Color headlineText = Color(0xFF212121); // Darker for headlines
  static const Color hintText = Color(
    0xFF9E9E9E,
  ); // Lighter for hints in text fields

  // Error and Success Colors
  static const Color error = Color(0xFFD32F2F); // Red for error messages
  static const Color success = Color(0xFF388E3C); // Green for success messages
  static const Color warning = Color(0xFFF57C00); // Orange for warnings
  static const Color onError = Color(
    0xFFFFFFFF,
  ); // Text/icons on error color (NEW)

  // Input Field Specific Colors (NEW)
  static const Color textFieldBackground = Color(
    0xFFE0E0E0,
  ); // Lighter grey for input field background
  static const Color borderColor = Color(0xFFBDBDBD); // Grey for borders
  static const Color inputFillColor = Color(
    0xFFF5F5F5,
  ); // A very light grey for input fill (alternative to textFieldBackground)
  static const Color inputBorder = Color(
    0xFFC7C7C7,
  ); // A slightly darker grey for input borders

  // OnBackground Color (NEW, for text/icons on the main background)
  static const Color onBackground = Color(
    0xFF212121,
  ); // Dark grey, similar to onSurface

  // Primary Swatch (NEW: A MaterialColor for ThemeData.primarySwatch)
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF0D47A1, // Primary color value
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  // Other UI Colors
  static const Color iconColor = Color(
    0xFF222222,
  ); // Dark icon color for AppBar and general use
  static const Color dividerColor = Color(0x1F000000); // Light divider

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFA07A), // Light Salmon (top)
      Color(0xFFFF6347), // Tomato (bottom)
    ],
  );
}
