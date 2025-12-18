import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/dishes_viewmodel.dart';
import 'screens/select_dishes_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DishesViewModel()..loadData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SelectDishesScreen(),
    );
  }
}
