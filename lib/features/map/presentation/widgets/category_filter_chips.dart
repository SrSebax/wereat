import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/features/map/domain/entities/place.dart';
import 'package:wereat/features/map/domain/entities/place_category_style.dart';
import 'package:wereat/features/map/presentation/providers/category_filter_provider.dart';

class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(categoryFilterProvider);

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _Chip(
            label: 'Todos',
            icon: Icons.apps_rounded,
            accent: AppColors.coral400,
            selected: selected == null,
            onTap: () => ref.read(categoryFilterProvider.notifier).select(null),
          ),
          const SizedBox(width: 8),
          for (final category in PlaceCategory.values) ...[
            _Chip(
              label: category.pluralLabel,
              icon: category.icon,
              accent: category.accent,
              selected: selected == category,
              onTap: () =>
                  ref.read(categoryFilterProvider.notifier).select(category),
            ),
            const SizedBox(width: 8),
          ],
          _Chip(
            label: 'Más',
            icon: Icons.more_horiz,
            accent: AppColors.gray600,
            selected: false,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Más categorías: próximamente')),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? accent : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: selected
                ? null
                : Border.all(color: AppColors.gray200, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: selected ? Colors.white : accent),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.gray900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
