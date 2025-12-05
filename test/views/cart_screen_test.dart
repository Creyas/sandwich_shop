import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartScreen - Empty Cart State', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      final CartScreen cartScreen = CartScreen(cart: emptyCart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      // Verify empty cart state is displayed
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
      expect(find.text('Start Shopping'), findsOneWidget);

      // Verify cart content is not displayed
      expect(find.text('Total:'), findsNothing);
    });

    testWidgets('empty cart shows shopping cart icon with correct styling',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      final CartScreen cartScreen = CartScreen(cart: emptyCart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      // Find the Icon widget
      final iconFinder = find.byIcon(Icons.shopping_cart_outlined);
      expect(iconFinder, findsOneWidget);

      // Verify icon properties
      final Icon icon = tester.widget(iconFinder);
      expect(icon.size, 100);
      expect(icon.color, isNotNull);
    });

    testWidgets('Start Shopping button navigates back',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      final CartScreen cartScreen = CartScreen(cart: emptyCart);

      // Create a navigation context
      final MaterialApp app = MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => cartScreen),
                ),
                child: const Text('Go to Cart'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(app);

      // Navigate to cart screen
      await tester.tap(find.text('Go to Cart'));
      await tester.pumpAndSettle();

      // Verify we're on cart screen with empty state
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Start Shopping'), findsOneWidget);

      // Tap Start Shopping button
      await tester.tap(find.text('Start Shopping'));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.text('Go to Cart'), findsOneWidget);
      expect(find.text('Your cart is empty'), findsNothing);
    });
  });

  group('CartScreen - Cart with Items', () {
    testWidgets('does not display empty cart state when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      // Verify cart items are displayed
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Qty: 2 - £22.00'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);

      // Verify empty cart state is NOT displayed
      expect(find.text('Your cart is empty'), findsNothing);
      expect(find.text('Start Shopping'), findsNothing);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsNothing);
    });

    testWidgets('displays single cart item correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Qty: 1 - £7.00'), findsOneWidget);
      expect(find.text('Total: £7.00'), findsOneWidget);
    });

    testWidgets('displays multiple cart items correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Qty: 1 - £11.00'), findsOneWidget);
      expect(find.text('Qty: 3 - £21.00'), findsOneWidget);
      expect(find.text('Total: £32.00'), findsOneWidget);
    });

    testWidgets('calculates total price correctly for multiple items',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      // Add various items
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      final sandwich3 = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      cart.add(sandwich1, quantity: 2); // 2 × £11.00 = £22.00
      cart.add(sandwich2, quantity: 1); // 1 × £7.00 = £7.00
      cart.add(sandwich3, quantity: 3); // 3 × £11.00 = £33.00
      // Total: £62.00

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Total: £62.00'), findsOneWidget);
    });

    testWidgets('displays Checkout button when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.byIcon(Icons.payment), findsOneWidget);
    });

    testWidgets('displays Back to Order button when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Back to Order'), findsOneWidget);
    });

    testWidgets('Back to Order button navigates back',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);

      // Create a navigation context
      final MaterialApp app = MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => cartScreen),
                ),
                child: const Text('Go to Cart'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(app);

      // Navigate to cart screen
      await tester.tap(find.text('Go to Cart'));
      await tester.pumpAndSettle();

      // Verify we're on cart screen
      expect(find.text('Back to Order'), findsOneWidget);

      // Tap Back to Order button
      await tester.tap(find.text('Back to Order'));
      await tester.pumpAndSettle();

      // Verify we navigated back
      expect(find.text('Go to Cart'), findsOneWidget);
      expect(find.text('Back to Order'), findsNothing);
    });
  });

  group('CartScreen - UI Elements', () {
    testWidgets('displays correct app bar title', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Your Cart'), findsOneWidget);
    });

    testWidgets('has AppBar widget', (WidgetTester tester) async {
      final Cart cart = Cart();
      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);
    });
  });

  group('CartScreen - Price Formatting', () {
    testWidgets('formats prices with two decimal places',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 3);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      // Verify proper formatting with .00
      expect(find.text('Qty: 3 - £33.00'), findsOneWidget);
      expect(find.text('Total: £33.00'), findsOneWidget);
    });

    testWidgets('displays correct footlong pricing',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Qty: 1 - £11.00'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('displays correct six-inch pricing',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Qty: 1 - £7.00'), findsOneWidget);
      expect(find.text('Total: £7.00'), findsOneWidget);
    });
  });

  group('CartScreen - Sandwich Details', () {
    testWidgets('displays correct sandwich names', (WidgetTester tester) async {
      final Cart cart = Cart();

      cart.add(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ),
        quantity: 1,
      );
      cart.add(
        Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat,
        ),
        quantity: 1,
      );
      cart.add(
        Sandwich(
          type: SandwichType.meatballMarinara,
          isFootlong: true,
          breadType: BreadType.wholemeal,
        ),
        quantity: 1,
      );

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Tuna Melt'), findsOneWidget);
      expect(find.text('Meatball Marinara'), findsOneWidget);
    });

    testWidgets('displays correct bread types', (WidgetTester tester) async {
      final Cart cart = Cart();

      cart.add(
        Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        ),
        quantity: 1,
      );
      cart.add(
        Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.wheat,
        ),
        quantity: 1,
      );
      cart.add(
        Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wholemeal,
        ),
        quantity: 1,
      );

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Footlong on wholemeal bread'), findsOneWidget);
    });

    testWidgets('displays correct size text for footlong',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.textContaining('Footlong'), findsOneWidget);
    });

    testWidgets('displays correct size text for six-inch',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich, quantity: 1);

      final CartScreen cartScreen = CartScreen(cart: cart);
      final MaterialApp app = MaterialApp(
        home: cartScreen,
      );

      await tester.pumpWidget(app);

      expect(find.textContaining('Six-inch'), findsOneWidget);
    });
  });
}
