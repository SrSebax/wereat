import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/map/domain/entities/place.dart';
import 'package:wereat/features/map/presentation/providers/category_filter_provider.dart';

/// Mock temporal mientras se integra el mapa real y su fuente de datos.
final groupPlacesProvider = Provider<List<Place>>((ref) {
  final now = DateTime.now();
  return [
    Place(
      id: '1',
      name: 'Miniburguer',
      addedByLabel: 'Agregado por Ana',
      category: PlaceCategory.restaurant,
      latitude: 6.2442,
      longitude: -75.5812,
      addedByAvatarUrl: 'https://i.pravatar.cc/150?img=47',
      addedAt: now.subtract(const Duration(hours: 2)),
    ),
    Place(
      id: '2',
      name: 'Glotona',
      addedByLabel: 'Agregado por Sebas',
      category: PlaceCategory.cafe,
      latitude: 6.2088,
      longitude: -75.5658,
      addedByAvatarUrl: 'https://i.pravatar.cc/150?img=12',
      addedAt: now.subtract(const Duration(hours: 4)),
    ),
    Place(
      id: '3',
      name: 'Glotonas',
      addedByLabel: 'Agregado por Sebas',
      category: PlaceCategory.restaurant,
      latitude: 6.2135,
      longitude: -75.5749,
      addedByAvatarUrl: 'https://i.pravatar.cc/150?img=33',
      addedAt: now.subtract(const Duration(hours: 6)),
    ),
    Place(
      id: '4',
      name: 'La Azotea',
      addedByLabel: 'Agregado por Juli',
      category: PlaceCategory.bar,
      latitude: 6.2098,
      longitude: -75.5731,
      addedByAvatarUrl: 'https://i.pravatar.cc/150?img=25',
      addedAt: now.subtract(const Duration(hours: 8)),
    ),
  ];
});

/// Lugares del grupo filtrados por la categoría seleccionada en el home.
final filteredPlacesProvider = Provider<List<Place>>((ref) {
  final places = ref.watch(groupPlacesProvider);
  final category = ref.watch(categoryFilterProvider);
  if (category == null) return places;
  return places.where((place) => place.category == category).toList();
});
