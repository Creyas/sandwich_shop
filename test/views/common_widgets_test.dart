import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CommonAppBar', () {
    testWidgets('displays title correctly', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Screen'), findsOneWidget);
    });

    testWidgets('displays logo', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows cart indicator by default', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CartIndicator), findsOneWidget);
    });

    testWidgets('hides cart indicator when showCartIndicator is false',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(
                title: 'Test Screen',
                showCartIndicator: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CartIndicator), findsNothing);
    });

    testWidgets('has correct preferredSize', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final CommonAppBar appBar = tester.widget<CommonAppBar>(
        find.byType(CommonAppBar),
      );

      expect(appBar.preferredSize.height, equals(kToolbarHeight));
    });

    testWidgets('title uses heading1 style', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Text titleText = tester.widget<Text>(find.text('Test Screen'));
      expect(titleText.style, equals(heading1));
    });

    testWidgets('is a PreferredSizeWidget', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final CommonAppBar appBar = tester.widget<CommonAppBar>(
        find.byType(CommonAppBar),
      );

      expect(appBar, isA<PreferredSizeWidget>());
    });

    testWidgets('logo has correct padding', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Padding logoPadding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(AppBar),
              matching: find.byType(Padding),
            )
            .first,
      );

      expect(logoPadding.padding, equals(const EdgeInsets.all(8.0)));
    });
  });

  group('CartIndicator', () {
    testWidgets('displays correct count for empty cart',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('displays correct count with items in cart',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 3);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('updates when cart changes', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      // Add item to cart
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('calls onTap callback when tapped',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      bool tapped = false;

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: MaterialApp(
            home: Scaffold(
              body: CartIndicator(
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CartIndicator));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('displays shopping cart icon', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('supports custom icon color', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(
                iconColor: Colors.red,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Icon icon = tester.widget<Icon>(find.byIcon(Icons.shopping_cart));
      expect(icon.color, equals(Colors.red));
    });

    testWidgets('uses default white color when iconColor is null',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Icon icon = tester.widget<Icon>(find.byIcon(Icons.shopping_cart));
      expect(icon.color, equals(Colors.white));
    });

    testWidgets('displays count with multiple items',
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
      cart.add(sandwich1, quantity: 2);
      cart.add(sandwich2, quantity: 3);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('has correct padding', (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Padding padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(CartIndicator),
          matching: find.byType(Padding),
        ),
      );

      expect(padding.padding, equals(const EdgeInsets.all(8.0)));
    });

    testWidgets('uses Consumer for reactive updates',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartIndicator(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Consumer<Cart>), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('CommonAppBar with CartIndicator shows correct count',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 4);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Screen'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.byType(CartIndicator), findsOneWidget);
    });

    testWidgets('Multiple cart updates reflect in CartIndicator',
        (WidgetTester tester) async {
      final Cart cart = Cart();

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: CommonAppBar(title: 'Test Screen'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      // Add first item
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich1, quantity: 1);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // Add second item
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich2, quantity: 2);
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      // Remove one item
      cart.remove(sandwich1, quantity: 1);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });
  });
}
