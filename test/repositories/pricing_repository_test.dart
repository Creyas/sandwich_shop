import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final repository = PricingRepository();

    // A reusable dummy sandwich object
    final dummySandwich = Sandwich(
      type: SandwichType.veggieDelight,
      breadType: BreadType.wheat,
      isFootlong: true,
    );

    test('calculates price for one six-inch', () {
      final price = repository.calculatePrice(
        dummySandwich,
        quantity: 1,
        isFootlong: false,
      );
      expect(price, 7.00);
    });

    test('calculates price for multiple footlongs', () {
      final price = repository.calculatePrice(
        dummySandwich,
        quantity: 3,
        isFootlong: true,
      );
      expect(price, 33.00);
    });

    test('calculates price as zero when quantity is zero', () {
      final price = repository.calculatePrice(
        dummySandwich,
        quantity: 0,
        isFootlong: true,
      );
      expect(price, 0.00);
    });
  });
}
