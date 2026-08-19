import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/core/utils/time_ago.dart';
import 'package:wereat/features/map/domain/entities/place.dart';
import 'package:wereat/features/map/presentation/widgets/category_badge.dart';

/// Card sin foto para la actividad del grupo: nombre, quién y cuándo lo
/// agregó, y su categoría.
class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.gray100, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            place.name,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.gray900,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            place.addedByLabel,
            style: textTheme.bodySmall?.copyWith(color: AppColors.gray400),
          ),
          const SizedBox(height: 10),
          CategoryBadge(category: place.category),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 9,
                backgroundColor: AppColors.gray100,
                backgroundImage: place.addedByAvatarUrl == null
                    ? null
                    : NetworkImage(place.addedByAvatarUrl!),
              ),
              const SizedBox(width: 6),
              if (place.addedAt != null)
                Text(
                  timeAgo(place.addedAt!),
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.gray400,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
