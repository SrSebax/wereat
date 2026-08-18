import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/core/theme/app_spacing.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.coral50,
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColors.coral600),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.coral600),
            ),
          ),
        ],
      ),
    );
  }
}
