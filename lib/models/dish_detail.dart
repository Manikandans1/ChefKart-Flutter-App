class DishDetail {
  final int id;
  final String name;
  final String timeToPrepare;
  final Ingredients ingredients;

  DishDetail({
    required this.id,
    required this.name,
    required this.timeToPrepare,
    required this.ingredients,
  });

  factory DishDetail.fromJson(Map<String, dynamic> json) {
    return DishDetail(
      id: json['id'],
      name: json['name'],
      timeToPrepare: json['timeToPrepare'],
      ingredients: Ingredients.fromJson(json['ingredients']),
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
      vegetables: (json['vegetables'] as List)
          .map((e) => IngredientItem.fromJson(e))
          .toList(),
      spices: (json['spices'] as List)
          .map((e) => IngredientItem.fromJson(e))
          .toList(),
      appliances: (json['appliances'] as List)
          .map((e) => Appliance.fromJson(e))
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
      name: json['name'],
      quantity: json['quantity'],
    );
  }
}

class Appliance {
  final String name;
  final String image;

  Appliance({
    required this.name,
    required this.image,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      name: json['name'],
      image: json['image'],
    );
  }
}
