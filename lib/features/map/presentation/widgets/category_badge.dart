import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/features/map/domain/entities/place.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final PlaceCategory category;

  ({String label, Color background, Color foreground}) get _style {
    switch (category) {
      case PlaceCategory.restaurant:
        return (
          label: 'Restaurante',
          background: AppColors.amber50,
          foreground: AppColors.amber600,
        );
      case PlaceCategory.cafe:
        return (
          label: 'Cafetería',
          background: AppColors.amber50,
          foreground: AppColors.amber600,
        );
      case PlaceCategory.bar:
        return (
          label: 'Bar',
          background: AppColors.amber50,
          foreground: AppColors.amber600,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: style.foreground,
        ),
      ),
    );
  }
}
