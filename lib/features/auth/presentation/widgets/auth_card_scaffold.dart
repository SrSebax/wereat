import 'package:flutter/material.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/core/theme/app_spacing.dart';

/// Layout compartido de las pantallas secundarias de auth (registro,
/// recuperar contraseña): AppBar simple + card blanca elevada sobre el
/// fondo cream, mismo lenguaje visual que el login.
class AuthCardScaffold extends StatelessWidget {
  const AuthCardScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(backgroundColor: AppColors.cream, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            32,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card * 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gray900.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
