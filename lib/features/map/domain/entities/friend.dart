import 'package:equatable/equatable.dart';

/// Un amigo del grupo con ubicación en tiempo real (mock por ahora).
class Friend extends Equatable {
  const Friend({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [id, name, avatarUrl, latitude, longitude];
}
