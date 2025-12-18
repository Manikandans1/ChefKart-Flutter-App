import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../models/dish_detail.dart';
import '../viewmodels/dish_detail_viewmodel.dart';

/// ================== MAIN SCREEN ==================
class DishDetailScreen extends StatelessWidget {
  final int dishId;
  final String image;

  const DishDetailScreen({
    super.key,
    required this.dishId,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DishDetailViewModel()..loadDetail(dishId),
      child: _DishDetailView(image: image),
    );
  }
}

/// ================== VIEW ==================
class _DishDetailView extends StatelessWidget {
  final String image;

  const _DishDetailView({required this.image});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishDetailViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _Body(
        detail: vm.detail!,
        image: image,
      ),
    );
  }
}

/// ================== BODY ==================
class _Body extends StatelessWidget {
  final DishDetail detail;
  final String image;

  const _Body({
    required this.detail,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(detail, image),
          const SizedBox(height: 24),
          _IngredientsSection(detail.ingredients),
          const SizedBox(height: 24),
          _AppliancesSection(detail.ingredients.appliances),
        ],
      ),
    );
  }
}

/// ================== HEADER ==================
class _Header extends StatelessWidget {
  final DishDetail detail;
  final String image;

  const _Header(this.detail, this.image);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -60,
          top: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF4EA),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        detail.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "4.2",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Mughlai Masala is a style of cookery developed in the Indian Subcontinent by the imperial kitchens of the Mughal Empire.",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        detail.timeToPrepare,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fastfood, size: 40),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ================== INGREDIENTS ==================
class _IngredientsSection extends StatelessWidget {
  final Ingredients ingredients;

  const _IngredientsSection(this.ingredients);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ingredients",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          "For 2 people",
          style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
        ),
        const Divider(height: 24),
        _ExpandableList(
          title: "Vegetables (${ingredients.vegetables.length})",
          items: ingredients.vegetables,
        ),
        _ExpandableList(
          title: "Spices (${ingredients.spices.length})",
          items: ingredients.spices,
        ),
      ],
    );
  }
}

/// ================== EXPANDABLE LIST ==================
class _ExpandableList extends StatefulWidget {
  final String title;
  final List<IngredientItem> items;

  const _ExpandableList({
    required this.title,
    required this.items,
  });

  @override
  State<_ExpandableList> createState() => _ExpandableListState();
}

class _ExpandableListState extends State<_ExpandableList> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => expanded = !expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          ...widget.items.map(
                (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(e.name,
                        style: const TextStyle(fontSize: 13)),
                  ),
                  Text(
                    e.quantity,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.darkGrey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
/// ================== APPLIANCES ==================
class _AppliancesSection extends StatelessWidget {
  final List<Appliance> appliances;

  const _AppliancesSection(this.appliances);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Appliances",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: appliances.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final a = appliances[i]; // ✅ NOW a IS DEFINED

              return Container(
                width: 90,
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.kitchen,
                      size: 32,
                      color: Colors.black87,
                    ),

                    const SizedBox(height: 0),

                    Expanded(
                      child: Center(
                        child: Text(
                          a.name, // ✅ SAFE NOW
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
