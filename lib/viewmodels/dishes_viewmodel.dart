import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../models/popular_dish.dart';
import '../services/dishes_api_service.dart';

class DishesViewModel extends ChangeNotifier {
  final _api = DishesApiService();

  List<Dish> dishes = [];
  List<PopularDish> popularDishes = [];
  Map<int, int> cart = {};

  bool isLoading = false;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _api.fetchDishes();
      dishes = result.$1;
      popularDishes = result.$2;
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  int qty(int id) => cart[id] ?? 0;

  void add(int id) {
    cart[id] = qty(id) + 1;
    notifyListeners();
  }

  void remove(int id) {
    if (qty(id) > 1) {
      cart[id] = qty(id) - 1;
    } else {
      cart.remove(id);
    }
    notifyListeners();
  }

  int get totalItems =>
      cart.values.fold(0, (sum, e) => sum + e);
}
