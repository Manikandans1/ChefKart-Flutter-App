import 'package:flutter/material.dart';

class ApplianceCard extends StatelessWidget {
  final String name;

  const ApplianceCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.25;

    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Icon(Icons.kitchen, size: 32),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
