import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dish_detail.dart';
import '../models/dish_list_response.dart';
import '../viewmodels/dish_detail_viewmodel.dart';
import '../viewmodels/dishes_viewmodel.dart';
import '../widgets/appliance_card.dart';
import '../widgets/rating_chip.dart';

class DishDetailScreen extends StatelessWidget {
  static const String routeName = '/dish-detail';

  final Dish dish;

  const DishDetailScreen({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishDetailViewModel>();
    final cartVm = context.watch<DishesViewModel>();
    final quantity = cartVm.quantityForDish(dish.id);

    return Scaffold(
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
            ? _buildError(context, vm)
            : _buildContent(context, vm, quantity),
      ),
    );
  }

  Widget _buildError(BuildContext context, DishDetailViewModel vm) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Failed to load dish details'),
          const SizedBox(height: 8),
          Text(
            vm.errorMessage ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: vm.loadDetail,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, DishDetailViewModel vm, int quantity) {
    final detail = vm.detail!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Row(
            children: const [
              BackButton(),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & hero image row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTitle(detail),
                    ),
                    const SizedBox(width: 12),
                    Hero(
                      tag: 'dish_image_${dish.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Image.network(
                            dish.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTime(colorScheme, detail.timeToPrepare),
                const SizedBox(height: 24),
                _buildIngredientsSection(context, detail),
                const SizedBox(height: 24),
                _buildAppliances(detail),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        _buildBottomAddBar(context, quantity),
      ],
    );
  }

  Widget _buildTitle(DishDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        RatingChip(rating: 4.2), // rating is only in list API
        const SizedBox(height: 10),
        const Text(
          'Mughlai Masala is a style of cookery developed in the Indian Subcontinent by the imperial kitchens of the Mughal Empire.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildTime(ColorScheme colorScheme, String time) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 18),
        const SizedBox(width: 8),
        Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context, DishDetail detail) {
    final ingredients = detail.ingredients;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'For 2 people',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        _ExpandableIngredientList(
          title: 'Vegetables (${ingredients.vegetables.length.toString().padLeft(2, '0')})',
          items: ingredients.vegetables,
        ),
        const SizedBox(height: 12),
        _ExpandableIngredientList(
          title: 'Spices (${ingredients.spices.length.toString().padLeft(2, '0')})',
          items: ingredients.spices,
        ),
      ],
    );
  }

  Widget _buildAppliances(DishDetail detail) {
    final apps = detail.ingredients.appliances;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Appliances',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: apps.length,
            itemBuilder: (context, index) {
              return ApplianceCard(name: apps[index].name);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAddBar(BuildContext context, int quantity) {
    final vm = context.read<DishesViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Text(
            'Add to cart',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                IconButton(
                  iconSize: 18,
                  onPressed: () {
                    final newQty = quantity - 1;
                    vm.updateQuantity(dish.id, newQty);
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  iconSize: 18,
                  onPressed: () {
                    final newQty = quantity + 1;
                    vm.updateQuantity(dish.id, newQty);
                  },
                  icon: Icon(Icons.add, color: colorScheme.primary),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ExpandableIngredientList extends StatefulWidget {
  final String title;
  final List<IngredientItem> items;

  const _ExpandableIngredientList({
    required this.title,
    required this.items,
  });

  @override
  State<_ExpandableIngredientList> createState() =>
      _ExpandableIngredientListState();
}

class _ExpandableIngredientListState extends State<_ExpandableIngredientList> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              )
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (_expanded)
          Column(
            children: widget.items
                .map(
                  (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.name,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      e.quantity,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .toList(),
          )
      ],
    );
  }
}
