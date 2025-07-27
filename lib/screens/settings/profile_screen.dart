// lib/screens/settings/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';
import 'package:campus_ballot_voting_system/theme/app_text_styles.dart';
import 'package:campus_ballot_voting_system/widgets/custom_button.dart';
import 'package:campus_ballot_voting_system/widgets/text_input_field.dart';
import 'package:campus_ballot_voting_system/session.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearLevelController = TextEditingController();
  final _fNameController = TextEditingController();
  final _mNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _srCodeController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedSex;
  DateTime? _selectedBirthday;
  bool _isProfileSaved = false;
  bool _isEditing = false;
  bool _showPasswordDialog = false;
  bool _showConfirmationDialog = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _userImagePath;
  String? _errorField;
  bool _attemptedSave = false;

  // Department options
  final List<String> _departments = ['CICS', 'CABEIHM', 'CTE', 'CAS', 'CET'];
  // Sex options
  final List<String> _sexOptions = ['Male', 'Female', 'Other'];

  final List<String> _yearLevels = ['1st', '2nd', '3rd', '4th'];
  final Map<String, List<String>> _coursesByDepartment = {
    'CICS': ['BS Information Technology'],
    'CABEIHM': [
      'BS Hospitality Management',
      'BS Tourism Management',
      'BS Business Administration',
      'BS Accounting',
      'BS Public Administration',
    ],
    'CTE': [
      'BS Secondary Education',
      'BS Elementary Education',
      'Bachelor of Physical Education',
    ],
    'CAS': [
      'BS Psychology',
      'BS Criminology',
      'BS Development Communication',
      'BA Communication',
    ],
    'CET': [
      'Bachelor of Automotive Engineering Technology',
      'Bachelor of Industrial Engineering Technology',
      'Bachelor of Computer Engineering Technology',
      'Bachelor of Drafting Engineering Technology',
      'Bachelor of Electrical Engineering Technology',
      'Bachelor of Electronics Engineering Technology',
      'Bachelor of Food Engineering Technology',
      'Bachelor of Mechanical Engineering Technology',
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _courseController.text = sessionUser?['course'] ?? '';
    _yearLevelController.text = sessionUser?['yearLevel'] ?? '';
    _fNameController.text = sessionUser?['FName'] ?? '';
    _mNameController.text = sessionUser?['MName'] ?? '';
    _lNameController.text = sessionUser?['LName'] ?? '';
    _srCodeController.text = sessionUser?['srCode'] ?? '';
  }

  void _loadUserData() {
    if (sessionUser != null) {
      // Load existing data if available
      _ageController.text = sessionUser!['age']?.toString() ?? '';
      _contactNumberController.text =
          sessionUser!['contactNumber']?.toString() ?? '';
      _selectedDepartment = sessionUser!['department']?.toString();
      _selectedSex = sessionUser!['sex']?.toString();
      _selectedBirthday = sessionUser!['birthday'] != null
          ? DateTime.parse(sessionUser!['birthday'].toString())
          : null;
      _fNameController.text = sessionUser?['FName'] ?? '';
      _mNameController.text = sessionUser?['MName'] ?? '';
      _lNameController.text = sessionUser?['LName'] ?? '';
      _isProfileSaved = sessionUser!['profileSaved'] == 'true';
      _userImagePath = sessionUser!['profileImage']?.toString();
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _contactNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _courseController.dispose();
    _yearLevelController.dispose();
    _fNameController.dispose();
    _mNameController.dispose();
    _lNameController.dispose();
    _srCodeController.dispose();
    super.dispose();
  }

  void _startEditing() {
    if (_isProfileSaved) {
      _showPasswordDialog = true;
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _saveProfile() {
    setState(() {
      _attemptedSave = true;
    });
    // Validation logic
    bool hasError = false;
    String? errorMsg;
    if (_fNameController.text.trim().isEmpty) {
      hasError = true;
      errorMsg = 'First Name is required.';
    } else if (_mNameController.text.trim().isEmpty) {
      hasError = true;
      errorMsg = 'Middle Name is required.';
    } else if (!RegExp(r'^[A-Z]$').hasMatch(_mNameController.text.trim())) {
      hasError = true;
      errorMsg = 'Middle name must be a single uppercase letter (A-Z)';
    } else if (_lNameController.text.trim().isEmpty) {
      hasError = true;
      errorMsg = 'Last Name is required.';
    } else if (_ageController.text.trim().isEmpty) {
      hasError = true;
      errorMsg = 'Age is required.';
    } else if (_selectedDepartment == null || _selectedDepartment!.isEmpty) {
      hasError = true;
      errorMsg = 'Department is required.';
    } else if (_selectedSex == null || _selectedSex!.isEmpty) {
      hasError = true;
      errorMsg = 'Sex is required.';
    } else if (_selectedBirthday == null) {
      hasError = true;
      errorMsg = 'Birthday is required.';
    } else if (_contactNumberController.text.trim().isEmpty) {
      hasError = true;
      errorMsg = 'Contact Number is required.';
    } else if (_contactNumberController.text.trim().length != 11 ||
        !_contactNumberController.text.trim().startsWith('09')) {
      hasError = true;
      errorMsg = 'Mobile number must be 11 digits and start with 09.';
    } else if (_courseController.text.trim().isEmpty) {
      hasError = true;
      errorMsg = 'Course is required.';
    } else if (_yearLevelController.text.trim().isEmpty) {
      hasError = true;
      errorMsg = 'Year Level is required.';
    }
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? 'Please fill all required fields.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() {
      _showConfirmationDialog = true;
      _errorField = null;
    });
  }

  void _confirmAndSaveProfile() {
    try {
      if (_confirmPasswordController.text == sessionUser!['password']) {
        // Update session data
        if (sessionUser != null) {
          final updatedFields = {
            'age': _ageController.text,
            'contactNumber': _contactNumberController.text,
            'department': _selectedDepartment ?? '',
            'sex': _selectedSex ?? '',
            'birthday': _selectedBirthday?.toIso8601String() ?? '',
            'profileSaved': 'true',
            'profileImage': _userImagePath ?? '',
            'course': _courseController.text,
            'yearLevel': _yearLevelController.text,
            'FName': _fNameController.text,
            'MName': _mNameController.text,
            'LName': _lNameController.text,
            'srCode': _srCodeController.text,
          };
          updateCurrentUserProfile(updatedFields);
        }
        // Close the dialog first
        Navigator.of(context).pop();
        setState(() {
          _isProfileSaved = true;
          _isEditing = false;
          _showConfirmationDialog = false;
        });
        _confirmPasswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile saved successfully! You can now vote.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
        // Navigate to ballot screen and refresh
        Future.delayed(const Duration(milliseconds: 800), () {
          Navigator.pushReplacementNamed(context, '/student-dashboard');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Incorrect password. Please try again.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving profile. Please try again.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _cancelEditing() {
    _loadUserData(); // This should reset all controllers to sessionUser values
    setState(() {
      _isEditing = false;
      _attemptedSave = false; // Only reset here!
    });
  }

  Future<void> _selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedBirthday ??
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime.now().subtract(
        const Duration(days: 36500),
      ), // 100 years ago
      lastDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  void _selectImage() async {
    // In a real app, this would open image picker
    // For now, we'll just simulate selecting an image
    setState(() {
      _userImagePath = 'assets/images/profile_placeholder.png';
    });
  }

  void _verifyPassword() {
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your password',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Verify against session password
    if (_passwordController.text == sessionUser!['password']) {
      // Close the dialog first
      Navigator.of(context).pop();

      setState(() {
        _showPasswordDialog = false;
        _isEditing = true;
        _passwordController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Incorrect password. Please try again.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _generateIdCard() {
    final user = sessionUser ?? {};
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: Center(
          child: SingleChildScrollView(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 340,
                    height: 560,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFFF3131), Color(0xFFFF914D)],
                      ),
                      border: Border.all(color: Colors.black, width: 2.5),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            border: Border(
                              top: BorderSide(color: Colors.black, width: 2.5),
                              left: BorderSide(color: Colors.black, width: 2.5),
                              right: BorderSide(
                                color: Colors.black,
                                width: 2.5,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/BatstateU-NEU-Logo.png',
                                height: 55,
                                width: 55,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'BATANGAS STATE UNIVERSITY\nTNEU - JPLPC MALVAR CAMPUS\nSUPREME STUDENT COUNCIL',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                'assets/images/SSC-JPLPCMalvar-Logo.png',
                                height: 55,
                                width: 55,
                              ),
                            ],
                          ),
                        ),
                        // Middle section
                        const SizedBox(height: 18),
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 90,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Last name
                        Text(
                          (() {
                            final lName = user['LName'] ?? '';
                            return lName.length > 15
                                ? lName.substring(0, 15)
                                : lName;
                          })(),
                          style:
                              AppTextStyles.headlineLarge?.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.4,
                                fontFamily: 'Etna',
                              ) ??
                              const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.4,
                                fontFamily: 'Etna',
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Full name (First Name + Middle Initial.)
                        Text(
                          (() {
                            final fName = user['FName'] ?? '';
                            final mName = user['MName'] ?? '';
                            String middleInitial = '';
                            if (mName.trim().isNotEmpty) {
                              middleInitial = ' ${mName.trim()[0]}.';
                            }
                            return '$fName$middleInitial';
                          })(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Etna', // Use the Etna font from assets
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Separator line
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          height: 1.5,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 12),
                        // Course and Department
                        Column(
                          children: [
                            Text(
                              user['course'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              user['department'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Barcode image, left-aligned, smaller height
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    right: 0,
                                  ),
                                  color: Colors.transparent,
                                  width: 150,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/images/Qr-Preview.png',
                                    fit: BoxFit.fill,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                // SR-Code, right-aligned, white background, no border radius
                                Expanded(
                                  child: Container(
                                    height: 38,
                                    width: 150,
                                    margin: const EdgeInsets.only(
                                      left: 0,
                                      right: 0,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.zero,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      'SR-Code: ${user['srCode'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Disclaimer bar
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Only Intended For Campus E-Ballot Use.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: 240,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Copy sent to your GSuite email',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onPrimary,
                              ),
                            ),
                            backgroundColor: AppColors.success,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      child: const Text('Print a Copy'),
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

  @override
  Widget build(BuildContext context) {
    final user = sessionUser ?? {};
    // Show password dialog if needed
    if (_showPasswordDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PasswordDialog(
            passwordController: _passwordController,
            onVerify: _verifyPassword,
            obscurePassword: _obscurePassword,
            onTogglePassword: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        );
      });
    }

    // Show confirmation dialog if needed
    if (_showConfirmationDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ConfirmationDialog(
            confirmPasswordController: _confirmPasswordController,
            onConfirm: _confirmAndSaveProfile,
            onCancel: () {
              setState(() {
                _showConfirmationDialog = false;
              });
            },
            obscurePassword: _obscureConfirmPassword,
            onTogglePassword: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.blueGrey[100],
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['fullName'] ?? 'No Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                user['gsuite'] ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'SR Code: ${user['srCode'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.success,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!_isEditing && !_isProfileSaved)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: _startEditing,
                            tooltip: 'Edit Profile',
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Age
                        TextFormField(
                          controller: _ageController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          style: const TextStyle(fontSize: 11),
                          decoration: InputDecoration(
                            labelText: 'Age',
                            labelStyle: const TextStyle(fontSize: 11),
                            errorText:
                                _attemptedSave &&
                                    _ageController.text.trim().isEmpty
                                ? 'Age is required.'
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _ageController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _ageController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _ageController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Department Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedDepartment,
                          items: _departments
                              .map(
                                (dept) => DropdownMenuItem(
                                  value: dept,
                                  child: Text(
                                    dept,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _isEditing
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _isEditing
                              ? (val) {
                                  setState(() {
                                    _selectedDepartment = val;
                                    // Reset course if department changes
                                    _courseController.text = '';
                                  });
                                }
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Department',
                            labelStyle: TextStyle(
                              fontSize: 11,
                              color: _isEditing ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            errorText:
                                _attemptedSave &&
                                    (_selectedDepartment == null ||
                                        _selectedDepartment!.isEmpty)
                                ? 'Department is required.'
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_selectedDepartment == null ||
                                            _selectedDepartment!.isEmpty)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_selectedDepartment == null ||
                                            _selectedDepartment!.isEmpty)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_selectedDepartment == null ||
                                            _selectedDepartment!.isEmpty)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Sex Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedSex,
                          items: _sexOptions
                              .map(
                                (sex) => DropdownMenuItem(
                                  value: sex,
                                  child: Text(
                                    sex,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _isEditing
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _isEditing
                              ? (val) {
                                  setState(() {
                                    _selectedSex = val;
                                  });
                                }
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Sex',
                            labelStyle: TextStyle(
                              fontSize: 11,
                              color: _isEditing ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            errorText:
                                _attemptedSave &&
                                    (_selectedSex == null ||
                                        _selectedSex!.isEmpty)
                                ? 'Sex is required.'
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_selectedSex == null ||
                                            _selectedSex!.isEmpty)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_selectedSex == null ||
                                            _selectedSex!.isEmpty)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_selectedSex == null ||
                                            _selectedSex!.isEmpty)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Birthday Date Picker
                        GestureDetector(
                          onTap: _isEditing
                              ? () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedBirthday ??
                                        DateTime(2000, 1, 1),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedBirthday = picked;
                                    });
                                  }
                                }
                              : null,
                          child: AbsorbPointer(
                            child: TextFormField(
                              enabled: _isEditing,
                              style: const TextStyle(fontSize: 11),
                              controller: TextEditingController(
                                text: _selectedBirthday != null
                                    ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                                    : '',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Birthday',
                                labelStyle: const TextStyle(fontSize: 11),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                ),
                                errorText:
                                    _attemptedSave && _selectedBirthday == null
                                    ? 'Birthday is required.'
                                    : null,
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        _attemptedSave &&
                                            _selectedBirthday == null
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        _attemptedSave &&
                                            _selectedBirthday == null
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        _attemptedSave &&
                                            _selectedBirthday == null
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Contact Number
                        TextFormField(
                          controller: _contactNumberController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          style: const TextStyle(fontSize: 11),
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            labelStyle: const TextStyle(fontSize: 11),
                            hintText: 'e.g. 09123456789',
                            errorText:
                                _attemptedSave &&
                                    (_contactNumberController.text
                                            .trim()
                                            .isEmpty ||
                                        _contactNumberController.text
                                                .trim()
                                                .length !=
                                            11 ||
                                        !_contactNumberController.text
                                            .trim()
                                            .startsWith('09'))
                                ? 'Mobile number must be 11 digits and start with 09.'
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_contactNumberController.text
                                                .trim()
                                                .isEmpty ||
                                            _contactNumberController.text
                                                    .trim()
                                                    .length !=
                                                11 ||
                                            !_contactNumberController.text
                                                .trim()
                                                .startsWith('09'))
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_contactNumberController.text
                                                .trim()
                                                .isEmpty ||
                                            _contactNumberController.text
                                                    .trim()
                                                    .length !=
                                                11 ||
                                            !_contactNumberController.text
                                                .trim()
                                                .startsWith('09'))
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        (_contactNumberController.text
                                                .trim()
                                                .isEmpty ||
                                            _contactNumberController.text
                                                    .trim()
                                                    .length !=
                                                11 ||
                                            !_contactNumberController.text
                                                .trim()
                                                .startsWith('09'))
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // First Name
                        TextFormField(
                          controller: _fNameController,
                          enabled: _isEditing,
                          style: const TextStyle(fontSize: 11),
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            labelStyle: const TextStyle(fontSize: 11),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _fNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _fNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _fNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Middle Name
                        TextFormField(
                          controller: _mNameController,
                          enabled: _isEditing,
                          style: const TextStyle(fontSize: 11),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Middle Name',
                            labelStyle: const TextStyle(fontSize: 11),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _mNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _mNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _mNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Last Name
                        TextFormField(
                          controller: _lNameController,
                          enabled: _isEditing,
                          style: const TextStyle(fontSize: 11),
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: const TextStyle(fontSize: 11),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _lNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _lNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _lNameController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ), // SR Code (not editable)
                        TextFormField(
                          controller: _srCodeController,
                          enabled: false,
                          style: const TextStyle(fontSize: 11),
                          decoration: InputDecoration(
                            labelText: 'SR Code',
                            labelStyle: const TextStyle(fontSize: 11),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Course Dropdown
                        DropdownButtonFormField<String>(
                          value: _courseController.text.isNotEmpty
                              ? _courseController.text
                              : null,
                          items:
                              (_selectedDepartment != null &&
                                  _coursesByDepartment[_selectedDepartment!] !=
                                      null)
                              ? _coursesByDepartment[_selectedDepartment!]!
                                    .map(
                                      (course) => DropdownMenuItem(
                                        value: course,
                                        child: Text(
                                          course,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _isEditing
                                                ? Colors.black
                                                : Colors.grey,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()
                              : [],
                          onChanged: _isEditing
                              ? (val) {
                                  setState(() {
                                    _courseController.text = val ?? '';
                                  });
                                }
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Course',
                            labelStyle: TextStyle(
                              fontSize: 11,
                              color: _isEditing ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            errorText:
                                _attemptedSave &&
                                    _courseController.text.trim().isEmpty
                                ? 'Course is required.'
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _courseController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _courseController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _courseController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Year Level Dropdown
                        DropdownButtonFormField<String>(
                          value: _yearLevelController.text.isNotEmpty
                              ? _yearLevelController.text
                              : null,
                          items: _yearLevels
                              .map(
                                (year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(
                                    year,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _isEditing
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: _isEditing
                              ? (val) {
                                  setState(() {
                                    _yearLevelController.text = val ?? '';
                                  });
                                }
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Year Level',
                            labelStyle: TextStyle(
                              fontSize: 11,
                              color: _isEditing ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 7,
                            ),
                            errorText:
                                _attemptedSave &&
                                    _yearLevelController.text.trim().isEmpty
                                ? 'Year Level is required.'
                                : null,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _yearLevelController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _yearLevelController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    _attemptedSave &&
                                        _yearLevelController.text.trim().isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  if (_isEditing) ...[
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Cancel',
                            onPressed: _cancelEditing,
                            backgroundColor: Colors.grey[300],
                            foregroundColor: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Save Profile',
                            onPressed: _saveProfile,
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (!_isEditing && _isProfileSaved) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generateIdCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        icon: const Icon(Icons.badge, color: Colors.white),
                        label: const Text('Generate ID Card'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Password Dialog Widget
class PasswordDialog extends StatelessWidget {
  final TextEditingController passwordController;
  final VoidCallback onVerify;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const PasswordDialog({
    super.key,
    required this.passwordController,
    required this.onVerify,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Verify Identity',
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'To edit your profile information, please enter your password:',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.hintText),
          ),
          const SizedBox(height: 20),
          TextInputField(
            controller: passwordController,
            hintText: 'Enter Password',
            obscureText: obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.iconColor,
              ),
              onPressed: onTogglePassword,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonText.copyWith(color: AppColors.primary),
          ),
        ),
        ElevatedButton(
          onPressed: onVerify,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
          ),
          child: Text(
            'Verify',
            style: AppTextStyles.buttonText.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// Confirmation Dialog Widget
class ConfirmationDialog extends StatelessWidget {
  final TextEditingController confirmPasswordController;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool passwordError;
  final String? passwordErrorText;

  const ConfirmationDialog({
    super.key,
    required this.confirmPasswordController,
    required this.onConfirm,
    required this.onCancel,
    required this.obscurePassword,
    required this.onTogglePassword,
    this.passwordError = false,
    this.passwordErrorText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirm Profile Save',
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.success, // green
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Please enter your password to confirm saving your profile information. This action can only be done once.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.hintText),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: confirmPasswordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              hintText: 'Enter Password',
              errorText: passwordError ? passwordErrorText : null,
              errorStyle: const TextStyle(color: Colors.red),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: passwordError ? Colors.red : AppColors.success,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: passwordError ? Colors.red : AppColors.success,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: passwordError ? Colors.red : AppColors.success,
                  width: 2,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.iconColor,
                ),
                onPressed: onTogglePassword,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Optionally, you can call onCancel() if you want to set _isEditing = true in parent
          },
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonText.copyWith(color: AppColors.success),
          ),
          style: TextButton.styleFrom(foregroundColor: AppColors.success),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
          ),
          child: Text(
            'Confirm Save',
            style: AppTextStyles.buttonText.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class IdCardWidget extends StatelessWidget {
  final Map<String, dynamic> user;
  const IdCardWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 560,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF3131), Color(0xFFFF914D)],
        ),
        border: Border.all(color: Colors.black, width: 2.5),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2.5),
                left: BorderSide(color: Colors.black, width: 2.5),
                right: BorderSide(color: Colors.black, width: 2.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/BatstateU-NEU-Logo.png',
                  height: 55,
                  width: 55,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'BATANGAS STATE UNIVERSITY\nTNEU - JPLPC MALVAR CAMPUS\nSUPREME STUDENT COUNCIL',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 55,
                  width: 55,
                ),
              ],
            ),
          ),
          // Middle section
          const SizedBox(height: 18),
          CircleAvatar(
            radius: 52,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 90, color: Colors.black),
          ),
          const SizedBox(height: 18),
          // Last name
          Text(
            (() {
              final lName = user['LName'] ?? '';
              return lName.length > 15 ? lName.substring(0, 15) : lName;
            })(),
            style:
                AppTextStyles.headlineLarge?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.4,
                  fontFamily: 'Etna',
                ) ??
                const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.4,
                  fontFamily: 'Etna',
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // First Name + Middle Initial.
          Text(
            (() {
              final fName = user['FName'] ?? '';
              final mName = user['MName'] ?? '';
              String middleInitial = '';
              if (mName.trim().isNotEmpty) {
                middleInitial = ' ${mName.trim()[0]}.';
              }
              return '$fName$middleInitial';
            })(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Etna',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Separator line
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 1.5,
            color: Colors.black,
          ),
          const SizedBox(height: 12),
          // Course and Department
          Column(
            children: [
              Text(
                user['course'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                user['department'] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Barcode image, left-aligned, smaller height
                  Container(
                    margin: const EdgeInsets.only(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      right: 0,
                    ),
                    color: Colors.transparent,
                    width: 150,
                    height: 40,
                    child: Image.asset(
                      'assets/images/Qr-Preview.png',
                      fit: BoxFit.fill,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  // SR-Code, right-aligned, white background, no border radius
                  Expanded(
                    child: Container(
                      height: 40,
                      width: 150,
                      margin: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 8,
                        bottom: 8,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Text(
                        'SR-Code: ${user['srCode'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Disclaimer bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              'Only Intended For Campus E-Ballot Use.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
