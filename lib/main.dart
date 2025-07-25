import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart'; // Import your app_router.dart
import 'package:campus_ballot_voting_system/theme/app_theme.dart'; // Import your app_theme.dart
import 'package:campus_ballot_voting_system/theme/app_colors.dart';

void main() {
  // This function is the entry point of your Flutter application.
  // It ensures that Flutter's widget binding is initialized,
  // then calls runApp() to start the app with the MyApp widget.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the root widget for a Material Design app.
    // It provides essential functionalities like navigation, theming, and title.
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: MaterialApp(
        // Set the title of the application. This appears in the task switcher on Android
        // and as the window title on desktop.
        title: 'Campus E-Ballot',

        // Disable the debug banner that appears in debug mode.
        debugShowCheckedModeBanner: false,

        // Apply the custom theme defined in app_theme.dart.
        // This ensures a consistent look and feel across the application.
        theme: AppTheme.lightTheme,

        // Define the initial route (the first screen shown when the app starts).
        // We'll typically point this to our SplashScreen.
        initialRoute: AppRouter.splashRoute,

        // A function that handles route generation for named routes.
        // This is crucial for managing navigation across different screens.
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
