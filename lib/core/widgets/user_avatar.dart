import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.displayName,
    required this.email,
    this.radius = 20,
  });

  final String? displayName;
  final String? email;
  final double radius;

  String get _initials {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
      return letters;
    }
    final mail = email?.trim();
    if (mail != null && mail.isNotEmpty) return mail[0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.coral200, width: 1.5),
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.coral200,
        child: Text(
          _initials,
          style: TextStyle(
            color: AppColors.coral900,
            fontWeight: FontWeight.w600,
            fontSize: radius * 0.75,
          ),
        ),
      ),
    );
  }
}
