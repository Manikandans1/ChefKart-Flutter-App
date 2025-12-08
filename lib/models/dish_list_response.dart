class DishListResponse {
  final List<Dish> dishes;
  final List<PopularDish> popularDishes;

  DishListResponse({
    required this.dishes,
    required this.popularDishes,
  });

  factory DishListResponse.fromJson(Map<String, dynamic> json) {
    return DishListResponse(
      dishes: (json['dishes'] as List<dynamic>)
          .map((e) => Dish.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularDishes: (json['popularDishes'] as List<dynamic>)
          .map((e) => PopularDish.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Dish {
  final String name;
  final double rating;
  final String description;
  final List<String> equipments;
  final String image;
  final int id;

  Dish({
    required this.name,
    required this.rating,
    required this.description,
    required this.equipments,
    required this.image,
    required this.id,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
      equipments:
      (json['equipments'] as List<dynamic>).map((e) => e as String).toList(),
      image: json['image'] as String,
      id: json['id'] as int,
    );
  }
}

class PopularDish {
  final String name;
  final String image;
  final int id;

  PopularDish({
    required this.name,
    required this.image,
    required this.id,
  });

  factory PopularDish.fromJson(Map<String, dynamic> json) {
    return PopularDish(
      name: json['name'] as String,
      image: json['image'] as String,
      id: json['id'] as int,
    );
  }
}
