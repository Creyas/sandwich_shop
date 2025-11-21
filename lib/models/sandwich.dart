enum BreadType { white, wheat, wholemeal }

enum SandwichType {
  veggieDelight,
  chickenTeriyaki,
  tunaMelt,
  meatballMarinara,
}

class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  // New fields to support JSON data
  final String id;
  final String? displayName;
  final String? description;
  final bool available;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
    String? id,
    this.displayName,
    this.description,
    this.available = true,
  }) : id = id ?? type.name;

  // Create from JSON coming from assets/sandwiches.json
  factory Sandwich.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String? name = json['name'] as String?;
    final String? description = json['description'] as String?;
    final bool available = json['available'] as bool? ?? true;

    final SandwichType type = _typeFromId(id);

    // The size and bread aren't present in the JSON catalog; default them.
    return Sandwich(
      type: type,
      isFootlong: false,
      breadType: BreadType.white,
      id: id,
      displayName: name,
      description: description,
      available: available,
    );
  }

  static SandwichType _typeFromId(String id) {
    switch (id) {
      case 'veggie_delight':
        return SandwichType.veggieDelight;
      case 'chicken_teriyaki':
        return SandwichType.chickenTeriyaki;
      case 'tuna_melt':
        return SandwichType.tunaMelt;
      case 'meatball_marinara':
        return SandwichType.meatballMarinara;
      default:
        // fallback if JSON contains an unexpected id
        return SandwichType.veggieDelight;
    }
  }

  String get name {
    if (displayName != null) return displayName!;
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    String typeString = type.name;
    String sizeString = isFootlong ? 'footlong' : 'six_inch';
    return 'assets/images/${typeString}_$sizeString.png';
  }
}
