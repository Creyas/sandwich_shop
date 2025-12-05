import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import '../widgets/base_scaffold.dart';
import '../models/cart.dart';

class AboutScreen extends StatelessWidget {
  final Cart? cart;

  const AboutScreen({Key? key, this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If cart is not provided, create a temporary empty one for navigation
    final cartInstance = cart ?? Cart();

    return BaseScaffold(
      title: 'About Us',
      currentScreen: 'About',
      cart: cartInstance,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to Sandwich Shop!', style: heading2),
            SizedBox(height: 20),
            Text(
              'We are a family-owned business dedicated to serving the best sandwiches in town. '
              'Our commitment to quality ingredients and exceptional service makes us your go-to destination for delicious meals.',
              style: normalText,
            ),
          ],
        ),
      ),
    );
  }
}
