import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/features/map/domain/entities/place.dart';

/// Centro por defecto (Medellín) cuando no hay lugares ni ubicación del
/// usuario para centrar el mapa.
const _defaultCenter = LatLng(6.2442, -75.5812);

class PlacesMapView extends StatefulWidget {
  const PlacesMapView({super.key, required this.places, this.userLocation});

  final List<Place> places;
  final LatLng? userLocation;

  @override
  State<PlacesMapView> createState() => _PlacesMapViewState();
}

class _PlacesMapViewState extends State<PlacesMapView> {
  final _mapController = MapController();

  LatLng get _initialCenter {
    if (widget.userLocation != null) return widget.userLocation!;
    if (widget.places.isNotEmpty) {
      return LatLng(widget.places.first.latitude, widget.places.first.longitude);
    }
    return _defaultCenter;
  }

  void _recenter() {
    _mapController.move(widget.userLocation ?? _initialCenter, 15);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _initialCenter, initialZoom: 14),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.wereat.app',
              ),
              MarkerLayer(
                markers: [
                  ...widget.places.map(
                    (place) => Marker(
                      point: LatLng(place.latitude, place.longitude),
                      width: 40,
                      height: 40,
                      child: const _PlacePin(),
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
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                const _BrandCard(),
                const SizedBox(width: 10),
                _LocationButton(onTap: _recenter),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlacePin extends StatelessWidget {
  const _PlacePin();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.coral400,
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
      child: const Icon(Icons.restaurant, color: Colors.white, size: 18),
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

class _BrandCard extends StatelessWidget {
  const _BrandCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.coral400, AppColors.coral600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral600.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(
              'assets/branding/wereat-isotype.svg',
              height: 17,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            'wereat',
            style: GoogleFonts.fraunces(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white,
              letterSpacing: -0.02 * 15,
            ),
          ),
        ],
      ),
    );
  }
}
