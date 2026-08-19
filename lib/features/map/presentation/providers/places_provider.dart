import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/map/domain/entities/place.dart';

/// Mock temporal mientras se integra el mapa real y su fuente de datos.
final groupPlacesProvider = Provider<List<Place>>((ref) {
  return const [
    Place(
      id: '1',
      name: 'Arepas Doña Luz',
      addedByLabel: 'Agregado por Ana',
      category: PlaceCategory.restaurant,
      latitude: 6.2442,
      longitude: -75.5812,
    ),
    Place(
      id: '2',
      name: 'Café Tostado',
      addedByLabel: 'Agregado por vos',
      category: PlaceCategory.cafe,
      latitude: 6.2088,
      longitude: -75.5658,
    ),
  ];
});
