// ... existing imports ...
import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart';
import 'package:campus_ballot_voting_system/widgets/drawer_navigation.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'package:campus_ballot_voting_system/screens/settings/profile_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  bool _expanded = false;

  void _showVoteSubmittedAlert(BuildContext context, String vrn) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/BatStateU-NEU-Logo.png',
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(width: 18),
                  Image.asset(
                    'assets/images/SSC-JPLPCMalvar-Logo.png',
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'You have already voted!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              if (vrn.isNotEmpty)
                Text(
                  'Vote Reference Number (VRN): ${vrn}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 18),
              const Text(
                'You can only vote once per GSuite Account',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('GO HOME'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateIdCard() {
    final user = sessionUser ?? {};
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Use the updated ID card widget from profile_screen.dart, but keep the rest of the logic and elements
              IdCardWidget(user: user),
              const SizedBox(height: 22),
              SizedBox(
                width: 240,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copy sent to your GSuite email',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  child: const Text('Print a Copy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIdCardDialog() {
    final user = sessionUser ?? {};
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IdCardWidget(user: user),
              const SizedBox(height: 22),
              SizedBox(
                width: 240,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copy sent to your GSuite email',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  child: const Text('Print a Copy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showFooterButtons =
        !(ModalRoute.of(context)?.isCurrent == false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Dashboard',
          style: AppTextStyles.appBarTitle,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/BatStateU-NEU-Logo.png',
                  height: 30,
                  width: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.school, size: 30);
                  },
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 30,
                  width: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.groups, size: 30);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const DrawerNavigation(),
      body: Stack(
        children: [
          // Fixed background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
          // Foreground scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32.0,
                    left: 24,
                    right: 24,
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '𝗦𝗦𝗖 𝗘𝗟𝗘𝗖𝗧𝗜𝗢𝗡 𝟮𝟬𝟮𝟱: \n𝗩𝗢𝗧𝗜𝗡𝗚 𝗜𝗦 𝗡𝗢𝗪 𝗢𝗣𝗘𝗡!',
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    color: AppColors.onSurface,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: AppColors.iconColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _expanded = !_expanded;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 200),
                            crossFadeState: _expanded
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Text(
                              '📢To All Esteemed Students of Batangas State University TNEU – JPLPC Malvar Campus, \n\nThe moment has arrived! The Supreme Student Council (SSC) Election 2025 is officially underway, and the Campus e-Ballot: Secure Student-Leader Elections System is now open for your crucial participation. This is your direct opportunity to choose the next generation of leaders who will represent your voice and drive progress within our beloved campus.\n\nYour active involvement in these elections is fundamental to shaping a vibrant, inclusive, and forward-thinking university community. The SSC plays a vital role in advancing student welfare, promoting academic excellence, and championing your interests \n\nExercise Your Right – Cast Your Vote Securely! \n\nWe invite every eligible student to log in to the Campus e-Ballot system and make your selection. Our system is designed with the highest standards of security, transparency, and confidentiality to ensure your vote is counted accurately and anonymously. \n\nTake a moment to review the platforms and aspirations of your candidates. Your informed decision today will define the leadership of tomorrow. \n\nDont miss this opportunity to make a lasting mark on our campus future! \n\n#BatStateUTNEUMalvar\n#LeadInspireLeaveAMark\n#SSCElection2025\n#VoteNow',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurface,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            secondChild: Text(
                              '📢To All Esteemed Students of Batangas State University TNEU – JPLPC Malvar Campus',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurface,
                                fontSize: 10,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomButton(
                              text: 'Vote now',
                              onPressed: () {
                                final gsuite = sessionUser?['gsuite'];
                                if (gsuite != null && getUserHasVoted(gsuite)) {
                                  // Show the vote submitted alert with VRN
                                  final vrn = getUserVRN(gsuite) ?? '';
                                  _showVoteSubmittedAlert(context, vrn);
                                } else {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(AppRouter.termsConditionsRoute);
                                }
                              },
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 0,
                              ),
                              textStyle: AppTextStyles.labelLarge,
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.grey[100],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
          (sessionUser != null &&
              sessionUser!['profileSaved'] == 'true' &&
              !_expanded)
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
                left: 40.0,
                right: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: FloatingActionButton(
                      onPressed: _showIdCardDialog,
                      backgroundColor: Colors.blue,
                      elevation: 8,
                      child: const Icon(
                        Icons.badge,
                        color: Colors.white,
                        size: 32,
                      ),
                      heroTag: 'idCardBtn',
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/feedback');
                      },
                      backgroundColor: Colors.green,
                      elevation: 8,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 28,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      tooltip: 'Send Feedback',
                      heroTag: 'feedbackBtn',
                    ),
                  ),
                ],
              ),
            )
          : (!_expanded
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/feedback');
                    },
                    backgroundColor: Colors.green,
                    elevation: 8,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 28,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    tooltip: 'Send Feedback',
                    heroTag: 'feedbackBtn',
                  )
                : null),
    );
  }
}
