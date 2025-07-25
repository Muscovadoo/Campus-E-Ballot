// lib/screens/settings/announcements_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/announcement_card.dart'; // Import the new widget

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  // Placeholder list of announcements. In a real app, this would come from a service/API.
  final List<Map<String, String>> _announcements = const [
    {
      'subject':
          '𝗖𝗔𝗠𝗣𝗨𝗦 𝗘-𝗕𝗔𝗟𝗟𝗢𝗧: 𝗦𝗬𝗦𝗧𝗘𝗠 𝗠𝗔𝗜𝗡𝗧𝗘𝗡𝗔𝗡𝗖𝗘 𝗔𝗗𝗩𝗜𝗦𝗢𝗥𝗬 ⚙️',
      'content': '''
To All Batangas State University TNEU – JPLPC Malvar Campus Students,
Please be advised that the Campus e-Ballot: Secure Student-Leader Elections System will undergo scheduled maintenance to enhance its performance, security, and reliability. This routine update is essential to ensure the continued smooth operation of our electoral platform.

Maintenance Schedule:
Date: Friday, August 9, 2025
Time: 9:00 PM to 12:00 AM PHT

During this period, the Campus e-Ballot system may be temporarily inaccessible. We apologize for any inconvenience this may cause and appreciate your understanding as we work to provide you with the best possible service.''',
      'date': 'July 05, 2024',
    },
    {
      'subject':
          '𝗬𝗢𝗨𝗥 𝗜𝗡𝗣𝗨𝗧 𝗠𝗔𝗧𝗧𝗘𝗥𝗦: 𝗛𝗘𝗟𝗣 𝗨𝗦 𝗜𝗠𝗣𝗥𝗢𝗩𝗘 𝗖𝗔𝗠𝗣𝗨𝗦 𝗘-𝗕𝗔𝗟𝗟𝗢𝗧! 💬',
      'content': '''
We at the Supreme Student Council (SSC) are committed to continuously enhancing your experience with the Campus e-Ballot: Secure Student-Leader Elections System. As we strive for excellence and transparency, your insights are invaluable in refining our platform.

Whether you've voted, explored candidate profiles, or simply navigated the system, we want to hear from you! Your feedback helps us identify areas for improvement, address any challenges, and ensure the e-Ballot system remains efficient, secure, and user-friendly for all future elections.

Share Your Thoughts!

Please take a few moments to provide your feedback through our dedicated Feedback Interface within the Campus e-Ballot system. Simply log in and look for the 'Feedback' or 'Contact Us' section.

Your constructive comments, suggestions, and observations are crucial to our continuous pursuit of excellence. Thank you for helping us build an even better electoral experience for the Batangas State University TNEU – JPLPC Malvar Campus community.''',
      'date': 'July 05, 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(
              context,
            ).pop(); // Go back to previous screen (Dashboard)
          },
        ),
        title: Text(
          'Announcements', // Title from UI Page 14
          style: AppTextStyles.appBarTitle,
        ),
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
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient, // Consistent gradient background
        ),
        child: _announcements.isEmpty
            ? Center(
                child: Text(
                  'No announcements yet.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _announcements.length,
                itemBuilder: (context, index) {
                  final announcement = _announcements[index];
                  return AnnouncementCard(
                    subject: announcement['subject']!,
                    content: announcement['content']!,
                    date: announcement['date']!,
                  );
                },
              ),
      ),
    );
  }
}
