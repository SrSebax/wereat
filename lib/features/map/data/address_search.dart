import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Radio (en grados) de la caja de búsqueda alrededor de [near]. ~0.5° son
/// unos 55 km, suficiente para cubrir el área metropolitana de una ciudad
/// sin colarse resultados de otra ciudad lejana.
const _nearBoxDelta = 0.5;

/// Candidato de dirección devuelto por el buscador, con nombre y ubicación.
class AddressSuggestion {
  const AddressSuggestion({
    required this.displayName,
    required this.mainText,
    required this.secondaryText,
    required this.latitude,
    required this.longitude,
    required this.isExact,
  });

  factory AddressSuggestion.fromNominatim(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>?;
    final fallback = json['display_name'] as String;
    final (mainText, secondaryText) = _shortAddress(address, fallback);

    return AddressSuggestion(
      displayName: secondaryText.isEmpty ? mainText : '$mainText, $secondaryText',
      mainText: mainText,
      secondaryText: secondaryText,
      latitude: double.parse(json['lat'] as String),
      longitude: double.parse(json['lon'] as String),
      isExact: address?['house_number'] != null,
    );
  }

  final String displayName;
  final String mainText;
  final String secondaryText;
  final double latitude;
  final double longitude;

  /// `false` cuando OpenStreetMap solo tiene la calle indexada (sin número
  /// de casa) — el pin cae en algún punto de la calle, no en el predio
  /// exacto. Pasa seguido con nomenclatura de carrera/calle en Colombia.
  final bool isExact;
}

/// A partir del `address` estructurado de Nominatim arma (calle + barrio),
/// sin código postal, departamento ni país.
(String, String) _shortAddress(
  Map<String, dynamic>? address,
  String fallbackDisplayName,
) {
  if (address == null) {
    return (fallbackDisplayName.split(',').first.trim(), '');
  }

  String? field(String key) => address[key] as String?;

  final street = [
    field('road'),
    field('house_number'),
  ].nonNulls.where((s) => s.isNotEmpty).join(' ');

  final mainText = street.isNotEmpty
      ? street
      : (field('amenity') ??
            field('shop') ??
            field('name') ??
            fallbackDisplayName.split(',').first.trim());

  final neighborhood =
      field('neighbourhood') ??
      field('suburb') ??
      field('quarter') ??
      field('city_district') ??
      '';

  return (mainText, neighborhood);
}

/// Busca direcciones candidatas para [query] usando el buscador público de
/// Nominatim (OpenStreetMap). Devuelve lista vacía si la query es muy corta
/// o si la búsqueda falla.
///
/// Si se pasa [near] (la ubicación del usuario), los resultados se
/// restringen a esa área para no traer, por ejemplo, direcciones de Bogotá
/// cuando el usuario está en Medellín.
Future<List<AddressSuggestion>> searchAddressSuggestions(
  String query, {
  LatLng? near,
}) async {
  if (query.trim().length < 3) return [];

  final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
    'q': query,
    'format': 'json',
    'addressdetails': '1',
    'limit': '6',
    'countrycodes': 'co',
    'accept-language': 'es',
    if (near != null) ...{
      'viewbox':
          '${near.longitude - _nearBoxDelta},${near.latitude + _nearBoxDelta},'
          '${near.longitude + _nearBoxDelta},${near.latitude - _nearBoxDelta}',
      'bounded': '1',
    },
  });

  try {
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'wereat-app'},
    );
    if (response.statusCode != 200) return [];

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => AddressSuggestion.fromNominatim(item as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return [];
  }
}

/// Devuelve la dirección corta (calle + barrio, sin código postal ni
/// departamento) para [point], o `null` si no se pudo resolver. Se usa
/// cuando el usuario coloca el pin manualmente en el mapa.
Future<String?> reverseGeocodeAddress(LatLng point) async {
  final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
    'lat': point.latitude.toString(),
    'lon': point.longitude.toString(),
    'format': 'json',
    'addressdetails': '1',
    'accept-language': 'es',
  });

  try {
    final response = await http.get(
      uri,
      headers: {'User-Agent': 'wereat-app'},
    );
    if (response.statusCode != 200) return null;

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final address = decoded['address'] as Map<String, dynamic>?;
    final fallback = decoded['display_name'] as String? ?? '';
    final (mainText, secondaryText) = _shortAddress(address, fallback);
    return secondaryText.isEmpty ? mainText : '$mainText, $secondaryText';
  } catch (_) {
    return null;
  }
}
