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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Add listeners for real-time validation
    _signInEmailController.addListener(_validateSignInEmail);
    _signInPasswordController.addListener(_validateSignInPassword);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
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
    // Placeholder for Sign Up tab - will be implemented in next subtask
    return const Center(
      child: Text('Sign Up form coming next...'),
    );
  }
}
