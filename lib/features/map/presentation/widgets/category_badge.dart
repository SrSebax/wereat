import 'package:flutter/material.dart';
import 'package:wereat/features/map/domain/entities/place.dart';
import 'package:wereat/features/map/domain/entities/place_category_style.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final PlaceCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: category.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        category.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: category.foreground,
        ),
      ),
    );
  }
}
