import 'package:equatable/equatable.dart';
import 'package:wereat/features/map/domain/entities/price_range.dart';

enum PlaceCategory { restaurant, cafe, bar }

class Place extends Equatable {
  const Place({
    required this.id,
    required this.name,
    required this.addedByLabel,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.groupId,
    this.rating = 5,
    this.priceRange = PriceRange.normal,
    this.notes,
    this.instagramUrl,
    this.tiktokUrl,
    this.facebookUrl,
    this.webUrl,
    this.addedByAvatarUrl,
    this.addedAt,
  });

  final String id;
  final String name;
  final String addedByLabel;
  final PlaceCategory category;
  final double latitude;
  final double longitude;
  final String address;

  /// Grupo (local) al que pertenece este lugar.
  final String groupId;

  /// Calificación de 1 a 5 estrellas.
  final int rating;

  final PriceRange priceRange;

  final String? notes;
  final String? instagramUrl;
  final String? tiktokUrl;
  final String? facebookUrl;
  final String? webUrl;

  /// Foto de quien lo agregó, para el pie de la card de actividad.
  final String? addedByAvatarUrl;

  /// Cuándo se agregó, para mostrar "Hace X h" en la card de actividad.
  final DateTime? addedAt;

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      name: json['name'] as String,
      addedByLabel: json['addedByLabel'] as String,
      category: PlaceCategory.values.byName(json['category'] as String),
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String,
      groupId: json['groupId'] as String? ?? 'default',
      rating: json['rating'] as int? ?? 5,
      priceRange: json['priceRange'] == null
          ? PriceRange.normal
          : PriceRange.values.byName(json['priceRange'] as String),
      notes: json['notes'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      tiktokUrl: json['tiktokUrl'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      webUrl: json['webUrl'] as String?,
      addedByAvatarUrl: json['addedByAvatarUrl'] as String?,
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'addedByLabel': addedByLabel,
      'category': category.name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'groupId': groupId,
      'rating': rating,
      'priceRange': priceRange.name,
      'notes': notes,
      'instagramUrl': instagramUrl,
      'tiktokUrl': tiktokUrl,
      'facebookUrl': facebookUrl,
      'webUrl': webUrl,
      'addedByAvatarUrl': addedByAvatarUrl,
      'addedAt': addedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    addedByLabel,
    category,
    latitude,
    longitude,
    address,
    groupId,
    rating,
    priceRange,
    notes,
    instagramUrl,
    tiktokUrl,
    facebookUrl,
    webUrl,
    addedByAvatarUrl,
    addedAt,
  ];
}
