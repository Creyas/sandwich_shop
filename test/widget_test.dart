import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/auth_screen.dart';
import 'package:sandwich_shop/widgets/custom_button.dart';
import 'package:sandwich_shop/widgets/custom_text_field.dart';

void main() {
  group('AuthScreen Widget Tests', () {
    testWidgets('AuthScreen renders with Sign In and Sign Up tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Verify logo and app name
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
      expect(find.text('Sandwich Shop'), findsOneWidget);

      // Verify tabs exist
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Sign In tab displays all required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Verify Sign In tab elements
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Remember Me'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.widgetWithText(CustomButton, 'Sign In'), findsOneWidget);
      expect(find.text('Demo Account:'), findsOneWidget);
    });

    testWidgets('Sign Up tab displays all required fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Switch to Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify Sign Up tab elements
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Phone Number (Optional)'), findsOneWidget);
      expect(find.widgetWithText(CustomButton, 'Sign Up'), findsOneWidget);
    });

    testWidgets('Tab switching works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Initially on Sign In tab
      expect(find.text('Welcome Back'), findsOneWidget);

      // Switch to Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.text('Create Account'), findsOneWidget);

      // Switch back to Sign In tab
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('Sign In button is initially disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Find the Sign In button
      final signInButton = find.widgetWithText(CustomButton, 'Sign In');
      expect(signInButton, findsOneWidget);

      // Button should be disabled (onPressed is null)
      final button = tester.widget<CustomButton>(signInButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('Sign Up button is initially disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Switch to Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Find the Sign Up button
      final signUpButton = find.widgetWithText(CustomButton, 'Sign Up');
      expect(signUpButton, findsOneWidget);

      // Button should be disabled
      final button = tester.widget<CustomButton>(signUpButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('Email validation shows error for invalid format',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Find email field and enter invalid email
      final emailFields = find.byType(CustomTextField);
      await tester.enterText(emailFields.first, 'invalidemail');
      await tester.pump();

      // Error should be displayed
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Find password field
      final passwordFields = find.byType(TextField);
      expect(passwordFields, findsWidgets);

      // Find the visibility toggle button
      final visibilityToggle = find.byIcon(Icons.visibility_off);
      expect(visibilityToggle, findsOneWidget);

      // Tap to show password
      await tester.tap(visibilityToggle);
      await tester.pump();

      // Icon should change
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Sign In form accepts valid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Enter valid credentials
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'test@example.com');
      await tester.enterText(textFields.at(1), 'Password123');
      await tester.pump();

      // Button should become enabled
      await tester.pump(const Duration(milliseconds: 100));
      final signInButton = find.widgetWithText(CustomButton, 'Sign In');
      final button = tester.widget<CustomButton>(signInButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Sign Up form validates password requirements',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Switch to Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Enter weak password
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(2), 'weak'); // Password field
      await tester.pump();

      // Error should be displayed
      expect(find.text('Password must be 8+ chars, 1 uppercase, 1 number'),
          findsOneWidget);
    });

    testWidgets('Sign Up password confirmation validates match',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Switch to Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Enter password and non-matching confirmation
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(2), 'Password123');
      await tester.enterText(textFields.at(3), 'Password456');
      await tester.pump();

      // Error should be displayed
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Remember Me checkbox toggles state',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Find and tap Remember Me checkbox
      final checkbox = find.byType(Checkbox).first;
      expect(tester.widget<Checkbox>(checkbox).value, false);

      await tester.tap(checkbox);
      await tester.pump();

      expect(tester.widget<Checkbox>(checkbox).value, true);
    });

    testWidgets('Terms checkbox is required for Sign Up',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Switch to Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Fill all required fields
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'john@example.com');
      await tester.enterText(textFields.at(2), 'Password123');
      await tester.enterText(textFields.at(3), 'Password123');
      await tester.pump();

      // Button should still be disabled without terms acceptance
      final signUpButton = find.widgetWithText(CustomButton, 'Sign Up');
      final button = tester.widget<CustomButton>(signUpButton);
      expect(button.onPressed, isNull);

      // Accept terms
      final termsCheckbox = find.byType(Checkbox).first;
      await tester.tap(termsCheckbox);
      await tester.pump();

      // Button should now be enabled
      await tester.pump(const Duration(milliseconds: 100));
      final updatedButton = tester.widget<CustomButton>(signUpButton);
      expect(updatedButton.onPressed, isNotNull);
    });

    testWidgets('Forgot Password dialog appears on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Enter email first
      final emailField = find.byType(TextField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Tap Forgot Password
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Loading indicator should appear
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Password requirements display updates dynamically',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

      // Switch to Sign Up tab
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify password requirements are displayed
      expect(find.text('Password must contain:'), findsOneWidget);
      expect(find.text('At least 8 characters'), findsOneWidget);
      expect(find.text('At least one uppercase letter'), findsOneWidget);
      expect(find.text('At least one number'), findsOneWidget);

      // Enter password that meets some requirements
      final passwordField = find.byType(TextField).at(2);
      await tester.enterText(passwordField, 'Pass1');
      await tester.pump();

      // Requirements should show partial fulfillment
      expect(find.byIcon(Icons.check_circle), findsWidgets);
      expect(find.byIcon(Icons.circle_outlined), findsWidgets);
    });
  });

  group('CustomTextField Widget Tests', () {
    testWidgets('CustomTextField renders with label and hint',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test Label',
              hint: 'Test Hint',
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
    });

    testWidgets('CustomTextField displays error text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Test',
              hint: 'Hint',
              controller: TextEditingController(),
              errorText: 'Error message',
            ),
          ),
        ),
      );

      expect(find.text('Error message'), findsOneWidget);
    });

    testWidgets('CustomTextField password toggle works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              label: 'Password',
              hint: 'Enter password',
              controller: TextEditingController(),
              isPassword: true,
            ),
          ),
        ),
      );

      // Find visibility toggle
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap to show password
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });

  group('CustomButton Widget Tests', () {
    testWidgets('CustomButton renders with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('CustomButton shows loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('CustomButton is disabled when onPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });
}
