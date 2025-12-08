import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/dish_api_service.dart';
import 'viewmodels/dishes_viewmodel.dart';
import 'viewmodels/dish_detail_viewmodel.dart';
import 'screens/select_dishes_screen.dart';
import 'screens/dish_detail_screen.dart';
import 'models/dish_list_response.dart';

void main() {
  runApp(const ChefKartApp());
}

class ChefKartApp extends StatelessWidget {
  const ChefKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = DishApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DishesViewModel(api)..loadDishes(),
        ),
        // DishDetailViewModel is created on demand via Provider.value in route
      ],
      child: MaterialApp(
        title: 'ChefKart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6F00), // accent orange
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case DishDetailScreen.routeName:
              final args = settings.arguments as Dish;
              return MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (_) => DishDetailViewModel(api, dishId: args.id),
                  child: DishDetailScreen(dish: args),
                ),
              );
            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => const SelectDishesScreen(),
              );
          }
        },
      ),
    );
  }
}
