import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:wereat/core/router/app_routes.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/widgets/user_avatar.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';
import 'package:wereat/features/map/presentation/providers/location_provider.dart';
import 'package:wereat/features/map/presentation/providers/places_provider.dart';
import 'package:wereat/features/map/presentation/widgets/place_card.dart';
import 'package:wereat/features/map/presentation/widgets/places_map_view.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  String _greetingName(String? displayName) {
    final name = displayName?.trim();
    if (name == null || name.isEmpty) return '';
    return ', ${name.split(RegExp(r'\s+')).first}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final places = ref.watch(groupPlacesProvider);
    final locationAsync = ref.watch(userLocationProvider);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    AppColors.coral400,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    'assets/branding/wereat-isotype.svg',
                    height: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola${_greetingName(user?.displayName)}',
                        style: textTheme.titleLarge?.copyWith(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Tus lugares favoritos, en un mapa',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.gray400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.profile),
                  child: UserAvatar(
                    displayName: user?.displayName,
                    email: user?.email,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: locationAsync.when(
                data: (position) => PlacesMapView(
                  places: places,
                  userLocation: position == null
                      ? null
                      : LatLng(position.latitude, position.longitude),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => PlacesMapView(places: places),
              ),
            ),
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
