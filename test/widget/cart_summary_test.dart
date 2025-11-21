import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('cart summary updates when Add to Cart is pressed',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: OrderScreen(maxQuantity: 5)));

    // initial state: compact summary shows zero values
    expect(find.text('Items: 0'), findsOneWidget);
    expect(find.text('Total: £0.00'), findsOneWidget);

    // Tap the Add to Cart button
    final addButton = find.text('Add to Cart');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // After adding one default sandwich (footlong) PricingRepository uses 11.00 for footlong
    // Compact summary should update to show item count and total
    expect(find.text('Items: 1'), findsOneWidget);
    expect(find.text('Total: £11.00'), findsOneWidget);

    // Tap the View Cart button to show the full receipt
    final viewCart = find.text('View Cart');
    expect(viewCart, findsOneWidget);
    await tester.tap(viewCart);
    await tester.pumpAndSettle();

    // Full cart screen should list the grouped line and totals
    expect(find.text('1 Footlong Veggie Delight(s)'), findsOneWidget);
    expect(find.text('Order total: £11.00'), findsOneWidget);
  });
}
