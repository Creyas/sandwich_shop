import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../models/cart.dart';
import '../views/order_screen.dart';
import '../views/cart_screen.dart';
import '../views/about_screen.dart';
import '../views/auth_screen.dart';

/// Reusable navigation drawer widget for the Sandwich Shop app.
///
/// This drawer provides:
/// - User profile header with current user info
/// - Navigation to main app screens (Home, Cart, About)
/// - Sign out functionality with confirmation
/// - Visual indication of the currently active screen
///
/// The drawer integrates with Flutter's Scaffold widget via the `drawer` property.
/// When a Scaffold has a drawer, the AppBar automatically shows a hamburger menu icon.
/// Users can also manually open the drawer programmatically using:
/// `Scaffold.of(context).openDrawer()`
///
/// After navigation, the drawer automatically closes using `Navigator.pop(context)`.
/// The drawer prevents duplicate screen instances by checking the current route.
class AppDrawer extends StatefulWidget {
  /// The current screen name (e.g., 'Home', 'Cart', 'About')
  final String currentScreen;

  /// The cart instance to pass when navigating to CartScreen
  final Cart cart;

  const AppDrawer({
    Key? key,
    required this.currentScreen,
    required this.cart,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  /// Load the current user from AuthService
  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  /// Navigate to a screen, avoiding duplicate navigation
  void _navigateToScreen(
      BuildContext context, String screenName, Widget screen) {
    // Close the drawer first
    Navigator.pop(context);

    // Don't navigate if we're already on this screen
    if (widget.currentScreen == screenName) {
      return;
    }

    // Navigate to the new screen
    // Using pushReplacement to avoid building a deep navigation stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Show confirmation dialog before signing out
  Future<void> _showSignOutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _authService.signOut();
      if (context.mounted) {
        // Navigate to auth screen and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // User Profile Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange[700],
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: _isLoading
                ? const Text('Loading...')
                : Text(
                    _currentUser?.name ?? 'User',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
            accountEmail: _isLoading
                ? const SizedBox.shrink()
                : Text(_currentUser?.email ?? ''),
          ),

          // Home/Order Screen
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: widget.currentScreen == 'Home',
            selectedTileColor: Colors.orange[50],
            onTap: () => _navigateToScreen(
              context,
              'Home',
              OrderScreen(cart: widget.cart),
            ),
          ),

          // Cart Screen
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            trailing: widget.cart.isEmpty
                ? null
                : CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 12,
                    child: Text(
                      '${widget.cart.totalQuantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
            selected: widget.currentScreen == 'Cart',
            selectedTileColor: Colors.orange[50],
            onTap: () => _navigateToScreen(
              context,
              'Cart',
              CartScreen(cart: widget.cart),
            ),
          ),

          // About Screen
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            selected: widget.currentScreen == 'About',
            selectedTileColor: Colors.orange[50],
            onTap: () => _navigateToScreen(
              context,
              'About',
              AboutScreen(cart: widget.cart),
            ),
          ),

          const Divider(),

          // Sign Out
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer first
              _showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
