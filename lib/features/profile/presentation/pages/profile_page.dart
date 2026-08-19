import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/core/widgets/user_avatar.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(signOutProvider)(const NoParams());
    if (!context.mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: UserAvatar(
                displayName: user?.displayName,
                email: user?.email,
                radius: 36,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              user?.displayName ?? 'Tu perfil',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            if (user?.email != null) ...[
              const SizedBox(height: 4),
              Text(
                user!.email!,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(color: AppColors.gray400),
              ),
            ],
            const Spacer(),
            OutlinedButton(
              onPressed: () => _signOut(context, ref),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
