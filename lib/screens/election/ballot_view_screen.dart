// lib/screens/election/ballot_view_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/models/candidate_model.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'package:campus_ballot_voting_system/screens/election/vote_confirmation_screen.dart';

class BallotViewScreen extends StatefulWidget {
  const BallotViewScreen({super.key});

  @override
  State<BallotViewScreen> createState() => _BallotViewScreenState();
}

class _BallotViewScreenState extends State<BallotViewScreen> {
  Map<String, String> selectedCandidates = {};
  bool _showIncompleteError = false;

  bool isProfileComplete(Map<String, dynamic> user) {
    return user['fullName']?.isNotEmpty == true &&
        user['srCode']?.isNotEmpty == true &&
        user['department']?.isNotEmpty == true &&
        user['course']?.isNotEmpty == true &&
        user['yearLevel']?.isNotEmpty == true;
  }

  @override
  Widget build(BuildContext context) {
    final user = sessionUser ?? {};
    if (!isProfileComplete(user)) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('E-Ballot'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/BatstateU-NEU-Logo.png',
                    height: 32,
                  ),
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
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info, color: Colors.red, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Please complete your profile before voting.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Go to Profile'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    final userDept = user['department'] ?? '';

    // Get all unique positions except governors
    final positions = candidates
        .map((c) => c.position)
        .where((pos) => !pos.contains('Governor'))
        .toSet()
        .toList();

    // Add a single 'Governor' section
    positions.add('Governor');

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Ballot'),
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
        children: [
          ...positions.map((position) {
            List<Candidate> positionCandidates;
            if (position == 'Governor' && userDept.isNotEmpty) {
              positionCandidates = candidates
                  .where(
                    (c) =>
                        c.position.contains('Governor') &&
                        c.department == userDept,
                  )
                  .toList();
            } else {
              positionCandidates = candidates
                  .where((c) => c.position == position)
                  .toList();
            }
            if (positionCandidates.isEmpty) return const SizedBox.shrink();
            final bool showAsterisk =
                _showIncompleteError && selectedCandidates[position] == null;
            return Stack(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          position,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ...positionCandidates.map(
                        (candidate) => RadioListTile<String>(
                          value: candidate.id,
                          groupValue: selectedCandidates[position],
                          onChanged: (val) {
                            setState(() {
                              selectedCandidates[position] = val!;
                            });
                          },
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(candidate.imageUrl),
                                radius: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      candidate.fullname,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      candidate.manifesto,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showAsterisk)
                  Positioned(
                    top: 8,
                    right: 16,
                    child: Text(
                      '*',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
              ],
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedCandidates.length != positions.length) {
                        setState(() {
                          _showIncompleteError = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please complete your vote for all positions.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      setState(() {
                        _showIncompleteError = false;
                      });
                      // Build the selected candidates list by matching IDs
                      final List<Candidate> selected = [];
                      for (final position in positions) {
                        final selectedId = selectedCandidates[position];
                        if (selectedId != null) {
                          final candidate = candidates.firstWhere(
                            (c) => c.id == selectedId,
                            orElse: () => candidates.first,
                          );
                          selected.add(candidate);
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VoteConfirmationScreen(),
                          settings: RouteSettings(
                            arguments: selected, // Pass List<Candidate>
                          ),
                        ),
                      );
                    },
                    child: const Text('Review & Confirm Vote'),
                  ),
                ),
                if (_showIncompleteError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'You must select a candidate for every position.',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
