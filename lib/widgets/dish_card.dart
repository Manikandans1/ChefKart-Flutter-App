import 'package:flutter/material.dart';
import '../models/dish_list_response.dart';
import 'rating_chip.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  final int quantity;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const DishCard({
    super.key,
    required this.dish,
    required this.quantity,
    required this.onTap,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      // tap whole card → details
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- Left info ----------
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(dish.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingChip(rating: dish.rating),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 3),
                      const Text('30 min',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (dish.equipments.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: dish.equipments.map((equip) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.kitchen,
                                  size: 12, color: Colors.deepOrange),
                              const SizedBox(width: 3),
                              Text(equip,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 6),
                  Text(dish.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade700)),
                ],
              ),
            ),
            const SizedBox(width: 12),

            /// ---------- Right image + button ----------
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Image.network(dish.image, fit: BoxFit.cover),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: GestureDetector(
                            // This ensures tap inside button doesn't trigger card tap
                            behavior: HitTestBehavior.opaque,
                            onTap: () {},
                            child: _buildAnimatedButton(colorScheme),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Animated Add / Quantity section
  Widget _buildAnimatedButton(ColorScheme scheme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: quantity == 0
          ? _buildAddButton(scheme, const ValueKey('add'))
          : _buildQtyBox(scheme, const ValueKey('qty')),
    );
  }

  Widget _buildAddButton(ColorScheme scheme, Key key) {
    return Container(
      key: key,
      height: 34,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.primary, width: 1.2),
      ),
      alignment: Alignment.center,
      // Only this tap triggers add
      child: GestureDetector(
        onTap: onAdd,
        child: const Text(
          'Add',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildQtyBox(ColorScheme scheme, Key key) {
    return Container(
      key: key,
      height: 34,
      width: 90,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onDecrement,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(Icons.remove, color: Colors.white, size: 18),
              )),
          Text('$quantity',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onIncrement,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Icon(Icons.add, color: Colors.white, size: 18),
              )),
        ],
      ),
    );
  }
}
