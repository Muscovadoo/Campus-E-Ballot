// lib/screens/settings/about_us_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // Content for the About Us section, based on Documentation E-Ballot.pdf, Page 25.
  final String _aboutUsContent = '''
Batangas State University (BSU)

Batangas State University (BSU) is the premier state university in the Province of Batangas, Philippines. Dedicated to providing quality education, BSU plays a pivotal role in national and regional development through its diverse academic programs, research, and community extension services. The TNEU – Jose P. Laurel Polytechnic College (JPLPC) Malvar Campus is one of BSU's key campuses, upholding the university's mission to produce globally competitive and morally upright graduates. BSU fosters an environment conducive to learning, innovation, and leadership development, serving as the overarching institution within which all student governance and activities, including the SSC elections, take place.


The Supreme Student Council (SSC)

The Supreme Student Council (SSC) is recognized as the highest student governing body within Batangas State University TNEU – Jose P. Laurel Polytechnic College (JPLPC) Malvar Campus. Composed of dedicated student leaders, the SSC is fundamentally committed to student welfare and interests.

Their core mission is to foster "a vibrant, inclusive, and progressive campus community where every student's voice is heard, valued, and represented." This mission is achieved through various key initiatives, including:

- Organizing impactful campus events that enrich student life and promote camaraderie.
- Promoting academic excellence by advocating for student needs in educational policies and resources.
- Championing student rights and privileges, ensuring fair treatment and opportunities for all.
- Providing avenues for leadership development, empowering students to grow into responsible and effective leaders.
- Playing a "crucial role in shaping campus policies," serving as the legitimate voice of the student body in university decisions.

The SSC's "continuous pursuit of excellence and transparency" is central to their operations. This commitment extends to their partnership in launching and maintaining the Campus e-Ballot: Secure Student-Leader Elections System, ensuring fair, secure, and accessible elections for all eligible students. Through their efforts, the SSC strives to build a stronger, more engaged, and more representative student community within Batangas State University.
''';

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
          'About us', // Title from UI Page 20
          style: AppTextStyles.appBarTitle,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Image.asset('assets/images/BatstateU-NEU-Logo.png', height: 40),
                const SizedBox(width: 4),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 40,
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
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center logos and main text
                children: [
                  // Logos at the top of the card, as per UI Page 20
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/BatstateU-NEU-Logo.png',
                        height: 110,
                        width: 110,
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/images/SSC-JPLPCMalvar-Logo.png',
                        height: 110,
                        width: 110,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Supreme Student Council',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Batangas State University TNEU – JPLPC Malvar Campus',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.dividerColor), // Separator
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _aboutUsContent,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurface,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // "Contact Us" Button, as mentioned in Documentation
                  CustomButton(
                    text: 'Contact Us',
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRouter.feedbackRoute);
                    },
                    backgroundColor: AppColors
                        .secondary, // Use a distinct color for this button
                    foregroundColor: AppColors.onSecondary,
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
