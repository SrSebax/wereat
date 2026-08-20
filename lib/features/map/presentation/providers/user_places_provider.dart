import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/map/data/places_local_storage.dart';
import 'package:wereat/features/map/domain/entities/place.dart';

final _placesLocalStorageProvider = Provider((ref) => PlacesLocalStorage());

/// Lugares agregados por el usuario, persistidos localmente en el
/// dispositivo.
class UserPlacesNotifier extends AsyncNotifier<List<Place>> {
  @override
  Future<List<Place>> build() {
    return ref.read(_placesLocalStorageProvider).loadPlaces();
  }

  Future<void> addPlace(Place place) async {
    final storage = ref.read(_placesLocalStorageProvider);
    final places = [...await future, place];
    await storage.savePlaces(places);
    state = AsyncData(places);
  }
}

final userPlacesProvider =
    AsyncNotifierProvider<UserPlacesNotifier, List<Place>>(
      UserPlacesNotifier.new,
    );
