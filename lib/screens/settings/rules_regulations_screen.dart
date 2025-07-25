// lib/screens/settings/rules_regulations_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';

class RulesRegulationsScreen extends StatelessWidget {
  const RulesRegulationsScreen({super.key});

  // Placeholder content for Rules and Regulations.
  // In a real app, this might be fetched from a database or a markdown file.
  final String _rulesContent = """
These rules and regulations would be established to ensure the fairness, integrity, security, and transparency of the student elections conducted through the Campus e-Ballot system.

Section 1. Eligibility and Access Rules 🔒
1.1 Voter Eligibility: Only currently enrolled students of Batangas State University TNEU – Jose P. Laurel Polytechnic College (JPLPC) Malvar Campus, who meet specific academic and residency criteria as set by the university or SSC, are eligible to vote.
1.2 Authentication: Access to the e-Ballot system requires valid university credentials. Any attempt to access the system with unauthorized credentials is strictly prohibited.
1.3 Single Vote Rule: Each eligible student is entitled to one vote per election. Any attempt to cast multiple votes will result in the invalidation of all associated votes and may lead to disciplinary action.

Section 2. Conduct and Prohibited Activities Rules 🚫
2.1 System Integrity: Users must not attempt to interfere with, disrupt, or gain unauthorized access to any part of the e-Ballot system, its servers, or its data.
2.2 Manipulation and Fraud: Any attempt to manipulate election results, cast fraudulent votes, or engage in any form of electoral misconduct is strictly forbidden and will result in severe disciplinary consequences.
2.3 Automated Access: The use of bots, scripts, or any automated tools for accessing or interacting with the voting system is expressly prohibited. All votes must be cast manually by the eligible voter.
2.4 Confidentiality of Credentials: Users are solely responsible for maintaining the confidentiality of their login credentials. Sharing credentials or allowing others to vote on one's behalf is a violation of these rules.
2.5 Electioneering: Specific rules would govern electioneering activities (e.g., campaigning) within or near the e-Ballot platform interface, if applicable, to prevent undue influence on voters.

Section 3. Voting Procedure 🗳️
3.1 Access to the e-Ballot system requires successful login using your registered credentials.
3.2 Voters must accept the Terms and Conditions before proceeding to the ballot.
3.3 The ballot lists all positions and their respective candidates. Voters must select one candidate for each mandatory position.
3.4 Review your selections on the Vote Confirmation Screen before final submission. Once confirmed, votes cannot be changed or retracted.

Section 4. System Integrity and Security 🔒
4.1 The Campus E-Ballot system employs advanced encryption and security measures to ensure the anonymity and integrity of each vote.
4.2 Any attempt to tamper with the system, cast multiple votes, or engage in fraudulent activities will result in immediate disqualification and may lead to disciplinary action.
4.3 Voter data, excluding the vote itself, may be logged for audit purposes to ensure fair conduct.

Section 5. Election Period 📅
5.1 The official election period will be announced through the Announcements section and campus-wide advisories.
5.2 Voting outside the designated period is not permitted. The system will automatically close once the period concludes.

Section 6. Voting Process Rules ✅
6.1 Voting Period: Votes can only be cast within the officially designated voting period (start and end dates/times). Votes cast outside this period will not be counted.
6.2 Finality of Vote: Once a vote is successfully submitted through the e-Ballot system, it is considered final and irreversible. There will be no option to change, retract, or re-cast a vote.
6.3 Technical Issues: Procedures for reporting and resolving technical issues during the voting period would be outlined, including contact points for support.
6.4 Review and Confirmation: Voters are encouraged to review their selections carefully before final submission, as changes cannot be made post-submission.

Section 7. Data Privacy and Security Rules 🛡️
7.1 Data Use: Personal data collected for voter verification purposes will only be used for the administration of the election and will be handled in accordance with the university's data privacy policies.
7.2 Vote Anonymity: The system is designed to ensure the anonymity of individual votes while maintaining the integrity of the overall election results. Rules would confirm that specific votes cannot be linked back to individual voters by authorized personnel, except for auditing purposes under strict conditions.
7.3 Reporting Breaches: Users must immediately report any suspected security breaches, unauthorized access, or misuse of the e-Ballot system to the designated authorities.

Section 8. Enforcement and Consequences ⚖️
8.1 Violation Procedures: Outlines the procedures for investigating alleged violations of these rules and regulations.
8.2 Disciplinary Actions: Specifies potential disciplinary actions for violations, which may include, but are not limited to, invalidation of votes, suspension of university privileges, academic sanctions, or legal action depending on the severity and nature of the offense.
8.3 Oversight Body: Identifies the body responsible for overseeing the election process and enforcing these rules (e.g., the SSC Electoral Board, University Administration).

Section 9. Amendments and Updates 🔄
9.1 Rule Changes: The university and/or the SSC reserve the right to amend or update these rules and regulations as deemed necessary.
9.2 Notification: All eligible voters and stakeholders will be duly informed of any changes to these rules through official university channels.
9.3 For any inquiries or technical assistance, please refer to the Help/FAQ’s section or contact the support team.
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(
              context,
            ).pop(); // Go back to previous screen (Dashboard/Settings)
          },
        ),
        title: Text(
          'Rules and Regulation', // Title from UI Page 16
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            margin: EdgeInsets.zero, // Card takes full padding from parent
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to start
                children: [
                  Text(
                    'Campus E-Ballot System',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Rules & Regulations',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _rulesContent,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign
                        .justify, // Justify text for better readability
                  ),
                  // If there were specific sections, you might use:
                  // Text(
                  //   'I. Eligibility to Vote',
                  //   style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
                  // ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  //   style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface),
                  // ),
                  // Add more sections as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
