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
  });

  final String id;
  final String name;
  final String addedByLabel;
  final PlaceCategory category;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [
    id,
    name,
    addedByLabel,
    category,
    latitude,
    longitude,
  ];
}
