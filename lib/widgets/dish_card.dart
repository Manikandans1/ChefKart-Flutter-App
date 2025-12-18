import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/dish.dart';
import '../screens/dish_detail_screen.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const DishCard({
    super.key,
    required this.dish,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// DISH NAME
                Text(
                  dish.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                /// VEG ICON + RATING
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${dish.rating} ★",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// EQUIPMENTS | INGREDIENTS | VIEW LIST
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT: EQUIPMENTS
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: dish.equipments.take(2).map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.kitchen,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    /// DIVIDER |
                    Container(
                      height: 14,
                      width: 1,
                      margin:
                      const EdgeInsets.symmetric(horizontal: 6),
                      color: Colors.grey.shade300,
                    ),

                    /// RIGHT: INGREDIENTS + VIEW LIST
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),

                        const SizedBox(height: 2),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DishDetailScreen(
                                  dishId: dish.id,
                                  image: dish.image, // ✅ PASS IMAGE
                                ),
                              ),
                            );

                          },
                          child: Row(
                            children: const [
                              Text(
                                "View List",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.orange,
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 11,
                                color: AppColors.orange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                /// DESCRIPTION
                Text(
                  dish.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT IMAGE + ADD / COUNTER
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  dish.image,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                bottom: 6,
                child: qty == 0 ? _addButton() : _counter(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ADD BUTTON
  Widget _addButton() {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        height: 26,
        width: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.orange),
        ),
        child: const Center(
          child: Text(
            "Add",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.orange,
            ),
          ),
        ),
      ),
    );
  }

  /// COUNTER (+ / -)
  Widget _counter() {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.orange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.remove, size: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              qty.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAdd,
            child: const Icon(
              Icons.add,
              size: 16,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
