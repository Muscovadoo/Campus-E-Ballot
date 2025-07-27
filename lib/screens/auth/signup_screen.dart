import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'dart:async';
import 'dart:math';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _gsuiteController = TextEditingController();
  final TextEditingController _srCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _fieldsLocked = false;
  bool _otpSent = false;
  String? _generatedOtp;
  int _otpTimer = 0;
  Timer? _timer;
  Map<String, String?> _fieldErrors = {};

  @override
  void dispose() {
    _fullNameController.dispose();
    _gsuiteController.dispose();
    _srCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _clearFields() {
    _fullNameController.clear();
    _gsuiteController.clear();
    _srCodeController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _otpController.clear();
    setState(() {
      _fieldsLocked = false;
      _otpSent = false;
      _generatedOtp = null;
      _otpTimer = 0;
      _fieldErrors.clear();
    });
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

  bool _validateFields({bool showErrors = true}) {
    Map<String, String?> errors = {};
    bool valid = true;
    if (_fullNameController.text.trim().isEmpty) {
      errors['fullname'] = 'Full name is required';
      valid = false;
    }
    if (!_gsuiteController.text.trim().endsWith('@g.batstate-u.edu.ph')) {
      errors['gsuite'] = 'Enter a valid Gsuite (@g.batstate-u.edu.ph)';
      valid = false;
    }
    if (_srCodeController.text.trim().isEmpty) {
      errors['srcode'] = 'SR-Code is required';
      valid = false;
    }
    if (_passwordController.text.isEmpty) {
      errors['password'] = 'Password is required';
      valid = false;
    } else if (_passwordController.text.length < 8) {
      errors['password'] = 'Password must be at least 8 characters';
      valid = false;
    }
    if (_confirmPasswordController.text.isEmpty) {
      errors['confirmpassword'] = 'Confirm password is required';
      valid = false;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      errors['confirmpassword'] = 'Passwords do not match';
      valid = false;
    }
    if (showErrors) {
      setState(() {
        _fieldErrors = errors;
      });
    }
    return valid;
  }

  void _sendOtp() {
    if (!_validateFields()) {
      // Show error hints and red borders
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Your OTP is: $otp',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _register() {
    bool valid = _validateFields(showErrors: false);
    if (!_otpSent || _otpController.text.trim() != _generatedOtp) {
      setState(() {
        _fieldErrors['otp'] = 'Invalid OTP';
      });
      return;
    }
    if (!valid) {
      setState(() {
        _fieldErrors['otp'] = null;
      });
      return;
    }
    // Save user to session (tempUserStore only)
    final user = {
      'gsuite': _gsuiteController.text.trim(),
      'password': _passwordController.text.trim(),
      'fullName': _fullNameController.text.trim(),
      'srCode': _srCodeController.text.trim(),
    };
    registerUser(user);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registration successful! Please login.'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
    });
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
    final cardWidth = screenWidth < 400 ? screenWidth * 0.95 : 370.0;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Create Account',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _fullNameController,
                          enabled: !_fieldsLocked,
                          decoration: _inputDecoration(
                            'Fullname (Ex. Juan A. Dela Cruz)',
                            'fullname',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _gsuiteController,
                          enabled: !_fieldsLocked,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            'Gsuite Email (@g.batstate-u.edu.ph)',
                            'gsuite',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _srCodeController,
                          enabled: !_fieldsLocked,
                          decoration: _inputDecoration(
                            'SR-Code (Ex. 22-12345)',
                            'srcode',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !_fieldsLocked,
                          obscureText: _obscurePassword,
                          decoration: _inputDecoration('Password', 'password')
                              .copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: _fieldErrors['password'] != null
                                        ? AppColors.error
                                        : Colors.black,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _confirmPasswordController,
                          enabled: !_fieldsLocked,
                          obscureText: _obscureConfirmPassword,
                          decoration:
                              _inputDecoration(
                                'Confirm Password',
                                'confirmpassword',
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        _fieldErrors['confirmpassword'] != null
                                        ? AppColors.error
                                        : Colors.black,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirmPassword =
                                        !_obscureConfirmPassword,
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 14),
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
                                onPressed: _otpTimer == 0 ? _sendOtp : null,
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
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'Register',
                          onPressed: _register,
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
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Have an Account? ',
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        _clearFields();
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRouter.loginRoute);
                      },
                      child: const Text(
                        'Login here',
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
