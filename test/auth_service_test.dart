import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AuthService Unit Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    group('Sign In Tests', () {
      test('signIn with valid demo credentials returns User', () async {
        final user = await authService.signIn('demo@example.com', 'Demo123');

        expect(user, isNotNull);
        expect(user!.email, 'demo@example.com');
        expect(user.name, 'Demo User');
      });

      test('signIn with invalid email returns null', () async {
        final user = await authService.signIn('wrong@example.com', 'Demo123');

        expect(user, isNull);
      });

      test('signIn with invalid password returns null', () async {
        final user = await authService.signIn('demo@example.com', 'WrongPass');

        expect(user, isNull);
      });

      test('signIn with invalid email format returns null', () async {
        final user = await authService.signIn('notanemail', 'Demo123');

        expect(user, isNull);
      });

      test('signIn with empty email returns null', () async {
        final user = await authService.signIn('', 'Demo123');

        expect(user, isNull);
      });

      test('signIn stores session after successful login', () async {
        await authService.signIn('demo@example.com', 'Demo123');
        final currentUser = await authService.getCurrentUser();

        expect(currentUser, isNotNull);
        expect(currentUser!.email, 'demo@example.com');
      });
    });

    group('Sign Up Tests', () {
      test('signUp with valid data creates new user', () async {
        final user = await authService.signUp(
          name: 'Test User',
          email: 'test@example.com',
          password: 'Test1234',
          phoneNumber: '+1234567890',
        );

        expect(user, isNotNull);
        expect(user!.name, 'Test User');
        expect(user.email, 'test@example.com');
        expect(user.phoneNumber, '+1234567890');
      });

      test('signUp without phone number succeeds', () async {
        final user = await authService.signUp(
          name: 'Test User',
          email: 'newuser@example.com',
          password: 'Test1234',
        );

        expect(user, isNotNull);
        expect(user!.phoneNumber, isNull);
      });

      test('signUp with duplicate email returns null', () async {
        // First signup
        await authService.signUp(
          name: 'First User',
          email: 'duplicate@example.com',
          password: 'Test1234',
        );

        // Attempt duplicate signup
        final duplicateUser = await authService.signUp(
          name: 'Second User',
          email: 'duplicate@example.com',
          password: 'Test5678',
        );

        expect(duplicateUser, isNull);
      });

      test('signUp with invalid email format returns null', () async {
        final user = await authService.signUp(
          name: 'Test User',
          email: 'invalidemail',
          password: 'Test1234',
        );

        expect(user, isNull);
      });

      test('signUp with weak password returns null', () async {
        final user = await authService.signUp(
          name: 'Test User',
          email: 'test2@example.com',
          password: 'weak',
        );

        expect(user, isNull);
      });

      test('signUp with password missing uppercase returns null', () async {
        final user = await authService.signUp(
          name: 'Test User',
          email: 'test3@example.com',
          password: 'password123',
        );

        expect(user, isNull);
      });

      test('signUp with password missing number returns null', () async {
        final user = await authService.signUp(
          name: 'Test User',
          email: 'test4@example.com',
          password: 'Password',
        );

        expect(user, isNull);
      });

      test('signUp with empty name returns null', () async {
        final user = await authService.signUp(
          name: '',
          email: 'test5@example.com',
          password: 'Test1234',
        );

        expect(user, isNull);
      });

      test('signUp stores session after successful registration', () async {
        await authService.signUp(
          name: 'New User',
          email: 'newuser2@example.com',
          password: 'NewPass123',
        );

        final currentUser = await authService.getCurrentUser();
        expect(currentUser, isNotNull);
        expect(currentUser!.email, 'newuser2@example.com');
      });

      test('signUp creates unique user IDs', () async {
        final user1 = await authService.signUp(
          name: 'User One',
          email: 'user1@example.com',
          password: 'Pass1234',
        );

        final user2 = await authService.signUp(
          name: 'User Two',
          email: 'user2@example.com',
          password: 'Pass1234',
        );

        expect(user1!.id, isNot(equals(user2!.id)));
      });
    });

    group('Session Management Tests', () {
      test('getCurrentUser returns null when no session exists', () async {
        final user = await authService.getCurrentUser();

        expect(user, isNull);
      });

      test('getCurrentUser returns user after sign in', () async {
        await authService.signIn('demo@example.com', 'Demo123');
        final user = await authService.getCurrentUser();

        expect(user, isNotNull);
        expect(user!.email, 'demo@example.com');
      });

      test('signOut clears current session', () async {
        await authService.signIn('demo@example.com', 'Demo123');
        expect(await authService.getCurrentUser(), isNotNull);

        await authService.signOut();
        final user = await authService.getCurrentUser();

        expect(user, isNull);
      });

      test('session persists across AuthService instances', () async {
        final authService1 = AuthService();
        await authService1.signIn('demo@example.com', 'Demo123');

        final authService2 = AuthService();
        final user = await authService2.getCurrentUser();

        expect(user, isNotNull);
        expect(user!.email, 'demo@example.com');
      });
    });

    group('Password Reset Tests', () {
      test('resetPassword returns true for existing email', () async {
        final result = await authService.resetPassword('demo@example.com');

        expect(result, isTrue);
      });

      test('resetPassword returns false for non-existent email', () async {
        final result = await authService.resetPassword('notfound@example.com');

        expect(result, isFalse);
      });

      test('resetPassword validates email format', () async {
        final result = await authService.resetPassword('invalidemail');

        expect(result, isFalse);
      });
    });

    group('Email Validation Tests', () {
      test('isEmailValid returns true for valid email', () {
        expect(authService.isEmailValid('test@example.com'), isTrue);
        expect(authService.isEmailValid('user.name@example.co.uk'), isTrue);
        expect(authService.isEmailValid('user+tag@example.com'), isTrue);
      });

      test('isEmailValid returns false for invalid email', () {
        expect(authService.isEmailValid('notanemail'), isFalse);
        expect(authService.isEmailValid('missing@domain'), isFalse);
        expect(authService.isEmailValid('@example.com'), isFalse);
        expect(authService.isEmailValid('user@'), isFalse);
        expect(authService.isEmailValid(''), isFalse);
      });
    });

    group('Password Validation Tests', () {
      test('isPasswordValid returns true for valid password', () {
        expect(authService.isPasswordValid('Password123'), isTrue);
        expect(authService.isPasswordValid('SecureP@ss1'), isTrue);
        expect(authService.isPasswordValid('ALLCAPS1valid'), isTrue);
      });

      test('isPasswordValid returns false for short password', () {
        expect(authService.isPasswordValid('Pass1'), isFalse);
        expect(authService.isPasswordValid('Aa1'), isFalse);
      });

      test('isPasswordValid returns false for missing uppercase', () {
        expect(authService.isPasswordValid('password123'), isFalse);
        expect(authService.isPasswordValid('alllowercase1'), isFalse);
      });

      test('isPasswordValid returns false for missing number', () {
        expect(authService.isPasswordValid('Password'), isFalse);
        expect(authService.isPasswordValid('NoNumbersHere'), isFalse);
      });

      test('isPasswordValid returns false for empty password', () {
        expect(authService.isPasswordValid(''), isFalse);
      });
    });
  });
}
