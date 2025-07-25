// lib/screens/election/candidate_viewer_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/models/candidate_model.dart';
// Reuse this widget

class CandidateViewerScreen extends StatefulWidget {
  const CandidateViewerScreen({super.key});

  @override
  State<CandidateViewerScreen> createState() => _CandidateViewerScreenState();
}

class _CandidateViewerScreenState extends State<CandidateViewerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Candidate> get _filteredCandidates {
    if (_searchQuery.isEmpty) return candidates;
    return candidates
        .where(
          (c) =>
              c.fullname.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.position.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _showCandidatePopup(Candidate candidate) {
    showDialog(
      context: context,
      barrierDismissible: false, // Only back button can close
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true, // Allow back button
          child: Dialog(
            insetPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          candidate.fullname,
                          style: AppTextStyles.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (candidate.imageUrl.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: AssetImage(candidate.imageUrl),
                      radius: 50,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Position: ${candidate.position}',
                    style: AppTextStyles.bodyLarge,
                  ),
                  Text(
                    'Party: ${candidate.party}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Manifesto:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(candidate.manifesto, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCandidateDetailPopup(BuildContext context, Candidate candidate) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            candidate.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 90,
                                  height: 90,
                                  color: AppColors.surface,
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColors.primary,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                candidate.fullname,
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                candidate.position,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                candidate.party,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Department: ${candidate.department}',
                                style: AppTextStyles.bodyMedium,
                              ),
                              Text(
                                'Course: ${candidate.course}',
                                style: AppTextStyles.bodyMedium,
                              ),
                              Text(
                                'Year Level: ${candidate.yearLevel}',
                                style: AppTextStyles.bodyMedium,
                              ),
                              Text(
                                'SR Code: ${candidate.srCode}',
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Manifesto:',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                candidate.manifesto,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.primary,
                          size: 28,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        tooltip: 'Close',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateListTile(BuildContext context, Candidate candidate) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                candidate.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidate.fullname,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    candidate.position,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 32,
              ),
              onPressed: () => _showCandidateDetailPopup(context, candidate),
              tooltip: 'View Details',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidate Viewer', style: AppTextStyles.appBarTitle),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or position...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.iconColor,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurface,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _filteredCandidates.length,
                itemBuilder: (context, index) {
                  final candidate = _filteredCandidates[index];
                  return _buildCandidateListTile(context, candidate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
