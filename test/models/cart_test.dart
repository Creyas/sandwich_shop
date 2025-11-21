import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// A small fake PricingRepository matching the signature used by Cart.
// Adjust base prices to match your real repository if needed.
class FakePricingRepository implements PricingRepository {
  static const Map<SandwichType, double> _base = {
    SandwichType.veggieDelight: 5.0,
    SandwichType.chickenTeriyaki: 6.5,
    SandwichType.tunaMelt: 6.0,
    SandwichType.meatballMarinara: 7.0,
  };

  @override
  double calculatePrice(
    Sandwich sandwich, {
    bool isFootlong = false,
    int quantity = 1,
  }) {
    final base = _base[sandwich.type] ?? 0.0;
    final sizeMultiplier = isFootlong ? 2.0 : 1.0;
    return base * sizeMultiplier * quantity;
  }
}

void main() {
  group('Cart', () {
    late Cart cart;
    late FakePricingRepository pricing;

    setUp(() {
      pricing = FakePricingRepository();
      cart = Cart(pricingRepository: pricing);
    });

    test('add increments itemCount and updates totalPrice', () {
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wheat);
      cart.add(s); // adds 1
      // tuna base 6.0, footlong multiplier 2 => 12.0
      expect(cart.itemCount, equals(1));
      expect(cart.totalPrice, closeTo(12.0, 1e-6));
    });

    test('adding same sandwich increases quantity and total price', () {
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wheat);
      cart.add(s); // +1 (12.0)
      cart.add(s, 2); // +2 (24.0)
      expect(cart.itemCount, equals(3));
      expect(cart.distinctItemCount, equals(1));
      expect(cart.totalPrice, closeTo(36.0, 1e-6));
    });

    test('remove decreases quantity and updates totalPrice', () {
      final s = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: true,
          breadType: BreadType.wheat);
      cart.add(s, 3); // totalPrice = 36.0, itemCount = 3
      final removed = cart.remove(s, 2); // remove 2 -> subtract 24.0
      expect(removed, isTrue);
      expect(cart.itemCount, equals(1));
      expect(cart.totalPrice, closeTo(12.0, 1e-6));
    });

    test('removeAll removes line item and updates totalPrice', () {
      final s = Sandwich(
          type: SandwichType.chickenTeriyaki,
          isFootlong: false,
          breadType: BreadType.white);
      cart.add(s, 2); // chicken base 6.5, six inch -> 6.5 * 1 * 2 = 13.0
      final removed = cart.removeAll(s);
      expect(removed, isTrue);
      expect(cart.itemCount, equals(0));
      expect(cart.distinctItemCount, equals(0));
      expect(cart.totalPrice, closeTo(0.0, 1e-6));
    });

    test('clear empties the cart and resets price', () {
      cart.add(
          Sandwich(
              type: SandwichType.veggieDelight,
              isFootlong: false,
              breadType: BreadType.wheat),
          2);
      cart.clear();
      expect(cart.itemCount, equals(0));
      expect(cart.totalPrice, closeTo(0.0, 1e-6));
    });
  });
}
