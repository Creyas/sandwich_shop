import 'sandwich.dart';
import '../repositories/pricing_repository.dart';

class _CartItemKey {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  _CartItemKey(Sandwich s)
      : type = s.type,
        isFootlong = s.isFootlong,
        breadType = s.breadType;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is _CartItemKey &&
            other.type == type &&
            other.isFootlong == isFootlong &&
            other.breadType == breadType);
  }

  @override
  int get hashCode => Object.hash(type, isFootlong, breadType);
}

class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem(this.sandwich, this.quantity);
}

class Cart {
  final PricingRepository pricingRepository;
  final Map<_CartItemKey, CartItem> _items = {};
  double _totalPrice = 0.0;

  Cart({required this.pricingRepository});

  // Add quantity of a sandwich to the cart (default 1)
  void add(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final key = _CartItemKey(sandwich);
    final existing = _items[key];
    if (existing == null) {
      _items[key] = CartItem(sandwich, quantity);
    } else {
      existing.quantity += quantity;
    }
    _totalPrice += pricingRepository.calculatePrice(sandwich, isFootlong: sandwich.isFootlong, quantity: quantity);
  }

  // Remove up to [quantity] of the sandwich from the cart.
  // Returns true if any item was removed.
  bool remove(Sandwich sandwich, [int quantity = 1]) {
    final key = _CartItemKey(sandwich);
    final existing = _items[key];
    if (existing == null) return false;

    // clamp to an int safely
    int removeQty = quantity;
    if (removeQty < 1) removeQty = 1;
    if (removeQty > existing.quantity) removeQty = existing.quantity;

    existing.quantity -= removeQty;
    _totalPrice -= pricingRepository.calculatePrice(sandwich, isFootlong: sandwich.isFootlong, quantity: removeQty);

    if (existing.quantity <= 0) {
      _items.remove(key);
    }

    if (_totalPrice < 0) _totalPrice = 0.0;
    return true;
  }

  // Remove all quantities of the given sandwich
  bool removeAll(Sandwich sandwich) {
    final key = _CartItemKey(sandwich);
    final existing = _items.remove(key);
    if (existing == null) return false;
    _totalPrice -=
        pricingRepository.calculatePrice(existing.sandwich, isFootlong: existing.sandwich.isFootlong, quantity: existing.quantity);
    if (_totalPrice < 0) _totalPrice = 0.0;
    return true;
  }

  void clear() {
    _items.clear();
    _totalPrice = 0.0;
  }

  // Number of items in the cart (sum of quantities)
  int get itemCount => _items.values.fold(0, (sum, it) => sum + it.quantity);

  // Number of distinct line items
  int get distinctItemCount => _items.length;

  // Read-only list of items (copies to avoid external mutation)
  List<CartItem> get items =>
      _items.values.map((it) => CartItem(it.sandwich, it.quantity)).toList();

  // Total price calculated/maintained using PricingRepository
  double get totalPrice => _totalPrice;
}
