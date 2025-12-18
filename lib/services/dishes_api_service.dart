import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dish.dart';
import '../models/popular_dish.dart';
import '../models/dish_detail.dart';

class DishesApiService {
  static const _baseUrl =
      'https://8b648f3c-b624-4ceb-9e7b-8028b7df0ad0.mock.pstmn.io';

  Future<(List<Dish>, List<PopularDish>)> fetchDishes() async {
    final res = await http.get(Uri.parse('$_baseUrl/dishes/v1'));

    if (res.statusCode != 200) {
      throw Exception('Failed to load dishes');
    }

    final data = json.decode(res.body);

    final dishes = (data['dishes'] as List)
        .map((e) => Dish.fromJson(e))
        .toList();

    final popular = (data['popularDishes'] as List)
        .map((e) => PopularDish.fromJson(e))
        .toList();

    return (dishes, popular);
  }

  Future<DishDetail> fetchDishDetail(int id) async {
    final res =
    await http.get(Uri.parse('$_baseUrl/dishes/v1/$id'));

    if (res.statusCode != 200) {
      throw Exception('Failed to load dish detail');
    }

    return DishDetail.fromJson(json.decode(res.body));
  }
}
