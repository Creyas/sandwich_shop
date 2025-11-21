import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('groups items by size (Footlong vs Six-inch) and shows totals',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: OrderScreen(maxQuantity: 5)));

    // Add a footlong Veggie Delight (default)
    final addButton = find.text('Add to Cart');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Toggle size switch to six-inch and add one
    final sizeSwitch = find.byType(Switch);
    expect(sizeSwitch, findsOneWidget);
    await tester.tap(sizeSwitch);
    await tester.pumpAndSettle();

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Compact summary should reflect the counts and total
    expect(find.text('Items: 2'), findsOneWidget);
    expect(find.text('Total: £18.00'), findsOneWidget);

    // Open full cart to verify grouping by size
    await tester.tap(find.text('View Cart'));
    await tester.pumpAndSettle();

    // Expect two grouped lines: one Footlong and one Six-inch
    expect(find.text('1 Footlong Veggie Delight(s)'), findsOneWidget);
    expect(find.text('1 Six-inch Veggie Delight(s)'), findsOneWidget);

    // Totals: footlong (11) + six-inch (7) = 18 -> formatted with £
    expect(find.text('Order total: £18.00'), findsOneWidget);
  });
}
