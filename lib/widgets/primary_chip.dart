import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const PrimaryChip({super.key, required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 34,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFF4EC) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Colors.deepOrange : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.deepOrange : Colors.grey,
          ),
        ),
      ),
    );
  }
}
