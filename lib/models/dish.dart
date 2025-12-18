class Dish {
  final int id;
  final String name;
  final double rating;
  final String description;
  final String image;
  final List<String> equipments;

  Dish({
    required this.id,
    required this.name,
    required this.rating,
    required this.description,
    required this.image,
    required this.equipments,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      rating: (json['rating'] as num).toDouble(),
      description: json['description'],
      image: json['image'],
      equipments: List<String>.from(json['equipments'] ?? []),
    );
  }
}
