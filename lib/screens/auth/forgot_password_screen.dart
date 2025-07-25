// lib/screens/auth/forgot_password_screen.dart (CORRECTED)

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/text_input_field.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart'; // Import for navigation
import 'package:campus_ballot_voting_system/session.dart';
import 'package:flutter/scheduler.dart' show Ticker;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _srCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController =
      TextEditingController(); // Assuming OTP field will be here
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  static String? sessionOtp; // Store OTP for session

  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;
  bool _isLoading = false;
  bool _otpSent = false;
  int _otpTimer = 0;
  late final Ticker _ticker;
  bool _fieldsLocked = false;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (_otpTimer > 0) {
      setState(() {
        _otpTimer--;
      });
    } else {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _srCodeController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _getOtp() async {
    if (_formKey.currentState!.validate()) {
      // G-Suite email validation
      if (!_emailController.text.trim().endsWith('@g.batstate-u.edu.ph')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please use your G-Suite (@g.batstate-u.edu.ph)',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      // Check if SR-Code and GSuite are registered
      final srCode = _srCodeController.text.trim();
      final gsuite = _emailController.text.trim();
      final foundUser = findUserByGsuiteAndSrCode(gsuite, srCode);
      if (foundUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'SR-Code and GSuite do not match any registered user.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      // Generate random 5-digit OTP
      final otp =
          (10000 +
                  (99999 - 10000) *
                      (DateTime.now().millisecondsSinceEpoch % 10000) ~/
                      10000)
              .toString();
      sessionOtp = otp;
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
        _otpSent = true;
        _fieldsLocked = true;
        _otpTimer = 30;
      });
      _ticker.start();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your OTP: $otp',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      // Check OTP
      if (_otpController.text.trim() != sessionOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid OTP. Please check and try again.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      // Check if SR-Code and GSuite match a registered user
      final srCode = _srCodeController.text.trim();
      final gsuite = _emailController.text.trim();
      final updated = updateUserPassword(
        gsuite,
        srCode,
        _newPasswordController.text.trim(),
      );
      if (!updated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'SR-Code and GSuite do not match any registered user.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password reset successfully! You can now log in.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 400 ? screenWidth * 0.90 : 320.0;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          'Forget Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/BatstateU-NEU-Logo.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
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
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forget Password',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextInputField(
                          controller: _srCodeController,
                          hintText: 'SR-Code',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your SR-Code';
                            }
                            return null;
                          },
                          readOnly: _fieldsLocked,
                          enabled: !_fieldsLocked,
                        ),
                        const SizedBox(height: 10),
                        TextInputField(
                          controller: _emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          readOnly: _fieldsLocked,
                          enabled: !_fieldsLocked,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextInputField(
                                controller: _otpController,
                                hintText: 'OTP',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (!_otpSent) {
                                    return null;
                                  }
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the OTP';
                                  }
                                  return null;
                                },
                                readOnly: !_otpSent,
                                enabled: _otpSent,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: (_otpTimer == 0 && !_isLoading)
                                      ? _getOtp
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        (_otpTimer == 0 && !_isLoading)
                                        ? AppColors.accent
                                        : Colors.grey,
                                    foregroundColor: AppColors.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Text(
                                    _otpTimer == 0
                                        ? (_otpSent ? 'Resend OTP' : 'Get OTP')
                                        : 'Resend OTP',
                                  ),
                                ),
                                if (_otpTimer > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      '${_otpTimer}s',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_otpSent) ...[
                          TextInputField(
                            controller: _newPasswordController,
                            hintText: 'New Password',
                            obscureText: _obscureNewPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color:
                                    _formKey.currentState != null &&
                                        !_formKey.currentState!.validate() &&
                                        _newPasswordController.text.isNotEmpty
                                    ? AppColors.error
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextInputField(
                            controller: _confirmNewPasswordController,
                            hintText: 'Confirm New Password',
                            obscureText: _obscureConfirmNewPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your new password';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color:
                                    _formKey.currentState != null &&
                                        !_formKey.currentState!.validate() &&
                                        _confirmNewPasswordController
                                            .text
                                            .isNotEmpty
                                    ? AppColors.error
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmNewPassword =
                                      !_obscureConfirmNewPassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: _isLoading ? 'Resetting...' : 'Confirm',
                            onPressed: _isLoading ? null : _resetPassword,
                            isLoading: _isLoading,
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            textStyle: AppTextStyles.buttonText.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
