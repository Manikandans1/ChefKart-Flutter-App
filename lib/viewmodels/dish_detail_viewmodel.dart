import 'package:flutter/material.dart';

import '../models/dish_detail.dart';
import '../services/dish_api_service.dart';

class DishDetailViewModel extends ChangeNotifier {
  final DishApiService api;
  final int dishId;

  bool _isLoading = false;
  String? _errorMessage;
  DishDetail? _detail;

  DishDetailViewModel(this.api, {required this.dishId}) {
    loadDetail();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DishDetail? get detail => _detail;

  Future<void> loadDetail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _detail = await api.fetchDishDetail(dishId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
