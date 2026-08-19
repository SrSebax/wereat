import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/features/map/domain/entities/friend.dart';

/// Card flotante con los avatares del grupo apilados y cuántos están
/// explorando el mapa ahora.
class GroupExplorersCard extends StatelessWidget {
  const GroupExplorersCard({super.key, required this.friends});

  final List<Friend> friends;

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18.0 * (friends.length.clamp(1, 4)) + 6,
            height: 26,
            child: Stack(
              children: [
                for (final (index, friend) in friends.take(4).indexed)
                  Positioned(
                    left: index * 18.0,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: AppColors.gray100,
                        backgroundImage: NetworkImage(friend.avatarUrl),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${friends.length} amigos explorando',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
