import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/dish_list_response.dart';
import '../models/dish_detail.dart';

class DishApiService {
  static const String _baseUrl =
      'https://8b648f3c-b624-4ceb-9e7b-8028b7df0ad0.mock.pstmn.io/dishes/v1';

  final http.Client _client;

  DishApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<DishListResponse> fetchDishes() async {
    final uri = Uri.parse('$_baseUrl/');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      return DishListResponse.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load dishes: ${response.statusCode}');
    }
  }

  Future<DishDetail> fetchDishDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      return DishDetail.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load dish detail: ${response.statusCode}');
    }
  }
}
