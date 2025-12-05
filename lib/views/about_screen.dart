import 'package:flutter/material.dart';
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
            const Text(
              'About Sandwich Shop',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to our Sandwich Shop! We serve delicious, freshly made sandwiches with quality ingredients.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our mission is to provide the best sandwiches in town with friendly service and a smile.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
