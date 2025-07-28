// lib/widgets/drawer_navigation.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background, // Use background color from theme
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header with logos and project name
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient, // Consistent gradient
            ),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.only(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/BatstateU-NEU-Logo.png',
                      height: 70,
                      width: 70,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/SSC-JPLPCMalvar-Logo.png',
                      height: 70,
                      width: 70,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Campus E-Ballot',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Navigation List Tiles
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Home',
            routeName:
                AppRouter.studentDashboardRoute, // Self-referential for now
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person,
            text: 'Profile',
            routeName: AppRouter.profileRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.group,
            text: 'Candidate Viewer',
            routeName: AppRouter.candidateViewerRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.gavel,
            text: 'Rules and Regulation',
            routeName: AppRouter.rulesRegulationsRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.announcement,
            text: 'Announcement',
            routeName: AppRouter.announcementsRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: 'Settings',
            routeName: AppRouter.settingsRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info,
            text: 'About us',
            routeName: AppRouter.aboutUsRoute,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.help_outline,
            text: 'Help/FAQ\'s',
            routeName: AppRouter.helpFaqRoute,
          ),
          const Divider(), // A visual separator

          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              // Close the drawer first
              Navigator.of(context).pop();
              // Show confirmation dialog before logout
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Helper method to build consistent DrawerListTiles
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    String? routeName,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.iconColor),
      title: Text(
        text,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onBackground),
      ),
      onTap:
          onTap ??
          () {
            // Close the drawer before navigating
            Navigator.of(context).pop();
            if (routeName != null && context.mounted) {
              Navigator.of(context).pushNamed(routeName);
            }
          },
    );
  }

  // Helper method to show logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'Confirm Logout',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to login screen, clearing the navigation stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.loginRoute,
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'Logout',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
