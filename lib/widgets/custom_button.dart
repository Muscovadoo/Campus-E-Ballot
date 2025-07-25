// lib/widgets/custom_button.dart (UPDATED)

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? backgroundColor; // Added backgroundColor parameter
  final Color? foregroundColor; // Added foregroundColor parameter

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.padding,
    this.textStyle,
    this.backgroundColor, // Initialize backgroundColor
    this.foregroundColor, // Initialize foregroundColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Button takes full width by default
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable if loading
        style: ElevatedButton.styleFrom(
          // Use provided colors, otherwise fall back to theme defaults
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? AppColors.onPrimary,
          // Apply padding if provided, otherwise use default from theme
          padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
          // Apply textStyle if provided, otherwise use default from theme
          textStyle: textStyle ?? AppTextStyles.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
              )
            : Text(text),
      ),
    );
  }
}
