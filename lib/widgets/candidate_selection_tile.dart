// lib/widgets/candidate_selection_tile.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/models/candidate_model.dart';

class CandidateSelectionTile extends StatelessWidget {
  final Candidate candidate;
  final bool selected;
  final VoidCallback? onTap;

  const CandidateSelectionTile({
    super.key,
    required this.candidate,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(candidate.imageUrl)),
      title: Text(candidate.fullname),
      subtitle: Text(candidate.position),
      trailing: selected ? Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: onTap,
    );
  }
}
