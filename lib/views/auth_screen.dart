import 'package:flutter/material.dart';
import 'package:sandwich_shop/services/auth_service.dart';
import 'package:sandwich_shop/widgets/custom_button.dart';
import 'package:sandwich_shop/widgets/custom_text_field.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/order_screen.dart';

/// Authentication screen with Sign In and Sign Up tabs.
///
/// Provides user authentication functionality including:
/// - Sign in for existing users
/// - Sign up for new users
/// - Password reset flow
/// - Session management
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();

  // Sign In controllers
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController =
      TextEditingController();

  // Sign In state
  bool _rememberMe = false;
  bool _isSignInLoading = false;
  String? _signInEmailError;
  String? _signInPasswordError;

  // Sign Up controllers
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpConfirmPasswordController =
      TextEditingController();
  final TextEditingController _signUpPhoneController = TextEditingController();

  // Sign Up state
  bool _acceptedTerms = false;
  bool _isSignUpLoading = false;
  String? _signUpNameError;
  String? _signUpEmailError;
  String? _signUpPasswordError;
  String? _signUpConfirmPasswordError;
  String? _signUpPhoneError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Add listeners for real-time validation
    _signInEmailController.addListener(_validateSignInEmail);
    _signInPasswordController.addListener(_validateSignInPassword);

    _signUpNameController.addListener(_validateSignUpName);
    _signUpEmailController.addListener(_validateSignUpEmail);
    _signUpPasswordController.addListener(_validateSignUpPassword);
    _signUpConfirmPasswordController
        .addListener(_validateSignUpConfirmPassword);
    _signUpPhoneController.addListener(_validateSignUpPhone);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    _signUpPhoneController.dispose();
    super.dispose();
  }

  // Validation methods for Sign In
  void _validateSignInEmail() {
    setState(() {
      if (_signInEmailController.text.isEmpty) {
        _signInEmailError = null;
      } else if (!_authService.isEmailValid(_signInEmailController.text)) {
        _signInEmailError = 'Please enter a valid email address';
      } else {
        _signInEmailError = null;
      }
    });
  }

  void _validateSignInPassword() {
    setState(() {
      if (_signInPasswordController.text.isEmpty) {
        _signInPasswordError = null;
      } else {
        _signInPasswordError = null;
      }
    });
  }

  bool get _isSignInFormValid {
    return _signInEmailController.text.isNotEmpty &&
        _signInPasswordController.text.isNotEmpty &&
        _signInEmailError == null &&
        _authService.isEmailValid(_signInEmailController.text);
  }

  Future<void> _handleSignIn() async {
    if (!_isSignInFormValid) return;

    setState(() {
      _isSignInLoading = true;
    });

    try {
      final user = await _authService.signIn(
        _signInEmailController.text.trim(),
        _signInPasswordController.text,
      );

      if (!mounted) return;

      if (user != null) {
        // Success - navigate to OrderScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OrderScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${user.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Failed - show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSignInLoading = false;
        });
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _signInEmailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_authService.isEmailValid(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final success = await _authService.resetPassword(email);

    if (!mounted) return;

    Navigator.of(context).pop(); // Close loading dialog

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Reset'),
          content: Text(
            'Password reset instructions have been sent to $email. '
            'Please check your email.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No account found with this email address'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSignUp() async {
    if (!_isSignUpFormValid) return;

    setState(() {
      _isSignUpLoading = true;
    });

    try {
      final user = await _authService.signUp(
        name: _signUpNameController.text.trim(),
        email: _signUpEmailController.text.trim(),
        password: _signUpPasswordController.text,
        phoneNumber: _signUpPhoneController.text.trim().isEmpty
            ? null
            : _signUpPhoneController.text.trim(),
      );

      if (!mounted) return;

      if (user != null) {
        // Success - navigate to OrderScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OrderScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Welcome, ${user.name}! Your account has been created.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Failed - show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account with this email already exists'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSignUpLoading = false;
        });
      }
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terms of Service',
                style: heading2.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                '1. By creating an account, you agree to provide accurate information.\n\n'
                '2. You are responsible for maintaining the confidentiality of your account.\n\n'
                '3. We reserve the right to terminate accounts that violate our policies.\n\n'
                '4. Your personal information will be handled according to our Privacy Policy.\n\n'
                '5. You must be at least 13 years old to create an account.',
                style: normalText,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Validation methods for Sign Up
  void _validateSignUpName() {
    setState(() {
      if (_signUpNameController.text.isEmpty) {
        _signUpNameError = null;
      } else if (_signUpNameController.text.trim().length < 2) {
        _signUpNameError = 'Name must be at least 2 characters';
      } else {
        _signUpNameError = null;
      }
    });
  }

  void _validateSignUpEmail() {
    setState(() {
      if (_signUpEmailController.text.isEmpty) {
        _signUpEmailError = null;
      } else if (!_authService.isEmailValid(_signUpEmailController.text)) {
        _signUpEmailError = 'Please enter a valid email address';
      } else {
        _signUpEmailError = null;
      }
    });
  }

  void _validateSignUpPassword() {
    setState(() {
      if (_signUpPasswordController.text.isEmpty) {
        _signUpPasswordError = null;
      } else if (!_authService
          .isPasswordValid(_signUpPasswordController.text)) {
        _signUpPasswordError =
            'Password must be 8+ chars, 1 uppercase, 1 number';
      } else {
        _signUpPasswordError = null;
      }
      // Also revalidate confirm password when password changes
      _validateSignUpConfirmPassword();
    });
  }

  void _validateSignUpConfirmPassword() {
    setState(() {
      if (_signUpConfirmPasswordController.text.isEmpty) {
        _signUpConfirmPasswordError = null;
      } else if (_signUpConfirmPasswordController.text !=
          _signUpPasswordController.text) {
        _signUpConfirmPasswordError = 'Passwords do not match';
      } else {
        _signUpConfirmPasswordError = null;
      }
    });
  }

  void _validateSignUpPhone() {
    setState(() {
      final phone = _signUpPhoneController.text.trim();
      if (phone.isEmpty) {
        _signUpPhoneError = null;
      } else if (phone.length < 10) {
        _signUpPhoneError = 'Please enter a valid phone number';
      } else {
        _signUpPhoneError = null;
      }
    });
  }

  bool get _isSignUpFormValid {
    return _signUpNameController.text.trim().isNotEmpty &&
        _signUpEmailController.text.isNotEmpty &&
        _signUpPasswordController.text.isNotEmpty &&
        _signUpConfirmPasswordController.text.isNotEmpty &&
        _signUpNameError == null &&
        _signUpEmailError == null &&
        _signUpPasswordError == null &&
        _signUpConfirmPasswordError == null &&
        _signUpPhoneError == null &&
        _authService.isEmailValid(_signUpEmailController.text) &&
        _authService.isPasswordValid(_signUpPasswordController.text) &&
        _signUpPasswordController.text ==
            _signUpConfirmPasswordController.text &&
        _acceptedTerms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Logo section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sandwich Shop',
                    style: heading1.copyWith(color: Colors.orange),
                  ),
                ],
              ),
            ),

            // Tab bar
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                labelStyle: heading2.copyWith(fontSize: 18),
                indicatorColor: Colors.orange,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Sign In'),
                  Tab(text: 'Sign Up'),
                ],
              ),
            ),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSignInTab(),
                  _buildSignUpTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back',
            style: heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to continue ordering',
            style: normalText.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Email field
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _signInEmailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            errorText: _signInEmailError,
            autofocus: true,
          ),
          const SizedBox(height: 16),

          // Password field
          CustomTextField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _signInPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            errorText: _signInPasswordError,
          ),
          const SizedBox(height: 12),

          // Remember me and Forgot password row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  Text('Remember Me', style: normalText),
                ],
              ),
              TextButton(
                onPressed: _handleForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: normalText.copyWith(color: Colors.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sign In button
          CustomButton(
            text: 'Sign In',
            onPressed: _isSignInFormValid ? _handleSignIn : null,
            isLoading: _isSignInLoading,
          ),
          const SizedBox(height: 16),

          // Demo credentials hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demo Account:',
                  style: normalText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Email: demo@example.com',
                  style: normalText.copyWith(color: Colors.blue.shade700),
                ),
                Text(
                  'Password: Demo123',
                  style: normalText.copyWith(color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create Account',
            style: heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign up to start ordering',
            style: normalText.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Full Name field
          CustomTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _signUpNameController,
            keyboardType: TextInputType.name,
            prefixIcon: Icons.person_outline,
            errorText: _signUpNameError,
            autofocus: false,
          ),
          const SizedBox(height: 16),

          // Email field
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _signUpEmailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            errorText: _signUpEmailError,
          ),
          const SizedBox(height: 16),

          // Password field
          CustomTextField(
            label: 'Password',
            hint: 'Create a password',
            controller: _signUpPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            errorText: _signUpPasswordError,
          ),
          const SizedBox(height: 8),

          // Password requirements
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password must contain:',
                  style: normalText.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                _buildPasswordRequirement(
                  'At least 8 characters',
                  _signUpPasswordController.text.length >= 8,
                ),
                _buildPasswordRequirement(
                  'At least one uppercase letter',
                  _signUpPasswordController.text.contains(RegExp(r'[A-Z]')),
                ),
                _buildPasswordRequirement(
                  'At least one number',
                  _signUpPasswordController.text.contains(RegExp(r'[0-9]')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Confirm Password field
          CustomTextField(
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            controller: _signUpConfirmPasswordController,
            isPassword: true,
            prefixIcon: Icons.lock_outline,
            errorText: _signUpConfirmPasswordError,
          ),
          const SizedBox(height: 16),

          // Phone Number field (optional)
          CustomTextField(
            label: 'Phone Number (Optional)',
            hint: 'Enter your phone number',
            controller: _signUpPhoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            errorText: _signUpPhoneError,
          ),
          const SizedBox(height: 20),

          // Terms and Conditions checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acceptedTerms,
                onChanged: (value) {
                  setState(() {
                    _acceptedTerms = value ?? false;
                  });
                },
                activeColor: Colors.orange,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _acceptedTerms = !_acceptedTerms;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: normalText.copyWith(fontSize: 14),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: _showTermsDialog,
                              child: Text(
                                'Terms & Conditions',
                                style: normalText.copyWith(
                                  color: Colors.orange,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sign Up button
          CustomButton(
            text: 'Sign Up',
            onPressed: _isSignUpFormValid ? _handleSignUp : null,
            isLoading: _isSignUpLoading,
          ),
          const SizedBox(height: 16),

          // Switch to Sign In
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: normalText,
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(0);
                },
                child: Text(
                  'Sign In',
                  style: normalText.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: normalText.copyWith(
              fontSize: 13,
              color: isMet ? Colors.green.shade700 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
