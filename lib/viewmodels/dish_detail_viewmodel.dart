import 'package:flutter/material.dart';
import '../models/dish_detail.dart';
import '../services/dishes_api_service.dart';

class DishDetailViewModel extends ChangeNotifier {
  final _api = DishesApiService();

  DishDetail? detail;
  bool isLoading = false;
  String? error;

  Future<void> loadDetail(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      detail = await _api.fetchDishDetail(id);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
