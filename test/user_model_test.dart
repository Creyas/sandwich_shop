import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/user.dart';

void main() {
  group('User Model Tests', () {
    final testDate = DateTime(2024, 1, 1, 12, 0, 0);

    group('User Creation Tests', () {
      test('User can be created with all fields', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          createdAt: testDate,
        );

        expect(user.id, '123');
        expect(user.name, 'Test User');
        expect(user.email, 'test@example.com');
        expect(user.phoneNumber, '+1234567890');
        expect(user.createdAt, testDate);
      });

      test('User can be created without phone number', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          createdAt: testDate,
        );

        expect(user.phoneNumber, isNull);
      });
    });

    group('JSON Serialization Tests', () {
      test('toJson converts User to JSON map', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          createdAt: testDate,
        );

        final json = user.toJson();

        expect(json['id'], '123');
        expect(json['name'], 'Test User');
        expect(json['email'], 'test@example.com');
        expect(json['phoneNumber'], '+1234567890');
        expect(json['createdAt'], testDate.toIso8601String());
      });

      test('toJson handles null phone number', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          createdAt: testDate,
        );

        final json = user.toJson();

        expect(json['phoneNumber'], isNull);
      });

      test('fromJson creates User from JSON map', () {
        final json = {
          'id': '123',
          'name': 'Test User',
          'email': 'test@example.com',
          'phoneNumber': '+1234567890',
          'createdAt': testDate.toIso8601String(),
        };

        final user = User.fromJson(json);

        expect(user.id, '123');
        expect(user.name, 'Test User');
        expect(user.email, 'test@example.com');
        expect(user.phoneNumber, '+1234567890');
        expect(user.createdAt, testDate);
      });

      test('fromJson handles null phone number', () {
        final json = {
          'id': '123',
          'name': 'Test User',
          'email': 'test@example.com',
          'phoneNumber': null,
          'createdAt': testDate.toIso8601String(),
        };

        final user = User.fromJson(json);

        expect(user.phoneNumber, isNull);
      });

      test('toJson and fromJson are symmetric', () {
        final originalUser = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          createdAt: testDate,
        );

        final json = originalUser.toJson();
        final reconstructedUser = User.fromJson(json);

        expect(reconstructedUser.id, originalUser.id);
        expect(reconstructedUser.name, originalUser.name);
        expect(reconstructedUser.email, originalUser.email);
        expect(reconstructedUser.phoneNumber, originalUser.phoneNumber);
        expect(reconstructedUser.createdAt, originalUser.createdAt);
      });
    });

    group('CopyWith Tests', () {
      test('copyWith creates new User with updated fields', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          createdAt: testDate,
        );

        final updatedUser = user.copyWith(name: 'Updated Name');

        expect(updatedUser.name, 'Updated Name');
        expect(updatedUser.id, user.id);
        expect(updatedUser.email, user.email);
        expect(updatedUser.phoneNumber, user.phoneNumber);
        expect(updatedUser.createdAt, user.createdAt);
      });

      test('copyWith can update multiple fields', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          createdAt: testDate,
        );

        final updatedUser = user.copyWith(
          name: 'New Name',
          phoneNumber: '+9876543210',
        );

        expect(updatedUser.name, 'New Name');
        expect(updatedUser.phoneNumber, '+9876543210');
        expect(updatedUser.id, user.id);
        expect(updatedUser.email, user.email);
      });

      test('copyWith with no arguments returns identical user', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          createdAt: testDate,
        );

        final copiedUser = user.copyWith();

        expect(copiedUser.id, user.id);
        expect(copiedUser.name, user.name);
        expect(copiedUser.email, user.email);
        expect(copiedUser.phoneNumber, user.phoneNumber);
        expect(copiedUser.createdAt, user.createdAt);
      });
    });

    group('Equality Tests', () {
      test('Users with same data are equal', () {
        final user1 = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          createdAt: testDate,
        );

        final user2 = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          createdAt: testDate,
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('Users with different data are not equal', () {
        final user1 = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          createdAt: testDate,
        );

        final user2 = User(
          id: '456',
          name: 'Test User',
          email: 'test@example.com',
          createdAt: testDate,
        );

        expect(user1, isNot(equals(user2)));
      });
    });

    group('ToString Tests', () {
      test('toString returns formatted string', () {
        final user = User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          phoneNumber: '+1234567890',
          createdAt: testDate,
        );

        final string = user.toString();

        expect(string, contains('123'));
        expect(string, contains('Test User'));
        expect(string, contains('test@example.com'));
        expect(string, contains('+1234567890'));
      });
    });
  });
}
