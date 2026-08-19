import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';

/// Avatar circular de un amigo, usado como marcador en el mapa.
class FriendMarker extends StatelessWidget {
  const FriendMarker({super.key, required this.avatarUrl});

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.gray100,
        backgroundImage: NetworkImage(avatarUrl),
      ),
    );
  }
}
