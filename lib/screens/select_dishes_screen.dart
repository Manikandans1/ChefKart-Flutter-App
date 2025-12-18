import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../viewmodels/dishes_viewmodel.dart';
import '../widgets/category_chip.dart';
import '../widgets/popular_dish_item.dart';
import '../widgets/dish_card.dart';

class SelectDishesScreen extends StatelessWidget {
  const SelectDishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishesViewModel>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: const BackButton(color: Colors.black),
            title: const Text(
              "Select Dishes",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),

          /// BLACK STRIP + DATE CARD
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(height: 40, color: Colors.black),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 18, color: AppColors.orange),
                        const SizedBox(width: 15),
                        const Text("21 May 2021",
                            style: TextStyle(fontSize: 13)),
                        Container(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 32),
                          width: 1,
                          height: 20,
                          color: AppColors.grey,
                        ),
                        const Icon(Icons.access_time,
                            size: 18, color: AppColors.orange),
                        const SizedBox(width: 6),
                        const Text("10:30 PM - 12:30 PM",
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// CATEGORY CHIPS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CategoryChip(text: "Italian", selected: true),
                    CategoryChip(text: "Indian", selected: false),
                    CategoryChip(text: "Indian", selected: false),
                    CategoryChip(text: "Indian", selected: false),
                    CategoryChip(text: "Indian", selected: false),
                  ],
                ),
              ),
            ),
          ),

          /// POPULAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Popular Dishes",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 72,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.popularDishes.length,
                      itemBuilder: (_, i) {
                        final dish = vm.popularDishes[i];

                        return PopularDishItem(
                          image: dish.image, // ✅ FROM API
                          name: dish.name,   // ✅ FROM API
                        );
                      },
                    ),
                  ),


                ],
              ),
            ),
          ),

          /// RECOMMENDED HEADER
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text("Recommended",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  Container(
                    height: 28,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text("Menu",
                          style: TextStyle(
                              fontSize: 12, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// DISH LIST
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, i) {
                  final d = vm.dishes[i];
                  return DishCard(
                    dish: d,
                    qty: vm.qty(d.id),
                    onAdd: () => vm.add(d.id),
                    onRemove: () => vm.remove(d.id),
                  );
                },
                childCount: vm.dishes.length,
              ),
            ),
          ),
        ],
      ),

      /// BOTTOM CART BAR
      bottomNavigationBar: vm.totalItems == 0
          ? null
          : Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), // 👈 key change
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius:
            BorderRadius.all(Radius.circular(16)), // keep same feel
          ),
          child: Row(
            children: [
              // const Icon(Icons.shopping_bag, color: Colors.white),
              Image.asset(
                'assets/icons/cart.png', // your icon path
                width: 22,
                height: 22,
                color: Colors.white, // keeps white like before
              ),

              const SizedBox(width: 8),
              Text(
                "${vm.totalItems} food items selected",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
