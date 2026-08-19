import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/widgets/user_avatar.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';
import 'package:wereat/features/map/presentation/providers/places_provider.dart';
import 'package:wereat/features/map/presentation/widgets/map_placeholder.dart';
import 'package:wereat/features/map/presentation/widgets/place_card.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final places = ref.watch(groupPlacesProvider);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'wereat',
                  style: GoogleFonts.fraunces(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    color: AppColors.coral400,
                    letterSpacing: -0.02 * 26,
                  ),
                ),
                UserAvatar(displayName: user?.displayName, email: user?.email),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Expanded(child: MapPlaceholder()),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Agregados por tu grupo',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.gray400),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 118,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: places.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) =>
                    PlaceCard(place: places[index]),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
