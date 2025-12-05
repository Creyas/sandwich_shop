# Prompt: Create Sign In/Sign Up Authentication Screens for Sandwich Shop App

Create a complete authentication system for the Sandwich Shop Flutter app with the following requirements:

## Files to Create

1. `lib/views/auth_screen.dart` - Main authentication screen with sign in and sign up tabs
2. `lib/models/user.dart` - User model to store user information
3. `lib/services/auth_service.dart` - Authentication service for handling sign in/sign up logic
4. `test/views/auth_screen_test.dart` - Comprehensive tests for the auth screen

## Design Requirements

### Visual Design

- Use the existing app styles from `app_styles.dart` (heading1, heading2, normalText)
- Include the sandwich shop logo at the top (use `assets/images/logo.png`)
- Use a TabBar with two tabs: "Sign In" and "Sign Up"
- Maintain consistency with the existing app's color scheme (orange accent colors)
- Make it visually appealing with proper spacing and padding

### Sign In Tab Features

- Email input field with email validation
- Password input field with visibility toggle
- "Remember Me" checkbox
- "Sign In" button (disabled until valid input)
- "Forgot Password?" text button
- Error message display for invalid credentials
- Loading indicator during authentication

### Sign Up Tab Features

- Full name input field
- Email input field with email validation
- Password input field with:
  - Visibility toggle
  - Minimum 8 characters requirement
  - Must contain at least one uppercase letter, one number
- Confirm password field (must match password)
- Phone number input field (optional)
- "Sign Up" button (disabled until all validations pass)
- Terms and conditions checkbox with clickable link
- Error message display
- Loading indicator during registration

## Functionality Requirements

- Form validation with real-time feedback
- Show/hide password functionality
- Proper keyboard handling (dismiss on tap outside)
- Navigation to OrderScreen after successful authentication
- Store user session (use shared_preferences or similar)
- Handle authentication errors gracefully
- Display success/error SnackBars

## User Model (`lib/models/user.dart`)

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;
  
  // Include necessary methods: toJson, fromJson, copyWith
}