// lib/screens/election/vote_submitted_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/session.dart';

class VoteSubmittedScreen extends StatelessWidget {
  const VoteSubmittedScreen({super.key});

  static bool hasSubmittedVote = false;

  static String generateVRN() {
    final rand = Random();
    final letters = String.fromCharCodes(
      List.generate(3, (_) => rand.nextInt(26) + 65),
    );
    final digits = rand.nextInt(900) + 100; // 3 digits
    return '$letters***$digits';
  }

  @override
  Widget build(BuildContext context) {
    // Mark as submitted
    VoteSubmittedScreen.hasSubmittedVote = true;
    final user = sessionUser ?? {};
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String vrn = args?['votingReceiptNumber'] ?? user['lastVRN'] ?? '';
    if (vrn.isEmpty) {
      vrn = generateVRN();
      sessionUser?['lastVRN'] = vrn;
    }
    final voterName = args?['voterName'] ?? user['fullName'] ?? '';
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 16,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/BatstateU-NEU-Logo.png',
                    height: 80,
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/SSC-JPLPCMalvar-Logo.png',
                    height: 80,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Vote Submitted Successfully',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'VRN. $vrn',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'GO HOME',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/student-dashboard',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
