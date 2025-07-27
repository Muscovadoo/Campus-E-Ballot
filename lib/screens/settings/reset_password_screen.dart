import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'package:campus_ballot_voting_system/config/app_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _srCodeController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  String? _generatedOtp;
  bool _otpSent = false;
  bool _otpValidated = false;
  String? _error;
  String? _errorField;
  int _otpTimer = 0;
  Timer? _timer;

  Map<String, dynamic>? _findUser() {
    // Only allow reset for currently logged-in user
    if (sessionUser == null) {
      return null;
    }

    final email = _emailController.text.trim();
    final srCode = _srCodeController.text.trim();
    final oldPassword = _oldPasswordController.text;

    // Check if the entered credentials match the current session user
    if (sessionUser!['gsuite'] == email &&
        sessionUser!['srCode'] == srCode &&
        sessionUser!['password'] == oldPassword) {
      return sessionUser;
    }
    return null;
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

  void _handleOtpButton() {
    setState(() {
      _error = null;
      _errorField = null;
    });

    // If OTP has not been sent or timer expired, validate fields and send OTP
    if (!_otpSent || _otpTimer == 0) {
      if (_emailController.text.isEmpty) {
        setState(() {
          _error = 'Email is required.';
          _errorField = 'email';
        });
        return;
      }
      if (_srCodeController.text.isEmpty) {
        setState(() {
          _error = 'SR-Code is required.';
          _errorField = 'srCode';
        });
        return;
      }
      if (_oldPasswordController.text.isEmpty) {
        setState(() {
          _error = 'Old password is required.';
          _errorField = 'oldPassword';
        });
        return;
      }
      if (_findUser() == null) {
        setState(() {
          _error = 'Credentials do not match to your account.';
          _errorField = 'oldPassword';
        });
        return;
      }
      _generatedOtp = (100000 + (Random().nextInt(900000))).toString();
      _otpSent = true;
      _otpValidated = false;
      _startOtpTimer();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OTP sent: $_generatedOtp')));
      return;
    }

    // If OTP has been sent, validate OTP
    if (_otpController.text == _generatedOtp) {
      setState(() {
        _otpValidated = true;
        _otpSent = false;
        _error = null;
        _errorField = null;
      });
    } else {
      setState(() {
        _error = 'Invalid OTP';
        _errorField = 'otp';
      });
    }
  }

  void _resetPassword() {
    setState(() {
      _error = null;
      _errorField = null;
    });
    if (_newPasswordController.text.length < 8) {
      setState(() {
        _error = 'Password must be at least 8 characters';
        _errorField = 'newPassword';
      });
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _error = 'Passwords do not match';
        _errorField = 'confirmPassword';
      });
      return;
    }
    final email = _emailController.text.trim();
    final srCode = _srCodeController.text.trim();
    final updated = updateUserPassword(
      email,
      srCode,
      _newPasswordController.text,
    );
    if (!updated) {
      setState(() {
        _error = 'Failed to update password.';
        _errorField = 'newPassword';
      });
      return;
    }
    if (sessionUser != null &&
        sessionUser!['gsuite'] == email &&
        sessionUser!['srCode'] == srCode) {
      sessionUser!['password'] = _newPasswordController.text;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password reset successful!')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _srCodeController.dispose();
    _oldPasswordController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, String field) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: (_errorField == field) ? Colors.red : Colors.transparent,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: (_errorField == field) ? Colors.red : Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Your Password',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Image.asset('assets/images/BatstateU-NEU-Logo.png', height: 32),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA07A), Color(0xFFFF6347)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Reset Your Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        enabled: !_otpValidated,
                        decoration: _inputDecoration('Email', 'email'),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _srCodeController,
                        enabled: !_otpValidated,
                        decoration: _inputDecoration('SR-Code', 'srCode'),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _oldPasswordController,
                        enabled: !_otpValidated,
                        obscureText: !_showOldPassword,
                        decoration:
                            _inputDecoration(
                              'Old Password',
                              'oldPassword',
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showOldPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () => setState(
                                  () => _showOldPassword = !_showOldPassword,
                                ),
                              ),
                            ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      if (!_otpValidated)
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _otpController,
                                enabled: _otpSent,
                                decoration: _inputDecoration(
                                  'Enter OTP',
                                  'otp',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _handleOtpButton,
                              child: Text(
                                (!_otpSent || _otpTimer == 0)
                                    ? 'Send OTP'
                                    : (_otpTimer > 0
                                          ? 'Validate OTP'
                                          : 'Send OTP'),
                              ),
                            ),
                            if (_otpSent && _otpTimer > 0)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '$_otpTimer s',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      if (_otpValidated) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: _newPasswordController,
                          obscureText: !_showNewPassword,
                          decoration:
                              _inputDecoration(
                                'New Password',
                                'newPassword',
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showNewPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => _showNewPassword = !_showNewPassword,
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_showConfirmPassword,
                          decoration:
                              _inputDecoration(
                                'Confirm New Password',
                                'confirmPassword',
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showConfirmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => _showConfirmPassword =
                                        !_showConfirmPassword,
                                  ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _resetPassword,
                          child: const Text('Confirm'),
                        ),
                      ],
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRouter.forgotPasswordRoute);
                            },
                            child: const Text(
                              'Forgot Password',
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
            ],
          ),
        ),
      ),
    );
  }
}
