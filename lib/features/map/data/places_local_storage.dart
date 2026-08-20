import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wereat/features/map/domain/entities/place.dart';

const _placesKey = 'user_places';

/// Guarda y carga los lugares agregados por el usuario en el dispositivo.
class PlacesLocalStorage {
  Future<List<Place>> loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_placesKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Place.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> savePlaces(List<Place> places) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(places.map((p) => p.toJson()).toList());
    await prefs.setString(_placesKey, encoded);
  }
}
