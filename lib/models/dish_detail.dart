class DishDetail {
  final String name;
  final int id;
  final String timeToPrepare;
  final Ingredients ingredients;

  DishDetail({
    required this.name,
    required this.id,
    required this.timeToPrepare,
    required this.ingredients,
  });

  factory DishDetail.fromJson(Map<String, dynamic> json) {
    return DishDetail(
      name: json['name'] as String,
      id: json['id'] as int,
      timeToPrepare: json['timeToPrepare'] as String,
      ingredients:
      Ingredients.fromJson(json['ingredients'] as Map<String, dynamic>),
    );
  }
}

class Ingredients {
  final List<IngredientItem> vegetables;
  final List<IngredientItem> spices;
  final List<Appliance> appliances;

  Ingredients({
    required this.vegetables,
    required this.spices,
    required this.appliances,
  });

  factory Ingredients.fromJson(Map<String, dynamic> json) {
    return Ingredients(
      vegetables: (json['vegetables'] as List<dynamic>)
          .map((e) => IngredientItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      spices: (json['spices'] as List<dynamic>)
          .map((e) => IngredientItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      appliances: (json['appliances'] as List<dynamic>)
          .map((e) => Appliance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IngredientItem {
  final String name;
  final String quantity;

  IngredientItem({
    required this.name,
    required this.quantity,
  });

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    return IngredientItem(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
    );
  }
}

class Appliance {
  final String name;
  final String image; // empty string in API, but kept for extensibility

  Appliance({
    required this.name,
    required this.image,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      name: json['name'] as String,
      image: (json['image'] ?? '') as String,
    );
  }
}
