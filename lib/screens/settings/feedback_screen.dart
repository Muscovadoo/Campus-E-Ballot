// lib/screens/settings/feedback_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  String? _selectedFeedbackType;
  final List<String> _feedbackTypes = [
    'General Inquiry',
    'Bug Report',
    'Feature Request',
    'Suggestion',
    'Complaint',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    // Handle feedback submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for your feedback!'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      _rating = 0;
      _feedbackController.clear();
      _selectedFeedbackType = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.studentDashboardRoute,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = sessionUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback / Contact Us', style: AppTextStyles.appBarTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Image.asset('assets/images/BatstateU-NEU-Logo.png', height: 28),
                const SizedBox(width: 4),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 28,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        alignment: Alignment.center,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370,
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Name',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: (() {
                      final fName = user?['FName'] ?? user?['firstName'] ?? '';
                      final mName = user?['MName'] ?? user?['middleName'] ?? '';
                      final lName = user?['LName'] ?? user?['lastName'] ?? '';
                      String middleInitial = '';
                      if (mName.trim().isNotEmpty) {
                        middleInitial = ' ${mName.trim()[0]}.';
                      }
                      return '$fName$middleInitial $lName'.trim();
                    })(),
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'GSuite Account',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: user?['gsuite'] ?? '',
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Feedback Type',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _selectedFeedbackType,
                    items: _feedbackTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurface,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedFeedbackType = val),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Rate your experience',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Your Feedback',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback or message here...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _feedbackController.text.isEmpty ||
                              _selectedFeedbackType == null
                          ? null
                          : () {
                              _submitFeedback();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: AppTextStyles.buttonText.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
