class PopularDish {
  final int id;
  final String name;
  final String image;

  PopularDish({
    required this.id,
    required this.name,
    required this.image,
  });

  factory PopularDish.fromJson(Map<String, dynamic> json) {
    return PopularDish(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
