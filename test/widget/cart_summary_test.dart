import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('cart summary updates when Add to Cart is pressed',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: OrderScreen(maxQuantity: 5)));

    // initial state: empty cart shows totals with zero values
    expect(find.text('Total items: 0'), findsOneWidget);
    expect(find.text('Order total: £0.00'), findsOneWidget);

    // Tap the Add to Cart button
    final addButton = find.text('Add to Cart');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // After adding one default sandwich (footlong) PricingRepository uses 11.00 for footlong
    expect(find.text('1 Footlong Veggie Delight(s)'), findsOneWidget);
    // line price and order total
    expect(find.text('£11.00'), findsWidgets);
    expect(find.text('Total items: 1'), findsOneWidget);
    expect(find.text('Order total: £11.00'), findsOneWidget);
  });
}
