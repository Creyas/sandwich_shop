import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('shows SnackBar when item is added to cart',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: OrderScreen(maxQuantity: 5)));

    // Ensure Add to Cart button exists and tap it
    final addButton = find.text('Add to Cart');
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);

    // Show SnackBar (pumping allows the ScaffoldMessenger to show it)
    await tester.pump();

    // SnackBar should be present
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
