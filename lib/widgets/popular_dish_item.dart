import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopularDishItem extends StatelessWidget {
  final String image;
  final String name;

  const PopularDishItem({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // IMAGE WITH ORANGE BORDER
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFFFF8C2B), width: 2),
              ),
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  Image.network(
                    image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),

                  /// 🔥 DULL OVERLAY (KEY PART)
                  Container(
                    width: 56,
                    height: 56,
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
              ),
            ),
          ),

          /// WHITE TEXT (CLEAR & READABLE)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
