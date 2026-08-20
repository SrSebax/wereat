import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/features/map/domain/entities/place.dart';
import 'package:wereat/features/map/domain/entities/place_category_style.dart';

/// Pantalla para colocar el pin manualmente: el mapa se mueve, el pin queda
/// fijo en el centro, y "Usar esta ubicación" devuelve esas coordenadas.
class PickLocationPage extends StatefulWidget {
  const PickLocationPage({
    super.key,
    required this.initialCenter,
    required this.category,
  });

  final LatLng initialCenter;
  final PlaceCategory category;

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  late LatLng _center = widget.initialCenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: 16,
              onPositionChanged: (camera, hasGesture) =>
                  setState(() => _center = camera.center),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.wereat.app',
              ),
            ],
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.category.accent,
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
                child: Icon(
                  widget.category.icon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.sm,
            left: AppSpacing.sm,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back, color: AppColors.gray900),
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: SafeArea(
              top: false,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_center),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coral400,
                  minimumSize: const Size.fromHeight(AppSpacing.touchTarget),
                ),
                child: const Text('Usar esta ubicación'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
