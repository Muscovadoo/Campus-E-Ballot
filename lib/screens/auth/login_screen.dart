// lib/screens/auth/login_screen.dart (CORRECTED)

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/text_input_field.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart'; // Import for navigation
import 'package:campus_ballot_voting_system/session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
      final username = _usernameController.text.trim();
      final password = _passwordController.text;
      // Use loginUser from session.dart
      if (loginUser(username, password)) {
        if (mounted) {
          Navigator.of(
            context,
          ).pushReplacementNamed(AppRouter.studentDashboardRoute);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid username or password',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 400 ? screenWidth * 0.90 : 320.0;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient, // Apply the gradient background
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logos Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/BatstateU-NEU-Logo.png',
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 20),
                    Image.asset(
                      'assets/images/SSC-JPLPCMalvar-Logo.png',
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey, // Assign the form key
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login your account',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Username (GSuite) Input
                        TextInputField(
                          controller: _usernameController,
                          hintText: 'Username (Gsuite Email)',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your GSuite email';
                            }
                            if (!value.trim().endsWith(
                                  '@g.batstate-u.edu.ph',
                                ) &&
                                value.trim() != 'test@example.com' &&
                                value.trim() != 'demo') {
                              return 'Enter a valid GSuite email ([SR-CODE]@g.batstate-u.edu.ph)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        // Password Input
                        TextInputField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.iconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Login Button
                        CustomButton(
                          text: _isLoading ? 'Logging In...' : 'Login',
                          onPressed: _isLoading ? null : _login,
                          isLoading: _isLoading,
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          textStyle: AppTextStyles.buttonText.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        const SizedBox(height: 8),
                        // Forgot Password Hyperlink
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRouter.forgotPasswordRoute);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // No Account Yet? Signup here!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No Account Yet? ',
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRouter.signupRoute);
                      },
                      child: const Text(
                        'Sign Up here',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
