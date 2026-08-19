import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:wereat/core/router/app_routes.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/widgets/user_avatar.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';
import 'package:wereat/features/map/presentation/providers/friends_provider.dart';
import 'package:wereat/features/map/presentation/providers/location_provider.dart';
import 'package:wereat/features/map/presentation/providers/places_provider.dart';
import 'package:wereat/features/map/presentation/widgets/category_filter_chips.dart';
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
    final places = ref.watch(filteredPlacesProvider);
    final friends = ref.watch(groupFriendsProvider);
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
              children: [
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    AppColors.coral400,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    'assets/branding/wereat-isotype.svg',
                    height: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'wereat',
                  style: GoogleFonts.fraunces(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: AppColors.gray900,
                    letterSpacing: -0.02 * 22,
                  ),
                ),
                const Spacer(),
                _NotificationBell(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notificaciones: próximamente'),
                    ),
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
            Text(
              'Hola${_greetingName(user?.displayName)}',
              style: textTheme.titleLarge?.copyWith(fontSize: 22),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'Descubre y guarda los mejores lugares con tu gente.',
              style: textTheme.bodySmall?.copyWith(color: AppColors.gray400),
            ),
            const SizedBox(height: AppSpacing.sm),
            const CategoryFilterChips(),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.gray100, width: 0.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: locationAsync.when(
                    data: (position) => PlacesMapView(
                      places: places,
                      friends: friends,
                      userLocation: position == null
                          ? null
                          : LatLng(position.latitude, position.longitude),
                      onGroupTap: () => context.go(AppRoutes.groups),
                    ),
                    loading: () => const ColoredBox(
                      color: Colors.white,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) =>
                        PlacesMapView(places: places, friends: friends),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Actividad del grupo',
                  style: textTheme.titleLarge?.copyWith(fontSize: 17),
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.list),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.coral400,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Ver todo'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (places.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  'Nadie ha agregado lugares de esta categoría todavía.',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.gray400,
                  ),
                ),
              )
            else
              IntrinsicHeight(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (index, place) in places.indexed) ...[
                        if (index > 0) const SizedBox(width: AppSpacing.md),
                        PlaceCard(place: place),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gray100, width: 0.5),
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 20,
              color: AppColors.gray900,
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.coral400,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
