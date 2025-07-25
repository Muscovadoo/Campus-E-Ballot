// lib/config/app_router.dart (CORRECTED/UPDATED)

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/screens/home/splash_screen.dart';
import 'package:campus_ballot_voting_system/screens/auth/login_screen.dart';
import 'package:campus_ballot_voting_system/screens/auth/signup_screen.dart';
import 'package:campus_ballot_voting_system/screens/auth/forgot_password_screen.dart';
import 'package:campus_ballot_voting_system/screens/home/student_dashboard_screen.dart';
import 'package:campus_ballot_voting_system/screens/election/ballot_view_screen.dart';
import 'package:campus_ballot_voting_system/screens/election/candidate_viewer_screen.dart';
import 'package:campus_ballot_voting_system/screens/election/terms_conditions_screen.dart';
import 'package:campus_ballot_voting_system/screens/election/vote_confirmation_screen.dart';
import 'package:campus_ballot_voting_system/screens/election/vote_submitted_screen.dart';
import 'package:campus_ballot_voting_system/screens/settings/profile_screen.dart';
import 'package:campus_ballot_voting_system/screens/settings/announcements_screen.dart';
import 'package:campus_ballot_voting_system/screens/settings/rules_regulations_screen.dart';
import 'package:campus_ballot_voting_system/screens/settings/settings_screen.dart';
import 'package:campus_ballot_voting_system/screens/settings/about_us_screen.dart';
import 'package:campus_ballot_voting_system/screens/settings/help_faq_screen.dart';
import 'package:campus_ballot_voting_system/screens/settings/feedback_screen.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/screens/settings/reset_password_screen.dart';

class AppRouter {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String studentDashboardRoute = '/student-dashboard';
  static const String ballotViewRoute = '/ballot-view';
  static const String candidateViewerRoute = '/candidate-viewer';
  static const String profileRoute = '/profile';
  static const String announcementsRoute = '/announcements';
  static const String rulesRegulationsRoute = '/rules-regulations';
  static const String settingsRoute = '/settings';
  static const String aboutUsRoute = '/about-us';
  static const String helpFaqRoute = '/help-faq';
  static const String feedbackRoute = '/feedback';
  static const String termsConditionsRoute = '/terms-conditions';
  static const String voteConfirmationRoute = '/vote-confirmation';
  static const String voteSubmittedRoute = '/vote-submitted';
  static const String resetPasswordRoute = '/reset-password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case studentDashboardRoute:
        return MaterialPageRoute(
          builder: (_) => const StudentDashboardScreen(),
        );
      case ballotViewRoute:
        return MaterialPageRoute(builder: (_) => const BallotViewScreen());
      case candidateViewerRoute:
        return MaterialPageRoute(builder: (_) => const CandidateViewerScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case announcementsRoute:
        return MaterialPageRoute(builder: (_) => const AnnouncementsScreen());
      case rulesRegulationsRoute:
        return MaterialPageRoute(
          builder: (_) => const RulesRegulationsScreen(),
        );
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case aboutUsRoute:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());
      case helpFaqRoute:
        return MaterialPageRoute(builder: (_) => const HelpFaqScreen());
      case feedbackRoute:
        return MaterialPageRoute(builder: (_) => const FeedbackScreen());
      case termsConditionsRoute:
        return MaterialPageRoute(builder: (_) => const TermsConditionsScreen());
      case voteConfirmationRoute:
        // Pass the settings object to preserve arguments
        return MaterialPageRoute(
          builder: (_) => const VoteConfirmationScreen(),
          settings: settings,
        );
      case voteSubmittedRoute:
        // Pass arguments to VoteSubmittedScreen using the public constructor
        return MaterialPageRoute(
          builder: (_) => const VoteSubmittedScreen(),
          settings: settings,
        );
      case resetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: AppColors.error,
            ),
            body: Container(
              color: AppColors.background,
              child: Center(
                child: Text(
                  'Error: Unknown route " ${settings.name}"',
                  style: TextStyle(color: AppColors.onSurface, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
    }
  }
}
