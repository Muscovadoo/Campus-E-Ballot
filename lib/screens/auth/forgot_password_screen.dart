// lib/screens/auth/forgot_password_screen.dart (CORRECTED)

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/text_input_field.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'dart:async';
import 'dart:math';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _srCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  static String? sessionOtp; // Store OTP for session

  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;
  bool _isLoading = false;
  bool _otpSent = false;
  bool _fieldsLocked = false;
  String? _generatedOtp;
  int _otpTimer = 0;
  Timer? _timer;
  Map<String, String?> _fieldErrors = {};

  @override
  void dispose() {
    _srCodeController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startOtpTimer() {
    setState(() => _otpTimer = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpTimer > 0) {
        setState(() => _otpTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  bool _validateOtpFields({bool showErrors = true}) {
    Map<String, String?> errors = {};
    bool valid = true;

    if (_srCodeController.text.trim().isEmpty) {
      errors['srcode'] = 'SR-Code is required';
      valid = false;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      errors['email'] = 'Email is required';
      valid = false;
    } else if (email != 'demo' && !email.endsWith('@g.batstate-u.edu.ph')) {
      errors['email'] = 'Enter a valid Gsuite (@g.batstate-u.edu.ph) or demo';
      valid = false;
    }

    if (showErrors) {
      setState(() {
        _fieldErrors = errors;
      });
    }
    return valid;
  }

  void _getOtp() {
    if (!_validateOtpFields()) {
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

    // Generate random 5-digit OTP
    final otp = (Random().nextInt(90000) + 10000).toString();
    setState(() {
      _generatedOtp = otp;
      _otpSent = true;
      _fieldsLocked = true;
      _otpTimer = 30;
    });
    _startOtpTimer();
    sessionOtp = otp;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Your OTP is: $otp',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 10),
      ),
    );
  }

  bool _validatePasswordFields() {
    Map<String, String?> errors = {};
    bool valid = true;

    if (_newPasswordController.text.isEmpty) {
      errors['newpassword'] = 'Please enter a new password';
      valid = false;
    } else if (_newPasswordController.text.length < 6) {
      errors['newpassword'] = 'Password must be at least 6 characters';
      valid = false;
    }

    if (_confirmNewPasswordController.text.isEmpty) {
      errors['confirmpassword'] = 'Please confirm your new password';
      valid = false;
    } else if (_confirmNewPasswordController.text !=
        _newPasswordController.text) {
      errors['confirmpassword'] = 'Passwords do not match';
      valid = false;
    }

    setState(() {
      _fieldErrors = {..._fieldErrors, ...errors};
    });
    return valid;
  }

  void _resetPassword() async {
    // Check OTP first
    if (_otpController.text.trim() != _generatedOtp) {
      setState(() {
        _fieldErrors['otp'] = 'Invalid OTP';
      });
      return;
    }

    // Validate password fields
    if (!_validatePasswordFields()) {
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

  InputDecoration _inputDecoration(String hint, String fieldKey) {
    return InputDecoration(
      hintText: hint,
      errorText: _fieldErrors[fieldKey],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _fieldErrors[fieldKey] != null ? Colors.red : Colors.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _fieldErrors[fieldKey] != null ? Colors.red : Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _fieldErrors[fieldKey] != null ? Colors.red : AppColors.accent,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
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
                        TextFormField(
                          controller: _srCodeController,
                          enabled: !_fieldsLocked,
                          decoration: _inputDecoration('SR-Code', 'srcode'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          enabled: !_fieldsLocked,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration('Email', 'email'),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _otpController,
                                enabled: _otpSent,
                                maxLength: 5,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(
                                  'OTP',
                                  'otp',
                                ).copyWith(counterText: ''),
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: _otpTimer == 0 ? _getOtp : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
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
                                child: _otpTimer > 0
                                    ? Text('Resend (${_otpTimer}s)')
                                    : Text(_otpSent ? 'Resend OTP' : 'Get OTP'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_otpSent) ...[
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            decoration:
                                _inputDecoration(
                                  'New Password',
                                  'newpassword',
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: _fieldErrors['newpassword'] != null
                                          ? AppColors.error
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureNewPassword =
                                            !_obscureNewPassword;
                                      });
                                    },
                                  ),
                                ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _confirmNewPasswordController,
                            obscureText: _obscureConfirmNewPassword,
                            decoration:
                                _inputDecoration(
                                  'Confirm New Password',
                                  'confirmpassword',
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color:
                                          _fieldErrors['confirmpassword'] !=
                                              null
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
