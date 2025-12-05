import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Service class for handling user authentication and session management.
///
/// Provides methods for sign in, sign up, session persistence, and logout.
/// Currently uses a mock implementation with in-memory storage.
/// In production, this would integrate with a backend API.
class AuthService {
  static const String _userSessionKey = 'user_session';

  // Mock database - In production, this would be a backend API
  // Key: email, Value: Map with user data and password
  static final Map<String, Map<String, dynamic>> _mockUserDatabase = {
    'demo@example.com': {
      'id': '1',
      'name': 'Demo User',
      'email': 'demo@example.com',
      'password': 'Demo123', // In production, passwords would be hashed
      'phoneNumber': '+1234567890',
      'createdAt': DateTime.now().toIso8601String(),
    },
  };

  /// Signs in a user with email and password.
  ///
  /// Returns the User object if successful, null if credentials are invalid.
  /// Validates email format and checks credentials against mock database.
  /// Stores user session locally upon successful sign in.
  ///
  /// [email] - User's email address
  /// [password] - User's password
  Future<User?> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Validate email format
    if (!_isValidEmail(email)) {
      return null;
    }

    // Check if user exists and password matches
    final userData = _mockUserDatabase[email.toLowerCase()];
    if (userData == null || userData['password'] != password) {
      return null;
    }

    // Create User object (exclude password)
    final user = User(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      phoneNumber: userData['phoneNumber'],
      createdAt: DateTime.parse(userData['createdAt']),
    );

    // Store session
    await _saveUserSession(user);

    return user;
  }

  /// Signs up a new user with the provided information.
  ///
  /// Returns the User object if successful, null if validation fails or email exists.
  /// Validates all input fields and creates a new user in the mock database.
  /// Stores user session locally upon successful registration.
  ///
  /// [name] - User's full name
  /// [email] - User's email address
  /// [password] - User's password (must meet requirements)
  /// [phoneNumber] - Optional phone number
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Validate inputs
    if (name.trim().isEmpty) {
      return null;
    }

    if (!_isValidEmail(email)) {
      return null;
    }

    if (!_isValidPassword(password)) {
      return null;
    }

    // Check if user already exists
    if (_mockUserDatabase.containsKey(email.toLowerCase())) {
      return null;
    }

    // Create new user
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final createdAt = DateTime.now();

    final user = User(
      id: userId,
      name: name,
      email: email.toLowerCase(),
      phoneNumber: phoneNumber,
      createdAt: createdAt,
    );

    // Store in mock database
    _mockUserDatabase[email.toLowerCase()] = {
      'id': userId,
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
    };

    // Store session
    await _saveUserSession(user);

    return user;
  }

  /// Retrieves the currently signed-in user from local storage.
  ///
  /// Returns the User object if a valid session exists, null otherwise.
  /// Used on app startup to check for existing sessions.
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userSessionKey);

      if (userJson == null) {
        return null;
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      // If there's any error reading the session, return null
      return null;
    }
  }

  /// Signs out the current user and clears the session.
  ///
  /// Removes all stored user data from local storage.
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userSessionKey);
  }

  /// Initiates password reset flow for the given email.
  ///
  /// This is a mock implementation that simulates sending a reset email.
  /// Returns true if email exists in system, false otherwise.
  ///
  /// [email] - User's email address
  Future<bool> resetPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Check if email exists
    return _mockUserDatabase.containsKey(email.toLowerCase());
  }

  /// Saves user session to local storage.
  ///
  /// Converts User object to JSON and stores it using shared_preferences.
  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userSessionKey, userJson);
  }

  /// Validates email format using regex pattern.
  ///
  /// Returns true if email matches standard email format.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password meets security requirements.
  ///
  /// Requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one number
  ///
  /// Returns true if password meets all requirements.
  bool _isValidPassword(String password) {
    if (password.length < 8) {
      return false;
    }

    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    // Check for at least one number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }

    return true;
  }

  /// Public method to validate email format (for UI validation).
  bool isEmailValid(String email) => _isValidEmail(email);

  /// Public method to validate password format (for UI validation).
  bool isPasswordValid(String password) => _isValidPassword(password);
}
