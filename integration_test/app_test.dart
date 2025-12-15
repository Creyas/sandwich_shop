import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI for desktop integration tests only
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton); // Scroll if needed
      await tester.pumpAndSettle();

      // Add a sandwich to the cart
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Find the View Cart button to navigate to the cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      // The + button should be the first one (before the cart + button)
      final quantityAddButton = addButtons.first;

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('complete checkout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pump(); // Start the async operation

      // Wait for payment processing timer (2 seconds)
      await tester.pump(const Duration(seconds: 2));

      // Let navigation and all animations complete
      await tester.pumpAndSettle();

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('increment and decrement quantity in cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Go to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);

      // Find increment button in cart (should be second + icon on page)
      final incrementButtons = find.byIcon(Icons.add);
      expect(incrementButtons, findsAtLeastNWidgets(1));
      await tester.tap(incrementButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
      expect(find.text('Quantity increased'), findsOneWidget);

      // Decrement quantity
      final decrementButtons = find.byIcon(Icons.remove);
      await tester.tap(decrementButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
      expect(find.text('Quantity decreased'), findsOneWidget);
    });

    testWidgets('remove item from cart with decrement to zero',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Go to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsOneWidget);

      // Decrement to zero
      final decrementButtons = find.byIcon(Icons.remove);
      await tester.tap(decrementButtons.first);
      await tester.pumpAndSettle();

      // Cart should be empty
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('remove item from cart with delete button',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Go to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsOneWidget);

      // Tap delete button
      final deleteButton = find.byIcon(Icons.delete);
      await tester.tap(deleteButton.first);
      await tester.pumpAndSettle();

      // Cart should be empty
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
      expect(find.text('Item removed from cart'), findsOneWidget);
    });

    testWidgets('navigate to settings and change font size',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings
      final settingsButton = find.widgetWithText(StyledButton, 'Settings');
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);

      // Find the slider and change font size
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Drag slider to increase font size
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Verify save message
      expect(find.text('Font size saved'), findsOneWidget);

      // Navigate back
      final backButton = find.widgetWithText(StyledButton, 'Back');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('view order history after checkout',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add and checkout
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Navigate to order history
      final orderHistoryButton =
          find.widgetWithText(StyledButton, 'Order History');
      await tester.ensureVisible(orderHistoryButton);
      await tester.tap(orderHistoryButton);
      await tester.pumpAndSettle();

      expect(find.text('Order History'), findsOneWidget);
      // Should see the completed order
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('£11.00'), findsOneWidget);
    });

    testWidgets('profile screen entry and welcome message',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);

      // Enter name and location
      final nameField = find.byType(TextField).first;
      final locationField = find.byType(TextField).last;

      await tester.enterText(nameField, 'John Doe');
      await tester.pumpAndSettle();

      await tester.enterText(locationField, 'London');
      await tester.pumpAndSettle();

      // Save profile
      final saveButton = find.widgetWithText(StyledButton, 'Save');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should return to order screen with welcome message
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(
          find.text('Welcome, John Doe! Ordering from London'), findsOneWidget);
    });

    testWidgets('attempt checkout with empty cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to cart without adding items
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty.'), findsOneWidget);
      // Checkout button should not be visible
      expect(find.widgetWithText(StyledButton, 'Checkout'), findsNothing);
    });

    testWidgets('add multiple different sandwiches to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add first sandwich (Veggie Delight)
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Change to Chicken Teriyaki
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Add second sandwich
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart shows 2 items
      expect(find.text('Cart: 2 items - £21.00'), findsOneWidget);

      // Go to cart and verify both items
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Total: £21.00'), findsOneWidget);
    });

    testWidgets('change bread type and verify in cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Change bread type
      final breadDropdown = find.byType(DropdownMenu<BreadType>);
      await tester.tap(breadDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Go to cart and verify bread type
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Footlong on wheat bread'), findsOneWidget);
    });

    testWidgets('toggle sandwich size and verify price change',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Initially footlong, price should be £11.00
      expect(find.textContaining('£11.00'), findsWidgets);

      // Find the size switch
      final sizeSwitch = find.byType(Switch);
      await tester.tap(sizeSwitch);
      await tester.pumpAndSettle();

      // Now six-inch, price should be lower (£6.00)
      expect(find.textContaining('£6.00'), findsWidgets);

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary shows six-inch price
      expect(find.text('Cart: 1 items - £6.00'), findsOneWidget);
    });

    testWidgets('add notes to sandwich order', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find notes field and enter text
      final notesField = find.byType(TextField);
      await tester.enterText(notesField, 'Extra pickles please');
      await tester.pumpAndSettle();

      // Notes should be visible
      expect(find.text('Extra pickles please'), findsOneWidget);

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Go to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify notes appear in cart
      expect(find.text('Extra pickles please'), findsOneWidget);
    });

    testWidgets('navigate back from cart to order screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Go to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);

      // Navigate back
      final backButton = find.widgetWithText(StyledButton, 'Back to Order');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Should be back on order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('cancel checkout and return to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add item and go to checkout
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);

      // Cancel checkout (use back button or app bar back)
      final cancelButton = find.widgetWithText(StyledButton, 'Cancel');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Should be back on cart screen with item still there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
    });

    testWidgets('empty order history shows appropriate message',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to order history without placing any orders
      final orderHistoryButton =
          find.widgetWithText(StyledButton, 'Order History');
      await tester.ensureVisible(orderHistoryButton);
      await tester.tap(orderHistoryButton);
      await tester.pumpAndSettle();

      expect(find.text('Order History'), findsOneWidget);
      expect(find.text('No orders yet.'), findsOneWidget);
    });
  });
}
