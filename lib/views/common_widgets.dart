import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

/// A reusable app bar widget with logo, title, and cart indicator.
///
/// This widget provides a consistent app bar across all screens in the app.
/// It displays the app logo on the left, a customizable title in the center,
/// and an optional cart indicator on the right showing the current cart count.
///
/// Example usage:
/// ```dart
/// CommonAppBar(
///   title: 'Order Screen',
///   showCartIndicator: true,
/// )
/// ```
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text to display in the app bar.
  final String title;

  /// Optional callback when the cart indicator is tapped.
  final VoidCallback? onCartTap;

  /// Whether to show the cart indicator. Defaults to true.
  final bool showCartIndicator;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onCartTap,
    this.showCartIndicator = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      title: Text(
        title,
        style: heading1,
      ),
      actions: showCartIndicator
          ? [
              CartIndicator(onTap: onCartTap),
            ]
          : null,
    );
  }
}

/// A widget that displays a shopping cart icon with a badge showing item count.
///
/// This widget uses Provider's Consumer to reactively update when the cart changes.
/// The badge is only shown when the cart has items. The widget supports customization
/// through optional color parameters and tap callbacks.
///
/// Example usage:
/// ```dart
/// CartIndicator(
///   onTap: () => Navigator.push(...),
///   iconColor: Colors.white,
///   badgeColor: Colors.red,
/// )
/// ```
class CartIndicator extends StatelessWidget {
  /// Optional callback when the cart indicator is tapped.
  final VoidCallback? onTap;

  /// The color of the shopping cart icon. Defaults to white.
  final Color? iconColor;

  /// The background color of the badge. Defaults to red.
  final Color? badgeColor;

  const CartIndicator({
    super.key,
    this.onTap,
    this.iconColor,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        final int itemCount = cart.countOfItems;

        return GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: iconColor ?? Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$itemCount',
                      style: TextStyle(color: iconColor ?? Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
