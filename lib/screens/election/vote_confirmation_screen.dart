// lib/screens/election/vote_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/models/candidate_model.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'package:campus_ballot_voting_system/screens/election/vote_submitted_screen.dart';

class VoteConfirmationScreen extends StatelessWidget {
  const VoteConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Candidate> selectedCandidates =
        ModalRoute.of(context)?.settings.arguments as List<Candidate>? ?? [];
    final user = sessionUser ?? {};
    final Map<String, Candidate> votesByPosition = {
      for (var c in selectedCandidates)
        c.position == 'Governor' ? 'Governor' : c.position: c,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote Confirmation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // This preserves state!
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Image.asset('assets/images/BatstateU-NEU-Logo.png', height: 32),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    // Compose full name as in profile_screen.dart: FName + middle initial + LName
                    (() {
                      final fName = user['FName'] ?? user['firstName'] ?? '';
                      final mName = user['MName'] ?? user['middleName'] ?? '';
                      final lName = user['LName'] ?? user['lastName'] ?? '';
                      String middleInitial = '';
                      if (mName.trim().isNotEmpty) {
                        middleInitial = ' ${mName.trim()[0]}.';
                      }
                      final fullName = '$fName$middleInitial $lName'.trim();
                      final srCode = user['srCode'] ?? '';
                      return 'Voter: $fullName (${srCode.isNotEmpty ? srCode : 'N/A'})';
                    })(),
                  ),
                  Text('GSuite: ${user['gsuite'] ?? ''}'),
                  const SizedBox(height: 16),
                  Text(
                    'Your Votes:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (votesByPosition.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No votes selected.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ...votesByPosition.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            entry.value.fullname,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            'Department: ${entry.value.department}',
                            style: const TextStyle(fontSize: 10),
                          ),
                          Text(
                            'Course: ${entry.value.course} (${entry.value.yearLevel})',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Check if user has already voted
                            if (sessionUser != null &&
                                hasUserVoted(sessionUser!['gsuite'])) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You have already voted with this account.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            // Prevent submission if no votes are selected
                            if (votesByPosition.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You must select at least one candidate.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            // Always generate a VRN if not present
                            String vrn = user['lastVRN'] ?? '';
                            if (vrn.isEmpty) {
                              vrn = VoteSubmittedScreen.generateVRN();
                              sessionUser?['lastVRN'] = vrn;
                            }
                            // Mark as submitted
                            VoteSubmittedScreen.hasSubmittedVote = true;
                            if (sessionUser != null) {
                              setUserVoted(sessionUser!['gsuite'], vrn);
                            }
                            Navigator.pushReplacementNamed(
                              context,
                              '/vote-submitted',
                              arguments: {
                                'votingReceiptNumber': vrn,
                                'voterName': sessionUser?['fullName'] ?? '',
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
