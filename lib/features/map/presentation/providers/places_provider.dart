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
    ),
    Place(
      id: '2',
      name: 'Café Tostado',
      addedByLabel: 'Agregado por vos',
      category: PlaceCategory.cafe,
    ),
  ];
});
