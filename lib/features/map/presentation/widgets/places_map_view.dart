import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/features/map/domain/entities/friend.dart';
import 'package:wereat/features/map/domain/entities/place.dart';
import 'package:wereat/features/map/domain/entities/place_category_style.dart';
import 'package:wereat/features/map/presentation/widgets/friend_marker.dart';
import 'package:wereat/features/map/presentation/widgets/group_explorers_card.dart';
import 'package:wereat/features/map/presentation/widgets/map_overlay_pill.dart';

/// Centro por defecto (Medellín) cuando no hay lugares ni ubicación del
/// usuario para centrar el mapa.
const _defaultCenter = LatLng(6.2442, -75.5812);

class PlacesMapView extends StatefulWidget {
  const PlacesMapView({
    super.key,
    required this.places,
    this.friends = const [],
    this.userLocation,
    this.onFiltersTap,
    this.onGroupTap,
  });

  final List<Place> places;
  final List<Friend> friends;
  final LatLng? userLocation;
  final VoidCallback? onFiltersTap;
  final VoidCallback? onGroupTap;

  @override
  State<PlacesMapView> createState() => _PlacesMapViewState();
}

class _PlacesMapViewState extends State<PlacesMapView> {
  final _mapController = MapController();

  LatLng get _initialCenter {
    if (widget.userLocation != null) return widget.userLocation!;
    if (widget.places.isNotEmpty) {
      return LatLng(
        widget.places.first.latitude,
        widget.places.first.longitude,
      );
    }
    return _defaultCenter;
  }

  void _recenter() {
    _mapController.move(widget.userLocation ?? _initialCenter, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialCenter: _initialCenter, initialZoom: 14),
          children: [
            TileLayer(
              urlTemplate:
                  'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.wereat.app',
            ),
            MarkerLayer(
              markers: [
                ...widget.places.map(
                  (place) => Marker(
                    point: LatLng(place.latitude, place.longitude),
                    width: 40,
                    height: 40,
                    child: _PlacePin(category: place.category),
                  ),
                ),
                ...widget.friends.map(
                  (friend) => Marker(
                    point: LatLng(friend.latitude, friend.longitude),
                    width: 36,
                    height: 36,
                    child: FriendMarker(avatarUrl: friend.avatarUrl),
                  ),
                ),
                if (widget.userLocation != null)
                  Marker(
                    point: widget.userLocation!,
                    width: 22,
                    height: 22,
                    child: const _UserLocationDot(),
                  ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
                TextSourceAttribution('CARTO'),
              ],
            ),
          ],
        ),
        if (widget.onGroupTap != null)
          Positioned(
            right: 16,
            top: 16,
            child: MapOverlayPill(
              icon: Icons.groups_outlined,
              label: 'Mi grupo',
              onTap: widget.onGroupTap!,
            ),
          ),
        if (widget.friends.isNotEmpty)
          Positioned(
            right: 16,
            bottom: 16,
            child: GroupExplorersCard(friends: widget.friends),
          ),
        Positioned(
          left: 16,
          bottom: 16,
          child: _LocationButton(onTap: _recenter),
        ),
      ],
    );
  }
}

class _PlacePin extends StatelessWidget {
  const _PlacePin({required this.category});

  final PlaceCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: category.accent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(category.icon, color: Colors.white, size: 18),
    );
  }
}

class _UserLocationDot extends StatelessWidget {
  const _UserLocationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.teal400,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal400.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.my_location, color: AppColors.gray900, size: 20),
        ),
      ),
    );
  }
}
