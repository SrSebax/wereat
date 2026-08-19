import 'package:equatable/equatable.dart';

enum PlaceCategory { restaurant, cafe, bar }

class Place extends Equatable {
  const Place({
    required this.id,
    required this.name,
    required this.addedByLabel,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.addedByAvatarUrl,
    this.addedAt,
  });

  final String id;
  final String name;
  final String addedByLabel;
  final PlaceCategory category;
  final double latitude;
  final double longitude;

  /// Foto de quien lo agregó, para el pie de la card de actividad.
  final String? addedByAvatarUrl;

  /// Cuándo se agregó, para mostrar "Hace X h" en la card de actividad.
  final DateTime? addedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    addedByLabel,
    category,
    latitude,
    longitude,
    addedByAvatarUrl,
    addedAt,
  ];
}
