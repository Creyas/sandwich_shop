import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../views/order_screen.dart';
import '../views/cart_screen.dart';
import '../views/about_screen.dart';
import '../views/auth_screen.dart';

/// Adaptive navigation widget that switches between Drawer and NavigationRail
/// based on screen size.
///
/// **Mobile (width < 600px)**: Returns a Drawer widget
/// **Tablet/Desktop (width >= 600px)**: Returns a NavigationRail widget
///
/// Both layouts provide the same navigation functionality:
/// - Navigate to Home/Order, Cart, and About screens
/// - Display current screen highlight
/// - Show user info
/// - Sign out functionality
class AdaptiveNavigation {
  static const double _mobileBreakpoint = 600;

  /// Check if the current screen size is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileBreakpoint;
  }

  /// Get the appropriate navigation widget based on screen size
  static Widget? getDrawer(
      BuildContext context, String currentScreen, Cart cart) {
    if (isMobile(context)) {
      return _MobileDrawer(currentScreen: currentScreen, cart: cart);
    }
    return null; // No drawer for desktop, we'll use a rail instead
  }

  /// Get the navigation rail for desktop layout
  static Widget? getNavigationRail(
      BuildContext context, String currentScreen, Cart cart) {
    if (!isMobile(context)) {
      return _DesktopNavigationRail(currentScreen: currentScreen, cart: cart);
    }
    return null;
  }
}

/// Mobile drawer implementation (for screens < 600px)
class _MobileDrawer extends StatefulWidget {
  final String currentScreen;
  final Cart cart;

  const _MobileDrawer({
    required this.currentScreen,
    required this.cart,
  });

  @override
  State<_MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<_MobileDrawer> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  void _navigateToScreen(
      BuildContext context, String screenName, Widget screen) {
    Navigator.pop(context); // Close drawer
    if (widget.currentScreen == screenName) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

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
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.orange[700]),
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
                      style: const TextStyle(fontSize: 12, color: Colors.white),
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
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

/// Desktop navigation rail implementation (for screens >= 600px)
class _DesktopNavigationRail extends StatefulWidget {
  final String currentScreen;
  final Cart cart;

  const _DesktopNavigationRail({
    required this.currentScreen,
    required this.cart,
  });

  @override
  State<_DesktopNavigationRail> createState() => _DesktopNavigationRailState();
}

class _DesktopNavigationRailState extends State<_DesktopNavigationRail> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  int get _selectedIndex {
    switch (widget.currentScreen) {
      case 'Home':
        return 0;
      case 'Cart':
        return 1;
      case 'About':
        return 2;
      default:
        return 0;
    }
  }

  void _onDestinationSelected(int index) {
    Widget screen;
    String screenName;

    switch (index) {
      case 0:
        screenName = 'Home';
        screen = OrderScreen(cart: widget.cart);
        break;
      case 1:
        screenName = 'Cart';
        screen = CartScreen(cart: widget.cart);
        break;
      case 2:
        screenName = 'About';
        screen = AboutScreen(cart: widget.cart);
        break;
      default:
        return;
    }

    if (widget.currentScreen == screenName) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

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
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      backgroundColor: Colors.orange[50],
      selectedIconTheme: const IconThemeData(color: Colors.orange),
      selectedLabelTextStyle: const TextStyle(color: Colors.orange),
      leading: Column(
        children: [
          const SizedBox(height: 16),
          // User avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.orange,
            child: Text(
              _currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // User name
          if (!_isLoading)
            SizedBox(
              width: 80,
              child: Text(
                _currentUser?.name ?? 'User',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () => _showSignOutDialog(context),
                  tooltip: 'Sign Out',
                ),
              ],
            ),
          ),
        ),
      ),
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: widget.cart.isEmpty
              ? const Icon(Icons.shopping_cart_outlined)
              : Badge(
                  label: Text('${widget.cart.totalQuantity}'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
          selectedIcon: widget.cart.isEmpty
              ? const Icon(Icons.shopping_cart)
              : Badge(
                  label: Text('${widget.cart.totalQuantity}'),
                  child: const Icon(Icons.shopping_cart),
                ),
          label: const Text('Cart'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.info_outlined),
          selectedIcon: Icon(Icons.info),
          label: Text('About'),
        ),
      ],
    );
  }
}
