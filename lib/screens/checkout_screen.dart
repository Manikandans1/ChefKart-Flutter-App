import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/dishes_viewmodel.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishesViewModel>();
    final dishes =
    vm.dishes.where((d) => vm.quantityForDish(d.id) > 0).toList();

    double total =
    dishes.fold(0, (p, d) => p + vm.quantityForDish(d.id) * 120.0);

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dishes.length,
                itemBuilder: (c, i) {
                  final d = dishes[i];
                  final q = vm.quantityForDish(d.id);
                  return ListTile(
                    title: Text(d.name),
                    subtitle: Text("Qty: $q"),
                    trailing:
                    Text("₹${(q * 120).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("₹${total.toStringAsFixed(2)}",
                    style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              // icon: const Icon(Icons.payment),
              // label: const Text("Pay & Confirm Order"),
              icon: const Icon(Icons.payment, color: Colors.white), // white icon
              label: const Text(
                "Pay & Confirm Order",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600), // white text
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Order Confirmed!"),
                    content:
                    const Text("Your payment was successful."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          vm.clearCart(); // clears cart
                          Navigator.popUntil(context, (r) => r.isFirst);
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
