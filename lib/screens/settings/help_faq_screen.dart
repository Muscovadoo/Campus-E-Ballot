// lib/screens/settings/help_faq_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'What is the Campus e-Ballot System?',
      'answer':
          'The Campus e-Ballot System is a secure online platform designed to facilitate the student-leader elections for the Supreme Student Council (SSC) of Batangas State University TNEU – Jose P. Laurel Polytechnic College (JPLPC) Malvar Campus. Its purpose is to ensure a fair, transparent, and accessible voting process for all eligible students.',
    },
    {
      'question': 'What is the Supreme Student Council (SSC)?',
      'answer':
          'The Supreme Student Council (SSC) is the highest student governing body at Batangas State University TNEU – JPLPC Malvar Campus. The SSC is committed to student welfare, promoting academic excellence, championing student rights, and playing a crucial role in shaping campus policies.',
    },
    {
      'question':
          'What are the benefits of using an e-Ballot system for elections?',
      'answer':
          'The e-Ballot system offers several benefits, including increased accessibility for voters, enhanced security and integrity of votes, faster and more accurate vote tabulation, reduced logistical costs, and a more environmentally friendly approach compared to traditional paper-based elections.',
    },
    {
      'question': 'How do I access the Campus e-Ballot System?',
      'answer':
          'You can access the Campus e-Ballot System by visiting the official link provided by the university/SSC. You will typically log in using your official university student credentials (e.g., student ID and password). Make sure you are using a stable internet connection.',
    },
    {
      'question': 'Who is eligible to vote in the SSC Elections?',
      'answer':
          'Generally, all currently enrolled students of Batangas State University TNEU – JPLPC Malvar Campus who meet specific academic and residency criteria set by the university or SSC are eligible to vote. Please refer to official election guidelines for precise eligibility requirements.',
    },
    {
      'question': 'What if I forget my university login credentials?',
      'answer':
          'The Campus e-Ballot System uses your existing university credentials. If you forget them, you will need to follow the standard university procedure for password recovery or account assistance, usually through the university\'s IT support or student services.',
    },
    {
      'question': 'Can I vote from any device?',
      'answer':
          'Yes, the system is designed to be accessible from various devices (e.g., desktop computers, laptops, tablets, smartphones) with an internet connection. Ensure your device is connected to a stable network for a smooth voting experience.',
    },
    {
      'question': 'Is my vote anonymous and secure?',
      'answer':
          'Yes, the Campus e-Ballot System is designed with robust security measures to ensure the anonymity and confidentiality of your individual vote. While your login ensures eligibility, your specific vote is separated from your identity to protect your privacy and guarantee election integrity. The system employs encryption and secure protocols.',
    },
    {
      'question': 'Can I change my vote after it\'s cast?',
      'answer':
          'No. Once your vote is successfully submitted through the Campus e-Ballot System, it is considered final and irreversible. Please review your selections carefully before confirming your vote. This rule ensures the integrity of the election process.',
    },
    {
      'question': 'What if I encounter a technical issue while voting?',
      'answer':
          'If you experience any technical difficulties or have questions during the voting process, please refer to the "Contact Us" section within the Campus e-Ballot system. You can usually find contact details for technical support or the SSC office there. Do not attempt to fix issues yourself by repeatedly trying to vote.',
    },
    {
      'question': 'How many times can I vote?',
      'answer':
          'Each eligible student is entitled to one vote per election. The system is designed with strict controls to prevent multiple votes from the same individual to maintain fairness and accuracy. Any attempt to cast more than one vote may lead to vote invalidation and disciplinary action.',
    },
    {
      'question': 'How long is the voting period open?',
      'answer':
          'The official voting period, including start and end dates and times, will be clearly announced by the Supreme Student Council (SSC) and will be visible on the Campus e-Ballot system\'s home screen. Votes can only be cast within this specified timeframe.',
    },
    {
      'question':
          'What happens if I lose my internet connection during voting?',
      'answer':
          'If your internet connection is interrupted before you confirm your vote, your selections may not be saved. You will need to re-access the system and complete the voting process once your connection is restored. Ensure you receive a confirmation message that your vote was successfully cast.',
    },
    {
      'question': 'Can I view candidate profiles before voting?',
      'answer':
          'Yes, the Campus e-Ballot system or associated election platforms will typically provide access to candidate profiles, platforms, and other relevant information to help you make an informed decision before casting your vote.',
    },
    {
      'question': 'How will I know the election results?',
      'answer':
          'Official election results will be announced by the Supreme Student Council (SSC) through various university channels, such as official announcements on the Campus e-Ballot system, campus bulletin boards, and university social media pages, after the voting period has concluded and votes have been tabulated and verified.',
    },
    {
      'question': 'How can I provide feedback on the Campus e-Ballot System?',
      'answer':
          'We value your input! You can provide feedback on the Campus e-Ballot System through the dedicated "Feedback Interface" within the platform. Simply log in and navigate to the feedback section, where you can share your suggestions and observations.',
    },
    {
      'question': 'What if I suspect a security breach or fraudulent activity?',
      'answer':
          'It is crucial to immediately report any suspected security breaches, unauthorized access, or fraudulent activities related to the e-Ballot system to the designated university authorities or the SSC office. Do not attempt to investigate it yourself.',
    },
    {
      'question':
          'Are there specific rules and regulations for using the system?',
      'answer':
          'Yes, the use of the Campus e-Ballot system is governed by specific rules and regulations established by the university and/or the SSC Electoral Board to ensure a fair and legitimate election. These rules cover eligibility, prohibited conduct, and consequences for violations.',
    },
    {
      'question': 'Who developed the Campus e-Ballot System?',
      'answer':
          'The Campus e-Ballot system for the Supreme Student Council of Batangas State University TNEU – JPLPC Malvar Campus was developed by [Anciado, Francis Andrei M., Galicio, Mark Jhon, and Peñaredondo. Jaymuel A. from BSIT SM-3302], as indicated in the system documentation.',
    },
    {
      'question': 'Where can I get more information about the SSC Elections?',
      'answer':
          'For more detailed information regarding the SSC Elections, including candidate registration, specific timelines, and official guidelines, please refer to announcements from the Supreme Student Council, official university circulars, or the dedicated election pages on the university website.',
    },
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Help & FAQ's", style: AppTextStyles.appBarTitle),
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
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Campus e-Ballot System: Helps and FAQs ❓',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome to the Help and FAQ section for the Campus e-Ballot: Secure Student-Leader Elections System. Here, you\'ll find answers to common questions to ensure a smooth and secure voting experience for the Supreme Student Council (SSC) elections at Batangas State University TNEU – JPLPC Malvar Campus.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onPrimary,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  ExpansionPanelList.radio(
                    expandedHeaderPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    elevation: 2,
                    initialOpenPanelValue: _expandedIndex,
                    children: _faqItems.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var faq = entry.value;
                      return ExpansionPanelRadio(
                        value: idx,
                        headerBuilder: (context, isExpanded) => ListTile(
                          title: Text(
                            faq['question']!,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        body: Container(
                          width: double.infinity,
                          color: AppColors.surface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            faq['answer']!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.onSurface,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/feedback');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        textStyle: AppTextStyles.buttonText.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      child: const Text('Send Feedback'),
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
