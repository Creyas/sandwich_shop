import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'adaptive_navigation.dart';

/// Base scaffold widget that provides consistent layout across all main screens.
///
/// This widget:
/// - Automatically adds adaptive navigation (drawer on mobile, rail on desktop)
/// - Provides a consistent AppBar with title
/// - Accepts optional AppBar actions
/// - Handles responsive layout for mobile and desktop
/// - Eliminates code duplication across screens
///
/// Usage:
/// ```dart
/// BaseScaffold(
///   title: 'My Screen',
///   currentScreen: 'Home',
///   cart: cart,
///   body: MyScreenContent(),
///   actions: [IconButton(...)], // optional
/// )
/// ```
class BaseScaffold extends StatelessWidget {
  /// The title displayed in the AppBar
  final String title;

  /// The current screen name for navigation highlighting ('Home', 'Cart', 'About')
  final String currentScreen;

  /// The cart instance for navigation
  final Cart cart;

  /// The main content of the screen
  final Widget body;

  /// Optional actions to display in the AppBar
  final List<Widget>? actions;

  /// Optional floating action button
  final Widget? floatingActionButton;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.currentScreen,
    required this.cart,
    required this.body,
    this.actions,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AdaptiveNavigation.isMobile(context);
    final navigationRail =
        AdaptiveNavigation.getNavigationRail(context, currentScreen, cart);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: actions,
        // On mobile, the hamburger icon appears automatically when drawer is set
        // On desktop, we don't show the hamburger icon since we have a permanent rail
      ),
      // Drawer only appears on mobile
      drawer: AdaptiveNavigation.getDrawer(context, currentScreen, cart),
      // Floating action button (optional)
      floatingActionButton: floatingActionButton,
      body: isMobile
          ? body // Mobile: just show the body
          : Row(
              children: [
                // Desktop: show navigation rail on the left
                if (navigationRail != null) navigationRail,
                // Vertical divider between rail and content
                const VerticalDivider(thickness: 1, width: 1),
                // Main content takes remaining space
                Expanded(child: body),
              ],
            ),
    );
  }
}
