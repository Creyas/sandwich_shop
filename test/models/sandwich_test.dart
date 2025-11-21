import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';
void main() {
  group('Sandwich', () {
    test('name returns friendly names for all types', () {
      final expectedNames = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };

      expectedNames.forEach((type, expected) {
        final sandwich = Sandwich(type: type, isFootlong: true, breadType: BreadType.wheat);
        expect(sandwich.name, equals(expected));
      });
    });

    test('image returns correct asset path for footlong', () {
      for (final type in SandwichType.values) {
        final sandwich = Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
        final expected = 'assets/images/${type.name}_footlong.png';
        expect(sandwich.image, equals(expected));
      }
    });

    test('image returns correct asset path for six inch', () {
      for (final type in SandwichType.values) {
        final sandwich = Sandwich(type: type, isFootlong: false, breadType: BreadType.wheat);
        final expected = 'assets/images/${type.name}_six_inch.png';
        expect(sandwich.image, equals(expected));
      }
    });

    test('breadType property is preserved', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );
      expect(sandwich.breadType, equals(BreadType.wholemeal));
    });
  });
}