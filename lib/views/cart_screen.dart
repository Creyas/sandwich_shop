import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandwich_shop/models/cart.dart';

class CartScreen extends StatelessWidget {
  final Cart cart;
  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_GB');
    final normalText = Theme.of(context).textTheme.bodyMedium;

    // Group items by name + size label
    final Map<String, Map<String, dynamic>> grouped = {};
    for (final it in cart.items) {
      final name = it.sandwich.name;
      final qty = it.quantity;
      final sizeLabel = it.sandwich.isFootlong ? 'Footlong' : 'Six-inch';
      final linePrice = cart.pricingRepository.calculatePrice(
        it.sandwich,
        isFootlong: it.sandwich.isFootlong,
        quantity: qty,
      );

      final keyName = '$name|$sizeLabel';
      if (!grouped.containsKey(keyName)) {
        grouped[keyName] = {
          'quantity': 0,
          'lineTotal': 0.0,
          'name': name,
          'sizeLabel': sizeLabel,
        };
      }
      grouped[keyName]!['quantity'] =
          (grouped[keyName]!['quantity'] as int) + qty;
      grouped[keyName]!['lineTotal'] =
          (grouped[keyName]!['lineTotal'] as double) + linePrice;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (grouped.isEmpty) ...[
              const SizedBox(height: 24),
              const Center(child: Text('Your cart is empty')),
            ] else ...[
              Expanded(
                child: ListView(
                  children: grouped.entries.map((e) {
                    final data = e.value;
                    final qty = data['quantity'] as int;
                    final lineTotal = data['lineTotal'] as double;
                    final name = data['name'] as String;
                    final sizeLabel = data['sizeLabel'] as String;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('$qty $sizeLabel $name(s)',
                                  style: normalText)),
                          Text(currencyFormat.format(lineTotal),
                              style: normalText),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total items: ${cart.itemCount}', style: normalText),
                  Text('Order total: ${currencyFormat.format(cart.totalPrice)}',
                      style: normalText),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
