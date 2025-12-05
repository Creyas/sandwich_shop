/// User model representing an authenticated user in the application.
///
/// Contains user identification, contact information, and account metadata.
class User {
  /// Unique identifier for the user
  final String id;

  /// Full name of the user
  final String name;

  /// Email address used for authentication
  final String email;

  /// Optional phone number for contact
  final String? phoneNumber;

  /// Timestamp when the user account was created
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
  });

  /// Creates a User instance from a JSON map
  ///
  /// Used for deserializing user data from local storage
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Converts the User instance to a JSON map
  ///
  /// Used for serializing user data to local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of this User with optionally updated fields
  ///
  /// Useful for updating user information without mutating the original
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, email, phoneNumber, createdAt);
  }
}
