import 'package:flutter/material.dart';
import '../models/dish_list_response.dart';
import '../services/dish_api_service.dart';

class DishesViewModel extends ChangeNotifier {
  final DishApiService api;
  bool _isLoading = false;
  String? _errorMessage;
  List<Dish> _dishes = [];
  List<PopularDish> _popular = [];
  String _searchQuery = '';

  // cart
  final Map<int, int> _cart = {};

  // Date and Time selection
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  DishesViewModel(this.api);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Dish> get dishes {
    if (_searchQuery.isEmpty) return _dishes;
    return _dishes
        .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<PopularDish> get popularDishes => _popular;
  int get totalItemsSelected =>
      _cart.values.fold<int>(0, (prev, q) => prev + q);
  int quantityForDish(int id) => _cart[id] ?? 0;
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;

  Future<void> loadDishes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final res = await api.fetchDishes();
      _dishes = res.dishes;
      _popular = res.popularDishes;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addToCart(int id) {
    _cart[id] = (_cart[id] ?? 0) + 1;
    notifyListeners();
  }

  void updateQuantity(int id, int q) {
    if (q <= 0) _cart.remove(id);
    else _cart[id] = q;
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void setDate(DateTime d) {
    _selectedDate = d;
    notifyListeners();
  }

  void setTime(TimeOfDay t) {
    _selectedTime = t;
    notifyListeners();
  }
}
