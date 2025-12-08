import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dishes_viewmodel.dart';
import '../widgets/dish_card.dart';
import '../widgets/primary_chip.dart';
import 'dish_detail_screen.dart';
import 'checkout_screen.dart';

class SelectDishesScreen extends StatelessWidget {
  const SelectDishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishesViewModel>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.loadDishes,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'Select Dishes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildDateTimeSelector(context, vm)),
              SliverToBoxAdapter(child: _buildCuisineChips(context)),
              SliverToBoxAdapter(child: _buildPopularSection(context)),
              SliverToBoxAdapter(child: _buildRecommendedHeader(context)),
              SliverToBoxAdapter(child: _buildSearchField(context)),
              _buildRecommendedList(context, vm),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: vm.totalItemsSelected == 0
          ? null
          : _buildCartBar(context, vm.totalItemsSelected),
    );
  }

  Widget _buildDateTimeSelector(BuildContext context, DishesViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: vm.selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime: vm.selectedTime,
            );
            if (time != null) {
              vm.setDate(date);
              vm.setTime(time);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                "${vm.selectedDate.day}/${vm.selectedDate.month}/${vm.selectedDate.year}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 6),
              Text(
                vm.selectedTime.format(context),
                style: const TextStyle(
                    color: Colors.deepOrange, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCuisineChips(BuildContext context) {
    final cuisines = ['Italian', 'Indian', 'Chinese', 'Mexican'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: cuisines.length,
          itemBuilder: (context, index) {
            return PrimaryChip(
              label: cuisines[index],
              selected: index == 0,
              onTap: () {},
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopularSection(BuildContext context) {
    final vm = context.watch<DishesViewModel>();
    if (vm.popularDishes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Popular Dishes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: vm.popularDishes.map((dish) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(left: 16, right: 4),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(dish.image),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dish.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRecommendedHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Recommended',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          Row(
            children: const [
              Text('Menu', style: TextStyle(fontWeight: FontWeight.w600)),
              Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final vm = context.read<DishesViewModel>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        onChanged: vm.setSearchQuery,
        decoration: InputDecoration(
          hintText: "Search dishes",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }

  Widget _buildRecommendedList(BuildContext ctx, DishesViewModel vm) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: vm.isLoading
          ? const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()))
          : SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, i) {
            final d = vm.dishes[i];
            final q = vm.quantityForDish(d.id);
            return DishCard(
              dish: d,
              quantity: q,
              onTap: () => Navigator.pushNamed(context, '/dish-detail',
                  arguments: d),
              onAdd: () => vm.addToCart(d.id),
              onIncrement: () => vm.updateQuantity(d.id, q + 1),
              onDecrement: () => vm.updateQuantity(d.id, q - 1),
            );
          },
          childCount: vm.dishes.length,
        ),
      ),
    );
  }

  Widget _buildCartBar(BuildContext context, int count) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
      ),
      child: Container(
        height: 56,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "$count item${count > 1 ? 's' : ''} • Proceed to Pay",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
