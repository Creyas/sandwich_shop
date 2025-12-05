import 'package:flutter/material.dart';
import 'package:sandwich_shop/services/auth_service.dart';
import 'package:sandwich_shop/views/auth_screen.dart';
import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sandwich Shop',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

/// Wrapper widget that checks for existing user session on app startup.
///
/// Displays a loading screen while checking for session, then navigates to:
/// - OrderScreen if valid session exists
/// - AuthScreen if no session exists
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return FutureBuilder(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        // Show loading screen while checking session
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 24),
                  CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Check if user session exists
        if (snapshot.hasData && snapshot.data != null) {
          // User is signed in - go to OrderScreen
          return OrderScreen();
        } else {
          // No session - show AuthScreen
          return const AuthScreen();
        }
      },
    );
  }
}
